
{$O+,F+}

UNIT GSCSTARB ;

INTERFACE

     PROCEDURE GSCSTARBIN;

IMPLEMENTATION


USES

   V_CATAL, PVAR, SHELL_X ;



     PROCEDURE GSCSTARBIN  ;


VAR

  EXIT                              : BOOLEAN ;

  SP, SP0                           : BYTE    ;

  IndRep,  IndOkr,
  IRD, IRM, IOD, IOM,
  IndOut, IOuD, IOuM,
  NGR, NFB                          : INTEGER ;

  NUM, NUM0,
  IFIRST, ILAST                     : LONGINT ;

  R0SEC, R0, R0M0, DMvGsc, R, XMAX  : DOUBLE    ;
  X0 , Y0 , M0                      : DOUBLE    ;
  X  , Y  , M                       : DOUBLE    ;



  BEGIN

    IFirst := IndCat [ CatGsc ].NBEG ;
    ILast  := IndCat [ CatGsc ].NEND ;

    SHELLX ( IFirst , ILast ) ;
   {::::::::::::::::::::::::::}

    R0SEC  := 30.0 ;     { R0  in  ArcSec ( Для яpких звезд )       }
    DMvGsc := 25   ;     { DMv пpи осpеднении в гpуппу ( 0.1 Magn ) }

    R0     := R0SEC / SekRad * FD ;  { R0  in  MM }

    IndOut := IFirst - 1 ;


    FOR IndRep := IFirst To ILast DO

     BEGIN

      IRD := IndRep Div ObjectBlockSize ;
      IRM := IndRep Mod ObjectBlockSize ;

      NUM0 := Objectptr [ IRD ] ^ [ IRM ] . NRecCat ;

      IF ( NUM0 > 0 )  THEN

       BEGIN  { VIZ }

         X0  := Objectptr [ IRD ] ^ [ IRM ] . X  ;
         Y0  := Objectptr [ IRD ] ^ [ IRM ] . Y  ;
         M0  := Objectptr [ IRD ] ^ [ IRM ] . M  ;
         SP0 := Objectptr [ IRD ] ^ [ IRM ] . SP ;

         If ( M0 <= 150 )
           Then  R0M0 := R0        {  Для  Mv <= 10.0  }
           Else  R0M0 := R0 / 4 ;  {  Для  Mv >  10.0  }


         XMAX := X0 + R0    ;
         NGR  := 1          ;

         IndOkr  := IndRep ;
         EXIT    := FALSE  ;


         WHILE ( IndOkr <= Ilast ) AND ( NOT EXIT ) DO

          BEGIN

           INC ( IndOkr ) ;

           IOD := IndOkr Div ObjectBlockSize ;
           IOM := IndOkr Mod ObjectBlockSize ;


           NUM := Objectptr [ IOD ] ^ [ IOM ] . NRecCat ;

           IF ( NUM > 0 )  THEN

            BEGIN  { VIZOKR = 1 }

             X := Objectptr [ IOD ] ^ [ IOM ] . X;

             EXIT := X > XMAX;


             IF ( NOT EXIT )  THEN

              BEGIN  { NOT EXIT }

               Y := Objectptr [ IOD ] ^ [ IOM ] . Y;

               R := SQRT ( ( X - X0 ) * ( X - X0 ) +
                           ( Y - Y0 ) * ( Y - Y0 ) ) ;

               M  := Objectptr [ IOD ] ^ [ IOM ] . M;


               IF (     (       R        <=  R0M0  )
                    And ( Abs ( M - M0 ) <= DMvGsc )  )  THEN

                BEGIN  { R <= R0 }

                   SP := Objectptr [ IOD ] ^ [ IOM ] . SP;

                   IF ( SP = 81 )  THEN  SP0 := 81 ;

                   X0 := ( X0 * NGR + X ) / ( NGR + 1 ) ;
                   Y0 := ( Y0 * NGR + Y ) / ( NGR + 1 ) ;
                   M0 := ( M0 * NGR + M ) / ( NGR + 1 ) ;

                   NGR  := NGR + 1  ;
                   XMAX := X0  + R0 ;

                   Objectptr [ IOD ] ^ [ IOM ] . NRecCat := - Num ;

                END ;  { R <= R0 }

              END;   { NOT EXIT }

            END ;  { VIZOKR = 1 }

          END ;  { IndOkr }



         IF ( NGR > 1 )  THEN

          BEGIN

           Objectptr [ IRD ] ^ [ IRM ] . X       :=  X0             ;
           Objectptr [ IRD ] ^ [ IRM ] . Y       :=  Y0             ;
           Objectptr [ IRD ] ^ [ IRM ] . SP      :=  SP0 + NGR - 1  ;
           Objectptr [ IRD ] ^ [ IRM ] . NRecCat := NUM0            ;
           Objectptr [ IRD ] ^ [ IRM ] . M       := ROUND ( M0 )    ;

          END  { NGR > 1 }

         ELSE

          BEGIN  { NGR = 1 }

            Objectptr [ IRD ] ^ [ IRM ] . SP := Sp0 ;

          END ; { NGR = 1 }



         INC ( IndOut ) ;

         IOuD := IndOut Div ObjectBlockSize ;
         IOuM := IndOut Mod ObjectBlockSize ;

         Objectptr [ IOuD ] ^ [ IOuM ]  := Objectptr [ IRD ] ^ [ IRM ]   ;


       END ;  { VIZ = 1 }


     END ;  { IndRep }


     IndCat [ CatGsc ].NEND := IndOut     ;
     NumberOfStars          := IndOut + 1 ;

  END ;

END.