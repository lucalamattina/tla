GCC=gcc
YACCOBJ=Grammatik.y
YACC=yacc
LEXOBJ=Übersetzer.l
LEX=lex
PARSER_FILES=node.c lex.yy.c y.tab.c
OUTPUT=erstellen
OUTOBJS=lex.yy.c y.tab.c y.tab.h

all: yacc lex parser unused

yacc: 
	$(YACC) -d $(YACCOBJ)

lex: 
	$(LEX) $(LEXOBJ)

parser:
	$(GCC) -o $(OUTPUT) $(PARSER_FILES)

clean: 
	rm -f $(OUTOBJS) $(OUTPUT)

unused:
	rm -f $(OUTOBJS)

.PHONY: all clean
