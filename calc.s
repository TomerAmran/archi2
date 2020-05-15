section	.rodata ;constats
    overflowMsg: db "Error: Operand Stack Overflow",10,0
    underflowMsg: db "Error: Insufficient Number of Arguments on Stack",10,0
    format_string: db "%d", 10, 0	; format string
    hexa_format: db "%X",0
    string_format: db "%s",0
    mynew_line: db "",10,0

section .data           ; inisiliazed vars
    size: dd 0
    capacity: dd 5    
section .bss            ; uninitilaized vars
    stack: resd 1       ; dynamic stack pointer
    stackBase: resd 1   ; pointer to head of stack
    buff: resb 81
    X: resd 1
    Y: resd 1
    Z: resd 1
    x: resd 1
    y: resd 1
    z: resd 1
    
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
%macro printString 1
    pushad              
    push dword %1
    push string_format
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
%macro myMalloc 1
    push ebx
    push ecx
    push edx              
    push dword %1
    call malloc
    add esp, 4
    pop edx
    pop ecx
    pop ebx
%endmacro
%macro myFree 1
    push ebx
    push ecx
    push edx              
    push dword %1
    call free
    add esp, 4
    pop edx
    pop ecx
    pop ebx
%endmacro
%macro myGets 1
    pushad              
    push %1
    call gets
    add esp, 4
    popad
%endmacro
%macro pushNewLink 1
    ; %1 data
    myMalloc 5                 ; eax will point to new-link
    mov ebx, dword [stack]      ; pointer to pointer head of linked list
    mov ebx, dword [ebx]        ; pointer to head linked list
    mov [eax], byte %1          ; new-link.data <- %1 (byte)
    mov [eax+1], dword ebx      ; new-link.next <- old head
    mov ebx, dword [stack]      ; pointer to pointer head of linked list
    mov [ebx], dword eax        ; head <- new-link
%endmacro
%macro incStack 0
    add dword [size],1
    add byte [stack], 4         ; move top pointer
    mov eax, [stack]
    mov dword [eax], dword 0    ; init as null pointer
%endmacro
%macro decStack 0
    sub dword [size], 1
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
%macro loopContent 0
    mov edx, [x]
    add edx, [y]
    cmp edx, 0      ;x&y ?!= 0
    je .end
        %%x:
        cmp dword [x], 0    ;is x null_ptr?
        je %%y             ;if yes jump to y
        mov edx, [x]        ;edx<- l
        mov ebx, 0
        add bl, byte [edx] ;bl <- l.value
        add ecx, ebx ;c <- c + l.value
        mov edx, dword [edx+1]    ;x <- l.next
        mov [x], edx
        %%y:
        cmp dword [y], 0    ;is y null_ptr?
        je %%z             ;if yes jump to z
        mov edx, [y]        ;edx<- l
        mov ebx, 0
        add bl, byte [edx] ;c <- c + l.value
        add ecx, ebx ;c <- c + l.value
        mov edx, dword [edx+1]  ;y <- l.next
        mov [y], edx
        %%z:
        myMalloc 5
        mov ebx, 0
        add bl, byte [edx] ;c <- c + l.value
        mov [eax], byte cl
        mov [eax+1], dword 0 

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
        myGets buff 
        call parseCommand   
        call Ed_Edd_n_Eddy          ; 
        jmp main_loop
myexit:
    myFree [stackBase]   
    mov ebx, EXIT_SUCCESS
    mov eax,  SIGEXIT
    int 0x80 

Ed_Edd_n_Eddy: ; add
    push ebp
    mov ebp, esp
    mov eax, [size]
    cmp eax, 2      ;eax ?> 1
    jl underflow
    getHeadOfNum eax
    mov [X], dword eax
    mov [x], dword eax
    decStack
    getHeadOfNum eax
    mov [Y], dword eax
    mov [y], dword eax
    mov ecx, 0      ;int carry
    ; mov [Z], dword 0
    ; mov [z], dword 0
    loopContent
    mov [Z], eax
    mov [z], eax
    shr ecx, 8
    .loop:
    loopContent
    mov edx, [z]
    mov [edx+1], eax    ;l.next<- new-link
    mov [z], eax        ;z <- l.next
    shr ecx, 8
    jmp .loop

    .end:
    cmp ecx, 0
    je .endend
    myMalloc 5
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
        ; printHexDigit ecx   ; 
        pushNewLink ecx
        add edx, 1 
        b3:
    evenlength:
        cmp byte [edx], 0
        je  end_posh
        parseTwochars edx
        mov ecx, eax        ; ecx <- data (becuase next macro mess with eax)
        ; printHexDigit ecx
        pushNewLink ecx
        add edx, 2
        jmp evenlength
    end_posh:
        mov esp, ebp
        pop ebp
        ret
    overflow:
        printString overflowMsg
        jmp main_loop

poop:
    push ebp
    mov ebp, esp
    mov eax, [size]
    cmp eax, 0      ;size ?= 0
    je underflow
    getHeadOfNum eax
    pushad
    push eax            ;push first link
    call printNumList   ;recursize function
    add esp, 4          ; pop to void
    popad
    myFree eax
    decStack
    mov esp, ebp    
    pop ebp
    printString mynew_line
    ret
    
    underflow:
    printString underflowMsg
    mov esp, ebp
    pop ebp
    ret

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
    add esp, 4              ;pop to void
    popad
    mov ebx, 0 ;importent
    mov bl , byte [eax]     ;ebx <- l.value
    printHexDigit ebx
    mov eax, dword [eax+1]        ;eax<-l.next
    myFree eax
    .end:
    mov esp, ebp
    pop ebp
    ret

parseCommand:
    push ebp
    mov ebp, esp
    mov eax, 0
    mov al, byte [buff] ;eax <- (char)buff[0]
    cmp eax ,0x70       ;eax ?= 'p'
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


