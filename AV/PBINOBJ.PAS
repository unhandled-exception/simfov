
{$O+,F+}

Unit PBinObj ;   { é°Í•§®≠•≠®• ™p†‚≠ÎÂ Æ°Í•™‚Æ¢ }
                 { ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ }


  Interface

    Uses  PVAR, SHELL_X ;


 Procedure DelBinStars ( Cat : Byte ) ;


  Implementation



 Procedure DelBinStars ( Cat : Byte ) ;

  Var

       CExit                      : Boolean ;

       NDel,
       IndOkr,
       IndRep                     : LongInt ;

       X, Y,
       X0, Y0, XMax,
       R0MM, R, R0                : Double  ;

  Begin


    IFirst := IndCat [ Cat ].NBEG ;
    ILast  := IndCat [ Cat ].NEND ;

    SHELLX ( IFirst , ILast ) ;
   {::::::::::::::::::::::::::}

    R0MM   := C20 / SekRad * FD  ;  { R0     in  MM }
    R0     := R0MM * R0MM  ;              { R0**2  in  MM }

    NDel := 0 ;


    For IndRep := IFirst To ILast Do
     Begin

      ObjectRecord := Objectptr [ IndRep Div ObjectBlockSize ]^
                                [ IndRep Mod ObjectBlockSize ] ;

      If ( ObjectRecord.M < 255 )  Then
       Begin

         X0   := ObjectRecord.X  ;
         Y0   := ObjectRecord.Y  ;

         XMax := X0 + R0MM  ;

         IndOkr  := IndRep ;
         CExit   := FALSE  ;

         While (    ( IndOkr < Ilast )
                And ( Not CExit      )  )  Do
          Begin

           Inc ( IndOkr ) ;

           ObjectRecord := Objectptr [ IndOkr Div ObjectBlockSize ]^
                                     [ IndOkr Mod ObjectBlockSize ] ;

           If ( ObjectRecord.M < 255 )  Then
            Begin

             X     := ObjectRecord.X ;
             CExit := X > XMax         ;

             If ( Not CExit )  Then
              Begin

               Y := ObjectRecord.Y ;
               R := Sqr ( X - X0 )  +  Sqr ( Y - Y0 )  ;

               If ( R <= R0 ) Then
                Begin

                   Inc ( NDel ) ;
                   ObjectRecord.M := 255 ;
                   Objectptr [ IndOkr Div ObjectBlockSize ]^
                             [ IndOkr Mod ObjectBlockSize ] := ObjectRecord ;

                End ;  { R <= R0 }

              End ;  { Not CExit }

            End ;  { VIZOKR = 1 }

          End ;  { IndOkr }

       End ;  { VIZ = 1 }

     End ;  { IndRep }



     If ( NDel <> 0 )  Then
       Begin

         IndOkr := IFirst - 1 ;

         For IndRep := IFirst To ILast Do
           Begin

             If ( Objectptr [ IndRep Div ObjectBlockSize ]^
                            [ IndRep Mod ObjectBlockSize ].M <> 255 )  Then
               Begin

                 Inc ( IndOkr ) ;

                 Objectptr [ IndOkr Div ObjectBlockSize ]^
                           [ IndOkr Mod ObjectBlockSize ]   :=
                 Objectptr [ IndRep Div ObjectBlockSize ]^
                           [ IndRep Mod ObjectBlockSize ]  ;

                 If ( B_VectDiagr )  Then
                   Begin
                     PmVect^[ IndOkr ].PmX := PmVect^[ IndRep ].PmX ;
                     PmVect^[ IndOkr ].PmY := PmVect^[ IndRep ].PmY ;
                   End ;

               End ;
              {
              Else
               Begin
                 X0 := 0.0 ;
               End ;
              }
           End ;

           IndCat [ Cat ].NEnd := IndOkr ;
           NumberOfStars := IndOkr + 1 ;

       End ;

  End ;


End.