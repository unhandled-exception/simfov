
{$F+,O+}


Unit AK_Moz ;

Interface

  Uses

      Dos     ,
      V_Catal ,
      PVar    ,
      Check   ,
      PMem    ,
      PJD8    ,
      PVarMenu,
      PFK4FK5 ,
      PProFld ,
      PRedFin ,
      PPREOLD ,
      Crt     ,
      MLib
               ;

      PROCEDURE AKMoz ( RaOpt, DeclOpt, JdOpt, XMax, YMax : Double;
                        Var NumberOfStars : LongInt ;
                        Var PlateZagol    : PlateZagolPtr ) ;

Implementation


      PROCEDURE AKMoz ( RaOpt, DeclOpt, JdOpt, XMax, YMax : Double;
                        Var NumberOfStars : LongInt ;
                        Var PlateZagol    : PlateZagolPtr ) ;



 Const

    FCDC : Double =     3437.75 ;

    Gr   : Double = Pi / 180.0  ;
    Rg   : Double = 180.0 / Pi  ;


    ZoneObs1B : Array [ 1 .. 19 ]  Of  Shortint = (
               -90, -64, -51, -40, -31, -23, -16,  -9,  -2,   5,
                12,  18,  25,  34,  36,  40,  47,  55, 65           ) ;

    ZoneObs1E : Array [ 1 .. 19 ]  Of  Shortint = (
               -65, -52, -41, -32, -24, -17, -10,  -3,   4,  11,
                17,  24,  33,  35,  39,  46,  54,  64,  90        ) ;

    NameObs  : Array [ 1 .. 19 ] Of String [ 3 ] = (
               'MLB','SYD','CAP','PRT','CRD','SHY','TCB','SNF','ALG','TLS',
               'BRD','PAR','OXF','UCL','NHY','HLS','CAT','VAT','GRN'        );


    ZoneObs2B : Array [ 1 .. 19 ]  Of  Shortint = (
               -90, -64, -51, -40, -31, -23, -16,  -9,  -2,   5,
                11,  18,  25,  34,  36,  40,  47,  52,  65       ) ;

    ZoneObs2E : Array [ 1 .. 19 ]  Of  Shortint = (
               -65, -52, -41, -32, -24, -17, -10,  -3,   4,  10,
                17,  24,  33,  35,  39,  46,  51,  64,  90       ) ;


 Label

     EndMemory ;


 Type

      AkMType = Record
                  M : Byte ;
                End ;



 Var

     BCnstExist,
     FileMozExist, ZagolOk              : Boolean ;

     Tag                                : Char    ;

     CalcPlate, PRedGsc, PhotRed        : Boolean ;

     NDecl , NZagol,
     NDeclZonesMoz                      : Word    ;

     NObs,
     DeclAkCg , RaAkCH , RaAkCM,
     NSerAkZagol, MType                 : Byte    ;

     IM,
     N,
     DeclOptG, DeclOptM, DeclOptGMax,
     DeclOptGPlate                      : Integer ;

     IY,
     JStar, NumStar                     : LongInt ;

     SRaOpt, CRaOpt,
     SDeclOpt, CDeclOpt,
     RaCPlate , DeclCPlete ,
     SRaCPlate, CRaCPlate,
     SDeclCPlate, CDeclCPlate,
     SRaCMoz, CRaCMoz,
     SDeclCMoz, CDeclCMoz,
     RaOptMoz, DeclOptMoz,
     SRaOptMoz, CRaOptMoz,
     SDeclOptMoz, CDeclOptMoz,
     RACD, DECCD,
     RoMaxCG, CRo, CRoMaxC,
     X, Y, Z, XX, YY, ZZ, XSt, YSt, P, S,
     Sr, Cr, Sd, Cd,
     Sp, Cp, Ss, Cs,
     SDa, CDa,
     SPoz, CPoz,
     Mv, Mv1, Mv2, Mv3,
     YPlate,
     Index                                                  : Double  ;

     Dx, Dy,
     X0, Y0,
     Day, Jd0,
{
     AX, BX, CX,
     AY, BY, CY,
}
     D, E,
     DistX, DistY,
     D1, D2,
     KmX, KmY,
{
     A1, B1, A2, B2,
     Cx2, Cy2,
}
     AXAdd, BXAdd, CXAdd,
     AYAdd, BYAdd, CYAdd,

{
     D00    , D01    , D02    , D03    ,
     E00    , E01    , E02    , E03    ,
     Dist0  , Dist1  , Dist2  , Dist3  ,
     D10    , D11    , D12    , D13    ,
     D20    , D21    , D22    , D23    ,
     KMx0   , KMx1   , KMx2   , KMx3   ,
     KMy0   , KMy1   , KMy2   , KMy3   ,
}

     MeanMPPM, MeanMAcPPM, PRedK0PPM, PRedK1PPM, PRedK2PPM,
     MeanMGsc, MeanMAcGsc, PRedK0Gsc, PRedK1Gsc, PRedK2Gsc  : Double ;


     ST, CT, SA, CA, SH,
     T,DT,DT2,DT3,T2,S1,S2,S3,C1,C2,C3                      : Double ;

     AkZagolFileNameMoz           : PathStr ;
     ConstFileNameMoz             : PathStr ;
     ConstAddFileNameMoz          : PathStr ;
     RectCoordFileNameMoz         : PathStr ;
     RStrMoz                      : PathStr ;
     AkMFileName                  : PathStr ;
     ExtFileAkMz                  : ExtStr  ;

     DeclZg, DeclZm    : Array [ 1 .. 30 ]  Of  Integer ;

     AkMFile           : File  Of  AkMType      ;

     AkMRec            :           AkMType      ;
     CObject           :           ObjectType   ;
     ConstRecMoz       :           ConstType    ;
     ConstAddRecMoz    :           ConstAddType ;



 Begin  { PRO CdcMoz }
        { ‹‹‹‹‹‹‹‹‹‹ }
   {
   NumberOfStars := 0 ;
   }
   IndCat [ CatCdcMoz ].RoDet := Param.RoCdcDet ;


          { èÆß®Ê®Æ≠≠Î© „£Æ´ ë•¢•p≠Æ£Æ èÆ´Ó·† }
          { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

   Povorot ( JdCat [ CatCdcMoz ], SPozNp1, CPozNp1 ) ;

   IndCat [ CatCdcMoz ].JdCat   := JdCat [ CatCdcMoz ] ;

   IndCat [ CatCdcMoz ].SPozNp1 := SPozNp1 ;
   IndCat [ CatCdcMoz ].CPozNp1 := CPozNp1 ;



    {  èêÖñÖëëàéHHõÖ èéëíéüHHõÖ  H é Ç õ Ö  }
    {  ===================================  }

   T   := ( JdCat [ CatCdcMoz ] - 2451545.0           ) / 36525.0 ;
   DT  := ( JdOpt               - JdCat [ CatCdcMoz ] ) / 36525.0 ;

   T2  := T   * T  ;
   DT2 := DT  * DT ;
   DT3 := DT2 * DT ;

   S2  :=      ( 2306.2181  + 1.39656  * T   - 0.000139 * T2) * DT  ;
   S1  := S2 + (    0.30188 - 0.000344 * T ) * DT2 + 0.017998 * DT3 ;
   S3  := S2 + (    1.09468 + 0.000066 * T ) * DT2 + 0.018203 * DT3 ;
   S2  :=      ( 2004.3109  - 0.85330  * T - 0.000217 * T2)   * DT  ;
   S2  := S2 - (    0.42665 + 0.000217 * T ) * DT2 - 0.041833 * DT3 ;

   S1  := S1 / SekRad ;
   S2  := S2 / SekRad ;
   S3  := S3 / SekRad ;

   C1  := COS ( S1 ) ;
   C2  := COS ( S2 ) ;
   C3  := COS ( S3 ) ;

   S1  := SIN ( S1 ) ;
   S2  := SIN ( S2 ) ;
   S3  := SIN ( S3 ) ;

         { ƒƒƒƒƒƒƒƒƒƒƒƒ  X  ƒƒƒƒƒƒƒƒƒƒƒƒ }

   NZagol := 0 ;

   SRaOpt   := Sin  ( RaOpt   ) ;
   CRaOpt   := Cos  ( RaOpt   ) ;
   SDeclOpt := Sin  ( DeclOpt ) ;
   CDeclOpt := Cos  ( DeclOpt ) ;

   If ( ( Abs ( Abs ( DeclOpt ) - PiD2 ) ) < 1.0e-9 )
     Then  CDeclOpt := 0.0
     Else  CDeclOpt := Sqrt ( C10 - Sqr ( SDeclOpt ) ) ;


   IndCat [ CatCdcMoz ].SRaOpt    := SRaOpt   ;
   IndCat [ CatCdcMoz ].CRaOpt    := CRaOpt   ;
   IndCat [ CatCdcMoz ].SDeclOpt  := SDeclOpt ;
   IndCat [ CatCdcMoz ].CDeclOpt  := CDeclOpt ;


       { ä - ‚Î  Ê•≠‚p† ØÆ´Ô 1900.0 }
       { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

   RaCD  := RaOpt   ;
   DecCD := DeclOpt ;

   PREOLD ( JdOpt , 2415020.3135 , RACD, DECCD ) ;
  {ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ}

   RaCPlate    := RaCD ;
   DeclCPlete  := DecCD ;

   SRaCPlate   := Sin ( RaCD ) ;
   CRaCPlate   := Cos ( RaCD ) ;

   SDeclCPlate := Sin ( DecCD ) ;
   CDeclCPlate := Cos ( DecCD ) ;


      { îÆp¨®p„•¨ ¨†··®¢ ·™´Æ≠•≠®© ßÆ≠ }
      { ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ }

          { ñ•≠‚p†´Ï≠†Ô Ø´†·‚®≠™† }
          { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

   DeclOptGPlate := Round ( DeclCPlete * Rg ) ;

           { å†··®¢ ·™´Æ≠•≠®© }
           { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

   RoMaxCG := ( ArcTan ( Sqrt ( Sqr ( XMax ) + Sqr ( YMax ) ) / FD ) ) * Rg ;
   RoMaxCG := RoMaxCG + 3.5 ;
   CRoMaxC := Cos ( RoMaxCG * Gr ) ;

   DeclOptG    := DeclOptGPlate - Trunc ( RoMaxCG );
   DeclOptGMax := DeclOptGPlate + Trunc ( RoMaxCG );

   If ( DeclOptG    < -90.0 )  Then
        DeclOptG    := -90 ;
   If ( DeclOptGMax >  90.0 )  Then
        DeclOptGMax :=  90 ;

   NDeclZonesMoz := 0 ;

   While ( DeclOptG <= DeclOptGMax )  Do
     Begin

       Inc ( NDeclZonesMoz ) ;
       DeclZg [ NDeclZonesMoz ] := DeclOptG ;

       If ( DeclOptG <> 11 )
         Then
           Begin
             DeclZm [ NDeclZonesMoz ] := 0 ;
           End
         Else
           Begin
             DeclZm [ NDeclZonesMoz ] := 0 ;
             Inc ( NDeclZonesMoz ) ;
             DeclZg [ NDeclZonesMoz ] := DeclOptG ;
             DeclZm [ NDeclZonesMoz ] := 1 ;
           End ;

       Inc ( DeclOptG ) ;

     End ;  { While }


      { èpÆ·¨Æ‚p áÆ≠ }
      { ƒƒƒƒƒƒƒƒƒƒƒƒ }

   For NDecl := 1  To  NDeclZonesMoz  Do
   Begin  { NDecl }
          { ƒƒƒƒƒ }

        { H†©§•¨ Ø´†·‚®≠™„ ¢ î†©´• á†£Æ´Æ¢™Æ¢ }
        { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

     DeclOptG := DeclZg [ NDecl ] ;
     DeclOptM := DeclZM [ NDecl ] ;

     If ( DeclOptM = 0 )  Then
       Begin

         For N := 1 To 19  Do
           Begin
             If (     ( DeclOptG >= ZoneObs1B [ N ] )
                  And ( DeclOptG <= ZoneObs1E [ N ] ) )
               Then
                    Begin
                      NObs         := N             ;
                      ExtFileAkMz  := NameObs [ N ] ;
                    End ;
           End ;

       End
      Else
       Begin

          For N := 1 To 19  Do
              Begin
                If (     ( DeclOptG >= ZoneObs2B [ N ] )
                     And ( DeclOptG <= ZoneObs2E [ N ] ) )
                  Then
                    Begin
                      NObs         := N             ;
                      ExtFileAkMz  := NameObs [ N ] ;
                    End ;
              End ;

       End ;



     Str ( Abs ( DeclOptG ) : 2 , RStrMoz ) ;
     If ( RStrMoz [ 1 ] = ' ' )  Then  RStrMoz [ 1 ] := '0' ;
     If (  DeclOptG <= 0 )
       Then RStrMoz := 's' + RStrMoz
       Else RStrMoz := 'n' + RStrMoz ;


     AkZagolFileNameMoz   := ParamDir.CdcDir + '\' + RStrMoz +
                             'PList.' + ExtFileAkMz ;
     ConstFileNameMoz     := ParamDir.CdcDir + '\' + RStrMoz +
                             'ACnst.' + ExtFileAkMz ;
     ConstAddFileNameMoz  := ParamDir.CdcDir + '\' + RStrMoz +
                             'BCnst.' + ExtFileAkMz ;
     RectCoordFileNameMoz := ParamDir.CdcDir + '\' + RStrMoz +
                             'PData.' + ExtFileAkMz ;
     AkMFileName          := ParamDir.CdcDir + '\' + RStrMoz +
                             'PMagn.'+ ExtFileAkMz  ;

     FileMozExist := False ;
     BCnstExist   := False ;

     If (      Exist ( ConstFileNameMoz     )
          And  Exist ( ConstAddFileNameMoz  )
          And  Exist ( AkZagolFileNameMoz   )
          And  Exist ( RectCoordFileNameMoz )
          And  Exist ( AkMFileName          )
                                              )  Then

       Begin

         FileMozExist := True ;
         BCnstExist   := True ;

         FileMode     := 0    ;

         Assign ( ConstFileMoz , ConstFileNameMoz    ) ;
            {$I-}
         Reset  ( ConstFileMoz                    ) ;
            {$I+}
         If ( IOResult <> 0 )  Then
            FileMozExist := False ;



         Assign ( ConstAddFileMoz , ConstAddFileNameMoz  ) ;
            {$I-}
         Reset  ( ConstAddFileMoz                        ) ;
            {$I+}
         If ( IOResult <> 0 )  Then
            BCnstExist := False ;


         Assign ( AkZagolFileMoz    , AkZagolFileNameMoz   )  ;
            {$I-}
         Reset  ( AkZagolFileMoz   ) ;
            {$I+}
         If ( IOResult <> 0 )  Then
            FileMozExist := False ;


         Assign ( RectCoordFileMoz  , RectCoordFileNameMoz ) ;
            {$I-}
         Reset  ( RectCoordFileMoz                      ) ;
            {$I+}
         If ( IOResult <> 0 )  Then
            FileMozExist := False ;


         Assign ( AkMFile  , AkMFileName ) ;
            {$I-}
         Reset  ( AkMFile                ) ;
            {$I+}
         If ( IOResult <> 0 )  Then
            FileMozExist := False ;


       End ;

          { èpÆ·¨Æ‚p Ø´†·‚®≠Æ™ áÆ≠Î }
          { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }


     If ( FileMozExist )  Then
     While ( Not Eof ( AkZagolFileMoz ) )  Do
     Begin  { Not Eof ( AkZagolFileMoz ) }

      If ( KeyPressed )  Then
        Begin

          KeyExist := True    ;
          UserKey  := GetKey  ;
          UngetCh ( UserKey ) ;

          If ( UserKey = EscKey )  Then
            Begin
              EndStars := True ;
              GoTo EndMemory ;
            End ;
        End ;

      Read   ( ConstFileMoz    , ConstRecMoz    ) ;
      If ( BCnstExist )
        Then
            Read   ( ConstAddFileMoz , ConstAddRecMoz )
        Else
          Begin
            ConstAddRecMoz.Ax := C10 ;
            ConstAddRecMoz.Bx := 0.0  ;
            ConstAddRecMoz.Cx := 0.0  ;

            ConstAddRecMoz.Ay := 0.0  ;
            ConstAddRecMoz.By := C10  ;
            ConstAddRecMoz.Cy := 0.0  ;
          End ;


             { ó‚•≠®• ·‚pÆ™® á†£Æ´Æ¢™† }
             { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

      Read ( AkZagolFileMoz , AkZagolRecMoz  ) ;
      AkZagolRecMoz .Tag := UpCase ( AkZagolRecMoz .Tag ) ;
      Tag := AkZagolRecMoz .Tag ;
      {
      RaOptMoz   := ( AkZagolRecMoz .RaH  +
                      AkZagolRecMoz .RaM  / C600 ) * Gr * 15.0 ;
      DeclOptMoz :=   AkZagolRecMoz .DcG           * Gr        ;
      }


         { èpÆ¢•p™† p†··‚ÆÔ≠®Ô Ê•≠‚p† Ø´†·‚®≠™® Æ‚ Ê•≠‚p† ØÆ´Ô }
         { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

       { Ñ´Ô  éØ‚. ñ. ¢ '0' X, Y }
       { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

      RaOptMoz   := ConstRecMoz.D ;
      DeclOptMoz := ConstRecMoz.E ;


      CRo := Sin ( DeclOptMoz ) * SDeclCPlate +
             Cos ( DeclOptMoz ) * CDeclCPlate * Cos ( RaOptMoz - RaCPlate ) ;

      CalcPlate := ( CRo > CRoMaxC ) ;
      {
      If (     ( B_Det_CDC And ( AkZagolRecMoz.RaH = AkZagolRec.RaH )
                           And ( AkZagolRecMoz.RaM = AkZagolRec.RaM )
                           And ( AkZagolRecMoz.DcG = AkZagolRec.DcG )
                           And ( AkZagolRecMoz.Tag = AkZagolRec.Tag ) )
            Or ( Not ( CalcPlate )                                    ) )
      }
      If (     ( False     And ( AkZagolRecMoz.RaH = AkZagolRec.RaH )
                           And ( AkZagolRecMoz.RaM = AkZagolRec.RaM )
                           And ( AkZagolRecMoz.DcG = AkZagolRec.DcG )
                           And ( AkZagolRecMoz.Tag = AkZagolRec.Tag ) )
            Or ( Not ( CalcPlate )                                    ) )
       Then
        Begin  { ù‚Æ Ê•≠‚p†´Ï≠†Ô ®´® §†´•™†Ô Ø´†·‚®≠™† }
          CRo := CRoMax ;
        End
       Else
        Begin  { èÆØ†´® }

          ZagolOk := False  ;
          (*
          RACD  := RaOptMoz   ;
          DECCD := DeclOptMoz ;

              { è•p•ÂÆ§   1900  ->  1950  }
              { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ  }

          PREOLD ( 2415020.3135 , 2433282.4234, RACD, DECCD ) ;
         {ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ}

              { è•p•ÂÆ§   1950  ->  2000  }
              { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ  }

          FK4FK5 (  RACD, DECCD ) ;
         {ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ}

          RaOptMoz   := RACD  ;
          DeclOptMoz := DECCD ;
          *)

          SRaOptMoz   := Sin ( RaOptMoz   ) ;
          CRaOptMoz   := Cos ( RaOptMoz   ) ;

          SDeclOptMoz := Sin ( DeclOptMoz ) ;
          CDeclOptMoz := Cos ( DeclOptMoz ) ;



                { ó‚•≠®• á¢•ß§ Ää }
                { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

          MType := AkZagolRecMoz .MeType  ;

          {
          AX := ConstRecMoz.Ax ;
          BX := ConstRecMoz.Bx ;
          CX := ConstRecMoz.Cx ;

          AY := ConstRecMoz.Ay ;
          BY := ConstRecMoz.By ;
          CY := ConstRecMoz.Cy ;

          A1 := ( Ax + By ) / C20 ;
          B1 := ( Bx - Ay ) / C20 ;

          A2 := A1 / Sqrt ( Sqr ( A1 ) + Sqr ( B1 ) ) ;
          B2 := B1 / Sqrt ( Sqr ( A1 ) + Sqr ( B1 ) ) ;

          Cx2 := Cx ;
          Cy2 := Cy ;
          }

          MeanMPPM    := ConstRecMoz.MeanMPPM    ;
          MeanMAcPPM  := ConstRecMoz.MeanMAcPPM  ;
          PRedK0PPM   := ConstRecMoz.K0PPM       ;
          PRedK1PPM   := ConstRecMoz.K1PPM       ;
          PRedK2PPM   := ConstRecMoz.K2PPM       ;

          MeanMGSC    := ConstRecMoz.MeanMGSC    ;
          MeanMAcGSC  := ConstRecMoz.MeanMAcGSC  ;
          PRedK0GSC   := ConstRecMoz.K0GSC       ;
          PRedK1GSC   := ConstRecMoz.K1GSC       ;
          PRedK2GSC   := ConstRecMoz.K2GSC       ;



          AXAdd := ConstAddRecMoz.Ax ;
          BXAdd := ConstAddRecMoz.Bx ;
          CXAdd := ConstAddRecMoz.Cx ;

          AYAdd := ConstAddRecMoz.Ay ;
          BYAdd := ConstAddRecMoz.By ;
          CYAdd := ConstAddRecMoz.Cy ;


            { ê•§„™Ê®Æ≠≠Î• ™Æ≠·‚†≠‚Î é°·•p¢†‚Æp®© }
            { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

          IY   := AkZagolRecMoz.Year ;
          IM   := AkZagolRecMoz.Mon  ;
          DAY  := AkZagolRecMoz.Day  ;


	  JD8 ( IY , IM , DAY , YPlate );
         {ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ}

          YPlate := ( YPlate - 2415020.0 ) / 365.25 + 1900.0 ;


          RedAcFin ( NObs, YPlate ) ;

          (*
          If ( MType = 0 )  Then
            Begin  { Diameter }

              If ( Abs ( PRedK1Gsc ) > 1.0e-6 ) Then
                  Begin
                    If ( PRedK1Gsc * PRedK1Gsc  -
                         4.0 * PRedK2Gsc * ( PRedK0Gsc - 8.5 ) ) > 0.01  Then
                      Begin
                        D70 := ( - PRedK1Gsc -
                               Sqrt ( PRedK1Gsc * PRedK1Gsc  -
                               4.0 * PRedK2Gsc * ( PRedK0Gsc - 8.5 ) ) ) /
                           (   C20 * PRedK2Gsc ) ;
                      End
                     Else
                      Begin  { èÆ®·™ D70 ØÆ PPM }
                        If ( PRedK1PPM < - 0.1 )
                           Then D70 := ( 8.5 - PRedK0PPM ) / PRedK1PPM
                           Else D70 := 10.0 ;
                      End;
                  End
               Else
                  Begin
                    If (  PRedK1PPM < - 0.1 )
                       Then D70 := ( 8.5 - PRedK0PPM ) / PRedK1PPM
                       Else D70 := 10.0 ;
                  End ;

            End ;  { Diameter }

          *)
          If ( Exist ( RectCoordFileNameMoz  )  )  Then
            Begin
                Seek ( RectCoordFileMoz, AkZagolRecMoz.NBeg + 1 ) ;
                Seek ( AkMFile,          AkZagolRecMoz.NBeg + 1 ) ;
            End ;

          If ( Exist ( RectCoordFileNameMoz  )  )  Then
          For JStar := 1 To  AkZagolRecMoz .RecCount  Do
          Begin  { JStar }

            Read ( RectCoordFileMoz , AkStarRecMoz ) ;
            Read ( AkMFile,           AkMRec       ) ;

            NumStar := AkStarRecMoz.N ;
            {
            PhotRed := True ;
            If ( ( NumStar Div 8 ) Mod 2 ) = 1
               Then PhotRed := False ;
            }
            (*
            If ( NumStar Mod 2 = 0 )  Then
              Begin { Mv }
                If (     ( MType = 0 )
                     And ( PhotRed   )  )   Then
                  Begin  { Diameter }
                         { ƒƒƒƒƒƒƒƒ }
                    Mv  :=  Sqrt ( AkStarRecMoz.E Div 16 ) ;
                    If ( AkStarRecMoz.E And 2 = 2 )  Then
                      Mv := 3 ;
                    {
                    If ( Mv < D70 )
                       Then  PRedGsc := True
                       Else  PRedGsc := False ;
                    }
                  End    { Diameter }
                         { ƒƒƒƒƒƒƒƒ }
                 Else

                  Begin { Magnitude }
                        { ƒƒƒƒƒƒƒƒƒ }

                    Mv  := ( AkStarRecMoz.E Div 16 ) / 10 ;
                    If ( AkStarRecMoz.E And 2 = 2 ) Then
                      Mv := 13 ;
                    {
                    If ( Mv > 8.5 )
                       Then  PRedGsc := True
                       Else  PRedGsc := False ;
                    }
                  End ; { Magnitude }
                        { ƒƒƒƒƒƒƒƒƒ }
                *)

                X := ( AkStarRecMoz.X  / 16.0 ) / 10000.0 ;
                Y := ( AkStarRecMoz.Y  / 16.0 ) / 10000.0 ;

                (*
                P := SQRT ( Sqr ( X )  +  Sqr ( Y ) ) ;

                   { îÆ‚Æ¨•‚p®Á•·™†Ô p•§„™Ê®Ô }
                   { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
                If ( PhotRed )  Then
                  Begin  { PhotRed }
                    If ( PRedGsc )   Then
                        Begin
                          Mv :=   ConstAddRecMoz.K0PPM
                                + ConstAddRecMoz.K1PPM  * Mv
                                + ConstAddRecMoz.K2PPM  * Sqr ( Mv )
                                + ConstAddRecMoz.Koma1  * P
                                + ConstAddRecMoz.Koma2  * Sqr ( P ) ;
                        End
                      Else
                        Begin
                          If ( Abs ( PRedK2PPM ) < 99 )
                             Then Mv := PRedK0PPM + PRedK1PPM * Mv
                             Else Mv := 12.0 ;
                        End ;
                  End ;  { PhotRed }
                *)
                (*
                If ( PhotRed )  Then
                  Begin  { PhotRed }
                          Mv :=   ConstAddRecMoz.K0PPM
                                + ConstAddRecMoz.K1PPM  * Mv
                                + ConstAddRecMoz.K2PPM  * Sqr ( Mv )
                                + ConstAddRecMoz.Koma1  * P
                                + ConstAddRecMoz.Koma2  * Sqr ( P ) ;
                  End ;  { PhotRed }

              End ; { Mv }
              *)

            Mv := AkMRec.M ;
            If ( Round ( Mv ) < 254 )
              Then
                Begin
                  Mv := Mv / 10.0 - 5.0 ;
                End
              Else
                Begin
                  Mv := 16.1  ;
                End ;


            If (     ( NumStar Mod 2 = 0 )
                 And ( Mv >= MvMin       )
                 And ( Mv <= MvMax       )  )  Then
              Begin  { á¢•ß§† Øp®£Æ¶†Ô }
                     { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }


                       { ìÁ•‚ éË®°Æ™ í•´•·™ÆØ† }
                       { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

                If (     ( BCnstExist )
                     And ( Mv >=  7.5 )
                     And ( Mv <= 13.0 )
                                        )   Then
                  Begin

                    Mv1 := Mv -  9.5   ;
                    Mv2 := Sqr ( Mv1 ) ;
                    Mv3 := Mv1 * Mv2   ;
                    {
                    D    :=   D00   + D01   * Mv1 + D02   * Mv2 + D03   * Mv3 ;
                    E    :=   E00   + E01   * Mv1 + E02   * Mv2 + E03   * Mv3 ;
                    Dist :=   Dist0 + Dist1 * Mv1 + Dist2 * Mv2 + Dist3 * Mv3 ;
                    D1   :=   D10   + D11   * Mv1 + D12   * Mv2 + D13   * Mv3 ;
                    D2   := + D20   + D21   * Mv1 + D22   * Mv2 + D23   * Mv3 ;
                    KMx  := + KMx0  + KMx1  * Mv1 + KMx2  * Mv2 + KMx3  * Mv3 ;
                    KMy  := + KMy0  + KMy1  * Mv1 + KMy2  * Mv2 + KMy3  * Mv3 ;

                    Dx :=       D * X  * X
                           +    E * X  * Y
                           + Dist * X  * ( Sqr(X) + Sqr(Y) )
                           +  C20 * D1 * X * Y
                           -        D2 * ( Sqr(X) - Sqr(Y) )
                           +  KMx * X                          ;

                    Dy :=       D * X  * Y
                           +    E * Y  * Y
                           + Dist * Y  * ( Sqr(X) + Sqr(Y) )
                           -        D1 * ( Sqr(X) - Sqr(Y) )
                           -  C20 * D2 * X * Y
                           +  KMy * Y                          ;

                    X := X - Dx ;
                    Y := Y - Dy ;
                    }


                          D    :=
                                    D00
                                  + D01   * Mv1
                                  + D02   * Mv2  
                                  + D03   * Mv3 ;
                                  

                          E    :=
                                    E00
                                  + E01   * Mv1
                                  + E02   * Mv2  
                                  + E03   * Mv3  ;

                          DistX :=
                                    DistX0 
                                  + DistX1  * Mv1 
                                  + DistX2  * Mv2
                                  + DistX3  * Mv3 ;

                          DistY :=
                                    DistY0 
                                  + DistY1  * Mv1 
                                  + DistY2  * Mv2  
                                  + DistY3  * Mv3 ;
                          {
                          Dist5X :=
                                    Dist5X0
                                  + Dist5X1  * Mv1
                                  + Dist5X2  * Mv2
                                  + Dist5X3  * Mv3 ;

                          Dist5Y :=
                                    Dist5Y0
                                  + Dist5Y1  * Mv1
                                  + Dist5Y2  * Mv2
                                  + Dist5Y3  * Mv3 ;
                          }
                          D1   :=
                                    D10   
                                  + D11   * Mv1 
                                  + D12   * Mv2  
                                  + D13   * Mv3  ;

                          D2   :=
                                    D20   
                                  + D21   * Mv1 
                                  + D22   * Mv2   
                                  + D23   * Mv3  ;

                          KMx  :=
                                    KMx0   
                                  + KMx1  * Mv1 
                                  + KMx2  * Mv2   
                                  + KMx3  * Mv3  ;

                          KMy  := 
                                    KMy0   
                                  + KMy1  * Mv1 
                                  + KMy2  * Mv2   
                                  + KMy3  * Mv3  ;



                          D    :=   D
                                  + D00t
                                  + D01t  * Mv1
                                  + D02t  * Mv2  
                                  + D03t  * Mv3 ;
                                  

                          E    :=   E
                                  + E00t
                                  + E01t  * Mv1
                                  + E02t  * Mv2  
                                  + E03t  * Mv3  ;

                          DistX :=  DistX
                                  + DistX0t
                                  + DistX1t * Mv1 
                                  + DistX2t * Mv2  
                                  + DistX3t * Mv3 ;

                          DistY :=  DistY
                                  + DistY0t
                                  + DistY1t * Mv1 
                                  + DistY2t * Mv2  
                                  + DistY3t * Mv3 ;
                          {
                          Dist5X :=
                                    Dist5X0
                                  + Dist5X1  * Mv1
                                  + Dist5X2  * Mv2
                                  + Dist5X3  * Mv3 ;

                          Dist5Y :=
                                    Dist5Y0
                                  + Dist5Y1  * Mv1
                                  + Dist5Y2  * Mv2
                                  + Dist5Y3  * Mv3 ;
                          }
                          D1   :=   D1
                                  + D10t  
                                  + D11t  * Mv1 
                                  + D12t  * Mv2  
                                  + D13t  * Mv3  ;

                          D2   :=   D2
                                  + D20t  
                                  + D21t  * Mv1 
                                  + D22t  * Mv2   
                                  + D23t  * Mv3  ;

                          KMx  :=   KMx
                                  + KMx0t  
                                  + KMx1t * Mv1 
                                  + KMx2t * Mv2   
                                  + KMx3t * Mv3  ;

                          KMy  :=   KMy
                                  + KMy0t  
                                  + KMy1t * Mv1 
                                  + KMy2t * Mv2   
                                  + KMy3t * Mv3  ;




                          Dx :=       D * X  * X  
                                 +    E * X  * Y  
                                 +  C20 * D1 * X * Y
                                 -        D2 * ( Sqr(X) - Sqr(Y) ) 
                                 +  KMx * X                          ;


                          Dy :=       D * X  * Y  
                                 +    E * Y  * Y                      
                                 -        D1 * ( Sqr(X) - Sqr(Y) )
                                 -  C20 * D2 * X * Y
                                 +  KMy * Y                          ; 

                          (*
                          If ( NObs = 4 )
                            Then
                              Begin  { Prt }
                                Dx := Dx + DistX * X * Sqrt ( Sqr(X) + Sqr(Y) ) ;
                                Dy := Dy + DistY * Y * Sqrt ( Sqr(X) + Sqr(Y) ) ;
                              End
                            Else
                              Begin
                                Dx := Dx + DistX * X *      ( Sqr(X) + Sqr(Y) ) ;
                                Dy := Dy + DistY * Y *      ( Sqr(X) + Sqr(Y) ) ;
                              End ;
                          *)

                          Dx := Dx + DistX  * X *     ( Sqr(X) + Sqr(Y) ) ;
                          Dy := Dy + DistY  * Y *     ( Sqr(X) + Sqr(Y) ) ;
                          {
                          Dx := Dx + Dist5X * X * Sqr ( Sqr(X) + Sqr(Y) ) ;
                          Dy := Dy + Dist5Y * Y * Sqr ( Sqr(X) + Sqr(Y) ) ;
                          }
                          X := X - Dx ;
                          Y := Y - Dy ;



                  End ; { BCnstExist }




                    { ê•§ 6 Const ( B_Cnst ) }
                    { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

                XSt :=  X * AxAdd  +
                        Y * BxAdd  +
                            CxAdd    ;

                YSt :=  X * AyAdd  +
                        Y * ByAdd  +
                            CyAdd    ;


                     { ùäÇ. äééêÑ. J2000 }
                     { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

                P := SQRT ( XSt * XSt + YSt * YSt ) ;
                S := P / FCDC ;

                If ( S < 1.0E-9 )  Then
                   Begin

                     SR := SRaOptMoz ;
                     CR := CRaOptMoz ;

                     SD := SDeclOptMoz ;
                     CD := CDeclOptMoz ;

                   End
                 Else
                   Begin

                     CP :=  YSt / P ;
                     SP :=  XSt / P ;

                     SS := S / SQRT ( C10  +  S * S ) ;
                     CS := SQRT ( C10 - SS * SS )     ;

                     SD := CS * SDeclOptMoz + SS * CDeclOptMoz * CP ;
                     CD := SQRT ( C10 - SD * SD ) ;

                     If ( Abs ( CD ) < 1.0E-9 )  Then
                         Begin

                           SR  := SRaOptMoz ;
                           CR  := CRaOptMoz ;

                           SDA := SDeclOptMoz ;
                           CDA := CDeclOptMoz ;

                         End
                       Else
                         Begin

                           SDA := ( SS * SP ) / CD ;
                           CDA := ( CS * CDeclOptMoz -
                                    SS * SDeclOptMoz * CP ) / CD ;

                           SR  := SDA * CRaOptMoz + CDA * SRaOptMoz ;
                           CR  := CDA * CRaOptMoz - SDA * SRaOptMoz ;

                         End ;


                   End ;



                  { èêÖñÖëëàü  JdStCat -> JDATEFLD  }
                  { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

               X  :=  CR  *  CD  ;
               Y  :=  SR  *  CD  ;
               Z  :=         SD  ;

               XX := X * C1 - Y * S1 ;
               YY := X * S1 + Y * C1 ;
               ZZ := Z               ;

               X   := XX * C2 - ZZ * S2 ;
               Y   := YY                ;
               Z   := XX * S2 + ZZ * C2 ;

               XX  := X * C3 - Y * S3 ;
               YY  := X * S3 + Y * C3 ;
               ZZ  := Z               ;

               SD := ZZ ;
               CD := SQRT ( 1 - SD * SD ) ;
               SR := YY / CD ;
               CR := XX / CD ;

                  {  ƒƒƒƒƒƒƒƒƒƒ  *  ƒƒƒƒƒƒƒƒƒƒ  }


	       CDA := CR * CRaOpt  +  SR * SRaOpt  ;
	       SDA := SR * CRaOpt  -  CR * SRaOpt  ;

	       CRO := SDeclOpt * SD  +  CDeclOpt * CD * CDA ;


	       SPoz  := CD * SDA ;
	       CPoz  := SD * CDeclOpt - CD * SDeclOpt * CDA ;

	       XSt   := - FD * SPoz / CRO ;
	       YSt   :=   FD * CPoz / CRO ;


               If ( Not ( NPolFix ) )   Then
                  Begin { ë‚†°®´®ß†Ê®Ô Æ·® Y ¢ ß•≠®‚ }
                        { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
                     Index := XSt ;
                     XSt :=   XSt  * CPozNp  -  YSt * SPozNp ;
                     YSt :=  Index * SPozNp  +  YSt * CPozNp ;
                  End ;



                If ( (Abs(XSt) < XMax) And (Abs(YSt) < YMax) )  Then
                 Begin  { XSt, YSt  < X(Y)Max }
                        { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

                   If  ( NumberOfStars mod ObjectBlockSize = 0 )  Then
                         CBlock := NumberOfStars Div ObjectBlockSize ;

                   If (    ( BlockAllocFlag [ CBlock ] )
                        Or ( AllocBlock                )  )  Then

                       Begin  { éÁ•‡•§≠†Ô ß¢•ß§† }
                              { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

                         If ( Not ZagolOk )  Then
                            Begin  { á†≠•·•≠®• á†£Æ´Æ¢™† }
                                   { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
                              ZagolOk   := True       ;
                              NZagol    := NZagol + 1 ;
                              PlateZagol ^ [ NZagol ] :=  AkZagolRecMoz  ;
                            End ;

                         CObject .Sp := 10  ;
                         CObject .Sp := CObject .Sp +
                                      ( AkStarRecMoz.X Mod 8 ) Div 4     ;
                         CObject .Sp := CObject .Sp +
                                      ( AkStarRecMoz.Y Mod 8 ) Div 4 * 2 ;

                         CObject .X      := XSt ;
		         CObject .Y      := YSt ;
			 CObject .NRecC  :=  NZagol +
                                           ( AkStarRecMoz.N Div 1024 ) * 1000 ;

                         CObject.M := Round ( ( MV + 5 ) * 10 ) ;

                         ObjectPtr [ NumberOfStars Div ObjectBlockSize ]^
                                   [ NumberOfStars Mod ObjectBlocksize ] := CObject;

                         If ( IndCat [ CatCdcMoz ].NBeg = -1 )  Then
                              IndCat [ CatCdcMoz ].NBeg := NumberOfStars ;

                         NumberOfStars  :=  NumberOfStars  +   1 ;


                       End    { éÁ•‡•§≠†Ô ß¢•ß§† }
                              { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
                     Else

                        Begin  { End Memory }
                               { ƒƒƒƒƒƒƒƒƒƒ }


                                    {$I-}
                           Reset  ( ConstFileMoz ) ;
                                    {$I+}
                           If ( IOResult = 0 )
                              Then  Close ( ConstFileMoz );

                                    {$I-}
                           Reset  ( ConstAddFileMoz ) ;
                                    {$I+}
                           If ( IOResult = 0 )
                              Then  Close ( ConstAddFileMoz );

                                    {$I-}
                           Reset  ( AkZagolFileMoz ) ;
                                    {$I+}
                           If ( IOResult = 0 )
                              Then  Close ( AkZagolFileMoz );

                                    {$I-}
                           Reset  ( RectCoordFileMoz ) ;
                                    {$I+}
                           If ( IOResult = 0 )
                              Then  Close ( RectCoordFileMoz );


                                    {$I-}
                           Reset  ( AkMFile ) ;
                                    {$I+}
                           If ( IOResult = 0 )
                              Then  Close ( AkMFile );


                           GoTo EndMemory ;

                        End ;  { End Memory }
                               { ƒƒƒƒƒƒƒƒƒƒ }

                 End ;  { XSt, YSt  < X(Y)Max }
                        { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

              End ;  { á¢•ß§† Øp®£Æ¶†Ô }
                     { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

            End ;  { JStar }

        End ;  { èÆØ†´® }

     End ;  { Not Eof ( AkZagolFileMoz ) }



            {$I-}
   Reset  ( ConstFileMoz ) ;
            {$I+}
   If ( IOResult = 0 )
      Then  Close ( ConstFileMoz );

            {$I-}
   Reset  ( ConstAddFileMoz ) ;
            {$I+}
   If ( IOResult = 0 )
      Then  Close ( ConstAddFileMoz );

            {$I-}
   Reset  ( AkZagolFileMoz ) ;
            {$I+}
   If ( IOResult = 0 )
      Then  Close ( AkZagolFileMoz );

            {$I-}
   Reset  ( RectCoordFileMoz ) ;
            {$I+}
   If ( IOResult = 0 )
      Then  Close ( RectCoordFileMoz );

            {$I-}
   Reset  ( AkMFile ) ;
            {$I+}
   If ( IOResult = 0 )
      Then  Close ( AkMFile );



   End ;  { NDecl }
          { ƒƒƒƒƒ }



 EndMemory : ;

 If ( IndCat [ CatCdcMoz ].NBeg <> -1 )  Then
      IndCat [ CatCdcMoz ].NEnd := NumberOfStars - 1 ;

 IndCat [ CatCdcMoz ].TypeCoord := IdCoord ;

 FileMode := 2 ;

 End ;  { PRO CdcMoz }
        { ‹‹‹‹‹‹‹‹‹‹ }

End.
