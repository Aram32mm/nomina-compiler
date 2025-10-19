#!/bin/bash

# Script de construcción para Sistema de Nómina
# Autor: José Aram Méndez Gómez
# Fecha: 2025

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir con color
print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Banner
echo "════════════════════════════════════════════════════════"
echo "  Sistema de Nómina - Script de Construcción"
echo "════════════════════════════════════════════════════════"
echo ""

# Verificar dependencias
check_dependencies() {
    print_info "Verificando dependencias..."
    
    local missing_deps=0
    
    if ! command -v lex &> /dev/null && ! command -v flex &> /dev/null; then
        print_error "LEX/Flex no está instalado"
        missing_deps=1
    fi
    
    if ! command -v yacc &> /dev/null && ! command -v bison &> /dev/null; then
        print_error "YACC/Bison no está instalado"
        missing_deps=1
    fi
    
    if ! command -v gcc &> /dev/null; then
        print_error "GCC no está instalado"
        missing_deps=1
    fi
    
    if [ $missing_deps -eq 1 ]; then
        print_warning "Instala las dependencias con:"
        echo "    sudo apt-get install bison flex gcc"
        echo "    o ejecuta: make install-deps"
        exit 1
    fi
    
    print_success "Todas las dependencias están instaladas"
}

# Limpiar archivos previos
clean_build() {
    print_info "Limpiando archivos anteriores..."
    rm -f nomina *.o lex.yy.c y.tab.c y.tab.h
    print_success "Limpieza completa"
}

# Compilar proyecto
build_project() {
    print_info "Iniciando compilación..."
    
    # Generar parser con YACC
    print_info "Generando parser con YACC..."
    yacc -d nomina.y
    if [ $? -ne 0 ]; then
        print_error "Error al generar parser"
        exit 1
    fi
    print_success "Parser generado"
    
    # Generar lexer con LEX
    print_info "Generando lexer con LEX..."
    lex nomina.l
    if [ $? -ne 0 ]; then
        print_error "Error al generar lexer"
        exit 1
    fi
    print_success "Lexer generado"
    
    # Compilar archivos
    print_info "Compilando archivos C..."
    gcc -c y.tab.c lex.yy.c
    if [ $? -ne 0 ]; then
        print_error "Error al compilar"
        exit 1
    fi
    print_success "Archivos compilados"
    
    # Enlazar
    print_info "Enlazando ejecutable..."
    gcc y.tab.o lex.yy.o -o nomina -lm
    if [ $? -ne 0 ]; then
        print_error "Error al enlazar"
        exit 1
    fi
    print_success "Ejecutable creado: nomina"
}

# Construir imagen Docker
build_docker() {
    print_info "Construyendo imagen Docker..."
    
    if ! command -v docker &> /dev/null; then
        print_error "Docker no está instalado"
        exit 1
    fi
    
    docker build -t "$1/nomina-compiler:latest" .
    if [ $? -eq 0 ]; then
        print_success "Imagen Docker construida: $1/nomina-compiler:latest"
    else
        print_error "Error al construir imagen Docker"
        exit 1
    fi
}

# Ejecutar pruebas
run_tests() {
    print_info "Ejecutando pruebas..."
    
    if [ ! -f nomina ]; then
        print_error "Ejecutable no encontrado. Compila primero."
        exit 1
    fi
    
    if [ -f test_nomina.txt ]; then
        ./nomina < test_nomina.txt
        print_success "Pruebas completadas"
    else
        print_warning "Archivo test_nomina.txt no encontrado"
    fi
}

# Menu principal
show_menu() {
    echo ""
    echo "Selecciona una opción:"
    echo "  1) Compilar proyecto"
    echo "  2) Compilar y ejecutar"
    echo "  3) Compilar y ejecutar pruebas"
    echo "  4) Limpiar archivos"
    echo "  5) Construir imagen Docker"
    echo "  6) Todo (compilar + Docker)"
    echo "  7) Salir"
    echo ""
}

# Procesar argumentos de línea de comandos
if [ $# -gt 0 ]; then
    case $1 in
        build)
            check_dependencies
            clean_build
            build_project
            ;;
        run)
            if [ ! -f nomina ]; then
                check_dependencies
                clean_build
                build_project
            fi
            print_info "Ejecutando programa..."
            ./nomina
            ;;
        test)
            if [ ! -f nomina ]; then
                check_dependencies
                clean_build
                build_project
            fi
            run_tests
            ;;
        clean)
            clean_build
            ;;
        docker)
            if [ -z "$2" ]; then
                print_error "Uso: ./build.sh docker <docker-username>"
                exit 1
            fi
            build_docker "$2"
            ;;
        all)
            if [ -z "$2" ]; then
                print_error "Uso: ./build.sh all <docker-username>"
                exit 1
            fi
            check_dependencies
            clean_build
            build_project
            run_tests
            build_docker "$2"
            ;;
        help|--help|-h)
            echo "Uso: ./build.sh [opción] [argumentos]"
            echo ""
            echo "Opciones:"
            echo "  build       - Compilar el proyecto"
            echo "  run         - Compilar y ejecutar"
            echo "  test        - Compilar y ejecutar pruebas"
            echo "  clean       - Limpiar archivos generados"
            echo "  docker <user> - Construir imagen Docker"
            echo "  all <user>  - Hacer todo (compilar + test + Docker)"
            echo "  help        - Mostrar esta ayuda"
            echo ""
            echo "Ejemplos:"
            echo "  ./build.sh build"
            echo "  ./build.sh run"
            echo "  ./build.sh docker miusuario"
            echo "  ./build.sh all miusuario"
            ;;
        *)
            print_error "Opción no válida: $1"
            print_info "Usa './build.sh help' para ver opciones"
            exit 1
            ;;
    esac
    exit 0
fi

# Modo interactivo
while true; do
    show_menu
    read -p "Opción: " choice
    
    case $choice in
        1)
            check_dependencies
            clean_build
            build_project
            ;;
        2)
            check_dependencies
            clean_build
            build_project
            print_info "Ejecutando programa..."
            ./nomina
            ;;
        3)
            check_dependencies
            clean_build
            build_project
            run_tests
            ;;
        4)
            clean_build
            ;;
        5)
            read -p "Ingresa tu usuario de Docker Hub: " docker_user
            build_docker "$docker_user"
            ;;
        6)
            read -p "Ingresa tu usuario de Docker Hub: " docker_user
            check_dependencies
            clean_build
            build_project
            run_tests
            build_docker "$docker_user"
            print_success "¡Todo completado!"
            ;;
        7)
            print_info "¡Hasta luego!"
            exit 0
            ;;
        *)
            print_error "Opción no válida"
            ;;
    esac
done