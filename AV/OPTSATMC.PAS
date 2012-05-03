
{$F+,O+}

 Unit  OptSatMc ;

 Interface


    Procedure    OptSatMultCat  ( NVarDir : String; ReadFile : Boolean ) ;
               { ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ }


  Implementation

  Uses

       Dos      ,

       PRdParOn ,  Check    ,  PSortImp ,

       ABOUT    ,  PRDPARAM ,  PCALCONS ,  V_CATAL  ,

       PMem     ,  PVAR     ,  POPTAX   ,  POutPV   ,

       PDAYJD   ,  PJD8     ,{  PSGP4    ,}

       PPLFLD   ,  PSATFLD  ,

       PGSCFLD  ,  PCcdFLD  ,  PVarMenu ,

       PPPMFLD  ,  PBSFLD   ,  PHDFLD   ,

       PGcvsFLD ,  PV200FLD ,

       PIMPFLD  ,  PDetImp  ,

       POSCREEN ,  CRT      ,  PIKO     ,

       GRAPH    ,  CURS     ,  SCREEN   ,  PSaoFld  ,

       SMENU    ,  INFO     ,  PProFld  ,  POthrFld ,

       PEndOpt  ,  MLib     ,

       POUTFLD  ,  PNLTTFld ,  Ak_Moz   ,  PCdcCFld ,

       PDmFld   ,  PNpmFld  ,  PHipFld  ,  PPlDraw  ,

       PA20Fld  ,  PTycFld                                        ;





   Procedure    OptSatMultCat  ( NVarDir : String; ReadFile : Boolean ) ;
               { ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ }


 Label NotCalcStar, ExitProc, DirCatError, EndCalcStars ;
{ÄÄÄÄÄ}

  Const

      NoCoord : Word   =    0    ;


  Var

      NewCalcStars : Boolean ;
      PSaveMem     : Pointer ;
      J            : Integer ;
      NStepSat     : LongInt ;
      NSat         : LongInt ;

  Begin        {  MAIN  PROGRAM   }
               {  ÜÜÜÜÜÜÜÜÜÜÜÜÜ   }

          {
          IndDeb := 0 ;
          Assign  ( Deb, 'Deb.Dat' ) ;
          Rewrite ( Deb            ) ;
          Writeln ( Deb, IndDeb    ) ;
          Inc     ( IndDeb         ) ;
          Close   ( Deb            ) ;
          }


     FileMode := 0 ;  { Read Only }
                      { ÄÄÄÄÄÄÄÄÄ }

     CatNotFound     := False ;
     EndProc         := False ;
     BPointerMark    := False ;


     RdParam ( NVarDir, ReadFile ) ;
   { ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ }


     CalCons ;
   { ÜÜÜÜÜÜÜ }


    If ( CatNotFound )  Then
      GoTo  DirCatError ;




    JDate      := JDate - StepTime ;
    NSTEPSAT   :=                0 ;



    { ãâ¨ « ­¥â }
    { ÜÜÜÜÜÜÜÜÜÜÜ }


    NSAT := PaRam.NSat ;
    (*
    If (     ( Param.NObj =  2 )   { ® ‘¯ãâ­¨ªã      }
         And (       NSat = -1 )   { ˆŠ              }
         And ( B_Surf          )   { H¥ á ®¢¥på­®áâ¨ }
                                 ) Then
    *)


    B_PlanDraw := False ;

    If (     ( B_ObserverNumSat           )
         And ( Round ( Param.ISat ) <= -1 )  )  Then
      Begin

        B_PlanDraw := True ;

        RaOpt   := ( PaRam.RaOptH   +
                     PaRam.RaOptM   / C600 ) * Gr ;

        RaOpt := RaOpt * 15.0 ;

        DeclOpt := ( PaRam.DeclOptG +
                     PaRam.DeclOptM / C600 ) * Gr ;

        If ( PaRam.DeclOptSig = '-' )  Then
          DeclOpt := - DeclOpt ;

        PlanDraw  ( RaOpt, DeclOpt, FldX / 2.0 );

        GoTo DirCatError

      End ;



      { ˆˆ–ˆ€‹ˆ‡€–ˆŸ ƒ€”ˆŠˆ }
      { ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ }

    Initgr ;
   {ÜÜÜÜÜÜ}


    { ˆ­¤¨ª â®p ªpã£®¢®£® ®¡§®p  }
    { ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ }


    NSAT := PaRam.NSat ;

    If (     ( Param.NObj = 2 )   { ® ‘¯ãâ­¨ªã   }
         And (       NSat = 0 )   { ˆŠ           }
         And (       NPl0 = 3 )   { ‘ ‡¥¬«¨       }
         And ( B_Surf         )   { ‘ ®¢¥på­®áâ¨ }
                                ) Then
         IKO ;
        {ÜÜÜ}

    If ( Stop )  Then
      GoTo  DirCatError ;



    If ( NGPages = 1 )
       Then   Start := False
       Else   Start := True  ;


    NumberOfStars := 0  ;

    For Page := 0 To NGPages-1 Do
      Begin

        SetActivePage ( Page ) ;

        If ( Page = 0 ) And ( NGPages <> 1 )
          Then
          Begin

            SayNames ;  { H  ¯¥p¢®© áâp ­¨æ¥ - § áâ ¢ª  }
            {ÜÜÜÜÜÜÜÜ}

          End

         Else

          Begin


            Initiw;
           {ÜÜÜÜÜÜ}

            Reporti;
           {ÜÜÜÜÜÜÜ}

          End;
      End;

    Page := ( Page + NGPages - 1 ) mod 2 ;

    InitPtr;
   {ÜÜÜÜÜÜÜ}



  { ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ }



 CBlock := 0 ;

 While BlockAllocFlag [ CBlock ] Do
  Begin
    FreeMem ( ObjectPtr [ CBlock ], SizeOf ( ObjectArrType ));
    BlockAllocFlag [ CBlock ] := False ;
    Inc ( CBlock ) ;
  End;


 CBlockPlanet := 0 ;

 While PlanetAllocFlag [ CBlockPlanet ] Do
  Begin
    FreeMem ( PlanetPtr [ CBlockPlanet ], SizeOf ( PlanetArrType ));
    PlanetAllocFlag [ CBlockPlanet ] := False ;
    Inc ( CBlockPlanet ) ;
  End;



    LastObject :=     - 1 ;
    GScale     :=     C10 ;
    NScaleArr  :=       0 ;
    NVScaleArr :=       0 ;
    CenterX    :=     0.0 ;
    CenterY    :=     0.0 ;
    VCenterX   :=     0.0 ;
    VCenterY   :=     0.0 ;
    Hist       :=       1 ;

    CalcFild       :=  True  ;
    EndProc        :=  False ;
    CalcVectDiagr  :=  False ;

    While (        ( NOT Stop                              )
              And  ( ABS (JDate-2415020) / 365.25 < 250000 )
              And  ( Not EndProc                           )  ) Do

      Begin  { PRDATE }


          Out_Mess_AV := False  ;
          Message ('Calc  FoV ...', true);

          {
          IndDeb := 10 ;
          Assign  ( Deb, 'Deb.Dat' ) ;
          Rewrite ( Deb            ) ;
          Writeln ( Deb, IndDeb    ) ;
          Inc     ( IndDeb         ) ;
          Close   ( Deb            ) ;
          }
          {
          Assign  ( Deb, 'Deb.Dat' ) ;
          Append  ( Deb            ) ;
          Writeln ( Deb, IndDeb    ) ;
          Inc     ( IndDeb         ) ;
          Close   ( Deb            ) ;
          }

          {
          If ( NPlanetsInFild > 0 )  Then
          }
           For NPl := 1  To  15  Do
            Begin

              CBlockPlanet :=  NPl Div PlanetBlockSize ;

              If (    ( PlanetAllocFlag [ CBlockPlanet ] )
                   Or ( AllocBlockPlanet                 )  )
                Then
                  Begin

                    PlanetRecord := PlanetPtr [ NPl Div PlanetBlockSize ]^
                                              [ NPl Mod PlanetBlockSize ] ;
                    PlanetRecord.Visible    := False       ;
                    PlanetRecord.NowVisible := False       ;
                    PlanetRecord.R          := C10000 * AE ;
                    PlanetPtr [ NPl Div PlanetBlockSize ]^
                              [ NPl Mod PlanetBlockSize ] := PlanetRecord ;
                  End
                Else
                  Begin

                    Fatal ( 'No Memory for Planets' ) ;
                    GoTo ExitProc ;

                  End ;

            End ;


          B_Menu         := False  ;
          B_X_Max        := True   ;
          OptIzo         := True   ;
          ReCalcPlanets  := False  ;
          FlagFieldZagol := False  ;
          FlagF9         := False  ;
          BReportOScreen := True   ;
          KeyExist       := False  ;

          NSTEPSAT := NSTEPSAT + 1 ;
          NPLSUM   :=  0           ;
          PozMon   :=  0.0         ;
          PozSun   :=  0.0         ;
          POM_FLD  :=  0           ;
          RoSun    := 90.0 * GR    ;
          RoMon    := 90.0 * GR    ;

          NPointSatMark        :=     0 ;
          NRecObjectOutFileOld := 65000 ;

          ErrElSat := False ;

          OptAx ;
        { ÜÜÜÜÜ }

          If ( ErrElSat )  Then
            Begin
              Fatal ( 'Error Opt Ax Satellit Elements ');
              GoTo  ExitProc ;
            End ;


          If (     ( EndProc      )
               And ( Not CalcFild )  )  Then
             GoTo  ExitProc ;


          If ( CalcFild )  Then
           Begin { CalcFild }
                 { ÄÄÄÄÄÄÄÄ }

            { ¯p¥¤¥«¥­¨¥ p §¬¥p  ¯®«ï §p¥­¨ï ¨ ¢ë¡®p ¨¬¯®pâ­ëå §¢¥§¤ }
            { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

              If ( B_Import_Fld )
                Then
                  Begin

                    NumberOfStars := 0 ;
                    CatMax        := 0 ;

                    MvMin    := MvMinParam  ;
                    MvMax    := MvMaxParam  ;


                    NPolFix := True ;
                    SPozNp := 0.0 ;
                    CPOzNp := C10 ;

                    For J := 0 To CatIzoMax Do
                      Begin
                        IndCat  [ J ].TypeCoord   :=  NoCoord ;
                        IndCat  [ J ].NBEG        :=  -1      ;
                        IndCat  [ J ].NEND        :=  -2      ;
                        IndCat  [ J ].RoDet       :=  0.0     ;
                        IndCat  [ J ].NDet        :=   0      ;
                        IndCat  [ J ].NStarInFild :=   0      ;
                        IndCat  [ J ].NoDetInFild :=   0      ;
                        CatSort [ J ]             :=  False   ;
                      End ;


                    If ( NStarGrMax = 1 )
                       Then B_X_Max  := False ;


                     If ( B_Inport_Ccd )
                       Then  { ImpCcd }
                         Begin
                           CcdFld ;
                         End
                       Else
                         Begin
                           ImpFld ;
                         End ;



                    If ( CatImp > CatMax )
                       Then  CatMax := CatImp ;

                    B_X_Max  := False ;

                  End
                Else
                  Begin

                       { ‹€…’› }
                       { ÄÄÄÄÄÄÄ }

                          PLFLD ;
                        { ÜÜÜÜÜ }

                          NPlanetsInFild := Max_Pl_PPlFld ;

                  End ;


             { ‘“’HˆŠˆ }
             { ÄÄÄÄÄÄÄÄ }

        NumberOfSatellits := 0 ;

        If ( B_IMPORT_Sat )  Then
          SatFld ;
        { ÜÜÜÜÜÜ }



    NewCalcStars      := False ;
    StepSectorMarkIzo := False ;
    (*
    If (       ( OPTRD And (Not B_Det_Cdc)  ) { –¥­âp ¯® RA, DECL       }
          And  ( Not B_Import_Fld           ) { ®«¥ ­¥ ¯® §¢. ¨§ ä ©«  }
          And  ( NSTEPSAT       >     1     ) { H¥ ¯¥p¢ë© è £           }
          And  ( ABS ( STEPTIME ) < 100 )   ) { ABS ( ˜ £ ) < 100 day   }
    *)
    If (       ( OPTRD                      ) { –¥­âp ¯® RA, DECL       }
          And  ( Not B_Import_Fld           ) { ®«¥ ­¥ ¯® §¢. ¨§ ä ©«  }
          And  ( NSTEPSAT       >     1     ) { H¥ ¯¥p¢ë© è £           }
          And  ( ABS ( STEPTIME ) < 100 )   ) { ABS ( ˜ £ ) < 100 day   }
       Then     GoTo  NotCalcStar ;   { ‡‚…‡„› H… ……‚›—ˆ‘‹Ÿ…Œ }
                                      { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

        NewCalcStars := True  ;
        EndStars     := False ;

        MvMin    := MvMinParam  ;
        MvMax    := MvMaxParam  ;

        NMarkingStars  := 0     ;


        If ( Not B_Import_Fld )  Then
          Begin

            NumberOfStars  := 0     ;
            CatMax         := 0     ;

            For J := 0 To CatIzoMax Do
              Begin
                IndCat  [ J ].TypeCoord   :=   NoCoord ;
                IndCat  [ J ].NBEG        :=  -1       ;
                IndCat  [ J ].NEND        :=  -2       ;
                IndCat  [ J ].RoDet       :=   0.0     ;
                IndCat  [ J ].NDet        :=   0       ;
                IndCat  [ J ].NStarInFild :=   0       ;
                IndCat  [ J ].NoDetInFild :=   0       ;
                CatSort [ J ]             :=   False   ;
              End ;

          End ;



          { ‚ë¡®p HicBin }
          { ÄÄÄÄÄÄÄÄÄÄÄÄ }
        (*
        HicBinFld ;
       {ÜÜÜÜÜÜÜÜÜ}

        IFirst := IndCat [ CatHicBin ].NBEG ;
        ILast  := IndCat [ CatHicBin ].NEND ;

        If ( ( Ilast - Ifirst ) >= 0 )  Then
           Begin
             If ( CatHicBin > CatMax )
                Then  CatMax := CatHicBin ;
           End ;
        *)



          { ‚ë¡®p Npm }
          { ÄÄÄÄÄÄÄÄÄ }

        If ( B_Npm )  Then
          Begin

            NpmFld ;
           {ÜÜÜÜÜÜÜÜÜ}

            IFirst := IndCat [ CatNpm ].NBeg ;
            ILast  := IndCat [ CatNpm ].NEnd ;

            If ( ( Ilast - Ifirst ) >= 0 )  Then
              Begin
                If ( CatNpm > CatMax )
                  Then  CatMax := CatNpm ;
              End ;

          End ;


        If ( EndStars )  Then
          GoTo EndCalcStars ;



          { ‚ë¡®p Nltt }
          { ÄÄÄÄÄÄÄÄÄ }

        If ( B_Nltt )  Then
          Begin

            NlttFld ;
           {ÜÜÜÜÜÜÜÜÜ}

            IFirst := IndCat [ CatNltt ].NBeg ;
            ILast  := IndCat [ CatNltt ].NEnd ;

            If ( ( Ilast - Ifirst ) >= 0 )  Then
              Begin
                If ( CatNltt > CatMax )
                  Then  CatMax := CatNltt ;
              End ;

          End ;

        If ( EndStars )  Then
          GoTo EndCalcStars ;


      { ‚› ‡‚…‡„   CDC }
      { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

        If ( B_CDC )  Then
          Begin
             (*
             If ( B_Det_Cdc )
                Then
                   CdcFld
                  {ÜÜÜÜÜÜ}
                Else
             *)
                  Begin

                    If ( B_Cdc_Cat )  Then
                      Begin

                        CdcCatFld ;

                      End ;

                  End ;


             IFirst := IndCat [ CatCdc ].NBEG ;
             ILast  := IndCat [ CatCdc ].NEND ;

             If ( ( Ilast - Ifirst ) >= 0 )  Then
               Begin
                 If ( CatCdc > CatMax )
                    Then  CatMax := CatCdc ;
               End ;

             {
             If ( B_Det_Cdc Or ( Not B_Cdc_Cat ) )
             }
             If ( False  Or ( Not B_Cdc_Cat ) )
                Then
                  Begin

                    { ‚ë¤¥«¥­¨¥ ¯ ¨ïâ¨ ¤«ï § £®«®¢ª®¢ AK }
                    { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                    If (     (  PlateZagol = Nil )
                         And (  MaxAvail-GraphBuffSize  >
                                SizeOf ( PlateZagolArr )  )  )   Then
                      Begin  {  ¬ïâ¨ ¤®áâ â®ç­® }
                        GetMem ( PlateZagol , SizeOf ( PlateZagolArr ) );
                      End ;

                    AKMoz ( RaOpt, DeclOpt, JDateFld,
                            XMax, YMax,
                            NumberOfStars, PlateZagol ) ;
                  End ;


             IFirst := IndCat [ CatCdcMoz ].NBEG ;
             ILast  := IndCat [ CatCdcMoz ].NEND ;

             If ( ( Ilast - Ifirst ) >= 0 )  Then
               Begin

                 If ( CatCdcMoz > CatMax )
                    Then  CatMax := CatCdcMoz ;
                 {
                 CdcStarBin ;
                 }

               End ;

          End ;

        If ( EndStars )  Then
          GoTo EndCalcStars ;




      { ‚›  ‡‚…‡„  OTHERS }
      { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

        If ( B_Others )  Then
          Begin

             OthersFld ;

             IFirst := IndCat [ CatOthers ].NBEG ;
             ILast  := IndCat [ CatOthers ].NEND ;

             If ( ( Ilast - Ifirst ) >= 0 )  Then
               Begin
                 If ( CatOthers > CatMax )
                    Then  CatMax := CatOthers ;
               End ;

          End ;

        If ( EndStars )  Then
          GoTo EndCalcStars ;




      { ‚›  ‡‚…‡„   Dm }
      { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

        If ( B_Dm )  Then
          Begin

                DmFld ;
              { ÜÜÜÜÜ }

             IFirst := IndCat [ CatDm ].NBEG ;
             ILast  := IndCat [ CatDm ].NEND ;

             If ( ( Ilast - Ifirst ) >= 0 )  Then
               Begin
                 If ( CatDm > CatMax )
                    Then  CatMax := CatDm ;
               End ;

          End ;

        If ( EndStars )  Then
          GoTo EndCalcStars ;




      { ‚›  ‡‚…‡„   Gcvs }
      { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

        If ( B_Gcvs )  Then
          Begin

             If ( B_Gcvs2000 )
               Then Gcvs2000Fld
               Else GcvsFld     ;

             IFirst := IndCat [ CatGcvs ].NBEG ;
             ILast  := IndCat [ CatGcvs ].NEND ;

             If ( ( Ilast - Ifirst ) >= 0 )  Then
               Begin
                 If ( CatGcvs > CatMax )
                    Then  CatMax := CatGcvs ;
               End ;

          End ;

        If ( EndStars )  Then
          GoTo EndCalcStars ;




      { ‚›  ‡‚…‡„   BS }
      { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

        If ( B_Bs )  Then
          Begin

               BsFld ;
              {ÜÜÜÜÜ}

             IFirst := IndCat [ CatBs ].NBEG ;
             ILast  := IndCat [ CatBs ].NEND ;

             If ( ( Ilast - Ifirst ) >= 0 )  Then
               Begin
                 If ( CatBs > CatMax )
                    Then  CatMax := CatBs ;
               End ;

          End ;

        If ( EndStars )  Then
          GoTo EndCalcStars ;




      { ‚›  ‡‚…‡„   HD }
      { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

        If ( B_Hd )  Then
          Begin

               HdFld ;
              {ÜÜÜÜÜ}

             IFirst := IndCat [ CatHd ].NBEG ;
             ILast  := IndCat [ CatHd ].NEND ;

             If ( ( Ilast - Ifirst ) >= 0 )  Then
               Begin
                 If ( CatHd > CatMax )
                    Then  CatMax := CatHd ;
               End ;

          End ;

        If ( EndStars )  Then
          GoTo EndCalcStars ;




      { ‚›  ‡‚…‡„   PPM }
      { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

        If ( B_PPM )  Then
          Begin

               PPMFld ;
              {ÜÜÜÜÜÜ}

             IFirst := IndCat [ CatPPM ].NBEG ;
             ILast  := IndCat [ CatPPM ].NEND ;

             If ( ( Ilast - Ifirst ) >= 0 )  Then
               Begin
                 If ( CatPPM > CatMax )
                    Then  CatMax := CatPPM ;
               End ;

          End ;

        If ( EndStars )  Then
          GoTo EndCalcStars ;






      { ‚›  ‡‚…‡„   Hip }
      { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

        If ( B_Hip )  Then
          Begin

               HipFld ;
              {ÜÜÜÜÜÜ}

             IFirst := IndCat [ CatHip ].NBEG ;
             ILast  := IndCat [ CatHip ].NEND ;

             If ( ( Ilast - Ifirst ) >= 0 )  Then
               Begin
                 If ( CatHip > CatMax )
                    Then  CatMax := CatHip ;
               End ;

          End ;

        If ( EndStars )  Then
          GoTo EndCalcStars ;




      { ‚›  ‡‚…‡„   Tyc }
      { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

        If ( B_Tyc )  Then
          Begin

               TycFld ;
              {ÜÜÜÜÜÜ}

             IFirst := IndCat [ CatTyc ].NBEG ;
             ILast  := IndCat [ CatTyc ].NEND ;

             If ( ( Ilast - Ifirst ) >= 0 )  Then
               Begin
                 If ( CatTyc > CatMax )
                    Then  CatMax := CatTyc ;
               End ;

          End ;

        If ( EndStars )  Then
          GoTo EndCalcStars ;





      { ‚›  ‡‚…‡„   Sao }
      { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

        If ( B_Sao )  Then
          Begin

               SaoFld ;
              {ÜÜÜÜÜÜ}

             IFirst := IndCat [ CatSao ].NBEG ;
             ILast  := IndCat [ CatSao ].NEND ;

             If ( ( Ilast - Ifirst ) >= 0 )  Then
               Begin
                 If ( CatSao > CatMax )
                    Then  CatMax := CatSao ;
               End ;

          End ;


        If ( EndStars )  Then
          GoTo EndCalcStars ;




      { ‚› ‡‚…‡„   GSC }
      { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

        If ( B_GSC )  Then
          Begin

               GscFld ;
              {ÜÜÜÜÜÜ }

             IFirst := IndCat [ CatGSC ].NBEG ;
             ILast  := IndCat [ CatGSC ].NEND ;

             If ( ( Ilast - Ifirst ) >= 0 )  Then
               Begin
                 If ( CatGSC > CatMax )
                    Then  CatMax := CatGSC ;
               End ;

          End ;

        If ( EndStars )  Then
          GoTo EndCalcStars ;






      { ‚› ‡‚…‡„   A20 }
      { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

        If ( B_A20 )  Then
          Begin

               A20Fld ;
              {ÜÜÜÜÜÜ}

             IFirst := IndCat [ CatA20 ].NBEG ;
             ILast  := IndCat [ CatA20 ].NEND ;

             If ( ( Ilast - Ifirst ) >= 0 )  Then
               Begin
                 If ( CatA20 > CatMax )
                    Then  CatMax := CatA20 ;
               End ;

          End ;

        If ( EndStars )  Then
          GoTo EndCalcStars ;




        EndCalcStars : ;

             { p®¢¥pª  ­ «¨ç¨ï §¢¥§¤ ¢ ¯®«¥ }
             { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

        StarsInFild := False ;
        NFound      := 0     ;

        For J := 1 To CatMax Do
          Begin

            IFirst := IndCat [ J ] . NBeg ;

            If  (      ( IFirst > -1      )
                  And  ( J  <> CatImp  )  )
               Then
                  StarsInFild := True ;

          End ;


              {  â®¦¤¥áâ¢«¥­¨¥  Cdc  c  Gsc  }
              {  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  }
        (*
        If  ( B_Det_Cdc )   Then

          Begin


             DetCdc ( CatCdcMoz );
            {ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ}


            If ( B_BS )  Then
              DetCdc ( CatBS );
             {ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ}


            If ( B_PPM )  Then
              DetCdc ( CatPPM );
             {ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ}

             { *************************
              DetCdc ( CatNLTT );
              **************************}
             {ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ}


            If ( B_GSC )  Then
              DetCdc ( CatGsc );
             {ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ}


          End ;
          *)


           { â®¦¤¥áâ¢«¥­¨¥ ¨¬¯®àâ­ëå ¢ ¯®«¥ íp¥­¨ï }
           { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

        If (     ( B_Det_Imp                      )
             And ( IndCat [ CatImp ] . NBeg > -1  )  ) Then

          Begin

             DetImp (  CatImp  );
            {ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ}

          End ;




       NotCalcStar : ;   {  –…H’ H…   ( RA, DECL )  }
                         {  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ  }



       If ( JDate > 0 )
         Then
           DayJd ( JDate + DtGrTopo / 24.0, YearDate, MonthDate, DayDate )
         Else
           Begin
             YEARDATE  := Round ( 1900 + ( JDate - 2415020 ) / 365.25 ) ;
             MONTHDATE := 0 ;
             DAYDATE   := 0 ;
           End ;


        If  ( B_Det_Imp )  Then
          Begin  { â®¦¤¥áâ¢«ï¥¬ ¨¬¯®pâ­ë¥ }
                 { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }
            If   ( Not  B_Stop_NoDet )
              Then
                Begin  { H¥ ®áâ ­ ¢«¨¢ ¥¬áï ¯p¨ ­¥®â®¦¤¥áâ¢«¥­¨¨ }
                       { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                  OptIzo := True ;

                  If (    ( NGrImport Mod 10 = 1 )
                       Or ( NGrImport        < 3 )  )
                     Then  OptIzo := True
                     Else  OptIzo := False ;


                End    { H¥ ®áâ ­ ¢«¨¢ ¥¬áï ¯p¨ ­¥®â®¦¤¥áâ¢«¥­¨¨ }
                       { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

              Else

                Begin  { áâ ­ ¢«¨¢ ¥¬áï ¯p¨ ­¥®â®¦¤¥áâ¢«¥­¨¨ }
                       { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }
                       {
                       If ( StarsInFild )
                         Then   OptIzo := True
                         Else   OptIzo := False ;

                       If (    ( NGrImport Mod 10 = 1 )
                            Or ( NGrImport        < 3 )
                            Or ( B_Menu               )  )
                         Then  OptIzo := True
                         Else  OptIzo := False ;
                       }

                       OptIzo := True  ;

                       If (     (     ( NGrImport Mod 10 <> 1 )
                                  And ( NStarGrMax       =  1 )
                                  And ( NGrImport         > 2 )  )
                            And ( B_Menu = False                 )  )
                         Then  OptIzo := False ;


                End ;  { áâ ­ ¢«¨¢ ¥¬áï ¯p¨ ­¥®â®¦¤¥áâ¢«¥­¨¨ }
                       { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }



            If ( B_Stop_All )  Then
              Begin
                OptIzo := True ;
                B_Menu := True ;
              End ;

          End    { â®¦¤¥áâ¢«ï¥¬ ¨¬¯®pâ­ë¥ }
                 { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }
         Else

          Begin  { H¥ ®â®¦¤¥áâ¢«ï¥¬ ¨¬¯®pâ­ë¥ }
                 { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }
             OptIzo := True ;

             If ( B_Import_Fld ) Then
               Begin

                 If (     (     ( NGrImport Mod 10 <> 1 )
                         {  And ( NStarGrMax       =  1 )}
                            And ( NGrImport         > 2 )  )
                      And ( B_Menu = False                 )  )
                   Then  OptIzo := False ;
               End ;

          End ;  { H¥ ®â®¦¤¥áâ¢«ï¥¬ ¨¬¯®pâ­ë¥ }
                 { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

        If (    ( KeyPressed )
             Or ( KeyExist   ) ) Then
          ScrIzo := True ;

        If (    (   OptIzo        )
             Or ( EndStars        )
             Or ( KeyExist        )
             Or ( KeyPressed      )  )  Then
         If ( ScrIzo )  Then
          Begin  { ¨áã¥¬ ª pâ¨­ªã }
                 { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }
             {
             If ( KeyPressed ) Then
               Begin
                 UserKey := GetCh;

                 UnGetCh ( UserKey ) ;

               End ;
             }
                 OutPV ;
                {ÜÜÜÜÜ}

             NMarking         := 0     ;
             NGrMarking       := 0     ;
             NMarkingRepStars := 0     ;
             MarkingRepStars  := False ;

             ReCalcObjects ;

             Oscreen ;
            {ÜÜÜÜÜÜÜÜ}


             Sound ( 10000 ) ;
             Delay (     0 ) ;
             NoSound ;


           { …á«¨ ­  ­ã«¥¢®© áâp ­¨æ¥ ¡ë«  § áâ ¢ª , ¥¥ ­ã¦­® áâ¥p¥âì }
           { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

           If Start Then
             Begin

               Start:=False;
               Page := ( Page + NGPages - 1 ) mod 2;
               SetActivePage ( Page ) ;
               setviewport(0,0,getmaxx,getmaxy,clipon);
               setfillstyle(emptyfill,0);
               bar(0,0,getmaxx,getmaxy);

               Initiw;
              {ÜÜÜÜÜÜ}
               Reporti;
              {ÜÜÜÜÜÜÜ}
              (**
               If ( B_PPM Or B_BS )  Then
                 SpectraLine ;
               **)

               Page := ( Page + NGPages - 1 ) mod 2;
               SetActivePage ( Page ) ;

             End;


          End ;  { ¨áã¥¬ ª pâ¨­ªã }
                 { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }



           If (    ( KeyPressed                       )
                Or ( Reenter                          )
                Or ( EndStars                         )
                Or ( KeyExist                         )
                Or ( B_Stop_All                       )
                Or (     ( B_Stop_NoDet             )
                     And ( StarsInFild  And  B_Menu ) ) )
            Then
             Begin

               If ( KeyPressed ) Or ( KeyExist )  Then
                 UserKey := GetCh;

               Stop := SatMenu ( StepTime, Page);
             End      {ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ}
            Else
               Stop := False;

           If  ( B_Export )  Then
             Begin

               OutputFieldData ;
             { ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ }

             End ;


           End ; { CalcFild }
                 { ÄÄÄÄÄÄÄÄ }

        ExitProc : ;

      End ;  { PRDATE }
             { ÄÄÄÄÄÄ }

  DirCatError : ;

    EndOpt ;
   {ÜÜÜÜÜÜ}

    FileMode := 2 ;  { Read & Write }
                     { ÄÄÄÄÄÄÄÄÄÄÄÄ }


    If (     ( B_Import_Fld )
         And ( Not Stop     )  )  Then
      Begin
        Sound ( 500 ) ;
        Delay ( 200 ) ;
        NoSound;
      End ;




  End;

End.    { PROGRAM OptSat }
