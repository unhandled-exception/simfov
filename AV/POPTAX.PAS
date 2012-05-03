
{$O+,F+}

 Unit POptAX ;

   InterFace



	  Procedure OptAX  ;


   Implementation

   Uses   Dos, PVAR, PVarMenu,  V_CATAL, POptImp, PSatElCh, Check,
          PXYSat, PSGP4, PXYFLHJ, PSTimeGR, PPRENXYZ, PPRENEW, PNutnew,
          {PXYOpt,} {PCdcFld,POptCdc,}
          POptCcd, POptPars, PElStRct,
          PPlPro, PJD8, PGalEkv, PAtan2 ;


	  Procedure OptAX ;
        { *************** }

  Label ExitProc ;

  Var

    CalcSatGP,
    CorrCenterPlanet            : Boolean ;

    NSat                        : LongInt ;

    KCalCons                    : Integer ;

    T,
    R0,
    R_Planet_Opt,
    RoS_Planet_Opt,
    SAV, CAV, SHV, CHV,
    Av, Hv,
    Tv, STv, CTv,
    SPOZVOPT, CPOZVOPT,
    XOPT, YOPT,
    TOPT, CTOPT, STOPT,
    ROV, ROS,
    XXV, YYV, ZZV,
    RAV, DECLV,
    SRAV, CRAV, SDECLV, CDECLV,
    XXS, YYS, ZZS,
    XSAT, YSAT, ZSAT, RSAT,
    VXSAT, VYSAT, VZSAT,
    RAS, DECLS,
    SRAS, CRAS, SDECLS, CDECLS,
    SLongS, CLongS,
    RaGalPol, DeclGalPol,
    SRaGalPol, SDeclGalPol,
    CRaGalPol, CDeclGalPol,
    SRaOptGal, CRaOptGal,
    SDeclOptGal, CDeclOptGal,
    PhaseEarth, PhaseMoon,
    X, Y, Z,
    BETCalCons, VCalCons,
    SQRCalCons, BETSKCalCons,
    RaOptOl, DeclOptOl          : Double ;

    Begin

        NRecObjectOutFile := 0 ;

        If ( Not RealTimeStep )
          Then
            Begin
              If ( Abs ( StepTime ) < 6307200000.0 )
                Then JDate := JDate + StepTime
                Else JDate := JDate + StepTime / GScale ;
            End
          Else
            Begin  { …†ˆŒ …€‹œHƒ ‚…Œ…Hˆ }
                   { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

              GetDate ( TimerYear, TimerMonth, TimerDay, TimerDayOfWeek );

              IY := TimerYear  ;
              IM := TimerMonth ;
              ID := TimerDay   ;
              JD8 ( IY, IM, ID, JDTimer2 ) ;

               Repeat
                 GetTime ( TimerHOUR, TimerMin, TimerSEC, TimerSEC100 ) ;
               Until (    ( TimerSEC100 > 95 )
                       Or ( TimerSEC100 <  5 ) )  ;

               If ( TimerSec100 >= 95 )
                 Then TimerSec100 := 2
                 Else TimerSec100 := 1 ;

               JDTimer2 := JDTimer2 + (   ( TimerHour ) * C36000
                                        +   TimerMin * C600    ) / 86400 ;
               JDTimer2 := JDTimer2 + (     TimerSEC + TimerSEC100 ) / 86400 ;

               JDTimer2 := JDTimer2 - ( DtGrTopo / 24.0 ) ;

               If ( Not RealTimeDate )
                 Then
                   Begin

                     If ( RealTimeStep )
                       Then
                         Begin
                           If Start
                             Then JDate :=   JDateParam
                             Else JDate :=   JDateParam
                                           + ( JdTimer2 - JdTimer2Param ) ;
                         End
                       Else
                         Begin
                           If ( Not Start ) Then
                             JDate := JDate + StepTime ;
                         End ;
                   End
                 Else
                   Begin
                     JDate := JDTimer2 ;
                   End ;

            End ;


        NPlOpt    := 0     ;
        CalcSatGP := True  ;
        JDateFld  := JDate ;

        If ( Param.EpOut = 2 )  Then
          JdOut := JDate ;

	T := ( JDateFld - 2451545.0 ) / 36525.0;

	Eps:= ( 84381.448 - 46.8150   * T
                          -  0.00059  * T*T
                          +  0.001813 * T*T*T  ) / SekRad ;

	SEps := Sin ( Eps );
	CEps := Cos ( Eps );


        OptRD := False ;
        Refr  := False ;


        If ( B_From_Star )
        Then
          Begin { ‘® ‡¢¥§¤ë }
                { ÄÄÄÄÄÄÄÄÄ }

               B_Surf := False ;
               B_Geoc := False ;

               NPlOpt := 3 ;


               If (     ( NPlOpt >=  1 )
                    And ( NPlOpt <= 11 )  )
                 Then R_Planet_Opt := R_Planets [ NPlOpt ]
                 Else R_Planet_Opt := 0.0 ;


               RaOpt   := ( PaRam.RaOptH Mod 100  +
                            PaRam.RaOptM   / C600 +
                            PaRam.RaOptS   / C36000 ) * Gr ;

               If ( Not B_Gal )  Then
                 RaOpt := RaOpt * 15.0 ;

               DeclOpt := ( PaRam.DeclOptG +
                            PaRam.DeclOptM / C600 +
                            PaRam.DeclOptS / C36000 ) * Gr ;

               If ( PaRam.DeclOptSig = '-' )  Then
                 DeclOpt := - DeclOpt ;


               If (  Abs ( JdEp )  >  0.1 )   Then
                 Begin
                   PreNew ( JdEp, JDate, RaOpt, DeclOpt);
                 End ;

               Z   := Sin  ( DeclOpt ) ;
               Y   := Sqrt ( C10 - Sqr ( Z ) ) ;
               X   := Cos ( RaOpt ) * Y ;
               Y   := Sin ( RaOpt ) * Y ;

               Nutnew  ( JDate, 1, X, Y, Z ) ;

               RaOpt   := ATan2 ( Y , X ) ;
               DeclOpt := Atan2 ( Z , Sqrt ( Sqr ( X ) + Sqr ( Y ) )  ) ;
               If ( DeclOpt > Pi )  Then
                 DeclOpt := DeclOpt - Pi2 ;



               RaOpt   := RaOpt + Pi ;
               If ( RaOpt > Pi2 )  Then
                 RaOpt := RaOpt - Pi2 ;

               DeclOpt := - DeclOpt ;


               RoS_Planet_Opt := C1000 * AE  ;

               VXS := RoS_Planet_Opt * Cos ( RaOpt ) * Cos ( DeclOpt ) ;
               VYS := RoS_Planet_Opt * Sin ( RaOpt ) * Cos ( DeclOpt ) ;
               VZS := RoS_Planet_Opt *                 Sin ( DeclOpt ) ;

               Xs := - VXs ;
               Ys := - VYs ;
               Zs := - VZs ;

          End   { ‘® ‡¢¥§¤ë }
        Else
        Begin  { Not B_From_Star }
        If (     ( Not B_Surf                   )
             And (    ( B_ObserverNumSat      )
                   Or ( Param.Earth_Space = 2 ) ) ) Then
          Begin  { SatELLIT }
                 { ÜÜÜÜÜÜÜÜ }


             If ( B_Ef_Sat_Cheb ) Then
               Begin  { ‘ç¥â í«¥¬¥­â®¢ á¯ãâ­¨ª  ¯® ¯®«¨­®¬ ¬ }
                      { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                 SatElCheb ( JDate, A0, EKSC, ISat, OMG, OML, M0 ) ;

                 Mot   := Sqrt ( Fm [ NPl0 ] / ( A0*A0*A0) ) ;
                 Mot1  := 0.0 ;
                 Mot2  := 0.0 ;
                 BStar := 0.0 ;

                 If ( Abs ( ISat ) < 1.0e-5 )  Then
                   ISat := 1.0e-5 ;

                 If ( A0 > 0 )  Then
                 XYSat ( JDate,  JDate,   NPl0 ,
                                          EKSC ,  ISat ,
                                          OMG  ,  OML  ,  M0   ,
                                          Mot  ,  Mot1 ,  Mot2 , BStar,
                                          XS   ,  YS   ,  ZS   ,
                                          VXS  ,  VYS  ,  VZS    ) ;

               End ;  { ‘ç¥â í«¥¬¥­â®¢ á¯ãâ­¨ª  ¯® ¯®«¨­®¬ ¬ }
                      { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }



             If (  ( Not B_Ef_Sat_Cheb ) Or ( A0 < 0 ) )  Then
               Begin  { ‘ç¥â í«¥¬¥­â®¢ á¯ãâ­¨ª  ¯® Š¥¯«. ®p¡¨â¥ }
                      { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                 If ( Not B_ObserverNumSat )  Then
                   Begin
                     NPl0     := Param.NPl0 ;
                     R_Planet := R_Planets [ NPl0 ] ;  { €„ˆ“‘ –…’€‹œ‰ ‹€…’› ‚ KM }
                   End ;

                 If ( Param.ElemFile Mod 4 = 3 )
                   Then
                     Begin { Satellits Orbite RectAngular }
                       ElSatRectAng ;
                       CalcSatGP := False ;
                     End
                   Else
                     Begin

                       If ( B_ObserverNumSat )
                         Then
                           Begin
                             JdEpSat := JdEpSatObs ;
                             ISAT    := ISatObs    ;
                             OMG     := OmGObs     ;
                             OML     := OmLObs     ;
                             Eksc    := EkscObs    ;
                             M0      := M0Obs      ;
                             Mot     := MotObs     ;
                             Mot1    := Mot1Obs    ;
                             Mot2    := Mot2Obs    ;
                             BStar   := BStarObs   ;
                           End
                         Else
                           Begin

                             CalcSatGP := False ;

                             ISAT   := Param.ISAT   * GR ;
                             OMG    := Param.OMG    * GR ;
                             OML    := Param.OML    * GR ;
                             ARGLAT := Param.ARGLAT * GR ;

                             HAp    := Param.HAp  ;
                             HPer   := Param.HPer ;

                             A0     := ( HAp + HPer ) /                C20 + R_PLANET   ;
                             EKSC   := ( HAp - HPer ) / ( HAp + HPer + C20 * R_PLANET ) ;

                             M0 := 0 ;

                             SQRCalCons   := Sqrt   ( C10 - Sqr ( EKSC ) ) ;
                             BETCalCons   := EKSC / ( C10 + SQRCalCons   ) ;
                             BETSKCalCons := C10                           ;
                             VCalCons     := ARGLAT - OML                  ;
                             M0           := VCalCons                      ;

                             For KCalCons := 1 To 24 Do
                               Begin

                                 BETSKCalCons := BETSKCalCons * ( - BETCalCons ) ;

                                 M0 := M0 + C20 * ( SQRCalCons + C10 / KCalCons )
                                                *   BETSKCalCons
                                                *   Sin ( KCalCons * VCalCons ) ;
                               End ;


                             A0 := Abs ( A0 ) ;

                             Mot   := Sqrt ( Fm [ NPl0 ] / ( A0*A0*A0) ) ;
                             Mot1  := 0.0 ;
                             Mot2  := 0.0 ;
                             BStar := 0.0 ;

                             { ¯®å  í«¥¬¥­â®¢ }
                             { ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ }


                             JD8 ( Param.InputYear, Param.InputMon, Param.InputDay, JdEp ) ;
                             {ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}

                             T := ( Param.InputH + Param.InputMin / C600 + Param.InputSek / C36000 )
                                                                  /   24.0  ;
                             JdEpSat := JdEp + T ;

                           End ;

                       If ( Abs ( ISat ) < 1.0e-6 )  Then
                         ISat := 1.0e-6 ;

                       If ( CalcSatGP )
                         Then
                           Begin

                             XYSatGP ( JDate, JdEpSat ,  3 ,
                                       EKSC ,  ISat ,
                                       OMG  ,  OML  ,  M0   ,
                                       Mot  ,  Mot1 ,  Mot2 , BStar ,
                                       XS   ,  YS   ,  ZS   ,
                                       VXS  ,  VYS  ,  VZS    ) ;

                             RSat := Sqrt (   Sqr ( Xs )
                                            + Sqr ( Ys )
                                            + Sqr ( Zs ) ) ;

                             If ( RSat <= R_Planets [ Param.NPl0 ] )  Then
                               Begin { Error Sat Elem }
                                 ErrElSat := True ;
                                 GoTo  ExitProc ;
                               End ;

                           End
                         Else
                           Begin
                             XYSat ( JDate, JdEpSat ,  NPl0 ,
                                     EKSC ,  ISat ,
                                     OMG  ,  OML  ,  M0   ,
                                     Mot  ,  Mot1 ,  Mot2 , BStar ,
                                     XS   ,  YS   ,  ZS   ,
                                     VXS  ,  VYS  ,  VZS    ) ;
                             PRENXYZ ( JdEpSat, JDate,  XS,  YS,  ZS ) ;
                             PRENXYZ ( JdEpSat, JDate, VXS, VYS, VZS ) ;
                           End ;

                     End ; { No Rectang }

               End  ; { ‘ç¥â í«¥¬¥­â®¢ á¯ãâ­¨ª  ¯® Š¥¯«. ®p¡¨â¥ }
                      { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

          End    { SatELLIT }
                 { ======== }
         Else

          Begin  {  ‚…•‘’œ }
                 {  ÜÜÜÜÜÜÜÜÜÜÜ }


             If (      ( NPl0 = 3   )
                   And ( Not B_GeoC ) )
               Then
                 Begin
                  {
                  If ( B_Det_Cdc )  Then
                    Begin
                      JdEp     := 2451545.0 ;
                      JDateFld := 2451545.0 ;
                      JDate    := 2451545.0 ;
                    End ;
                   }

                   XYFLHJ  ( FiSAstron, LongSAstron, Alt, JDate,
                             XS, YS, ZS,
                             VXS , VYS ,  VZS ,
                             R_Planet, FiSGeoc, STime ) ;

                   Refr := True ;

                   {
                   If ( BOlValMenu )  Then
                     STime := STime + Frac ( STime ) * STime ;
                   }
                 End
               Else
                 Begin  { „pã£ ï ¯« ­¥â  ¨«¨ ¯« ­¥â®æ¥­âp }
                        { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                   Xs := 1.0e-10 ;
                   Ys := 1.0e-10 ;
                   Zs := 1.0e-10 ;

                   FiSGeoc :=  0.0 ;
                   STime   :=  0.0 ;

                   B_Geoc  := True ;

                 End ;  { „pã£ ï ¯« ­¥â  }
                        { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }
          End ;  {  ‚…•‘’œ  ‡…Œ‹ˆ  }
                 {  ==================  }


        If  ( PaRam.OptAxOrient <> 3  )  Then
          Begin  { ’ˆ—…‘Šˆ‰ –…’ H… ’‘ˆ’…‹œ  V  }
                 { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

           If  ( PaRam.OptAxOrient = 4 )  Then
            Begin  { ’ˆ—…‘Šˆ‰ –…’  ‹€…’… ˆ‹ˆ ‘“’HˆŠ“ }
                   { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

             If ( PaRam.NObj = 2 )  Then
              Begin  { ’ˆ—…‘Šˆ‰ –…’  ‘“’HˆŠ“ }
                     { ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ }

                NSat := PaRam.NSat ;

                If ( NSat = ObserverNumSat )  Then
                  Fatal (
                    'Number Satellit Telescops = Number Satellit Ax Optic');

                If ( NSat > 0 )
                  Then
                   Begin

                    NPlSat := 3 ;

                    If ( NPl0 = NPlSat )
                      Then
                          CorrCenterPlanet := False
                      Else
                        Begin
                          PlPro ( False,
                                  JDate, JDate, NPl0, XS/AE, YS/AE, ZS/AE,
                                          Abs ( NPlSat ),
                                                RezPl, RectCoordPl,
                                                PhaseMoon, PhaseEarth ) ;
                          CorrCenterPlanet := True ;
                        End ;

                    CheckFile ( SatElementFileName         ) ;
                    Reset     ( SatElemFile                ) ;
                    Seek      ( SatElemFile, NSat - 1      ) ;
                    Read      ( SatElemFile, SatElementRec ) ;
                    Close     ( SatElemFile                ) ;


                    NPlSat  := 3 ;

                    JdEpSat := SatElementRec.T0   ;
                    ISAT    := SatElementRec.ISat ;
                    OMG     := SatElementRec.OmG  ;
                    OML     := SatElementRec.OmL  ;
                    Eksc    := SatElementRec.Eksc ;
                    M0      := SatElementRec.M0   ;
                    Mot     := SatElementRec.Mot  ;
                    Mot1    := SatElementRec.Mot1 ;
                    BStar   := SatElementRec.BStar;

                    If ( Abs ( ISat ) < 1.0e-6 )  Then
                      ISat := 1.0e-6 ;

                    XYSatGP (  JDate,
                               JdEpSat     ,
                               NPlSat      ,
                               EKSC        ,
                               ISat        ,
                               OMG         ,
                               OML         ,
                               M0          ,
                               Mot         ,
                               Mot1        ,
                               Mot2        ,
                               BStar       ,
                               XSat,  YSat , ZSat,
                               VXSat, VYSat, VZSat  ) ;

                    {
                    PRENXYZ ( JdEpSat , JDate, XSat, YSat, ZSat ) ;
                    }

                    If ( CorrCenterPlanet )  Then
                      Begin
                        XSat := RectCoordPl [ NPlSat , 1 ] + XSat ;
                        YSat := RectCoordPl [ NPlSat , 2 ] + YSat ;
                        ZSat := RectCoordPl [ NPlSat , 3 ] + ZSat ;
                      End ;


                   End
                  Else
                   Begin
                     XSat :=  1000000.0 ;
                     YSat :=        0.0 ;
                     ZSat :=        0.0 ;
                   End ;



                {  ’…‹…‘Š–…H’ˆ—…‘Šˆ…  Š„ˆH€’›  }
                {  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  }

                VXS := XSat - XS ;
                VYS := YSat - YS ;
                VZS := ZSat - ZS ;


              End    { ’ˆ—…‘Šˆ‰ –…’  ‘“’HˆŠ“ }
                     { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }
             Else

              Begin  { ’ˆ—…‘Šˆ‰ –…’  ‹€…’…  NPlOpt }
                     { ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ }


               NPlOpt := PaRam.NPlan ;


               If ( ( NPlOpt >= 1 )  And  ( NPlOpt <= 15 )  )
                 Then R_Planet_Opt := R_Planets [ NPlOpt ]
                 Else R_Planet_Opt := 0.0 ;


               PlPro ( False,
                       JDate, JDate, NPl0, XS/AE, YS/AE, ZS/AE,
                                     NPlOpt, RezPl, RectCoordPl,
                                     PhaseMoon, PhaseEarth      ) ;


               RoS_Planet_Opt := RezPl [ NPlOpt , 7 ] * AE ;
               RaOpt          := RezPl [ NPlOpt , 1 ]      ;
               DeclOpt        := RezPl [ NPlOpt , 2 ]      ;

               VXS := RoS_Planet_Opt * Cos ( RaOpt ) * Cos ( DeclOpt ) ;
               VYS := RoS_Planet_Opt * Sin ( RaOpt ) * Cos ( DeclOpt ) ;
               VZS := RoS_Planet_Opt *                 Sin ( DeclOpt ) ;

             End   { ’ˆ—…‘Šˆ‰ –…’  ‹€…’…  NPlOpt }

            End   { ’ˆ—…‘Šˆ‰ –…’  ‹€…’… ˆ‹ˆ ‘“’HˆŠ“ }

           Else

            Begin  { ’ˆ—…‘Šˆ‰ –…’   ( Ra , Decl ) ˆ‹ˆ ( A , H ) }
                   { ================================================ }

             If ( PaRam.OptAxOrient = 2 )  Then
              Begin { ’ˆ—…‘Šˆ‰ –…’  ( A , H ) }
                    { ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ }

                VXS := XS ;
                VYS := YS ;
                VZS := ZS ;

              End   { ’ˆ—…‘Šˆ‰ –…’  ( A , H ) }
                    { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }
             Else

              Begin  { ’ˆ—…‘Šˆ‰ –…’   ( Ra , Decl ) }
                     { ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ }

                RoS_Planet_Opt := C10   ;
                OptRD          := True  ;
                JDateFld       := JDOut ;

                If ( Abs ( StepTime )  >  1000 )
                   Then  NPolFix := True ;

                If ( B_Gal )
                  Then  RaOpt := PaRam.RaOptH
                  Else  RaOpt := PaRam.RaOptH Mod 100 ;

                RaOpt := ( RaOpt + PaRam.RaOptM / C600
                                 + PaRam.RaOptS / C36000 ) * Gr ;

                If ( Not B_Gal )
                  Then  RaOpt := RaOpt * 15.0 ;

                DeclOpt := ( PaRam.DeclOptG +
                             PaRam.DeclOptM / C600 +
                             PaRam.DeclOptS / C36000 ) * Gr ;

                If ( PaRam.DeclOptSig = '-' )  Then  DeclOpt := - DeclOpt ;


                If ( B_Import_Fld )  Then
                  Begin { ¯â¨ç¥áª¨© –¥­âp ¯® ®¡ê¥ªâ ¬ ¨§ ä ©«  }
                        { ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ }

                    If ( B_Inport_Ccd )
                      Then
                        Begin

                          If ( B_Parsek )
                            Then
                              Begin
                                OptPars ( 2, ErrProcCcd ) ;
                              End
                            Else
                              Begin
                                OptCcd ( 2, ErrProcCcd ) ;
                              End ;


                          If ( ErrProcCcd )  Then
                            GoTo  ExitProc ;

                        End
                      Else
                        Begin
                          OptImp ;
                         {ÄÄÄÄÄÄ}
                        End ;

                  End ; { ¯â¨ç¥áª¨© –¥­âp ¯® ®¡ê¥ªâ ¬ ¨§ ä ©«  }
                        { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                (*
                If ( B_Det_Cdc )  Then
                  Begin  { ¯â¨ç¥áª¨© æ¥­âp ¯® ¯« áâ¨­ª¥ CDC }
                         { ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ }

                    OptCdc ;

                    JdEp     := 2451545.0 ;
                    JDateFld := 2451545.0 ;
                    JDate    := 2451545.0 ;

                    If ( EndProc )  Then  GoTo  ExitProc ;

                  End ;  { ¯â¨ç¥áª¨© æ¥­âp ¯® ¯« áâ¨­ª¥ CDC }
                         { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }
                *)

                RaGalPol   := RaGalPol50   ;
                DeclGalPol := DeclGalPol50 ;

                PreNew ( Jd50, JDateFld, RaGalPol, DeclGalPol ) ;

                SRaGalPol   := Sin ( RaGalPol   ) ;
                CRaGalPol   := Cos ( RaGalPol   ) ;
                SDeclGalPol := Sin ( DeclGalPol ) ;
                CDeclGalPol := Cos ( DeclGalPol ) ;

                RaOptGal    := RaOpt   ;
                DeclOptGal  := DeclOpt ;

                SRaOptGal   := Sin ( RaOptGal   ) ;
                CRaOptGal   := Cos ( RaOptGal   ) ;
                SDeclOptGal := Sin ( DeclOptGal ) ;
                CDeclOptGal := Cos ( DeclOptGal ) ;


                If ( B_Gal )
                  Then
                    Begin
                       { Gal -> Ekv ­  JDateFld }
                       { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }


                      GalEkv ( RaOpt, DeclOpt,
                               RaOpt, DeclOpt,
                               SRaOpt, CRaOpt, SDeclOpt, CDeclOpt ) ;

                      {
                      If ( Abs ( CRaOpt ) > 1.0e-11 )
                        Then
                          Begin
                            RaOpt := ArcTan ( SRaOpt / CRaOpt ) ;
                              If ( CRaOpt < 0.0 ) Then  RaOpt := RaOpt + Pi  ;
                              If ( RaOpt  < 0.0 ) Then  RaOpt := RaOpt + Pi2 ;
                          End
                        Else
                          Begin
                            If ( SRaOpt > 0 )
                               Then RaOpt :=       Pi / C20
                               Else RaOpt := Pi2 - Pi / C20 ;
                          End;

                      If ( CDeclOpt > 1.0e-11 )
                        Then
                          DeclOpt := ArcTan ( SDeclOpt / CDeclOpt )
                        Else
                          Begin
                            If ( SDeclOpt > 0 )
                               Then DeclOpt :=   Pi / C20
                               Else DeclOpt := - Pi / C20 ;
                          End ;

                      }

                      RaOpt   := ATan2 ( SRaOpt  , CRaOpt   ) ;
                      DeclOpt := ATan2 ( SDeclOpt, CDeclOpt )

                    End
                  Else
                    Begin
                      If (  Abs ( JdEp )  >  0.1 )   Then
                        Begin

                          PreNew ( JdEp, JDateFld, RaOpt, DeclOpt);

                          SRaOpt   := Sin ( RaOpt ) ;
                          CRaOpt   := Cos ( RaOpt ) ;
                          SDeclOpt := Sin ( DeclOpt ) ;
                          CDeclOpt := Cos ( DeclOpt ) ;

                        End ;
                     End ;

                VXS := RoS_Planet_Opt * CRaOpt * CDeclOpt ;
                VYS := RoS_Planet_Opt * SRaOpt * CDeclOpt ;
                VZS := RoS_Planet_Opt *          SDeclOpt ;


              End ;  { ’ˆ—…‘Šˆ‰ –…’   ( Ra , Decl ) }
                     { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

            End ;  { ’ˆ—…‘Šˆ‰ –…’   ( Ra , Decl )  }
                   { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

          End ;  { ’ˆ—…‘Šˆ‰ –…’ H… ’‘ˆ’…‹œ  V  }
                 { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }


        End ;  { Not B_From_Star }




        XSAE := XS / AE ;
        YSAE := YS / AE ;
        ZSAE := ZS / AE ;



        { Š‚€’ˆ€‹œ›… Š„ˆ€’› ‚…Š’€ ‘Š‘’ˆ }
        { ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }

        ROV := Sqrt (   Sqr ( VXS )
                      + Sqr ( VYS )
                      + Sqr ( VZS ) )  ;

        XXV := VXS / ROV ;
        YYV := VYS / ROV ;
        ZZV := VZS / ROV ;


        Rav   := ATan2 ( YYV , XXV ) ;
        Declv := Atan2 ( ZZV , Sqrt ( Sqr ( XXV ) + Sqr ( YYV ) )  ) ;
        If ( DeclV > Pi )  Then
           DeclV := DeclV - Pi2 ;


        SRAv   := Sin ( RAv   ) ;
        CRAv   := Cos ( RAv   ) ;
        SDeclV := Sin ( DeclV ) ;
        CDeclV := Cos ( DeclV ) ;



        { Š‚€’ˆ€‹œ›… Š„ˆ€’› „‘“’ˆŠ‚‰ ’—Šˆ }
        { ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }


        RoS     := Sqrt (   Sqr ( XS )
                          + Sqr ( YS )
                          + Sqr ( ZS ) ) ;
        RoSGeoc := RoS ;


        If ( NPlOpt = NPl0 )  Then
           RoS_Planet_Opt := RoS ;

        If ( RoS > 1.0e-20 )  Then
          Begin
            XXS := XS / RoS ;
            YYS := YS / RoS ;
            ZZS := ZS / RoS ;
          End ;


        If ( NPl0 <> 3 )  Then
          Begin  { H ¡«î¤ â¥«ì ­¥ ­  ‡¥¬«¥ }
                 { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

             PlPro ( False,
                     JDate, JDate,
                            NPl0, XSAE, YSAE, ZSAE,
                            3, RezPl, RectCoordPl,
                            PhaseMoon, PhaseEarth  ) ;

             {
             RoSGeoc := Sqrt ( Sqr ( XS ) + Sqr ( YS ) + Sqr ( ZS ) ) ;

             XXS := XS / RoSGeoc ;
             YYS := YS / RoSGeoc ;
             ZZS := ZS / RoSGeoc ;
             }
             {
             XXS := - RectCoordPl [ 3 , 1 ] + XS ;
             YYS := - RectCoordPl [ 3 , 2 ] + YS ;
             ZZS := - RectCoordPl [ 3 , 3 ] + ZS ;
             }
             XXS := - RectCoordPl [ 3 , 1 ] ;
             YYS := - RectCoordPl [ 3 , 2 ] ;
             ZZS := - RectCoordPl [ 3 , 3 ] ;

             RoSGeoc := Sqrt (   Sqr ( XXS )
                               + Sqr ( YYS )
                               + Sqr ( ZZS ) ) ;

             XXS := XXS / RoSGeoc ;
             YYS := YYS / RoSGeoc ;
             ZZS := ZZS / RoSGeoc ;


          End ;  { H ¡«î¤ â¥«ì ­¥ ­  ‡¥¬«¥ }
                 { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }


        RaS   := ATan2 ( YYS , XXS ) ;
        DeclS := Atan2 ( ZZS , Sqrt ( Sqr ( XXS ) + Sqr ( YYS ) )  ) ;
        If ( DeclS > Pi )  Then
           DeclS := DeclS - Pi2 ;


        STime := RaS ;
        {
        If ( BOlValMenu )  Then
          STime := STime + Frac ( STime ) * STime ;
        }
        SSTime   := Sin ( STime ) ;
        CSTime   := Cos ( STime ) ;



        STimeGR ( JDate , SGrinv ) ;
       {ßßßßßßßßßßßßßßßßßßßßßßßßß}

        LongS := STime - SGrinv ;
        If ( LongS < 0 )  Then
             LongS := LongS + Pi2 ;

        SLongS := Sin ( LongS ) ;
        CLongS := Cos ( LongS ) ;


        FiSGeoc  := DeclS ;

        SFiSGeoc := Sin ( FiSGeoc ) ;
        CFiSGeoc := Cos ( FiSGeoc ) ;



        If ( B_Surf )  Then
          Begin
            SFiS := Sin ( FiSAstron ) ;
            CFiS := Cos ( FiSAstron ) ;
          End
         Else
          Begin
            SFiS := SFiSGeoc ;
            CFiS := CFiSGeoc ;
          End ;

        { €‡ˆŒ“’ ‚…Š’€ ‘Š‘’ˆ }
        { ßßßßßßßßßßßßßßßßßßßßßßß }

        Tv := STime - RAv ;

        STv := Sin ( Tv ) ;
        CTv := Cos ( Tv ) ;

        SHv := SFiS * SDeclV + CFiS * CDeclV * CTv ;

        If ( ( 1 - Abs ( SHv ) ) > 1E-15 )  Then
          Begin
            CHv :=   Sqrt ( C10 - Sqr ( SHv ) ) ;
            SAv :=   CDeclV * STv / CHv ;
            CAv := - SDeclV * CFiS / CHv + CDeclV * SFiS * CTv / CHv  ;
          End
         Else
          Begin
            If ( SHv > 0 )
              Then  Hv :=   PiD2
              Else  Hv := - PiD2 ;
            SHv := Sin ( Hv ) ;
            CHv := Cos ( Hv ) ;
            SAv := 0.0 ;
            CAv := C10 ;
          End ;


        Av := ATan2 ( SAv , CAv ) ;
        Hv := ATan2 ( SHv , CHv ) ;
        If ( Hv > Pi )  Then
           Hv := Hv - Pi2 ;



        { €‡ˆŒ“’ ˆ ‚›‘’€ ’ˆ—…‘Š‰ ‘ˆ }
        { ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }


        Case  PaRam.OptAxOrient Of

          1 : Begin  { ª¢ â®p¨ «ì­ë¥ ª®®p¤. ¯â. á¨ }
                     { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                HOpt := Hv ;
                AOpt := Av ;

              End ;

          2 : Begin  { ƒ®p¨§®­â «ì­ë¥ ª®®p¤. ¯â. á¨ }
                     { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                AOpt := AOpt0 ;

                If ( Param.Earth_Space = 2 )  Then

                  Begin  { ˆ§  Š®á¬®á  }
                         { ÄÄÄÄÄÄÄÄÄÄÄ }

                   If ( Param.HOptType = 2 )   Then
                     Begin  { Š á â ª £®p¨§ }
                            { ÄÄÄÄÄÄÄÄÄÄÄÄÄ }
                       SRo  := R_Planet_Opt / ( RoS + R_Planet_Opt );
                       R0   := PiD2 - ArcTan  ( SRo / Sqrt ( C10 - Sqr ( SRo ) ) );
                       HOpt := HOpt0 - R0 ;
                     End
                   Else
                     Begin
                       HOpt := HOpt0 ;
                     End ;

                  End    { ˆ§  Š®á¬®á  }
                         { ÄÄÄÄÄÄÄÄÄÄÄ }

                 Else

                  Begin  { ‘ ®¢¥på­®áâ¨ }
                         { ÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                    HOpt := HOpt0 ;
                    AOpt := AOpt0 ;

                  End ;  { ‘ ®¢¥på­®áâ¨ }
                         { ÄÄÄÄÄÄÄÄÄÄÄÄÄ }

              End ;

          3 : Begin  { p¡¨â «ì­ë¥ ª®®p¤. ¯â. á¨ }
                     { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                HOpt := Hv + DHopt0 ;
                AOpt := Av + DAOpt0 ;

              End ;


          4 : Begin  { Š®p¤. ¯â. á¨ ¯®  ¡ê¥ªâã  }
                     { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  }

                HOpt := Hv ;
                AOpt := Av ;

              End ;


        End ; { Case }


        SHMin := Sin ( HOpt - DHMax ) ;
        SHMax := Sin ( HOpt + DHMax ) ;


        If ( ( HOpt - DHMax ) <= -PiD2 ) Then
          Begin
            SHMin := - C10 ;
            SHMax := Sin ( HOpt + DHMax ) ;
          End ;

        If ( ( HOpt + DHMax ) >=  PiD2 ) Then
          Begin
            SHMax :=  C10 ;
            SHMin := Sin ( HOpt - DHMax ) ;
          End ;


        SHOpt := Sin ( HOpt ) ;
        CHOpt := Cos ( HOpt ) ;

        SAOpt := Sin ( AOpt ) ;
        CAOpt := Cos ( AOpt ) ;

        {
        If ( BOlValMenu )  Then
          Begin
            RaOptOl   := AOpt + Frac ( AOpt ) * 0.17897 ;
            DeclOptOl := HOpt + Frac ( HOpt ) * 0.13454 ;
            SAOpt     := Sin ( RaOptOl   ) ;
            CAOpt     := Cos ( RaOptOl   ) ;
            SHOpt     := Sin ( DeclOptOl ) ;
            CHOpt     := Cos ( DeclOptOl ) ;
          End ;
        }


        { Š‚€’ˆ€‹œ›… Š„ˆ€’› ’ˆ—…‘Š‰ ‘ˆ }
        { ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }


        If ( Not OptRD )  Then
          Begin
            SDeclOpt := SHOpt * SFiS - CHOpt * CFiS * CAOpt ;
            CDeclOpt := Sqrt ( C10 - Sqr ( SDeclOpt ) ) ;
          End ;


        If ( Abs ( CDeclOpt ) > 1.0E-13 )  Then
           Begin

             CTOpt := ( SHOpt * CFiS + CHOpt * SFiS * CAOpt ) / CDeclOpt ;
             STOpt := ( CHOpt * SAOpt ) / CDeclOpt ;

             TOpt  := ATan2 ( STOpt , CTOpt ) ;

             If ( Not OptRD )  Then
               Begin
                 DeclOpt := ATan2 ( SDeclOpt , CDeclOpt ) ;
                 If ( DeclOpt > Pi )  Then
                   DeclOpt := DeclOpt - Pi2 ;
               End ;

           End

         Else

           Begin

             STOpt := CHOpt * SAOpt ;
             CTOpt := SHOpt * CFiS + CHOpt * SFiS * CAOpt ;

             TOpt := 0.0 ;

             If ( SDeclOpt > 0.0 )  Then
                 Begin

                   If ( Not OptRD )  Then
                      DeclOpt := PiD2 ;

                   If ( Abs ( CTOpt ) > 1.0E-13 )  Then
                     Begin
                       TOpt  := ATan2 ( STOpt, CTOpt ) ;
                     End ;

                 End
               Else
                 Begin

                   If ( Not OptRD )  Then
                     DeclOpt := - PiD2 ;

                   If ( Abs ( CTOpt ) > 1.0E-13 )  Then
                     Begin

                       STOpt := - STOpt ;
                       CTOpt := - CTOpt ;

                       TOpt  := ATan2 ( STOpt, CTOpt ) ;

                     End ;

                 End ;

           End ;


        If ( Not OptRD )  Then
          Begin

            RaOpt := STime - TOpt ;

            If ( RaOpt < 0.0 )  Then
               RaOpt := RaOpt + Pi2 ;

            SRaOpt := Sin ( RaOpt ) ;
            CRaOpt := Cos ( RaOpt ) ;

          End ;

        {
        If ( BOlValMenu )  Then
          Begin
            RaOptOl   := RaOpt   + Frac ( RaOpt   ) * 0.0137 ;
            DeclOptOl := DeclOpt + Frac ( DeclOpt ) * 0.0137 ;
            SRaOpt    := Sin ( RaOptOl   ) ;
            CRaOpt    := Cos ( RaOptOl   ) ;
            SDeclOpt  := Sin ( DeclOptOl ) ;
            CDeclOpt  := Cos ( DeclOptOl ) ;
          End ;
        }


        { €€‚‹…ˆ… „‚ˆ†…ˆŸ –…’€ ‹Ÿ ‡…ˆŸ ‚ ”Š€‹œ‰ ‹‘Š‘’ˆ }
        { ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß }


        ROpt := 0.0 ;
        VOpt := 0.0 ;

          (*
          If ( PRDATE > 0 )  Then
            Begin

                XYOpt ;
              { ÄÄÄÄÄ }


              If ( ROpt > 1.0E-20 )  Then
                Begin

                  SPozVOpt := - YOpt / ROpt ;
                  CPozVOpt := - XOpt / ROpt ;

                  If ( Abs ( CPozVOpt ) > 1.0E-20 )  Then
                    Begin

                       VOpt  := ArcTan ( SPozVOpt / CPozVOpt ) ;

                         If ( CPozVOpt < 0.0 )  Then  VOpt := VOpt + Pi  ;
                         If ( VOpt     < 0.0 )  Then  VOpt := VOpt + Pi2 ;

                       VOpt  := VOpt - PiD2 ;
                       VOpt  := Pi2  - VOpt ;

                       If ( VOpt < 0.0 )  Then  VOpt := VOpt + Pi2 ;
                       If ( VOpt > Pi2 )  Then  VOpt := VOpt - Pi2 ;

                    End
                   Else
                       VOpt := 0.0 ;
                End
               Else
                  VOpt := 0.0 ;
            End ; { PRDATE > 0 }
            *)
          {
          PRDATE      :=      1   ;

          SRaOptOLD   :=   SRaOpt ;
          CRaOptOLD   :=   CRaOpt ;

          SDeclOptOLD := SDeclOpt ;
          CDeclOptOLD := CDeclOpt ;
          }
      ExitProc : ;

    End ;

 End.
