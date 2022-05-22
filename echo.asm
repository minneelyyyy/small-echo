BITS 32

              org     0x08048000

ehdr:                                                 ; Elf32_Ehdr
              db      0x7F, "ELF", 1, 1, 1, 0         ;   e_ident
      times 8 db      0
              dw      2                               ;   e_type
              dw      3                               ;   e_machine
              dd      1                               ;   e_version
              dd      _start                          ;   e_entry
              dd      phdr - $$                       ;   e_phoff
              dd      0                               ;   e_shoff
              dd      0                               ;   e_flags
              dw      ehdrsize                        ;   e_ehsize
              dw      phdrsize                        ;   e_phentsize
              dw      1                               ;   e_phnum
              dw      0                               ;   e_shentsize
              dw      0                               ;   e_shnum
              dw      0                               ;   e_shstrndx

ehdrsize      equ     $ - ehdr

phdr:                                                 ; Elf32_Phdr
              dd      1                               ;   p_type
              dd      0                               ;   p_offset
              dd      $$                              ;   p_vaddr
              dd      $$                              ;   p_paddr
              dd      filesize                        ;   p_filesz
              dd      filesize                        ;   p_memsz
              dd      5                               ;   p_flags
              dd      0x1000                          ;   p_align

phdrsize      equ     $ - phdr

; void print(char *str)
; prints a string
; args:
;    ecx = str
print:
    xor     edx,    edx
  .printloop0:
    cmp     BYTE [ecx+edx], 0
    je      .printloop0end
    inc     edx
    jmp     .printloop0
  .printloop0end:
    mov     ebx,    1
    mov     eax,    4
    int     0x80
    ret

newline:    db      0xa, 0
space:      db      ' ', 0

_start:
    ; [esp] = argc
    ; [esp+4] = argv[0], this is why you must use lea instead of mov
    mov     edi,    DWORD [esp]
    lea     eax,    DWORD [esp+4]

    push    ebp
    mov     ebp,    esp
    sub     esp,    16

    ; edi   = argc
    ; ebp-4 = argv
    ; esi   = i
    mov     DWORD [ebp-4],  eax
    mov     esi,            1

    cmp     edi,  esi
    jle     .endmainloop0

    .startmainloop0:
        mov     ecx,    DWORD [ebp-4]
        mov     ecx,    DWORD [ecx+esi*4]
        call    print

        inc     esi
        cmp     edi,    esi
        je      .endmainloop0

        mov     ecx,    space
        call    print

        jmp     .startmainloop0
  .endmainloop0:

    mov     ecx,    newline
    call    print

  end_start:
    mov     eax,    1
    xor     ebx,    ebx
    int     0x80
    ret

filesize      equ     $ - $$
