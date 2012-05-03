{ ⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø }
{ ≥                                                                    ≥ }
{ ≥    ASKYVIEW  Version 1.0a Copyright (c) 1991, 92 by ASTROSOFT.     ≥ }
{ ≥                                                                    ≥ }
{ ¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ }

{$F+,O+}

Unit SSFile;

Interface

Uses SSVar,     SSError ,  TDialogs , TStdObj ,
     PWrParam, PVarMenu ,  PVar     , PRdParOn ,     Dos ,    TUtil ;

Var
  FileFlag : Boolean;

Procedure  PFLoad( FName : PathStr; DialogFlag : Boolean  );
Procedure  PFSave( FName : PathStr; DialogFlag : Boolean  );

Procedure SetVarParameters   ;
Procedure WriteVarParameters ;

Implementation

Const

   ParamFileName : PathStr  =  '' ;
   OpenFileFlag  : Boolean  =  False ;

Var

   ParamFile : Text ;
   UserDir   : Text ;


    { è•p•§†Á† 'Param' -> é´•£ }
    { ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ }

Procedure SetVarParameters;

Begin

  FlagSdIzo := False  ;

  If ( DateNew )  Then
  With BeginDate Do
    Begin

      Month    := Param.TimeMon ;
      Day      := Param.TimeDay ;
      Year     := Param.TimeYear ;

      Hour     := Param.TimeH ;
      Minute   := Param.TimeMin ;
      Sec      := Param.TimeSek ;

      Step     := Param.StepTime;

    End;


  With FotoPriemnik Do
    Begin

      PeriodMatrX     := Param.Period_X_Min ;
      PeriodMatrY     := Param.Period_Y_Min ;

      RazmPixX        := Param.Pixel_X_Min ;
      RazmPixY        := Param.Pixel_Y_Min ;

      KolElemX        := Param.N_Pixel_X ;
      KolElemY        := Param.N_Pixel_Y ;

    End;

  With PoleZr Do
    Begin

        RazmPolX        := Param.FldX;
        RazmPolY        := Param.FldY;

        RazmDopRamkX    := Param.RRX;
        RazmDopRamkY    := Param.RRY;

        OrientX         := Param.XOrient;
        OrientY         := Param.YOrient;


    End;

  With EpohaElementov Do
    Begin

      Month    := Param.InputMon ;
      Day      := Param.InputDay ;
      Year     := Param.InputYear ;

      Hour     := Param.InputH ;
      Minute   := Param.InputMin ;
      Sec      := Param.InputSek ;

    End;

  With EpInform Do
    Begin

      EpModel := Param.EpOut;

      Month    := Param.OutMon ;
      Day      := Param.OutDay ;
      Year     := Param.OutYear ;

      Hour     := Param.OutH ;
      Minute   := Param.OutMin ;
      Sec      := Param.OutSek ;

    End;

  Space_Earth_Flag := Param.Earth_Space;

  If Param.EarthIzo = 0
    Then  TPCP := 1
    Else  TPCP := 2 ;

  KosmosCentralTelo := Param.NPL0;

  With TeleskopPosition Do
    Begin

      Dolgota.BChar := Param.LongSig;
      Dolgota.PI1   := Param.LongG;
      Dolgota.PI2   := Param.LongM;
      Dolgota.PD    := Param.LongS;

      Shirota.BChar := Param.LatSig;
      Shirota.PI1   := Param.LatG;
      Shirota.PI2   := Param.LatM;
      Shirota.PD    := Param.LatS;

      Height        := Param.Alt;

    End;


  With KosmosOrbita Do
    Begin

        HeightAppoCentra   := Param.HAp ;
        HeightPeriCentra   := Param.HPer ;

        NaklOrbKEkv        := Param.ISat ;
        PrVoshVoshUzla     := Param.OmG ;
        ArgPeriCentra      := Param.OmL ;
        ArgShir            := Param.ArgLat ;

    End;

  SetOptOrbit := Param.ElemFile ;


  With CatalogDir Do
    Begin

      HIP       := ParamDir.HipDir  ;
      TYC       := ParamDir.TycDir  ;
      PPM       := ParamDir.PPMDir  ;
      BS        := ParamDir.BSDir   ;
      HD        := ParamDir.HDDir   ;
      Gcvs      := ParamDir.GcvsDir ;
      CDS       := ParamDir.CDCDir  ;
      NPM       := ParamDir.NpmDir  ;
      NLTT      := ParamDir.NLttDir ;
      A20       := ParamDir.A20Dir  ;
      GSC       := ParamDir.GSCDir  ;
      DM        := ParamDir.DmDir   ;
      IRAS      := ParamDir.IRASDir ;
      Satellits := ParamDir.SatDir ;

    End;

  With EDir Do
    Begin

      Import    := Param.ImportStarDir ;
      Satellits := Param.SatellitsDir  ;
      Pzs       := Param.PZSDir        ;
      FotSysDir := Param.FotSysDir     ;

    End;

  OptOsOrient := Param.OptAxOrient;

  With EkvCoord Do
    Begin

      Param1.BChar := ' ';
      Param1.PI1   := Param.RaOptH ;
      Param1.PI2   := Param.RaOptM ;
      Param1.PD    := Param.RaOptS ;

      Param2.BChar := Param.DeclOptSig ;
      Param2.PI1   := Param.DeclOptG   ;
      Param2.PI2   := Param.DeclOptM   ;
      Param2.PD    := Param.DeclOptS   ;

    End;

  With HorCoord Do
    Begin

      Param1.BChar := Param.ASig;
      Param1.PI1   := Param.AG;
      Param1.PI2   := Param.AM;
      Param1.PD    := Param.AS;

      Param2.BChar := Param.HSig;
      Param2.PI1   := Param.HG;
      Param2.PI2   := Param.HM;
      Param2.PD    := Param.HS;

    End;


  With OrientDet Do
    Begin

     Tangag       := Param.Tangag   ;
     Ryskanie     := Param.Ryskanie ;

   End ;



  NObject := Param.NPlan ;

  If ( Param.NObj = 2 )  Then
    Begin

      NObject :=  12;
      NObjectSputnikNum := Param.NSat;

    End;


 { ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }

  CCatalogFlag := $0000;

  If ( Param.CDC And 8 ) = 8 Then
   CCatalogFlag := CCatalogFlag + BSqr( 2, 0 );    { Hip }

  If ( Param.Ppm And 4 ) = 4 Then
   CCatalogFlag := CCatalogFlag + BSqr( 2, 1 );    { Tyc }

  If ( Param.Ppm And 1 ) = 1 Then
   CCatalogFlag := CCatalogFlag + BSqr( 2, 2 );    { Ppm }

  If ( Param.Ppm And 2 ) = 2 Then
   CCatalogFlag := CCatalogFlag + BSqr( 2, 3 );    { Sao }

  If Param.Bs = 1 Then
   CCatalogFlag := CCatalogFlag + BSqr( 2, 4 );

  If Param.Hd = 1 Then
   CCatalogFlag := CCatalogFlag + BSqr( 2, 5 );

  If Param.Gcvs = 1 Then
   CCatalogFlag := CCatalogFlag + BSqr( 2, 6 );

  If ( Param.CDC And 1 ) = 1 Then
   CCatalogFlag := CCatalogFlag + BSqr( 2, 7 );

  If ( Param.CDC And 2 ) = 2 Then
   CCatalogFlag := CCatalogFlag + BSqr( 2, 8 );

  If ( Param.CDC And 4 ) = 4 Then
   CCatalogFlag := CCatalogFlag + BSqr( 2, 9 );

  If ( Param.Gsc And 2 ) = 2 Then
   CCatalogFlag := CCatalogFlag + BSqr( 2, 10 );  { A20 }

  If ( Param.Gsc And 1 ) = 1 Then
   CCatalogFlag := CCatalogFlag + BSqr( 2, 11 );  { Gsc }


  If Param.Dm >= 1 Then
    Begin
      Param.Dm := 1 ;
      CCatalogFlag := CCatalogFlag + BSqr( 2, 12 );
    End ;

  If Param.Iras = 1 Then
   CCatalogFlag := CCatalogFlag + BSqr( 2, 13 );

  If Param.ImportStar = 1 Then
   CCatalogFlag := CCatalogFlag + BSqr( 2, 14 );

  If Param.Satellits = 1 Then
   CCatalogFlag := CCatalogFlag + BSqr( 2, 15 );




{ ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }


  With FotometrHar Do
    Begin

       MvPred     := Param.MvMax  ;
       dMPriOtogd := Param.DMvDet ;

    End ;


  NGrImpBeg := Param.NGrImportBeg ;

  With Regims Do
    Begin

      OutFOV        := Param.OutFOV         ;
      Object_Tracks := Param.Object_Tracks  ;
      DetCdc        := Param.DetCdc         ;
      DetImp        := Param.DetImp         ;
      StopNoDet     := Param.StopNoDet      ;
      PzsInFOV      := Param.PzsInFOV       ;
      Corr_Fot_Sys  := Param.Corr_Fot_Sys   ;
      NPolFix       := Param.NPolFix        ;

    End;


  With RCatDet Do
    Begin

      RoPPMDet       := Param.RoPPMDet  ;
      RoBsDet        := Param.RoBsDet   ;
      RoHdDet        := Param.RoHdDet   ;
      RoGcvsDet      := Param.RoGcvsDet ;
      RoCdcDet       := Param.RoCdcDet  ;
      RoGscDet       := Param.RoGscDet  ;
      RoIrasDet      := Param.RoIrasDet ;
      RoDmDet        := Param.RoDmDet   ;
      RoImpDet       := Param.RDetImp   ;

   End ;



End;

{ ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }




    { è•p•§†Á† é´•£ -> 'Param' }
    { ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ }

Procedure WriteVarParameters;
Var
 OldCatalogFlag : Word;
 NObjMax        : Word;
Begin


  With BeginDate Do
    Begin

      Param.TimeMon    := Month  ;
      Param.TimeDay    := Day    ;
      Param.TimeYear   := Year   ;

      Param.TimeH      := Hour   ;
      Param.TimeMin    := Minute ;
      Param.TimeSek    := Sec    ;

      Param.StepTime     := Step;

    End;


  With FotoPriemnik Do
    Begin

      Param.Period_X_Min     := PeriodMatrX ;
      Param.Period_Y_Min     := PeriodMatrY ;

      Param.Pixel_X_Min      := RazmPixX ;
      Param.Pixel_Y_Min      := RazmPixY;

      Param.N_Pixel_X        := KolElemX ;
      Param.N_Pixel_Y        := KolElemY ;

    End;

  With PoleZr Do
    Begin

        Param.FldX     := RazmPolX ;
        Param.FldY     := RazmPolY ;

        Param.RRX      := RazmDopRamkX ;
        Param.RRY      := RazmDopRamkY ;

        Param.XOrient  := OrientX ;
        Param.YOrient  := OrientY ;

    End;

  With EpohaElementov Do
    Begin

      Param.InputMon    := Month ;
      Param.InputDay    := Day;
      Param.InputYear   := Year ;

      Param.InputH      := Hour ;
      Param.InputMin    := Minute ;
      Param.InputSek    := Sec ;

    End;

  With EpInform Do
    Begin

      Param.EpOut     := EpModel;

      Param.OutMon    := Month ;
      Param.OutDay    := Day ;
      Param.OutYear   := Year ;

      Param.OutH      := Hour ;
      Param.OutMin    := Minute ;
      Param.OutSek    := Sec ;

    End;

  Param.Earth_Space := Space_Earth_Flag;

  Param.NPL0 := KosmosCentralTelo;

  If  TPCP = 1
    Then
      Param.EarthIzo := 0
    Else
      Param.EarthIzo := 1;

  With TeleskopPosition Do
    Begin

      Param.LongSig := Dolgota.BChar;
      Param.LongG   := Dolgota.PI1;
      Param.LongM   := Dolgota.PI2;
      Param.LongS   := Dolgota.PD;

      Param.LatSig := Shirota.BChar;
      Param.LatG   := Shirota.PI1;
      Param.LatM   := Shirota.PI2;
      Param.LatS   := Shirota.PD;

      Param.Alt    := Height;

    End;


  With KosmosOrbita Do
    Begin

        Param.HAp   := HeightAppoCentra ;
        Param.HPer   := HeightPeriCentra ;

        Param.ISat     := NaklOrbKEkv ;
        Param.OmG      := PrVoshVoshUzla ;
        Param.OmL      := ArgPeriCentra ;
        Param.ArgLat   := ArgShir ;

    End;

  Param.ElemFile := SetOptOrbit ;


  With CatalogDir Do
    Begin

      ParamDir.HipDir    := Hip       ;
      ParamDir.TycDir    := Tyc       ;
      ParamDir.PPMDir    := PPM       ;
      ParamDir.BSDir     := BS        ;
      ParamDir.HDDir     := HD        ;
      ParamDir.GcvsDir   := Gcvs      ;
      ParamDir.CDCDir    := CDS       ;
      ParamDir.NpmDir    := Npm       ;
      ParamDir.NLttDir   := NLtt      ;
      ParamDir.A20Dir    := A20       ;
      ParamDir.GSCDir    := GSC       ;
      ParamDir.DmDir     := DM        ;
      ParamDir.IRASDir   := IRAS      ;
      ParamDir.SatDir    := Satellits ;

    End;

  With EDir Do
    Begin

      Param.ImportStarDir  := Import    ;
      Param.SatellitsDir   := Satellits ;
      Param.PZSDir         := Pzs       ;
      Param.FotSysDir      := FotSysDir ;

    End;

  Param.OptAxOrient := OptOsOrient;

  With EkvCoord Do
    Begin

      Param.RaOptH     := Param1.PI1;
      Param.RaOptM     := Param1.PI2;
      Param.RaOptS     := Param1.PD;

      Param.DeclOptSig := Param2.BChar;
      Param.DeclOptG   := Param2.PI1;
      Param.DeclOptM   := Param2.PI2;
      Param.DeclOptS   := Param2.PD;

    End;

  With HorCoord Do
    Begin

      Param.ASig := Param1.BChar;
      Param.AG   := Param1.PI1;
      Param.AM   := Param1.PI2;
      Param.AS   := Param1.PD;

      Param.HSig := Param2.BChar;
      Param.HG   := Param2.PI1;
      Param.HM   := Param2.PI2;
      Param.HS   := Param2.PD;

    End;


  With OrientDet Do
    Begin

     Param.Tangag    :=  Tangag   ;
     Param.Ryskanie  :=  Ryskanie ;

   End ;



  If  NObject = 12
    Then
      Begin

        Param.NObj := 2;
        Param.NSat := NObjectSputnikNum ;

      End

    Else

        Param.NObj := 1;


  Param.NPlan := NObject ;


 { ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }

  OldCatalogFlag  :=    CCatalogFlag ;

  Param.CDC       :=    0                     ;
  Param.Ppm       :=    0                     ;

  Param.CDC       :=    Param.CDC
                     + 8 * ( CCatalogFlag Mod 2 );    { Hip }

  CCatalogFlag    :=    CCatalogFlag    Div 2 ;
  Param.PPM       :=    Param.Ppm
                      + 4 * ( CCatalogFlag Mod 2 ) ;  { Tyc }

  CCatalogFlag    :=    CCatalogFlag    Div 2 ;       { Ppm }
  Param.PPM       :=    Param.Ppm
                      + ( CCatalogFlag Mod 2 ) ;

  CCatalogFlag    :=    CCatalogFlag    Div 2 ;
  Param.PPM       :=    Param.Ppm
                      + 2 * ( CCatalogFlag Mod 2 ) ;  { Sao }


  CCatalogFlag    :=    CCatalogFlag    Div 2 ;
  Param.Bs        :=    CCatalogFlag    Mod 2 ;

  CCatalogFlag    :=    CCatalogFlag    Div 2 ;
  Param.Hd        :=    CCatalogFlag    Mod 2 ;

  CCatalogFlag    :=    CCatalogFlag    Div 2 ;
  Param.Gcvs      :=    CCatalogFlag    Mod 2 ;

  CCatalogFlag    :=    CCatalogFlag    Div 2 ;
  Param.Cdc       :=    Param.Cdc
                      + ( CCatalogFlag Mod 2 );

  CCatalogFlag    :=    CCatalogFlag    Div 2 ;
  Param.Cdc       :=    Param.Cdc
                      + 2 * ( CCatalogFlag Mod 2 ) ;

  CCatalogFlag    :=    CCatalogFlag    Div 2 ;
  Param.Cdc       :=    Param.Cdc
                      + 4 * ( CCatalogFlag Mod 2 ) ;


  Param.Gsc       := 0 ;

  CCatalogFlag    :=    CCatalogFlag    Div 2 ;
  Param.Gsc       :=    Param.Gsc + 2 * ( CCatalogFlag Mod 2 ) ;

  CCatalogFlag    :=    CCatalogFlag    Div 2 ;
  Param.Gsc       :=    Param.Gsc + ( CCatalogFlag Mod 2 ) ;

  CCatalogFlag    :=    CCatalogFlag    Div 2 ;
  Param.Dm        :=    CCatalogFlag    Mod 2 ;
  If (     ( Param.Dm = 1 )
       And ( DmFlag       )
       And ( FlagSdIzo    )  )  Then
    Param.Dm := 2 ;  { àßÆ°p†¶†‚Ï SD §´Ô -1 grad. }

  CCatalogFlag    :=    CCatalogFlag    Div 2 ;
  Param.Iras      :=    CCatalogFlag    Mod 2 ;

  CCatalogFlag    :=    CCatalogFlag    Div 2 ;
  Param.ImportStar:=    CCatalogFlag    Mod 2 ;

  CCatalogFlag    :=    CCatalogFlag    Div 2 ;
  Param.Satellits :=    CCatalogFlag    Mod 2 ;


  CCatalogFlag     :=    OldCatalogFlag ;

{ ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }


  With FotometrHar Do
    Begin

       Param.MvMax  :=  MvPred     ;
       Param.DMvDet :=  dMPriOtogd ;

    End ;


  Param.NGrImportBeg := NGrImpBeg ;

  With Regims Do
    Begin

      Param.OutFOV        := OutFOV        ;
      Param.Object_Tracks := Object_Tracks ;
      Param.DetCdc        := DetCdc        ;
      Param.DetImp        := DetImp        ;
      Param.StopNoDet     := StopNoDet     ;
      Param.Corr_Fot_Sys  := Corr_Fot_Sys  ;
      Param.NPolFix       := NPolFix       ;

      Param.PzsInFOV      := PzsInFOV      ;

    End;

  With RCatDet Do
    Begin

      Param.RoPPMDet  :=  RoPPMDet   ;
      Param.RoBsDet   :=  RoBsDet    ;
      Param.RoHdDet   :=  RoHdDet    ;
      Param.RoGcvsDet :=  RoGcvsDet  ;
      Param.RoCdcDet  :=  RoCdcDet   ;
      Param.RoGscDet  :=  RoGscDet   ;
      Param.RoIrasDet :=  RoIrasDet  ;
      Param.RoDmDet   :=  RoDmDet    ;
      Param.RDetImp   :=  RoImpDet   ;

   End ;




End;

{ ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }

Procedure  PFLoad( FName : PathStr; DialogFlag : Boolean );
Label BegRun, BegLoadFile;
Var
  R      : TRect;
  Dialog : PDialog;
  Bruce  : PView;
  ECode  : Word;

  PFile  : Text;

  RString : String;

  IReal : Double;

  IInteger : Integer;
  i        : Byte;

Begin

 If DialogFlag = False Then
   GoTo  BegLoadFile;

 R.Assign( 1, 1, 50, 8 );
 Dialog := New( PDialog, Init( R, ' Load file ', jcCentered ));
 With Dialog^ Do
   Begin

     R.Assign( 2, 3, 49, 4 );
     Bruce := New( PInputline, Init( R, 79 ));
     R.Assign( 2, 2, 26, 3 );
     Bruce^.InitLabel( R, 'File name' );
     Insert( Bruce );

     R.Assign( 2, 5, 13, 6 );
     Bruce := New( PButton, Init( R,'Load', bfNormal, cmOk ));
     Insert( Bruce );

     R.Assign( 15, 5, 28, 6 );
     Bruce := New( PButton, Init( R,'Cancel', bfNormal, cmCancel ));
     Insert( Bruce );

     SetData( FName );

BegRun:;

     ECode := Run;


     If ( ECode <> cmCancel ) Then
       Begin

   BegLoadFile:;

       If DialogFlag = True Then
         GetData( FName );

       If FName  = '' Then
         FName := ' ';

       i := Pos( '.', FName );
       If i <> 0 Then
         Begin
           Delete( FName, I , Length( FName ) - i + 1 );
         End;
       Fname := FName + '.par';


         Assign( PFile , FName );

     {$I-}
         Reset( PFile );
     {$I+}
         If IOResult <> 0 Then
           Begin

             ErrorReadFile ( FName );

             FileFlag := false;

             If Not DialogFlag Then
               Exit
                 Else
                   GoTo BegRun;
           End;

     {$I-}
         ReSet ( PFile );
     {$I+}
         If IOResult = 0 Then  Close ( PFile );


         ParamFileName := FName ;

         MainParamFileName := ParamFileName;
         MPFFlag := True;

 { ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }
 { ±±                                                                ±± }
 { ±±                  ó‚•≠®• Ø†p†¨•‚pÆ¢ ®ß ‰†©´†.                   ±± }
 { ±±                                                                ±± }
 { ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }

         RdParamOnly (  MainParamFileName  );

       { ±± èp®·¢†®¢†≠®• Ø•p•¨•≠≠ÎÂ.  ±± }

         SetVarParameters;

       End;

   End;{ With Dialog^ }

If DialogFlag = True Then
   Dispose( Dialog, Done );

End;{ PFLoad }

{ ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }

Procedure  PFSave( FName : PathStr; DialogFlag : Boolean );
Label BegRun, BegSaveFile;
Var
  R      : TRect;
  Dialog : PDialog;
  Bruce  : PView;
  ECode  : Word;

  PFile  : Text;

  RString : String;

  IReal : Double;

  IInteger : Integer;

  i      : byte;

Begin

 If DialogFlag = False Then
   GoTo  BegSaveFile;

 R.Assign( 1, 1, 50, 8 );
 Dialog := New( PDialog, Init( R, ' Save file ', jcCentered ));
 With Dialog^ Do
   Begin

     R.Assign( 2, 3, 49, 4 );
     Bruce := New( PInputline, Init( R, 79 ));
     R.Assign( 2, 2, 26, 3 );
     Bruce^.InitLabel( R, 'File name' );
     Insert( Bruce );

     R.Assign( 2, 5, 13, 6 );
     Bruce := New( PButton, Init( R,'Save', bfNormal, cmOk ));
     Insert( Bruce );

     R.Assign( 15, 5, 28, 6 );
     Bruce := New( PButton, Init( R,'Cancel', bfNormal, cmCancel ));
     Insert( Bruce );

     SetData( FName );

BegRun:;

     ECode := Run;

     If ( ECode <> cmCancel ) Then
       Begin

   BegSaveFile:;

       If DialogFlag = True Then
         GetData( FName );

         If FName = '' Then
           FName := ' ';

         i := Pos( '.', FName );
         If i <> 0 Then
           Begin
             Delete( FName, I , Length( FName ) - i + 1 );
           End;
         FName := FName + '.par';

         ParamFileName := FName ;

         Assign ( PFile , FName );

     {$I-}
         ReSet ( PFile );
     {$I+}
         If IOResult = 0 Then  Close ( PFile );

     {$I-}
         ReWrite( PFile );
     {$I+}
         If IOResult <> 0 Then
           Begin

             ErrorOpenFile( FName );

             FileFlag := false;

             If Not DialogFlag Then
               Exit
                 Else
                   GoTo BegRun;

           End;

     {$I-}
         ReSet ( PFile );
     {$I+}
         If IOResult = 0 Then  Close ( PFile );


 { ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }
 { ±±                                                                ±± }
 { ±±                   á†Ø®·Ï Ø†p†¨•‚pÆ¢ ¢ ‰†©´.                    ±± }
 { ±±                                                                ±± }
 { ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }

       { ±± èp®·¢†®¢†≠®• Ø•p•¨•≠≠ÎÂ.  ±± }

         WriteVarParameters;

         WriteParam (  ParamFileName  );

         FileFlag := True;

       End;

   End;{ With Dialog^ }

If DialogFlag = True Then
   Dispose( Dialog, Done );

End;{ PFSave }

End.