
{$O+,F+}

Unit Shl_X_Ac ;
Interface

Procedure ShellXAcMain ( Low , High : Longint );

Implementation
Uses  V_Catal, PVar ;

Procedure ShellXAcMain ( Low , High : Longint );
Var
 Ind,
 n, ni, in1, j, l ,
 i1, i2,
 i1d, i1m, i2d, i2m,
 k1, k2             : Longint   ;
 key1, key2         : Double    ;
 dummy              : Longint   ;
 ordered            : boolean   ;
Begin

  If (  MaxAvail-GraphBuffSize > SizeOf ( AcMainNumArr ) )   Then
     Begin  { Памяти достаточно }
            { ----------------- }
       If ( FlagAcMainNumAlloc = False )  Then
          Begin
            GetMem ( AcMainNum , SizeOf ( AcMainNumArr ) );
            FlagAcMainNumAlloc := True ;
            Dummy := 0 ;
            For Ind := IndCat [ CatCdc ].NBeg  To  IndCat [ CatCdc ].NEnd Do
              Begin
                AcMainNum ^ [ Ind ] := Dummy ;
                Inc ( Dummy ) ;
              End ;
          End ;
     End    { Памяти достаточно }
            { ----------------- }
   Else
            FlagAcMainNumAlloc := False ;

 If  ( FlagAcMainNumAlloc )  Then
   Begin

     n := high - low + 1;
     If ( n > 1 ) Then
       Begin

         ni:=1;
         While ( 9 * ni < n ) Do ni:= 3 * ni + 1;

         While ( ni >= 1 ) Do
           Begin
             in1 := ni + 1;
             for j:=in1 to n Do
               Begin
                 l:= j - ni;
                 ordered:=false;

                 While ( l >= 1 ) And Not ordered Do
                   Begin

                     i1 := l + low - 1      ;
                     i2 := l + low - 1 + ni ;

                     i1d := AcMainNum ^ [ i1 ] Div ObjectBlockSize ;
                     i1m := AcMainNum ^ [ i1 ] Mod ObjectBlockSize ;

                     i2d := AcMainNum ^ [ i2 ] Div ObjectBlockSize ;
                     i2m := AcMainNum ^ [ i2 ] Mod ObjectBlockSize ;

                     key1 := ObjectPtr [i1d] ^ [i1m].X ;
                     key2 := ObjectPtr [i2d] ^ [i2m].X ;

                     If ( key1 > key2 )  Then
                       Begin
                              { swap records }
                         dummy := AcMainNum ^ [ i1 ]  ;
                         AcMainNum ^ [ i1 ] := AcMainNum ^ [ i2 ] ;
                         AcMainNum ^ [ i2 ] := dummy;
                         l := l- ni;
                       End
                      Else
                         ordered:=true;
                   End;
               End;
             ni := trunc(ni / 3 );
           End;
       End;
   End ;


End;
End.
