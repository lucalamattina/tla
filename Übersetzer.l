%{
  #include <stdio.h>
  #include "y.tab.h"
  int yylex();
  void yyerror (char *s);
%}

number    [0-9][0-9]*
space     [ \t\n]
spaces    {space}+
string    [a-zA-Z][_a-zA-Z0-9]*


%%

"wenn"                return IF;
"während"             return WHILE;
"semikolon"           return END_LINE;
"kolon"               return COMMA;
"und"                 return AND;
"oder"                return OR;
"gleich"              return EQUAL;
"gleich?"             return IS_EQUAL;
"nicht"               return NOT;
"anders"              return NOT_EQUAL;
"weniger"             return L_THAN;
"wenigerg"            return LE_THAN;
"größer"              return G_THAN;
"größerg"             return GE_THAN;
"zahl"                return INT;
"wort"                return STRING;
"boolescher"          return BOOLEAN;
"drucken"             return PRINT;
"lesen"               return READ;
"ruckkehr"            return RETURN;
"sum"                 return ADD;
"subtrahieren"        return SUBSTRACT;
"multiplizieren"      return MULTIPLY;
"teilen"              return DIVIDE;
"modul"               return MODULE;
"wahr"                return TRUE_BOOL;
"falsch"              return FALSE_BOOL;
"oklammer"            return L_PAREN;
"sklammer"            return R_PAREN;
"ohalterung"          return L_BRACK;
"shalterung"          return R_BRACK;
"main"                return MAIN;
"ausfahrt"            return EXIT;
{spaces}                  ;


{string}                {char *str = malloc(strlen(yytext)+1);
                        strcpy(str, yytext);
                        yylval.str = str;
                        return ID;
                        }

{number}                {char *str = malloc(strlen(yytext)+1);
                        strcpy(str, yytext);
                        yylval.str = str;
                        return NUM;
                        }

\"[^\"]*\"              {char *str = malloc(strlen(yytext)+1);
                        strcpy(str, yytext);
                        yylval.str = str;
                        return TSTRING;
                        }


.                       {yyerror("Invalid character!");}

%%

int yywrap(void) {
  return 1;
}
