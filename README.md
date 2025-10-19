# 💼 Sistema de Nómina - Compilador LEX & YACC

![Status](https://img.shields.io/badge/status-active-success.svg)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

## 📋 Descripción

Sistema de gestión de nómina desarrollado con LEX y YACC que permite:
- ✅ Registrar empleados con horas trabajadas y tarifa por hora
- ✅ Calcular salarios automáticamente (incluye horas extras al 1.5x)
- ✅ Consultar información individual de empleados
- ✅ Generar reportes totales de nómina

## 🎯 Características

- **Horas extras**: Cálculo automático de tiempo extra (>40 hrs) al 1.5x
- **Validación**: Manejo robusto de errores en entrada de datos
- **Reportes**: Resumen individual y total de nómina
- **Docker**: Containerización completa
- **Portable**: Scripts de construcción automatizados

## 📚 Tecnologías

- **LEX/Flex**: Generador de analizadores léxicos
- **YACC/Bison**: Generador de analizadores sintácticos
- **C/GCC**: Lenguaje y compilador
- **Docker**: Containerización
- **Make**: Automatización de build
- **Bash**: Scripts de construcción

## 📁 Estructura del Proyecto

```
nomina-compiler/
├── nomina.l            # Analizador léxico (LEX)
├── nomina.y            # Analizador sintáctico (YACC)
├── Dockerfile          # Configuración Docker
├── Makefile            # Automatización de build
├── test_nomina.txt     # Archivo de pruebas
├── .gitignore          # Archivos ignorados por git
└── README.md           # Este archivo
```

## 🚀 Inicio Rápido

### Requisitos Previos

- GCC
- LEX/Flex
- YACC/Bison
- Docker (opcional)
- Make (opcional)

### Instalación de Dependencias

**Debian/Ubuntu:**
```bash
sudo apt-get update
sudo apt-get install -y bison flex gcc make
```

**macOS:**
```bash
brew install bison flex gcc
```

## 🔨 Compilación

### Opción 1: Usando Makefile (Recomendado)

```bash
# Compilar
make

# Compilar y ejecutar
make run

# Ejecutar pruebas
make test

# Limpiar
make clean

# Ver todas las opciones
make help
```

### Opción 2: Manual

```bash
# 1. Generar parser
yacc -d nomina.y

# 2. Generar lexer
lex nomina.l

# 3. Compilar
gcc -c y.tab.c lex.yy.c

# 4. Enlazar
gcc y.tab.o lex.yy.o -o nomina -lm

# 5. Ejecutar
./nomina
```

## 🐳 Docker

### Build

```bash
# Usando Makefile
make docker-build

# Usando build.sh
./build.sh docker tuusuario

# Manual
docker build -t tuusuario/nomina-compiler .
```

### Run

```bash
# Interactivo
docker run -it tuusuario/nomina-compiler

# Con archivo de prueba
docker run -i tuusuario/nomina-compiler < test_nomina.txt

# Usando Makefile
make docker-run
make docker-test
```

### Push a Docker Hub

```bash
# Usando Makefile
make docker-push

# Manual
docker login
docker push tuusuario/nomina-compiler:latest
```

## 📝 Comandos del Sistema

### 1. Registrar Empleado
```
EMPLEADO <nombre> <horas> <tarifa>
```

**Ejemplos:**
```
EMPLEADO Juan 160 50
EMPLEADO Maria 180 45.5
EMPLEADO Pedro 40 60
```

### 2. Calcular Nómina
```
CALCULAR
```
Calcula el salario de todos los empleados registrados considerando horas extras.

### 3. Mostrar Información
```
MOSTRAR <nombre>      # Información de un empleado
MOSTRAR TOTAL         # Resumen total de nómina
```

### 4. Salir
```
Ctrl+D (Unix/Mac) o Ctrl+Z (Windows)
```

## 💡 Ejemplo de Uso

```
╔════════════════════════════════════════╗
║   SISTEMA DE NÓMINA - LEX & YACC      ║
╚════════════════════════════════════════╝

Comandos disponibles:
  EMPLEADO <nombre> <horas> <tarifa>
  CALCULAR
  MOSTRAR <nombre>
  MOSTRAR TOTAL
  Ctrl+D para salir

> EMPLEADO Juan 45 50
✓ Empleado registrado

> EMPLEADO Maria 38 60
✓ Empleado registrado

> EMPLEADO Carlos 50 40
✓ Empleado registrado

> CALCULAR

========== CÁLCULO DE NÓMINA ==========
Juan            |  45 hrs | $50.00/hr | $2375.00 (incluye 5 hrs extras)
Maria           |  38 hrs | $60.00/hr | $2280.00
Carlos          |  50 hrs | $40.00/hr | $2200.00 (incluye 10 hrs extras)
=======================================

> MOSTRAR Juan

--- Información de Juan ---
Horas trabajadas: 45
Tarifa por hora: $50.00
Salario calculado: $2375.00
------------------------

> MOSTRAR TOTAL

========== RESUMEN TOTAL ==========
Total de empleados: 3
Total de horas: 133
Total a pagar: $6855.00
===================================
```

## 📊 Lógica de Cálculo

### Horas Normales (≤40)
```
Salario = horas × tarifa
```

### Horas Extras (>40)
```
Salario = (40 × tarifa) + ((horas - 40) × tarifa × 1.5)
```

**Ejemplo:**
- Empleado: Juan
- Horas: 45
- Tarifa: $50/hr
- Cálculo: `(40 × $50) + (5 × $50 × 1.5) = $2000 + $375 = $2375`

## 🧪 Testing

### Archivo de Prueba
El proyecto incluye `test_nomina.txt` con casos de prueba:

```bash
# Ejecutar pruebas
make test

# O manualmente
./nomina < test_nomina.txt
```

### Crear Tus Propias Pruebas
```bash
echo "EMPLEADO Test1 40 50" > mis_pruebas.txt
echo "EMPLEADO Test2 45 60" >> mis_pruebas.txt
echo "CALCULAR" >> mis_pruebas.txt
echo "MOSTRAR TOTAL" >> mis_pruebas.txt

./nomina < mis_pruebas.txt
```
