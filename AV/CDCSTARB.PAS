
{$O+,F+}

Unit CDCSTARB ;

InterFace

     Procedure CdcStarBin;

Implementation


Uses

   V_CATAL, PVAR, SHELL_X ;



     Procedure CdcStarBin  ;


Var

  CExit                              : BOOLEAN ;

  SP, SP0                           : BYTE    ;

  IndRep,  IndOkr,
  IRD, IRM, IOD, IOM,
  IndOut, IOuD, IOuM,
  NGr, NGr1                         : INTEGER ;

  Num, Num0,
  IFIRST, ILAST                     : LONGINT ;
  R0SEC, R0, R0MM, DMvCdc, R, XMax  : DOUBLE  ;
  X0 , Y0 , M0                      : DOUBLE  ;
  X  , Y  , M                       : DOUBLE  ;

  NZagol                            : Word    ;
  Date, Date0                       : Double  ;

  ObjectRecord0,
  ObjectRecord                      : ObjectType ;


  Begin

    IFirst := IndCat [ CatCdcMoz ].NBEG ;
    ILast  := IndCat [ CatCdcMoz ].NEND ;

    SHELLX ( IFirst , ILast ) ;
   {::::::::::::::::::::::::::}

    R0SEC  :=  4.0 ;  { R0  in  ArcSec                           }
    DMvCdc :=  30  ;  { DMv пpи осpеднении в гpуппу ( 0.1 Magn ) }

    R0MM   := R0SEC / SekRad * FD  ;  { R0     in  MM }
    R0     := R0MM * R0MM  ;              { R0**2  in  MM }

    IndOut := IFirst - 1 ;


    For IndRep := IFirst To ILast Do

     Begin

      IRD := IndRep Div ObjectBlockSize ;
      IRM := IndRep Mod ObjectBlockSize ;

      ObjectRecord0 := Objectptr [ IRD ] ^ [ IRM ] ;

      Num0 := ObjectRecord0 . NRecC ;

      If ( Num0 >= 0 )  Then

       Begin  { VIZ }

         X0   := ObjectRecord0 . X  ;
         Y0   := ObjectRecord0 . Y  ;
         M0   := ObjectRecord0 . M  ;

         NZagol     := Num0 Mod 1000 ;
         AkZagolRec := PlateZagol ^ [ NZagol ]  ;
         Date0      := AkZagolRec.Year + ( AkZagolRec.Mon - 0.5 ) / 12.0 ;

         XMax := X0 + R0MM  ;
         NGr  := 1          ;

         IndOkr  := IndRep ;
         CExit    := FALSE  ;

         While ( IndOkr <= Ilast ) And ( Not CExit ) Do

          Begin

           INC ( IndOkr ) ;

           IOD := IndOkr Div ObjectBlockSize ;
           IOM := IndOkr Mod ObjectBlockSize ;

           ObjectRecord := Objectptr [ IOD ] ^ [ IOM ] ;
           Num := ObjectRecord . NRecC ;

           If ( Num >= 0 )  Then

            Begin  { VIZOKR = 1 }

             X    := ObjectRecord . X ;
             CExit := X > XMax         ;

             If ( Not CExit )  Then
              Begin

               M := ObjectRecord . M ;
               Y := ObjectRecord . Y ;
               R := Sqr ( X - X0 )  +  Sqr ( Y - Y0 )  ;

               If (     (       R        <=  R0    )
                    And ( Abs ( M - M0 ) <= DMvCdc )  )
                 Then
                Begin

                   NGr1 := NGr + 1 ;

                   X0 := ( X0 * NGr + X ) / NGr1 ;
                   Y0 := ( Y0 * NGr + Y ) / NGr1 ;
                   M0 := ( M0 * NGr + M ) / NGr1 ;

                   NZagol     := Num0 Mod 1000 ;
                   AkZagolRec := PlateZagol ^ [ NZagol ] ;
                   Date       :=   AkZagolRec.Year +
                                 ( AkZagolRec.Mon  - 0.5 ) / 12.0 ;
                   Date0      := ( Date0 * NGr + Date ) / NGr1 ;

                   Inc ( NGr ) ;
                   XMax := X0  + R0MM ;

                   Objectptr [ IOD ] ^ [ IOM ] . NRecC := - 1 ;

                End ; { R <= R0 }

              End;

            End ;  { VIZOKR = 1 }

          End ;  { IndOkr }



         If ( NGr > 1 )
           Then
             Begin { NGr > 1 }
               ObjectRecord0 . X     :=  X0                    ;
               ObjectRecord0 . Y     :=  Y0                    ;
               ObjectRecord0 . SP    :=  10 + NGr              ;
               ObjectRecord0 . M     := Round ( M0 )           ;
               ObjectRecord0 . NRecC := Num0                   ;
               ObjectRecord0 . Date  := Trunc ( Date0 * C100 ) ;
             End  { NGr > 1 }
           Else
             Begin  { Осpеднения не было }
               NZagol     := Num0 Mod 1000 ;
               AkZagolRec := PlateZagol ^ [ NZagol ] ;
               Date0      :=   AkZagolRec.Year +
                               ( AkZagolRec.Mon  - 0.5 ) / 12.0 ;
               ObjectRecord0 . Date  := Trunc ( Date0 * C100 ) ;
             End ;  { Осpеднения не было }

         Inc ( IndOut ) ;

         IOuD := IndOut Div ObjectBlockSize ;
         IOuM := IndOut Mod ObjectBlockSize ;

         Objectptr [ IOuD ] ^ [ IOuM ]  := ObjectRecord0  ;


       End ;  { VIZ = 1 }


     End ;  { IndRep }



     IndCat [ CatCdcMoz ].NEnd := IndOut ;
     NumberOfStars := IndOut + 1 ;


  End ;

End.