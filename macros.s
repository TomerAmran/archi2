%line 1+1 calc.s
[section .rodata]
 overflowMsg: db "Error: Operand Stack Overflow",10,0
 underflowMsg: db "Error: Insufficient Number of Arguments on Stack",10,0
 format_string: db "%d", 10, 0
 hexa_format: db "%X",0
 string_format: db "%s",0
 new_line: db 10

[section .data]
 size: dd 0
 capacity: dd 5
[section .bss]
 stack: resd 1
 stackBase: resd 1

 buff: resb 81

%line 139+1 calc.s
[section .text]
[sectalign 16]
%line 140+0 calc.s
times (((16) - (($-$$) % (16))) % (16)) nop
%line 141+1 calc.s
[global main]
[extern printf]
[extern fprintf]
[extern fflush]
[extern malloc]
[extern calloc]
[extern free]
[extern gets]
[extern getchar]
[extern fgets]
main:

 mov eax, [esp+4]
 cmp eax, 1
 jg update_stack_size
 jmp init_stack
 update_stack_size:
 mov eax, [esp+8]
 mov ecx, [eax+4]

%line 160+0 calc.s
 mov eax, ecx
 ..@16.looop:
 cmp byte [eax], 0
 je ..@16.endofstring
 inc eax
 jmp ..@16.looop
 ..@16.endofstring:
 sub eax , ecx
 and eax, 1
%line 161+1 calc.s
 cmp eax, 1
 je odd
 jmp even
 odd:
 mov eax, 0
%line 165+0 calc.s
 mov al, byte [ecx]
 cmp eax, 0x41
 jge ..@18.itA_F
 sub eax, 0x30
 jmp ..@18.it0_9
 ..@18.itA_F:
 sub eax, 0x41
 add eax, 10
 ..@18.it0_9:
%line 166+1 calc.s
 jmp updateCapacity
 even:
 mov eax, 0
%line 168+0 calc.s
 mov al, [ecx]
 cmp eax, 0x41
 jge ..@20.itA_F
 sub eax, 0x30
 jmp ..@20.it0_9
 ..@20.itA_F:
 sub eax, 0x41
 add eax, 10
 ..@20.it0_9:
 mov ebx, 0
 mov bl, [ecx+1]
 cmp ebx, 0x41
 jge ..@21.itA_F
 sub ebx, 0x30
 jmp ..@21.it0_9
 ..@21.itA_F:
 sub ebx, 0x41
 add ebx, 10
 ..@21.it0_9:
 shl eax, 4
 add eax, ebx
%line 169+1 calc.s
 updateCapacity:
 mov [capacity], eax
 push dword [capacity]
%line 171+0 calc.s
 push format_string
 call printf
%line 172+1 calc.s
 init_stack:
 push dword 4
 push dword [capacity]
 call calloc
 mov [stack], eax
 mov [stackBase], eax


 main_loop:
 push buff
 call gets

 call posh
 call poop
 jmp main_loop
myexit:
 push dword [stackBase]
 call free
 mov ebx, 0

posh:
 push ebp
 mov ebp, esp

 mov eax, [size]
 cmp eax , [capacity]
 je overflow
 add dword [size],1
%line 199+0 calc.s
 add byte [stack], 4
 mov eax, [stack]
 mov dword [eax], dword 0
%line 200+1 calc.s
 mov edx, buff
 b2:

%line 202+0 calc.s
 mov eax, buff
 ..@24.looop:
 cmp byte [eax], 0
 je ..@24.endofstring
 inc eax
 jmp ..@24.looop
 ..@24.endofstring:
 sub eax , buff
 and eax, 1
%line 203+1 calc.s
 cmp eax,0
 je evenlength
 oddlength:
 mov eax, 0
%line 206+0 calc.s
 mov al, byte [edx]
 cmp eax, 0x41
 jge ..@26.itA_F
 sub eax, 0x30
 jmp ..@26.it0_9
 ..@26.itA_F:
 sub eax, 0x41
 add eax, 10
 ..@26.it0_9:
%line 207+1 calc.s
 mov ecx, eax


%line 209+0 calc.s
 push ebx
 push ecx
 push edx
 push dword 5
 call malloc
 add esp, 4
 pop edx
 pop ecx
 pop ebx
 mov ebx, dword [stack]
 mov ebx, dword [ebx]
 mov [eax], byte ecx
 mov [eax+1], dword ebx
 mov ebx, dword [stack]
 mov [ebx], dword eax
%line 210+1 calc.s
 add edx, 1
 b3:
 evenlength:
 cmp byte [edx], 0
 je end_posh
 mov eax, 0
%line 215+0 calc.s
 mov al, [edx]
 cmp eax, 0x41
 jge ..@30.itA_F
 sub eax, 0x30
 jmp ..@30.it0_9
 ..@30.itA_F:
 sub eax, 0x41
 add eax, 10
 ..@30.it0_9:
 mov ebx, 0
 mov bl, [edx+1]
 cmp ebx, 0x41
 jge ..@31.itA_F
 sub ebx, 0x30
 jmp ..@31.it0_9
 ..@31.itA_F:
 sub ebx, 0x41
 add ebx, 10
 ..@31.it0_9:
 shl eax, 4
 add eax, ebx
%line 216+1 calc.s
 mov ecx, eax


%line 218+0 calc.s
 push ebx
 push ecx
 push edx
 push dword 5
 call malloc
 add esp, 4
 pop edx
 pop ecx
 pop ebx
 mov ebx, dword [stack]
 mov ebx, dword [ebx]
 mov [eax], byte ecx
 mov [eax+1], dword ebx
 mov ebx, dword [stack]
 mov [ebx], dword eax
%line 219+1 calc.s
 add edx, 2
 jmp evenlength
 end_posh:
 mov esp, ebp
 pop ebp
 ret
 overflow:
 push overflowMsg
 call printf
 jmp myexit

poop:
 push ebp
 mov ebp, esp

 mov eax, [size]
 cmp eax, 0
 je underflow


%line 238+0 calc.s

 mov eax, dword [stack]
 mov eax, dword [eax]
%line 239+1 calc.s
 push eax
 call printNumList
 add esp, 4

 sub dword [size], 1
%line 243+0 calc.s
 sub byte [stack], 4
%line 244+1 calc.s

 mov esp, ebp
 pop ebp

 ret

 underflow:
 pushad
%line 251+0 calc.s
 push dword underflowMsg
 push string_format
 call printf
 add esp, 8
 popad
%line 252+1 calc.s
 jmp main_loop

printNumList:
 push ebp
 mov ebp, esp

 mov eax, [ebp+8]
 cmp eax, 0
 je .end
 mov ebx , dword[eax+1]
 pushad
 push ebx
 call printNumList
 add esp, 4
 popad

 mov ebx, 0
 mov bl , byte [eax]


 pushad
%line 272+0 calc.s
 push dword ebx
 push hexa_format
 call printf
 add esp, 8
 popad
%line 273+1 calc.s

 mov eax, [eax+1]
 push ebx
%line 275+0 calc.s
 push ecx
 push edx
 push dword eax
 call free
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 276+1 calc.s






 .end:
 mov esp, ebp
 pop ebx
 ret










































