; $MODE = "UniformRegister"
; $UNIFORM_VARS[0].name = "uRCPScreenSize"
; $UNIFORM_VARS[0].type = "vec2"
; $UNIFORM_VARS[0].count = 1
; $UNIFORM_VARS[0].offset = 0
; $UNIFORM_VARS[0].block = -1
; $ATTRIB_VARS[0].name = "aPosition"
; $ATTRIB_VARS[0].type = "vec2"
; $ATTRIB_VARS[0].location = 0
; $ATTRIB_VARS[1].name = "aColour"
; $ATTRIB_VARS[1].type = "vec4"
; $ATTRIB_VARS[1].location = 1

; Semantic 0: aTexCoord
; $NUM_SPI_VS_OUT_ID = 1
; $SPI_VS_OUT_ID[0].SEMANTIC_0 = 0

; ALU: (2 * aPosition * uRCPScreenSize) - 1.0f
; uRCPScreenSize is the reciprocal of the screen size, calc'd on CPU
; This gives a range from -1.0f to 1.0f for coordinates
; Since GX2 uses Cartesian coordinates, with positive Y *upwards*, we also
; invert the Y axis (01.1:y). This needs to happen for aPosition and aTexCoord.

00 CALL_FS NO_BARRIER
01 ALU: ADDR(32) CNT(5)
    0 x: MUL*2   R1.x,  R1.x,  C0.x
      y: MUL*2   R1.y,  R1.y,  C0.y
    1 x: ADD     R1.x,  R1.x, -1.0f
      y: ADD     R1.y, -R1.y,  1.0f
02 EXP_DONE: POS0, R1.xy01
03 EXP_DONE: PARAM0, R2.xyzw NO_BARRIER
END_OF_PROGRAM

; https://github.com/decaf-emu/decaf-emu/blob/master/tools/latte-assembler/resources/grammar.txt
