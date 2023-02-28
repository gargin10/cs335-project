parse: parser.y lexer.l
	bison -dtv parser.y
	flex lexer.l
	g++ -w lex.yy.c parser.tab.c -o myASTGenerator

clean:
	rm myASTGenerator
	rm parser.tab.c parser.tab.h parser.output
	rm lex.yy.c
