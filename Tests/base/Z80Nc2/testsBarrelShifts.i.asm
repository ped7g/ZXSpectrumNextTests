; Depends on many things set in Main.asm

; ";;DEBUG" mark instructions can be used to intentionally trigger error (test testing)

; This file has tests for: BRLC | BSLA | BSRA | BSRF | BSRL

;;FIXME add tests...

;;;;;;;;;;;;;;;;;;;;;;;; Test BRLC DE,B (1min19s) ;;;;;;;;;;;;;;;;;;
TestFull_Brlc:
    INIT_HEARTBEAT_256
    ld      c,16        ; this will become very handy constant in this test
.LoopAllDe:
    ld      hl,(.DeSource)  ; expected value (unrotated yet)
    ld      b,15
.LoopAllBby1:               ; loop through B 15..0, prepare new expected data every time
    ; RRC hl,1 (produces expected result compared to previous B+1 run)
    ld      a,l
    rra
    rr      h
    rr      l
    or      a           ; CF=0 (for SBC test)
    ld      a,b         ; keep B in A for faster +16 looping
.LoopAllBby16:          ; loop through B+=16 (should produce identical results for all B)
                        ; that eliminates need to touch HL expected value
    ld      de,0        ; load source value for test into DE (B is set)
.DeSource   equ $-2
    db      $ED, $2C    ; BRLC DE,B
    ;res     0,e ;;DEBUG
    sbc     hl,de       ; verify against expected value in HL
    jr      nz,.errorFound
    ex      de,hl       ; restore expected value
    add     a,c         ; calculate next B (+16)
    ld      b,a
    jp      nc,.LoopAllBby16
    dec     b           ; update next B (will modify expected result, as it's -1 only)
    jp      p,.LoopAllBby1
    ld      hl,.DeSource
    inc     (hl)        ; adjust bottom byte of source DE value
    jp      nz,.LoopAllDe
    call    TestHeartbeat   ; will do heartbeat 256 times here
    inc     hl
    inc     (hl)        ; adjust high byte of source DE value
    jp      nz,.LoopAllDe
    ret
.errorFound:
    add     hl,de       ; restore expected value in HL (DE contains obtained value)
    ex      de,hl       ; expected should be in DE, obtained should be in HL
    call    LogAdd1B2W  ; B:B DE:expected DE HL:received DE
    ld      (ix+1),RESULT_ERR   ; set result to ERR
    ret                 ; terminate test

;;;;;;;;;;;;;;;;;;;;;;;; Test BSLA DE,B (?) ;;;;;;;;;;;;;;;;;;
TestFull_Bsla:
    INIT_HEARTBEAT_256
    ld      c,32        ; this will become very handy constant in this test
.LoopAllDe:
    ld      hl,(.DeSource)  ; expected value
    xor     a           ; A (will become B) = 0, CF=0 - it's kept in A for faster +32 loop
    jp      .LoopAllBby32   ; expected value is already OK, CF=0, skip first SLA HL shift
.LoopAllBby1:           ; loop through B 0..31, prepare new expected data every time
    ; SLA hl
    sla     l
    rl      h
    or      a           ; CF=0 (for SBC test)
.LoopAllBby32:          ; loop through B+=32 (should produce identical results for all B)
                        ; that eliminates need to touch HL expected value
    ld      b,a         ; set B for BSLA
    ld      de,0        ; load source value for test into DE
.DeSource   equ $-2
    db      $ED, $28    ; BSLA DE,B
    ;res     7,d ;;DEBUG
    sbc     hl,de       ; verify against expected value in HL
    jr      nz,.errorFound
    ex      de,hl       ; restore expected value
    add     a,c         ; calculate next B (+32 will make BSLA produce same result)
    jp      nc,.LoopAllBby32
    inc     a           ; update next B (will modify expected result, as it's +1 only)
    cp      c
    jp      c,.LoopAllBby1
    ld      hl,.DeSource
    inc     (hl)        ; adjust bottom byte of source DE value
    jr      nz,.LoopAllDe
    call    TestHeartbeat   ; will do heartbeat 256 times here
    inc     hl
    inc     (hl)        ; adjust high byte of source DE value
    jr      nz,.LoopAllDe
    ret
.errorFound:
    add     hl,de       ; restore expected value in HL (DE contains obtained value)
    ex      de,hl       ; expected should be in DE, obtained should be in HL
    call    LogAdd1B2W  ; B:B DE:expected DE HL:received DE
    ld      (ix+1),RESULT_ERR   ; set result to ERR
    ret                 ; terminate test

;;;;;;;;;;;;;;;;;;;;;;;; Test BSRA DE,B (1min21s) ;;;;;;;;;;;;;;;;;;
TestFull_Bsra:
    INIT_HEARTBEAT_256
    ld      c,32        ; this will become very handy constant in this test
.LoopAllDe:
    ld      hl,(.DeSource)  ; expected value
    xor     a           ; A (will become B) = 0, CF=0 - it's kept in A for faster +32 loop
    jp      .LoopAllBby32   ; expected value is already OK, CF=0, skip first SRA HL shift
.LoopAllBby1:           ; loop through B 0..31, prepare new expected data every time
    ; SRA hl
    sra     h
    rr      l
    or      a           ; CF=0 (for SBC test)
.LoopAllBby32:          ; loop through B+=32 (should produce identical results for all B)
                        ; that eliminates need to touch HL expected value
    ld      b,a         ; set B for BSRA
    ld      de,0        ; load source value for test into DE
.DeSource   equ $-2
    db      $ED, $29    ; BSRA DE,B
    ;res     7,d ;;DEBUG
    sbc     hl,de       ; verify against expected value in HL
    jr      nz,.errorFound
    ex      de,hl       ; restore expected value
    add     a,c         ; calculate next B (+32 will make BSRA produce same result)
    jp      nc,.LoopAllBby32
    inc     a           ; update next B (will modify expected result, as it's +1 only)
    cp      c
    jp      c,.LoopAllBby1
    ld      hl,.DeSource
    inc     (hl)        ; adjust bottom byte of source DE value
    jr      nz,.LoopAllDe
    call    TestHeartbeat   ; will do heartbeat 256 times here
    inc     hl
    inc     (hl)        ; adjust high byte of source DE value
    jr      nz,.LoopAllDe
    ret
.errorFound:
    add     hl,de       ; restore expected value in HL (DE contains obtained value)
    ex      de,hl       ; expected should be in DE, obtained should be in HL
    call    LogAdd1B2W  ; B:B DE:expected DE HL:received DE
    ld      (ix+1),RESULT_ERR   ; set result to ERR
    ret                 ; terminate test

;;;;;;;;;;;;;;;;;;;;;;;; Test BSRF DE,B (1min21s) ;;;;;;;;;;;;;;;;;;
TestFull_Bsrf:
    INIT_HEARTBEAT_256
    ld      c,32        ; this will become very handy constant in this test
.LoopAllDe:
    ld      hl,(.DeSource)  ; expected value
    xor     a           ; A (will become B) = 0, CF=0 - it's kept in A for faster +32 loop
    jp      .LoopAllBby32   ; expected value is already OK, CF=0, skip first SRF HL shift
.LoopAllBby1:           ; loop through B 0..31, prepare new expected data every time
    ; SRF hl
    scf
    rr      h
    rr      l
    or      a           ; CF=0 (for SBC test)
.LoopAllBby32:          ; loop through B+=32 (should produce identical results for all B)
                        ; that eliminates need to touch HL expected value
    ld      b,a         ; set B for BSRF
    ld      de,0        ; load source value for test into DE
.DeSource   equ $-2
    db      $ED, $2B    ; BSRF DE,B
    ;res     0,e ;;DEBUG
    sbc     hl,de       ; verify against expected value in HL
    jr      nz,.errorFound
    ex      de,hl       ; restore expected value
    add     a,c         ; calculate next B (+32 will make BSRF produce same result)
    jp      nc,.LoopAllBby32
    inc     a           ; update next B (will modify expected result, as it's +1 only)
    cp      c
    jp      c,.LoopAllBby1
    ld      hl,.DeSource
    inc     (hl)        ; adjust bottom byte of source DE value
    jr      nz,.LoopAllDe
    call    TestHeartbeat   ; will do heartbeat 256 times here
    inc     hl
    inc     (hl)        ; adjust high byte of source DE value
    jr      nz,.LoopAllDe
    ret
.errorFound:
    add     hl,de       ; restore expected value in HL (DE contains obtained value)
    ex      de,hl       ; expected should be in DE, obtained should be in HL
    call    LogAdd1B2W  ; B:B DE:expected DE HL:received DE
    ld      (ix+1),RESULT_ERR   ; set result to ERR
    ret                 ; terminate test
