.data
    format_descriptor: .asciz "Descriptor:%d\n"
    format_dimensiune: .asciz "Dimensiune:%d\n"
    format_adaugari: .asciz "Nr fisiere:%d\n"
    format_interval: .asciz "%d: (%d, %d)\n"
    format_interval_get: .asciz "(%d, %d)\n"
    format_int: .asciz "%d"
    format_array: .asciz "%d "
    adds: .space 4
    v: .space 8192
    n: .long 1024
    x: .long 8 # folosim pentru impartire la nr de blocuri
    descriptor: .space 4
    dimensiune: .space 4
    nr_locuri: .long 0
    start: .space 4
    nr_blocuri: .space 4
    ok: .long 0
    valoare_zero: .long 0
    valoare_ebx: .quad 8
    cod: .space 4
    nr_operatii: .space 4
    valoare_ecx: .long 0
    valoare_ecxx: .long 0
    interval: .long 0
    index: .long 0
.text
.global main
apel_add :
    push %eax    
    push %ebx
    push %ecx
    push %edx
    push %esi

    lea v,%edi
    mov $0,%ecx
    mov $0,%esi

citire_adds:
    push $adds
    push $format_int 
    call scanf
    add $8,%esp

    mov $0,%ebx
    mov $0,valoare_ebx


for_adds:
    mov valoare_ebx,%ebx
    cmp adds,%ebx
    je iesire

    mov $0,%eax # initializam cu 0 start,nr_locuri si ok-ul
    mov %eax,start
    mov %eax,nr_locuri
    mov %eax,ok
    
    push $descriptor # citim descriptor
    push $format_int
    call scanf
    add $8,%esp

    push $dimensiune # citim dimensiunea
    push $format_int
    call scanf
    add $8,%esp

    cmp $9,dimensiune
    jl dimensiune_sub9


    add $7,dimensiune
    mov dimensiune,%eax
    mov $0,%edx
    div x
    mov %eax,nr_blocuri
    sub $7,dimensiune

    mov $0,%ecx
    add $1,valoare_ebx

et_for2: # for-ul de la 0 la n
    cmp n,%ecx
    je inc_ebx

    mov (%edi,%ecx,4),%edx
    cmp %edx,valoare_zero
    je et_for2.2
    mov $0,nr_locuri
    jmp continuare_for

et_for2.2:
    cmp $0,nr_locuri
    je start_i
    add $1,nr_locuri
    jmp continuare_for

start_i:
    mov %ecx,start
    add $1,nr_locuri
    jmp continuare_for
continuare_for:
    mov nr_locuri,%eax
    cmp nr_blocuri,%eax
    je pre_conditie
    add $1,%ecx
    jmp et_for2
pre_conditie:
    mov start,%eax
    mov $1,ok
conditie:
    cmp %eax,%ecx
    jl incrementare
    lea (%edi,%eax,4),%esi
    mov descriptor,%edx
    mov %edx,(%esi)
    add $1,%eax
    jmp conditie
incrementare:
    add $1,%ecx

    sub $1,%eax
    push %eax
    push start
    push descriptor
    push $format_interval
    call printf
    add $16,%esp

    push $0
    call fflush
    add $4,%esp

    add $1,%eax

inc_ebx:
    mov $0,%esi
    cmp %esi,ok
    je afisare_zero
    mov valoare_ebx,%ebx
    jmp for_adds
afisare_zero:
    push $0
    push $0
    push descriptor
    push $format_interval
    call printf
    add $16,%esp

    push $0
    call fflush
    add $4,%esp

    mov valoare_ebx,%ebx
    jmp for_adds
dimensiune_sub9:
    add $1,valoare_ebx
    jmp for_adds
iesire:
    pop %esi
    pop %edx
    pop %ecx
    pop %ebx
    pop %eax
    ret

# operatia get:
apel_get:
    push %eax
    push %ecx   
    push %edx 
    mov $0,%edx
    lea v,%edi


for_get:
    mov $0,%eax # initializam cu 0 start,interval si ok
    mov %eax,start
    mov %eax,interval
    mov %eax,ok

    push $descriptor # citim descriptor
    push $format_int
    call scanf
    add $8,%esp

    mov $0,%ecx

et_for_get: # for-ul de la 0 la n
    cmp n,%ecx
    je afisare_intervale
    
    mov (%edi,%ecx,4),%edx
    cmp %edx,descriptor
    je continuare_for2
    add $1,%ecx
    jmp et_for_get

continuare_for2:
    mov $0,%eax
    mov $1,ok
    cmp interval,%eax
    je start_ii
    add $1,interval
    add $1,%ecx
    jmp et_for_get

start_ii:
    mov %ecx,start
    add $1,interval
    add $1,%ecx
    jmp et_for_get

afisare_intervale:
    cmp $0,ok
    je afisare_zerouri
    mov start,%eax
    add  interval,%eax
    sub $1,%eax

    push %eax
    push start
    push $format_interval_get
    call printf
    add $12,%esp

    push $0
    call fflush
    add $4,%esp

    jmp iesire_get

afisare_zerouri:
    push $0
    push $0
    push $format_interval_get
    call printf
    add $12,%esp

    push $0
    call fflush
    add $4,%esp

iesire_get:
    pop %edx
    pop %ecx
    pop %eax
    ret

# operatia DELETE 
apel_delete:
    push %eax
    push %ebx
    push %ecx   
    push %edx 
    lea v,%edi

citire_descriptor:
    push $descriptor
    push $format_int
    call scanf
    add $8,%esp

    mov $0,%ecx
    mov $0,%edx

for_gasire_descriptor: #for de la 0 la n
    cmp n,%ecx
    je restaurare_ecx
    mov (%edi,%ecx,4),%edx
    cmp descriptor,%edx
    je stergere
    add $1,%ecx
    jmp for_gasire_descriptor

stergere:
    mov $0,(%edi,%ecx,4)
    add $1,%ecx
    jmp for_gasire_descriptor

restaurare_ecx:
    xor %ecx,%ecx
    mov  $0,start
    lea v,%edi
    

afisare_intervale_delete:
    cmp n,%ecx
    je iesire_delete
    mov (%edi,%ecx,4),%edx
    cmp $0,%edx
    jg resetare_start
    add $1,%ecx
    jmp afisare_intervale_delete
resetare_start:
    mov %ecx,start
    mov start,%edx
et_while: 
    cmp %ecx,n
    je afisare_del
    mov (%edi,%edx,4),%ebx
    cmp (%edi,%ecx,4),%ebx
    jne afisare_del
    add $1,%ecx
    jmp et_while
afisare_del:
    sub $1,%ecx
    mov %ecx,valoare_ecxx

    push %ecx
    push start
    push %ebx
    push $format_interval
    call printf
    add $16,%esp

    push $0
    call fflush
    add $4,%esp

    mov valoare_ecxx,%ecx
    add $1,%ecx
    cmp %ecx,n
    je iesire_delete
    jmp afisare_intervale_delete

iesire_delete:
    pop %edx
    pop %ecx
    pop %ebx
    pop %eax
    ret

# operatia DEFRAG 

apel_defrag:
    push %eax
    push %ebx
    push %ecx   
    push %edx 
    push %esi
    lea v,%edi

    mov $0,index
    mov $0,%ecx
for_defrag:
    cmp n,%ecx
    je adaugare_zerouri
    cmp $0,(%edi,%ecx,4)
    jg conditie1_defrag
    add $1,%ecx
    jmp for_defrag

conditie1_defrag:
    mov index,%edx
    mov (%edi,%ecx,4),%eax
    mov %eax,(%edi,%edx,4)
    add $1,index
    add $1,%ecx
    jmp for_defrag

adaugare_zerouri:
    mov index,%ecx

for_2:
    cmp n,%ecx
    je resetare
    mov $0,(%edi,%ecx,4)
    add $1,%ecx
    jmp for_2
resetare:
    mov $0,%ecx
    mov $0,%eax
    mov $0,%ebx


afisare_defrag:
    cmp n,%ecx
    je ies
    mov (%edi,%ecx,4),%edx
    cmp $0,%edx
    jg et_resetare
    add $1,%ecx
    jmp afisare_defrag

et_resetare:
    mov %ecx,start
    mov start,%edx

et_while2: 
    cmp %ecx,n
    je et_pre_ies
    mov (%edi,%edx,4),%ebx
    cmp (%edi,%ecx,4),%ebx
    jne et_pre_ies
    add $1,%ecx
    jmp et_while2

et_pre_ies:
    sub $1,%ecx
    mov %ecx,valoare_ecxx

    push %ecx
    push start
    push %ebx
    push $format_interval
    call printf
    add $16,%esp

    push $0
    call fflush
    add $4,%esp

    mov valoare_ecxx,%ecx
    add $1,%ecx
    cmp %ecx,n
    je ies
    jmp afisare_defrag

ies:
    pop %esi
    pop %edx
    pop %ecx
    pop %ebx
    pop %eax
    ret


main:
    lea v,%edi
    mov $0,%ebx
    mov $0,%ecx
    mov $0,%edx
    mov $0,%eax


    push $nr_operatii
    push $format_int
    call scanf
    add $8,%esp

operatii:
    cmp nr_operatii,%ecx
    je et_exit

    push $cod
    push $format_int
    call scanf
    add $8,%esp

    cmp $1,cod
    je cod_add
    cmp $2,cod
    je cod_get

    cmp $3,cod
    je cod_delete

    cmp $4,cod
    je cod_defrag

cod_add:
    call apel_add
    add $1,valoare_ecx
    mov valoare_ecx,%ecx
    jmp operatii
cod_get:
    call apel_get
    add $1,valoare_ecx
    mov valoare_ecx,%ecx
    jmp operatii
cod_delete:
    call apel_delete
    add $1,valoare_ecx
    mov valoare_ecx,%ecx
    jmp operatii
cod_defrag:
    call apel_defrag
    add $1,valoare_ecx 
    mov valoare_ecx,%ecx 
    jmp operatii
et_exit:
    pushl $0
    call fflush
    popl %eax
    
    mov $1,%eax
    mov $0,%ebx
    int $0x80
