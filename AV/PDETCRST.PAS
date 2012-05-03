
{$O+,F+}


UNIT PDetCrst ;


   {  é‚Æ¶§•·‚¢´•≠®•  Cdc  ¢ 'äp•·‚†Â'  }
   {  ********************************  }


INTERFACE

     Procedure  DetCrest ( CatDet : Byte ; IndCdc : LongInt ) ;


IMPLEMENTATION


USES

  SHELL_X ,
  PVAR    ,
  PProFld ,
  ProOut  ,
  PPreNew ,
  V_Catal  ;

Var

  DMvDetStars : Double ;


     Procedure  DetCrest ( CatDet : Byte ; IndCdc : LongInt ) ;


VAR


  PriX, PriY,
  FindAcMain,
  BMv,
  CExit          : BOOLEAN ;

  SpCdc         : Byte    ;

  InvX,
  InvY,
  Iter,
  PMu,
  SigX, SigY,
  UnitXMes, UnitYMes,
  DecXMes , DecYMes,
  IndX, IndY              : Integer ;

  RI,
  NMax,
  YearCdc,
  IndGscDet ,
  IndGsc  ,
  IGscBeg, IGscEnd ,
  IId    , IIm     ,
  IRd    , IRm     ,
  I, I1, I2,
  NumCdc , NumGsc         : Longint ;

  R0, R, R0Det, R0Det2,
  R0Gsc,
  StepCoordCdcX,
  StepCoordCdcY,
  CoordMesMax,
  XMinFind,
  XMaxFind                : Double    ;
  DMv, MvCdc              : Double    ;
  MvGsc , MvGscDet        : Double    ;
  X0 , Y0                 : Double    ;
  X  , Y                  : Double    ;
  XMes  , YMes            : Double    ;
  FracXMes, FracYMes      : Double    ;
  DMvDetCrest             : Double    ;
  XOut, YOut              : Double    ;


  ora, odc           : Double   ;
  g, mnt             : Integer  ;
  sec                : Double     ;
  cneg               : Boolean  ;


  S, t                    : String [ 40 ] ;
  CaseError               : String [ 10 ] ;

  AkZagolRecCrst          : AkInfType  ;



 {ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ}

 Function AcMain : Boolean ;
{‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹}

  Var

     ExitAcMain      : Boolean ;

     IAcMain  ,
     I2AcMain ,
     IRdAcMain,
     IRmAcMain,
     IndAcMain  ,
     IndAcMainBeg,
     IndAcMainEnd    : Longint ;


     XAcMain ,
     YAcMain ,
     RAcMain ,
     R0DetAcMain  ,
     R0DetAcMain2 ,
     XMinAcMain,
     XMaxAcMain      : Double   ;


   Begin

            IndAcMainBeg := IndCat [ CatCdc ].NBeg ;
            IndAcMainEnd := IndCat [ CatCdc ].NEnd ;

            R0DetAcMain  := Sqrt ( 2.0 ) * IndCat [ CatCdc ].RoDet
                                         / SekRad * FD ;
            R0DetAcMain2 := Sqr ( R0DetAcMain ) ;

            XMinAcMain   := X0 - R0DetAcMain  ;
            XMaxAcMain   := X0 + R0DetAcMain  ;


              { AcMain Ind. Star }
              { -------------- }

            IndAcMain := IndAcMainBeg ;
            I2AcMain  := IndAcMainEnd ;


            While ( ( I2AcMain - IndAcMain ) > 1 )  DO

              Begin  { I2-I1 > 1 }

                IAcMain := ( IndAcMain + I2AcMain )  Div  2 ;

                XAcMain := Objectptr [ AcMainNum^[IAcMain] Div ObjectBlockSize ]^
                                     [ AcMainNum^[IAcMain] Mod ObjectBlockSize ].X;

                If  ( XAcMain <= XMinAcMain )
                  Then  IndAcMain := IAcMain
                  Else  I2AcMain  := IAcMain ;

              End ; { I2-IndAcMain > 1 }


            ExitAcMain :=  False ;


               { èÆ®·™  Star Æ™Æ´Æ Ac  }
               { --------------------- }

            While (     ( NOT  ExitAcMain          )
                    And ( IndAcMain < IndAcMainEnd )  )    Do

              Begin  { èpÆ·¨Æ‚p† Star }
                     { -------------- }


                IRdAcMain := AcMainNum ^ [ IndAcMain ] Div ObjectBlockSize ;
                IRmAcMain := AcMainNum ^ [ IndAcMain ] Mod ObjectBlockSize ;

                XAcMain := Objectptr [ IRdAcMain ]^[ IRmAcMain ] . X;

                ExitAcMain := XAcMain > XMaxAcMain ;

                If ( Not ExitAcMain )  Then

                  Begin  { NOT CExit }

                    YAcMain := Objectptr [ IRdAcMain ]^[ IRmAcMain ] . Y;

                    RAcMain :=    Sqr ( XAcMain - X0 )
                               +  Sqr ( YAcMain - Y0 ) ;

                    If ( RAcMain <= R0DetAcMain2 )
                       Then
                         Begin
                            AcMain     := True ;
                            ExitAcMain := True ;
                         End
                       Else
                            AcMain := False ;

                  End ;  { NOT CExit }
                         { -------- }

                Inc ( IndAcMain ) ;


              End ;  { èpÆ·¨Æ‚p† Star }
                     { -------------- }

   End ; { AcMain }
         { ------ }

 {ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ}


 Procedure DetS ;
{‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹}

   Begin


        R0Det2 := Sqr ( R0Det ) ;

        XOut := X ;
        YOut := Y ;

        X := X - AkZagolRec.XShift ;
        Y := Y - AkZagolRec.YShift ;

        X := X * StepCoordCdcX ;
        Y := Y * StepCoordCdcY ;

        X := - X ;

        X0 :=  X * Ax  +  Y * Bx  +  Cx  +  D * X * X  +  E * X * Y  ;
        Y0 :=  X * Ay  +  Y * By  +  Cy  +  D * X * Y  +  E * Y * Y  ;


        If (      ( Abs ( X0 ) <= 70 )
             And  ( Abs ( Y0 ) <= 70 )   )  Then
          Begin  { Ç ØÆ´• ßp•≠®Ô }
                 { ------------- }


            XMinFind   := X0 - R0Det  ;
            XMaxFind   := X0 + R0Det  ;


              { FInd Ind. Star }
              { -------------- }

            I1 := IGscBeg  ;
            I2 := IGscEnd  ;


            While ( (I2-I1) > 1 ) DO

              Begin  { I2-I1 > 1 }

                I :=  ( I1 + I2 )  Div  2 ;

                X := Objectptr [ I div ObjectBlockSize ]^
                               [ I mod ObjectBlockSize ].X;

                If  ( X <= XMinFind )
                  Then  I1 := I
                  Else  I2 := I ;

              End ; { I2-I1 > 1 }


            CExit :=  False ;



               { èÆ®·™  Star Æ™Æ´Æ Cdc  }
               { ---------------------- }

            IndGsc :=  I1 - 1 ;

            While (     ( NOT  CExit        )
                    And ( IndGsc < IGscEnd )  )    Do

              Begin  { èpÆ·¨Æ‚p† Star }
                     { -------------- }

                IndGsc := IndGsc + 1 ;

                IRd := IndGsc Div ObjectBlockSize ;
                IRM := IndGsc Mod ObjectBlockSize ;

                X := Objectptr [ IRd ]^[ IRM ] . X;

                CExit := X > XMaxFind ;

                If ( Not CExit )  Then

                  Begin  { NOT CExit }

                    Y := Objectptr [ IRd ]^[ IRM ] . Y;

                    R := Sqr ( X - X0 )  +  Sqr ( Y - Y0 )  ;

                    MvGsc := Objectptr [ IRd ] ^ [ IRM ].M / 10 - 5 ;

                    DMv   := MvCdc - MvGsc ;

                    If (      ( R           <= R0Det2      )
                          And ( Objectptr [ IRd ]^[ IRM ].Sp Div 10 <> 4 )
                          And ( Abs ( DMv ) <= DMvDetCrest )  )  Then

                      Begin  { H•Æ‚Æ¶§•·‚¢´•≠≠†Ô Star ØÆØ†´† ¢ ™p„£ }
                             { ------------------------------------ }


                        If (     ( Not ( BMv ) )
                              Or ( BMv And ( Abs ( DMv ) > DmvDetStars ) ))
                            Then
                          Begin

                            S :=  NameCatOut[CatDet] ;
                            If ( CatDet = CatCdcMoz )  Then
                               S := 'AC  ' ;

{ ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ }
                            If ( FlagAcMainNumAlloc ) Then
                              Begin
                                If ( ( FindAcMain )  And ( AcMain ) )
                                   Then S := '* ' + S
                                   Else S := '  ' + S ;
                              End ;
{  ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ }

                            If  ( Not  OutCdc  )  Then
                              Begin

                                WriteLn ( OutFile ) ;
                                WriteLn ( OutFile ) ;

                                RI := ( NRecCOut Mod 1000000000 ) Div 1000  ;

                                If  ( RI Mod 10 > 0 )  Then
                                  Begin
                                    Write ( OutFile ,
                                          RI  div  10                     :8,
                                          Chr ( Ord('a')+ (RI mod 10 - 1)):1);
                                  End
                                 Else
                                    Write ( OutFile , RI Div 10 :8, ' ' ) ;



                                Write   ( OutFile ,
                                                     XMes  : 13:4 ,
                                                     YMes  :  9:4 ,
                                                     MvCdc :  6:1    ) ;

                                OutCdc := True ;

(*
                                IdToEq ( Objectptr [ IId ]^[ IIm ].X,
                                Objectptr [ IId ]^[ IIm ].Y, npolfix, spoznp, cpoznp,
                                                             ora, odc );

                                PreNew ( JDateFld, JDOut, ORA, ODC ) ;

                                                   { R.A. }
                                                   { ---- }
                                radtohms ( ora, g, mnt,sec);
                                Write ( OutFile, '':42,
                                                 HourString(g, mnt, sec) );

                                                   { Decl }
                                                   { ---- }
                                radtogms(odc,cneg,g,mnt,sec);
                                Write ( OutFile, '  ',
                                        DegrString(cneg, g, mnt, sec),'  ' );

*)

                                Writeln ( OutFile ) ;


                              End ;



                            Write  ( OutFile ,
                                     S           : 14     ) ;

                            If PriX
                               Then   Write ( OutFile, XOut :  8:4 )
                               Else   Write ( OutFile,   '' :  8   ) ;

                            If PriY
                               Then   Write ( OutFile, YOut :  9:4 )
                               Else   Write ( OutFile,   '' :  9   ) ;

                            Write  ( OutFile ,
                                     MvGsc       :  6:1 ,
                                     CaseError          ,
                                     InvX * (X0-X)/FD*SekRad : 4:0,
                                     '" ',
                                     InvY * (Y-Y0)/FD*SekRad : 4:0,
                                     '" '
                                       ) ;

                            If ( CatDet = CatCdcMoz )  Then
                               Begin

                                 AkZagolRecCrst := PlateZagol ^ [ Objectptr [ IRd ]^[ IRM ].NRecC Mod 1000 ] ;

                                 Str ( AkZagolRecCrst.DcG : 4 , t ) ;
                                 If ( t[3] = ' ' )  Then t[3] := '0' ;
                                 If ( t[3] = '-' )  Then
                                   Begin
                                     t[3] := '0' ;
                                     t[2] := '-' ;
                                   End ;
                                 If ( t[2] = ' ' )  Then t[2] := '+' ;
                                 S := ' ' + t + ' ' ;

                                 Str ( AkZagolRecCrst.RaH : 2 , t ) ;
                                 If ( t[1] = ' ' )  Then  t[1] := '0' ;
                                 S := S + t ;

                                 Str ( AkZagolRecCrst.RaM : 2 , t ) ;
                                 If ( t[1] = ' ' )  Then  t[1] := '0' ;
                                 S := S + '.' + t ;

                                 RI := ( Objectptr [ IRd ]^[ IRM ].NRecC Mod 1000000000 ) Div 1000  ;

                                 If  ( RI Mod 10 > 0 )  Then
                                   Begin
                                     Str ( RI Div 10  : 7 , t ) ;
                                     t := t + Chr ( Ord('a')+ (RI mod 10 - 1)) ;
                                   End
                                  Else  Str ( RI Div 10 : 7   , t ) ;

                                 S := S + '  ' + t ;

                                 Write ( OutFile , S ) ;

                               End ;


                            If (    ( PMu = 1 )
                                 Or ( ( CatDet = CatNLTT ) And ( PMu <> 1 ) ))
                              Then

                                Begin

                                       { ÇÎ§†Á† Ì™¢†‚Æp®†´Ï≠ÎÂ ™ÆÆp§®≠†‚ }

(*
                                  If ( CatDet <> CatCdcMoz )
                                      Then Write ( OutFile, '':20 ) ;

                                  IdToEq ( X0, Y0, npolfix, spoznp, cpoznp,
                                           ora, odc );

                                  PreNew ( JDateFld, JDOut, ORA, ODC ) ;

                                                 { R.A. }
                                                 { ---- }
                                  radtohms ( ora, g, mnt,sec);
                                  Write ( OutFile, '  ',
                                          HourString(g, mnt, sec) );

                                                { Decl }
                                                { ---- }
                                  radtogms(odc,cneg,g,mnt,sec);
                                  Write ( OutFile, '  ',
                                          DegrString(cneg, g, mnt, sec),'  ' );

*)
                                  Writeln ( OutFile ) ;

                                End

                              Else

                                Begin

                                  If ( CatDet = CatGsc )  Then
                                    Begin

                                      Writeln ( OutFile,
                                        Sqrt ( R ) / FD * SekRad / YearCdc : 6:2,
                                        ' "/y'  ) ;

                                    End

                                   Else

                                      Writeln ( OutFile ) ;

                                End ;

                          End ;

                      End ;  { Star ØÆØ†´† ¢ ™p„£ }
                             { ------------------ }

                  End ;  { NOT CExit }
                         { -------- }

              End ;  { èpÆ·¨Æ‚p† Star }
                     { -------------- }

          End ;  { Ç ØÆ´• ßp•≠®Ô }
                 { ------------- }

   End ; { DetS }
         { ---- }

 {ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ}


  Begin { PRO DetStar }

    DMvDetStars   := 3      ;
    BMv           := False  ;

    StepCoordCdcX := AkZagolRec.XScale ;
    StepCoordCdcY := AkZagolRec.YScale ;

    InvX          := Round ( StepCoordCdcX / Abs ( StepCoordCdcX ) );
    InvY          := Round ( StepCoordCdcY / Abs ( StepCoordCdcY ) );

    DMvDetCrest   := DmvDetStars ;

    NMax := 65 Div Round ( Abs ( AkZagolRec.XScale ) ) ;
    If ( NMax = 13 )  Then
      NMax := 26 ;

    CoordMesMax := NMax + 1 ;

    NMax := NMax Div 10 ;  { Max Á®·´Æ §•·Ô‚™Æ¢ ¢ ™ÆÆp§®≠†‚• }
                           { ------------------------------- }

    PMu := 1 ;

    IGscBeg := IndCat [ CatDet ] . NBeg ;
    IGscEnd := IndCat [ CatDet ] . NEnd ;


    R0 := IndCat [ CatDet ].RoDet / SekRad * FD ; { R0 , MM }
                                                      { ------- }
    R0Det  := R0      ;
    R0Det2 := R0 * R0 ;

    R0Gsc := R0Det ;

    R0Gsc := 5.0 / SekRad * FD * Abs ( AkZagolRec.XScale ) ;


    If ( CatSort [ CatDet ] = False ) Then
       Begin
          SHELLX ( IGscBeg , IGscEnd ) ;
          CatSort [ CatDet ] := True ;
       End ;



          {  ÇÎ°Æp Cdc  }
          {  ---------  }

    IId := IndCdc Div ObjectBlockSize ;
    IIm := IndCdc Mod ObjectBlockSize ;

    SpCdc  := Objectptr [ IId ]^[ IIm ] . Sp                   ;
    MvCdc  := Objectptr [ IId ]^[ IIm ] . M / 10 - 5           ;

    YearCdc := Objectptr [ IId ]^[ IIM ].NRecC Mod 1000 ;
    YearCdc := 1982 - ( YearCdc Div 13 + 1890 );



    X0 := Objectptr [ IId ]^[ IIm ] . X  ;
    Y0 := Objectptr [ IId ]^[ IIm ] . Y  ;


    { à‚•p†Ê®Æ≠≠Æ• p•Ë•≠®• ß†§†Á® ÆØp•§•´•≠®Ô
      ®ß¨•p•≠≠ÎÂ ™ÆÆp§®≠†‚ ØÆ ®§•†´Ï≠Î¨ }

    X0 := X0 - Cx ;
    Y0 := Y0 - Cy;

    XMes := ( (X0) * By  -  (Y0) * Bx ) / ( Ax * By - Ay * Bx ) ;
    YMes := ( (Y0) * Ax  -  (X0) * Ay ) / ( Ax * By - Ay * Bx ) ;

    for iter:=1 to 4 do
    begin

         X :=  Xmes * Ax  +  Ymes * Bx  + D * Xmes * Xmes  +  E * Xmes * Ymes  ;
         Y :=  Xmes * Ay  +  Ymes * By  + D * Xmes * Ymes  +  E * Ymes * Ymes  ;

         xMes := xMes + X0 - X;
         yMes := yMes + Y0 - Y;

    end ;

    XMes := - XMes ;


        { ìÁ•‚ Ë†£† Ë™†´Î }
        { --------------- }

    XMes := XMes / StepCoordCdcX ;
    YMes := YMes / StepCoordCdcY ;

        { H†Á†´Æ Æ‚·Á•‚† Ë™†´ }
        { ------------------- }

    XMes := XMes + AkZagolRec.XShift ;
    YMes := YMes + AkZagolRec.YShift ;

    SigX := 1 ;  If ( XMes < 0 )  Then SigX := - 1 ;
    SigY := 1 ;  If ( YMes < 0 )  Then SigY := - 1 ;

    FracXMes := Frac  ( Abs ( XMes ) ) ;
    FracYMes := Frac  ( Abs ( YMes ) ) ;

    DecXMes  := Trunc ( Abs ( XMes ) ) Div 10 ;
    DecYMes  := Trunc ( Abs ( YMes ) ) Div 10 ;

    UnitXMes := Trunc ( Abs ( XMes ) ) Mod 10 ;
    UnitYMes := Trunc ( Abs ( YMes ) ) Mod 10 ;

{
    If  ( Not  OutCdc  )  Then
      Begin

        Write   ( OutFile ,
                  XMes  : 13:4 ,
                  YMes  :  9:4 ,
                  MvCdc :  6:1    ) ;

        OutCdc := True ;
}

(*
        IdToEq ( Objectptr [ IId ]^[ IIm ].X,
                 Objectptr [ IId ]^[ IIm ].Y, npolfix, spoznp, cpoznp,
                 ora, odc );

        PreNew ( JDateFld, JDOut, ORA, ODC ) ;

                  { R.A. }
                  { ---- }
        radtohms ( ora, g, mnt,sec);
        Write ( OutFile, '':42,   HourString(g, mnt, sec) );

                  { Decl }
                  { ---- }
        radtogms(odc,cneg,g,mnt,sec);
        Write ( OutFile, '  ',  DegrString(cneg, g, mnt, sec),'  ' );

*)
{
        Writeln ( OutFile ) ;

      End ;
}


     FindAcMain   := False  ;

     PriX := False ;
     PriY := False ;


     { éË®°™† ¢ ß¢•ß§≠Æ© ¢•´®Á®≠• }
     { -------------------------- }

        X   := XMes ;
        Y   := YMes ;
        CaseError    := ' Mv     ' ;
        FindAcMain   := False  ;
        BMv          := True   ;
        DMvDetCrest  := 20.0   ;
        Dets ;
        DMvDetCrest  := DmvDetStars ;
        BMv          := False  ;


     { ÅÆ´ÏËÆ• ·Æ°·‚¢. §¢®¶•≠®• }
     { ------------------------ }

   PMu := 3 ;


   If ( PMu > 1 )  Then
     Begin
       R0Det := R0 * PMu ;
       X  := XMes ;
       Y  := YMes ;
       CaseError := ' P.M.   ' ;
       FindAcMain := False  ;
       Dets ;
       R0Det  := R0  ;
       PMu := 1 ;
     End ;




          { à≠¢•p·®Ô X }
          { ƒƒƒƒƒƒƒƒƒƒ }

    PriX := True  ;
    PriY := False ;
    FindAcMain := True  ;

    CaseError := ' Inv   X' ;

    If ( UnitXMes <> DecXMes )  Then
      Begin
        X := SigX * ( UnitXMes * 10.0 + DecXMes + FracXMes ) ;
        Y := YMes ;
        Dets ;
       {====}
      End ;


          { à≠¢•p·®Ô Y }
          { ƒƒƒƒƒƒƒƒƒƒ }

    PriX := False ;
    PriY := True  ;

    CaseError := ' Inv   Y' ;

    If ( UnitYMes <> DecYMes )  Then
      Begin
        X := XMes ;
        Y := SigY * ( UnitYMes * 10.0 + DecYMes + FracYMes ) ;
        Dets ;
       {====}
      End ;


    PriX := True  ;
    PriY := False ;


          { ë¨•≠† ß≠†™† X }
          { ƒƒƒƒƒƒƒƒƒƒƒƒƒ }

    X := - XMes ;
    Y :=   YMes ;
    CaseError := ' Sig   X' ;
    Dets ;
   {====}


       { éØ•Á†‚™† ¢ §•·Ô‚ÎÂ X }
       { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

      CaseError := ' 0.1   X' ;

      If ( CatDet = CatGsc )
         Then   R0Det := R0Gsc ;


      For  IndX := 0  To  9  Do
        Begin  { IndX }

          X := SigX * (    Trunc ( Abs ( XMes ) )
                         + FracXMes - Trunc ( FracXMes * 10.0 + 0.0001 ) / 10.0
                         + IndX  / 10.0  ) ;
          Y := YMes ;

          If ( Abs ( X - XMes ) > 0.001 )  Then
             Dets ;

        End ;  { IndX }

      If ( CatDet = CatGsc )
         Then   R0Det := R0 ;




       { éË®°™† ≠† Ë†£ Ë´†´Î  }
       { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }


      If ( NMax > 3 )  Then
        Begin

          CaseError := ' Step  X' ;

          For  IndX := 1  To  2  Do
            Begin  { IndY }

              X := XMes + ( IndX * 2 - 1 ) * 5.0 / StepCoordCdcX ;
              Y := YMes ;

              If ( Trunc ( X / 10.0 ) <> Trunc ( XMes / 10.0 ) )
                 Then  Dets ;

              X := XMes - ( IndX * 2 - 1 ) * 5.0 / StepCoordCdcX ;
              Y := YMes ;

              If ( Trunc ( X / 10.0 ) <> Trunc ( XMes / 10.0 ) )
                 Then  Dets ;

            End ;  { IndX }

        End ;




       { éØ•Á†‚™† ¢ n * 0.5 X }
       { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

      If ( NMax > 3 )  Then
        Begin

          CaseError := ' 0.5   X' ;

          For  IndX := 0  To  3  Do
            Begin  { IndX }

              X := XMes + IndX + 0.5 ;
              Y := YMes ;

              If ( Trunc ( X ) <> Trunc ( XMes ) )
                 Then  Dets ;

              X := XMes - IndX - 0.5 ;
              Y := YMes ;

              If ( Trunc ( X ) <> Trunc ( XMes ) )
                 Then  Dets ;

            End ;  { IndX }

        End ; { NMax > 3 }



       { éØ•Á†‚™† ¢ •§®≠®Ê• X }
       { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

      CaseError := ' Unit  X' ;

      For  IndX := 0  To  9  Do
        Begin  { IndX }

          If ( IndX <> UnitXMes )  Then
            Begin

              X := SigX * ( DecXMes * 10 + IndX + FracXMes ) ;
              Y := YMes ;

              Dets ;

            End ;

        End ;  { IndX }


       { éØ•Á†‚™† ¢ §•·Ô‚™• X }
       { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

      CaseError := ' Dec   X' ;

      For  IndX := 0  To  NMax  Do
        Begin  { IndX }

          If ( IndX <> DecXMes )  Then
            Begin

              X := SigX * ( IndX * 10 + UnitXMes + FracXMes ) ;
              Y := YMes ;

              Dets ;

            End ;

        End ;  { IndX }


     { éË®°™† ¢ ØÆ´Æ¶•≠®® §•·Ô‚®Á≠Æ© ‚ÆÁ™® X }
     { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

    CaseError := ' Point X' ;

    If ( Abs ( XMes ) > 1 )
      Then  X := XMes /  10 ;
    Y := YMes ;
    DetS ;

    X := XMes *  10 ;
    If ( Abs ( X ) <= CoordMesMax )  Then
      Begin
        Y := YMes ;
        DetS ;
      End ;

    X := XMes * 100 ;
    If ( Abs ( X ) <= CoordMesMax )  Then
      Begin
        Y := YMes ;
        DetS ;
      End ;



    PriX := False ;
    PriY := True  ;




          { ë¨•≠† ß≠†™† Y }
          { ƒƒƒƒƒƒƒƒƒƒƒƒƒ }

    X :=   XMes ;
    Y := - YMes ;
    CaseError := ' Sig   Y' ;
    Dets ;
   {====}


       { éØ•Á†‚™† ¢ §•·Ô‚ÎÂ Y }
       { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

      CaseError := ' 0.1   Y' ;

      If ( CatDet = CatGsc )
         Then   R0Det := R0Gsc ;


      For  IndY := 0  To  9  Do
        Begin  { IndX }

          Y := SigY * (    Trunc ( Abs ( YMes ) )
                         + FracYMes - Trunc ( FracYMes * 10.0 + 0.0001 ) / 10.0
                         + IndY  / 10.0  ) ;
          X := XMes ;

          If ( Abs ( Y - YMes ) > 0.001 )  Then
             Dets ;

        End ;  { IndX }

      If ( CatDet = CatGsc )
         Then   R0Det := R0 ;



       { éË®°™† ≠† Ë†£ Ë´†´Î  }
       { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

      If ( NMax > 3 )  Then
        Begin

          CaseError := ' Step  Y' ;

          For  IndY :=  1  To  2  Do
            Begin  { IndY }

              Y := YMes + ( IndY * 2 - 1 ) * 5.0 / StepCoordCdcY ;
              X := XMes ;

              If ( Trunc ( Y / 10.0 ) <> Trunc ( YMes / 10.0 ) )
                 Then  Dets ;

              Y := YMes - ( IndY * 2 - 1 ) * 5.0 / StepCoordCdcY ;
              X := XMes ;

              If ( Trunc ( Y / 10.0 ) <> Trunc ( YMes / 10.0 ) )
                 Then  Dets ;

            End ;  { IndY }

        End ;



       { éØ•Á†‚™† ¢ n * 0.5 Y }
       { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

      If ( NMax > 3 )  Then
        Begin

          CaseError := ' 0.5   Y' ;

          For  IndY := 0  To  3  Do
            Begin  { IndY }

              Y := YMes + IndY + 0.5 ;
              X := XMes ;

              If ( Trunc ( Y ) <> Trunc ( YMes ) )
                 Then  Dets ;

              Y := YMes - IndY - 0.5 ;
              X := XMes ;

              If ( Trunc ( Y ) <> Trunc ( YMes ) )
                 Then  Dets ;

            End ;  { IndY }

        End ; { NMax > 3 }



       { éØ•Á†‚™† ¢ •§®≠®Ê• Y }
       { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

      CaseError := ' Unit  Y' ;

      For  IndY := 0  To  9  Do
        Begin  { IndY }

          If ( IndY <> UnitYMes )  Then
            Begin

              Y := SigY * ( DecYMes * 10 + IndY + FracYMes ) ;
              X := XMes ;

              Dets ;

            End ;

        End ;  { IndY }



       { éØ•Á†‚™† ¢ §•·Ô‚™• Y }
       { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

      CaseError := ' Dec   Y' ;

      For  IndY := 0  To  NMax  Do
        Begin  { IndY }

          If ( IndY <> DecYMes )  Then
            Begin

              Y := SigY * ( IndY * 10 + UnitYMes + FracYMes ) ;
              X := XMes ;

              Dets ;

            End ;

        End ;  { IndY }



     { éË®°™† ¢ ØÆ´Æ¶•≠®® §•·Ô‚®Á≠Æ© ‚ÆÁ™® Y }
     { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

    CaseError := ' Point Y' ;

    If ( Abs ( YMes ) > 1 )
      Then  Y := YMes /  10 ;
    X := XMes ;
    DetS ;

    Y := YMes *  10 ;
    If ( Abs ( Y ) <= CoordMesMax )  Then
      Begin
        X := XMes ;
        DetS ;
      End ;

    Y := YMes * 100 ;
    If ( Abs ( Y ) <= CoordMesMax )  Then
      Begin
        X := XMes ;
        DetS ;
      End ;


  End ;  { PRO DetStar }



End.