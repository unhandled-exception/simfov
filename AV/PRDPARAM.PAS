
{$O+,F+}

 Unit  PrdParam ;


  Interface

    Uses  PVar ;

    Procedure RDParam ( NVarDir : String; ReadFile : Boolean ) ;


  Implementation

    Uses   PRdParOn, PRdFormt, PRdSat, PMem,
           PVarMenu, V_Catal, Check, PJd8, PDefPar, Dos ;

    Var

         CExit,
         Pusto, OldPusto        : Boolean        ;

         I                      : Integer        ;

         Cs                     : Char           ;

         NN                     : Integer        ;

         SpKl                   : String [  2 ]  ;



{  ß  ß  ß  ß  ß  ß  ß  ß  ß  ß  ß  ß  ß  ß  ß  ß  ß  ß  ß  ß  ß  ß  ß  ß  }

 Procedure RDParam ( NVarDir : String; ReadFile : Boolean ) ;
{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}

  Label DirCatNotFound ;

  Var

       CoordExist         : Boolean  ;

       PBeg, ColorPixel   : Byte     ;

       KCalCons,
       NSat               : Integer  ;

       Year               : LongInt  ;

       T,
       SSATEF, Fl,
       BETCalCons,
       VCalCons,
       SQRCalCons,
       BETSKCalCons,
       RX, RY,RH          : Double   ;

       S                  : String   ;

    Begin


      If ReadFile  Then
        RdParamOnly ( NVarDir ) ;
       {ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ}

      If ( CatNotFound )  Then
        GoTo  DirCatNotFound ;


            {  H€‡H€—…Hˆ…  ……Œ…HH›•  ƒ€ŒŒ›  }
            {  ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß  }


 If ( Param.BS    = 1 )
   Then  B_BS    := True
   Else  B_BS    := False ;

 If ( Param.Hd    = 1 )
   Then  B_Hd    := True
   Else  B_Hd    := False ;

 If ( Param.Gcvs  = 1 )
   Then  B_Gcvs  := True
   Else  B_Gcvs  := False ;




 If ( ( Param.Ppm And 1 )  = 1 )
   Then  B_Ppm   := True
   Else  B_Ppm   := False ;

 If ( ( Param.Ppm And 2 )  = 2 )
   Then  B_Sao   := True
   Else  B_Sao   := False ;

 If ( ( Param.Ppm And 4 )  = 4 )
   Then  B_Tyc   := True
   Else  B_Tyc   := False ;




 If ( ( Param.Cdc And 1 )  = 1 )
   Then  B_Cdc   := True
   Else  B_Cdc   := False ;

 If ( ( Param.Cdc And 2 )  = 2 )
   Then  B_Npm   := True
   Else  B_Npm   := False ;

 If ( ( Param.Cdc And 4 )  = 4 )
   Then  B_Nltt  := True
   Else  B_Nltt  := False ;

 If ( ( Param.Cdc And 8 )  = 8 )
   Then  B_Hip   := True
   Else  B_Hip   := False ;


 If ( ( Param.Gsc And 1 ) = 1 )
   Then  B_Gsc  := True
   Else  B_Gsc  := False ;


 If ( ( Param.Gsc And 2 )  = 2 )
   Then  B_A20 := True
   Else  B_A20 := False ;

 If ( Param.Iras = 1 )
   Then  B_Others := True
   Else  B_Others := False ;

 If ( Param.Dm   >= 1 )
   Then
     Begin
       B_Dm := True ;
       If ( Param.Dm > 1 )
         Then  SdIzo := True
         Else  SdIzo := False ;
     End
   Else
     Begin
       B_Dm := False ;
     End ;



 If ( ( Param.OutFOV Mod 2 ) = 1 )
   Then  B_Export  := True
   Else  B_Export  := False ;

 If ( ( Param.OutFOV Div 2 Mod 2 ) = 1 )
   Then  B_Color_A2_0  := True
   Else  B_Color_A2_0  := False ;

 If ( ( Param.OutFOV Div 4 Mod 2 ) = 1 )
   Then  ScrIzo := False
   Else  ScrIzo := True  ;

 If ( Param.DetImp = 1 )
   Then  B_Det_Imp := True
   Else  B_Det_Imp := False ;

 If ( Param.Satellits = 1 )
   Then  B_Import_Sat  :=  True
   Else  B_Import_Sat  :=  False ;

 If ( Param.Corr_Fot_Sys   = 1 )
   Then  B_FOT_SYS     :=  True
   Else  B_FOT_SYS     :=  False ;
 {
 If ( Param.OptAxOrient    = 2 )
   Then  OptAH         :=  True
   Else  OptAH         :=  False ;
 }

 If ( Param.DetCdc = 1 )
   Then  B_Gal := True
   Else  B_Gal := False ;

 B_From_Star := False ;
 If (     ( Not B_Gal           )
      And ( Param.RaOptH >= 100 ) )   Then
   Begin
     B_From_Star := True ;        { ‘® ‡¢¥§¤ë }
   End ;


 NPl0 := Param.NPl0 ;

 If (     ( Param.Earth_Space = 1 )
      And ( NPl0              = 3 )  )
   Then  B_Surf := True
   Else  B_Surf := False ;

 If ( Param.ElemFile Mod 4 = 2 )
   Then  B_Ef_Sat_Cheb := True
   Else  B_Ef_Sat_Cheb := False ;

 B_Geoc := True ;

 If ( Param.ElemFile Div 4 = 1 )
    Then
      Begin
        B_Surf           := False ;
        B_Geoc           := False ;
        B_ObserverNumSat := True  ;
        If ( Param.ISat < 0.5 )
          Then  ObserverNumSat := Round ( Param.ISat )
          Else  ObserverNumSat := Trunc ( Abs ( Param.ISat ) + 0.5 ) ;
      End
    Else
      Begin
        B_ObserverNumSat := False ;
      End ;


 If ( B_Det_Imp )
   Then
       MvMin := -10
   Else
     Begin
       MvMin := Round ( Abs ( Param.DMvDet ) * 1000.0 + 0.5 ) / 1000.0 ;
       If ( Param.DMvDet < 0 )  Then
         MvMin := - MvMin ;
     End ;

 {
 B_Det_Cdc := False ;
 }

 NGPages     := NGPagesConst ;
 B_VectDiagr := False ;
 {
 B_Matrix    := False ;
 }
 {
 If ( PassW )
   Then PSaveDate := True
   Else PSaveDate := False ;
 }
 DateOld := False ;
 {
 If ( PSaveDate )
   Then  DateOld := True
   Else  DateOld := False ;
 }
 If ( Param.PzsInFOV = 1 ) Then
   Begin    { ‚¥ªâ®p­ ï „¨ £p ¬¬  }
            { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }
     PmMaxMm := 0.2 ;
     If ( Param.RRX > 0.001 )
       Then PmMaxMm := Param.RRX ;
     If ( Param.RRY > PmMaxMm )  Then
        PmMaxMm := Param.RRY ;
     NDiagrScale         := Round ( PmMaxMm / 0.01 ) ;
     PmMaxMm             := PmMaxMm * FD / SekRad ;

     B_VectDiagr   := True  ;
     DateOld       := False ;

   End ;


 CalcVectDiagr   := False ;
 B_Object_Tracks := False ;

 If ( Param.Object_Tracks  = 1 )  Then
    Begin
      B_Object_Tracks := True  ;
      NStepTracks     := 1     ;
      NGPages         := 1     ;
      DateOld         := False ;
    End ;


 NStarGrMax   := 1000000000 ;

 NGrImportBeg     := Param.NGrImportBeg ;
 If ( NGrImportBeg < 0 )  Then
   Begin
     NGrImportBeg := Abs ( NGrImportBeg ) ;
     NStarGrMax   := 1 ;
   End ;

 NumbMarkingBegin := NGrImportBeg - 1   ;

 B_Import_Fld := False ;
 B_Inport_Ccd := False ;
 B_Parsek     := False ;


 If ( Param.ImportStar = 1 )
   Then
     Begin

       B_Import_Fld := True ;

       ObjectFileName := Param.ImportStarDir ;
       FSplit ( ObjectFileName , DStr, NStr, EStr );
       For I := 1 To Length ( EStr )  Do
         EStr [ I ] := UpCase ( EStr [ I ] ) ;

       ObjectOutFileName := DStr + NStr + '.Det' ;

       If (    ( EStr = '.CCD' )
            Or ( EStr = '.PRS' )  )   Then
         Begin
           ConstCcdFileName := DStr + NStr + '.Red' ;
           B_Inport_Ccd := True  ;
           If ( EStr = '.PRS' )  Then
             B_Parsek     := True  ;
           CcdDiamExist := False ;
           NameImpCCD   := NStr  ;
         End ;

       CheckFile ( ObjectFileName ) ;
       If ( CatNotFound )  Then
         GoTo  DirCatNotFound ;

       If ( Param.DetImp = 1 ) Then  B_ObjOut := True
                               Else  B_ObjOut := False ;

       If ( Param.StopNoDet = 1 ) Then  B_Stop_NoDet := True
                                  Else  B_Stop_NoDet := False ;
     End

   Else

     Begin

       B_Import_Fld := False ;
       B_ObjOut     := False ;
       B_Stop_NoDet := False ;
       B_Det_Imp    := False ;

     End ;


 If ( Param.EarthIzo = 0 )
    Then  B_Geoc := True
    Else  B_Geoc := False ;


 DMvDet := Param.DMvDet ;


{  ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ  }



                       {  ’Š›’ˆ…  ”€‰‹‚  }
                       {  ßßßßßßßßßßßßßßßß  }

 FileMode  := 0 ;
 B_Hip_Add := False ;

 If ( B_Hip )  Then
  Begin

    CheckFile ( ParamDir.HipDir + '\' + CatFile.HipFileName  ) ;
    CheckFile ( ParamDir.HipDir + '\' + CatFile.HipKeyFileName  ) ;

    Assign    ( HipFile    ,  ParamDir.HipDir + '\' + CatFile.HipFileName  ) ;
    Assign    ( HipKeyFile ,  ParamDir.HipDir + '\' + CatFile.HipKeyFileName  ) ;

    {$I-}
    Assign ( HipAddFile, ParamDir.HipDir + '\' + CatFile.HipAddFileName );
    FileMode := 0;

    Reset ( HipAddFile ) ;
    Close ( HipAddFile ) ;
    {$I+}

    If ( IOResult = 0 ) Then
      B_Hip_Add := True ;



  End ; { Hip }



 If ( B_Tyc )  Then
  Begin

    B_Tyc_2     := False ;
    B_Tyc_2_Add := False ;
    B_Tyc_Sai   := False ;
    B_Tyc_0     := False ;

    {$I-}
    Assign ( TycFile, ParamDir.TycDir + '\' + CatFile.Tyc_2_FileName );
    FileMode := 0;
    Reset ( TycFile ) ;
    Close ( TycFile ) ;
    {$I+}
    If ( IOResult = 0 ) Then
      Begin

        B_Tyc_2 := True ;

        CheckFile (             ParamDir.TycDir + '\' + CatFile.Tyc_2_FileName     ) ;
        Assign    ( TycFile,    ParamDir.TycDir + '\' + CatFile.Tyc_2_FileName     ) ;
        CheckFile (             ParamDir.TycDir + '\' + CatFile.Tyc_2_KeyFileName  ) ;
        Assign    ( TycKeyFile, ParamDir.TycDir + '\' + CatFile.Tyc_2_KeyFileName  ) ;

        {$I-}
        Assign ( TycAddFile, ParamDir.TycDir + '\' + CatFile.Tyc_2_AddName );
        FileMode := 0;
        Reset ( TycAddFile ) ;
        Close ( TycAddFile ) ;
        {$I+}

        If ( IOResult = 0 ) Then
          B_Tyc_2_Add := True ;

      End ;


    If ( Not B_Tyc_2 )  Then
      Begin
        {$I-}
        Assign ( TycFile, ParamDir.TycDir + '\' + CatFile.TycSaiFileName );
        FileMode := 0;
        Reset ( TycFile ) ;
        Close ( TycFile ) ;
        {$I+}
        If ( IOResult = 0 ) Then
          Begin
            B_Tyc_Sai := True ;
            CheckFile (             ParamDir.TycDir + '\' + CatFile.TycSaiFileName     ) ;
            Assign    ( TycFile,    ParamDir.TycDir + '\' + CatFile.TycSaiFileName     ) ;
            CheckFile (             ParamDir.TycDir + '\' + CatFile.TycSaiKeyFileName  ) ;
            Assign    ( TycKeyFile, ParamDir.TycDir + '\' + CatFile.TycSaiKeyFileName  ) ;
          End ;
      End ;

    If (     ( Not B_Tyc_2   )
         And ( Not B_Tyc_Sai ) )  Then
      Begin
        {$I-}
        Assign ( TycFile, ParamDir.TycDir + '\' + CatFile.TycFileName );
        FileMode := 0;
        Reset ( TycFile ) ;
        Close ( TycFile ) ;
        {$I+}
        If ( IOResult = 0 ) Then
          Begin

            B_Tyc_0 := True ;

            CheckFile (             ParamDir.TycDir + '\' + CatFile.TycFileName     ) ;
            Assign    ( TycFile,    ParamDir.TycDir + '\' + CatFile.TycFileName     ) ;
            CheckFile (             ParamDir.TycDir + '\' + CatFile.TycKeyFileName  ) ;
            Assign    ( TycKeyFile, ParamDir.TycDir + '\' + CatFile.TycKeyFileName  ) ;

          End ;
      End ;

  End ; { Tyc }



 If ( B_PPM )  Then
  Begin

    CheckFile ( ParamDir.PPMDir + '\' + CatFile.PPMFileName  ) ;
    CheckFile ( ParamDir.PPMDir + '\' + CatFile.PPMKeyFileName  ) ;

    Assign    ( PPMFile    ,  ParamDir.PPMDir + '\' + CatFile.PPMFileName  ) ;
    Assign    ( PPMKeyFile ,  ParamDir.PPMDir + '\' + CatFile.PPMKeyFileName  ) ;

  End ; { PPM }



 If ( B_Sao )  Then
  Begin

    CheckFile ( ParamDir.PPMDir + '\' + CatFile.SaoFileName  ) ;
    CheckFile ( ParamDir.PPMDir + '\' + CatFile.SaoKeyFileName  ) ;

    Assign  ( SaoFile    , ParamDir.PPMDir + '\' + CatFile.SaoFileName    ) ;
    Assign  ( SaoKeyFile , ParamDir.PPMDir + '\' + CatFile.SaoKeyFileName ) ;

  End ; { Sao }



 If ( B_Npm )  Then
  Begin

    CheckFile ( ParamDir.NpmDir + '\' + CatFile.NpmFileName  ) ;
    CheckFile ( ParamDir.NpmDir + '\' + CatFile.NpmKeyFileName  ) ;

    Assign    ( NpmFile    ,  ParamDir.NpmDir + '\' + CatFile.NpmFileName  ) ;
    Assign    ( NpmKeyFile ,  ParamDir.NpmDir + '\' + CatFile.NpmKeyFileName  ) ;

  End ; { Npm }


 If ( B_NLtt )  Then
  Begin

    CheckFile ( ParamDir.NLttDir + '\' + CatFile.NLttFileName  ) ;
    CheckFile ( ParamDir.NLttDir + '\' + CatFile.NLttKeyFileName  ) ;

    Assign    ( NLttFile    ,  ParamDir.NLttDir + '\' + CatFile.NLttFileName  ) ;
    Assign    ( NLttKeyFile ,  ParamDir.NLttDir + '\' + CatFile.NLttKeyFileName  ) ;

  End ; { NLtt }


 If ( B_BS )  Then
  Begin
    CheckFile ( ParamDir.BsDir + '\' + 'Bs.Srt' ) ;
    CheckFile ( ParamDir.BsDir + '\' + 'Bs.Grn' ) ;
    CheckFile ( ParamDir.BsDir + '\' + 'Bs.Bin' ) ;
    Assign    ( BsFile    , ParamDir.BsDir + '\' + 'Bs.Srt' ) ;
    Assign    ( BsKeyFile , ParamDir.BsDir + '\' + 'Bs.Grn' ) ;
    Assign    ( BsSrcFile , ParamDir.BsDir + '\' + 'Bs.Bin' ) ;
  End ; { Bs }


 If ( B_Hd )  Then
  Begin
    CheckFile ( ParamDir.HdDir + '\' + CatFile.HdFileName     ) ;
    CheckFile ( ParamDir.HdDir + '\' + CatFile.HdKeyFileName  ) ;
    CheckFile ( ParamDir.HdDir + '\' + CatFile.HdEFileName    ) ;
    CheckFile ( ParamDir.HdDir + '\' + CatFile.HdEKeyFileName ) ;
    Assign    ( HdEFile    , ParamDir.HdDir + '\' + CatFile.HdEFileName    ) ;
  End ; { Hd }


 If ( B_A20 )  Then
  Begin
    CheckFile ( ParamDir.A20Dir + '\dates\' + 'nort.dat'  ) ;
    CheckFile ( ParamDir.A20Dir + '\dates\' + 'suth_a20.dat'  ) ;
    Assign    ( A20DateNFile , ParamDir.A20Dir + '\dates\' + 'nort.dat'  ) ;
    Assign    ( A20DateSFile , ParamDir.A20Dir + '\dates\' + 'suth_a20.dat'  ) ;
    If Exist ( ParamDir.A20Dir + '\dates\' + 'nort.dat' ) Then
      Reset  ( A20DateNFile  ) ;
    If Exist ( ParamDir.A20Dir + '\dates\' + 'suth_a20.dat' ) Then
      Reset  ( A20DateSFile  ) ;
  End ; { Hd }


 If ( B_Gcvs )  Then
  Begin

    B_Gcvs2000 := False ;

    {$I-}
    Assign ( Gcvs2000File, ParamDir.GcvsDir + '\' + CatFile.Gcvs2000FileName );
    FileMode := 0;
    Reset ( Gcvs2000File ) ;
    Close ( Gcvs2000File ) ;
    {$I+}
    If ( IOResult = 0 ) Then
      Begin
        CheckFile (               ParamDir.GcvsDir + '\' + CatFile.Gcvs2000FileName     ) ;
        Assign    ( Gcvs2000File, ParamDir.GcvsDir + '\' + CatFile.Gcvs2000FileName     ) ;
        CheckFile (               ParamDir.GcvsDir + '\' + CatFile.Gcvs2000KeyFileName  ) ;
        Assign    ( GcvsKeyFile,  ParamDir.GcvsDir + '\' + CatFile.Gcvs2000KeyFileName  ) ;
        B_Gcvs2000 := True ;
        JdCat [ CatGcvs ] := J2000 ;
      End ;

    If ( Not B_Gcvs2000 )  Then
      Begin
        CheckFile ( ParamDir.GcvsDir + '\' + CatFile.GcvsFileName    ) ;
        CheckFile ( ParamDir.GcvsDir + '\' + CatFile.GcvsKeyFileName ) ;
        JdCat [ CatGcvs ] := Jd50 ;
      End ;

  End ; { Gcvs }




 NameCatCdcExist := False ;
 B_Cdc_Cat       := False ;

 If ( B_Cdc )  Then
  Begin

     NameCatCdcExist     := False ;

        { p®¢¥pª  ­ «¨ç¨ï ª â «®£  AK }
        { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

     Assign ( CdcFile    , ParamDir.CdcDir + '\' + CatFile.CdcCatFileName ) ;
     Assign ( CdcKeyFile , ParamDir.CdcDir + '\' + CatFile.CdcKeyFileName ) ;
         {$I-}
     Reset   ( CdcFile  ) ;
         {$I+}
     B_Cdc_Cat := ( IoResult = 0 ) ;

     If ( B_Cdc_Cat )  Then
       Begin
          {$I-}
         FileMode := 0 ;
         Reset   ( CdcKeyFile  ) ;
          {$I+}
         B_Cdc_Cat := ( IoResult = 0 ) ;

         If ( B_Cdc_Cat )  Then
           NameCatCdcExist := True ;

       End ;

(*
     If  (    ( B_Det_Cdc              )
           Or (     ( B_Cdc         )
                And ( B_Import_Fld  )  )
           Or ( B_Cdc_Cat              )  )  Then
       Begin
         CheckFile ( 'E:\Catalog\NLTT\' + CatFile.NLTTFileName     ) ;
         CheckFile ( 'E:\Catalog\NLTT\' + CatFile.NLTTKeyFileName  ) ;
       End ;
*)
  End ; { Cdc }



(*
 If ( B_Gsc )  Then
  Begin
     NameDirGscOld    := ''    ;
     NameCatExist     := False ;
     NameCatTekExist  := False ;
  End ; { Gsc }
*)


 If ( B_Dm )  Then
  Begin
    If ( ParamDir.DmDir <> '' )
         Then  ParamDir.DmDir := ParamDir.DmDir + '\' ;

    CheckFile ( ParamDir.DmDir + '\' + CatFile.DmFileName    ) ;
    CheckFile ( ParamDir.DmDir + '\' + CatFile.DmKeyFileName ) ;

    Assign ( DmFile    ,  ParamDir.DmDir + '\' + CatFile.DmFileName    ) ;
    Assign ( DmKeyFile ,  ParamDir.DmDir + '\' + CatFile.DmKeyFileName ) ;

  End ; { Dm }


 If ( B_Ef_Sat_Cheb )  Then
   Begin
     CheckFile ( 'Efems.Stp' ) ;
     CheckFile ( 'Efems.Dat' ) ;
   End ;


 If ( Param.NGrImportBeg >= 0 )
    Then   NGrImport := Param.NGrImportBeg
    Else   NGrImport :=                  1 ;




            { ‡‹…Œ…’› ˆ’› ‘“’HˆŠ‚ }
            { ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ }



    If (     (       B_Surf  )
         And   B_Geoc
         And ( NPl0 = 3      )  )             { « ­¥â®æ¥­âp ‡¥¬«¨ }
      Then
        Begin
          B_Import_Sat := False ;
        End ;


 SatFileName := 'Fignia' ;

 If ( B_Import_Sat )
   Then
     Begin

       MatrixFileName := Param.PzsDir ;

       MatrixFileName := 'Sat_Elem\' ;

       SatFileName := Param.SatellitsDir ;
       For I := 1 To Length ( SatFileName )  Do
         SatFileName [ I ] := UpCase ( SatFileName [ I ] ) ;


       SatFileName := ParamDir.SatDir + '\' + SatFileName ;

       If (       SatElementsOld
            And ( SatFileNameOld <> SatFileName ) )  Then
         Begin

               CBlockSat := 0 ;

               If ( SatEartchPoint <> Nil )  Then
                 Begin
                   FreeMem ( SatEartchPoint,
                             MaxSatMark * SizeOf ( SatEartchPointType ) ) ;
                   SatEartchPoint := Nil ;
                 End ;

               SatElementsOld     := False ;
               SatFileNameOld     := ''    ;
               MaxSatellitsInFile :=     0 ;

         End ;

     End  { Import Sat }
   Else
     Begin
       If ( SatElementsOld )
         Then
           Begin

             CBlockPlanet := 0 ;

             While PlanetAllocFlag [ CBlock ] Do
                 Begin
                   FreeMem ( PlanetPtr [ CBlockSat ], SizeOf ( PlanetPtrType ));
                   PlanetAllocFlag [ CBlockPlanet ] := False ;
                   Inc ( CBlockPlanet ) ;
                 End;

             CBlockPlanet := 0 ;

             If ( SatEartchPoint <> Nil )  Then
               Begin
                 FreeMem ( SatEartchPoint,
                           MaxSatMark * SizeOf ( SatEartchPointType ) ) ;
                 SatEartchPoint := Nil ;
               End ;

             SatElementsOld     := False ;
             SatFileNameOld     := ''    ;
             MaxSatellitsInFile :=     0 ;

           End ;

     End ;

    {
    MaxSatellitsInFile :=     0 ;
    FlagSatElements    := False ;
    FlagSatEartchPoint := False ;
    FlagPlanet         := False ;
    }

    If (     ( B_Import_Sat                  )
         And ( SatFileNameOld <> SatFileName ) )  Then
      Begin { ReadSatEl }


         ReadSatFile ;
        {ÄÄÄÄÄÄÄÄÄÄÄ}

         CheckFile ( SatElementFileName ) ;

         If ( Not CatNotFound )  Then
           Begin  { Not CatNotFound }
             (*
             FileMode := 0 ;

             Reset  ( SatElemFile ) ;

             MaxSatellitsInFile := 0 ;

             While ( Not Eof ( SatElemFile ) )  Do
               Begin

                 Read ( SatElemFile, SatElementRec ) ;

                 Inc ( MaxSatellitsInFile ) ;

                 If ( MaxSatellitsInFile > MaxSatellits )  Then
                   Begin
                     Str ( MaxSatellits : 6, S ) ;
                     S := 'Number Satellit In File > '+ S ;
                     Fatal ( S );
                   End ;
               End ;
             *)

             SatElementsOld := True ;
             SatFileNameOld := SatFileName ;

             If (  MaxAvail - GraphBuffSize >
                  ( MaxSatellitsInFile * SizeOf ( SatElementsRecord ) +
                  ( MaxSatellitsInFile + 15 ) * SizeOf ( PlanetRecord ) ) )
               Then
                 Begin

                   GetMem ( SatEartchPoint ,
                            MaxSatMark * SizeOf ( SatEartchPointType ) ) ;

                 End
               Else
                 Begin
                   Fatal ( 'Not Memory for Satellits ');
                 End ;


             (*
             FileMode := 0 ;

             Reset ( SatElemFile ) ;
             NSat := 0 ;

             While ( Not Eof ( SatElemFile ) )  Do
               Begin

                 Read ( SatElemFile, SatElementRec ) ;

                 Inc ( NSat ) ;

                 Jd0  := SatElementRec.T0   ;
                 ISat := SatElementRec.ISat ;
                 OmG  := SatElementRec.OmG  ;
                 Eksc := SatElementRec.Eksc ;
                 OmL  := SatElementRec.OmL  ;
                 M0   := SatElementRec.M0   ;
                 Mot  := SatElementRec.Mot  ;
                 Mot1 := SatElementRec.Mot1 ;


                 { •€ ‹…Œ…H’‚ NSat }
                 { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                 Year := DateEl.Year ;
                 If ( Year < 100 )  Then
                   Begin
                     If ( Year < 50 )
                       Then  Year := Year + 2000
                       Else  Year := Year + 1900 ;
                   End ;

                 JD8 ( Year, DateEl.Month, DateEl.Day,  JD0 ) ;

                 T := (   TIMEEL.Hour
                        + TIMEEL.Min  /   C600
                        + TIMEEL.Sec  / C36000 ) / 24.0 ;

                 JD0 := JD0 + T ;

                 ISAT   := ISAT    * GR ;
                 OMG    := OMG     * GR ;
                 OML    := OML     * GR ;
                 ARGLAT := ARGLAT  * GR ;

                 M0     := ArgLat       ;

                 A0     := ( HAp + HPer  ) / C20 + R_Planets [ Abs ( NPlSat ) ] ;
                 EKSC   := ( HAp - HPer  ) /
                           ( HAp + HPer + C20 * R_Planets [ Abs ( NPlSat ) ] ) ;


                  { ‚›—ˆ‘‹…Hˆ… M0  OML ˆ ARGLAT }
                  { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                 SQRCalCons   := Sqrt   ( C10 - EKSC * EKSC  ) ;
                 BETCalCons   := EKSC / ( C10 + SQRCalCons   ) ;
                 BETSKCalCons := C10 ;
                 VCalCons     := ARGLAT - OML ;
                 M0           := VCalCons     ;

                 For KCalCons :=  1  To  10  Do
                   Begin

                     BETSKCalCons := BETSKCalCons * ( - BETCalCons ) ;

                     M0 := M0 + C20 * ( SQRCalCons + C10 / KCalCons )
                                    *   BETSKCalCons
                                    *    Sin ( KCalCons * VCalCons ) ;

                   End ;   { CALC M0 }
                 *)
                 (*
                 If (    ( BlockAllocFlag [ CBlock ] )
                      Or ( AllocBlock                )  )  Then

                   With ObjectPtr [ NSat Div BlockSize ]^
                                  [ NSat Mod ObjectBlockSize ] Do
                 SatElements^[ NSat ].NSat  :=  NSat    ;
                 SatElements^[ NSat ].T0    :=  JD0     ;
                 SatElements^[ NSat ].EKSC  :=  EKSC    ;
                 SatElements^[ NSat ].ISAT  :=  ISAT    ;
                 SatElements^[ NSat ].OMG   :=  OMG     ;
                 SatElements^[ NSat ].OML   :=  OML     ;
                 SatElements^[ NSat ].M0    :=  M0      ;
                 SatElements^[ NSat ].Mot   :=  Mot     ;
                 SatElements^[ NSat ].Mot1  :=  Mot1    ;

               End ; { While Not Eof ( SatFile ) }
                     { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }


             SatElementsOld := True ;
             SatFileNameOld := SatFileName ;

             Close ( SatElemFile ) ;
             *)

           End ; { Not CatNotFound }

      End  { ReadSatEl }

     Else

      Begin  { Not ReadSatEl }


        If ( Not B_Import_Sat )  Then
          Begin

            If ( MaxSatellitsInFile <> 0 )  Then
              Begin

                If ( SatEartchPoint <> Nil )  Then
                  Begin
                    FreeMem ( SatEartchPoint ,
                              MaxSatMark * SizeOf ( SatEartchPointType ) ) ;
                    SatEartchPoint := Nil ;
                  End ;


                CBlockPlanet := 0 ;

                While PlanetAllocFlag [ CBlockPlanet ] Do
                  Begin
                    FreeMem ( PlanetPtr [ CBlockPlanet ], SizeOf ( PlanetArrType ));
                    PlanetAllocFlag [ CBlockPlanet ] := False ;
                    Inc ( CBlockPlanet ) ;
                  End;

                CBlockPlanet := 0 ;
                MaxSatellitsInFile :=   0 ;

              End ;

          End ;

      End ;  { Not ReadSatEl }


    If (     ( B_Import_Sat         )
         And ( SatEartchPoint = Nil ) )  Then
      Begin
        GetMem ( SatEartchPoint ,
                 MaxSatMark * SizeOf ( SatEartchPointType ) ) ;
      End ;

    MaxPlanets := MaxSatellitsInFile + 15 ;


    (*
    {  ¬ïâì ¯®¤ « ­¥âë }
    { ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ }

    If ( MaxAvail - GraphBuffSize ) >
         MaxPlanets * SizeOf ( PlanetRecord )  Then
      Begin
        GetMem ( Planet, MaxPlanets * SizeOf ( PlanetRecord ) ) ;
      End ;
    *)

        { ®¤£®â®¢ª  Œ â¥p¨ª®¢ }
        { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }
    NumPointMateriki  :=     0 ;
    IRecpr            :=     0 ;
    ColorPixel        :=     0 ;




              {  ª¢ â®p  }
              {  ÍÍÍÍÍÍÍ  }

    Ry := Pi / 180.0 ;

    GetMem ( Ekv , SizeOf ( EkvArr ) );

    If ( Ekv = Nil )  Then
      Fatal ( 'No Memory For Equator Array' ) ;

    If ( Ekv <> Nil )  Then
     For I := 1  To  362  Do
      Begin

        RX := I * Ry ;  { Long }

        Ekv^[ I ].X := Round ( Cos ( RX ) * R_Planets [3] * 100000.0 ) ;
        Ekv^[ I ].Y := Round ( Sin ( RX ) * R_Planets [3] * 100000.0 ) ;
        Ekv^[ I ].Z := 0                                               ;

      End ;




    If (     ( MaxAvail-GraphBuffSize > SizeOf ( MaterikiArr )  )
         And (    ( Not ( B_Surf ) Or ( Param.NPl0 <> 3 ) )
               Or ( B_From_Star                           )     )
       )
      Then
        Begin  {  ¬ïâ¨ ¤®áâ â®ç­® }
               { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

          If Exist ( 'World.Dat' )  Then
            Begin  { …áâì ä ©« World.Dat }
                   { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

              GetMem ( Materiki , SizeOf ( MaterikiArr ) );

              FileMode := 0 ;

              Assign ( MaterikiFile , 'World.Dat' ) ;
              Reset  ( MaterikiFile               ) ;


                  { —â¥­¨¥ ä ©«  Œ â¥p¨ª®¢ }
                  { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

              PBeg := 0 ;

              While ( Not Eof ( MaterikiFile ) )   Do
                Begin

                  ReadLn ( MaterikiFile , WS ) ;

                  CoordExist := False ;

                  For N := 1 To Length ( WS )  Do
                    If ( WS [ N ] <> ' ' ) Then
                       CoordExist := True ;


                  If ( Ws [ 1 ] = '*' )  Then
                    Begin
                      ColorPixel := 3     ;
                      CoordExist := False ;
                    End ;


                  If ( Ws [ 1 ] = '=' )  Then
                    Begin
                      ColorPixel := 5     ;
                      CoordExist := False ;
                    End ;


                  If  ( Not  CoordExist )   Then

                    Begin  { ãáâ ï áâp®ª  }
                           { ÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                      If ( ColorPixel <> 5 ) Then
                        Materiki^[ NumPointMateriki ].E := 1 ;

                    End    { ãáâ ï áâp®ª  }
                           { ÄÄÄÄÄÄÄÄÄÄÄÄÄ }
                   Else

                    Begin  { ‘âp®ª  ª®®p¤¨­ â }
                           { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                      While  ( Ws [ 1 ] = ' ' )  Do
                         Delete ( WS , 1 , 1 ) ;

                      N := Pos ( ' ', WS ) ;

                      WS1 := Copy ( WS , 1 , N-1 ) ;
                      Val ( WS1 , RX , Code ) ;        { Long }


                      Delete ( WS , 1 , N ) ;

                      While  ( Ws [ 1 ] = ' ' )  Do
                        Delete ( WS , 1 , 1 ) ;


                      N := Pos ( ' ', WS ) ;

                      If ( N > 0 )  Then
                        WS := Copy ( WS , 1 , N-1 ) ;

                      Val ( WS , RY , Code ) ;        { Lat }

                      RX := RX * GR ;  { Long }
                      RY := RY * GR ;  { Lat  }
                      RH := C10 ;
                      {
                      RH := 0.99832707 + 0.00167644 * Cos ( C20 * RY ) -
                                         0.00000352 * Cos ( 4.0 * RY )   ;
                      }

                      Inc ( NumPointMateriki ) ;

                      If ( NumPointMateriki > 3000 ) Then
                        Fatal ( 'Number of point array WORLD > 3000' ) ;


                      Materiki^[ NumPointMateriki ].X :=
                        Round (   R_Planets [3] * RH
                                * Cos ( RX ) * Cos ( RY ) * 5 ) ;

                      Materiki^[ NumPointMateriki ].Y :=
                        Round (   R_Planets [3] * RH
                                * Sin ( RX ) * Cos ( RY ) * 5 ) ;

                      Materiki^[ NumPointMateriki ].Z :=
                        Round (   R_Planets [3] * RH * Sin ( RY ) * 5 ) ;

                      Materiki^[ NumPointMateriki ].E := ColorPixel ;

                    End ;   { ‘âp®ª  ª®®p¤¨­ â }
                            { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                End ; { While Not Eof ( MaterikiFile ) }
                      { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

              Close  ( MaterikiFile  ) ;


            End ;  { …áâì ä ©« World.Dat }
                   { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }



        End    {  ¬ïâ¨ ¤®áâ â®ç­® }
               { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

      Else

        Begin  {  ¬ïâ¨ ­¥¤®áâ â®ç­® }
               { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }
        End ;  {  ¬ïâ¨ ­¥¤®áâ â®ç­® }
               { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }






 If ( B_Import_Fld )  Then
  Begin

    ReadFormatImp ;

    FileMode := 2 ;
    Assign  ( OutStarFile , 'OSF.TXT' ) ;
    Rewrite ( OutStarFile ) ;
    FileMode := 0 ;

    If ( B_ObjOut )  Then
      Begin

        Assign  ( ObjectOutFile , ObjectOutFileName ) ;

        FileMode := 2 ;
        If (     ( NGrImportBeg > 1                       )
             And ( FSearch ( ObjectOutFileName ,'') <> '' )  )
          Then
            Begin
              Append  ( ObjectOutFile      ) ;
              Writeln ( ObjectOutFile , '' ) ;
            End
          Else
            Rewrite ( ObjectOutFile ) ;

        FileMode := 0 ;

      End ;

    If (    ( B_ObjOut )
         Or ( B_Export )  )  Then
      Begin
        FileMode := 2 ;
        Assign  ( OutDetFile  , 'ODF.TXT' ) ;
        Rewrite ( OutDetFile              ) ;
        FileMode := 0 ;
      End ;


    Assign  ( ObjectFile , ObjectFileName ) ;
    FileMode := 0 ;
    Reset   ( ObjectFile ) ;

    NOF        := 0 ;

    NGrImport  := 0 ;
    RDetImp    := Param.RDetImp  ;
    If ( RDetImp < 0 )
      Then
        Begin
          RDetImp := Abs ( RDetImp ) ;
          If ( B_Det_Imp )
            Then  B_Stop_All := True
            Else  B_Stop_All := False ;
        End
      Else
          B_Stop_All := False ;




        { ®¤¢®¤ ­ ç «ì­®© £pã¯¯ë }
        { ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ }

    N        := 0     ;
    OldPusto := True  ;

    If (     ( NGrImportBeg >= 1    )
         And ( Not ( B_Inport_Ccd ) )  )  Then
      Begin

        While (      ( N < NGrImportBeg - 1    )
                 And ( Not Eof ( ObjectFile )  )  )  Do
          Begin

            ReadLn ( ObjectFile , ObjectString ) ;

            NN    := Length  ( ObjectString ) ;
            I     := 1     ;
            CExit := False ;
            Pusto := True  ;

              { p®¢¥pª  ­ «¨ç¨ï ª®®p¤¨­ â ¢ áâp®ª¥ }
              { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

            While  ( ( I <= NN ) And ( Not CExit ) )  Do
              Begin
                Cs := ObjectString [ I ] ;
                If ( Cs <> ' ' )  Then
                  Begin { H ©¤¥­ á¨¬¢®« <> ' ' }
                    CExit := True ;
                    If ( ( Cs < '0' )  Or  ( Cs > '2' ) )
                      Then  Pusto := True
                      Else  Pusto := False ;
                  End ;
                I := I + 1 ;
              End ;


            If ( NStarGrMax = 1 )
              Then
                Begin  { ® 1 §¢¥§¤¥ }
                       { ÄÄÄÄÄÄÄÄÄÄÄ }
                  If ( Not Pusto )  Then
                    Inc ( N ) ;
                End    { ® 1 §¢¥§¤¥ }
              Else
                Begin  { ® £pã¯¯¥ §¢¥§¤ }
                       { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }
                  If (     ( Pusto            )
                       And ( Not ( OldPusto ) )  )
                    Then
                      Begin { ãáâ ï áâp®ª  ¯®á«¥ £pã¯¯ë }
                        Inc ( N ) ;
                      End ;
                  OldPusto := Pusto ;
                End ;  { ® £pã¯¯¥ §¢¥§¤ }

          End ;


        NGrImport := NGrImportBeg - 1 ;

      End
     Else
      Begin
        NGrImport := 0 ;
      End ;


    FileMode := 2 ;
    Assign  ( ImportStarFile , 'ISF.TXT' ) ;
    Rewrite ( ImportStarFile ) ;
    FileMode := 0 ;


  End ; { Import Fld }


 {
 MatrixFileName := 'fignia' ;

 If ( B_Matrix )  Then
    MatrixFileName := Param.PzsDir ;
 }


       {  —’…Hˆ… Šˆ‚‰ ˆ‚…„…HˆŸ Š ‘ˆ‘’…Œ… ”’ˆ…ŒHˆŠ€  }
       {  ************************************************  }

 If ( B_FOT_SYS )  Then
  Begin  { B_FOT_SYS }

      ParamFileName := Param.FotSysDir ;
      CheckFile ( ParamFileName ) ;
      If ( Not CatNotFound )  Then
        Begin
          Assign ( ParamFile, ParamFileName ) ;
          FileMode := 0 ;
          Reset ( ParamFile ) ;
          For I := 1 To 70 Do
            ReadLn ( ParamFile, SpKl, DMv [ I ] ) ;
          Close ( ParamFile ) ;
        End ;

  End ;  { B_FOT_SYS }

 DirCatNotFound : ;

 FileMode := 2 ;

 End ;  { RDParam }

End.


