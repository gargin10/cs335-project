parse: parser.y lexer.l
	bison -dtvg parser.y
	flex lexer.l
	g++ lex.yy.c parser.tab.c

clean:
	rm a.out
	rm parser.tab.c parser.tab.h
	rm lex.yy.c
