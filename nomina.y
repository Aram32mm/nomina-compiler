%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex();
void yyerror(char *s);

// Estructura para empleados
typedef struct {
    char nombre[50];
    int horas;
    float tarifa;
    float salario;
    int activo;
} Empleado;

Empleado empleados[100];
int num_empleados = 0;

void agregar_empleado(char* nombre, int horas, float tarifa);
void calcular_nomina();
void mostrar_empleado(char* nombre);
void mostrar_total();
%}

%union {
    int num;
    float fnum;
    char *str;
}

%token EMPLEADO CALCULAR MOSTRAR TOTAL
%token <str> NOMBRE
%token <num> NUMERO
%token <fnum> DECIMAL
%token EOL

%%

programa: /* vacio */
        | programa comando
        ;

comando: agregar EOL       { printf("✓ Empleado registrado\n"); }
       | calcular EOL      { calcular_nomina(); }
       | mostrar EOL       
       | error EOL         { yyerrok; }
       ;

agregar: EMPLEADO NOMBRE NUMERO NUMERO {
           agregar_empleado($2, $3, (float)$4);
         }
       | EMPLEADO NOMBRE NUMERO DECIMAL {
           agregar_empleado($2, $3, $4);
         }
       ;

calcular: CALCULAR {
            calcular_nomina();
          }
        ;

mostrar: MOSTRAR NOMBRE {
           mostrar_empleado($2);
         }
       | MOSTRAR TOTAL {
           mostrar_total();
         }
       ;

%%

void agregar_empleado(char* nombre, int horas, float tarifa) {
    if (num_empleados >= 100) {
        printf("Error: Máximo de empleados alcanzado\n");
        return;
    }
    
    strcpy(empleados[num_empleados].nombre, nombre);
    empleados[num_empleados].horas = horas;
    empleados[num_empleados].tarifa = tarifa;
    empleados[num_empleados].salario = 0;
    empleados[num_empleados].activo = 1;
    num_empleados++;
}

void calcular_nomina() {
    printf("\n========== CÁLCULO DE NÓMINA ==========\n");
    
    for (int i = 0; i < num_empleados; i++) {
        if (empleados[i].activo) {
            // Calcular horas normales y extras
            float salario;
            if (empleados[i].horas <= 40) {
                salario = empleados[i].horas * empleados[i].tarifa;
            } else {
                // Horas extras al 1.5x
                float horas_normales = 40;
                float horas_extras = empleados[i].horas - 40;
                salario = (horas_normales * empleados[i].tarifa) + 
                         (horas_extras * empleados[i].tarifa * 1.5);
            }
            
            empleados[i].salario = salario;
            
            printf("%-15s | %3d hrs | $%.2f/hr | ", 
                   empleados[i].nombre, 
                   empleados[i].horas, 
                   empleados[i].tarifa);
            
            if (empleados[i].horas > 40) {
                printf("$%.2f (incluye %.0f hrs extras)\n", 
                       salario, 
                       (float)(empleados[i].horas - 40));
            } else {
                printf("$%.2f\n", salario);
            }
        }
    }
    printf("=======================================\n\n");
}

void mostrar_empleado(char* nombre) {
    for (int i = 0; i < num_empleados; i++) {
        if (empleados[i].activo && strcmp(empleados[i].nombre, nombre) == 0) {
            printf("\n--- Información de %s ---\n", empleados[i].nombre);
            printf("Horas trabajadas: %d\n", empleados[i].horas);
            printf("Tarifa por hora: $%.2f\n", empleados[i].tarifa);
            if (empleados[i].salario > 0) {
                printf("Salario calculado: $%.2f\n", empleados[i].salario);
            } else {
                printf("Salario: Aún no calculado\n");
            }
            printf("------------------------\n\n");
            return;
        }
    }
    printf("Error: Empleado '%s' no encontrado\n", nombre);
}

void mostrar_total() {
    float total = 0;
    int total_horas = 0;
    
    printf("\n========== RESUMEN TOTAL ==========\n");
    for (int i = 0; i < num_empleados; i++) {
        if (empleados[i].activo) {
            total += empleados[i].salario;
            total_horas += empleados[i].horas;
        }
    }
    
    printf("Total de empleados: %d\n", num_empleados);
    printf("Total de horas: %d\n", total_horas);
    printf("Total a pagar: $%.2f\n", total);
    printf("===================================\n\n");
}

void yyerror(char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    printf("╔════════════════════════════════════════╗\n");
    printf("║   SISTEMA DE NÓMINA - LEX & YACC      ║\n");
    printf("╚════════════════════════════════════════╝\n\n");
    printf("Comandos disponibles:\n");
    printf("  EMPLEADO <nombre> <horas> <tarifa>\n");
    printf("  CALCULAR\n");
    printf("  MOSTRAR <nombre>\n");
    printf("  MOSTRAR TOTAL\n");
    printf("  Ctrl+D para salir\n\n");
    printf("> ");
    
    yyparse();
    
    printf("\n¡Hasta luego!\n");
    return 0;
}