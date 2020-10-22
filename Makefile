tudo: mcalc direto dinamico.rkt

mcalc: mcalc.tab.o lex.yy.o main.o 
	gcc -o $@ $^  -lfl

mcalc.tab.o: mcalc.y
	bison -dv mcalc.y
	gcc -c mcalc.tab.c

lex.yy.o: mcalc.l
	flex mcalc.l
	gcc -c lex.yy.c

direto: direto.rkt
	raco exe $<

dinamico.rkt: mcalc direto.rkt stdlib repl-start.rkt repl-end.rkt
	cat direto.rkt > dinamico.rkt
	cat repl-start.rkt >> dinamico.rkt
	cat stdlib | ./mcalc >> dinamico.rkt
	cat repl-end.rkt >> dinamico.rkt

clean:
	rm -f *.o lex.yy.c mcalc mcalc.tab.c mcalc.tab.h direto mcalc.output dinamico.rkt *~
