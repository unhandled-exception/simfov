
{$F+,O+}

 Unit  OptSatMc ;

 Interface


    Procedure    OptSatMultCat  ( NVarDir : String; ReadFile : Boolean ) ;
               { ����������������������������������������������������� }


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
               { ���������������������������������������������������� }


 Label NotCalcStar, ExitProc, DirCatError, EndCalcStars ;
{�����}

  Const

      NoCoord : Word   =    0    ;


  Var

      NewCalcStars : Boolean ;
      PSaveMem     : Pointer ;
      J            : Integer ;
      NStepSat     : LongInt ;
      NSat         : LongInt ;

  Begin        {  MAIN  PROGRAM   }
               {  �������������   }

          {
          IndDeb := 0 ;
          Assign  ( Deb, 'Deb.Dat' ) ;
          Rewrite ( Deb            ) ;
          Writeln ( Deb, IndDeb    ) ;
          Inc     ( IndDeb         ) ;
          Close   ( Deb            ) ;
          }


     FileMode := 0 ;  { Read Only }
                      { ��������� }

     CatNotFound     := False ;
     EndProc         := False ;
     BPointerMark    := False ;


     RdParam ( NVarDir, ReadFile ) ;
   { ��������������������������� }


     CalCons ;
   { ������� }


    If ( CatNotFound )  Then
      GoTo  DirCatError ;




    JDate      := JDate - StepTime ;
    NSTEPSAT   :=                0 ;



    { ��� ������ }
    { ����������� }


    NSAT := PaRam.NSat ;
    (*
    If (     ( Param.NObj =  2 )   { �� ���⭨��      }
         And (       NSat = -1 )   { ���              }
         And ( B_Surf          )   { H� � ����p孮�� }
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



      { ������������� ������� }
      { ��������������������� }

    Initgr ;
   {������}


    { �������p �p㣮���� ����p� }
    { �������������������������� }


    NSAT := PaRam.NSat ;

    If (     ( Param.NObj = 2 )   { �� ���⭨��   }
         And (       NSat = 0 )   { ���           }
         And (       NPl0 = 3 )   { � �����       }
         And ( B_Surf         )   { � ����p孮�� }
                                ) Then
         IKO ;
        {���}

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

            SayNames ;  { H� ��p��� ��p���� - ���⠢�� }
            {��������}

          End

         Else

          Begin


            Initiw;
           {������}

            Reporti;
           {�������}

          End;
      End;

    Page := ( Page + NGPages - 1 ) mod 2 ;

    InitPtr;
   {�������}



  { ����������������������������������������������������������������������� }



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
        { ����� }

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
                 { �������� }

            { ��p�������� p����p� ���� �p���� � �롮p ����p��� ����� }
            { ������������������������������������������������������� }

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

                       { ������� }
                       { ������� }

                          PLFLD ;
                        { ����� }

                          NPlanetsInFild := Max_Pl_PPlFld ;

                  End ;


             { ����H��� }
             { �������� }

        NumberOfSatellits := 0 ;

        If ( B_IMPORT_Sat )  Then
          SatFld ;
        { ������ }



    NewCalcStars      := False ;
    StepSectorMarkIzo := False ;
    (*
    If (       ( OPTRD And (Not B_Det_Cdc)  ) { ����p �� RA, DECL       }
          And  ( Not B_Import_Fld           ) { ���� �� �� ��. �� 䠩�� }
          And  ( NSTEPSAT       >     1     ) { H� ��p�� 蠣           }
          And  ( ABS ( STEPTIME ) < 100 )   ) { ABS ( ��� ) < 100 day   }
    *)
    If (       ( OPTRD                      ) { ����p �� RA, DECL       }
          And  ( Not B_Import_Fld           ) { ���� �� �� ��. �� 䠩�� }
          And  ( NSTEPSAT       >     1     ) { H� ��p�� 蠣           }
          And  ( ABS ( STEPTIME ) < 100 )   ) { ABS ( ��� ) < 100 day   }
       Then     GoTo  NotCalcStar ;   { ������ H� ������������� }
                                      { ����������������������� }

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



          { �롮p HicBin }
          { ������������ }
        (*
        HicBinFld ;
       {���������}

        IFirst := IndCat [ CatHicBin ].NBEG ;
        ILast  := IndCat [ CatHicBin ].NEND ;

        If ( ( Ilast - Ifirst ) >= 0 )  Then
           Begin
             If ( CatHicBin > CatMax )
                Then  CatMax := CatHicBin ;
           End ;
        *)



          { �롮p Npm }
          { ��������� }

        If ( B_Npm )  Then
          Begin

            NpmFld ;
           {���������}

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



          { �롮p Nltt }
          { ��������� }

        If ( B_Nltt )  Then
          Begin

            NlttFld ;
           {���������}

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


      { ����� �����   CDC }
      { ����������������� }

        If ( B_CDC )  Then
          Begin
             (*
             If ( B_Det_Cdc )
                Then
                   CdcFld
                  {������}
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

                    { �뤥����� ����� ��� ���������� AK }
                    { ���������������������������������� }

                    If (     (  PlateZagol = Nil )
                         And (  MaxAvail-GraphBuffSize  >
                                SizeOf ( PlateZagolArr )  )  )   Then
                      Begin  { ����� �����筮 }
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




      { �����  �����  OTHERS }
      { �������������������� }

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




      { �����  �����   Dm }
      { ����������������� }

        If ( B_Dm )  Then
          Begin

                DmFld ;
              { ����� }

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




      { �����  �����   Gcvs }
      { ������������������� }

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




      { �����  �����   BS }
      { ����������������� }

        If ( B_Bs )  Then
          Begin

               BsFld ;
              {�����}

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




      { �����  �����   HD }
      { ����������������� }

        If ( B_Hd )  Then
          Begin

               HdFld ;
              {�����}

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




      { �����  �����   PPM }
      { ������������������ }

        If ( B_PPM )  Then
          Begin

               PPMFld ;
              {������}

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






      { �����  �����   Hip }
      { ������������������ }

        If ( B_Hip )  Then
          Begin

               HipFld ;
              {������}

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




      { �����  �����   Tyc }
      { ������������������ }

        If ( B_Tyc )  Then
          Begin

               TycFld ;
              {������}

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





      { �����  �����   Sao }
      { ������������������ }

        If ( B_Sao )  Then
          Begin

               SaoFld ;
              {������}

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




      { ����� �����   GSC }
      { ����������������� }

        If ( B_GSC )  Then
          Begin

               GscFld ;
              {������ }

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






      { ����� �����   A20 }
      { ����������������� }

        If ( B_A20 )  Then
          Begin

               A20Fld ;
              {������}

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

             { �p���p�� ������ ����� � ���� }
             { ����������������������������� }

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


              {  �⮦���⢫����  Cdc  c  Gsc  }
              {  ���������������������������  }
        (*
        If  ( B_Det_Cdc )   Then

          Begin


             DetCdc ( CatCdcMoz );
            {��������������������}


            If ( B_BS )  Then
              DetCdc ( CatBS );
             {����������������}


            If ( B_PPM )  Then
              DetCdc ( CatPPM );
             {����������������}

             { *************************
              DetCdc ( CatNLTT );
              **************************}
             {�����������������}


            If ( B_GSC )  Then
              DetCdc ( CatGsc );
             {����������������}


          End ;
          *)


           { �⮦���⢫���� �������� � ���� �p���� }
           { �������������������������������������� }

        If (     ( B_Det_Imp                      )
             And ( IndCat [ CatImp ] . NBeg > -1  )  ) Then

          Begin

             DetImp (  CatImp  );
            {�������������������}

          End ;




       NotCalcStar : ;   {  ��H�� H� ��  ( RA, DECL )  }
                         {  �������������������������  }



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
          Begin  { �⮦���⢫塞 ����p�� }
                 { ����������������������� }
            If   ( Not  B_Stop_NoDet )
              Then
                Begin  { H� ��⠭���������� �p� ���⮦���⢫���� }
                       { ��������������������������������������� }

                  OptIzo := True ;

                  If (    ( NGrImport Mod 10 = 1 )
                       Or ( NGrImport        < 3 )  )
                     Then  OptIzo := True
                     Else  OptIzo := False ;


                End    { H� ��⠭���������� �p� ���⮦���⢫���� }
                       { ��������������������������������������� }

              Else

                Begin  { ��⠭���������� �p� ���⮦���⢫���� }
                       { ������������������������������������ }
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


                End ;  { ��⠭���������� �p� ���⮦���⢫���� }
                       { ������������������������������������ }



            If ( B_Stop_All )  Then
              Begin
                OptIzo := True ;
                B_Menu := True ;
              End ;

          End    { �⮦���⢫塞 ����p�� }
                 { ����������������������� }
         Else

          Begin  { H� �⮦���⢫塞 ����p�� }
                 { �������������������������� }
             OptIzo := True ;

             If ( B_Import_Fld ) Then
               Begin

                 If (     (     ( NGrImport Mod 10 <> 1 )
                         {  And ( NStarGrMax       =  1 )}
                            And ( NGrImport         > 2 )  )
                      And ( B_Menu = False                 )  )
                   Then  OptIzo := False ;
               End ;

          End ;  { H� �⮦���⢫塞 ����p�� }
                 { �������������������������� }

        If (    ( KeyPressed )
             Or ( KeyExist   ) ) Then
          ScrIzo := True ;

        If (    (   OptIzo        )
             Or ( EndStars        )
             Or ( KeyExist        )
             Or ( KeyPressed      )  )  Then
         If ( ScrIzo )  Then
          Begin  { ���㥬 ��p⨭�� }
                 { ��������������� }
             {
             If ( KeyPressed ) Then
               Begin
                 UserKey := GetCh;

                 UnGetCh ( UserKey ) ;

               End ;
             }
                 OutPV ;
                {�����}

             NMarking         := 0     ;
             NGrMarking       := 0     ;
             NMarkingRepStars := 0     ;
             MarkingRepStars  := False ;

             ReCalcObjects ;

             Oscreen ;
            {��������}


             Sound ( 10000 ) ;
             Delay (     0 ) ;
             NoSound ;


           { �᫨ �� �㫥��� ��p���� �뫠 ���⠢��, �� �㦭� ��p��� }
           { �������������������������������������������������������� }

           If Start Then
             Begin

               Start:=False;
               Page := ( Page + NGPages - 1 ) mod 2;
               SetActivePage ( Page ) ;
               setviewport(0,0,getmaxx,getmaxy,clipon);
               setfillstyle(emptyfill,0);
               bar(0,0,getmaxx,getmaxy);

               Initiw;
              {������}
               Reporti;
              {�������}
              (**
               If ( B_PPM Or B_BS )  Then
                 SpectraLine ;
               **)

               Page := ( Page + NGPages - 1 ) mod 2;
               SetActivePage ( Page ) ;

             End;


          End ;  { ���㥬 ��p⨭�� }
                 { ��������������� }



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
             End      {�������������������������}
            Else
               Stop := False;

           If  ( B_Export )  Then
             Begin

               OutputFieldData ;
             { ��������������� }

             End ;


           End ; { CalcFild }
                 { �������� }

        ExitProc : ;

      End ;  { PRDATE }
             { ������ }

  DirCatError : ;

    EndOpt ;
   {������}

    FileMode := 2 ;  { Read & Write }
                     { ������������ }


    If (     ( B_Import_Fld )
         And ( Not Stop     )  )  Then
      Begin
        Sound ( 500 ) ;
        Delay ( 200 ) ;
        NoSound;
      End ;




  End;

End.    { PROGRAM OptSat }
