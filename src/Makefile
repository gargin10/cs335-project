parse: parser.y lexer.l
	bison -dtv parser.y
	flex lexer.l
	g++ -w lex.yy.c parser.tab.c -o milestone4

run:	
	gcc code_gen.s -o code_gen
	./code_gen

test1:
	./milestone4 ../tests/test_1.java

test2:
	./milestone4 ../tests/test_2.java

test3:
	./milestone4 ../tests/test_3.java

test4:
	./milestone4 ../tests/test_4.java

test5:
	./milestone4 ../tests/test_5.java

test6:
	./milestone4 ../tests/test_6.java

test7:
	./milestone4 ../tests/test_7.java

test8:
	./milestone4 ../tests/test_8.java

test9:
	./milestone4 ../tests/test_9.java

test10:
	./milestone4 ../tests/test_10.java

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
	rm output.3ac code_gen.s
	rm code_gen