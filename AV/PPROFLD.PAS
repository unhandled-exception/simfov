
{$O+,F+}

Unit PProFld ;

Interface


Procedure RecalcObjects ;
Procedure ResetObjects  ;
Procedure ScToId   ( ScX, ScY : Double ; Var IdX, IdY : Double );
Procedure XYEpOut  ( Cat : Byte ; Var PmRa, PmDecl, XSt, YSt : Double ) ;
Procedure IdToEq1  ( XSt, YSt : Double  ;  Var  Ra, Decl : Double ) ;
Procedure IdToEq   ( ox,oy : Double; npfix : boolean; spnp, cpnp : Double; Var ora, odc : double );
Procedure RadToGms ( x : Double ; Var neg : boolean; Var g, m : integer ; Var s : Double );
Procedure RadToHms ( x : Double ; Var h, m : integer ; Var s : Double );
Procedure Povorot  ( JDate : Double; Var SPoz, CPoz : Double ) ;
Procedure RaDcHip  ( Var Ra, Decl, PmRa, PmDecl : Double ) ;

Implementation

Uses

   PVar , V_Catal , PPreNew, PPreNXyz, PGalEkv, PATan2  ;

Var

    SClas  : Byte ;

    IFirst,
    ILast  : LongInt ;

    ANod,
    Index,
    TNOD, RANOD, DECLNOD,
    SRANOD,   CRANOD,
    SDECLNOD, CDECLNOD,
    STNOD,    CTNOD,
    SANOD,    CANOD,
    SHNOD,    CHNOD     : Double ;



Procedure RecalcObjects;
Var
 MvFirst      : Boolean ;
 Ind          : Integer ;
 Mplanet      : Double  ;
 dx, dy       : Double  ;
 D,
 DxSc, DySc   : Double  ;
 DxObj,DyObj  : Double  ;

Begin

 { è•‡•¢Æ§ ™ÆÆ‡§®≠†‚ ¢ Ì™‡†≠≠Î•  }
 { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ  }

 With sw Do
   Begin

     Dx := ( x2 - x1 + 1 ) / C20 ;
     Dy := ( y2 - y1 + 1 ) / C20 ;

     DxSc := XOrient * GScale / XMax * Dx  ;
     DySc := YOrient * GScale / YMax * Dy  ;

   End ;

 MvFirst := True ;

 If  ( Not CalcVectDiagr )  Then
 Begin

  For SClas  := 1 To CatMax Do
    Begin

      IFirst := IndCat [ SClas  ].NBEG ;
      ILast  := IndCat [ SClas  ].NEND ;

      If  (     ( ILast >= IFirst                       )
            And ( IndCat [ SClas  ].TypeCoord = IdCoord )  )   Then
        Begin

          If ( MvFirst )  Then
            Begin

              MvMinIzo :=  1000        ;
              MvMin    := MvMinParam   ;

              MvMaxIzo := -1000        ;
              MvMax    := MvMaxParam   ;

              MvFirst := False ;

            End ;

          IndCat  [ SClas  ].TypeCoord := 0     ;
          CatSort [ SClas  ]           := False ;

          For Ind := IFirst To ILast  Do
            With  ObjectPtr [ Ind Div ObjectBlockSize ] ^
                            [ Ind Mod ObjectBlockSize ]   Do
              Begin

                If ( Not  CalcVectDiagr )  Then
                  Begin

                    DxObj := ( X - CenterX ) * DxSc ;
                    DyObj := ( Y - CenterY ) * DySc ;

                    X  :=  Dx + DxObj ;
                    Y  :=  Dy - DyObj ;

                  End ;

                If (     ( CalcVectDiagr          )
                     And (    ( SClas  = CatCdc )
                           Or ( SClas  = CatHip )
                           Or ( SClas  = CatTyc )
                           Or ( SClas  = CatNpm )
                           Or ( SClas  = CatPpm ) )  )   Then
                   Begin   { ë‚pÆ®¨ ëÆ°·‚¢•≠≠Î• §¢®¶•≠®Ô }
                           { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

                     DxObj := ( PmVect^[Ind].PmX / C1270 * XMax - CenterX ) *
                                DxSc ;
                     DyObj := ( PmVect^[Ind].PmY / C1270 * YMax - CenterY ) *
                                DySc ;

                   End ;


                If (      ( Abs ( DyObj ) <= Dy )
                     And  ( Abs ( DxObj ) <= Dx ) )  Then
                  Begin  { Ç ØÆ´• ßp•≠®Ô }
                         { ƒƒƒƒƒƒƒƒƒƒƒƒƒ }

                        Begin

                          If (     Not (     ( SClas  = CatImp )
                                         And ( B_Inport_Ccd    ) )
                               And     ( SClas  <> CatGcVs       ) )  Then
                            Begin
                              If ( SClas  <> CatA20 )
                                Then
                                  Begin
                                    If ( M > MvMaxIzo )
                                      Then  MvMaxIzo := M ;

                                    If ( M < MvMinIzo )
                                      Then  MvMinIzo := M ;
                                  End
                                Else
                                  Begin {PMM}

                                    If ( ( ( Sp Mod 10 ) And 1 ) = 0 )  Then
                                      Begin
                                        If ( M+50 > MvMaxIzo )
                                          Then  MvMaxIzo := M+50 ;

                                        If ( M+50 < MvMinIzo )
                                          Then  MvMinIzo := M+50 ;
                                      End ;
                                  End ;

                            End ;

                        End ;

                  End ; { Ç ØÆ´• ßp•≠®Ô }
                        { ƒƒƒƒƒƒƒƒƒƒƒƒƒ }

              End ;

        End ;

    End ;


      { è´†≠•‚Î }
      { ƒƒƒƒƒƒƒ }

 If ( Not ReCalcPlanets ) Then
  Begin

   For Ind := 1 To NPlanetsInFild Do
    If PlanetPtr [ Ind Div PlanetBlockSize ] ^
                 [ Ind Mod PlanetBlockSize ].Visible Then
      With  PlanetPtr [ Ind Div PlanetBlockSize ] ^
                      [ Ind Mod PlanetBlockSize ]   Do
        Begin

          X  :=  Dx + ( X - CenterX ) * DxSc ;
          Y  :=  Dy - ( Y - CenterY ) * DySc ;

          D := D_IZO * GScale / XMax * (sw.x2-sw.x1+1) / C20;
          {}
          If (     ( Not StarsInFild                )
               And ( Nr <> NPlOpt                   )
               And ( Nr <> NPl0                     )
               And ( Nr <> 10                       )
               And ( Nr <= Max_PL_PPLFLD            )
              {And ( ( NPl0 = 3 ) And ( Nr <> 11 )  ) }
                                                       )  Then
             Begin

                Mplanet := ( M + 5.0 ) * C100 ;

                If (     (  Not  B_Import_Fld  )
                     And (  Not  B_VectDiagr   )
                                                  )  Then
                  Begin
                    If ( Mplanet > MvMaxIzo )   Then
                         MvMaxIzo := Mplanet ;
                    If ( Mplanet < MvMinIzo )   Then
                         MvMinIzo := Mplanet ;
                  End ;

             End ;
             {}
        End ;

   If ( NPointSatMark > 0 )  Then
     For Ind := 1 To NPointSatMark  Do
       With  SatEartchPoint^ [ Ind ]  Do
         Begin
           X  :=  Dx + ( X - CenterX ) * DxSc ;
           Y  :=  Dy - ( Y - CenterY ) * DySc ;
         End ;

   ReCalcPlanets := True ;

 End ;

 End ; { Not CalcVectDiagr }


 If ( MvMaxIzo > - 1000 )
   Then
     MvMax := MvMaxIzo / C100 - 5.0 + 0.01
   Else
     MvMax := MvMaxParam ;

 If ( MvMinIzo < 1000 )
   Then
     MvMin := MvMinIzo / C100 - 5.0 - 0.01
   Else
     MvMin := MvMinParam ;

End;





Procedure ResetObjects ;
Var
 NSort,
 Ind            : integer ;
 dx, dy         : Double  ;
 DxSc, DySc     : Double  ;
Begin

 { è•‡•¢Æ§ ™ÆÆ‡§®≠†‚ ¢ ®§•†´Ï≠Î•  }

If ( Not CalcVectDiagr )  Then
Begin  { Not CalcVectDiagr }

 With sw Do
   Begin
     Dx := ( x2 - x1 + 1 )  ;
     Dy := ( y2 - y1 + 1 )  ;
     DxSc := XMax / GScale * XOrient / Dx  ;
     DySc := YMax / GScale * YOrient / Dy  ;
   End ;


 For NSort := 1 To CatMax Do
    Begin

      IFirst := IndCat [ NSort ].NBEG ;
      ILast  := IndCat [ NSort ].NEND ;

      If  (     ( ILast >= IFirst                       )
            And ( IndCat [ NSort ].TypeCoord <> IdCoord )  )   Then
        Begin

          IndCat  [ NSort ].TypeCoord := IdCoord ;
          CatSort [ NSort ]           := False   ;

          For Ind := IFirst To ILast Do
            With  ObjectPtr [ Ind Div ObjectBlockSize ] ^
                            [ Ind Mod ObjectBlockSize ]    Do
              Begin
                If ( Not CalcVectDiagr )  Then
                  Begin
                    X := CenterX + ( C20 * X - Dx ) * DxSc ;
                    Y := CenterY - ( C20 * Y - Dy ) * DySc ;
                  End ;
              End ;
        End ;
    End ;


        { è´†≠•‚Î }
        { ƒƒƒƒƒƒƒ }

 If ( ReCalcPlanets )  Then
   Begin

     For Ind := 1 To NPlanetsInFild  Do
       If PlanetPtr [ Ind Div PlanetBlockSize ] ^
                    [ Ind Mod PlanetBlockSize ].Visible Then
         With  PlanetPtr [ Ind Div PlanetBlockSize ] ^
                         [ Ind Mod PlanetBlockSize ]   Do
           Begin
             X := CenterX + ( C20 * X - Dx ) * DxSc ;
             Y := CenterY - ( C20 * Y - Dy ) * DySc ;
           End ;


     If ( NPointSatMark > 0 )  Then
       For Ind := 1 To NPointSatMark  Do
         With  SatEartchPoint ^ [ Ind ] Do
           Begin
             X := CenterX + ( C20 * X - Dx ) * DxSc ;
             Y := CenterY - ( C20 * Y - Dy ) * DySc ;
           End ;



     ReCalcPlanets := False ;

   End ;

End ;  { Not CalcVectDiagr }

End;  { resetobjects }
      { ƒƒƒƒƒƒƒƒƒƒƒƒ }




Procedure ScToId ( ScX, ScY : Double ; Var IdX, IdY : Double );

Begin
 With sw Do
 Begin

  IdX := CenterX + (  C20 * ScX - ( x2-x1+C10 ) ) *
                      XMax * XOrient / Gscale / (x2-x1+C10);

  IdY := CenterY + ( -C20 * ScY + ( y2-y1+C10 ) ) *
                      YMax * YOrient / Gscale / (y2-y1+C10);

 End;
End;



  Procedure  XYEpOut ( Cat : Byte ; Var PmRa, PmDecl, XSt, YSt : Double ) ;
  {
  ÇÂÆ§: XSt, YSt  ≠†  JDate · „Á‚•≠≠Î¨® ≠† JDate P.M.
  ìÁ•‚ P.M. · JDate ≠† JdOut  =>  PmRa, PmDecl, XSt, YSt  ≠†  JdOut.
  }
Var

    X, Y,
    SDa, CDa,
    PmX, PmY,
    Sp, Cp, Ss, Cs,
    P, S, SRaSt, CRaSt, SDecSt, CDecSt,
    R, RR,
    XRect,   YRect,  ZRect,
    VXRect, VYRect, VZRect,
    X1 , Y1 , Z1 ,
    X2 , Y2 , Z2 ,
    MR, MD,
    SPoz, CPoz, SG, CG     : Double ;


Begin


If ( Abs ( JdOut - JDate ) > 0.1 )  Then
 Begin  { Abs ( JdOut - JDate ) > 0.1  }

    { èÆ¢Æp†Á®¢†•¨ X, Y ≠† p†¢≠Æ§•≠·‚¢®• ™†‚†´Æ£† }
    { ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ }


  X := XSt ;
  Y := YSt ;

  SPozNp1 := IndCat [ Cat ].SPozNp1 ;
  CPozNp1 := IndCat [ Cat ].CPozNp1 ;


       { ë‚†°®´®ß†Ê®Ô Æ·® Y ¢ ß•≠®‚ }
       { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

  If ( Not ( NPolFix ) )   Then
    Begin
      Index :=    X ;
      X     :=    X     * CPozNp  +  Y * SPozNp ;
      Y     := -  Index * SPozNp  +  Y * CPozNp ;

    End ;

              { èp•Ê•··®Ô }
              { ƒƒƒƒƒƒƒƒƒ }

  Index :=    X ;
  X     :=    X    * CPozNp1  +  Y * SPozNp1 ;
  Y     := - Index * SPozNp1  +  Y * CPozNp1 ;

      { èÆ´„Á®´® X, Y ≠† p†¢≠Æ§. ™†‚†´Æ£† }



            { H†©§•¨ Ì™¢. ™-‚Î }
            { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

  X := - X ;

  P := Sqrt  (  Sqr ( X )  +  Sqr ( Y )  ) ;
  S := P / FD ;

  If ( S < 1.0E-9 )
    Then
      Begin

        SRaSt := IndCat [ Cat ].SRaOpt ;
        CRaSt := IndCat [ Cat ].CRaOpt ;

        SDecSt := IndCat [ Cat ].SDeclOpt ;
        CDecSt := IndCat [ Cat ].CDeclOpt ;

        CDa := C10 ;
        SDa := 0.0 ;

      End
    Else
      Begin

        CP :=  Y / P ;
        SP :=  X / P ;

        SS := S / Sqrt ( C10  +  Sqr ( S )  ) ;
        CS := Sqrt ( C10 - Sqr ( SS )   )     ;

        SDecSt := CS * IndCat [ Cat ].SDeclOpt +
                  SS * IndCat [ Cat ].CDeclOpt * CP ;
        CDecSt := Sqrt ( C10 - Sqr ( SDecSt )  ) ;

        If ( Abs ( CDecSt ) < 1.0E-9 )
          Then
            Begin

              SRaSt  := IndCat [ Cat ].SRaOpt ;
              CRaSt  := IndCat [ Cat ].CRaOpt ;

              SDA    := IndCat [ Cat ].SDeclOpt ;
              CDA    := IndCat [ Cat ].CDeclOpt ;

            End
          Else
            Begin

              SDA := ( SS * SP ) / CDecSt ;
              CDA := ( CS * IndCat [ Cat ].CDeclOpt -
                       SS * IndCat [ Cat ].SDeclOpt * CP ) / CDecSt ;

              SRaSt := SDA * IndCat [ Cat ].CRaOpt +
                       CDA * IndCat [ Cat ].SRaOpt ;

              CRaSt := CDA * IndCat [ Cat ].CRaOpt -
                       SDA * IndCat [ Cat ].SRaOpt ;

            End ;

      End ;

      { èÆ´„Á®´® Ra, Decl ≠† p†¢≠Æ§. ™†‚†´Æ£† }



    Mr      := PmRa   / Fd * ( JdOut - JDate ) / 365.25 ;
    Md      := PmDecl / Fd * ( JdOut - JDate ) / 365.25 ;

    XRect   := CRaSt * CDecSt - Md * SDecSt * CRaSt - Mr * SRaSt ;
    YRect   := SRaSt * CDecSt - Md * SDecSt * SRaSt + Mr * CRaSt ;
    ZRect   := SDecSt         + Md * CDecSt                      ;



    X1 := - XRect * IndCat [ Cat ].SRaOpt
          + YRect * IndCat [ Cat ].CRaOpt    ;
    Y1 := - XRect * IndCat [ Cat ].CRaOpt
          - YRect * IndCat [ Cat ].SRaOpt    ;
    Z1 :=   ZRect                            ;

    X2 :=   X1                               ;
    Y2 :=   Y1 * IndCat [ Cat ].SDeclOpt
          + Z1 * IndCat [ Cat ].CDeclOpt     ;
    Z2 := - Y1 * IndCat [ Cat ].CDeclOpt
          + Z1 * IndCat [ Cat ].SDeclOpt     ;

    XSt := - Fd * X2 / Z2 ;
    YSt :=   Fd * Y2 / Z2 ;




    Mr      := PmRa   / Fd ;
    Md      := PmDecl / Fd ;

    VXRect := - Md * SDecSt * CRaSt - Mr * SRaSt ;
    VYRect := - Md * SDecSt * SRaSt + Mr * CRaSt ;
    VZRect :=   Md * CDecSt                      ;


    PreNXyz ( IndCat [ Cat ].JdCat, JdOut,   XRect,   YRect,   ZRect  ) ;
    PreNXyz ( IndCat [ Cat ].JdCat, JdOut,  VXRect,  VYRect,  VZRect  ) ;

    R  := Sqrt (  Sqr ( XRect )  +  Sqr ( YRect )                    ) ;
    RR :=      (  Sqr ( XRect )  +  Sqr ( YRect )  +  Sqr ( ZRect )  ) ;

    If ( R > 1.0e-9 )
      Then
        Begin

          PmRa   := ( XRect * VYRect - YRect * VxRect ) /  R  ;
          PmDecl := (   R * VZRect
                      - ZRect * ( XRect * VXRect + YRect * VYRect ) / R )
                    / RR ;

          PmRa   := PmRa   * Fd ;
          PmDecl := PmDecl * Fd ;

        End
      Else
        Begin
          PmRa   := 1001.0 ;
          PmDecl := 1001.0 ;
        End ;



          { è•p•ÂÆ§ ™ ·®·‚•¨• è´†·‚®≠™® }
          { ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ }



     { èÆ¢ÆpÆ‚ ù™¢ ë®·‚ JdCat -> ù™¢ ë®·‚ JdFld }
     { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

    Index :=   XSt ;
    XSt   :=   XSt  * CPozNp1  -  YSt * SPozNp1 ;
    YSt   :=  Index * SPozNp1  +  YSt * CPozNp1 ;

             { é·Ï 'Y' ¢ ØÆ´Ó·• JdFld }



    If ( Not ( NPolFix ) )   Then
      Begin { ë‚†°®´®ß†Ê®Ô Æ·® Y ¢ ß•≠®‚ }
            { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
        Index := XSt ;

        XSt :=   XSt  * CPozNp  -  YSt * SPozNp ;
        YSt :=  Index * SPozNp  +  YSt * CPozNp ;

      End ;

 End ;  { Abs ( JdOut - JDate ) > 0.1  }


End;   { XYEpOut }




           { ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ }

    Procedure IdToEq1 ( XSt, YSt  : Double ;  Var  Ra, Decl  : Double  ) ;

Var
    P, S, Sr, Cr, Sd, Cd,
    Sp, Cp, Ss, Cs,
    SDa, CDa, SPoz,
    SRaO, CRaO, SDO, CDO
                           : Double ;


Begin

   SRaO := SRaOpt   ;
   CRaO := CRaOpt   ;
   SDO  := SDeclOpt ;
   CDO  := CDeclOpt ;


   If ( Not NPolFix )   Then
       Begin

         SPOZ  :=    XSt ;
         XSt   :=    XSt * CPozNp + YSt * SPozNp ;
         YSt   := - SPOZ * SPozNp + YSt * CPozNp ;

       End ;




   P := Sqrt (  Sqr ( XST ) + Sqr ( YST )  ) ;
   S := P / FD ;

   If ( S < 1.0E-9 )  Then

      Begin

        SR := SRaO ;
        CR := CRaO ;

        SD := SDO ;
        CD := CDO ;

      End
    Else
      Begin

        CP :=    YSt / P ;
        SP :=  - XSt / P ;

        SS := S / Sqrt ( C10  +  Sqr ( S )  ) ;
        CS := Sqrt ( C10 - Sqr ( SS )   )     ;

        SD := CS * SDO + SS * CDO * CP ;
        CD := Sqrt ( C10 - Sqr ( SD )  ) ;

        If ( ABS ( CD ) < 1.0E-9 )  Then
            Begin

              SR  := SRaO ;
              CR  := CRaO ;

              SDA := SDO ;
              CDA := CDO ;

            End
          Else
            Begin

              SDA := ( SS * SP ) / CD ;
              CDA := ( CS * CDO - SS * SDO * CP ) / CD ;

              SR  := SDA * CRaO + CDA * SRaO ;
              CR  := CDA * CRaO - SDA * SRaO ;

            End ;


      End ;

   Ra   := ATan2  ( Sr , Cr ) ;
   Decl := ArcTan ( Sd / Cd ) ;


   If ( B_Gal )  Then
     Begin
       EkvGal ( Ra, Decl, Ra, Decl ) ;
     End ;


End;   { IdToEq1 }


           { ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ }



Procedure IdToEq (            OX, OY  : Double  ;
                               NPFIX  : BOOLEAN ;
                          SPNP, CPNP  : Double  ;
                   Var      ORA, ODC  : Double    ) ;

 Var
      SPoz,
      CPoz,
      R1, R2     : Double ;


Begin

 R1   := Sqrt ( Sqr ( OX ) + Sqr ( OY )  ) ;

 If ( R1/FD > 1.0E-10 ) Then
 Begin

   If  (  NPFIX )  Then
     Begin
       SPOZ :=   OX ;
       OX   :=   OX * CPNP - OY * SPNP ;
       OY   := SPOZ * SPNP + OY * CPNP ;
     End ;


   SPOZ := OX / R1 ;
   CPOZ := OY / R1 ;

   SRO  := R1 / FD ;
   CRO  := Sqrt ( C10 + Sqr ( SRO )  ) ;
   SRO  := SRO / CRO ;
   CRO  := C10 / CRO ;

   SHNOD := CRO * SHOPT  +  SRO * CHOPT * CPOZ ;
   CHNOD := Sqrt ( C10  -  Sqr ( SHNOD )  ) ;

   R1    := SRO * SPOZ ;
   R2    := CRO * CHOPT  -  SRO * SHOPT * CPOZ ;

   ANOD  := ATAN2 ( R1, R2 ) ;

  End
  Else
  Begin

   ANOD  := 0.0 ;

   SHNOD := SHOPT ;
   CHNOD := CHOPT ;

  End ;

  ANOD := ANOD + AOPT ;
  If ( ANOD < 0.0    )  Then
    ANOD := ANOD + PI*C20 ;
  If ( ANOD > PI*C20 )
    Then  ANOD := ANOD - PI*C20 ;


  SANOD := SIN ( ANOD ) ;
  CANOD := COS ( ANOD ) ;

  SDECLNOD := SHNOD * SFIS - CHNOD * CFIS * CANOD ;
  CDECLNOD := Sqrt ( C10 - Sqr ( SDECLNOD )  ) ;

  STNOD    :=   CHNOD * SANOD                         / CDECLNOD ;
  CTNOD    := ( SHNOD * CFIS + CHNOD * SFIS * CANOD ) / CDECLNOD  ;

  DECLNOD := ARCTAN ( SDECLNOD / CDECLNOD ) ;

  TNOD     := ATAN2 ( STNOD, CTNOD ) ;

  RANOD    := STIME - TNOD ;
  If ( RANOD < 0.0 )  Then
    RANOD := RANOD + PI*C20 ;

  Ora :=   RANOD;
  Odc := DECLNOD;

End;



Procedure RadToGms( x : Double ; Var neg : boolean; Var g, m : integer ; Var s : Double );
Var
 Sign : Integer;
Begin

 If ( x < 0 )
   Then Sign:=  -1
   Else Sign:=1;

 neg := ( Sign = -1 );

 x   := ( Sign * x ) * SekRad;
 g   := Trunc( x / C36000 );
 x   := x - g * C36000;
 m   := Trunc( x / C600 );
 s   := x - m * C600;

 If ( s >= C600 )
   Then
     Begin
       s:=s - C600;
       Inc(m);
     End
   Else
     If ( s > 59.99 ) Then
       s:=59.99;

 If ( m >= 60 )  Then
   Begin
     m:=m-60;
     g:=g+1;
   End;

End;



Procedure RadToHms( x : Double ; Var h,m : Integer; Var s : Double );

Begin
 x:=x * ( SekRad / 15.0 );
 h:=Trunc( x / C36000 );
 x:= x - h * C36000;
 m:=Trunc( x / C600 );
 s:= x - m * C600;

 If ( s >= C600 )
   Then
     Begin
       s:=s - C600;
       Inc(m);
     End
   Else
     If ( S > 59.999 ) Then
       s:=59.999;

 If ( m >= 60 )
   Then
     Begin
       m:=m-60;
       Inc(h);
     End;

 If ( ( h = 24 ) And ( m = 0 ) ) Then
   Begin
     h:=0;
     m:=0;
   End;

End;



Procedure Povorot ( JDate : Double; Var SPoz, CPoz : Double ) ;

 Var
    RaNp1, DeclNp1, RRRR,
    SPozNp1, CPozNp1, Cs, Ss             : Double ;

  Begin

         { è¢ÆpÆ‚ Æ‚ èÆ´Ó·† ä†‚†´Æ£† ™ èÆ´Ó·„ JDateFld }
         { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

        RaNp1   := 0.0      ;
        DeclNp1 := Pi / C20 ;

        If ( Abs ( JDate - JDateFld ) > C10 )  Then
          PreNew ( JDate, JDateFld, RaNp1, DeclNp1 );


        If  ( Abs ( DeclNp1 - DeclOpt )  < 1.5e-7 )
          Then
            Begin
              Cs := C10 ;
              Ss := 0.0 ;
            End
          Else
            Begin
              Cs := SDeclOpt * Sin ( DeclNp1 ) +
                    CDeclOpt * Cos ( DeclNp1 ) * Cos ( RaNp1 - RaOpt ) ;

              Ss := Sqrt ( C10 - Sqr ( Cs ) ) ;
            End ;


        If ( Ss < 1.0e-10 )
          Then
            Begin

              SPoz := Cos ( DeclNp1 ) * Sin ( RaNp1 - RaOpt ) ;

              CPoz := ( Sin ( DeclNp1 ) * CDeclOpt -
                        Cos ( DeclNp1 ) * SDeclOpt * Cos ( RaNp1 - RaOpt )
                      ) ;

              RRRR := ATan2 ( SPoz, CPoz ) ;

              SPoz := Sin ( RRRR ) ;
              CPoz := Cos ( RRRR ) ;

            End
          Else
            Begin

              SPoz := Cos ( DeclNp1 ) * Sin ( RaNp1 - RaOpt ) / Ss ;

              CPoz := ( Sin ( DeclNp1 ) * CDeclOpt -
                        Cos ( DeclNp1 ) * SDeclOpt * Cos ( RaNp1 - RaOpt )
                      ) / Ss ;
            End ;

  End ;



Procedure RaDcHip  ( Var Ra, Decl, PmRa, PmDecl : Double ) ;

Const

    Cat = 11 ;

Var

    SRaSt, CRaSt, SDecSt, CDecSt,
    R, RR,
    Jd,
    Mr, Md,
    XRect,   YRect,  ZRect,
    VXRect, VYRect, VZRect,
    X1 , Y1 , Z1 ,
    X2 , Y2 , Z2
                                      : Double ;


Begin

      { Eq 2000, Ep 1991 }
      { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

    SRaSt   := Sin ( Ra   ) ;
    CRaSt   := Cos ( Ra   ) ;
    SDecSt  := Sin ( Decl ) ;
    CDecSt  := Cos ( Decl ) ;

    JD := ( JDOut - 2451545.0 ) / 365.25 + 2000.0;

    Mr      := PmRa   * ( Jd - 1991.25 ) ;
    Md      := PmDecl * ( Jd - 1991.25 ) ;

      { Eq 2000, Ep 2000 }
      { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

    XRect   := CRaSt * CDecSt - Md * SDecSt * CRaSt - Mr * SRaSt ;
    YRect   := SRaSt * CDecSt - Md * SDecSt * SRaSt + Mr * CRaSt ;
    ZRect   := SDecSt         + Md * CDecSt                      ;


      { Eq 2000, Ep 1991 }
      { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

    VXRect := - PmDecl * SDecSt * CRaSt - PmRa * SRaSt ;
    VYRect := - PmDecl * SDecSt * SRaSt + PmRa * CRaSt ;
    VZRect :=   PmDecl * CDecSt                        ;


    R  := Sqrt (  Sqr ( XRect )  +  Sqr ( YRect )                    ) ;
    RR :=      (  Sqr ( XRect )  +  Sqr ( YRect )  +  Sqr ( ZRect )  ) ;

      { Eq 2000, Ep 2000 }
      { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
    PmRa   := ( XRect * VYRect - YRect * VxRect ) /  R  ;
    PmDecl := (   R * VZRect
                - ZRect * ( XRect * VXRect + YRect * VYRect ) / R )
                / RR ;


      { Eq 2000, Ep 2000 }
      { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
    SDecSt := ZRect ;
    CDecSt := Sqrt ( C10 - Sqr ( SDecSt ) ) ;
    SRaSt  := YRect / CDecSt ;
    CRaSt  := XRect / CDecSt ;

      { Eq 2000, Ep 2000 }
      { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
    VXRect := - PmDecl * SDecSt * CRaSt - PmRa * SRaSt ;
    VYRect := - PmDecl * SDecSt * SRaSt + PmRa * CRaSt ;
    VZRect :=   PmDecl * CDecSt                        ;


    PreNXyz ( 2451545.0, JdOut,   XRect,   YRect,   ZRect  ) ;
    PreNXyz ( 2451545.0, JdOut,  VXRect,  VYRect,  VZRect  ) ;
    {
    PreNXyz ( 2448349.0, JdOut,  VXRect,  VYRect,  VZRect  ) ;
    }

      { Eq Out, Ep Out }
      { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
    R  := Sqrt (  Sqr ( XRect )  +  Sqr ( YRect )                    ) ;
    RR :=      (  Sqr ( XRect )  +  Sqr ( YRect )  +  Sqr ( ZRect )  ) ;

    If ( R > 1.0e-9 )
      Then
        Begin
          PmRa   := ( XRect * VYRect - YRect * VxRect ) /  R  ;
          PmDecl := (   R * VZRect
                      - ZRect * ( XRect * VXRect + YRect * VYRect ) / R )
                    / RR ;
        End
      Else
        Begin
          PmRa   := 1001.0 ;
          PmDecl := 1001.0 ;
        End ;



    Ra   := ATan2 ( YRect , XRect ) ;

    Decl := Atan2 ( ZRect , Sqrt ( Sqr ( XRect ) + Sqr ( YRect ) )  ) ;
    If ( Decl > Pi )  Then
      Decl := Decl - Pi2 ;

                 
End ; { RaDcHip }


End.
