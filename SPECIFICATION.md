# LNOS — Especificación Técnica Completa de la Distribución

---

**Versión del documento:** 1.0.0  
**Estado:** Borrador inicial  
**Clasificación:** Público  
**Última actualización:** 2026-07-29  
**Autoría:** Equipo de diseño LNOS (Arquitectos Kernel Linux, Mantenedores Arch Linux, Desarrolladores systemd, Hyprland, Wayland, Expertos seguridad, DevOps, Ingenieros compiladores, sistemas distribuidos, drivers, UX/UI, rendimiento)

---

## Prefacio

Este documento constituye la especificación técnica oficial y completa del sistema LNOS. Ha sido redactado por un equipo multidisciplinario de expertos en cada una de las áreas que comprende la distribución. Cada decisión de ingeniería aquí documentada ha sido debatida, justificada y contrastada con alternativas existentes.

El propósito de este documento es servir como fuente única de verdad durante la implementación del sistema. Cualquier equipo de desarrollo —humano o basado en inteligencia artificial— debe poder implementar la distribución completa siguiendo exclusivamente las especificaciones aquí contenidas, sin necesidad de tomar decisiones arquitectónicas significativas.

---

## Índice General

1. [Visión del Proyecto](#1-visión-del-proyecto)
2. [Filosofía](#2-filosofía)
3. [Objetivos](#3-objetivos)
4. [Público Objetivo](#4-público-objetivo)
5. [Casos de Uso](#5-casos-de-uso)
6. [Arquitectura General](#6-arquitectura-general)
7. [Arquitectura Modular](#7-arquitectura-modular)
8. [Estructura del Repositorio](#8-estructura-del-repositorio)
9. [Sistema de Compilación](#9-sistema-de-compilación)
10. [Sistema de Generación de ISO](#10-sistema-de-generación-de-iso)
11. [Herramientas Utilizadas](#11-herramientas-utilizadas)
12. [Organización del Proyecto](#12-organización-del-proyecto)
13. [Convenciones](#13-convenciones)
14. [Estilo del Código](#14-estilo-del-código)
15. [Política de Ramas Git](#15-política-de-ramas-git)
16. [Versionado](#16-versionado)
17. [CI/CD](#17-cicd)
18. [Testing](#18-testing)
19. [QA](#19-qa)
20. [Documentación](#20-documentación)
21. [Branding](#21-branding)
22. [Instalador](#22-instalador)
23. [Particionado](#23-particionado)
24. [EFI](#24-efi)
25. [Bootloader](#25-bootloader)
26. [Secure Boot](#26-secure-boot)
27. [Gestión de Usuarios](#27-gestión-de-usuarios)
28. [PAM](#28-pam)
29. [sudo](#29-sudo)
30. [Polkit](#30-polkit)
31. [systemd](#31-systemd)
32. [Servicios](#32-servicios)
33. [NetworkManager](#33-networkmanager)
34. [Bluetooth](#34-bluetooth)
35. [Audio](#35-audio)
36. [PipeWire](#36-pipewire)
37. [WirePlumber](#37-wireplumber)
38. [Firewall](#38-firewall)
39. [nftables](#39-nftables)
40. [AppArmor](#40-apparmor)
41. [SELinux (Evaluación)](#41-selinux-evaluación)
42. [Drivers Intel](#42-drivers-intel)
43. [Drivers AMD](#43-drivers-amd)
44. [Drivers NVIDIA](#44-drivers-nvidia)
45. [Microcode](#45-microcode)
46. [Wayland](#46-wayland)
47. [Hyprland](#47-hyprland)
48. [Configuración Completa de Hyprland](#48-configuración-completa-de-hyprland)
49. [Waybar](#49-waybar)
50. [Rofi](#50-rofi)
51. [Kitty](#51-kitty)
52. [Foot](#52-foot)
53. [Fastfetch](#53-fastfetch)
54. [GTK](#54-gtk)
55. [QT](#55-qt)
56. [Cursores](#56-cursores)
57. [Iconos](#57-iconos)
58. [Temas](#58-temas)
59. [Wallpapers](#59-wallpapers)
60. [Fuentes](#60-fuentes)
61. [Pantalla de Bloqueo](#61-pantalla-de-bloqueo)
62. [Gestor de Energía](#62-gestor-de-energía)
63. [Laptop Mode](#63-laptop-mode)
64. [Optimización para Portátiles](#64-optimización-para-portátiles)
65. [Optimización para Sobremesas](#65-optimización-para-sobremesas)
66. [Gaming](#66-gaming)
67. [Steam](#67-steam)
68. [Proton](#68-proton)
69. [Wine](#69-wine)
70. [Vulkan](#70-vulkan)
71. [OpenGL](#71-opengl)
72. [Mesa](#72-mesa)
73. [Flatpak](#73-flatpak)
74. [Repositorios](#74-repositorios)
75. [AUR](#75-aur)
76. [Gestor Gráfico de Paquetes](#76-gestor-gráfico-de-paquetes)
77. [Gestor de Actualizaciones](#77-gestor-de-actualizaciones)
78. [Actualizaciones Automáticas](#78-actualizaciones-automáticas)
79. [Rollback](#79-rollback)
80. [Snapshots](#80-snapshots)
81. [Btrfs](#81-btrfs)
82. [Timeshift](#82-timeshift)
83. [Scripts de Mantenimiento](#83-scripts-de-mantenimiento)
84. [Backups](#84-backups)
85. [Recuperación](#85-recuperación)
86. [Impresoras](#86-impresoras)
87. [Escáneres](#87-escáneres)
88. [Cámaras](#88-cámaras)
89. [Bluetooth Avanzado](#89-bluetooth-avanzado)
90. [Sincronización](#90-sincronización)
91. [Nube](#91-nube)
92. [Asistente de Bienvenida](#92-asistente-de-bienvenida)
93. [Configuración Inicial](#93-configuración-inicial)
94. [Centro de Configuración](#94-centro-de-configuración)
95. [Centro de Software](#95-centro-de-software)
96. [API Interna](#96-api-interna)
97. [Sistema de Módulos](#97-sistema-de-módulos)
98. [Sistema de Plugins](#98-sistema-de-plugins)
99. [Internacionalización](#99-internacionalización)
100. [Accesibilidad](#100-accesibilidad)
101. [Telemetría](#101-telemetría)
102. [Política de Privacidad](#102-política-de-privacidad)
103. [Seguridad](#103-seguridad)
104. [Sandboxing](#104-sandboxing)
105. [Contenedores](#105-contenedores)
106. [Docker](#106-docker)
107. [Podman](#107-podman)
108. [Virtualización](#108-virtualización)
109. [KVM](#109-kvm)
110. [QEMU](#110-qemu)
111. [Desarrollo](#111-desarrollo)
112. [Toolchains](#112-toolchains)
113. [IDEs](#113-ides)
114. [SDK](#114-sdk)
115. [Herramientas para Desarrolladores](#115-herramientas-para-desarrolladores)
116. [Monitorización](#116-monitorización)
117. [Logging](#117-logging)
118. [Benchmarks](#118-benchmarks)
119. [Rendimiento](#119-rendimiento)
120. [Roadmap](#120-roadmap)

---

## 1. Visión del Proyecto

### 1.1 ¿Para qué existe?

LNOS nace de la necesidad de una distribución Linux profesional que combine la flexibilidad y el modelo rolling-release de Arch Linux con la estabilidad, seguridad y experiencia de usuario pulida que exigen los entornos profesionales. No existe actualmente ninguna distribución que ofrezca simultáneamente:

- La potencia arquitectónica y actualidad de Arch Linux.
- La seguridad por defecto de proyectos como Qubes OS o Fedora Silverblue.
- La experiencia de usuario de macOS o Windows 11.
- La modularidad de NixOS.
- El rendimiento gráfico de una estación de trabajo gaming.
- El consumo mínimo de recursos de una distribución minimalista.

LNOS cubre este vacío.

### 1.2 Justificación

El ecosistema Linux actual está fragmentado entre distribuciones orientadas a servidores, distribuciones para usuarios domésticos y distribuciones para entusiastas. Ninguna cubre adecuadamente el perfil del profesional técnico que necesita:

1. **Actualizaciones continuas** (rolling release) sin temor a roturas gracias a snapshots y rollback automático.
2. **Entorno gráfico moderno** basado en Wayland + Hyprland con aceleración 3D completa.
3. **Seguridad integral** con AppArmor, firewall por defecto, Secure Boot, y sandboxing.
4. **Mínimo consumo de recursos** para maximizar rendimiento en hardware modesto y prolongar batería en portátiles.
5. **Reproducibilidad** de configuraciones mediante dotfiles gestionados y módulos declarativos.

### 1.3 Ventajas frente a otras distribuciones

| Aspecto | LNOS | Ubuntu | Fedora | Arch Linux | NixOS |
|---|---|---|---|---|---|
| Rolling release | Sí | No | No | Sí | Mixto |
| Seguridad por defecto | Completa | Parcial | Parcial | Manual | Buena |
| Consumo RAM (~) | 400-600 MB | 1.2-2 GB | 1-1.5 GB | 300-500 MB | 500-800 MB |
| Modularidad nativa | Sí (módulos) | No | No | No | Sí (Nix) |
| UX profesional | Sí | Estándar | Estándar | Mínima | Mínima |
| Gaming ready | Sí | Limitado | Limitado | Manual | Manual |
| Snapshots automáticos | Sí | No | No | No | No |

### 1.4 Inconvenientes asumidos

- **Curva de aprendizaje:** Hyprland + Wayland requiere adaptación para usuarios de entornos tradicionales.
- **Compatibilidad:** Algunas aplicaciones X11 legacy pueden requerir XWayland.
- **Rolling release:** Aunque mitigado con snapshots, no se puede garantizar la estabilidad absoluta de Arch Linux upstream.
- **Hardware NVIDIA:** Wayland + NVIDIA requiere configuración específica (ver capítulo 44).

### 1.5 Alternativas descartadas

| Distribución | Motivo del descarte |
|---|---|
| Ubuntu/Debian | Base demasiado conservadora, paquetes desactualizados, Snap forzado |
| Fedora | Ciclo de vida corto (13 meses), no rolling, decisiones upstream restrictivas |
| openSUSE Tumbleweed | Buena pero con menos soporte comunitario y de software |
| NixOS | Curva de aprendizaje demasiado pronunciada, ecosistema de aplicaciones limitado |
| Gentoo | Compilación desde fuente impracticable para usuarios profesionales |

### 1.6 Diagrama de visión del sistema

```
+--------------------------------------------------------------+
|                     LNOS - Visión General                      |
+--------------------------------------------------------------+
|                                                                |
|  +------------------+  +------------------+  +--------------+ |
|  |   Experiencia    |  |    Seguridad     |  |  Rendimiento | |
|  |   de Usuario     |  |   Integral       |  |  Máximo      | |
|  |  (Hyprland,      |  |  (AppArmor,      |  |  (Mesa,      | |
|  |   Waybar, Rofi)  |  |   Firewall, SB)  |  |   Vulkan,    | |
|  +------------------+  +------------------+  |   low RAM)   | |
|                                                                |
|  +------------------+  +------------------+  +--------------+ |
|  |   Modularidad    |  |  Reproducibilidad|  | Automatizac. | |
|  |  (Módulos,       |  |  (Dotfiles,      |  | (Snapshots,  | |
|  |   Plugins)       |  |   Módulos decl.) |  |  CI/CD)      | |
|  +------------------+  +------------------+  +--------------+ |
|                                                                |
|  +----------------------------------------------------------+ |
|  |              Arch Linux (base rolling)                     | |
|  +----------------------------------------------------------+ |
|  |              Linux Kernel (optimizado)                     | |
|  +----------------------------------------------------------+ |
+--------------------------------------------------------------+
```

---

## 2. Filosofía

### 2.1 Principios fundamentales

LNOS se rige por los siguientes principios, ordenados por prioridad:

#### 2.1.1 Basada completamente en Arch Linux

Se utiliza Arch Linux como base absoluta. No se forkearán paquetes del core ni del extra a menos que sea estrictamente necesario para seguridad o funcionalidad crítica. Cualquier modificación a paquetes upstream debe ser:
- Documentada explícitamente.
- Enviada como parche upstream.
- Limitada al mínimo indispensable.

**Justificación:** Arch Linux proporciona el mejor equilibrio entre actualidad, simplicidad arquitectónica (KISS) y disponibilidad de software. Derivar de Arch evita tener que mantener un repositorio de paquetes completo.

#### 2.1.2 100% Open Source

No se incluirá software privativo por defecto. El usuario puede instalarlo explícitamente (drivers NVIDIA, codecs, Steam), pero nunca vendrá preinstalado.

**Justificación:** Garantiza que la distribución puede ser auditada, modificada y redistribuida sin restricciones legales. También permite empaquetar para cualquier país sin preocupaciones de exportación de criptografía.

**Excepciones documentadas:**
- Microcode Intel/AMD (binario pero necesario para seguridad).
- Firmware de dispositivos (linux-firmware).
- Secure Boot (binarios firmados por Microsoft).

#### 2.1.3 Extremadamente modular

Todo el sistema se organiza en módulos independientes con interfaces bien definidas. Cada módulo:
- Puede instalarse o desinstalarse sin afectar al resto.
- Declara sus dependencias explícitamente.
- Expone una API interna documentada.
- Puede ser reemplazado por una implementación alternativa.

**Justificación:** La modularidad permite que LNOS sirva tanto para un servidor headless como para una estación gaming, simplemente seleccionando los módulos adecuados.

#### 2.1.4 Mantenible durante muchos años

Cada decisión de diseño se toma pensando en el mantenimiento a 5-10 años vista. Esto implica:
- Preferir soluciones estándar (systemd, PipeWire, Wayland) sobre soluciones caseras.
- Minimizar el código propio; todo lo que pueda delegarse en herramientas existentes debe delegarse.
- Documentar absolutamente todo.

#### 2.1.5 Preparada para actualizaciones futuras

La arquitectura debe soportar cambios futuros en:
- **Wayland:** Nuevos protocolos (ext-double-buffer, security-context, etc.).
- **Hyprland:** Versiones que puedan cambiar su API de configuración.
- **systemd:** Nuevas unidades y servicios.
- **Linux Kernel:** Nuevos subsistemas (sched_ext, Rust-for-Linux, etc.).

Esto se logra mediante:
- Capas de abstracción en los módulos.
- Configuración generada, no estática.
- Tests de regresión automatizados.

#### 2.1.6 Fácil de ampliar mediante módulos

Cualquier desarrollador debe poder crear un módulo LNOS siguiendo una plantilla documentada. La publicación de módulos debe ser tan sencilla como crear un repositorio Git con una estructura específica.

### 2.2 Principios operativos

#### 2.2.1 Automatización absoluta

Todo proceso que pueda automatizarse debe automatizarse:
- Instalación: scriptable y no interactiva (preseed).
- Configuración inicial: detecta hardware y aplica configuración óptima.
- Actualizaciones: automáticas con rollback en caso de fallo.
- Backups: programados por defecto.
- Mantenimiento: scripts semanales/mensuales automáticos.

#### 2.2.2 Todo configurable

No existen valores hardcodeados. Cada parámetro del sistema debe poder modificarse mediante:
1. Archivos de configuración en `/etc/lnos/` (configuración del sistema).
2. Archivos de configuración en `~/.config/lnos/` (configuración de usuario).
3. Variables de entorno (para overrides temporales).
4. API REST local (para herramientas gráficas).

#### 2.2.3 Todo reproducible

Dado un conjunto de módulos y una versión, la instalación debe producir siempre el mismo sistema. Esto se garantiza mediante:
- Ficheros de lock de versiones de módulos.
- Checksums de configuraciones generadas.
- Sistema de módulos que es esencialmente una máquina de estados determinista.

#### 2.2.4 Todo documentado

No se acepta código sin documentación. La documentación incluye:
- Documentación técnica (este documento).
- Documentación de usuario (manuales, wikis).
- Documentación de API (generada automáticamente de comentarios).
- Documentación de configuración (con ejemplos).
- Documentación de módulos (cada módulo incluye su propia especificación).

### 2.3 Árbol de decisiones filosóficas

```
Filosofía LNOS
├── Base
│   ├── ¿Por qué Arch? → Rolling, KISS, AUR, Pacman, BKUs
│   ├── ¿Por qué no Debian? → Paquetes desactualizados, estabilidad falsa
│   └── ¿Por qué no Fedora? → Ciclo corto, decisiones upstream forzadas
├── Gráficos
│   ├── ¿Por qué Wayland? → Seguridad, rendimiento, modernidad
│   ├── ¿Por qué Hyprland? → Animaciones, productividad, Wayland nativo
│   └── ¿Por qué no GNOME/KDE? → Consumo RAM, falta de modularidad
├── Seguridad
│   ├── ¿Por qué AppArmor? → Integración con systemd, facilidad de perfiles
│   ├── ¿Por qué no SELinux? → Complejidad, pocos perfiles en Arch
│   └── ¿Por qué nftables? → Moderno, reemplazo de iptables
├── Paquetes
│   ├── ¿Por qué Pacman? → Nativo de Arch, rápido, simple
│   ├── ¿Por qué Flatpak? → Sandboxing para aplicaciones de escritorio
│   └── ¿Por qué no Snap? → Centralizado, servidor propietario
└── Almacenamiento
    ├── ¿Por qué Btrfs? → Snapshots, compresión, checksumming
    ├── ¿Por qué no ZFS? → Licencia CDDL incompatible con GPL
    └── ¿Por qué no ext4? → Sin snapshots nativos
```

---

## 3. Objetivos

### 3.1 Objetivos primarios (MVP)

1. **ISO instalable** que produzca un sistema funcional completo en menos de 15 minutos.
2. **Entorno Hyprland** con Waybar, Rofi y configuración profesional por defecto.
3. **Seguridad mínima:** Firewall activo, AppArmor, Secure Boot, sudo con contraseña.
4. **Snapshots automáticos** con Timeshift + Btrfs preconfigurado.
5. **Audio funcional** con PipeWire + WirePlumber.
6. **Soporte gráfico** Intel, AMD y NVIDIA con Mesa + Vulkan.
7. **Sistema de módulos** funcional con al menos 10 módulos base.
8. **Centro de software** para gestión visual de paquetes.
9. **Actualizaciones automáticas** con rollback.
10. **Documentación completa** de instalación y uso.

### 3.2 Objetivos secundarios (v1.1 - v2.0)

11. **Asistente de bienvenida** interactivo post-instalación.
12. **Centro de configuración** gráfico unificado.
13. **Soporte de impresión** (CUPS + drivers comunes).
14. **Integración con nube** (Nextcloud, Google Drive, OneDrive).
15. **Soporte de contenedores** (Docker, Podman) preconfigurado.
16. **Herramientas para desarrolladores** (toolchains, IDEs).
17. **Sistema de plugins** para extensiones del centro de software.
18. **Telemetría** deshabilitada por defecto (solo opt-in).
19. **Benchmarking** integrado en el centro de configuración.
20. **Soporte multi-idioma** completo (i18n + l10n).

### 3.3 Objetivos aspiracionales (v3.0+)

21. **App Store descentralizada** basada en módulos + Flatpak + AUR.
22. **Asistente IA** para configuración y resolución de problemas.
23. **Instalador web** para despliegues remotos.
24. **Soporte de arranque dual** automático con Windows/macOS.
25. **Sistema de imágenes inmutables** (opcional, modo inmutable).

### 3.4 Matriz de objetivos vs. capítulos

| Objetivo | Capítulo principal | Dependencias | Prioridad |
|---|---|---|---|
| ISO instalable | 10, 22, 23, 24, 25 | 8, 9 | P0 |
| Hyprland | 47, 48, 49, 50 | 46 | P0 |
| Seguridad | 26, 28, 29, 30, 38, 39, 40 | 27 | P0 |
| Snapshots | 80, 81, 82 | 23 | P0 |
| Audio | 35, 36, 37 | 46 | P0 |
| Drivers | 42, 43, 44, 45, 70, 71, 72 | Kernel | P0 |
| Módulos | 7, 97, 98 | 6 | P0 |
| Centro software | 95 | 74, 75, 76 | P0 |
| Actualizaciones | 77, 78, 79 | 81 | P0 |
| Docs | 20 | — | P0 |

---

## 4. Público Objetivo

### 4.1 Perfiles primarios

| Perfil | Descripción | Módulos necesarios |
|---|---|---|
| Desarrollador de software | Necesita toolchains, IDEs, contenedores, rendimiento | Base + Dev + Docker |
| Diseñador gráfico | Necesita color preciso, tabletas gráficas, fuentes | Base + Creative |
| Científico de datos | Necesita GPGPU, Python, R, Jupyter | Base + DataScience + CUDA |
| Ingeniero DevOps | Necesita contenedores, virtualización, automatización | Base + DevOps |
| Estudiante de informática | Necesita herramientas de desarrollo, bajo coste | Base + Dev |
| Entusiasta del gaming | Necesita Steam, Proton, máximo rendimiento | Base + Gaming |
| Usuario profesional | Ofimática, navegación, multimedia, estabilidad | Base + Office |

### 4.2 Perfiles secundarios

| Perfil | Descripción | Módulos necesarios |
|---|---|---|
| Administrador de sistemas | Gestión remota, monitorización, scripting | Base + Server + Monitoring |
| Investigador | Reproducibilidad, contenedores, GPGPU | Base + DataScience + Dev |
| Creador de contenidos | Edición de vídeo, 3D, streaming | Base + Creative |
| Jubilado/Usuario básico | Navegación, correo, fotos, sencillez | Base minimal |

### 4.3 No-público objetivo

- Usuarios que requieran soporte oficial 24/7 (LNOS es comunidad, no empresa).
- Organizaciones que necesiten certificaciones (FIPS, Common Criteria, etc.).
- Usuarios de X11 que se nieguen a migrar a Wayland.
- Usuarios de GNOME/KDE que no quieran aprender Hyprland.

### 4.4 Requisitos de hardware mínimos

| Componente | Mínimo | Recomendado |
|---|---|---|
| CPU | x86-64, 2 cores | x86-64, 4+ cores |
| RAM | 2 GB | 8+ GB |
| Almacenamiento | 20 GB SSD | 256 GB+ NVMe |
| GPU | Cualquier compat. Mesa | Intel Xe/AMD RDNA/NVIDIA Ampere+ |
| Pantalla | 1366x768 | 1920x1080+ |
| Red | Cualquier | Ethernet + Wi-Fi |

---

## 5. Casos de Uso

### 5.1 Caso 1: Estación de desarrollo Python/JavaScript

**Usuario:** Andrea, desarrolladora web full-stack.  
**Hardware:** ThinkPad X1 Carbon (8 GB RAM, 256 GB SSD, Intel Iris).  

**Flujo:**
1. Arranca la ISO, selecciona "Instalación mínima + Módulo Dev".
2. El instalador detecta el hardware, configura Btrfs + snapshots.
3. Tras instalar, el asistente de bienvenida pregunta: "¿Qué lenguajes usas?"
4. Selecciona Python, Node.js y VS Code.
5. El sistema instala toolchains, extensiones y configura el entorno.
6. Andrea abre Kitty (Ctrl+Alt+T), escribe `python -m venv .venv`.
7. Usa Waybar para monitorizar CPU/RAM mientras ejecuta tests.

**Módulos implicados:** Base + Dev + Python + NodeJS + VSCode + Hyprland.

### 5.2 Caso 2: Estación gaming

**Usuario:** Carlos, jugador de Steam.  
**Hardware:** Desktop con Ryzen 7 + RTX 4070 + 32 GB RAM.  

**Flujo:**
1. ISO completa + Módulo Gaming.
2. El instalador detecta NVIDIA y ofrece instalar drivers privativos.
3. Configura MangoHud, Gamemode, Steam, Proton.
4. Carlos abre Rofi (Meta+D), escribe "steam".
5. Steam se ejecuta en modo gaming (GameMode activo).
6. MangoHud muestra FPS, temperaturas, consumo.

**Módulos implicados:** Base + Gaming + NVIDIA + Steam + MangoHud.

### 5.3 Caso 3: Servidor doméstico ligero

**Usuario:** Miguel, administrador de sistemas.  
**Hardware:** Intel NUC (4 GB RAM, 128 GB SSD).  

**Flujo:**
1. ISO mínima + Módulo Server + Módulo Docker.
2. Instalación headless (SSH activo por defecto).
3. Miguel accede por SSH, despliega contenedores Docker.
4. Firewall activo, AppArmor confinando contenedores.
5. Actualizaciones automáticas programadas a las 3 AM.

**Módulos implicados:** Base (minimal) + Server + Docker + SSH.

### 5.4 Caso 4: Diseño gráfico 3D

**Usuario:** Elena, diseñadora 3D con Blender.  
**Hardware:** Desktop AMD Ryzen 9 + RX 7900 XTX + 64 GB RAM.  

**Flujo:**
1. ISO completa + Módulo Creative + Módulo AMD.
2. Mesa + RADV + ROCm para aceleración AMD.
3. Configuración de color calibrada (colord + ICC profiles).
4. Wacom configurado con input remaper.
5. Blender con Cycles (GPU ROCm) funcionando.

**Módulos implicados:** Base + Creative + AMD + ROCm + Wacom.

### 5.5 Matriz casos de uso vs. requisitos

| Requisito | Caso 1 (Dev) | Caso 2 (Gaming) | Caso 3 (Server) | Caso 4 (Creative) |
|---|---|---|---|---|
| RAM mínima | 8 GB | 16 GB | 2 GB | 16 GB |
| GPU requerida | No | Sí | No | Sí |
| Rollback | Importante | Importante | Crítico | Importante |
| Seguridad | Alta | Alta | Máxima | Alta |
| Rendimiento gráfico | Medio | Máximo | Bajo | Máximo |
| Consumo batería | Importante | No aplica | No aplica | No aplica |

---

## 6. Arquitectura General

### 6.1 Diagrama de capas

```
+-----------------------------------------------------------------------+
|                          LNOS - ARQUITECTURA GENERAL                    |
+-----------------------------------------------------------------------+
|                                                                         |
|  +-------------------------------------------------------------------+ |
|  |                       EXPERIENCIA DE USUARIO                       | |
|  |  +--------+ +--------+ +--------+ +--------+ +------------------+ | |
|  |  | Waybar  | |  Rofi  | | Kitty  | |  Foot  | |  Centro Control  | | |
|  |  +--------+ +--------+ +--------+ +--------+ +------------------+ | |
|  |  +--------+ +--------+ +--------+ +--------+ +------------------+ | |
|  |  | Dunst   | |  Lock  | | Wall   | |  Lxdm  | |  Centro Software | | |
|  |  +--------+ +--------+ +--------+ +--------+ +------------------+ | |
|  +-------------------------------------------------------------------+ |
|                                |                                        |
|  +-------------------------------------------------------------------+ |
|  |                       COMPOSITOR / DISPLAY                         | |
|  |  +----------+ +----------+ +----------+ +--------+               | |
|  |  | Hyprland  | | XWayland | |  wlroots  | |  VRR   |               | |
|  |  +----------+ +----------+ +----------+ +--------+               | |
|  |  +----------+ +----------+ +----------+ +-----------------------+ | |
|  |  | libliftoff| | hwdata   | | libdisplay-info | |  libinput       | | |
|  |  +----------+ +----------+ +----------+ +-----------------------+ | |
|  +-------------------------------------------------------------------+ |
|                                |                                        |
|  +-------------------------------------------------------------------+ |
|  |                     MULTIMEDIA / GRÁFICOS                          | |
|  |  +--------+ +--------+ +--------+ +--------+ +--------+          | |
|  |  | PipeWire| | Vulkan | | OpenGL | |  Mesa  | |  VA-API |          | |
|  |  +--------+ +--------+ +--------+ +--------+ +--------+          | |
|  +-------------------------------------------------------------------+ |
|                                |                                        |
|  +-------------------------------------------------------------------+ |
|  |                       SISTEMA / KERNEL                             | |
|  |  +--------+ +--------+ +--------+ +--------+ +------------------+ | |
|  |  | systemd | |  D-Bus | |  udev  | | Kernel | |  Firmware + µcode| | |
|  |  +--------+ +--------+ +--------+ +--------+ +------------------+ | |
|  |  +--------+ +--------+ +--------+ +--------+ +------------------+ | |
|  |  | AppArmor| | nftables| |  PAM   | | Polkit | |  systemd-boot    | | |
|  |  +--------+ +--------+ +--------+ +--------+ +------------------+ | |
|  +-------------------------------------------------------------------+ |
|                                |                                        |
|  +-------------------------------------------------------------------+ |
|  |                      ALMACENAMIENTO / SISTEMA DE ARCHIVOS         | |
|  |  +--------+ +--------+ +--------+ +--------+ +--------+          | |
|  |  |  Btrfs  | |  EFI   | |  LUKS2 | |  Mount  | |  Timeshift |          | |
|  |  +--------+ +--------+ +--------+ +--------+ +--------+          | |
|  +-------------------------------------------------------------------+ |
|                                |                                        |
|  +-------------------------------------------------------------------+ |
|  |                      LNOS CORE (GESTIÓN MODULAR)                  | |
|  |  +------------------+ +------------------+ +--------------------+ | |
|  |  | Gestor de Módulos| | Gestor de Plugins| | API Interna (REST) | | |
|  |  +------------------+ +------------------+ +--------------------+ | |
|  |  +------------------+ +------------------+ +--------------------+ | |
|  |  | Centro de Conf.  | | Centro Software  | |  i18n/L10n Engine   | | |
|  |  +------------------+ +------------------+ +--------------------+ | |
|  +-------------------------------------------------------------------+ |
+-----------------------------------------------------------------------+
```

### 6.2 Flujo de arranque

```
ENCENDIDO
    │
    ▼
UEFI BIOS/Firmware
    │
    ▼
systemd-boot
    │
    ├── Secure Boot (verifica firma)
    │
    ▼
Linux Kernel (con microcode aplicado)
    │
    ▼
initramfs → systemd init
    │
    ├── systemd-udevd (detección hardware)
    ├── systemd-cryptsetup (LUKS2 si aplica)
    ├── systemd-bootchart (profiling opcional)
    │
    ▼
systemd default target (graphical.target)
    │
    ├── NetworkManager (red)
    ├── pipewire (audio)
    ├── bluetooth (si hardware presente)
    ├── apparmor (perfiles)
    ├── nftables (firewall)
    │
    ▼
display-manager.service
    │
    ▼
Hyprland (Wayland compositor)
    │
    ├── waybar (barra superior)
    ├── dunst (notificaciones)
    ├── polkit-gnome (autenticación)
    ├── wl-clipboard (portapapeles)
    │
    ▼
Sesión de usuario iniciada
```

### 6.3 Interacción entre componentes

```
Usuario
  │
  ├──[Keyboard/Mouse]──► libinput ──► Hyprland ──► waybar/dunst
  │                                                    │
  ├──[App gráfica]─────► Wayland ──► Hyprland ──► Mesa ──► KMS ──► GPU
  │                                                    │
  ├──[App X11]────────► XWayland ──► Hyprland
  │
  ├──[App audio]──────► PipeWire ──► WirePlumber ──► ALSA ──► Hardware
  │
  ├──[sudo/polkit]────► PAM ──► systemd-logind
  │
  ├──[paquete]────────► Pacman ──► repositorios Arch + LNOS
  │
  └──[config]────────► API LNOS ──► /etc/lnos/*.conf
                            │
                            └──► Módulo ──► hooks/scripts
```

### 6.4 Principios arquitectónicos

1. **Separación de responsabilidades:** Cada capa solo se comunica con la capa inmediatamente inferior/superior mediante interfaces definidas.
2. **Configuración declarativa:** `/etc/lnos/modules/<modulo>/config.toml` define el estado deseado.
3. **Mínimo código propio:** Preferir herramientas existentes a desarrollar soluciones internas.
4. **Graceful degradation:** Si un módulo falla, el sistema sigue funcionando sin ese módulo.
5. **Stateless donde sea posible:** Los módulos no almacenan estado interno; este reside en `/etc/lnos/state/`.

### 6.5 Dependencias entre capas

| Capa | Depende de | Proporciona a |
|---|---|---|
| Experiencia usuario | Compositor, Centro Software, Módulos | Usuario final |
| Compositor | Wayland, wlroots, libinput, Mesa | UX, Apps |
| Multimedia | ALSA, Kernel (DRM), Mesa | Compositor, Apps |
| Sistema | Kernel, Firmware, initramfs | Todo lo superior |
| Almacenamiento | Kernel (Btrfs, LUKS, DM) | Sistema |
| LNOS Core | systemd, D-Bus, Python/Go runtime | Módulos, Plugins, API |

---

## 7. Arquitectura Modular

### 7.1 Definición de módulo

Un **módulo LNOS** es un conjunto autocontenido de configuraciones, scripts y metadatos que añade una funcionalidad específica al sistema. Cada módulo:

- Tiene un identificador único (ej: `lnos-base`, `lnos-hyprland`, `lnos-gaming`).
- Declara sus dependencias (otros módulos y paquetes de Arch).
- Proporciona hooks de instalación, configuración y desinstalación.
- Expone variables de configuración con valores por defecto.

### 7.2 Estructura de un módulo

```
/usr/share/lnos/modules/<module-id>/
├── module.toml          # Metadatos del módulo
├── config.toml          # Configuración por defecto (opcional)
├── hooks/
│   ├── pre-install      # Antes de instalar paquetes
│   ├── post-install     # Después de instalar paquetes
│   ├── pre-remove       # Antes de desinstalar
│   ├── post-remove      # Después de desinstalar
│   ├── configure        # Aplicar configuración
│   └── status           # Verificar estado del módulo
├── files/
│   └── ... (archivos a copiar en el sistema)
├── templates/
│   └── ... (plantillas de configuración)
└── tests/
    └── ... (tests del módulo)
```

### 7.3 Formato `module.toml`

```toml
[module]
id = "lnos-gaming"
version = "1.0.0"
name = "LNOS Gaming Module"
description = "Optimizaciones para gaming: GameMode, MangoHud, Steam"
license = "MIT"
author = "LNOS Team"

[dependencies]
modules = ["lnos-base", "lnos-hyprland"]
packages = [
    "steam",
    "gamemode",
    "lib32-gamemode",
    "mangohud",
    "lib32-mangohud",
    "lutris",
    "wine",
    "winetricks",
]

[conflicts]
modules = []
packages = []

[config]
game_mode.enabled = true
mangohud.enabled = true
mangohud.show_fps = true
mangohud.show_temp = true
steam.runtime = "native"  # native, flatpak, container

[arch]
supported = ["x86_64"]
```

### 7.4 Sistema de resolución de dependencias

El gestor de módulos implementa un resolvedor de dependencias basado en SAT (Satisfiability), similar al de Pacman pero para módulos:

1. Lee `module.toml` de todos los módulos disponibles.
2. Construye un grafo de dependencias dirigido acíclico (DAG).
3. Detecta ciclos y los reporta como error.
4. Resuelve el orden de instalación/actualización mediante orden topológico.
5. Verifica conflictos con módulos ya instalados.

**Algoritmo:**

```
function resolve(module_list):
    graph = build_dependency_graph(module_list)
    if has_cycles(graph):
        report_cycles()
        return error
    order = topological_sort(graph)
    for module in order:
        if not satisfies_dependencies(module):
            report_missing(module)
            return error
    return order
```

### 7.5 Estados de un módulo

| Estado | Descripción |
|---|---|
| `available` | Disponible en repositorio, no instalado |
| `installed` | Paquetes instalados, configuración no aplicada |
| `configured` | Configuración aplicada y activa |
| `disabled` | Instalado pero desactivado (configuración no aplicada) |
| `broken` | Dependencia faltante o configuración corrupta |
| `updatable` | Versión más reciente disponible |

### 7.6 Transacciones de módulos

Toda operación sobre módulos es transaccional:

1. **Fase de preparación:** Verificar dependencias, espacio en disco, permisos.
2. **Fase de ejecución:** Ejecutar hooks, instalar paquetes, copiar archivos.
3. **Fase de commit:** Marcar módulo como instalado/actualizado.
4. **Fase de rollback:** En caso de error, revertir a estado anterior.

Si cualquier paso falla, la transacción completa se deshace.

### 7.7 Módulos base (core)

| ID | Descripción | Dependencias |
|---|---|---|
| `lnos-base` | Sistema mínimo: kernel, systemd, firmware, shell | — |
| `lnos-base-devel` | Herramientas de compilación: base-devel, git | lnos-base |
| `lnos-boot` | systemd-boot, Secure Boot, microcode | lnos-base |
| `lnos-storage` | Btrfs, LUKS2, Timeshift, snapshots | lnos-base |
| `lnos-security` | AppArmor, nftables, firewalld, fail2ban | lnos-base |
| `lnos-network` | NetworkManager, iwd, dhcpcd, DNS | lnos-base |
| `lnos-audio` | PipeWire, WirePlumber, ALSA, PulseAudio compat | lnos-base |
| `lnos-bluetooth` | BlueZ, bluetoothctl, blueman | lnos-base |
| `lnos-printing` | CUPS, drivers printer, avahi | lnos-base |

### 7.8 Módulos de experiencia (desktop)

| ID | Descripción | Dependencias |
|---|---|---|
| `lnos-hyprland` | Hyprland, Waybar, Rofi, Dunst, lockscreen | lnos-base |
| `lnos-hyprland-extras` | Hyprpaper, hyprlock, hypridle, wlogout | lnos-hyprland |
| `lnos-gtk` | GTK3/4 con tema, iconos, cursores, fuentes | lnos-hyprland |
| `lnos-qt` | QT5/6 con tema, integración Wayland | lnos-hyprland |
| `lnos-fonts` | Fuentes tipográficas completas | lnos-base |
| `lnos-wallpapers` | Colección de wallpapers oficiales | lnos-hyprland |

### 7.9 Módulos funcionales

| ID | Descripción | Dependencias |
|---|---|---|
| `lnos-gaming` | Steam, Lutris, GameMode, MangoHud | lnos-hyprland, lnos-gpu |
| `lnos-gpu-intel` | Drivers Intel, VA-API, Vulkan Intel | lnos-base |
| `lnos-gpu-amd` | Mesa AMD, RADV, ROCm, VA-API AMD | lnos-base |
| `lnos-gpu-nvidia` | nvidia-open, nvidia-utils, CUDA | lnos-base |
| `lnos-dev` | Toolchains, git, compiladores, contenedores | lnos-base |
| `lnos-dev-python` | Python, pip, poetry, pyenv | lnos-dev |
| `lnos-dev-node` | Node.js, npm, yarn, nvm | lnos-dev |
| `lnos-dev-rust` | Rust, cargo, rustup, clippy | lnos-dev |
| `lnos-dev-go` | Go, golangci-lint, delve | lnos-dev |
| `lnos-docker` | Docker, docker-compose, containerd | lnos-dev |
| `lnos-podman` | Podman, podman-compose, buildah | lnos-dev |
| `lnos-virtualization` | KVM, QEMU, libvirt, virt-manager | lnos-base |
| `lnos-flatpak` | Flatpak, flathub, flatpak-builder | lnos-base |

### 7.10 Módulos de aplicación

| ID | Descripción | Dependencias |
|---|---|---|
| `lnos-browser-firefox` | Firefox hardenizado | lnos-hyprland |
| `lnos-browser-chromium` | Chromium o Ungoogled Chromium | lnos-hyprland |
| `lnos-office` | LibreOffice, OnlyOffice, PDF tools | lnos-hyprland |
| `lnos-media` | VLC, MPV, GIMP, Inkscape, Blender | lnos-hyprland |
| `lnos-cloud` | Nextcloud client, rclone, gdrive | lnos-base |
| `lnos-sync` | Syncthing, rsync, cron | lnos-base |

### 7.11 Gestor de módulos: `lnos-mod`

El gestor de módulos es una herramienta CLI llamada `lnos-mod` y una API D-Bus (para uso desde el centro de control).

**Comandos CLI:**

```
lnos-mod list                     # Listar módulos disponibles
lnos-mod list --installed         # Listar módulos instalados
lnos-mod info <module>            # Información detallada
lnos-mod install <module> [...]   # Instalar módulos
lnos-mod remove <module> [...]    # Desinstalar módulos
lnos-mod update <module> [...]    # Actualizar módulos
lnos-mod update --all             # Actualizar todos
lnos-mod enable <module>          # Activar módulo
lnos-mod disable <module>         # Desactivar módulo
lnos-mod status <module>          # Ver estado
lnos-mod check                    # Verificar integridad
lnos-mod export                   # Exportar lista de módulos
lnos-mod import <file>            # Importar lista de módulos
```

**API D-Bus:**

```
Interface: org.lnos.ModuleManager
Methods:
    - ListModules(installed: bool) → Array<ModuleInfo>
    - GetModuleInfo(id: string) → ModuleInfo
    - InstallModules(ids: Array<string>) → TransactionResult
    - RemoveModules(ids: Array<string>) → TransactionResult
    - UpdateModules(ids: Array<string>) → TransactionResult
    - UpdateAllModules() → TransactionResult
    - EnableModule(id: string) → boolean
    - DisableModule(id: string) → boolean
    - GetModuleStatus(id: string) → ModuleStatus
    - CheckIntegrity() → Array<IntegrityIssue>
    - ExportModuleList() → string
    - ImportModuleList(data: string) → TransactionResult
Signals:
    - ModuleInstalled(id: string, version: string)
    - ModuleRemoved(id: string)
    - ModuleUpdated(id: string, old_ver: string, new_ver: string)
    - TransactionError(id: string, error: string)
    - IntegrityWarning(issue: IntegrityIssue)
```

### 7.12 Repositorio de módulos

Los módulos se distribuyen mediante:

1. **Repositorio Git oficial:** `github.com/lnos/modules`
2. **Paquete Arch individual:** Cada módulo puede ser un paquete Arch (`lnos-module-<name>`).
3. **Repositorio de módulos de la comunidad:** Similar a AUR pero para módulos LNOS.

### 7.13 Consideraciones de seguridad en módulos

- Los hooks se ejecutan con privilegios mínimos (systemd dynamic user).
- Los módulos de terceros requieren aprobación explícita del usuario.
- Cada módulo tiene un hash de integridad verificado antes de la instalación.
- Los hooks no pueden ejecutar código arbitrario fuera de su directorio temporal.

---

## 8. Estructura del Repositorio

### 8.1 Repositorio principal

```
lnos/
├── README.md
├── LICENSE
├── CONTRIBUTING.md
├── CODE_OF_CONDUCT.md
├── SECURITY.md
│
├── docs/                          # Documentación
│   ├── SPECIFICATION.md           # Este documento
│   ├── ARCHITECTURE.md            # Visión arquitectónica
│   ├── INSTALL.md                 # Guía de instalación
│   ├── CONTRIBUTE.md              # Guía de contribución
│   ├── MODULES.md                 # Desarrollo de módulos
│   ├── STYLEGUIDE.md              # Guía de estilo
│   ├── SECURITY.md                # Política de seguridad
│   ├── i18n/                      # Documentación traducida
│   │   ├── es/
│   │   ├── de/
│   │   ├── fr/
│   │   ├── zh/
│   │   └── ...
│   └── man/                       # Páginas de manual
│       ├── lnos-mod.8
│       ├── lnos-config.8
│       ├── lnos-welcome.8
│       └── ...
│
├── src/                           # Código fuente de herramientas LNOS
│   ├── lnos-mod/                  # Gestor de módulos
│   │   ├── Cargo.toml
│   │   └── src/
│   │       ├── main.rs
│   │       ├── module.rs
│   │       ├── resolver.rs
│   │       ├── transaction.rs
│   │       ├── dbus.rs
│   │       └── cli.rs
│   ├── lnos-config/               # Centro de configuración
│   │   ├── Cargo.toml
│   │   ├── src/
│   │   ├── gui/                   # Frontend GTK4
│   │   └── resources/
│   ├── lnos-welcome/              # Asistente de bienvenida
│   │   ├── Cargo.toml
│   │   └── src/
│   ├── lnos-software/             # Centro de software
│   │   ├── Cargo.toml
│   │   └── src/
│   ├── liblnos/                   # Librería compartida LNOS
│   │   ├── Cargo.toml
│   │   └── src/
│   │       ├── lib.rs
│   │       ├── config.rs
│   │       ├── module.rs
│   │       ├── dbus.rs
│   │       └── i18n.rs
│   └── tools/                     # Herramientas auxiliares
│       ├── lnos-bench/
│       ├── lnos-backup/
│       ├── lnos-recovery/
│       └── lnos-firstrun/
│
├── modules/                       # Definición de módulos oficiales
│   ├── base/
│   │   ├── module.toml
│   │   ├── hooks/
│   │   ├── files/
│   │   └── tests/
│   ├── hyprland/
│   │   ├── module.toml
│   │   ├── hooks/
│   │   ├── files/
│   │   │   ├── hyprland.conf
│   │   │   ├── waybar/
│   │   │   ├── rofi/
│   │   │   └── dunst/
│   │   └── tests/
│   ├── gaming/
│   ├── gpu-intel/
│   ├── gpu-amd/
│   ├── gpu-nvidia/
│   ├── dev/
│   ├── docker/
│   ├── podman/
│   ├── flatpak/
│   ├── printing/
│   ├── bluetooth/
│   ├── audio/
│   ├── security/
│   ├── fonts/
│   ├── gtk/
│   ├── qt/
│   ├── cloud/
│   └── virtualization/
│
├── iso/                           # Configuración de generación de ISO
│   ├── default/
│   │   ├── pacman.conf
│   │   ├── mkarchiso profile/
│   │   └── efi/
│   ├── minimal/
│   ├── desktop/
│   └── gaming/
│
├── scripts/                       # Scripts de automatización
│   ├── build-iso.sh
│   ├── build-modules.sh
│   ├── update-pkgbuilds.sh
│   └── generate-docs.sh
│
├── pkg/                           # PKGBUILDs para paquetes LNOS
│   ├── lnos-mod/
│   │   └── PKGBUILD
│   ├── lnos-config/
│   │   └── PKGBUILD
│   └── ...
│
├── tests/                         # Tests de integración y sistema
│   ├── integration/
│   │   ├── test_module_install.py
│   │   ├── test_config_api.py
│   │   └── test_dbus.py
│   ├── e2e/
│   │   ├── test_install_iso.py
│   │   ├── test_hyprland_config.py
│   │   └── test_snapshot_rollback.py
│   └── fixtures/
│
├── ci/                            # Configuración de CI/CD
│   ├── Dockerfile.test
│   ├── docker-compose.test.yml
│   ├── build.yml
│   └── test.yml
│
├── branding/                      # Recursos de marca
│   ├── logo/
│   │   ├── lnos-logo.svg
│   │   ├── lnos-logo-256.png
│   │   └── lnos-logo.iconset/
│   ├── wallpaper/
│   │   ├── default.png
│   │   ├── dark.png
│   │   └── light.png
│   ├── grub/
│   ├── plymouth/
│   └── iso/
│
└── .github/
    ├── workflows/
    │   ├── build.yml
    │   ├── test.yml
    │   ├── lint.yml
    │   ├── docs.yml
    │   └── release.yml
    ├── ISSUE_TEMPLATE/
    ├── PULL_REQUEST_TEMPLATE.md
    └── CODEOWNERS
```

### 8.2 Repositorios satélite

| Repositorio | Propósito |
|---|---|
| `github.com/lnos/lnos` | Principal (arriba) |
| `github.com/lnos/modules-community` | Módulos creados por la comunidad |
| `github.com/lnos/packages` | PKGBUILDs de paquetes LNOS en AUR |
| `github.com/lnos/iso-releases` | ISOs compilados y firmados |
| `github.com/lnos/website` | Página web del proyecto |
| `github.com/lnos/wiki` | Wiki de documentación de usuario |

### 8.3 Política de versiones en repositorios

- `main`: Estable, solo CI/CD y revisiones de seguridad.
- `develop`: Integración, rama por defecto para PRs.
- `release/<version>`: Preparación de release.
- `feature/<name>`: Ramas de características.
- `fix/<issue-id>-<desc>`: Ramas de corrección.
- `docs/<desc>`: Ramas de documentación.

---

## 9. Sistema de Compilación

### 9.1 Lenguajes y herramientas

| Componente | Lenguaje | Compilador/Build | Justificación |
|---|---|---|---|
| `lnos-mod` | Rust | Cargo | Rendimiento, seguridad de memoria, tipado fuerte |
| `lnos-config` | Rust + GTK4 | Cargo + blueprint | Renderizado nativo, bindings GTK4 maduros |
| `lnos-software` | Rust + GTK4 | Cargo + blueprint | Misma base que lnos-config |
| `lnos-welcome` | Rust + GTK4 | Cargo + blueprint | Reutilización de componentes |
| `liblnos` | Rust | Cargo | Librería compartida, FFI segura |
| Herramientas CLI | Rust | Cargo | Consistencia con el resto |
| Herramientas GUI | Rust + GTK4 | Cargo | Rendimiento, integración Wayland |
| Scripts CI | Python/Bash | — | Automatización, legibilidad |
| Tests | Python (pytest) | pytest | Amplio ecosistema de testing |

**Razón para elegir Rust sobre otras opciones:**
- **Go:** Bueno para CLI pero pobre para GUI, GC añade latencia.
- **Python:** Demasiado lento para herramientas del sistema, dependencia de intérprete.
- **C++:** Potente pero inseguro en memoria, compilación lenta, desarrollo más lento.
- **Rust:** Rendimiento de C++, seguridad de memoria, ecosistema creciente, integración con GTK4.

### 9.2 Sistema de compilación de paquetes

Para los paquetes Arch Linux de LNOS se utiliza `makepkg` estándar, pero con las siguientes extensiones:

1. **Firma de paquetes:** Todos los paquetes oficiales LNOS van firmados con GPG.
2. **Reproducibilidad:** Los PKGBUILD deben producir paquetes reproducibles (mismo hash para mismo código fuente).
3. **Cache compartido:** `ccache` y `sccache` para acelerar compilaciones en CI.
4. **Validación de checksums:** SHA-256 verificados contra upstream.

### 9.3 Compilación de la ISO

La ISO se genera mediante `mkarchiso` (de archiso), con perfiles personalizados:

```
iso/
├── <profile>/
│   ├── profiledef.sh           # Definición del perfil
│   ├── pacman.conf             # Configuración de pacman para la ISO
│   ├── packages.x86_64         # Lista de paquetes
│   ├── packages.x86_64.single  # Paquetes para single-user
│   ├── efiboot/
│   │   ├── loader/
│   │   │   └── entries/
│   │   │       └── arch.conf   # Entrada de arranque UEFI
│   │   └── EFI/
│   │       └── boot/
│   │           └── bootx64.efi
│   ├── grub/
│   │   └── ...
│   ├── sysprep/
│   │   └── ...
│   ├── root-image/
│   │   ├── customize-image.sh  # Script de personalización
│   │   └── usr/
│   │       └── ...
│   └── branding/
│       ├── splash.png
│       └── ...
```

### 9.4 Perfiles de ISO

| Perfil | Contenido | Tamaño estimado |
|---|---|---|
| `minimal` | Solo base + network + ssh | ~800 MB |
| `desktop` | Base + Hyprland + herramientas | ~2.5 GB |
| `gaming` | Desktop + gaming + drivers NVIDIA | ~4 GB |

### 9.5 Pipeline de compilación

```
1. Clonar repositorio
       │
       ▼
2. Verificar firmas Git
       │
       ▼
3. Compilar lnos-mod (cargo build --release)
       │
       ▼
4. Compilar lnos-config (cargo build --release)
       │
       ▼
5. Compilar lnos-software (cargo build --release)
       │
       ▼
6. Compilar liblnos (cargo build --release)
       │
       ▼
7. Empaquetar como PKGBUILD (makepkg)
       │
       ▼
8. Firmar paquetes (gpg --sign)
       │
       ▼
9. Generar ISO (mkarchiso)
       │
       ▼
10. Firmar ISO (gpg --detach-sign)
       │
       ▼
11. Calcular checksums (sha256sum)
       │
       ▼
12. Publicar ISO + firmas + checksums
```

### 9.6 Requisitos de compilación

| Herramienta | Versión mínima | Propósito |
|---|---|---|
| Rust | 1.75+ | Compilación de herramientas LNOS |
| cargo | 1.75+ | Build system Rust |
| makepkg | 6.0+ | Build de paquetes Arch |
| archiso | 75+ | Generación de ISO |
| gpg | 2.4+ | Firmado de paquetes/ISO |
| git | 2.40+ | Control de versiones |
| python | 3.11+ | Scripts CI/testing |
| pytest | 7+ | Testing |
| podman/docker | — | Entornos de CI reproducibles |

---

## 10. Sistema de Generación de ISO

### 10.1 Propósito

El sistema de generación de ISO produce imágenes de instalación booteables que contienen el sistema LNOS completo listo para ser instalado.

### 10.2 Flujo de trabajo

```
make-iso.sh [profile] [--version X.Y.Z]
```

El script `build-iso.sh`:

1. Verifica que todas las herramientas de compilación están presentes.
2. Configura un entorno chroot limpio usando `mkarchiso`.
3. Instala los paquetes base de Arch Linux + paquetes LNOS.
4. Aplica configuraciones personalizadas del perfil.
5. Genera el initramfs, la imagen del kernel y el cargador de arranque.
6. Empaqueta todo en una ISO híbrida (UEFI + BIOS).
7. Firma la ISO y genera checksums.

### 10.3 Estructura de la ISO

```
LNOS-<version>-<profile>.iso
├── [BOOT]
│   └── Boot-NoEmul.img
├── EFI/
│   ├── BOOT/
│   │   └── BOOTx64.EFI
│   └── systemd/
│       └── systemd-bootx64.efi
├── loader/
│   ├── entries/
│   │   ├── arch-x86_64.conf
│   │   ├── arch-x86_64.conf
│   │   └── arch-x86_64-desktop.conf
│   └── loader.conf
├── kernel/
│   └── vmlinuz-x86_64
├── initramfs/
│   └── initramfs-x86_64.img
├── grub/
│   └── ...
├── arch/
│   ├── pkglist.x86_64.txt
│   └── x86_64/
│       └── airootfs.sfs           # SquashFS del sistema raíz
└── lnos/
    ├── version.txt
    ├── modules.txt
    └── sha256sums.txt
```

### 10.4 Contenido de `airootfs.sfs`

El sistema de archivos raíz comprimido (SquashFS) contiene:

- Todos los paquetes base de Arch Linux seleccionados.
- Todas las herramientas LNOS precompiladas.
- Configuración por defecto de módulos base.
- Script `lnos-installer` en `/usr/bin/`.
- Configuración de red (NetworkManager, iwd).
- Configuración regional (locale, console font, keymap).
- Servicios systemd habilitados.

### 10.5 Instalador en vivo

La ISO arranca en un entorno live que ofrece:

1. **Selección de idioma** (teclado, locale, zona horaria).
2. **Selección de perfil de instalación** (minimal, desktop, gaming, custom).
3. **Particionado** (automático o manual).
4. **Selección de módulos** adicionales.
5. **Configuración de usuario** (nombre, contraseña, hostname).
6. **Resumen** antes de instalar.
7. **Instalación** con barra de progreso.
8. **Reinicio** opcional.

### 10.6 Opciones de arranque

| Opción | Descripción |
|---|---|
| `lnos.install` | Iniciar instalador gráfico |
| `lnos.install.auto` | Instalación no interactiva (preseed) |
| `lnos.rescue` | Modo rescate (shell root) |
| `lnos.memtest` | Test de memoria |
| `lnos.nvidia` | Cargar drivers NVIDIA en live |
| `lnos.noswap` | No activar swap |
| `lnos.ssh` | Activar SSH en live (con contraseña temporal) |
| `lnos.debug` | Shell de depuración en cada paso |

---

## 11. Herramientas Utilizadas

### 11.1 Lenguajes de programación

LNOS emplea tres lenguajes de programación con roles claramente diferenciados:

| Lenguaje | Rol | Componentes |
|---|---|---|
| Rust | Herramientas del sistema, librerías, GUI | `lnos-mod`, `lnos-config`, `liblnos` |
| Python | Automatización, testing, scripts CI | Tests, scripts de build, generación de documentación |
| Bash | Scripts de shell, hooks de módulos, initramfs | `customize-image.sh`, hooks pre/post-install |

### 11.2 Rust: justificación frente a alternativas

**11.2.1 ¿Para qué existe?**

Rust es el lenguaje principal de LNOS para todo el código de infraestructura: gestor de módulos, centro de configuración, centro de software, librería compartida, herramientas CLI y cualquier componente que requiera rendimiento, seguridad de memoria y mantenibilidad a largo plazo.

**11.2.2 ¿Por qué se ha elegido?**

Rust ofrece la combinación única de:
- **Rendimiento nativo** (comparable a C/C++) sin runtime ni garbage collector.
- **Seguridad de memoria garantizada** en tiempo de compilación, eliminando clases enteras de vulnerabilidades (use-after-free, buffer overflows, data races).
- **Tipado fuerte** con inferencia, pattern matching y genéricos que permiten expresar invariantes del sistema en el tipo.
- **Ecosistema moderno** con Cargo (build system, dependencias, testing, documentación), crates.io y herramientas como clippy y rustfmt.
- **FFI segura** con C, permitiendo integrar bibliotecas del sistema (GTK4, systemd, D-Bus) mediante bindings seguros.
- **Módulos y traits** que facilitan la arquitectura modular del sistema.
- **Herencia nula** de C++: no arrastra décadas de decisiones de diseño obsoletas.

**11.2.3 ¿Qué alternativas existen y por qué se descartan?**

| Lenguaje | Ventajas | Problemas para LNOS |
|---|---|---|
| **C++** | Rendimiento máximo, ecosistema maduro | Inseguro en memoria, compilación lenta, ABI inestable, desarrollo propenso a errores |
| **Go** | Sencillez, concurrencia nativa, compilación rápida | GC añade latencia impredecible, pobre integración GUI, sin FFI segura |
| **Python** | Productividad máxima, amplio ecosistema | Demasiado lento para herramientas del sistema, requiere runtime, sin tipado estático real |
| **C** | Ubicuidad, rendimiento, mínimo runtime | Sin abstracciones modernas, gestión manual de memoria, inseguro |
| **Zig** | Moderno, sin GC, buen FFI | Ecosistema demasiado pequeño, pocas bibliotecas, comunidad emergente |
| **Zig** (alternativa) | Prometedor pero no maduro para 2026 | Misma razón: ecosistema insuficiente |

**11.2.4 ¿Cómo se comunica con el resto del sistema?**

- **D-Bus**: Las herramientas Rust se registran en el bus del sistema (`org.lnos.*`) para comunicación entre procesos.
- **FFI con C**: A través de `liblnos` (librería compartida `.so`) que expone una API C estable para ser usada desde Python, Bash o C.
- **systemd**: Las herramientas Rust se integran como servicios systemd o se comunican mediante `sd-bus` (bindings `zbus`).
- **GTK4**: Mediante `gtk4-rs`, bindings seguros de Rust para GTK4.
- **CLI estándar**: Las herramientas CLI Rust siguen la convención de argumentos POSIX y salida estructurada (JSON opcional mediante `--json`).

**11.2.5 ¿Qué dependencias tiene?**

- **Rust toolchain**: `rustc`, `cargo`, `rustup` (versión mínima 1.75+).
- **Crates principales**: `clap` (CLI), `zbus` (D-Bus), `serde` (serialización), `toml` (configuración), `gtk4-rs` (GUI), `tokio` (async), `anyhow`/`thiserror` (errores).
- **Bibliotecas del sistema**: `glibc`, `libsystemd`, `libdbus-1`, `libgtk-4`, `pkg-config`.

**11.2.6 ¿Qué problemas puede producir y cómo se mitigan?**

| Problema | Mitigación |
|---|---|
| Compilación lenta | Uso de `sccache` (cache distribuido), compilaciones incrementales, dependencias mínimas |
| Binarios grandes | LTO (`-C link-attr=yes`), stripping, `upx` opcional para CI |
| Curva de aprendizaje | Documentación interna, style guide, code review obligatorio |
| Ecosistema cambiante | Pin versiones de crates en `Cargo.lock`, updates controlados |

**11.2.7 ¿Cómo se prueba?**

- Tests unitarios: `cargo test` en cada crate.
- Tests de integración: tests que ejercitan la API D-Bus completa.
- Fuzzing: `cargo-fuzz` para parsing de configuración.
- Linting: `cargo clippy` con configuración estricta.
- Cobertura: `tarpaulin` o `cargo-llvm-cov`.
- Benchmarks: `criterion` para partes críticas.

**11.2.8 ¿Cómo se mantiene?**

- `rustup update` en CI para seguir el canal estable.
- `cargo update` periódico para dependencias.
- Deprecación de crates evaluada en cada release.
- Revisión semestral de patrones Rust obsoletos.

**11.2.9 ¿Cómo puede ampliarse?**

- Nuevos crates dentro del workspace `Cargo.toml` del repositorio.
- Bindings adicionales para bibliotecas del sistema mediante `-sys` crates.
- Plugins Rust mediante carga dinámica de bibliotecas (FFI con `libloading`).

### 11.3 Python: rol y justificación

**11.3.1 ¿Para qué existe?**

Python se utiliza exclusivamente para:
- Scripts de automatización del build system (`build-iso.sh` no es Bash puro; la lógica compleja está en Python).
- Tests de integración y sistema (`pytest`).
- Generación de documentación (`mkdocs`, `sphinx`).
- Herramientas de desarrollo internas (generación de módulos, validación de configuraciones).

**11.3.2 ¿Por qué se ha elegido?**

Python es el estándar de facto para scripting de automatización en el ecosistema Linux. Su sintaxis legible, su amplio ecosistema de bibliotecas (`pytest`, `click`, `toml`, `requests`) y su disponibilidad en cualquier sistema lo convierten en la opción obvia para tareas que no requieren rendimiento crítico.

**11.3.3 ¿Qué alternativas existen y por qué se descartan?**

| Alternativa | Motivo de descarte |
|---|---|
| Ruby | Menos común en entornos Linux, ecosistema más pequeño |
| Lua | Demasiado limitado para lógica compleja de testing |
| JavaScript/Node | Dependencia de runtime pesado, diseño asíncrono complejo |
| Bash exclusivo | Mantenibilidad pobre para lógica no trivial |

**11.3.4 ¿Cómo se comunica con el resto del sistema?**

- Subprocess calls a herramientas CLI Rust.
- Lectura/escritura de archivos de configuración en `/etc/lnos/`.
- D-Bus mediante `pydbus` o `dasbus` para monitorización de servicios.
- API REST de `lnos-config` para tests de integración.

**11.3.5 ¿Qué dependencias tiene?**

- Python 3.11+.
- Paquetes pip: `pytest`, `pytest-cov`, `pytest-xdist`, `toml`, `click`, `dasbus`, `requests`.
- Solo en entornos de desarrollo/CI, no en el sistema final.

**11.3.6 ¿Qué problemas puede producir y cómo se mitigan?**

| Problema | Mitigación |
|---|---|
| Dependencias pip rotas | Entornos virtuales (`venv`) en CI, lockfiles (`requirements.txt`) |
| Diferencias entre versiones Python | Test matrix con 3.11, 3.12, 3.13 |
| Rendimiento lento en tests | Paralelización con `pytest-xdist`, timeout en tests |

**11.3.7 ¿Cómo se prueba?**

Los scripts Python se prueban con `pytest`; no se utiliza Python en producción, solo en desarrollo/CI.

**11.3.8 ¿Cómo se mantiene?**

- `pip-compile` para mantener requirements actualizados.
- `ruff` para linting.
- `mypy` para tipado estático opcional.

**11.3.9 ¿Cómo puede ampliarse?**

Nuevos scripts Python pueden añadirse en `scripts/` y `tests/` siguiendo la estructura existente.

### 11.4 Bash: rol y justificación

**11.4.1 ¿Para qué existe?**

Bash se utiliza para:
- Scripts de shell de los hooks de módulos (`pre-install`, `post-install`, etc.).
- Scripts de personalización de la ISO (`customize-image.sh`).
- Scripts de inicio del instalador live.
- Wrappers de automatización simples.

**11.4.2 ¿Por qué se ha elegido?**

Bash es el shell nativo de Linux, presente en cualquier instalación. Para scripts cortos de orquestación (instalar paquetes, copiar archivos, ejecutar comandos), Bash es la herramienta más directa y con menor sobrecarga.

**11.4.3 ¿Qué alternativas existen y por qué se descartan?**

| Alternativa | Motivo de descarte |
|---|---|
| Python | Sobrecarga de interpreter para scripts triviales |
| Rust | Compilación necesaria, no apropiado para scripts ad-hoc |
| POSIX sh | Limitaciones de sintaxis, arrays, funciones |

**11.4.4 ¿Cómo se comunica con el resto del sistema?**

- Ejecución directa de comandos del sistema.
- Invocación de herramientas CLI Rust.
- Lectura/escritura de archivos de configuración.
- Variables de entorno para paso de parámetros.

**11.4.5 ¿Qué dependencias tiene?**

- `bash` 5.0+ (incluido en cualquier instalación Arch Linux).
- `coreutils`, `findutils`, `grep`, `sed`, `awk` (estándar POSIX).

**11.4.6 ¿Qué problemas puede producir y cómo se mitigan?**

| Problema | Mitigación |
|---|---|
| Errores silenciosos | `set -euo pipefail` en todos los scripts |
| Código frágil | `shellcheck` obligatorio en CI |
| Falta de tipado | Variables con nombres descriptivos, validación de entrada |
| Dependencia de comandos externos | Verificación de disponibilidad antes de usar |

**11.4.7 ¿Cómo se prueba?**

- `shellcheck` para análisis estático.
- `bats` (Bash Automated Testing System) para scripts complejos.
- Tests de integración que ejecutan hooks en contenedores.

**11.4.8 ¿Cómo se mantiene?**

- `shfmt` para formateo consistente.
- Máxima longitud de línea: 80 caracteres.
- Documentación de cada función con `# Description:`.

**11.4.9 ¿Cómo puede ampliarse?**

Nuevos hooks Bash siguen la plantilla de `modules/<id>/hooks/` con funciones separadas por responsabilidad.

### 11.5 GTK4 + Blueprint

**11.5.1 ¿Para qué existe?**

GTK4 + Blueprint es el toolkit de interfaz gráfica para todas las aplicaciones LNOS: instalador, centro de configuración, centro de software y asistente de bienvenida.

**11.5.2 ¿Por qué se ha elegido?**

| Razón | Detalle |
|---|---|
| Nativo Wayland | GTK4 tiene soporte Wayland de primera clase, renderizado directo |
| Rendimiento | Renderizado GPU acelerado, bajo consumo de RAM comparado con Electron |
| Blueprint | Lenguaje de descripción de UI compilado a GTK4 Builder XML, más legible y mantenible |
| Bindings Rust | `gtk4-rs` proporciona bindings seguros y completos |
| Tema nativo | Adaptación automática al tema del sistema (adwaita o tema LNOS) |
| Accesibilidad | Soporte integrado de a11y, AT-SPI, lectores de pantalla |

**11.5.3 ¿Qué alternativas existen y por qué se descartan?**

| Alternativa | Motivo de descarte |
|---|---|
| **Qt 6** | Binding Rust inmaduros (`cxx-qt` en desarrollo), licencia LGPL con restricciones adicionales, mayor consumo de memoria |
| **Electron** | Basado en Chromium, 100-200 MB RAM por ventana, no nativo, sobreingeniería para apps de sistema |
| **Tauri** | Ideal para apps web, pero LNOS prefiere UIs nativas sin runtime web |
| **Slint** | Toolkit emergente, bonito pero ecosistema pequeño, pocos widgets |
| **ICED** | Puramente Rust, nativo, pero ecosistema de widgets aún inmaduro (2026) |
| **Terminal TUI** | No apropiado para centro de configuración y centro de software |

**11.5.4 ¿Cómo se comunica con el resto del sistema?**

- D-Bus: las aplicaciones GTK4 interactúan con los servicios del sistema mediante D-Bus.
- `liblnos` (FFI C/Rust): las apps cargan `liblnos` para operaciones del sistema.
- GSettings: almacenamiento de preferencias de usuario mediante dconf.
- Portal API: uso de portales XDG (FileChooser, Screenshot, etc.) para integración segura con el escritorio.

**11.5.5 ¿Qué dependencias tiene?**

- `gtk4`, `libadwaita` (o `libpanel` para apps de desarrollo).
- `blueprint-compiler` para compilar archivos `.blp` a `.ui`.
- `gtk4-rs` (crates `gtk4`, `gdk4`, `adw`).
- `gresource` para embeber recursos en el binario.

**11.5.6 ¿Qué problemas puede producir y cómo se mitigan?**

| Problema | Mitigación |
|---|---|
| Cambios en API GTK4 | Versionado semántico, pruebas en GTK4 estable |
| Blueprint en evolución | Congelar versión de blueprint-compiler en CI |
| Accesibilidad limitada | Tests con AT-SPI, revisión manual |
| Consumo de memoria | Perfilado con sysprof, optimización de widgets |

**11.5.7 ¿Cómo se prueba?**

- Tests de UI con `gtk4-test` y `dogtail` (accesibilidad).
- Tests de snapshot de widgets.
- Pruebas manuales en hardware real.

**11.5.8 ¿Cómo se mantiene?**

- Dependencias actualizadas mediante `cargo update`.
- Migración de widgets obsoletos guiada por deprecation warnings.
- Versionado de esquemas GSettings.

**11.5.9 ¿Cómo puede ampliarse?**

- Nuevos widgets Blueprint en `src/*/gui/`.
- Nuevos diálogos y asistentes siguiendo el patrón AdwNavigationView.
- Plugins gráficos mediante GObject introspection.

### 11.6 mkarchiso, pacman, makepkg

**11.6.1 ¿Para qué existen?**

- **mkarchiso**: Herramienta de archiso para generar ISOs booteables.
- **pacman**: Gestor de paquetes de Arch Linux.
- **makepkg**: Herramienta de compilación de paquetes Arch a partir de PKGBUILD.

**11.6.2 ¿Por qué se han elegido?**

Son las herramientas nativas de Arch Linux. Al derivar de Arch, usar su toolchain nativo garantiza compatibilidad total, aprovecha el conocimiento existente de la comunidad y evita mantener herramientas de build paralelas. mkarchiso es la herramienta estándar de la industria para generar ISOs Arch; cualquier alternativa requeriría reinventar la rueda.

**11.6.3 ¿Qué alternativas existen y por qué se descartan?**

| Alternativa | Motivo de descarte |
|---|---|
| **Debian Live Build** | Diseñado para Debian/Ubuntu, no para Arch |
| **Kiwi NG** | Herramienta de SUSE, sobrecarga de configuración |
| **Pacstall** | No es un gestor de paquetes oficial, ecosistema pequeño |
| **Calamares** | Instalador, no generador de ISOs; complementa pero no sustituye a mkarchiso |

**11.6.4 ¿Cómo se comunican con el resto del sistema?**

- mkarchiso lee perfiles en `iso/<profile>/`.
- pacman se configura mediante `pacman.conf` personalizado en la ISO.
- makepkg lee PKGBUILDs en `pkg/` y produce paquetes `.pkg.tar.zst`.
- Todos se invocan desde `build-iso.sh`.

**11.6.5 ¿Qué dependencias tienen?**

- `archiso` (mkarchiso) — instalado en el host de compilación.
- `pacman` — instalado en el host y dentro del chroot de la ISO.
- `makepkg` — parte de `pacman`.
- `base-devel` — grupo de paquetes necesario para makepkg.

**11.6.6 ¿Qué problemas puede producir y cómo se mitigan?**

| Problema | Mitigación |
|---|---|
| mkarchiso versiones incompatibles | Docker con versión fija de archiso |
| Pacman rompe transacción | `--noconfirm` controlado, validación previa |
| makepkg dependencias faltantes | `ci/` con entorno de compilación completo |
| Cache de paquetes inconsistente | `pacman -Scc` antes de cada build |

**11.6.7 ¿Cómo se prueba?**

- Build de prueba en CI.
- Verificación de que la ISO generada arranca en QEMU.
- Validación de integridad de la ISO (`sha256sum`, `gpg --verify`).

**11.6.8 ¿Cómo se mantiene?**

- Actualizaciones sincronizadas con los releases de archiso upstream.
- Perfiles versionados junto con el código fuente.

**11.6.9 ¿Cómo puede ampliarse?**

- Nuevos perfiles mkarchiso en `iso/<profile>/`.
- Nuevos PKGBUILDs en `pkg/<package>/`.
- Hooks de pacman personalizados en `pkg/hooks/`.

### 11.7 systemd, D-Bus

**11.7.1 ¿Para qué existen?**

- **systemd**: Init system, gestor de servicios, resolvedor DNS, temporizadores, journald, logind, udev, tmpfiles, sysusers, bootchart y oomd.
- **D-Bus**: Sistema de IPC (Inter-Process Communication) para comunicación entre procesos del escritorio y del sistema.

**11.7.2 ¿Por qué se han elegido?**

systemd es el init estándar de facto en Linux. Su integración profunda en el ecosistema Arch, su conjunto de herramientas unificado y su amplia adopción lo convierten en la opción obligada. D-Bus es el IPC estándar del escritorio Linux, utilizado por GTK, Qt, systemd y prácticamente todo el ecosistema.

**11.7.3 ¿Qué alternativas existen y por qué se descartan?**

| Alternativa | Motivo de descarte |
|---|---|
| **OpenRC** | No compatible con Arch Linux oficial, ecosistema pequeño |
| **runit** | Sin integración con logind, udev, resolved |
| **s6** | Demasiado minimalista, requiere supervisión manual |
| **Bus IPC (dbus)** | No hay alternativa real; kdbus fue rechazado |

**11.7.4 ¿Cómo se comunican con el resto del sistema?**

- systemd provee servicios D-Bus para logind, hostnamed, timedated, resolved.
- Las herramientas LNOS se comunican con systemd mediante `sd-bus` (zbus en Rust).
- D-Bus es el bus principal para señales y métodos entre componentes del escritorio.

**11.7.5 ¿Qué dependencias tiene?**

- `systemd`, `systemd-libs`, `dbus`, `dbus-broker` (opcional).
- `glibc` como dependencia base.

**11.7.6 ¿Qué problemas puede producir y cómo se mitigan?**

| Problema | Mitigación |
|---|---|
| Systemd actualizaciones rompen servicios | Testing en CI, snapshots Btrfs pre-update |
| D-Bus congestión | `dbus-broker` como reemplazo de dbus-daemon |
| Dependencia excesiva | No acoplar código a versiones específicas de systemd |
| Journald llena disco | Límite de tamaño configurado (`SystemMaxUse=500M`) |

**11.7.7 ¿Cómo se prueba?**

- `systemd-analyze verify` para unidades.
- Tests de integración que verifican estados de servicios.
- `busctl` para verificar interfaces D-Bus.

**11.7.8 ¿Cómo se mantiene?**

- Seguir releases upstream de systemd.
- Adaptar unidades a nuevas versiones (nombres de servicios, opciones deprecadas).

**11.7.9 ¿Cómo puede ampliarse?**

- Nuevas unidades systemd en `modules/<id>/files/usr/lib/systemd/system/`.
- Nuevos servicios D-Bus registrados en `org.lnos.*`.

### 11.8 Git, GitHub/GitLab

**11.8.1 ¿Para qué existen?**

Git es el sistema de control de versiones; GitHub/GitLab son las plataformas de alojamiento y colaboración.

**11.8.2 ¿Por qué se han elegido?**

Git es el VCS estándar de la industria. GitHub se elige como plataforma primaria por su ecosistema de CI/CD (GitHub Actions),社区的 omnipresencia y herramientas de colaboración (PRs, issues, discussions). GitLab se mantiene como espejo y alternativa si GitHub cambia sus condiciones.

**11.8.3 ¿Qué alternativas existen y por qué se descartan?**

| Alternativa | Motivo de descarte |
|---|---|
| **SourceHut** | Menos funcionalidades, comunidad pequeña |
| **Codeberg** | Bueno pero menor adopción y funcionalidades |
| **Self-hosted** | Coste de mantenimiento, sin justificación para MVP |

**11.8.4 ¿Cómo se comunican con el resto del sistema?**

- Git hooks para validación de commits (pre-commit: clippy, shellcheck).
- GitHub Actions para CI/CD.
- Webhooks para publicación automática de ISO.
- Git LFS para binarios grandes (wallpapers, ISOs).

**11.8.5 ¿Qué dependencias tiene?**

- `git` 2.40+.
- `git-lfs` para archivos binarios.
- Acceso a GitHub para CI y releases.

**11.8.6 ¿Qué problemas puede producir y cómo se mitigan?**

| Problema | Mitigación |
|---|---|
| Límites de GitHub Actions (minutos) | Auto-hosted runner para builds grandes |
| Dependencia de plataforma externa | Espejo GitLab automático, docs de migración |
| Git LFS costes | Solo para assets de release, no para desarrollo |

**11.8.7 ¿Cómo se prueba?**

Los workflows CI se prueban en ramas feature antes de mergear a develop.

**11.8.8 ¿Cómo se mantiene?**

- Dependencias de Actions versionadas mediante SHA commits.
- Revisión periódica de workflows obsoletos.

**11.8.9 ¿Cómo puede ampliarse?**

- Nuevos workflows en `.github/workflows/`.
- Nuevos templates de issues y PRs.
- Acciones reutilizables en `actions/`.

---

## 12. Organización del Proyecto

### 12.1 ¿Para qué existe?

La organización del proyecto define la estructura de gobierno, los procesos de toma de decisiones y el marco de colaboración que permiten que LNOS sea mantenible a largo plazo por un equipo distribuido.

### 12.2 Roles del equipo

| Rol | Responsabilidades | Requisitos |
|---|---|---|
| **Arquitecto** | Decisiones técnicas globales, RFCs, revisiones de diseño | 5+ años en Linux, experiencia en distros |
| **Mantenedor de módulos** | Mantener módulos específicos, revisar PRs relacionados | Conocimiento del dominio del módulo |
| **Mantenedor de CI/CD** | Pipelines, releases, infraestructura | DevOps/SRE experience |
| **Mantenedor de documentación** | Wiki, SPECIFICATION.md, guías | Technical writing |
| **Mantenedor de seguridad** | Vulnerabilidades, AppArmor, audit | Seguridad Linux |
| **Desarrollador** | Implementación de features y fixes | Contribuciones activas |
| **Tester/QA** | Validación manual y automatizada | Testing methodology |
| **Community Manager** | Issues, discussions, onboarding | Comunicación |

### 12.3 Cómo se toman decisiones

Las decisiones se toman mediante un sistema de consenso aproximado (lazy consensus):

1. **RFC (Request for Comments):** Para cambios arquitectónicos significativos.
2. **Issue discusión:** Para bugs y features menores.
3. **Code review:** Para cambios de implementación.
4. **Voto del equipo:** Para decisiones que no alcanzan consenso (mayoría simple).

```
Flujo de decisión:
┌─────────────┐   ┌──────────────┐   ┌───────────────┐
│ Cambio menor│   │ RFC          │   │ Emergencia    │
│ → PR directo │   │ → Discusión  │   │ → Acción +    │
│ → Review     │   │ → Consenso   │   │   Reporte     │
└─────────────┘   └──────────────┘   └───────────────┘
```

### 12.4 Proceso de RFC

Las RFCs se utilizan para cambios que afectan a la arquitectura, interfaz pública, o decisiones de diseño significativas.

**Formato de RFC:**
```
RFC-NNNN: Título descriptivo
Estado: [Borrador | En discusión | Aprobada | Rechazada | Implementada]
Autor: Nombre
Fecha: YYYY-MM-DD

Resumen ejecutivo
Motivación
Diseño propuesto
Alternativas consideradas
Impacto en módulos existentes
Migración (si aplica)
```

**Ciclo de vida:**
1. Crear archivo `docs/rfc/NNNN-titulo.md`.
2. Abrir PR marcado como `rfc`.
3. Período de discusión mínimo: 7 días.
4. Decisión por el equipo de arquitectos.
5. Actualizar estado y mergear/rechazar.

### 12.5 Código de conducta

LNOS adopta el **Contributor Covenant v2.1** como código de conducta. Se espera que todos los participantes:

- Sean respetuosos y profesionales.
- Acepten críticas constructivas.
- Se centren en lo que es mejor para la comunidad.
- Muestren empatía hacia otros miembros.

Las violaciones se reportan al equipo de mantenedores y se resuelven de forma privada.

### 12.6 Contribuciones

**¿Cómo contribuir?**

1. Leer `CONTRIBUTING.md`.
2. Buscar issues etiquetados como `good-first-issue` o `help-wanted`.
3. Hacer fork del repositorio.
4. Crear rama siguiendo la convención de nombres.
5. Desarrollar siguiendo las convenciones del capítulo 13.
6. Abrir PR contra `develop`.
7. Esperar review (máximo 48 horas para PRs pequeños).

**Tipos de contribución:**
| Tipo | Proceso | Reviewers requeridos |
|---|---|---|
| Bug fix | PR directo | 1 mantenedor |
| Feature | RFC → PR | 2 mantenedores |
| Módulo nuevo | PR con módulo | 1 mantenedor + 1 arquitecto |
| Documentación | PR directo | 1 mantenedor |
| Seguridad | Privado (SECURITY.md) | Equipo seguridad |

### 12.7 Mantenimiento a largo plazo

**Estrategia:**
- **Versionado semántico** para detectar cambios rupturistas.
- **Deprecación lenta**: 2 releases de aviso antes de eliminar funcionalidad.
- **LTS (?):** No hay LTS formal (rolling release), pero se mantienen snapshots estables.
- **Archivo de decisiones:** `docs/decisions/` registra decisiones arquitectónicas (ADRs).

**Rotación de mantenedores:**
- Los mantenedores pueden retirarse dejando documentación de los módulos a su cargo.
- Nuevos mantenedores son nominados por el equipo existente.
- Mínimo 2 mantenedores por módulo crítico.

---

## 13. Convenciones

### 13.1 ¿Para qué existe?

Las convenciones garantizan consistencia en todo el código base, reducen la fricción en las revisiones y permiten que cualquier desarrollador entienda el código independientemente de quién lo escribió.

### 13.2 Convenciones de nomenclatura

| Elemento | Convención | Ejemplo |
|---|---|---|
| Repositorios | `kebab-case` | `lnos-mod`, `lnos-config` |
| Paquetes Arch | `kebab-case` | `lnos-module-gaming` |
| Módulos LNOS | prefijo `lnos-` + `kebab-case` | `lnos-gpu-nvidia` |
| Directorios | `kebab-case` | `/etc/lnos/modules/` |
| Archivos de configuración | `kebab-case` | `default-config.toml` |
| Variables Rust | `snake_case` | `module_list` |
| Funciones Rust | `snake_case` | `install_module()` |
| Tipos Rust | `PascalCase` | `ModuleInfo` |
| Traits Rust | `PascalCase` | `ModuleManager` |
| Constantes Rust | `SCREAMING_SNAKE_CASE` | `MAX_RETRY_COUNT` |
| Variables Python | `snake_case` | `module_list` |
| Funciones Python | `snake_case` | `install_module()` |
| Clases Python | `PascalCase` | `ModuleManager` |
| Variables Bash | `UPPER_SNAKE_CASE` | `MODULE_DIR` |
| Funciones Bash | `snake_case` | `install_module()` |
| Issues/PRs | `kebab-case` | `fix-module-install-error` |
| Ramas Git | `tipo/descripcion-kebab` | `feat/add-gpu-module` |
| Tags Git | `vX.Y.Z` | `v1.0.0` |

### 13.3 Convenciones de código Rust

- Seguir **Rust API Guidelines** (rust-lang.github.io/api-guidelines/).
- Usar `rustfmt` con configuración por defecto.
- Todos los ítems públicos deben tener documentación (`///`).
- Preferir `Result<T, Error>` sobre `panic!` o `unwrap()`.
- Usar `thiserror` para errores, `anyhow` para errores no críticos.
- `unsafe` solo con aprobación explícita en code review.
- Preferir iteradores sobre bucles explícitos.
- Usar `clap` para CLI con subcomandos.
- Tests unitarios en el mismo archivo (`#[cfg(test)] mod tests`).

### 13.4 Convenciones de Git

**Commits:**
```
tipo(ámbito): descripción breve

Cuerpo opcional explicando el qué y el porqué (no el cómo).
```

**Tipos de commit:**
| Tipo | Significado |
|---|---|
| `feat` | Nueva funcionalidad |
| `fix` | Corrección de bug |
| `docs` | Documentación |
| `style` | Formato, estilo |
| `refactor` | Refactorización |
| `test` | Tests |
| `chore` | Mantenimiento, CI, build |
| `security` | Parche de seguridad |

**Ejemplos:**
```
feat(lnos-mod): add --json output flag
fix(storage): correct Btrfs subvolume mounting order
docs(architecture): update module communication diagram
security(auth): fix PAM timing attack vector
```

**PRs:**
- Título descriptivo (máximo 72 caracteres).
- Referencia a issue (ej: `Closes #123`).
- Checklist de review incluido en el template.
- Máximo 400 líneas de cambio por PR (excepciones documentadas).

### 13.5 Convenciones de documentación

- Toda documentación en markdown (CommonMark).
- Máximo 80 columnas en texto plano.
- Diagramas ASCII con ancho máximo 78 caracteres.
- Enlaces a capítulos como referencias relativas.
- Tablas con alineación vertical consistente.
- Versión del documento en el header.
- Fecha de última modificación al pie.

### 13.6 Convenciones de configuración

- Formato TOML para configuración de módulos.
- Formato JSON para API D-Bus.
- Formato INI legacy solo para compatibilidad con herramientas existentes.
- Prefijo `lnos_` para variables de entorno.
- Archivos de configuración en `/etc/lnos/` con permisos 644.
- Secrets en `/etc/lnos/secrets/` con permisos 600.

---

## 14. Estilo del Código

### 14.1 ¿Para qué existe?

Las reglas de estilo garantizan que el código sea legible, consistente y mantenible, automatizando la revisión de formato para centrarse en la lógica.

### 14.2 Rust: rustfmt, clippy

**rustfmt:**
- Usar configuración por defecto de `rustfmt` (estilo RFC).
- Verificación en CI: `cargo fmt --check`.
- Formateo automático en pre-commit hook.

**clippy:**
```toml
# .clippy.toml
# Configuración estricta para LNOS
```

| Regla | Comportamiento |
|---|---|
| `clippy::all` | Activar todos los lints |
| `clippy::pedantic` | Activar lints pedantes (excepto `doc_markdown`) |
| `clippy::nursery` | Activar lints experimentales |
| `clippy::cargo` | Lints relacionados con Cargo |
| `unsafe_derive_deserialize` | Deny — no derivar deserialize en tipos con unsafe |
| `missing_docs_in_private_items` | Warn |

**Reglas adicionales:**
- `#![deny(unsafe_code)]` en librerías (excepto FFI explícito).
- `#![warn(missing_docs)]` en todos los crates públicos.
- `#![forbid(unsafe_op_in_unsafe_fn)]`.

### 14.3 Python: black, ruff, mypy

**black:**
- Formateo automático con `black` (default 88 chars).
- Verificación en CI: `black --check .`

**ruff:**
```toml
[tool.ruff]
line-length = 88
target-version = "py311"

[tool.ruff.lint]
select = ["E", "F", "I", "N", "W", "UP", "B", "SIM", "PT"]
ignore = []
```

**mypy:**
```toml
[tool.mypy]
strict = true
python_version = "3.11"
disallow_untyped_defs = true
no_implicit_optional = true
warn_redundant_casts = true
```

### 14.4 Shell: shellcheck, shfmt

**shellcheck:**
- Todos los scripts `.sh` deben pasar `shellcheck -x`.
- Severidad mínima: style.

**shfmt:**
- `shfmt -i 4` (indentación 4 espacios).
- `shfmt -bn` (espacios alrededor de `=` en asignaciones).

### 14.5 Documentación: rustdoc, mkdocs

**rustdoc:**
- Documentar todos los ítems públicos con `///`.
- Incluir ejemplos en doc-tests cuando sea posible.
- Secciones: `# Description`, `# Arguments`, `# Returns`, `# Errors`, `# Panics`, `# Example`.

**mkdocs:**
- Tema `mkdocs-material`.
- Navegación generada de `mkdocs.yml`.
- Búsqueda integrada con lunr.js.
- Desplegado en GitHub Pages en cada release.

---

## 15. Política de Ramas Git

### 15.1 ¿Para qué existe?

Define cómo se organizan, nombran y fusionan las ramas para garantizar un flujo de trabajo predecible y seguro.

### 15.2 Git Flow vs Trunk Based

**Decisión:** Git Flow adaptado (simplificado).

```
Ramas permanentes:
    main        → Estable, solo releases
    develop     → Integración, rama por defecto

Ramas temporales:
    feat/<id>-<desc>       → Nuevas funcionalidades
    fix/<id>-<desc>        → Correcciones
    docs/<desc>            → Documentación
    release/<version>      → Preparación de release
    hotfix/<version>       → Parche urgente sobre main
```

**Justificación:** Trunk Based Development es demasiado agresivo para un proyecto con múltiples mantenedores y requiere CI extremadamente rápido. Git Flow completo es excesivo. Esta adaptación ofrece equilibrio.

```
main ◄── develop ◄── feat/xxx
  │            │
  └── hotfix ──┘
  │
  └── release/1.0.0 ──► main (tag v1.0.0)
```

### 15.3 Convención de nombres de ramas

| Patrón | Ejemplo |
|---|---|
| `feat/<issue-id>-<kebab-desc>` | `feat/142-add-json-output` |
| `fix/<issue-id>-<kebab-desc>` | `fix/89-correct-mount-order` |
| `docs/<kebab-desc>` | `docs/update-module-readme` |
| `release/<semver>` | `release/1.2.0` |
| `hotfix/<semver>` | `hotfix/1.2.1` |
| `chore/<kebab-desc>` | `chore/update-dependencies` |

### 15.4 Política de merges (merge vs rebase)

| Situación | Estrategia |
|---|---|
| Feature branch → develop | `merge --no-ff` (merge commit conservahistoria) |
| Hotfix → main + develop | `merge --no-ff` |
| Release → main | `merge --no-ff` + tag |
| Develop → release | `merge --no-ff` |
| Actualizar feature branch con develop | `rebase` (historia lineal) |

**Prohibido:** `git push --force-with-lease` solo en ramas personales. Nunca forzar push en `main` o `develop`.

### 15.5 Protección de ramas

| Rama | Protección |
|---|---|
| `main` | Sin push directo. Solo merges de PR aprobados + CI verde. Requiere GPG signature. |
| `develop` | Sin push directo. Solo merges de PR aprobados + CI verde. |

**Reglas de protección (GitHub):**
- Requerir status checks (CI, lint, test).
- Requerer aprobación de al menos 1 mantenedor.
- Requerer rama actualizada (evitar merge conflicts).
- Requerer firmado de commits (GPG).
- Limitar a usuarios autorizados (equipo mantenedores).

### 15.6 Firmado de commits (GPG)

Todos los commits en `main` y `develop` deben estar firmados con GPG.

**Configuración:**
```bash
git config --global commit.gpgsign true
git config --global user.signingkey <KEY_ID>
```

**Verificación en CI:**
```yaml
- name: Verify GPG signatures
  run: |
    git verify-commit HEAD
    git log --show-signature -1
```

Los mantenedores deben registrar su clave GPG pública en su perfil de GitHub.

---

## 16. Versionado

### 16.1 ¿Para qué existe?

Define cómo se versionan todos los artefactos del proyecto para garantizar trazabilidad, compatibilidad y comunicación clara de cambios.

### 16.2 SemVer estricto

LNOS utiliza **Semantic Versioning 2.0.0** para todos los componentes:

```
MAJOR.MINOR.PATCH
  │      │      └── Correcciones (compatibles hacia atrás)
  │      └───────── Nuevas funcionalidades (compatibles hacia atrás)
  └──────────────── Cambios incompatibles
```

**Excepciones:**
- Versiones 0.x (desarrollo inicial): MINOR puede incluir breaking changes.
- Componentes marcados como `experimental` pueden cambiar sin aviso.

### 16.3 Versionado de módulos

Cada módulo tiene su propio `version` en `module.toml`:

```toml
[module]
id = "lnos-gpu-nvidia"
version = "1.2.0"     # SemVer independiente del sistema
```

El sistema de módulos verifica compatibilidad:
- `MAJOR` debe coincidir con la versión del sistema (`lnos-core`).
- `MINOR` puede ser igual o superior.
- `PATCH` independiente.

### 16.4 Versionado de ISO

```
LNOS-<MAJOR>.<MINOR>.<PATCH>-<PROFILE>
Ejemplo: LNOS-1.2.0-desktop.iso
```

- `MAJOR`: Cambio mayor en la arquitectura.
- `MINOR`: Nueva funcionalidad significativa.
- `PATCH`: Correcciones, actualizaciones de paquetes.
- `PROFILE`: Perfil de ISO (minimal, desktop, gaming).

### 16.5 Changelogs

Cada release incluye `CHANGELOG.md` en la raíz del repositorio con formato Keep a Changelog:

```markdown
# Changelog

## [1.2.0] - 2026-08-15

### Added
- Nuevo módulo `lnos-dev-rust` con toolchain Rust completa
- Soporte de preseed en el instalador (#142)

### Changed
- Actualizado systemd a v256 (#89)
- Mejorada detección de GPU NVIDIA en live ISO (#67)

### Fixed
- Corregido montaje de subvolúmenes Btrfs en particionado manual (#45)
- Solucionado crash de `lnos-mod` con configuraciones vacías (#23)

### Security
- Parcheada vulnerabilidad CVE-2026-1234 en PAM (#12)
```

### 16.6 Etiquetado Git

Los releases se etiquetan con tags anotados y firmados:

```bash
git tag -s v1.2.0 -m "Release v1.2.0: Desktop ISO, módulo NVIDIA, correcciones"
git push origin v1.2.0
```

| Tag | Propósito |
|---|---|
| `v1.2.0` | Release estable |
| `v1.3.0-rc1` | Release candidate |
| `v1.3.0-beta1` | Pre-release beta |

---

## 17. CI/CD

### 17.1 ¿Para qué existe?

La integración continua y el despliegue continuo automatizan la verificación, compilación y publicación del sistema, garantizando que cada cambio pase por controles de calidad antes de llegar a los usuarios.

### 17.2 GitHub Actions / GitLab CI

**Elección:** GitHub Actions como primario, GitLab CI como espejo.

**Justificación:**
- GitHub Actions ofrece integración nativa con el ecosistema GitHub.
- Runners públicos gratuitos generosos para proyectos open source.
- Matriz de testing, artefactos, y despliegue integrados.
- GitLab CI como fallback si GitHub cambia sus políticas.

### 17.3 Pipeline de build

```yaml
# .github/workflows/build.yml
name: Build
on:
  push:
    branches: [develop, main]
  pull_request:
    branches: [develop]

jobs:
  build-rust:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        rust: [stable, beta]
    steps:
      - uses: actions/checkout@v4
      - uses: actions-rust-lang/setup-rust-toolchain@v1
      - run: cargo build --release --workspace
      - run: cargo test --workspace
      - run: cargo clippy --workspace -- -D warnings
      - run: cargo fmt --check

  build-packages:
    needs: build-rust
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: ./scripts/build-packages.sh

  build-iso:
    needs: build-packages
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: ./scripts/build-iso.sh desktop
      - uses: actions/upload-artifact@v4
        with:
          name: LNOS-desktop-iso
          path: out/*.iso
```

### 17.4 Pipeline de test

```yaml
name: Test
on: [push, pull_request]

jobs:
  unit-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: cargo test --workspace

  integration-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: python -m pytest tests/integration/ -v

  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: cargo clippy --workspace -- -D warnings
      - run: cargo fmt --check
      - run: shellcheck modules/*/hooks/*.sh
      - run: ruff check scripts/ tests/

  iso-test:
    needs: build-iso
    runs-on: ubuntu-latest
    steps:
      - uses: actions/download-artifact@v4
      - run: python tests/e2e/test_install_iso_qemu.py
```

### 17.5 Pipeline de release

```yaml
name: Release
on:
  push:
    tags: ['v*']

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: ./scripts/build-iso.sh desktop
      - run: ./scripts/build-iso.sh minimal
      - run: ./scripts/build-iso.sh gaming
      - run: ./scripts/sign-artifacts.sh
      - uses: softprops/action-gh-release@v2
        with:
          files: |
            out/*.iso
            out/*.iso.sig
            out/*.sha256sum
          body_path: CHANGELOG.md
          draft: true
```

### 17.6 Publicación automática de ISO

Cada release en GitHub:
1. Compila los tres perfiles de ISO.
2. Firma cada ISO con GPG.
3. Genera checksums SHA-256.
4. Crea un release de GitHub con los artefactos.
5. Publica en la página web del proyecto.
6. Notifica en el canal de Discord/Matrix del proyecto.

### 17.7 Actualización de repositorios

El proceso de actualización del repositorio de paquetes LNOS se automatiza mediante:

1. CI detecta nuevos commits en `main`.
2. Recompila los paquetes modificados.
3. Firma y publica en el repositorio de paquetes LNOS.
4. Actualiza el índice de paquetes (repo-add).
5. Notifica a los usuarios mediante `lnos-update-notifier`.

---

## 18. Testing

### 18.1 ¿Para qué existe?

El sistema de testing garantiza que LNOS funciona correctamente en todos los niveles: desde la unidad más pequeña hasta la ISO completa instalada en hardware virtualizado.

### 18.2 Tests unitarios (Rust: cargo test)

**Propósito:** Verificar el comportamiento de funciones y módulos individuales.

**Cobertura esperada:** >80% en crates de librería (`liblnos`), >60% en binarios.

**Ejecución:**
```bash
cargo test --workspace                  # Todos los tests
cargo test -p liblnos                   # Tests de liblnos
cargo test -- --include-ignored         # Tests marcados como ignore (lentos)
```

**Convenciones:**
```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_module_resolve_dependencies() {
        let modules = vec![/* ... */];
        let result = resolve_dependencies(&modules);
        assert!(result.is_ok());
    }

    #[test]
    fn test_config_parse_invalid_toml() {
        let result = parse_config("invalid toml {{{");
        assert!(result.is_err());
    }
}
```

### 18.3 Tests de integración

**Propósito:** Verificar que los componentes funcionan correctamente juntos.

**Ubicación:** `tests/integration/`

**Ejemplos:**
- `test_module_install.py`: Instala un módulo completo, verifica que los paquetes se instalan y la configuración se aplica.
- `test_dbus_api.py`: Ejercita la API D-Bus completa de `lnos-mod`.
- `test_config_persistence.py`: Verifica que los cambios de configuración persisten tras reinicio.

**Ejecución:**
```bash
pytest tests/integration/ -v --timeout=120
```

### 18.4 Tests de ISO (instalación automatizada en QEMU)

**Propósito:** Validar que la ISO arranca, el instalador funciona y el sistema instalado es funcional.

**Flujo:**
```
1. Arrancar ISO en QEMU (UEFI)
2. Esperar a que cargue el instalador
3. Seleccionar perfil de instalación
4. Seleccionar particionado automático
5. Configurar usuario y contraseña
6. Ejecutar instalación
7. Verificar que la instalación completa sin errores
8. Rearrancar desde el disco instalado
9. Verificar:
   - Arranque correcto del sistema
   - Servicios systemd activos
   - Red funcional (NetworkManager)
   - Audio funcional (PipeWire)
   - Hyprland arranca
   - Usuario puede hacer sudo
```

**Script de test:**
```python
# tests/e2e/test_install_iso_qemu.py
def test_install_desktop_profile():
    with QEMUVirtualMachine(iso="LNOS-1.0.0-desktop.iso") as vm:
        vm.wait_for_boot()
        vm.start_installer()
        vm.select_profile("desktop")
        vm.select_auto_partitioning()
        vm.set_user("testuser", "testpass")
        vm.start_installation()
        assert vm.installation_successful()
        vm.reboot()
        vm.wait_for_boot_from_disk()
        assert vm.service_is_active("NetworkManager")
        assert vm.service_is_active("pipewire")
        assert vm.can_sudo("testuser")
```

### 18.5 Tests de regresión

**Propósito:** Prevenir que cambios nuevos rompan funcionalidad existente.

**Estrategia:**
- Todo bug fix debe incluir un test que reproduzca el bug.
- Los tests de regresión se ejecutan en cada PR.
- Se mantiene una suite de tests de humo (smoke tests) que se ejecuta en <5 minutos.

### 18.6 Cobertura de código

| Herramienta | Componente | Objetivo |
|---|---|---|
| `cargo-llvm-cov` | Rust (librerías) | >80% |
| `cargo-llvm-cov` | Rust (binarios) | >60% |
| `pytest-cov` | Python | >70% |

La cobertura se mide en CI y se reporta como comentario en PRs. No se exige cobertura mínima para mergear, pero se recomienda mantener los objetivos.

### 18.7 Propósito de cada tipo de test

| Tipo | Propósito | Velocidad | Frecuencia |
|---|---|---|---|
| Unitarios | Verificar lógica individual | milisegundos | Cada commit |
| Integración | Verificar interacción entre componentes | segundos | Cada PR |
| ISO (E2E) | Validar instalación completa | minutos | Cada release y semanal |
| Regresión | Prevenir reintroducción de bugs | segundos | Cada PR |
| Humo | Verificación rápida de salud | <5 minutos | Cada commit a develop |

---

## 19. QA

### 19.1 ¿Para qué existe?

El proceso de aseguramiento de calidad garantiza que cada release de LNOS cumple con los estándares de funcionalidad, seguridad y estabilidad antes de llegar a los usuarios.

### 19.2 Proceso de revisión de código

Cada PR pasa por las siguientes fases:

```
PR abierto → CI automático → Review humano → Aprobación → Merge
     │            │               │
     │            ▼               ▼
     │     - Compila?      - Diseño correcto?
     │     - Tests pasan?  - Sigue convenciones?
     │     - Lints OK?     - Documentación?
     │     - Cobertura?    - Seguridad?
     ▼
   Feedback → Correcciones → Re-review
```

### 19.3 Code review checklist

**Checklist para reviewers:**
- [ ] ¿El código sigue las convenciones del proyecto (capítulo 13)?
- [ ] ¿El diseño es correcto y mantenible?
- [ ] ¿Hay tests para el nuevo código?
- [ ] ¿Los tests existentes siguen pasando?
- [ ] ¿La documentación está actualizada?
- [ ] ¿No hay vulnerabilidades de seguridad evidentes?
- [ ] ¿No hay dependencias innecesarias?
- [ ] ¿Los mensajes de error son informativos?
- [ ] ¿La configuración tiene valores por defecto razonables?
- [ ] ¿El rendimiento es aceptable?

**Checklist para el autor:**
- [ ] ¿Ejecuté `cargo clippy -- -D warnings`?
- [ ] ¿Ejecuté `cargo test`?
- [ ] ¿Ejecuté `shellcheck` en scripts?
- [ ] ¿El CHANGELOG está actualizado?
- [ ] ¿La documentación se actualizó?
- [ ] ¿No hay secretos ni tokens en el código?

### 19.4 QA manual antes de release

Antes de cada release, un humano debe realizar las siguientes pruebas manuales:

1. **Instalación limpia** en QEMU con UEFI y Secure Boot.
2. **Instalación limpia** en hardware real (al menos 2 configuraciones distintas).
3. **Actualización desde release anterior** (si aplica).
4. **Prueba de cada módulo** instalado individualmente.
5. **Prueba de combinaciones** de módulos (mínimo 3 combinaciones).
6. **Verificación de servicios** activos por defecto.
7. **Prueba de red** (Ethernet, Wi-Fi, VPN).
8. **Prueba de audio** (altavoces, micrófono, Bluetooth).
9. **Prueba de Hyprland** (animaciones, atajos, workspaces).
10. **Prueba de snapshots** (Timeshift, rollback).

### 19.5 Release candidates

Cada release pasa por un período de Release Candidates (RC):
- `v1.2.0-rc1`: Primer candidato.
- `v1.2.0-rc2`: Segundo candidato (si rc1 tuvo issues).
- Período de testing mínimo: 7 días.
- Anuncio en Discord/Matrix/foro.
- Los RCs se etiquetan en Git y se publican como pre-release en GitHub.

**Criterios para pasar de RC a estable:**
- No hay bugs críticos (severidad P0 o P1).
- Todos los tests automatizados pasan en RC.
- Al menos 3 personas reportan instalación exitosa.
- No hay regresiones conocidas respecto al release anterior.

### 19.6 Pruebas en hardware real

La matriz de hardware objetivo para pruebas:

| Fabricante | Modelo | Tipo |
|---|---|---|
| Dell | XPS 13 9340 | Portátil Intel |
| Lenovo | ThinkPad X1 Carbon Gen 12 | Portátil Intel |
| Lenovo | ThinkPad T14s Gen 4 AMD | Portátil AMD |
| System76 | Lemur Pro | Portátil Intel |
| Apple | MacBook Air M1 (Asahi Linux) | ARM (futuro) |
| Desktop | AMD Ryzen 9 + RX 7900 XTX | Sobremesa AMD |
| Desktop | Intel i7 + RTX 4070 | Sobremesa NVIDIA |
| Mini PC | Intel NUC 13 Pro | Mini PC |
| Framework | Framework 13 AMD | Portátil modular |

### 19.7 Reporte de bugs

Los bugs se reportan mediante issues de GitHub con la siguiente plantilla:

```markdown
**Comportamiento esperado:**
[qué debería pasar]

**Comportamiento actual:**
[qué pasa realmente]

**Pasos para reproducir:**
1. Ir a...
2. Hacer clic en...
3. Observar error

**Entorno:**
- LNOS versión: [vX.Y.Z]
- Módulos instalados: [lista]
- Kernel: [uname -a]
- Hardware: [CPU, GPU, RAM]

**Logs relevantes:**
```
[logs de journalctl, dmesg, etc.]
```

**Severidad:**
- P0: Sistema no arranca / datos perdidos
- P1: Funcionalidad principal rota
- P2: Funcionalidad secundaria rota
- P3: Problema cosmético / mejora
```

---

## 20. Documentación

### 20.1 ¿Para qué existe?

La documentación es un componente fundamental de LNOS. Sin documentación adecuada, el sistema no puede ser instalado, usado, mantenido ni ampliado por nadie más que sus creadores originales.

### 20.2 Wiki de usuario

**Plataforma:** GitHub Wiki o sitio web estático (mkdocs-material).

**Contenido:**
- Guía de instalación paso a paso.
- Guía de primeros pasos post-instalación.
- Preguntas frecuentes (FAQ).
- Solución de problemas comunes (troubleshooting).
- Guías de personalización.
- Referencia de módulos disponibles.
- Referencia de atajos de teclado.

**Formato:** Markdown, con enlaces cruzados y búsqueda integrada.

### 20.3 Documentación técnica

**Ubicación:** `docs/` en el repositorio principal.

**Contenido:**
- `SPECIFICATION.md`: Este documento.
- `ARCHITECTURE.md`: Visión general de la arquitectura.
- `MODULES.md`: Guía de desarrollo de módulos.
- `STYLEGUIDE.md`: Guía de estilo de código.
- `SECURITY.md`: Política de seguridad.
- `PLUGINS.md`: Desarrollo de plugins.
- `API.md`: Documentación de APIs internas.

### 20.4 Documentación de API (rustdoc)

Todas las herramientas Rust generan documentación de API mediante `rustdoc`:

```bash
cargo doc --workspace --no-deps
```

La documentación se despliega en GitHub Pages tras cada release:
```
https://lnos.github.io/lnos/
```

**Requisitos:**
- Toda función pública documentada.
- Ejemplos en doc-tests para funciones críticas.
- Diagramas ASCII incluidos donde sea relevante.

### 20.5 Páginas man

Las herramientas CLI de LNOS incluyen páginas de manual:

| Página | Herramienta |
|---|---|
| `lnos-mod.8` | Gestor de módulos |
| `lnos-config.8` | Centro de configuración CLI |
| `lnos-software.8` | Centro de software CLI |
| `lnos-welcome.8` | Asistente de bienvenida |
| `lnos-backup.8` | Herramienta de backups |

Las páginas man se generan a partir de la documentación de las herramientas (CLI help + asciidoc/mdoc).

### 20.6 Guías de instalación

Formato: markdown, disponible en:
1. La wiki.
2. El repositorio (`docs/INSTALL.md`).
3. La ISO (en `/root/install-guide.txt`).
4. La web del proyecto.

**Contenido mínimo:**
- Requisitos de hardware.
- Descarga y verificación de la ISO.
- Creación de medio booteable (USB, DVD, PXE).
- Arranque desde la ISO.
- Pasos del instalador.
- Configuración post-instalación.
- Resolución de problemas comunes.

### 20.7 Guías de contribución

**Ubicación:** `CONTRIBUTING.md` en la raíz del repositorio.

**Contenido:**
- Cómo configurar el entorno de desarrollo.
- Cómo compilar el proyecto.
- Cómo ejecutar tests.
- Cómo crear un módulo.
- Política de commits y PRs.
- Código de conducta.
- Proceso de RFC.

### 20.8 Traducciones (i18n)

**Estrategia:**
- La documentación del sistema (especificación, guías) se mantiene en español como lengua vehicular del equipo.
- La interfaz de usuario del instalador y herramientas gráficas se internacionaliza mediante gettext + archivos `.po`.
- Las páginas man se traducen al inglés y otros idiomas según demanda de la comunidad.
- La wiki soporta múltiples idiomas mediante directorios `docs/i18n/<lang>/`.

**Idiomas prioritarios:**
1. Español (lengua principal del equipo).
2. Inglés (cobertura máxima).
3. Alemán, Francés, Portugués (comunidad).
4. Chino simplificado, Japonés (bajo demanda).

---

## 21. Branding

### 21.1 ¿Para qué existe?

El branding de LNOS crea una identidad visual y verbal consistente que diferencia la distribución en el ecosistema Linux y genera reconocimiento.

### 21.2 Nombre "LNOS": razón y significado

**Significado:** **L**inux **N**ative **O**perating **S**ystem.

**Razón de la elección:**
- **Corto y memorable:** 4 caracteres, fácil de recordar y escribir.
- **Significativo:** Refleja la naturaleza nativa de Linux sin artificios.
- **Disponible:** No conflictúa con marcas existentes.
- **Pronunciable:** /ˈɛlɛnˈoʊˈɛs/ en inglés, /ˈeleˈeneˈoˈese/ en español.
- **Dominio disponible:** lnos.dev, lnos.org, lnos.github.io.

**Alternativas descartadas:**
| Nombre | Motivo |
|---|---|
| ArchHypr | Demasiado específico (solo Hyprland) |
| NovaLinux | Genérico, conflictos con Nova (Fedora) |
| Pulsar | Ya usado en varios proyectos |
| Zenith | Pretencioso, difícil de recordar |
| Aurora | Ya usado por distribución existente |

### 21.3 Logotipo, colores, tipografía

**Logotipo:**
- Marca compuesta por el texto "LNOS" en caja alta con una barra diagonal estilizada que representa "/" (raíz del sistema de archivos).
- Versión icono: "/" estilizado como un indicador de directorio raíz.

**Paleta de colores:**

| Color | Hex | Uso |
|---|---|---|
| Primary | `#00B4D8` | Cyan oscuro — color principal |
| Secondary | `#0077B6` | Azul medio — acentos |
| Accent | `#FF6B35` | Naranja — CTAs, alertas |
| Dark | `#1A1A2E` | Fondo oscuro |
| Light | `#F0F0F0` | Fondo claro |
| Text | `#E0E0E0` | Texto sobre oscuro |
| Surface | `#16213E` | Superficie oscura |

**Tipografía:**
- UI: **Inter** (variable font, legible en pantalla).
- Mono: **JetBrains Mono** (terminal, código).
- Display: **Space Grotesk** (títulos, logo).

### 21.4 Marca en la ISO

- Splash screen de arranque con logo LNOS + nombre.
- Fondo de pantalla del live environment con logo.
- Prompt del terminal en live: `[lnos@live ~]$`.
- Nombre del host live: `lnos-live`.

### 21.5 Marca en el GRUB/systemd-boot

- Tema personalizado con colores LNOS.
- Logo LNOS en la esquina del menú de arranque.
- Nombre del sistema: `LNOS v1.2.0`.
- Entradas de arranque: `LNOS (default)`, `LNOS (fallback)`, `LNOS (memtest)`.

### 21.6 Marca en la pantalla de login

- Display manager (SDDM o greetd + gtkgreet) con tema LNOS.
- Logo LNOS centrado.
- Input de usuario con placeholder: "Usuario LNOS".

### 21.7 Marca en el wallpaper

- Default wallpaper: patrón geométrico abstracto en cyan/azul/naranja.
- Versión dark: fondo oscuro con acentos cyan.
- Versión light: fondo claro con acentos azul.
- Logo LNOS en esquina inferior derecha (opaco al 15%).

### 21.8 Marca en el prompt

```bash
# Prompt por defecto en terminal:
[lnos@hwinfo ~]$

# Prompt root:
[root@hwinfo ~]#

# Format: [usuario@hostname directorio]$
# Colores: usuario en cyan, hostname en azul, directorio en blanco
```

---

## 22. Instalador

### 22.1 ¿Para qué existe?

El instalador es el primer contacto del usuario con LNOS. Debe ser fiable, rápido e intuitivo, guiando al usuario desde la ISO en vivo hasta un sistema completamente funcional.

### 22.2 Instalador gráfico (GTK4)

**Framework:** GTK4 + Blueprint + Adwaita.

**Flujo del instalador:**

```
┌─────────────────────────────────────────────────────────────┐
│                    INSTALADOR LNOS                           │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  [1/7] Idioma        → Selección de idioma, teclado, zona    │
│  [2/7] Perfil        → Mínimo / Desktop / Gaming / Custom    │
│  [3/7] Particionado  → Automático / Manual / Avanzado        │
│  [4/7] Módulos       → Selección de módulos adicionales      │
│  [5/7] Usuarios      → Nombre, contraseña, hostname          │
│  [6/7] Resumen       → Confirmar configuración               │
│  [7/7] Instalación   → Barra de progreso + logs              │
│                                                              │
│  Botones: [Atrás] [Siguiente] [Cancelar]                     │
└─────────────────────────────────────────────────────────────┘
```

**Paso 1: Idioma**
- Selección de idioma de la interfaz.
- Selección de distribución de teclado.
- Selección de zona horaria (mapa interactivo o lista).
- Locale del sistema (UTF-8 por defecto).

**Paso 2: Perfil**
| Perfil | Descripción | Tamaño aproximado |
|---|---|---|
| Minimal | Solo sistema base + SSH | ~1.5 GB |
| Desktop | Base + Hyprland + herramientas | ~4 GB |
| Gaming | Desktop + gaming + drivers | ~6 GB |
| Custom | Selección manual de módulos | Variable |

**Paso 3: Particionado** (ver capítulo 23)
- Automático: Usa todo el disco.
- Manual: Interfaz de tabla de particiones.
- Avanzado: LUKS2 + LVM + Btrfs.

**Paso 4: Módulos**
- Módulos pre-seleccionados según perfil.
- Búsqueda y selección de módulos adicionales.
- Información de cada módulo (tamaño, descripción, dependencias).
- Conflictos detectados automáticamente.

**Paso 5: Usuarios**
- Nombre completo.
- Nombre de usuario (Unix).
- Contraseña (con indicador de fortaleza).
- Hostname.
- ¿Hacer este usuario admin? (Sí, por defecto).
- Contraseña de root (opcional, por defecto deshabilitada).

**Paso 6: Resumen**
- Tabla con todas las opciones seleccionadas.
- Botón "Editar" para cada sección.
- Advertencia: "Se borrarán todos los datos del disco".

**Paso 7: Instalación**
- Barra de progreso determinista.
- Logs en tiempo real (expandibles).
- Tiempo estimado restante.
- Opción "Mostrar detalles".
- Botón "Cancelar" (con confirmación).

### 22.3 Instalador TUI (alternativa para servidores)

Para entornos sin GUI o servidores headless:
- Framework: `dialog` o FMI (textual).
- Mismo flujo que el instalador gráfico pero en terminal.
- Soporte de colores 256.
- Navegación por teclado (Tab, Enter, Flechas).

### 22.4 Modo preseed (completamente automatizado)

**Formato:** Archivo YAML/TOML con todas las opciones de instalación.

```toml
# preseed.toml — Instalación automatizada LNOS
[system]
locale = "es_ES.UTF-8"
keymap = "es"
timezone = "Europe/Madrid"
hostname = "lnos-server"

[disk]
device = "/dev/nvme0n1"
partitioning = "auto"  # "auto", "manual", "luks"
encryption = true
encryption_password = ""

[user]
name = "admin"
full_name = "Administrator"
password_hash = "$y$j9T$..."  # SHA-512 o yescrypt hash
groups = ["wheel", "audio", "video"]

[modules]
base = true
desktop = false
gaming = false
server = true
docker = true
security = true

[network]
interfaces = [
    { name = "eth0", dhcp = true }
]
```

**Uso:**
```bash
# Arrancar ISO con preseed en dispositivo USB
lnos.install.auto preseed=/mnt/preseed.toml

# O desde URL
lnos.install.auto preseed=https://config.example.com/preseed.toml
```

### 22.5 Detección de hardware

El instalador detecta automáticamente:

| Componente | Detección | Acción |
|---|---|---|
| GPU | `lspci`, `glxinfo`, Vulkan | Ofrecer driver apropiado |
| Red | Ethernet, Wi-Fi, WWAN | Configurar NetworkManager |
| Audio | `aplay -l`, `arecord -l` | Activar PipeWire |
| Bluetooth | `hciconfig`, `btmgmt` | Activar bluetooth.service |
| Disco | `lsblk`, `blkid` | Particionado |
| RAM | `dmidecode` | Sugerir tamaño de swap |
| CPU | `/proc/cpuinfo` | Microcode, optimizaciones |
| Pantalla | `edid-parse`, `hwinfo` | Resolución óptima, HiDPI |
| Batería | `/sys/class/power_supply/` | Modo laptop (TLP) |
| Sensor táctil | `libinput list-devices` | Configurar gestos |

### 22.6 Configuración de red

El instalador ofrece:
- Detección automática de interfaces.
- DHCP por defecto.
- Configuración manual (IP, máscara, gateway, DNS).
- Wi-Fi: selección de redes, WPA2/WPA3.
- VPN opcional.
- Proxy corporativo.

### 22.7 Selección de módulos

Basado en:
1. Perfil seleccionado (preselección).
2. Hardware detectado (drivers GPU, Bluetooth, etc.).
3. Selección manual del usuario.
4. Dependencias resueltas automáticamente.

### 22.8 Gestión de errores

| Error | Manejo |
|---|---|
| Disco sin espacio | Mostrar espacio requerido vs disponible, sugerir limpieza |
| Fallo de red | Reintentar, mostrar error, ofrecer configuración manual |
| Paquete no encontrado | Log, continuar, reportar al final |
| Error de particionado | Revertir cambios, mostrar mensaje claro |
| Falla de hardware incompat. | Mostrar advertencia, continuar si es posible |
| Error de GRUB/systemd-boot | Ofrecer instalar manualmente desde chroot |

---

## 23. Particionado

### 23.1 ¿Para qué existe?

El particionado define la estructura de almacenamiento del sistema. La elección correcta impacta en rendimiento, seguridad, flexibilidad y capacidad de recuperación.

### 23.2 Layout por defecto (Btrfs + EFI + Swap)

```
Partición 1: /boot (EFI system partition)
  - Tamaño: 1 GiB
  - Sistema: FAT32 (vfat)
  - Mount point: /boot (o /efi)
  - Flags: esp, boot

Partición 2: Btrfs (sistema raíz)
  - Tamaño: resto del disco
  - Sistema: Btrfs
  - Subvolúmenes:
    - @         → /
    - @home     → /home
    - @snapshots → /.snapshots
    - @var      → /var
    - @cache    → /var/cache
    - @log      → /var/log
    - @tmp      → /tmp (opcional)

Partición 3: Swap (opcional)
  - Tamaño: RAM × 1.0 (suspender), RAM × 0.5 (sin suspender)
  - Sistema: swap
  - Swapfile: alternativa dentro de Btrfs
```

**Justificación del layout:**
- **EFI separada:** Requisito UEFI, 1 GiB suficiente para múltiples kernels.
- **Btrfs:** Snapshots, compresión (`zstd:3`), checksumming, subvolúmenes flexibles.
- **Subvolúmenes separados:** Permite snapshots excluyendo `/home`, snapshots independientes de `/var/log`.
- **Swap:** Opcional; en sistemas con >16 GB RAM se puede omitir o usar swapfile.

### 23.3 Particionado manual (fdisk, gdisk, parted)

El instalador ofrece una interfaz gráfica para particionado manual:

- Tabla de particiones GPT (obligatorio para UEFI).
- Creación/eliminación/redimensionado de particiones.
- Selección de sistema de archivos (Btrfs, ext4, XFS, FAT32).
- Puntos de montaje.
- Flags de partición.

### 23.4 Particionado automático

**Modo "Usar todo el disco":**
1. Borra la tabla de particiones existente.
2. Crea partición EFI (1 GiB).
3. Crea partición Btrfs (resto).
4. Crea swapfile dentro de Btrfs si se solicita.
5. Crea subvolúmenes por defecto.

**Modo "Instalar junto a otro sistema":**
1. Detecta sistemas operativos existentes.
2. Reduce la partición más grande si hay espacio suficiente.
3. Crea particiones LNOS en el espacio liberado.
4. Configura systemd-boot con entrada dual.

### 23.5 LUKS2 + LVM opcional

Para usuarios que requieren cifrado completo del disco:

```
LUKS2 (cifrado)
  └── LVM (volume group: lnos-vg)
       ├── root      → 20 GB
       ├── home      → resto
       ├── var       → 10 GB
       └── swap      → según RAM
```

**Configuración de LUKS2:**
- Algoritmo: `aes-xts-plain64`
- Tamaño clave: 512 bits
- Iteraciones: argon2id (por defecto)
- PBKDF: argon2id (memoria: 64 MB, tiempo: 3, paralelismo: 4)

**Integración con systemd:**
- `/etc/crypttab` con `luks` o `luks2` y `key-slot`.
- `systemd-cryptsetup` para desbloqueo en initramfs.
- Soporte TPM2 para desbloqueo automático (opcional).

### 23.6 Esquema de subvolúmenes Btrfs

| Subvolumen | Mount point | Propiedades | Snapshot | Excluir de snapshot |
|---|---|---|---|---|
| `@` | `/` | `compress=zstd:3` | Sí | — |
| `@home` | `/home` | `compress=zstd:3,noatime` | No | Sí (política) |
| `@snapshots` | `/.snapshots` | `compress=zstd:1` | — | — |
| `@var` | `/var` | `compress=zstd:3` | Sí | — |
| `@cache` | `/var/cache` | `compress=zstd:1,nodatacow` | No | Sí |
| `@log` | `/var/log` | `compress=zstd:1` | No | Sí |
| `@tmp` | `/tmp` | `nodatacow` | No | Sí |

**Comando de creación:**
```bash
mkfs.btrfs -L lnos /dev/nvme0n1p2
mount /dev/nvme0n1p2 /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@snapshots
btrfs subvolume create /mnt/@var
btrfs subvolume create /mnt/@cache
btrfs subvolume create /mnt/@log
btrfs subvolume create /mnt/@tmp
```

### 23.7 Tamaños recomendados

| Escenario | EFI | Root (Btrfs) | Home | Swap | Total mínimo |
|---|---|---|---|---|---|
| Desktop mínimo | 1 GB | 20 GB | 50 GB | 4 GB | 75 GB |
| Desktop completo | 1 GB | 40 GB | 100 GB | 8 GB | 149 GB |
| Gaming | 1 GB | 60 GB | 200 GB | 16 GB | 277 GB |
| Servidor | 1 GB | 30 GB | 50 GB | 2 GB | 83 GB |
| Estación trabajo | 1 GB | 50 GB | 200 GB | 32 GB | 283 GB |

---

## 24. EFI

### 24.1 ¿Para qué existe?

La Interfaz de Firmware Extensible (EFI) es el estándar moderno para el arranque del sistema. Sustituye al antiguo BIOS/MBR y proporciona un entorno más seguro, flexible y estandarizado.

### 24.2 Partición del sistema EFI (ESP)

**Ubicación:** `/boot` (o `/efi` si se prefiere separación).

**Especificaciones:**
- Sistema de archivos: FAT32 (vfat).
- Tamaño: 512 MiB mínimo, 1 GiB recomendado.
- UUID: tipo de partición `C12A7328-F81F-11D2-BA4B-00A0C93EC93B` (ESP).
- Flags: `esp`, `boot`.

**Contenido de la ESP:**
```
/boot/
├── EFI/
│   ├── BOOT/
│   │   └── BOOTx64.EFI           # Fallback bootloader
│   ├── Linux/
│   │   ├── lnos-6.8.5-arch1-1.efi  # UKI (Unified Kernel Image)
│   │   └── lnos-6.8.5-arch1-1-fallback.efi
│   └── systemd/
│       └── systemd-bootx64.efi    # systemd-boot
├── loader/
│   ├── entries/
│   │   ├── lnos.conf
│   │   ├── lnos-fallback.conf
│   │   └── lnos-memtest.conf
│   └── loader.conf
├── initramfs-linux.img
├── initramfs-linux-fallback.img
├── vmlinuz-linux
└── sbctl/
    └── keys/                      # Claves Secure Boot
```

### 24.3 systemd-boot como gestor predeterminado

systemd-boot es el gestor de arranque predeterminado (ver capítulo 25 para justificación detallada). Se instala en la ESP:

```bash
bootctl --esp-path=/boot install
```

### 24.4 Entradas de arranque

**Entrada por defecto (`/boot/loader/entries/lnos.conf`):**
```conf
title   LNOS v1.2.0
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=UUID=xxxx rw rootflags=subvol=@ quiet loglevel=3
```

**Entrada de fallback:**
```conf
title   LNOS v1.2.0 (Fallback)
linux   /vmlinuz-linux
initrd  /initramfs-linux-fallback.img
options root=UUID=xxxx rw rootflags=subvol=@
```

**Entrada de memoria:**
```conf
title   LNOS v1.2.0 (Memtest86+)
efi     /EFI/memtest86+/memtest.efi
```

### 24.5 Actualización de firmware (fwupd)

LNOS incluye `fwupd` para actualización de firmware UEFI:

- Servicio: `fwupd.service` (habilitado por defecto).
- Herramienta: `fwupdmgr` (CLI), integración en centro de configuración.
- Fuentes: LVFS (Linux Vendor Firmware Service).
- Seguridad: actualizaciones firmadas verificadas por UEFI.

### 24.6 Consideraciones multi-arranque

**Detección de otros sistemas operativos:**
systemd-boot puede detectar entradas de otros SO mediante `bootctl list`.

**Configuración recomendada:**
- Cada SO tiene su propia partición ESP (o se comparte con cuidado).
- LNOS respeta las entradas existentes de systemd-boot.
- Para Windows: se añade entrada manual apuntando a `\EFI\Microsoft\Boot\bootmgfw.efi`.

---

## 25. Bootloader

### 25.1 ¿Para qué existe?

El bootloader (gestor de arranque) es el primer software que se ejecuta tras el firmware UEFI. Su función es cargar el kernel de Linux y el initramfs en memoria y transferir el control al sistema operativo.

### 25.2 systemd-boot: por qué sobre GRUB

**Decisión:** systemd-boot como gestor de arranque predeterminado.

**Justificación:**

| Aspecto | systemd-boot | GRUB |
|---|---|---|
| Complejidad | Simple (~2000 líneas C) | Complejo (~300,000 líneas) |
| Configuración | Archivos de texto simples | Scripting GRUB (lenguaje propio) |
| Mantenimiento | Parte de systemd | Proyecto separado |
| Secure Boot | Soporte nativo con sbctl | Requiere shim + configuración extra |
| Velocidad | Muy rápido (~1s) | Más lento (~3-5s) |
| Temas | Limitado (solo colores/fondo) | Temas completos |
| Arranque dual | Manual | Automático (os-prober) |
| Cifrado | No soportado | Sí (LUKS2 GRUB) |
| Rescue | Menú básico | Consola interactiva completa |
| UEFI only | Sí (no BIOS) | UEFI + BIOS |
| Tamaño | ~100 KB | ~5 MB |

**Razones principales para systemd-boot:**
1. **Simplicidad:** Menos superficie de ataque, menos bugs, más fácil de mantener.
2. **Integración systemd:** Mismo maintainer, mismo ciclo de releases, misma filosofía.
3. **Velocidad:** Arranque más rápido, esencial para el objetivo de LNOS (<10s a Hyprland).
4. **Secure Boot:** Configuración trivial con `sbctl`.

**Contras asumidos:**
- Sin soporte BIOS legacy (asumimos UEFI, estándar desde 2012).
- Sin arranque dual automático (el usuario debe configurarlo manualmente).
- Sin cifrado de boot (el kernel y initramfs quedan en claro en ESP; mitigado por Secure Boot + LUKS2).

### 25.3 Configuración de entradas

**`/boot/loader/loader.conf`:**
```conf
default  lnos.conf
timeout  3
console-mode max
editor   no
auto-entries  0
```

**Parámetros:**
- `default`: Entrada predeterminada.
- `timeout`: Tiempo de espera en segundos (0 = arranque inmediato).
- `console-mode`: `max` = resolución nativa de la pantalla.
- `editor`: `no` = impedir edición de parámetros del kernel (seguridad).
- `auto-entries`: `0` = no generar entradas automáticas.

### 25.4 Fallback (recuperación)

El sistema incluye una entrada de kernel de respaldo en la ESP:

```
/boot/initramfs-linux-fallback.img
```

Esta entrada se usa cuando:
1. El kernel predeterminado falla por corrupción.
2. Un módulo del initramfs causa problemas.
3. Se necesita arrancar sin microcode o sin drivers específicos.

**Configuración de fallback automático:**
systemd-boot + systemd `bootctl set-oneshot` permite cambiar la entrada predeterminada para el siguiente arranque, usado por `lnos-mod` tras actualizaciones críticas.

### 25.5 Tema visual

systemd-boot soporta personalización visual limitada:
- **Fondo de pantalla:** Imagen BMP 1024x768 (escalable a resolución nativa).
- **Colores:** Configurables en `loader.conf`.
- **Logo de LNOS:** Integrado en el fondo.

```
┌─────────────────────────────────────────────────────┐
│                                                      │
│   ╔══════════════════════════════════════════════╗   │
│   ║              LNOS v1.2.0                     ║   │
│   ╠══════════════════════════════════════════════╣   │
│   ║  ▸ LNOS (default)                           ║   │
│   ║    LNOS (Fallback)                          ║   │
│   ║    Memtest86+                               ║   │
│   ║    UEFI Firmware Settings                   ║   │
│   ╚══════════════════════════════════════════════╝   │
│                                                      │
│   Presione una tecla para editar las opciones...     │
└─────────────────────────────────────────────────────┘
```

### 25.6 Parámetros de kernel

| Parámetro | Valor LNOS | Propósito |
|---|---|---|
| `root` | `UUID=xxxx` | Partición raíz por UUID (robusto) |
| `rw` | — | Montar raíz en lectura-escritura |
| `rootflags` | `subvol=@` | Subvolumen Btrfs raíz |
| `quiet` | — | Mensajes mínimos de boot |
| `loglevel` | 3 | Warnings y errores solamente |
| `mitigations` | `auto` | Mitigaciones de CPU (seguridad vs rendimiento) |
| `udev.log_priority` | 3 | Log de udev mínimo |
| `systemd.show_status` | `false` | Sin status de systemd en boot (limpio) |

---

## 26. Secure Boot

### 26.1 ¿Para qué existe?

Secure Boot es una característica de UEFI que verifica la firma criptográfica de cada componente cargado durante el arranque: firmware, bootloader, kernel, drivers. Previene la ejecución de código no autorizado (rootkits, bootkits) en la fase más temprana del arranque.

### 26.2 sbctl para gestión

**Herramienta:** `sbctl` (systemd-bootctl).

**¿Por qué sbctl?**
- Integración nativa con systemd-boot.
- Gestión simple de claves (creación, inscripción, revocación).
- Automatización de firmado de kernels e initramfs.
- Soporte para Microsoft KEK (certificados cruzados) y claves personalizadas (MOK).

**Instalación:**
```bash
sbctl create-keys
sbctl enroll-keys --microsoft  # Inscribir claves + KEK Microsoft
sbctl sign -s /boot/vmlinuz-linux
sbctl sign -s /boot/EFI/BOOT/BOOTx64.EFI
sbctl sign -s /boot/EFI/systemd/systemd-bootx64.efi
```

### 26.3 Claves personalizadas (MOK)

MOK (Machine Owner Key) permite al usuario gestionar sus propias claves para Secure Boot sin depender de Microsoft:

```
PK (Platform Key) ─── Propietario de la plataforma (LNOS)
  └── KEK (Key Exchange Key) ─── Microsoft + LNOS
       └── db (Signature Database) ─── Claves de confianza
            ├── Clave LNOS
            ├── Clave Microsoft (para shim)
            └── dbx (Forbidden Signatures) ─── Claves revocadas
```

**Flujo de inscripción de clave LNOS:**
```bash
# En el sistema LNOS
sbctl create-keys                    # Crea PK, KEK, db
sbctl enroll-keys --microsoft        # Inscribe en UEFI (req. reinicio)
sbctl sign /boot/vmlinuz-linux       # Firma kernel
sbctl sign /boot/EFI/systemd/*.efi   # Firma bootloader
```

### 26.4 Firma del kernel y gestor de arranque

El firmado se automatiza mediante hooks de pacman:

**Hook de pacman:**
```
# /usr/share/libalpm/hooks/lnos-secureboot.hook
[Trigger]
Operation = Install
Operation = Upgrade
Target = usr/lib/modules/*/vmlinuz
Target = usr/lib/systemd/boot/efi/systemd-bootx64.efi

[Action]
When = PostTransaction
Exec = /usr/bin/sbctl sign-all
```

Este hook garantiza que cada actualización del kernel o systemd-boot vuelva a firmar automáticamente los binarios.

### 26.5 Flujo de verificación

```
UEFI Firmware
    │
    ├── 1. Verifica PK → OK (clave LNOS inscrita)
    │
    ├── 2. Verifica firmware UEFI → OK (firma de OEM)
    │
    ├── 3. Carga systemd-boot BOOTx64.EFI
    │      └── Verifica db → OK (firma LNOS)
    │
    ├── 4. systemd-boot carga vmlinuz-linux
    │      └── Verifica db → OK (firma LNOS via sbctl)
    │
    ├── 5. Kernel carga initramfs
    │      └── initramfs verificado por firma del kernel
    │
    ├── 6. Kernel carga módulos
    │      └── Módulos firmados individualmente
    │
    └── 7. Arranque completo verificado
```

### 26.6 Pre-boot authentication (LUKS2 + TPM2)

Para sistemas con cifrado de disco, el desbloqueo automático mediante TPM2 evita tener que introducir la contraseña dos veces:

```bash
# Configurar LUKS2 con TPM2
systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+7 /dev/nvme0n1p2
```

**Flujo:**
```
1. UEFI + Secure Boot verifica integridad
2. systemd-boot carga kernel firmado
3. Kernel mide PCRs (Platform Configuration Registers) del TPM
4. systemd-cryptsetup desbloquea LUKS2 usando TPM2
5. Sistema arranca sin intervención del usuario
```

**Seguridad:** Si se modifica el kernel, bootloader o initramfs, los PCRs cambian y TPM2 no libera la clave, requiriendo contraseña de recuperación.

---

## 27. Gestión de Usuarios

### 27.1 ¿Para qué existe?

Define cómo se crean, gestionan y eliminan los usuarios en LNOS, estableciendo políticas de seguridad, grupos y privilegios.

### 27.2 Usuario por defecto (primer usuario = sudoer)

Durante la instalación se crea el primer usuario:
- Nombre: el que elija el usuario.
- Grupos: `wheel`, `audio`, `video`, `storage`, `input`, `power`, `network`.
- Shell: `/bin/bash` (por defecto).
- Sudo: habilitado mediante grupo `wheel`.
- Home: `/home/<username>` con Btrfs subvolume @home.

**Política:**
- El primer usuario es siempre administrador (grupo `wheel`).
- Se puede crear un usuario root con contraseña separada (opcional).
- No hay usuario por defecto en el sistema instalado (seguridad).

### 27.3 Grupos de seguridad

| Grupo | Propósito | Miembros por defecto |
|---|---|---|
| `wheel` | Administración (sudo) | Primer usuario |
| `audio` | Acceso a dispositivos de audio | Primer usuario |
| `video` | Aceleración gráfica, backlight | Primer usuario |
| `storage` | Montaje de dispositivos extraíbles | Primer usuario |
| `input` | Dispositivos de entrada | Primer usuario |
| `power` | Suspensión, hibernación, apagado | Primer usuario |
| `network` | Gestión de redes (NetworkManager) | Primer usuario |
| `docker` | Acceso a Docker daemon | (opt-in) |
| `libvirt` | Acceso a virtualización | (opt-in) |
| `vboxsf` | Carpetas compartidas VirtualBox | (opt-in) |
| `wireshark` | Captura de paquetes | (opt-in) |

### 27.4 useradd, usermod, groupadd

Comandos estándar de gestión de usuarios. LNOS proporciona wrappers en `lnos-mod` para operaciones comunes:

```bash
# Añadir usuario (convención LNOS)
lnos-mod user add --name=jane --fullname="Jane Doe" --groups=wheel,audio

# Equivalente estándar:
useradd -m -G wheel,audio -s /bin/bash -c "Jane Doe" jane
passwd jane
```

**Parámetros por defecto (`/etc/default/useradd`):**
```
HOME_MODE=0700
SHELL=/bin/bash
SKEL=/etc/skel
CREATE_MAIL_SPOOL=no
```

### 27.5 systemd-homed opcional

systemd-homed ofrece gestión de usuarios con directorios home portátiles y cifrados:

```bash
homectl create jane --real-name="Jane Doe" --storage=luks --disk-size=50G
```

**¿Por qué opcional?**
- **Ventajas:** Home portátil (USB), cifrado automático, gestión de sesiones.
- **Desventajas:** Complejidad adicional, no compatible con Btrfs subvolumes @home, algunos problemas de compatibilidad con aplicaciones existentes.
- **Decisión:** systemd-homed deshabilitado por defecto. El usuario puede activarlo si lo desea.

### 27.6 Política de contraseñas

**Requisitos de contraseña (`/etc/security/pwquality.conf`):**
```
minlen = 8
dcredit = -1  # Al menos 1 dígito
ucredit = -1  # Al menos 1 mayúscula
lcredit = -1  # Al menos 1 minúscula
ocredit = -1  # Al menos 1 carácter especial
maxrepeat = 3 # Máximo 3 repeticiones consecutivas
```

**Algoritmo de hash:** `yescrypt` (estándar desde glibc 2.36+).

**Caducidad:** Sin caducidad por defecto (el usuario puede configurarla con `chage`).

---

## 28. PAM (Pluggable Authentication Modules)

### 28.1 ¿Para qué existe?

PAM es el framework de autenticación de Linux. Permite configurar cómo se autentican los usuarios en el sistema: contraseñas, biometría, tokens, etc.

### 28.2 Configuración de PAM

**Archivos de configuración:**
- `/etc/pam.d/system-auth` — Autenticación del sistema.
- `/etc/pam.d/login` — Login en TTY.
- `/etc/pam.d/sudo` — Autenticación para sudo.
- `/etc/pam.d/polkit-1` — Autenticación para Polkit.
- `/etc/pam.d/sshd` — Autenticación SSH.
- `/etc/pam.d/passwd` — Cambio de contraseña.

**Estructura de configuración:**
```
# /etc/pam.d/system-auth
auth        required      pam_faillock.so      preauth
auth        required      pam_unix.so          try_first_pass
auth        [default=die] pam_faillock.so      authfail
auth        sufficient    pam_faillock.so      authsucc
account     required      pam_unix.so
account     required      pam_faillock.so
password    required      pam_unix.so          yescrypt shadow
session     required      pam_unix.so
session     required      pam_systemd.so
```

### 28.3 pam_faillock (bloqueo por intentos)

Previene ataques de fuerza bruta bloqueando la cuenta tras un número de intentos fallidos:

```
# /etc/security/faillock.conf
deny = 5                 # Bloquear tras 5 intentos fallidos
unlock_time = 600        # Desbloquear tras 10 minutos
fail_interval = 900      # Ventana de 15 minutos para contar intentos
even_deny_root           # Aplicar también a root (con advertencia)
```

**Integración con systemd-logind:**
```bash
# Verificar estado de bloqueo
faillock --user jane

# Desbloquear manualmente
faillock --user jane --reset
```

### 28.4 pam_tally2

Alternativa legacy a pam_faillock. LNOS usa pam_faillock por ser la solución moderna integrada en systemd.

### 28.5 pam_unix (shadow passwords)

Gestiona la autenticación tradicional mediante `/etc/shadow`:
- Algoritmo de hash: `yescrypt` (por defecto).
- Shadow passwords habilitados.
- Nullok deshabilitado (no permitir contraseñas vacías).
- `remember=5` (recordar últimas 5 contraseñas para evitar repetición).

### 28.6 pam_systemd (sesiones)

Crea una sesión systemd-logind para cada login:

**Funciones:**
- Asigna el usuario a su propia sesión de systemd.
- Gestiona permisos de dispositivos (mediante ACL).
- Permite logind gestionar suspensión/cierre de sesión.
- Integración con systemd-homed (si está activo).

### 28.7 Integración con sudo

PAM autentica las solicitudes de sudo mediante `pam_unix.so` y `pam_systemd.so`:

```
# /etc/pam.d/sudo
auth        sufficient    pam_unix.so        try_first_pass
auth        required      pam_faillock.so    preauth
auth        [default=die] pam_faillock.so    authfail
auth        sufficient    pam_faillock.so    authsucc
account     required      pam_unix.so
session     required      pam_systemd.so
```

**Timeout de sudo:** 5 minutos sin reintroducir contraseña (ver capítulo 29).

---

## 29. sudo

### 29.1 ¿Para qué existe?

sudo permite a usuarios autorizados ejecutar comandos con privilegios elevados, proporcionando auditoría y control granular sobre quién puede hacer qué.

### 29.2 Configuración de sudoers

**Archivo principal:** `/etc/sudoers` (editado con `visudo`).

**Configuración LNOS:**
```
# /etc/sudoers
Defaults        env_reset
Defaults        mail_badpass
Defaults        secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
Defaults        timestamp_timeout=5
Defaults        passwd_tries=3
Defaults        badpass_message="Contraseña incorrecta. Intentos restantes: %d"

root            ALL=(ALL:ALL) ALL
%wheel          ALL=(ALL:ALL) ALL
```

### 29.3 Grupo wheel

LNOS utiliza el grupo `wheel` como grupo administrativo:

```bash
# Añadir usuario al grupo wheel (instalación)
usermod -aG wheel jane

# Verificar membresía
groups jane
# → jane wheel audio video storage
```

**Política:** Todos los miembros de `wheel` pueden ejecutar cualquier comando como root previa autenticación.

### 29.4 Timeout de contraseña

```conf
Defaults        timestamp_timeout=5
```

- 5 minutos sin necesidad de reintroducir contraseña.
- `timestamp_timeout=0`: pedir siempre contraseña.
- `timestamp_timeout=-1`: timeout infinito (no recomendado).

**Borrar timeout manualmente:**
```bash
sudo -k    # Borrar timestamp
sudo -K    # Forzar borrado inmediato
```

### 29.5 sudo_log (auditoría)

LNOS habilita logging de todos los comandos sudo para auditoría:

```
# /etc/sudoers.d/logging
Defaults        log_input, log_output
Defaults        iolog_dir=/var/log/sudo-io/%{user}
```

**Visualización de logs:**
```bash
# Ver comandos ejecutados
sudo journalctl -t sudo

# Reproducir sesión (input/output logging)
sudo sudoreplay -d /var/log/sudo-io/jane <ID>
```

### 29.6 doas como alternativa (descartada)

**doas** (de OpenBSD) es una alternativa más simple a sudo:

| Aspecto | sudo | doas |
|---|---|---|
| Configuración | Compleja pero potente | Simple |
| Auditoría | Sí | Limitada |
| Ecosistema | Universal en Linux | Minoritario |
| Logging | Sí | No nativo |
| Compatibilidad | 100% guiones existentes | Parcial |

**Decisión:** Se mantiene sudo por ser el estándar de facto en Linux, proporcionar mejor auditoría y ser requerido por herramientas del ecosistema (pacman, systemd, etc.).

---

## 30. Polkit

### 30.1 ¿Para qué existe?

Polkit (PolicyKit) es un sistema de autorización que permite a procesos no root realizar acciones privilegiadas, proporcionando un control granular sobre permisos sin necesidad de sudo.

### 30.2 Polkit como sistema de autorización

Polkit funciona mediante acciones y reglas:
- **Acción:** Una operación privilegiada (ej: montar un disco, instalar paquetes).
- **Regla:** Define qué usuarios/roles pueden realizar qué acciones.
- **Agente:** Proceso que solicita autenticación al usuario cuando es necesario.

**Arquitectura:**
```
Aplicación → D-Bus → polkitd → Reglas → ¿Autorizado?
                              ↓
                        Agente → Usuario → Contraseña → polkitd → OK/Deny
```

### 30.3 Reglas por defecto

**Acciones predefinidas de LNOS:**

```
# /usr/share/polkit-1/actions/org.lnos.modules.policy
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE policyconfig PUBLIC
  "-//freedesktop//DTD PolicyKit Policy Configuration 1.0//EN"
  "http://www.freedesktop.org/standards/PolicyKit/1/policyconfig.dtd">
<policyconfig>
  <action id="org.lnos.modules.install">
    <description>Install LNOS modules</description>
    <message>Authentication is required to install system modules</message>
    <defaults>
      <allow_any>auth_admin</allow_any>
      <allow_inactive>auth_admin</allow_inactive>
      <allow_active>auth_admin_keep</allow_active>
    </defaults>
  </action>
</policyconfig>
```

**Políticas del sistema por defecto:**

| Acción | Permiso por defecto |
|---|---|
| Instalar paquetes (pacman) | Solo admin (auth_admin) |
| Montar dispositivos extraíbles | Usuario activo (yes) |
| Suspender/ hibernar | Usuario activo (yes) |
| Cambiar hora del sistema | Solo admin |
| Gestionar redes | Usuarios grupo network (yes) |
| Actualizar firmware | Solo admin |
| Apagar/ reiniciar | Usuario activo (yes) |
| Acceder a logs del sistema | Solo admin |
| Ver permisos de otros usuarios | Solo admin |

### 30.4 Integración con systemd

Polkit se integra con systemd-logind para determinar si un usuario está activo (sesión local activa) o inactivo (sesión remota o sin actividad):

```xml
<defaults>
  <allow_active>auth_admin_keep</allow_active>
  <allow_inactive>auth_admin</allow_inactive>
</defaults>
```

- `allow_active`: Usuario en sesión local activa (auth_admin_keep = autenticación única por sesión).
- `allow_inactive`: Usuario remoto o sesión inactiva (auth_admin = autenticación cada vez).

### 30.5 Agente polkit-gnome

LNOS incluye `polkit-gnome-authentication-agent-1` como agente de autenticación gráfico:

```
# Se inicia automáticamente en Hyprland
exec-once = /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
```

**Flujo:**
1. Una aplicación solicita una acción privilegiada.
2. Polkit requiere autenticación.
3. El agente muestra un diálogo GTK: "Se requiere autenticación para instalar módulos del sistema".
4. El usuario introduce su contraseña.
5. Polkit otorga o deniega el permiso.

### 30.6 Reglas para acciones administrativas

**Reglas personalizadas de LNOS:**

```
# /etc/polkit-1/rules.d/10-lnos-admin.rules
polkit.addRule(function(action, subject) {
    if (action.id == "org.lnos.modules.install" &&
        subject.isInGroup("wheel")) {
        return polkit.Result.AUTH_ADMIN_KEEP;
    }
});

polkit.addRule(function(action, subject) {
    if (action.id == "org.freedesktop.NetworkManager.settings.modify.system" &&
        subject.isInGroup("network")) {
        return polkit.Result.YES;
    }
});
```

---

## 31. systemd

### 31.1 ¿Para qué existe?

systemd es el sistema de inicio (init) y gestor de servicios de LNOS. Proporciona el marco para la gestión de procesos, servicios, dispositivos, temporizadores, sesiones de usuario, logging y más.

### 31.2 systemd como init: por qué

**Decisión:** systemd como init system exclusivo.

**Justificación:**

| Aspecto | systemd | Alternativas |
|---|---|---|
| Adopción | Estándar en Arch, Fedora, Debian, Ubuntu | OpenRC (Gentoo), runit (Void) |
| Funcionalidad | Init + logind + journald + resolved + timedated + udev + tmpfiles + sysusers + bootchart + oomd | Fragmentado en múltiples herramientas |
| Mantenimiento | Un equipo, un ciclo de releases | Diferentes equipos, coordinación manual |
| Integración | D-Bus nativo, Polkit, logind | Conexiones ad-hoc |
| Rendimiento | Arranque paralelo, activación por socket/DBus | Arranque secuencial (OpenRC) |
| Seguridad | Sandboxing de unidades, ProtectHome, ProtectSystem, PrivateTmp | Limitado (OpenRC) |
| Ecosistema | Soportado por todas las herramientas modernas | Soporte decreciente |

**Contras asumidos:**
- Complejidad (más código que un init tradicional).
- Dependencia (systemd-PID 1 es irremplazable una vez adoptado).
- Controversia en ciertos sectores de la comunidad Linux.

### 31.3 Unidades críticas

| Unidad | Función | Prioridad |
|---|---|---|
| `basic.target` | Sistema base montado | Crítica |
| `local-fs.target` | Sistemas de archivos locales | Crítica |
| `sysinit.target` | Inicialización del sistema | Crítica |
| `multi-user.target` | Modo multiusuario (sin GUI) | Crítica |
| `graphical.target` | Modo con interfaz gráfica | Crítica |
| `NetworkManager.service` | Gestión de red | Alta |
| `pipewire.service` | Servidor de audio | Alta |
| `apparmor.service` | Perfiles de seguridad | Alta |
| `nftables.service` | Firewall | Alta |
| `systemd-logind.service` | Sesiones de usuario | Crítica |
| `systemd-udevd.service` | Dispositivos | Crítica |
| `systemd-journald.service` | Logging del sistema | Crítica |
| `bluetooth.service` | Bluetooth | Media |
| `fwupd.service` | Actualización de firmware | Media |
| `tlp.service` | Gestión de energía | Media |
| `cups.service` | Impresión | Baja |
| `sshd.service` | SSH (desactivado por defecto) | Baja |

### 31.4 systemd-journald

**Propósito:** Logging centralizado del sistema.

**Configuración LNOS:**
```ini
# /etc/systemd/journald.conf
[Journal]
Storage=persistent
SystemMaxUse=500M
SystemMaxFileSize=100M
SystemKeepFree=1G
MaxRetentionSec=30day
ForwardToSyslog=no
ForwardToWall=yes
Compress=yes
```

**Comandos útiles:**
```bash
journalctl -xe                          # Últimos logs + explicación
journalctl -u NetworkManager.service    # Logs de un servicio
journalctl --since "1 hour ago"         # Logs recientes
journalctl -p err -b                    # Errores del boot actual
journalctl --vacuum-size=200M           # Limpiar logs viejos
```

### 31.5 systemd-resolved

**Propósito:** Resolución de DNS.

**Configuración LNOS:**
```ini
# /etc/systemd/resolved.conf
[Resolve]
DNS=1.1.1.1 9.9.9.9
FallbackDNS=8.8.8.8 8.8.4.4
DNSSEC=allow-downgrade
DNSOverTLS=yes
MulticastDNS=yes
LLMNR=no
Cache=yes
CacheFromLocalhost=no
```

**Integración con NetworkManager:**
```ini
# /etc/NetworkManager/conf.d/dns.conf
[main]
dns=systemd-resolved
```

### 31.6 systemd-timesyncd

**Propósito:** Sincronización de tiempo NTP.

```ini
# /etc/systemd/timesyncd.conf
[Time]
NTP=0.arch.pool.ntp.org 1.arch.pool.ntp.org
FallbackNTP=2.arch.pool.ntp.org 3.arch.pool.ntp.org
RootDistanceMaxSec=5
PollIntervalMinSec=32
PollIntervalMaxSec=2048
```

### 31.7 systemd-logind

**Propósito:** Gestión de sesiones de usuario.

**Configuración LNOS:**
```ini
# /etc/systemd/logind.conf
[Login]
NAutoVTs=6
ReserveVT=6
KillUserProcesses=yes
KillOnlyUsers=
KillExcludeUsers=root
IdleAction=lock
IdleActionSec=30min
HandleLidSwitch=suspend
HandleLidSwitchExternalPower=lock
HandleLidSwitchDocked=ignore
PowerKeyIgnoreInhibited=no
SuspendKeyIgnoreInhibited=no
HibernateKeyIgnoreInhibited=no
LidSwitchIgnoreInhibited=yes
RuntimeDirectorySize=10%
UserTasksMax=4096
```

### 31.8 systemd-udevd

**Propósito:** Gestión de dispositivos (udev).

**Configuración LNOS:**
```ini
# /etc/udev/udev.conf
udev_log=info
children_max=64
exec_delay=0
event_timeout=180
timeout_signal=SIGKILL
```

**Reglas udev adicionales:**
```
# /etc/udev/rules.d/60-lnos-backlight.rules
ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="*", RUN+="/usr/bin/chgrp video /sys/class/backlight/%k/brightness"
ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="*", RUN+="/usr/bin/chmod g+w /sys/class/backlight/%k/brightness"
```

### 31.9 systemd-tmpfiles

**Propósito:** Gestión de archivos temporales.

**Configuración LNOS:**
```
# /etc/tmpfiles.d/lnos.conf
d /tmp 1777 root root 1d
d /var/tmp 1777 root root 30d
d /var/cache/pacman/pkg 0755 root root 30d
d /var/log/journal 2755 root systemd-journal 1w
```

### 31.10 systemd-sysusers

**Propósito:** Creación de usuarios y grupos del sistema.

**Configuración LNOS:**
```
# /usr/lib/sysusers.d/lnos.conf
u lnos-mod 450 "LNOS Module Manager" /var/lib/lnos-mod
g network 120
g wireshark 121
u _fwupd 122 "Firmware Update Daemon" /var/lib/fwupd
```

### 31.11 systemd-bootchart

**Propósito:** Profiling de tiempo de arranque (opcional, desactivado por defecto).

```bash
# Activar bootchart
systemctl enable systemd-bootchart.service

# Ver resultados
systemd-analyze plot > boot.svg
systemd-analyze blame | head -20
systemd-analyze critical-chain
```

### 31.12 systemd-oomd

**Propósito:** Gestión de Out-Of-Memory (evitar que el sistema se cuelgue por falta de memoria).

```ini
# /etc/systemd/oomd.conf
[OOM]
SwapUsedLimitPercent=90
DefaultMemoryPressureLimitPercent=50
DefaultMemoryPressureDurationSec=30
```

**Integración con unidades del usuario:**
```
# /etc/systemd/system/user@.service.d/oomd.conf
[Service]
ManagedOOMSwap=kill
ManagedOOMMemoryPressure=kill
ManagedOOMMemoryPressureLimitPercent=80
```

### 31.13 Optimizaciones de tiempo de arranque

**Objetivo:** <10 segundos desde UEFI a Hyprland.

**Estrategias:**
1. **Arranque paralelo:** systemd por defecto paraleliza servicios independientes.
2. **Eliminar esperas innecesarias:** `systemd-analyze blame` identifica servicios lentos.
3. **Initramfs mínimo:** Solo drivers necesarios para arrancar.
4. **systemd-boot:** Más rápido que GRUB (~2s menos).
5. **UKI (Unified Kernel Image):** Kernel + initramfs + boot params en un solo archivo EFI.
6. **Desactivar servicios innecesarios:** Solo esenciales en graphical.target.
7. **Kernel params:** `quiet`, `udev.log_priority=3`, `systemd.show_status=false`.

```bash
# Ver tiempo de arranque
systemd-analyze
# Startup finished in 2.345s (firmware) + 1.123s (loader) + 3.456s (kernel) + 2.789s (initrd) + 1.234s (userspace) = 10.947s
```

**Mediciones objetivo:**

| Componente | Tiempo objetivo |
|---|---|
| Firmware UEFI | <3s |
| systemd-boot | <1s |
| Kernel + initramfs | <4s |
| Userspace (systemd) | <3s |
| Hyprland + servicios | <2s |
| **Total** | **<10s** |

---

## 32. Servicios

### 32.1 ¿Para qué existe?

Los servicios systemd determinan qué procesos se ejecutan en cada estado del sistema. LNOS define qué servicios están habilitados por defecto, cuáles deshabilitados y cuáles se activan bajo demanda.

### 32.2 Servicios habilitados por defecto

| Servicio | Propósito | Dependencia |
|---|---|---|
| `NetworkManager.service` | Gestión de redes | — |
| `pipewire.service` | Servidor de audio | — |
| `pipewire-pulse.service` | Compatibilidad PulseAudio | pipewire.service |
| `wireplumber.service` | Gestión de sesiones de audio | pipewire.service |
| `apparmor.service` | Perfiles AppArmor | — |
| `nftables.service` | Firewall nftables | — |
| `firewalld.service` | Frontend de firewall | nftables.service |
| `systemd-resolved.service` | Resolución DNS | — |
| `systemd-timesyncd.service` | Sincronización NTP | — |
| `systemd-logind.service` | Sesiones de usuario | — |
| `systemd-udevd.service` | Gestión de dispositivos | — |
| `systemd-journald.service` | Logging | — |
| `systemd-tmpfiles-setup.service` | Archivos temporales | — |
| `bluetooth.service` | Bluetooth | (condicional: si hardware presente) |
| `tlp.service` | Gestión de energía | (condicional: si batería presente) |
| `fwupd.service` | Actualización de firmware | — |
| `cups.service` | Impresión (socket, no servicio) | (condicional) |
| `polkit.service` | Autorización Polkit | — |
| `dbus-broker.service` | Bus D-Bus | — |

### 32.3 Servicios deshabilitados por defecto

| Servicio | Razón | Cómo activar |
|---|---|---|
| `sshd.service` | Seguridad (sin SSH abierto por defecto) | `systemctl enable --now sshd` |
| `docker.service` | Solo necesario si se instala Docker | `lnos-mod install lnos-docker` |
| `podman.socket` | Solo necesario si se instala Podman | `lnos-mod install lnos-podman` |
| `libvirtd.service` | Solo necesario si se usa virtualización | `lnos-mod install lnos-virtualization` |
| `cups.service` | Solo si hay impresora | `lnos-mod install lnos-printing` |
| `systemd-bootchart.service` | Solo para profiling | `systemctl enable bootchart` |
| `systemd-oomd.service` | Opcional (sistema con mucha RAM) | `systemctl enable systemd-oomd` |

### 32.4 Temporizadores systemd

LNOS utiliza temporizadores systemd (reemplazo moderno de cron) para tareas programadas:

| Temporizador | Programa | Frecuencia |
|---|---|---|
| `lnos-snapshot.timer` | Timeshift snapshot | Cada 6 horas |
| `lnos-update.timer` | Comprobar actualizaciones | Cada 4 horas |
| `lnos-cleanup.timer` | Limpiar cache/tmp | Diario |
| `lnos-backup.timer` | Backup programado | Semanal |
| `lnos-refresh-mirrors.timer` | Actualizar mirrors | Semanal |
| `fwupd-refresh.timer` | Comprobar firmware | Diario |
| `trash-empty.timer` | Vaciar papelera | Cada 30 días |

**Ejemplo de temporizador:**
```ini
# /etc/systemd/system/lnos-snapshot.timer
[Unit]
Description=Create Btrfs snapshot every 6 hours

[Timer]
OnCalendar=*-*-* 00/6:00:00
Persistent=true
RandomizedDelaySec=300

[Install]
WantedBy=timers.target
```

### 32.5 Servicios de usuario

Servicios que se ejecutan en el contexto del usuario (no requieren root):

| Servicio de usuario | Propósito |
|---|---|
| `pipewire.service` | Servidor de audio (usuario) |
| `pipewire-pulse.service` | PulseAudio compat (usuario) |
| `wireplumber.service` | Gestión de audio (usuario) |
| `dunst.service` | Notificaciones |
| `hyprpaper.service` | Wallpaper |
| `polkit-gnome-authentication-agent-1.service` | Agente Polkit |
| `waybar.service` | Barra de estado |
| `nm-applet.service` | Applet de red |

Los servicios de usuario se habilitan con:
```bash
systemctl --user enable waybar.service
systemctl --user start waybar.service
```

### 32.6 Dependencias entre servicios

```
graphical.target
  ├── NetworkManager.service
  │     └── dbus.service
  ├── pipewire.service (user)
  │     └── wireplumber.service (user)
  ├── apparmor.service
  ├── nftables.service
  ├── firewalld.service
  │     └── nftables.service
  ├── systemd-logind.service
  │     └── dbus.service
  ├── polkit.service
  │     └── dbus.service
  └── bluetooth.service (condicional)
        └── dbus.service

multi-user.target
  ├── systemd-resolved.service
  ├── systemd-timesyncd.service
  ├── systemd-journald.service
  └── systemd-udevd.service
```

---

## 33. NetworkManager

### 33.1 ¿Para qué existe?

NetworkManager es el gestor de redes de LNOS. Proporciona detección automática de redes, configuración de interfaces Ethernet, Wi-Fi, VPN y gestión de conexiones.

### 33.2 NetworkManager: por qué sobre systemd-networkd

**Decisión:** NetworkManager como gestor de redes principal.

**Justificación:**

| Aspecto | NetworkManager | systemd-networkd |
|---|---|---|
| UX | nmcli, nmtui, nm-applet, gnome-control-center | networkctl, archivos .network |
| Wi-Fi | Integrado con iwd/wpa_supplicant | Soporte básico |
| VPN | Integración nativa (WireGuard, OpenVPN, IPSec) | Limitado |
| Móvil/MMS | Sí (ModemManager) | No |
| Bluetooth PAN | Sí | No |
| D-Bus API | Completa, usada por GUIs | Limitada |
| Detección automática | Sí (plug-and-play) | Configuración manual |
| Perfiles | Múltiples perfiles por interfaz | Un perfil por archivo |
| Hotspot | Fácil | Manual |

**Decisión:** NetworkManager para escritorio (flexibilidad, UX, Wi-Fi). systemd-networkd está disponible como alternativa para servidores que prefieran minimalismo.

### 33.3 Configuración por defecto (DHCP)

```ini
# /etc/NetworkManager/NetworkManager.conf
[main]
plugins=keyfile
dhcp=internal
dns=systemd-resolved
hostname-mode=config

[connectivity]
interval=300
uri=http://detectportal.archlinux.org/

[device]
wifi.backend=iwd
wifi.iwd.autoconnect=yes
```

**Perfiles de conexión por defecto:** No hay; el instalador o el usuario crean el primer perfil.

### 33.4 iwd como backend Wi-Fi

**Decisión:** iwd (iNet Wireless Daemon) como backend Wi-Fi en lugar de wpa_supplicant.

**Justificación:**

| Aspecto | iwd | wpa_supplicant |
|---|---|---|
| Consumo RAM | ~5 MB | ~20 MB |
| Velocidad de conexión | <1s | ~3-5s |
| Soporte WPA3 | Nativo | Parcial (parches) |
| Arquitectura | Moderna, D-Bus única | Legacy, múltiples interfaces |
| Código | ~50k líneas C | ~150k líneas C |
| Mantenimiento | Desarrollado por Intel | Mantenimiento comunitario |

**Configuración:**
```ini
# /etc/iwd/main.conf
[General]
EnableNetworkConfiguration=true
AddressRandomization=network

[Scan]
DisablePeriodicScan=false
```

### 33.5 nmcli, nmtui, nm-applet

**nmcli (CLI):**
```bash
nmcli dev status                    # Estado de dispositivos
nmcli con show                      # Conexiones guardadas
nmcli dev wifi list                 # Redes Wi-Fi disponibles
nmcli dev wifi connect "MiRed" password "pass"  # Conectar Wi-Fi
nmcli con up "MiRed"                # Activar conexión
nmcli con down "MiRed"              # Desactivar conexión
nmcli con add type ethernet ifname eth0   # Añadir perfil ethernet
```

**nmtui (TUI):** Interfaz de terminal con curses.

**nm-applet (GUI):** Applet de bandeja del sistema para Hyprland.

### 33.6 Conexiones VPN (WireGuard, OpenVPN)

**WireGuard (nativo en kernel):**
```bash
nmcli con add type wireguard ifname wg0 \
    con-name "MyWG" \
    ipv4.method manual \
    ipv4.addresses 10.0.0.2/32 \
    wireguard.private-key "..." \
    wireguard.peer "..."

nmcli con modify "MyWG" \
    wireguard.listen-port 51820 \
    +wireguard.allowed-ips "0.0.0.0/0" \
    +wireguard.endpoint "vpn.example.com:51820" \
    +wireguard.public-key "..."
```

**OpenVPN:**
```bash
nmcli con import type openvpn file ~/client.ovpn
```

### 33.7 DNS sobre TLS

Configurado mediante systemd-resolved (ver capítulo 31.5):
- Todos los DNS queries se envían sobre TLS.
- Servidores: Cloudflare (1.1.1.1) + Quad9 (9.9.9.9).
- Fallback: Google (8.8.8.8).

---

## 34. Bluetooth

### 34.1 ¿Para qué existe?

Bluetooth proporciona conectividad inalámbrica de corto alcance para dispositivos como auriculares, teclados, ratones, altavoces y transferencia de archivos.

### 34.2 BlueZ stack

BlueZ es el stack Bluetooth oficial de Linux, mantenido por Intel.

**Componentes:**
- `bluetoothd`: Daemon Bluetooth (servicio systemd).
- `bluetoothctl`: Herramienta CLI de gestión.
- `libbluetooth`: Librería Bluetooth.
- `hid2hci`: Conversión HID a HCI (para dispositivos Bluetooth en portátiles).

**Arquitectura:**
```
Aplicación (pavucontrol, blueman, bluetoothctl)
    │
    ▼
D-Bus (/org/bluez/hci0)
    │
    ▼
bluetoothd
    │
    ▼
Kernel (Bluetooth subsystem: HCI, L2CAP, RFCOMM, BNEP)
    │
    ▼
Hardware (USB Bluetooth, PCI Bluetooth, UART)
```

### 34.3 bluetooth.service

```bash
systemctl enable --now bluetooth.service
```

**Configuración por defecto:**
```ini
# /etc/bluetooth/main.conf
[General]
Name = LNOS-%d
Class = 0x000000
DiscoverableTimeout = 30
AlwaysPairable = true
PairableTimeout = 0
AutoEnable = true
```

**Justificación de parámetros:**
- `DiscoverableTimeout=30`: Solo visible 30 segundos (seguridad).
- `AutoEnable=true`: Activa automáticamente el adaptador al iniciar.
- `Name=LNOS-%d`: Identificador visible, %d = MAC.

### 34.4 blueman (gestión gráfica)

**blueman** es el gestor gráfico de Bluetooth:

```bash
lnos-mod install lnos-bluetooth  # Instala blueman + BlueZ
```

**Componentes de blueman:**
- `blueman-manager`: Gestor de dispositivos (GTK4).
- `blueman-applet`: Applet de bandeja (Hyprland).
- `blueman-sendto`: Envío de archivos.
- `blueman-adapters`: Configuración de adaptadores.

### 34.5 Perfiles soportados

| Perfil | Propósito | Estado en LNOS |
|---|---|---|
| **A2DP** (Advanced Audio Distribution) | Audio estéreo de alta calidad | Soportado |
| **HFP** (Hands-Free Profile) | Llamadas telefónicas, micrófono | Soportado |
| **HSP** (Headset Profile) | Auriculares con micrófono | Soportado |
| **AVRCP** (Audio/Video Remote Control) | Control remoto de reproducción | Soportado |
| **HID** (Human Interface Device) | Teclados, ratones, gamepads | Soportado |
| **PAN** (Personal Area Network) | Tethering de red | Soportado |
| **OBEX** (Object Exchange) | Transferencia de archivos | Soportado |
| **BLE** (Bluetooth Low Energy) | Dispositivos de baja energía | Soportado |

### 34.6 Bluetooth en dispositivos de audio (codecs LDAC, AAC, aptX)

| Códec | Calidad | Latencia | Soporte en PipeWire |
|---|---|---|---|
| **SBC** (estándar) | Buena (328 kbps) | ~200ms | Sí (por defecto) |
| **SBC XQ** (calidad alta) | Muy buena (452 kbps) | ~200ms | Sí |
| **AAC** (Apple) | Buena (250 kbps) | ~150ms | Sí (con `pipewire-codec-aac`) |
| **aptX** (Qualcomm) | Muy buena (352 kbps) | ~80ms | Sí (con `libfreeaptx`) |
| **aptX HD** (Qualcomm) | Alta (576 kbps) | ~80ms | Sí |
| **LDAC** (Sony) | Máxima (990 kbps) | ~200ms | Sí (con `ldacdec`) |

**Configuración de codec en PipeWire:**
```ini
# /etc/pipewire/media-session.d/bluez-monitor.conf
properties = {
    bluez5.codecs = [ldac aac aptx aptx_hd sbc sbc_xq]
    bluez5.auto-connect = true
    bluez5.hfphsp-backend = none
}
```

**Decisión:** SBC XQ por defecto (amplia compatibilidad, buena calidad). LDAC y aptX como opciones configurables.

---

## 35. Audio

### 35.1 ¿Para qué existe?

El subsistema de audio de LNOS proporciona reproducción y captura de sonido para aplicaciones, juegos, comunicación y producción multimedia.

### 35.2 ALSA (capa baja)

ALSA (Advanced Linux Sound Architecture) es la capa de más bajo nivel del audio en Linux.

**Propósito en LNOS:**
- Drivers de dispositivos de audio (kernel).
- Mezcla de hardware (dmix).
- Configuración de volúmenes de tarjeta (amixer, alsamixer).
- Enrutamiento de canales.

**Configuración LNOS:**
```ini
# /etc/asound.conf (mínimo, todo se delega en PipeWire)
defaults.pcm.card 0
defaults.ctl.card 0
```

**Nota:** No se configura ALSA directamente para aplicaciones; todo pasa por PipeWire. ALSA se mantiene como capa de drivers y para utilidades de diagnóstico.

### 35.3 PipeWire (capa media/servidor)

PipeWire es el servidor de audio y vídeo de LNOS (ver capítulo 36 para detalles completos).

**Rol en la pila de audio:**
```
Aplicación (Spotify, Firefox, DAW)
    │
    ▼
PipeWire (servidor de audio)
    │
    ├── pipewire-pulse (compatibilidad PulseAudio)
    │
    ├── pipewire-jack (compatibilidad JACK)
    │
    ▼
WirePlumber (gestión de sesiones)
    │
    ▼
ALSA (drivers)
    │
    ▼
Hardware (tarjeta de sonido, USB, HDMI)
```

### 35.4 WirePlumber (gestión de sesiones)

WirePlumber gestiona el enrutamiento de audio: qué dispositivo se usa por defecto, qué aplicación va a qué salida, perfiles de dispositivos (ver capítulo 37).

### 35.5 PulseAudio compat layer

`pipewire-pulse` proporciona compatibilidad total con aplicaciones que esperan PulseAudio:

```bash
# Verificar que pipewire-pulse está activo
pactl info
# → Server Name: PulseAudio (on PipeWire X.X.X)
```

No se necesita instalar PulseAudio; `pipewire-pulse` sustituye completamente al demonio de PulseAudio.

### 35.6 Audio profesional (JACK compat)

`pipewire-jack` proporciona compatibilidad con aplicaciones JACK (Ardour, Reaper, Carla, etc.):

```bash
# Usar pipewire-jack
# No es necesario ejecutar jackd; PipeWire maneja JACK clients automáticamente
```

**Configuración de baja latencia:**
```ini
# /etc/pipewire/pipewire.conf.d/latency.conf
context.properties = {
    default.clock.rate = 48000
    default.clock.quantum = 256       # ~5.3ms a 48kHz
    default.clock.min-quantum = 64    # ~1.3ms
    default.clock.max-quantum = 2048  # ~42.7ms
}
```

### 35.7 Dispositivos de audio USB

**Detección:** Automática mediante udev + PipeWire.

**Perfiles:**
- `output:analog-stereo`: Salida estéreo analógica.
- `output:hdmi-stereo`: Salida HDMI/DisplayPort.
- `input:analog-mono`: Micrófono analógico.
- `input:iec958`: Entrada digital S/PDIF.

**Prioridad de dispositivos:** El usuario puede configurar el dispositivo por defecto:
```bash
wpctl set-default <device-id>
```

---

## 36. PipeWire

### 36.1 ¿Para qué existe?

PipeWire es un servidor multimedia que maneja flujos de audio y vídeo en Linux. En LNOS, es el componente central del subsistema de audio.

### 36.2 PipeWire como reemplazo de PulseAudio + JACK

**Decisión:** PipeWire como único servidor multimedia, reemplazando a PulseAudio y JACK.

**Justificación:**

| Aspecto | PipeWire | PulseAudio | JACK |
|---|---|---|---|
| Modelo | Grafo de nodos | Flujo fuente-sumidero | Grafo de conexiones |
| Latencia | Configurable (64-4096 frames) | Alta (~100ms mínimo) | Baja (~2-10ms) |
| Consumo RAM | ~20-40 MB | ~30-60 MB | ~50-100 MB |
| Professional audio | Sí (JACK compat) | Limitado | Sí (nativo) |
| Video routing | Sí | No | No |
| Bluetooth codecs | LDAC, AAC, aptX, SBC | SBC, AAC limitado | No |
| Mantenimiento | Activo (Wim Taymans, Red Hat) | Mantenimiento mínimo | Mantenimiento mínimo |
| Integración Wayland | Nativa | No | No |

**Razones principales:**
1. **Unificación:** Un solo servicio para todo el audio, eliminando la fragmentación PA+JACK.
2. **Rendimiento:** Latencia configurable desde 64 frames (~1.3ms) hasta 4096 frames (~85ms).
3. **Consumo:** Menor uso de RAM que la combinación PulseAudio + JACK.
4. **Bluetooth:** Soporte nativo de codecs de alta calidad (LDAC, aptX).
5. **Video:** PipeWire también maneja captura de pantalla y video (compartir pantalla en Wayland).
6. **Seguridad:** Modelo de permisos basado en Polkit + portal.

### 36.3 Configuración de PipeWire

**Archivos de configuración:**
- `/etc/pipewire/pipewire.conf` — Configuración global.
- `/etc/pipewire/pipewire.conf.d/*.conf` — Overrides.
- `~/.config/pipewire/pipewire.conf.d/*.conf` — Overrides de usuario.

**Configuración LNOS por defecto:**
```ini
# /etc/pipewire/pipewire.conf.d/lnos-defaults.conf
context.properties = {
    default.clock.rate = 48000
    default.clock.allowed-rates = [44100 48000 88200 96000]
    default.clock.quantum = 1024
    default.clock.min-quantum = 32
    default.clock.max-quantum = 8192
    core.daemon = true
    core.name = "pipewire-0"
    link.max-buffers = 64
    mem.pool-size = 8388608  # 8 MB pool
}

context.modules = [
    { name = libpipewire-module-protocol-native }
    { name = libpipewire-module-client-node }
    { name = libpipewire-module-adapter }
    { name = libpipewire-module-metadata }
]

context.spa-libs = {
    audio.convert.* = audioconvert/libspa-audioconvert
    support.* = support/libspa-support
}
```

### 36.4 pipewire-pulse

Reemplaza completamente al demonio PulseAudio.

```ini
# /etc/pipewire/pipewire-pulse.conf.d/lnos-pulse.conf
pulse.rules = [
    {
        matches = [ { application.process.binary = "firefox" } ]
        actions = {
            update-props = {
                node.target = "alsa_output.pci-0000_00_1f.3.analog-stereo"
            }
        }
    }
]
```

### 36.5 pipewire-jack

Proporciona compatibilidad JACK:

```ini
# /etc/pipewire/pipewire-jack.conf.d/lnos-jack.conf
jack.properties = {
    jack.show-off = false
    jack.show-all = false
}
```

**Uso:**
```bash
# Las aplicaciones JACK detectan PipeWire automáticamente
export JACK_DEFAULT_SERVER=pipewire-0
```

### 36.6 Bajo consumo de recursos

| Configuración | RAM PipeWire | RAM PulseAudio+JACK | Ahorro |
|---|---|---|---|
| Idle | ~15 MB | ~45 MB | 67% |
| Reproducción (música) | ~22 MB | ~55 MB | 60% |
| Múltiples streams | ~35 MB | ~80 MB | 56% |

**Optimizaciones de LNOS:**
- Pool de memoria de 8 MB (suficiente para uso normal).
- Módulos mínimos cargados (solo los necesarios).
- Sin módulos legacy (no cargar módulos de compatibilidad innecesarios).

### 36.7 Latencia configurable

| Perfil | Quantum | Latencia | Uso recomendado |
|---|---|---|---|
| Batería/bajo consumo | 2048 | ~42.7ms | Música, vídeo, ofimática |
| Equilibrado (por defecto) | 1024 | ~21.3ms | Escritorio general |
| Gaming | 256 | ~5.3ms | Juegos, VoIP |
| Profesional | 64 | ~1.3ms | DAW, producción musical |

**Cambio dinámico:**
```bash
# Reducir latencia para gaming (temporal)
pw-cli set-default-quantum 256

# Restaurar
pw-cli set-default-quantum 1024
```

---

## 37. WirePlumber

### 37.1 ¿Para qué existe?

WirePlumber es el gestor de sesiones de PipeWire. Decide qué dispositivo de audio se usa por defecto, cómo se enrutan las aplicaciones a los dispositivos, y gestiona los perfiles de los dispositivos.

### 37.2 WirePlumber como gestor de sesiones

**¿Por qué WirePlumber y no media-session (el gestor por defecto de PipeWire)?**

| Aspecto | WirePlumber | media-session |
|---|---|---|
| Mantenimiento | Activo (Colabora, Red Hat) | Mantenimiento mínimo |
| Flexibilidad | Políticas configurables en Lua | Configuración limitada |
| Rendimiento | Bajo consumo (~10 MB RAM) | Similar |
| Características | Routing avanzado, perfiles, políticas | Funcionalidades básicas |
| Código | ~30k líneas C + Lua | ~10k líneas C |
| Adopción | Por defecto en Fedora, Ubuntu | Legacy |

**Decisión:** WirePlumber es el gestor de sesiones predeterminado por su flexibilidad, mantenimiento activo y políticas configurables.

### 37.3 Políticas de enrutamiento

WirePlumber asigna automáticamente las aplicaciones a los dispositivos según políticas configurables:

**Políticas por defecto:**
1. **Prioridad de dispositivos:** HDMI > USB > Analógica > Bluetooth.
2. **Preferencia de aplicación:** Aplicaciones de comunicación (Zoom, Discord) tienen prioridad de micrófono.
3. **Persistencia:** Una vez que el usuario cambia manualmente el dispositivo de una aplicación, se recuerda.
4. **Sesión:** Las nuevas aplicaciones van al dispositivo por defecto del usuario.

### 37.4 Perfiles de dispositivos

**Perfiles predefinidos:**
```lua
-- /etc/wireplumber/policy.lua.d/lnos-profiles.lua
rule = {
    matches = {
        {
            { "device.name", "matches", "alsa_card.*" },
        },
    },
    apply_properties = {
        ["device.nick"] = "Built-in Audio",
        ["device.profile"] = "output:analog-stereo+input:analog-stereo",
    },
}

rule = {
    matches = {
        {
            { "device.name", "matches", "alsa_card.*HDMI.*" },
        },
    },
    apply_properties = {
        ["device.nick"] = "HDMI Audio",
        ["device.profile"] = "output:hdmi-stereo",
    },
}
```

### 37.5 Configuración de políticas

**Archivos de configuración:**
- `/etc/wireplumber/main.lua.d/` — Configuración global.
- `/etc/wireplumber/policy.lua.d/` — Políticas de enrutamiento.
- `~/.config/wireplumber/policy.lua.d/` — Políticas de usuario.

**Configuración del dispositivo por defecto:**
```bash
# Listar dispositivos
wpctl status

# Establecer dispositivo por defecto
wpctl set-default <device-id>

# Ver y cambiar volúmenes
wpctl get-volume @DEFAULT_AUDIO_SINK@
wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.75
```

### 37.6 Lua scripting opcional

WirePlumber permite scripting Lua para políticas avanzadas:

```lua
-- /etc/wireplumber/policy.lua.d/50-lnos-gaming-mode.lua
-- Si el dispositivo USB gaming está conectado, usarlo por defecto
rule = {
    matches = {
        {
            { "node.name", "matches", "alsa_output.usb-Gaming_Headset.*" },
        },
    },
    apply_properties = {
        ["priority.session"] = 1000,
    },
}
```

---

## 38. Firewall

### 38.1 ¿Para qué existe?

El firewall controla el tráfico de red entrante y saliente, protegiendo el sistema contra accesos no autorizados y ataques de red.

### 38.2 nftables como backend

nftables es el backend de filtrado de paquetes del kernel Linux, sucesor de iptables (ver capítulo 39).

### 38.3 firewalld como frontend

**Decisión:** firewalld como frontend de gestión del firewall.

**¿Por qué firewalld?**
- Gestión dinámica de reglas (sin reiniciar el firewall).
- Zonas de seguridad (red doméstica, pública, corporativa).
- Integración con NetworkManager (cambio automático de zona al cambiar de red).
- D-Bus API para aplicaciones gráficas.
- Reglas predefinidas para servicios comunes (SSH, HTTP, Samba, etc.).
- Runtime + permanent configuration (separación de cambios temporales y permanentes).

### 38.4 firewalld: por qué sobre ufw, gufw

| Aspecto | firewalld | ufw + gufw |
|---|---|---|
| Arquitectura | Zonas dinámicas | Reglas simples |
| D-Bus API | Sí | No |
| Integración NM | Sí (automática) | Manual |
| Servicios predef. | Muchos (firewall-cmd --list-services) | Pocos |
| Runtime + Permanent | Sí | Sí |
| nftables backend | Sí (nativo desde v0.9.0) | Sí (desde 2021) |
| Complejidad | Mayor (curva de aprendizaje) | Menor (simple) |
| Público objetivo | Administradores, escritorios | Usuarios domésticos |

**Decisión:** firewalld para LNOS por su integración con NetworkManager, D-Bus API (para el centro de configuración) y flexibilidad para entornos profesionales.

### 38.5 Zonas de seguridad

| Zona | Comportamiento | Uso |
|---|---|---|
| `drop` | Bloquear todo el tráfico entrante, solo saliente | Redes públicas no confiables |
| `block` | Rechazar todo el tráfico entrante con icmp-host-prohibited | Redes públicas |
| `public` | Permitir solo servicios seleccionados (por defecto) | Redes Wi-Fi públicas, hotspots |
| `external` | Similar a public, con NAT para red interna | Gateways, routers |
| `internal` | Permitir servicios comunes (SSH, Samba, MDNS) | Red corporativa |
| `dmz` | Permitir solo servicios específicos (HTTP, HTTPS, SSH) | Servidores DMZ |
| `work` | Permitir servicios de oficina (SSH, DHCP) | Red laboral |
| `home` | Permitir todos los servicios comunes | Red doméstica |
| `trusted` | Permitir todo el tráfico | Red interna confiable |

**Zona por defecto en LNOS:** `public` con servicios `dhcpv6-client` y `mdns`.

### 38.6 Reglas predefinidas

**Servicios permitidos por defecto (zona public):**
```bash
firewall-cmd --zone=public --list-services
# dhcpv6-client mdns
```

**Reglas adicionales configurables:**
```bash
# SSH (solo en redes internas)
firewall-cmd --zone=internal --add-service=ssh

# Servidor web
firewall-cmd --zone=public --add-service=http
firewall-cmd --zone=public --add-service=https

# Samba
firewall-cmd --zone=internal --add-service=samba

# Jellyfin/Plex
firewall-cmd --zone=home --add-port=8096/tcp
```

**Reglas de logging:**
```bash
# Log de paquetes rechazados (rate-limited)
firewall-cmd --add-rich-rule='rule family="ipv4" log prefix="FW_DROP" level="info" limit value="10/m" reject'
```

### 38.7 Integración con NetworkManager

NetworkManager cambia automáticamente la zona del firewall según la red:
- Red doméstica conocida -> `home`.
- Red corporativa -> `internal`.
- Red Wi-Fi pública -> `public`.
- Red móvil -> `public`.
- Red cableada ethernet -> `internal` (si es red conocida) o `public`.

```bash
# Ver zona actual
firewall-cmd --get-active-zones

# Asignar zona a una conexión
nmcli con modify "MiWifi" connection.zone "public"
```

---

## 39. nftables

### 39.1 ¿Para qué existe?

nftables es el marco de filtrado de paquetes del kernel Linux. Proporciona el backend subyacente para firewalld y para reglas de firewall directas.

### 39.2 nftables: por qué sobre iptables

| Aspecto | nftables | iptables |
|---|---|---|
| Arquitectura | Tablas + chains + reglas (único framework) | Múltiples tablas separadas (filter, nat, mangle, raw) |
| Sintaxis | Simplificada, pseudo-JSON | Complicada, verbosa |
| Rendimiento | Mejor (evaluación más eficiente) | Legacy (evaluación lineal) |
| Actualizaciones | Atómicas (reemplazo completo de reglas) | No atómicas (regla a regla) |
| Protocolos | IPv4 e IPv6 en misma regla | Separados (iptables + ip6tables) |
| Conjuntos (sets) | Sí, nativos (mapas, conjuntos anónimos) | Limitados (ipset) |
| Depuración | `nft monitor trace` | Complicada |
| Mantenimiento upstream | Activo (kernel mismo equipo) | Mantenimiento mínimo (modo compat) |

**Decisión:** nftables puro, sin iptables ni iptables-legacy. firewalld usa nftables como backend desde v0.9.0.

### 39.3 Tablas, chains, reglas

**Estructura conceptual:**
```
Tabla (familia: ip, ip6, inet, arp, bridge, netdev)
  +-- Chain (tipo: filter, nat, route)
       +-- hook (prerouting, input, forward, output, postrouting)
       |    +-- priority (numero: -500 a 500)
       +-- Reglas (criteria + contador + accion)
```

**Configuracion LNOS (generada por firewalld):**
```nft
# /etc/nftables.conf (configuracion directa, si no se usa firewalld)
#!/usr/sbin/nft -f

flush ruleset

table inet lnos-filter {
    chain input {
        type filter hook input priority 0; policy drop;

        # Trafico local
        iif "lo" accept
        ct state { established, related } accept

        # ICMP (ping limitado)
        ip protocol icmp icmp type { echo-request } limit rate 10/second accept
        ip6 nexthdr icmpv6 icmpv6 type { echo-request } limit rate 10/second accept

        # Servicios permitidos
        tcp dport { 22 } accept       # SSH
        tcp dport { 5353 } accept     # mDNS (Avahi)

        # Logging
        log prefix "NFT_INPUT_DROP: " limit rate 3/minute burst 5 packets
        counter drop
    }

    chain forward {
        type filter hook forward priority 0; policy drop;
        log prefix "NFT_FORWARD_DROP: " limit rate 3/minute burst 5 packets
        counter drop
    }

    chain output {
        type filter hook output priority 0; policy accept;
    }
}
```

### 39.4 Configuracion por defecto

LNOS configura nftables con las siguientes politicas:

| Chain | Politica por defecto | Justificacion |
|---|---|---|
| Input | `drop` | Maxima seguridad: solo trafico explicitamente permitido |
| Forward | `drop` | No se enruta trafico por defecto |
| Output | `accept` | Las aplicaciones pueden iniciar conexiones salientes |

**Servicios permitidos en input:**
- Loopback (interfaz local).
- Trafico establecido/relacionado (conexiones iniciadas por el sistema).
- ICMP limitado (ping, path MTU discovery).
- mDNS (Avahi, deteccion de servicios en red local).
- DHCPv6.
- SSH (solo en zonas internas; bloqueado en publica).

### 39.5 Reglas para aplicaciones

Las aplicaciones que necesitan puertos abiertos pueden registrarse mediante firewalld:

```bash
# Permitir aplicacion (ej: servidor Jellyfin)
sudo firewall-cmd --add-port=8096/tcp --permanent
sudo firewall-cmd --reload
```

O mediante reglas nftables directas (para usuarios avanzados):

```nft
table inet lnos-apps {
    chain apps-input {
        type filter hook input priority 1; policy accept;
        tcp dport { 8096, 8920 } accept  # Jellyfin
        tcp dport { 32400 } accept        # Plex
        udp dport { 51820 } accept        # WireGuard
    }
}
```

### 39.6 Logging de trafico rechazado

El logging de trafico rechazado es fundamental para depuracion y seguridad:

```nft
# Regla de logging (rate-limited para evitar DoS en journald)
log prefix "NFT_INPUT_DROP: " limit rate 3/minute burst 5 packets
counter drop
```

**Visualizacion de logs:**
```bash
journalctl -k -f -g NFT_INPUT_DROP
```

**Formato de log:**
```
kernel: NFT_INPUT_DROP: IN=wlp2s0 OUT= MAC=xx:xx:xx:xx:xx:xx SRC=10.0.0.5 DST=10.0.0.10 LEN=60 TOS=0x00 PREC=0x00 TTL=64 ID=54321 PROTO=TCP SPT=54321 DPT=22 WINDOW=65535 RES=0x00 SYN URGP=0
```

---

## 40. AppArmor

### 40.1 Para que existe?

AppArmor (Application Armor) es un sistema de control de acceso obligatorio (MAC) basado en perfiles que restringe las capacidades de las aplicaciones mediante politicas de seguridad.

### 40.2 AppArmor: por que sobre SELinux

| Aspecto | AppArmor | SELinux |
|---|---|---|
| Modelo | Basado en rutas de archivo (path-based) | Basado en etiquetas (label-based) |
| Complejidad | Baja-media | Alta (categorias + tipos + niveles) |
| Curva aprendizaje | Baja (perfiles legibles) | Alta (policy language complejo) |
| Perfiles en Arch | Muchos paquetes incluyen perfiles | Muy pocos (casi ningun paquete) |
| Integracion systemd | Nativa (systemd-journald, systemd-logind) | Soporte limitado en Arch |
| Rendimiento | Minimo impacto | Impacto medible |
| Administracion | `aa-status`, `aa-enforce`, `aa-complain` | `semanage`, `audit2allow` |
| Herramientas | `aa-genprof`, `aa-logprof` | `audit2why`, `sealert` |
| Usabilidad | Perfiles faciles de escribir y auditar | Politicas extensas y anidadas |

**Decision fundamental:** AppArmor sobre SELinux.

**Razones principales:**
1. **Soporte en Arch Linux:** Arch tiene numerosos perfiles AppArmor mantenidos por la comunidad. SELinux apenas tiene soporte en Arch.
2. **Simplicidad:** Los perfiles AppArmor son archivos de texto legibles que cualquier administrador puede entender y modificar.
3. **Integracion:** AppArmor se integra directamente con systemd (journald, logind) sin configuracion adicional.
4. **Mantenimiento:** El equipo de seguridad de LNOS puede mantener perfiles AppArmor con recursos limitados; mantener politicas SELinux completas requeriria un equipo dedicado.

### 40.3 Perfiles por defecto

**Perfiles cargados por defecto en LNOS:**

| Perfil | Modo | Proposito |
|---|---|---|
| `lsb_release` | Enforce | Confinar lsb_release |
| `man` | Enforce | Confinar man (procesamiento de troff) |
| `tcpdump` | Enforce | Confinar captura de paquetes |
| `ping` | Enforce | Confinar ping |
| `mdnsd` (Avahi) | Enforce | Confinar mDNS |
| `dnsmasq` | Enforce | Confinar DNS forwarder |
| `libreoffice` | Enforce (si instalado) | Confinar LibreOffice |
| `firefox` | Enforce (si instalado) | Confinar Firefox |
| `evince` | Enforce (si instalado) | Confinar visor de PDF |
| `systemd-journald` | Enforce | Confinar journald (integrado) |
| `systemd-logind` | Enforce | Confinar logind (integrado) |
| `systemd-resolved` | Enforce | Confinar resolved |
| `systemd-timesyncd` | Enforce | Confinar timesyncd |
| `NetworkManager` | Enforce | Confinar gestor de redes |
| `ntpd` | Enforce | Confinar NTP alternativo |
| `docker` | Enforce (si instalado) | Confinar demonio Docker |
| `wireshark` | Enforce (si instalado) | Confinar captura |

**Modos de perfil:**
- **Enforce:** Las violaciones son bloqueadas y registradas.
- **Complain:** Las violaciones solo se registran (modo aprendizaje).
- **Unconfined:** Sin restricciones.
- **Disable:** Perfil descargado.

### 40.4 Herramientas (aa-status, aa-enforce, aa-complain)

```bash
# Estado de AppArmor
aa-status
# apparmor module is loaded.
# 18 profiles are loaded.
# 18 profiles are in enforce mode.
# 0 profiles are in complain mode.

# Cambiar modo de perfil
aa-enforce /etc/apparmor.d/usr.bin.firefox   # Activar enforce
aa-complain /etc/apparmor.d/usr.bin.firefox   # Activar complain
aa-disable /etc/apparmor.d/usr.bin.firefox    # Desactivar perfil

# Ver logs de violaciones
journalctl -xe | grep -i apparmor
# o
cat /var/log/audit/audit.log | grep apparmor
```

### 40.5 Integracion con systemd

AppArmor se integra con systemd mediante:

1. **Perfiles integrados en unidades systemd:**
```ini
[Service]
AppArmorProfile=NetworkManager
```

2. **systemd-journald:** Los eventos de AppArmor se registran en journald directamente.

3. **systemd-logind:** Las sesiones de usuario se asocian automaticamente a perfiles AppArmor.

**Carga de perfiles en el arranque:**
```bash
# apparmor.service carga todos los perfiles en /etc/apparmor.d/
systemctl enable --now apparmor.service
```

### 40.6 Perfiles para aplicaciones comunes

**Ejemplo de perfil para Firefox (parcial):**
```
# /etc/apparmor.d/usr.bin.firefox
#include <tunables/global>

profile firefox /usr/lib/firefox/firefox {
    #include <abstractions/base>
    #include <abstractions/nameservice>
    #include <abstractions/X>
    #include <abstractions/dbus-session>
    #include <abstractions/fonts>
    #include <abstractions/audio>

    # Ejecutable Firefox
    /usr/lib/firefox/firefox mr,
    /usr/lib/firefox/** mr,

    # Configuracion y cache
    owner @{HOME}/.mozilla/** rwk,
    owner @{HOME}/.cache/mozilla/** rwk,
    owner @{HOME}/.config/mozilla/** rw,

    # Descargas
    owner @{HOME}/Downloads/* rw,
    owner @{HOME}/Descargas/* rw,

    # Red
    network tcp,
    network udp,
    network netlink raw,

    # GPU (WebGL)
    /dev/dri/* rw,
    /dev/nvidia* rw,

    # Microphone (WebRTC)
    /dev/snd/* rw,

    # Denegar acceso sensible
    deny @{HOME}/.ssh/** r,
    deny @{HOME}/.gnupg/** r,
    deny /etc/shadow r,
}
```

### 40.7 Generacion de perfiles (aa-genprof)

Para aplicaciones sin perfil, LNOS proporciona `aa-genprof` como herramienta de generacion:

```bash
# Generar perfil para una aplicacion
aa-genprof /usr/bin/miapp

# Flujo:
# 1. Ejecuta la aplicacion en modo complain
# 2. Registra todas las violaciones
# 3. Pregunta al administrador que permisos anadir
# 4. Genera el perfil
# 5. Activa modo enforce

# Alternativa: aa-logprof (basado en logs existentes)
aa-logprof
```

**Politica LNOS para perfiles de comunidad:**
- Los perfiles generados con `aa-genprof` deben ser revisados por el equipo de seguridad antes de incluirse en el repositorio oficial.
- Perfiles demasiado permisivos (que usan `/** rw,` sin restriccion) no son aceptados.
- Los perfiles deben pasar el validador de AppArmor: `apparmor_parser -O no-expr-simplify -d /etc/apparmor.d/ --show-cache`.

---

*Los capitulos 11 al 40 han sido completados. La especificacion continua con los capitulos 41 al 120.*---

## 41. SELinux (Evaluación)

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

## 42. Drivers Intel

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

## 43. Drivers AMD

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

## 44. Drivers NVIDIA

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

## 45. Microcode

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

## 46. Wayland

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

## 47. Hyprland

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

## 48. Configuración Completa de Hyprland

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

## 49. Waybar

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

## 50. Rofi

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

## 51. Kitty

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

## 52. Foot

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

## 53. Fastfetch

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

## 54. GTK

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

## 55. QT

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

## 56. Cursores

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

## 57. Iconos

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

## 58. Temas

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

## 59. Wallpapers

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

## 60. Fuentes

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

## 61. Pantalla de Bloqueo

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

## 62. Gestor de Energía

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

## 63. Laptop Mode

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

## 64. Optimización para Portátiles

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

## 65. Optimización para Sobremesas

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

## 66. Gaming

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

## 67. Steam

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

## 68. Proton

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

## 69. Wine

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

## 70. Vulkan

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

## 71. OpenGL

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

## 72. Mesa

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

## 73. Flatpak

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

## 74. Repositorios

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

## 75. AUR

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

## 76. Gestor Gráfico de Paquetes

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

## 77. Gestor de Actualizaciones

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

## 78. Actualizaciones Automáticas

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

## 79. Rollback

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

## 80. Snapshots

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
## 81. Btrfs

### 81.1 ¿Para qué existe?

Btrfs (B-tree File System) es el sistema de archivos por defecto de LNOS. Proporciona funcionalidades críticas que ningún otro sistema de archivos nativo de Linux ofrece de forma integrada: snapshots instantáneos, compresión transparente, checksumming de datos y metadatos, y capacidad de autocuración. En LNOS, Btrfs es la base sobre la que se construyen los sistemas de snapshots (Timeshift), rollback de actualizaciones, y compresión eficiente de almacenamiento.

**Justificación de la elección:** Ningún otro sistema de archivos en el kernel Linux mainline ofrece el conjunto completo de características que LNOS necesita para su estrategia de resiliencia. ext4 es estable pero carece de snapshots. XFS tiene snapshots (xfs_fsr) limitados y sin integración con herramientas de usuario. ZFS ofrece todo pero tiene problemas de licencia (CDDL vs GPL) que impiden su distribución en el kernel. Btrfs es la única opción que satisface todos los requisitos siendo parte del kernel upstream.

### 81.2 Alternativas descartadas

| Sistema | Razón del descarte |
|---------|-------------------|
| **ext4** | Sin snapshots, sin checksumming, sin compresión transparente. No permite implementar rollback de actualizaciones. |
| **XFS** | Snapshots no nativos (xfs_fsr es defragmentación, no snapshot). Sin compresión. Checksumming solo en metadatos (v5). Orientado a grandes archivos, no a escritorios. |
| **ZFS** | Licencia CDDL incompatible con GPL del kernel. No se distribuye como módulo del kernel upstream. OpenZFS requiere compilación externa. Complejidad de gestión excesiva para escritorio. |
| **F2FS** | Orientado a flash NAND (móviles/embedded). Sin snapshots. Sin checksumming robusto. Sin soporte de compresión maduro. |
| **bcachefs** | Prometedor pero experimental. No está en kernel mainline (a fecha de este documento). Inmaduro para producción en LNOS. |

### 81.3 Estructura de subvolúmenes

LNOS utiliza una estructura de subvolúmenes específica que maximiza las ventajas de Btrfs:

```
@          → /          (sistema)
@home     → /home      (datos de usuario)
@snapshots → /.snapshots (snapshots de Timeshift)
@log      → /var/log   (logs, sin COW para rendimiento)
@cache    → /var/cache (caché, sin COW para rendimiento)
@tmp      → /tmp       (archivos temporales, montado en RAM)
@swap     → /swap      (archivo de swap si no hay partición)
```

**Diagrama de árbol de subvolúmenes:**

```
Btrfs pool (single device o RAID)
│
├── @ (/)                    COW=activo, compress=zstd:1
│   ├── /usr
│   ├── /etc
│   ├── /opt
│   └── /var (excepto log, cache, tmp)
│
├── @home (/home)            COW=activo, compress=zstd:1
│
├── @snapshots (/.snapshots) COW=activo, compress=zstd:3
│
├── @log (/var/log)          COW=inactivo (nodatacow)
│
├── @cache (/var/cache)      COW=inactivo (nodatacow)
│
└── @swap (/swap)            COW=inactivo
```

**Justificación de cada subvolumen:**

| Subvolumen | COW | Compresión | Razón |
|-----------|-----|-----------|-------|
| `@` | Sí | zstd:1 | COW necesario para snapshots. Compresión ligera para sistema. |
| `@home` | Sí | zstd:1 | COW necesario para snapshots de datos de usuario. |
| `@snapshots` | Sí | zstd:3 | Snapshots se comprimen más agresivamente al ser datos fríos. |
| `@log` | No | No | Los logs rotan y reescriben; COW causa fragmentación masiva. |
| `@cache` | No | No | Cachés de paquetes y aplicaciones; COW empeora rendimiento. |
| `@tmp` | No (tmpfs) | No | Datos efímeros, en RAM. |
| `@swap` | No | No | COW en swap causa corrupción. |

### 81.4 Compresión

La compresión por defecto es `zstd:1` para los subvolúmenes `@` y `@home`. Esta configuración proporciona:

- **Ratio de compresión típico:** 1.3x–2.0x en datos del sistema, 1.5x–3.0x en home.
- **Overhead de CPU:** <5% en CPUs modernas (zstd es extremadamente rápido en nivel 1).
- **Ahorro en SSD:** Menos escrituras = mayor vida útil del SSD.

**Justificación de zstd sobre otras opciones:**

| Algoritmo | Ratio | Velocidad compresión | Velocidad descompresión | Uso en LNOS |
|-----------|-------|---------------------|------------------------|-------------|
| **zstd:1** | Bueno | Muy rápida | Muy rápida | **Por defecto** |
| zstd:3 | Mejor | Rápida | Muy rápida | Snapshots |
| lzo | Medio | Muy rápida | Rápida | Descartado (peor ratio) |
| zlib | Mejor | Lenta | Media | Descartado (lento para escritura) |
| Sin compresión | 1:1 | Máxima | Máxima | logs, cache, swap |

### 81.5 Checksumming y autocuración

Btrfs calcula checksums CRC-32C para todos los datos y metadatos. En configuraciones multi-dispositivo, cuando se detecta un checksum incorrecto:

1. Btrfs busca una copia válida en otro dispositivo (RAID1, RAID10, etc.).
2. Si encuentra una copia válida, repara automáticamente el bloque dañado.
3. Registra el evento en el journal del sistema.

En un solo dispositivo, el checksumming permite **detección** de corrupción silenciosa (bit rot), aunque no reparación (sin redundancia). El scrub periódico (ver capítulo 83) es el mecanismo para detectar y reportar estos errores.

### 81.6 Deduplicación

Deduplicación en Btrfs es **opcional** y no está activada por defecto. LNOS ofrece herramientas para activación manual:

| Herramienta | Método | Uso en LNOS |
|------------|--------|-------------|
| `duperemove` | Out-of-band, basado en hashes | Recomendado para datos de usuario con muchos duplicados (VM images, descargas) |
| `bees` | Online, en tiempo real | Opcional, para servidores o power users |
| `rmlint` | Offline | Útil para limpieza puntual |

**Por qué no está activado por defecto:** La deduplicación consume CPU y RAM significativamente. En un SSD moderno, el beneficio de espacio rara vez justifica el coste para el usuario típico de escritorio. Se ofrece como optimización avanzada.

### 81.7 Balance automático

Btrfs requiere balance periódico para reclamar chunks de datos/metadatos fragmentados. LNOS configura un timer systemd para balance automático:

```
lnos-btrfs-balance.service
├── Ejecuta: btrfs balance start -dusage=50 -musage=50 /
├── Frecuencia: semanal (lnos-btrfs-balance.timer)
└── Límite: 5 minutos máximo, cancelar si excede
```

**Justificación de parámetros:** `dusage=50` y `musage=50` solo reubican chunks con menos del 50% de uso, lo que es suficiente para mantener la fragmentación bajo control sin consumir CPU excesivamente.

### 81.8 Scrub periódico

El scrub verifica checksums de todos los datos y metadatos. LNOS configura:

```
lnos-btrfs-scrub.service
├── Ejecuta: btrfs scrub start -B /
├── Frecuencia: mensual (lnos-btrfs-scrub.timer)
└── Reporte: systemd-journald + lnos-report
```

### 81.9 Cómo se comunica con el resto del sistema

```
Btrfs ←→ Kernel (VFS)
   │
   ├──→ Timeshift (snapshots via ioctl BTRFS_IOC_SNAP_CREATE)
   ├──→ lnos-mod (rollback de módulos via snapshots)
   ├──→ systemd (journald en @log, tmp en tmpfs)
   ├──→ lnos-backup (send/receive para backups incrementales)
   └──→ lnos-report (estado de salud via btrfs device stats)
```

### 81.10 Dependencias

| Dependencia | Tipo | Razón |
|------------|------|-------|
| `btrfs-progs` | Paquete | Herramientas de usuario (mkfs, balance, scrub, etc.) |
| Kernel ≥ 6.6 | Sistema | Soporte Btrfs estable con todas las características |
| `python-btrfs` | Opcional | Scripts de monitoreo avanzado |
| `duperemove` | Opcional | Deduplicación |

### 81.11 Problemas potenciales y mitigaciones

| Problema | Síntoma | Mitigación |
|----------|---------|------------|
| Fragmentación con COW intenso | Rendimiento de escritura degradado | nodatacow en @log, @cache; balance periódico |
| Espacio agotado por snapshots | No se puede escribir | Política de retención en Timeshift; alerta al 80% |
| Checksum mismatch en single-device | Error en scrub | No reparable sin redundancia; notificar al usuario |
| ENOSPC con espacio libre aparente | "No space left" con `df` mostrando espacio | Balance; la fragmentación de chunks causa falsos ENOSPC |
| Quota groups lentos | Operaciones de qgroup ralentizan el sistema | No activar quotas a menos que sea necesario |

### 81.12 Cómo se prueba

| Test | Herramienta | Frecuencia |
|------|-----------|-----------|
| Integridad de datos | `btrfs check --readonly` | Mensual (scrub) |
| Rendimiento de compresión | `btrfs compression-show` | Post-instalación |
| Fragmentación | `btrfs filesystem defrag -c /` | Bajo demanda |
| Espacio por subvolumen | `btrfs filesystem usage /` | Semanal (script) |
| Snapshots funcionales | Crear/borrar snapshot de prueba | En tests CI |

### 81.13 Cómo se mantiene

El mantenimiento de Btrfs en LNOS es principalmente automático mediante timers systemd:

| Tarea | Timer | Herramienta |
|-------|-------|-----------|
| Scrub mensual | `lnos-btrfs-scrub.timer` | `btrfs scrub` |
| Balance semanal | `lnos-btrfs-balance.timer` | `btrfs balance` |
| Reporte de salud | `lnos-health-report.timer` | Script `verificar-salud.sh` |
| Limpieza de snapshots antiguos | Config Timeshift | Timeshift |

### 81.14 Cómo puede ampliarse

- **RAID:** Btrfs soporta RAID0, RAID1, RAID10, RAID5, RAID6 (RAID5/6 con precaución, ver bugs conocidos). LNOS puede añadir perfiles RAID en instalación avanzada.
- **Deduplicación:** Activar `bees` como servicio systemd para deduplicación en tiempo real.
- **Compresión por directorio:** Configurar compresión diferenciada por ruta mediante atributos extendidos.
- **Snapshots automáticos por aplicación:** Hooks en `lnos-mod` para snapshot previo a instalación de módulos.
- **Send/Receive:** Backup remoto de snapshots via SSH (btrfs send | ssh btrfs receive).

---

## 82. Timeshift

### 82.1 ¿Para qué existe?

Timeshift es el gestor de snapshots de LNOS. Proporciona protección contra actualizaciones fallidas, configuraciones incorrectas o cualquier cambio en el sistema que pueda dejarlo inestable. Permite al usuario "volver atrás en el tiempo" a un estado previo del sistema en segundos.

**¿Por qué Timeshift y no otra herramienta?** Timeshift está específicamente diseñado para Btrfs (modo Btrfs) y rsync (modo RSYNC). Su integración con Btrfs es la mejor del ecosistema Linux: utiliza directamente las capacidades de snapshot de Btrfs sin capas de abstracción adicionales, lo que garantiza que los snapshots sean instantáneos (independientemente del tamaño de datos) y ocupen espacio mínimo (solo las diferencias).

### 82.2 Alternativas descartadas

| Herramienta | Razón del descarte |
|------------|-------------------|
| **Snapper** | Buena herramienta pero configuración más compleja. Interfaz solo CLI. Políticas de retención menos intuitivas. No tiene interfaz gráfica nativa (necesita snapper-gui). |
| **Btrbk** | Excelente para backups Btrfs pero no diseñado como gestor de snapshots de sistema. Sin interfaz gráfica. |
| **systemd-snapshot** | No existe como herramienta madura. Funcionalidad limitada. |
| **Snap-pac** | Hook para Pacman que crea snapshots pre/post transacciones. Complementario a Timeshift (no sustituto). |

**Decisión:** Usar Timeshift como gestor principal y `snap-pac` como complemento para snapshots automáticos pre/post de Pacman.

### 82.3 Configuración de schedules

Timeshift en LNOS se configura con el siguiente esquema de retención:

| Tipo de snapshot | Frecuencia | Retención | Propósito |
|-----------------|-----------|-----------|-----------|
| **Horario** | Cada hora | 5 | Protección contra cambios recientes |
| **Diario** | Cada día | 7 | Protección diaria |
| **Semanal** | Cada semana | 4 | Protección semanal |
| **Mensual** | Cada mes | 3 | Protección a largo plazo |
| **Boot** | En cada arranque | 5 | Protección antes de cada sesión |
| **Pre/Post transacción** | Con cada `pacman` | Ilimitado (máx. 20) | Protección ante actualizaciones |

**Diagrama de política de retención:**

```
Línea temporal:
◄──────────────────────────────────────────────────────────────────────►
│         │         │         │         │         │         │         │
M3        M2        M1       S4       S3       S2       S1       Hoy
├─────────┴─────────┴─────────┴─────────┴─────────┴─────────┴─────────┤
│    3 mensuales    │     4 semanales    │  7 diarios  │  5 horarios  │
└─────────────────────────────────────────────────────────────────────┘
```

### 82.4 Integración con Btrfs

Timeshift opera en modo Btrfs, que utiliza los ioctls del kernel para crear snapshots:

```
Snapshot creation flow:

1. Timeshift solicita: btrfs subvolume snapshot -r @ @snapshots/2026-07-29_10-00-00
2. Kernel crea el snapshot (operación O(1), independiente del tamaño)
3. Timeshift registra el snapshot en su base de datos SQLite
4. El snapshot aparece en /.snapshots como subvolumen de solo lectura
5. Los snapshots antiguos se eliminan según política de retención:
   btrfs subvolume delete @snapshots/2026-07-22_10-00-00
```

**Ubicación de snapshots:**

```
/.snapshots/
├── 2026-07-29_10-00-00/    # Snapshot horario
│   ├── @                   # Subvolumen del sistema
│   └── @home               # Subvolumen de home (opcional)
├── 2026-07-29_06-00-00/
├── 2026-07-28_23-00-00/
└── ...
```

### 82.5 Interfaz GTK

Timeshift incluye interfaz gráfica GTK3 que LNOS integra en el Centro de Configuración. La interfaz permite:

- Ver lista de snapshots con fecha, tipo y descripción.
- Crear snapshots manuales.
- Restaurar snapshots seleccionados.
- Configurar schedules y retención.
- Excluir directorios.
- Ver espacio ocupado por snapshots.

**Integración en LNOS:** El Centro de Configuración (capítulo 94) expone la funcionalidad de Timeshift mediante su backend D-Bus, usando `pkexec timeshift-gtk` para operaciones privilegiadas.

### 82.6 Exclusión de directorios

Por defecto, Timeshift excluye:

```
@log/**      (/var/log)
@cache/**    (/var/cache)
@tmp/**      (/tmp)
/var/lib/docker/**
/var/lib/libvirt/images/**
/home/*/.cache/**
/home/*/.steam/**
/home/*/.local/share/Steam/**
/proc/**
/sys/**
/dev/**
/run/**
/mnt/**
/media/**
```

**Justificación de las exclusiones:**

| Exclusión | Razón |
|-----------|-------|
| `@log`, `@cache`, `@tmp` | Subvolúmenes sin COW; contenido efímero o regenerable |
| Docker/libvirt | Imágenes de contenedores/VMs muy grandes; deben respaldarse aparte |
| `.cache/`, `.steam/` | Datos regenerables, muy grandes, sin sentido en snapshot |
| `/proc`, `/sys`, `/dev`, `/run` | Sistemas de archivos virtuales del kernel |

### 82.7 Restauración desde Timeshift

LNOS soporta dos modos de restauración:

**Modo recovery desde bootloader:**

```
1. Arrancar el sistema
2. En systemd-boot, seleccionar "LNOS Recovery Mode"
3. El initramfs carga un entorno mínimo con Timeshift
4. Timeshift lista los snapshots disponibles
5. Usuario selecciona snapshot a restaurar
6. Timeshift restaura los subvolúmenes @ (y @home si se selecciona)
7. Se regenera initramfs
8. Se reinicia el sistema
```

**Modo recovery desde ISO:**

```
1. Arrancar ISO de LNOS
2. Seleccionar "Rescue Mode"
3. Montar el sistema instalado: mount -o subvol=@ /dev/sdX /mnt
4. Montar @home, @snapshots, EFI
5. Ejecutar timeshift --restore --snapshot-device /dev/sdX
6. Seleccionar snapshot desde la lista
7. Confirmar restauración
```

### 82.8 Dependencias

| Dependencia | Tipo | Razón |
|------------|------|-------|
| `timeshift` | Paquete | El gestor de snapshots |
| `btrfs-progs` | Paquete | Necesario para modo Btrfs |
| `polkit` | Paquete | Autorización para operaciones privilegiadas |
| `gtk3` | Paquete | Interfaz gráfica |
| `cronie` o `systemd-timers` | Paquete | Programación de snapshots automáticos |
| `snap-pac` | Opcional | Snapshots automáticos pre/post pacman |

### 82.9 Problemas potenciales y mitigaciones

| Problema | Síntoma | Mitigación |
|----------|---------|------------|
| Snapshots ocupan demasiado espacio | Disco lleno | Política de retención ajustada; alerta al 80% |
| Restauración falla por COW | Error al restaurar | Verificar que el subvolumen destino no es hijo del snapshot |
| Arranque lento con boot snapshots | Muchos snapshots boot | Limitar a 5 boot snapshots |
| Home incluido en snapshot de sistema | Home irrestaurable por error | Configurar exclusión de @home en snapshots de sistema |

### 82.10 Cómo se prueba

| Test | Procedimiento |
|------|--------------|
| Creación de snapshot | `timeshift --create --comments "test"`; verificar en `/.snapshots` |
| Restauración | `timeshift --restore --snapshot-device /dev/sdX --snapshot "test"` |
| Programación | Verificar que cron/systemd timer ejecuta timeshift |
| Exclusión | Crear archivo en directorio excluido; verificar que no aparece en snapshot |
| Integración GTK | Abrir timeshift-gtk; crear/restaurar snapshot |

### 82.11 Cómo se mantiene

- **Actualizaciones:** Timeshift se actualiza desde repositorios de Arch Linux (extra).
- **Configuración:** `/etc/timeshift/timeshift.json` generado y gestionado por lnos-storage.
- **Monitoreo:** El script `verificar-salud.sh` comprueba que los snapshots recientes están intactos.
- **Limpieza:** Timeshift elimina snapshots automáticamente según política de retención.

### 82.12 Cómo puede ampliarse

- **Hooks de módulos:** Los módulos LNOS pueden declarar `pre-install` hooks que crean un snapshot antes de la instalación.
- **Timeshift remoto:** Snapshots enviados a servidor remoto via `btrfs send/receive`.
- **Integración con lnos-software:** El centro de software puede mostrar snapshots disponibles antes de una actualización.
- **Restauración granular:** Restaurar archivos individuales desde un snapshot (montando el snapshot como read-only).

---

## 83. Scripts de Mantenimiento

### 83.1 ¿Para qué existe?

LNOS incluye un conjunto de scripts de mantenimiento que automatizan tareas críticas de salud del sistema. Estos scripts garantizan que el sistema se mantiene en estado óptimo sin intervención manual del usuario, siguiendo el principio de "automant mantenimiento".

**Filosofía:** Todo proceso de mantenimiento que puede automatizarse debe automatizarse. El usuario solo debe intervenir cuando algo requiere decisión humana.

### 83.2 Script: `limpiar-cache.sh`

**Propósito:** Liberar espacio en disco eliminando datos innecesarios.

**Operaciones:**

| Operación | Comando | Riesgo | Frecuencia |
|-----------|---------|--------|-----------|
| Limpiar caché de pacman | `pacman -Sc` | Bajo | Semanal |
| Limpiar caché de pacman no usado | `paccache -r -k 3` | Bajo | Semanal |
| Eliminar kernels antiguos | `pacman -Rns $(pacman -Qdtq)` | Medio | Mensual |
| Eliminar paquetes huérfanos | `pacman -Qtdq \| pacman -Rns -` | Medio | Mensual |
| Limpiar caché de flatpak | `flatpak uninstall --unused` | Bajo | Mensual |
| Limpiar caché de parches | `rm -rf /var/cache/pacman/pkg/*` | Bajo | Solo si emergencia |
| Limpiar logs antiguos | `journalctl --vacuum-time=30d` | Bajo | Mensual |

**Diagrama de flujo:**

```
limpiar-cache.sh
    │
    ├── 1. Verificar espacio libre en /
    │      └── Si < 20% → alerta temprana
    │
    ├── 2. Limpiar pacman (paccache -rk3)
    │
    ├── 3. Eliminar paquetes huérfanos (pacman -Qtdq)
    │
    ├── 4. Limpiar flatpak (flatpak uninstall --unused)
    │
    ├── 5. Vaciar logs antiguos (journalctl --vacuum-time=30d)
    │
    ├── 6. Registrar espacio recuperado en journald
    │
    └── 7. Reportar resultado
```

**Nota sobre seguridad:** La eliminación de kernels antiguos y paquetes huérfanos se confirma con `--print` primero. Si se detectan paquetes críticos en la lista de huérfanos, se aborta la operación.

### 83.3 Script: `verificar-salud.sh`

**Propósito:** Verificar el estado general del sistema y detectar problemas antes de que sean críticos.

**Operaciones:**

| Operación | Comando | Explicación |
|-----------|---------|-------------|
| Scrub Btrfs | `btrfs scrub start -B /` | Verifica checksums de todos los datos |
| Verificar sistema de archivos | `btrfs check --readonly /dev/sdX` | Comprueba integridad del FS (solo lectura) |
| Verificar journal | `journalctl -p 3 -b` | Busca errores del kernel y servicios |
| Verificar SMART | `smartctl -H /dev/sdX` | Health status del disco |
| Verificar SMART attributes | `smartctl -A /dev/sdX` | Atributos detallados (reallocated sectors, etc.) |
| Verificar memoria | `free -h` | Memoria disponible vs total |
| Verificar carga | `uptime` | Load average |
| Verificar temperatura | `sensors -j` | Temperaturas de CPU/GPU |
| Verificar zona de muerte | `btrfs device stats /` | Estadísticas de errores de dispositivo |

**Diagrama de flujo:**

```
verificar-salud.sh
    │
    ├── 1. Comprobar que se ejecuta como root
    │
    ├── 2. Btrfs scrub (solo si no hay otro en ejecución)
    │      └── Si errores → alerta + registrar en reporte
    │
    ├── 3. SMART check (todos los dispositivos)
    │      └── Si fallos → alerta URGENTE (email/notificación)
    │
    ├── 4. Journal errors (prioridad err/crit/alert/emerg)
    │      └── Si hay → listar los 10 más recientes
    │
    ├── 5. Sistema de archivos (btrfs check read-only)
    │      └── Si errores → alerta
    │
    ├── 6. Temperaturas
    │      └── Si > 85°C → alerta
    │
    └── 7. Generar reporte JSON en /var/log/lnos/health/
```

### 83.4 Script: `optimizar-repo.sh`

**Propósito:** Optimizar la configuración de repositorios para máxima velocidad y fiabilidad.

**Operaciones:**

| Operación | Comando | Frecuencia |
|-----------|---------|-----------|
| Actualizar mirrorlist | `reflector --latest 10 --protocol https --sort rate` | Mensual |
| Actualizar llaves de pacman | `pacman-key --refresh-keys` | Mensual |
| Verificar integridad DB | `pacman -Dk` | Mensual |
| Reindexar base de datos | `pacman -Syy` | Mensual (tras mirrorlist) |
| Verificar paquetes corruptos | `pacman -Qkk` | Mensual |

**Por qué Reflector y no RankMirrors:** Reflector es más rápido, más configurable, y está mantenido activamente. Soporta filtrado por protocolo, país, velocidad, y fecha de último refresh.

### 83.5 Script: `generar-reporte.sh`

**Propósito:** Generar un reporte completo del estado del sistema para revisión del usuario o envío a soporte.

**Contenido del reporte:**

```json
{
  "fecha": "2026-07-29T10:00:00Z",
  "hostname": "lnos-workstation",
  "kernel": "6.6.30-arch1-1",
  "uptime": "14d 3h 22m",
  "almacenamiento": {
    "total": 512687104512,
    "usado": 214748364800,
    "libre": 297938739712,
    "porcentaje": 41.9,
    "snapshots_count": 12,
    "snapshots_size": 42949672960
  },
  "memoria": {
    "total": 17179869184,
    "usado": 8589934592,
    "libre": 8589934592
  },
  "salud": {
    "btrfs_scrub_status": "ok",
    "btrfs_errors": 0,
    "smarts_status": ["PASS", "PASS"],
    "journal_errors_count": 2,
    "journal_errors_recent": [
      "kernel: ata1: softreset failed",
      "NetworkManager: connection timeout"
    ],
    "temperatura_cpu": 52,
    "temperatura_gpu": 48
  },
  "modulos": {
    "instalados": 14,
    "actualizables": 2,
    "rotos": 0
  },
  "paquetes": {
    "total": 1856,
    "explicitos": 342,
    "dependencias": 1514,
    "huérfanos": 0,
    "actualizaciones_disponibles": 23
  },
  "red": {
    "interfaces": ["wlp2s0", "enp3s0"],
    "ip_publica": "203.0.113.42",
    "dns": ["1.1.1.1", "8.8.8.8"]
  }
}
```

### 83.6 Programación (Cron y systemd timer)

Todos los scripts se ejecutan mediante **systemd timers** (no cron), por consistencia con el resto del sistema:

| Timer | Script | Schedule | Descripción |
|-------|--------|----------|-------------|
| `lnos-clean-cache.timer` | `limpiar-cache.sh` | weekly | Limpieza semanal de cachés |
| `lnos-health-check.timer` | `verificar-salud.sh` | daily | Verificación diaria de salud |
| `lnos-optimize-repo.timer` | `optimizar-repo.sh` | monthly | Optimización mensual de repositorios |
| `lnos-generate-report.timer` | `generar-reporte.sh` | weekly | Reporte semanal |

**Definición del timer systemd (ejemplo):**

```
[Unit]
Description=LNOS Health Check Timer

[Timer]
OnCalendar=daily
Persistent=true
RandomizedDelaySec=1h

[Install]
WantedBy=timers.target
```

**Por qué systemd timers en lugar de cron:**

| Aspecto | systemd timer | cron |
|---------|--------------|------|
| Integración con journald | Nativa | Requiere configuración |
| Dependencias entre servicios | Sí (After, Requires) | No |
| Randomización de ejecución | Sí (RandomizedDelaySec) | No |
| Persistencia tras apagado | Sí (Persistent=true) | Limitada (anacron) |
| Sandboxing del servicio | Sí (ProtectSystem, etc.) | No |
| Monitoreo de fallos | Sí (Restart=, FailureAction=) | No |

### 83.7 Cómo se comunica con el resto del sistema

```
Scripts de Mantenimiento
    │
    ├──→ systemd-journald (logs de ejecución)
    ├──→ lnos-report (datos para reporte)
    ├──→ /var/log/lnos/health/ (reportes JSON históricos)
    ├──→ Timeshift (crear snapshot antes de limpieza agresiva)
    └──→ notificaciones (dunst, si es escritorio)
```

### 83.8 Dependencias

| Script | Dependencias |
|--------|-------------|
| `limpiar-cache.sh` | pacman, paccache (pacman-contrib), flatpak (opcional) |
| `verificar-salud.sh` | btrfs-progs, smartmontools, lm_sensors, coreutils |
| `optimizar-repo.sh` | reflector, pacman, pacman-key |
| `generar-reporte.sh` | jq, coreutils, btrfs-progs, smartmontools |

### 83.9 Problemas potenciales y mitigaciones

| Problema | Mitigación |
|----------|-----------|
| Script elimina paquetes necesarios | `--dry-run` primero; confirmación para operaciones destructivas |
| Scrub Btrfs consume I/O en horas de trabajo | Programar en horario nocturno (RandomizedDelaySec) |
| Reflector falla por falta de red | Comprobar conectividad antes; mantener mirrorlist anterior |
| SMART falla en VM/containers | Detectar virtualización y omitir SMART |
| Reporte ocupa demasiado espacio | Rotar reportes >30 días |

### 83.10 Cómo se prueba

| Test | Método |
|------|--------|
| Script unitario | Ejecutar con `--dry-run` y verificar salida |
| Timer funciona | `systemctl list-timers --all \| grep lnos` |
| Reporte es válido | `jq . /var/log/lnos/health/*.json` y verificar estructura |
| No elimina paquetes críticos | Ejecutar en contenedor de prueba con paquetes mínimos |
| Integridad tras ejecución | Comparar checksums de binarios del sistema antes/después |

### 83.11 Cómo se mantiene

- **Scripts en repositorio Git:** `/usr/share/lnos/scripts/` enlazados simbólicamente a `/etc/lnos/scripts/`.
- **Actualizaciones:** Via módulo `lnos-base` (actualización de paquetes).
- **Logs:** Todos los scripts registran en systemd-journald con identificador `lnos-maint`.
- **Override:** Los usuarios pueden sobrescribir scripts en `/etc/lnos/scripts/` (no se sobrescriben en actualizaciones).

### 83.12 Cómo puede ampliarse

- **Scripts personalizados:** Los usuarios pueden añadir scripts en `/etc/lnos/scripts/custom/` que se ejecutan con los demás.
- **Hooks de módulos:** Los módulos pueden declarar scripts de mantenimiento adicionales en su `module.toml`.
- **Alertas vía email/webhook:** Configurable para entornos server.
- **Dashboard web:** Los reportes JSON pueden ser consumidos por una interfaz web tipo Netdata.

---

## 84. Backups

### 84.1 ¿Para qué existe?

LNOS implementa una estrategia de backups que garantiza la recuperación del sistema y los datos del usuario ante fallos catastróficos (robo, incendio, fallo de disco). Mientras que Timeshift protege contra errores lógicos (configuración incorrecta, actualización fallida), los backups protegen contra pérdida física de datos.

**Filosofía de backups en LNOS:**

```
Backups LNOS
├── Snapshots locales (Timeshift) → Protección lógica, rápida
├── Backup local (borg) → Protección física local
└── Backup remoto (borg + cloud) → Protección geográfica (3-2-1)
```

### 84.2 Alternativas descartadas

| Herramienta | Razón del descarte |
|------------|-------------------|
| **rsync + cron** | Sin deduplicación, sin cifrado integrado, sin gestión de versiones. Cada backup es una copia completa o incremental plana. |
| **Restic** | Excelente herramienta. Se ofrece como alternativa. Descartada como principal porque borg tiene mejor deduplicación y compresión. |
| **Duplicati** | Basado en .NET/Mono. Problemas de rendimiento y estabilidad en Linux. |
| **Deja Dup** | Interfaz sobre Duplicity. Lento, sin deduplicación eficiente. |
| **Back In Time** | Simple pero sin cifrado, sin deduplicación. |
| **Bacula** | Demasiado pesado para escritorio. Orientado a empresa. |

**Decisión: borgbackup como herramienta recomendada por defecto.**

### 84.3 ¿Por qué borgbackup?

| Característica | borgbackup | restic | rsync |
|---------------|-----------|--------|-------|
| Deduplicación | Sí (basada en chunks variables) | Sí | No |
| Compresión | Sí (lz4, zstd, zlib, lzma) | Sí | No |
| Cifrado | Sí (AES-256-CTR + HMAC-SHA256) | Sí | No (solo con SSH) |
| Backups incrementales | Sí (solo chunks nuevos) | Sí | Sí (rsync --link-dest) |
| Montar backup como FS | Sí (FUSE) | Sí | No |
| Rendimiento dedup | Excelente | Bueno | N/A |
| Integridad checksum | Sí (CRC32 + HMAC) | Sí | No |

### 84.4 Configuración de repositorios

**Repositorio local:**

```
/etc/lnos/backup/local.toml:

[repository]
type = "local"
path = "/mnt/backup/lnos"
encryption = "keyfile"
compression = "zstd,6"

[schedule]
frequency = "daily"
time = "03:00"
retention = { keep_daily = 7, keep_weekly = 4, keep_monthly = 6 }
```

**Repositorio remoto (via SSH):**

```
/etc/lnos/backup/remote.toml:

[repository]
type = "ssh"
host = "backup.example.com"
port = 22
path = "/backups/lnos"
encryption = "keyfile"
compression = "zstd,6"

[schedule]
frequency = "weekly"
time = "04:00"
retention = { keep_daily = 7, keep_weekly = 4, keep_monthly = 12 }
```

**Integración con módulo cloud** (capítulo 91): Si el módulo `lnos-cloud` está instalado, los repositorios remotos pueden ser servicios cloud (Nextcloud, S3, etc.) mediante rclone.

### 84.5 Automatización con systemd timer

```
lnos-backup-local.service / .timer    → Backup diario a disco local
lnos-backup-remote.service / .timer   → Backup semanal a remoto
```

**Definición del servicio:**

```
[Unit]
Description=LNOS Borg Backup
Documentation=https://lnos.dev/docs/backup

[Service]
Type=oneshot
ExecStart=/usr/bin/lnos-backup run
Environment=BORG_REPO=/mnt/backup/lnos
Environment=BORG_PASSPHRASE_FILE=/etc/lnos/backup/passphrase
Environment=BORG_RSH=ssh -i /etc/lnos/backup/id_ed25519
Nice=19
IOSchedulingClass=idle
ProtectSystem=strict
ProtectHome=read-only
ReadWritePaths=/mnt/backup
```

### 84.6 Directorios incluidos y excluidos

**Por defecto, se incluye:**

```
/home/          → Datos de usuario (cada usuario es un backup distinto)
/etc/           → Configuración del sistema
/var/lib/       → Datos de aplicaciones (docker, libvirt, etc.)
/root/          → Home de root
```

**Por defecto, se excluye:**

```
/home/*/.cache/         → Cachés regenerables
/home/*/.steam/         → Juegos (muy grandes, respaldar aparte)
/home/*/Downloads/      → Descargas (no críticas)
/var/cache/             → Cachés del sistema
/var/log/               → Logs (se respaldan en snapshots)
/var/tmp/               → Temporales
/proc/, /sys/, /dev/, /run/, /mnt/, /media/
```

### 84.7 Restauración

```bash
# Listar backups disponibles
lnos-backup list

# Restaurar backup completo del sistema
lnos-backup restore --repo /mnt/backup/lnos --archive lnos-2026-07-29

# Restaurar archivos específicos
lnos-backup restore --repo /mnt/backup/lnos --path home/usuario/documentos

# Montar backup como sistema de archivos
lnos-backup mount --repo /mnt/backup/lnos --archive lnos-2026-07-29 /mnt/restore
```

### 84.8 Dependencias

| Dependencia | Tipo | Razón |
|------------|------|-------|
| `borg` | Paquete | Herramienta principal de backup |
| `openssh` | Paquete | Repositorios remotos via SSH |
| `rclone` | Opcional | Repositorios cloud |
| `python` | Paquete | Scripts auxiliares de borg |
| `jq` | Paquete | Formateo de reportes |

### 84.9 Problemas potenciales y mitigaciones

| Problema | Mitigación |
|----------|-----------|
| Backup remoto falla por red | Programar reintentos (3 intentos, backoff exponencial) |
| Repositorio local lleno | Alerta cuando <10% espacio libre en disco de backup |
| Clave de cifrado perdida | Imprimir y almacenar clave de recuperación en lugar seguro |
| Borg corrompe repositorio | `borg check` semanal; mantener repositorio redundante |
| Backup muy lento | Prioridad idle (Nice=19, IOSchedulingClass=idle) en horario nocturno |

### 84.10 Cómo se prueba

| Test | Procedimiento |
|------|--------------|
| Backup completo | Ejecutar `lnos-backup run` y verificar código de salida |
| Restauración | Restaurar en directorio temporal y comparar checksums |
| Integridad | `borg check --verify-data REPO` |
| Cifrado | Verificar que los archivos del repositorio están cifrados |
| Automatización | Verificar `systemctl status lnos-backup-*.timer` |

### 84.11 Cómo se mantiene

- **Actualización de borg:** Via pacman (módulo lnos-base).
- **Verificación de repositorios:** `lnos-backup check` semanal (integrado en `verificar-salud.sh`).
- **Rotación de claves:** Se recomienda rotar claves SSH cada 2 años.
- **Logs:** Todos los backups registran en systemd-journald con identificador `lnos-backup`.

### 84.12 Cómo puede ampliarse

- **Múltiples repositorios:** Configurar varios destinos simultáneamente.
- **Pre/Post hooks:** Ejecutar scripts antes/después del backup (ej: dump de base de datos).
- **Integración con lnos-config:** Interfaz gráfica para gestión de backups.
- **Backup de módulos:** Los módulos pueden declarar rutas a incluir en backup.

---

## 85. Recuperación

### 85.1 ¿Para qué existe?

El sistema de recuperación de LNOS proporciona mecanismos para restaurar el sistema ante cualquier tipo de fallo, desde un paquete roto hasta un disco dañado. La filosofía es que **ningún problema debe requerir reinstalación completa**.

### 85.2 Modos de recuperación

LNOS ofrece múltiples modos de recuperación, ordenados por severidad:

```
Nivel 1: Systemd-boot fallback
    └── Snapshot previo al cambio
    └── Kernel antiguo (fallback initramfs)

Nivel 2: Recovery mode (desde bootloader)
    └── Root shell con herramientas de recuperación
    └── Timeshift para restaurar snapshot
    └── Chroot al sistema instalado

Nivel 3: Live ISO (modo rescue)
    └── Shell completa con todas las herramientas
    └── Reparación de Btrfs
    └── Reinstalación sin perder /home

Nivel 4: Reinstalación completa
    └── Preservar @home
    └── Reinstalar sistema
    └── Restaurar configuración desde backup
```

### 85.3 Modo recovery desde bootloader

**Entrada de systemd-boot:**

```
title   LNOS Recovery Mode
linux   /vmlinuz-linux-lnos
initrd  /initramfs-linux-lnos-recovery.img
options root=UUID=... rw lnos.recovery
```

**El initramfs de recovery contiene:**

- Root shell con bash
- Btrfs progs completos
- Timeshift
- NetworkManager (para recovery remoto)
- SSH server (opcional, con contraseña temporal)
- `lnos-recovery` (herramienta de recuperación guiada)
- `chroot` al sistema instalado

**Flujo de recovery desde bootloader:**

```
1. Arrancar y seleccionar "LNOS Recovery Mode"
2. Cargar initramfs de recovery
3. Sistema monta todos los subvolúmenes en /mnt
4. Se presenta shell root o menú interactivo:
    ┌─────────────────────────────────────┐
    │     LNOS Recovery Mode              │
    │                                     │
    │  1. Restaurar snapshot (Timeshift)  │
    │  2. Reparar Btrfs                   │
    │  3. Chroot al sistema               │
    │  4. Reparar bootloader              │
    │  5. Activar SSH para recovery remoto│
    │  6. Shell root                      │
    └─────────────────────────────────────┘
5. Usuario selecciona opción
```

### 85.4 Restauración de snapshots desde recovery

```
Menú → Opción 1: Restaurar snapshot

1. Timeshift escanea /.snapshots en /mnt/.snapshots
2. Muestra lista de snapshots disponibles
3. Usuario selecciona snapshot
4. Timeshift restaura:
   - Reemplaza @ (subvolumen de sistema)
   - Opcional: reemplaza @home
5. Regenera initramfs
6. Pregunta: ¿Reiniciar ahora?
```

### 85.5 Reinstalación sin perder /home

En caso de daño irreparable del sistema, LNOS permite reinstalar preservando `/home`:

```
1. Arrancar ISO de LNOS
2. Seleccionar "Instalación personalizada"
3. Seleccionar disco existente
4. Elegir opción: "Reinstalar sistema, preservar /home"
5. Instalador:
   a. Detecta subvolúmenes existentes
   b. Borra @ (sistema) pero preserva @home
   c. Recrea @ con configuración limpia
   d. Monta @home existente
   e. Instala paquetes
   f. Mantiene usuarios y datos intactos
```

**Diagrama de preservación de datos:**

```
Antes:                    Después:
/dev/sdX                  /dev/sdX
├── @ (roto)              ├── @ (nuevo sistema)
├── @home (intacto)  →    ├── @home (preservado)
├── @snapshots            ├── @snapshots (preservado)
├── @log                  ├── @log (nuevo)
└── @cache                └── @cache (nuevo)
```

### 85.6 Live ISO como rescue

La ISO de LNOS puede arrancarse en modo rescue:

```
lnos.rescue   →   Modo rescue completo

En modo rescue, la ISO proporciona:
- Terminal root
- NetworkManager activo
- SSH server (lnos.ssh para activar)
- btrfs-progs, smartmontools, fsck, parted, gdisk
- timeshift, borg (si ISO completa)
- chroot, arch-chroot
- lnos-repair (herramienta de reparación guiada)
```

### 85.7 Reparación de Btrfs

La herramienta `lnos-repair` guía al usuario en la reparación de Btrfs:

```
lnos-repair --device /dev/sdX

1. Detectar problema:
   - btrfs check --readonly /dev/sdX
   - Analizar tipo de error

2. Si error menor:
   - btrfs check --repair /dev/sdX (CONFIRMAR con usuario)

3. Si error mayor (estructura):
   - Extraer datos via btrfs restore
   - Recomendar reinstalación preservando @home

4. Si dispositivo fallando (SMART errores):
   - btrfs replace (si RAID)
   - ddrescue + btrfs restore
```

**ADVERTENCIA:** `btrfs check --repair` se considera una operación de último recurso. LNOS siempre recomienda restaurar desde snapshot o backup antes de reparar in-place.

### 85.8 Chroot desde ISO

```
1. Arrancar ISO → Modo rescue
2. Montar subvolúmenes:
   mount -o subvol=@ /dev/sdX /mnt
   mount -o subvol=@home /dev/sdX /mnt/home
   mount /dev/sdX1 /mnt/boot  (EFI)
3. Bind mount sistemas virtuales:
   mount --bind /dev /mnt/dev
   mount --bind /proc /mnt/proc
   mount --bind /sys /mnt/sys
4. Chroot:
   arch-chroot /mnt
5. Reparar: regenerar initramfs, reinstalar paquetes, etc.
```

### 85.9 Cómo se comunica con el resto del sistema

```
Recuperación
    ├──→ Timeshift (restaurar snapshots)
    ├──→ Btrfs (reparar, restore, check)
    ├──→ systemd-boot (entradas de recovery)
    ├──→ mkinitcpio (initramfs de recovery)
    ├──→ lnos-backup (restaurar desde backup)
    └──→ NetworkManager (SSH remoto)
```

### 85.10 Dependencias

| Dependencia | Tipo | Razón |
|------------|------|-------|
| `btrfs-progs` | Paquete | Herramientas de reparación Btrfs |
| `timeshift` | Paquete | Restauración de snapshots |
| `mkinitcpio` | Paquete | Initramfs de recovery personalizado |
| `openssh` | Opcional | Recovery remoto |
| `smartmontools` | Paquete | Diagnóstico de disco |
| `parted`, `gdisk` | Paquete | Reparación de particiones |
| `arch-install-scripts` | Paquete | arch-chroot |

### 85.11 Problemas potenciales y mitigaciones

| Problema | Mitigación |
|----------|-----------|
| Initramfs de recovery dañado | ISO de rescate como fallback |
| Snapshot también dañado | Backups borg como último recurso |
| Disco fallando irreparablemente | Reemplazo de disco + restauración desde backup remoto |
| Usuario no tiene contraseña de root | Recovery ofrece shell sin autenticación (solo local) |
| Red no disponible para recovery remoto | Recovery local siempre disponible |

### 85.12 Cómo se prueba

| Test | Procedimiento |
|------|--------------|
| Initramfs recovery | Arrancar opción recovery; verificar que aparece shell |
| Restauración snapshot | Crear snapshot, romper sistema, restaurar, verificar |
| Chroot desde ISO | Arrancar ISO, chroot, verificar acceso a herramientas |
| Reinstalación parcial | Reinstalar preservando home, verificar datos intactos |
| Reparación Btrfs | Inducir error en dispositivo de prueba, ejecutar lnos-repair |

### 85.13 Cómo se mantiene

- **Initramfs recovery:** Se regenera con cada actualización del kernel (hook mkinitcpio).
- **Herramientas:** Se actualizan via pacman.
- **Scripts de recovery:** `/usr/share/lnos/recovery/`, actualizables por módulo.
- **Documentación:** Cada módulo documenta su procedimiento de recuperación específico.

### 85.14 Cómo puede ampliarse

- **Recovery remoto vía web:** Interfaz web minimalista en initramfs para recovery sin SSH.
- **Recovery automático:** Si el sistema falla 3 arranques seguidos, arrancar automáticamente en modo recovery.
- **Recovery de módulos:** Scripts de recovery específicos por módulo (ej: recovery de base de datos, recovery de Docker).
- **Integración con Netboot:** Recovery via PXE para despliegues empresariales.

---

## 86. Impresoras

### 86.1 ¿Para qué existe?

LNOS proporciona soporte completo de impresión mediante CUPS (Common Unix Printing System), el estándar de facto para impresión en Linux. La configuración por defecto permite que la mayoría de impresoras sean detectadas y configuradas automáticamente.

**¿Por qué CUPS?** CUPS es el sistema de impresión más maduro y compatible del ecosistema Linux. Soportado por prácticamente todos los fabricantes, con drivers para impresoras de todas las épocas. Avahi (Bonjour) permite descubrimiento automático de impresoras de red.

### 86.2 Alternativas descartadas

| Alternativa | Razón del descarte |
|------------|-------------------|
| **systemd-cups** | No existe como entidad separada; CUPS ya se integra con systemd |
| **IPP Everywhere** | Solo impresoras modernas; no cubre impresoras legacy |
| **Samba printing** | Solo necesario para impresoras compartidas en red Windows |
| **LPRng** | Obsoleto, reemplazado completamente por CUPS |

### 86.3 Arquitectura

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  Aplicación   │────►│   CUPS       │────►│   Backend     │
│  (LibreOffice)│     │  localhost:631│     │  (usb, ipp,   │
└──────────────┘     └──────────────┘     │  socket, lpd)  │
                           │              └──────┬───────┘
                           ▼                     ▼
                    ┌──────────────┐     ┌──────────────┐
                    │  Avahi/mDNS   │     │  Impresora    │
                    │  (descubrim.)│     │  (USB/Red)    │
                    └──────────────┘     └──────────────┘
```

### 86.4 Drivers incluidos

| Driver | Fabricantes | Tipo |
|--------|------------|------|
| **Gutenprint** | Canon, Epson, HP, Brother, Lexmark | Controladores de código abierto de alta calidad |
| **HPLIP** | HP (todas las series) | Oficial HP, código abierto |
| **brlaser** | Brother (láser) | Controlador genérico para Brother |
| **brscan4** | Brother (escaner) | Parte de HPLIP alternativo |
| **splix** | Samsung (CLP-5/6, ML-1x00) | Controlador para Samsung antiguas |
| **cups-pdf** | Virtual | Imprimir a PDF (muy útil) |
| **cups-filters** | Genérico | Filtros de impresión (PDF→PS, etc.) |
| **foomatic-db** | Genérico | Base de datos de drivers foomatic |
| **hpcups** | HP | Integrado en HPLIP |

**Por defecto se instalan:**
- `cups`, `cups-filters`, `cups-pdf`
- `gutenprint`
- `hplip`
- `avahi`, `nss-mdns`
- `system-config-printer`

### 86.5 Configuración por defecto

**CUPS configurado para:**

- Escuchar en `localhost:631` (interfaz web de administración)
- Descubrimiento de impresoras de red via mDNS/Bonjour (Avahi)
- Autenticación vía Polkit para operaciones administrativas
- Compartición de impresoras desactivada por defecto
- Registro de trabajos en systemd-journald

**Firewall (firewalld) para impresión en red:**

```
# Impresoras locales (descubrimiento mDNS)
firewall-cmd --add-service=ipp-client --permanent
firewall-cmd --add-service=mdns --permanent

# Compartición de impresoras (opcional, desactivado por defecto)
firewall-cmd --add-service=ipp --permanent
firewall-cmd --add-service=printer --permanent
```

### 86.6 system-config-printer

`system-config-printer` es la interfaz gráfica de administración de impresoras. LNOS la integra en el Centro de Configuración:

```
lnos-config → Dispositivos → Impresoras
    ├── Añadir impresora (detección automática)
    ├── Gestionar trabajos de impresión
    ├── Configurar opciones (calidad, papel, color)
    ├── Compartir impresora en red
    └── Estado y tinta
```

### 86.7 Cómo se comunica con el resto del sistema

```
CUPS ←→ Kernel (USB, parport)
  │
  ├──→ Avahi (descubrimiento mDNS de impresoras de red)
  ├──→ firewalld (apertura de puertos)
  ├──→ Polkit (autorización administrativa)
  ├──→ systemd (cups.service, cups.socket, cups.path)
  └──→ lnos-config (interfaz gráfica de gestión)
```

### 86.8 Dependencias

| Dependencia | Tipo | Razón |
|------------|------|-------|
| `cups` | Paquete | Servidor de impresión |
| `cups-filters` | Paquete | Filtros de impresión |
| `cups-pdf` | Paquete | Impresora virtual PDF |
| `gutenprint` | Paquete | Drivers genéricos |
| `hplip` | Paquete | Drivers HP |
| `avahi` | Paquete | Descubrimiento mDNS |
| `nss-mdns` | Paquete | Resolución .local |
| `system-config-printer` | Paquete | Interfaz gráfica |

### 86.9 Problemas potenciales y mitigaciones

| Problema | Mitigación |
|----------|-----------|
| Impresora no detectada por USB | Verificar `lsusb`, comprobar driver específico |
| mDNS no resuelve `.local` | Verificar `nss-mdns` en `/etc/nsswitch.conf` |
| Firewall bloquea descubrimiento | Añadir servicios ipp-client, mdns |
| HPLIP no reconoce HP | Instalar `python-pyqt5` (requisito HPLIP GUI) |
| Impresión lenta | Reducir resolución en opciones de impresión |

### 86.10 Cómo se prueba

| Test | Procedimiento |
|------|--------------|
| CUPS funcionando | `systemctl status cups`; acceder a `http://localhost:631` |
| Detección USB | Conectar impresora USB; `lpinfo -v` debe mostrar el dispositivo |
| Detección red | Conectar impresora de red; Avahi debe descubrirla (`avahi-browse -a`) |
| Impresión de prueba | `lp -d printer_name /usr/share/cups/data/testprint.ps` |
| Impresión PDF | `lp -d cups-pdf /path/to/document.pdf` |

### 86.11 Cómo se mantiene

- **CUPS:** Se actualiza via pacman. La configuración está en `/etc/cups/`.
- **Drivers:** Se actualizan con el sistema. HPLIP requiere atención especial (a veces rompe con versiones nuevas de CUPS).
- **Logs:** `journalctl -u cups` para depuración.
- **Reinicio:** `cups.socket` activa cups.service bajo demanda (socket activation).

### 86.12 Cómo puede ampliarse

- **Samba sharing:** Compartir impresoras con clientes Windows via `samba`.
- **Impresoras 3D:** Módulo `lnos-3d-printing` para OctoPrint, Cura, etc.
- **Driverless printing:** IPP Everywhere para impresoras modernas (sin necesidad de drivers).
- **Escaneo a impresora multifunción:** Ver capítulo 87 (Escáneres).

---

## 87. Escáneres

### 87.1 ¿Para qué existe?

El soporte de escáneres en LNOS se basa en SANE (Scanner Access Now Easy), el estándar de facto para acceso a escáneres en Linux. Proporciona una capa de abstracción que permite a cualquier aplicación escanear independientemente del hardware subyacente.

**¿Por qué SANE?** SANE es el estándar más extendido, con soporte para cientos de escáneres de todos los fabricantes. Su arquitectura cliente-servidor permite escanear tanto local como remotamente.

### 87.2 Alternativas descartadas

| Alternativa | Razón del descarte |
|------------|-------------------|
| **libsane** | Es SANE mismo (librería). No es alternativa. |
| **sane-airscan** | No es alternativa, es extensión de SANE para eSCL/WSD. |
| **VueScan (privativo)** | Propietario, caro, no necesario con SANE. |
| **Escáner via CUPS** | Limitado a multifunción, no cubre escáneres solo scan. |

### 87.3 Arquitectura

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  Aplicación   │────►│   SANE        │────►│   Backend     │
│  (simple-scan)│     │  libsane      │     │  (genesys,    │
└──────────────┘     └──────────────┘     │  epkowa, ...)  │
                           │              └──────┬───────┘
                           ▼                     ▼
                    ┌──────────────┐     ┌──────────────┐
                    │  sane-airscan │     │  Escáner      │
                    │  (eSCL/WSD)   │     │  (USB/Red)    │
                    └──────────────┘     └──────────────┘
```

### 87.4 Componentes incluidos

| Componente | Descripción |
|-----------|-----------|
| `sane` | Librería y backend SANE |
| `sane-airscan` | Backend para escáneres de red (eSCL, WSD) |
| `simple-scan` | Aplicación GUI de escaneo (GNOME) |
| `xsane` | Aplicación GUI avanzada |
| `skanlite` | Aplicación GUI KDE (opcional) |
| `sane-utils` | Herramientas CLI (`scanimage`, `scanadf`) |
| Drivers específicos | `samsung-scanner`, `brother-scanner`, `epkowa` (Epson) |

### 87.5 sane-airscan (eSCL/WSD)

`sane-airscan` es el backend que permite escanear sin drivers a través de la red usando los protocolos:

- **eSCL** (Apple AirScan): Protocolo moderno soportado por la mayoría de multifunción recientes.
- **WSD** (Web Services on Devices): Protocolo de Microsoft para descubrimiento de dispositivos.

**Por qué es importante:** Elimina la necesidad de drivers propietarios para escáneres de red modernos. Simplemente conecta la multifunción a la red y `sane-airscan` la descubre automáticamente via mDNS.

### 87.6 Configuración de red para escáneres

**Descubrimiento automático (mDNS):**

```
# Asegurar que Avahi está activo
systemctl enable --now avahi-daemon.service

# Verificar descubrimiento
avahi-browse -a | grep -i scan
  + wlp2s0 IPv4 EPSON XP-3100 series      _uscan._tcp    local
  + wlp2s0 IPv4 EPSON XP-3100 series      _uscans._tcp   local
```

**Configuración manual (si no hay descubrimiento):**

```
# /etc/sane.d/airscan.conf
[devices]
"EPSON XP-3100" = "http://192.168.1.100:443/eSCL/"
```

**Firewall:**

```
firewall-cmd --add-service=mdns --permanent     # mDNS discovery
firewall-cmd --add-port=5353/udp --permanent    # mDNS
firewall-cmd --add-service=wsd --permanent      # WSD discovery (opcional)
```

### 87.7 Cómo se comunica con el resto del sistema

```
SANE (libsane)
  │
  ├──→ kernel (USB via libusb, SCSI vía kernel drivers)
  ├──→ Avahi (descubrimiento de escáneres de red)
  ├──→ sane-airscan (protocolo eSCL/WSD)
  ├──→ simple-scan, xsane, skanlite (GUI)
  ├──→ lnos-config (Centro de Configuración → Dispositivos → Escáner)
  └──→ firewalld (apertura de puertos para escáner de red)
```

### 87.8 Dependencias

| Dependencia | Tipo | Razón |
|------------|------|-------|
| `sane` | Paquete | Librería y backends |
| `sane-airscan` | Paquete | Backend eSCL/WSD para escáneres de red |
| `simple-scan` | Paquete | GUI de escaneo por defecto |
| `avahi` | Paquete | Descubrimiento mDNS |
| `libusb` | Paquete | Acceso USB a escáneres |
| Drivers fabricante | Opcional | Según modelo |

### 87.9 Problemas potenciales y mitigaciones

| Problema | Mitigación |
|----------|-----------|
| Escáner no detectado | `scanimage -L` para listar dispositivos; verificar permisos USB |
| Permisos insuficientes | Añadir usuario al grupo `scanner` |
| sane-airscan no encuentra escáner | Verificar que escáner y PC están en misma VLAN; probar configuración manual |
| Escáner USB no aparece | `lsusb` para verificar conexión; instalar backend propietario si existe |
| Escaneo muy lento | Reducir resolución (300 DPI es suficiente para documentos) |

### 87.10 Cómo se prueba

| Test | Procedimiento |
|------|--------------|
| Detección USB | Conectar escáner USB; `scanimage -L` debe listarlo |
| Detección red | Conectar multifunción; `avahi-browse -a \| grep -i scan` |
| Escaneo CLI | `scanimage > test.pnm`; verificar archivo generado |
| Escaneo GUI | `simple-scan`; escanear y guardar PDF |
| ADF (alimentador) | `scanimage --source "ADF" > documento.pdf` |

### 87.11 Cómo se mantiene

- **SANE:** Actualización via pacman. La base de datos de dispositivos se actualiza automáticamente.
- **sane-airscan:** Actualizaciones frecuentes; mantenido por comunidad.
- **Configuración:** `/etc/sane.d/` para configuración de backends.
- **Logs:** `sane-find-scanner -q` para depuración de detección.

### 87.12 Cómo puede ampliarse

- **Escaneo remoto:** `saned` (SANE daemon) permite escanear desde otros ordenadores de la red.
- **Escaneo a PDF automático:** Script que escanea y convierte automáticamente al conectar documento.
- **OCR:** Integración con `tesseract` para escaneo con reconocimiento de texto.
- **Escaneo por lotes:** `scanadf` para escaneo automático desde alimentador.

---

## 88. Cámaras

### 88.1 ¿Para qué existe?

El soporte de cámaras en LNOS cubre tanto webcams integradas (laptops) como cámaras USB externas y cámaras IP de red. La base tecnológica es V4L2 (Video4Linux 2), el framework de captura de video del kernel Linux.

**¿Por qué V4L2?** Es el estándar del kernel para captura de video. Cualquier cámara compatible con UVC (USB Video Class) funciona automáticamente sin drivers adicionales. PipeWire proporciona la capa de usuario para compartir la cámara entre múltiples aplicaciones.

### 88.2 Alternativas descartadas

| Alternativa | Razón del descarte |
|------------|-------------------|
| **GStreamer standalone** | Puede capturar video pero no gestiona el permiso de cámara a nivel de sistema |
| **FFmpeg directo** | Solo captura, no ofrece compartición entre apps |
| **V4L1** | Obsoleto, reemplazado por V4L2 |
| **libuvc** | Librería de usuario para UVC; duplica funcionalidad de V4L2 |

### 88.3 Arquitectura

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  Aplicación   │────►│  PipeWire     │────►│  V4L2         │
│  (Zoom/Chrome)│     │  (cámara node)│     │  (kernel)     │
└──────────────┘     └──────────────┘     └──────┬───────┘
                                                  │
                    ┌──────────────┐              ▼
                    │  Cámara IP    │     ┌──────────────┐
                    │  (RTSP/ONVIF) │     │  Cámara USB   │
                    │  + FFmpeg     │     │  (UVC)        │
                    └──────────────┘     └──────────────┘
```

### 88.4 Componentes incluidos

| Componente | Descripción |
|-----------|-----------|
| **V4L2** | Framework de captura del kernel (incluido en kernel) |
| **UVC** | USB Video Class driver (incluido en kernel) |
| **PipeWire camera node** | Compartición de cámara entre aplicaciones |
| **cheese** | GUI de cámara simple |
| **guvcview** | GUI avanzada con control de parámetros |
| **ffmpeg** | Captura desde cámaras IP (RTSP) |
| **v4l-utils** | Herramientas CLI (`v4l2-ctl`) |

### 88.5 Permisos de cámara

LNOS configura los permisos de cámara para máxima seguridad:

```
# Grupo video para acceso a dispositivos V4L2
# Los usuarios en grupo 'video' pueden acceder a cámaras

# Polkit: las aplicaciones Flatpak necesitan permiso explícito
flatpak override --user --socket=camera

# AppArmor: perfil que permite acceso a /dev/video*
# Configurado en /etc/apparmor.d/local/lnos-camera
```

**Por defecto:** El usuario que inició sesión en Hyprland tiene acceso a la cámara. Las aplicaciones Flatpak deben conceder permiso explícitamente (sandboxing).

### 88.6 Cámaras IP (RTSP)

Para cámaras IP, LNOS proporciona integración via FFmpeg y GStreamer:

```
# Capturar cámara IP como dispositivo V4L2 virtual
ffmpeg -i rtsp://user:pass@192.168.1.100:554/stream1 \
       -f v4l2 /dev/video0

# O usar gst-launch para transcodificar
gst-launch-1.0 rtspsrc location=rtsp://192.168.1.100:554/stream1 \
               ! decodebin \
               ! videoconvert \
               ! v4l2sink device=/dev/video0
```

### 88.7 Cómo se comunica con el resto del sistema

```
Cámara (hardware)
    │
    ├──→ Kernel (UVC driver o V4L2 bridge)
    │       │
    │       ▼
    │   /dev/video0
    │       │
    ├──→ PipeWire (camera node, compartición entre apps)
    │       │
    │       ├──→ Aplicaciones (Zoom, Chrome, OBS, cheese)
    │       └──→ wireplumber (gestión de sesiones)
    │
    ├──→ AppArmor (control de acceso a /dev/video*)
    ├──→ Polkit (permisos Flatpak)
    └──→ lnos-config (Centro de Configuración → Dispositivos → Cámara)
```

### 88.8 Dependencias

| Dependencia | Tipo | Razón |
|------------|------|-------|
| `v4l-utils` | Paquete | Herramientas CLI V4L2 |
| `pipewire` | Paquete | Compartición de cámara |
| `wireplumber` | Paquete | Gestión de sesiones PipeWire |
| `cheese` | Paquete | GUI de cámara por defecto |
| `guvcview` | Opcional | GUI avanzada |
| `ffmpeg` | Opcional | Cámaras IP (RTSP) |

### 88.9 Problemas potenciales y mitigaciones

| Problema | Mitigación |
|----------|-----------|
| Cámara no detectada | `v4l2-ctl --list-devices`; comprobar `lsusb`; verificar UVC |
| App no ve la cámara | Verificar permisos de PipeWire; `pw-cli list-nodes \| grep camera` |
| Cámara ocupada por otra app | PipeWire multiplexa, pero apps legacy pueden bloquear V4L2 |
| Cámara IP no conecta | Verificar RTSP URL; firewalld permite puerto 554 |
| Baja calidad de imagen | `v4l2-ctl --set-ctrl=...` para ajustar brillo, contraste, resolución |

### 88.10 Cómo se prueba

| Test | Procedimiento |
|------|--------------|
| Detección | `v4l2-ctl --list-devices` debe mostrar cámara |
| Captura | `ffplay /dev/video0` debe mostrar video en vivo |
| PipeWire | `pw-cli list-nodes` debe mostrar nodo de cámara |
| Cheese | Abrir cheese; debe mostrar imagen de cámara |
| Resolución | `v4l2-ctl --list-formats-ext` para ver resoluciones soportadas |

### 88.11 Cómo se mantiene

- **V4L2:** Parte del kernel Linux; se actualiza con el kernel.
- **PipeWire:** Actualizaciones via pacman; configuración en `/etc/pipewire/`.
- **Permisos:** Gestionados por udev rules en `/usr/lib/udev/rules.d/`.
- **Logs:** `journalctl -u pipewire` para problemas de cámara.

### 88.12 Cómo puede ampliarse

- **Realidad aumentada:** Módulo `lnos-ar` con soporte para OpenCV + V4L2.
- **Videovigilancia:** Módulo `lnos-surveillance` con motion, ZoneMinder o Frigate.
- **Streaming:** Módulo `lnos-streaming` con OBS Studio preconfigurado.
- **Cámara virtual:** Dispositivo V4L2 loopback para pruebas y efectos.

---

## 89. Bluetooth Avanzado

### 89.1 ¿Para qué existe?

Bluetooth en LNOS va más allá de la configuración básica (capítulo 34). Este capítulo cubre perfiles avanzados, codecs de audio, dispositivos de juego, y tecnologías emergentes como LE Audio.

**¿Por qué dedicar un capítulo aparte?** Bluetooth es uno de los subsistemas más complejos de Linux. La configuración por defecto debe equilibrar compatibilidad, calidad de audio y consumo de energía.

### 89.2 Stack Bluetooth

```
┌─────────────────────────────────────────────────────┐
│                   BlueZ (daemon)                      │
│  bluetoothd, bluetoothctl, btmon, hcitool, gatttool  │
└──────────────────────┬──────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────┐
│              Perfiles Bluetooth (Profiles)            │
│  A2DP │ HFP │ HSP │ AVRCP │ HID │ GATT │ PAN │ SPP   │
└──────────────────────┬──────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────┐
│               Codecs de Audio                         │
│  SBC │ AAC │ aptX │ LDAC │ LC3 (LE Audio)            │
└──────────────────────┬──────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────┐
│               Capa de transporte                      │
│  UART, USB, SDIO (Hardware)                          │
└─────────────────────────────────────────────────────┘
```

### 89.3 Perfiles Bluetooth

| Perfil | Propósito | Configuración LNOS |
|--------|-----------|-------------------|
| **A2DP** | Audio estéreo de alta calidad | Codec LDAC > aptX HD > AAC > SBC |
| **HFP** | Manos libres para llamadas | HFP 1.7 (wideband speech) |
| **HSP** | Auricular simple | HSP 1.2 |
| **AVRCP** | Control remoto de reproducción | AVRCP 1.6 (absolute volume) |
| **HID** | Teclados, ratones, gamepads | Soporte completo |
| **GATT** | Perfiles de baja energía (LE) | Soporte completo |
| **PAN** | Red personal Bluetooth | Desactivado por defecto |
| **SPP** | Puerto serie Bluetooth | Desactivado por defecto |

### 89.4 Codecs de audio

**Configuración por defecto de codecs (prioridad decreciente):**

| Codec | Calidad | Bitrate | Latencia | Soporte LNOS |
|-------|---------|---------|----------|-------------|
| **LDAC** | Excelente | 990 kbps | Alta | Sí (pipewire-codec-ldac) |
| **aptX HD** | Muy buena | 576 kbps | Media | Sí (pipewire-codec-aptx) |
| **aptX** | Buena | 352 kbps | Media | Sí |
| **AAC** | Buena | 256 kbps | Media | Sí (nativo) |
| **SBC** | Aceptable | 328 kbps (dual channel) | Baja | Sí (por defecto en BlueZ) |
| **LC3** | Buena | Variable | Muy baja | LE Audio (futuro) |

**Por qué LDAC como prioridad máxima:** Proporciona calidad cercana a audio con cable. Es el codec Bluetooth de mejor calidad disponible. Soporte nativo en Android y la mayoría de auriculares modernos.

### 89.5 FastConnect y Bluetooth multipunto

**FastConnect:** Tecnología de Qualcomm que reduce la latencia y mejora la estabilidad del Bluetooth. Activado automáticamente en hardware Qualcomm Atheros/QCA.

**Bluetooth multipunto:** Permite conectar los auriculares a dos dispositivos simultáneamente (ej: PC y teléfono). Se configura via:

```
# /etc/bluetooth/multipoint.conf
[Multipoint]
Enabled = true
MaxConnections = 2
Priority = "latency"  # "latency" o "quality"
```

### 89.6 Gamepad Bluetooth

LNOS soporta gamepads Bluetooth de las principales consolas:

| Gamepad | Perfil | Notas |
|---------|--------|-------|
| **PS4 DualShock 4** | HID + hid-sony | Soporte nativo del kernel |
| **PS5 DualSense** | HID + hid-playstation | Soporte nativo del kernel (desde 5.12) |
| **Xbox One/Series** | HID + xpad | `xpadneo` o `xpad` (kernel) |
| **Switch Pro** | HID + hid-nintendo | Soporte nativo del kernel (desde 5.16) |
| **8BitDo** | HID | Compatible con perfiles Switch o Xbox |

**Instalación de drivers adicionales:**

```
# Xbox Series (xpadneo - mejor compatibilidad que xpad del kernel)
lnos-mod install lnos-gaming-xpadneo

# Joy-Con de Switch
lnos-mod install lnos-gaming-joycond
```

### 89.7 LE Audio (futuro)

LE Audio es la nueva generación de Bluetooth que introduce:

- **LC3 codec:** Mejor calidad a menor bitrate que SBC.
- **Broadcast audio:** Audio a múltiples dispositivos simultáneamente.
- **Menor consumo:** Ideal para auriculares pequeños.

**Estado en LNOS:** A fecha de este documento, LE Audio requiere hardware Bluetooth 5.2+ y kernel ≥ 6.5. LNOS prepara el soporte pero lo activa solo si el hardware lo soporta:

```
# Detección automática en lnos-firstrun.service
if hcitool info | grep -q "Version: 5.2"; then
    systemctl enable --now bt-le-audio.service
fi
```

### 89.8 Cómo se comunica con el resto del sistema

```
BlueZ (bluetoothd)
  │
  ├──→ Kernel (BT HCI, USB, UART)
  ├──→ PipeWire + WirePlumber (audio A2DP/HFP)
  ├──→ Blueman (applet GTK de gestión)
  ├──→ systemd-logind (gestión de sesiones)
  ├──→ upower (consumo de batería de dispositivos)
  ├──→ lnos-config (Centro de Configuración → Bluetooth)
  └──→ AppArmor (perfiles para bluetoothd)
```

### 89.9 Dependencias

| Dependencia | Tipo | Razón |
|------------|------|-------|
| `bluez` | Paquete | Stack Bluetooth principal |
| `bluez-utils` | Paquete | Herramientas CLI (bluetoothctl, etc.) |
| `blueman` | Paquete | Applet de gestión GTK |
| `pipewire-codec-ldac` | Paquete | Codec LDAC para A2DP |
| `pipewire-codec-aptx` | Paquete | Codec aptX para A2DP |
| `libspa` | Paquete | Integración PipeWire-BlueZ |
| `xpadneo` | Opcional | Driver mejorado para Xbox |

### 89.10 Problemas potenciales y mitigaciones

| Problema | Mitigación |
|----------|-----------|
| Audio A2DP entrecortado | Aumentar `MaxConnected` en BlueZ; cambiar codec a AAC o SBC |
| Micrófono HFP no funciona | Configurar PipeWire para cambiar perfil automáticamente |
| Gamepad no conecta | Verificar compatibilidad; instalar driver específico |
| Bluetooth no enciende | `rfkill unblock bluetooth`; verificar `dmesg` para errores BT USB |
| Multipunto inestable | Desactivar multipunto si hay interferencias |

### 89.11 Cómo se prueba

| Test | Procedimiento |
|------|--------------|
| Encendido Bluetooth | `bluetoothctl power on`; verificar `show` |
| Emparejamiento | `bluetoothctl scan on` + `bluetoothctl pair <MAC>` |
| Audio A2DP | Emparejar auriculares; reproducir música; verificar calidad |
| Gamepad | Emparejar gamepad; `evtest` para verificar ejes y botones |
| Multipunto | Conectar dos dispositivos; alternar reproducción |

### 89.12 Cómo se mantiene

- **BlueZ:** Actualizaciones via pacman. Configuración en `/etc/bluetooth/`.
- **Codecs:** Paquetes separados que se actualizan con PipeWire.
- **Perfiles de audio:** Gestionados por WirePlumber.
- **Logs:** `journalctl -u bluetooth`; `btmon` para monitoreo en tiempo real.

### 89.13 Cómo puede ampliarse

- **Bluetooth Mesh:** Soporte para redes mesh Bluetooth (IoT).
- **Perfiles personalizados:** Scripts que cambian perfil automáticamente según aplicación (música→A2DP, llamada→HFP).
- **Batería de dispositivos:** Mostrar batería de auriculares/gamepad en Waybar.
- **Bluetooth MIDI:** Soporte para controladores MIDI Bluetooth.

---

## 90. Sincronización

### 90.1 ¿Para qué existe?

El módulo de sincronización de LNOS permite mantener datos sincronizados entre múltiples dispositivos de forma segura, eficiente y en tiempo real. Cubre tanto sincronización P2P (Syncthing) como sincronización programada (rsync + cron).

**Filosofía:** Sin servidores centrales, sin suscripciones, sin comprometer la privacidad. El usuario controla dónde y cómo se sincronizan sus datos.

### 90.2 Alternativas descartadas

| Alternativa | Razón del descarte |
|------------|-------------------|
| **Nextcloud Sync** | Bueno pero requiere servidor. Alternativa cloud (ver capítulo 91). |
| **Dropbox/Google Drive** | Propietarios, sin cifrado local, dependencia de servidores externos. |
| **Resilio Sync** | Propietario, versión gratuita limitada. |
| **Seafile** | Cliente-servidor, no P2P nativo. |
| **git-annex** | Potente pero complejo; no ofrece sincronización en tiempo real. |

**Decisión: Syncthing como solución primaria de sincronización P2P.**

### 90.3 Syncthing

**¿Por qué Syncthing?**

| Característica | Syncthing | rsync+cron | Nextcloud |
|---------------|-----------|-----------|-----------|
| Sincronización en tiempo real | Sí (inotify) | No | Sí (polling) |
| P2P (sin servidor) | Sí | No | No |
| Cifrado extremo a extremo | Sí (TLS) | Opcional (SSH) | Sí (EE2E opcional) |
| Control de versiones | Sí (trash, simple, staggered) | Manual | Sí |
| Resolución de conflictos | Automática | Manual | Automática |
| Interfaz web | Sí (localhost:8384) | No | Sí |
| Historial de versiones | Sí | No | Sí |
| Rendimiento en LAN | Excelente (descubrimiento local) | Excelente | Bueno |

**Configuración por defecto de Syncthing en LNOS:**

```
# Directorio de configuración
~/.config/syncthing/

# Directorios sincronizados por defecto
~/Documentos/
~/Imágenes/
~/Proyectos/
~/.lnos/sync/

# Interfaz web en localhost:8384 (autenticada)
# Descubrimiento local (LAN): activado
# Descubrimiento global (Internet): activado (opcional)
# Relay: activado (cuando no hay conexión directa)
```

**Servicio systemd:**

```
# Servicio de usuario (se ejecuta con la sesión del usuario)
systemctl --user enable --now syncthing.service

# Verificar estado
systemctl --user status syncthing.service
```

### 90.4 rsync + cron (sincronización programada)

Para casos donde no se necesita sincronización en tiempo real (backups programados, sincronización periódica a servidor), LNOS ofrece scripts basados en rsync:

```
/etc/lnos/sync/rsync.toml:

[[sync]]
source = "/home/usuario/Documentos"
destination = "user@server:/backups/documentos/"
schedule = "daily"        # daily, weekly, monthly
options = ["-avz", "--delete", "--progress"]
encryption = "ssh"        # SSH con clave pública

[[sync]]
source = "/home/usuario/Fotos"
destination = "/mnt/backup/fotos/"
schedule = "weekly"
options = ["-avz", "--link-dest=../last-backup"]
```

**Script de sincronización programada:**

```
lnos-sync-rsync.sh
├── Lee config desde /etc/lnos/sync/rsync.toml
├── Ejecuta rsync con cada destino programado
├── Notifica errores via dunst (escritorio) o email (server)
└── Registra en systemd-journald
```

### 90.5 Integración con módulo cloud

Cuando el módulo `lnos-cloud` está instalado (capítulo 91), Syncthing puede integrarse con servicios cloud:

```
Sincronización híbrida:
┌──────────┐     ┌──────────┐     ┌──────────┐
│  Laptop   │◄───►│ Servidor  │◄───►│  Cloud    │
│ (Syncth.) │     │ (Syncth.) │     │ (rclone)  │
└──────────┘     └──────────┘     └──────────┘

Flujo:
1. Laptop → Servidor: Syncthing (P2P, tiempo real)
2. Servidor → Cloud: rclone (programado, comprimido)
```

### 90.6 Cómo se comunica con el resto del sistema

```
Syncthing
  │
  ├──→ systemd (servicio de usuario)
  ├──→ NetworkManager (detección de red local vs internet)
  ├──→ firewalld (puertos 22000/TCP, 21027/UDP)
  ├──→ lnos-config (Centro de Configuración → Sincronización)
  ├──→ lnos-cloud (integración con servicios cloud)
  └──→ notificaciones (dunst para eventos de sincronización)
```

### 90.7 Dependencias

| Dependencia | Tipo | Razón |
|------------|------|-------|
| `syncthing` | Paquete | Sincronización P2P en tiempo real |
| `rsync` | Paquete | Sincronización programada |
| `cronie` | Paquete | Programación de rsync |
| `openssh` | Paquete | Rsync remoto via SSH |

### 90.8 Problemas potenciales y mitigaciones

| Problema | Mitigación |
|----------|-----------|
| Conflictos de archivos | Syncthing crea copias `*.sync-conflict-*` con fecha |
| Syncthing consume CPU con muchos archivos | Excluir directorios `.git/`, `node_modules/` |
| Firewall bloquea P2P | Abrir puertos 22000/TCP, 21027/UDP |
| Batería en portátil | Syncthing pause cuando no hay AC (configurable) |
| rsync elimina archivos por error | Usar `--backup --backup-dir` como safenet |

### 90.9 Cómo se prueba

| Test | Procedimiento |
|------|--------------|
| Syncthing funcionando | Acceder a `http://localhost:8384` |
| Sincronización local | Crear archivo en directorio sincronizado; verificar en otro dispositivo |
| Sincronización remota | Configurar dos dispositivos; verificar conexión TLS |
| rsync programado | Ejecutar `lnos-sync-rsync.sh` y verificar archivos destino |
| Resolución conflictos | Crear archivo con mismo nombre en dos dispositivos; verificar `.sync-conflict-*` |

### 90.10 Cómo se mantiene

- **Syncthing:** Actualizaciones automáticas via repositorio oficial (añadido en LNOS).
- **Configuración:** Interfaz web para cambios en tiempo real.
- **Logs:** `journalctl --user -u syncthing`.
- **Monitorización:** Verificar conectividad entre dispositivos semanalmente.

### 90.11 Cómo puede ampliarse

- **Múltiples carpetas:** Sincronización selectiva por tipo de datos.
- **Syncthing + STUNNEL:** Proxy TLS para entornos corporativos restrictivos.
- **Versionado personalizado:** Scripts post-sync para versionado diferencial.
- **Sincronización selectiva:** Ignorar patrones específicos por dispositivo (`.stignore`).

---

## 91. Nube

### 91.1 ¿Para qué existe?

El módulo `lnos-cloud` proporciona conectividad con servicios cloud comerciales (Google Drive, OneDrive, Dropbox, S3) y autohospedados (Nextcloud). Permite montar almacenamiento cloud como si fuera local y sincronizar archivos bidireccionalmente.

**Filosofía:** Sin bloqueo de proveedor. El usuario puede usar cualquier servicio cloud o combinación de ellos. La abstracción la proporciona `rclone`, que unifica la interfaz para más de 40 proveedores.

### 91.2 Alternativas descartadas

| Alternativa | Razón del descarte |
|------------|-------------------|
| **Insync** | Propietario, caro (~$30), solo Google Drive y OneDrive |
| **Grive2** | Solo Google Drive, mantenimiento irregular |
| **gdrive** | CLI, funcional pero limitado |
| **Nextcloud client** | Solo Nextcloud, no unifica múltiples nubes |
| **Rclone + RcloneBrowser** | Se ofrece como complemento gráfico |

**Decisión: rclone como herramienta central, con Nextcloud client para servidores LNOS.**

### 91.3 rclone

**¿Por qué rclone?**

| Característica | rclone | Alternativas |
|---------------|--------|-------------|
| Proveedores soportados | 40+ (GDrive, OneDrive, Dropbox, S3, SFTP, etc.) | Limitado |
| Cifrado | Sí (crypt remoto) | Variable |
| Compresión | No (confiar en el proveedor) | Variable |
| Montaje FUSE | Sí (rclone mount) | Limitado |
| Sincronización bidireccional | Sí (bisync) | Variable |
| CLI + Scripting | Excelente | Variable |
| Integración systemd | Sí (servicio de montaje) | Manual |

**Configuración de rclone en LNOS:**

```
# Configuración interactiva (primera vez)
rclone config

# Archivo de configuración
~/.config/rclone/rclone.conf

# Ejemplo de configuración
[gdrive]
type = drive
scope = drive.file
token = {"access_token":"...","token_type":"...","refresh_token":"..."}
```

**Montaje cloud como servicio systemd:**

```
# /etc/systemd/system/lnos-cloud-mount@.service
[Unit]
Description=LNOS Cloud Mount (%i)

[Service]
Type=simple
ExecStart=/usr/bin/rclone mount %i: /home/%u/Cloud/%i \
    --vfs-cache-mode full \
    --vfs-cache-max-size 2G \
    --vfs-cache-max-age 24h \
    --attr-timeout 5s \
    --dir-cache-time 60s \
    --daemon \
    --log-level INFO
ExecStop=/bin/fusermount -u /home/%u/Cloud/%i
Restart=on-failure

[Install]
WantedBy=default.target
```

### 91.4 Nextcloud client

Para usuarios con servidor Nextcloud (autohospedado o proveedor), LNOS ofrece integración completa:

```
# Cliente de escritorio Nextcloud
lnos-mod install lnos-cloud-nextcloud

# Configuración
nextcloud --server https://nextcloud.example.com \
          --user usuario \
          --password \
          --sync-dir ~/Nextcloud

# Servicio systemd
systemctl --user enable --now nextcloud-client.service
```

**Integración con módulo Nextcloud server (futuro):** Si el servidor Nextcloud corre en el mismo equipo, la sincronización es local (loopback) y no consume ancho de banda de red.

### 91.5 gdrive (CLI para Google Drive)

`gdrive` es una herramienta CLI específica para Google Drive, útil para automatizaciones:

```
# Subir archivo
gdrive upload archivo.pdf

# Descargar archivo por ID
gdrive download 1abc123def456

# Listar archivos
gdrive list

# Compartir archivo
gdrive share 1abc123def456 --email usuario@example.com --role reader
```

### 91.6 Cómo se comunica con el resto del sistema

```
rclone / Nextcloud / gdrive
  │
  ├──→ systemd (servicios de montaje y sincronización)
  ├──→ FUSE (montaje cloud como sistema de archivos local)
  ├──→ NetworkManager (detección de conectividad)
  ├──→ lnos-config (Centro de Configuración → Nube)
  ├──→ lnos-sync (integración con Syncthing + cloud)
  ├──→ ~/Cloud/ (punto de montaje unificado)
  └──→ firewalld (tráfico HTTPS a servicios cloud)
```

### 91.7 Dependencias

| Dependencia | Tipo | Razón |
|------------|------|-------|
| `rclone` | Paquete | Herramienta central de cloud |
| `fuse3` | Paquete | Montaje de sistemas cloud |
| `nextcloud-client` | Opcional | Cliente Nextcloud |
| `gdrive` | Opcional | CLI Google Drive |
| `xdg-desktop-portal` | Paquete | Integración con portal de archivos |

### 91.8 Problemas potenciales y mitigaciones

| Problema | Mitigación |
|----------|-----------|
| Token expirado | rclone refresca automáticamente; notificar si falla |
| Montaje FUSE no responde | `fusermount -u` + reiniciar servicio |
| Sincronización conflictiva | rclone bisync con detección de conflictos |
| Límite de API de Google Drive | Implementar rate limiting en script de sincronización |
| Conexión lenta | rclone --bwlimit para limitar ancho de banda |

### 91.9 Cómo se prueba

| Test | Procedimiento |
|------|--------------|
| rclone config | `rclone config show` verifica configuración |
| Listar archivos | `rclone ls gdrive:` |
| Montaje | `rclone mount gdrive: ~/Cloud/GDrive --daemon`; `ls ~/Cloud/GDrive` |
| Sincronización | `rclone sync ~/Documentos gdrive:Documentos --dry-run` |
| Nextcloud | Abrir cliente; verificar estado de sincronización |

### 91.10 Cómo se mantiene

- **rclone:** Actualizaciones frecuentes via pacman (repo community).
- **Configuración:** `~/.config/rclone/rclone.conf` no se toca en actualizaciones.
- **Tokens:** Almacenados en el config file; renovar si expiran.
- **Logs:** `journalctl -u lnos-cloud-mount@gdrive` para montajes.

### 91.11 Cómo puede ampliarse

- **Múltiples nubes unificadas:** Union mount de varios proveedores cloud en un solo directorio (mergerfs).
- **Cifrado cloud:** rclone crypt para cifrar archivos antes de subirlos.
- **Backup a cloud:** Integración con borg (capítulo 84) para repositorios en S3/SFTP.
- **Portal de archivos GTK:** Integración con `xdg-desktop-portal` para abrir/guardar archivos cloud desde cualquier app.

---

## 92. Asistente de Bienvenida

### 92.1 ¿Para qué existe?

`lnos-welcome` es el asistente de bienvenida que aparece en el primer inicio del sistema tras la instalación. Su propósito es completar la configuración que no pudo realizarse durante la instalación (por ser interactiva o requerir elección del usuario con el sistema ya funcionando).

**Diferencia clave con el instalador:** El instalador configura el sistema para que arranque. El asistente de bienvenida configura el sistema para que el usuario comience a trabajar productivamente.

### 92.2 Alternativas descartadas

| Alternativa | Razón del descarte |
|------------|-------------------|
| **GNOME Initial Setup** | Atado a GNOME, no funciona con Hyprland |
| **Ubuntu OOBE** | Código propietario de Canonical, difícil de adaptar |
| **KDE Plasma Welcome** | Dependiente de KDE, stack pesado |
| **Configuración manual** | Mala experiencia de usuario, primer contacto negativo |
| **Web-based setup** | Dependencia de navegador, peor integración |

**Decisión: Desarrollo propio en Rust + GTK4, ligero e integrado con el ecosistema LNOS.**

### 92.3 Interfaz de usuario

`lnos-welcome` se implementa como una aplicación GTK4 que se ejecuta en el primer inicio (y solo en el primero). Ofrece un asistente paso a paso:

```
┌─────────────────────────────────────────────────────────┐
│           Bienvenido a LNOS                              │
│                                                          │
│  Paso 1/5: Idioma y Región                               │
│  ┌─────────────────────────────────────────────────────┐ │
│  │  Idioma:      [Español ▼]      │                    │ │
│  │  Teclado:     [Spanish ▼]      │                    │ │
│  │  Zona horaria: [Europe/Madrid ▼]│                    │ │
│  │  Formato:     [es_ES.UTF-8 ▼]  │                    │ │
│  └─────────────────────────────────────────────────────┘ │
│                                                          │
│  [Saltar]               [Anterior]        [Siguiente →]  │
└─────────────────────────────────────────────────────────┘
```

**Pasos del asistente:**

| Paso | Contenido | ¿Obligatorio? |
|------|-----------|--------------|
| 1 | Idioma, teclado, zona horaria, formato regional | Sí (si no se configuró en instalador) |
| 2 | Selección de módulos adicionales | No |
| 3 | Creación de usuarios adicionales | No |
| 4 | Conexión a servicios cloud | No |
| 5 | Personalización rápida (tema, wallpaper) | No |
| 6 | Resumen y finalización | Sí |

### 92.4 Selección de módulos adicionales

El paso 2 del asistente permite al usuario seleccionar módulos que no se instalaron durante la instalación:

```
┌─────────────────────────────────────────────────────────┐
│  Paso 2/5: Selecciona los módulos que necesitas          │
│                                                          │
│  ☑ Gaming (Steam, GameMode, MangoHud)                   │
│  ☐ Desarrollo (compiladores, git, contenedores)          │
│  ☑ Oficina (LibreOffice, OnlyOffice)                     │
│  ☐ Diseño (Blender, GIMP, Inkscape)                     │
│  ☐ Virtualización (KVM, QEMU, virt-manager)              │
│  ☐ Servidor (SSH, Docker, monitorización)                │
│                                                          │
│  [Saltar]               [Anterior]        [Siguiente →]  │
└─────────────────────────────────────────────────────────┘
```

### 92.5 Conexión a servicios cloud

El paso 4 permite configurar servicios cloud de forma sencilla:

```
┌─────────────────────────────────────────────────────────┐
│  Paso 4/5: Conecta tus servicios cloud                   │
│                                                          │
│  [Conectar Google Drive] → (abre navegador para OAuth)   │
│  [Conectar OneDrive]     → (abre navegador para OAuth)   │
│  [Conectar Nextcloud]    → URL: _________________        │
│  [Configurar Syncthing]  → (abre interfaz web :8384)     │
│                                                          │
│  [Saltar]               [Anterior]        [Siguiente →]  │
└─────────────────────────────────────────────────────────┘
```

### 92.6 Comunicación con el resto del sistema

```
lnos-welcome
  │
  ├──→ D-Bus system (cambiar configuración del sistema)
  │     ├──→ localectl (idioma, teclado)
  │     ├──→ timedatectl (zona horaria)
  │     └──→ logind (crear usuarios)
  ├──→ lnos-mod (instalación de módulos)
  ├──→ rclone (configuración cloud)
  ├──→ /etc/lnos/ (configuración persistente)
  └──→ /var/lib/lnos/welcome-done (flag de primera ejecución)
```

### 92.7 Dependencias

| Dependencia | Tipo | Razón |
|------------|------|-------|
| `gtk4` | Paquete | Interfaz gráfica |
| `libadwaita` | Paquete | Estilo y componentes GTK4 |
| `lnos-mod` | Paquete | Instalación de módulos |
| `rclone` | Opcional | Configuración cloud |
| `systemd-libs` | Paquete | D-Bus API |

### 92.8 Problemas potenciales y mitigaciones

| Problema | Mitigación |
|----------|-----------|
| Usuario cierra el asistente | Se puede reiniciar manualmente con `lnos-welcome` |
| Asistente aparece en cada inicio | Flag `/var/lib/lnos/welcome-done` evita re-ejecución |
| No hay internet para módulos | Omitir pasos cloud; continuar offline |
| Usuario no sabe qué módulos elegir | Descripciones claras; tooltips informativos |

### 92.9 Cómo se prueba

| Test | Procedimiento |
|------|--------------|
| Primer inicio | Instalar ISO limpia; verificar que asistente aparece |
| Saltar asistente | Cerrar asistente; verificar que no reaparece |
| Instalación módulos | Seleccionar Gaming; verificar que Steam y GameMode se instalan |
| Cloud OAuth | Conectar Google Drive; verificar token en rclone |
| Persistencia | Completar asistente; reiniciar; no debe reaparecer |

### 92.10 Cómo se mantiene

- **Código:** Repositorio en `src/lnos-welcome/` del monorepo.
- **Traducciones:** Archivos `.po` en `src/lnos-welcome/po/`.
- **Flag de primera ejecución:** `/var/lib/lnos/welcome-done` (archivo vacío).
- **Logs:** `journalctl -u lnos-welcome`.

### 92.11 Cómo puede ampliarse

- **Pasos adicionales por módulo:** Los módulos pueden registrar pasos extra en el asistente.
- **Asistente post-actualización:** Versión simplificada que aparece tras upgrades mayores.
- **Integración con telemetría:** Paso opcional para activar telemetría (capítulo 101).
- **Temas de bienvenida:** Módulos pueden proporcionar wallpapers y temas para mostrar en el asistente.

---

## 93. Configuración Inicial

### 93.1 ¿Para qué existe?

`lnos-firstrun.service` es un servicio systemd que se ejecuta automáticamente en el primer arranque para detectar hardware, aplicar optimizaciones y configurar servicios según el hardware detectado. A diferencia del asistente de bienvenida (interactivo), la configuración inicial es completamente automática y transparente para el usuario.

**Diferencia clave:**

| Aspecto | lnos-welcome (cap. 92) | lnos-firstrun (cap. 93) |
|---------|----------------------|------------------------|
| Tipo | Interactivo | Automático |
| Cuándo | Primer inicio de sesión | Primer arranque del sistema |
| Usuario visible | Sí (GUI) | No (servicio en background) |
| Configura | Preferencias de usuario | Optimizaciones de hardware/sistema |
| Puede saltarse | Sí | No (se ejecuta siempre) |

### 93.2 ¿Por qué existe como servicio separado?

**Justificación:** Separar la configuración automática (hardware, rendimiento) de la configuración interactiva (preferencias del usuario) permite:

1. El sistema está optimizado incluso si el usuario salta el asistente de bienvenida.
2. Las optimizaciones de hardware no requieren intervención del usuario.
3. El servicio puede reintentar si falla (hardware no disponible en el primer intento).
4. Puede re-ejecutarse si se añade hardware nuevo (via udev rule).

### 93.3 Detección de hardware y optimización automática

```
lnos-firstrun.service
    │
    ├── 1. Detectar GPU
    │      ├── Intel → activar módulo lnos-gpu-intel
    │      ├── AMD   → activar módulo lnos-gpu-amd
    │      └── NVIDIA → ofrecer instalación drivers (solo si consentimiento)
    │
    ├── 2. Detectar CPU
    │      ├── Intel → aplicar microcode intel-ucode
    │      ├── AMD   → aplicar microcode amd-ucode
    │      └── Ambos → optimizar governor según perfil
    │
    ├── 3. Detectar audio
    │      ├── HDMI/DP audio → configurar PipeWire para salida digital
    │      └── Solo analógico → configuración estándar
    │
    ├── 4. Detectar red
    │      ├── Wi-Fi → activar iwd + NetworkManager
    │      └── Solo Ethernet → configuración estándar
    │
    ├── 5. Detectar almacenamiento
    │      ├── NVMe → activar discard (TRIM) semanal
    │      ├── SSD  → activar discard semanal; optimizar scheduler
    │      └── HDD  → activar scheduler BFQ; aumentar vm.dirty_ratio
    │
    ├── 6. Detectar batería
    │      ├── Sí → activar TLP o power-profiles-daemon
    │      └── No → perfil de rendimiento máximo
    │
    └── 7. Aplicar perfiles de energía
           ├── Laptop → balanceado (rendimiento + batería)
           ├── Desktop → rendimiento máximo
           └── Server → eficiencia energética
```

### 93.4 Perfiles de energía

LNOS aplica perfiles de energía basados en el hardware detectado:

| Perfil | Uso | CPU governor | GPU power | Discos | WiFi |
|--------|-----|-------------|-----------|--------|------|
| **Rendimiento** | Desktop gaming | performance | performance | never sleep | max performance |
| **Balanceado** | Laptop normal | schedutil | auto | 5 min timeout | powersave |
| **Ahorro** | Laptop batería | powersave | low | 2 min timeout | powersave |
| **Eficiencia** | Server | schedutil | low | never sleep | max performance |

### 93.5 Aplicación de firewalld

El servicio configura firewalld según el perfil detectado:

```
# Laptop / Desktop
firewall-cmd --set-default-zone=home

# Server
firewall-cmd --set-default-zone=public
firewall-cmd --add-service=ssh

# Gaming (LAN)
firewall-cmd --add-service=steam
```

### 93.6 Activación de servicios según hardware

```
Hardware detectado       → Servicios activados
─────────────────────────────────────────────────
GPU                     → mesa, vulkan-*
CPU Intel               → intel-ucode
CPU AMD                 → amd-ucode
Wi-Fi                   → iwd + NetworkManager-wifi
Bluetooth               → bluetooth.service
Audio HDMI              → pipewire + wireplumber + config HDMI
NVMe SSD                → fstrim.timer
Batería                 → power-profiles-daemon, tlp (opcional)
Impresora/USB           → cups.service + avahi-daemon
Touchpad                → libinput config para touchpad
Tableta gráfica         → Wacom config (if detected)
```

### 93.7 Cómo se comunica con el resto del sistema

```
lnos-firstrun.service
    │
    ├──→ udev (detección de hardware)
    ├──→ systemd (activar/desactivar servicios)
    ├──→ lnos-mod (instalar módulos de GPU)
    ├──→ /etc/lnos/ (perfiles de energía, firewalld)
    ├──→ sysctl (parámetros del kernel)
    ├──→ kernel (CPU governors, I/O schedulers)
    └──→ /var/lib/lnos/firstrun-done (flag de ejecución)
```

### 93.8 Dependencias

| Dependencia | Tipo | Razón |
|------------|------|-------|
| `systemd` | Paquete | Servicio y temporizador |
| `udev` | Paquete | Detección de hardware |
| `lnos-mod` | Paquete | Instalación de módulos GPU |
| `tlp` o `power-profiles-daemon` | Paquete | Gestión de energía |
| `firewalld` | Paquete | Configuración de firewall |
| `hwdata` | Paquete | Base de datos de hardware |

### 93.9 Problemas potenciales y mitigaciones

| Problema | Mitigación |
|----------|-----------|
| Hardware no detectado en primer arranque | Re-ejecutar servicio via udev add event |
| Optimización incorrecta para hardware raro | Permitir override manual en `/etc/lnos/firstrun.override.toml` |
| Servicio tarda demasiado | Timeout de 30 segundos; continuar con configuración por defecto |
| Módulo GPU falla (NVIDIA) | No bloquear; continuar con Mesa |

### 93.10 Cómo se prueba

| Test | Procedimiento |
|------|--------------|
| Detección GPU | Ejecutar en VM con GPU virtual; verificar módulo activado |
| Perfil energía | Verificar `/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor` |
| Servicios hardware | Verificar `systemctl status` de servicios activados |
| Re-ejecución | Añadir hardware nuevo; verificar que udev trigger re-ejecuta |
| Override | Crear override file; verificar que se aplica |

### 93.11 Cómo se mantiene

- **Servicio:** Definido en `/usr/lib/systemd/system/lnos-firstrun.service`.
- **Scripts:** `/usr/lib/lnos/firstrun/` (scripts de detección y configuración).
- **Base de datos hardware:** `hwdata` se actualiza con el sistema.
- **Flag:** `/var/lib/lnos/firstrun-done` contiene hash de la configuración aplicada.

### 93.12 Cómo puede ampliarse

- **Módulos firstrun:** Los módulos pueden registrar scripts de firstrun en su `module.toml`.
- **Hardware profiles:** Perfiles de hardware prediseñados para hardware específico (ThinkPad, MacBook, etc.).
- **Cloud firstrun:** Si el usuario configuró cloud en `lnos-welcome`, restaurar configuración desde cloud.
- **Benchmark inicial:** Ejecutar benchmark en primer arranque para establecer línea base.

---

## 94. Centro de Configuración

### 94.1 ¿Para qué existe?

`lnos-config` es la herramienta gráfica central de configuración del sistema LNOS. Proporciona una interfaz unificada (GTK4) para todas las opciones de configuración del sistema, eliminando la necesidad de usar múltiples herramientas dispares.

**¿Por qué una herramienta central?** Linux tradicionalmente dispersa la configuración en decenas de herramientas: `systemctl`, `nmtui`, `bluetoothctl`, `timedatectl`, `localectl`, etc. LNOS unifica todo en una sola interfaz coherente.

### 94.2 Alternativas descartadas

| Alternativa | Razón del descarte |
|------------|-------------------|
| **GNOME Control Center** | Dependiente de GNOME Shell, no funciona con Hyprland |
| **KDE System Settings** | Dependiente de KDE Plasma, stack pesado |
| **xfce4-settings** | Limitado a XFCE, no integrado con LNOS |
| **Web-based (Cockpit)** | Para servidores, no para escritorio |
| **Múltiples herramientas CLI** | Mala UX para usuarios no técnicos |

**Decisión: Desarrollo propio en Rust + GTK4, con backend D-Bus.**

### 94.3 Arquitectura

```
┌─────────────────────────────────────────────────────┐
│              lnos-config (GTK4 GUI)                    │
│  Apariencia │ Pantalla │ Sonido │ Red │ Bluetooth │   │
│  Impresión │ Energía │ Dispositivos │ Sistema │ ...│   │
└──────────────────────┬──────────────────────────────┘
                       │ D-Bus
┌──────────────────────▼──────────────────────────────┐
│              lnos-config-daemon (D-Bus service)       │
│  Lee/escribe: /etc/lnos/*.toml                       │
│  Ejecuta: systemctl, timedatectl, localectl, ...      │
│  Notifica cambios en tiempo real                      │
└──────────────────────┬──────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────┐
│              API Interna (REST localhost)              │
│  Endpoints para cada sección de configuración         │
└─────────────────────────────────────────────────────┘
```

### 94.4 Secciones del Centro de Configuración

| Sección | Funcionalidad | Backend |
|---------|--------------|---------|
| **Apariencia** | Tema GTK, iconos, cursores, fuentes, wallpapers, barra | Hyprland, GTK settings |
| **Pantalla** | Resolución, refresco, escala, orientación, VRR | wlr-randr, hyprctl |
| **Sonido** | Volumen, dispositivos entrada/salida, perfiles, codecs | WirePlumber, PipeWire |
| **Red** | Wi-Fi, Ethernet, VPN, DNS, proxy | NetworkManager |
| **Bluetooth** | Encendido, descubrimiento, dispositivos emparejados | BlueZ |
| **Impresión** | Añadir/eliminar impresoras, gestionar trabajos | CUPS |
| **Energía** | Perfil energía, brillo, suspensión, hibernación | systemd, TLP |
| **Dispositivos** | Ratón, teclado, touchpad, gamepad, tableta | libinput, udev |
| **Sistema** | Hostname, zona horaria, idioma, fecha, usuarios | systemd, accounts-daemon |
| **Módulos** | Listar, instalar, eliminar, actualizar módulos | lnos-mod |
| **Actualizaciones** | Buscar, instalar, historial, rollback, schedule | pacman, timeshift |
| **Seguridad** | Firewall, AppArmor, Secure Boot, sandboxing | firewalld, aa-status |

### 94.5 Aplicación de cambios en tiempo real

**Principio:** Los cambios deben aplicarse inmediatamente, no requerir reinicio ni cierre de sesión.

```
Flow de cambio de configuración:

1. Usuario modifica opción en GUI (ej: cambiar wallpaper)
2. lnos-config → D-Bus → lnos-config-daemon
3. Daemon escribe cambio en /etc/lnos/ (o ~/.config/lnos/)
4. Daemon ejecuta acción correspondiente:
   - wallpaper: hyprctl hyprpaper wallpaper ...,reload
   - red: nmcli connection modify ...,reload
   - sonido: wpctl set-volume ...,reload
5. Daemon emite señal D-Bus "SettingChanged"
6. GUI actualiza estado (checkmark verde)
```

**Ejemplo de configuración**

```
# /etc/lnos/config/red.toml
[wireless]
ssid = "MiRed"
password = "***"
autoconnect = true

[ethernet]
dhcp = true
dns = ["1.1.1.1", "8.8.8.8"]
```

### 94.6 Cómo se comunica con el resto del sistema

```
lnos-config (GUI)
    │
    ├──→ D-Bus system bus → lnos-config-daemon
    │       │
    │       ├──→ systemd (servicios, timers)
    │       ├──→ NetworkManager (red)
    │       ├──→ BlueZ (bluetooth)
    │       ├──→ CUPS (impresión)
    │       ├──→ WirePlumber (audio)
    │       ├──→ Hyprland (compositor)
    │       ├──→ firewalld (firewall)
    │       ├──→ lnos-mod (módulos)
    │       ├──→ Timeshift (snapshots)
    │       └──→ sysctl (kernel params)
    │
    ├──→ /etc/lnos/ (configuración persistente)
    └──→ ~/.config/lnos/ (configuración de usuario)
```

### 94.7 Dependencias

| Dependencia | Tipo | Razón |
|------------|------|-------|
| `gtk4` | Paquete | Interfaz gráfica |
| `libadwaita` | Paquete | Componentes GTK4 |
| `liblnos` | Paquete | Librería compartida LNOS |
| `python-gobject` | Paquete | Bindings Python para D-Bus (daemon) |
| `NetworkManager` | Paquete | Backend de red |
| `bluez` | Paquete | Backend bluetooth |
| `pipewire` | Paquete | Backend audio |

### 94.8 Problemas potenciales y mitigaciones

| Problema | Mitigación |
|----------|-----------|
| D-Bus no responde | lnos-config puede operar en modo local (lectura/escritura directa de archivos) |
| Cambio no se aplica | Timeout de 5s; notificar error con sugerencia |
| Configuración conflictiva | Validación de esquema antes de aplicar; rollback automático |
| Interfaz lenta con muchas secciones | Lazy loading de secciones; cache de estados |
| Permisos insuficientes | Polkit para operaciones privilegiadas; daemon corre como root |

### 94.9 Cómo se prueba

| Test | Procedimiento |
|------|--------------|
| Cargar sección | Abrir cada sección; verificar que se carga sin errores |
| Cambiar opción | Modificar opción; verificar que cambio persiste tras reinicio |
| Cambio en tiempo real | Cambiar wallpaper; verificar que cambia inmediatamente |
| D-Bus signals | Monitorizar D-Bus; verificar SettingChanged emitida |
| Permisos | Ejecutar sin root; verificar que Polkit pide contraseña |

### 94.10 Cómo se mantiene

- **GUI:** `src/lnos-config/` en el monorepo. Código Rust + Blueprint (UI definition).
- **Daemon:** `src/lnos-config-daemon/` en el monorepo. Python con dbus-next.
- **Esquemas:** `/usr/share/lnos/config-schemas/` define la estructura de cada sección.
- **Logs:** `journalctl -u lnos-config-daemon` para depuración.

### 94.11 Cómo puede ampliarse

- **Secciones dinámicas:** Los módulos pueden registrar nuevas secciones en el centro de configuración.
- **Plugins de configuración:** Interfaz de plugins para añadir páginas de configuración específicas (capítulo 98).
- **Exportar/importar configuración:** Exportar toda la configuración a un archivo TOML.
- **Sincronizar configuración:** Sincronizar configuración entre dispositivos via Syncthing.

---

## 95. Centro de Software

### 95.1 ¿Para qué existe?

`lnos-software` es el centro de software gráfico de LNOS, equivalente a GNOME Software, KDE Discover o Ubuntu Software Center. Permite buscar, instalar, actualizar y eliminar aplicaciones y módulos de forma unificada.

**¿Por qué una herramienta propia?** Las alternativas existentes (GNOME Software, KDE Discover) están atadas a sus respectivos entornos de escritorio. LNOS necesita una herramienta que integre nativamente pacman, Flatpak, AUR y módulos LNOS en una sola interfaz.

### 95.2 Alternativas descartadas

| Alternativa | Razón del descarte |
|------------|-------------------|
| **GNOME Software** | Depende de GNOME; no soporta pacman nativamente (solo PackageKit) |
| **KDE Discover** | Depende de KDE; soporte pacman limitado |
| **Pamac** | De Manjaro; buena pero no integra módulos LNOS |
| **Octopi** | GUI para pacman, no soporta Flatpak/AUR/módulos |
| **Fluent** | GUI para pacman, limitada funcionalidad |

**Decisión: Desarrollo propio en Rust + GTK4, integrando pacman, Flatpak, AUR y módulos LNOS.**

### 95.3 Arquitectura

```
┌─────────────────────────────────────────────────────┐
│              lnos-software (GTK4 GUI)                 │
│  Inicio │ Explorar │ Instalados │ Actualizaciones │   │
│  Módulos │ AUR │ Flatpak │ Historial                 │
└──────────────────────┬──────────────────────────────┘
                       │ D-Bus + REST API
┌──────────────────────▼──────────────────────────────┐
│              lnos-software-daemon (backend)           │
│  Gestor pacman     │ Gestor Flatpak │ Gestor AUR    │
│  Gestor módulos    │ Transacciones  │ Cache         │
└──────────────────────┬──────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────┐
│              Backends                                 │
│  pacman (ALPM) │ flatpak (libflatpak) │ AUR (RPC)   │
│  lnos-mod (D-Bus) │ PackageKit (fallback)            │
└─────────────────────────────────────────────────────┘
```

### 95.4 Vistas del Centro de Software

| Vista | Descripción |
|-------|-----------|
| **Inicio** | Aplicaciones destacadas, módulos recomendados, novedades |
| **Explorar** | Búsqueda y categorización (gráficas, utilidades, desarrollo, gaming) |
| **Instalados** | Lista de aplicaciones y módulos instalados |
| **Actualizaciones** | Actualizaciones disponibles por tipo (sistema, flatpak, módulos) |
| **Módulos LNOS** | Vista específica de módulos de la distribución |
| **AUR** | Búsqueda en Arch User Repository (con advertencia de seguridad) |
| **Flatpak** | Navegación por Flathub |
| **Historial** | Transacciones pasadas con posibilidad de rollback |

### 95.5 Integración con pacman

`lnos-software` utiliza la librería ALPM (Arch Linux Package Manager) directamente para operaciones con pacman:

```python
# Backend pacman (Python via pyalpm)
import pyalpm

handle = pyalpm.Handle("/", "/var/lib/pacman")
db = handle.get_localdb()

# Buscar paquetes
for pkg in db.pkgcache:
    if query in pkg.name:
        results.append(pkg)

# Instalar
transaction = handle.init_transaction()
transaction.add_pkg(pkg)
transaction.prepare()
transaction.commit()
```

**Ventajas de ALPM sobre PackageKit:** ALPM es la API nativa de pacman. PackageKit añade una capa de abstracción que introduce latencia, limita funcionalidades y añade dependencias innecesarias.

### 95.6 Integración con Flatpak

`lnos-software` utiliza `libflatpak` (via bindings Python o Rust) para gestionar aplicaciones Flatpak:

```
- Mostrar aplicaciones de Flathub
- Instalar/actualizar/eliminar Flatpaks
- Gestionar permisos de Flatpak
- Mostrar aplicaciones runtime
```

### 95.7 Integración con AUR

La integración con AUR es explícitamente **opt-in** y requiere confirmación del usuario:

```
┌─────────────────────────────────────────────────────────┐
│  ⚠  Estás a punto de instalar desde AUR                 │
│                                                          │
│  Los paquetes AUR son creados por la comunidad y         │
│  NO están verificados por LNOS.                          │
│                                                          │
│  [Entiendo los riesgos]  [Volver]                        │
└─────────────────────────────────────────────────────────┘
```

El backend AUR usa el RPC de AUR para búsqueda y `makepkg` para instalación, con sandboxing via systemd-nspawn (opcional).

### 95.8 Vista por módulos LNOS

El centro de software muestra los módulos LNOS como una categoría especial:

```
Módulos LNOS:
┌─────────────────────────────────────────────────────────┐
│  Gaming                            [Instalado] [✓]     │
│  Optimizaciones para gaming: Steam, GameMode, MangoHud │
│  Tamaño: ~2.5 GB                                       │
├─────────────────────────────────────────────────────────┤
│  Desarrollo                         [Instalar] [ ]     │
│  Toolchains, IDEs, contenedores, git                    │
│  Tamaño: ~3.2 GB                                       │
├─────────────────────────────────────────────────────────┤
│  Virtualización                     [Instalar] [ ]     │
│  KVM, QEMU, libvirt, virt-manager                       │
│  Tamaño: ~800 MB                                       │
└─────────────────────────────────────────────────────────┘
```

### 95.9 Notificaciones de actualizaciones

`lnos-software-daemon` incluye un servicio de notificaciones que verifica actualizaciones periódicamente:

```
lnos-update-checker.service / .timer
├── Cada 6 horas
├── Verifica: pacman, flatpak, módulos LNOS
├── Si hay actualizaciones → notificación dunst:
│     ┌─────────────────────────────────┐
│     │ 📦 15 actualizaciones disponibles│
│     │ [Ver] [Actualizar ahora] [OK]   │
│     └─────────────────────────────────┘
└── Registra en /var/log/lnos/updates.json
```

### 95.10 Historial de transacciones

Cada operación se registra con posibilidad de rollback:

```
/var/log/lnos/transactions/
├── 2026-07-29_10-00-00.json
├── 2026-07-28_15-30-00.json
└── ...

Formato:
{
  "id": "tx_20260729_100000",
  "timestamp": "2026-07-29T10:00:00Z",
  "type": "install",
  "packages": ["steam", "gamemode", "mangohud"],
  "modules": ["lnos-gaming"],
  "snapshot_id": "2026-07-29_09-59-00",
  "status": "completed",
  "errors": []
}
```

### 95.11 Cómo se comunica con el resto del sistema

```
lnos-software (GUI)
    │
    ├──→ D-Bus → lnos-software-daemon
    │       │
    │       ├──→ pyalpm (pacman operations)
    │       ├──→ libflatpak (flatpak operations)
    │       ├──→ AUR RPC (AUR operations)
    │       ├──→ lnos-mod (módulo operations)
    │       ├──→ Timeshift (snapshot pre/post transaction)
    │       └──→ systemd-journald (logging)
    │
    ├──→ /etc/lnos/software.conf (configuración)
    └──→ /var/log/lnos/transactions/ (historial)
```

### 95.12 Dependencias

| Dependencia | Tipo | Razón |
|------------|------|-------|
| `gtk4` | Paquete | Interfaz gráfica |
| `libadwaita` | Paquete | Componentes GTK4 |
| `pyalpm` | Paquete | Bindings Python para ALPM |
| `flatpak` | Paquete | Gestión de Flatpak |
| `lnos-mod` | Paquete | Gestión de módulos |
| `timeshift` | Paquete | Snapshots pre/post transacción |
| `| `timeshift` | Paquete | Snapshots pre/post transacción |

### 95.13 Problemas potenciales y mitigaciones

| Problema | Mitigación |
|----------|-----------|
| AUR instala paquete malicioso | Sandbox makepkg con systemd-nspawn; verificar PKGBUILD antes de ejecutar |
| Flatpak no actualiza | `flatpak repair`; verificar remotos configurados |
| ALPM lock (otro proceso pacman) | Esperar 30s; si no se libera, preguntar al usuario |
| Transacción falla a medias | Rollback automático via snapshot Timeshift pre-transacción |
| Centro de software lento | Cache de búsqueda local; actualizar cache en background |

### 95.14 Cómo se prueba

| Test | Procedimiento |
|------|--------------|
| Buscar paquete | Buscar "firefox"; verificar resultados de pacman, flatpak, AUR |
| Instalar módulo | Instalar lnos-gaming; verificar Steam instalado |
| Actualizar sistema | Click "Actualizar todo"; verificar transacción completa |
| Historial | Realizar operación; verificar entrada en historial |
| Rollback | Instalar paquete problemático; hacer rollback desde historial |

### 95.15 Cómo se mantiene

- **GUI:** `src/lnos-software/` en Rust + GTK4 + Blueprint.
- **Daemon:** `src/lnos-software-daemon/` en Python con pyalpm.
- **Cache:** `/var/cache/lnos/software/` (paquetes descargados, metadata).
- **Actualizaciones:** El daemon se actualiza con el módulo lnos-base.

### 95.16 Cómo puede ampliarse

- **Repositorios adicionales:** Soporte para repositorios de terceros (chaotic-aur, etc.).
- **Plugins de fuentes:** Plugins para añadir nuevas fuentes de software (snap, nix, etc.).
- **Reviews comunitarios:** Sistema de valoraciones de paquetes.
- **Instalación remota:** Instalar paquetes en otro dispositivo LNOS via SSH.

---

## 96. API Interna

### 96.1 ¿Para qué existe?

La API Interna de LNOS es una API REST local que expone todas las funcionalidades del sistema de forma programática. Permite que las herramientas gráficas (Centro de Configuración, Centro de Software), CLI scripts y módulos se comuniquen con el sistema de forma estandarizada.

**¿Por qué REST en lugar de solo D-Bus?** D-Bus es excelente para comunicación entre procesos en el mismo escritorio, pero tiene limitaciones: no es fácilmente accesible desde scripts Bash o herramientas HTTP, no tiene documentación OpenAPI estándar, y la depuración es más compleja. La API REST complementa a D-Bus ofreciendo una interfaz universal.

### 96.2 Alternativas descartadas

| Alternativa | Razón del descarte |
|------------|-------------------|
| **Solo D-Bus** | Difícil para scripts, sin documentación OpenAPI nativa |
| **Solo Unix sockets** | Sin descubrimiento, sin HTTP semantics |
| **gRPC** | Complejo para herramientas simples; requiere protobuf |
| **GraphQL** | Sobrecarga para la simplicidad de las operaciones |
| **FlatBuffers** | Sin necesidad de máxima eficiencia binaria |

**Decisión: REST + JSON sobre Unix socket, con token de autenticación. Complementado por D-Bus para integración de escritorio.**

### 96.3 Arquitectura

```
┌─────────────────────────────────────────────────────┐
│              Consumidores                              │
│  lnos-config │ lnos-software │ scripts │ módulos     │
│  curl │ python-requests │ cualquier HTTP client       │
└──────────────────────┬──────────────────────────────┘
                       │ HTTP (localhost:8472)
┌──────────────────────▼──────────────────────────────┐
│              API Server (lnos-api)                    │
│  Rust + Actix-web (o Axum)                           │
│  Autenticación: Token en /run/lnos/api.token         │
│  Logging: structured + journald                      │
└──────┬──────────────┬──────────────┬────────────────┘
       │              │              │
       ▼              ▼              ▼
┌──────────┐  ┌──────────┐  ┌──────────┐
│ Módulos   │  │ Sistema   │  │ Paquetes  │
│ /api/modules│ │ /api/system│ │ /api/pkgs │
└──────────┘  └──────────┘  └──────────┘
```

### 96.4 Endpoints

**Módulos:**

| Método | Endpoint | Descripción |
|--------|----------|-----------|
| `GET` | `/api/modules` | Listar todos los módulos |
| `GET` | `/api/modules/{id}` | Información detallada |
| `POST` | `/api/modules/{id}/install` | Instalar módulo |
| `POST` | `/api/modules/{id}/remove` | Desinstalar módulo |
| `POST` | `/api/modules/{id}/update` | Actualizar módulo |
| `GET` | `/api/modules/{id}/status` | Estado del módulo |

**Sistema:**

| Método | Endpoint | Descripción |
|--------|----------|-----------|
| `GET` | `/api/system/info` | Información del sistema |
| `GET` | `/api/system/health` | Salud del sistema |
| `GET` | `/api/system/storage` | Información de almacenamiento |
| `GET` | `/api/system/services` | Listar servicios |
| `POST` | `/api/system/services/{name}/start` | Iniciar servicio |
| `POST` | `/api/system/services/{name}/stop` | Detener servicio |

**Configuración:**

| Método | Endpoint | Descripción |
|--------|----------|-----------|
| `GET` | `/api/config/{section}` | Obtener configuración |
| `PUT` | `/api/config/{section}` | Actualizar configuración |
| `GET` | `/api/config/{section}/{key}` | Obtener valor específico |

**Actualizaciones:**

| Método | Endpoint | Descripción |
|--------|----------|-----------|
| `GET` | `/api/updates/check` | Buscar actualizaciones |
| `POST` | `/api/updates/install` | Instalar actualizaciones |
| `GET` | `/api/updates/history` | Historial de actualizaciones |

**Snapshots:**

| Método | Endpoint | Descripción |
|--------|----------|-----------|
| `GET` | `/api/snapshots` | Listar snapshots |
| `POST` | `/api/snapshots/create` | Crear snapshot manual |
| `POST` | `/api/snapshots/{id}/restore` | Restaurar snapshot |

**Backups:**

| Método | Endpoint | Descripción |
|--------|----------|-----------|
| `GET` | `/api/backups/repos` | Listar repositorios |
| `POST` | `/api/backups/repos/{name}/run` | Ejecutar backup |
| `GET` | `/api/backups/status` | Estado del último backup |

### 96.5 Autenticación

La API se autentica mediante un token almacenado en `/run/lnos/api.token`:

```
# El token se genera en el arranque del sistema
# Solo accesible por root y el usuario activo

GET /api/system/info
Authorization: Bearer <token_content>
```

**Seguridad del token:**

- Generado aleatoriamente (256 bits) en cada arranque del sistema.
- Almacenado en `tmpfs` (no persiste en disco).
- Permisos `0600`, propietario `root:lnos`.
- Los usuarios en el grupo `lnos` pueden leer el token via Polkit.
- El token expira al apagar el sistema (no reutilizable entre reinicios).

### 96.6 Formato de respuesta

Todas las respuestas siguen un formato JSON estandarizado:

```json
{
  "success": true,
  "data": { ... },
  "error": null,
  "meta": {
    "api_version": "1.0",
    "timestamp": "2026-07-29T10:00:00Z",
    "request_id": "req_abc123"
  }
}
```

En caso de error:

```json
{
  "success": false,
  "data": null,
  "error": {
    "code": "MODULE_NOT_FOUND",
    "message": "Module 'lnos-nonexistent' not found",
    "details": "Available modules: lnos-base, lnos-hyprland..."
  },
  "meta": { ... }
}
```

### 96.7 Documentación OpenAPI

La API incluye un endpoint de documentación OpenAPI 3.0:

```
GET /api/openapi.json → Esquema OpenAPI completo

Interfaz Swagger UI disponible en:
http://localhost:8472/docs (si lnos-api-docs instalado)
```

### 96.8 Cómo se comunica con el resto del sistema

```
lnos-api
    │
    ├──→ lnos-mod (backend de módulos)
    ├──→ Timeshift (backend de snapshots)
    ├──→ borg (backend de backups)
    ├──→ systemd (gestión de servicios)
    ├──→ pacman/ALPM (gestión de paquetes)
    ├──→ /etc/lnos/ (lectura/escritura configuración)
    ├──→ /run/lnos/api.token (autenticación)
    └──→ systemd-journald (logging)
```

### 96.9 Dependencias

| Dependencia | Tipo | Razón |
|------------|------|-------|
| `lnos-lib` | Paquete | Librería compartida |
| `python` | Paquete | Runtime del servidor API |
| `fastapi` o `axum` | Paquete | Framework HTTP |
| `uvicorn` | Paquete | Servidor ASGI (si FastAPI) |
| `jq` | Opcional | Procesamiento JSON en scripts |

### 96.10 Problemas potenciales y mitigaciones

| Problema | Mitigación |
|----------|-----------|
| API no responde | systemd restart automático; timeout corto en clientes |
| Token expirado/faltante | Regenerar token; notificar a clientes |
| Endpoint lento | Rate limiting por IP; cache de respuestas frecuentes |
| Inyección JSON | Validación estricta de esquemas con Pydantic |
| Ataque DoS local | Rate limiting; solo responde en localhost |

### 96.11 Cómo se prueba

| Test | Procedimiento |
|------|--------------|
| Health check | `curl -H "Authorization: Bearer $(cat /run/lnos/api.token)" http://localhost:8472/api/system/health` |
| Listar módulos | GET `/api/modules`; verificar JSON válido |
| Instalar módulo | POST `/api/modules/lnos-gaming/install`; verificar transacción |
| Error handling | GET `/api/modules/nonexistent`; verificar error JSON |
| Autenticación | GET sin token; verificar 401 |

### 96.12 Cómo se mantiene

- **Servidor:** Servicio systemd `lnos-api.service`.
- **Código:** `src/lnos-api/` en el monorepo (Rust o Python).
- **Documentación:** OpenAPI generado automáticamente del código.
- **Logs:** `journalctl -u lnos-api`.
- **Versionado:** API versionada por URL (`/api/v1/...`).

### 96.13 Cómo puede ampliarse

- **Webhooks:** Endpoints que notifican a URL externas cuando ocurren eventos.
- **WebSocket:** Para actualizaciones en tiempo real (progreso de instalaciones, cambios de configuración).
- **API keys de usuario:** Tokens adicionales para scripts de usuario.
- **Rate limiting por usuario:** Control de acceso granular.

---

## 97. Sistema de Módulos (profundización)

### 97.1 ¿Para qué existe?

Este capítulo amplía el capítulo 7 con detalles de implementación del sistema de módulos. Mientras el capítulo 7 proporciona una visión general, este capítulo cubre el diseño interno, el formato `module.toml` completo, la resolución de dependencias, los hooks, las transacciones, el versionado y la gestión de repositorios.

### 97.2 Resolución de dependencias en detalle

El resolvedor de módulos implementa un algoritmo basado en **SAT (Satisfiability)** simplificado para el caso específico de módulos LNOS.

**Algoritmo:**

```
1. Cargar todos los módulos disponibles (locales + repositorios)
2. Construir grafo de dependencias dirigido:
   - Nodos: módulos
   - Aristas: depends → dependency
3. Validar que el grafo es acíclico (topological sort)
4. Para módulos a instalar:
   a. Obtener todas las dependencias transitivas
   b. Marcar módulos en conflicto
   c. Seleccionar versión compatible (resolución de versiones)
5. Generar orden de instalación (topológico inverso)
6. Ejecutar transacción
```

**Resolución de versiones:**

```
# module.toml
[dependencies]
modules = [
    "lnos-base >= 1.0.0",
    "lnos-hyprland >= 2.0.0, < 3.0.0",
    "lnos-gtk ~1.5.0",  # Compatible con 1.5.x
]
```

El resolvedor usa **semver** (Semantic Versioning) con los siguientes operadores:

| Operador | Significado | Ejemplo |
|----------|-----------|---------|
| `>=` | Mayor o igual | `>= 1.0.0` |
| `<=` | Menor o igual | `<= 2.0.0` |
| `>` | Mayor estricto | `> 1.5.0` |
| `<` | Menor estricto | `< 3.0.0` |
| `=` | Exacto | `= 1.0.0` |
| `~` | Compatible (~1.5 → 1.5.x) | `~1.5.0` |
| `^` | Compatible (^1.5 → ≥1.5, <2.0) | `^1.5.0` |

### 97.3 Formato `module.toml` completo

```toml
[module]
id = "lnos-gaming"
version = "1.0.0"
name = "LNOS Gaming Module"
description = """
Optimizaciones para gaming: GameMode, MangoHud, Steam,
Lutris y configuraciones de rendimiento para juegos.
"""
license = "MIT"
author = "LNOS Team"
homepage = "https://lnos.dev/modules/gaming"
repository = "https://github.com/lnos/modules/gaming"
documentation = "https://lnos.dev/docs/modules/gaming"

[dependencies]
modules = [
    "lnos-base >= 1.0.0",
    "lnos-hyprland >= 2.0.0",
    "lnos-gpu >= 1.0.0",
]
packages = [
    "steam",
    "gamemode",
    "lib32-gamemode",
    "mangohud",
    "lib32-mangohud",
    "lutris",
    "wine",
    "winetricks",
    "proton-ge-custom",
]

[conflicts]
modules = ["lnos-gaming-lite"]
packages = ["steam-native-runtime"]

[recommends]
modules = ["lnos-gpu-nvidia", "lnos-gpu-amd"]
packages = ["mangoapp", "gamescope"]

[provides]
modules = ["lnos-gaming-stub"]
packages = ["steam-stub"]

[arch]
supported = ["x86_64"]

[config]
game_mode.enabled = true
game_mode.default_inhibit = false
mangohud.enabled = true
mangohud.show_fps = true
mangohud.show_temp = true
mangohud.show_cpu = true
mangohud.show_gpu = true
mangohud.position = "top-right"
steam.runtime = "native"
steam.beta_updates = false
gamescope.enabled = false

[files]
config = "/etc/lnos/modules/gaming/config.toml"
assets = "/usr/share/lnos/modules/gaming/assets/"
scripts = "/usr/share/lnos/modules/gaming/scripts/"

[size]
estimated_install = 2500000000  # ~2.5 GB
estimated_download = 850000000  # ~850 MB

[maintainer]
name = "LNOS Team"
email = "gaming@lnos.dev"

[tags]
categories = ["gaming", "entertainment", "performance"]
keywords = ["steam", "games", "proton", "wine"]
```

### 97.4 Hooks completo

Los hooks son scripts ejecutables que se invocan en momentos específicos del ciclo de vida del módulo.

| Hook | Cuándo se ejecuta | Propósito |
|------|-------------------|-----------|
| `pre-install` | Antes de instalar paquetes | Verificar requisitos, espacio en disco, backups |
| `post-install` | Después de instalar paquetes | Configuración inicial, activar servicios |
| `pre-remove` | Antes de desinstalar | Backup de configuración, detener servicios |
| `post-remove` | Después de desinstalar | Limpiar archivos residuales |
| `configure` | Al activar/configurar módulo | Aplicar configuración, regenerar archivos |
| `pre-upgrade` | Antes de actualizar | Backup de configuración actual |
| `post-upgrade` | Después de actualizar | Migrar configuración, reiniciar servicios |
| `status` | Verificar estado | Devolver JSON con estado del módulo |
| `backup` | Durante backup del sistema | Backup de datos específicos del módulo |
| `restore` | Durante restauración | Restaurar datos específicos del módulo |

**Entorno de ejecución de hooks:**

```
Variables de entorno disponibles:
LNOS_MODULE_ID=lnos-gaming
LNOS_MODULE_VERSION=1.0.0
LNOS_MODULE_DIR=/usr/share/lnos/modules/lnos-gaming
LNOS_CONFIG_DIR=/etc/lnos/modules/lnos-gaming
LNOS_STATE_DIR=/var/lib/lnos/modules/lnos-gaming
LNOS_TRANSACTION_ID=tx_20260729_100000
LNOS_DRY_RUN=false  # true si solo es simulación

Directorio de trabajo temporal: /tmp/lnos-hooks/<transaction_id>/
```

**Requisitos de hooks:**

- Deben ser ejecutables (chmod +x).
- Código de salida 0 = éxito, cualquier otro = fallo.
- Deben ser idempotentes (ejecutarse múltiples veces sin efectos secundarios).
- Máximo 5 minutos de ejecución (timeout).
- Deben escribir logs a stdout/stderr (capturados por el gestor).

### 97.5 Transacciones

Las transacciones garantizan que las operaciones sobre módulos sean atómicas:

```
Fase 1: PREPARACIÓN
├── Verificar módulo existe en repositorio
├── Verificar dependencias resueltas
├── Verificar espacio en disco suficiente
├── Verificar no hay conflictos con módulos instalados
├── Verificar permisos (root)
└── Verificar no hay otra transacción en curso

Fase 2: EJECUCIÓN
├── Ejecutar hook pre-install (si existe)
├── Instalar paquetes Arch (pacman -S)
├── Crear directorios de configuración
├── Copiar archivos de configuración por defecto
├── Ejecutar hook configure (si existe)
├── Activar servicios systemd (si aplica)
├── Ejecutar hook post-install (si existe)
└── Registrar módulo como instalado

Fase 3: COMMIT
├── Actualizar base de datos de módulos
├── Registrar transacción en historial
├── Emitir señal D-Bus "ModuleInstalled"
└── Notificar al usuario (dunst)

Fase 4: ROLLBACK (si fallo en Fase 2)
├── Ejecutar hook post-remove (si existe)
├── Desinstalar paquetes añadidos
├── Restaurar archivos de configuración previos (desde backup)
├── Desactivar servicios nuevos
└── Marcar módulo como no instalado
```

### 97.6 Estados de módulos

```
                    ┌──────────┐
                    │ available │
                    └─────┬────┘
                          │ install
                    ┌─────▼────┐
              ┌────►│preparing │◄────┐
              │     └─────┬────┘     │
              │           │           │
              │     ┌─────▼────┐     │
              │     │installing │     │
              │     └─────┬────┘     │
              │           │           │
         ┌────┴────┐ ┌────▼────┐ ┌──┴───┐
         │  error  │ │configured│ │broken│
         └────┬────┘ └────┬────┘ └──┬───┘
              │           │         │
              │     ┌─────▼────┐    │
              │     │ enabled  │    │
              │     └─────┬────┘    │
              │           │         │
         ┌────┴────┐ ┌────▼────┐   │
         │ running │ │ disabled│   │
         └─────────┘ └─────────┘   │
                                    │
                              ┌─────▼─────┐
                              │updatable   │
                              └─────┬─────┘
                                    │ update
                              ┌─────▼─────┐
                              │ upgrading  │
                              └─────┬─────┘
                                    │
                              ┌─────▼─────┐
                              │ configured │
                              └───────────┘
```

### 97.7 Versionado de módulos

Los módulos siguen **Semantic Versioning 2.0**:

| Componente | Significado | Ejemplo |
|-----------|-----------|---------|
| **MAJOR** | Cambio incompatible en API, configuración o dependencias | 1.0.0 → 2.0.0 |
| **MINOR** | Nueva funcionalidad compatible hacia atrás | 1.0.0 → 1.1.0 |
| **PATCH** | Corrección de errores compatible | 1.0.0 → 1.0.1 |
| **Pre-release** | Versión de desarrollo | 1.0.0-alpha.1, 1.0.0-beta.2 |

**Política de versionado:**

- `lnos-base` sigue la versión de LNOS (v1.0, v1.1, etc.).
- Módulos de primer nivel (lnos-hyprland, lnos-gaming): versionado independiente.
- Módulos de terceros: versionado por el mantenedor.

### 97.8 Repositorio de módulos

Los módulos se distribuyen desde:

1. **Repositorio oficial:** `modules.lnos.dev` (lista de módulos verificados por el equipo LNOS).
2. **Repositorio de comunidad:** `community.modules.lnos.dev` (similar a AUR, sin verificación exhaustiva).
3. **Repositorios locales:** `/usr/share/lnos/modules/` (módulos instalados via pacman).
4. **Repositorios Git:** Cualquier repositorio Git que contenga módulos (para desarrollo).

**Estructura del repositorio:**

```
modules.lnos.dev/
├── index.json                  # Índice de todos los módulos
├── metadata/
│   ├── lnos-base.json
│   ├── lnos-hyprland.json
│   └── ...
└── archives/
    ├── lnos-base-1.0.0.tar.gz  # Módulo empaquetado
    ├── lnos-base-1.0.1.tar.gz
    └── ...
```

**Índice de módulos (index.json):**

```json
{
  "api_version": "1.0",
  "modules": [
    {
      "id": "lnos-base",
      "version": "1.0.0",
      "name": "LNOS Base",
      "description": "Sistema mínimo LNOS",
      "author": "LNOS Team",
      "license": "MIT",
      "tags": ["core", "base"],
      "dependencies": [],
      "conflicts": [],
      "size": 1500000,
      "checksum": "sha256:abc123..."
    }
  ],
  "updated": "2026-07-29T00:00:00Z"
}
```

### 97.9 Cómo se comunica con el resto del sistema

```
Gestor de módulos (lnos-mod)
    │
    ├──→ D-Bus (API para herramientas gráficas)
    ├──→ REST API (endpoint /api/modules/)
    ├──→ pacman/ALPM (instalación de paquetes)
    ├──→ systemd (activar/desactivar servicios)
    ├──→ Timeshift (snapshot pre/post transacciones)
    ├──→ /usr/share/lnos/modules/ (módulos instalados)
    ├──→ /etc/lnos/modules/ (configuración de módulos)
    ├──→ /var/lib/lnos/modules/ (estado de módulos)
    └──→ systemd-journald (logging de transacciones)
```

### 97.10 Dependencias

| Dependencia | Tipo | Razón |
|------------|------|-------|
| `python` | Paquete | Runtime del gestor de módulos |
| `pyalpm` | Paquete | Interacción con pacman |
| `dbus-python` | Paquete | API D-Bus |
| `requests` | Paquete | Comunicación con repositorio |
| `jsonschema` | Paquete | Validación de module.toml |

### 97.11 Problemas potenciales y mitigaciones

| Problema | Mitigación |
|----------|-----------|
| Ciclo de dependencias | Detección en fase de preparación; error claro con lista de módulos implicados |
| Hook falla y bloquea instalación | Timeout de 5 min; rollback automático |
| Módulo incompatible con versión del sistema | Verificar `[arch]` y dependencias de sistema; error claro |
| Repositorio de módulos offline | Cache local de índices; `lnos-mod install --offline` |
| Transacción interrumpida (apagado) | Recovery en próximo arranque; estado persistente en `/var/lib/lnos/modules/` |

### 97.12 Cómo se prueba

| Test | Procedimiento |
|------|--------------|
| Instalación limpia | `lnos-mod install lnos-gaming`; verificar paquetes y configuración |
| Resolución dependencias | Instalar módulo con dependencias transitivas; verificar orden |
| Conflicto | Instalar módulo conflictivo; verificar error |
| Hook falla | Crear módulo con hook que retorna 1; verificar rollback |
| Transacción atómica | Interrumpir instalación (kill); verificar sistema consistente |

### 97.13 Cómo se mantiene

- **Gestor de módulos:** `lnos-mod` en Rust, mantenido por el equipo core.
- **Índice de repositorio:** Actualizado automáticamente via CI cuando se publican nuevos módulos.
- **Validación:** CI valida `module.toml` de cada PR en el repositorio de módulos.
- **Logs:** `journalctl -t lnos-mod` para transacciones.

### 97.14 Cómo puede ampliarse

- **Módulos condicionales:** Dependencias que solo se instalan si se cumple una condición (ej: solo en laptops).
- **Módulos virtuales:** Módulos que no instalan nada pero agrupan dependencias.
- **Overlay de módulos:** Módulos que modifican configuración de otros módulos.
- **Módulos con versiones múltiples:** Permitir múltiples versiones del mismo módulo (similar a Python venv).

---

## 98. Sistema de Plugins

### 98.1 ¿Para qué existe?

El sistema de plugins de LNOS permite extender la funcionalidad de las herramientas principales (Centro de Software, Centro de Configuración, Asistente de Bienvenida) sin modificar su código base. Mientras los módulos añaden funcionalidad al *sistema*, los plugins añaden funcionalidad a las *herramientas LNOS*.

**Diferencia fundamental entre módulos y plugins:**

| Aspecto | Módulo | Plugin |
|---------|--------|--------|
| **¿Qué extiende?** | El sistema operativo | Una herramienta LNOS |
| **Alcance** | Global (afecta al sistema) | Local (afecta a una herramienta) |
| **Instalación** | `lnos-mod install` | A través de la herramienta |
| **Dependencias** | Paquetes Arch, otros módulos | API de la herramienta |
| **Seguridad** | Alto (se ejecuta como root) | Medio (sandbox en la herramienta) |
| **Ejemplos** | lnos-gaming, lnos-dev | Plugin de tema, plugin de AppIndicator |

### 98.2 Alternativas descartadas

| Alternativa | Razón del descarte |
|------------|-------------------|
| **GNOME Shell Extensions** | Atado a GNOME Shell; no aplica a Hyprland |
| **KDE Plasma Widgets** | Atado a KDE Plasma |
| **VS Code Extensions** | Solo para editor, no para herramientas del sistema |
| **WebExtensions** | Solo para navegador |

**Decisión: Sistema de plugins propio, ligero, basado en Python/Rust con API bien definida.**

### 98.3 API de plugins

Cada herramienta LNOS expone una API de plugins que permite:

**Centro de Software (`lnos-software`):**

| Hook de plugin | Descripción |
|---------------|-----------|
| `on_search(query)` | Modificar resultados de búsqueda |
| `on_install(package)` | Ejecutar antes/después de instalar |
| `on_category_render(category)` | Personalizar vista de categoría |
| `provide_source()` | Añadir fuente de paquetes adicional |

**Centro de Configuración (`lnos-config`):**

| Hook de plugin | Descripción |
|---------------|-----------|
| `register_section()` | Añadir sección de configuración |
| `on_section_render(section)` | Personalizar renderizado |
| `on_config_change(section, key, value)` | Reaccionar a cambios |

**Asistente de Bienvenida (`lnos-welcome`):**

| Hook de plugin | Descripción |
|---------------|-----------|
| `register_step()` | Añadir paso adicional al asistente |
| `on_step_render(step)` | Personalizar paso existente |

**API Interna (`lnos-api`):**

| Hook de plugin | Descripción |
|---------------|-----------|
| `register_endpoint()` | Añadir endpoint REST |
| `on_request(endpoint, method)` | Middleware en peticiones |

### 98.4 Registro de plugins

Los plugins se registran mediante archivos de manifiesto:

```
~/.local/share/lnos/plugins/
├── vscode-integration/
│   ├── manifest.toml
│   ├── plugin.py
│   └── assets/
├── dark-theme-extra/
│   ├── manifest.toml
│   ├── plugin.py
│   └── theme.css
└── appindicator-support/
    ├── manifest.toml
    ├── plugin.py
    └── icons/
```

**Formato `manifest.toml`:**

```toml
[plugin]
id = "vscode-integration"
version = "1.0.0"
name = "VS Code Integration"
description = "Integración de VS Code en el Centro de Software"
author = "LNOS Community"
license = "MIT"

[target]
tool = "lnos-software"  # lnos-software, lnos-config, lnos-welcome, lnos-api
api_version = ">= 1.0"

[hooks]
on_search = "plugin.py:on_search"
on_install = "plugin.py:on_install"
provide_source = "plugin.py:provide_source"

[dependencies]
plugins = ["lnos-base-plugin"]
packages = ["code"]  # Paquetes Arch necesarios
```

### 98.5 Ejemplos de plugins

**Plugin: Integración con VS Code**

```python
# plugin.py
def provide_source():
    """Añade VS Code Marketplace como fuente de paquetes."""
    return {
        "name": "VS Code Extensions",
        "icon": "code",
        "search": search_vscode_extensions,
        "install": install_vscode_extension,
        "remove": remove_vscode_extension,
    }

def search_vscode_extension(query):
    """Buscar extensiones en Open VSX Registry."""
    import requests
    response = requests.get(
        "https://open-vsx.org/api/-/search",
        params={"query": query, "size": 20}
    )
    return [
        {
            "id": ext["name"],
            "name": ext["displayName"] or ext["name"],
            "description": ext.get("description", ""),
            "publisher": ext.get("publisher", {}).get("name", ""),
            "version": ext.get("version", ""),
            "type": "vscode-extension",
        }
        for ext in response.json().get("extensions", [])
    ]
```

**Plugin: Tema adicional**

```python
# plugin.py
def register_section():
    """Añade sección 'Temas' al Centro de Configuración."""
    return {
        "id": "themes",
        "name": "Temas",
        "icon": "preferences-desktop-theme",
        "priority": 10,
        "widget": ThemeWidget(),
    }

class ThemeWidget:
    def render(self):
        """Renderizar selector de temas."""
        # GTK4 widget listando temas instalados
        pass
```

**Plugin: AppIndicator**

```python
# plugin.py
def on_section_render(section):
    """Añade opciones de AppIndicator a la sección Sistema."""
    if section == "system":
        return {
            "appindicator_enabled": {
                "type": "switch",
                "label": "AppIndicator Support",
                "default": True,
                "apply": toggle_appindicator,
            }
        }

def toggle_appindicator(enabled):
    """Activar/desactivar soporte AppIndicator en Waybar."""
    import subprocess
    if enabled:
        subprocess.run(["systemctl", "--user", "start", "waybar-appindicator"])
    else:
        subprocess.run(["systemctl", "--user", "stop", "waybar-appindicator"])
```

### 98.6 Seguridad de plugins

Los plugins se ejecutan en un entorno sandboxed:

- **Centro de Software:** Plugin se ejecuta en proceso hijo separado con timeout.
- **Centro de Configuración:** Plugin se ejecuta en proceso separado; cambios requieren confirmación.
- **API de plugins:** Solo ciertos hooks pueden ejecutar comandos del sistema.
- **Manifiesto:** Declara permisos necesarios (network, filesystem, system).

**Permisos de plugins (en `manifest.toml`):**

```toml
[permissions]
network = false          # ¿Puede hacer peticiones HTTP?
system = false           # ¿Puede ejecutar comandos del sistema?
filesystem = "read"     # read, write, o false
notifications = true    # ¿Puede enviar notificaciones?
dbus = false            # ¿Puede comunicarse via D-Bus?
```

### 98.7 Cómo se comunica con el resto del sistema

```
Plugins LNOS
    │
    ├──→ lnos-software (API de plugins del Centro de Software)
    ├──→ lnos-config (API de plugins del Centro de Configuración)
    ├──→ lnos-welcome (API de plugins del Asistente de Bienvenida)
    ├──→ lnos-api (API de plugins de la API Interna)
    ├──→ ~/.local/share/lnos/plugins/ (directorio de plugins)
    └──→ systemd-journald (logging de plugins)
```

### 98.8 Dependencias

| Dependencia | Tipo | Razón |
|------------|------|-------|
| `python` | Paquete | Runtime de plugins (la mayoría escritos en Python) |
| `lnos-mod` | Paquete | Gestión de plugins del sistema |
| `jsonschema` | Paquete | Validación de manifiestos |

### 98.9 Problemas potenciales y mitigaciones

| Problema | Mitigación |
|----------|-----------|
| Plugin malicioso | Sandbox por permisos declarados; sandboxing del proceso |
| Plugin consume mucha memoria | Timeout y límite de memoria por proceso hijo |
| Plugin incompatible con versión de herramienta | `api_version` en manifiesto; verificación al cargar |
| Plugin conflictivo con otro plugin | Aislamiento entre plugins; resolución de conflictos |
| Plugin no responde (cuelga) | Timeout de 10s; kill del proceso hijo |

### 98.10 Cómo se prueba

| Test | Procedimiento |
|------|--------------|
| Cargar plugin | Copiar plugin a directorio; reiniciar herramienta; verificar en logs |
| Hook ejecutado | Plugin con hook de log; verificar mensaje en journal |
| Permisos | Plugin sin permiso network intenta HTTP; verificar bloqueo |
| Conflicto | Instalar dos plugins con mismo hook; verificar orden de ejecución |
| Timeout | Plugin con sleep(30); verificar que es terminado a los 10s |

### 98.11 Cómo se mantiene

- **API de plugins:** Definida en `liblnos` (Rust) con bindings para Python.
- **Documentación:** `docs/PLUGINS.md` con guía de desarrollo.
- **Repositorio de plugins:** `plugins.lnos.dev` (similar a repositorio de módulos).
- **Logs:** `journalctl -t lnos-plugin` para eventos de plugins.

### 98.12 Cómo puede ampliarse

- **Plugins de sistema:** Plugins que se ejecutan a nivel del sistema (no de herramienta).
- **Mercado de plugins:** Interfaz en Centro de Software para explorar e instalar plugins.
- **Plugin SDK:** `lnos-sdk plugin new` para crear nuevos plugins.
- **Plugins con GUI:** Plugins que aportan widgets GTK4 personalizados.

---

## 99. Internacionalización

### 99.1 ¿Para qué existe?

El sistema de internacionalización (i18n) de LNOS garantiza que todas las herramientas de la distribución puedan ser traducidas a cualquier idioma. La localización (l10n) adapta formatos de fecha, hora, moneda y teclados a cada región.

**Filosofía:** LNOS debe ser usable por cualquier persona en su idioma nativo desde el primer momento. No hay idioma "de primer nivel"; todos los idiomas tienen el mismo estatus.

### 99.2 Alternativas descartadas

| Alternativa | Razón del descarte |
|------------|-------------------|
| **intltool** | Obsoleto, reemplazado por gettext |
| **GNU gettext + XML** | Complejo; gettext + .po es estándar |
| **JSON i18n** | Sin herramientas de traducción maduras |
| **Fluent (Project Fluent)** | Prometedor pero ecosistema pequeño en GTK/Rust |
| **Localización solo en instalador** | Insuficiente; todas las herramientas deben estar traducidas |

**Decisión: GNU gettext (.po/.mo) como formato de traducción, Weblate como plataforma de traducción.**

### 99.3 Arquitectura

```
┌─────────────────────────────────────────────────────┐
│              Código fuente                            │
│  Rust: gettext-rs + tr!() macro                      │
│  Python: gettext + _() función                       │
│  Shell: gettext.sh + eval_gettext                    │
└──────────────────────┬──────────────────────────────┘
                       │ xgettext (extraer cadenas)
┌──────────────────────▼──────────────────────────────┐
│              Archivos .pot (Plantilla)                │
│  lnos-mod.pot, lnos-config.pot, lnos-software.pot    │
└──────────────────────┬──────────────────────────────┘
                       │ msginit / msgmerge
┌──────────────────────▼──────────────────────────────┐
│              Archivos .po (Traducciones)              │
│  es/lnos-mod.po, de/lnos-mod.po, fr/lnos-mod.po     │
└──────────────────────┬──────────────────────────────┘
                       │ msgfmt (compilar)
┌──────────────────────▼──────────────────────────────┐
│              Archivos .mo (Compilados)                │
│  es/LC_MESSAGES/lnos-mod.mo                          │
│  de/LC_MESSAGES/lnos-mod.mo                          │
└──────────────────────┬──────────────────────────────┘
                       │ Instalación
┌──────────────────────▼──────────────────────────────┐
│              /usr/share/locale/<lang>/LC_MESSAGES/    │
│  lnos-mod.mo, lnos-config.mo, lnos-software.mo       │
└─────────────────────────────────────────────────────┘
```

### 99.4 Cadenas traducibles

**En Rust (herramientas LNOS):**

```rust
use gettextrs::*;

fn main() {
    setlocale(LocaleCategory::LcAll, "");
    bindtextdomain("lnos-mod", "/usr/share/locale");
    textdomain("lnos-mod");

    let msg = t!("Installing module {module}", module = module_name);
    println!("{}", msg);
}
```

**En Python (scripts LNOS):**

```python
import gettext
gettext.bindtextdomain('lnos-mod', '/usr/share/locale')
gettext.textdomain('lnos-mod')
_ = gettext.gettext

print(_("Installing module {module}").format(module=module_name))
```

**En Bash (scripts de mantenimiento):**

```bash
export TEXTDOMAIN=lnos-mod
export TEXTDOMAINDIR=/usr/share/locale
source /usr/bin/gettext.sh

echo "$(eval_gettext "Installing module \$module_name")"
```

### 99.5 Traducciones de módulos

Cada módulo puede incluir sus propias traducciones:

```
/usr/share/lnos/modules/<module-id>/
├── module.toml
├── hooks/
├── files/
└── locale/
    ├── es/
    │   └── LC_MESSAGES/
    │       └── lnos-module-<id>.mo
    ├── de/
    │   └── LC_MESSAGES/
    │       └── lnos-module-<id>.mo
    └── ...
```

### 99.6 Weblate / Plataforma de traducción

LNOS utiliza **Weblate** (o Pontoon) como plataforma de traducción colaborativa:

```
translate.lnos.dev
├── Proyecto: LNOS
│   ├── Componente: lnos-mod (Rust strings)
│   ├── Componente: lnos-config (Rust strings)
│   ├── Componente: lnos-software (Rust strings)
│   ├── Componente: lnos-welcome (Rust strings)
│   ├── Componente: lnos-installer (Python strings)
│   ├── Componente: Módulo: lnos-gaming
│   ├── Componente: Módulo: lnos-dev
│   └── ...
├── Idiomas: es, de, fr, pt, it, ru, zh, ja, ko, ar, hi, ...
└── Estadísticas: 85% traducido (es), 72% (de), 68% (fr), ...
```

**Flujo de traducción:**

```
1. Desarrollador añade cadena en código (tr!("Hello"))
2. CI ejecuta xgettext → actualiza .pot
3. Weblate detecta cambios en .pot → marca cadenas como desactualizadas
4. Traductor traduce en Weblate (interfaz web)
5. Weblate crea PR con .po actualizado
6. CI verifica .po (msgfmt -c) y mergea
7. Release incluye .mo compilados
```

### 99.7 Localización (l10n)

**Formatos de fecha, hora y moneda:**

| Región | Fecha | Hora | Moneda | Número |
|--------|------|------|--------|--------|
| es_ES | 29/07/2026 | 10:00 | 1.234,56 € | 1.234,56 |
| de_DE | 29.07.2026 | 10:00 | 1.234,56 € | 1.234,56 |
| fr_FR | 29/07/2026 | 10:00 | 1 234,56 € | 1 234,56 |
| en_US | 07/29/2026 | 10:00 AM | $1,234.56 | 1,234.56 |
| en_GB | 29/07/2026 | 10:00 | £1,234.56 | 1,234.56 |
| ja_JP | 2026/07/29 | 10:00 | ¥1,234 | 1,234 |
| ar_SA | 29/07/2026 | 10:00 ص | ١٬٢٣٤٫٥٦ ر.س | ١٬٢٣٤٫٥٦ |

**Configuración regional:**

```bash
# /etc/locale.conf
LANG=es_ES.UTF-8
LC_TIME=es_ES.UTF-8
LC_MONETARY=es_ES.UTF-8
LC_NUMERIC=es_ES.UTF-8
LC_PAPER=es_ES.UTF-8
LC_MEASUREMENT=es_ES.UTF-8
```

**Teclados:**

```
localectl list-keymaps | grep es
  es           # Español (teclado estándar)
  es-cat       # Español (Catalán)
  es-dvorak    # Español (Dvorak)
  es-mac       # Español (Macintosh)
  es-olin      # Español (Olín)
  es-sun       # Español (Sun)
```

### 99.8 Cómo se comunica con el resto del sistema

```
i18n/l10n LNOS
    │
    ├──→ GNU gettext (traducciones de herramientas)
    ├──→ libc locale (formateo regional)
    ├──→ systemd-localed (configuración del sistema)
    ├──→ Weblate (plataforma de traducción remota)
    ├──→ CI (extracción, compilación, verificación)
    ├──→ /usr/share/locale/ (traducciones instaladas)
    └──→ /etc/locale.conf (configuración regional del sistema)
```

### 99.9 Dependencias

| Dependencia | Tipo | Razón |
|------------|------|-------|
| `gettext` | Paquete | Herramientas de traducción |
| `glibc` | Paquete | locale definition |
| `python-gettext` | Paquete | Soporte en Python |
| `weblate` | Opcional | Servidor de traducción (solo para mantenedores) |

### 99.10 Problemas potenciales y mitigaciones

| Problema | Mitigación |
|----------|-----------|
| Cadena sin traducir | Fallback al inglés (idioma por defecto) |
| Caracteres no soportados en terminal | Verificar UTF-8; usar iconv si necesario |
| Traducción incompleta en release | CI verifica mínimo 80% de cobertura por idioma |
| Formato regional incorrecto | Validar locale generado: `locale -a` |
| RTL (árabe, hebreo) mal renderizado | GTK4 soporta RTL; probar con `LANG=ar_SA.UTF-8` |

### 99.11 Cómo se prueba

| Test | Procedimiento |
|------|--------------|
| Extracción cadenas | `xgettext -o - src/*.rs` verificar que extrae cadenas marcadas |
| Compilación .mo | `msgfmt -c file.po` verificar sin errores |
| Carga traducción | `LANG=es_ES.UTF-8 lnos-mod --help` verificar español |
| Formato regional | `LC_TIME=de_DE.UTF-8 date` verificar formato alemán |
| RTL | `LANG=ar_SA.UTF-8 lnos-config` verificar layout correcto |

### 99.12 Cómo se mantiene

- **Pot files:** Generados automáticamente en CI.
- **Po files:** Mantenidos en repositorio Git (traducciones de comunidad).
- **Weblate:** Sincronización automática con repositorio.
- **Idiomas mínimos:** Release requiere 80% de cobertura en al menos 3 idiomas además de inglés.

### 99.13 Cómo puede ampliarse

- **Traducción de módulos de comunidad:** Sistema de traducción descentralizado para módulos de terceros.
- **Asistente IA para traducciones:** Integración con modelos de lenguaje para sugerir traducciones.
- **Idiomas minoritarios:** Soporte para idiomas con pocos traductores mediante traducción automática + revisión.
- **Plural forms:** Soporte completo para reglas de plural complejas (eslavas, árabes).

---

## 100. Accesibilidad

### 100.1 ¿Para qué existe?

La accesibilidad en LNOS garantiza que personas con discapacidades visuales, motoras o cognitivas puedan utilizar el sistema de forma efectiva. No es un "extra" opcional; es un requisito de diseño.

**Filosofía:** La accesibilidad no debe ser una ocurrencia tardía. Debe integrarse en el diseño desde el principio, no añadirse como parches.

### 100.2 Alternativas descartadas

| Alternativa | Razón del descarte |
|------------|-------------------|
| **Solo atajos de teclado** | No cubre discapacidad visual o cognitiva |
| **Dependencia exclusiva de Orca** | Orca es excelente pero no cubre todos los aspectos |
| **Tema claro único** | No suficiente para baja visión o daltonismo |
| **Solo configurable en GNOME/KDE** | LNOS no usa GNOME ni KDE |

**Decisión: Accesibilidad integral desde el diseño de Hyprland + GTK4 + herramientas LNOS.**

### 100.3 Componentes de accesibilidad

```
Accesibilidad LNOS
├── Visual
│   ├── Contraste de color (temas de alto contraste)
│   ├── Fuentes para dislexia (OpenDyslexic)
│   ├── Escalado de interfaz (hasta 200%)
│   └── Screen reader (Orca)
├── Motora
│   ├── Atajos de teclado configurables
│   ├── Gestos para movilidad reducida (Hyprland gestures)
│   ├── Sticky keys, slow keys, bounce keys
│   └── Mouse keys (teclado numérico como ratón)
└── Cognitiva
    ├── Notificaciones visuales + auditivas
    ├── Simplificación de interfaz (modo fácil)
    └── Tiempos de espera configurables
```

### 100.4 Contraste de color

LNOS incluye temas de alto contraste preinstalados:

| Tema | Contraste | Uso recomendado |
|------|-----------|----------------|
| **LNOS Default** | 7:1 (cumple WCAG AA) | Uso general |
| **LNOS High Contrast** | 15:1 (cumple WCAG AAA) | Baja visión |
| **LNOS Dark** | 12:1 | Fatiga visual / noches |
| **LNOS Light** | 10:1 | Ambientes muy iluminados |

**Verificación WCAG:**

```
# Herramienta de verificación de contraste incorporada
lnos-config --check-contrast

# Resultado:
# Fondo: #1a1b1e (oscuro)
# Texto: #ffffff (blanco)
# Ratio de contraste: 18.5:1 ✓ WCAG AA ✓ WCAG AAA
```

### 100.5 Fuentes para dislexia

LNOS incluye y preconfigura **OpenDyslexic**, una fuente diseñada específicamente para reducir los errores de lectura asociados a la dislexia:

```css
/* ~/.config/gtk-4.0/settings.ini o Centro de Configuración */
[Settings]
gtk-font-name=OpenDyslexic 12
```

**Características de OpenDyslexic:**

- Pesos en la parte inferior de las letras para evitar rotación.
- Formas de letras distintivas para reducir confusiones (b/d/p/q).
- Espaciado aumentado entre caracteres y líneas.
- Variantes: Regular, Bold, Italic, Bold Italic.

### 100.6 Atajos de teclado configurables

LNOS permite reconfigurar todos los atajos de teclado del sistema:

```
# ~/.config/hypr/hyprland.conf (gestionado por lnos-config)
$mainMod = SUPER

# Atajos por defecto
bind = $mainMod, Q, exec, kitty
bind = $mainMod, D, exec, rofi -show drun
bind = $mainMod, W, killactive,
bind = $mainMod, E, exec, thunar
bind = $mainMod, F, fullscreen,
bind = $mainMod, L, exec, hyprlock

# Atajos de accesibilidad
bind = $mainMod SHIFT, Plus, exec, hyprctl keyword cursor:zoom_factor $(echo "$(hyprctl getoption cursor:zoom_factor -j | jq .float) + 0.2" | bc)
bind = $mainMod SHIFT, Minus, exec, hyprctl keyword cursor:zoom_factor $(echo "$(hyprctl getoption cursor:zoom_factor -j | jq .float) - 0.2" | bc)
bind = $mainMod SHIFT, 0, exec, hyprctl keyword cursor:zoom_factor 1.0
```

### 100.7 Screen reader (Orca)

LNOS incluye **Orca** como screen reader, preconfigurado para Hyprland:

```
# Activar Orca (atajo: Super+Alt+S)
orca -r

# Configuración de Orca
~/.config/orca/orca-customizations.py
```

**Integración con Wayland:** Orca funciona con Wayland gracias al protocolo de accesibilidad de GTK4. LNOS asegura que:

- `at-spi2-core` está instalado y activo.
- `at-spi-bus-launcher` se inicia automáticamente.
- Las aplicaciones GTK4 exponen la información de accesibilidad correctamente.

### 100.8 Gestos para movilidad reducida

Hyprland permite gestos configurables que pueden adaptarse a movilidad reducida:

```
# ~/.config/hypr/hyprland.conf
# Gestos táctiles (touchpad)
gestures {
    workspace_swipe = true
    workspace_swipe_fingers = 3
    workspace_swipe_distance = 300
    workspace_swipe_invert = true
}

# Gestos para botones auxiliares
bind = , BTN_SIDE, workspace, +1
bind = , BTN_EXTRA, workspace, -1
```

**Dispositivos de asistencia:** LNOS reconoce pulsadores, joysticks adaptativos y otros dispositivos HID especializados como dispositivos de entrada completos.

### 100.9 Notificaciones visuales + auditivas

Todas las notificaciones del sistema se emiten en dos canales simultáneamente:

| Evento | Visual (dunst) | Auditivo | 
|--------|---------------|----------|
| Actualización disponible | Banner informativo | Sonido "pop" |
| Error del sistema | Banner rojo + icono | Sonido "error" |
| Backup completado | Banner verde + icono | Sonido "success" |
| Batería baja | Banner amarillo persistente | Sonido "warning" cada 5 min |
| Snapshot creado | Notificación temporal | Sonido sutil |

**Configuración de sonidos de notificación:**

```
# ~/.config/dunst/dunstrc
[urgency_low]
    frame_color = "#4CAF50"
    sound = /usr/share/sounds/lnos/notification-low.oga

[urgency_normal]
    frame_color = "#2196F3"
    sound = /usr/share/sounds/lnos/notification-normal.oga

[urgency_critical]
    frame_color = "#F44336"
    sound = /usr/share/sounds/lnos/notification-critical.oga
```

### 100.10 Cómo se comunica con el resto del sistema

```
Accesibilidad LNOS
    │
    ├──→ at-spi2 (Accessibility Toolkit)
    ├──→ Orca (screen reader)
    ├──→ Hyprland (gestos, atajos, zoom)
    ├──→ GTK4 (temas, fuentes, contraste)
    ├──→ dunst (notificaciones visuales)
    ├──→ PipeWire (notificaciones auditivas)
    ├──→ libinput (gestos táctiles, dispositivos especiales)
    └──→ lnos-config (Centro de Configuración → Accesibilidad)
```

### 100.11 Dependencias

| Dependencia | Tipo | Razón |
|------------|------|-------|
| `at-spi2-core` | Paquete | Accessibility toolkit |
| `orca` | Paquete | Screen reader |
| `opendyslexic-fonts` | Paquete | Fuente para dislexia |
| `dunst` | Paquete | Notificaciones visuales |
| `sound-theme-freedesktop` | Paquete | Sonidos de sistema |
| `gtk4` | Paquete | Soporte de accesibilidad nativo |

### 100.12 Problemas potenciales y mitigaciones

| Problema | Mitigación |
|----------|-----------|
| Orca no funciona con Wayland | Usar `orca --wayland`; verificar at-spi2 |
| Screen reader no lee app específica | Verificar que app expone interfaz AT-SPI |
| Contraste insuficiente en app GTK4 | Forzar tema de alto contraste: `GTK_THEME=lnos-high-contrast` |
| Zoom degrada rendimiento | Zoom solo activo cuando se solicita; no permanente |
| Gestos de touchpad no funcionan | Verificar `libinput gestures`; comprobar configuración Hyprland |

### 100.13 Cómo se prueba

| Test | Procedimiento |
|------|--------------|
| Orca | `orca -r` y navegar por menús; verificar lectura en voz alta |
| Contraste | Activar tema alto contraste; verificar ratio con herramienta |
| Fuente dislexia | Cambiar a OpenDyslexic; verificar legibilidad |
| Atajos | Reconfigurar atajo; verificar que funciona |
| Zoom | Activar zoom; verificar que magnifica correctamente |

### 100.14 Cómo se mantiene

- **Orca:** Actualizaciones via pacman. Configuración en `~/.config/orca/`.
- **Temas de accesibilidad:** Mantenidos en repositorio de temas LNOS.
- **Atajos:** Gestionados por lnos-config.
- **Documentación:** Guía de accesibilidad en `docs/ACCESSIBILITY.md`.

### 100.15 Cómo puede ampliarse

- **Reconocimiento de voz:** Integración con Vosk/Whisper para control por voz.
- **Eye tracking:** Soporte para eye trackers (Tobii, etc.) como dispositivo de entrada.
- **Switch access:** Soporte para pulsadores externos como único dispositivo de entrada.
- **Traducción a lengua de signos:** Avatar 3D que traduce texto a lengua de signos (futuro aspiracional).

---

## 101. Telemetría

### 101.1 ¿Para qué existe?

El sistema de telemetría de LNOS permite recoger datos anónimos sobre el hardware y el rendimiento del sistema para mejorar la distribución. **Está deshabilitado por defecto (opt-in).** El usuario debe activarlo explícitamente.

**Filosofía:** La telemetría no es para vigilancia ni publicidad. Es para que el equipo de desarrollo entienda qué hardware usa la comunidad, qué módulos son populares, y dónde hay problemas de rendimiento.

### 101.2 Alternativas descartadas

| Alternativa | Razón del descarte |
|------------|-------------------|
| **Google Analytics** | Propietario, rastrea usuarios, no ético |
| **Sentry** | Orientado a errores, no a métricas de hardware |
| **Prometheus + Grafana** | Excelente pero pensado para servidores, no para escritorio |
| **Ubuntu Apport** | Solo reporte de crashes |
| **Firefox telemetry** | Referencia pero demasiado agresivo para LNOS |

**Decisión: Sistema propio minimalista, self-hosted, anonimizado por diseño.**

### 101.3 Datos recogidos

Cuando el usuario activa la telemetría, se recogen los siguientes datos **anonimizados**:

| Categoría | Datos | ¿Identificable? |
|-----------|-------|----------------|
| **Hardware** | CPU (familia, núcleos), GPU (modelo), RAM (total), disco (tipo, tamaño) | No |
| **Software** | Kernel version, módulos LNOS instalados, display server | No |
| **Rendimiento** | Tiempo de arranque, uso de RAM promedio, tiempo de actividad | No |
| **Errores** | Kernel panics (anonymized), service failures count | No |
| **Actualizaciones** | Paquetes actualizados por semana, módulos actualizados | No |

**Datos que NO se recogen:**

- Nombre de usuario o hostname
- Dirección IP (se anonimiza truncando)
- Archivos, directorios o nombres de aplicaciones
- Contenido de ningún tipo
- Geolocalización precisa (solo zona horaria)

### 101.4 Anonimización

```
Pipeline de anonimización:

1. Recogida: se ejecuta localmente como servicio systemd (lnos-telemetry)
2. Anonimización en el cliente:
   - IP truncada: 192.168.1.100 → 192.168.0.0
   - Hostname: reemplazado por hash SHA-256 truncado
   - MAC address: reemplazada por hash SHA-256 truncado
   - User ID: reemplazado por ID de instalación (UUID aleatorio)
3. Cifrado: datos cifrados con clave pública del servidor LNOS
4. Envío: HTTPS POST a telemetry.lnos.dev/api/v1/submit
5. Almacenamiento: servidor descifra, procesa y descarta datos crudos
```

### 101.5 Servidor propio (self-hosted)

El servidor de telemetría es **código abierto** y puede ser auditado:

```
github.com/lnos/telemetry-server
├── src/
│   ├── server.rs       # Servidor HTTP (Actix-web)
│   ├── ingest.rs       # Ingesta de datos
│   ├── anonymize.rs    # Verificación de anonimización
│   ├── aggregate.rs    # Agregación de métricas
│   └── dashboard.rs    # Dashboard interno
├── migrations/
├── config/
└── Dockerfile
```

**Infraestructura:**

```
Usuario → HTTPS → nginx → telemetry-server → PostgreSQL
                                                │
                                           Grafana (dashboard interno)
                                                │
                                         Desarrollo LNOS (métricas agregadas)
```

### 101.6 Visualización para el usuario

El usuario puede ver qué datos se han enviado:

```
lnos-config → Sistema → Privacidad → Telemetría

┌─────────────────────────────────────────────────────────┐
│  Telemetría                                              │
│                                                          │
│  [Compartir datos anónimos para mejorar LNOS]           │
│  Estado: ☐ Desactivado  ☑ Activado                      │
│                                                          │
│  Último envío: 29/07/2026 10:00                         │
│  Próximo envío: 30/07/2026 10:00                        │
│  Datos a enviar:                                         │
│  ├─ Hardware: Intel i7-13700H, NVIDIA RTX 4070, 32GB    │
│  ├─ Software: Kernel 6.6.30, Módulos: base, hyprland..  │
│  └─ Rendimiento: Arranque 8.2s, RAM 3.5GB/32GB         │
│                                                          │
│  [Ver datos completos que se enviarán]                   │
│  [Eliminar todos los datos enviados]                     │
└─────────────────────────────────────────────────────────┘
```

### 101.7 Política de datos

La política de telemetría sigue el principio de **mínimos datos posibles**:

- Los datos se retienen 24 meses en forma agregada.
- Los datos crudos (no agregados) se eliminan tras 7 días.
- El usuario puede solicitar la eliminación de todos sus datos.
- El usuario puede descargar todos los datos asociados a su ID de instalación.

### 101.8 Mecanismo de exclusión total

El usuario puede desactivar la telemetría en cualquier momento:

```
# Via lnos-config (interfaz gráfica)
lnos-config → Privacidad → Desactivar telemetría

# Via CLI
lnos-mod disable lnos-telemetry

# Via systemd
systemctl disable --now lnos-telemetry.timer

# Archivo de exclusión (pre-instalación)
echo "telemetry = false" >> /etc/lnos/telemetry.conf
```

Cuando se desactiva:
- Se detiene el timer de recogida.
- Se eliminan los datos pendientes de envío.
- Se envía petición de eliminación al servidor (opcional).

### 101.9 Cómo se comunica con el resto del sistema

```
lnos-telemetry
    │
    ├──→ systemd (timer de recogida diaria)
    ├──→ lnos-report (datos del sistema para enviar)
    ├──→ lnos-config (interfaz de configuración)
    ├──→ HTTPS (envío a telemetry.lnos.dev)
    ├──→ /var/lib/lnos/telemetry/ (cache local de datos)
    └──→ /etc/lnos/telemetry.conf (configuración de privacidad)
```

### 101.10 Dependencias

| Dependencia | Tipo | Razón |
|------------|------|-------|
| `python` | Paquete | Script de recogida |
| `curl` | Paquete | Envío HTTPS |
| `jq` | Paquete | Procesamiento JSON |
| `coreutils` | Paquete | Comandos de sistema |

### 101.11 Problemas potenciales y mitigaciones

| Problema | Mitigación |
|----------|-----------|
| Usuario no sabe que está activado | Por defecto desactivado; activación explícita requerida |
| Fuga de datos por error de anonimización | Doble verificación en cliente y servidor |
| Servidor de telemetría caído | Cache local; reintento en próximo timer |
| Usuario quiere eliminar datos históricos | Endpoint DELETE en servidor; confirmación |
| Datos identificables por combinación | No recoger suficientes dimensiones para fingerprinting |

### 101.12 Cómo se prueba

| Test | Procedimiento |
|------|--------------|
| Recogida local | `lnos-telemetry collect --dry-run` verifica JSON generado |
| Anonimización | Verificar que IP, hostname, MAC no están presentes |
| Envío | `lnos-telemetry send` verifica código 200 |
| Exclusión | Desactivar; verificar que timer no se ejecuta |
| Eliminación | Solicitar eliminación; verificar en servidor |

### 101.13 Cómo se mantiene

- **Servicio:** `lnos-telemetry.service` y `lnos-telemetry.timer`.
- **Script:** `/usr/lib/lnos/telemetry/collect.py`.
- **Servidor:** Desplegado en infraestructura LNOS; mantenido por el equipo core.
- **Dashboard:** Grafana con métricas agregadas para el equipo de desarrollo.

### 101.14 Cómo puede ampliarse

- **Telemetría de paquetes:** Qué paquetes se instalan más (solo conteo, sin identificación).
- **Benchmark remoto:** Enviar resultados de benchmark anonimizados para comparativa (capítulo 118).
- **Reporte de crashes:** Similar a Apport pero anonimizado y opt-in.
- **Encuestas integradas:** Ocasionalmente preguntar a usuarios opt-in sobre su experiencia.

---

## 102. Política de Privacidad

### 102.1 ¿Para qué existe?

Este capítulo contiene el texto completo de la política de privacidad de LNOS. No es una guía técnica sino el documento legal/informativo para los usuarios.

**Filosofía:** Transparencia total. La política de privacidad está escrita en lenguaje claro, sin jerga legal ambigua. Cualquier persona debe poder entender exactamente qué datos se recogen y por qué.

### 102.2 Texto completo de la política de privacidad

```
# POLÍTICA DE PRIVACIDAD DE LNOS

**Versión:** 1.0.0
**Fecha de entrada en vigor:** 29 de julio de 2026
**Contacto:** privacy@lnos.dev

---

## 1. INTRODUCCIÓN

LNOS ("nosotros", "nuestro") es una distribución Linux de código abierto. Esta
política de privacidad explica cómo manejamos tus datos cuando usas LNOS.

**Resumen para quien tiene prisa:**
- Por defecto, LNOS NO recoge ningún dato.
- Si activas la telemetría, recogemos datos anónimos de hardware y rendimiento.
- No vendemos ni compartimos tus datos con terceros.
- Puedes desactivar la telemetría en cualquier momento.
- Puedes solicitar la eliminación de todos tus datos.

---

## 2. DATOS QUE RECOGEMOS

### 2.1 Datos que NO recogemos (nunca)

- Tu nombre, dirección, número de teléfono o email
- Tu dirección IP (se anonimiza)
- Tus archivos, documentos, fotos o cualquier contenido
- Nombres de aplicaciones o archivos en tu sistema
- Tu actividad de navegación web
- Tus contraseñas o claves
- Geolocalización precisa (solo zona horaria)
- Identificadores de publicidad
- Huella digital completa del dispositivo (fingerprinting)

### 2.2 Datos que recogemos (solo si activas telemetría)

#### Hardware
- Familia y número de núcleos de la CPU
- Modelo y VRAM de la GPU
- Cantidad total de RAM
- Tipo de disco (SSD/HDD/NVMe) y capacidad
- Fabricante y modelo del equipo (si detectable)

#### Software
- Versión del kernel Linux
- Lista de módulos LNOS instalados (IDs, no configuración)
- Versión de LNOS
- Display server (Wayland)

#### Rendimiento
- Tiempo de arranque del sistema
- Uso de RAM promedio
- Tiempo de actividad (uptime)
- Temperaturas promedio de CPU/GPU

#### Errores
- Conteo de errores del kernel (no los errores en sí)
- Conteo de servicios systemd fallados
- Versión del último snapshot restaurado (sin datos del snapshot)

---

## 3. CÓMO RECOGEMOS LOS DATOS

Los datos se recogen mediante un servicio systemd que se ejecuta
localmente en tu sistema. El servicio:

1. Se ejecuta una vez al día (configurable).
2. Recoge los datos descritos en la sección 2.
3. Anonimiza los datos localmente (ver sección 4).
4. Envía los datos cifrados a nuestro servidor.
5. Los datos se almacenan durante 24 meses en forma agregada.

---

## 4. ANONIMIZACIÓN

Antes de enviar cualquier dato, se anonimiza localmente:

- **Dirección IP:** Se trunca (192.168.x.x → 192.168.0.0)
- **Hostname:** Se reemplaza por un hash irreversible
- **Dirección MAC:** Se reemplaza por un hash irreversible
- **Identificador de instalación:** UUID aleatorio generado en primera ejecución
- **Tiempos:** Se redondean al minuto más cercano

La anonimización se realiza en TU sistema, antes de que los datos salgan
de tu máquina. Puedes verificarlo inspeccionando el código fuente en:
https://github.com/lnos/telemetry

---

## 5. POR QUÉ RECOGEMOS DATOS

Utilizamos los datos anónimos para:

1. **Mejorar la compatibilidad:** Saber qué hardware usa nuestra comunidad
   nos permite priorizar pruebas y controladores.
2. **Identificar problemas:** Si muchos usuarios con cierto hardware reportan
   errores, podemos investigar y solucionar.
3. **Optimizar el rendimiento:** Entender el rendimiento típico nos ayuda
   a establecer líneas base y detectar regresiones.
4. **Priorizar desarrollo:** Saber qué módulos son más populares nos ayuda
   a enfocar nuestros recursos.

NO utilizamos los datos para:
- Publicidad o marketing
- Perfiles de usuario
- Venta a terceros
- Cualquier propósito comercial

---

## 6. ALMACENAMIENTO Y SEGURIDAD

- Los datos se almacenan en servidores propiedad de LNOS en la Unión Europea.
- Los datos se cifran en reposo (AES-256) y en tránsito (TLS 1.3).
- Solo 3 personas del equipo de desarrollo tienen acceso a los datos agregados.
- Los datos crudos (no agregados) se eliminan tras 7 días.
- Los datos agregados se retienen 24 meses y luego se eliminan.

---

## 7. TUS DERECHOS (GDPR)

Si resides en la Unión Europea, tienes los siguientes derechos:

- **Acceso:** Solicitar una copia de todos los datos asociados a tu ID de instalación.
- **Rectificación:** Corregir datos incorrectos.
- **Eliminación:** Solicitar la eliminación de todos tus datos.
- **Limitación:** Restringir el procesamiento de tus datos.
- **Portabilidad:** Recibir tus datos en formato estructurado.
- **Oposición:** Oponerte al procesamiento (desactivando la telemetría).

Para ejercer estos derechos, contacta a privacy@lnos.dev.

---

## 8. CAMBIOS EN ESTA POLÍTICA

Si esta política cambia, se te notificará:
- En la próxima actualización del sistema (notificación en Centro de Software).
- En el Centro de Configuración (sección Privacidad).

Los cambios sustanciales requerirán tu consentimiento explícito.

---

## 9. CONTACTO

- **Email:** privacy@lnos.dev
- **Responsable de protección de datos:** dpo@lnos.dev
- **Código fuente:** https://github.com/lnos/telemetry
- **Foro de discusión:** https://discuss.lnos.dev/c/privacy

---

## 10. HERRAMIENTAS DE TRANSPARENCIA

Puedes ver exactamente qué datos se han enviado desde tu sistema:

```
lnos-config → Privacidad → Telemetría → "Ver datos enviados"
```

O desde la línea de comandos:

```bash
cat /var/lib/lnos/telemetry/last-submission.json
```
```

### 102.3 Base legal (GDPR)

| Actividad | Base legal | Justificación |
|-----------|-----------|---------------|
| Recogida de telemetría | Consentimiento (Art. 6.1.a) | El usuario activa explícitamente |
| Datos de instalación (no telemetría) | Interés legítimo (Art. 6.1.f) | Conteo anónimo de descargas |
| Logs del servidor | Obligación legal (Art. 6.1.c) | Seguridad del servidor |
| Contacto vía email | Consentimiento (Art. 6.1.a) | El usuario inicia el contacto |

### 102.4 Información de contacto

```
LNOS Project
(Proyecto comunitario, sin entidad legal)

Email de privacidad: privacy@lnos.dev
Email de seguridad: security@lnos.dev
Foro público: https://discuss.lnos.dev

Tiempo de respuesta: Máximo 30 días (GDPR Art. 12.3)
```

### 102.5 Cómo se comunica con el resto del sistema

```
Política de Privacidad
    │
    ├──→ Telemetría (capítulo 101) — datos recogidos
    ├──→ Centro de Configuración — visualización de política
    ├──→ lnos-welcome — aceptación de política en primer inicio
    ├──→ Centro de Software — notificación de cambios
    └──→ /usr/share/doc/lnos/PRIVACY.md — archivo local
```

### 102.6 Mantenimiento

- **Revisión:** La política se revisa anualmente o cuando cambian los datos recogidos.
- **Control de versiones:** La política tiene versionado semántico (v1.0.0).
- **Historial de cambios:** `CHANGELOG-PRIVACY.md` en el repositorio.
- **Notificación:** Cambios mayores se notifican con 30 días de antelación.

---

## 103. Seguridad (visión general)

### 103.1 ¿Para qué existe?

Este capítulo proporciona una visión general de la estrategia de seguridad de LNOS. Los detalles de implementación de cada componente están en sus respectivos capítulos (AppArmor en 40, Firewall en 38, Secure Boot en 26, LUKS2 en 23, Sandboxing en 104).

**Filosofía:** Defensa en profundidad. No confiamos en una sola capa de seguridad. Múltiples capas independientes garantizan que si una falla, las demás siguen protegiendo.

### 103.2 Estrategia de defensa en profundidad

```
CAPA 1: FÍSICA
├── LUKS2 (cifrado completo del disco)
├── Secure Boot (firma de bootloader y kernel)
└── BIOS/UEFI password (opcional)

CAPA 2: SISTEMA
├── Kernel hardening (sysctl)
├── AppArmor (control de acceso obligatorio)
├── firewalld/nftables (filtrado de red)
├── SELinux alternativo (opcional, para servidores)
└── Auditd (auditoría de eventos de seguridad)

CAPA 3: APLICACIONES
├── Flatpak (sandboxing de aplicaciones)
├── Bubblewrap (sandboxing ligero)
├── Polkit (autorización de operaciones privilegiadas)
├── PAM (autenticación de usuarios)
└── sudo (elevación de privilegios controlada)

CAPA 4: RED
├── firewalld (firewall por zona)
├── fail2ban (protección contra fuerza bruta)
├── SSH hardening (solo clave, no root, puerto no estándar opcional)
├── DNS over TLS (dnscrypt-proxy o systemd-resolved)
└── WireGuard (VPN integrada, opcional)

CAPA 5: ACTUALIZACIONES
├── Actualizaciones automáticas de seguridad
├── Snapshots pre/post actualización
├── Firmado de paquetes (GPG)
├── Firmado de ISO (GPG)
└── Verificación de integridad (checksums)
```

### 103.3 Comparativa de seguridad

| Aspecto | LNOS | Ubuntu | Fedora | Arch Linux |
|---------|------|--------|--------|-----------|
| Secure Boot | ✓ | ✓ | ✓ | Manual |
| AppArmor | ✓ (por defecto) | ✓ (parcial) | ✓ (SELinux) | Manual |
| Firewall | ✓ (firewalld) | ✓ (ufw) | ✓ (firewalld) | Manual |
| LUKS2 | ✓ (instalador) | ✓ (instalador) | ✓ (instalador) | Manual |
| Sandboxing | ✓ (Flatpak + Bubblewrap) | ✓ (Snap) | ✓ (Flatpak) | Manual |
| Actualizaciones seg. auto. | ✓ | ✓ | ✓ | Manual |
| Paquetes firmados | ✓ | ✓ | ✓ | ✓ |
| Hardening kernel | ✓ | Parcial | ✓ | Manual |

### 103.4 Actualizaciones de seguridad automáticas

**Política de actualizaciones de seguridad:**

| Tipo de actualización | ¿Automática? | ¿Requiere reinicio? | Notificación |
|----------------------|-------------|--------------------|-------------|
| Kernel (crítica) | Sí | Sí | Previa 24h |
| Kernel (normal) | No | Sí | Centro Software |
| Paquete (crítica) | Sí | No (usar) | Notificación |
| Paquete (normal) | No | No | Centro Software |
| Módulo LNOS | No | Depende | Centro Software |
| Firmware | Sí | Sí | Previa 24h |

**Mecanismo:**

```
lnos-security-updates.service
├── Timer: cada 6 horas
├── Verifica: pacman -Sy (solo sync, no upgrade)
├── Si CVE crítico: pacman -Syu --needed
│   ├── Crea snapshot pre-update
│   ├── Descarga e instala
│   ├── Verifica integridad
│   └── Notifica al usuario
└── Si normal: marca como disponible en Centro Software
```

### 103.5 Política de divulgación de vulnerabilidades

```
LNOS SECURITY POLICY
────────────────────

Contacto: security@lnos.dev
Clave GPG: https://lnos.dev/security.gpg
Fingerprint: A1B2 C3D4 E5F6 7890 1234 5678 9ABC DEF0 1234 5678

Tiempo de respuesta objetivo:
- Crítica (RCE, escalado privilegios): 48 horas
- Alta (denegación servicio, fuga datos): 7 días
- Media (cross-site, configuraciones débiles): 30 días
- Baja (mejora de seguridad): Próximo release

Programa de recompensas: No hay recompensa económica.
Reconocimiento: Los investigadores son reconocidos en SECURITY.md
y en los créditos del release.

Proceso:
1. Investigador envía reporte cifrado con GPG a security@lnos.dev
2. El equipo confirma recepción en < 24h
3. Evaluación de impacto y severidad
4. Desarrollo de fix
5. Release coordinado (parche silencioso o CVE público)
6. Reconocimiento público (si el investigador lo desea)
```

### 103.6 Cómo se comunica con el resto del sistema

```
Seguridad LNOS
    │
    ├──→ AppArmor (capítulo 40)
    ├──→ nftables/firewalld (capítulos 38-39)
    ├──→ Secure Boot (capítulo 26)
    ├──→ LUKS2 (capítulo 23)
    ├──→ Sandboxing (capítulo 104)
    ├──→ Polkit (capítulo 30)
    ├──→ PAM (capítulo 28)
    ├──→ sudo (capítulo 29)
    ├──→ Kernel hardening (capítulo 119)
    └──→ Actualizaciones automáticas (capítulo 78)
```

### 103.7 Mantenimiento

- **Auditoría:** El equipo de seguridad revisa la configuración de seguridad cada release.
- **CVE monitoring:** Suscripción a listas de CVE para Arch Linux y paquetes críticos.
- **Tests de penetración:** Anuales, realizados por miembros de la comunidad.
- **Bug bounty:** Programa de reconocimiento (sin recompensa económica).

---

## 104. Sandboxing

### 104.1 ¿Para qué existe?

El sandboxing en LNOS aísla las aplicaciones del sistema y entre sí, limitando el daño potencial si una aplicación es comprometida. Es una capa fundamental de la estrategia de defensa en profundidad.

**Filosofía:** Las aplicaciones no deberían tener más permisos de los que necesitan para funcionar. El sandboxing por defecto protege al usuario de sí mismo (instalar software no confiable) y de vulnerabilidades en aplicaciones legítimas.

### 104.2 Estrategia de sandboxing

```
Sandboxing LNOS
├── Aplicaciones Flatpak → sandbox nativo (burbuja)
├── Aplicaciones del sistema → Bubblewrap
├── Scripts/AUR → systemd-nspawn (opcional)
├── Aplicaciones no Flatpak → Firejail (opcional)
└── Contenedores → Docker/Podman (ver capítulos 105-107)
```

### 104.3 Flatpak como sandbox primario

Flatpak es el método de sandboxing **recomendado y configurado por defecto** en LNOS.

**Permisos Flatpak por defecto:**

```
# Permisos por defecto (restringidos)
--nosocket=x11           # Solo Wayland
--nosocket=session-bus   # Sin D-Bus de sesión (aislado)
--nodevice=all           # Sin acceso a dispositivos
--nofilesystem=host      # Sin acceso a archivos del sistema
--nofilesystem=home      # Sin acceso a /home
```

**Permisos que concede LNOS (según app):**

| Permiso | Apps ejemplo | Riesgo |
|---------|-------------|--------|
| `--socket=wayland` | Todas las GUI | Bajo (solo render) |
| `--share=network` | Navegadores, messengers | Medio |
| `--filesystem=home` | Gestores de archivos | Alto |
| `--device=all` | OBS, Steam (captura) | Alto |
| `--talk-name=org.freedesktop.Notifications` | Mensajería | Bajo |

**Herramienta de gestión de permisos:**

```
lnos-config → Seguridad → Permisos Flatpak

┌─────────────────────────────────────────────────────────┐
│  Permisos de aplicaciones Flatpak                        │
│                                                          │
│  Firefox                                                  │
│    [✓] Red              [ ] Cámara                       │
│    [✓] Wayland           [ ] Micrófono                    │
│    [ ] Sistema archivos  [ ] D-Bus sistema                │
│    [✓] Notificaciones   [ ] Ejecución en background      │
│                                                          │
│  Steam                                                    │
│    [✓] Red              [✓] Dispositivos GPU              │
│    [✓] Wayland           [✓] Home (solo Steam/)           │
│    [✓] GameMode         [ ] D-Bus sistema                │
└─────────────────────────────────────────────────────────┘
```

### 104.4 Bubblewrap

Para aplicaciones que no están empaquetadas como Flatpak, LNOS proporciona **Bubblewrap** como capa de sandboxing ligera:

```bash
# Ejemplo: ejecutar aplicación no Flatpak con permisos mínimos
bwrap \
    --ro-bind /usr /usr \
    --ro-bind /etc /etc \
    --proc /proc \
    --dev /dev \
    --bind ~/Documents ~/Documents \
    --unshare-all \
    --hostname lnos-sandbox \
    --chdir /home/user \
    app-to-sandbox
```

**Integración con lnos-config:**

```
lnos-config → Seguridad → Sandboxing → Bubblewrap

Configuración de sandboxing para aplicaciones nativas:
┌─────────────────────────────────────────────────────────┐
│  Aplicaciones nativas con Bubblewrap                     │
│                                                          │
│  [✓] Aplicar sandboxing a todas las apps no listadas     │
│  [ ] Excepciones:                                        │
│      - thunar (gestor archivos → necesita sistema)       │
│      - kitty (terminal → necesita /dev/pts)              │
│      - hyprland (compositor → necesita todo)             │
└─────────────────────────────────────────────────────────┘
```

### 104.5 systemd-nspawn para sandboxing ligero

Para scripts y entornos de compilación (como AUR), LNOS ofrece systemd-nspawn:

```bash
# Ejecutar makepkg en contenedor ligero
lnos-aur-build --sandbox
# Equivalente a:
systemd-nspawn \
    --directory=/var/lib/lnos/aur-build \
    --bind=/tmp/aur-build:/build \
    --as-pid2 \
    --private-network \
    --read-only \
    makepkg -si
```

### 104.6 Firejail (opcional)

Firejail está disponible como alternativa para usuarios que prefieran su modelo de perfiles. LNOS proporciona perfiles preconfigurados:

```
/etc/firejail/
├── firefox.profile          # Perfil para Firefox
├── chromium.profile         # Perfil para Chromium
├── steam.profile            # Perfil para Steam
├── discord.profile          # Perfil para Discord
├── obs.profile              # Perfil para OBS Studio
├── lnos-default.profile     # Perfil por defecto LNOS
└── lnos-restricted.profile  # Perfil máximo restricción
```

**Por qué Firejail es opcional (no recomendado por defecto):**

| Aspecto | Flatpak | Bubblewrap | Firejail |
|---------|---------|------------|----------|
| Aislamiento | Fuerte | Medio | Medio |
| Integración Wayland | Sí | Sí | Limitada |
| Mantenimiento | Activo | Activo | Bajo |
| SUID | No | No | Sí (riesgo seguridad) |
| Perfiles actualizados | Automáticos | Manuales | Comunidad |

### 104.7 Políticas de permisos

LNOS implementa un sistema de políticas de permisos que controla qué aplicaciones pueden hacer:

```
/etc/lnos/sandbox-policies/
├── default.toml             # Política por defecto
├── browsers.toml            # Política para navegadores
├── games.toml               # Política para juegos
└── custom/                  # Políticas de usuario

default.toml:
[network]
allow = true  # La mayoría de apps necesitan red

[camera]
allow = false  # Denegado por defecto

[mic]
allow = false  # Denegado por defecto

[filesystem]
home_read = true
home_write = false  # No escribir en home sin permiso
other_read = false
other_write = false

[devices]
gpu = true
usb = false
input = false
```

### 104.8 Cómo se comunica con el resto del sistema

```
Sandboxing LNOS
    │
    ├──→ Flatpak (sandbox primario)
    ├──→ Bubblewrap (sandbox secundario para apps nativas)
    ├──→ systemd-nspawn (sandbox para compilación/scripts)
    ├──→ Firejail (opcional)
    ├──→ AppArmor (perfiles que complementan sandbox)
    ├──→ lnos-config (gestión de permisos)
    ├──→ Polkit (autorización de excepciones)
    └──→ /etc/lnos/sandbox-policies/ (políticas de permisos)
```

### 104.9 Dependencias

| Dependencia | Tipo | Razón |
|------------|------|-------|
| `flatpak` | Paquete | Sandbox primario |
| `bubblewrap` | Paquete | Sandbox secundario |
| `systemd` | Paquete | systemd-nspawn |
| `firejail` | Opcional | Sandbox alternativo |

### 104.10 Problemas potenciales y mitigaciones

| Problema | Mitigación |
|----------|-----------|
| App Flatpak no funciona correctamente | Conceder permisos adicionales específicos |
| Bubblewrap rompe app que necesita /sys | Añadir `--ro-bind /sys /sys` |
| Firejail SUID es riesgo de seguridad | No instalar Firejail si no es necesario |
| Permiso excesivo concedido por error | Revisión periódica en lnos-config |
| App evade sandbox via kernel exploit | Mantener kernel actualizado |

### 104.11 Cómo se prueba

| Test | Procedimiento |
|------|--------------|
| Flatpak aislado | `flatpak run --command=bash app`; verificar `ls /home` denegado |
| Bubblewrap aislado | Ejecutar app con bwrap; verificar `/sys` no accesible |
| nspawn aislado | Ejecutar script en contenedor; verificar red aislada |
| Permisos | Conceder/quitar permiso; verificar efecto inmediato |

### 104.12 Cómo se mantiene

- **Flatpak:** Permisos gestionados por el usuario via `flatpak override`.
- **Bubblewrap:** Scripts de sandbox en `/usr/share/lnos/sandbox/`.
- **Políticas:** Archivos TOML en `/etc/lnos/sandbox-policies/`.
- **Logs:** `journalctl -t lnos-sandbox` para violaciones de permisos.

### 104.13 Cómo puede ampliarse

- **Sandbox por módulo:** Los módulos pueden declarar sus propias políticas de sandbox.
- **Sandbox adaptativo:** Políticas que se ajustan según el comportamiento de la app (ML-based).
- **Sandbox de red:** Control granular de conexiones de red por aplicación.
- **Sandbox portátil:** Perfiles de sandbox que viajan con la app en formatos portátiles.

---

## 105. Contenedores

### 105.1 ¿Para qué existe?

LNOS proporciona soporte completo para contenedores, tanto para desarrollo como para producción. Se ofrecen dos motores: **Docker** (estándar de la industria) y **Podman** (alternativa sin daemon, integrada con systemd).

**Filosofía:** No imponer un motor de contenedores. El usuario elige según sus necesidades. Ambos están preconfigurados para funcionar correctamente en LNOS.

### 105.2 Comparativa Docker vs Podman

| Aspecto | Docker | Podman |
|---------|--------|--------|
| Arquitectura | Cliente-servidor (dockerd) | Sin daemon (fork/exec) |
| Rootless | Sí (docker-rootless) | Sí (por defecto) |
| Integración systemd | Limitada | Nativa (generar unidad) |
| Compatibilidad Docker CLI | 100% | 100% (alias docker=podman) |
| Orquestación | docker-compose | podman-compose |
| Kubernetes | Sí | Sí (Podman → kube play) |
| Rendimiento | Excelente | Excelente |
| Comunidad | Masiva | En crecimiento |
| Uso en LNOS | Gaming, desarrollo | Servidores, systemd |

**Decisión:** **Ambos.** Docker para compatibilidad con ecosistema existente. Podman para integración nativa con systemd y entornos rootless.

### 105.3 Almacenamiento para contenedores

LNOS configura el almacenamiento de contenedores para funcionar sobre Btrfs:

```
# Docker: storage driver overlay2 sobre Btrfs
/etc/docker/daemon.json:
{
  "storage-driver": "overlay2",
  "log-driver": "journald",
  "iptables": false,
  "experimental": true
}

# Podman: storage driver overlay2
/etc/containers/storage.conf:
[storage]
driver = "overlay2"
runroot = "/run/containers/storage"
graphroot = "/var/lib/containers/storage"

# Ubicación de imágenes y volúmenes
/var/lib/docker/       → subvolumen @docker (nodatacow)
/var/lib/containers/   → subvolumen @containers (nodatacow)
```

**Por qué nodatacow en almacenamiento de contenedores:** Las capas de contenedores generan mucha actividad de archivos pequeños y reescrituras. COW en Btrfs fragmenta y degrada el rendimiento. `nodatacow` evita este problema.

### 105.4 Red de contenedores

```
Red LNOS para contenedores:
┌──────────┐     ┌──────────┐     ┌──────────┐
│  Host     │────►│  Bridge  │◄────│ Contened.│
│  LNOS     │     │  docker0 │     │  red      │
│           │     │  podman  │     │          │
└──────────┘     └──────────┘     └──────────┘
                      │
                 ┌────▼────┐
                 │ firewalld│
                 │  (NAT)   │
                 └─────────┘
```

**Configuración de red por defecto:**

```
# Firewall para contenedores
firewall-cmd --zone=trusted --add-interface=docker0 --permanent
firewall-cmd --zone=trusted --add-interface=podman --permanent
firewall-cmd --add-masquerade --permanent
```

### 105.5 Orquestación ligera

**Docker Compose:**

```
# Instalación
lnos-mod install lnos-docker
pip install docker-compose  # o docker compose plugin

# Ejemplo docker-compose.yml
version: "3.8"
services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
  db:
    image: postgres:16
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

**Podman Compose:**

```
# Instalación
lnos-mod install lnos-podman
pip install podman-compose

# Mismo docker-compose.yml funciona con podman-compose
podman-compose up
```

### 105.6 Cómo se comunica con el resto del sistema

```
Contenedores LNOS
    │
    ├──→ Docker Engine (dockerd) o Podman
    ├──→ Btrfs (almacenamiento overlay2)
    ├──→ firewalld (NAT para contenedores)
    ├──→ systemd (gestión de servicios de contenedores)
    ├──→ AppArmor (perfiles para contenedores)
    ├──→ lnos-mod (instalación de Docker/Podman)
    └──→ lnos-config (Centro de Configuración → Contenedores)
```

### 105.7 Dependencias

| Dependencia | Tipo | Razón |
|------------|------|-------|
| `docker` o `podman` | Paquete | Motor de contenedores |
| `containerd` | Paquete | Runtime de contenedores (Docker) |
| `runc` o `crun` | Paquete | Ejecutor de contenedores |
| `docker-compose` o `podman-compose` | Opcional | Orquestación |
| `slirp4netns` | Paquete | Red rootless |
| `fuse-overlayfs` | Paquete | Almacenamiento rootless |

### 105.8 Problemas potenciales y mitigaciones

| Problema | Mitigación |
|----------|-----------|
| Contenedor no tiene red | Verificar firewalld masquerade; verificar bridge |
| Almacenamiento overlay2 lento | nodatacow en directorio de almacenamiento |
| Docker no arranca | `dockerd --debug` para diagnóstico |
| Podman rootless: puerto <1024 | Usar `podman port` o `authbind` |
| Contenedor no ve GPU | `--device /dev/dri` o `--gpus all` |

### 105.9 Cómo se prueba

| Test | Procedimiento |
|------|--------------|
| Docker funcionando | `docker run hello-world` |
| Podman funcionando | `podman run hello-world` |
| Red contenedor | `docker run --rm alpine ping 8.8.8.8` |
| Almacenamiento | `docker info \| grep "Storage Driver"` debe ser overlay2 |
| docker-compose | `docker-compose up -d` y verificar servicios |

### 105.10 Cómo se mantiene

- **Docker/Podman:** Actualizaciones via pacman.
- **Imágenes:** `docker system prune` mensual (script de mantenimiento).
- **Seguridad:** `docker scan` para vulnerabilidades en imágenes.
- **Logs:** `journalctl -u docker` o `journalctl -u podman`.

### 105.11 Cómo puede ampliarse

- **Registry local:** Docker Registry mirror para acelerar descargas.
- **Web UI:** Portainer o Podman Desktop para gestión gráfica.
- **CI/CD containers:** Integración con GitLab Runner o Jenkins.
- **Kubernetes:** MicroK8s o K3s para orquestación completa.

---

## 106. Docker

### 106.1 ¿Para qué existe?

Docker es el motor de contenedores más utilizado del mundo. LNOS lo ofrece como opción para usuarios que necesitan compatibilidad con el ecosistema Docker existente, especialmente en desarrollo, CI/CD y gaming.

**¿Por qué incluir Docker si Podman es compatible?** Docker sigue siendo el estándar de facto. Ciertas herramientas (docker-compose v1, ciertas imágenes, algunos flujos de trabajo) funcionan mejor con Docker. LNOS ofrece ambos para que el usuario elija.

### 106.2 Componentes

```
Docker LNOS
├── docker-ce (Docker Engine)
├── containerd (runtime de contenedores)
├── docker-cli (CLI)
├── docker-compose-plugin (compose v2)
├── docker-buildx (build multi-plataforma)
└── docker-rootless (modo sin root)
```

### 106.3 docker-rootless

LNOS configura Docker para funcionar en **modo rootless** por defecto:

```
# Instalación del modo rootless
dockerd-rootless-setuptool.sh install

# Servicio systemd (usuario)
systemctl --user enable --now docker

# Verificar
docker info | grep -i rootless
# Rootless: true
```

**Ventajas del modo rootless:**

- El daemon Docker no corre como root.
- Los contenedores tienen menos privilegios.
- La superficie de ataque se reduce significativamente.
- Compatible con el sandboxing de LNOS.

**Si el usuario necesita modo root (para ciertas herramientas):**

```
lnos-config → Seguridad → Contenedores → "Permitir Docker root"
# O via CLI:
lnos-mod enable lnos-docker-rooted
```

### 106.4 Configuración de registros

LNOS preconfigura Docker para usar registros de imágenes:

```json
// /etc/docker/daemon.json
{
  "registry-mirrors": [
    "https://mirror.gcr.io",
    "https://docker.mirrors.lnos.dev"
  ],
  "insecure-registries": [],
  "log-driver": "journald",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
```

**Registros soportados:**

| Registro | Configuración | 
|----------|--------------|
| Docker Hub | Por defecto |
| GitHub Container Registry (GHCR) | `docker pull ghcr.io/user/repo` |
| GitLab Container Registry | `docker pull registry.gitlab.com/user/repo` |
| Quay.io | `docker pull quay.io/user/repo` |
| Registro privado | Añadir a `/etc/docker/daemon.json` |

### 106.5 Integración con firewalld y AppArmor

**Firewalld:**

```bash
# Zona para contenedores
firewall-cmd --zone=trusted --add-interface=docker0 --permanent
firewall-cmd --reload
```

**AppArmor:**

```bash
# Perfil de AppArmor para Docker (incluido en docker-ce)
# /etc/apparmor.d/docker
# Activado por defecto

# Verificar perfil cargado
aa-status | grep docker
# docker-default profile is in enforce mode
```

### 106.6 Cómo se comunica con el resto del sistema

```
Docker
    │
    ├──→ containerd (gestión de contenedores)
    ├──→ runc (ejecución de contenedores)
    ├──→ Btrfs (almacenamiento overlay2)
    ├──→ firewalld (red de contenedores)
    ├──→ AppArmor (perfil docker-default)
    ├──→ systemd (docker.service, containerd.service)
    └──→ lnos-mod (instalación/desinstalación)
```

### 106.7 Dependencias

| Dependencia | Tipo | Razón |
|------------|------|-------|
| `docker-ce` | Paquete | Docker Engine |
| `containerd` | Paquete | Runtime de contenedores |
| `docker-cli` | Paquete | CLI de Docker |
| `docker-compose` | Paquete | Orquestación |
| `slirp4netns` | Paquete | Red rootless |
| `fuse-overlayfs` | Paquete | Almacenamiento rootless |
| `iptables-nft` | Paquete | Reglas de red para Docker |

### 106.8 Problemas potenciales y mitigaciones

| Problema | Mitigación |
|----------|-----------|
| Docker no arranca en rootless | Verificar `dockerd-rootless-setuptool.sh` ejecutado |
| Puertos privilegiados (<1024) | Usar `docker run -p 8080:80` en lugar de `-p 80:80` |
| Almacenamiento overlay2 lento | Verificar nodatacow en /var/lib/docker |
| Red no funciona en contenedor | Verificar firewalld masquerade; `--iptables=false` en daemon.json |
| Imagen no encontrada | Verificar registry-mirrors; `docker pull --platform linux/amd64` |

### 106.9 Cómo se prueba

| Test | Procedimiento |
|------|--------------|
| Docker Engine | `docker run hello-world` |
| Rootless | `docker info \| grep Rootless` debe ser true |
| Red | `docker run --rm alpine ping 8.8.8.8` |
| Volumen | `docker run --rm -v /tmp:/tmp alpine ls /tmp` |
| docker-compose | `docker compose version` |

### 106.10 Cómo se mantiene

- **Docker:** `lnos-mod update lnos-docker` o pacman.
- **Limpieza:** `docker system prune` semanal (script mantenimiento).
- **Seguridad:** `docker scan` en imágenes descargadas.
- **Logs:** `journalctl -u docker`; `docker logs <container>`.

### 106.11 Cómo puede ampliarse

- **Docker Compose V2:** Plugin integrado en docker CLI.
- **BuildKit:** Sistema de compilación mejorado (activado por defecto en Docker v24+).
- **Docker Desktop:** No disponible en Linux nativo; alternativa: Podman Desktop.
- **Extensions Docker:** No soportadas en Linux (solo Docker Desktop).

---

## 107. Podman

### 107.1 ¿Para qué existe?

Podman es el motor de contenedores alternativo a Docker, con las siguientes ventajas que lo hacen especialmente atractivo para LNOS:

1. **Sin daemon:** No necesita un proceso en background (dockerd), ahorrando RAM (~50MB).
2. **Rootless por defecto:** Mayor seguridad sin configuración adicional.
3. **Integración systemd:** Puede generar unidades systemd para contenedores.
4. **100% CLI compatible:** `alias docker=podman` funciona sin cambios.

**¿Por qué ofrecer ambos?** Podman es la opción recomendada para LNOS por su integración nativa con systemd y su modelo de seguridad. Docker se ofrece para compatibilidad con herramientas y flujos de trabajo existentes.

### 107.2 Ventajas sobre Docker

| Aspecto | Podman | Docker |
|---------|--------|--------|
| Daemon | No necesita | Sí (dockerd) |
| Rootless | Por defecto | Configurable |
| RAM en reposo | 0 MB | ~50 MB (dockerd) |
| Integración systemd | Nativa | Limitada |
| Sin permisos SUID | Sí | No (docker grupo) |
| Generar unidades systemd | `podman generate systemd` | No nativo |
| Manejo de pods | Sí (Kubernetes-like) | No |
| API REST | Via socket (opcional) | Siempre |

### 107.3 Podman rootless

Podman funciona **sin root** por defecto. No requiere configuración adicional:

```bash
# Un usuario normal puede ejecutar contenedores inmediatamente
podman run hello-world

# Verificar modo rootless
podman info | grep rootless
# rootless: true
```

**Almacenamiento rootless:**

```
~/.local/share/containers/storage/  → Imágenes y capas
/run/user/$UID/containers/          → Runtime
```

### 107.4 Podman-compose

Podman-compose es compatible con archivos `docker-compose.yml`:

```bash
# Instalación
pip install podman-compose

# Uso (mismo archivo docker-compose.yml)
podman-compose up -d
podman-compose ps
podman-compose down
```

**Limitaciones conocidas:**

- `docker-compose.yml` con `network_mode: host` puede no funcionar en rootless.
- Algunas extensiones de Compose v3 no son soportadas.
- Escalado de servicios puede ser más lento.

### 107.5 Podman machine

Podman machine permite ejecutar contenedores Linux en macOS/Windows, pero en LNOS (Linux nativo) no es necesario. Se incluye por completitud:

```
# No necesario en LNOS (Linux nativo)
# Solo útil si quieres ejecutar Podman dentro de una VM
podman machine init lnos-vm
podman machine start lnos-vm
```

### 107.6 Integración con systemd

Podman puede generar unidades systemd para que los contenedores se inicien automáticamente:

```bash
# Crear contenedor
podman create --name my-app --restart=always my-image

# Generar unidad systemd
podman generate systemd --name my-app --files

# Instalar unidad
cp container-my-app.service ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now container-my-app.service

# Verificar
systemctl --user status container-my-app.service
```

**Ventaja:** Los contenedores se comportan como servicios systemd nativos, con logging en journald, dependencias, y reinicio automático.

### 107.7 Cómo se comunica con el resto del sistema

```
Podman
    │
    ├──→ crun/runc (runtime de contenedores)
    ├──→ Btrfs (almacenamiento overlay2)
    ├──→ firewalld (red de contenedores)
    ├──→ systemd (unidades generadas para contenedores)
    ├──→ AppArmor (perfiles)
    ├──→ lnos-config (Centro de Configuración → Contenedores)
    └──→ /etc/containers/ (configuración)
```

### 107.8 Dependencias

| Dependencia | Tipo | Razón |
|------------|------|-------|
| `podman` | Paquete | Motor de contenedores |
| `crun` | Paquete | Runtime rápido (escrito en C) |
| `podman-compose` | Opcional | Orquestación |
| `slirp4netns` | Paquete | Red rootless |
| `fuse-overlayfs` | Paquete | Almacenamiento rootless |
| `catatonit` | Paquete | Init para contenedores |

### 107.9 Problemas potenciales y mitigaciones

| Problema | Mitigación |
|----------|-----------|
| Podman no encuentra imagen Docker | Podman usa Docker Hub por defecto; `podman pull docker.io/image` |
| Red rootless no funciona | Verificar `slirp4netns` instalado |
| mount --bind no funciona rootless | Usar `--volume` en su lugar |
| Podman-compose falla con ciertos compose | Usar `podman play kube` (formato Kubernetes) |
| Contenedor no persiste tras reinicio | Generar unidad systemd con `podman generate systemd` |

### 107.10 Cómo se prueba

| Test | Procedimiento |
|------|--------------|
| Podman funcionando | `podman run hello-world` |
| Rootless | `podman info \| grep rootless` debe ser true |
| Red | `podman run --rm alpine ping 8.8.8.8` |
| systemd unit | Generar unidad; verificar `systemctl --user status` |
| docker alias | `alias docker=podman`; `docker ps` debe funcionar |

### 107.11 Cómo se mantiene

- **Podman:** Actualizaciones via pacman. Configuración en `/etc/containers/`.
- **Imágenes:** `podman system prune` mensual.
- **Logs:** `journalctl --user -u container-*` para contenedores como servicios.
- **Seguridad:** Podman actualizado con el sistema.

### 107.12 Cómo puede ampliarse

- **Kubernetes play:** `podman play kube` para desplegar pods desde YAML de Kubernetes.
- **Podman Desktop:** GUI para gestión de contenedores.
- **Hooks de contenedores:** Scripts que se ejecutan antes/durante/después del ciclo de vida del contenedor.
- **Integración con firewall:** Podman puede integrarse con firewalld para gestión de puertos.

---

## 108. Virtualización

### 108.1 ¿Para qué existe?

LNOS proporciona virtualización completa mediante KVM + QEMU, permitiendo ejecutar máquinas virtuales con rendimiento casi nativo. La virtualización es esencial para desarrolladores, administradores de sistemas y usuarios que necesitan probar otros sistemas operativos.

**¿Por qué KVM+QEMU y no VirtualBox?**

| Aspecto | KVM+QEMU | VirtualBox |
|---------|----------|-----------|
| Rendimiento | Casi nativo (virtio) | Bueno pero inferior |
| Integración kernel | Nativa (módulo kernel) | Módulo kernel externo |
| Seguridad | Sandboxing (sVirt) | Limitado |
| Open Source | 100% | Código abierto parcial |
| Passthrough GPU | Sí (VFIO) | Limitado |
| Snapshots | Sí (QEMU + Btrfs) | Sí |
| CLI | Poderosa (virsh, qemu) | CLI limitada |
| Precio | Gratuito | Gratuito (Extension Pack pago) |

**Decisión: KVM+QEMU como hipervisor por defecto.**

### 108.2 Componentes

```
Virtualización LNOS
├── Kernel: kvm_intel.ko / kvm_amd.ko
├── QEMU (emulador + acelerador KVM)
├── libvirtd (daemon de virtualización)
├── virt-manager (GUI)
├── vmcli (CLI alternativa, propia de LNOS)
├── edk2-ovmf (UEFI firmware para VMs)
├── dnsmasq (DHCP para redes virtuales)
└── swtpm (TPM virtual para VMs)
```

### 108.3 Arquitectura

```
┌─────────────────────────────────────────────────────┐
│    Host LNOS                                         │
│  ┌──────────────┐     ┌──────────────┐              │
│  │  VM1          │     │  VM2          │              │
│  │  Windows 11   │     │  Fedora       │              │
│  │  qemu-system  │     │  qemu-system  │              │
│  │  x86_64       │     │  x86_64       │              │
│  └──────┬───────┘     └──────┬───────┘              │
│         │                    │                       │
│         ▼                    ▼                       │
│  ┌─────────────────────────────────────┐            │
│  │         libvirtd (daemon)            │            │
│  └──────────────────┬──────────────────┘            │
│                     │                               │
│  ┌──────────────────▼──────────────────┐            │
│  │         KVM (kernel module)          │            │
│  │    kvm_intel / kvm_amd              │            │
│  └──────────────────┬──────────────────┘            │
│                     │                               │
│  ┌──────────────────▼──────────────────┐            │
│  │         Hardware (CPU + RAM + GPU)   │            │
│  └─────────────────────────────────────┘            │
└─────────────────────────────────────────────────────┘
```

### 108.4 Configuración de redes virtuales

**NAT (por defecto):**

```xml
<!-- Red NAT por defecto: 192.168.122.0/24 -->
<network>
  <name>default</name>
  <forward mode='nat'/>
  <bridge name='virbr0'/>
  <ip address='192.168.122.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.122.2' end='192.168.122.254'/>
    </dhcp>
  </ip>
</network>
```

**Bridge (acceso completo a red local):**

```
1. Crear bridge (networkmanager):
   nmcli connection add type bridge con-name br0 ifname br0
2. Añadir interfaz física al bridge:
   nmcli connection add type bridge-slave con-name br0-enp3s0 ifname enp3s0 master br0
3. Configurar libvirt para usar el bridge:
   virsh net-define bridge.xml
   virsh net-start bridge
   virsh net-autostart bridge
```

### 108.5 Almacenamiento virtual

**Pool de almacenamiento:**

```
# Pool por defecto (directorio)
/var/lib/libvirt/images/  → Pool "default" (tipo dir)

# Pool Btrfs (con snapshots)
virsh pool-define-as btrfs_pool dir --target /var/lib/libvirt/btrfs
virsh pool-build btrfs_pool
virsh pool-start btrfs_pool
virsh pool-autostart btrfs_pool
```

**Formatos de imagen:**

| Formato | Uso | Características |
|---------|-----|----------------|
| **qcow2** | Por defecto | Snapshots, compresión, sparse, cifrado |
| **raw** | Rendimiento máximo | Sin features, mapeo directo |
| **qed** | Obsoleto | No usar |

### 108.6 virsh (CLI principal)

```bash
# Listar VMs
virsh list --all

# Iniciar VM
virsh start vm-name

# Apagar VM (ACPI)
virsh shutdown vm-name

# Conectar consola VNC
virsh vncdisplay vm-name

# Crear snapshot
virsh snapshot-create-as vm-name snapshot1

# Migrar VM (en caliente)
virsh migrate --live vm-name qemu+ssh://destino/system
```

### 108.7 virt-manager (GUI)

Virt-manager es la interfaz gráfica para gestión de VMs. LNOS la integra en el Centro de Configuración:

```
lnos-config → Virtualización
├── Listar VMs
├── Crear VM (asistente: SO, RAM, CPU, disco, red)
├── Iniciar/Detener/Reiniciar
├── Snapshot (crear, restaurar, eliminar)
├── Configurar hardware (CPU, RAM, GPU passthrough)
└── Consola VNC/SPICE
```

### 108.8 vmcli (CLI alternativa LNOS)

Para usuarios que prefieren CLI sobre GUI, LNOS incluye `vmcli`, una herramienta CLI simplificada para operaciones comunes:

```bash
# Listar VMs
vmcli list

# Crear VM rápida
vmcli create --name win11 --os windows --ram 8G --cpu 4 --disk 64G

# Iniciar
vmcli start win11

# Conectar VNC
vmcli vnc win11

# Passthrough GPU
vmcli passthrough --vm win11 --pci 01:00.0

# Exportar VM a otro host
vmcli export win11 --format qcow2 --output /backup/win11.qcow2
```

### 108.9 Cómo se comunica con el resto del sistema

```
Virtualización LNOS
    │
    ├──→ Kernel (kvm_intel/kvm_amd, vfio, virtio)
    ├──→ libvirtd (daemon de gestión)
    ├──→ QEMU (emulador/acelerador)
    ├──→ Btrfs (imágenes qcow2, snapshots)
    ├──→ firewalld (redes virtuales, NAT)
    ├──→ AppArmor/sVirt (seguridad de VMs)
    ├──→ lnos-config (Centro de Configuración → Virtualización)
    └──→ systemd (libvirtd.service)
```

### 108.10 Dependencias

| Dependencia | Tipo | Razón |
|------------|------|-------|
| `qemu-desktop` o `qemu-full` | Paquete | QEMU con soporte gráfico |
| `libvirt` | Paquete | Daemon de virtualización |
| `virt-manager` | Paquete | GUI de gestión |
| `edk2-ovmf` | Paquete | UEFI firmware |
| `dnsmasq` | Paquete | DHCP para redes NAT |
| `swtpm` | Paquete | TPM virtual |
| `virt-viewer` | Paquete | Cliente SPICE/VNC |

### 108.11 Problemas potenciales y mitigaciones

| Problema | Mitigación |
|----------|-----------|
| KVM no disponible | Verificar `kvm-ok`; habilitar VT-x/AMD-V en BIOS |
| VM no arranca con UEFI | Instalar `edk2-ovmf`; seleccionar firmware UEFI |
| Red NAT no funciona | Verificar `dnsmasq`; `systemctl restart libvirtd` |
| GPU passthrough no funciona | Verificar IOMMU groups; ACS patch si necesario |
| Rendimiento pobre | Usar virtio para disco y red; activar KVM |

### 108.12 Cómo se prueba

| Test | Procedimiento |
|------|--------------|
| KVM activo | `kvm-ok` o `lsmod \| grep kvm` |
| libvirtd | `systemctl status libvirtd` |
| Crear VM | `virt-install --name test --ram 1024 --disk size=5 --cdrom /dev/null` |
| Red NAT | Crear VM con red default; verificar IP asignada |
| virt-manager | Abrir virt-manager; conectar a QEMU:///system |

### 108.13 Cómo se mantiene

- **libvirtd:** `systemctl restart libvirtd` tras actualizaciones.
- **QEMU:** Actualizaciones via pacman; cambios breaking son raros pero documentados.
- **Imágenes:** Limpiar imágenes no usadas: `virsh vol-list default --details`.
- **Redes:** Verificar bridges; `virsh net-list --all`.

### 108.14 Cómo puede ampliarse

- **Passthrough automatizado:** Script que detecta IOMMU groups y configura VFIO.
- **Plantillas de VMs:** VMs preconfiguradas para entornos comunes (Windows 11, Fedora, Ubuntu Server).
- **Orquestación de VMs:** Terraform provider para libvirt.
- **Incremental backups:** `virsh backup-begin` + integración con borg.

---

## 109. KVM

### 109.1 ¿Para qué existe?

KVM (Kernel-based Virtual Machine) es la tecnología de virtualización del kernel Linux que convierte a Linux en un hipervisor tipo 1 (bare-metal). Es el componente fundamental sobre el que se construye la virtualización en LNOS.

**¿Por qué KVM y no VirtualBox o VMware?**

| Aspecto | KVM | VirtualBox | VMware Workstation |
|---------|-----|-----------|-------------------|
| Tipo de hipervisor | Tipo 1 (bare-metal) | Tipo 2 (hosted) | Tipo 2 (hosted) |
| Rendimiento | Casi nativo | ~85% nativo | ~90% nativo |
| Integración kernel | Nativa (módulo kernel) | Módulo externo (vboxdrv) | Módulos externos |
| Open Source | 100% (GPL) | Código abierto parcial | Propietario |
| Precio | Gratuito | Gratuito (Extension Pack pago) | $199/año |
| Passthrough GPU | Sí (VFIO) | Limitado | Limitado |
| Seguridad (sVirt) | Sí | No | No |

### 109.2 Módulos KVM

KVM se compone de dos módulos del kernel:

```
kvm.ko                   → Core KVM (independiente de arquitectura)
kvm_intel.ko             → Soporte para CPUs Intel (VT-x)
kvm_amd.ko               → Soporte para CPUs AMD (AMD-V)
```

**Verificación de módulos cargados:**

```bash
lsmod | grep kvm
kvm_intel             122880  0
kvm                  1064960  1 kvm_intel

# Verificar soporte hardware
kvm-ok
INFO: /dev/kvm exists
KVM acceleration can be used
```

### 109.3 Configuración de anidamiento (nested virtualization)

El anidamiento permite ejecutar un hipervisor dentro de una VM:

```
# Activar anidamiento para Intel
echo "options kvm_intel nested=1" > /etc/modprobe.d/kvm_intel.conf

# Activar anidamiento para AMD
echo "options kvm_amd nested=1" > /etc/modprobe.d/kvm_amd.conf

# Verificar
cat /sys/module/kvm_intel/parameters/nested
Y
```

**Uso en LNOS:** Activado por defecto para permitir contenedores dentro de VMs y VMs dentro de VMs.

### 109.4 Rendimiento

KVM ofrece rendimiento casi nativo mediante dispositivos **virtio**:

| Dispositivo | Emulado | virtio | Diferencia |
|------------|---------|--------|-----------|
| **Disco** | IDE (~100 MB/s) | virtio-blk (~5000 MB/s) | 50x |
| **Red** | e1000 (~1 Gbps) | virtio-net (~40 Gbps) | 40x |
| **GPU** | VGA (~100 FPS) | virtio-vga / virtio-gpu | 5-10x |
| **Memoria** | — | — | Sin overhead en CPU moderna |

**Configuración virtio por defecto en LNOS:**

```xml
<controller type='virtio-serial' index='0'/>
<disk type='file' device='disk'>
  <driver name='qemu' type='qcow2' iothread='1'/>
  <source file='/var/lib/libvirt/images/vm.qcow2'/>
  <target dev='vda' bus='virtio'/>
</disk>
<interface type='network'>
  <model type='virtio'/>
</interface>
<video>
  <model type='virtio' heads='1'/>
</video>
```

### 109.5 KVM como hipervisor por defecto

LNOS configura KVM como hipervisor por defecto:

```bash
# Verificar que KVM está disponible
kvm-ok

# Configurar libvirt para usar KVM (ya es por defecto)
virsh capabilities | grep kvm
  <kvm>
    <domain type='kvm'/>
  </kvm>
```

### 109.6 Cómo se comunica con el resto del sistema

```
KVM
    │
    ├──→ /dev/kvm (interfaz ioctl con QEMU/libvirt)
    ├──→ kvm_intel.ko / kvm_amd.ko (módulos kernel)
    ├──→ QEMU (aceleración via KVM)
    ├──→ libvirtd (gestión de VMs)
    ├──→ cgroups (limitación de recursos)
    ├──→ sVirt/AppArmor (seguridad)
    └──→ Kernel (gestión de memoria, E/S)
```

### 109.7 Dependencias

| Dependencia | Tipo | Razón |
|------------|------|-------|
| `qemu-system-x86_64` | Paquete | QEMU con KVM |
| `libvirt` | Paquete | Gestión de VMs |
| `cpu-checker` | Paquete | kvm-ok |
| Kernel ≥ 6.6 | Sistema | Soporte KVM estable |

### 109.8 Problemas potenciales y mitigaciones

| Problema | Mitigación |
|----------|-----------|
| VT-x/AMD-V desactivado en BIOS | Habilitar en BIOS/UEFI |
| /dev/kvm no accesible | Añadir usuario a grupo `kvm` |
| Rendimiento pobre con emulación | Configurar dispositivos virtio |
| Nested virtualization no funciona | Activar módulo con nested=1 |
| KVM no disponible en cloud VM | Usar TCG (QEMU sin aceleración) como fallback |

### 109.9 Cómo se prueba

| Test | Procedimiento |
|------|--------------|
| kvm-ok | `kvm-ok` debe mostrar "KVM acceleration can be used" |
| Módulos | `lsmod \| grep kvm` debe mostrar kvm_intel/kvm_amd |
| /dev/kvm | `ls -l /dev/kvm` permisos correctos |
| Rendimiento | `virsh perf ...` métricas de rendimiento |
| Anidamiento | Crear VM con KVM dentro; verificar que funciona |

### 109.10 Cómo se mantiene

- **KVM:** Parte del kernel Linux; se actualiza con cada kernel.
- **Módulos:** Gestionados por kernel/modprobe.
- **Parámetros:** `/etc/modprobe.d/kvm*.conf`.
- **Logs:** `dmesg | grep kvm` para errores.

### 109.11 Cómo puede ampliarse

- **sVirt:** Security virtualización (SELinux/AppArmor + svirt) para aislar VMs.
- **Vhost:** Aceleración de red virtio en el kernel (vhost-net, vhost-scsi).
- **IOMMU groups:** Scripts para gestionar passthrough de dispositivos PCI.
- **KVM for ARM:** Soporte para ARM64 si la distribución lo requiere.

---

## 110. QEMU

### 110.1 ¿Para qué existe?

QEMU es el emulador de hardware que, combinado con KVM, proporciona la capa de virtualización completa en LNOS. QEMU por sí solo puede emular CPUs completas (lento); con KVM, acelera las VMs ejecutando el código invitado directamente en la CPU real.

**¿Por qué QEMU?** Es el emulador más completo y flexible del ecosistema open source. Soporta una cantidad masiva de hardware emulado (CPU, chipsets, dispositivos), permitiendo virtualizar cualquier sistema operativo.

### 110.2 QEMU modes

```
QEMU LNOS
├── Full system emulation (qemu-system-x86_64)
│   └── Emula un PC completo: CPU, RAM, discos, red, GPU
│       └── Con KVM: aceleración casi nativa
├── User mode emulation (qemu-x86_64)
│   └── Ejecuta binarios de una arquitectura en otra
│       └── Ej: ejecutar binarios ARM en x86_64
└── QEMU monitor (consola de control)
    └── Control en tiempo real: dispositivos, snapshots, migración
```

### 110.3 Dispositivos virtio

LNOS configura QEMU con dispositivos virtio para máximo rendimiento:

```
Dispositivos virtio por defecto:
├── virtio-blk (disco)
│   └── Controlador paravirtualizado: ~5000 MB/s
├── virtio-net (red)
│   └── Controlador paravirtualizado: ~40 Gbps
├── virtio-vga / virtio-gpu (GPU)
│   └── Aceleración 3D básica, 2 pantallas
├── virtio-serial (serial)
│   └── Comunicación huésped-invitado
├── virtio-balloon (memoria)
│   └── Gestión dinámica de memoria
└── virtio-rng (entropía)
    └── Mejora la generación de números aleatorios en el invitado
```

**Rendimiento comparativo (disco):**

```
Dispositivo:        virtio-blk    | virtio-scsi    | IDE emulado
Rendimiento seq:    5000 MB/s     | 4500 MB/s      | 100 MB/s
Rendimiento rand:   350,000 IOPS  | 300,000 IOPS   | 5,000 IOPS
Latencia:           50 μs         | 60 μs          | 5 ms
```

### 110.4 QEMU monitor

El monitor QEMU permite controlar la VM en tiempo real:

```
# Acceder al monitor desde virsh
virsh qemu-monitor-command vm-name --hmp "info block"

# Comandos útiles del monitor:
info block           → Estado de discos
info network         → Estado de red
info snapshots       → Lista de snapshots
savevm <name>        → Crear snapshot
loadvm <name>        → Restaurar snapshot
migrate tcp:host:port → Migrar en caliente
system_powerdown     → Apagado ACPI
system_reset         → Reset
```

### 110.5 QEMU user mode

QEMU user mode permite ejecutar binarios de otras arquitecturas:

```bash
# Ejecutar binario ARM64 en x86_64
qemu-aarch64-static ./programa_arm64

# Ejecutar binario Raspberry Pi
qemu-arm-static ./programa_arm

# Usar con chroot (para emular sistemas completos)
sudo qemu-user-static -execve
sudo chroot /rpi-rootfs /bin/bash
```

**Aplicaciones en LNOS:**
- Compilación cruzada (ver capítulo 112)
- Ejecución de contenedores multi-arquitectura
- Pruebas de software para ARM sin hardware ARM

### 110.6 Snapshots de VM

QEMU soporta snapshots a dos niveles:

**Snapshots de disco (qcow2):**

```bash
# Crear snapshot interno (en el mismo qcow2)
virsh snapshot-create-as vm-name snapshot1

# Crear snapshot externo (nuevo qcow2)
virsh snapshot-create-as vm-name snapshot2 --disk-only

# Listar snapshots
virsh snapshot-list vm-name

# Restaurar
virsh snapshot-revert vm-name snapshot1
```

**Snapshots a nivel de sistema de archivos (Btrfs + QEMU):**

```bash
# Pausar VM
virsh suspend vm-name

# Snapshot Btrfs del archivo qcow2
btrfs subvolume snapshot /var/lib/libvirt/images/vm.qcow2 /var/lib/libvirt/images/vm-backup.qcow2

# Reanudar VM
virsh resume vm-name
```

### 110.7 Cómo se comunica con el resto del sistema

```
QEMU
    │
    ├──→ KVM (aceleración)
    ├──→ libvirtd (gestión de VMs)
    ├──→ kernel (dispositivos vhost, VFIO)
    ├──→ Btrfs (imágenes qcow2)
    ├──→ SPICE/VNC (consola gráfica)
    ├──→ systemd (gestión de procesos)
    └──→ AppArmor (perfiles de seguridad)
```

### 110.8 Dependencias

| Dependencia | Tipo | Razón |
|------------|------|-------|
| `qemu-desktop` | Paquete | QEMU con soporte gráfico |

| `qemu-desktop` | Paquete | QEMU con soporte gráfico |
| `qemu-block-iscsi` | Opcional | Soporte iSCSI |
| `qemu-block-rbd` | Opcional | Soporte Ceph/RBD |
| `qemu-audio-pa` | Paquete | Audio PulseAudio para VMs |
| `qemu-hw-usb-redirect` | Opcional | Redirección USB |

### 110.9 Problemas potenciales y mitigaciones

| Problema | Mitigación |
|----------|-----------|
| QEMU no encuentra KVM | Usar `qemu-system-x86_64 -accel kvm` debe funcionar; verificar /dev/kvm |
| VM sin audio | PipeWire + `qemu-audio-pa`; configurar audio como PulseAudio |
| Snapshot qcow2 lento | No hacer snapshots con VM en ejecución; pausar VM primero |
| QEMU user mode no ejecuta binario | Verificar binfmt_misc configurado |
| Monitor QEMU no responde | Conectar via virsh: `virsh qemu-monitor-command vm-name --hmp "info status"` |

### 110.10 Cómo se prueba

| Test | Procedimiento |
|------|--------------|
| QEMU funcionando | `qemu-system-x86_64 -machine help` debe listar máquinas |
| KVM acelerando | `qemu-system-x86_64 -accel kvm -M pc -m 1024 -cdrom /dev/null` |
| Dispositivos virtio | `virsh edit vm-name` verificar bus=virtio |
| Snapshot | Crear snapshot; verificar `qcow2` con `qemu-img info` |
| Monitor | `virsh qemu-monitor-command vm-name --hmp "info kvm"` debe mostrar "kvm support: enabled" |

### 110.11 Cómo se mantiene

- **QEMU:** Actualizaciones via pacman. Configuración via libvirt.
- **Imágenes:** `qemu-img check` para verificar integridad.
- **Snapshots:** Gestionados por virsh o el monitor.
- **Logs:** `journalctl -u libvirtd` para errores de QEMU.

### 110.12 Cómo puede ampliarse

- **QEMU + GDB:** Depurar el kernel de la VM con GDB conectado a QEMU (`-s -S`).
- **VFIO passthrough:** Pasar GPU, NVMe, USB completos a la VM.
- **QEMU NUMA:** Simular topología NUMA para pruebas de rendimiento.
- **QEMU sandboxing:** QEMU se ejecuta con `-sandbox on` para aislar del host.
- **Migración en caliente:** Migrar VMs entre hosts sin interrupción.

---

## 111. Desarrollo

### 111.1 ¿Para qué existe?

El módulo `lnos-dev` convierte LNOS en una estación de desarrollo completa. Proporciona toolchains, IDEs, contenedores y herramientas para los lenguajes y frameworks más utilizados.

**Filosofía:** El desarrollador no debería pasar horas configurando su entorno. Con un solo comando (`lnos-mod install lnos-dev`), obtiene un entorno de desarrollo completo y reproducible.

### 111.2 Componentes del módulo lnos-dev

| Componente | Incluido | Opcional | Propósito |
|-----------|----------|----------|-----------|
| **Toolchains** | gcc, clang, rust, go, python, node, jvm | — | Compilación |
| **Git** | git, git-lfs, git-delta | — | Control de versiones |
| **Contenedores** | Docker o Podman | Ambos | Entornos aislados |
| **IDEs** | VS Code (VSCodium) | JetBrains, Neovim, Zed | Edición |
| **Shell** | zsh + oh-my-zsh + plugins | fish, nushell | Terminal |
| **Utilidades** | ripgrep, fd, bat, eza, fzf, jq, yq | — | Productividad |
| **Documentación** | devhelp, zeal | — | Consulta |
| **Testing** | pytest, cargo test, go test | — | Automatización |

### 111.3 Entornos de desarrollo reproducibles

LNOS recomienda **entornos de desarrollo reproducibles** para evitar el clásico "en mi máquina funciona":

| Herramienta | Descripción | LNOS recomienda |
|------------|-----------|----------------|
| **Devbox** | Entornos basados en Nix | Sí, para proyectos | 
| **Nix** | Gestor de paquetes puro funcional | Sí, opcional |
| **devenv** | Entornos Nix simplificados | Sí, opcional |
| **Docker/Podman** | Contenedores para desarrollo | Sí |
| **asdf/mise** | Gestores de versiones de lenguajes | Sí (mise moderno) |
| **pyenv, nvm, rbenv** | Gestores específicos | Alternativa a mise |

**Configuración por defecto: Devbox + mise:**

```bash
# mise (gestor de versiones de runtime)
mise use python@3.12
mise use node@22
mise use go@1.22

# devbox (entorno reproducible)
devbox init
devbox add python@3.12 node@22
devbox shell  # Entorno con las herramientas configuradas
```

### 111.4 Git y control de versiones

Configuración por defecto de Git en LNOS:

```ini
# ~/.config/git/config
[user]
    name = (se configura en lnos-welcome)
    email = (se configura en lnos-welcome)

[core]
    editor = nvim
    autocrlf = input
    safecrlf = warn
    
[init]
    defaultBranch = main

[push]
    autoSetupRemote = true
    default = current

[merge]
    conflictstyle = zdiff3

[diff]
    tool = delta
    colorMoved = default

[delta]
    navigate = true
    side-by-side = true

[alias]
    lg = log --oneline --graph --all
    s = status -sb
    undo = reset --soft HEAD~1
```

### 111.5 Integración con módulos de lenguaje

Cada lenguaje tiene su propio submódulo:

| Módulo | Contenido |
|--------|-----------|
| `lnos-dev-python` | Python 3.12+, pip, poetry, ruff, mypy, pytest |
| `lnos-dev-node` | Node.js 22+, npm, yarn, pnpm, typescript |
| `lnos-dev-rust` | Rust, cargo, rustup, clippy, rust-analyzer |
| `lnos-dev-go` | Go 1.22+, golangci-lint, delve debugger |
| `lnos-dev-java` | JDK 21 (OpenJDK), maven, gradle |
| `lnos-dev-lua` | Lua 5.4, luarocks, lua-language-server |
| `lnos-dev-php` | PHP 8.3+, composer, php-cs-fixer |
| `lnos-dev-haskell` | GHC, cabal, stack, haskell-language-server |

### 111.6 Cómo se comunica con el resto del sistema

```
lnos-dev
    │
    ├──→ Toolchains (gcc, clang, rust, etc.) → /usr/bin/
    ├──→ IDEs (VSCodium, Neovim) → aplicaciones de escritorio
    ├──→ Contenedores (Docker/Podman) → ver capítulos 106-107
    ├──→ mise (gestor de versiones) → ~/.local/share/mise/
    ├──→ Git → ~/.config/git/
    ├──→ lnos-dev-* (módulos de lenguaje) → toolchains específicas
    └──→ lnos-config (Centro de Configuración → Desarrollo)
```

### 111.7 Dependencias

| Dependencia | Tipo | Razón |
|------------|------|-------|
| `base-devel` | Paquete | Herramientas de compilación base |
| `git` | Paquete | Control de versiones |
| `mise` | Paquete | Gestor de versiones de runtime |
| `devbox` | Opcional | Entornos reproducibles |
| `docker` o `podman` | Opcional | Contenedores |

### 111.8 Problemas potenciales y mitigaciones

| Problema | Mitigación |
|----------|-----------|
| Toolchain conflictiva con paquetes del sistema | mise gestiona versiones en espacio de usuario |
| npm install falla por permisos | Usar `npm config set prefix ~/.npm-global` |
| Rust nightly rompe algo | `rustup toolchain add stable` como fallback |
| Contenedor de desarrollo sin GPU | `--device /dev/dri` para aceleración gráfica |

### 111.9 Cómo se prueba

| Test | Procedimiento |
|------|--------------|
| gcc | `gcc --version` |
| rust | `rustc --version` |
| node | `node --version` |
| git | `git init test && cd test && git commit --allow-empty -m "test"` |
| mise | `mise ls` |

### 111.10 Cómo se mantiene

- **Toolchains:** Actualizaciones via pacman. Los módulos de lenguaje se actualizan independientemente.
- **mise:** Se actualiza via pacman; las versiones de runtime las gestiona el usuario.
- **Git:** Configuración global gestionada por lnos-config.

### 111.11 Cómo puede ampliarse

- **Módulos de lenguaje comunitarios:** Cualquier lenguaje puede tener su módulo LNOS.
- **Plantillas de proyecto:** `lnos-sdk new project --type python` etc.
- **Entornos CI/CD locales:** Integración con GitLab Runner o Jenkins en contenedores.

---

## 112. Toolchains

### 112.1 ¿Para qué existe?

LNOS proporciona toolchains completas para los lenguajes de programación más utilizados. Una toolchain incluye compilador, linker, depurador, linter y herramientas auxiliares.

**Filosofía:** Múltiples toolchains coexistiendo sin conflicto. El desarrollador elige la que necesita.

### 112.2 Toolchains incluidas

| Lenguaje | Compilador | Linker | Depurador | Linter/Formatter | Build system |
|----------|-----------|--------|-----------|-----------------|-------------|
| **C/C++** | GCC 14, Clang 18 | mold (por defecto), ld.lld | GDB, LLDB | clang-tidy, clang-format | CMake, Meson |
| **Rust** | rustc 1.78+ | rust-lld | lldb, rust-gdb | clippy, rustfmt | Cargo |
| **Go** | go 1.22+ | go link | delve (dlv) | golangci-lint | go build |
| **Python** | CPython 3.12 | — | pdb, debugpy | ruff, mypy | poetry, pip |
| **JavaScript/TS** | Node 22, bun | — | node inspect | eslint, prettier | npm, pnpm, yarn |
| **Java** | OpenJDK 21 | — | jdb | checkstyle, pmd | maven, gradle |
| **.NET** | dotnet 8 | — | dotnet debug | dotnet format | dotnet CLI |

### 112.3 mold (linker rápido)

LNOS configura **mold** como linker por defecto para C/C++ y Rust:

```bash
# mold es hasta 5x más rápido que GNU ld
# Instalación: lnos-dev lo incluye
# Configuración en CMake:
#   set(CMAKE_LINKER_TYPE MOLD)
# Configuración en Cargo:
#   # .cargo/config.toml
#   [target.x86_64-unknown-linux-gnu]
#   linker = "clang"
#   rustflags = ["-C", "link-arg=-fuse-ld=mold"]

# Verificar velocidad
hyperfine 'ld.lld hello.o' 'mold hello.o'
```

**Rendimiento comparativo (linker):**

| Linker | Hello World | LLVM (proyecto grande) | Ratio |
|--------|------------|----------------------|-------|
| GNU ld | 0.2s | 45s | 1x |
| gold | 0.1s | 30s | 1.5x |
| lld | 0.05s | 12s | 3.75x |
| **mold** | **0.02s** | **8s** | **5.6x** |

### 112.4 Compilación cruzada

LNOS proporciona toolchains de compilación cruzada para los destinos más comunes:

```
# Destinos soportados:
aarch64-linux-gnu     → ARM64 (Raspberry Pi, servidores ARM)
arm-linux-gnueabihf   → ARM32 (IoT, embedded)
x86_64-w64-mingw32    → Windows (mingw)
x86_64-linux-gnu      → Linux (nativa)

# Instalación de toolchain cruzada
pacman -S aarch64-linux-gnu-gcc aarch64-linux-gnu-binutils

# Ejemplo: compilar para ARM64
aarch64-linux-gnu-gcc -o hello-arm64 hello.c

# Verificar
file hello-arm64
# hello-arm64: ELF 64-bit LSB executable, ARM aarch64
```

**Cross compilación con Rust:**

```bash
rustup target add aarch64-unknown-linux-gnu
cargo build --target aarch64-unknown-linux-gnu
```

### 112.5 ccache y sccache

LNOS configura ccache (y opcionalmente sccache para Rust) para acelerar compilaciones repetidas:

```
# ccache para C/C++ (ya incluido en base-devel)
export CCACHE_DIR=~/.cache/ccache
export CC="ccache gcc"
export CXX="ccache g++"

# sccache para Rust
# ~/.cargo/config.toml
[build]
rustc-wrapper = "sccache"

# Verificar estadísticas
ccache -s
sccache --show-stats
```

### 112.6 Optimizaciones

LNOS configura optimizaciones por defecto para paquetes compilados localmente:

```bash
# /etc/makepkg.conf (optimizado para CPU del desarrollador)
CFLAGS="-march=native -O3 -pipe -fno-plt"
CXXFLAGS="$CFLAGS"
RUSTFLAGS="-C target-cpu=native -C opt-level=3"
MAKEFLAGS="-j$(nproc)"
```

**Advertencia:** `-march=native` optimiza para la CPU actual. Los binarios pueden no ejecutarse en CPUs más antiguas.

### 112.7 Cómo se comunica con el resto del sistema

```
Toolchains LNOS
    │
    ├──→ /usr/bin/ (compiladores, linkers, herramientas)
    ├──→ /usr/lib/ (librerías de runtime)
    ├──→ ccache/sccache (cache de compilación)
    ├──→ mold (linker rápido)
    ├──→ lnos-dev (módulo que agrupa toolchains)
    └──→ lnos-dev-* (módulos específicos por lenguaje)
```

### 112.8 Dependencias

| Dependencia | Tipo | Razón |
|------------|------|-------|
| `gcc` | Paquete | GNU Compiler Collection |
| `clang` | Paquete | LLVM Clang compiler |
| `mold` | Paquete | Linker rápido |
| `ccache` | Paquete | Cache de compilación |
| `rust` | Paquete | Rust toolchain |
| `go` | Paquete | Go toolchain |
| `cmake` | Paquete | Build system |

### 112.9 Problemas potenciales y mitigaciones

| Problema | Mitigación |
|----------|-----------|
| mold no compatible con algún proyecto | Configurar `-fuse-ld=gold` o `-fuse-ld=lld` como fallback |
| -march=native en CPU diferente | Usar `-march=x86-64-v3` para compatibilidad amplia |
| Compilación cruzada lenta | Usar `distcc` para distribución en red |
| ccache llena el disco | `ccache -c` para limpiar; límite `max_size = 5G` en ccache.conf |

### 112.10 Cómo se prueba

| Test | Procedimiento |
|------|--------------|
| GCC | `echo "int main(){return 0;}" \| gcc -x c -o /tmp/test - && /tmp/test` |
| Clang | `echo "int main(){return 0;}" \| clang -x c -o /tmp/test - && /tmp/test` |
| Rust | `cargo new --bin /tmp/test && cd /tmp/test && cargo build` |
| mold | `gcc -fuse-ld=mold -o /tmp/test hello.c` |
| Cross | file de binario compilado con toolchain cruzada |

### 112.11 Cómo se mantiene

- **Toolchains:** Actualizaciones via pacman (mantenidas por Arch Linux).
- **Optimizaciones:** Revisadas en cada actualización mayor de GCC/Clang.
- **Cross toolchains:** Mantenidas por Arch Linux ARM.

### 112.12 Cómo puede ampliarse

- **Toolchains para Zig:** Zig como compilador de C/C++ (alternativa a GCC/Clang).
- **Toolchain para WASM:** `wasm-pack`, `emscripten` para WebAssembly.
- **Toolchain para GPU:** CUDA (NVIDIA), ROCm (AMD), OpenCL.
- **GCC plugins:** Plugins de análisis estático para GCC.

---

## 113. IDEs

### 113.1 ¿Para qué existe?

LNOS proporciona soporte para múltiples entornos de desarrollo integrados (IDEs), cubriendo desde editores ligeros hasta IDEs completos.

**Filosofía:** No imponer un IDE. Ofrecer varios con configuración predefinida óptima para LNOS.

### 113.2 VS Code (VSCodium)

**VSCodium** es la build 100% open source de VS Code (sin telemetría de Microsoft). Es el IDE recomendado por defecto en LNOS.

**Configuración predefinida de LNOS:**

```json
{
  "editor.fontFamily": "'JetBrains Mono', 'Fira Code', monospace",
  "editor.fontSize": 14,
  "editor.fontLigatures": true,
  "editor.minimap.enabled": false,
  "editor.bracketPairColorization.enabled": true,
  "editor.guides.bracketPairs": true,
  "workbench.colorTheme": "LNOS Dark",
  "workbench.iconTheme": "material-icon-theme",
  "terminal.integrated.defaultProfile.linux": "zsh",
  "terminal.integrated.fontFamily": "'JetBrains Mono', monospace",
  "files.autoSave": "afterDelay",
  "git.enableSmartCommit": true,
  "git.confirmSync": false,
  "extensions.autoUpdate": true,
  "telemetry.enableCrashReporter": false,
  "telemetry.enableTelemetry": false
}
```

**Extensiones preinstaladas:**

| Extensión | Propósito |
|-----------|-----------|
| **LNOS Extension Pack** | Pack oficial con todas las extensiones abajo |
| **rust-analyzer** | Soporte Rust |
| **Python** | Soporte Python (Pylance) |
| **Go** | Soporte Go |
| **GitLens** | Git avanzado |
| **Material Icon Theme** | Iconos |
| **GitHub Copilot** | Asistente AI (opt-in) |
| **Error Lens** | Errores inline |
| **Prettier** | Formateador |
| **ESLint** | Linter JavaScript |

### 113.3 JetBrains Toolbox

Para usuarios que prefieren IDEs completos, LNOS proporciona JetBrains Toolbox:

```bash
# Instalación
lnos-mod install lnos-jetbrains

# Toolbox instala y gestiona:
# - IntelliJ IDEA (Java, Kotlin)
# - PyCharm (Python)
# - GoLand (Go)
# - CLion (C/C++)
# - WebStorm (JavaScript/TypeScript)
# - RustRover (Rust)
```

**Integración con Hyprland:** Atajos de teclado para lanzar cada IDE.

### 113.4 Neovim (LazyVim)

Para desarrolladores avanzados, LNOS ofrece Neovim con LazyVim:

```
Neovim LNOS
├── LazyVim (distribución de Neovim)
├── LunarVim o AstroNvim (alternativas)
├── lazygit (git integrado)
├── LSP: rust-analyzer, pyright, gopls, typescript-language-server
├── Telescope (búsqueda fuzzy)
├── Which-key (ayuda de atajos)
├── cmp (autocompletado)
└── Treesitter (resaltado sintáctico avanzado)
```

**Instalación:**

```bash
lnos-mod install lnos-neovim
# Configuración predefinida en ~/.config/nvim/
```

### 113.5 Zed

Zed es un editor moderno escrito en Rust con GTK4, nativo para Wayland:

```
Características de Zed:
- Rendimiento: arranque en <100ms
- Nativo Wayland (sin Electron)
- Editor colaborativo en tiempo real
- LSP integrado
- Terminal integrada
- Vim mode
```

LNOS incluye Zed como alternativa ligera a VS Code:

```bash
lnos-mod install lnos-zed
```

### 113.6 Cómo se comunica con el resto del sistema

```
IDEs LNOS
    │
    ├──→ Toolchains (gcc, rust, go, etc.)
    ├──→ Git (control de versiones)
    ├──→ LSP servers (rust-analyzer, pyright, etc.)
    ├──→ D-Bus (integración con escritorio)
    ├──→ Hyprland (atajos de teclado, ventanas)
    └──→ lnos-config (Centro de Configuración → Desarrollo → IDEs)
```

### 113.7 Dependencias

| Dependencia | Tipo | Razón |
|------------|------|-------|
| `vscodium` | Paquete | IDE por defecto |
| `jetbrains-toolbox` | Opcional | IDEs JetBrains |
| `neovim` | Opcional | Editor avanzado |
| `zed-editor` | Opcional | Editor moderno |
| `lnos-dev` | Paquete | Toolchains necesarias |

### 113.8 Problemas potenciales y mitigaciones

| Problema | Mitigación |
|----------|-----------|
| VSCodium no tiene某些 extensiones | VS Code Marketplace no accesible; usar Open VSX Registry |
| JetBrains consume mucha RAM | Configurar `-Xmx` en vmoptions |
| Neovim sin plugins | Ejecutar `:Lazy sync` al iniciar |
| Zed no tiene ciertos LSP | Instalar LSP manualmente |

### 113.9 Cómo se prueba

| Test | Procedimiento |
|------|--------------|
| VSCodium | `codium --version`; abrir y crear archivo |
| Neovim | `nvim +checkhealth` |
| JetBrains | `jetbrains-toolbox` e instalar IDE |
| Zed | `zed --version` |
| LSP | Abrir proyecto Rust; verificar rust-analyzer activo |

### 113.10 Cómo se mantiene

- **VSCodium:** Actualizaciones via pacman. Extensiones se actualizan automáticamente.
- **Neovim:** `:Lazy sync` para actualizar plugins.
- **JetBrains:** Toolbox gestiona actualizaciones.
- **Configuraciones:** En `/etc/lnos/ides/` (sobrescribible por usuario).

### 113.11 Cómo puede ampliarse

- **Extension Pack LNOS:** Pack de extensiones para VSCodium mantenido oficialmente.
- **Configuraciones por proyecto:** `lnos-sdk` genera configuraciones específicas por tipo de proyecto.
- **Dev Containers:** VS Code Dev Containers para entornos de desarrollo completos.

---

## 114. SDK

### 114.1 ¿Para qué existe?

El SDK de LNOS (`lnos-sdk`) es el kit de desarrollo para crear módulos y plugins LNOS. Proporciona herramientas CLI, plantillas, y utilidades para facilitar el desarrollo de módulos de la distribución.

**Filosofía:** Cualquier desarrollador debe poder crear un módulo LNOS en minutos, no en horas.

### 114.2 Componentes del SDK

```
lnos-sdk
├── CLI (lnos-sdk)
│   ├── new (generar proyecto)
│   ├── build (compilar módulo)
│   ├── test (ejecutar tests)
│   ├── lint (verificar estilo/código)
│   ├── package (empaquetar)
│   ├── publish (publicar en repositorio)
│   └── validate (validar module.toml)
├── Plantillas
│   ├── module-python/    # Módulo en Python
│   ├── module-rust/      # Módulo en Rust
│   ├── module-bash/      # Módulo en Bash
│   ├── plugin-software/  # Plugin para Centro Software
│   └── plugin-config/    # Plugin para Centro Configuración
├── Testing
│   ├── test framework
│   ├── mock system
│   └── integration helpers
└── Documentación
    ├── API reference
    ├── module.toml schema
    └── examples/
```

### 114.3 lnos-sdk CLI

```bash
# Crear nuevo módulo
lnos-sdk new module --name lnos-my-extension --lang rust
# Crea: ./lnos-my-extension/
#   ├── module.toml
#   ├── src/
#   │   └── main.rs
#   ├── hooks/
#   │   ├── pre-install
#   │   ├── post-install
#   │   └── configure
#   └── tests/
#       └── test_module.py

# Crear nuevo plugin
lnos-sdk new plugin --name my-config-plugin --target lnos-config
# Crea plugin para el Centro de Configuración

# Compilar módulo
cd lnos-my-extension
lnos-sdk build
# Valida module.toml, compila código, verifica estructura

# Testear módulo
lnos-sdk test
# Ejecuta tests en sandbox

# Validar module.toml
lnos-sdk validate module.toml
# Valida esquema, dependencias, conflictos

# Empaquetar
lnos-sdk package
# Crea: lnos-my-extension-1.0.0.tar.gz

# Publicar (requiere autenticación)
lnos-sdk publish --repo community
# Publica en repositorio de comunidad
```

### 114.4 Generación de proyectos

```
lnos-sdk new module --name lnos-web-server
```

**Estructura generada:**

```
lnos-web-server/
├── module.toml
├── README.md
├── LICENSE
├── CHANGELOG.md
├── hooks/
│   ├── pre-install
│   ├── post-install
│   ├── pre-remove
│   ├── post-remove
│   ├── configure
│   └── status
├── files/
│   └── etc/
│       └── lnos/
│           └── modules/
│               └── lnos-web-server/
│                   └── config.toml
├── templates/
│   └── nginx.conf.j2
├── locale/
│   ├── es/
│   │   └── LC_MESSAGES/
│   │       └── lnos-module-web-server.po
│   └── lnos-module-web-server.pot
├── tests/
│   ├── test_install.py
│   ├── test_config.py
│   └── test_integration.py
├── docs/
│   └── index.md
└── .gitignore
```

### 114.5 Testing de módulos

El SDK proporciona un framework de testing que simula el entorno LNOS:

```python
# tests/test_install.py
from lnos_sdk.testing import LnosModuleTest

class TestWebServer(LnosModuleTest):
    def setup_method(self):
        self.module = self.load_module("lnos-web-server")
    
    def test_install(self):
        result = self.module.install()
        assert result.success
        assert self.service_running("nginx")
    
    def test_config(self):
        self.module.configure({"port": 8080})
        config = self.read_file("/etc/lnos/modules/lnos-web-server/config.toml")
        assert "port = 8080" in config
    
    def test_uninstall(self):
        self.module.install()
        result = self.module.remove()
        assert result.success
        assert not self.service_exists("nginx")
```

### 114.6 Empaquetado y publicación

**Empaquetado:**

```bash
lnos-sdk package
# Crea: lnos-web-server-1.0.0.tar.gz
# Incluye: módulo completo + checksums + firma GPG

# Verificar paquete
lnos-sdk package --verify lnos-web-server-1.0.0.tar.gz
```

**Publicación en repositorio oficial (requiere revisión):**

```bash
lnos-sdk publish --repo official
# 1. Valida módulo
# 2. Firma con GPG
# 3. Envía a repositorio oficial
# 4. Crea PR en github.com/lnos/modules
# 5. CI ejecuta tests
# 6. Revisión por mantenedores
# 7. Publicado en modules.lnos.dev
```

**Publicación en repositorio de comunidad (automática):**

```bash
lnos-sdk publish --repo community
# Publicación inmediata sin revisión
# Marcado como "community" en el índice
```

### 114.7 Cómo se comunica con el resto del sistema

```
lnos-sdk
    │
    ├──→ lnos-mod (API de módulos)
    ├──→ lnos-api (API REST para testing)
    ├──→ Git (gestión de proyectos)
    ├──→ Toolchains (compilación)
    ├──→ systemd-nspawn (sandbox de testing)
    ├──→ modules.lnos.dev (publicación)
    └──→ /usr/share/lnos/sdk/ (plantillas y librerías)
```

### 114.8 Dependencias

| Dependencia | Tipo | Razón |
|------------|------|-------|
| `lnos-mod` | Paquete | API de módulos |
| `python` | Paquete | Runtime del SDK |
| `git` | Paquete | Gestión de proyectos |
| `gpg` | Paquete | Firmado de paquetes |
| `systemd` | Paquete | Sandbox de testing |
| `cargo`/`gcc` | Opcional | Compilación según lenguaje |

### 114.9 Problemas potenciales y mitigaciones

| Problema | Mitigación |
|----------|-----------|
| SDK no soporta mi lenguaje | SDK es extensible; añadir plantilla para nuevo lenguaje |
| Test falla por entorno real faltante | Usar sandbox que simula LNOS completo |
| Publicación sin firma GPG | Generar clave GPG con `lnos-sdk setup-gpg` |
| Módulo rechazado en revisión | Seguir guía de estilo; ejecutar `lnos-sdk lint` |

### 114.10 Cómo se prueba

| Test | Procedimiento |
|------|--------------|
| SDK instalado | `lnos-sdk --version` |
| Generar módulo | `lnos-sdk new module --name test-module` |
| Validar | `lnos-sdk validate module.toml` |
| Build | `lnos-sdk build` |
| Test | `lnos-sdk test` |

### 114.11 Cómo se mantiene

- **SDK:** Código en `src/lnos-sdk/` del monorepo.
- **Plantillas:** En `src/lnos-sdk/templates/`.
- **Documentación:** `docs/SDK.md` y `docs/MODULE-CREATION.md`.
- **Versiones:** Sigue versionado semántico, independiente de LNOS.

### 114.12 Cómo puede ampliarse

- **SDK web:** Interfaz web para crear módulos sin instalar el SDK.
- **Mercado de plantillas:** Repositorio de plantillas comunitarias.
- **Generación automatizada:** `lnos-sdk new --from-existing-app` escanea app y genera módulo.
- **CI/CD integration:** `lnos-sdk ci` genera pipeline de CI para el módulo.

---

## 115. Herramientas para Desarrolladores

### 115.1 ¿Para qué existe?

LNOS incluye un conjunto de herramientas de línea de comandos modernas que mejoran la productividad del desarrollador. Son herramientas que reemplazan a las clásicas con mejores prestaciones, velocidad y experiencia de usuario.

**Filosofía:** El terminal es el centro de la productividad del desarrollador. Merece herramientas modernas.

### 115.2 Herramientas incluidas

| Herramienta | Reemplaza | Propósito | Por qué |
|------------|-----------|-----------|---------|
| **htop** / **btop** | top | Monitor de procesos | Mejor interfaz, colores, árbol de procesos |
| **jq** | — | Procesamiento JSON | Estándar para JSON en CLI |
| **yq** | — | Procesamiento YAML | Equivalente a jq para YAML |
| **ripgrep (rg)** | grep | Búsqueda en texto | 10x más rápido que grep |
| **fd** | find | Búsqueda de archivos | 5x más rápido, sintaxis intuitiva |
| **bat** | cat | Visualización de archivos | Syntax highlighting, paginación |
| **eza** | ls | Listado de archivos | Colores, iconos, permisos legibles |
| **zoxide** | cd | Navegación de directorios | Aprendizaje de rutas frecuentes |
| **fzf** | — | Búsqueda fuzzy general | Filtrado interactivo universal |
| **delta** | diff | Visualización de diferencias | Syntax highlighting, side-by-side |
| **lazygit** | git CLI | Git en TUI | Gestión visual de git |
| **mise** | asdf | Gestor de versiones runtimes | Más rápido, compatible asdf |
| **hyperfine** | time | Benchmarking de comandos | Estadísticas, warm-up, comparativas |

### 115.3 Comparativa de rendimiento

```
Ripgrep vs Grep (búsqueda en kernel Linux, ~20M archivos):
┌─────────────────────────────────────────────────────────┐
│  grep -r "void main"  █████████████████████████ 45.2s  │
│  rg "void main"       ████████ 4.8s                     │
└─────────────────────────────────────────────────────────┘

fd vs find (búsqueda de archivos Rust en /usr):
┌─────────────────────────────────────────────────────────┐
│  find -name "*.rs"   █████████████████████████ 12.5s   │
│  fd -e rs            █████ 2.1s                         │
└─────────────────────────────────────────────────────────┘

bat vs cat (archivo de 500 líneas):
┌─────────────────────────────────────────────────────────┐
│  cat file           ████████████████████████████ 0.8s  │
│  bat file           ████████████████████████████ 0.9s  │
│  (bat tiene resaltado, números de línea, paginación)   │
└─────────────────────────────────────────────────────────┘
```

### 115.4 Integración con shell

**~/.zshrc (gestionado por lnos-dev):**

```zsh
# alias modernos
alias ls='eza --icons --group-directories-first'
alias ll='eza -l --icons --group-directories-first'
alias la='eza -la --icons --group-directories-first'
alias lt='eza -T --icons'  # Tree view
alias cat='bat --paging=never'
alias grep='rg'
alias find='fd'
alias cd='z'  # zoxide
alias diff='delta'
alias top='btop'
alias du='duf'  # modern df/du
alias ps='procs'  # modern ps

# fzf integration
source <(fzf --zsh)
source <(zoxide init zsh)

# lazygit
alias lg='lazygit'

# mise
eval "$(mise activate zsh)"
```

### 115.5 lazygit

Lazygit es una interfaz TUI (Terminal User Interface) para Git que simplifica operaciones complejas:

```
lazygit
├── Panel 1: Status (cambios, staged, unstaged)
├── Panel 2: Branches (cambio rápido entre ramas)
├── Panel 3: Commits (log visual, rebase interactivo)
├── Panel 4: Stash (gestionar stash)
└── Atajos principales:
    espacio: Stage/Unstage archivo
    c: Commit
    p: Push
    P: Pull
    m: Merge
    r: Rebase
    d: Diff
    g: Git flow
```

### 115.6 Zoxide

Zoxide aprende qué directorios visitas y permite navegar con pocos caracteres:

```bash
# En lugar de:
cd /home/user/projects/lnos/src/lnos-mod

# Con zoxide:
z lnos-mod       # Si es el más frecuente
z mod            # Búsqueda fuzzy
z lnos src       # Múltiples términos
```

**Estadísticas de uso:** Zoxide mantiene un ranking de frecuencias en `~/.local/share/zoxide/db.zo`.

### 115.7 Cómo se comunica con el resto del sistema

```
Herramientas Dev
    │
    ├──→ Shell (zsh/fish) — integración via aliases y plugins
    ├──→ lnos-dev (módulo que las incluye)
    ├──→ lnos-config (Centro de Configuración → Shell)
    └──→ ~/.config/ (configuraciones individuales)
```

### 115.8 Dependencias

| Dependencia | Tipo | Razón |
|------------|------|-------|
| `eza` | Paquete | ls moderno |
| `bat` | Paquete | cat con syntax highlighting |
| `ripgrep` | Paquete | búsqueda rápida |
| `fd` | Paquete | find rápido |
| `fzf` | Paquete | búsqueda fuzzy |
| `jq` | Paquete | procesamiento JSON |
| `yq` | Paquete | procesamiento YAML |
| `zoxide` | Paquete | navegación inteligente |
| `delta` | Paquete | diff moderno |
| `lazygit` | Paquete | git en TUI |
| `btop` | Paquete | monitor de sistema |
| `hyperfine` | Paquete | benchmarking de comandos |

### 115.9 Problemas potenciales y mitigaciones

| Problema | Mitigación |
|----------|-----------|
| eza no disponible en algunos scripts | `export LS_OVERRIDE=false` para usar ls |
| bat interfiere con piping | `bat --paging=never` cuando se pipea |
| ripgrep diferente sintaxis que grep | Recordar usar `rg` en lugar de `grep` |
| fzf lento con directorios enormes | Limitar búsqueda con `FZF_DEFAULT_COMMAND='fd'` |

### 115.10 Cómo se prueba

| Test | Procedimiento |
|------|--------------|
| eza | `eza -la /usr` |
| bat | `bat /etc/os-release` |
| rg | `rg "Btrfs" SPEC_C81_120.md` |
| fd | `fd -e md` |
| fzf | `echo -e "a\nb\nc" \| fzf` |
| lazygit | `lazygit --version` |

### 115.11 Cómo se mantiene

- **Paquetes:** Actualizaciones via pacman (individuales).
- **Configuración:** Gestionada por lnos-config y dotfiles de usuario.
- **Aliases:** En `/etc/skel/.zshrc` para nuevos usuarios.

### 115.12 Cómo puede ampliarse

- **Herramientas adicionales:** `procs` (ps moderno), `duf` (df moderno), `dog` (dig moderno).
- **Plugins de shell:** `zsh-autosuggestions`, `zsh-syntax-highlighting`, `you-should-use`.
- **Dotfiles manager:** `chezmoi` o `yadm` para gestionar dotfiles.

---

## 116. Monitorización

### 116.1 ¿Para qué existe?

LNOS proporciona herramientas de monitorización para que el usuario pueda entender el estado de su sistema: uso de CPU, RAM, disco, red, temperaturas y salud de componentes.

**Filosofía:** Monitorización en tiempo real, minimalista por defecto, ampliable para servidores.

### 116.2 Herramientas incluidas

| Herramienta | Tipo | Propósito |
|------------|------|-----------|
| **btop++** | TUI | Monitor gráfico en terminal (CPU, RAM, disco, red, procesos) |
| **Netdata** | Web | Monitorización en tiempo real con dashboard web |
| **lm-sensors** | CLI | Temperaturas, voltajes, ventiladores |
| **smartmontools** | CLI | Salud de discos (SMART) |
| **vnstat** | CLI/Daemon | Monitorización de tráfico de red |
| **nethogs** | CLI | Tráfico de red por proceso |
| **iotop** | CLI | I/O de disco por proceso |
| **powertop** | CLI | Consumo de energía por componente |

### 116.3 btop++

**btop++** es el monitor gráfico por defecto de LNOS. Muestra en tiempo real:

```
┌─────────────────────────────────────────────────────────┐
│  btop++ — LNOS Workstation                              │
├──────────┬──────────┬──────────┬────────────────────────┤
│ CPU [### │ RAM [## │ DISK [# │ NET [##               │
│    ] 45% │   ] 65% │   ] 32% │    ] ↑2MB ↓1MB        │
│          │          │          │                        │
│ ████████ │ ████████ │ ████████ │ ████████               │
│ ████████ │ ████████ │ ██░░░░░░ │ ████████               │
│ ████████ │ ████████ │          │ ██░░░░░░               │
│ 3.5GHz   │ 16GB/32  │ 256/512  │ eth0: 1.2 Gbps         │
├──────────┴──────────┴──────────┴────────────────────────┤
│  Procesos: 342  │  Carga: 2.1 1.8 1.5  │  Uptime: 3d   │
│  Temp CPU: 52°C │  Temp GPU: 48°C      │  Fan: 2100 RPM │
└─────────────────────────────────────────────────────────┘
```

### 116.4 Netdata

Netdata está disponible como opción (no instalado por defecto por consumo de recursos):

```bash
# Instalación
lnos-mod install lnos-netdata

# Dashboard web: http://localhost:19999

# Consumo típico: ~1% CPU, ~50 MB RAM
# Monitoriza: 2000+ métricas, 200+ aplicaciones
```

**Integración con LNOS:**

```
Netdata → lnos-config → Sección Monitorización
├── Estado actual (widget en dashboard)
├── Alertas configurables
├── Histórico (1 hora, 6 horas, 1 día, 1 semana)
└── Enlace a dashboard completo (http://localhost:19999)
```

### 116.5 Prometheus + node_exporter (opcional)

Para usuarios avanzados que necesitan monitorización tipo servidor:

```bash
lnos-mod install lnos-prometheus
# Incluye: prometheus, node_exporter, alertmanager
# Dashboard: localhost:9090
# Métricas de node: localhost:9100/metrics
```

### 116.6 Grafana (opcional)

```bash
lnos-mod install lnos-grafana
# Dashboard: localhost:3000
# Datasources preconfigurados: Prometheus, Netdata
# Paneles: CPU, RAM, disco, red, temperatura, SMART
```

### 116.7 Monitoreo de temperatura

```bash
# Configurar sensores (primera vez)
sensors-detect --auto

# Ver temperaturas
sensors -j
{
  "coretemp-isa-0000": {
    "Package id 0": {"temp1_input": 52.0},
    "Core 0": {"temp2_input": 50.0},
    "Core 1": {"temp3_input": 48.0}
  }
}

# En btop++ y waybar: integración directa
# Waybar muestra temperatura en la barra
```

### 116.8 SMART (disk health)

```bash
# Verificar salud de todos los discos
smartctl --scan
# /dev/sda -d scsi # Samsung SSD 970 EVO 1TB
# /dev/nvme0 -d nvme # Samsung SSD 980 PRO 2TB

# Ver salud
smartctl -H /dev/nvme0
# SMART overall-health: PASSED

# Atributos detallados
smartctl -A /dev/nvme0
# Temperature: 42°C
# Percentage Used: 3%
# Data Units Written: 15 TB
```

### 116.9 Monitoreo de red

```bash
# vnstat (tráfico acumulado)
vnstat -i wlp2s0
#  wlp2s0  /  monthly
#    Jul '26     45.2 GiB  │  ████████████████  78%
#    Jun '26     58.1 GiB  │  ████████████████████  100%

# vnstat (tráfico en tiempo real)
vnstat -i wlp2s0 -l

# nethogs (tráfico por proceso)
sudo nethogs
#  PID   PROGRAM              SENT      RECEIVED
#  2456  firefox              1.2 MB/s  3.5 MB/s
#  1876  steam                0.5 MB/s  2.1 MB/s
#  1234  dropbox              0.1 MB/s  0.2 MB/s
```

### 116.10 Cómo se comunica con el resto del sistema

```
Monitorización LNOS
    │
    ├──→ kernel (procfs, sysfs, thermal zones)
    ├──→ lm-sensors (temperaturas, voltajes)
    ├──→ smartmontools (SMART disk)
    ├──→ Netdata/Prometheus (métricas agregadas)
    ├──→ btop++ (TUI monitor)
    ├──→ Waybar (widgets de monitorización en barra)
    ├──→ lnos-report (script de reporte semanal)
    └──→ lnos-config (Centro de Configuración → Monitorización)
```

### 116.11 Dependencias

| Dependencia | Tipo | Razón |
|------------|------|-------|
| `btop` | Paquete | Monitor TUI por defecto |
| `lm_sensors` | Paquete | Sensores de temperatura |
| `smartmontools` | Paquete | SMART disk health |
| `vnstat` | Paquete | Monitor de red |
| `nethogs` | Paquete | Tráfico por proceso |
| `netdata` | Opcional | Dashboard web |
| `prometheus` | Opcional | Métricas avanzadas |

### 116.12 Problemas potenciales y mitigaciones

| Problema | Mitigación |
|----------|-----------|
| Netdata consume demasiados recursos | No instalar por defecto; instalar solo si se necesita |
| Sensores no detectados | `sensors-detect --auto`; cargar módulos del kernel |
| SMART no disponible en NVMe | `nvme-cli` para NVMe específico |
| btop++ no detecta GPU | Verificar drivers GPU; `btop --gpu` |

### 116.13 Cómo se prueba

| Test | Procedimiento |
|------|--------------|
| btop++ | `btop`; verificar todas las métricas |
| Sensores | `sensors`; verificar temperaturas razonables |
| SMART | `smartctl -H /dev/nvme0`; PASS esperado |
| vnstat | `vnstat`; verificar datos de tráfico |
| Netdata | `systemctl start netdata`; acceder a localhost:19999 |

### 116.14 Cómo se mantiene

- **btop++:** Actualizaciones via pacman.
- **Netdata:** Actualizaciones automáticas vía su propio actualizador.
- **SMART:** Script `verificar-salud.sh` ejecuta chequeos semanales.
- **Sensores:** Reconfigurar solo si se añade nuevo hardware.

### 116.15 Cómo puede ampliarse

- **Monitoreo remoto:** Netdata cloud o Prometheus federation.
- **Alertas vía Telegram/Email:** Notificaciones cuando temperatura excede umbral.
- **Dashboard personalizado:** Grafana con datasources múltiples.
- **Monitoreo de aplicaciones:** Integración con exporters específicos (PostgreSQL, nginx, etc.).

---

## 117. Logging

### 117.1 ¿Para qué existe?

El sistema de logging de LNOS utiliza **systemd-journald** como sistema central, proporcionando una forma unificada, estructurada y eficiente de gestionar logs del sistema y aplicaciones.

**¿Por qué journald y no syslog tradicional?**

| Aspecto | journald | syslog (rsyslog) |
|---------|----------|-----------------|
| Formato | Binario estructurado (JSON-like) | Texto plano |
| Metadatos | PID, UID, GID, comm, syslog facility, priority, etc. | Solo mensaje y timestamp |
| Compresión | Sí (LZ4/XZ) | No |
| Rotación automática | Sí (por tamaño/tiempo) | Sí (logrotate) |
| Búsqueda | `journalctl` poderoso (filtros, consultas) | `grep` básico |
| Forwarding | A syslog, a syslog-ng, a remoto | A remoto |
| Integración kernel | Nativa (dmesg en journald) | vía klogd |

### 117.2 Configuración de journald

```
# /etc/systemd/journald.conf
[Journal]
Storage=auto                    # Persistente en /var/log/journal/
Compress=yes                    # Compresión LZ4
Seal=yes                        # Firma HMAC para integridad
SplitMode=uid                   # Logs separados por usuario
RateLimitIntervalSec=30s        # Rate limiting
RateLimitBurst=10000             # Máximo 10000 msg en 30s
SystemMaxUse=1G                 # Máximo 1GB para logs del sistema
SystemKeepFree=500M             # Mantener 500MB libres en /var
SystemMaxFileSize=100M          # Máximo 100MB por archivo
SystemMaxFiles=10               # Máximo 10 archivos
MaxRetentionSec=6months          # Retener máximo 6 meses
ForwardToSyslog=no              # No forwardear a syslog por defecto
ForwardToWall=yes               # Mostrar emergencias en todas las terminales
```

### 117.3 journalctl

```bash
# Ver logs del sistema
journalctl

# Logs del arranque actual
journalctl -b

# Logs de un servicio específico
journalctl -u sshd.service

# Logs con prioridad específica
journalctl -p err -b           # Errores del arranque actual
journalctl -p crit             # Solo mensajes críticos

# Logs de un PID
journalctl _PID=1234

# Logs de las últimas 2 horas
journalctl --since "2 hours ago"

# Seguir logs en tiempo real
journalctl -f

# Seguir logs de varios servicios
journalctl -u nginx.service -u postgresql.service -f

# Output en JSON
journalctl -o json
journalctl -o json-pretty

# Ver uso de disco
journalctl --disk-usage
# Logs are currently using 342.5M

# Rotar logs manualmente
journalctl --rotate

# Vaciar logs antiguos
journalctl --vacuum-time=30d
journalctl --vacuum-size=500M
```

### 117.4 logrotate para logs legacy

Aunque journald es el sistema primario, LNOS mantiene compatibilidad con logrotate para aplicaciones que escriben directamente a archivos de log:

```
/etc/logrotate.d/
├── docker               # /var/lib/docker/containers/*/*.log
├── nginx                # /var/log/nginx/*.log
├── mariadb              # /var/log/mariadb/*.log
├── cups                 # /var/log/cups/*.log
├── samba                # /var/log/samba/*.log
└── lnos                 # /var/log/lnos/*.log

# Configuración por defecto
/var/log/lnos/*.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    create 0640 root root
    postrotate
        systemctl restart lnos-api.service > /dev/null 2>&1 || true
    endscript
}
```

### 117.5 Forwarding a syslog (opcional)

Para entornos que requieren un servidor central de logs:

```bash
# Activar forwarding a syslog
sed -i 's/ForwardToSyslog=no/ForwardToSyslog=yes/' /etc/systemd/journald.conf
systemctl restart systemd-journald

# Configurar rsyslog para enviar a servidor central
# /etc/rsyslog.d/remote.conf
*.* @192.168.1.100:514   # UDP
## *.* @@192.168.1.100:514  # TCP
```

### 117.6 Logs de aplicaciones

LNOS configura las aplicaciones para que usen systemd-journald como backend de logging:

```json
// Configuración de logging para aplicaciones LNOS
{
  "docker": { "log-driver": "journald" },
  "nginx": { "access_log": "journald", "error_log": "journald" },
  "postgresql": { "log_destination": "journald" },
  "lnos-api": { "logging": { "systemd": true } }
}
```

### 117.7 Logs del kernel

Los logs del kernel se integran nativamente con journald:

```bash
# Equivalente a dmesg
journalctl -k

# Logs del kernel del arranque actual
journalctl -k -b

# Errores del kernel
journalctl -k -p err

# Seguir logs del kernel en tiempo real
journalctl -k -f
```

### 117.8 Cómo se comunica con el resto del sistema

```
systemd-journald
    │
    ├──→ kernel (dmesg via /dev/kmsg)
    ├──→ systemd (logs de servicios)
    ├──→ aplicaciones (vía stdout/stderr/sd-journal)
    ├──→ journalctl (herramienta de consulta)
    ├──→ logrotate (logs legacy)
    ├──→ rsyslog (forwarding opcional)
    ├──→ /var/log/journal/ (logs persistentes)
    └──→ /run/systemd/journal/ (logs volátiles)
```

### 117.9 Dependencias

| Dependencia | Tipo | Razón |
|------------|------|-------|
| `systemd` | Paquete | systemd-journald incluido |
| `rsyslog` | Opcional | Forwarding a syslog |
| `logrotate` | Paquete | Rotación de logs legacy |

### 117.10 Problemas potenciales y mitigaciones

| Problema | Mitigación |
|----------|-----------|
| Logs ocupan demasiado espacio | Ajustar SystemMaxUse, MaxRetentionSec |
| journalctl lento con muchos logs | `journalctl --vacuum-size=200M` para reducir |
| Logs binarios difíciles de parsear | `journalctl -o json` para output estructurado |
| Rate limiting muy agresivo | Aumentar RateLimitBurst si se pierden logs |

### 117.11 Cómo se prueba

| Test | Procedimiento |
|------|--------------|
| journald activo | `systemctl status systemd-journald` |
| Logs del sistema | `journalctl -b | tail -20` |
| Logs de servicio | `journalctl -u sshd --no-pager | head -5` |
| Rotación | `journalctl --disk-usage`; `journalctl --rotate` |
| JSON output | `journalctl -o json-pretty -n 1` |

### 117.12 Cómo se mantiene

- **journald:** Configuración en `/etc/systemd/journald.conf`.
- **Mantenimiento automático:** Timers de LNOS ejecutan `journalctl --vacuum-time=30d` mensualmente.
- **Integridad:** `journalctl --verify` para verificar integridad de logs.
- **Logs de usuario:** Separados por UID en `/var/log/journal/<machine-id>/user-<uid>.journal`.

### 117.13 Cómo puede ampliarse

- **Logs remotos:** Forwarding centralizado a servidor ELK (Elasticsearch, Logstash, Kibana).
- **Análisis de logs:** `journalctl --output=cursor` + scripts de análisis.
- **Auditoría:** `auditd` para logging de seguridad detallado.
- **Correlación de logs:** `journalctl -u nginx -u postgresql -u app` para correlación temporal.

---

## 118. Benchmarks

### 118.1 ¿Para qué existe?

LNOS incluye herramientas de benchmarking integradas que permiten medir el rendimiento del sistema antes y después de configuraciones, actualizaciones o cambios de hardware.

**Filosofía:** No confiar en percepciones. Medir objetivamente el rendimiento para tomar decisiones informadas.

### 118.2 Herramientas de benchmark

| Herramienta | Componente | Métricas | Integración LNOS |
|------------|-----------|----------|-----------------|
| **lnos-bench** | Sistema completo | CPU, RAM, disco, GPU, red | Herramienta propia, unificada |
| **stress-ng** | CPU/RAM | Estrés y rendimiento | Via lnos-bench |
| **sysbench** | CPU/RAM/Disco | Operaciones por segundo | Via lnos-bench |
| **fio** | Disco | IOPS, latencia, bandwidth | Via lnos-bench |
| **iperf3** | Red | Throughput, latencia | Via lnos-bench |
| **glmark2** | GPU (OpenGL) | FPS, escenas | Benchmark gráfico |
| **vkmark** | GPU (Vulkan) | FPS, escenas | Benchmark gráfico |
| **gputest** | GPU | FPS, temperatura | Benchmark GPU completo |
| **Geekbench** | Sistema completo | Multi-plataforma | Opcional (pago) |
| **Phoronix Test Suite** | Sistema completo | Suite completa | Opcional (open source) |

### 118.3 lnos-bench (herramienta propia)

```
lnos-bench — Benchmark unificado LNOS
```

```bash
# Benchmark rápido (2-3 minutos)
lnos-bench quick
# Resultados:
# ┌──────────────────────────┬────────────┐
# │  CPU (single)            │  2,345 pts │
# │  CPU (multi)             │ 18,234 pts │
# │  RAM (copy)              │ 45.2 GB/s  │
# │  Disco (seq read)        │ 3,456 MB/s │
# │  Disco (seq write)       │ 2,891 MB/s │
# │  Disco (rand read 4k)    │ 89.2 MB/s  │
# │  GPU (glmark2)           │  8,234 pts │
# │  Red (localhost)         │ 42.3 Gbps  │
# └──────────────────────────┴────────────┘

# Benchmark completo (10-15 minutos)
lnos-bench full

# Comparar con resultado anterior
lnos-bench compare --with last

# Exportar resultados
lnos-bench export --format json > /tmp/bench-20260729.json

# Comparar con línea base de LNOS
lnos-bench compare --with baseline
```

**Resultados típicos (línea base LNOS):**

```
Línea base LNOS v1.0:
CPU: Intel i7-13700H (14 cores, 20 threads)
┌───────────────┬──────────┬──────────┬──────────┐
│   Benchmark    │  Mínimo  │  Medio   │  Máximo  │
├───────────────┼──────────┼──────────┼──────────┤
│ CPU single    │  2,100   │  2,345   │  2,500   │
│ CPU multi     │ 16,000   │ 18,234   │ 20,000   │
│ RAM copy      │ 40 GB/s  │ 45 GB/s  │ 52 GB/s  │
│ Disco seq r   │ 3,000    │ 3,456    │ 5,000    │
│ Disco seq w   │ 2,500    │ 2,891    │ 4,000    │
│ GPU glmark2   │ 6,000    │ 8,234    │ 10,000   │
└───────────────┴──────────┴──────────┴──────────┘
```

### 118.4 stress-ng

```bash
# Estrés de CPU (todos los cores, 60 segundos)
stress-ng --cpu 0 --timeout 60s --metrics

# Estrés de memoria
stress-ng --vm 4 --vm-bytes 2G --timeout 60s

# Estrés combinado
stress-ng --cpu 0 --vm 2 --hdd 1 --timeout 120s
```

### 118.5 fio (disco)

```bash
# Benchmark de lectura secuencial
fio --name=seqread --rw=read --bs=1M --size=1G --numjobs=4 --runtime=30s

# Benchmark de lectura aleatoria 4K
fio --name=randread --rw=randread --bs=4k --size=1G --numjobs=4 --runtime=30s

# Benchmark de escritura secuencial
fio --name=seqwrite --rw=write --bs=1M --size=1G --numjobs=4 --runtime=30s

# Resultados típicos (NVMe Gen4):
# seq read:  3,456 MB/s
# seq write: 2,891 MB/s
# rand read 4K: 892,000 IOPS
# rand write 4K: 456,000 IOPS
```

### 118.6 iperf3 (red)

```bash
# Servidor (en otro host o local)
iperf3 -s

# Cliente
iperf3 -c 192.168.1.100 -t 30

# Bidireccional
iperf3 -c 192.168.1.100 -t 30 --bidir

# Resultados típicos:
# LAN Gigabit:   941 Mbps
# Wi-Fi 6:       720 Mbps (cercano)
# localhost:   42.3 Gbps
```

### 118.7 glmark2 (GPU OpenGL)

```bash
# Benchmark OpenGL completo
glmark2

# Benchmark con resolución específica
glmark2 --size 1920x1080

# Benchmark sin ventana (headless)
glmark2 --off-screen
```

### 118.8 vkmark (GPU Vulkan)

```bash
# Benchmark Vulkan completo
vkmark

# Benchmark con escenas específicas
vkmark --scene asteroids --scene shadow
```

### 118.9 Comparativa post-instalación vs óptima

LNOS ejecuta un benchmark inicial post-instalación y otro tras aplicar la configuración óptima, mostrando la mejora:

```
lnos-bench compare --with initial

Comparativa LNOS: Post-instalación → Configuración óptima
┌───────────────┬────────────────┬────────────────┬────────┐
│   Benchmark    │  Post-install  │  Config. óptima│ Mejora │
├───────────────┼────────────────┼────────────────┼────────┤
│ CPU single    │  2,100 pts     │  2,345 pts     │  +11%  │
│ CPU multi     │ 16,000 pts     │ 18,234 pts     │  +14%  │
│ RAM copy      │ 40.0 GB/s      │ 45.2 GB/s      │  +13%  │
│ Disco seq r   │ 3,000 MB/s     │ 3,456 MB/s     │  +15%  │
│ GPU glmark2   │ 6,000 pts      │ 8,234 pts      │  +37%  │
│ Latencia red  │ 0.5 ms         │ 0.3 ms         │  -40%  │
└───────────────┴────────────────┴────────────────┴────────┘
```

### 118.10 Cómo se comunica con el resto del sistema

```
lnos-bench
    │
    ├──→ stress-ng (CPU/RAM benchmark)
    ├──→ sysbench (CPU/RAM/disco benchmark)
    ├──→ fio (disco benchmark)
    ├──→ iperf3 (red benchmark)
    ├──→ glmark2 / vkmark (GPU benchmark)
    ├──→ /var/lib/lnos/benchmarks/ (histórico de resultados)
    ├──→ lnos-config (Centro de Configuración → Benchmark)
    └──→ lnos-telemetry (envío anonimizado de resultados agregados)
```

### 118.11 Dependencias

| Dependencia | Tipo | Razón |
|------------|------|-------|
| `stress-ng` | Paquete | CPU/RAM/stress benchmark |
| `sysbench` | Paquete | Benchmark de sistema |
| `fio` | Paquete | Benchmark de disco |
| `iperf3` | Paquete | Benchmark de red |
| `glmark2` | Paquete | Benchmark GPU OpenGL |
| `vkmark` | Paquete | Benchmark GPU Vulkan |
| `python` | Paquete | Script lnos-bench |

### 118.12 Problemas potenciales y mitigaciones

| Problema | Mitigación |
|----------|-----------|
| Benchmark afecta al rendimiento del sistema | Ejecutar en horario de bajo uso; avisar al usuario |
| GPU benchmark se cuelga | Timeout de 5 minutos por test |
| fio llena el disco | Usar `--size=1G` por defecto; limitar escrituras |
| iperf3 necesita servidor remoto | Incluir `iperf3 -s` local para test loopback |
| Resultados no reproducibles | Cerrar aplicaciones en background; ejecutar 3 veces y promediar |

### 118.13 Cómo se prueba

| Test | Procedimiento |
|------|--------------|
| lnos-bench quick | `lnos-bench quick`; verificar resultados en tiempo < 5 min |
| lnos-bench full | `lnos-bench full`; verificar todos los componentes |
| stress-ng | `stress-ng --cpu 1 --timeout 10s --metrics` |
| fio | `fio --name=test --size=100M --runtime=10s` |
| glmark2 | `glmark2 --off-screen` |

### 118.14 Cómo se mantiene

- **lnos-bench:** Script en `/usr/bin/lnos-bench` (Python).
- **Histórico:** Resultados en `/var/lib/lnos/benchmarks/`.
- **Referencias:** Línea base en `/usr/share/lnos/benchmarks/baseline.json`.
- **Actualizaciones:** Herramientas de benchmark via pacman.

### 118.15 Cómo puede ampliarse

- **Benchmark de batería:** `lnos-bench battery` mide duración con carga típica.
- **Benchmark de temperatura:** Estrés + monitoreo térmico para probar refrigeración.
- **Benchmark de gaming:** Escenas de juegos reales para medir FPS.
- **Benchmark cloud:** Comparar rendimiento de instancias cloud.

---

## 119. Rendimiento

### 119.1 ¿Para qué existe?

LNOS aplica optimizaciones de rendimiento en múltiples capas del sistema: kernel, almacenamiento, CPU, GPU y red. Estas optimizaciones están activadas por defecto y se ajustan automáticamente según el hardware detectado.

**Filosofía:** Máximo rendimiento por defecto, sin sacrificar estabilidad. Las optimizaciones agresivas son opcionales (perfil "rendimiento extremo").

### 119.2 Kernel params (sysctl)

LNOS configura los siguientes parámetros del kernel para rendimiento:

```
# /etc/sysctl.d/99-lnos-performance.conf

# Gestión de memoria
vm.swappiness = 10                    # Minimizar uso de swap
vm.vfs_cache_pressure = 50            # Cache de inodos/dentries en RAM más tiempo
vm.dirty_ratio = 30                   # % de RAM para dirty pages
vm.dirty_background_ratio = 5         # Background flush más temprano
vm.dirty_expire_centisecs = 3000      # Dirty pages expiran en 30s
vm.dirty_writeback_centisecs = 500    # Wake up writeback cada 5s
vm.max_map_count = 1048576            # Límite de mapas de memoria (para juegos)
vm.overcommit_memory = 1              # Siempre overcommit (para VMs)

# Red (buffer sizes)
net.core.rmem_max = 16777216          # Buffer máximo de recepción
net.core.wmem_max = 16777216          # Buffer máximo de envío
net.ipv4.tcp_rmem = 4096 87380 16777216   # TCP receive buffer
net.ipv4.tcp_wmem = 4096 65536 16777216   # TCP send buffer
net.core.default_qdisc = fq            # Fair Queuing (bufferbloat)
net.ipv4.tcp_congestion_control = bbr  # BBR congestion control

# Kernel
kernel.numa_balancing = 0              # Desactivar balanceo NUMA (latencia)
kernel.sched_autogroup_enabled = 0     # Desactivar autogroup (rendimiento consistente)
kernel.sched_migration_cost_ns = 5000000 # Migración de procesos menos frecuente
```

**Justificación de cada parámetro:**

| Parámetro | Valor | Efecto |
|-----------|-------|--------|
| vm.swappiness = 10 | Menor que 60 | Swap solo como último recurso |
| vm.vfs_cache_pressure = 50 | Menor que 100 | Mantener caches de FS en RAM |
| net.core.default_qdisc = fq | Fair Queueing | Reduce bufferbloat en redes |
| tcp_congestion_control = bbr | BBR | Mejor throughput en redes modernas |
| numa_balancing = 0 | Desactivado | Evita latencia por rebalanceo de páginas |

### 119.3 I/O schedulers

LNOS configura el scheduler de I/O según el tipo de disco:

| Tipo de disco | Scheduler | Justificación |
|--------------|-----------|---------------|
| **NVMe** | none (noop) | NVMe es tan rápido que el scheduler añade latencia |
| **SSD SATA** | mq-deadline | Buen equilibrio entre rendimiento y latencia |
| **HDD** | BFQ | Fairness para discos mecánicos; evita starvation |
| **Virtual** | none | Discos virtuales no necesitan scheduler |

```bash
# Configuración por disco en udev
# /etc/udev/rules.d/60-iosched.rules
ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="none"
ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"
ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
```

### 119.4 Gestión de CPU (governors)

| Perfil LNOS | Governor CPU | Efecto |
|------------|-------------|--------|
| Rendimiento | `performance` | Frecuencia máxima, máxima respuesta |
| Balanceado | `schedutil` | Frecuencia según carga, buen equilibrio |
| Ahorro | `powersave` | Frecuencia mínima, máxima duración batería |
| Gaming | `performance` | Igual que rendimiento |

**Configuración automática:**

```bash
# lnos-firstrun.service detecta y aplica:
# Desktop/Gaming → performance
# Laptop enchufado → schedutil
# Laptop batería → powersave

cpupower frequency-set -g schedutil
```

### 119.5 Gestión de GPU

| GPU | Perfil LNOS | Configuración |
|-----|------------|---------------|
| Intel | Rendimiento | `HUD=1` en RADV; `INTEL_DEBUG=perf` |
| AMD | Rendimiento | `RADV_PERFTEST=ngg`; `RADV_PREFER=performance` |
| NVIDIA | Rendimiento | `nvidia-settings -a GPUPowerMizerMode=1` |

**Configuración automática de GPU:**

```bash
# AMD: forzar rendimiento máximo
echo "high" > /sys/class/drm/card0/device/power_dpm_force_performance_level

# NVIDIA: forzar rendimiento máximo
nvidia-smi -pm 1
nvidia-smi -pl 150  # Limitar功耗 (opcional)
nvidia-smi -ac 5001,1590  # Lock clock memory/graphics
```

### 119.6 zram/zswap

LNOS configura **zram** o **zswap** según el perfil del sistema:

```
# zram (recomendado para ≤8GB RAM): comprime RAM en RAM
# Crea dispositivo comprimido en RAM como swap
# Más rápido que swap en disco

# Configuración por defecto
zram.size = RAM / 2
zram.compressor = zstd
zram.algorithm = zstd

# zswap (alternativa): cachea páginas comprimidas antes de swap
# Recomendado para sistemas con suficiente RAM
zswap.enabled = 0  # Desactivado por defecto (zram preferido)
```

### 119.7 Network tuning

```bash
# Desactivar IPv6 (si no se usa)
sysctl net.ipv6.conf.all.disable_ipv6=1

# Aceleración de hardware (if supported)
ethtool -K eth0 rx-checksumming on
ethtool -K eth0 tx-checksumming on
ethtool -K eth0 tcp-segmentation-offload on
ethtool -K eth0 generic-segmentation-offload on

# IRQ affinity para NIC
# Distribuir interrupciones entre cores
# Automático via irqbalance
systemctl enable --now irqbalance
```

### 119.8 Tuning para gaming

```
GameMode (incluido en lnos-gaming):
├── CPU governor → performance
├── I/O priority → high
├── Kernel scheduler → SCHED_ISO (mediante parche)
├── GPU → performance mode
├── Inhibit screensaver
└── Scripts personalizados pre/post game

# Configuración de GameMode
# /etc/gamemode.ini
[general]
renice = 10
desiredgov = performance
softrealtime = auto
reaper_freq = 5

[gpu]
apply_gpu_optimisations = accept-responsibility
gpu_device = 0
amd_performance_level = high
nv_powermizer_mode = 1
```

### 119.9 Cómo se comunica con el resto del sistema

```
Rendimiento LNOS
    │
    ├──→ Kernel (sysctl, governors, schedulers)
    ├──→ systemd (servicios de rendimiento)
    ├──→ GameMode (gaming optimizations)
    ├──→ lnos-firstrun (detección y configuración)
    ├──→ lnos-config (Centro de Configuración → Energía → Rendimiento)
    ├──→ lnos-gpu-* (módulos de GPU)
    └──→ TLP/power-profiles-daemon (gestión de energía)
```

### 119.10 Dependencias

| Dependencia | Tipo | Razón |
|------------|------|-------|
| `linux-lnos` | Paquete | Kernel optimizado LNOS |
| `gamemode` | Paquete | Optimizaciones para gaming |
| `irqbalance` | Paquete | Balanceo de interrupciones |
| `zram-generator` o `zram-init` | Paquete | Compresión de RAM |
| `tlp` | Opcional | Gestión de energía (laptops) |

### 119.11 Problemas potenciales y mitigaciones

| Problema | Mitigación |
|----------|-----------|
| zram consume CPU | No usar en sistemas con CPU débil; zswap alternativa |
| BBR no funciona con ciertos routers | Volver a `cubic` |
| governor performance gasta batería | Cambiar automáticamente a schedutil en batería |
| IRQ balance causa latencia | Probar con `irqbalance --oneshot` para una sola asignación |

### 119.12 Cómo se prueba

| Test | Procedimiento |
|------|--------------|
| sysctl | `sysctl vm.swappiness` debe ser 10 |
| I/O scheduler | `cat /sys/block/nvme0n1/queue/scheduler` |
| Governor | `cpupower frequency-info` |
| GameMode | `gamemoderun echo "test"` |
| zram | `zramctl` ver dispositivo comprimido |

### 119.13 Cómo se mantiene

- **sysctl:** Archivos en `/etc/sysctl.d/` actualizables por el usuario.
- **Schedulers:** Reglas udev en `/etc/udev/rules.d/`.
- **GameMode:** Configuración en `/etc/gamemode.ini`.
- **Perfiles:** En `/usr/share/lnos/performance/` (perfiles predefinidos).

### 119.14 Cómo puede ampliarse

- **CPU governors con IA:** `schedutil` con modelo ML para predecir carga.
- **GPU undervolt:** Scripts de undervolt seguro para Intel/AMD/NVIDIA.
- **RAM optimizations:** `cleancache`, `frontswap` configuraciones adicionales.
- **Perfiles por aplicación:** Reglas que aplican tuning específico al ejecutar ciertas aplicaciones.

---

## 120. Roadmap

### 120.1 ¿Para qué existe?

Este capítulo describe el plan de desarrollo de LNOS a medio y largo plazo. Define qué funcionalidades se entregarán en cada versión, los hitos principales y las fechas estimadas.

**Filosofía:** Roadmap realista, basado en prioridades de la comunidad, no en fechas de marketing.

### 120.2 Visión general

```
LNOS Roadmap 2026-2028
┌─────────────────────────────────────────────────────────┐
│  2026                 2027                 2028          │
├────────┬────────┬────────┬────────┬────────┬────────────┤
│   Q3   │   Q4   │   Q1   │   Q2   │   Q3   │   Q4+      │
├────────┼────────┼────────┼────────┼────────┼────────────┤
│  v1.0  │ v1.1   │ v1.2   │ v1.3   │ v2.0   │  LTS+      │
│  MVP   │ UX      │ Dev     │ Gaming  │ Estable │ Mant.      │
└────────┴────────┴────────┴────────┴────────┴────────────┘
```

### 120.3 v1.0 — MVP (Q3 2026)

**Objetivo:** Sistema instalable y funcional para el usuario técnico.

| Funcionalidad | Estado | Depende de |
|--------------|--------|-----------|
| ISO instalable (UEFI + BIOS) | Planificado | mkarchiso, systemd-boot |
| Hyprland + Wayland + Waybar + Rofi | Planificado | wlroots, hyprland |
| PipeWire + WirePlumber (audio) | Planificado | pipewire v1.0+ |
| NetworkManager + iwd (red) | Planificado | networkmanager |
| Btrfs + Timeshift (snapshots) | Planificado | btrfs-progs, timeshift |
| firewalld + AppArmor (seguridad) | Planificado | firewalld, apparmor |
| Drivers Intel/AMD/NVIDIA | Planificado | mesa, nvidia-open |
| Steam + Proton + GameMode (gaming) | Planificado | steam, proton |
| Pacman + Flatpak + AUR (paquetes) | Planificado | pacman, flatpak |
| Sistema de módulos (lnos-mod) | Planificado | módulos core |
| Centro de software (lnos-software) | Planificado | — |
| Actualizaciones automáticas + rollback | Planificado | timeshift |

**Fecha estimada:** Septiembre 2026  
**Riesgos:** Integración NVIDIA + Wayland, estabilidad de Hyprland con múltiples monitores.  
**Criterios de calidad:**
- Arranque en < 15 segundos (SSD).
- Consumo RAM < 600 MB en idle.
- Sin regresiones en paquetes Arch core.

### 120.4 v1.1 — UX Improvements (Q4 2026)

**Objetivo:** Pulir la experiencia de usuario y añadir herramientas de configuración.

| Funcionalidad | Estado | Depende de |
|--------------|--------|-----------|
| Centro de configuración (lnos-config) | Planificado | lnos-api, D-Bus |
| Asistente de bienvenida (lnos-welcome) | Planificado | — |
| lnos-firstrun.service | Planificado | udev, hwdata |
| Soporte de impresión (CUPS) | Planificado | cups, gutenprint, hplip |
| Soporte de escáneres (SANE) | Planificado | sane, sane-airscan |
| Bluetooth avanzado (codecs LDAC/aptX) | Planificado | bluez, pipewire |
| Syncthing + rsync (sincronización) | Planificado | — |
| Nextcloud + rclone (nube) | Planificado | — |
| Internacionalización (i18n) | Planificado | gettext, weblate |
| Accesibilidad (Orca, alto contraste) | Planificado | at-spi2, orca |
| Scripts de mantenimiento | Planificado | — |

**Fecha estimada:** Diciembre 2026  
**Riesgos:** Integración con D-Bus, complejidad del centro de configuración.  
**Criterios de calidad:**
- Centro de configuración funcional al 90%.
- Traducciones al 80% en 5 idiomas.
- Scripts de mantenimiento probados durante 1 mes.

### 120.5 v1.2 — Developer Tools (Q1 2027)

**Objetivo:** Convertir LNOS en una plataforma de desarrollo atractiva.

| Funcionalidad | Estado | Depende de |
|--------------|--------|-----------|
| Módulo lnos-dev (toolchains completas) | Planificado | gcc, rust, go, node, etc. |
| IDEs preconfigurados (VSCodium, Neovim, Zed) | Planificado | — |
| SDK (lnos-sdk) para módulos LNOS | Planificado | lnos-mod |
| API Interna REST | Planificado | — |
| Sistema de plugins | Planificado | lnos-config, lnos-software |
| Docker + Podman (contenedores) | Planificado | — |
| KVM + QEMU + libvirt (virtualización) | Planificado | — |
| Herramientas dev (ripgrep, fd, bat, fzf, etc.) | Planificado | — |
| Benchmarks (lnos-bench) | Planificado | stress-ng, fio, glmark2 |
| Netdata + Prometheus (monitorización) | Planificado | — |

**Fecha estimada:** Marzo 2027  
**Riesgos:** Mantener la coherencia de tantas herramientas.  
**Criterios de calidad:**
- SDK puede generar y empaquetar un módulo funcional.
- Todos los toolchains compilan "Hello World" sin errores.
- API REST documentada al 100% (OpenAPI).

### 120.6 v1.3 — Gaming & Performance (Q2 2027)

**Objetivo:** Rendimiento máximo para gaming y optimizaciones avanzadas.

| Funcionalidad | Estado | Depende de |
|--------------|--------|-----------|
| Kernel optimizado (linux-lnos) | Planificado | linux |
| GameMode + MangoHud + Gamescope | Planificado | — |
| zram/zswap (compresión de RAM) | Planificado | — |
| Kernel params optimizados (sysctl) | Planificado | — |
| I/O schedulers por dispositivo | Planificado | udev |
| GPU tuning (performance mode) | Planificado | — |
| Performance profiles (rendimiento/ahorro) | Planificado | — |
| TLP (gestión de energía laptops) | Planificado | — |
| Soporte de gamepads (PS4/PS5/Xbox/Switch) | Planificado | bluez, xpadneo |
| LE Audio (Bluetooth 5.2+) | Planificado | bluez 5.7+ |
| Roadmap feedback loop | Planificado | — |

**Fecha estimada:** Junio 2027  
**Riesgos:** Kernel personalizado requiere mantenimiento continuo.  
**Criterios de calidad:**
- Rendimiento gaming comparable a Windows 11 en mismo hardware.
- Consumo batería laptop LNOS vs Windows: no más de 15% de diferencia.
- Todos los gamepads Bluetooth principales funcionan out-of-the-box.

### 120.7 v2.0 — Stable / LTS-like (Q3 2027)

**Objetivo:** Versión estable, madura, con soporte a largo plazo.

| Funcionalidad | Estado | Depende de |
|--------------|--------|-----------|
| Congelación de API de módulos (1.0) | Planificado | — |
| Congelación de formatos de configuración | Planificado | — |
| Test suite completa (unit + integration + e2e) | Planificado | — |
| CI/CD pipeline maduro | Planificado | — |
| Documentación completa | Planificado | — |
| Política de estabilidad (no breaking changes) | Planificado | — |
| Versión LTS con 3 años de soporte | Planificado | — |
| Comunidad consolidada | Planificado | — |
| Módulos de comunidad en repositorio | Planificado | — |

**Fecha estimada:** Septiembre 2027  
**Riesgos:** Mantener el ritmo con Arch Linux upstream (rolling release).  
**Criterios de calidad:**
- 95%+ tests pasando en CI.
- Sin regresiones reportadas en los primeros 30 días.
- 50+ módulos de comunidad disponibles.

### 120.8 v2.x — Mantenimiento a largo plazo (Q4 2027+)

**Objetivo:** Mantenimiento continuo con mejoras incrementales.

| Versión | Foco | Fecha estimada |
|---------|------|---------------|
| v2.1 | Mejoras de estabilidad y seguridad | Q1 2028 |
| v2.2 | Nuevos módulos oficiales | Q2 2028 |
| v2.3 | Optimizaciones de rendimiento | Q3 2028 |
| v3.0 | Próxima generación (inmutable, IA) | 2029+ |

**Mantenimiento a largo plazo:**

```
Política de mantenimiento v2.x:
├── Actualizaciones de seguridad: 3 años desde release
├── Corrección de bugs críticos: 2 años desde release
├── Nuevas features: Solo en releases mayores (v3.0+)
└── Rolling release: Se mantiene la base Arch actualizada
```

**Fin del proyecto:**

```
Criterios para considerar el proyecto "finalizado":
├── Distribución completamente usable
├── Comunidad autosuficiente (mantenedores comunitarios)
├── Documentación completa y actualizada
├── 100+ módulos oficiales + comunitarios
└── Usuarios activos reportando bugs y contribuyendo

El proyecto no tiene fecha de finalización planificada.
Se mantendrá mientras haya comunidad activa.
```

### 120.9 Dependencias del roadmap

```
Dependencias entre versiones:

v1.0 → v1.1 → v1.2 → v1.3 → v2.0 → v2.x
 │       │       │       │       │       │
 │       │       │       │       │       └── Mantenimiento
 │       │       │       │       │
 │       │       │       │       └── Estabilización
 │       │       │       │
 │       │       │       └── Gaming
 │       │       │
 │       │       └── Developer tools
 │       │
 │       └── UX enhancements
 │
 └── MVP (base funcional)
```

### 120.10 Riesgos del roadmap

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|-------------|---------|-----------|
| Hyprland cambia API incompatible | Alta | Alto | Congelar versión de Hyprland para release |
| NVIDIA rompe soporte Wayland | Media | Alto | Fallback a XWayland documentado |
| Arch Linux cambia init system | Baja | Alto | Evaluar alternativas; plan de migración |
| Pérdida de mantenedores activos | Media | Medio | Documentación completa; bus de contribución |
| Falta de financiación | Alta | Medio | Proyecto 100% comunidad; sin dependencia económica |

### 120.11 Cómo contribuir al roadmap

El roadmap no es estático. La comunidad puede influir en las prioridades mediante:

1. **Discusiones en forums.lnos.dev** — Propuestas de features.
2. **GitHub Issues** — Reporte de bugs y solicitudes.
3. **Pull Requests** — Implementación directa.
4. **Encuestas de prioridad** — Realizadas cada release mayor.
5. **Votación de módulos** — Los módulos más solicitados reciben prioridad.

---

*Fin de la especificación técnica de LNOS — Capítulos 81 a 120.*

---

**Documento:** LNOS Technical Specification (SPEC_C81_120.md)  
**Versión:** 1.0.0  
**Última actualización:** 2026-07-29  
**Licencia:** CC BY-SA 4.0  
**Autoría:** Equipo de diseño LNOS
