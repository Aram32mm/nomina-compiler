# Makefile para Sistema de Nómina
# Compiladores
LEX = lex
YACC = yacc
CC = gcc
CFLAGS = -Wall

# Archivos
LEX_SRC = nomina.l
YACC_SRC = nomina.y
TARGET = nomina

# Archivos intermedios
LEX_OUT = lex.yy.c
YACC_OUT = y.tab.c
YACC_HEADER = y.tab.h
OBJECTS = y.tab.o lex.yy.o

# Docker
DOCKER_USER = tuusuario
DOCKER_IMAGE = nomina-compiler
DOCKER_TAG = latest

# Regla principal
all: $(TARGET)

# Compilar el ejecutable
$(TARGET): $(OBJECTS)
	@echo "🔗 Enlazando archivos objeto..."
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJECTS) -lm
	@echo "✅ Compilación exitosa: $(TARGET)"

# Generar archivos de YACC
$(YACC_OUT) $(YACC_HEADER): $(YACC_SRC)
	@echo "📝 Generando parser con YACC..."
	$(YACC) -d $(YACC_SRC)

# Generar archivos de LEX
$(LEX_OUT): $(LEX_SRC) $(YACC_HEADER)
	@echo "📝 Generando lexer con LEX..."
	$(LEX) $(LEX_SRC)

# Compilar objetos
y.tab.o: $(YACC_OUT)
	@echo "🔨 Compilando parser..."
	$(CC) $(CFLAGS) -c $(YACC_OUT)

lex.yy.o: $(LEX_OUT)
	@echo "🔨 Compilando lexer..."
	$(CC) $(CFLAGS) -c $(LEX_OUT)

# Ejecutar el programa
run: $(TARGET)
	@echo "🚀 Ejecutando $(TARGET)..."
	./$(TARGET)

# Ejecutar con archivo de prueba
test: $(TARGET)
	@echo "🧪 Ejecutando pruebas..."
	@if [ -f test_nomina.txt ]; then \
		./$(TARGET) < test_nomina.txt; \
	else \
		echo "❌ Archivo test_nomina.txt no encontrado"; \
	fi

# Limpiar archivos generados
clean:
	@echo "🧹 Limpiando archivos generados..."
	rm -f $(TARGET) $(OBJECTS) $(LEX_OUT) $(YACC_OUT) $(YACC_HEADER)
	@echo "✅ Limpieza completa"

# Limpiar todo incluyendo backups
cleanall: clean
	rm -f *~ *.bak

# Docker: construir imagen
docker-build:
	@echo "🐳 Construyendo imagen Docker..."
	docker build -t $(DOCKER_USER)/$(DOCKER_IMAGE):$(DOCKER_TAG) .
	@echo "✅ Imagen construida: $(DOCKER_USER)/$(DOCKER_IMAGE):$(DOCKER_TAG)"

# Docker: ejecutar contenedor
docker-run:
	@echo "🚀 Ejecutando contenedor Docker..."
	docker run -it $(DOCKER_USER)/$(DOCKER_IMAGE):$(DOCKER_TAG)

# Docker: ejecutar con archivo de prueba
docker-test:
	@echo "🧪 Ejecutando pruebas en Docker..."
	docker run -i $(DOCKER_USER)/$(DOCKER_IMAGE):$(DOCKER_TAG) < test_nomina.txt

# Docker: subir a Docker Hub
docker-push: docker-build
	@echo "📤 Subiendo imagen a Docker Hub..."
	docker login
	docker push $(DOCKER_USER)/$(DOCKER_IMAGE):$(DOCKER_TAG)
	@echo "✅ Imagen subida a Docker Hub"

# Docker: listar imágenes
docker-images:
	@echo "📋 Listando imágenes Docker..."
	docker images | grep $(DOCKER_IMAGE)

# Docker: eliminar imagen
docker-clean:
	@echo "🧹 Eliminando imagen Docker..."
	docker rmi $(DOCKER_USER)/$(DOCKER_IMAGE):$(DOCKER_TAG)

# Mostrar ayuda
help:
	@echo "════════════════════════════════════════════════════════"
	@echo "  Sistema de Nómina - Makefile"
	@echo "════════════════════════════════════════════════════════"
	@echo ""
	@echo "Compilación:"
	@echo "  make              - Compilar el proyecto"
	@echo "  make clean        - Limpiar archivos generados"
	@echo "  make cleanall     - Limpiar todo"
	@echo ""
	@echo "Ejecución:"
	@echo "  make run          - Ejecutar el programa"
	@echo "  make test         - Ejecutar con archivo de prueba"
	@echo ""
	@echo "Docker:"
	@echo "  make docker-build - Construir imagen Docker"
	@echo "  make docker-run   - Ejecutar en Docker (interactivo)"
	@echo "  make docker-test  - Ejecutar pruebas en Docker"
	@echo "  make docker-push  - Subir a Docker Hub"
	@echo "  make docker-images- Listar imágenes Docker"
	@echo "  make docker-clean - Eliminar imagen Docker"
	@echo ""
	@echo "════════════════════════════════════════════════════════"

# Instalar dependencias (Debian/Ubuntu)
install-deps:
	@echo "📦 Instalando dependencias..."
	sudo apt-get update
	sudo apt-get install -y bison flex gcc make
	@echo "✅ Dependencias instaladas"

.PHONY: all run test clean cleanall docker-build docker-run docker-test docker-push docker-images docker-clean help install-deps