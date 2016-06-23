READ TABLE X INTO DATA(z) INDEX 2.

DATA(a)=value d((f)(x)).

x = 1+2.

CALL TRANSFORMATION abap RESULT XML DATA(aa).

REPORT k.
METHOD x.


oref->meth( IMPORTING p1 = DATA(a1)
            EXPORTING p2 = DATA(a2)
            IMPORTING p2 = a2
).

FIND x IN z MATCH COUNT DATA(cnt).

LOOP AT itab INTO DATA(wa).

ENDLOOP.

LOOP AT itab INTO wa.
ENDLOOP.
ENDMETHOD.
