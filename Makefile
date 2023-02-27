parse: parser.y lexer.l
	bison -dtvg parser.y
	flex lexer.l
	g++ -w lex.yy.c parser.tab.c -o out

clean:
	rm a.out
	rm parser.tab.c parser.tab.h
	rm lex.yy.c
