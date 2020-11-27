%{
  #include <stdio.h>
  #include "./y.tab.h"
  void yyerror (char *s);
  int yylex();
%}

word      [a-zA-Z][_a-zA-Z0-9]*
number    [0-9][0-9]*
space     [ \t\n]
ws        {space}+

%%


"wenn"                return IF;
"während"             return WHILE;
"und"                 return AND;
"oder"                return OR;
"main"                return MAIN;
"zahl"                return T_INT;
"wort"                return T_STRING;
"boolescher"          return T_BOOL;
"drucken"             return PRINT;
"lesen"               return READ;
"rückkehr"            return RETURN;
"sum"                 return SUM;
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
"wahr"                return TRUE_VAL;
"falsch"              return FALSE_VAL;
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

.                       {yyerror("Unexpected character");}

%%

int yywrap(void) {
  return 1;
}
