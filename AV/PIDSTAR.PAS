
{$O+,F+}

UNIT PIDSTAR ;

INTERFACE

     PROCEDURE IDSTAR ( VAR   ROMAX    : Double    ;
                              MINPAIRS : INTEGER ;
                              CATREF   : BYTE    ;
                              CATDET   : BYTE    ;
                              FLMINREF : Double    ;
                              FLMINDET : Double    ;
                        VAR   NPAIRS   : INTEGER ;
                        VAR   MQE      : Double    ) ;

IMPLEMENTATION


USES

  PVAR ,
  PLSQ ,
  DATA   ;

     PROCEDURE IDSTAR ( VAR   ROMAX    : Double    ;
                              MINPAIRS : INTEGER ;
                              CATREF   : BYTE    ;
                              CATDET   : BYTE    ;
                              FLMINREF : Double    ;
                              FLMINDET : Double    ;
                        VAR   NPAIRS   : INTEGER ;
                        VAR   MQE      : Double    ) ;


VAR


  EXIT, ERROR, VIZ, VIZD            : BOOLEAN ;


  INDREP, IND0, IND, ISAO, INDOKR,
  INDREF,  NGR, NFB, I, I1, I2,
  IREFBEG, IREFEND,
  IDETBEG, IDETEND,
  PIND, SIND, D, DMAX               : INTEGER ;


  R0SEC, R0, R, MAXOC               : Double    ;
  FLREF, FLDET                      : Double    ;
  XMIN, XMAX                        : Double    ;
  X0 , Y0                           : Double    ;
  X  , Y                            : Double    ;


  XTO, YTO, XFROM, YFROM, RESIDUAL  : VECTOR  ;
  ResultX, ResultY                  : Vector3 ;

  SelectedObject                    : Array [ 1 .. VectSize * 2 ] OF INTEGER ;



BEGIN { PRO IDSTARS }


 EXIT := FALSE ;

 DMAX  := 1000 ;


 WHILE ( NOT EXIT ) DO

  BEGIN { NOT EXIT }


    NPAIRS := 1 ;
    R0     := ROMAX / SekRad * FD ;   { R0  IN  MM  }


    IREFBEG := IndCat [ CatRef ] . NBEG ;
    IREFEND := IndCat [ CatRef ] . NEND ;

    IDETBEG := IndCat [ CatDet ] . NBEG ;
    IDETEND := IndCat [ CatDet ] . NEND ;



          {  FIND  CATREF  }
          {  ------------  }

    FOR INDREF :=  IREFBEG  To  IREFEND  DO

     BEGIN  { INDREF }


       FLREF := objectptr [ INDREF div ObjectBlockSize ]^
                          [ INDREF mod ObjectBlockSize ].F ;

       IF ( FLREF <= FLMINREF )  THEN

         BEGIN  { çÄâÑÖç  éèéêíçõâ éÅ'Öäí }
                { ----------------------- }

           X0 := objectptr [ INDREF div ObjectBlockSize ]^
                           [ INDREF mod ObjectBlockSize ].X;


           Y0 := objectptr [ INDREF div ObjectBlockSize ]^
                           [ INDREF mod ObjectBlockSize ].Y;


           NGR    := 0          ;


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



           IF ( NOT  EXIT )  THEN

             BEGIN  { NOT EXIT }


                { FIND PAIRS FOR  CATREF }
                { ---------------------- }

               IND := I1 ;

               WHILE ( ( IND <= I2  ) AND ( NOT EXIT ) )  DO

                 BEGIN  { WHILE }


                   FLDET := objectptr [ IND div ObjectBlockSize ]^
                                      [ IND mod ObjectBlockSize ].F ;

                   IF  ( FLDET >= FLMINDET )  THEN

                     BEGIN


                        X := objectptr [IND div ObjectBlockSize ]^
                                       [IND mod ObjectBlockSize ].X;


                        Y := objectptr [ IND div ObjectBlockSize ]^
                                       [ IND mod ObjectBlockSize ].Y;

                        R := SQRT ( ( X - X0 ) * ( X - X0 ) +
                                    ( Y - Y0 ) * ( Y - Y0 ) ) ;


                        IF ( R <= R0 )  THEN

                           BEGIN  { R < R0 }

                              NGR  := NGR + 1  ;
                              EXIT := NGR > 1  ;

                              IF ( NOT EXIT )  THEN

                                 BEGIN

                                   INDOKR := IND ;

                                 END ;

                           END ; { R <= R0 }

                     END ;  { VIZ }

                   INC ( IND ) ;

                 END ;  { WHILE  FIND PAIRS }

             END ;  { NOT EXIT }


          IF ( NGR = 1 )  THEN

            BEGIN

              selectedobject [ 2 * NPAIRS     ] := INDOKR ;
              selectedobject [ 2 * NPAIRS - 1 ] := INDREF ;

              NPAIRS := NPAIRS + 1 ;  { 1 STAR }

              EXIT := EXIT OR ( NPAIRS > VectSize );

            END ;

         END ; { çÄâÑÖç  éèéêíçõâ éÅ'Öäí }

     END ;  { INDREF }



    EXIT := FALSE ;

    NPAIRS := NPAIRS - 1 ;

    IF (  NPAIRS < MINPAIRS  )  THEN
       BEGIN
           EXIT := TRUE ;
       END ;


    WHILE ( NOT EXIT )  DO

    BEGIN  { WHILE NOT EXIT }

     FOR  PIND :=1  TO  NPAIRS  DO

      BEGIN

       sind := selectedobject [ 2 * pind - 1 ] ;

       xto [ pind ]   := objectptr [ sind div ObjectBlockSize ]^
                                   [ sind mod ObjectBlockSize ].X;

       yto [ pind ]   := objectptr [ sind div ObjectBlockSize ]^
                                   [ sind mod ObjectBlockSize ].Y;

       sind := selectedobject [ 2 * pind  ];

       xfrom [ pind ] := objectptr [ sind div ObjectBlockSize ]^
                                   [ sind mod ObjectBlockSize ].X;
       yfrom [ pind ] := objectptr [ sind div ObjectBlockSize ]^
                                   [ sind mod ObjectBlockSize ].Y;

      END ;


      LsqSolve ( NPairs  , xfrom   , yfrom , xto , yto ,
                 resultx , resulty , error , residual ) ;


      IF ( ERROR )  THEN

       BEGIN

         NPAIRS  := 0    ;
         MQE     := 0.0  ;
         EXIT    := TRUE ;

       END

      ELSE

       BEGIN  { NOT ERROR }


            { CONTROL O - C }
            { ------------- }

        MQE   := 0 ;
        MAXOC := 0 ;


        FOR I := 1 TO NPAIRS DO

          BEGIN

            R := RESIDUAL [ I ] ;

            IF ( R > MAXOC )  THEN

              BEGIN

                MAXOC := R ;
                IND   := I ;

              END ;

            MQE := MQE + R * R ;

          END ;


        MQE := SQRT ( MQE / ( NPAIRS - 1 ) ) ;


        IF ( MAXOC > R0 )  THEN

           BEGIN

             FOR I := ( IND * 2 + 1 )   TO  NPAIRS * 2  DO

                 SelectedObject [ I - 2 ] :=  SelectedObject [ I ] ;

             NPAIRS  := NPAIRS - 1 ;

             EXIT    := NPAIRS < MINPAIRS ;

           END

          ELSE

             EXIT := TRUE ;


       END ; { NOT ERROR }

    END ;  { WHILE NOT EXIT }



    IF ( NPAIRS >= MINPAIRS )  THEN

     BEGIN  { NP>= MINPAIRS }

      FOR  SIND := IDETBEG  TO  IDETEND   DO

       BEGIN  { SIND }


             { Modify coordinates }
             { ------------------ }

           X := Objectptr [ sind div ObjectBlockSize ]^
                          [ sind mod ObjectBlockSize ].X ;

           Y := Objectptr [ sind div ObjectBlockSize ]^
                          [ sind mod ObjectBlockSize ].Y ;

           Objectptr [ sind div ObjectBlockSize ]^
                     [ sind mod ObjectBlockSize ].X :=
                     X * resultx [ 1 ] + Y * resultx [ 2 ] + resultx [ 3 ] ;

           Objectptr [ sind div ObjectBlockSize ]^
                     [ sind mod ObjectBlockSize ].Y :=
                     X * resulty [ 1 ] + Y * resulty [ 2 ] + resulty [ 3 ] ;


       END ;  { SIND }

     END ;  { NP>= MINPAIRS }


    EXIT := TRUE ;


  END ;  { NOT EXIT }


 END ;  { PRO  IDSTARS }

BEGIN
END.
