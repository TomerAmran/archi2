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
 X: resd 1
 Y: resd 1
 Z: resd 1
 x: resd 1
 y: resd 1
 z: resd 1

%line 182+1 calc.s
[section .text]
[sectalign 16]
%line 183+0 calc.s
times (((16) - (($-$$) % (16))) % (16)) nop
%line 184+1 calc.s
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

%line 203+0 calc.s
 mov eax, ecx
 ..@16.looop:
 cmp byte [eax], 0
 je ..@16.endofstring
 inc eax
 jmp ..@16.looop
 ..@16.endofstring:
 sub eax , ecx
 and eax, 1
%line 204+1 calc.s
 cmp eax, 1
 je odd
 jmp even
 odd:
 mov eax, 0
%line 208+0 calc.s
 mov al, byte [ecx]
 cmp eax, 0x41
 jge ..@18.itA_F
 sub eax, 0x30
 jmp ..@18.it0_9
 ..@18.itA_F:
 sub eax, 0x41
 add eax, 10
 ..@18.it0_9:
%line 209+1 calc.s
 jmp updateCapacity
 even:
 mov eax, 0
%line 211+0 calc.s
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
%line 212+1 calc.s
 updateCapacity:
 mov [capacity], eax
 push dword [capacity]
%line 214+0 calc.s
 push format_string
 call printf
%line 215+1 calc.s
 init_stack:
 push dword 4
 push dword [capacity]
 call calloc
 mov [stack], eax
 mov [stackBase], eax


 main_loop:
 pushad
%line 224+0 calc.s
 push buff
 call gets
 add esp, 4
 popad
%line 225+1 calc.s
 call parseCommand
 call Ed_Edd_n_Eddy
 jmp main_loop
myexit:
 push ebx
%line 229+0 calc.s
 push ecx
 push edx
 push dword [stackBase]
 call free
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 230+1 calc.s
 mov ebx, 0
 mov eax, 1
 int 0x80

Ed_Edd_n_Eddy:
 push ebp
 mov ebp, esp
 mov eax, [size]
 cmp eax, 2
 jl underflow

%line 240+0 calc.s

 mov eax, dword [stack]
 mov eax, dword [eax]
%line 241+1 calc.s
 mov [X], dword eax
 mov [x], dword eax
 sub dword [size], 1
%line 243+0 calc.s
 sub byte [stack], 4
%line 244+1 calc.s

%line 244+0 calc.s

 mov eax, dword [stack]
 mov eax, dword [eax]
%line 245+1 calc.s
 mov [Y], dword eax
 mov [y], dword eax
 mov ecx, 0


 mov edx, [x]
%line 250+0 calc.s
 add edx, [y]
 cmp edx, 0
 je .end
 ..@28.x:
 cmp dword [x], 0
 je ..@28.y
 mov edx, [x]
 mov ebx, 0
 add bl, byte [edx]
 add ecx, ebx
 mov edx, dword [edx+1]
 mov [x], edx
 ..@28.y:
 cmp dword [y], 0
 je ..@28.z
 mov edx, [y]
 mov ebx, 0
 add bl, byte [edx]
 add ecx, ebx
 mov edx, dword [edx+1]
 mov [y], edx
 ..@28.z:
 push ebx
 push ecx
 push edx
 push dword 5
 call malloc
 add esp, 4
 pop edx
 pop ecx
 pop ebx
 mov ebx, 0
 add bl, byte [edx]
 mov [eax], byte cl
 mov [eax+1], dword 0

%line 251+1 calc.s
 mov [Z], eax
 mov [z], eax
 shr ecx, 8
 .loop:
 mov edx, [x]
%line 255+0 calc.s
 add edx, [y]
 cmp edx, 0
 je .end
 ..@30.x:
 cmp dword [x], 0
 je ..@30.y
 mov edx, [x]
 mov ebx, 0
 add bl, byte [edx]
 add ecx, ebx
 mov edx, dword [edx+1]
 mov [x], edx
 ..@30.y:
 cmp dword [y], 0
 je ..@30.z
 mov edx, [y]
 mov ebx, 0
 add bl, byte [edx]
 add ecx, ebx
 mov edx, dword [edx+1]
 mov [y], edx
 ..@30.z:
 push ebx
 push ecx
 push edx
 push dword 5
 call malloc
 add esp, 4
 pop edx
 pop ecx
 pop ebx
 mov ebx, 0
 add bl, byte [edx]
 mov [eax], byte cl
 mov [eax+1], dword 0

%line 256+1 calc.s
 mov edx, [z]
 mov [edx+1], eax
 mov [z], eax
 shr ecx, 8
 jmp .loop

 .end:
 cmp ecx, 0
 je .endend
 push ebx
%line 265+0 calc.s
 push ecx
 push edx
 push dword 5
 call malloc
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 266+1 calc.s
 mov [eax], byte cl
 mov [eax+1], dword 0
 mov edx, [z]
 mov [edx+1], dword eax
 .endend:
 mov edx, dword [Z]
 mov [stack], dword edx
 mov esp, ebp
 pop ebp
 ret

posh:
 push ebp
 mov ebp, esp

 mov eax, [size]
 cmp eax , [capacity]
 je overflow
 add dword [size],1
%line 284+0 calc.s
 add byte [stack], 4
 mov eax, [stack]
 mov dword [eax], dword 0
%line 285+1 calc.s
 mov edx, buff
 b2:

%line 287+0 calc.s
 mov eax, buff
 ..@34.looop:
 cmp byte [eax], 0
 je ..@34.endofstring
 inc eax
 jmp ..@34.looop
 ..@34.endofstring:
 sub eax , buff
 and eax, 1
%line 288+1 calc.s
 cmp eax,0
 je evenlength
 oddlength:
 mov eax, 0
%line 291+0 calc.s
 mov al, byte [edx]
 cmp eax, 0x41
 jge ..@36.itA_F
 sub eax, 0x30
 jmp ..@36.it0_9
 ..@36.itA_F:
 sub eax, 0x41
 add eax, 10
 ..@36.it0_9:
%line 292+1 calc.s
 mov ecx, eax


%line 294+0 calc.s
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
%line 295+1 calc.s
 add edx, 1
 b3:
 evenlength:
 cmp byte [edx], 0
 je end_posh
 mov eax, 0
%line 300+0 calc.s
 mov al, [edx]
 cmp eax, 0x41
 jge ..@40.itA_F
 sub eax, 0x30
 jmp ..@40.it0_9
 ..@40.itA_F:
 sub eax, 0x41
 add eax, 10
 ..@40.it0_9:
 mov ebx, 0
 mov bl, [edx+1]
 cmp ebx, 0x41
 jge ..@41.itA_F
 sub ebx, 0x30
 jmp ..@41.it0_9
 ..@41.itA_F:
 sub ebx, 0x41
 add ebx, 10
 ..@41.it0_9:
 shl eax, 4
 add eax, ebx
%line 301+1 calc.s
 mov ecx, eax


%line 303+0 calc.s
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
%line 304+1 calc.s
 add edx, 2
 jmp evenlength
 end_posh:
 mov esp, ebp
 pop ebp
 ret
 overflow:
 pushad
%line 311+0 calc.s
 push dword overflowMsg
 push string_format
 call printf
 add esp, 8
 popad
%line 312+1 calc.s
 jmp main_loop

poop:
 push ebp
 mov ebp, esp
 mov eax, [size]
 cmp eax, 0
 je underflow

%line 320+0 calc.s

 mov eax, dword [stack]
 mov eax, dword [eax]
%line 321+1 calc.s
 pushad
 push eax
 call printNumList
 add esp, 4
 popad
 push ebx
%line 326+0 calc.s
 push ecx
 push edx
 push dword eax
 call free
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 327+1 calc.s
 sub dword [size], 1
%line 327+0 calc.s
 sub byte [stack], 4
%line 328+1 calc.s
 mov esp, ebp
 pop ebp
 pushad
%line 330+0 calc.s
 push dword mynew_line
 push string_format
 call printf
 add esp, 8
 popad
%line 331+1 calc.s
 ret

 underflow:
 pushad
%line 334+0 calc.s
 push dword underflowMsg
 push string_format
 call printf
 add esp, 8
 popad
%line 335+1 calc.s
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
%line 353+0 calc.s
 push dword ebx
 push hexa_format
 call printf
 add esp, 8
 popad
%line 354+1 calc.s
 mov eax, dword [eax+1]
 push ebx
%line 355+0 calc.s
 push ecx
 push edx
 push dword eax
 call free
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 356+1 calc.s
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


