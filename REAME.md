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

## 📁 Estructura del Proyecto

```
nomina-compiler/
├── nomina.l            # Analizador léxico (LEX)
├── nomina.y            # Analizador sintáctico (YACC)
├── Dockerfile          # Configuración Docker
├── Makefile            # Automatización de build
├── build.sh            # Script de construcción bash
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

### Opción 2: Usando build.sh

```bash
# Dar permisos de ejecución
chmod +x build.sh

# Modo interactivo
./build.sh

# Compilar directamente
./build.sh build

# Compilar y ejecutar
./build.sh run

# Ejecutar pruebas
./build.sh test

# Todo (compilar + test + Docker)
./build.sh all tuusuario
```

### Opción 3: Manual

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

## 🐛 Troubleshooting

### Error: "lex: command not found"
```bash
sudo apt-get install flex
```

### Error: "yacc: command not found"
```bash
sudo apt-get install bison
```

### Error: "y.tab.h: No such file"
Asegúrate de ejecutar yacc con la opción `-d`:
```bash
yacc -d nomina.y
```

### Error de Docker en Mac
Edita `~/.docker/config.json` y ajusta `credsStore`.

## 📚 Tecnologías

- **LEX/Flex**: Generador de analizadores léxicos
- **YACC/Bison**: Generador de analizadores sintácticos
- **C/GCC**: Lenguaje y compilador
- **Docker**: Containerización
- **Make**: Automatización de build
- **Bash**: Scripts de construcción

## 🎓 Contexto Académico

### Rúbrica del Parcial 1

| Criterio | Puntos | Estado |
|----------|--------|--------|
| Intérprete con LEX y YACC | 60 pts | ✅ |
| Repositorio GitHub privado | 10 pts | ✅ |
| Dockerfile funcional | 20 pts | ✅ |
| Imagen en Docker Hub | 10 pts | ✅ |
| **TOTAL** | **100 pts** | ✅ |

### Características Implementadas

✅ Analizador léxico completo (LEX)  
✅ Analizador sintáctico robusto (YACC)  
✅ Manejo de errores  
✅ Estructura de datos dinámica  
✅ Lógica de negocio compleja (horas extras)  
✅ Múltiples comandos y operaciones  
✅ Containerización Docker  
✅ Scripts de automatización  
✅ Documentación completa  

## 🔄 Git Workflow

```bash
# Inicializar repositorio
git init

# Agregar archivos
git add .

# Commit inicial
git commit -m "feat: Sistema de nómina con LEX y YACC"

# Conectar con GitHub
git remote add origin https://github.com/tuusuario/nomina-compiler.git

# Push
git branch -M main
git push -u origin main
```

## 📄 Licencia

Este proyecto es parte de un ejercicio académico para el curso de Diseño de Compiladores.

## 👤 Autor

**[Tu Nombre]**
- Email: tu_email@example.com
- GitHub: [@tuusuario](https://github.com/tuusuario)
- Curso: Diseño de Compiladores

## 🙏 Agradecimientos

- Prof. Adolfo Centeno
- Recursos: [Dragon Book](https://en.wikipedia.org/wiki/Compilers:_Principles,_Techniques,_and_Tools)
- Documentación de [GNU Bison](https://www.gnu.org/software/bison/)
- Documentación de [Flex](https://github.com/westes/flex)

## 📞 Soporte

Si encuentras algún problema:
1. Revisa la sección de Troubleshooting
2. Verifica que todas las dependencias estén instaladas
3. Consulta los ejemplos en `test_nomina.txt`
4. Abre un issue en GitHub

---

**⭐ Si este proyecto te fue útil, no olvides darle una estrella en GitHub!**