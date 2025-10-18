.data
    matrix: .space 4194304
    newMatrix: .space 4194304
    columnIndex: .long 0
    lineIndex: .long 0
    lineIndex2: .long 0
    columnIndex2: .long 0
    lines: .long 1024
    columns: .long 1024
    n: .long 1024
    newline: .asciz "\n"
    formatPrintf: .asciz "%d "
    formatAdds: .asciz "%d"
    adds: .space 4
    descriptor: .space 4
    dimensiune: .space 4
    ind: .space 4
    nr_blocuri: .long 0
    x: .long 8
    startX: .space 4
    startY: .space 4
    endX: .space 4
    endY: .space 4
    alocat : .space 4
    index_for: .space 4
    index_for2: .space 4
    nr_blocuri_libere: .space 4
    linie_start: .space 4
    formatInterval: .asciz "%d: ((%d, %d), (%d, %d))\n"
    formatGet: .asciz "((%d, %d), (%d, %d))\n"
    nr_operatii: .space 4
    cod: .space 4
    valoare_ecx: .long 0
    comparator : .long 0
    interval: .long 0
    start: .long 0
    linie: .long 0
    inceput: .space 4
    valoare_inceput: .space 4
    colInd: .long 0
    cnt: .long 0
    valoare: .long 0
    valoare_eax: .long 0
    columnIndex3: .long 0
    newCol: .long 0
    newRow: .long 0
    newLineIndex: .long 0
    newColumnIndex: .long 0
    k: .long 0


.text
.global main
# main:
#    lea matrix,%edi

apel_add:
    lea matrix,%edi
    push %eax    
    push %ebx
    push %ecx
    push %edx

citire_adds:
    push $adds
    push $formatAdds
    call scanf
    add $8,%esp

    mov $0,ind

et_while:
    mov ind,%ecx
    cmp adds,%ecx
    je iesire

    push $descriptor # citim descriptor
    push $formatAdds
    call scanf
    add $8,%esp

    push $dimensiune # citim dimensiunea
    push $formatAdds
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

    mov $-1,startX
    mov $-1,startY
    mov $-1,endX
    mov $-1,endY
    mov $0,alocat
    mov $0,lineIndex

for_lines_1:

    mov lineIndex,%ecx # cautam pe linii
    cmp lines,%ecx
    je afisare_zerouri
    
    mov $0,nr_blocuri_libere
    mov $-1,linie_start

    mov $0,columnIndex
    lea matrix,%edi

    for_columns_1:
        mov columnIndex,%ecx
        cmp columns,%ecx
        # je afisare_intervale
        # add $1,index_for2
        je continuare_for_lines_1

        movl lineIndex, %eax
        mull columns
        add columnIndex, %eax

        # prelucrare
        cmp $0,(%edi,%eax,4)
        je conditie_primul_for
        mov $0,nr_blocuri_libere
        mov $-1,linie_start

        add $1,columnIndex
        jmp for_columns_1

    continuare_for_lines_1 :
        add $1,lineIndex
        jmp for_lines_1

conditie_primul_for: # v[i][j] == 0
    add $1,nr_blocuri_libere
    cmp $-1,linie_start
    jne conditie2
    # mov columnIndex,linie_start
    mov columnIndex,%edx
    mov %edx,linie_start
    jmp conditie2

conditie2: # nr_blocuri == nr_blocuri_libere
    mov nr_blocuri,%edx
    cmp nr_blocuri_libere,%edx
    je atribuiri
    add $1,columnIndex
    jmp for_columns_1

atribuiri: 
    mov lineIndex,%edx
    mov %edx,startX
    mov %edx,endX
    mov linie_start,%edx
    mov %edx,startY 
    mov columnIndex,%edx
    mov %edx,endY
    mov $1,alocat

    mov startX,%edx
    mov %edx,lineIndex2
    add $1,%edx
    mov %edx,comparator

    # aici trebuie pus for-ul cu v[startx]
    for_lines_2: # for(int columnIndex2=startY;columnIndex2<=endY;columnIndex2++)
        mov lineIndex2,%ecx
        cmp comparator,%ecx
        je afisare_intervale

        mov startY,%edx
        # mov startY,columnIndex2
        mov %edx,columnIndex2
        lea matrix,%edi

        for_columns_2:

            mov columnIndex2,%ecx
            cmp endY,%ecx
            jg continuare_for_lines_2
                
            movl lineIndex2, %eax
            mov $0,%edx
            mull columns
            add columnIndex2, %eax

            mov descriptor,%edx
            mov %edx,(%edi,%eax,4)

            add $1,columnIndex2
            jmp for_columns_2
            
        continuare_for_lines_2:
            add $1,lineIndex2
            jmp for_lines_2

        afisare_zerouri:

            cmp $1,alocat
            je afisare_intervale
            push $0
            push $0
            push $0
            push $0
            push descriptor
            push $formatInterval
            call printf
            add $24,%esp

            push $0
            call fflush
            add $4,%esp

            add $1,ind
            jmp et_while

        afisare_intervale:
            push endY
            push startX
            push startY
            push startX
            push descriptor
            push $formatInterval
            call printf
            add $24,%esp

            push $0
            call fflush
            add $4,%esp

            add $1,ind
            jmp et_while

dimensiune_sub9:
    add $1,ind
    jmp et_while

iesire: 
    pop %edx
    pop %ecx
    pop %ebx
    pop %eax
    ret

apel_get:
    push %eax
    push %ebx
    push %ecx
    push %edx
    lea matrix,%edi

citire_descriptor:
    push $descriptor
    push $formatAdds
    call scanf
    add $8,%esp 

    mov $0,linie
    mov $0,interval
    mov $0,start
    mov $0,lineIndex
for_i:
    mov lineIndex,%ecx
    cmp %ecx,n 
    je afisare_int

    mov $0,columnIndex
    lea matrix,%edi

    for_j:
    mov columnIndex,%ecx
    cmp %ecx,n
    je continuare_for_i

    movl lineIndex, %eax
    mov $0,%edx
    mull columns
    add columnIndex, %eax
    mov descriptor,%ebx
    cmp %ebx,(%edi,%eax,4)
    je cond_fori

    add $1,columnIndex
    jmp for_j 
continuare_for_i:
    add $1,lineIndex
    jmp for_i
cond_fori:
    mov lineIndex,%edx
    mov %edx,linie
    cmp $0,interval
    je start_j
    add $1,interval 
    add $1,columnIndex
    jmp for_j
start_j:
    mov columnIndex,%edx
    mov %edx,start
    add $1,interval
    add $1,columnIndex
    jmp for_j

afisare_int:
    mov interval,%edx
    add start,%edx
    sub $1,%edx
    cmp $0,interval
    je afisare_zero_

    push %edx
    push linie
    push start
    push linie
    push $formatGet
    call printf
    add $20,%esp

    push $0
    call fflush
    add $4,%esp
    jmp ies
afisare_zero_:
    push $0
    push $0
    push $0
    push $0
    push $formatGet
    call printf
    add $20,%esp

    push $0
    call fflush
    add $4,%esp
ies:
    pop %edx
    pop %ecx
    pop %ebx
    pop %eax
    ret

apel_del:
    lea matrix,%edi
    push %eax
    push %ebx
    push %ecx
    push %edx

citiri:
    push $descriptor
    push $formatAdds
    call scanf
    add $8,%esp

    mov $0,lineIndex
for_line:
    mov lineIndex,%ecx
    cmp n,%ecx
    je resetari 

    mov $0,columnIndex
    lea matrix,%edi
    for_col:
    mov columnIndex,%ecx
    cmp %ecx,n 
    je con 

    movl lineIndex, %eax
    mull columns
    add columnIndex, %eax

    mov descriptor,%edx
    cmp %edx,(%edi,%eax,4)
    je stergere_desc

    add $1,columnIndex
    jmp for_col
con:
    add $1,lineIndex
    jmp for_line
stergere_desc:
    mov $0,%edx
    mov %edx,(%edi,%eax,4)
    add $1,columnIndex
    jmp for_col        

resetari:
    mov $0,lineIndex
    mov $0,inceput

et_for_line:
    mov lineIndex,%ecx
    cmp n,%ecx
    je et_iesire

    mov $0,columnIndex
    lea matrix,%edi

    et_for_col:

    mov columnIndex,%ecx
    cmp %ecx,n 
    je et_con 

    movl lineIndex, %eax
    mull columns
    add columnIndex, %eax

    mov $0,%edx
    cmp %edx,(%edi,%eax,4)
    jne et_continuare # if v[i][j]!=0

    add $1,columnIndex
    jmp et_for_col
et_con:
    add $1,lineIndex
    jmp et_for_line

et_continuare: 
    mov columnIndex,%edx
    mov %edx,inceput
    mov %edx,colInd

    movl lineIndex, %eax
    mull columns
    add colInd, %eax

    mov (%edi,%eax,4),%edx
    mov %edx,valoare_inceput # mutam v[i][start] in valoare_inceput

numarare_interval:
    mov columnIndex,%ecx
    cmp %ecx,n 
    je afisare_intervale_del 

    movl lineIndex, %eax
    mull columns
    add columnIndex,%eax

    mov (%edi,%eax,4),%edx
    cmp %edx,valoare_inceput
    jne afisare_intervale_del

    add $1,columnIndex
    jmp numarare_interval

afisare_intervale_del:
    mov columnIndex,%ebx
    sub $1,%ebx

    push %ebx
    push lineIndex
    push inceput
    push lineIndex
    push valoare_inceput
    push $formatInterval
    call printf
    add $24,%esp

    push $0
    call fflush
    add $4,%esp

  
    jmp et_for_col
et_iesire:
    pop %edx
    pop %ecx
    pop %ebx
    pop %eax
    ret
apel_defrag:
    push %eax
    push %ebx
    push %ecx
    push %edx 
resetare_new_matrix:
    mov $0,lineIndex
    lea newMatrix,%esi
    for_newMatrix:
    mov lineIndex,%ecx
    cmp n,%ecx
    je initializari
    mov $0,columnIndex
        for_newMatrix_col:
        mov columnIndex,%ecx
        cmp n,%ecx
        je newMatrix_cont
        movl lineIndex, %eax
        mull columns
        add columnIndex, %eax
        mov $0,(%esi,%eax,4)
        add $1,columnIndex
        jmp for_newMatrix_col
    newMatrix_cont:
        add $1,lineIndex
        jmp for_newMatrix


initializari:
    lea matrix,%edi
    mov $0,lineIndex
    mov $0,newLineIndex
    mov $0,columnIndex3
    mov $0,newCol
    mov $0,newRow
    mov $0,k
    mov $0,cnt


et_forr_line:
    mov lineIndex,%ecx
    cmp n,%ecx
    je resetari_defrag

    mov $0,columnIndex
    lea matrix,%edi

    et_forr_cols:

    mov columnIndex,%ecx
    cmp %ecx,n 
    je et_contt

    movl lineIndex, %eax
    mull columns
    add columnIndex, %eax

    mov $0,%edx
    cmp %edx,(%edi,%eax,4)
    jne conditie_dif_zero 

    add $1,columnIndex
    jmp et_forr_cols

et_contt:
    add $1,lineIndex
    jmp et_forr_line

conditie_dif_zero:
    mov (%edi,%eax,4),%edx
    mov %edx,valoare 
    mov $0,cnt
    mov %eax,valoare_eax

et_whl:
    mov columnIndex,%ebx
    mov %ebx,columnIndex3 
    add cnt,%ebx
    cmp %ebx,n # comparam j + cnt cu nr coloane
    je conditie_rand_curent

    # add cnt,columnIndex3 # matrix[i][j+count]

    mov cnt,%edx
    add %edx,columnIndex3

    movl lineIndex, %eax
    mov $0,%edx
    mull columns
    add columnIndex3, %eax
    mov (%edi,%eax,4),%ebx
    cmp %ebx,valoare # matrix[i][j+cnt] == valoare 
    jne conditie_rand_curent

    add $1,cnt
    jmp et_whl

conditie_rand_curent: # if (newCol + count > cols)
    mov newCol,%edx
    add cnt,%edx 
    cmp n,%edx 
    jg incr_newRow
    jmp for_matrice_noua
incr_newRow:
    add $1,newRow
    mov $0,newCol

for_matrice_noua:
    mov newRow,%edx
    mov %edx,newLineIndex
    lea newMatrix,%esi
    mov newCol,%edx
    mov %edx,newColumnIndex
    mov $0,k

    for_matrice_noua_coloane:
    mov k,%edx
    cmp %edx,cnt
    je final

    movl newLineIndex,%eax
    mov $0,%edx
    mull columns
    add newColumnIndex, %eax
    mov valoare,%edx
    mov %edx,(%esi,%eax,4)

    add $1,newColumnIndex
    add $1,newCol
    add $1,k
    jmp for_matrice_noua_coloane

final:
    mov cnt,%edx
    add columnIndex,%edx
    mov %edx,columnIndex
    sub $1,columnIndex
    add $1,columnIndex
    jmp et_forr_cols



resetari_defrag:
    mov $0,lineIndex
    mov $0,inceput
    lea newMatrix,%esi

et_for_line_defrag:
    mov lineIndex,%ecx
    cmp n,%ecx
    je copiere_matrice

    mov $0,columnIndex
    lea newMatrix,%esi

    et_for_col_defrag:

    mov columnIndex,%ecx
    cmp %ecx,n 
    je et_con_defrag

    movl lineIndex, %eax
    mull columns
    add columnIndex, %eax

    mov $0,%edx
    cmp %edx,(%esi,%eax,4)
    jne et_continuare_defrag # if v[i][j]!=0

    add $1,columnIndex
    jmp et_for_col_defrag
et_con_defrag:
    add $1,lineIndex
    jmp et_for_line_defrag

et_continuare_defrag: 
    mov columnIndex,%edx
    mov %edx,inceput
    mov %edx,colInd

    movl lineIndex, %eax
    mull columns
    add colInd, %eax

    mov (%esi,%eax,4),%edx
    mov %edx,valoare_inceput # mutam v[i][start] in valoare_inceput

numarare_interval_defrag:
    mov columnIndex,%ecx
    cmp %ecx,n 
    je afisare_intervale_delf

    movl lineIndex, %eax
    mull columns
    add columnIndex,%eax

    mov (%esi,%eax,4),%edx
    cmp %edx,valoare_inceput
    jne afisare_intervale_delf

    add $1,columnIndex
    jmp numarare_interval_defrag

afisare_intervale_delf:
    mov columnIndex,%ebx
    sub $1,%ebx

    push %ebx
    push lineIndex
    push inceput
    push lineIndex
    push valoare_inceput
    push $formatInterval
    call printf
    add $24,%esp

    push $0
    call fflush
    add $4,%esp

    jmp et_for_col_defrag

copiere_matrice:
    mov $0,lineIndex # matrix[lineIndex][columnIndex] = newMatrix[lineIndex][columnIndex]
    lea matrix,%edi
    lea newMatrix,%esi

    for_lines_copiere:
        mov lineIndex,%ecx
        cmp n,%ecx
        je iesire_defrag

        mov $0,columnIndex
        lea matrix,%edi
        lea newMatrix,%esi

        for_columns_copiere:

        mov columnIndex,%ecx
        cmp n,%ecx
        je continuare_copiere

        mov lineIndex,%eax
        mov $0,%edx
        mull n 
        addl columnIndex,%eax

        movl (%esi,%eax,4),%ebx
        mov %ebx,(%edi,%eax,4)


        add $1, columnIndex
        jmp for_columns_copiere

    continuare_copiere:

        incl lineIndex 
        jmp for_lines_copiere

iesire_defrag:
    pop %edx
    pop %ecx
    pop %ebx
    pop %eax
    ret


main: 
    lea matrix,%edi

    push $nr_operatii
    push $formatAdds
    call scanf
    add $8,%esp

    mov $0,%ebx
    mov $0,%ecx
    mov $0,%edx
    mov $0,%eax
    mov $0,valoare_ecx

operatii:
    cmp nr_operatii,%ecx
    je et_exit

    push $cod
    push $formatAdds
    call scanf
    add $8,%esp

    cmp $1,cod
    je cod_add

    cmp $2,cod
    je cod_get

    cmp $3,cod
    je cod_del

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
cod_del:
    call apel_del
    add $1,valoare_ecx
    mov valoare_ecx,%ecx
    jmp operatii
cod_defrag:
    call apel_defrag
    add $1,valoare_ecx
    mov valoare_ecx,%ecx
    jmp operatii

et_exit:
    push $0
    call fflush
    add $4,%esp

    mov $1,%eax
    mov $0,%ebx
    int $0x80