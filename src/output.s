	.text
	.globl  main
	.type   main, @function
main: 
	endbr64
	pushq   %rbp
	movq    %rsp, %rbp
	movl    $23, %edx
	sarl    $3, %edx
	cmpl    $0, %edx
	jge     $Lurs1
	movl    $3, %eax
	notl    %eax
	sall    %eax, $2
	addl    %eax, %edx
$Lurs1:
	movl    %edx, -20(%rbp)
	movl    -20(%rbp), %eax
	movl    %eax, -16(%rbp)
	movl    $25, %edx
	negl    %edx
	movl    %edx, -12(%rbp)
	movl    -12(%rbp), %edx
	sarl    $3, %edx
	cmpl    $0, %edx
	jge     $Lurs2
	movl    $3, %eax
	notl    %eax
	sall    %eax, $2
	addl    %eax, %edx
$Lurs2:
	movl    %edx, -8(%rbp)
	movl    -8(%rbp), %eax
	movl    %eax, -4(%rbp)
	movq    $0, %rax
	movq    %rbp, %rsp
	popq    %rbp
	ret
