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

%line 146+1 calc.s
[section .text]
[sectalign 16]
%line 147+0 calc.s
times (((16) - (($-$$) % (16))) % (16)) nop
%line 148+1 calc.s
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

%line 167+0 calc.s
 mov eax, ecx
 ..@16.looop:
 cmp byte [eax], 0
 je ..@16.endofstring
 inc eax
 jmp ..@16.looop
 ..@16.endofstring:
 sub eax , ecx
 and eax, 1
%line 168+1 calc.s
 cmp eax, 1
 je odd
 jmp even
 odd:
 mov eax, 0
%line 172+0 calc.s
 mov al, byte [ecx]
 cmp eax, 0x41
 jge ..@18.itA_F
 sub eax, 0x30
 jmp ..@18.it0_9
 ..@18.itA_F:
 sub eax, 0x41
 add eax, 10
 ..@18.it0_9:
%line 173+1 calc.s
 jmp updateCapacity
 even:
 mov eax, 0
%line 175+0 calc.s
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
%line 176+1 calc.s
 updateCapacity:
 mov [capacity], eax
 push dword [capacity]
%line 178+0 calc.s
 push format_string
 call printf
%line 179+1 calc.s
 init_stack:
 push dword 4
 push dword [capacity]
 call calloc
 mov [stack], eax
 mov [stackBase], eax


 main_loop:
 pushad
%line 188+0 calc.s
 push buff
 call gets
 add esp, 4
 popad
%line 189+1 calc.s
 call parseCommand
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
%line 203+0 calc.s
 add byte [stack], 4
 mov eax, [stack]
 mov dword [eax], dword 0
%line 204+1 calc.s
 mov edx, buff
 b2:

%line 206+0 calc.s
 mov eax, buff
 ..@25.looop:
 cmp byte [eax], 0
 je ..@25.endofstring
 inc eax
 jmp ..@25.looop
 ..@25.endofstring:
 sub eax , buff
 and eax, 1
%line 207+1 calc.s
 cmp eax,0
 je evenlength
 oddlength:
 mov eax, 0
%line 210+0 calc.s
 mov al, byte [edx]
 cmp eax, 0x41
 jge ..@27.itA_F
 sub eax, 0x30
 jmp ..@27.it0_9
 ..@27.itA_F:
 sub eax, 0x41
 add eax, 10
 ..@27.it0_9:
%line 211+1 calc.s
 mov ecx, eax


%line 213+0 calc.s
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
%line 214+1 calc.s
 add edx, 1
 b3:
 evenlength:
 cmp byte [edx], 0
 je end_posh
 mov eax, 0
%line 219+0 calc.s
 mov al, [edx]
 cmp eax, 0x41
 jge ..@31.itA_F
 sub eax, 0x30
 jmp ..@31.it0_9
 ..@31.itA_F:
 sub eax, 0x41
 add eax, 10
 ..@31.it0_9:
 mov ebx, 0
 mov bl, [edx+1]
 cmp ebx, 0x41
 jge ..@32.itA_F
 sub ebx, 0x30
 jmp ..@32.it0_9
 ..@32.itA_F:
 sub ebx, 0x41
 add ebx, 10
 ..@32.it0_9:
 shl eax, 4
 add eax, ebx
%line 220+1 calc.s
 mov ecx, eax


%line 222+0 calc.s
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
%line 223+1 calc.s
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


%line 242+0 calc.s

 mov eax, dword [stack]
 mov eax, dword [eax]
%line 243+1 calc.s
 push eax
 call printNumList
 add esp, 4

 sub dword [size], 1
%line 247+0 calc.s
 sub byte [stack], 4
%line 248+1 calc.s

 mov esp, ebp
 pop ebp

 ret

 underflow:
 pushad
%line 255+0 calc.s
 push dword underflowMsg
 push string_format
 call printf
 add esp, 8
 popad
%line 256+1 calc.s
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
%line 274+0 calc.s
 push ecx
 push edx
 push dword eax
 call free
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 275+1 calc.s
 .end:
 mov esp, ebp
 pop ebx
 ret

parseCommand:
 push ebp
 mov ebp, esp
 mov eax, 0
 mov al, byte [buff]
 cmp eax ,0x70
 je user_wants_to_poop
 call posh
 jmp end_p
 user_wants_to_poop:
 call poop
 end_p:
 mov esp, ebp
 pop ebx
 ret

