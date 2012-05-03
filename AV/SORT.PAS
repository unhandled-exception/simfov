
{$O+,F+}

Unit Sort;    { Сортировка объектов в поле зрения }

Interface

  Procedure SortObjectsInField;
  Procedure SortPlanetsInField;
  Procedure Shell ( WhatToSort : Byte ; Low , High : Integer );

Implementation

  Uses
    V_Catal, PVar;

  Const
    SortStars    = 1;
    SortPlanets  = 2;



Procedure Shell ( WhatToSort : Byte ; Low , High : Integer );
Var
 n, ni, in1, j, l ,
 i1d, i1m,
 i2d, i2m,
 i1, i2           : Integer   ;
 Key1, Key2       : Double    ;
 DummyS           : ObjectType;
 PlanetRec1,
 PlanetRec2       : PlanetType;
 Ordered          : Boolean   ;
Begin

  n := high - low + 1;

  If ( n > 1 ) Then
  Begin
    ni:=1;
    While ( 9 * ni < n ) Do ni:= 3 * ni + 1;

    While ( ni >= 1 ) Do
    Begin
      in1 := ni + 1;

      For j:=in1 to n Do
      Begin
        l:= j - ni;
        Ordered:=false;

        While ( l >= 1 ) And Not Ordered Do
        Begin

          i1 := l + low - 1;
          i2 := l + low - 1 + ni;

          i1d := i1 div objectblocksize ;
          i1m := i1 mod objectblocksize ;

          i2d := i2 div objectblocksize ;
          i2m := i2 mod objectblocksize ;

          Case WhatToSort of
            SortStars   :
              Begin
                Key1:=ObjectPtr[i1d]^[i1m].X ;
                Key2:=ObjectPtr[i2d]^[i2m].X ;
              End;

            SortPlanets :
             If ( NPlanetsInFild > 0 )  Then
              Begin

                PlanetRec1 := PlanetPtr [ I1 Div PlanetBlockSize ]^
                                        [ I1 Mod PlanetBlockSize ] ;

                If PlanetRec1.Visible
                  Then
                    Begin
                      NPl := PlanetRec1.Nr ;
                      If ( NPl <= 11 )
                        Then
                          Key1 := Sqrt (   Sqr ( RectCoordPl [ NPl , 1 ] )
                                         + Sqr ( RectCoordPl [ NPl , 2 ] )
                                         + Sqr ( RectCoordPl [ NPl , 3 ] )
                                         - Sqr ( R_PLANETS   [ NPl     ] ) )
                        Else
                          Key1:=PlanetRec1.R ;
                    End
                  Else
                      Key1 := 0 ;


                PlanetRec2 := PlanetPtr [ I2 Div PlanetBlockSize ]^
                                        [ I2 Mod PlanetBlockSize ] ;

                If PlanetRec2.Visible
                  Then
                    Begin
                      NPl := PlanetRec2.Nr ;
                      If ( NPl <= 11 )
                        Then
                          Key2 := Sqrt (   Sqr ( RectCoordPl [ NPl , 1 ] )
                                         + Sqr ( RectCoordPl [ NPl , 2 ] )
                                         + Sqr ( RectCoordPl [ NPl , 3 ] )
                                         - Sqr ( R_PLANETS   [ NPl     ] ) )
                        Else
                          Key2:=PlanetRec2.R ;
                    End
                  Else
                      Key2 := 0 ;

              End;
          End;

          If ( Key1 > Key2 )  Then
            Begin

              { swap records }
              { ------------ }

            Case WhatToSort of
              SortStars   :
                Begin
                  DummyS :=  ObjectPtr [i1d]^[i1m] ;
                  ObjectPtr [i1d]^[i1m] := ObjectPtr [i2d]^[i2m];
                  ObjectPtr [i2d]^[i2m] := DummyS;
                  If ( B_VectDiagr )  Then
                     Begin
                       PmVectRecord  := PmVect^[ i1 ] ;
                       PmVect^[ i1 ] := PmVect^[ i2 ] ;
                       PmVect^[ i2 ] := PmVectRecord  ;
                     End ;
                End;

              SortPlanets :
              If ( NPlanetsInFild > 0 )  Then
                Begin

                  PlanetPtr [ I1 Div PlanetBlockSize ]^
                            [ I1 Mod PlanetBlockSize ] := PlanetRec2 ;

                  PlanetPtr [ I2 Div PlanetBlockSize ]^
                            [ I2 Mod PlanetBlockSize ] := PlanetRec1 ;

                End;
            End;

            l := l- ni;

          End

         Else
            Ordered := True;
        End;

      End;

    ni := trunc ( ni / 3 );

    End;

  End;

End;




Procedure  SortObjectsInField ;

Var

  NSort : Integer ;

Begin

  For NSort := 1 To CatMax Do
    Begin

      Ifirst := IndCat [ NSort ].NBeg ;
      ILast  := IndCat [ NSort ].NEnd ;

      If  (  Ifirst  > -1  )  Then
         Begin

           Shell ( SortStars, Ifirst , ILast ) ;
           CatSort [ NSort ] := True ;

         End ;

    End ;

 Shell ( SortPlanets , 1 , NPlanetsInFild ) ;

End;


Procedure SortPlanetsInField ;
 Begin
   Shell ( SortPlanets, 1, NPlanetsInFild  );
 End;

End.