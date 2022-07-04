import compilerTools.Token;

%%
%class Lexer
%type Token
%line
%column
%{
    private Token token(String lexeme, String lexicalComp, int line, int column){
        return new Token(lexeme, lexicalComp, line+1, column+1);
    }
%}
/* Variables básicas de comentarios y espacios */
TerminadorDeLinea = \r|\n|\r\n
EntradaDeCaracter = [^\r\n]
EspacioEnBlanco = {TerminadorDeLinea} | [ \t\f]
ComentarioTradicional = "/*" [^*] ~"*/" | "/*" "*"+ "/"
FinDeLineaComentario = "//" {EntradaDeCaracter}* {TerminadorDeLinea}?
ContenidoComentario = ( [^*] | \*+ [^/*] )*
ComentarioDeDocumentacion = "/**" {ContenidoComentario} "*"+ "/"

/* Comentario */
Comentario = {ComentarioTradicional} | {FinDeLineaComentario} | {ComentarioDeDocumentacion}

/* Identificador */
Letra = [A-Za-zÑñ_ÁÉÍÓÚáéíóúÜü]
Digito = [0-9]
Identificador = {Letra}({Letra}|{Digito})*

/* Número */
Numero = 0 | [1-9][0-9]*
%%

/* Comentarios o espacios en blanco */
{Comentario}|{EspacioEnBlanco} { /*Ignorar*/ }

/* Identificador */
\${Identificador} { return token(yytext(), "IDENTIFICADOR", yyline, yycolumn); }

/* Tipos de dato */
numero |
color { return token(yytext(), "TIPO_DATO", yyline, yycolumn); }

/* Numero */
{Numero} { return token(yytext(), "NUMERO", yyline, yycolumn); }

/* Color */
#[ {Letra} | {Digito} ]{6} { return token(yytext(), "COLOR", yyline, yycolumn); }

/* Operadores de agrupacion */
"(" { return token(yytext(), "PARENTESIS_A", yyline, yycolumn); }
")" { return token(yytext(), "PARENTESIS_C", yyline, yycolumn); }
"{" { return token(yytext(), "LLAVE_A", yyline, yycolumn); }
"}" { return token(yytext(), "LLAVE_C", yyline, yycolumn); }

/* SIGNOS DE PUNTUACION */
"," { return token(yytext(), "COMA", yyline, yycolumn); }
";" { return token(yytext(), "PUNTO_COMA", yyline, yycolumn); }

/* Operador de asignacion */
--> { return token(yytext(), "OP_ASIGNACION", yyline, yycolumn); }

/* Repetir */
repetir | 
repetirMientras { return token(yytext(), "REPETIR", yyline, yycolumn); }

/* Detener repetir */
interrumpir { return token(yytext(), "DETENER_REPETIR", yyline, yycolumn); }

/* Estructura si */
si | 
sino { return token(yytext(), "ESTRUCTURA_SI", yyline, yycolumn); }

/* Operadores logicos */
"&" | 
"|" { return token(yytext(), "OP_LOGICO", yyline, yycolumn); }

/* FInal */
final { return token(yytext(), "FINAL", yyline, yycolumn); }

//Numero erroneo
0{Numero} { return token(yytext(), "ERROR_1", yyline, yycolumn);}
// Identificador erroneo
{Identificador} { return token(yytext(), "Error_2", yyline, yycolumn);}

. { return token(yytext(), "ERROR", yyline, yycolumn); }