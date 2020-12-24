%macro pushd 0
    push edx
    push ecx
    push ebx
    push eax
%endmacro

%macro popd 0
    pop eax
    pop ebx
    pop ecx
    pop edx
%endmacro

%macro print 2
    pushd
    mov edx, %1
    mov ecx, %2
    mov ebx, 1
    mov eax, 4
    int 0x80

    popd
%endmacro

%macro dprint 0
    pushd
    mov ecx, 10
    mov bx, 0
    

    %%_divide:
        mov edx,0
        div ecx
        push dx
        inc bx
        test eax, eax
        jnz %%_divide
        
    mov cx,bx
    
    %%_digit:
        pop ax
        add ax, '0'
        mov [count], ax
        print 1, count
        dec cx
        mov ax, cx
        cmp cx, 0
        jg %%_digit
    popd
%endmacro     


section .text

global _start

_start:
    ;поиск суммы 1 массива
    mov bx, 0
    mov eax, 0 
    
    
_loop:
    add eax, [x + ebx]
    add bx, 4
    
cmp bx, alen ;сравниваем с длиной
jne _loop ;прыгаем на loop

    mov [sum1], eax
    
    ; 
    mov bx, 0
    mov eax, 0  
    
_loopp:
    add eax, [y + ebx]
    add bx, 4
    
cmp ebx, alen2 ;
jne _loopp ;

    mov [sum2], eax
    
    ; 
    mov edx, 0
    mov eax, alen
    mov ecx, 4
    div ecx
    
    mov [c], eax

    ;
    mov edx, 0
    mov eax, [sum1]
    mov ecx, [c]
    div ecx
    
    mov [sum1], eax
   
   ;
    mov edx, 0
    mov eax, [sum2]
    mov ecx, [c]
    div ecx
    
    mov [sum2], eax
    
    ;разность
    mov ax, [sum2]
    mov bx, [sum1]
    sub ax, bx
    dprint
    
    print nlen, newline
    print len, message
    print nlen, newline

    mov eax, 1
    int 0x80

section .data
    x dd 5, 3, 2, 6, 1, 7, 4 ;
    alen equ $ - x ; считаем длину массива с адреса начала до конца
    
    y dd 0, 10, 1, 9, 2, 8, 5 ;
    alen2 equ $ - y ; ; считаем длину массива с адреса начала до конца
    

    message db "Done"
    len equ $ - message
    
    newline db 0xA, 0xD
    nlen equ $ - newline
    
section .bss
    count resd 1 ;
    sum1 resd 1 ;сумма первого массива
    sum2 resd 1 ;сумма второго массива
    c resd 1 ;длина массива
