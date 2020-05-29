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
 opCounter: dd 0
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

%line 227+1 calc.s

[section .text]
[sectalign 16]
%line 229+0 calc.s
times (((16) - (($-$$) % (16))) % (16)) nop
%line 230+1 calc.s
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
[extern debug]
main:

 mov eax, [esp+4]
 cmp eax, 1
 jg update_stack_size
 jmp init_stack
 update_stack_size:
 mov eax, [esp+8]
 mov ecx, [eax+4]

%line 250+0 calc.s
 mov eax, ecx
 ..@17.looop:
 cmp byte [eax], 0
 je ..@17.endofstring
 inc eax
 jmp ..@17.looop
 ..@17.endofstring:
 sub eax , ecx
 and eax, 1
%line 251+1 calc.s
 cmp eax, 1
 je odd
 jmp even
 odd:
 mov eax, 0
%line 255+0 calc.s
 mov al, byte [ecx]
 cmp eax, 0x41
 jge ..@19.itA_F
 sub eax, 0x30
 jmp ..@19.it0_9
 ..@19.itA_F:
 sub eax, 0x41
 add eax, 10
 ..@19.it0_9:
%line 256+1 calc.s
 jmp updateCapacity
 even:
 mov eax, 0
%line 258+0 calc.s
 mov al, [ecx]
 cmp eax, 0x41
 jge ..@21.itA_F
 sub eax, 0x30
 jmp ..@21.it0_9
 ..@21.itA_F:
 sub eax, 0x41
 add eax, 10
 ..@21.it0_9:
 mov ebx, 0
 mov bl, [ecx+1]
 cmp ebx, 0x41
 jge ..@22.itA_F
 sub ebx, 0x30
 jmp ..@22.it0_9
 ..@22.itA_F:
 sub ebx, 0x41
 add ebx, 10
 ..@22.it0_9:
 shl eax, 4
 add eax, ebx
%line 259+1 calc.s
 updateCapacity:
 mov [capacity], eax
 push dword [capacity]
%line 261+0 calc.s
 push format_string
 call printf
%line 262+1 calc.s
 init_stack:
 push dword 4
 push dword [capacity]
 call calloc
 mov [stack], eax
 sub dword[stack], 4
 mov [stackBase], eax

 call myCalc
 push dword eax
%line 271+0 calc.s
 push format_string
 call printf
%line 272+1 calc.s
 call myexit


myCalc:
 push ebp
%line 276+0 calc.s
 mov ebp, esp
 sub esp, 0
%line 277+1 calc.s
 .main_loop:
 pushad
%line 278+0 calc.s
 push buff
 call gets
 add esp, 4
 popad
%line 279+1 calc.s
 call parseCommand
 cmp eax, 0x71
 jne .main_loop
 .endMyCalc:
 mov eax, dword [opCounter]
 dec eax
 add esp, 0
%line 285+0 calc.s
 mov esp, ebp
 pop ebp
 ret
%line 286+1 calc.s
myexit:

%line 287+0 calc.s
 push ebx
 push ecx
 push edx
 push dword [stackBase]
 call free
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 288+1 calc.s
 mov eax, 1
 mov ebx, 0
 int 0x80

Ed_Edd_n_Eddy:
 push ebp
%line 293+0 calc.s
 mov ebp, esp
 sub esp, 0
%line 294+1 calc.s


%line 295+0 calc.s
 mov eax, [size]
 cmp eax, 2
 jge ..@30.notUnderFlow
 pushad
 push dword underflowMsg
 push string_format
 call printf
 add esp, 8
 popad
 add esp, 0
 mov esp, ebp
 pop ebp
 ret
 ..@30.notUnderFlow:
%line 296+1 calc.s

%line 296+0 calc.s

 mov eax, dword [stack]
 mov eax, dword [eax]
 mov [X], dword eax
 mov [x], dword eax
 mov eax, [stack]
 mov [eax], dword 0
 sub dword [size], 1
 sub byte [stack], 4


 mov ebx, dword [stack]
 mov ebx, dword [ebx]
 mov [Y], dword ebx
 mov [y], dword ebx
%line 297+1 calc.s
 mov ecx, 0

 mov edx, [x]
%line 299+0 calc.s
 add edx, [y]
 cmp edx, 0
 je .beforeEnd
%line 300+1 calc.s
 .x1:
 cmp dword [x], 0
 je .y1
 mov edx, [x]
%line 303+0 calc.s
 mov ebx, 0
 add bl, byte [edx]
 add ecx, ebx
 mov edx, dword [edx+1]
 mov [x], edx
%line 304+1 calc.s
 .y1:
 cmp dword [y], 0
 je .z1
 mov edx, [y]
%line 307+0 calc.s
 mov ebx, 0
 add bl, byte [edx]
 add ecx, ebx
 mov edx, dword [edx+1]
 mov [y], edx
%line 308+1 calc.s
 .z1:
 push ebx
%line 309+0 calc.s
 push ecx
 push edx
 push dword 5
 call malloc
 add esp, 4
 pop edx
 pop ecx
 pop ebx
 mov [eax], byte cl
 mov [eax+1], dword 0
 shr ecx, 8
%line 310+1 calc.s
 mov [Z], dword eax
 mov [z], dword eax

 .loop:
 mov edx, [x]
%line 314+0 calc.s
 add edx, [y]
 cmp edx, 0
 je .beforeEnd
%line 315+1 calc.s
 .x2:
 cmp dword [x], 0
 je .y2
 mov edx, [x]
%line 318+0 calc.s
 mov ebx, 0
 add bl, byte [edx]
 add ecx, ebx
 mov edx, dword [edx+1]
 mov [x], edx
%line 319+1 calc.s
 .y2:
 cmp dword [y], 0
 je .z2
 mov edx, [y]
%line 322+0 calc.s
 mov ebx, 0
 add bl, byte [edx]
 add ecx, ebx
 mov edx, dword [edx+1]
 mov [y], edx
%line 323+1 calc.s
 .z2:
 push ebx
%line 324+0 calc.s
 push ecx
 push edx
 push dword 5
 call malloc
 add esp, 4
 pop edx
 pop ecx
 pop ebx
 mov [eax], byte cl
 mov [eax+1], dword 0
 shr ecx, 8
%line 325+1 calc.s
 mov edx, dword [z]
 mov [edx+1], dword eax
 mov [z], dword eax
 jmp .loop

 .beforeEnd:
 cmp ecx, 0
 je .end
 push ebx
%line 333+0 calc.s
 push ecx
 push edx
 push dword 5
 call malloc
 add esp, 4
 pop edx
 pop ecx
 pop ebx
 mov [eax], byte cl
 mov [eax+1], dword 0
 shr ecx, 8
%line 334+1 calc.s
 mov edx, dword [z]
 mov [edx+1], dword eax
 .end:
 mov edx, dword [Z]
 mov ecx, dword [stack]
 mov [ecx], dword edx
 mov eax, [X]

%line 341+0 calc.s
 push ebx
 push ecx
 push edx
 push dword eax
 call free
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 342+1 calc.s
 mov eax, [Y]

%line 343+0 calc.s
 push ebx
 push ecx
 push edx
 push dword eax
 call free
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 344+1 calc.s

 add esp, 0
%line 345+0 calc.s
 mov esp, ebp
 pop ebp
 ret
%line 346+1 calc.s

posh:
 push ebp
%line 348+0 calc.s
 mov ebp, esp
 sub esp, 0
%line 349+1 calc.s

 mov eax, [size]
%line 350+0 calc.s
 cmp eax, [capacity]
 jl ..@53.notOverFlow
 pushad
 push dword overflowMsg
 push string_format
 call printf
 add esp, 8
 popad
 add esp, 0
 mov esp, ebp
 pop ebp
 ret
 ..@53.notOverFlow:
%line 351+1 calc.s
 add dword [size],1
%line 351+0 calc.s
 add byte [stack], 4
 mov eax, [stack]
 mov dword [eax], dword 0
%line 352+1 calc.s
 mov edx, buff

%line 353+0 calc.s
 mov eax, buff
 ..@57.looop:
 cmp byte [eax], 0
 je ..@57.endofstring
 inc eax
 jmp ..@57.looop
 ..@57.endofstring:
 sub eax , buff
 and eax, 1
%line 354+1 calc.s
 cmp eax,0
 je .evenlength
 .oddlength:
 mov eax, 0
%line 357+0 calc.s
 mov al, byte [edx]
 cmp eax, 0x41
 jge ..@59.itA_F
 sub eax, 0x30
 jmp ..@59.it0_9
 ..@59.itA_F:
 sub eax, 0x41
 add eax, 10
 ..@59.it0_9:
%line 358+1 calc.s
 mov ecx, eax


%line 360+0 calc.s
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
 mov [eax], byte cl
 mov [eax+1], dword ebx
 mov ebx, dword [stack]
 mov [ebx], dword eax
%line 361+1 calc.s
 add edx, 1
 .evenlength:
 cmp byte [edx], 0
 je .end
 mov eax, 0
%line 365+0 calc.s
 mov al, [edx]
 cmp eax, 0x41
 jge ..@63.itA_F
 sub eax, 0x30
 jmp ..@63.it0_9
 ..@63.itA_F:
 sub eax, 0x41
 add eax, 10
 ..@63.it0_9:
 mov ebx, 0
 mov bl, [edx+1]
 cmp ebx, 0x41
 jge ..@64.itA_F
 sub ebx, 0x30
 jmp ..@64.it0_9
 ..@64.itA_F:
 sub ebx, 0x41
 add ebx, 10
 ..@64.it0_9:
 shl eax, 4
 add eax, ebx
%line 366+1 calc.s
 mov ecx, eax


%line 368+0 calc.s
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
 mov [eax], byte cl
 mov [eax+1], dword ebx
 mov ebx, dword [stack]
 mov [ebx], dword eax
%line 369+1 calc.s
 add edx, 2
 jmp .evenlength
 .end:
 mov esp, ebp
 pop ebp
 ret

poop:
 push ebp
 mov ebp, esp


%line 380+0 calc.s
 mov eax, [size]
 cmp eax, 1
 jge ..@67.notUnderFlow
 pushad
 push dword underflowMsg
 push string_format
 call printf
 add esp, 8
 popad
 add esp, 0
 mov esp, ebp
 pop ebp
 ret
 ..@67.notUnderFlow:
%line 381+1 calc.s

%line 381+0 calc.s

 mov eax, dword [stack]
 mov eax, dword [eax]
%line 382+1 calc.s
 pushad
 push eax
 call printNumList
 add esp, 4
 popad

%line 387+0 calc.s
 push ebx
 push ecx
 push edx
 push dword eax
 call free
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 388+1 calc.s


 mov eax, [stack]
%line 390+0 calc.s
 mov [eax], dword 0
 sub dword [size], 1
 sub byte [stack], 4
%line 391+1 calc.s
 .end:
 mov esp, ebp
 pop ebp
 pushad
%line 394+0 calc.s
 push dword mynew_line
 push string_format
 call printf
 add esp, 8
 popad
%line 395+1 calc.s
 ret


printNumList:
 push ebp
%line 399+0 calc.s
 mov ebp, esp
 sub esp, 0
%line 400+1 calc.s

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
%line 412+0 calc.s
 push dword ebx
 push hexa_format
 call printf
 add esp, 8
 popad
%line 413+1 calc.s
 mov eax, dword [eax+1]

%line 414+0 calc.s
 push ebx
 push ecx
 push edx
 push dword eax
 call free
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 415+1 calc.s
 .end:
 add esp, 0
%line 416+0 calc.s
 mov esp, ebp
 pop ebp
 ret
%line 417+1 calc.s

duplicate:
 push ebp
%line 419+0 calc.s
 mov ebp, esp
 sub esp, 0
%line 420+1 calc.s


%line 421+0 calc.s
 mov eax, [size]
 cmp eax, 1
 jge ..@79.notUnderFlow
 pushad
 push dword underflowMsg
 push string_format
 call printf
 add esp, 8
 popad
 add esp, 0
 mov esp, ebp
 pop ebp
 ret
 ..@79.notUnderFlow:
%line 422+1 calc.s
 mov eax, [size]
%line 422+0 calc.s
 cmp eax, [capacity]
 jl ..@82.notOverFlow
 pushad
 push dword overflowMsg
 push string_format
 call printf
 add esp, 8
 popad
 add esp, 0
 mov esp, ebp
 pop ebp
 ret
 ..@82.notOverFlow:
%line 423+1 calc.s


%line 424+0 calc.s

 mov edx, dword [stack]
 mov edx, dword [edx]
%line 425+1 calc.s
 mov [x], dword edx
 add dword [size],1
%line 426+0 calc.s
 add byte [stack], 4
 mov eax, [stack]
 mov dword [eax], dword 0
%line 427+1 calc.s
 push ebx
%line 427+0 calc.s
 push ecx
 push edx
 push dword 5
 call malloc
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 428+1 calc.s
 mov [z], dword eax
 mov ebx, dword [stack]
 mov [ebx], dword eax


 mov cl, byte [edx]
 mov [eax], byte cl
 mov [eax+1], dword 0

 mov ebx, eax





 .loop:

 mov edx, dword [edx+1]


 cmp dword edx, 0
 je .end


 push ebx
%line 452+0 calc.s
 push ecx
 push edx
 push dword 5
 call malloc
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 453+1 calc.s
 mov [ebx+1], dword eax
 mov ebx, dword eax
 mov cl, byte [edx]
 mov [ebx], byte cl
 mov [ebx+1], dword 0

 jmp .loop

 .end:
 add esp, 0
%line 462+0 calc.s
 mov esp, ebp
 pop ebp
 ret
%line 463+1 calc.s

myAnd:
 push ebp
%line 465+0 calc.s
 mov ebp, esp
 sub esp, 0
%line 466+1 calc.s


%line 467+0 calc.s
 mov eax, [size]
 cmp eax, 2
 jge ..@91.notUnderFlow
 pushad
 push dword underflowMsg
 push string_format
 call printf
 add esp, 8
 popad
 add esp, 0
 mov esp, ebp
 pop ebp
 ret
 ..@91.notUnderFlow:
%line 468+1 calc.s

%line 468+0 calc.s

 mov eax, dword [stack]
 mov eax, dword [eax]
 mov [X], dword eax
 mov [x], dword eax
 mov eax, [stack]
 mov [eax], dword 0
 sub dword [size], 1
 sub byte [stack], 4


 mov ebx, dword [stack]
 mov ebx, dword [ebx]
 mov [Y], dword ebx
 mov [y], dword ebx
%line 469+1 calc.s




 .loop:
 cmp eax, 0
 je .end
 cmp ebx, 0
 je .end

 mov eax, [x]
 mov al, byte [eax]
 mov ebx, [y]
 mov cl, byte [ebx]
 and cl, al
 mov [ebx], cl

 mov ebx, [y]
%line 486+0 calc.s
 mov ebx, dword [ebx+1]
 mov [y], dword ebx
 mov eax, [x]
 mov eax, dword [eax+1]
 mov [x], dword eax
%line 487+1 calc.s

 jmp .loop

 .end:
 mov eax, [X]

%line 492+0 calc.s
 push ebx
 push ecx
 push edx
 push dword eax
 call free
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 493+1 calc.s
 mov eax, ebx

%line 494+0 calc.s
 push ebx
 push ecx
 push edx
 push dword eax
 call free
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 495+1 calc.s
 add esp, 0
%line 495+0 calc.s
 mov esp, ebp
 pop ebp
 ret
%line 496+1 calc.s

myOr:
 push ebp
%line 498+0 calc.s
 mov ebp, esp
 sub esp, 0
%line 499+1 calc.s


%line 500+0 calc.s
 mov eax, [size]
 cmp eax, 2
 jge ..@103.notUnderFlow
 pushad
 push dword underflowMsg
 push string_format
 call printf
 add esp, 8
 popad
 add esp, 0
 mov esp, ebp
 pop ebp
 ret
 ..@103.notUnderFlow:
%line 501+1 calc.s

%line 501+0 calc.s

 mov eax, dword [stack]
 mov eax, dword [eax]
 mov [X], dword eax
 mov [x], dword eax
 mov eax, [stack]
 mov [eax], dword 0
 sub dword [size], 1
 sub byte [stack], 4


 mov ebx, dword [stack]
 mov ebx, dword [ebx]
 mov [Y], dword ebx
 mov [y], dword ebx
%line 502+1 calc.s




 .loop:
 mov edx, [x]
%line 507+0 calc.s
 add edx, [y]
 cmp edx, 0
 je .beforeEnd
%line 508+1 calc.s
 cmp eax, 0
 je .freeX
 cmp ebx, 0
 je .movXtoY

 mov eax, [x]
 mov al, byte [eax]
 mov ebx, [y]
 mov cl, byte [ebx]
 or cl, al
 mov [ebx], cl

 mov ebx, [y]
%line 520+0 calc.s
 mov ebx, dword [ebx+1]
 mov [y], dword ebx
 mov eax, [x]
 mov eax, dword [eax+1]
 mov [x], dword eax
%line 521+1 calc.s

 jmp .loop

 .movXtoY:
 mov eax, [x]
 mov eax, dword [eax+1]
 mov ebx, [y]
 mov dword [ebx+1], dword eax
 .freeX:
 mov eax, [X]

%line 531+0 calc.s
 push ebx
 push ecx
 push edx
 push dword eax
 call free
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 532+1 calc.s
 .beforeEnd:
 .end:
 add esp, 0
%line 534+0 calc.s
 mov esp, ebp
 pop ebp
 ret
%line 535+1 calc.s
parseCommand:
 push ebp
%line 536+0 calc.s
 mov ebp, esp
 sub esp, 0
%line 537+1 calc.s
 inc dword [opCounter]
 mov eax, 0
 mov al, byte [buff]

 cmp eax ,0x70
 je user_wants_to_poop
 cmp eax, 0x71
 je end_p
 cmp eax, 0x73
 je debugAc
 cmp eax, 43
 je Ed
 cmp eax, 0x64
 je duplicate_fun
 cmp eax, 0x26
 je and_meow
 cmp eax, 0x7C
 je or_meow

 Posh:
 pushad
 call posh
 popad
 jmp end_p
 Ed:
 pushad
 call Ed_Edd_n_Eddy
 popad
 jmp end_p
 debugAc:
 pushad
 pushad
%line 568+0 calc.s
 push dword [size]
 push dword [capacity]
 push dword [stackBase]
 push dword [stack]
 call debug
 add esp, 16
 popad
%line 569+1 calc.s
 popad
 jmp end_p
 user_wants_to_poop:
 pushad
 call poop
 popad
 jmp end_p
 duplicate_fun:
 pushad
 call duplicate
 popad
 jmp end_p
 and_meow:
 pushad
 call myAnd
 popad
 jmp end_p
 or_meow:
 pushad
 call myOr
 popad
 jmp end_p


 end_p:
 mov esp, ebp
 pop ebp
 ret


