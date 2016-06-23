READ TABLE tb INTO DATA(line) INDEX 2.

DATA(line) = tb[3].

DATA x TYPE i.
x = 1 + 2.

CALL TRANSFORMATION source_trans RESULT XML DATA(result_trans).

REPORT repo_name.

METHOD method_name.

  oref->meth( IMPORTING param1 = DATA(valueA)
              EXPORTING param2 = DATA(valueB)
              IMPORTING param3 = var_x
              ).

FIND value_ IN data_ MATCH COUNT DATA(cnt).

LOOP AT itab INTO DATA(wa).

ENDLOOP.

LOOP AT itab INTO wa.
ENDLOOP.
ENDMETHOD.

DATA(a)=value d((f)(x)).
