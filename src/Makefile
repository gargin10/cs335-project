parse: parser.y lexer.l
	bison -dtv parser.y
	flex lexer.l
	g++ -w lex.yy.c parser.tab.c -o myASTGenerator
	
test:
	./myASTGenerator ../tests/test_1.java
	./myASTGenerator ../tests/test_2.java
	./myASTGenerator ../tests/test_3.java
	./myASTGenerator ../tests/test_4.java
	./myASTGenerator ../tests/test_5.java
	./myASTGenerator ../tests/test_6.java
	./myASTGenerator ../tests/test_7.java
	./myASTGenerator ../tests/test_8.java
	./myASTGenerator ../tests/test_9.java
	./myASTGenerator ../tests/test_10.java

clean:
	rm myASTGenerator
	rm parser.tab.c parser.tab.h parser.output
	rm lex.yy.c
