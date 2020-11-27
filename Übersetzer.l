%{
  #include <stdio.h>
  #include "./y.tab.h"
  void yyerror (char *s);
  int yylex();
%}

string    [a-zA-Z][_a-zA-Z0-9]*
number    [0-9][0-9]*
space     [ \t\n]

%%


"wenn"                return IF;
"während"             return WHILE;
"und"                 return AND;
"oder"                return OR;
"main"                return MAIN;
"zahl"                return INT;
"wort"                return STRING;
"boolescher"          return BOOLEAN;
"drucken"             return PRINT;
"lesen"               return READ;
"rückkehr"            return RETURN;
"sum"                 return ADD;
"subtrahieren"        return SUBSTRACT;
"multiplizieren"      return MULTIPLY;
"teilen"              return DIVIDE;
"modul"               return MODULE;
"gleich"              return EQUAL;
"gleich?"             return IS_EQUAL;
"nicht"               return NOT;
"anders"              return NOT_EQUAL;
"weniger"             return L_THAN;
"wenigerg"            return LE_THAN;
"größer"              return G_THAN;
"größerg"             return GE_THAN;
"wahr"                return TRUE_BOOL;
"falsch"              return FALSE_BOOL;
"oklammer"            return L_PAREN;
"sklammer"            return R_PAREN;
"ohalterung"          return L_BRACK;
"shalterung"          return R_BRACK;
"semikolon"           return END_LINE;
"kolon"               return COMMA;
"ausfahrt"            return EXIT;

\"[^\"]*\"              {char *str = malloc(strlen(yytext)+1);
                        strcpy(str, yytext);
                        yylval.str = str;
                        return STRING;
                        }  

{number}                {char *str = malloc(strlen(yytext)+1);
                        strcpy(str, yytext);
                        yylval.str = str;
                        return NUM;
                        }

{word}                  {char *str = malloc(strlen(yytext)+1);
                        strcpy(str, yytext);
                        yylval.str = str;
                        return ID;
                        }

.                       {yyerror("Invalid character!");}

%%

int yywrap(void) {
  return 1;
}
