
{$O+,F+}

UNIT PDELS ;


   { ìÑÄãÖçàÖ äÄíÄãéïçõï à éíéÜÑÖëíÇãÖççõï éÅ'ÖäíéÇ àá èéãü áêÖçàü }
   { ************************************************************* }


INTERFACE

     PROCEDURE DELS ( CatRef , CatDet  : BYTE ;
                                ROKR   : Double  { ARCSEC } ) ;

IMPLEMENTATION


USES

  PVAR ,
  DATA   ;



     PROCEDURE DELS ( CatRef , CatDet  : BYTE ;
                                ROKR   : Double  { ARCSEC } ) ;


VAR

  EXIT                    : BOOLEAN ;

  VIZ, SCLASS             : BYTE    ;

  INDREP, IND,
  IREFBEG, IREFEND,
  IDETBEG, IDETEND,
  INDREF, I, I1, I2       : INTEGER ;

  R0, R                   : Double    ;
  XMIN, XMAX              : Double    ;
  X0 , Y0                 : Double    ;
  X  , Y                  : Double    ;



  BEGIN { PRO IDSTARS }

    R0      := ROKR / SekRad * FD ;   {  R0  ,  MM  }
                                      { ----------- }
    IREFBEG := IndCat [ CatRef ] . NBEG ;
    IREFEND := IndCat [ CatRef ] . NEND ;

    IDETBEG := IndCat [ CatDet ] . NBEG ;
    IDETEND := IndCat [ CatDet ] . NEND ;



          {  èéàëä éèéêçéÉé éÅ'ÖäíÄ  }
          {  ----------------------  }


    FOR INDREF := IREFBEG  TO  IREFEND  DO

       BEGIN  { INDREF }


          VIZ := Objectptr [ INDREF div ObjectBlockSize ]^
                           [ INDREF mod ObjectBlockSize ].VM ;

          VIZ := VIZ DIV 16 * 16 ;

          Objectptr [ INDREF div ObjectBlockSize ]^
                    [ INDREF mod ObjectBlockSize ].VM := VIZ ;



           X0 := objectptr [ INDREF div ObjectBlockSize ]^
                           [ INDREF mod ObjectBlockSize ].X;


           Y0 := objectptr [ INDREF div ObjectBlockSize ]^
                           [ INDREF mod ObjectBlockSize ].Y;


           XMIN   := X0 - R0    ;
           XMAX   := X0 + R0    ;



                { FIND IND. }
                { --------- }

           I1 := IDETBEG  ;
           I2 := IDETEND  ;


           WHILE ( (I2-I1) > 1 ) DO

           BEGIN  { I2-I1 > 1 }

            I := ( I1 + I2 ) DIV 2 ;

            X := objectptr [ I div ObjectBlockSize ]^
                           [ I mod ObjectBlockSize ].X;

            IF  ( X <= XMIN )  THEN

                I1 := I

             ELSE

                I2 := I ;


           END ; { I2-I1 > 1 }


           EXIT :=  X >= XMAX  ;




          { ìÑÄãÖçàÖ  éíéÜÑÖëíÇãüÖåõï  éÅ'ÖäíéÇ  éäéãé  éèéêçõï  }
          { ---------------------------------------------------- }



           IF ( NOT  EXIT )  THEN

             BEGIN  { NOT EXIT }

              FOR  IND :=  I1  TO  I2  DO

               BEGIN  { INDDET }


                  X := objectptr [ IND div ObjectBlockSize ]^
                                 [ IND mod ObjectBlockSize ].X;

                  Y := objectptr [ IND div ObjectBlockSize ]^
                                 [ IND mod ObjectBlockSize ].Y;


                  R := SQRT ( ( X - X0 ) * ( X - X0 ) +
                              ( Y - Y0 ) * ( Y - Y0 ) ) ;


                  IF ( R <= R0 )  THEN

                     BEGIN  { R < R0 }

                       VIZ := objectptr [IND div ObjectBlockSize]^
                                        [IND mod ObjectBlockSize].VM ;

                       VIZ := VIZ DIV 16 * 16 ;

                       objectptr [IND div ObjectBlockSize]^
                                 [IND mod ObjectBlockSize].VM := VIZ ;

                     END ; { R <= R0 }

               END ; { INDDET }

             END ;  { NOT EXIT }

       END ;  { INDREF }

  END ;  { PRO  DELS }

BEGIN
END.
