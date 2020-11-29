%{
  int yylex();
  void yyerror (char *s);
  #include <stdio.h>
  #include <string.h>
  #include <ctype.h>
  #include <stdlib.h>
  #include "node.h"
%}

%start start

%union {
  struct node_t *node;
  char *str;
}

%token <str> NUM TSTRING ID
%token IF PRINT READ TRUE_BOOL FALSE_BOOL INT STRING MAIN RETURN BOOLEAN EQUAL IS_EQUAL NOT_EQUAL NOT L_THAN LE_THAN G_THAN GE_THAN WHILE AND OR ADD SUBSTRACT MULTIPLY DIVIDE MODULE L_PAREN R_PAREN L_BRACK R_BRACK END_LINE COMMA EXIT
%type <node> start sentences extra_sentence if while boolean arguments methods main extra_function parameters declare goto return body assign extra_parameter goto_arguments goto_extra_parameter type goto_parameters expression cond term compare 
%left MULTIPLY DIVIDE MODULE NOT_EQUAL AND OR SUBSTRACT ADD IS_EQUAL G_THAN GE_THAN L_THAN LE_THAN 

%%

start : methods {
	$$ = $1;
	print_headers();
	print_tree($$);
};


parameters : extra_parameter COMMA parameters {
	$$ = new_node("parameters");
	node_attach($$, $1);
	node_attach($$, new_node_with_val(NULL, Tcomma));
	node_attach($$, $3);
} | extra_parameter {
	$$ = new_node("parameters");
	node_attach($$, $1);
};

extra_parameter : type ID {
	$$ = new_node("extra_parameter");
	node_attach($$, $1);
	node_attach($$, new_node_with_val($2, Tid));
};

goto_arguments : goto_parameters {
	$$ = new_node("goto_arguments");
	node_attach($$, $1); 
} | {
	$$ = NULL;
};

body : sentences {
	$$ = new_node("body");
	node_attach($$, $1);
	} | {
	$$ = NULL;
};

sentences : extra_sentence sentences {
	$$ = new_node("sentences");
	node_attach($$, $1); node_attach($$, $2);
	} | extra_sentence {
	$$ = new_node("sentences");
	node_attach($$, $1);
};

methods : extra_function methods {
	$$ = new_node("methods");
	node_attach($$, $1);
	node_attach($$, $2);
} | main {
	$$ = new_node("methods");
	node_attach($$, $1);
};

goto_parameters : goto_extra_parameter COMMA goto_parameters {
	$$ = new_node("goto_parameters");
	node_attach($$, $1);
	node_attach($$, new_node_with_val(NULL, Tcomma));
	node_attach($$, $3);
} | goto_extra_parameter {
	$$ = new_node("goto_parameters");
	node_attach($$, $1);
};

goto_extra_parameter: expression {
	$$ = new_node("goto_extra_parameter");
	node_attach($$, $1);
} | boolean {
	$$ = new_node("goto_extra_parameter");
	node_attach($$, $1);
} | TSTRING {
	$$ = new_node_with_val($1, Tstring_E);
};


type: INT {
	$$ = new_node_with_val(NULL, Tint);
} | BOOLEAN {
	$$ = new_node_with_val(NULL, Tboolean);
} | STRING {
	$$ = new_node_with_val(NULL, Tstring);
};

boolean : TRUE_BOOL {
	$$ = new_node_with_val(NULL, Ttrue);
} | FALSE_BOOL {
	$$ = new_node_with_val(NULL, Tfalse);
};


assign : ID EQUAL expression {
	$$ = new_node("assign");
	node_attach($$, new_node_with_val($1, Tid));
	node_attach($$, new_node_with_val(NULL, Tequal));
	node_attach($$, $3);
} | ID EQUAL TSTRING {
	$$ = new_node("assign");
	node_attach($$, new_node_with_val($1, Tid));
	node_attach($$, new_node_with_val(NULL, Tequal));
	node_attach($$, new_node_with_val($3, Tstring_E));
} | ID EQUAL boolean {
	$$ = new_node("assign");
	node_attach($$, new_node_with_val($1, Tid));
	node_attach($$, new_node_with_val(NULL, Tequal));
	node_attach($$, $3);
};

expression : ID {
	$$ = new_node_with_val($1, Tid);
}| NUM {
	$$ = new_node_with_val($1, Tint_E); 
} | goto {
	$$ = new_node("expression");
	node_attach($$, $1);
} | expression ADD expression {
	$$ = new_node("expression");
	node_attach($$, $1);
	node_attach($$, new_node_with_val(NULL, Tadd));
	node_attach($$, $3);
} | expression SUBSTRACT expression {
	$$ = new_node("expression");
	node_attach($$, $1);
	node_attach($$, new_node_with_val(NULL, Tsubstract));
	node_attach($$, $3);
} | expression MULTIPLY expression {
	$$ = new_node("expression");
	node_attach($$, $1);
	node_attach($$, new_node_with_val(NULL, Tmultiply));
	node_attach($$, $3);
} | expression DIVIDE expression {
	$$ = new_node("expression");
	node_attach($$, $1);
	node_attach($$, new_node_with_val(NULL, Tdivide));
	node_attach($$, $3);
} | expression MODULE expression {
	$$ = new_node("expression");
	node_attach($$, $1);
	node_attach($$, new_node_with_val(NULL, Tmodule));
	node_attach($$, $3);
};

compare : IS_EQUAL {
	$$ = new_node("compare");
	node_attach($$, new_node_with_val(NULL, Tisequal));
} | NOT_EQUAL {
	$$ = new_node("compare");
	node_attach($$, new_node_with_val(NULL, Tdiff));
} | G_THAN {
	$$ = new_node("compare");
	node_attach($$, new_node_with_val(NULL, Tgthan));
} | GE_THAN {
	$$ = new_node("compare");
	node_attach($$, new_node_with_val(NULL, Tgethan));
} | L_THAN {
	$$ = new_node("compare");
	node_attach($$, new_node_with_val(NULL, Tlthan));
} | LE_THAN {
	$$ = new_node("compare");
	node_attach($$, new_node_with_val(NULL, Tlethan));
};


goto : ID L_PAREN goto_arguments R_PAREN {
	$$ = new_node("goto");
	node_attach($$, new_node_with_val($1, Tid));
	node_attach($$, new_node_with_val(NULL, Tlparen));
	node_attach($$, $3);
	node_attach($$, new_node_with_val(NULL, Trparen));
} | PRINT L_PAREN goto_arguments R_PAREN {
	$$ = new_node("goto");
	node_attach($$, new_node_with_val(NULL, Tprint));
	node_attach($$, new_node_with_val(NULL, Tlparen));
	node_attach($$, $3);
	node_attach($$, new_node_with_val(NULL, Trparen));
} | READ L_PAREN goto_arguments R_PAREN {
	$$ = new_node("goto");
	node_attach($$, new_node_with_val(NULL, Treadbuff));
	node_attach($$, new_node_with_val(NULL, Tlparen));
	node_attach($$, $3);
	node_attach($$, new_node_with_val(NULL, Trparen));
};

main : MAIN L_PAREN R_PAREN L_BRACK body EXIT R_BRACK {
	$$ = new_node("main");
	node_attach($$, new_node_with_val(NULL, Tmain));
	node_attach($$, new_node_with_val(NULL, Tlparen));
	node_attach($$, new_node_with_val(NULL, Trparen));
	node_attach($$, new_node_with_val(NULL, Tlbrack));
	node_attach($$, $5); 
	node_attach($$, new_node_with_val(NULL, Tfreebuff));
	node_attach($$, new_node_with_val(NULL, Trbrack));
};

return : RETURN expression {
	$$ = new_node("return");
	node_attach($$, new_node_with_val(NULL, Treturn));
	node_attach($$, $2);
} | RETURN TSTRING {
	$$ = new_node("return");
	node_attach($$, new_node_with_val(NULL, Treturn));
	node_attach($$, new_node_with_val($2, Tstring_E));
} | RETURN cond {
	$$ = new_node("return");
	node_attach($$, new_node_with_val(NULL, Treturn));
	node_attach($$, $2);
}; 


extra_function : type ID L_PAREN arguments R_PAREN L_BRACK body R_BRACK {
	$$ = new_node("extra_function");
	node_attach($$, $1);
	node_attach($$, new_node_with_val($2, Tid));
	node_attach($$, new_node_with_val(NULL, Tlparen));
	node_attach($$, $4);
	node_attach($$, new_node_with_val(NULL, Trparen));
	node_attach($$, new_node_with_val(NULL, Tlbrack));
	node_attach($$, $7);
	node_attach($$, new_node_with_val(NULL, Trbrack));
};

if : IF L_PAREN cond R_PAREN L_BRACK body R_BRACK {
	$$ = new_node("if");
	node_attach($$, new_node_with_val(NULL, Tif));
	node_attach($$, new_node_with_val(NULL, Tlparen));
	node_attach($$, $3);
	node_attach($$, new_node_with_val(NULL, Trparen));
	node_attach($$, new_node_with_val(NULL, Tlbrack));
	node_attach($$, $6);
	node_attach($$, new_node_with_val(NULL, Trbrack));
};

while : WHILE L_PAREN cond R_PAREN L_BRACK body R_BRACK {
	$$ = new_node("while");
	node_attach($$, new_node_with_val(NULL, Twhile));
	node_attach($$, new_node_with_val(NULL, Tlparen));
	node_attach($$, $3);
	node_attach($$, new_node_with_val(NULL, Trparen));
	node_attach($$, new_node_with_val(NULL, Tlbrack));
	node_attach($$, $6);
	node_attach($$, new_node_with_val(NULL, Trbrack));
};


extra_sentence : assign END_LINE {
	$$ = new_node("extra_sentence");
	node_attach($$, $1);
	node_attach($$, new_node_with_val(NULL, Tsemicolon));
} | declare END_LINE {
	$$ = new_node("extra_sentence");
	node_attach($$, $1);
	node_attach($$, new_node_with_val(NULL, Tsemicolon));
} | goto END_LINE {
	$$ = new_node("extra_sentence");
	node_attach($$, $1);
	node_attach($$, new_node_with_val(NULL, Tsemicolon));
} | return END_LINE {
	$$ = new_node("extra_sentence");
	node_attach($$, $1);
	node_attach($$, new_node_with_val(NULL, Tsemicolon));
} | if {
	$$ = new_node("extra_sentence");
	node_attach($$, $1);
} | while {
	$$ = new_node("extra_sentence");
	node_attach($$, $1);
}

arguments : parameters {
	$$ = new_node("arguments");
	node_attach($$, $1);
} | {
	$$ = NULL;
};

declare : INT ID EQUAL expression {
	$$ = new_node("declare");
	node_attach($$, new_node_with_val(NULL, Tint));
	node_attach($$, new_node_with_val($2, Tid));
	node_attach($$, new_node_with_val(NULL, Tequal));
	node_attach($$, $4);
} | BOOLEAN ID EQUAL boolean {
	$$ = new_node("declare");
	node_attach($$, new_node_with_val(NULL, Tboolean));
	node_attach($$, new_node_with_val($2, Tid));
	node_attach($$, new_node_with_val(NULL, Tequal));
	node_attach($$, $4);
} | BOOLEAN ID EQUAL goto {
	$$ = new_node("declare");
	node_attach($$, new_node_with_val(NULL, Tboolean));
	node_attach($$, new_node_with_val($2, Tid));
	node_attach($$, new_node_with_val(NULL, Tequal));
	node_attach($$, $4);
} | STRING ID EQUAL TSTRING {
	$$ = new_node("declare");
	node_attach($$, new_node_with_val(NULL, Tstring));
	node_attach($$, new_node_with_val($2, Tid));
	node_attach($$, new_node_with_val(NULL, Tequal));
	node_attach($$, new_node_with_val($4, Tstring_E));
} | STRING ID EQUAL goto {
	$$ = new_node("declare");
	node_attach($$, new_node_with_val(NULL, Tstring));
	node_attach($$, new_node_with_val($2, Tid));
	node_attach($$, new_node_with_val(NULL, Tequal));
	node_attach($$, $4);
} | type ID EQUAL ID {
	$$ = new_node("declare");
	node_attach($$, $1);
	node_attach($$, new_node_with_val($2, Tid));
	node_attach($$, new_node_with_val(NULL, Tequal));
	node_attach($$, new_node_with_val($4, Tid));
};

cond : term {
	$$ = new_node("cond");
	node_attach($$, $1);
} | cond AND cond {
	$$ = new_node("cond");
	node_attach($$, $1);
	node_attach($$, new_node_with_val(NULL, Tand));
	node_attach($$, $3);
} | cond OR cond {
	$$ = new_node("cond");
	node_attach($$, $1);
	node_attach($$, new_node_with_val(NULL, Tor));
	node_attach($$, $3);
} | NOT cond {
	$$ = new_node("cond");
	node_attach($$, new_node_with_val(NULL, Tnot));
	node_attach($$, $2);
};

term : boolean {
	$$ = new_node("term");
	node_attach($$, $1);
} | expression compare expression {
	$$ = new_node("term");
	node_attach($$, $1);
	node_attach($$, $2);
	node_attach($$, $3);
} | goto {
	$$ = new_node("term");
	node_attach($$, $1);
} | ID {
	$$ = new_node("term");
	node_attach($$, new_node_with_val($1, Tid));
};

%%

int main() {
  yyparse();
  return 0;
}

void yyerror(char * s) {
  fprintf(stderr, "%s\n", s);
  return;
}
