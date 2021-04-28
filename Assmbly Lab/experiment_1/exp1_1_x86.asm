
a.out:	file format mach-o 64-bit x86-64


Disassembly of section __TEXT,__text:

0000000100003eb0 <_main>:
100003eb0: 55                          	pushq	%rbp
100003eb1: 48 89 e5                    	movq	%rsp, %rbp
100003eb4: 48 83 ec 20                 	subq	$32, %rsp
100003eb8: c7 45 fc 00 00 00 00        	movl	$0, -4(%rbp)
100003ebf: c7 45 ec 00 00 00 00        	movl	$0, -20(%rbp)
100003ec6: 48 8d 3d db 00 00 00        	leaq	219(%rip), %rdi  # 100003fa8 <dyld_stub_binder+0x100003fa8>
100003ecd: 48 8d 75 f8                 	leaq	-8(%rbp), %rsi
100003ed1: b0 00                       	movb	$0, %al
100003ed3: e8 a6 00 00 00              	callq	0x100003f7e <dyld_stub_binder+0x100003f7e>
100003ed8: 48 8d 3d c9 00 00 00        	leaq	201(%rip), %rdi  # 100003fa8 <dyld_stub_binder+0x100003fa8>
100003edf: 48 8d 75 f4                 	leaq	-12(%rbp), %rsi
100003ee3: 89 45 e8                    	movl	%eax, -24(%rbp)
100003ee6: b0 00                       	movb	$0, %al
100003ee8: e8 91 00 00 00              	callq	0x100003f7e <dyld_stub_binder+0x100003f7e>
100003eed: 83 7d f8 00                 	cmpl	$0, -8(%rbp)
100003ef1: 0f 8d 08 00 00 00           	jge	0x100003eff <_main+0x4f>
100003ef7: 31 c0                       	xorl	%eax, %eax
100003ef9: 2b 45 f8                    	subl	-8(%rbp), %eax
100003efc: 89 45 f8                    	movl	%eax, -8(%rbp)
100003eff: 83 7d f4 00                 	cmpl	$0, -12(%rbp)
100003f03: 0f 8d 08 00 00 00           	jge	0x100003f11 <_main+0x61>
100003f09: 31 c0                       	xorl	%eax, %eax
100003f0b: 2b 45 f4                    	subl	-12(%rbp), %eax
100003f0e: 89 45 f4                    	movl	%eax, -12(%rbp)
100003f11: 8b 45 f4                    	movl	-12(%rbp), %eax
100003f14: 3b 45 f8                    	cmpl	-8(%rbp), %eax
100003f17: 0f 8e 12 00 00 00           	jle	0x100003f2f <_main+0x7f>
100003f1d: 8b 45 f8                    	movl	-8(%rbp), %eax
100003f20: 89 45 f0                    	movl	%eax, -16(%rbp)
100003f23: 8b 45 f4                    	movl	-12(%rbp), %eax
100003f26: 89 45 f8                    	movl	%eax, -8(%rbp)
100003f29: 8b 45 f0                    	movl	-16(%rbp), %eax
100003f2c: 89 45 f4                    	movl	%eax, -12(%rbp)
100003f2f: c7 45 f0 00 00 00 00        	movl	$0, -16(%rbp)
100003f36: 8b 45 f0                    	movl	-16(%rbp), %eax
100003f39: 3b 45 f4                    	cmpl	-12(%rbp), %eax
100003f3c: 0f 8f 17 00 00 00           	jg	0x100003f59 <_main+0xa9>
100003f42: 8b 45 f0                    	movl	-16(%rbp), %eax
100003f45: 03 45 ec                    	addl	-20(%rbp), %eax
100003f48: 89 45 ec                    	movl	%eax, -20(%rbp)
100003f4b: 8b 45 f0                    	movl	-16(%rbp), %eax
100003f4e: 83 c0 01                    	addl	$1, %eax
100003f51: 89 45 f0                    	movl	%eax, -16(%rbp)
100003f54: e9 dd ff ff ff              	jmp	0x100003f36 <_main+0x86>
100003f59: 8b 75 ec                    	movl	-20(%rbp), %esi
100003f5c: 48 8d 3d 45 00 00 00        	leaq	69(%rip), %rdi  # 100003fa8 <dyld_stub_binder+0x100003fa8>
100003f63: b0 00                       	movb	$0, %al
100003f65: e8 0e 00 00 00              	callq	0x100003f78 <dyld_stub_binder+0x100003f78>
100003f6a: 31 c9                       	xorl	%ecx, %ecx
100003f6c: 89 45 e4                    	movl	%eax, -28(%rbp)
100003f6f: 89 c8                       	movl	%ecx, %eax
100003f71: 48 83 c4 20                 	addq	$32, %rsp
100003f75: 5d                          	popq	%rbp
100003f76: c3                          	retq

Disassembly of section __TEXT,__stubs:

0000000100003f78 <__stubs>:
100003f78: ff 25 82 40 00 00           	jmpq	*16514(%rip)  # 100008000 <dyld_stub_binder+0x100008000>
100003f7e: ff 25 84 40 00 00           	jmpq	*16516(%rip)  # 100008008 <dyld_stub_binder+0x100008008>

Disassembly of section __TEXT,__stub_helper:

0000000100003f84 <__stub_helper>:
100003f84: 4c 8d 1d 85 40 00 00        	leaq	16517(%rip), %r11  # 100008010 <__dyld_private>
100003f8b: 41 53                       	pushq	%r11
100003f8d: ff 25 6d 00 00 00           	jmpq	*109(%rip)  # 100004000 <dyld_stub_binder+0x100004000>
100003f93: 90                          	nop
100003f94: 68 00 00 00 00              	pushq	$0
100003f99: e9 e6 ff ff ff              	jmp	0x100003f84 <__stub_helper>
100003f9e: 68 0e 00 00 00              	pushq	$14
100003fa3: e9 dc ff ff ff              	jmp	0x100003f84 <__stub_helper>

Disassembly of section __TEXT,__cstring:

0000000100003fa8 <__cstring>:
100003fa8: 25                          	<unknown>
100003fa9: 64 00                       	<unknown>

Disassembly of section __TEXT,__unwind_info:

0000000100003fac <__unwind_info>:
100003fac: 01 00                       	addl	%eax, (%rax)
100003fae: 00 00                       	addb	%al, (%rax)
100003fb0: 1c 00                       	sbbb	$0, %al
100003fb2: 00 00                       	addb	%al, (%rax)
100003fb4: 00 00                       	addb	%al, (%rax)
100003fb6: 00 00                       	addb	%al, (%rax)
100003fb8: 1c 00                       	sbbb	$0, %al
100003fba: 00 00                       	addb	%al, (%rax)
100003fbc: 00 00                       	addb	%al, (%rax)
100003fbe: 00 00                       	addb	%al, (%rax)
100003fc0: 1c 00                       	sbbb	$0, %al
100003fc2: 00 00                       	addb	%al, (%rax)
100003fc4: 02 00                       	addb	(%rax), %al
100003fc6: 00 00                       	addb	%al, (%rax)
100003fc8: b0 3e                       	movb	$62, %al
100003fca: 00 00                       	addb	%al, (%rax)
100003fcc: 34 00                       	xorb	$0, %al
100003fce: 00 00                       	addb	%al, (%rax)
100003fd0: 34 00                       	xorb	$0, %al
100003fd2: 00 00                       	addb	%al, (%rax)
100003fd4: 78 3f                       	js	0x100004015 <dyld_stub_binder+0x100004015>
100003fd6: 00 00                       	addb	%al, (%rax)
100003fd8: 00 00                       	addb	%al, (%rax)
100003fda: 00 00                       	addb	%al, (%rax)
100003fdc: 34 00                       	xorb	$0, %al
100003fde: 00 00                       	addb	%al, (%rax)
100003fe0: 03 00                       	addl	(%rax), %eax
100003fe2: 00 00                       	addb	%al, (%rax)
100003fe4: 0c 00                       	orb	$0, %al
100003fe6: 01 00                       	addl	%eax, (%rax)
100003fe8: 10 00                       	adcb	%al, (%rax)
100003fea: 01 00                       	addl	%eax, (%rax)
100003fec: 00 00                       	addb	%al, (%rax)
100003fee: 00 00                       	addb	%al, (%rax)
100003ff0: 00 00                       	addb	%al, (%rax)
100003ff2: 00 01                       	addb	%al, (%rcx)

Disassembly of section __DATA_CONST,__got:

0000000100004000 <__got>:
		...

Disassembly of section __DATA,__la_symbol_ptr:

0000000100008000 <__la_symbol_ptr>:
100008000: 94                          	xchgl	%esp, %eax
100008001: 3f                          	<unknown>
100008002: 00 00                       	addb	%al, (%rax)
100008004: 01 00                       	addl	%eax, (%rax)
100008006: 00 00                       	addb	%al, (%rax)
100008008: 9e                          	sahf
100008009: 3f                          	<unknown>
10000800a: 00 00                       	addb	%al, (%rax)
10000800c: 01 00                       	addl	%eax, (%rax)
10000800e: 00 00                       	addb	%al, (%rax)

Disassembly of section __DATA,__data:

0000000100008010 <__dyld_private>:
		...
