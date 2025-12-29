#!/bin/bash

# Esperar un poco para que Hyprland termine de inicializar

setup_single_monitor() {
    hyprctl keyword monitor "eDP-1,preferred,0x0,1"
}

# Función para configurar monitores duales
setup_dual_monitors() {
    echo "🖥️  Monitor externo detectado - Configurando dual pantalla"
    
    # Configurar HDMI-A-1 como principal (derecha)
    hyprctl keyword monitor "HDMI-A-1,preferred,0x0,1"
    
    # Configurar eDP-1 a la izquierda del HDMI
    hyprctl keyword monitor "eDP-1,preferred,1440x1,1"
    
    
    # Asigna workspaces a monitores de forma persistente.
    # Esto evita confusiones y asegura que cada workspace permanezca en su monitor.
    hyprctl keyword workspace "1,monitor:HDMI-A-1,persistent:true,rounding:true,decorate:true,gapsin:5,gapsout:15"
    hyprctl keyword workspace "2,monitor:HDMI-A-1,persistent:true,rounding:true,decorate:true,gapsin:5,gapsout:15"
    hyprctl keyword workspace "3,monitor:HDMI-A-1,persistent:true,rounding:true,decorate:true,gapsin:5,gapsout:15"
    hyprctl keyword workspace "4,monitor:HDMI-A-1,persistent:true,rounding:true,decorate:true,gapsin:5,gapsout:15"
    hyprctl keyword workspace "5,monitor:HDMI-A-1,persistent:true,rounding:true,decorate:true,gapsin:5,gapsout:15"

    hyprctl keyword workspace "6,monitor:eDP-1,persistent:true,rounding:true,decorate:true,gapsin:5,gapsout:15"
    hyprctl keyword workspace "7,monitor:eDP-1,persistent:true,rounding:true,decorate:true,gapsin:5,gapsout:15"
    hyprctl keyword workspace "8,monitor:eDP-1,persistent:true,rounding:true,decorate:true,gapsin:5,gapsout:15"
    hyprctl keyword workspace "9,monitor:eDP-1,persistent:true,rounding:true,decorate:true,gapsin:5,gapsout:15"
    hyprctl keyword workspace "10,monitor:eDP-1,persistent:true,rounding:true,decorate:true,gapsin:5,gapsout:15"

    # Espera un segundo para asegurar que la configuración del monitor se haya aplicado

    # Mueve los workspaces que ya existan a su monitor correspondiente.
    # hyprctl workspaces | grep "workspace ID" | awk '{print $3}' | while read -r id; do
    #     if [ "$id" -ge 1 ] && [ "$id" -le 5 ]; then
    #         hyprctl dispatch moveworkspacetomonitor "$id HDMI-A-1"
    #     elif [ "$id" -ge 6 ] && [ "$id" -le 10 ]; then
    #         hyprctl dispatch moveworkspacetomonitor "$id eDP-1"
    #     fi
    # done
}

# Detectar monitores conectados
detect_monitors() {
    # Opción 1: Usar hyprctl (más confiable con Hyprland)
    if hyprctl monitors | grep -q "HDMI-A-1"; then
        echo "Monitor HDMI-A-1 detectado"
        return 0  # true - HDMI conectado
    else
        echo "Monitor HDMI-A-1 NO detectado"
        return 1  # false - solo eDP-1
    fi
}

# Función principal
main() {
    if detect_monitors; then
        setup_dual_monitors
    else
        setup_single_monitor
    fi
}

# Ejecutar función principal
main
