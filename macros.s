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

%line 251+1 calc.s



[section .text]
[sectalign 16]
%line 255+0 calc.s
times (((16) - (($-$$) % (16))) % (16)) nop
%line 256+1 calc.s
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

%line 276+0 calc.s
 mov eax, ecx
 ..@17.looop:
 cmp byte [eax], 0
 je ..@17.endofstring
 inc eax
 jmp ..@17.looop
 ..@17.endofstring:
 sub eax , ecx
 and eax, 1
%line 277+1 calc.s
 cmp eax, 1
 je odd
 jmp even
 odd:
 mov eax, 0
%line 281+0 calc.s
 mov al, byte [ecx]
 cmp eax, 0x41
 jge ..@19.itA_F
 sub eax, 0x30
 jmp ..@19.it0_9
 ..@19.itA_F:
 sub eax, 0x41
 add eax, 10
 ..@19.it0_9:
%line 282+1 calc.s
 jmp updateCapacity
 even:
 mov eax, 0
%line 284+0 calc.s
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
%line 285+1 calc.s
 updateCapacity:
 mov [capacity], eax
 push dword [capacity]
%line 287+0 calc.s
 push format_string
 call printf
%line 288+1 calc.s
 init_stack:
 push dword 4
 push dword [capacity]
 call calloc
 mov [stack], eax
 sub dword[stack], 4
 mov [stackBase], eax

 call myCalc
 pushad
%line 297+0 calc.s
 push dword eax
 push hexa_format
 call printf
 add esp, 8
 popad
%line 298+1 calc.s
 pushad
%line 298+0 calc.s
 push dword mynew_line
 push string_format
 call printf
 add esp, 8
 popad
%line 299+1 calc.s
 call myexit

myCalc:
 push ebp
%line 302+0 calc.s
 mov ebp, esp
 sub esp, 0
%line 303+1 calc.s
 .main_loop:
 pushad
%line 304+0 calc.s
 push buff
 call gets
 add esp, 4
 popad
%line 305+1 calc.s
 call parseCommand
 cmp eax, 0x71
 jne .main_loop
 .endMyCalc:
 mov eax, dword [opCounter]
 dec eax
 add esp, 0
%line 311+0 calc.s
 mov esp, ebp
 pop ebp
 ret
%line 312+1 calc.s
myexit:
 mov eax, [stackBase]
 .freeLoop:
 cmp eax, dword [stack]
 jg .end
 mov ebx, dword [eax]
 pushad
%line 318+0 calc.s
 push ebx
 call freeList
 add esp, 4
 popad
%line 319+1 calc.s
 add eax, 4
 jmp .freeLoop
 .end:

%line 322+0 calc.s
 push ebx
 push ecx
 push edx
 push dword [stackBase]
 call free
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 323+1 calc.s
 mov eax, 1
 mov ebx, 0
 int 0x80

Ed_Edd_n_Eddy:
 push ebp
%line 328+0 calc.s
 mov ebp, esp
 sub esp, 0
%line 329+1 calc.s


%line 330+0 calc.s
 mov eax, [size]
 cmp eax, 2
 jge ..@32.notUnderFlow
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
 ..@32.notUnderFlow:
%line 331+1 calc.s

%line 331+0 calc.s

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
%line 332+1 calc.s
 mov ecx, 0

 mov edx, [x]
%line 334+0 calc.s
 add edx, [y]
 cmp edx, 0
 je .beforeEnd
%line 335+1 calc.s
 .x1:
 cmp dword [x], 0
 je .y1
 mov edx, [x]
%line 338+0 calc.s
 mov ebx, 0
 add bl, byte [edx]
 add ecx, ebx
 mov edx, dword [edx+1]
 mov [x], edx
%line 339+1 calc.s
 .y1:
 cmp dword [y], 0
 je .z1
 mov edx, [y]
%line 342+0 calc.s
 mov ebx, 0
 add bl, byte [edx]
 add ecx, ebx
 mov edx, dword [edx+1]
 mov [y], edx
%line 343+1 calc.s
 .z1:
 push ebx
%line 344+0 calc.s
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
%line 345+1 calc.s
 mov [Z], dword eax
 mov [z], dword eax

 .loop:
 mov edx, [x]
%line 349+0 calc.s
 add edx, [y]
 cmp edx, 0
 je .beforeEnd
%line 350+1 calc.s
 .x2:
 cmp dword [x], 0
 je .y2
 mov edx, [x]
%line 353+0 calc.s
 mov ebx, 0
 add bl, byte [edx]
 add ecx, ebx
 mov edx, dword [edx+1]
 mov [x], edx
%line 354+1 calc.s
 .y2:
 cmp dword [y], 0
 je .z2
 mov edx, [y]
%line 357+0 calc.s
 mov ebx, 0
 add bl, byte [edx]
 add ecx, ebx
 mov edx, dword [edx+1]
 mov [y], edx
%line 358+1 calc.s
 .z2:
 push ebx
%line 359+0 calc.s
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
%line 360+1 calc.s
 mov edx, dword [z]
 mov [edx+1], dword eax
 mov [z], dword eax
 jmp .loop

 .beforeEnd:
 cmp ecx, 0
 je .end
 push ebx
%line 368+0 calc.s
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
%line 369+1 calc.s
 mov edx, dword [z]
 mov [edx+1], dword eax
 .end:
 mov edx, dword [Z]
 mov ecx, dword [stack]
 mov [ecx], dword edx
 mov eax, [X]
 pushad
%line 376+0 calc.s
 push eax
 call freeList
 add esp, 4
 popad
%line 377+1 calc.s
 mov eax, [Y]
 pushad
%line 378+0 calc.s
 push eax
 call freeList
 add esp, 4
 popad
%line 379+1 calc.s

 add esp, 0
%line 380+0 calc.s
 mov esp, ebp
 pop ebp
 ret
%line 381+1 calc.s

posh:
 push ebp
%line 383+0 calc.s
 mov ebp, esp
 sub esp, 0
%line 384+1 calc.s

 mov eax, [size]
%line 385+0 calc.s
 cmp eax, [capacity]
 jl ..@55.notOverFlow
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
 ..@55.notOverFlow:
%line 386+1 calc.s
 add dword [size],1
%line 386+0 calc.s
 add byte [stack], 4
 mov eax, [stack]
 mov dword [eax], dword 0
%line 387+1 calc.s

 mov edx, buff
%line 388+0 calc.s
 ..@59.cleanLoop:
 cmp byte [edx], 0x30
 je ..@59.isZero
 cmp byte [edx], 0
 je ..@59.isNull

 jmp ..@59.endclean
 ..@59.isZero:
 inc edx
 jmp ..@59.cleanLoop
 ..@59.isNull:
 dec edx
 jmp ..@59.endclean
 ..@59.endclean:
%line 389+1 calc.s

%line 389+0 calc.s
 mov eax, edx
 ..@60.looop:
 cmp byte [eax], 0
 je ..@60.endofstring
 inc eax
 jmp ..@60.looop
 ..@60.endofstring:
 sub eax , edx
 and eax, 1
%line 390+1 calc.s
 cmp eax,0
 je .evenlength
 .oddlength:
 mov eax, 0
%line 393+0 calc.s
 mov al, byte [edx]
 cmp eax, 0x41
 jge ..@62.itA_F
 sub eax, 0x30
 jmp ..@62.it0_9
 ..@62.itA_F:
 sub eax, 0x41
 add eax, 10
 ..@62.it0_9:
%line 394+1 calc.s
 mov ecx, eax


%line 396+0 calc.s
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
%line 397+1 calc.s
 add edx, 1
 .evenlength:
 cmp byte [edx], 0
 je .end
 mov eax, 0
%line 401+0 calc.s
 mov al, [edx]
 cmp eax, 0x41
 jge ..@66.itA_F
 sub eax, 0x30
 jmp ..@66.it0_9
 ..@66.itA_F:
 sub eax, 0x41
 add eax, 10
 ..@66.it0_9:
 mov ebx, 0
 mov bl, [edx+1]
 cmp ebx, 0x41
 jge ..@67.itA_F
 sub ebx, 0x30
 jmp ..@67.it0_9
 ..@67.itA_F:
 sub ebx, 0x41
 add ebx, 10
 ..@67.it0_9:
 shl eax, 4
 add eax, ebx
%line 402+1 calc.s
 mov ecx, eax


%line 404+0 calc.s
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
%line 405+1 calc.s
 add edx, 2
 jmp .evenlength
 .end:
 mov esp, ebp
 pop ebp
 ret

poop:
 push ebp
 mov ebp, esp


%line 416+0 calc.s
 mov eax, [size]
 cmp eax, 1
 jge ..@70.notUnderFlow
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
 ..@70.notUnderFlow:
%line 417+1 calc.s

%line 417+0 calc.s

 mov eax, dword [stack]
 mov eax, dword [eax]
%line 418+1 calc.s
 pushad
 push eax
 call printNumList
 add esp, 4
 popad

%line 423+0 calc.s
 push ebx
 push ecx
 push edx
 push dword eax
 call free
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 424+1 calc.s


 mov eax, [stack]
%line 426+0 calc.s
 mov [eax], dword 0
 sub dword [size], 1
 sub byte [stack], 4
%line 427+1 calc.s
 .end:
 mov esp, ebp
 pop ebp
 pushad
%line 430+0 calc.s
 push dword mynew_line
 push string_format
 call printf
 add esp, 8
 popad
%line 431+1 calc.s
 ret


printNumList:
 push ebp
%line 435+0 calc.s
 mov ebp, esp
 sub esp, 0
%line 436+1 calc.s

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
%line 448+0 calc.s
 push dword ebx
 push hexa_format
 call printf
 add esp, 8
 popad
%line 449+1 calc.s
 mov eax, dword [eax+1]

%line 450+0 calc.s
 push ebx
 push ecx
 push edx
 push dword eax
 call free
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 451+1 calc.s
 .end:
 add esp, 0
%line 452+0 calc.s
 mov esp, ebp
 pop ebp
 ret
%line 453+1 calc.s

duplicate:
 push ebp
%line 455+0 calc.s
 mov ebp, esp
 sub esp, 0
%line 456+1 calc.s


%line 457+0 calc.s
 mov eax, [size]
 cmp eax, 1
 jge ..@82.notUnderFlow
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
 ..@82.notUnderFlow:
%line 458+1 calc.s
 mov eax, [size]
%line 458+0 calc.s
 cmp eax, [capacity]
 jl ..@85.notOverFlow
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
 ..@85.notOverFlow:
%line 459+1 calc.s


%line 460+0 calc.s

 mov edx, dword [stack]
 mov edx, dword [edx]
%line 461+1 calc.s
 mov [x], dword edx
 add dword [size],1
%line 462+0 calc.s
 add byte [stack], 4
 mov eax, [stack]
 mov dword [eax], dword 0
%line 463+1 calc.s
 push ebx
%line 463+0 calc.s
 push ecx
 push edx
 push dword 5
 call malloc
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 464+1 calc.s
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
%line 488+0 calc.s
 push ecx
 push edx
 push dword 5
 call malloc
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 489+1 calc.s
 mov [ebx+1], dword eax
 mov ebx, dword eax
 mov cl, byte [edx]
 mov [ebx], byte cl
 mov [ebx+1], dword 0

 jmp .loop

 .end:
 add esp, 0
%line 498+0 calc.s
 mov esp, ebp
 pop ebp
 ret
%line 499+1 calc.s

myAnd:
 push ebp
%line 501+0 calc.s
 mov ebp, esp
 sub esp, 0
%line 502+1 calc.s


%line 503+0 calc.s
 mov eax, [size]
 cmp eax, 2
 jge ..@94.notUnderFlow
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
 ..@94.notUnderFlow:
%line 504+1 calc.s

%line 504+0 calc.s

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
%line 505+1 calc.s




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
%line 522+0 calc.s
 mov ebx, dword [ebx+1]
 mov [y], dword ebx
 mov eax, [x]
 mov eax, dword [eax+1]
 mov [x], dword eax
%line 523+1 calc.s

 jmp .loop

 .end:
 mov eax, [X]
 pushad
%line 528+0 calc.s
 push eax
 call freeList
 add esp, 4
 popad
%line 529+1 calc.s
 mov eax, ebx
 pushad
%line 530+0 calc.s
 push eax
 call freeList
 add esp, 4
 popad
%line 531+1 calc.s
 add esp, 0
%line 531+0 calc.s
 mov esp, ebp
 pop ebp
 ret
%line 532+1 calc.s

myOr:
 push ebp
%line 534+0 calc.s
 mov ebp, esp
 sub esp, 0
%line 535+1 calc.s


%line 536+0 calc.s
 mov eax, [size]
 cmp eax, 2
 jge ..@106.notUnderFlow
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
 ..@106.notUnderFlow:
%line 537+1 calc.s

%line 537+0 calc.s

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
%line 538+1 calc.s




 .loop:
 mov edx, [x]
%line 543+0 calc.s
 add edx, [y]
 cmp edx, 0
 je .beforeEnd
%line 544+1 calc.s
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
%line 556+0 calc.s
 mov ebx, dword [ebx+1]
 mov [y], dword ebx
 mov eax, [x]
 mov eax, dword [eax+1]
 mov [x], dword eax
%line 557+1 calc.s

 jmp .loop

 .movXtoY:
 mov eax, [x]
 mov eax, dword [eax+1]
 mov ebx, [y]
 mov dword [ebx+1], dword eax
 .freeX:
 mov eax, [X]
 pushad
%line 567+0 calc.s
 push eax
 call freeList
 add esp, 4
 popad
%line 568+1 calc.s
 .beforeEnd:
 .end:
 add esp, 0
%line 570+0 calc.s
 mov esp, ebp
 pop ebp
 ret
%line 571+1 calc.s
parseCommand:
 push ebp
%line 572+0 calc.s
 mov ebp, esp
 sub esp, 0
%line 573+1 calc.s
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
 dec dword [opCounter]
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
%line 605+0 calc.s
 push dword [size]
 push dword [capacity]
 push dword [stackBase]
 push dword [stack]
 call debug
 add esp, 16
 popad
%line 606+1 calc.s
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

freeList:
 push ebp
%line 636+0 calc.s
 mov ebp, esp
 sub esp, 0
%line 637+1 calc.s

 mov eax, [ebp+8]
 cmp eax, 0
 je .end
 mov ebx , dword [eax+1]
 cmp ebx, 0
 je .release

 pushad
%line 645+0 calc.s
 push ebx
 call freeList
 add esp, 4
 popad
%line 646+1 calc.s

 .release:

%line 648+0 calc.s
 push ebx
 push ecx
 push edx
 push dword eax
 call free
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 649+1 calc.s

 .end:
 add esp, 0
%line 651+0 calc.s
 mov esp, ebp
 pop ebp
 ret
%line 652+1 calc.s

