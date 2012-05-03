
{$O+,F+}


UNIT POSCREEN ;

 INTERFACE

    Procedure OScreen ;
   {ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ}

IMPLEMENTATION

 USES GRAPH, V_CATAL, PVAR, SCREEN, Service,
      PPLANET, PProFld, POutPV, PVarMenu ;


   Procedure FieldDop ;   { èéëíêéÖHàÖ ÑéèéãHàíÖãúHéâ êÄåäà }
 { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }   { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

Var

 Dx, Dy, VX, VY : Double  ;
 col            : Integer ;
 vp             : Viewporttype;
 ls             : lineSettingstype;
 Xl, Xp, Yv, Yn,
 Cx, Cy, Sx, Sy : LongInt ;

Begin

 getviewSettings(vp);
 getlineSettings(ls);

 With Sw Do
   Begin

     Setviewport ( x1, y1, x2, y2, clipon ) ;

     VX  := FD * Sin ( RRX ) / Cos ( RRX ) ;
     VY  := FD * Sin ( RRY ) / Cos ( RRY ) ;

     Dx  := VX * XOrient * GScale / XMax * (x2-x1+C10) / C20 ;
     Dy  := VY * YOrient * GScale / YMax * (y2-y1+C10) / C20 ;

     If ( Abs ( Dx ) < 1000000000 )
       Then  Sx := Trunc ( Dx )
       Else
         Begin
           If ( Dx ) > 0
             Then Sx :=   1000000000
             Else Sx := - 1000000000
         End ;

     If ( Abs ( Dy ) < 1000000000 )
       Then  Sy := Trunc ( Dy )
       Else
         Begin
           If ( Dy ) > 0
             Then Sy :=   1000000000
             Else Sy := - 1000000000
         End ;

     Dx  := ( (x2-x1+1) - CenterX * XOrient * GScale / XMax * (x2-x1+1) ) / C20 ;
     Dy  := ( (y2-y1+1) + CenterY * YOrient * GScale / YMax * (y2-y1+1) ) / C20 ;

     If ( Abs ( Dx ) < 1000000000 )
       Then  Cx := Trunc ( Dx )
       Else
         Begin
           If ( Dx ) > 0
             Then Cx :=   1000000000
             Else Cx := - 1000000000
         End ;

     If ( Abs ( Dy ) < 1000000000 )
       Then  Cy := Trunc ( Dy )
       Else
         Begin
           If ( Dy ) > 0
             Then Cy :=   1000000000
             Else Cy := - 1000000000
         End ;

     Xl  := Cx - Sx ;
     Xp  := Cx + Sx ;
     Yv  := Cy - Sy ;
     Yn  := Cy + Sy ;

     If  ( Xl <    0 )  Then  Xl := -   1  ;
     If  ( Xl > 1000 )  Then  Xl :=  1000  ;

     If  ( Xp <    0 )  Then  Xp := -   1  ;
     If  ( Xp > 1000 )  Then  Xp :=  1000  ;

     If  ( Yv <    0 )  Then  Yv := -   1  ;
     If  ( Yv > 1000 )  Then  Yv :=  1000  ;

     If  ( Yn <    0 )  Then  Yn := -   1  ;
     If  ( Yn > 1000 )  Then  Yn :=  1000  ;

   End ;

 Col := GetColor ;
 SetColor ( LightGray );
 SetWriteMode ( XorPut ) ;
 SetLineStyle ( DottedLn, 0, NormWidth ) ;
 SetWriteMode ( NormalPut ) ;
 Rectangle    ( Xl, Yv, Xp, Yn ) ;
 SetColor     ( Col );

 With vp Do Setviewport(x1,y1,x2,y2,clipon);
 With ls Do Setlinestyle(linestyle, pattern, thickness);

 End ; { FieldDop }
       { ƒƒƒƒƒƒƒƒ }





   Procedure OScreen ;
   {ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ}

Const
  {
  GscCol  : Array [0..5] of Byte = ( LightCyan  , LightBlue, Yellow  ,
                                     LightGreen , LightGray, LightRed  ) ;
  }
  GscCol  : Array [0..5] of Byte = ( LightCyan, LightBlue, LightGreen,
                                     Yellow   , LightGray, LightRed   ) ;
  {
     0 - star
     1 - galaxy
     2 - blend or member of incorrectly resolved blend.
     3 - non-star
     5 - potential artifact
         (Note that code 1 is used only For a few  hand-entered errata;
         galaxies successfully processed by the software have a classi-
         fication of 3 [non-stellar].  Also code 4 is never used.)
  }
  GranMax  : Integer = 12 ;
  dSxScale : Integer =  7 ;
  dSyScale : Integer =  5 ;

  MvMinGscOscreen : Double = 7.0 ;

var

  MvCorr   : Boolean ;
  sx, sy   : LongInt ;
  XScrMax,
  YScrMax  : Integer ;
  dsx, dsy : LongInt ;
  stx, sty : Double  ;
  SRadii   : Word    ;
  SRadiiX  : LongInt ;
  SRadiiY  : LongInt ;
  cCol     : byte    ;
  IndCatIzo: Integer ;
  Ind      : Integer ;
  NPL      : Integer ;
  SpInd    : Byte    ;
  SClas    : Byte    ;
  sColor   : byte    ;

  PmX, PmY : ShortInt ;

  SRadiiReal : Double ;

 dx, dy          : Double  ;
 DxSc, DySc      : Double  ;
 DxObj,DyObj     : Double  ;

 vp  : viewporttype    ;
 fs  : fillsettingstype;
 ts  : textsettingstype;
 b,c : byte;

 NameCat : String [ 15 ] ;
 S       : String        ;



 Procedure Elipse ( NRecC : LongInt ; Sx0, Sy0 : Integer ) ;

    Var
        S1,
        SName,
        NameCat    : String  ;
        Ga, La,
        I, I1,
        Sx, Sy,
        SxOld,
        SyOld      : Integer ;
        M,
        XSt, YSt,
        Index,
        Poz,
        SPoz, CPoz,
        K          : Single  ;
        Dx, Dy,
        DxSc, DySc,
        DxObj,
        DyObj      : Double  ;
        NRec       : LongInt ;
        FData      : File    ;
        Buf        : Array [ 1 .. 2000 ] Of Char   ;
        Xe, Ye     : Array [ 0 ..   36 ] Of Single ;

      Begin

        NameCat := CatNameKutcha [ ( NRecC Mod 1000000000 ) Mod 20 ] ;
        I1      := CatKutchaRecL [ ( NRecC Mod 1000000000 ) Mod 20 ] ;
        NRec    := ( NRecC Mod 1000000000 ) Div 20 ;

        Assign ( FData, ParamDir.IrasDir + '\' + NameCat + '.Dat' ) ;
        {$I-}
        FileMode := 0 ;
        Reset  ( FData, I1 );
        FileMode := 2 ;
        {$I+}

        If ( IOResult = 0 )  Then
          Begin

            Seek       ( FData, NRec - 1 ) ;
            BlockRead  ( FData, Buf, 1   ) ;
            Close      ( FData           ) ;

            SName := CatNameKutcha [ ( NRecC Mod 1000000000 ) Mod 20 ];
            If ( SName = 'PSC' )
              Then I1 := 0
              Else I1 := 1 ;

            S1 := '' ;
            For I := 26 To 28 Do
              S1 := S1 + Buf [ I1 + I ] ;
            Val ( S1, Ga, Code ) ;

            S1 := '' ;
            For I := 29 To 31 Do
              S1 := S1 + Buf [ I1 + I ] ;
            Val ( S1, La, Code ) ;

            S1 := '' ;
            For I := 32 To 34 Do
              S1 := S1 + Buf [ I1 + I ] ;
            Val ( S1, Poz, Code ) ;

            Poz  := Poz*Gr + Pid2 ;
            SPoz := Sin ( Poz )   ;
            CPoz := Cos ( Poz )   ;

            If ( Ga > 0.0 )
              Then  K := La / Ga
              Else  K := 0.0    ;

            M := Fd / SekRad * Ga ;

            SPozNp1 := IndCat [ CatOthers ].SPozNp1 ;
            CPozNp1 := IndCat [ CatOthers ].CPozNp1 ;

            { Ñ•´†•¨ ù´´®Ø· }
            { ƒƒƒƒƒƒƒƒƒƒƒƒƒ }
            For I := 0 To 36 Do
              Begin
                Xe [ I ] := - Ekv^[ I * 10 + 1 ].X / R_Planets [3]
                              / 100000.0     * M ;
                Ye [ I ] :=   Ekv^[ I * 10 + 1 ].Y / R_Planets [3]
                              / 100000.0 * K * M ;
              End ;

            With sw Do
              Begin

                Dx := ( x2 - x1 + 1 ) / C20 ;
                Dy := ( y2 - y1 + 1 ) / C20 ;

                DxSc := XOrient * GScale / XMax * Dx  ;
                DySc := YOrient * GScale / YMax * Dy  ;

              End ;


            For I := 0 To 36 Do
              Begin

               XSt := Xe [ I ] ;
               YSt := Ye [ I ] ;

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


               Index :=   XSt ;
               XSt :=     XSt   * CPoz  -  YSt * SPoz   ;
               YSt := - ( Index * SPoz  +  YSt * CPoz ) ;
               {
               XSt :=   XSt  * CPoz  -  YSt * SPoz ;
               YSt :=  Index * SPoz  +  YSt * CPoz ;
               }

               DxObj := ( XSt ) * DxSc ;
               DyObj := ( YSt ) * DySc ;

               Sx := Sx0 + Round ( DxObj )   ;
               Sy := Sy0 + Round ( DyObj )   ;

               If ( I = 0 )
                 Then PutPixel ( Sx, Sy, SColor )
                 Else Line ( SxOld, SyOld, Sx, Sy ) ;

               SxOld := Sx ;
               SyOld := Sy ;

              End ;

          End ;

      End ; { Elipse }




Begin

 getviewsettings(vp);
 c := getcolor;
 b := getbkcolor;
 getfillsettings(fs);
 gettextsettings(ts);

 Page  := ( Page + NGPages - 1 ) mod 2;
 SetActivePage ( Page ) ;
 SetWriteMode ( NormalPut ) ;

{
 If (     ( CalcVectDiagr   )
      And ( GScale = VScale )  )  Then
   Begin
     GScale  := C10 ;
     CenterX := 0.0 ;
     CenterY := 0.0 ;
   End ;
}

 With sw Do
 Begin { sw }

 SetViewPort ( x1, y1, x2, y2, clipon ) ;

 XScrMax := x2 - x1 + 1 ;
 YScrMax := y2 - y1 + 1 ;

 Dx := ( x2 - x1 + 1 ) / C20 ;
 Dy := ( y2 - y1 + 1 ) / C20 ;

 DxSc := XOrient * GScale * Dx / XMax  ;
 DySc := YOrient * GScale * Dy / YMax  ;



  { ó®·‚®¨ ØÆ´•, •·´® ≠• íp•™® }
  { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
 If (    ( Not B_Object_Tracks )
      Or ( ClearScr            )  )   Then
   Begin
     ClearViewPort;
     ClearScr := False ;
   End ;

{
 If ( N_Matrix > 0 )  Then
   DrawMatMap;
}

 sColor := black;
 cCol   := GetColor;
 {
 If ( IndCat [ CatA20 ].NBEG > -1 )
   Then GranMax  := 12
   Else GranMax  :=  7 ;
 }
 If ( IndCat [ CatA20 ].NBEG > -1 )
   Then GranMax  :=  9
   Else GranMax  :=  7 ;


 For Ind := 1 To CatIzoMax Do
   CatSort [ Ind ] := False ;


   { MvMin , MvMax }
   { ƒƒƒƒƒƒƒƒƒƒƒƒƒ }

 MvCorr := False ; { dMv > 2 }

 If ( Not MvFloat )
   Then
     Begin
       MvMax := MvMaxParam ;
       MvMin := MvMinParam ;
     End
   Else
     Begin  { Float }
       If (  ( MvMax - MvMin ) < C10 )  Then
         Begin
           MvCorr := True        ;
           MvMax  := MvMax + 0.5 ;
           MvMin  := MvMin - 0.5 ;
         End ;
     End ;


 If ( MvMax > 25.0 )  Then
   MvMax := 25.0 ;


 If (  ( MvMax - MvMin ) > 0 )
   Then
     Begin  { Ö·‚Ï á¢•ß§Î ¢ ØÆ´• }

       If (     ( IndCat [ CatGsc ].NBeg > -1 )
            And ( Not MvFloat                 )  )
         Then
           Begin  { Gsc Exist. MvMin := MvMinGscOscreen }
             If ( ( MvMax - MvMinGscOscreen ) <= 0.0 )
                Then
                    KMD := C10
                Else
                  Begin

                    KMD := GranMax / ( MvMax - MvMinGscOscreen ) ;

                    If ( KMD > 3.0 )  Then
                      KMD := 3.0 ;
                    {
                    If ( KMD > 1.5 )  Then
                      KMD := 1.5 ;
                    }
                  End
           End
         Else
           Begin

             KMD := GranMax / ( MvMax - MvMin ) ;

             If ( KMD > 3.0 )  Then
               KMD := 3.0;
             {
             If ( KMD > 1.5 )  Then
               KMD := 1.5 ;
             }
           End ;

     End  { Ö·‚Ï á¢•ß§Î ¢ ØÆ´• }
   Else
     KMD := C10  ;


 NoDetCdcExist := False ;
 NMarkingField := 0     ;


 For IndCatIzo := CatIzoMax  DownTo  1  Do
  Begin { IndCatOut }
        { ƒƒƒƒƒƒƒƒƒ }

   SClas  := PrioritetIzo [ IndCatIzo ] ;
   If (     ( SClas  <> 0      )
        And ( SClas  <= CatMax )  )   Then
    Begin { SClas  }
          { ƒƒƒƒƒƒ }

     IFirst := IndCat [ SClas  ].NBeg ;
     ILast  := IndCat [ SClas  ].NEnd ;

     IndCat [ SClas  ].NStarInFild := 0 ;
     IndCat [ SClas  ].NoDetInFild := 0 ;


     If (     (    ( CalcVectDiagr And (    ( SClas  = CatCdc    )
                                         Or ( SClas  = CatHip    )
                                         Or ( SClas  = CatTyc    )
                                         Or ( SClas  = CatPpm    )
                                         Or ( SClas  = CatNpm    )
                                         Or ( SClas  = CatOthers )
                                       )
                   )
                Or ( Not CalcVectDiagr )
              )
          And ( IFirst > -1 )
        ) Then
      Begin  { IFirst > -1 }


       If ( IndCat [ SClas  ].TypeCoord = IdCoord )  Then
           ReCalcObjects ;


       For Ind := IFirst To ILast Do
         With ObjectPtr [ Ind Div ObjectBlockSize ]^
                        [ Ind Mod ObjectBlockSize ] Do
         Begin  { ObjectPtr }

           If (     ( X >=  0      )
                And ( X <= XScrMax )
                And ( Y >=  0      )
                And ( Y <= YScrMax )  )
             Then
               Begin
                 NRecC := Abs ( NRecC ) ;
                 Sx    := Round ( X )   ;
                 Sy    := Round ( Y )   ;
               End
             Else
                 NRecC := - Abs ( NRecC ) ;


           If (     ( CalcVectDiagr )
                And ( NRecC >= 0    )  )
             Then
               Begin

                 PmX := PmVect^[Ind].PmX ;
                 PmY := PmVect^[Ind].PmY ;

                 DxObj := ( PmX / C1270 * XMax - CenterX ) * DxSc ;
                 DyObj := ( PmY / C1270 * YMax - CenterY ) * DySc ;

                 Sx :=  Round ( Dx + DxObj ) ;
                 Sy :=  Round ( Dy - DyObj ) ;

                 If (     ( Sx >= X1      )
                      And ( Sx <= XScrMax )
                      And ( Sy >= Y1      )
                      And ( Sy <= YScrMax )
                      And ( PmX > -128    )
                      And ( PmY > -128    )
                    )
                   Then  NRecC :=   Abs ( NRecC )
                   Else  NRecC := - Abs ( NRecC ) ;

               End ;

           If (     ( StepSectorMarkIzo          )
                And ( Abs ( NRecC ) < 1000000000 )  )  Then
              NRecC := - Abs ( NRecC ) ;


           If ( NRecC >= 0 )  Then
             Begin  { Ç ØÆ´• ßp•≠®Ô }
                    { ƒƒƒƒƒƒƒƒƒƒƒƒƒ }

               Inc ( IndCat[ SClas  ].NStarInFild ) ;

               IF ( SClas  = CatOthers )  Then
                 NameCat := CatNameKutcha [ ( NRecC Mod 1000000000 ) Mod 20 ];

               IF (     ( SClas  = CatOthers  )
                    And ( NameCat <> 'HIP'    )
                    And ( NameCat <> 'TYC'    )  )
                 Then
                   DMvOScr := 0.0
                 Else
                   Begin
                     If (      ( SClas  = CatImp )
                          And  ( M / 10 > 25     )  )
                       Then  DMvOScr := 0
                       Else
                         Begin
                           If ( SClas  <> CatA20 )
                             Then  DMvOScr := MVMax - ( M / 10 - 5 )
                             Else  DMvOScr := MVMax - ( M / 10     ) ;
                         End ;
                   End ;

               If ( DMvOScr < 0.0 )  Then
                 DMvOScr := 0.0 ; { GCVS Øp® ≠†´®Á®® §p„£®Â ¢ ØÆ´• }

               If (     ( SClas  <> CatGsc )
                    And ( MvFloat          )  )
                 Then  { Mv Float }
                   SRadiiReal := 2 + KMD * DMvOScr
                 Else
                   Begin  { Mv Fix }
                     If ( SClas  = CatGsc )
                       Then
                         Begin
                           If ( ( M / 10 - 5 ) > MvMinGscOscreen )
                              Then  SRadiiReal := 2 + KMD * DMvOScr
                              Else  SRadiiReal := GranMax ;
                         End
                       Else
                         Begin
                           If ( ( M / 10 - 5 ) > MvMin )
                              Then  SRadiiReal := 2 + KMD * DMvOScr
                              Else  SRadiiReal := GranMax ;
                         End ;

                   End ;


               If (     ( SClas  = CatImp )
                    And ( B_Inport_Ccd    )  )  Then
                 Begin
                   If ( CcdDiamExist )
                     Then
                       Begin

                         SRadiiReal := M ;

                         If ( SRadiiReal < 1.1 )  Then
                           SRadiiReal := 1.1 ;

                       End
                     Else
                       SRadiiReal := 6 ;
                 End ;


               
               If ( SClas  = CatNpm )
                 Then SColor := LightRed
                 Else
                   Begin
                     If ( SClas  = CatA20 )
                       Then SColor :=     A20Col [ ( Sp Mod 100 ) Div 10 ]
                       Else SColor := SpectraCol [ ( Sp Mod 100 ) Div 10 ] ;
                   End ;

               If (  B_Cdc_Cat  )  Then
                 Begin
                   If (     ( SClas  = CatCdc                       )
                        And (     (   Sp >= 100                   )
                              And ( ( ( Sp Mod 100 ) Div 10 ) = 2 ) )
                                                                      )  Then
                      SColor := Yellow ;

                 End ;

               {
               If ( SClas  = CatHicBin  )  Then
                  SColor := White ;
               }
               {
               If (     ( SClas  = CatA20  )
                    And ( Not B_Color_A2_0 )  )  Then
                  SColor := LightGray ;
               }

               If ( SClas  = CatDm  )  Then
                 Begin
                   If ( Not B_Cdc_Cat )
                     Then   SColor := Yellow
                     Else   SColor := LightGreen ;
                 End ;

               If ( SClas  = CatGcvs  )  Then
                  SColor := LightMagenta ;


               If (     ( SClas  = CatNltt  )
                    And ( ( Sp Mod 10 ) = 0 )  )  Then
                 SColor := White ;

                { Ç•·Ï ≠•Æ‚Æ¶§•·‚¢´•≠≠Î© GSC p®·„•¨ Ê¢•‚Æ¨ ß¢•ß§ }
                { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

               If  ( SClas  = CatGsc )    Then
                 Begin
                   {
                   If ( B_Det_Cdc )
                     Then
                       Begin
                         If  ( Not (    ( Sp Div 10 = 4 )
                                     Or ( Sp Div 10 = 5 ) )  ) Then
                           Begin
                             SColor := SpectraCol [ 8 ] ;
                           End ;
                       End
                     Else
                    }
                       Begin  { GSC p†·™p†Ë®¢†•¨ }
                         SpInd  := Sp Mod 10 ;
                         If ( SpInd >= 6 )  Then
                           SpInd := SpInd Mod 6 ; { GSC 1.1 }
                         SColor := GscCol [ SpInd ] ;
                       End ;
                 End ;



                { AKMoz °•´Î©, •·´® ≠• Æ‚Æ¶§•·‚¢´Ô•¨ }
                { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
               {
               If  (     ( SClas  = CatCDCMoz )
                     And ( Not B_Det_Cdc   ) ) Then
                   SColor := SpectraCol [ 2 ] ;
               }
               If ( SClas  = CatCDCMoz )  Then
                 SColor := SpectraCol [ 2 ] ;


               SetColor ( SColor );

               {
               If (    (   SClas  = CatImp                     )
                    Or ( ( SClas  = CatCdc ) And ( B_Det_Cdc ) )  )
               }
               If (    (   SClas  = CatImp                 )
                    Or ( ( SClas  = CatCdc ) And ( False ) )  )
                Then
                 Begin

                   If  (     ( SClas  = CatCdc                  )
                         {
                         And ( B_Det_Cdc                        )
                         }
                         And ( False                            )
                         And ( Not (     ( Sp Div 10 = 7 )
                                      Or ( Sp Div 10 = 5 )  )   ) )  Then
                       Begin  { H•Æ‚Æ¶§•·‚¢´•≠≠Î• Cdc }
                              { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

                         Inc ( IndCat[ SClas  ].NoDetInFild ) ;
                         NoDetCdcExist := True ;

                         SetColor ( LightRed ) ;
                         SetWriteMode ( XORPut ) ;

                         SradiiX := Trunc ( SRadiiReal ) ;
                         If ( SRadiiX > 7 )  Then
                           SRadiiX := 8 ;

                         SradiiY := Round ( SRadiiReal * XAsp / YAsp ) ;
                         If ( SRadiiY > 7 )  Then
                           SRadiiY := 8 ;

                         Line ( Sx - SRadiiX, Sy           ,
                                Sx + SRadiiX, Sy             ) ;
                         Line ( Sx          , Sy - SRadiiY ,
                                Sx          , Sy + SRadiiY   ) ;

                         SetWriteMode ( NormalPut ) ;

                       End
                     Else
                       Begin

                         If  (     ( SClas  = CatImp                  )
                               And ( Not (     ( Sp Div 10 = 7 )
                                            Or ( Sp Div 10 = 4 )  )   ) )
                           Then
                             Begin  { H•Æ‚Æ¶§•·‚¢´•≠≠Î• Imp }
                                    { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
                               If ( B_Inport_Ccd )
                                 Then SetColor ( LightGreen )
                                 Else SetColor ( LightRed   ) ;
                               {
                               SetWriteMode ( XORPut ) ;
                               }
                               SradiiX := Trunc ( SRadiiReal ) ;
                               If ( B_Inport_Ccd )
                                 Then
                                   Begin
                                     SradiiY :=
                                       Trunc ( SRadiiReal * XAsp / YAsp ) ;
                                     If ( SRadiiY < 1 )  Then
                                       SRadiiY := 1 ;
                                   End
                                 Else
                                   Begin
                                     If ( SRadiiX >= 25 )  Then
                                       SRadiiX := 25 ;
                                     SradiiY :=
                                       Round ( SRadiiReal * XAsp / YAsp ) ;
                                     If ( SRadiiY < 1 )  Then
                                       SRadiiY := 1 ;
                                     If ( SRadiiY >= 25 )  Then
                                       SRadiiY := 25 ;
                                   End ;

                               Line ( Sx - SRadiiX, Sy           ,
                                      Sx + SRadiiX, Sy             ) ;
                               Line ( Sx          , Sy - SRadiiY ,
                                      Sx          , Sy + SRadiiY   ) ;
                               {
                               SetWriteMode ( NormalPut ) ;
                               }
                             End
                           Else
                             Begin
                               SRadii := Trunc ( SRadiiReal + 1 ) ;
                               Circle  ( Sx, Sy, SRadii + 3 ) ;
                             End ;

                       End

                 End

                Else

                 Begin

                   SRadii := Round ( SRadiiReal ) ;
                   If ( SRadii < 2 )  Then
                     SRadii := 2 ;

                   If ( SRadii > GranMax )  Then
                     SRadii := GranMax ;
                   {
                   If (     ( B_Import_Fld )
                        And ( SRadii <= 1  )  )  Then
                     SRadii := 2 ;
                   }

                   If (     ( B_Object_Tracks       )
                        And ( Not StepSectorMarkIzo )
                        And ( Not B_Import_Sat      )
                        And ( Not CalcVectDiagr     )  )  Then
                     Begin
                       If (     ( NStepTracks = 1 )
                            And ( Not B_VectDiagr ) )
                          Then  SRadii := 3
                          Else  SRadii := 0 ;
                     End ;



                   If (     (    ( SClas  = CatPPM                 )
                              Or ( SClas  = CatBS                  )
                              Or ( SClas  = CatSao                 )
                              Or (     ( SClas  = CatOthers        )
                                   And (    ( NameCat = 'HIP')
                                         Or ( NameCat = 'TYC')  )  )
                              Or ( SClas  = CatNLtt                )  )
                        And (    ( B_GSC                           )
                              Or ( B_A20                           )
                              Or ( B_CDC                           )
                              Or ( B_Import_Fld                    )
                              Or ( B_Dm  )                            )
                        And ( Not B_VectDiagr                         )
                        And ( Not B_Object_Tracks                     )  )
                   Then
                     Begin

                       Circle  ( Sx,Sy,SRadii ) ;

                       If (     ( SClas  = CatOthers  )
                            And ( NameCat = 'TYC'     )  )  Then
                           Begin

                             Line ( Sx, Sy-SRadii-1, Sx, Sy-SRadii+1 ) ;
                             Line ( Sx, Sy+SRadii+1, Sx, Sy+SRadii-1 ) ;

                           End ;


                       If (     ( SClas  = CatOthers  )
                            And ( NameCat = 'HIP'     )  )  Then
                           Begin

                             Line ( Sx-SRadii-3, Sy, Sx-SRadii, Sy ) ;
                             Line ( Sx+SRadii+3, Sy, Sx+SRadii, Sy ) ;

                             Line ( Sx, Sy-SRadii-1, Sx, Sy-SRadii+1 ) ;
                             Line ( Sx, Sy+SRadii+1, Sx, Sy+SRadii-1 ) ;

                           End ;

                     End
                   Else
                     Begin

                       If (     ( SClas  = CatOthers  )
                            And ( NameCat <> 'HIP'    )
                            And ( NameCat <> 'TYC'    )
                            And ( Not B_Object_Tracks ) )
                         Then
                           Begin

                             {
                             If ( NameCat = 'HIP' )  Then
                               Begin
                                 SetColor ( LightGreen ) ;
                                 Line ( Sx-3 , Sy   , Sx+3 , Sy   ) ;
                                 Line ( Sx   , Sy+2 , Sx   , Sy-2 ) ;
                                 Line ( Sx-2 , Sy-2 , Sx+2 , Sy+2 ) ;
                                 Line ( Sx-2 , Sy+2 , Sx+2 , Sy-2 ) ;
                               End ;

                             If ( NameCat = 'TYC' )  Then
                               Begin
                                 SetColor ( LightGreen ) ;
                                 Line ( Sx-1 , Sy-1 , Sx+1 , Sy+1 ) ;
                                 Line ( Sx-1 , Sy+1 , Sx+1 , Sy-1 ) ;
                               End ;
                             }

                             If (     ( NameCat <> 'HIP' )
                                  And ( NameCat <> 'TYC' ) )  Then
                               Begin

                                 PutPixel ( Sx-1, Sy,   SColor ) ;
                                 PutPixel ( Sx+1, Sy,   SColor ) ;
                                 PutPixel ( Sx,   Sy-1, SColor ) ;
                                 PutPixel ( Sx,   Sy+1, SColor ) ;

                                 PutPixel ( Sx-4, Sy,   SColor ) ;
                                 PutPixel ( Sx+4, Sy,   SColor ) ;
                                 PutPixel ( Sx,   Sy-3, SColor ) ;
                                 PutPixel ( Sx,   Sy+3, SColor ) ;

                                 PutPixel ( Sx-3, Sy-2, SColor ) ;
                                 PutPixel ( Sx+3, Sy-2, SColor ) ;
                                 PutPixel ( Sx-3, Sy+2, SColor ) ;
                                 PutPixel ( Sx+3, Sy+2, SColor ) ;

                               End ;

                           End
                         Else
                           Begin
                             Case SRadii Of

                               0:    PutPixel ( Sx,   Sy, SColor ) ;

                               1:  Begin
                                     PutPixel ( Sx,   Sy, SColor ) ;
                                     PutPixel ( Sx+1, Sy, SColor ) ;
                                   End ;

                               2:  Begin
                                     PutPixel ( Sx  , Sy   , SColor ) ;
                                     Line ( Sx-1 , Sy+1   , Sx+1 , Sy+1   ) ;
                                     {
                                     PutPixel ( Sx  , Sy-1 , SColor ) ;
                                     PutPixel ( Sx+1, Sy   , SColor ) ;
                                     }
                                   End ;

                               3:  Begin
                                     Line ( Sx-1 , Sy   , Sx+1 , Sy   ) ;
                                     Line ( Sx   , Sy-1 , Sx   , Sy+1 ) ;
                                   End ;

                               4: Begin
                                    Line ( Sx-1 , Sy-1 , Sx+1 , Sy-1 ) ;
                                    Line ( Sx-1 , Sy   , Sx+1 , Sy   ) ;
                                    Line ( Sx-1 , Sy+1 , Sx+1 , Sy+1 ) ;
                                  End ;

                               5: Begin
                                    Line ( Sx-1 , Sy-1 , Sx+1 , Sy-1 ) ;
                                    Line ( Sx-2 , Sy   , Sx+2 , Sy   ) ;
                                    Line ( Sx-1 , Sy+1 , Sx+1 , Sy+1 ) ;
                                    {
                                    Line ( Sx   , Sy-2 , Sx   , Sy+2 ) ;
                                    }
                                  End ;

                               6: Begin
                                    Line ( Sx-1 , Sy-1 , Sx+1 , Sy-1 ) ;
                                    Line ( Sx-2 , Sy   , Sx+2 , Sy   ) ;
                                    Line ( Sx-1 , Sy+1 , Sx+1 , Sy+1 ) ;
                                    Line ( Sx   , Sy-2 , Sx   , Sy+2 ) ;
                                  End ;

                               7: Begin
                                    Line ( Sx-1 , Sy-2 , Sx+1 , Sy-2 ) ;
                                    Line ( Sx-2 , Sy-1 , Sx+2 , Sy-1 ) ;
                                    Line ( Sx-3 , Sy   , Sx+3 , Sy   ) ;
                                    Line ( Sx-2 , Sy+1 , Sx+2 , Sy+1 ) ;
                                    Line ( Sx-1 , Sy+2 , Sx+1 , Sy+2 ) ;
                                  End ;

                               8: Begin
                                    Line ( Sx-1 , Sy-3 , Sx+1 , Sy-3 ) ;
                                    Line ( Sx-3 , Sy-2 , Sx+3 , Sy-2 ) ;
                                    Line ( Sx-4 , Sy-1 , Sx+4 , Sy-1 ) ;
                                    Line ( Sx-4 , Sy   , Sx+4 , Sy   ) ;
                                    Line ( Sx-4 , Sy+1 , Sx+4 , Sy+1 ) ;
                                    Line ( Sx-3 , Sy+2 , Sx+3 , Sy+2 ) ;
                                    Line ( Sx-1 , Sy+3 , Sx+1 , Sy+3 ) ;
                                  End ;
                              {
                              9: Begin
                                    Line ( Sx-2 , Sy-3 , Sx+2 , Sy-3 ) ;
                                    Line ( Sx-4 , Sy-2 , Sx+4 , Sy-2 ) ;
                                    Line ( Sx-5 , Sy-1 , Sx+5 , Sy-1 ) ;
                                    Line ( Sx-5 , Sy   , Sx+5 , Sy   ) ;
                                    Line ( Sx-5 , Sy+1 , Sx+5 , Sy+1 ) ;
                                    Line ( Sx-4 , Sy+2 , Sx+4 , Sy+2 ) ;
                                    Line ( Sx-2 , Sy+3 , Sx+2 , Sy+3 ) ;
                                  End ;
                              }
                              9: Begin
                                    Line ( Sx-2 , Sy-4 , Sx+2 , Sy-4 ) ;
                                    Line ( Sx-4 , Sy-3 , Sx+4 , Sy-3 ) ;
                                    Line ( Sx-5 , Sy-2 , Sx+5 , Sy-2 ) ;
                                    Line ( Sx-6 , Sy-1 , Sx+6 , Sy-1 ) ;
                                    Line ( Sx-6 , Sy   , Sx+6 , Sy   ) ;
                                    Line ( Sx-6 , Sy+1 , Sx+6 , Sy+1 ) ;
                                    Line ( Sx-5 , Sy+2 , Sx+5 , Sy+2 ) ;
                                    Line ( Sx-4 , Sy+3 , Sx+4 , Sy+3 ) ;
                                    Line ( Sx-2 , Sy+4 , Sx+2 , Sy+4 ) ;
                                  End ;

                             10: Begin
                                    Line ( Sx-2 , Sy-5 , Sx+2 , Sy-5 ) ;
                                    Line ( Sx-4 , Sy-4 , Sx+4 , Sy-4 ) ;
                                    Line ( Sx-6 , Sy-3 , Sx+6 , Sy-3 ) ;
                                    Line ( Sx-7 , Sy-2 , Sx+7 , Sy-2 ) ;
                                    Line ( Sx-7 , Sy-1 , Sx+7 , Sy-1 ) ;
                                    Line ( Sx-8 , Sy   , Sx+8 , Sy   ) ;
                                    Line ( Sx-7 , Sy+1 , Sx+7 , Sy+1 ) ;
                                    Line ( Sx-7 , Sy+2 , Sx+7 , Sy+2 ) ;
                                    Line ( Sx-6 , Sy+3 , Sx+6 , Sy+3 ) ;
                                    Line ( Sx-4 , Sy+4 , Sx+4 , Sy+4 ) ;
                                    Line ( Sx-2 , Sy+5 , Sx+2 , Sy+5 ) ;
                                  End ;


                             11: Begin
                                   SetFillStyle ( SolidFill, SColor ) ;
                                   FillEllipse ( Sx, Sy, 9, 9 * Longint(Xasp) div Yasp ) ;
                                 End ;


                             12: Begin
                                   SetFillStyle ( SolidFill, SColor ) ;
                                   FillEllipse ( Sx, Sy, 10, 10 * Longint(Xasp) div Yasp  ) ;
                                 End ;


                             13: Begin
                                   SetFillStyle ( SolidFill, SColor ) ;
                                   FillEllipse ( Sx, Sy, 11, 11 * Longint(Xasp) div Yasp  ) ;
                                 End ;


                             14: Begin
                                   SetFillStyle ( SolidFill, SColor ) ;
                                   FillEllipse ( Sx, Sy, 12, 12 * Longint(Xasp) div Yasp  ) ;
                                 End ;


                             End ;

                       End ; { Case }

                     End ;



                   If ( SClas = CatOthers )  Then
                     Begin

                       S := CatNameKutcha [ ( NRecC Mod 1000000000 ) Mod 20 ];
                       If ( S = 'PSC' ) Or ( S = 'FSC' )  Then
                         Begin
                           Elipse ( NRecC, Sx, Sy ) ;
                         End ;

                     End ;



                   If ( NRecC Div 1000000000 = 1 ) Then
                     Begin  { å†p™®pÆ¢™† }
                            { ƒƒƒƒƒƒƒƒƒƒ }
                       {
                       SetWriteMode ( XORPut ) ;
                       }
                       If ( NGrMarking = 0 )
                         Then
                           Begin

                             SetColor ( LightRed ) ;

                             Triangle [ 1 ].X := Sx - 8 ;
                             Triangle [ 2 ].X := Sx     ;
                             Triangle [ 3 ].X := Sx + 8 ;
                             Triangle [ 4 ].X := Sx - 8 ;

                             Triangle [ 1 ].Y := Sy + 4 ;
                             Triangle [ 2 ].Y := Sy - 7 ;
                             Triangle [ 3 ].Y := Sy + 4 ;
                             Triangle [ 4 ].Y := Sy + 4 ;

                             DrawPoly ( SizeOf ( Triangle  ) Div
                                        SizeOf ( PointType ), Triangle);


                           End
                         Else
                           Begin
                             SetColor ( MarkingCol [ Date ] ) ;
                             Circle   ( Sx, Sy, SRadii+2 ) ;
                           End ;


                       Inc ( NMarkingField ) ;
                       {
                       SetWriteMode ( NormalPut ) ;
                       }
                     End ;

                 End ;

             End ;  { Ç ØÆ´• ßp•≠®Ô }
                    { ƒƒƒƒƒƒƒƒƒƒƒƒƒ }

         End; { ObjectPtr }

      End ;  { IFirst > -1 }

    End ; { SClas  }
          { ƒƒƒƒƒƒ }

  End ; { IndCatOut }
        { ƒƒƒƒƒƒƒƒƒ }


       { ò™†´Î §´Ô ¢•™‚Æp≠Æ© §®†£p†¨¨Î }
       { ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ }

   If ( CalcVectDiagr )  Then
     Begin

       SetColor     ( LightRed ) ;
       SetWriteMode ( CopyPut    ) ;

       Sx := (sw.x2-sw.x1) Div 2 -
             Trunc ( CenterX * GScale / XMax * (sw.x2-sw.x1+1) / C20 );
       Sy := Trunc ( ( (sw.y2-sw.y1+1) +
             CenterY * GScale / YMax * (sw.y2-sw.y1+1) ) / C20);

       Stx := ( (sw.x2-sw.x1) / C20 ) / NDiagrScale * GScale ;
       Sty := ( (sw.y2-sw.y1) / C20 ) / NDiagrScale * GScale ;

       If (     ( Sy > -   1 )
            And ( Sy <  1000 )  )  Then
         Line ( 0, Sy, 700, Sy ) ;

       If (     ( Sx > -   1 )
            And ( Sx <  1000 )  )  Then
         Line ( Sx, 0, Sx, 400 ) ;

       For Ind := 1 To NDiagrScale Do
         Begin
           If ( ( Ind Mod 10 ) = 0 )
             Then
               Begin
                 dSx := dSxScale * 2 ;
                 dSy := dSyScale * 2 ;
                 SetColor ( LightCyan ) ;
               End
             Else
               Begin
                 dSx := dSxScale ;
                 dSy := dSyScale ;
                 SetColor ( LightRed ) ;
               End ;


           If (     (   Sx               > - 100 )
                And (   Sx               <  1000 )
                And ( ( Sy - Ind * StY ) > - 100 )
                And ( ( Sy - Ind * StY ) <  1000 )
                                                   )  Then
             Line ( Sx-dSx, Trunc ( Sy - Ind * StY ),
                    Sx+dSx, Trunc ( Sy - Ind * StY )  ) ;

           If (     (   Sx               > - 100 )
                And (   Sx               <  1000 )
                And ( ( Sy + Ind * StY ) > - 100 )
                And ( ( Sy + Ind * StY ) <  1000 )
                                                   )  Then
           Line ( Sx-dSx, Trunc ( Sy + Ind * StY ),
                  Sx+dSx, Trunc ( Sy + Ind * StY )  ) ;


           If (     (   Sy               > - 100 )
                And (   Sy               <  1000 )
                And ( ( Sx - Ind * StY ) > - 100 )
                And ( ( Sx - Ind * StY ) <  1000 )
                                                   )  Then
           Line ( Trunc ( Sx - Ind * StX )    , Sy-dSy,
                  Trunc ( Sx - Ind * StX )    , Sy+dSy  ) ;

           If (     (   Sy               > - 100 )
                And (   Sy               <  1000 )
                And ( ( Sx + Ind * StY ) > - 100 )
                And ( ( Sx + Ind * StY ) <  1000 )
                                                   )  Then
           Line ( Trunc ( Sx + Ind * StX - 1 ), Sy-dSy,
                  Trunc ( Sx + Ind * StX - 1 ), Sy+dSy  ) ;

         End ;

       SetWriteMode ( NormalPut ) ;

     End ;



 If ( MvCorr )  Then
   Begin
     MvMax  := MvMax - 0.5 ;
     MvMin  := MvMin + 0.5 ;
   End ;



 SetColor ( cCol ) ;
 SetWriteMode ( NormalPut ) ;
 {
 If (     (  Not  B_Import_Fld  )
      And (  Not  B_VectDiagr   )
      And (  Not  B_Det_Cdc     )  )  Then
 }
 If (     (  Not  B_Import_Fld  )
      And (  Not  B_VectDiagr   )
                                  )  Then
   ShowPlanets;


 End; { sw }

 If ( Not B_VectDiagr )  Then
   Begin
     FieldDop  ;        { ÑÆØÆ´≠®‚•´Ï≠†Ô ê†¨™† }
   End ;


 OutPV   ;
 Reportp ;

 If ( PMScale )  Then
   OrientSectPM ;

 SetVisualPage ( Page ) ;

 Inc ( NStepTracks ) ;


 With fs Do setfillstyle   ( pattern, color );
 With ts Do settextjustify ( horiz  , vert  );
 With vp Do setviewport    ( x1, y1, x2, y2, clip );
 setcolor   ( c ) ;
 setbkcolor ( b ) ;


End;

End.