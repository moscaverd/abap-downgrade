CALL TRANSFORMATION abap RESULT XML aaa.(null) REPORT k.
 METHOD x.
DATA a1 TYPE any.
DATA a2 TYPE any.
oref->meth(
IMPORTING p1 = a1
EXPORTING p2 = a2
IMPORTING p2 = a2
).

DATA cnt TYPE any.
FIND x IN z MATCH COUNT cnt.

DATA wa TYPE any.
LOOP AT itab INTO wa.

ENDLOOP.
LOOP AT itab INTO wa.

ENDLOOP.

ENDMETHOD.