section	.rodata ;constats
    overflowMsg: db "Error: Operand Stack Overflow",10,0
    underflowMsg: db "Error: Insufficient Number of Arguments on Stack",10,0
    format_string: db "%d", 10, 0	; format string
    hexa_format: db "%X",0
    new_line: db 10

section .data           ; inisiliazed vars
    size: dd 0
    capacity: dd 5    
section .bss            ; uninitilaized vars
    stack: resd 1       ; dynamic stack pointer
    stackBase: resd 1   ; pointer to head of stack
    buff: resb 81

%define EXIT_SUCCESS 0
%define SIGEXIT 1
%define _0 0x30
%define _A 0x41
%macro printNumber 1
    push dword %1
    push format_string
    call printf
%endmacro
%macro printHexDigit 1
    pushad              
    push dword %1
    push hexa_format
    call printf
    add esp, 8
    popad
%endmacro
%macro asciiToHex 1
    cmp %1, _A
	jge %%itA_F
	sub %1, _0 ; 
	jmp %%it0_9
	%%itA_F:
	sub %1, _A ; %1 - 'A'
    add %1, 10
	%%it0_9:
%endmacro
%macro parseOneChar 1
    mov eax, 0
    mov al, byte [%1]
    asciiToHex eax
%endmacro
%macro parseTwochars 1
    mov eax, 0
    mov al, [%1]
    asciiToHex eax
    mov ebx, 0
    mov bl, [%1+1]
    asciiToHex ebx
    shl eax, 4
    add eax, ebx
%endmacro
%macro checkLengthPairty 1
    ;if odd eax==1, if even eax ==0
    mov eax, %1
    %%looop:
    cmp byte [eax], 0 
    je %%endofstring 
    inc eax
    jmp %%looop
    %%endofstring:
    sub eax , %1
    and eax, 1 
%endmacro
%macro pushNewLink 1
    ; %1 data
    push dword 5
    call malloc                 ; eax will point to new-link
    mov ebx, dword [stack]      ; pointer to pointer head of linked list
    mov ebx, dword [ebx]        ; pointer to head linked list
    mov [eax], byte %1          ; new-link.data <- %1 (byte)
    mov [eax+1], dword ebx      ; new-link.next <- old head
    mov ebx, dword [stack]      ; pointer to pointer head of linked list
    mov [ebx], dword eax        ; head <- new-link
%endmacro
%macro incStack 0
    inc dword [size]
    add byte [stack], 4         ; move top pointer
    mov eax, [stack]
    mov dword [eax], dword 0    ; init as null pointer
%endmacro
%macro decStack 0
    dec dword [size]
    sub byte [stack], 4         ;move top pointer
%endmacro
%macro getHeadOfNum 1
        ;;%1 can be only a register
        ;;%1 <- head
    mov %1, dword [stack]       ; pointer to pointer head of linked list
    mov %1, dword [%1]          ; pointer to head linked list
%endmacro
%macro startFunc 1
    push ebp
    mov ebp, esp
    sub esp, %1
%endmacro
%macro endFunc 1
    add esp, %1
    mov esp, ebp
    pop ebp
    ret
%endmacro
section .text
  align 16
  global main
  extern printf
  extern fprintf 
  extern fflush
  extern malloc 
  extern calloc 
  extern free 
  extern gets 
  extern getchar 
  extern fgets 
main:
    ; #####  INITIALIZING OPERAND STACK  #######
    mov eax, [esp+4]            ; argc
    cmp eax, 1                  ; cheack if argc >1
    jg update_stack_size        ; if argc>1 -> argv[1] = stacksize
    jmp init_stack          
    update_stack_size:
        mov eax, [esp+8]        ; put argv pointer in eax
        mov ecx, [eax+4]        ; put argv[1] in ecx
        checkLengthPairty ecx   ; chack if number length is odd, return value in eax
        cmp eax, 1              
        je odd                  ; if odd
        jmp even                ; else even
    odd:
        parseOneChar ecx        ; returned value in eax
        jmp updateCapacity      
    even:
        parseTwochars ecx       ; returned value in eax
    updateCapacity:
        mov [capacity], eax     ; [capasity] <- eax = (decimal) capacity
        printNumber [capacity]
    init_stack:
        push dword 4            ; calloc first arg
        push dword [capacity]   ; calloc second arg
        call calloc             ; allocate memory for opetand stack. eax <- stack pointer
        mov [stack], eax        ; pointer to end of stack
        mov [stackBase], eax
    
    ; #####  MAIN LOOP  #####
    main_loop:
        push buff               ; gets only argument
        call gets               ; load input inti buff
        b1:
        call posh
        ; call poop
        jmp main_loop
    ; push dword 4
    ; push dword defaultCapacity
    ; int calloc
    
    ; poop:
    ; mov ebx, size-1
    ; mov X, [stack + 4*ebx]
    ; dec size

    ; push:
    ; ; error handeling

    ; myAdd:
    ;     poop
    ;     mov Y, X 
    ;     poop
myexit:
    push dword [stackBase]      ; push free() only argument
    call free   
    mov ebx, EXIT_SUCCESS       ; 




posh:
    push ebp                ; jump over ret address             
    mov ebp, esp            

    mov eax, [size]         ; put size in eax
    cmp eax , [capacity]    ; size ?= capacity
    je overflow             ; if stack if full
    incStack                ; else, size++
    mov edx, buff           ; we gonna mess with this pointer
    b2:
    checkLengthPairty buff  ; returned value in eax
    cmp eax,0               ; if buff size is even
    je evenlength
    oddlength:
        parseOneChar edx    ; returned value in eax
        mov ecx, eax        ; ecx <- data (becuase next macro mess with eax)
        printHexDigit ecx   ; 
        pushNewLink ecx
        add edx, 1 
        b3:
    evenlength:
        cmp byte [edx], 0
        je  end_posh
        parseTwochars edx
        mov ecx, eax        ; ecx <- data (becuase next macro mess with eax)
        printHexDigit ecx
        pushNewLink ecx
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
    cmp eax, 0 ;size ?= 0
    je underflow

    getHeadOfNum eax
    push eax
    call printNumList
    add esp, 4
    decStack

    mov esp, ebp
    pop ebp

    ret
    
    underflow:
    push underflowMsg
    call printf
    jmp myexit

printNumList:
    push ebp
    mov ebp, esp
    mov eax, [ebp+8]        ;get link* l (given parameter)
    cmp eax, 0              ;if (l == null_ptr)
    je .end                 ;jmp to end
    mov ebx , dword[eax+1]  ;else ebx<-l.next
    pushad                  ;backup registers
    push ebx                ;argument of recursive call
    call printNumList       ;recursive call
    add esp, 4              ;clean arg
    popad
    mov ebx, 0
    mov bl , byte [eax]     ;ebx <- l.value
    push ebx
    push hexa_format
    call printf
    add esp, 4              ;clean arg
    .end:
    mov esp, ebp
    pop ebx
    ret

    

; poop:
;     mov eax, [size]
;     cmp eax, 0 ;size ?= 0
;     je underflow
;         poop_loop:
;         getHeadOfNum eax ;prev
;         cmp eax, dword 0
;         je end_of_poop
;         mov ebx, dword [eax+1] ;curr
;         checkIfEnd:
;         cmp ebx, 0 ;curr.next
;         je printLink ;
;         step:  
;         mov eax, ebx
;         mov ebx, ecx
;         jmp checkIfEnd
;         printLink:
;             mov edx, 0
;             mov dl, [ebx]
;             push dword edx
;             push hexa_format
;             call printf
;             ; push new_line
;             mov [eax + 1], dword 0
;             jmp poop_loop
;     underflow:
;         push underflowMsg
;         call printf
;         jmp myexit
;     end_of_poop:
;         decStack
;         jmp main_loop
;         mov     eax, SIGEXIT
;         int     0x80
;         nop




