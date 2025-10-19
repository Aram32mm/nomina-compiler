FROM gcc:latest

# Metadata
LABEL maintainer="A01657142@tec.mx"
LABEL description="Sistema de Nómina con LEX y YACC"

# Instalar dependencias
RUN apt-get update && \
    apt-get install -y bison flex && \
    rm -rf /var/lib/apt/lists/*

# Directorio de trabajo
WORKDIR /nomina

# Copiar archivos fuente
COPY nomina.l .
COPY nomina.y .

# Compilar el proyecto
RUN lex nomina.l && \
    yacc -d nomina.y && \
    gcc -c y.tab.c lex.yy.c && \
    gcc y.tab.o lex.yy.o -o nomina -lm

# Comando por defecto
CMD ["./nomina"]