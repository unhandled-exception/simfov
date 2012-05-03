
{$O+,F+}

Unit Shell_X ;
Interface

Procedure ShellX ( Low , High : Integer );

Implementation
Uses  V_Catal, PVar ;

Procedure ShellX ( Low , High : Integer );
var
 N, Ni, in1, j, L ,
 i1, i2,
 i1d, i1m, i2d, i2m,
 k1, k2             : Integer    ;
 Key1, Key2         : Double     ;
 Dummy              : Objecttype ;
 Ordered            : boolean    ;

Begin

 N := high - low + 1;
 If ( N > 1 ) Then
 Begin

  Ni:=1;
  While ( 9 * Ni < N ) Do Ni:= 3 * Ni + 1;

  While ( Ni >= 1 ) Do
  Begin
   in1 := Ni + 1;
   For j := in1  To  N  Do
   Begin
    L := j - Ni;
    Ordered:=false;

    While ( L >= 1 ) And Not Ordered Do
    Begin

      i1  := L + low - 1      ;
      i2  := L + low - 1 + Ni ;

      i1d := i1 div ObjectBlockSize ;
      i1m := i1 mod ObjectBlockSize ;

      i2d := i2 div ObjectBlockSize ;
      i2m := i2 mod ObjectBlockSize ;

      Key1 := ObjectPtr [i1d]^[i1m].X ;
      Key2 := ObjectPtr [i2d]^[i2m].X ;

      If ( Key1 > Key2 )  Then
       Begin
            { swap records }
        Dummy := ObjectPtr [ i1d ] ^ [ i1m ];
        ObjectPtr [ i1d ] ^ [ i1m ] := ObjectPtr [ i2d ] ^ [ i2m ];
        ObjectPtr [ i2d ] ^ [ i2m ] := Dummy;
        If ( B_VectDiagr )  Then
          Begin
            PmVectRecord  := PmVect^[ i1 ] ;
            PmVect^[ i1 ] := PmVect^[ i2 ] ;
            PmVect^[ i2 ] := PmVectRecord  ;
          End ;
        L := L - Ni;
       End
      Else
        Ordered := True ;
    End;
   End;
   Ni := Trunc ( Ni / 3 );
  End;
 End;


End;
End.