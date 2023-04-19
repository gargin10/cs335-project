parse: parser.y lexer.l
	bison -dtv parser.y
	flex lexer.l
	g++ -w lex.yy.c parser.tab.c -o milestone4
	
test:
	./milestone4 ../tests/test_1.java
	./milestone4 ../tests/test_2.java
	./milestone4 ../tests/test_3.java
	./milestone4 ../tests/test_4.java
	./milestone4 ../tests/test_5.java
	./milestone4 ../tests/test_6.java
	./milestone4 ../tests/test_7.java
	./milestone4 ../tests/test_8.java
	./milestone4 ../tests/test_9.java
	./milestone4 ../tests/test_10.java

clean:
	rm output/*
	rm milestone4
	rm parser.tab.c parser.tab.h parser.output
	rm lex.yy.c
	rm symbol_table.txt output.dot