#!/usr/bin/env bash
# LNOS VM Creator - Crea una máquina virtual con la ISO de LNOS
# Basado en la Especificación Técnica LNOS (Secciones 4.4, 108-110)
set -euo pipefail

# Colores para output
ROJO='\033[0;31m'
VERDE='\033[0;32m'
AMARILLO='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # Sin color

info()  { echo -e "${CYAN}[INFO]${NC} $*"; }
ok()    { echo -e "${VERDE}[OK]${NC} $*"; }
warn()  { echo -e "${AMARILLO}[WARN]${NC} $*"; }
error() { echo -e "${ROJO}[ERROR]${NC} $*"; }

# ============================================================
# CONFIGURACIÓN POR DEFECTO (overrideable via variables de entorno)
# ============================================================
VM_NAME="${VM_NAME:-lnos-vm}"
VM_RAM="${VM_RAM:-4096}"          # MB (mínimo 2048, recomendado 4096+)
VM_VCPUS="${VM_VCPUS:-4}"         # CPUs (mínimo 2, recomendado 4+)
VM_DISK_SIZE="${VM_DISK_SIZE:-40}" # GB (mínimo 20, recomendado 40+)
VM_DISK_PATH="${VM_DISK_PATH:-/var/lib/libvirt/images/${VM_NAME}.qcow2}"
VM_OS_VARIANT="${VM_OS_VARIANT:-archlinux}"
VM_NETWORK="${VM_NETWORK:-network=default}"
VM_GRAPHICS="${VM_GRAPHICS:-vnc,listen=0.0.0.0}"
VM_CPU_MODEL="${VM_CPU_MODEL:-host-passthrough}"

# Rutas del proyecto
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
ISO_DIR="${PROJECT_DIR}/out"
DEFAULT_ISO="${ISO_DIR}/LNOS-0.1.0-desktop.iso"
ARCH_ISO="${PROJECT_DIR}/archlinux-x86_64.iso"

# ============================================================
# FUNCIONES AUXILIARES
# ============================================================

check_prerequisites() {
    local missing=0

    info "Verificando requisitos previos..."

    # virt-install
    if ! command -v virt-install &>/dev/null; then
        error "virt-install no encontrado. Instala: pacman -S virt-manager libvirt qemu-desktop"
        missing=1
    fi

    # qemu-img
    if ! command -v qemu-img &>/dev/null; then
        error "qemu-img no encontrado."
        missing=1
    fi

    # OVMF (UEFI)
    local ovmf_code
    ovmf_code=$(get_ovmf_path)
    if [ -z "$ovmf_code" ]; then
        warn "OVMF no encontrado. La VM usará BIOS legacy en lugar de UEFI."
        warn "Instala: pacman -S edk2-ovmf"
    fi

    # libvirtd
    if ! systemctl is-active --quiet libvirtd 2>/dev/null; then
        warn "libvirtd no está activo. Intentando iniciar..."
        if sudo -n systemctl start libvirtd 2>/dev/null; then
            ok "libvirtd iniciado"
        else
            error "No se pudo iniciar libvirtd. Ejecuta: sudo systemctl start libvirtd"
            missing=1
        fi
    fi

    # Red default de libvirt
    if ! sudo virsh net-list --all --name 2>/dev/null | grep -q "^default$"; then
        warn "Red 'default' de libvirt no existe. Creándola..."
        sudo virsh net-define /etc/libvirt/qemu/networks/default.xml 2>/dev/null || {
            # Crear red desde cero si el archivo no existe
            sudo virsh net-define /dev/stdin <<< '<network><name>default</name><forward mode="nat"/><bridge name="virbr0" stp="on" delay="0"/><ip address="192.168.122.1" netmask="255.255.255.0"><dhcp><range start="192.168.122.2" end="192.168.122.254"/></dhcp></ip></network>' 2>/dev/null
        }
        sudo virsh net-autostart default 2>/dev/null || true
    fi
    if ! sudo virsh net-info default 2>/dev/null | grep -q "Activo"; then
        sudo virsh net-start default 2>/dev/null || true
    fi

    # Añadir regla sudoers para virsh sin contraseña (opcional)
    if ! sudo -n virsh list &>/dev/null; then
        warn "sudo requiere contraseña para virsh. El script la pedirá cuando sea necesario."
    fi

    # Verificar grupo kvm
    if [ ! -e /dev/kvm ]; then
        warn "/dev/kvm no disponible. La VM será MUY lenta (sin aceleración KVM)."
        warn "Verifica que la virtualización está habilitada en BIOS."
    fi

    # Verificar que el usuario está en grupo libvirt
    if ! groups | grep -q "libvirt\|qemu\|kvm"; then
        warn "Tu usuario no está en grupos kvm/libvirt. Ejecuta:"
        warn "  sudo usermod -aG libvirt,kvm $USER"
        warn "  newgrp libvirt  (o cierra sesión y vuelve a entrar)"
    fi

    if [ "$missing" -eq 1 ]; then
        error "Requisitos insuficientes. Abortando."
        exit 1
    fi

    ok "Todos los requisitos cumplidos"
}

find_iso() {
    # Buscar ISO de LNOS compilada
    if [ -f "$DEFAULT_ISO" ]; then
        ISO_PATH="$DEFAULT_ISO"
        ISO_TYPE="lnos"
        info "Usando ISO de LNOS: $ISO_PATH"
        return 0
    fi

    # Buscar cualquier ISO de LNOS en out/
    local lnos_iso
    lnos_iso=$(ls -t "${ISO_DIR}"/LNOS-*.iso 2>/dev/null | head -1)
    if [ -n "$lnos_iso" ]; then
        ISO_PATH="$lnos_iso"
        ISO_TYPE="lnos"
        info "Usando ISO de LNOS: $ISO_PATH"
        return 0
    fi

    # Fallback a ISO de Arch
    if [ -f "$ARCH_ISO" ]; then
        ISO_PATH="$ARCH_ISO"
        ISO_TYPE="arch"
        warn "No se encontró ISO de LNOS compilada. Usando Arch Linux ISO."
        warn "Para compilar la ISO de LNOS: ./scripts/build-iso.sh"
        return 0
    fi

    error "No se encontró ninguna ISO."
    error "Coloca archlinux-x86_64.iso en: $PROJECT_DIR"
    error "O compila la ISO de LNOS: cd $PROJECT_DIR && ./scripts/build-iso.sh"
    exit 1
}

get_ovmf_path() {
    for p in /usr/share/edk2/x64/OVMF_CODE.fd /usr/share/OVMF/OVMF_CODE.fd /usr/share/OVMF/x64/OVMF_CODE.fd; do
        [ -f "$p" ] && echo "$p" && return
    done
    echo ""
}

get_ovmf_vars() {
    for p in /usr/share/edk2/x64/OVMF_VARS.fd /usr/share/OVMF/OVMF_VARS.fd /usr/share/OVMF/x64/OVMF_VARS.fd; do
        [ -f "$p" ] && echo "$p" && return
    done
    echo ""
}

# ============================================================
# CONFIGURACIÓN DE LA VM SEGÚN ESPECIFICACIÓN LNOS
# ============================================================

show_config() {
    info "=== Configuración de la VM ==="
    echo "  Nombre:         ${VM_NAME}"
    echo "  RAM:            ${VM_RAM} MB (mín: 2048, recomendado: 4096+)"
    echo "  vCPUs:          ${VM_VCPUS} (mín: 2, recomendado: 4+)"
    echo "  Disco:          ${VM_DISK_SIZE}G en ${VM_DISK_PATH}"
    echo "  Red:            ${VM_NETWORK}"
    echo "  Gráficos:       ${VM_GRAPHICS}"
    echo "  CPU model:      ${VM_CPU_MODEL}"
    echo "  ISO:            ${ISO_PATH}"
    echo ""
    warn "Requiere sudo para crear la VM. Se pedirá la contraseña."
    echo ""
    read -rp "¿Continuar? [s/N]: " confirm
    if [[ ! "$confirm" =~ ^[sS]$ ]]; then
        info "Abortado por el usuario."
        exit 0
    fi
}

create_disk() {
    local disk_dir
    disk_dir=$(dirname "$VM_DISK_PATH")

    if [ -f "$VM_DISK_PATH" ]; then
        warn "El disco ya existe: ${VM_DISK_PATH}"
        read -rp "¿Sobrescribir? [s/N]: " overwrite
        if [[ "$overwrite" =~ ^[sS]$ ]]; then
            sudo rm -f "$VM_DISK_PATH"
        else
            info "Usando disco existente."
            return 0
        fi
    fi

    info "Creando disco qcow2 de ${VM_DISK_SIZE}G..."
    sudo mkdir -p "$disk_dir"
    sudo qemu-img create -f qcow2 "$VM_DISK_PATH" "${VM_DISK_SIZE}G"
    ok "Disco creado: ${VM_DISK_PATH}"
}

prepare_iso() {
    # Si es ISO de LNOS, copiar a ubicación accesible por qemu
    local iso_basename
    iso_basename=$(basename "$ISO_PATH")
    local target_iso="/var/lib/libvirt/images/${iso_basename}"

    if [ "$ISO_PATH" != "$target_iso" ]; then
        info "Copiando ISO a ${target_iso}..."
        sudo cp "$ISO_PATH" "$target_iso"
        sudo chown qemu:qemu "$target_iso" 2>/dev/null || true
        ISO_PATH="$target_iso"
    fi
}

# ============================================================
# CREACIÓN DE LA VM CON VIRT-INSTALL
# ============================================================

create_vm() {
    local ovmf_code ovmf_vars
    ovmf_code=$(get_ovmf_path)
    ovmf_vars=$(get_ovmf_vars)

    # Construir argumentos de virt-install
    local args=()
    args+=(--name "$VM_NAME")
    args+=(--memory "$VM_RAM")
    args+=(--vcpus "$VM_VCPUS")
    args+=(--disk "path=${VM_DISK_PATH},format=qcow2")
    args+=(--cdrom "$ISO_PATH")
    args+=(--os-variant "$VM_OS_VARIANT")
    args+=(--network "$VM_NETWORK")
    args+=(--graphics "$VM_GRAPHICS")
    args+=(--cpu "$VM_CPU_MODEL")
    args+=(--noautoconsole)
    args+=(--autostart)

    # UEFI si OVMF está disponible
    if [ -n "$ovmf_code" ]; then
        info "Usando UEFI (OVMF) para arranque"
        local ovmf_dir
        ovmf_dir=$(dirname "$ovmf_code")
        local ovmf_vars
        ovmf_vars=$(get_ovmf_vars)
        if [ -n "$ovmf_vars" ]; then
            local vm_vars="/var/lib/libvirt/qemu/nvram/${VM_NAME}_VARS.fd"
            sudo mkdir -p "$(dirname "$vm_vars")"
            sudo cp "$ovmf_vars" "$vm_vars"
            args+=(--boot "uefi,firmware=${ovmf_code},nvram=${vm_vars}")
        else
            args+=(--boot "uefi,firmware=${ovmf_code}")
        fi
    else
        warn "UEFI no disponible. Usando BIOS legacy."
    fi

    # Características adicionales recomendadas
    args+=(--features "acpi,apic")
    args+=(--clock "offset=utc")

    # Dispositivos
    args+=(--input "tablet,bus=usb")  # Mejor precisión del ratón
    args+=(--soundhw "hda")           # Audio
    args+=(--rng "/dev/urandom")     # Entropía

    info "Creando VM '${VM_NAME}' con virt-install..."
    echo ""
    echo "  Comando completo:"
    echo "  virt-install \\"
    for arg in "${args[@]}"; do
        echo "    ${arg} \\"
    done
    echo ""

    # Crear la VM
    sudo virt-install "${args[@]}"
    ok "VM '${VM_NAME}' creada correctamente"
}

# ============================================================
# POST-CREACIÓN
# ============================================================

post_creation() {
    echo ""
    info "=== VM '${VM_NAME}' creada ==="
    echo ""
    echo "  Gestiona la VM con:"
    echo "    sudo virsh list               # Ver VMs activas"
    echo "    sudo virsh start ${VM_NAME}   # Iniciar VM"
    echo "    sudo virsh shutdown ${VM_NAME}  # Apagar VM"
    echo "    sudo virsh destroy ${VM_NAME}  # Forzar apagado"
    echo "    sudo virsh undefine ${VM_NAME} # Eliminar VM"
    echo "    virt-manager                   # Gestor gráfico"
    echo ""
    echo "  Conexión VNC:"
    local vnc_port
    vnc_port=$(sudo virsh vncdisplay "${VM_NAME}" 2>/dev/null || echo ":0")
    echo "    Puerto VNC: 590${vnc_port#:}"
    echo "    Conectar con: virt-manager → doble clic en '${VM_NAME}'"
    echo ""
    echo "  Instalación de LNOS:"
    if [ "$ISO_TYPE" = "lnos" ]; then
        echo "    La ISO de LNOS es autoinstalable o guiada."
    else
        echo "    La ISO es de Arch Linux. Sigue la guía de instalación:"
        echo "    https://wiki.archlinux.org/title/Installation_guide"
        echo ""
        echo "    O usa el instalador automatizado de LNOS:"
        echo "    Una vez dentro de Arch Linux, ejecuta:"
        echo "      bash <(curl -sL https://raw.githubusercontent.com/LowNoise647/ArchDotFileISO/main/scripts/install-lnos.sh)"
    fi
    echo ""
    echo "  Especificaciones de la VM:"
    echo "    RAM: ${VM_RAM} MB | vCPUs: ${VM_VCPUS} | Disco: ${VM_DISK_SIZE}G"
    echo "    Red: NAT (192.168.122.x) | Gráficos: VNC"
    echo ""

    # Mostrar resumen en formato tabla
    echo "  ┌─────────────────────────────────────────────────────┐"
    echo "  │              LNOS VM - RESUMEN                       │"
    echo "  ├──────────────────────┬──────────────────────────────┤"
    printf "  │ %-20s │ %-28s │\n" "Nombre" "${VM_NAME}"
    printf "  │ %-20s │ %-28s │\n" "RAM" "${VM_RAM} MB"
    printf "  │ %-20s │ %-28s │\n" "vCPUs" "${VM_VCPUS}"
    printf "  │ %-20s │ %-28s │\n" "Disco" "${VM_DISK_SIZE}G"
    printf "  │ %-20s │ %-28s │\n" "ISO" "$(basename "${ISO_PATH}")"
    printf "  │ %-20s │ %-28s │\n" "Red" "NAT (192.168.122.x)"
    printf "  │ %-20s │ %-28s │\n" "VNC" "590${vnc_port#:}"
    echo "  └──────────────────────┴──────────────────────────────┘"
}

# ============================================================
# MAIN
# ============================================================

main() {
    echo ""
    echo "╔══════════════════════════════════════════════════════╗"
    echo "║         LNOS - Creador de Máquinas Virtuales        ║"
    echo "║  Basado en la Especificación Técnica (Secciones 4.4, ║"
    echo "║  108-110: KVM/QEMU, Requisitos de Hardware)          ║"
    echo "╚══════════════════════════════════════════════════════╝"
    echo ""

    # Verificar que no exista una VM con el mismo nombre
    if virsh list --all --name 2>/dev/null | grep -q "^${VM_NAME}$"; then
        error "Ya existe una VM llamada '${VM_NAME}'"
        echo ""
        echo "  Opciones:"
        echo "    1. Usa otro nombre: VM_NAME=lnos-test2 $0"
        echo "    2. Elimínala: sudo virsh undefine ${VM_NAME}"
        echo "    3. Conéctate: virt-manager (doble clic en '${VM_NAME}')"
        exit 1
    fi

    check_prerequisites
    find_iso
    show_config
    prepare_iso
    create_disk
    create_vm
    post_creation

    ok "Script completado exitosamente"
}

main "$@"
