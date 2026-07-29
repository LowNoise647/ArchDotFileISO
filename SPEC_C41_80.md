# LNOS — Especificación Técnica

## Capítulos 41–80: Entorno Gráfico, Drivers, Gaming, Paquetes y Mantenimiento

---

# 41. SELinux (Evaluación)

## 41.1 ¿Para qué existe este análisis?

SELinux (Security-Enhanced Linux) es un módulo de seguridad del kernel de Linux que proporciona un control de acceso obligatorio (MAC). Este capítulo documenta por qué LNOS **no** utiliza SELinux y opta por AppArmor.

## 41.2 ¿Por qué NO se usa SELinux en LNOS?

| Factor | SELinux | AppArmor |
|--------|---------|----------|
| **Complejidad de políticas** | Alta. Etiquetado de todo el sistema. | Media. Perfiles por aplicación. |
| **Cobertura en Arch Linux** | Mínima. No hay perfiles mantenidos oficialmente. | Buena. Perfiles en `extra` y mantenidos por el equipo de Arch. |
| **Mantenimiento continuo** | Requiere reetiquetado en cada actualización del sistema. | Los perfiles rara vez necesitan cambios. |
| **Carga administrativa** | Alta. Se necesita experiencia específica. | Baja. Configuración declarativa trivial. |
| **Rendimiento** | Impacto medible en operaciones masivas de E/S. | Impacto negligible. |
| **Modelo** | MAC a nivel de objeto (todo o nada). | MAC por ruta de ejecutable. |

**Decisión:** Se descarta SELinux porque:

1. El mantenimiento en Arch Linux es prácticamente nulo. No hay políticas empaquetadas y actualizadas.
2. El etiquetado constante (relabel) rompe en cada actualización mayor de glibc o systemd.
3. La complejidad añadida no compensa el beneficio: LNOS es un sistema de escritorio, no un servidor gubernamental o militar.
4. AppArmor ofrece el 90% de la seguridad con el 10% del esfuerzo.

## 41.3 Alternativas descartadas

- **SELinux + refpolicy**: Se descartó porque la referencia policy necesita parches específicos de distribución que Arch no proporciona.
- **TOMOYO**: Proyecto inactivo, sin soporte en Arch.
- **SMACK**: Orientado a dispositivos embebidos, sin casos de uso en escritorio.
- **Ningún LSM**: No recomendable; todo sistema moderno debe tener un LSM activo. AppArmor es el mínimo aceptable.

## 41.4 Comunicación con el resto del sistema

```
+--------------------------------------------------+
|                  Systemd                          |
|    apparmor.service (carga de perfiles)           |
+--------------------+-----------------------------+
                     |
+--------------------v-----------------------------+
|                Kernel (LSM)                       |
|         AppArmor LSM hook en syscalls             |
|   open(), execve(), mknod(), link(), etc.         |
+--------------------+-----------------------------+
                     |
+--------------------v-----------------------------+
|            aa-status / aa-enabled                 |
|            (herramientas de usuario)              |
+--------------------+-----------------------------+
                     |
+--------------------v-----------------------------+
|   /etc/apparmor.d/            /sys/kernel/security|
|   (perfiles .d)               (apparmor/ interfaces)|
+--------------------------------------------------+
```

## 41.5 Dependencias

- `apparmor` (paquete Arch: kernel + userspace)
- `apparmor-profiles` (perfiles genéricos)
- `systemd` (carga temprana via `apparmor.service`)

## 41.6 Problemas potenciales y mitigaciones

| Problema | Mitigación |
|----------|-----------|
| Perfil demasiado restrictivo bloquea app | `aa-log` para diagnosticar; `aa-complain` para modo auditoría |
| Servicio no inicia por perfil | `journalctl -u apparmor` + `apparmor_parser -R` |
| Perfiles desactualizados | `apparmor-profiles` se actualiza semanalmente en `lnos-stable` |

## 41.7 Pruebas

- `aa-enabled` -> debe devolver `Yes`
- `aa-status` -> listar perfiles cargados
- `sudo aa-genprof <binario>` -> generar perfil interactivo
- Reiniciar con `lsm=apparmor` en cmdline -> verificar carga temprana

## 41.8 Mantenimiento

- Los perfiles se actualizan desde el paquete `apparmor-profiles` durante las actualizaciones regulares.
- Los perfiles personalizados se almacenan en `/etc/apparmor.d/local/` y no se sobrescriben.
- Una vez al trimestre: revisión de `aa-log` para perfiles en modo `complain`.

## 41.9 Ampliación

- Se pueden añadir perfiles nuevos simplemente colocando un archivo en `/etc/apparmor.d/`.
- Integración con `systemd` via `apparmor.service` para perfiles de servicios systemd.
- Integración con contenedores (Docker/Podman) via `apparmor_parser` dentro del contenedor.

---

# 42. Drivers Intel

## 42.1 ¿Para qué existe?

La pila gráfica Intel en LNOS debe proporcionar aceleración 2D/3D, decodificación de video por hardware y soporte Vulkan completo para hardware Intel integrado (Gen7+ Ivy Bridge hasta Meteor Lake y más allá).

## 42.2 Componentes de la pila

```
Aplicación (juego, navegador, DAW)
    |
    +-- Vulkan -> ANV (Mesa) -> i915 (KMS)
    +-- OpenGL -> Crocus/Iris (Mesa) -> i915 (KMS)
    +-- VA-API -> intel-media-driver -> i915 (KMS)
                +-- libva
```

### 42.2.1 Kernel Modesetting (i915)

El driver `i915` del kernel gestiona:

- Modos de video (resolución, refresh rate)
- Planes de hardware (scanout)
- Gestión de memoria VRAM (a través de TTM o DSM)
- Fences de GPU
- Frecuencias del chip (DVFS)

Configuración en `/etc/modprobe.d/i915.conf`:

```
options i915 enable_guc=3
options i915 enable_fbc=1
options i915 enable_psr=1
options i915 fastboot=1
```

| Parámetro | Valor | Efecto |
|-----------|-------|--------|
| `enable_guc=3` | GuC + HuC | Carga firmware del microcontrolador para decodificación y reclocking |
| `enable_fbc=1` | Framebuffer Compression | Reduce ancho de banda de memoria en portátiles |
| `enable_psr=1` | Panel Self Refresh | Ahorro energético en pantalla estática |
| `fastboot=1` | Inicio rápido | Evita modo de rescate en early boot |

### 42.2.2 Mesa - Iris (Gen8+) y Crocus (Gen7 y anteriores)

| Driver | Generaciones | Característica |
|--------|-------------|---------------|
| Crocus | Ivy Bridge, Haswell, Bay Trail (Gen7) | Mantenimiento heredado; OpenGL 4.6 |
| Iris | Broadwell+ (Gen8+) | Driver Gallium moderno; OpenGL 4.6, mejor rendimiento |

**Decisión de ingeniería:** Se usa **Iris** como driver predeterminado para hardware moderno. Crocus solo como fallback para hardware antiguo. NO se usa `i965` (driver clásico, deprecado upstream).

### 42.2.3 Vulkan - ANV

ANV es el driver Vulkan de Intel dentro de Mesa. Soporta Vulkan 1.3 completo en Gen9+.

- `VK_EXT_graphics_pipeline_library` - reduce compilación de shaders
- `VK_KHR_present_id` / `VK_KHR_present_wait` - presentación síncrona en Wayland

### 42.2.4 Decodificación de video - intel-media-driver

| Codec | Gen9+ (iHD) | Gen7 (i965) |
|-------|-------------|-------------|
| H.264 | Sí | Sí |
| H.265/HEVC 8/10bit | Sí | No |
| VP9 8/10bit | Sí | No |
| AV1 (Tiger Lake+) | Sí | No |

Se usa `intel-media-driver` con `libva`. El driver `iHD` es el predeterminado; se descarta `i965` por estar deprecado.

### 42.2.5 Firmware

- `linux-firmware` contiene `i915/` con GuC, HuC y DMC.
- DMC (Display Microcontroller) necesario para estados de bajo consumo en pantalla.

### 42.2.6 Microcode

- `intel-ucode` cargado por el bootloader (ver capítulo 45).

## 42.3 Alternativas descartadas

| Alternativa | Razón de descarte |
|-------------|-------------------|
| `xf86-video-intel` (Xorg DDX) | X11 está deprecado; Wayland usa KMS directo via `i915`. |
| `beignet` (OpenCL Intel) | Proyecto muerto. Sustituido por `intel-compute-runtime` (NEO). |
| `i965` clásico de Mesa | Deprecado upstream, no soporta Gen12+. |

## 42.4 Dependencias

- `linux` (>= 6.6) con `CONFIG_DRM_I915`
- `mesa` (>= 24.0) con `iris`, `crocus`, `anv`
- `intel-media-driver`
- `libva` + `libva-utils`
- `vulkan-icd-loader`
- `linux-firmware` (subdirectorio `i915/`)
- `intel-ucode`

## 42.5 Pruebas

- `glxinfo -B` -> verificar `Mesa Iris` o `Mesa Crocus`
- `vulkaninfo` -> verificar `Intel ANV`
- `vainfo` -> verificar perfiles VA-API
- `intel_gpu_top` -> monitorear uso GPU
- Renderizar `mesa-demos` (ej. `es2gears_wayland`)

## 42.6 Mantenimiento

- Actualizaciones de Mesa e `intel-media-driver` via `lnos-stable`.
- Firmware actualizado con `linux-firmware`.
- Microcode actualizado con `intel-ucode`.

## 42.7 Ampliación

- Soporte para `intel-compute-runtime` (OpenCL/Level Zero) para cómputo.
- `intel_gpu_time` para profiling fino.
- Integración con `powertop` para diagnóstico energético.

---

# 43. Drivers AMD

## 43.1 ¿Para qué existe?

Proporcionar aceleración gráfica completa (OpenGL, Vulkan, VA-API) y cómputo (ROCm) para GPUs AMD desde GCN 1.0 (Southern Islands) hasta RDNA3+.

## 43.2 Pila completa

```
Aplicación
    |
    +-- Vulkan -> RADV (Mesa) -> amdgpu (KMS)
    +-- OpenGL -> RadeonSI (Mesa) -> amdgpu (KMS)
    +-- ROCm   -> amdgpu-pro / rocm-opencl -> amdgpu (KMS)
    +-- VA-API -> Mesa (radeonsi) -> amdgpu (KMS)
```

### 43.2.1 Kernel Modesetting - amdgpu

Driver del kernel unificado para todas las GPUs modernas AMD (GCN 1.0+).

Configuración en `/etc/modprobe.d/amdgpu.conf`:

```
options amdgpu si_support=1
options amdgpu cik_support=1
options amdgpu gpu_recovery=1
options amdgpu dc=1
options amdgpu audio=1
```

| Parámetro | Valor | Efecto |
|-----------|-------|--------|
| `si_support=1` | Habilita Southern Islands (GCN 1.0) | Permite que `amdgpu` maneje HD 7000 |
| `cik_support=1` | Habilita Sea Islands (GCN 2.0/3.0) | Permite que `amdgpu` maneje R7/R9 200 |
| `gpu_recovery=1` | Recuperación tras hang GPU | Reinicia GPU sin reiniciar sistema |
| `dc=1` | Display Core | Códec de pantalla moderno (necesario para HDMI 2.1, DSC) |
| `audio=1` | Audio HDMI/DP por GPU | Streaming de audio digital |

**Nota:** `si_support` y `cik_support` requieren los parámetros de kernel `amdgpu.si_support=1 amdgpu.cik_support=1` y `radeon.si_support=0 radeon.cik_support=0` para desactivar `radeon` legacy.

### 43.2.2 Mesa - RadeonSI (OpenGL)

- Driver Gallium para OpenGL 4.6 completo.
- GCN 1.0 a RDNA3+.
- Soportes: `GL_ARB_ray_tracing` (RDNA2+), `GL_ARB_sparse_texture`.

### 43.2.3 Mesa - RADV (Vulkan)

- Driver Vulkan 1.3 completo.
- Mejor rendimiento que `amdgpu-pro` Vulkan en la mayoría de los casos.
- Soportes: `VK_KHR_ray_tracing`, `VK_KHR_present_wait`, `VK_EXT_graphics_pipeline_library`.

**Decisión de ingeniería:** RADV es el driver Vulkan predeterminado. `amdgpu-pro` Vulkan solo se ofrece como capa de compatibilidad para aplicaciones que requieren certificación específica (ej. Autodesk, DaVinci Resolve).

### 43.2.4 ROCm

ROCm (Radeon Open Compute) proporciona:

- `rocm-opencl-runtime` (OpenCL 2.0)
- `rocm-hip-runtime` (HIP para cómputo)
- `rocm-llvm` (compilador)

**Decisión:** ROCm se instala opcionalmente. NO está en la instalación base. El usuario lo añade con `pacman -S rocm-hip-runtime`.

### 43.2.5 Decodificación de video

| Codec | RadeonSI (VA-API) |
|-------|-------------------|
| H.264 | Sí |
| H.265/HEVC | GCN 1.0+ |
| VP9 | Polaris+ |
| AV1 | RDNA3+ |

Se usa el backend VA-API de Mesa (`radeonsi`). No se necesita driver separado.

## 43.3 Alternativas descartadas

| Alternativa | Razón |
|-------------|-------|
| `xf86-video-amdgpu` (Xorg DDX) | No necesario en Wayland. |
| `amdgpu-pro` completo | Cerrado, peor rendimiento en Vulkan, más complejo. |
| `radeon` (kernel legacy) | No soporta GCN 1.0+ correctamente; sin soporte de recuperación. |
| `opencl-amd` (AUR) | Preferir `rocm-opencl-runtime` oficial. |

## 43.4 Dependencias

- `linux` (>= 6.6) con `CONFIG_DRM_AMDGPU`
- `mesa` (>= 24.0) con `radeonsi`, `radv`
- `libva-mesa-driver`
- `vulkan-icd-loader`
- `linux-firmware` (subdirectorio `amdgpu/`)

## 43.5 Pruebas

- `glxinfo -B` -> `Mesa Radeon SI`
- `vulkaninfo` -> `RADV`
- `vainfo` -> perfiles VA-API
- `rocm-smi` -> estado de GPU ROCm (si instalado)
- `umr` -> diagnóstico AMDGPU
- `mesa-demos` -> `es2gears_wayland`

## 43.6 Mantenimiento

- Mesa, firmware, kernel se actualizan por `lnos-stable`.
- `amdgpu` kernel module se actualiza con el kernel.
- ROCm requiere actualizaciones manuales (no automáticas).

## 43.7 Ampliación

- Añadir `rocm-hip-sdk` para desarrollo de cómputo.
- Añadir `amdgpu_top` para monitorización gráfica de GPU.
- Integrar `corectrl` para overclocking/undervolt de GPU AMD.

---

# 44. Drivers NVIDIA

## 44.1 ¿Para qué existe?

Proporcionar soporte gráfico para GPUs NVIDIA (desde Kepler/Maxwell hasta Ada Lovelace y posteriores) en un entorno Wayland+Hyprland.

## 44.2 Arquitectura de la pila NVIDIA

```
Aplicación
    |
    +-- Vulkan -> libGLX_nvidia.so -> nvidia-open (kernel)
    +-- OpenGL -> libGLX_nvidia.so -> nvidia-open (kernel)
    +-- CUDA   -> libcuda.so -> nvidia-open (kernel)
    +-- VA-API -> nvidia-vaapi-driver -> nvidia-open (kernel)
    +-- Wayland -> nvidia-drm (KMS) -> nvidia-open
```

### 44.2.1 nvidia-open (kernel module)

- Módulo kernel de código abierto (desde la serie 525+).
- Reemplaza a `nvidia` (cerrado) para GPUs Turing+.
- Para Kepler/Maxwell/Pascal: se usa `nvidia` (cerrado) por falta de soporte en `nvidia-open`.

**Decisión de ingeniería:** `nvidia-open` es el predeterminado para GPUs Turing+. Para GPUs antiguas, se usa `nvidia` (DKMS).

### 44.2.2 nvidia-utils

- Librerías de usuario: OpenGL, Vulkan, EGL, GLX.
- `libnvidia-egl-wayland.so` para EGLStreams.

### 44.2.3 Wayland con NVIDIA - EGLStreams vs GBM

```
+--------------------------------------------------------------+
|                    NVIDIA + Wayland                           |
+--------------------------------------------------------------+
|                                                              |
|  Hasta 2023: Solo EGLStreams (nativo NVIDIA)                 |
|  A partir de 2023: Soporte GBM (parcial)                     |
|                                                              |
|  EGLStreams:                                                 |
|    - Flujo de trabajo propietario NVIDIA                     |
|    - No funciona con wlroots puro (Hyprland lo parchea)      |
|    - Mayor latencia                                          |
|                                                              |
|  GBM:                                                        |
|    - Estandar abierto usado por Intel/AMD                    |
|    - Funciona nativamente con wlroots                        |
|    - NVIDIA necesita `nvidia_drm.modeset=1`                  |
+--------------------------------------------------------------+
```

**Decisión:** Se usa **GBM** siempre que sea posible. Para ello se requiere:

- `nvidia-drm.modeset=1` en cmdline del kernel
- `nvidia_drm.fbdev=1` en cmdline del kernel (framebuffer emulado)
- `__GLX_VENDOR_LIBRARY_NAME=nvidia` en entorno
- `GBM_BACKEND=nvidia-drm` en entorno

### 44.2.4 Configuración de kernel

En `/etc/modprobe.d/nvidia.conf`:

```
options nvidia_drm modeset=1 fbdev=1
options nvidia NVreg_UsePageAttributeTable=1
options nvidia NVreg_InitializeSystemMemoryAllocations=0
options nvidia NVreg_DynamicPowerManagement=0x02
```

| Parámetro | Efecto |
|-----------|--------|
| `modeset=1` | Habilita KMS (necesario para Wayland) |
| `fbdev=1` | Habilita framebuffer emulado (fundamental para algunos gestores de arranque) |
| `NVreg_UsePageAttributeTable=1` | Mejora rendimiento de memoria |
| `NVreg_InitializeSystemMemoryAllocations=0` | Evita inicialización de memoria en boot (ahorra tiempo) |
| `NVreg_DynamicPowerManagement=0x02` | Permite apagar GPU cuando no se usa (Fine-grain) |

### 44.2.5 nvidia-settings

Herramienta gráfica de configuración. Se usa principalmente para:

- Configurar múltiples monitores (aunque en Wayland se usa `wlr-randr`)
- Ajustar configuración de OpenGL (Sync to VBlank, etc.)
- Ver información de la GPU

### 44.2.6 CUDA

- `cuda` (paquete oficial de Arch) o `cuda-keyring` (NVIDIA).
- Se instala bajo `/opt/cuda`.
- `nvcc` para compilación.
- `cuda-tools` para profiling.

**Decisión:** CUDA NO está en la instalación base. Se instala bajo demanda.

### 44.2.7 nvidia-vaapi-driver

- Traduce VA-API a NVDEC.
- Permite decodificación de video por hardware en aplicaciones que usan VA-API (Firefox, Chromium, GStreamer).
- Funciona con `nvidia-open`.

## 44.3 Problemas conocidos y mitigaciones

| Problema | Síntoma | Mitigación |
|----------|---------|-----------|
| **VSync roto en Wayland** | Tearing en videojuegos | `KWIN_DRM_NO_AMS=1` o esperar fix de NVIDIA |
| **Suspensión no funciona** | GPU no reactiva tras resume | `nvreg_EnableGpuFirmware=0` o `nvreg_RestrictProfiling=1` |
| **Multi-monitor con diferentes Hz** | Stutter en pantalla de 60Hz con monitor 144Hz | `nvidia_drm.fbdev=1` + límite de FPS en compositor |
| **Hyprland crashea con NVIDIA** | Hyprland se cierra al iniciar | Usar `hyprland-nvidia` (AUR) que incluye parches |
| **Vulkan no carga** | `vulkaninfo` falla | Verificar que `nvidia-utils` y `vulkan-icd-loader` están instalados |
| **Aplicaciones X11 no funcionan** | Ventanas negras en XWayland | Usar `XWAYLAND_ALLOW_COMMITS=1` o desactivar aceleración de la app |

### 44.3.1 Mitigación específica para Hyprland

Crear `/etc/environment.d/nvidia.conf`:

```
LIBVA_DRIVER_NAME=nvidia
GBM_BACKEND=nvidia-drm
__GLX_VENDOR_LIBRARY_NAME=nvidia
ENABLE_VKBASALT=1
WLR_NO_HARDWARE_CURSORS=1
```

## 44.4 Alternativas descartadas

| Alternativa | Razón |
|-------------|-------|
| `nouveau` (open source) | Sin reclocking, rendimiento pésimo, sin Vulkan, sin CUDA. |
| `nvidia` (cerrado, no open) | Se prefiere `nvidia-open` cuando es posible. |

## 44.5 Dependencias

- `nvidia-open` o `nvidia` (según GPU)
- `nvidia-utils`
- `egl-wayland`
- `libva-nvidia-driver` (para VA-API)
- `vulkan-icd-loader`
- `cuda` (opcional)

## 44.6 Pruebas

- `nvidia-smi` -> ver GPU, uso de VRAM, procesos
- `vulkaninfo --summary` -> NVIDIA Vulkan ICD cargado
- `glxinfo -B` -> NVIDIA OpenGL
- `nvtop` -> monitorización GPU en tiempo real
- Iniciar Hyprland y verificar que no hay crasheos con `hyprctl`

## 44.7 Mantenimiento

- Actualizaciones de drivers desde `lnos-stable` o `lnos-nvidia` (AUR).
- Las actualizaciones del kernel requieren reconstrucción de `nvidia-open` (DKMS) o esperar a que Arch proporcione binarios.
- Se recomienda mantener al menos 2 kernels instalados para tener un fallback.

## 44.8 Ampliación

- Soporte para **Optimus** (híbrido Intel/AMD + NVIDIA): `optimus-manager` o `supergfxctl`.
- Integración con **CUDA** para machine learning (PyTorch, TensorFlow).
- **NVIDIA Fabric Manager** para múltiples GPUs en servidor.

---

# 45. Microcode

## 45.1 ¿Para qué existe?

El microcode es una capa de microinstrucciones que parchea el comportamiento de la CPU en caliente. Las actualizaciones de microcode corrigen errores de hardware (errata) y vulnerabilidades de seguridad (Spectre, Meltdown, MMIO Stale Data, etc.) **sin cambiar el silicio**.

## 45.2 Intel-ucode vs amd-ucode

| Aspecto | Intel | AMD |
|---------|-------|-----|
| Paquete | `intel-ucode` | `amd-ucode` |
| Archivo de imagen | `/boot/intel-ucode.img` | `/boot/amd-ucode.img` |
| Formato en initramfs | CPIO | CPIO |
| Carga en bootloader | Antes del initramfs | Antes del initramfs |
| Frecuencia de actualización | Mensual (o semanal en vulnerabilidades graves) | Trimestral |
| Versión aplicada | Visible en `/proc/cpuinfo` (microcode field) | Visible en `dmesg | grep microcode` |

**Decisión de ingeniería:** Se incluye el microcode correspondiente según la CPU detectada en la instalación. Ambos paquetes son pequeños (~100KB) y no hay penalización en incluir ambos (el kernel aplica el que corresponda si no hay conflicto).

## 45.3 Aplicación en el bootloader

El microcode debe cargarse **antes** del initramfs. En systemd-boot:

```
title   LNOS
linux   /vmlinuz-linux
initrd  /intel-ucode.img
initrd  /initramfs-linux.img
options root=UUID=... quiet
```

En GRUB:

```
GRUB_EARLY_INITRD_LINUX_CUSTOM="intel-ucode.img"
```

**Error común:** Si el microcode se carga después del initramfs, no se aplica. El kernel solo admite microcode en los primeros 8 MB del initramfs.

## 45.4 Secure Boot y microcode

El microcode no está firmado. Con Secure Boot activo:

- El bootloader firmado carga `intel-ucode.img` o `amd-ucode.img` (sin firmar).
- El Secure Boot solo verifica el bootloader y el kernel, no los initrd.
- Si se usa `sbctl` o `mokutil`, el initrd completo se firma.

**Riesgo:** Un initrd malicioso podría inyectar microcode malicioso. Mitigación: firmar el initrd completo.

## 45.5 Actualizaciones de seguridad

Las actualizaciones de microcode se instalan como cualquier otro paquete. Sin embargo:

1. El nuevo microcode no se aplica hasta el **próximo reinicio**.
2. No hay mecanismo de aplicación en caliente (no hay kpatch para microcode).
3. Las vulnerabilidades corregidas se anuncian en los boletines de Intel/AMD.

**Flujo en LNOS:**

```
1. `pacman -Syu` descarga nuevo intel-ucode
2. `lnos-updater` detecta que microcode cambió
3. Se regenera initramfs (mkinitcpio -P)
4. Se notifica al usuario que debe reiniciar
5. En el próximo boot, el nuevo microcode se aplica
```

## 45.6 Verificación

```bash
# Intel
grep "microcode" /proc/cpuinfo | head -1

# AMD
dmesg | grep "microcode"

# Versión aplicada
cat /sys/devices/system/cpu/cpu0/microcode/version
```

## 45.7 Problemas y mitigaciones

| Problema | Síntoma | Acción |
|----------|---------|--------|
| Microcode antiguo aplicado | CPU vulnerable conocida sin corregir | `pacman -Syu && mkinitcpio -P && reboot` |
| Microcode no coincide con stepping | WARNING en dmesg | Verificar que el microcode es correcto para el modelo exacto |
| Arranque falla tras microcode | Kernel panic en early boot | Bootear kernel anterior, deshabilitar microcode añadiendo `dis_ucode_ldr` |

---

# 46. Wayland

## 46.1 ¿Para qué existe?

Wayland es el protocolo de servidor gráfico moderno que reemplaza a X11. En LNOS es el **único** servidor de pantalla soportado. X11 existe solo como capa de compatibilidad (XWayland).

## 46.2 Arquitectura

```
+-------------------------------------------------------------+
|                     Wayland Architecture                      |
+-------------------------------------------------------------+
|                                                              |
|  Aplicación (cliente Wayland)                                |
|       |                                                     |
|       v                                                     |
|  +----------+    +----------+    +----------+               |
|  |  wlroots  |    |   Mesa   |    |  Kernel  |               |
|  |  (Hyprland|    | (EGL/GL) |    |  (DRM)   |               |
|  |   compositor) |          |    |          |               |
|  +----------+    +----------+    +----------+               |
|       |                                                     |
|       v                                                     |
|  +----------+                                               |
|  |  KMS/DRM  |  (Direct Rendering Manager)                  |
|  +  libinput |  (input handling)                            |
|  +----------+                                               |
|                                                              |
+-------------------------------------------------------------+
```

**Características clave:**

- **Cada frame es completo:** No hay repaint parcial como en X11, el compositor decide.
- **Sin round trips:** Los protocolos son asíncronos; no hay bloqueos por petición-respuesta.
- **Seguridad:** No hay acceso global a input/output. Un cliente no puede leer el teclado de otro.

## 46.3 wlroots

wlroots es la biblioteca base sobre la que se construye Hyprland:

- Gestión de DRM/KMS
- Manejo de input (libinput)
- Gestión de outputs (monitores)
- Gestión de vistas (xdg-shell)
- Gestión de capas (layer-shell)

Hyprland usa wlroots como dependencia fundamental. No es un fork; es una integración estable.

## 46.4 Protocolos Wayland esenciales

| Protocolo | Propósito | Estado |
|-----------|-----------|--------|
| `xdg-shell` | Ventanas decoradas, minimizar, maximizar, cerrar | Estable |
| `layer-shell` | Paneles, notificaciones, barras (Waybar) | Estable |
| `wlr-screenshot` | Captura de pantalla | wlr-protocols |
| `wlr-foreign-toplevel` | Gestión de ventanas externas | wlr-protocols |
| `wlr-gamma-control` | Ajuste de gamma por monitor | wlr-protocols |
| `wlr-output-power-management` | Apagar/encender monitores | wlr-protocols |
| `ext-foreign-toplevel-list` | Gestión de ventanas (estándar) | En desarrollo |
| `fractional-scale-v1` | Escalado fraccional (125%, 150%) | Estable |
| `idle-inhibit` | Evitar suspensión | Estable |
| `input-method` | Métodos de entrada (IME) | Estable |

## 46.5 XWayland

- Proporciona compatibilidad con aplicaciones X11.
- Se ejecuta como un cliente Wayland más.
- Usa `xorg-xwayland`.
- No hay aceleración 3D directa; las aplicaciones X11 renderizan a un buffer que el compositor presenta.

**Limitaciones de XWayland:**

- Escalado fraccional limitado (o se escala entero o se ve borroso).
- Algunas extensiones X11 no están implementadas (ej. XTest complejo).
- Aplicaciones que esperan `_NET_WM_USER_TIME` pueden tener problemas de foco.

## 46.6 Seguridad en Wayland

| Aspecto | X11 | Wayland |
|---------|-----|---------|
| Keylogging | Cualquier cliente puede leer el teclado global | Imposible por diseño |
| Screen capturing | Cualquier cliente puede capturar la pantalla | Requiere protocolo explícito (screenshot) |
| Inyección de eventos | Cualquier cliente puede simular input | Deshabilitado por defecto |
| Aislamiento | Ninguno | Cada cliente está aislado |

## 46.7 Ventajas sobre X11

1. **Latencia reducida:** No hay servidor intermediario para el rendering.
2. **Sin tearing:** El compositor controla el buffer swap.
3. **Mejor gestión de monitores:** Hotplugging limpio, diferentes Hz por monitor.
4. **Seguridad:** Aislamiento completo entre clientes.
5. **Mantenimiento:** Código más limpio y moderno; no hay 40 años de legacy.

## 46.8 Problemas conocidos

| Problema | Estado | Mitigación |
|----------|--------|-----------|
| Algunas apps X11 no funcionan | Parcial | Usar `XWayland` + `X11_FORCE=1` |
| NVIDIA EGLStreams | Parcial | Usar GBM (ver capítulo 44) |
| Drag & drop entre Wayland y XWayland | A veces falla | Usar protocolo `data-device` |
| Grabación de pantalla con OBS | Solucionado | Usar `wlrobs` o `pipewire` + `xdg-desktop-portal-wlr` |

## 46.9 Pruebas

- `wayland-info` -> lista protocolos soportados
- `weston-info` -> información de la sesión Wayland
- `xdg-desktop-portal-wlr` funcionando -> test de grabación
- `XWayland` -> `xeyes` debe funcionar sin problemas

## 46.10 Mantenimiento

- wlroots se actualiza con `hyprland` (dependencia vinculada).
- Protocolos se actualizan con `wayland-protocols`.
- XWayland es parte de `xorg-xwayland`.

---

# 47. Hyprland

## 47.1 ¿Qué es Hyprland?

Hyprland es un compositor Wayland basado en wlroots, escrito en C++20, diseñado para ser moderno, animado y extensible. No es un fork de Sway ni un wrapper; es una implementación independiente.

## 47.2 wlroots-based, Wayland nativo

Hyprland implementa los protocolos Wayland estándar sobre wlroots. No usa X11 ni tiene capas de compatibilidad internas.

```
Hyprland
    |
    +-- wlroots (DRM/KMS, libinput, xdg-shell, layer-shell)
    +-- aquamarine (backend de renderizado propio)
    +-- pixman (software compositing)
    +-- libdrm (interfaz DRM)
```

## 47.3 Razones frente a alternativas

| Compositor | Base | Animaciones | Layouts | Rendimiento | RAM (idle) |
|------------|------|-------------|---------|-------------|------------|
| **Hyprland** | wlroots | Sí (nativas, aceleradas por GPU) | Master/Stack/Dwindle | Excelente | ~60-80 MB |
| **Sway** | wlroots | No (sin animaciones) | Tree (i3-like) | Excelente | ~40-60 MB |
| **River** | wlroots | No (barebones) | Layouts externos | Excelente | ~30-40 MB |
| **dwl** | wlroots | No (suckless) | Monocle/Stack | Excelente | ~20-30 MB |
| **Qtile (Wayland)** | wcso | Parcial | Python custom | Bueno | ~60-80 MB |
| **KDE (KWin/Wayland)** | Propio | Sí | KDE completo | Bueno | ~200-400 MB |
| **GNOME (Mutter)** | Propio | Sí (mínimas) | GNOME completo | Aceptable | ~200-500 MB |

**Decisión de ingeniería:** Hyprland se elige por:

1. **Animaciones GPU-acceleradas:** Proporcionan feedback visual sin apenas coste de CPU.
2. **Master Layout:** Flujo de trabajo productivo (ventana principal grande + stack secundario).
3. **Rendimiento:** Consume ~60-80 MB RAM en reposo frente a 200+ MB de GNOME/KDE.
4. **Configuración declarativa:** Archivo único `hyprland.conf`, sin necesidad de scripting.
5. **Comunidad activa:** Actualizaciones frecuentes, corrección rápida de bugs.

## 47.4 Animaciones

Las animaciones se ejecutan completamente en GPU (shaders GLES32). No hay animaciones por software.

```
hyprland.conf:
  animations {
    enabled = yes
    bezier = myBezier, 0.05, 0.9, 0.1, 1.05
    animation = windows, 1, 7, myBezier
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, myBezier, slide
  }
```

**Impacto en rendimiento:** Las animaciones añaden entre 0.5-1.5 ms por frame. En una GPU moderna, es imperceptible.

## 47.5 Window Management (layouts)

### 47.5.1 Master Layout

Es el layout predeterminado en LNOS:

```
+----------------------+--------------+
|                      |   Stack 1    |
|                      |              |
|     Master           +--------------+
|                      |   Stack 2    |
|   (ventana ppal)     |              |
|                      +--------------+
|                      |   Stack 3    |
+----------------------+--------------+
```

- La ventana principal (master) ocupa la mitad izquierda (o superior, configurable).
- El resto se apilan en el lado derecho.
- `super + M` cambia la ventana master.
- `super + +` / `super + -` cambia el ratio master/stack.

### 47.5.2 Dwindle Layout

- Layout jerárquico similar a i3/bspwm.
- Cada ventana divide el espacio disponible.
- No se usa como predeterminado por ser menos predecible que master.

### 47.5.3 Tiling manual

- `super + click` arrastra ventanas para reorganizarlas.
- `super + V` cambia a flotante.

## 47.6 Rendimiento

| Escenario | FPS | Consumo RAM |
|-----------|-----|-------------|
| Idle (sin apps) | 60 | ~60 MB |
| 1 terminal + 1 navegador | 60 | ~80 MB |
| 3 terminales + editor + navegador | 60 | ~100 MB |
| Reproducción de video 4K | 60 | ~90 MB |
| Juego (Vulkan) | 144 (vsync off) | ~120 MB |

## 47.7 Pruebas

- `hyprctl monitors` -> detectar monitores
- `hyprctl clients` -> listar ventanas
- `hyprctl animations` -> ver animaciones activas
- `hyprctl version` -> versión instalada
- Ejecutar `glxgears` -> verificar FPS sostenidos

## 47.8 Mantenimiento

- Se actualiza con `lnos-stable` (o `hyprland` desde `extra` de Arch).
- Las configuraciones no cambian entre versiones menores.
- Las versiones mayores pueden requerir ajustes (revisar `hyprctl version` antes de actualizar).

---

# 48. Configuración Completa de Hyprland

## 48.1 ¿Para qué existe?

Hyprland se configura exclusivamente via archivos de texto. No hay GUI de configuración. Esto permite:

- Control total sobre cada aspecto.
- Versionado con Git.
- Reproducibilidad entre máquinas.

## 48.2 Estructura de archivos

```
~/.config/hypr/
+-- hyprland.conf              # Archivo principal
+-- hyprland.conf.bak          # Backup automático
+-- hyprlock.conf              # Pantalla de bloqueo
+-- hypridle.conf              # Gestión de idle/suspensión
+-- themes/
|   +-- dark.conf              # Configuración para tema oscuro
|   +-- light.conf             # Configuración para tema claro
+-- monitors/
|   +-- single-eDP.conf        # Solo portátil
|   +-- dual-desk.conf         # Escritorio dual
|   +-- triple.conf            # Triple monitor
+-- binds/
|   +-- default.conf           # Atajos por defecto
|   +-- vim-navigation.conf    # Navegación estilo Vim
+-- windowrules/
    +-- games.conf             # Reglas para juegos
    +-- work.conf              # Reglas para apps de trabajo
```

**Decisión de ingeniería:** Se divide la configuración en archivos modulares para facilitar el mantenimiento.

## 48.3 Configuración de monitores

```conf
# hyprland.conf -> include
source = ~/.config/hypr/monitors/single-eDP.conf
```

```conf
# monitors/single-eDP.conf
monitor = eDP-1, 1920x1080@60, 0x0, 1
```

```conf
# monitors/dual-desk.conf
monitor = DP-1, 2560x1440@144, 0x0, 1
monitor = DP-2, 1920x1080@60, 2560x0, 1
```

## 48.4 Reglas de ventanas

```conf
windowrule = float, title:^(Calculator)$
windowrule = tile, title:^(Firefox)$
windowrule = workspace 1 silent, title:^(Alacritty)$
windowrule = opacity 0.9 0.9, class:^(kitty)$
windowrule = noanim, class:^(rofi)$
windowrule = noblur, class:^(rofi)$
windowrule = nomaxsize, class:^(Steam)$
windowrule = fullscreen, class:^(gamescope)$
```

## 48.5 Bindings

```conf
$mainMod = SUPER

# Navegación de ventanas
bind = $mainMod, H, movefocus, l
bind = $mainMod, L, movefocus, r
bind = $mainMod, K, movefocus, u
bind = $mainMod, J, movefocus, d

# Gestión de ventanas
bind = $mainMod, Q, killactive,
bind = $mainMod, F, fullscreen,
bind = $mainMod, T, togglefloating,
bind = $mainMod, M, layoutmsg, swapwithmaster master

# Workspaces
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
...
bind = $mainMod SHIFT, 1, movetoworkspacesilent, 1

# Lanzadores
bind = $mainMod, D, exec, rofi -show drun
bind = $mainMod, Return, exec, kitty
bind = $mainMod SHIFT, Return, exec, foot

# Screenshot
bind = , Print, exec, grimblast copysave area
```

## 48.6 Animaciones (detallado)

```conf
animations {
    enabled = yes

    # Curvas bezier personalizadas
    bezier = wind, 0.05, 0.9, 0.1, 1.05
    bezier = overshot, 0.13, 0.99, 0.29, 1.1
    bezier = linear, 0.0, 0.0, 1.0, 1.0

    # Animaciones específicas
    animation = windows, 1, 7, wind, slide
    animation = windowsOut, 1, 7, wind, slide
    animation = fade, 1, 5, linear
    animation = workspaces, 1, 6, overshot, slide
    animation = specialWorkspace, 1, 6, overshot, slidevert
    animation = border, 1, 10, default
}
```

## 48.7 Decoraciones

```conf
decoration {
    rounding = 10
    border_size = 2
    border_plus_passing = yes

    blur {
        enabled = yes
        size = 5
        passes = 3
        noise = 0.1
        contrast = 0.8
        brightness = 0.9
        popups = true
    }

    shadow {
        enabled = yes
        range = 20
        render_power = 3
        color = rgba(0, 0, 0, 0.8)
    }
}
```

## 48.8 Input

```conf
input {
    kb_layout = es
    kb_variant =
    kb_model =
    kb_options = ctrl:nocaps
    numlock_by_default = true

    follow_mouse = 1
    mouse_refocus = false

    touchpad {
        natural_scroll = yes
        tap-to-click = yes
        drag_lock = yes
        disable_while_typing = true
        clickfinger_behavior = yes
    }

    tablet {
        output = eDP-1
    }
}
```

## 48.9 Gestión de ventanas (Master Layout)

```conf
# Configuración específica para Master
master {
    new_status = master
    orientation = left
    smart_gaps = false
    mfact = 0.55
}

# Gaps
general {
    gaps_in = 5
    gaps_out = 10
    border_size = 2
    col.active_border = rgba(89b4faff)
    col.inactive_border = rgba(45475aff)
    cursor_inactive_timeout = 5
    no_focus_fallback = false
}
```

## 48.10 Variables de entorno

En `~/.config/hypr/hyprland.conf`:

```conf
env = XDG_CURRENT_DESKTOP,Hyprland
env = XDG_SESSION_TYPE,wayland
env = XDG_SESSION_DESKTOP,Hyprland
env = QT_QPA_PLATFORM,wayland;xcb
env = GDK_BACKEND,wayland,x11
env = _JAVA_AWT_WM_NONREPARENTING,1
env = NIXOS_OZONE_WL,1
```

## 48.11 Mantenimiento

- La configuración se valida con `hyprctl configinfo`.
- `hyprctl reload` recarga sin reiniciar.
- Los cambios en monitors requieren reinicio de Hyprland.

---

# 49. Waybar

## 49.1 ¿Para qué existe?

Waybar es una barra de estado para compositores Wayland basados en wlroots. Proporciona información del sistema y permite lanzar acciones.

## 49.2 Arquitectura

```
+-----------------------------------------------------------------+
|                         Waybar (barra superior/inferior)        |
+-----------------------------------------------------------------+
|                                                                 |
|  Workspaces | Clock | CPU | Memory | Network | Audio | Battery |
|  (Hyprland  |       |     |        |         |       |         |
|   IPC via   |       |     |        |         |       |         |
|   hyprctl)  |       |     |        |         |       |         |
|                                                                 |
+-----------------------------------------------------------------+
```

## 49.3 Configuración

### 49.3.1 Estructura

```
~/.config/waybar/
+-- config.jsonc       # Configuración de módulos
+-- style.css          # Estilos CSS
+-- modules/
|   +-- clock.jsonc    # Módulo de reloj
|   +-- cpu.jsonc      # Módulo de CPU
|   +-- battery.jsonc  # Módulo de batería
+-- themes/
    +-- dark.css
    +-- light.css
```

### 49.3.2 Ejemplo de `config.jsonc`

```jsonc
{
    "layer": "top",
    "position": "top",
    "height": 30,
    "modules-left": ["hyprland/workspaces"],
    "modules-center": ["clock"],
    "modules-right": ["cpu", "memory", "network", "pulseaudio", "battery", "tray"],
    "hyprland/workspaces": {
        "format": "{icon}",
        "on-click": "activate",
        "format-icons": {
            "1": "1",
            "2": "2",
            "3": "3",
            "4": "4",
            "5": "5",
            "urgent": "!"
        }
    },
    "clock": {
        "format": "{:%H:%M  %d/%m/%Y}",
        "tooltip-format": "{:%A, %d de %B de %Y}",
        "interval": 60
    },
    "cpu": {
        "format": "CPU {usage}%",
        "interval": 2
    },
    "memory": {
        "format": "RAM {}%",
        "interval": 5
    },
    "network": {
        "format-wifi": "WiFi {signalStrength}%",
        "format-ethernet": "Eth {ipaddr}",
        "format-disconnected": "Desconectado",
        "interval": 10
    },
    "pulseaudio": {
        "format": "{volume}% {icon}",
        "format-icons": ["muted", "low", "medium", "high"],
        "on-click": "pavucontrol"
    },
    "battery": {
        "format": "{capacity}% {icon}",
        "format-icons": ["", "", "", "", ""],
        "interval": 30
    },
    "tray": {
        "icon-size": 16,
        "spacing": 5
    }
}
```

### 49.3.3 CSS personalizado (`style.css`)

```css
* {
    font-family: "JetBrains Mono", "Noto Sans", sans-serif;
    font-size: 13px;
    min-height: 0;
}

window#waybar {
    background: rgba(30, 30, 46, 0.9);
    color: #cdd6f4;
}

#workspaces button {
    padding: 0 5px;
    background: transparent;
    color: #585b70;
}

#workspaces button.active {
    color: #89b4fa;
}

#workspaces button.urgent {
    color: #f38ba8;
}

#clock, #cpu, #memory, #network, #pulseaudio, #battery {
    padding: 0 10px;
}

#cpu { color: #a6e3a1; }
#memory { color: #89b4fa; }
#network { color: #94e2d5; }
#pulseaudio { color: #cba6f7; }
#battery { color: #a6e3a1; }
#battery.warning { color: #f9e2af; }
#battery.critical { color: #f38ba8; }
```

## 49.4 Módulos principales

| Módulo | Función | IPC con Hyprland |
|--------|---------|-----------------|
| `hyprland/workspaces` | Lista workspaces activos | Sí (`hyprctl` para workspaces) |
| `hyprland/window` | Título de la ventana activa | Sí |
| `hyprland/submap` | Submodo actual | Sí |
| `clock` | Fecha y hora | No |
| `cpu` | Uso de CPU (%) | No |
| `memory` | Uso de RAM (%) | No |
| `disk` | Uso de disco | No |
| `network` | Estado de red | No |
| `pulseaudio` | Volumen de audio | No |
| `battery` | Estado de batería | No |
| `tray` | Bandeja del sistema (GTK/QT) | No |
| `custom` | Scripts personalizados | No |

## 49.5 Integración con Hyprland via IPC

Waybar usa `libhyprpanel` internamente para comunicarse con Hyprland:

```jsonc
"hyprland/workspaces": {
    "all-outputs": true,
    "format": "{name}",
    "on-click": "activate",
    "persistent-workspaces": {
        "eDP-1": [1, 2, 3, 4],
        "DP-1": [5, 6, 7, 8]
    }
}
```

## 49.6 Rendimiento

| Escenario | Consumo RAM |
|-----------|-------------|
| Waybar mínimo (workspaces + clock) | ~8 MB |
| Waybar completo (8 módulos) | ~15 MB |
| Waybar + animaciones CSS | ~18 MB |

## 49.7 Mantenimiento

- Las configuraciones son compatibles entre versiones.
- Se recomienda usar `waybar -h` para ver opciones de debugging.
- `pkill waybar && waybar` para reiniciar.

---

# 50. Rofi

## 50.1 ¿Para qué existe?

Rofi es un lanzador de aplicaciones, cambiador de ventanas, y selector de comandos. Es el punto de entrada principal en LNOS para ejecutar aplicaciones (`super + D`).

## 50.2 Modos

| Modo | Descripción | Comando |
|------|-------------|---------|
| `drun` | Lanza aplicaciones desde archivos `.desktop` | `rofi -show drun` |
| `run` | Lanza comandos arbitrarios | `rofi -show run` |
| `window` | Cambia entre ventanas abiertas | `rofi -show window` |
| `ssh` | Conexión SSH a hosts conocidos | `rofi -show ssh` |
| `combi` | Combina drun + run + window | `rofi -show combi` |
| `keys` | Muestra atajos de teclado | `rofi -show keys` |
| `file browser` | Navegación de archivos | `rofi -show filebrowser` |

## 50.3 Integraciones

### 50.3.1 Clipboard

```bash
# ~/.config/rofi/clipboard.sh
#!/bin/bash
cliphist list | rofi -dmenu -p "Clipboard" | cliphist decode | wl-copy
```

### 50.3.2 Emoji

```bash
# ~/.config/rofi/emoji.sh
#!/bin/bash
rofi -modi emoji -show emoji
```

### 50.3.3 Calculadora

```bash
# ~/.config/rofi/calc.sh
#!/bin/bash
echo "" | rofi -dmenu -p "Calc" -theme ~/.config/rofi/calc.rasi | bc | wl-copy
```

## 50.4 Configuración de temas

```
~/.config/rofi/
+-- config.rasi         # Configuración global
+-- themes/
|   +-- catppuccin-mocha.rasi
|   +-- catppuccin-latte.rasi
|   +-- launcher.rasi
|   +-- powermenu.rasi
+-- scripts/
|   +-- clipboard.sh
|   +-- emoji.sh
|   +-- calc.sh
+-- powermenu.sh        # Menú de apagado
```

## 50.5 Ejemplo de `config.rasi`

```
configuration {
    modi: "drun,run,window,ssh,combi";
    show-icons: true;
    icon-theme: "Papirus-Dark";
    drun-display-format: "{name}";
    font: "JetBrains Mono 12";
    terminal: "kitty";
}
@theme "~/.config/rofi/themes/catppuccin-mocha.rasi"
```

## 50.6 Atajos de teclado en Hyprland

```conf
# Rofi como lanzador
bind = $mainMod, D, exec, rofi -show drun

# Rofi como cambiador de ventanas
bind = $mainMod, Tab, exec, rofi -show window

# Rofi como menú de energía
bind = $mainMod, Escape, exec, ~/.config/rofi/powermenu.sh

# Rofi como emoji picker
bind = $mainMod, period, exec, ~/.config/rofi/emoji.sh

# Rofi como gestor de clipboard
bind = $mainMod, V, exec, ~/.config/rofi/clipboard.sh
```

## 50.7 Rendimiento

| Modo | Tiempo de apertura | RAM adicional |
|------|-------------------|---------------|
| drun (sin cache) | ~150 ms | ~30 MB |
| drun (con cache) | ~20 ms | ~30 MB |
| window | ~10 ms | ~15 MB |
| ssh | ~5 ms | ~10 MB |

---

# 51. Kitty

## 51.1 ¿Para qué existe?

Kitty es un emulador de terminal acelerado por GPU, diseñado para ser rápido, ligero y rico en características. Es el terminal predeterminado en LNOS.

## 51.2 Kitty vs Alternativas

| Terminal | GPU | Multiplexor interno | SSH integration | Remote control | Licencia |
|----------|-----|---------------------|----------------|----------------|----------|
| **Kitty** | Sí (OpenGL) | Sí (kittens) | Sí (kitten ssh) | Sí | GPLv3 |
| **Alacritty** | Sí (OpenGL) | No | No | No | Apache 2.0 |
| **Foot** | No (software) | No | No | No | MIT |
| **WezTerm** | Sí (OpenGL) | Sí (tabs) | No | No | MIT |

**Decisión de ingeniería:** Kitty es el predeterminado porque:

1. **GPU-accelerated:** Renderiza texto en GPU, permitiendo 240+ FPS incluso con mucho texto.
2. **Kittens:** Sistema de scripts (kittens) que proporcionan funcionalidades avanzadas sin salir de la terminal.
3. **SSH integration:** `kitten ssh` maneja forwarding de configuración automática.
4. **Remote control:** Puede ser controlado desde scripts externos.
5. **Ligero:** ~15 MB RAM en reposo.

## 51.3 Configuración de Kitty

```
~/.config/kitty/
+-- kitty.conf              # Configuración principal
+-- current-session.conf    # Sesión guardada
+-- theme.conf              # Tema (Catppuccin Mocha)
+-- ssh.conf                # Configuración SSH
+-- fonts.conf              # Configuración de fuentes
```

### 51.3.1 `kitty.conf`

```conf
# Fuente
font_family      JetBrains Mono
bold_font         JetBrains Mono Bold
italic_font       JetBrains Mono Italic
font_size        11.0

# Desplazamiento
scrollback_lines 10000
scrollback_pager less --chop-long-lines +G

# Aceleración
sync_to_monitor no
repaint_delay 2
input_delay 1

# Apariencia
background_opacity 0.95
hide_window_decorations yes
confirm_os_window_close 0

# Atajos
map ctrl+shift+t new_tab
map ctrl+shift+q close_tab
map ctrl+shift+enter new_window
map ctrl+shift+right next_tab
map ctrl+shift+left previous_tab

# Tema
include theme.conf

# Integración Wayland
linux_display_server wayland
```

### 51.3.2 Tema (Catppuccin Mocha)

```conf
# theme.conf
foreground #cdd6f4
background #1e1e2e
selection_foreground #1e1e2e
selection_background #585b70

color0 #45475a
color1 #f38ba8
color2 #a6e3a1
color3 #f9e2af
color4 #89b4fa
color5 #cba6f7
color6 #94e2d5
color7 #bac2de
color8 #585b70
color9 #f38ba8
color10 #a6e3a1
color11 #f9e2af
color12 #89b4fa
color13 #cba6f7
color14 #94e2d5
color15 #a6adc8
```

## 51.4 SSH integration (kitten)

```bash
kitten ssh usuario@servidor
```

Ventajas frente a `ssh` estándar:

- Las configuraciones de Kitty (tema, fuente) se replican del lado remoto.
- El scrollback funciona remotamente.
- Se pueden usar kittens del lado remoto.

## 51.5 Remote control

```bash
kitty @ set-font-size 15
kitty @ new-window --cwd /proyecto
kitty @ resize-window --axis horizontal --increment 20
kitty @ close-window
```

## 51.6 Rendimiento

| Prueba | Kitty | Alacritty | Foot |
|--------|-------|-----------|------|
| Idle RAM | ~15 MB | ~8 MB | ~4 MB |
| Scroll masivo (100k líneas) | 60 FPS | 60 FPS | 30 FPS |
| Carga de 1000 archivos en editor | 120 FPS | 120 FPS | 45 FPS |
| Font ligatures | Sí | Sí | No |
| Renderizado Unicode (CJK) | Excelente | Bueno | Básico |

---

# 52. Foot

## 52.1 ¿Para qué existe?

Foot es un emulador de terminal minimalista, nativo de Wayland (sin X11 support), renderizado por software. Es la alternativa ligera en LNOS para hardware modesto o cuando se necesita mínimo consumo.

## 52.2 Foot vs Kitty

| Aspecto | Kitty | Foot |
|---------|-------|------|
| **Público objetivo** | Usuarios que quieren máximas prestaciones | Usuarios que quieren mínimo consumo |
| **Renderizado** | GPU | CPU (software) |
| **RAM en idle** | ~15 MB | ~4 MB |
| **Funcionalidades** | Tabs, kittens, remote control, SSH | Mínimas (solo terminal) |
| **Rendimiento con mucho texto** | Excelente | Bueno |
| **Consumo de batería** | Medio (GPU activa) | Bajo (solo CPU) |
| **Dependencias** | OpenGL, fontconfig, libxkbcommon | Solo Wayland, fontconfig |

**Cuándo usar cada uno:**

- **Kitty:** Uso diario, desarrollo, multitarea pesada.
- **Foot:** Sesiones ligeras, hardware antiguo, maximizar batería, servidores.

## 52.3 Configuración

```
~/.config/foot/foot.ini
```

### 52.3.1 `foot.ini`

```ini
[main]
term=xterm-256color
font=JetBrains Mono:size=10
dpi-aware=yes

[scrollback]
lines=10000
indicator-position=relative

[colors]
background=1e1e2e
foreground=cdd6f4
regular0=45475a
regular1=f38ba8
regular2=a6e3a1
regular3=f9e2af
regular4=89b4fa
regular5=cba6f7
regular6=94e2d5
regular7=bac2de
bright0=585b70
bright1=f38ba8
bright2=a6e3a1
bright3=f9e2af
bright4=89b4fa
bright5=cba6f7
bright6=94e2d5
bright7=a6adc8

[key-bindings]
search-start=ctrl+shift+f
font-increase=ctrl+plus
font-decrease=ctrl+minus

[mouse]
hide-when-typing=yes

[cursor]
style=beam
color=cdd6f4 1e1e2e
```

## 52.4 Rendimiento en hardware modesto

| Hardware | Kitty (FPS) | Foot (FPS) |
|----------|-------------|------------|
| Intel Celeron N4000 (GPU débil) | 25 FPS | 60 FPS |
| Raspberry Pi 4 | 20 FPS | 60 FPS |
| ThinkPad X230 (Ivy Bridge) | 45 FPS | 60 FPS |
| AMD Ryzen 7 + GPU dedicada | 240 FPS | 60 FPS |

Foot es superior en hardware sin GPU potente porque no depende de OpenGL.

## 52.5 Dependencias

- `foot` (paquete)
- `fonts` (cualquier fuente mono)

---

# 53. Fastfetch

## 53.1 ¿Para qué existe?

Fastfetch es una herramienta de información del sistema, similar a Neofetch pero significativamente más rápida y rica en información. Se usa en LNOS para diagnóstico rápido y personalización del prompt.

## 53.2 Fastfetch vs Alternativas

| Herramienta | Lenguaje | Velocidad | Info de hardware | Info de software | Personalizable |
|-------------|----------|-----------|-----------------|------------------|---------------|
| **Fastfetch** | C | ~2 ms | Completa | Completa | Alta (JSONC) |
| **Neofetch** | Bash | ~150 ms | Completa | Completa | Alta (Bash) |
| **Screenfetch** | Bash | ~200 ms | Básica | Básica | Baja |
| **pfetch** | Bash | ~80 ms | Media | Media | Media |
| **Macchina** | Rust | ~5 ms | Media | Media | Media |

**Decisión:** Fastfetch reemplaza a Neofetch (que está en desarrollo ralentizado) por:

1. **Velocidad:** 2 ms vs 150 ms de Neofetch. La diferencia es notable en un prompt de shell.
2. **Mantenimiento activo:** Neofetch está sin commits desde 2022.
3. **Más información:** Fastfetch detecta más hardware (BIOS, resolución de monitor, GPU, etc.).
4. **Formato de salida:** JSON, XML, raw, etc.

## 53.3 Configuración

```
~/.config/fastfetch/
+-- config.jsonc      # Configuración global
+-- presets/
    +-- minimal.jsonc  # Solo info esencial
    +-- full.jsonc     # Toda la info disponible
    +-- logo.jsonc     # Solo logo + OS
```

### 53.3.1 `config.jsonc` (predeterminado LNOS)

```jsonc
{
    "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
    "logo": {
        "type": "small",
        "color": {
            "1": "blue"
        }
    },
    "display": {
        "separator": " -> ",
        "color": "cyan"
    },
    "modules": [
        "title",
        "separator",
        "os",
        "host",
        "kernel",
        "uptime",
        "packages",
        "shell",
        "display",
        "de",
        "wm",
        "wmtheme",
        "terminal",
        "terminalfont",
        "cpu",
        "gpu",
        "memory",
        "disk",
        "battery",
        "locale",
        "localip",
        "break",
        "colors"
    ]
}
```

### 53.3.2 Salida esperada

```
       +-----+  LNOS (Arch Linux x86_64)
      /       \  Host -> ThinkPad X1 Carbon Gen 11
     |  o  o  |  Kernel -> Linux 6.9.3-arch1-1
     |    V   |  Uptime -> 2 hours, 34 mins
      \       /  Packages -> 1342 (pacman), 23 (flatpak)
       +-----+   Shell -> zsh 5.9
                Display -> 1920x1080 @ 60 Hz
                DE -> Hyprland (Wayland)
                Terminal -> Kitty 0.35.2
                CPU -> 13th Gen Intel i7-1365U (12)
                GPU -> Intel Iris Xe Graphics
                Memory -> 3.5 GiB / 15.3 GiB (23%)
                Disk -> 120 GiB / 500 GiB (24%)
                Battery -> 78% (Charging)
                Locale -> es_ES.UTF-8
                IP -> 192.168.1.42
                ## ## ## ## ## ## ## ##
```

## 53.4 Integración con shell prompt

```zsh
# ~/.zshrc
fastfetch --config minimal
```

O en el prompt:

```zsh
# ~/.zshrc (precmd hook)
precmd() {
    fastfetch --pipe true --config minimal --recache
}
```

## 53.5 Mantenimiento

- Fastfetch se actualiza con `lnos-stable`.
- Los presets son compatibles entre versiones.
- `fastfetch --list-modules` para ver todos los módulos disponibles.

---

# 54. GTK

## 54.1 ¿Para qué existe?

GTK (GIMP Toolkit) es el toolkit de interfaz gráfica usado por la mayoría de aplicaciones nativas de Linux. En LNOS, GTK3 y GTK4 coexisten.

## 54.2 GTK3 vs GTK4 en LNOS

| Aspecto | GTK3 | GTK4 |
|---------|------|------|
| **Aplicaciones que lo usan** | Firefox, Thunar, GIMP, Inkscape | GNOME Files (nautilus), GTK4 apps nuevas |
| **Tema** | Adwaita adaptado | Adwaita nativo |
| **Configuración** | `~/.config/gtk-3.0/settings.ini` | `~/.config/gtk-4.0/settings.ini` |
| **Soporte Wayland** | Completo (GDK_BACKEND=wayland) | Nativo |
| **Rendimiento** | Bueno | Mejor (menos overhead de rendering) |

**Decisión de ingeniería:** Se configuran ambos, dando prioridad a GTK4 cuando sea posible. GTK3 se mantiene por compatibilidad.

## 54.3 Tema por defecto

**Elección:** Tema personalizado base Catppuccin Mocha adaptado para GTK3/GTK4.

**Alternativas descartadas:**

| Tema | Razón de descarte |
|------|-------------------|
| Adwaita estándar | Gris claro, sin respetar tema oscuro del sistema |
| Adwaita-dark | Mejor, pero limitado (no personalizable) |
| Gradience | Requiere Flatpak y no tiene perfiles estables |
| Arc | Sin actualizaciones desde 2022 |
| Materia | Sin soporte GTK4 |
| Nordic | Bueno, pero Catppuccin tiene más ecosistema |

**Decisión:** Tema Catppuccin Mocha adaptado (se genera con `catppuccin-gtk`) porque:

1. Cohesión visual con el resto del sistema (Hyprland, Kitty, Rofi, Waybar).
2. Mantenimiento activo (Catppuccin es uno de los proyectos de temas más activos).
3. Soporta GTK3, GTK4, y las variantes de color.

## 54.4 Configuración

### 54.4.1 `~/.config/gtk-3.0/settings.ini`

```ini
[Settings]
gtk-theme-name=Catppuccin-Mocha-Standard-Blue-Dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=Noto Sans, 10
gtk-cursor-theme-name=Bibata-Modern-Classic
gtk-cursor-theme-size=24
gtk-toolbar-style=GTK_TOOLBAR_BOTH
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=1
gtk-menu-images=1
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=1
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintmedium
gtk-xft-rgba=rgb
gtk-application-prefer-dark-theme=1
gtk-decoration-layout=menu:close
```

### 54.4.2 `~/.config/gtk-4.0/settings.ini`

```ini
[Settings]
gtk-theme-name=Catppuccin-Mocha-Standard-Blue-Dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=Noto Sans, 10
gtk-cursor-theme-name=Bibata-Modern-Classic
gtk-cursor-theme-size=24
gtk-application-prefer-dark-theme=1
```

## 54.5 Integración Wayland

```bash
# ~/.config/environment.d/gtk.conf
GDK_BACKEND=wayland,x11
```

Si `GDK_BACKEND=wayland` no se establece, GTK usará X11. Esto es crítico para que las aplicaciones GTK se muestren correctamente en Hyprland.

## 54.6 Tema oscuro por defecto

`gtk-application-prefer-dark-theme=1` fuerza el tema oscuro en GTK3 (Adwaita-dark si se usa Adwaita, o el tema oscuro de Catppuccin). En GTK4, esto funciona de manera nativa.

## 54.7 Dependencias

- `gtk3`
- `gtk4`
- `catppuccin-gtk` (desde lnos-stable o AUR)
- `papirus-icon-theme`

## 54.8 Pruebas

- `gsettings get org.gnome.desktop.interface gtk-theme` -> `Catppuccin-Mocha-...`
- Iniciar `gtk3-demo` y `gtk4-demo` -> verificar tema aplicado
- `GDK_DEBUG=interactive gtk4-widget-factory` -> inspeccionar widgets

---

# 55. QT

## 55.1 ¿Para qué existe?

QT es el toolkit usado por aplicaciones como KDE apps, qBittorrent, Wireshark, VLC (Qt interface), y muchas más. En LNOS, QT5 y QT6 coexisten.

## 55.2 QT5 vs QT6 en LNOS

| Aspecto | QT5 | QT6 |
|---------|-----|-----|
| **Aplicaciones** | qBittorrent, Wireshark, VLC | Krita, qBittorrent (nuevo), apps nuevas |
| **Tema** | `adwaita-qt` + `qt5ct` | `adwaita-qt` + `qt6ct` |
| **Configuración** | `qt5ct` | `qt6ct` |
| **Soporte Wayland** | Parcial (QT_WAYLAND_SHELL_INTEGRATION) | Nativo |
| **Rendimiento** | Bueno | Excelente |

**Decisión de ingeniería:** Se configuran ambas con `adwaita-qt` para que sigan el tema del sistema. Para personalización, se usan `qt5ct` y `qt6ct`.

## 55.3 Tema (adwaita-qt, qt6ct)

| Opción | Descripción | Estado |
|--------|-------------|--------|
| `adwaita-qt` | Tema que hace que las apps QT parezcan GTK Adwaita | Estable, recomendado |
| `qt6ct` | Panel de control para temas QT6 | Estable |
| `qt5ct` | Panel de control para temas QT5 | Estable |
| `breeze` | Tema KDE | Demasiado "KDE", no cohesivo |
| `kvantum` | Motor de temas SVG | Sobredimensionado, ralentiza |

**Decisión:** `adwaita-qt` es el tema por defecto. Si el usuario quiere más control, `qt6ct`/`qt5ct`.

## 55.4 Configuración

### 55.4.1 `~/.config/qt5ct/qt5ct.conf`

```ini
[Appearance]
style=adwaita-dark
color_scheme_path=/usr/share/qt5ct/colors/adwaita-dark.conf
custom_palette=false
icon_theme=Papirus-Dark
standard_dialogs=default
```

### 55.4.2 `~/.config/qt6ct/qt6ct.conf`

```ini
[Appearance]
style=adwaita-dark
color_scheme_path=/usr/share/qt6ct/colors/adwaita-dark.conf
custom_palette=false
icon_theme=Papirus-Dark
standard_dialogs=default
```

## 55.5 Integración Wayland

```bash
# ~/.config/environment.d/qt.conf
QT_QPA_PLATFORM=wayland;xcb
```

## 55.6 Aplicaciones QT en Hyprland

Algunas aplicaciones QT tienen problemas en Wayland:

| Problema | Síntoma | Solución |
|----------|---------|----------|
| Menús desplegables en posición incorrecta | El menú aparece en otra pantalla | `QT_WAYLAND_SHELL_INTEGRATION=xdg-shell` o actualizar QT |
| Ventanas sin bordes | La app no tiene decoraciones | `QT_WAYLAND_FORCE_DISABLE_HIGHDPI_SCALING=1` |
| Drag & drop no funciona | No se pueden arrastrar archivos | Usar `XWayland` temporalmente |
| Clipboard no funciona | Copiar/pegar entre apps no funciona | `export QT_QPA_PLATFORM=wayland` y asegurar que `wl-clipboard` está instalado |

## 55.7 Dependencias

- `qt5-base`
- `qt6-base`
- `adwaita-qt5`
- `adwaita-qt6`
- `qt5ct`
- `qt6ct`
- `papirus-icon-theme`

## 55.8 Pruebas

- `qt5ct` -> abrir y verificar tema
- `qt6ct` -> abrir y verificar tema
- Iniciar `qterminal` -> verificar que el tema oscuro se aplica
- `QT_QPA_PLATFORM=wayland qbittorrent` -> verificar integración Wayland

---

# 56. Cursores

## 56.1 ¿Para qué existe?

Los cursores definen el aspecto visual del puntero del ratón. En LNOS deben ser cohesivos con el tema general, funcionar en GTK, QT, y el compositor Wayland.

## 56.2 Tema de cursores

**Elección:** `Bibata-Modern-Classic` (tamaño 24).

**Alternativas descartadas:**

| Tema | Razón |
|------|-------|
| Adwaita | Muy pequeño, no personalizable |
| Adwaita-large | Mejor, pero sin variedad de estilos |
| Vanilla-DMZ | Genérico, aspecto antiguo |
| Capitaine | Bueno, pero sin mantenimiento activo |
| Bibata | Excelente, mantenimiento activo, variantes (Classic, Ice, Modern) |

**Decisión:** Bibata-Modern-Classic porque es moderno, tiene buena visibilidad, y el proyecto está activo en GitHub con actualizaciones periódicas.

## 56.3 Configuración

### 56.3.1 Entorno Hyprland

```bash
# ~/.config/hypr/hyprland.conf
env = XCURSOR_THEME,Bibata-Modern-Classic
env = XCURSOR_SIZE,24
```

```bash
# ~/.config/environment.d/cursor.conf
XCURSOR_THEME=Bibata-Modern-Classic
XCURSOR_SIZE=24
```

### 56.3.2 GTK

```ini
# ~/.config/gtk-3.0/settings.ini
gtk-cursor-theme-name=Bibata-Modern-Classic
gtk-cursor-theme-size=24
```

```ini
# ~/.config/gtk-4.0/settings.ini
gtk-cursor-theme-name=Bibata-Modern-Classic
gtk-cursor-theme-size=24
```

### 56.3.3 QT

```bash
# Forzar cursor en QT (si no funciona)
export QT_QPA_PLATFORMTHEME=qt5ct
# y configurar en qt5ct/qt6ct el tema de cursores
```

### 56.3.4 HYPRCURSOR

Hyprland tiene su propio sistema de cursores:

```bash
hyprctl setcursor Bibata-Modern-Classic 24
```

## 56.4 Tamaño por defecto

- **24px**: Tamaño estándar para pantallas FHD/QHD.
- **32px**: Para pantallas 4K (escalado 1x) o usuarios que prefieren cursores grandes.
- **48px**: Para pantallas 4K con escalado 2x.

## 56.5 Dependencias

- `bibata-cursor-theme` (AUR / lnos-stable)
- `xcursor-themes` (si se necesita Adwaita como fallback)

## 56.6 Pruebas

- Mover el ratón en Hyprland -> verificar el tema
- `hyprctl getoption cursor:theme` -> `Bibata-Modern-Classic`
- Abrir app GTK -> el cursor debe coincidir
- Abrir app QT -> el cursor debe coincidir

---

# 57. Iconos

## 57.1 ¿Para qué existe?

El tema de iconos proporciona las representaciones visuales de archivos, aplicaciones y carpetas. Un buen tema de iconos es esencial para la experiencia de escritorio.

## 57.2 Tema de iconos

**Elección:** `Papirus-Dark` (variante oscura).

**Alternativas descartadas:**

| Tema | Razón |
|------|-------|
| Adwaita | Genérico, pocos iconos de terceros |
| Adwaita-icon-theme | Mínimo, incompleto para apps no GNOME |
| Tela | Bueno, menos cobertura que Papirus |
| Papirus | Excelente cobertura, activo, variante oscura |
| Numix | Sin mantenimiento desde 2022 |
| ePapirus | Variante de Papirus para apps adicionales |

**Decisión:** Papirus-Dark porque:

1. **Cobertura:** Más de 10,000 iconos para aplicaciones, carpetas y tipos MIME.
2. **Mantenimiento:** Actualizaciones frecuentes (GitHub activo, releases cada mes).
3. **Variante oscura:** Cohesión con el tema oscuro general.
4. **Compatibilidad:** Funciona en GTK, QT, y entornos de escritorio.

## 57.3 Configuración

### 57.3.1 GTK

```ini
# ~/.config/gtk-3.0/settings.ini
gtk-icon-theme-name=Papirus-Dark
```

### 57.3.2 QT

Configurar desde `qt5ct` / `qt6ct` -> icon theme -> `Papirus-Dark`.

### 57.3.3 Rofi

```rasi
# ~/.config/rofi/config.rasi
configuration {
    show-icons: true;
    icon-theme: "Papirus-Dark";
}
```

## 57.4 Iconos para aplicaciones LNOS

Las aplicaciones propias de LNOS (`lnos-software`, `lnos-updater`) deben incluir iconos en el formato estándar:

```
/usr/share/icons/hicolor/
+-- 16x16/apps/lnos-software.png
+-- 24x24/apps/lnos-software.png
+-- 32x32/apps/lnos-software.png
+-- 48x48/apps/lnos-software.png
+-- 64x64/apps/lnos-software.png
+-- 128x128/apps/lnos-software.png
+-- scalable/apps/lnos-software.svg
```

## 57.5 Dependencias

- `papirus-icon-theme` (extra de Arch)

## 57.6 Pruebas

- Abrir Nautilus -> verificar iconos de carpetas y archivos
- Abrir Rofi -> los iconos deben aparecer
- `ls /usr/share/icons/Papirus-Dark/` -> verificar estructura

---

# 58. Temas

## 58.1 ¿Para qué existe?

Un tema visual cohesivo es la clave para que un sistema se sienta "polished". LNOS define un tema completo que abarca GTK, QT, iconos, cursores, shell, wallpapers y fuentes.

## 58.2 Tema completo

| Componente | Tema |
|------------|------|
| **GTK3/GTK4** | Catppuccin-Mocha-Standard-Blue-Dark |
| **QT5/QT6** | adwaita-qt (con colores oscuros via qt5ct/qt6ct) |
| **Iconos** | Papirus-Dark |
| **Cursores** | Bibata-Modern-Classic |
| **Shell (prompt)** | Catppuccin Mocha (zsh + p10k) |
| **Terminal** | Catppuccin Mocha (Kitty/Foot) |
| **Barra (Waybar)** | Catppuccin Mocha |
| **Lanzador (Rofi)** | Catppuccin Mocha |
| **Wallpaper** | Catppuccin Mocha abstract gradient |
| **Fuente mono** | JetBrains Mono |
| **Fuente sans** | Noto Sans |
| **Paleta de color** | Catppuccin Mocha |

## 58.3 Tema oscuro como predeterminado

LNOS arranca en tema oscuro. Razones:

1. **Fatiga visual:** El tema oscuro reduce la fatiga visual en entornos de baja luz.
2. **Ahorro energético:** En pantallas OLED/AMOLED, los píxeles negros están apagados.
3. **Estética:** Consistencia con la industria del desarrollo (VS Code, JetBrains, terminal).
4. **Moda en desarrollo:** La mayoría de herramientas de desarrollo tienen tema oscuro; tener el sistema en oscuro es cohesivo.

## 58.4 Tema claro como opción

Se proporciona un script `lnos-theme` para cambiar entre claro y oscuro:

```bash
lnos-theme dark    # Cambia todo a oscuro
lnos-theme light   # Cambia todo a claro
lnos-theme toggle  # Alterna entre ambos
```

El tema claro usa Catppuccin Latte (contraparte clara de Mocha).

## 58.5 Catppuccin como base

**Por qué Catppuccin?**

| Aspecto | Catppuccin | Otros |
|---------|------------|-------|
| **Variantes** | 4 (Mocha, Macchiato, Frappe, Latte) | 1-2 (Nord, Dracula) |
| **Acabado** | 26 colores + 8 de acento | 16 colores |
| **Ecosistema** | 200+ ports (GTK, QT, terminales, editores, etc.) | 20-30 ports |
| **Mantenimiento** | Activo (cientos de contribuidores) | Variable |
| **Accesibilidad** | Contrastes validados WCAG | No siempre |
| **Personalización** | Acentos de color (blue, mauve, green, etc.) | Fijo |

**Color por defecto:** Azul (`rgb(137, 180, 250)` / `#89b4fa`) como color de acento.

## 58.6 Configuración

### 58.6.1 Instalación de temas

```bash
# GTK
pacman -S catppuccin-gtk

# QT (via qt5ct/qt6ct)
pacman -S adwaita-qt5 adwaita-qt6 qt5ct qt6ct

# Iconos
pacman -S papirus-icon-theme

# Cursores
pacman -S bibata-cursor-theme
```

### 58.6.2 Script de cambio de tema (`/usr/bin/lnos-theme`)

```bash
#!/bin/bash
MODE=$1

set_dark() {
    gsettings set org.gnome.desktop.interface gtk-theme "Catppuccin-Mocha-Standard-Blue-Dark"
    sed -i 's/gtk-theme-name=.*/gtk-theme-name=Catppuccin-Mocha-Standard-Blue-Dark/' ~/.config/gtk-3.0/settings.ini
    sed -i 's/gtk-theme-name=.*/gtk-theme-name=Catppuccin-Mocha-Standard-Blue-Dark/' ~/.config/gtk-4.0/settings.ini
    # Cambiar wallpaper
    hyprctl hyprpaper wallpaper "eDP-1,~/.local/share/wallpapers/catppuccin-mocha.png"
    # Notificar
    notify-send "Tema oscuro activado"
}

set_light() {
    gsettings set org.gnome.desktop.interface gtk-theme "Catppuccin-Latte-Standard-Blue-Light"
    sed -i 's/gtk-theme-name=.*/gtk-theme-name=Catppuccin-Latte-Standard-Blue-Light/' ~/.config/gtk-3.0/settings.ini
    sed -i 's/gtk-theme-name=.*/gtk-theme-name=Catppuccin-Latte-Standard-Blue-Light/' ~/.config/gtk-4.0/settings.ini
    hyprctl hyprpaper wallpaper "eDP-1,~/.local/share/wallpapers/catppuccin-latte.png"
    notify-send "Tema claro activado"
}

case $MODE in
    dark) set_dark ;;
    light) set_light ;;
    toggle)
        CURRENT=$(gsettings get org.gnome.desktop.interface gtk-theme)
        if [[ $CURRENT == *"Mocha"* ]]; then
            set_light
        else
            set_dark
        fi
        ;;
    *) echo "Uso: lnos-theme {dark|light|toggle}" ;;
esac
```

## 58.7 Dependencias

- Varios paquetes de tema (GTK, QT, iconos, cursores)
- `hyprpaper` (para cambio de wallpapers)

## 58.8 Pruebas

- `lnos-theme dark` -> todo cambia a oscuro
- `lnos-theme light` -> todo cambia a claro
- `lnos-theme toggle` -> alterna
- Verificar que Kitty, Waybar, Rofi y GTK apps cambian correctamente

---

# 59. Wallpapers

## 59.1 ¿Para qué existe?

El wallpaper es la primera impresión visual del sistema. En LNOS, el wallpaper se integra con el sistema de temas y es gestionado por `hyprpaper`.

## 59.2 Wallpaper por defecto

**Elección:** Gradiente abstracto basado en la paleta Catppuccin Mocha.

- Resolución: 4K (3840x2160) para soportar pantallas de alta densidad.
- Formato: PNG (con pérdida mínima).
- Variantes: Mocha (oscuro) y Latte (claro).

## 59.3 Sistema de gestión

### 59.3.1 hyprpaper

`hyprpaper` es el gestor de wallpapers nativo para wlroots. Es ligero, rápido, y se integra con Hyprland.

**Alternativas descartadas:**

| Gestor | Consumo RAM | Características | Decisión |
|--------|-------------|-----------------|----------|
| **hyprpaper** | ~8 MB | Múltiples monitores, preloading, IPC via `hyprctl` | **Elegido** |
| **swaybg** | ~10 MB | Simple, solo un wallpaper | Descartado (menos features) |
| **feh** | ~15 MB | X11 legacy, no funciona en Wayland puro | Incompatible |
| **mpvpaper** | ~40 MB | Wallpapers animados | Opcional, no predeterminado |

### 59.3.2 Configuración de hyprpaper

`~/.config/hypr/hyprpaper.conf`:

```conf
preload = ~/.local/share/wallpapers/catppuccin-mocha.png
preload = ~/.local/share/wallpapers/catppuccin-latte.png

wallpaper = eDP-1,~/.local/share/wallpapers/catppuccin-mocha.png
wallpaper = DP-1,~/.local/share/wallpapers/catppuccin-mocha.png

ipc = on
```

### 59.3.3 Rotación automática

Script para rotación de wallpapers:

```bash
#!/bin/bash
# ~/.config/hypr/scripts/rotate-wallpaper.sh

WALLPAPER_DIR=~/.local/share/wallpapers/rotation

while true; do
    for wallpaper in "$WALLPAPER_DIR"/*; do
        hyprctl hyprpaper wallpaper "eDP-1,$wallpaper"
        sleep 3600  # Cambia cada hora
    done
done
```

## 59.4 Integración con tema oscuro/claro

El script `lnos-theme` cambia el wallpaper automáticamente:

```bash
set_dark() {
    hyprctl hyprpaper wallpaper "eDP-1,~/.local/share/wallpapers/catppuccin-mocha.png"
}
set_light() {
    hyprctl hyprpaper wallpaper "eDP-1,~/.local/share/wallpapers/catppuccin-latte.png"
}
```

## 59.5 Repositorio de wallpapers oficiales

```text
~/.local/share/wallpapers/
+-- catppuccin-mocha.png        # Predeterminado oscuro
+-- catppuccin-latte.png        # Predeterminado claro
+-- rotation/                   # Carpeta para rotación
|   +-- mountain.png
|   +-- forest.png
|   +-- ocean.png
|   +-- city.png
+-- community/                  # Wallpapers contribuidos
+-- user/                       # Wallpapers del usuario
```

Los wallpapers oficiales se empaquetan como `lnos-wallpapers`.

## 59.6 Dependencias

- `hyprpaper`
- `lnos-wallpapers` (paquete)

## 59.7 Pruebas

- Iniciar Hyprland -> verificar wallpaper por defecto
- `hyprctl hyprpaper wallpaper "eDP-1,/ruta/a/wallpaper.png"` -> cambio manual
- `lnos-theme toggle` -> verificar cambio de wallpaper
- Rotación automática -> `systemctl --user start hyprpaper-rotation.service`

---

# 60. Fuentes

## 60.1 ¿Para qué existe?

Las fuentes del sistema definen la legibilidad y estética de la interfaz. En LNOS se seleccionan cuidadosamente para proporcionar máxima legibilidad en terminal, interfaz y documentos.

## 60.2 Fuentes del sistema

| Tipo | Fuente | Justificación |
|------|--------|---------------|
| **Mono (terminal)** | JetBrains Mono 11pt | Ligaduras de programación, buena legibilidad, hinting óptimo |
| **Mono (alternativa)** | Iosevka 10pt | Más compacta, buena para paneles pequeños |
| **Sans-serif (interfaz)** | Noto Sans 10pt | Cobertura Unicode completa, hinting excelente |
| **Serif (documentos)** | Noto Serif 11pt | Buena legibilidad en texto largo |
| **Emoji** | Noto Color Emoji | Cobertura completa de emojis |

**Alternativas descartadas:**

| Fuente | Razón de descarte |
|--------|-------------------|
| Fira Code | Buenas ligaduras, pero menor cobertura Unicode |
| DejaVu Sans/Serif | Sin variante variable, sin cobertura CJK |
| Liberation Sans/Serif | Equivalentes a Times/Arial, muy genéricas |
| Source Code Pro | Buena para terminal, pero JetBrains Mono es superior en legibilidad |
| Noto Sans CJK | Incluido en `noto-fonts-cjk` para quienes lo necesiten |

**Decisión de ingeniería:** JetBrains Mono + Noto Sans cubren el 99.9% de los casos de uso. Iosevka se ofrece como alternativa compacta.

## 60.3 Configuración fontconfig

`~/.config/fontconfig/fonts.conf`:

```xml
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
<fontconfig>
    <alias>
        <family>sans-serif</family>
        <prefer>
            <family>Noto Sans</family>
            <family>Noto Sans CJK SC</family>
            <family>Noto Color Emoji</family>
        </prefer>
    </alias>

    <alias>
        <family>serif</family>
        <prefer>
            <family>Noto Serif</family>
            <family>Noto Serif CJK SC</family>
        </prefer>
    </alias>

    <alias>
        <family>monospace</family>
        <prefer>
            <family>JetBrains Mono</family>
            <family>Iosevka</family>
        </prefer>
    </alias>

    <match target="pattern">
        <test name="family"><string>sans-serif</string></test>
        <edit name="family" mode="append_last">
            <string>Noto Color Emoji</string>
        </edit>
    </match>

    <match target="font">
        <edit name="hinting" mode="assign"><bool>true</bool></edit>
        <edit name="hintstyle" mode="assign"><const>hintslight</const></edit>
        <edit name="antialias" mode="assign"><bool>true</bool></edit>
        <edit name="rgba" mode="assign"><const>rgb</const></edit>
    </match>
</fontconfig>
```

## 60.4 Configuración de fuentes en terminales

### Kitty

```conf
font_family      JetBrains Mono
bold_font         JetBrains Mono Bold
italic_font       JetBrains Mono Italic
font_size        11.0
font_features     JetBrains Mono +liga
```

### Foot

```ini
font=JetBrains Mono:size=10
```

## 60.5 Configuración de fuentes en GTK

```ini
# ~/.config/gtk-3.0/settings.ini
gtk-font-name=Noto Sans, 10
```

## 60.6 Dependencias

- `noto-fonts` (+ `noto-fonts-cjk`, `noto-fonts-emoji`)
- `jetbrains-mono` (o `ttf-jetbrains-mono-nerd`)
- `iosevka` (opcional)
- `fontconfig`

## 60.7 Pruebas

- `fc-list :lang=es` -> verificar fuentes disponibles
- `fc-match mono` -> debería mostrar JetBrains Mono
- `fc-match sans` -> Noto Sans
- Abrir Kitty -> verificar que JetBrains Mono se muestra correctamente
- `cat /usr/share/fonts/README` -> verificar hinting (debe ser `hintslight`)

---

# 61. Pantalla de Bloqueo

## 61.1 ¿Para qué existe?

La pantalla de bloqueo protege el sistema cuando el usuario se ausenta. En LNOS se usa `hyprlock`, el bloqueador nativo de Hyprland.

## 61.2 hyprlock (nativo Hyprland)

**Alternativas descartadas:**

| Bloqueador | Integración Hyprland | Efecto blur | Fingerprint | Decisión |
|------------|---------------------|-------------|-------------|----------|
| **hyprlock** | Nativa | Sí | Sí (via `fprintd`) | **Elegido** |
| swaylock-effects | Via script | Sí | No | Descartado (no nativo) |
| i3lock-color | X11 legacy | No | No | Incompatible |
| gtklock | GTK | Sí | No | Pesado, dependencias GTK |
| waylock | Ligero | No | No | Demasiado básico |

**Decisión:** hyprlock es la opción nativa con mejor integración.

## 61.3 Configuración de hyprlock

`~/.config/hypr/hyprlock.conf`:

```conf
general {
    hide_cursor = true
    grace = 5
    no_fade_in = false
    fingerprint_present_msg = Escanea tu huella para desbloquear
}

background {
    path = ~/.local/share/wallpapers/catppuccin-mocha.png
    blur_passes = 3
    blur_size = 8
    noise = 0.01
    contrast = 0.9
    brightness = 0.8
    vibrancy = 0.2
    vibrancy_darkness = 0.0
}

input-field {
    monitor = eDP-1
    size = 300, 50
    outline_thickness = 2
    dots_size = 0.2
    dots_spacing = 0.5
    dots_center = true
    outer_color = rgba(89, 180, 250, 1.0)
    inner_color = rgba(30, 30, 46, 0.5)
    font_color = rgba(205, 214, 244, 1.0)
    fade_on_empty = true
    shadow_passes = 2
    shadow_size = 5
    placeholder_text = <i>Contraseña...</i>
    hide_input = false
    position = 0, -200
    halign = center
    valign = center
}

label {
    monitor = eDP-1
    text = $TIME
    color = rgba(205, 214, 244, 1.0)
    font_size = 72
    font_family = JetBrains Mono
    position = 0, -300
    halign = center
    valign = center
}

label {
    monitor = eDP-1
    text = Bienvenido a LNOS
    color = rgba(166, 227, 161, 1.0)
    font_size = 16
    font_family = Noto Sans
    position = 0, -240
    halign = center
    valign = center
}
```

## 61.4 Integración con systemd-suspend

`/etc/systemd/system/hyprlock-suspend.service`:

```ini
[Unit]
Description=Lock screen before suspend
Before=sleep.target

[Service]
Type=oneshot
ExecStart=/usr/bin/hyprlock
Environment=DISPLAY=:0
User=%I

[Install]
WantedBy=sleep.target
```

## 61.5 hypridle para idle management

`~/.config/hypr/hypridle.conf`:

```conf
general {
    lock_cmd = pidof hyprlock || hyprlock
    unlock_cmd = pidof hyprlock && killall hyprlock
    before_sleep_cmd = loginctl lock-session
    after_sleep_cmd = hyprctl dispatch dpms on
}

listener {
    timeout = 300        # 5 minutos
    on-timeout = loginctl lock-session
}

listener {
    timeout = 600        # 10 minutos
    on-timeout = hyprctl dispatch dpms off
}

listener {
    timeout = 900        # 15 minutos
    on-timeout = systemctl suspend
}
```

## 61.6 Modos de desbloqueo

- **Contraseña:** Ingreso manual del password del usuario.
- **Fingerprint:** Si el dispositivo tiene lector de huellas y `fprintd` configurado.
- **Auto-desbloqueo:** Deshabilitado por seguridad.

## 61.7 Dependencias

- `hyprlock`
- `hypridle`
- `fprintd` (opcional, para fingerprint)

## 61.8 Pruebas

- `hyprlock` -> la pantalla debe bloquearse con blur y reloj
- Esperar 5 minutos -> hypridle debe bloquear
- Esperar 10 minutos -> la pantalla debe apagarse
- Esperar 15 minutos -> el sistema debe suspender
- Desbloquear con contraseña -> debe volver a Hyprland

---

# 62. Gestor de Energía

## 62.1 ¿Para qué existe?

El gestor de energía controla el rendimiento del sistema en función del contexto: máximo rendimiento en escritorio, ahorro en portátil, equilibrado en uso normal.

## 62.2 systemd-powerprofilesctl

`powerprofilesctl` es la herramienta de systemd para gestionar perfiles de energía. Es la solución predeterminada en LNOS.

```
+---------------------------------------------------------+
|              power-profiles-daemon                       |
|                                                          |
|  power-saver    balanced    performance                  |
|       |             |            |                       |
|       v             v            v                       |
|  CPU: schedutil   schedutil    performance              |
|  GPU: low freq    auto         max freq                 |
|  Disk: SATA LPM   auto         no LPM                   |
|  WiFi: powersave  auto         throughput               |
+---------------------------------------------------------+
```

| Perfil | Cuándo usarlo | Efecto |
|--------|--------------|--------|
| `power-saver` | Batería, baja carga | Reduce frecuencia CPU, apaga núcleos, bajo consumo |
| `balanced` | Uso normal | Equilibrio rendimiento/consumo |
| `performance` | Juegos, compilación | Frecuencia máxima, sin ahorro |

## 62.3 tlp para portátiles (alternativa)

`tlp` es una herramienta más granular para portátiles:

| Función | powerprofilesctl | tlp |
|---------|-----------------|-----|
| CPU scaling governor | Sí | Sí |
| Disco (SATA LPM) | No | Sí |
| PCIe ASPM | No | Sí |
| WiFi powersave | No | Sí |
| Bluetooth off en batería | No | Sí |
| Batería threshold | No | Sí |
| Carga de batería | No | Sí |

**Decisión de ingeniería:** `powerprofilesctl` es suficiente para el 80% de los casos. `tlp` se ofrece como instalación opcional para usuarios avanzados. **No se instalan ambos para evitar conflictos.**

## 62.4 auto-cpufreq

`auto-cpufreq` es un monitor automático que cambia el governor según la carga:

- Si la carga es baja -> cambia a `powersave`.
- Si la carga sube -> cambia a `performance`.
- No requiere intervención del usuario.

**Estado en LNOS:** No se instala por defecto porque `powerprofilesctl` + el governor `schedutil` del kernel hacen esencialmente lo mismo. `auto-cpufreq` es redundante.

## 62.5 Gestión gráfica de energía

`lnos-power` es una interfaz gráfica para gestionar perfiles:

```
+--------------------------------------+
|  Gestor de Energía LNOS              |
+--------------------------------------+
|                                      |
|  o Power Saver   (ahorro máximo)     |
|  o Balanced      (predeterminado)    |
|  o Performance   (máximo rendim.)    |
|                                      |
|  [x] Cambiar automáticamente         |
|      al desconectar cargador         |
|                                      |
+--------------------------------------+
```

## 62.6 Dependencias

- `power-profiles-daemon`
- `tlp` (opcional, solo portátiles)

## 62.7 Pruebas

- `powerprofilesctl list` -> ver perfiles disponibles
- `powerprofilesctl set performance` -> cambiar a rendimiento
- `powerprofilesctl get` -> ver perfil activo
- Medir `cpupower frequency-info` -> verificar frecuencia según perfil

---

# 63. Laptop Mode

## 63.1 ¿Para qué existe?

Un portátil necesita optimizaciones específicas para maximizar la duración de la batería, gestionar la temperatura y reducir el consumo en reposo.

## 63.2 tlp

`tlp` es el gestor de energía para portátiles más completo en Linux. En LNOS:

- **No se instala por defecto** (para evitar conflicto con `power-profiles-daemon`).
- **Se instala opcionalmente** en portátiles donde se necesita control granular.
- **Alternativa:** `laptop-mode-tools` (obsoleto, no se usa).

### 63.2.1 Configuración de tlp

`/etc/tlp.conf`:

```conf
# CPU
CPU_SCALING_GOVERNOR_ON_AC=performance
CPU_SCALING_GOVERNOR_ON_BAT=powersave
CPU_MIN_PERF_ON_AC=0
CPU_MAX_PERF_ON_AC=100
CPU_MIN_PERF_ON_BAT=0
CPU_MAX_PERF_ON_BAT=50
CPU_ENERGY_PERF_POLICY_ON_AC=performance
CPU_ENERGY_PERF_POLICY_ON_BAT=power

# Discos
DISK_DEVICES="nvme0n1 sda"
DISK_APM_LEVEL_ON_AC="254 254"
DISK_APM_LEVEL_ON_BAT="128 128"
DISK_SPINDOWN_TIMEOUT_ON_AC="0 0"
DISK_SPINDOWN_TIMEOUT_ON_BAT="0 0"
SATA_LINKPWR_ON_AC="max_performance"
SATA_LINKPWR_ON_BAT="min_power"

# PCIe
PCIE_ASPM_ON_AC=performance
PCIE_ASPM_ON_BAT=powersave

# WiFi
WIFI_PWR_ON_AC=off
WIFI_PWR_ON_BAT=on

# Bluetooth
DEVICES_TO_DISABLE_ON_LAN_CONNECT="bluetooth"
DEVICES_TO_DISABLE_ON_WIFI_CONNECT="bluetooth"
DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE="bluetooth"

# Batería
START_CHARGE_THRESH_BAT0=50
STOP_CHARGE_THRESH_BAT0=80
```

## 63.3 Gestión térmica

- `thermald` demonio de Intel para gestión térmica.
- `throttled` para evitar throttling en CPUs Intel (opcional).

## 63.4 Reducción de consumo

| Medida | Ahorro estimado | Fuente |
|--------|----------------|--------|
| CPU governor `powersave` | 1-3W | CPU |
| SATA LPM `min_power` | 0.5-1W | Disco |
| WiFi powersave | 0.3-0.5W | WiFi |
| Brillo al 50% | 1-2W | Pantalla |
| Bluetooth apagado | 0.1-0.3W | Bluetooth |
| PCIe ASPM powersave | 0.5-1W | PCIe |
| Panel Self Refresh (PSR) | 0.3-0.5W | Pantalla |

## 63.5 Modos de rendimiento en batería

El sistema cambia automáticamente:

1. **Cargador conectado:** Rendimiento máximo (performance governor).
2. **Desconectado (>20% batería):** Equilibrado (schedutil).
3. **Batería baja (<20%):** Ahorro máximo (powersave).

## 63.6 Dependencias (opcionales)

- `tlp`
- `thermald`

## 63.7 Pruebas

- `tlp-stat -b` -> estado de batería
- `tlp-stat -c` -> configuración activa
- `tlp-stat -t` -> temperaturas
- Desconectar cargador -> verificar que governor cambia a powersave

---

# 64. Optimización para Portátiles

## 64.1 ¿Para qué existe?

Los portátiles tienen necesidades específicas: brillo ajustable, teclas de función, touchpad preciso, suspensión correcta y gestión de batería. LNOS debe funcionar "out of the box" en portátiles.

## 64.2 Gestión de brillo

### 64.2.1 brightnessctl

Herramienta ligera para controlar el brillo:

```bash
brightnessctl set 50%       # 50% de brillo
brightnessctl set +10%      # Subir 10%
brightnessctl set -10%      # Bajar 10%
brightnessctl -l             # Listar dispositivos
```

### 64.2.2 ddcutil (monitores externos)

Para monitores externos conectados por DP/HDMI que soportan DDC/CI:

```bash
ddcutil setvcp 10 50        # Brillo al 50% en monitor externo
```

**Limitación:** No todos los monitores soportan DDC/CI via USB-C/HDMI. Es una herramienta complementaria.

## 64.3 Teclas de función

Las teclas de función (Fn+F1-F12) se configuran via `hyprland.conf`:

```conf
# Brillo
bind = , XF86MonBrightnessDown, exec, brightnessctl set 5%-
bind = , XF86MonBrightnessUp, exec, brightnessctl set +5%

# Volumen
bind = , XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%
bind = , XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%
bind = , XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle

# Multimedia
bind = , XF86AudioPlay, exec, playerctl play-pause
bind = , XF86AudioNext, exec, playerctl next
bind = , XF86AudioPrev, exec, playerctl previous

# Brillo del teclado
bind = , XF86KbdBrightnessDown, exec, brightnessctl -d *::kbd_backlight set 10%-
bind = , XF86KbdBrightnessUp, exec, brightnessctl -d *::kbd_backlight set +10%
```

## 64.4 Touchpad

Configuración en `hyprland.conf`:

```conf
input {
    touchpad {
        natural_scroll = yes
        tap-to-click = yes
        tap-and-drag = yes
        drag_lock = yes
        disable_while_typing = true
        clickfinger_behavior = yes
        middle_button_emulation = yes
        scroll_factor = 0.5
    }
}
```

### Gestos multitáctiles

Usando `touchpad gestures` de Hyprland:

```conf
# Gestos de 3 dedos
bind = , touchpad:tap:3, exec, rofi -show drun
bind = , touchpad:swipe:3:left, exec, hyprctl dispatch workspace e-1
bind = , touchpad:swipe:3:right, exec, hyprctl dispatch workspace e+1

# Gestos de 4 dedos
bind = , touchpad:swipe:4:up, exec, hyprctl dispatch workspace 1
bind = , touchpad:swipe:4:down, exec, hyprctl dispatch workspace 2
```

## 64.5 Suspensión e hibernación

| Tipo | Descripción | Swap necesario |
|------|-------------|---------------|
| `suspend` (S3) | RAM encendida, CPU apagada | No |
| `hibernate` (S4) | RAM volcada a swap, sistema apagado | Swap >= RAM |
| `suspend-then-hibernate` | S3 durante X tiempo, luego S4 | Swap >= RAM |

### Configuración de hibernación

Kernel parameter:

```
resume=UUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
```

`/etc/mkinitcpio.conf`:

```
HOOKS=(base udev autodetect keyboard modconf block filesystems resume)
```

## 64.6 Gestión de batería

### 64.6.1 tlp

Ver capítulo 63. `tlp` se instala opcionalmente.

### 64.6.2 powertop

Herramienta de diagnóstico:

```bash
powertop          # Modo interactivo
powertop --csv    # Reporte CSV
powertop --auto-tune  # Aplicar optimizaciones (no persistente)
```

### 64.6.3 Carga de batería (threshold)

Para portátiles que pasan mucho tiempo conectados:

`/etc/tlp.conf`:

```conf
START_CHARGE_THRESH_BAT0=50
STOP_CHARGE_THRESH_BAT0=80
```

Esto limita la carga al 80%, alargando la vida útil de la batería (las baterías de Li-ion se degradan más rápido al 100%).

## 64.7 Dependencias

- `brightnessctl`
- `ddcutil` (opcional)
- `tlp` (opcional)
- `powertop` (opcional)

## 64.8 Pruebas

- `brightnessctl set 50%` -> brillo cambia
- Pulsar Fn+F5 -> brillo baja
- Pulsar Fn+F6 -> brillo sube
- Touchpad: tap, scroll, gesture -> respuesta correcta
- `systemctl suspend` -> el sistema suspende y despierta

---

# 65. Optimización para Sobremesas

## 65.1 ¿Para qué existe?

Los escritorios de sobremesa no necesitan ahorro de energía. LNOS debe ofrecer máximo rendimiento para gaming, edición de video, compilación y multitarea pesada.

## 65.2 Alto rendimiento

### 65.2.1 Governor de CPU

```bash
powerprofilesctl set performance
```

O directamente:

```bash
cpupower frequency-set -g performance
```

### 65.2.2 Kernel parameters

```conf
# /etc/sysctl.d/99-performance.conf
kernel.sched_latency_ns = 100000
kernel.sched_min_granularity_ns = 50000
kernel.sched_wakeup_granularity_ns = 30000
vm.swappiness = 10
vm.vfs_cache_pressure = 50
kernel.numa_balancing = 0
```

### 65.2.3 IRQ balance

`irqbalance` redirige interrupciones al núcleo más rápido:

```bash
systemctl enable --now irqbalance
```

## 65.3 Desactivar gobernadores de ahorro

```bash
# Desactivar TLP si está instalado
systemctl stop tlp
systemctl disable tlp

# Desactivar power-profiles-daemon si es necesario
systemctl stop power-profiles-daemon
```

## 65.4 Gestión de ventiladores

### 65.4.1 nbfc (Notebook Fan Control)

Para portátiles donde los ventiladores son controlados por EC:

```bash
pacman -S nbfc
nbfc config set "Modelo"
nbfc start
```

### 65.4.2 fancontrol (lm-sensors)

Para sobremesas con ventiladores PWM:

```bash
pwmconfig           # Configuración interactiva
systemctl enable fancontrol
```

## 65.5 Overclocking (via firmware)

LNOS no realiza overclocking por software. Se recomienda:

1. **Intel:** Intel Extreme Tuning Utility (XTU) no disponible en Linux. Alternativa: `intel-undervolt` para undervolt.
2. **AMD:** `corectrl` permite ajustar frecuencias y voltajes en GPUs AMD.
3. **BIOS/UEFI:** El overclocking debe hacerse desde el firmware.

## 65.6 Múltiples monitores

Configuración en `hyprland.conf`:

```conf
monitor = DP-1, 2560x1440@144, 0x0, 1
monitor = DP-2, 1920x1080@60, 2560x0, 1
monitor = HDMI-A-1, 1920x1080@60, 4480x0, 1

workspace = 1, monitor:DP-1
workspace = 2, monitor:DP-1
workspace = 3, monitor:DP-2
workspace = 4, monitor:HDMI-A-1
```

**Problema conocido:** Monitores con diferentes frecuencias de refresco pueden causar stuttering en Wayland. Solución: usar `hyprctl` para forzar composición a la frecuencia más alta.

## 65.7 Dependencias

- `cpupower`
- `irqbalance`
- `corectrl` (opcional, AMD)
- `nbfc` (opcional)

## 65.8 Pruebas

- `cpupower frequency-info` -> governor debe ser `performance`
- `glxgears` -> FPS sostenido igual al refresh rate del monitor
- `stress --cpu 8` -> CPU debe mantener frecuencia máxima sin throttling
- Conectar segundo monitor -> debe detectarse y configurarse correctamente

---

# 66. Gaming

## 66.1 ¿Para qué existe?

Gaming en Linux ha madurado significativamente. LNOS proporciona un stack gaming optimizado: GameMode, MangoHud, vkBasalt, gamescope, Lutris y Heroic Games Launcher.

## 66.2 Componentes del stack gaming

```
+---------------------------------------------------------+
|                   Gaming Stack                           |
+---------------------------------------------------------+
|                                                          |
|  Juego (Vulkan/OpenGL)                                   |
|       |                                                 |
|       +-- GameMode (Feral) -> CPU governor performance  |
|       +-- MangoHud -> HUD de rendimiento (FPS, temp)    |
|       +-- vkBasalt -> CAS, FSR (post-processing)        |
|       +-- gamescope -> micro-compositor para juegos     |
|                                                          |
|  Lanzadores: Lutris / Heroic Games Launcher             |
|  Capas: Proton / Wine / DXVK / VKD3D                   |
|  Drivers: RADV / ANV / NVIDIA Vulkan                   |
|                                                          |
+---------------------------------------------------------+
```

## 66.3 GameMode (Feral)

GameMode es un demonio que optimiza el sistema cuando un juego se ejecuta:

- Cambia governor CPU a `performance`.
- Aumenta la prioridad del proceso del juego.
- Reduce el timer tick del kernel.
- Desactiva el ahorro de energía de GPU.

```bash
# Instalación
pacman -S gamemode

# Configuración (/etc/gamemode.ini)
[general]
desiredgov=performance
softrealtime=auto
renice=10
ioprio=1

[gpu]
apply_gpu_optimisations=accept-responsibility
gpu_device=0
amd_performance_level=high
nv_powermizer_mode=1
```

**Integración con juegos:**

```bash
# Lanzar juego con GameMode
gamemoderun ./juego

# Steam (parámetro de lanzamiento)
gamemoderun %command%
```

## 66.4 MangoHud

MangoHud es un HUD de rendimiento que muestra FPS, temperatura, uso de CPU/GPU, VRAM, etc.

```bash
# Instalación
pacman -S mangohud

# Configuración global (~/.config/MangoHud/MangoHud.conf)
fps_limit=0
fps_only=0
cpu_stats=1
gpu_stats=1
vram=1
ram=1
engine_version=1
resolution=1
time=1
output_folder=~/mangohud-logs

# Lanzar con MangoHud
mangohud ./juego

# Steam (parámetro de lanzamiento)
mangohud %command%
```

## 66.5 vkBasalt (CAS, FSR)

vkBasalt es una capa de post-processing para Vulkan que permite aplicar:

- **CAS** (Contrast Adaptive Sharpening): Nitidez adaptativa.
- **FSR** (FidelityFX Super Resolution): Reescalado espacial.

```bash
# Instalación
pacman -S vkbasalt

# Configuración (~/.config/vkbasalt/vkbasalt.conf)
effects=CAS
casSharpness=0.5
# O FSR
# effects=FSR
# fsrSharpness=0.5
# fsrStrength=0.5
```

## 66.6 gamescope

gamescope es un micro-compositor Wayland que aísla el juego en su propia sesión:

- FPS limit independiente del compositor.
- Escalado (FSR, NIS, integer scaling).
- HDR (próximamente).
- Sin tearing.

```bash
# Instalación
pacman -S gamescope

# Uso
gamescope -W 1920 -H 1080 -r 60 -- ./juego

# Steam (parámetro de lanzamiento)
gamescope -W 1920 -H 1080 -r 144 -- %command%
```

**Decisión de ingeniería:** gamescope es opcional. Se recomienda para juegos que no se comportan bien con el compositor (tearing, stuttering).

## 66.7 Lutris

Lutris es un gestor de juegos que unifica:

- Juegos nativos de Linux.
- Wine/Proton.
- Emuladores (RetroArch, Dolphin, PCSX2, etc.).
- Plataformas (Steam, GOG, Epic, etc.).

```bash
pacman -S lutris
```

## 66.8 heroic-games-launcher

Heroic es un lanzador para Epic Games Store y GOG:

```bash
pacman -S heroic-games-launcher
```

**Ventajas sobre Lutris para Epic/GOG:**

- Interfaz más moderna.
- Integración directa con Epic API.
- Gestión de Wine/Proton integrada.

## 66.9 Optimizaciones de kernel

| Kernel | Uso | Característica |
|--------|-----|---------------|
| `linux` (Arch) | Defecto | Estable, actualizado |
| `linux-zen` | Gaming | Scheduler MuQSS, latencia reducida |
| `linux-ck` | Gaming extremo | Parches CK, BFS scheduler |
| `linux-tkg` | Custom | Parches personalizables |

**Decisión:** `linux` es el kernel por defecto. `linux-zen` se ofrece como alternativa para gaming. No se recomienda `linux-ck` por falta de mantenimiento.

## 66.10 Dependencias

- `gamemode`
- `mangohud`
- `vkbasalt`
- `gamescope` (opcional)
- `lutris` (opcional)
- `heroic-games-launcher` (opcional)
- `linux-zen` (opcional)

## 66.11 Pruebas

- `gamemoderun glxgears` -> governor cambia a performance
- `mangohud glxgears` -> HUD se muestra
- `vkbasalt glxgears` -> CAS aplicado (verificar nitidez)
- `gamescope -- glxgears` -> juego en micro-compositor
- Lutris -> iniciar juego de GOG
- Heroic -> iniciar juego de Epic

---

# 67. Steam

## 67.1 ¿Para qué existe?

Steam es la plataforma de juegos más grande en PC. LNOS debe tener Steam configurado correctamente: runtime, Wayland, Steam Input y Remote Play.

## 67.2 Steam (runtime nativo vs flatpak)

| Aspecto | Nativo (pacman) | Flatpak |
|---------|----------------|---------|
| **Rendimiento** | Nativo, sin overhead | Mínimo overhead |
| **Integración** | Acceso completo al sistema | Sandbox, permisos limitados |
| **Actualizaciones** | Via pacman | Via flatpak |
| **Runtime** | Steam runtime propia | Runtime Flatpak |
| **Mangohud/GameMode** | Plug and play | Requiere overrides |
| **Proton** | Nativo | Nativo |

**Decisión de ingeniería:** Steam nativo (desde `multilib/steam`) es el predeterminado. Flatpak se ofrece como alternativa para usuarios que prefieren sandboxing.

## 67.3 Steam Client

```bash
# Instalación
pacman -S steam

# Configuración de lanzamiento en Hyprland
# ~/.config/hypr/hyprland.conf
windowrule = nomaxsize, class:^(steam)$
windowrule = dimaround, class:^(Steam)$
```

**Variables de entorno para Steam:**

```bash
# ~/.config/environment.d/steam.conf
STEAM_FORCE_DRI_PRIME=1  # Para NVIDIA Optimus
STEAM_USE_WAYLAND=0      # Steam no soporta Wayland nativamente
```

## 67.4 Compatibilidad Wayland

Steam no soporta Wayland nativamente. Se ejecuta bajo XWayland:

```bash
# Forzar Steam en XWayland (necesario para captura de pantalla)
STEAM_FORCE_DRI_PRIME=1 steam
```

**Problema:** Las capturas de pantalla de Steam no funcionan en XWayland. Solución: usar `grimblast` para capturar.

## 67.5 Steam Input

Steam Input es el mapeador de mandos de Steam:

- **Xbox/PlayStation/Nintendo Switch:** Plug and play.
- **Controladores genéricos:** Mapeo manual.
- **Gyro:** Mapeo a ratón o joystick.

Configuración: Steam -> Settings -> Controller -> Desktop Configuration.

## 67.6 Remote Play

- **Remote Play Together:** Jugar local multijugador online.
- **Remote Play:** Transmitir juegos desde otro PC.
- **Steam Link:** Transmitir a móvil o TV.

**Requisitos:** Puerto 27036 abierto, latencia baja, NAT tipo abierto.

## 67.7 Dependencias

- `steam` (multilib)
- `steam-native` (runtime nativa)
- `wine` (para juegos no Steam)
- `proton-ge-custom` (AUR)

## 67.8 Pruebas

- `steam` -> cliente inicia
- Steam -> Settings -> Interface -> marcar "Use native Steam runtime"
- Iniciar juego nativo de Linux -> debe funcionar
- Iniciar juego Proton -> debe funcionar (ver capítulo 68)
- Steam Remote Play -> conectar desde otro dispositivo

---

# 68. Proton

## 68.1 ¿Para qué existe?

Proton es una capa de compatibilidad de Valve que permite ejecutar juegos de Windows en Linux usando Wine + DXVK / VKD3D. LNOS incluye Proton GE (GloriousEggroll) como mejora sobre el Proton oficial de Steam.

## 68.2 Arquitectura de Proton

```
+-------------------------------------------------------------+
|             Proton Layer                                     |
+-------------------------------------------------------------+
|                                                              |
|  Juego Windows (.exe)                                        |
|       |                                                     |
|       v                                                     |
|  +-----------+  +-----------+                               |
|  |  DXVK     |  | VKD3D-    |                               |
|  |  (DX9/10/ |  | Proton    |                               |
|  |   11)     |  | (DX12)    |                               |
|  +-----+-----+  +-----+-----+                               |
|        |              |                                     |
|        v              v                                     |
|  +---------------------------+                               |
|  |      Vulkan               |                               |
|  +-----------+---------------+                               |
|              |                                              |
|              v                                              |
|  +---------------------------+                               |
|  |  Wine (Windows API)       |                               |
|  |  + DXVK-native            |                               |
|  +---------------------------+                               |
|                                                              |
+-------------------------------------------------------------+
```

## 68.3 Proton GE (GloriousEggroll)

Proton GE es un fork de Proton con parches adicionales:

- **Media Foundation:** Soporte para codecs de video en cinemáticas.
- **VKD3D extra:** Parches para DirectX 12 no oficiales.
- **MangoHud integrado:** HUD preconfigurado.
- **GameMode:** Integración automática.
- **Parches de compatibilidad:** Para juegos específicos (Destiny 2, etc.).

```bash
# Instalación (AUR)
yay -S proton-ge-custom

# Los binarios se instalan en:
# ~/.local/share/Steam/compatibilitytools.d/
```

## 68.4 Proton Experimental

Es la rama de desarrollo de Proton. Se actualiza semanalmente:

- Steam -> Properties -> Compatibility -> Force the use of a specific Steam Play compatibility tool -> Proton Experimental.

**Cuándo usarlo:** Para juegos nuevos que necesitan parches recientes.

## 68.5 wine-ge

Wine GE es una versión de Wine con parches de GloriousEggroll:

```bash
yay -S wine-ge-custom
```

**Diferencia con Proton GE:** Wine GE no incluye DXVK/VKD3D; es solo Wine mejorado.

## 68.6 Configuración de capas de compatibilidad

### 68.6.1 DXVK

DXVK traduce DirectX 9/10/11 a Vulkan:

```bash
# Instalación global
pacman -S dxvk

# Configuración
# ~/.config/dxvk.conf
dxvk.numBackBuffers = 2
dxvk.enableAsync = false
dxvk.useRawSsbo = true
```

### 68.6.2 VKD3D-Proton

VKD3D-Proton traduce DirectX 12 a Vulkan:

```bash
# Se incluye con Proton
# No se instala por separado

# Configuración
# ~/.config/vkd3d-proton.conf
vkd3d_proton_dump = false
vkd3d_proton_relay_ray_tracing = true
```

### 68.6.3 D9VK

D9VK (ahora parte de DXVK) traduce DirectX 9 a Vulkan:

```bash
# Ya incluido en DXVK moderno
# No requiere instalación separada
```

## 68.7 Variables de entorno para Proton

```bash
# ~/.config/environment.d/proton.conf
PROTON_ENABLE_NVAPI=1          # Habilita NVAPI (NVIDIA specific)
PROTON_ENABLE_NGX_UPDATER=1    # Habilita DLSS en juegos compatibles
PROTON_HIDE_NVIDIA_GPU=0       # Muestra GPU NVIDIA a juegos
PROTON_USE_WINED3D=0           # No usar wined3d (usar DXVK)
DXVK_HUD=0                     # Deshabilitar HUD de DXVK por defecto
DXVK_LOG_LEVEL=none            # Silenciar logs de DXVK
VKD3D_DEBUG=none               # Silenciar logs de VKD3D
```

## 68.8 Pruebas

- Ir a `protondb.com` -> buscar juego compatible
- Lanzar juego en Steam con Proton GE
- Verificar FPS en MangoHud
- Verificar que DXVK/VKD3D se cargan (log en `~/.local/share/Steam/logs/`)

---

# 69. Wine

## 69.1 ¿Para qué existe?

Wine (Wine Is Not an Emulator) permite ejecutar aplicaciones de Windows en Linux. En LNOS se usa principalmente para juegos que no están en Steam, ejecutables de Windows antiguos, y aplicaciones empresariales.

## 69.2 Wine + wine-ge

| Versión | Descripción | Cuándo usarla |
|---------|-------------|---------------|
| `wine` (estable) | Wine oficial | Apps de Windows estables |
| `wine-staging` | Wine con parches experimentales | Juegos modernos |
| `wine-ge-custom` | GloriousEggroll, optimizado para juegos | Gaming en general |
| `wine-wayland` | Wine con backend Wayland nativo | Wayland sin XWayland |

**Decisión de ingeniería:** `wine-ge-custom` (AUR) es la versión predeterminada para gaming. `wine-staging` para aplicaciones no gaming. `wine-wayland` es experimental y no se recomienda aún.

## 69.3 Winetricks

Winetricks es un script que facilita la instalación de componentes de Windows (VC++ runtimes, DirectX, .NET, etc.) en prefijos de Wine.

```bash
# Instalación
pacman -S winetricks

# Uso básico
winetricks corefonts vcrun2022 dxvk
```

## 69.4 Configuración de prefijos

Cada aplicación de Windows debe tener su propio prefijo (entorno aislado):

```bash
# Crear prefijo
WINEPREFIX=~/.wine-apps/miapp winecfg

# Configurar versión de Windows
WINEPREFIX=~/.wine-apps/miapp winetricks win10

# Instalar componentes
WINEPREFIX=~/.wine-apps/miapp winetricks corefonts

# Ejecutar aplicación
WINEPREFIX=~/.wine-apps/miapp wine miapp.exe
```

## 69.5 Wayland vs X11 backend

| Backend | Estado | Uso |
|---------|--------|-----|
| X11 (predeterminado) | Estable | Compatibilidad total |
| Wayland (experimental) | En desarrollo | Sin XWayland, mejor integración |

**Decisión:** Por defecto, Wine usa X11 (XWayland). El backend Wayland nativo (`wine-wayland`) es experimental y no está habilitado.

Para habilitar Wayland experimental:

```bash
export DISPLAY=
export WAYLAND_DISPLAY=wayland-1
export WINEDLLOVERRIDES=winemac.drv=d
```

## 69.6 Integración con Lutris/Heroic

Tanto Lutris como Heroic gestionan prefijos automáticamente:

- **Lutris:** Cada juego tiene su propio prefijo en `~/Games/`.
- **Heroic:** Cada juego tiene su prefijo en `~/Games/Heroic/`.

Ambos permiten seleccionar la versión de Wine (wine-ge, wine-staging, proton).

## 69.7 Dependencias

- `wine` (o `wine-ge-custom`)
- `winetricks`
- `wine-mono` (para .NET)
- `wine-gecko` (para HTML rendering)

## 69.8 Pruebas

- `wine --version` -> verificar versión
- `winecfg` -> abrir configuración
- `winetricks --gui` -> abrir gestor de componentes
- Ejecutar `wine notepad` -> debe abrir el bloc de notas de Windows
- Ejecutar juego en Lutris con wine-ge -> debe funcionar

---

# 70. Vulkan

## 70.1 ¿Para qué existe?

Vulkan es la API gráfica moderna de baja latencia y alto rendimiento. En LNOS, Vulkan es la API de renderizado predeterminada para juegos y aplicaciones 3D.

## 70.2 Pila de Vulkan

```
+--------------------------------------------------+
|                 Vulkan Stack                      |
+--------------------------------------------------+
|                                                   |
|  Aplicación (juego, motor 3D)                     |
|       |                                           |
|       v                                           |
|  +------------------+                             |
|  | Vulkan Loader    |  (vulkan-icd-loader)        |
|  +--------+---------+                             |
|           |                                       |
|           v                                       |
|  +------------------+                             |
|  | Validation Layers| (vulkan-validation-layers)  |
|  +--------+---------+                             |
|           |                                       |
|           v                                       |
|  +------------------+  +------------------+       |
|  | RADV (AMD)       |  | ANV (Intel)      |       |
|  | Mesa Vulkan      |  | Mesa Vulkan      |       |
|  +------------------+  +------------------+       |
|                                                   |
|  +------------------+                             |
|  | nvidia-utils     | (NVIDIA Vulkan)             |
|  | (proprietary)    |                             |
|  +------------------+                             |
|                                                   |
+--------------------------------------------------+
```

## 70.3 Vulkan Loader y Layers

| Componente | Propósito | Paquete |
|------------|-----------|---------|
| `libvulkan.so` | Carga la ICD correcta según GPU | `vulkan-icd-loader` |
| Validation layers | Debugging de llamadas Vulkan | `vulkan-validation-layers` |
| Vulkan tools | `vulkaninfo`, `vkcube` | `vulkan-tools` |
| Vulkan headers | Desarrollo | `vulkan-headers` |

## 70.4 Vulkan Drivers

| Driver | GPU | Mantenimiento | Rendimiento |
|--------|-----|---------------|-------------|
| **RADV** | AMD GCN/RDNA | Mesa (activo) | Excelente |
| **ANV** | Intel Gen7+ | Mesa (activo) | Excelente |
| **nvidia-utils** | NVIDIA | NVIDIA (cerrado) | Excelente (con DLSS, RT) |
| **amdgpu-pro** | AMD | AMD (cerrado) | Bueno (menor que RADV) |
| **lvp** | CPU (llvmpipe) | Mesa | Muy lento (software) |

**Decisión:** Se instalan RADV, ANV y nvidia-utils. El loader selecciona automáticamente el driver correcto.

## 70.5 VK_KHR_display (presentación Wayland)

En Wayland, la presentación de frames se hace via `VK_KHR_wayland_surface` o `VK_KHR_display` (KMS directo). Hyprland usa `VK_KHR_wayland_surface` a través de wlroots.

## 70.6 Vulkan configurado por defecto

En LNOS, Vulkan está configurado para que funcione out-of-the-box:

```bash
# Verificar drivers disponibles
vulkaninfo --summary

# Verificar ICDs instalados
ls /usr/share/vulkan/icd.d/
# Debe mostrar: radv.json, intel_icd.x86_64.json, nvidia_icd.json
```

## 70.7 DXVK y VKD3D

- **DXVK:** DirectX 9/10/11 -> Vulkan
- **VKD3D-Proton:** DirectX 12 -> Vulkan

Ambos son capas de traducción que se cargan automáticamente con Proton.

## 70.8 Dependencias

- `vulkan-icd-loader`
- `vulkan-validation-layers`
- `vulkan-tools`
- `mesa` (incluye RADV, ANV)
- `nvidia-utils` (opcional)

## 70.9 Pruebas

- `vulkaninfo --summary` -> ver drivers ICD cargados
- `vkcube` -> renderizar cubo Vulkan
- `vkcube-wayland` -> renderizar cubo en Wayland
- `VK_LOADER_DEBUG=all vulkaninfo` -> debug del loader

---

# 71. OpenGL

## 71.1 ¿Para qué existe?

OpenGL sigue siendo necesario para aplicaciones GTK, algunos juegos antiguos, y herramientas de diseño (Blender, GIMP). LNOS proporciona OpenGL 4.6 completo via Mesa.

## 71.2 Mesa + drivers OpenGL

```
+--------------------------------------------------+
|                 OpenGL Stack                      |
+--------------------------------------------------+
|                                                   |
|  Aplicación (glxgears, Blender, GTK)              |
|       |                                           |
|       v                                           |
|  +------------------+                             |
|  | libGL (Mesa)     |  (OpenGL core/compat)       |
|  +--------+---------+                             |
|           |                                       |
|           v                                       |
|  +------------------+                             |
|  | Gallium (Mesa)   |  (drivers: iris,            |
|  |                  |   radeonsi, zink, etc.)     |
|  +------------------+                             |
|                                                   |
+--------------------------------------------------+
```

## 71.3 OpenGL Core vs Compatibilidad

| Perfil | Uso |
|--------|-----|
| **Core** (3.2+) | Aplicaciones modernas, juegos, GTK4 |
| **Compatibilidad** (1.0-2.1 legacy) | Aplicaciones antiguas, OpenGL 1.x |

Mesa carga el perfil Core por defecto. La compatibilidad está disponible pero no se usa activamente.

## 71.4 Renderizado directo a KMS

En Wayland, OpenGL no habla con X11. Las aplicaciones OpenGL usan:

- **EGL** (Embedded GL) para renderizar a buffers Wayland.
- **GLX** solo funciona con X11 (XWayland).

**Flujo en Wayland:**

```
App OpenGL -> EGL -> wl_egl_window -> wlroots compositor -> KMS/DRM
```

## 71.5 OpenGL ES (EGL)

OpenGL ES 3.2 está disponible via Mesa para aplicaciones embebidas y móviles. No es el foco principal de LNOS.

## 71.6 Dependencias

- `mesa` (incluye `libGL`, `libEGL`)
- `mesa-utils` (para `glxinfo`, `glxgears`)

## 71.7 Pruebas

- `glxinfo -B` -> ver driver OpenGL activo
- `glxgears` -> FPS sostenido (no benchmark real, pero indica funcionamiento)
- `eglinfo` -> ver configuración EGL
- `es2gears_wayland` -> OpenGL ES en Wayland

---

# 72. Mesa

## 72.1 ¿Para qué existe?

Mesa 3D es la implementación open source de OpenGL, Vulkan, VA-API y VDPAU. Es el componente central de la pila gráfica en LNOS.

## 72.2 Arquitectura de Mesa

```
+--------------------------------------------------+
|                   Mesa 3D                         |
+--------------------------------------------------+
|                                                   |
|  Frontends: OpenGL, Vulkan, VA-API, VDPAU        |
|       |                                           |
|       v                                           |
|  +----------------------+                         |
|  |   Gallium3D (state   |  (drivers modernos)     |
|  |   tracker)           |                         |
|  +----------------------+                         |
|       |                                           |
|       v                                           |
|  +----------------------+  +------------------+   |
|  | Hardware drivers     |  | Software drivers  |   |
|  |  - radeonsi (AMD)    |  |  - llvmpipe       |   |
|  |  - iris (Intel Gen8+)|  |  - softpipe       |   |
|  |  - crocus (Intel G7) |  |  - zink (Vulkan)  |   |
|  |  - zink (Vulkan)     |  |                   |   |
|  |  - etnaviv (ARM)     |  |                   |   |
|  +----------------------+  +------------------+   |
|                                                   |
+--------------------------------------------------+
```

## 72.3 Drivers en LNOS

| Driver | API | Hardware | Estado |
|--------|-----|----------|--------|
| **RadeonSI** | OpenGL 4.6 | AMD GCN/RDNA | Activo |
| **RADV** | Vulkan 1.3 | AMD GCN/RDNA | Activo |
| **Iris** | OpenGL 4.6 | Intel Gen8+ | Activo |
| **Crocus** | OpenGL 4.6 | Intel Gen7 | Mantenimiento |
| **ANV** | Vulkan 1.3 | Intel Gen7+ | Activo |
| **Zink** | OpenGL 4.6 via Vulkan | Cualquier Vulkan | Emergente |
| **softpipe** | OpenGL 3.3 (software) | CPU | Fallback |
| **llvmpipe** | OpenGL 4.6 (software) | CPU (JIT) | Fallback |

## 72.4 Mesa VA-API

Mesa incluye `libva-mesa-driver` para decodificación de video:

```bash
# Verificar soporte VA-API
vainfo

# Driver: radeonsi (AMD) / iHD (Intel via intel-media-driver)
# No para NVIDIA (usar nvidia-vaapi-driver)
```

## 72.5 Mesa Vulkan

Los drivers Vulkan de Mesa (RADV, ANV) se empaquetan dentro de `mesa`:

```bash
# Verificar ICD de Mesa
ls /usr/share/vulkan/icd.d/
# radv.json, intel_icd.x86_64.json
```

## 72.6 Actualizaciones periódicas desde Arch

Mesa se actualiza frecuentemente (cada 2-4 semanas):

- `mesa` en `extra` de Arch.
- `lnos-stable` sigue a `extra` con un desfase máximo de 1 semana.
- Las actualizaciones de Mesa no requieren reinicio (solo reiniciar apps).

## 72.7 Dependencias

- `mesa` (incluye todo: libGL, libEGL, gallium, vulkan, vaapi)
- `mesa-utils` (herramientas de diagnóstico)
- `libva-mesa-driver` (para VA-API en AMD)

## 72.8 Pruebas

- `glxinfo -B` -> ver driver y versión de Mesa
- `vulkaninfo --summary` -> ver drivers Vulkan de Mesa
- `vainfo` -> ver perfiles VA-API
- `MESA_LOADER_DRIVER_OVERRIDE=softpipe glxgears` -> probar driver software

## 72.9 Mantenimiento

- `pacman -Syu` actualiza Mesa regularmente.
- No hay configuración específica; los drivers se auto-seleccionan.
- Para depuración: `MESA_DEBUG=1`, `RADV_DEBUG=info`, `ANV_DEBUG=1`.

---

# 73. Flatpak

## 73.1 ¿Para qué existe?

Flatpak es un sistema de paquetes sandboxed que proporciona aislamiento de aplicaciones. En LNOS se usa para aplicaciones que no están en los repositorios de Arch, o que se benefician del sandboxing (navegadores, Slack, Discord, etc.).

## 73.2 Flatpak como sistema de paquetes sandboxed

```
+--------------------------------------------------+
|              Flatpak Architecture                 |
+--------------------------------------------------+
|                                                   |
|  +------------------------------------------+     |
|  |          Application (sandbox)            |     |
|  |  +--------+  +--------+  +--------+      |     |
|  |  | Binary  |  | Libs   |  | Runtime|      |     |
|  |  +--------+  +--------+  +--------+      |     |
|  +------------------------------------------+     |
|                                                   |
|  +------------------------------------------+     |
|  |     bubblewrap (namespace isolation)      |     |
|  +------------------------------------------+     |
|                                                   |
|  +------------------------------------------+     |
|  |          Host system (drivers, kernel)    |     |
|  +------------------------------------------+     |
|                                                   |
+--------------------------------------------------+
```

## 73.3 Flathub configurado por defecto

Flathub es el repositorio oficial de Flatpak. En LNOS se añade automáticamente:

```bash
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

## 73.4 Flatpak override para permisos

Los permisos de Flatpak se gestionan con `flatpak override`:

```bash
# Ejemplo: dar acceso a red a una aplicación
flatpak override --user --socket=network org.mozilla.firefox

# Ejemplo: dar acceso a directorios
flatpak override --user --filesystem=~/Documentos org.gimp.GIMP

# Ver permisos
flatpak info --show-permissions org.mozilla.firefox

# Resetear permisos
flatpak override --user --reset org.mozilla.firefox
```

## 73.5 flatpak-builder

`flatpak-builder` permite construir aplicaciones Flatpak:

```bash
pacman -S flatpak-builder
flatpak-builder build-dir org.app.Manifest.json --force-clean
flatpak-builder --user --install build-dir org.app.Manifest.json
```

## 73.6 Integración con centro de software

El centro de software de LNOS (`lnos-software`) muestra aplicaciones Flatpak y las instala con un solo clic.

## 73.7 Dependencias

- `flatpak`
- `flatpak-builder` (opcional)

## 73.8 Pruebas

- `flatpak list` -> ver aplicaciones instaladas
- `flatpak remote-list` -> ver repositorios (debe incluir flathub)
- `flatpak search gimp` -> buscar aplicación
- `flatpak install flathub org.gimp.GIMP` -> instalar GIMP

---

# 74. Repositorios

## 74.1 ¿Para qué existe?

Los repositorios son la fuente de paquetes de LNOS. La configuración de repositorios determina la disponibilidad, velocidad y seguridad de las instalaciones.

## 74.2 Repositorios Arch

| Repositorio | Contenido | Prioridad |
|-------------|-----------|-----------|
| **core** | Paquetes base del sistema | 1 (máxima) |
| **extra** | Paquetes adicionales mantenidos | 2 |
| **multilib** | Bibliotecas de 32 bits (Steam, Wine) | 3 |

Configuración en `/etc/pacman.conf`:

```conf
[core]
Include = /etc/pacman.d/mirrorlist

[extra]
Include = /etc/pacman.d/mirrorlist

[multilib]
Include = /etc/pacman.d/mirrorlist
```

## 74.3 Repositorio LNOS (lnos-stable)

`lnos-stable` contiene paquetes específicos de LNOS:

- `hyprland` (configuraciones predeterminadas)
- `lnos-software` (centro de software)
- `lnos-updater` (gestor de actualizaciones)
- `lnos-wallpapers` (wallpapers oficiales)
- `lnos-themes` (temas visuales)
- `catppuccin-gtk`, `bibata-cursor-theme`, etc.

```
[lnos-stable]
Server = https://packages.lnos.dev/stable/$arch
SigLevel = Required
```

**Firma:** Los paquetes están firmados con GPG. La clave pública se incluye en `lnos-keyring`.

## 74.4 Mirrorlist optimizado

El mirrorlist de Arch se optimiza automáticamente:

```bash
# Durante la instalación
pacman-mirrors --fasttrack 10

# Manualmente
reflector --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
```

**Reflector** se ejecuta semanalmente via systemd timer para mantener los mirrors actualizados.

## 74.5 Priorización de mirrors por velocidad

`/etc/xdg/reflector/reflector.conf`:

```conf
--latest 10
--protocol https
--sort rate
--save /etc/pacman.d/mirrorlist
```

## 74.6 Dependencias

- `pacman`
- `reflector` (para optimización de mirrors)

## 74.7 Pruebas

- `pacman -Syu` -> verificar que los repositorios responden
- `reflector --latest 5 --protocol https --sort rate` -> probar velocidad
- `pacman -Si lnos-wallpapers` -> ver info de paquete LNOS

---

# 75. AUR

## 75.1 ¿Para qué existe?

AUR (Arch User Repository) es un repositorio comunitario de Arch Linux donde los usuarios publican PKGBUILDs. LNOS soporta AUR pero con precauciones de seguridad.

## 75.2 Soporte AUR

En LNOS, el acceso a AUR se hace mediante `yay` (AYoUr AUR helper), por defecto.

**Alternativas descartadas:**

| Helper | Lenguaje | Características | Decisión |
|--------|----------|-----------------|----------|
| **yay** | Go | Sencillo, rápido, integración con pacman | **Elegido** |
| **paru** | Rust | Más moderno, sandboxing nativo | Descartado (menos adoptado) |
| **pacman** nativo | C | No soporta AUR | No aplica |
| **trizen** | Perl | Lento, sin mantenimiento | Descartado |
| **aura** | Haskell | Complejo, dependencias pesadas | Descartado |

**Decisión:** yay porque es el helper más extendido, tiene buen rendimiento y es fácil de mantener.

## 75.3 yay vs paru vs pacman nativo

| Aspecto | pacman | yay | paru |
|---------|--------|-----|------|
| Repos oficiales | Sí | Sí | Sí |
| AUR | No | Sí | Sí |
| Búsqueda AUR | No | Sí | Sí |
| Actualización combinada | No | Sí | Sí |
| Sandbox en compilación | N/A | No | Sí (opcional) |
| Velocidad | Rápido | Rápido | Rápido |
| Dependencias extra | Ninguna | `go` (binario) | `rust` (binario) |

## 75.4 Construcción en contenedor (sandbox)

Para seguridad, los paquetes AUR se construyen en entornos aislados:

```bash
# Con paru (sandbox nativo)
paru -S --sandbox paquete-aur

# Con yay + contenedor manual
podman run --rm -v $PWD:/build archlinux:latest bash -c "cd /build && makepkg -si"
```

**En LNOS:** Se recomienda usar `paru` si el usuario valora la seguridad máxima. `yay` es el predeterminado por simplicidad.

## 75.5 AUR helpers configurados por defecto

```bash
# Configuración de yay (/etc/yay.conf)
[yay]
# Usar diffs de PKGBUILD
diffmenu=true
# Mostrar información antes de compilar
develmenu=true
# No preguntar antes de compilar
cleanmenu=true
# Usar git clone
usesysusers=true
```

## 75.6 Dependencias

- `yay` (AUR helper predeterminado)
- `base-devel` (necesario para compilar paquetes AUR)
- `git` (para clonar PKGBUILDs)

## 75.7 Pruebas

- `yay -Syu` -> actualizar sistema + AUR
- `yay -Ss google-chrome` -> buscar en AUR
- `yay -S google-chrome` -> instalar desde AUR
- `yay -R google-chrome` -> eliminar paquete

---

# 76. Gestor Gráfico de Paquetes

## 76.1 ¿Para qué existe?

`lnos-software` es el centro de software gráfico de LNOS. Proporciona una interfaz unificada para instalar, actualizar y eliminar paquetes de pacman, flatpak y AUR.

## 76.2 Centro de Software (lnos-software)

```
+--------------------------------------------------+
|              lnos-software                         |
+--------------------------------------------------+
|                                                   |
|  [Buscar aplicaciones...]                         |
|                                                   |
|  +--------+  +--------+  +--------+              |
|  | Naveg. |  | Juegos |  | Office |  ...         |
|  +--------+  +--------+  +--------+              |
|                                                   |
|  +------------------------------------------+     |
|  | Resultados:                               |     |
|  |  Firefox    ★★★★★  pacman  [Instalar]    |     |
|  |  Chromium   ★★★★☆  flatpak [Instalar]    |     |
|  |  Google     ★★★★☆  AUR     [Instalar]    |     |
|  |   Chrome    ★★★★☆          [Instalar]    |     |
|  +------------------------------------------+     |
|                                                   |
+--------------------------------------------------+
```

## 76.3 Funcionalidades

| Función | Descripción |
|---------|-------------|
| **Instalar** | Instala paquetes desde pacman, flatpak o AUR |
| **Actualizar** | Actualiza todos los paquetes del sistema |
| **Eliminar** | Desinstala paquetes seleccionados |
| **Buscar** | Busca en pacman + flatpak + AUR simultáneamente |
| **Vista por módulos** | Categorías: gaming, desarrollo, oficina, multimedia |
| **Snapshots** | Crea snapshot Btrfs antes de cambios importantes |

## 76.4 Soporte para pacman, flatpak, AUR

```python
# Backend conceptual
class PackageManager:
    def search(self, query):
        results = []
        results += pacman.search(query)
        results += flatpak.search(query)
        results += aur.search(query)
        return sorted(results, key=lambda x: x.score, reverse=True)

    def install(self, package):
        if package.source == "pacman":
            pacman.install(package.name)
        elif package.source == "flatpak":
            flatpak.install(package.remote, package.name)
        elif package.source == "aur":
            aur.install(package.name)
```

## 76.5 Vista por módulos

```
+--------------------------------------------------+
|  lnos-software                                    |
+--------------------------------------------------+
|                                                   |
|  Navegación y herramientas                        |
|    [Firefox] [Chromium] [Brave] [qBittorrent]    |
|                                                   |
|  Gaming                                           |
|    [Steam] [Lutris] [Heroic] [MangoHud]          |
|                                                   |
|  Desarrollo                                       |
|    [VS Code] [JetBrains] [Docker] [Git]          |
|                                                   |
|  Multimedia                                       |
|    [VLC] [GIMP] [Inkscape] [Kdenlive]            |
|                                                   |
+--------------------------------------------------+
```

## 76.6 Dependencias

- `python-gobject` (interfaz GTK)
- `pacman` (backend)
- `flatpak` (backend)
- `yay` (backend AUR)
- `polkit` (privilegios)

## 76.7 Pruebas

- Abrir `lnos-software`
- Buscar "firefox" -> debe aparecer en resultados
- Instalar paquete desde pacman -> debe funcionar
- Instalar paquete desde flatpak -> debe funcionar
- Instalar paquete desde AUR -> debe funcionar
- Actualizar todos los paquetes -> debe completarse

---

# 77. Gestor de Actualizaciones

## 77.1 ¿Para qué existe?

`lnos-updater` es el gestor de actualizaciones en línea de comandos para LNOS. Proporciona control granular sobre cuándo y cómo se actualiza el sistema.

## 77.2 lnos-updater (CLI)

```bash
# Ver actualizaciones disponibles
lnos-updater check

# Actualizar todo el sistema
lnos-updater update

# Actualizar solo paquetes de seguridad
lnos-updater update --security

# Actualizar solo flatpak
lnos-updater update --flatpak

# Actualizar solo AUR
lnos-updater update --aur

# Mostrar historial de actualizaciones
lnos-updater history

# Mostrar estado (última actualización, paquetes pendientes)
lnos-updater status
```

## 77.3 Frecuencia de actualizaciones

| Tipo | Frecuencia | Gatillo |
|------|-----------|---------|
| Seguridad | Inmediata | Vulnerabilidad crítica |
| Paquetes normales | Diaria | Systemd timer |
| Kernel | Semanal | Systemd timer |
| Firmware | Mensual | Systemd timer |
| Flatpak | Diaria | Systemd timer |

## 77.4 Notificaciones de actualizaciones

Las notificaciones se muestran via `notify-send`:

```
+--------------------------------------+
|  Actualizaciones disponibles          |
+--------------------------------------+
|                                      |
|  Hay 12 actualizaciones disponibles  |
|                                      |
|  [Actualizar ahora] [Recordar luego] |
|                                      |
+--------------------------------------+
```

## 77.5 Actualizaciones de seguridad prioritarias

Las vulnerabilidades críticas se actualizan inmediatamente:

```bash
# /etc/lnos/updater.conf
[security]
auto_update = true
notify = true
reboot_required = true

[general]
update_frequency = daily
max_concurrent = 5
log_level = info
```

## 77.6 Integración con snapshots

Antes de cada actualización, `lnos-updater` crea un snapshot Btrfs:

```bash
# Flujo de actualización
1. lnos-updater check -> descubre paquetes
2. Crea snapshot Btrfs pre-update
3. Ejecuta pacman -Syu / flatpak update
4. Verifica que no hay errores
5. Si falla: lnos-updater rollback -> restaura snapshot
6. Crea snapshot post-update
```

## 77.7 Dependencias

- `pacman`
- `flatpak`
- `btrfs-progs` (para snapshots)
- `python` (backend)

## 77.8 Pruebas

- `lnos-updater check` -> mostrar paquetes disponibles
- `lnos-updater status` -> mostrar estado del sistema
- `lnos-updater history --last 10` -> mostrar últimas 10 actualizaciones
- `lnos-updater update --dry-run` -> simular actualización

---

# 78. Actualizaciones Automáticas

## 78.1 ¿Para qué existe?

Las actualizaciones automáticas garantizan que el sistema esté siempre al día con parches de seguridad y correcciones de bugs, sin intervención del usuario.

## 78.2 Systemd timer (lnos-update.timer)

```ini
# /etc/systemd/system/lnos-update.timer
[Unit]
Description=LnOS daily update timer

[Timer]
OnCalendar=daily
Persistent=true
RandomizedDelaySec=1h

[Install]
WantedBy=timers.target
```

```ini
# /etc/systemd/system/lnos-update.service
[Unit]
Description=LnOS daily update
Documentation=https://docs.lnos.dev/updater

[Service]
Type=oneshot
ExecStart=/usr/bin/lnos-updater update --non-interactive
Environment=LNOS_AUTO_UPDATE=1
Nice=19
IOSchedulingClass=idle
```

## 78.3 Actualizaciones diarias

El timer se ejecuta diariamente. Las actualizaciones se descargan en segundo plano con baja prioridad (`nice=19`) para no interferir con el trabajo del usuario.

## 78.4 Snapshots pre/post actualización

Antes de actualizar, se crea un snapshot Btrfs:

```bash
#!/bin/bash
# /usr/lib/lnos/pre-update-snapshot.sh
SNAPSHOT_NAME="pre-update-$(date +%Y%m%d-%H%M%S)"
btrfs subvolume snapshot / /.snapshots/$SNAPSHOT_NAME
```

Después de actualizar, se crea otro:

```bash
#!/bin/bash
# /usr/lib/lnos/post-update-snapshot.sh
SNAPSHOT_NAME="post-update-$(date +%Y%m%d-%H%M%S)"
btrfs subvolume snapshot / /.snapshots/$SNAPSHOT_NAME

# Limpiar snapshots antiguos (conservar 30 días)
btrfs subvolume list / | grep pre-update | head -n -30 | xargs -I {} btrfs subvolume delete {}
```

## 78.5 Notificaciones post-update

```bash
# /usr/lib/lnos/notify-update.sh
if [ -f /var/run/reboot-required ]; then
    notify-send "LNOS" "Se requiere reinicio para completar las actualizaciones"
fi

if [ -f /var/run/lnos-update-errors ]; then
    notify-send -u critical "LNOS" "Hubo errores en la actualización. Revisa el log."
fi
```

## 78.6 Rollback automático en fallo

Si una actualización falla (kernel panic, paquete roto), `lnos-updater` detecta el fallo en el siguiente arranque y ofrece rollback:

```bash
# Detección de fallo en boot
systemd-fsck falla o kernel panic -> lnos-updater detecta en next boot

# lnos-updater status muestra:
"La última actualización parece haber fallado. Último snapshot: pre-update-20250728-153000"
"Ejecuta 'lnos-updater rollback' para restaurar"
```

## 78.7 Dependencias

- `systemd` (timers)
- `btrfs-progs` (snapshots)
- `lnos-updater`

## 78.8 Pruebas

- `systemctl status lnos-update.timer` -> verificar timer activo
- `systemctl start lnos-update.service` -> ejecutar actualización manual
- `journalctl -u lnos-update.service` -> ver logs
- Verificar que se crean snapshots en `/.snapshots/`

---

# 79. Rollback

## 79.1 ¿Para qué existe?

El sistema de rollback permite deshacer cambios que hayan roto el sistema, ya sea por una actualización fallida, una configuración incorrecta, o un paquete conflictivo.

## 79.2 Sistema de rollback (basado en snapshots Btrfs)

```
+--------------------------------------------------+
|              Sistema de Rollback                  |
+--------------------------------------------------+
|                                                   |
|  Snapshot pre-update   <---  Snapshot post-update |
|       |                              |            |
|       v                              v            |
|  Sistema estable                  Sistema actual  |
|       |                              |            |
|       +--- [Rollback] ---------------+            |
|                                                   |
|  Mecanismo:                                       |
|  1. Desmontar subvolumen actual                   |
|  2. Renombrar a @broken                          |
|  3. Crear snapshot de pre-update como @           |
|  4. Montar y continuar boot                       |
|                                                   |
+--------------------------------------------------+
```

## 79.3 Rollback completo o por paquete

### 79.3.1 Rollback completo (vía Btrfs)

```bash
# Listar snapshots disponibles
lnos-updater rollback list

# Realizar rollback al snapshot especificado
lnos-updater rollback --snapshot pre-update-20250728-153000

# Rollback automático al último snapshot exitoso
lnos-updater rollback --auto
```

### 79.3.2 Rollback por paquete (vía pacman)

```bash
# Bajar de versión un paquete específico
pacman -U /var/cache/pacman/pkg/paquete-version-anterior.pkg.tar.zst

# Usando lnos-updater
lnos-updater rollback --package firefox --version 128.0
```

**Limitación:** El rollback por paquete solo funciona si el paquete anterior está en cache (`/var/cache/pacman/pkg/`).

## 79.4 Restauración de configuración

Los archivos de configuración se restauran automáticamente:

```bash
# /etc/ se incluye en el snapshot Btrfs
# Al hacer rollback, /etc vuelve al estado del snapshot

# Configuraciones de usuario (~/.config/) NO se restauran automáticamente
# (están en /home, que no se incluye en snapshots del sistema)
```

## 79.5 Interfaz gráfica para rollback

`lnos-software` incluye una sección de rollback:

```
+--------------------------------------------------+
|  lnos-software -> Rollback                       |
+--------------------------------------------------+
|                                                   |
|  Snapshots disponibles:                           |
|                                                   |
|  [x] pre-update-20250728-153000  (hace 2 días)   |
|  [ ] pre-update-20250727-120000  (hace 3 días)   |
|  [ ] pre-update-20250726-090000  (hace 4 días)   |
|                                                   |
|  [Realizar rollback] [Cancelar]                   |
|                                                   |
+--------------------------------------------------+
```

## 79.6 Dependencias

- `btrfs-progs`
- `snapper` (opcional, para gestión de snapshots)
- `lnos-updater`

## 79.7 Pruebas

- `lnos-updater rollback list` -> ver snapshots
- `lnos-updater rollback --snapshot pre-update-20250728-153000` -> realizar rollback
- Verificar que el sistema arranca correctamente tras rollback
- Verificar que los paquetes vuelven a la versión anterior

---

# 80. Snapshots

## 80.1 ¿Para qué existe?

Los snapshots Btrfs proporcionan puntos de restauración del sistema. En LNOS se usan para proteger el sistema antes y después de cambios significativos.

## 80.2 Snapshots Btrfs automáticos

```
+--------------------------------------------------+
|              Sistema de Snapshots                 |
+--------------------------------------------------+
|                                                   |
|  Subvolumen @ (/)                                 |
|       |                                           |
|       v                                           |
|  /.snapshots/                                     |
|  +-- hourly/       (últimas 24 horas)            |
|  |   +-- 20250728-090000                         |
|  |   +-- 20250728-100000                         |
|  |   +-- ...                                     |
|  +-- daily/        (últimos 7 días)              |
|  |   +-- 20250728-000000                         |
|  |   +-- 20250727-000000                         |
|  +-- weekly/       (últimos 4 semanas)           |
|  |   +-- 20250728-000000                         |
|  +-- pre-update/   (antes de actualizar)          |
|  +-- post-update/  (después de actualizar)        |
|                                                   |
+--------------------------------------------------+
```

## 80.3 Frecuencia

| Tipo | Frecuencia | Retención | Propósito |
|------|-----------|-----------|-----------|
| **Horaria** | Cada hora | 24 horas | Protección contra cambios recientes |
| **Diaria** | Cada día | 7 días | Protección diaria |
| **Semanal** | Cada semana | 4 semanas | Protección a largo plazo |
| **Pre-update** | Antes de `pacman -Syu` | 30 días | Protección de actualizaciones |
| **Post-update** | Después de `pacman -Syu` | 7 días | Punto de verificación |

## 80.4 Política de retención

```bash
# /etc/lnos/snapper.conf
# Configuración de snapper para LNOS

# Snapshots horarios: conservar 24, eliminar los más antiguos
HOURLY_LIMIT=24

# Snapshots diarios: conservar 7
DAILY_LIMIT=7

# Snapshots semanales: conservar 4
WEEKLY_LIMIT=4

# Snapshots pre/post-update: conservar 30
PRE_UPDATE_LIMIT=30
POST_UPDATE_LIMIT=7
```

**Limpieza automática:** Los snapshots antiguos se eliminan automáticamente cuando se supera el límite. `snapper` se encarga de esto.

## 80.5 Snapshots pre/post actualización

Cuando se ejecuta `lnos-updater update`:

```bash
# /usr/lib/lnos/snapshot-pre-update.sh
#!/bin/bash
SNAPSHOT_NAME="pre-update-$(date +%Y%m%d-%H%M%S)"
snapper -c lnos create --description "$SNAPSHOT_NAME" --cleanup-algorithm number

# /usr/lib/lnos/snapshot-post-update.sh
#!/bin/bash
SNAPSHOT_NAME="post-update-$(date +%Y%m%d-%H%M%S)"
snapper -c lnos create --description "$SNAPSHOT_NAME" --cleanup-algorithm number
```

## 80.6 Integración con timeshift

Timeshift es una herramienta gráfica para gestionar snapshots. En LNOS:

- Timeshift NO se instala por defecto (usamos `snapper` para consistencia con Btrfs).
- Se ofrece como alternativa opcional (`pacman -S timeshift`).

**Comparativa:**

| Herramienta | Backend | Interfaz | Automatización | Integración LNOS |
|-------------|---------|----------|---------------|------------------|
| **snapper** | Btrfs | CLI + Yast | Completa | Nativa |
| **Timeshift** | Btrfs/RSYNC | GTK | Buena | Opcional |

## 80.7 Recuperación desde snapshot

Métodos de recuperación:

### 80.7.1 Desde LNOS en funcionamiento

```bash
# Ver snapshots
snapper -c lnos list

# Restaurar snapshot
snapper -c lnos undochange SNAPSHOT_ID..0
```

### 80.7.2 Desde el bootloader (systemd-boot)

En systemd-boot, se añade una entrada de rescate:

```
title   LNOS (Restore from snapshot)
linux   /vmlinuz-linux
initrd  /intel-ucode.img
initrd  /initramfs-linux.img
options root=UUID=... snapper_recovery=1
```

### 80.7.3 Desde live USB

```bash
# Arrancar con USB de LNOS
# Montar sistema
mount /dev/sdX2 /mnt
# Buscar snapshots
btrfs subvolume list /mnt
# Restaurar snapshot específico
btrfs subvolume snapshot /mnt/.snapshots/XXX/snapshot /mnt/@
```

## 80.8 Dependencias

- `btrfs-progs`
- `snapper`
- `lnos-updater`

## 80.9 Pruebas

- `snapper -c lnos list` -> ver snapshots
- `snapper -c lnos create --description "test-snapshot"` -> crear snapshot manual
- `lnos-updater rollback list` -> ver snapshots disponibles
- `lnos-updater rollback --snapshot test-snapshot` -> restaurar
- Verificar que tras rollback el sistema funciona correctamente

---
