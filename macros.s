%line 1+1 calc.s
[section .rodata]
 overflowMsg: db "Error: Operand Stack Overflow",10,0
 underflowMsg: db "Error: Insufficient Number of Arguments on Stack",10,0
 format_string: db "%d", 10, 0
 hexa_format: db "%X",0
 string_format: db "%s",0
 mynew_line: db "",10,0

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
 push ebx
%line 192+0 calc.s
 push ecx
 push edx
 push dword [stackBase]
 call free
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 193+1 calc.s
 mov ebx, 0
 mov eax, 1
 int 0x80


posh:
 push ebp
 mov ebp, esp

 mov eax, [size]
 cmp eax , [capacity]
 je overflow
 add dword [size],1
%line 205+0 calc.s
 add byte [stack], 4
 mov eax, [stack]
 mov dword [eax], dword 0
%line 206+1 calc.s
 mov edx, buff
 b2:

%line 208+0 calc.s
 mov eax, buff
 ..@26.looop:
 cmp byte [eax], 0
 je ..@26.endofstring
 inc eax
 jmp ..@26.looop
 ..@26.endofstring:
 sub eax , buff
 and eax, 1
%line 209+1 calc.s
 cmp eax,0
 je evenlength
 oddlength:
 mov eax, 0
%line 212+0 calc.s
 mov al, byte [edx]
 cmp eax, 0x41
 jge ..@28.itA_F
 sub eax, 0x30
 jmp ..@28.it0_9
 ..@28.itA_F:
 sub eax, 0x41
 add eax, 10
 ..@28.it0_9:
%line 213+1 calc.s
 mov ecx, eax


%line 215+0 calc.s
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
%line 216+1 calc.s
 add edx, 1
 b3:
 evenlength:
 cmp byte [edx], 0
 je end_posh
 mov eax, 0
%line 221+0 calc.s
 mov al, [edx]
 cmp eax, 0x41
 jge ..@32.itA_F
 sub eax, 0x30
 jmp ..@32.it0_9
 ..@32.itA_F:
 sub eax, 0x41
 add eax, 10
 ..@32.it0_9:
 mov ebx, 0
 mov bl, [edx+1]
 cmp ebx, 0x41
 jge ..@33.itA_F
 sub ebx, 0x30
 jmp ..@33.it0_9
 ..@33.itA_F:
 sub ebx, 0x41
 add ebx, 10
 ..@33.it0_9:
 shl eax, 4
 add eax, ebx
%line 222+1 calc.s
 mov ecx, eax


%line 224+0 calc.s
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
%line 225+1 calc.s
 add edx, 2
 jmp evenlength
 end_posh:
 mov esp, ebp
 pop ebp
 ret
 overflow:
 pushad
%line 232+0 calc.s
 push dword overflowMsg
 push string_format
 call printf
 add esp, 8
 popad
%line 233+1 calc.s
 jmp main_loop

poop:
 push ebp
 mov ebp, esp
 mov eax, [size]
 cmp eax, 0
 je underflow

%line 241+0 calc.s

 mov eax, dword [stack]
 mov eax, dword [eax]
%line 242+1 calc.s
 pushad
 push eax
 call printNumList
 add esp, 4
 popad
 push ebx
%line 247+0 calc.s
 push ecx
 push edx
 push dword eax
 call free
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 248+1 calc.s
 sub dword [size], 1
%line 248+0 calc.s
 sub byte [stack], 4
%line 249+1 calc.s
 mov esp, ebp
 pop ebp
 pushad
%line 251+0 calc.s
 push dword mynew_line
 push string_format
 call printf
 add esp, 8
 popad
%line 252+1 calc.s
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
 mov esp, ebp
 pop ebp
 ret

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
%line 274+0 calc.s
 push dword ebx
 push hexa_format
 call printf
 add esp, 8
 popad
%line 275+1 calc.s
 mov eax, dword [eax+1]
 push ebx
%line 276+0 calc.s
 push ecx
 push edx
 push dword eax
 call free
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 277+1 calc.s
 .end:
 mov esp, ebp
 pop ebp
 ret

parseCommand:
 push ebp
 mov ebp, esp
 mov eax, 0
 mov al, byte [buff]
 cmp eax ,0x70
 je user_wants_to_poop
 cmp eax, 0x71
 je myexit
 call posh
 jmp end_p
 user_wants_to_poop:
 call poop
 end_p:
 mov esp, ebp
 pop ebx
 ret

