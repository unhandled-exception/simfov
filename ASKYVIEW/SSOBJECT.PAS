{$F+,O+}

Unit SSObject;

Interface

Uses SSVar, TDialogs, TStdObj, SSError, TMsgWin;

Procedure SetObject ( Title          : String  ;
                      Var CP         : Byte    ;
                      Var SputnikNum : Integer ;
                      TerraFlag      : Boolean ;
                      SatellitFlag   : Boolean ;
                      DmExecFlag     : Boolean  ) ;


Implementation

Uses PVar, PProFld, PATan2, Crt, V_Catal ;


Function FileExists ( FileName: String): Boolean;
{ Boolean function that returns True If the file exists;
  otherwise, it returns False. Closes the file If it exists. }
Var
 F : File;
Begin
 {$I-}
 Assign ( F , FileName ) ;
 FileMode := 0;  { Set file access to read only }
 Reset ( F ) ;
 Close ( F ) ;
 {$I+}
 FileExists :=     ( IOResult =  0  )
               And ( FileName <> '' ) ;
End;  { FileExists }



Procedure SetObject ( Title          : String  ;
                      Var CP         : Byte    ;
                      Var SputnikNum : Integer ;
                      TerraFlag      : Boolean ;
                      SatellitFlag   : Boolean ;
                      DmExecFlag     : Boolean  ) ;



Label BegDialog;


Var

  Dialog   : PDialog ;

  Bruce    : PView   ;

  R        : TRect   ;
  RR       : Double  ;

  ExitCode : Word    ;

  y,k,m,
  OO       : Byte    ;
  EFlag    : Boolean ;
  GscMult  : Boolean ;
  NMult    : Byte    ;

  FlagFindGsc,
  FlagFindSao,
  FlagFindDm,
  NumExist,
  NumberMultError,
  SrtFileExist,
  NumFileExist        : Boolean ;


  Mv { * 10 }         : Integer ;
  RaH, RaM            : Integer ;
  RaS                 : Double  ;
  DeclSig             : Char    ;
  DeclG, DeclM        : Integer ;
  DeclS               : Double  ;
  N,
  AdrMult             : LongInt ;

  GSCKeyRecord        : KeyType ;





  { ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ }





     Procedure SaoNumb (     DmStr, NameDir      : String  ;
                         Var RaH, RaM            : Integer ;
                         Var RaS                 : Double  ;
                         Var DeclSig             : Char    ;
                         Var DeclG, DeclM        : Integer ;
                         Var DeclS               : Double  ;
                         Var Flag                : Boolean   ) ;


Type

  SaoNumType = Record
                 Ra,                  { In Radians.                   }
                 Decl     : Single  ; { Ra > 10.0 - Number Not Exist  }
               End ;


Var

  S, S1      : String             ;

  I,
  Code       : Integer            ;

  Sao        : LongInt            ;

  CNeg       : Boolean            ;

  SaoNumFile : File Of SaoNumType ;
  SaoNumRec  :         SaoNumType ;

Begin


  S1      := DmStr ;
  RaH     := 0     ;
  RaM     := 0     ;
  RaS     := 0.0   ;
  DeclSig := ' '   ;
  DeclG   := 0     ;
  DeclM   := 0     ;
  DeclS   := 0     ;

  NumExist     := False ;
  NumFileExist := False ;
  Flag         := False ;


   { è•p•¢Æ§ ¢ °Æ´ÏË®• °„™¢Î }

  For I := 1 To Length ( S1 ) Do
    S1 [ I ] := UpCase ( S1 [ I ] ) ;


   { ì§†´•≠®• ¢·•£Æ §Æ Ø•p¢Æ© Ê®‰pÎ }

  While (     ( Length ( S1 ) >   0  )
          And (     ( S1 [ 1 ]  < '0' )
                Or  ( S1 [ 1 ]  > '9' ) )  )  Do
    Delete ( S1, 1, 1 ) ;


   { ì§†´•≠®• Â¢Æ·‚† }

  While (     ( Length ( S1 ) >  0                 )
          And (    ( S1 [ Length ( S1 ) ] < '0' )
                Or ( S1 [ Length ( S1 ) ] > '9' )  )
                                                        )  Do
    Delete ( S1, Length ( S1 ), 1 ) ;


  S := NameDir ;
  If ( S [ LengTh ( S ) ] <> '\' )  Then
    S := S + '\' ;
  S := S + 'Sao.Num';

  If ( FileExists ( S ) )  Then
    NumFileExist := True ;


  Val ( S1, Sao, Code ) ;
  If  (     ( Code = 0              )
        And ( S1   <> ''            )
        And ( FileExists ( S )      )
        And (     ( Sao >      0 )
              And ( Sao < 258997 )  )  )  Then
    Begin


      Assign ( SaoNumFile,  S  ) ;
      Reset  ( SaoNumFile      ) ;

      Seek   ( SaoNumFile, Sao - 1   ) ;
      Read   ( SaoNumFile, SaoNumRec ) ;
      Close  ( SaoNumFile ) ;

      If (  Abs ( SaoNumRec.Ra ) < 9.0 )  Then
        Begin

          Flag      := True  ;
          NumExist  := True  ;

                              { R.A. }
                              { ƒƒƒƒ }
          RadToHMS ( SaoNumRec.Ra, RaH, RaM, RaS );

                              { Decl }
                              { ƒƒƒƒ }
          RadToGMS ( SaoNumRec.Decl, CNeg, DeclG, DeclM, DeclS );
          If ( CNeg )
            Then DeclSig := '-'
            Else DeclSig := '+' ;

        End ;

    End ;

End ;






  { ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ }




     Procedure GscNumb (     DmStr, NameDir      : String  ;
                         Var RaH, RaM            : Integer ;
                         Var RaS                 : Double  ;
                         Var DeclSig             : Char    ;
                         Var DeclG, DeclM        : Integer ;
                         Var DeclS               : Double  ;
                         Var Flag                : Boolean   ) ;



 Type

    NumGscType = Record
                   NumZoneGsc    : Byte ; { NumZoneGsc * 10 + NumDeclInZone }
                   NumRAInZone   : Byte ; { NumRa Div 4                     }
                   NumStar       : Word ; { NumStar * 4 + NumRa Mod 4       }
                 End ;

    OutType   = Array [ 1 .. 30 ]  Of Char ;

 Label
    EndNameGsc ;

 Const

     ConstDSinGSC = Trunc ( 65535.0 / 2.0 /
         ( 1.25 * 3600.0 / 206264.8062470964 / 2.0 ) ) ;


     NPlateGscMax = 9537 ;

     NameDirGsc : Array [ 1 .. 24 ] Of String [ 8 ] =
       (
           'N8230\',
           'N7500\',
           'N6730\',
           'N6000\',
           'N5230\',
           'N4500\',
           'N3730\',
           'N3000\',
           'N2230\',
           'N1500\',
           'N0730\',
           'N0000\',
           'S0000\',
           'S0730\',
           'S1500\',
           'S2230\',
           'S3000\',
           'S3730\',
           'S4500\',
           'S5230\',
           'S6000\',
           'S6730\',
           'S7500\',
           'S8230\'
       ) ;

   DeclZoneGsc : Array [ 1 .. 24 ] Of Double =
       (
           +82.5,
           +75.0,
           +67.5,
           +60.0,
           +52.5,
           +45.0,
           +37.5,
           +30.0,
           +22.5,
           +15.0,
           +07.5,
           +00.0,
           -00.0,
           -07.5,
           -15.0,
           -22.5,
           -30.0,
           -37.5,
           -45.0,
           -52.5,
           -60.0,
           -67.5,
           -75.0,
           -82.5
       ) ;



 Var

    ChOut            :         OutType   ;
    ChOutBuf         :         OutType   ;

    S, S1, S2        : String [ 80 ] ;
    NameGscSrt,
    NameGscAdd,
    NameGscKey,
    NameGscGrani,
    NameGscNumber,
    NameGscBin       : String [ 80 ] ;

    CNeg             : Boolean ;

    Code             : Integer ;


    NPlate,
    NStar,
    DeclG1,
    NumZone,
    NumRa,
    NumDecl,
    NumStar,
    NumKey,
    ZoneDecl,
    NBinStar,
    Adr,
    N1, N2,
    I, J, K
                       : LongInt ;

    RaStar,
    DeclStar           : Double  ;

    ADECC,
    DECCKR, SDD,
    RAMIN, RAMax,
    RAMIN1, RAMax1,
    RAMIN2, RAMax2,
    R0, DRA, DECTEK,
    SRAFILD, CRAFILD,
    SDECFILD, CDECFILD,
    SDRA, CDRA,
    SDDEC, CDDEC,
    SRAST, CRAST,
    SDECST, CDECST,
    R                  : Double  ;

    GscNumFile         : File Of NumGscType ;
    GscMultFile        : File Of NumGscType ;
    KeyPlateGscFile    : File Of    KeyType ;

    GSCFile            : File Of GSCType    ;
    GSCKeyFile         : File Of KeyType    ;
    GSCRecord          : GSCType            ;

    GscNumRecord       : NumGscType ;
    GscMultRecord      : NumGscType ;
    KeyPlateGscRecord  :    KeyType ;
    KeyPlateGscRecord2 :    KeyType ;


{          ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹          }


Begin

  Flag            := False ;
  GscMult         := False ;
  NumberMultError := False ;
  NumExist        := False ;
  NMult           := 0     ;


  S1      := DmStr ;
  RaH     := 0     ;
  RaM     := 0     ;
  RaS     := 0.0   ;
  DeclSig := ' '   ;
  DeclG   := 0     ;
  DeclM   := 0     ;
  DeclS   := 0     ;


   { è•p•¢Æ§ ¢ °Æ´ÏË®• °„™¢Î }

  For I := 1 To Length ( S1 ) Do
    S1 [ I ] := UpCase ( S1 [ I ] ) ;

   { ì§†´•≠®• ¢·•£Æ §Æ Ø•p¢Æ© Ê®‰pÎ }

  While (     ( Length ( S1 ) >   0  )
          And (     ( S1 [ 1 ]  < '0' )
                Or  ( S1 [ 1 ]  > '9' ) )  )  Do
    Delete ( S1, 1, 1 ) ;



    { èp®ß≠†™ §¢Æ©·‚¢•≠≠Æ·‚® ≠Æ¨•p† }

  AdrMult := 0 ;

  J := Pos ( 'A', S1 ) ;
  If ( J > 0 )
    Then
      Begin
        S1 [ J ] := ' ' ;
        AdrMult := 1 ;
      End
    Else
      Begin
        J := Pos ( 'B', S1 ) ;
        If ( J > 0 )
          Then
            Begin
              S1 [ J ] := ' ' ;
              AdrMult := 2 ;
            End
          Else
            Begin
              J := Pos ( 'C', S1 ) ;
              If ( J > 0 )
                Then
                  Begin
                    S1 [ J ] := ' ' ;
                    AdrMult  := 3   ;
                  End ;
{
                Else
                    AdrMult := 4 ;
}
            End ;
      End ;



   { HÆ¨•p è´†·‚®≠™® ® á¢•ß§Î }

  S2 := '' ;
  While (     ( Length ( S1 ) >   0  )
          And (    (       S1 [ 1 ]   = '.'   )
                Or (     ( S1 [ 1 ]  >= '0' )
                     And ( S1 [ 1 ]  <= '9' ) ) ) )  Do
    Begin
      S2 := S2 + Copy ( S1, 1, 1 ) ;
      Delete ( S1, 1, 1 ) ;
    End ;

  If ( S2 = '' )  Then
    GoTo EndNameGsc ;


  Val ( S2, R, Code ) ;


  NPlate := Trunc ( R ) ;
{
  NStar  := Round ( Frac  ( R ) * 10000 ) ;
}
  J := Pos ( '.', S2 ) ;
  Delete ( S2, 1, J ) ;
  Val ( S2, NStar, Code ) ;


  S := NameDir ;
  If ( S [ LengTh ( S ) ] <> '\' )  Then
    S := S + '\' ;

  NameGscNumber := S + 'Numbers\GscNum.Adr'   ;
  NameGscGrani  := S + 'Numbers\GscPlNum.Grn' ;
  NameGscBin    := S + 'Numbers\GscPlNum.Bin' ;


  If (     FileExists ( NameGscNumber )
       And FileExists ( NameGscGrani  )
       And FileExists ( NameGscBin    )  )  Then
    Begin { NumFileExists }

      NumFileExist := True ;

      Assign ( GscNumFile,      NameGscNumber ) ;
      Reset  ( GscNumFile                     ) ;

      Assign ( KeyPlateGscFile, NameGscGrani  ) ;
      Reset  ( KeyPlateGscFile                ) ;

      GscNumRecord.NumZoneGsc := 0 ;
      J := FileSize ( KeyPlateGscFile ) ;
      If ( NPlate < J )  Then
        Begin

          Seek ( KeyPlateGscFile, NPlate - 1 ) ;
          Read ( KeyPlateGscFile, KeyPlateGscRecord  ) ;
          Read ( KeyPlateGscFile, KeyPlateGscRecord2 ) ;


          If ( NStar < (   KeyPlateGscRecord2.NBeg
                         - KeyPlateGscRecord.NBeg  -1 ) )  Then
            Begin
              Seek ( GscNumFile, KeyPlateGscRecord.NBeg + NStar ) ;
              Read ( GscNumFile, GscNumRecord                   ) ;
            End ;

        End ;

      If ( GscNumRecord.NumZoneGsc = 0 )
      Then
        Begin
          NumExist := False ;
        End
      Else
      If ( GscNumRecord.NumZoneGsc <> 255 )
        Then
          Begin { Mono Number }
(*
            NumZoneGsc    : Byte ; { NumZoneGsc * 10 + NumDeclInZone }
            NumRAInZone   : Byte ; { NumRa Div 4                     }
            NumStar       : Word ; { NumStar * 4 + NumRa Mod 4       }
*)

            NumExist := True ;

            If ( AdrMult > 0 )  Then
              NumberMultError := True ;

            NumZone := GscNumRecord.NumZoneGsc Div 10   ;
            NumRa   := GscNumRecord.NumRaInZone *   4 +
                       GscNumRecord.NumStar    Mod  4   ;
            NumDecl := GscNumRecord.NumZoneGsc Mod 10   ;
            NumStar := GscNumRecord.NumStar    Div  4   ;

            NameGscSrt := S + NameDirGsc [ NumZone ] + 'Gsc.Srt'   ;
            NameGscKey := S + NameDirGsc [ NumZone ] + 'Gsc.Grn'   ;


            NumKey  := ( 24 - NumZone ) * 1728 ;
            NumKey  := NumKey + ( 288 * NumDecl + NumRa ) ;

            If (     ( FileExists ( NameGscKey ) )
                 And ( FileExists ( NameGscSrt ) )  )
              Then  SrtFileExist := True
              Else  SrtFileExist := False ;


            If (     ( SrtFileExist        )
                 And ( Not NumberMultError )
                                              )  Then
              Begin

                Flag    := True  ;
                GscMult := False ;

                Assign ( GscKeyFile, NameGscKey ) ;
                ReSet  ( GscKeyFile             ) ;

                Assign ( GscFile,    NameGscSrt ) ;
                ReSet  ( GscFile                ) ;

                Seek   ( GscKeyFile, NumKey - 1   ) ;
                Read   ( GscKeyFile, GscKeyRecord ) ;

                Seek   ( GscFile, GscKeyRecord.NBeg + NumStar - 1 ) ;
                Read   ( GscFile, GscRecord ) ;

                          { äÆÆp§®≠†‚Î }

                N := ( NumKey - 1 ) Mod 288 + 1 ;

                SRaFild := SinRaFild [ N ] ;
                CRaFild := CosRaFild [ N ] ;

                SDecFild := SinDecFild [ ( NumKey - 1 ) Div 288 + 1 ] ;
                CDecFild := Sqrt ( 1.0 - SDecFild * SDecFild ) ;

                SDRA   := GSCRecord.SDRA  / ConstDSinGsc ;
                SDDEC  := GSCRecord.SDDEC / ConstDSinGsc ;

                CDRA   := SQRT ( 1.0 - SDRA  * SDRA  ) ;
                CDDEC  := SQRT ( 1.0 - SDDEC * SDDEC ) ;

                SRaSt  := SRAFILD  * CDRA  + CRAFILD  * SDRA  ;
                CRaSt  := CRAFILD  * CDRA  - SRAFILD  * SDRA  ;

                SDecSt := SDECFILD * CDDEC + CDECFILD * SDDEC ;
                CDecSt := CDECFILD * CDDEC - SDECFILD * SDDEC ;

                              { R.A. }
                              { ƒƒƒƒ }
                RaStar := ATan2 ( SRaSt, CRaSt ) ;
                RadToHMS ( RaStar, RaH, RaM, RaS );

                              { Decl }
                              { ƒƒƒƒ }
                DeclStar := ArcTan ( SDecSt/CDecSt ) ;
                RadToGMS ( DeclStar, CNeg, DeclG, DeclM, DeclS );
                If ( CNeg )
                  Then DeclSig := '-'
                  Else DeclSig := '+' ;

                Close  ( GscFile    ) ;
                Close  ( GscKeyFile ) ;

              End ;

          End   { Mono Number }
        Else
          Begin { Mult Number }
(*
            NumZoneGsc    : Byte ; { 255 = BinNumber        }
            NumRAInZone   : Byte ; { NComponent             }
            NumStar       : Word ; { Adr Groupe In BinFile  }
*)

            Adr := GscNumRecord.NumStar ;
            If ( AdrMult > 0 )  Then
              Adr := Adr + ( AdrMult - 1 ) ;

            NMult := GscNumRecord.NumRAInZone ;

            If (     ( FileExists ( NameGscBin ) )
                 And ( AdrMult <= NMult          ) )  Then
              Begin

                NumExist := True ;

                Assign ( GscMultFile, NameGscBin    ) ;
                Reset  ( GscMultFile                ) ;
                Seek   ( GscMultFile, Adr           ) ;
                Read   ( GscMultFile, GscNumRecord  ) ;

                NumZone := GscNumRecord.NumZoneGsc Div 10   ;
                NumRa   := GscNumRecord.NumRaInZone *   4 +
                           GscNumRecord.NumStar    Mod  4   ;
                NumDecl := GscNumRecord.NumZoneGsc Mod 10   ;
                NumStar := GscNumRecord.NumStar    Div  4   ;

                NameGscSrt := S + NameDirGsc [ NumZone ] + 'Gsc.Srt'   ;
                NameGscKey := S + NameDirGsc [ NumZone ] + 'Gsc.Grn'   ;

                NumKey  := ( 24 - NumZone ) * 1728 ;
                NumKey  := NumKey + ( 288 * NumDecl + NumRa )  ;

                NameGscSrt := S + NameDirGsc [ NumZone ] + 'Gsc.Srt'   ;
                NameGscKey := S + NameDirGsc [ NumZone ] + 'Gsc.Grn'   ;
{
                NameGscAdd := S + NameDirGsc [ NumZone ] + 'Gsc.Add'   ;
}

                If (     ( FileExists ( NameGscKey ) )
                     And ( FileExists ( NameGscSrt ) )  )
                  Then  SrtFileExist := True
                  Else  SrtFileExist := False ;


                If ( SrtFileExist )  Then
                  Begin

                    Flag    := True  ;

                    If ( AdrMult = 0 )
                      Then GscMult := True
                      Else GscMult := False ;


                    Assign ( GscKeyFile, NameGscKey ) ;
                    ReSet  ( GscKeyFile             ) ;

                    Assign ( GscFile,    NameGscSrt ) ;
                    ReSet  ( GscFile                ) ;

                    Seek   ( GscKeyFile, NumKey - 1   ) ;
                    Read   ( GscKeyFile, GscKeyRecord ) ;

                    Seek   ( GscFile, GscKeyRecord.NBeg + NumStar - 1 ) ;
                    Read   ( GscFile, GscRecord ) ;

                          { äÆÆp§®≠†‚Î }

                    N := ( NumKey - 1 ) Mod 288 + 1 ;

                    SRaFild := SinRaFild [ N ] ;
                    CRaFild := CosRaFild [ N ] ;

                    SDecFild := SinDecFild [ ( NumKey - 1 ) Div 288 + 1 ] ;
                    CDecFild := Sqrt ( 1.0 - SDecFild * SDecFild ) ;

                    SDRA   := GSCRecord.SDRA  / ConstDSinGsc ;
                    SDDEC  := GSCRecord.SDDEC / ConstDSinGsc ;

                    CDRA   := SQRT ( 1.0 - SDRA  * SDRA  ) ;
                    CDDEC  := SQRT ( 1.0 - SDDEC * SDDEC ) ;

                    SRaSt  := SRAFILD  * CDRA  + CRAFILD  * SDRA  ;
                    CRaSt  := CRAFILD  * CDRA  - SRAFILD  * SDRA  ;

                    SDecSt := SDECFILD * CDDEC + CDECFILD * SDDEC ;
                    CDecSt := CDECFILD * CDDEC - SDECFILD * SDDEC ;

                              { R.A. }
                              { ƒƒƒƒ }
                    RaStar := ATan2 ( SRaSt, CRaSt ) ;
                    RadToHMS ( RaStar, RaH, RaM, RaS );

                              { Decl }
                              { ƒƒƒƒ }
                    DeclStar := ArcTan ( SDecSt/CDecSt ) ;
                    RadToGMS ( DeclStar, CNeg, DeclG, DeclM, DeclS );
                    If ( CNeg )
                      Then DeclSig := '-'
                      Else DeclSig := '+' ;

                    Close  ( GscFile    ) ;
                    Close  ( GscKeyFile ) ;

                  End ;

                Close  ( GscMultFile ) ;

              End ;

          End ; { Mult Number }

      Close  ( GscNumFile      ) ;
      Close  ( KeyPlateGscFile ) ;

    End  { NumFileExists }
   Else
    Begin
      NumFileExist := False ;
    End ;


 EndNameGsc : ;


End ;  { à¨Ô GSC }
       { ƒƒƒƒƒƒƒ }


  { ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ }


     Procedure DmNumb (     DmStr, DirCatDm     : String  ;
                        Var RaH, RaM            : Integer ;
                        Var RaS                 : Double  ;
                        Var DeclSig             : Char    ;
                        Var DeclG, DeclM        : Integer ;
                        Var DeclS               : Double  ;
                        Var Flag                : Boolean   ) ;

 Type

    DmType =  Record
                RaH      : Byte     ;
                RaM      : Byte     ;
                RaS      : Word     ;
                DeclSig  : Char     ;
                DeclG    : Byte     ;
                DeclM    : Byte     ;
                DeclS    : Byte     ;
              End ;

    OutType   = Array [ 1 .. 30 ]  Of Char ;
    GraniType = Array [ 1 .. 10 ]  Of Char ;


 Var


    FGrani           : File Of GraniType ;
    ChGrani          :         GraniType ;

    Fpd1             : File Of DMType    ;
    Fpd1Rec          :         DMType    ;
    Fpd2             : File Of OutType   ;

    ChOut            :         OutType   ;
    ChOutBuf         :         OutType   ;

    DetBin,
    ChBinError       : Boolean ;

    Ch,
    ChBin,
    ChBin2,
    SigDecl          : Char    ;

    S, S1, S2        : String [ 80 ] ;

    NameIdent        : String [  2 ] ;

    DeclG1,
    ZoneDecl,
    NBinStar,
    Code             : Integer ;

    N1, N2,
    NRecFpd,
    NRecFpdBin,
    DeclNum,
    DeclNumMax,
    NNameCatDet,
    NNameInp,
    I, J             : LongInt ;

    R                : Double ;



{          ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹          }

Begin

  Flag      := True  ;
  FlagSdIzo := False ;
  DmDel     := False ;
  S1        := DmStr ;

  RaH     := 0   ;
  RaM     := 0   ;
  RaS     := 0.0 ;
  DeclSig := ' ' ;
  DeclG   := 0   ;
  DeclM   := 0   ;
  DeclS   := 0   ;


   { è•p•¢Æ§ ¢ °Æ´ÏË®• °„™¢Î }

  For I := 1 To Length ( S1 ) Do
    S1 [ I ] := UpCase ( S1 [ I ] ) ;

  While (     ( Length ( S1 ) >  0  )
          And ( S1 [ 1 ]      = ' ' )  )  Do
    Delete ( S1, 1, 1 ) ;

  NameIdent := Copy ( S1, 1, 2 ) ;

  NNameCatDet := 0 ;
  If ( NameIdent = 'BD' )  Then  NNameCatDet := 1 ;
  If ( NameIdent = 'SD' )  Then
    Begin
      NNameCatDet := 2     ;
      FlagSdIzo   := True  ;
    End ;
  If ( NameIdent = 'CD' )  Then  NNameCatDet := 3 ;
  If ( NameIdent = 'CP' )  Then  NNameCatDet := 4 ;

  If ( NNameCatDet = 0 )  Then
    Flag := False ;

  Delete ( S1, 1, 2 ) ;

  While (     ( Length ( S1 ) >  0     )
          And (    ( S1 [ 1 ] = ' ' )
                Or ( S1 [ 1 ] = '+' )  )  )  Do
    Delete ( S1, 1, 1 ) ;


  If ( S1 [ 1 ] = '-' )
    Then
      Begin
        SigDecl := '-' ;
        Delete ( S1, 1, 1 ) ;
        While (     ( Length ( S1 ) >  0  )
                And ( S1 [ 1 ]      = ' ' )  )  Do
          Delete ( S1, 1, 1 ) ;
      End
    Else
        SigDecl := '+' ;


      { áÆ≠† ë™´Æ≠•≠®Ô }
      { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

  J := Pos ( ' ' , S1 ) ;
  S2 := Copy ( S1 , 1, J - 1 ) ;
  Val ( S2, DeclG1, Code )  ;
  If ( SigDecl = '-' )  Then
    DeclG1 := - DeclG1 ;

  Delete ( S1, 1, J ) ;

  While  ( Length( s1 ) > 0 ) and  ( S1 [ 1 ] = ' ' )  Do
    Delete ( S1, 1, 1 ) ;

  S2 := '' ;
  While (     ( Length ( S1 ) >   0  )
          And ( S1 [ 1 ]      >= '0' )
          And ( S1 [ 1 ]      <= '9' )  )  Do
    Begin
      S2 := S2 + S1 [ 1 ] ;
      Delete ( S1, 1, 1 ) ;
    End ;

  Val ( S2, DeclNum, Code ) ;


  While (     ( Length ( S1 ) >  0  )
          And ( S1 [ 1 ]      = ' ' )  )  Do
    Delete ( S1, 1, 1 ) ;


  ChBin := ' ' ;
  If  ( Length ( S1 ) > 0 )  Then
    Begin
      ChBin  := UpCase ( S1 [ 1 ] ) ;
      If (     ( ChBin < 'A' )
           Or  ( ChBin > 'Z' )  )
        Then Flag := False ;
    End ;


  If (     ( NameIdent = 'BD' )
       And ( DeclG1   <= - 2  )  )  Then
    Begin
      NameIdent := 'SD' ;
      FlagSdIzo := True ;
    End ;



  If ( Flag )  Then
    Begin

      S := DirCatDm ;
      If ( S [ LengTh ( S ) ] <> '\' )  Then
        S := S + '\' ;

      S1 := S + NameIdent + '_Viz.' ;
      S  := S + NameIdent + '_2000.' ;

      If ( Not FileExists ( S1 + '1' )  )  Then
        Flag := False ;

      If ( Not FileExists ( S  + '2' )  )  Then
        Flag := False ;

      If ( Not FileExists ( S  + 'G' )  )  Then
        Flag := False ;


      If ( Flag )  Then
        Begin { DmExist }

          Assign  ( Fpd1    , S1 + '1' ) ;
          Reset   ( Fpd1               ) ;

          Assign  ( Fpd2    , S  + '2' ) ;
          Reset   ( Fpd2               ) ;

          Assign  ( FGrani  , S  + 'G' ) ;
          Reset   ( FGrani             ) ;



                  { HÆ¨•p ·‚pÆ™® FGrani }
                  { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

          ZoneDecl := 100 + DeclG1 ;
          If ( SigDecl <> '-' )  Then
            Inc ( ZoneDecl ) ;

          Seek  ( FGrani , ZoneDecl - 1 ) ;
          Read  ( FGrani , ChGrani      ) ;

          S2 := '' ;
          For I := 1 To 8 Do
            S2 := S2 + ChGrani [ I ] ;

          Val ( S2, NRecFpd, Code ) ;

          Seek  ( FGrani , ZoneDecl - 2 ) ;
          Read  ( FGrani , ChGrani      ) ;

          S2 := '' ;
          For I := 1 To 8 Do
            S2 := S2 + ChGrani [ I] ;
          Val ( S2, DeclNumMax, Code ) ;

          DeclNumMax := DeclNumMax - NRecFpd ;

          If (     ( DeclNum <= DeclNumMax )
               And ( NRecFpd >       0     )  )
            Then
              Begin { DeclNum <= DeclNumMax }
                    { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

                NRecFpd := NRecFpd + DeclNum ;

                Seek  ( Fpd1 , NRecFpd - 1 ) ;
                Read  ( Fpd1 , Fpd1Rec     ) ;


                If (     (    ( ChBin = ' ' )
                           Or ( ChBin = 'D' )     )
                     And ( Fpd1Rec.DeclSig <> '*' )  )
                  Then
                    Begin { á†§†≠† °•ß °„™¢Î ®´® „§†´•≠≠†Ô ®ß DM, Æ§®≠ÆÁ≠†Ô }
                          { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
                      RaH := Fpd1Rec.RaH         ;
                      RaM := Fpd1Rec.RaM         ;
                      RaS := Fpd1Rec.RaS / 10.0  ;

                      DeclSig := Fpd1Rec.DeclSig ;

                      DeclG := Fpd1Rec.DeclG     ;
                      DeclM := Fpd1Rec.DeclM     ;
                      DeclS := Fpd1Rec.DeclS     ;

                    End   { á†§†≠† °•ß °„™¢Î }
                          { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
                  Else

                    If ( Fpd1Rec.DeclSig = '*' )  Then
                    Begin  { DM ™p†‚≠†Ô }
                           { ƒƒƒƒƒƒƒƒƒƒ }
{
                      S2 := '' ;
                      For I := 1 To 8  Do
                        S2 := S2 + ChOutBuf [ I + 2 ] ;
                      Val ( S2, NRecFpdBin, Code ) ;

                      S2 := '' ;
                      For I := 1 To 4  Do
                        S2 := S2 + ChOutBuf [ I + 12 ] ;
                      Val ( S2, NBinStar, Code ) ;
}
                      NRecFpdBin := Fpd1Rec.RaS ;
                      NBinStar   := Fpd1Rec.RaM ;

                        { èpÆ·¨Æ‚p ™p†‚≠Æ© ·®·‚•¨Î }
                        { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

                      DetBin := False ;
                      Seek  ( Fpd2 , NRecFpdBin - 1 ) ;

                      For I := 1 To NBinStar Do
                        Begin

                          Read  ( Fpd2 , ChOut ) ;

                          ChBin2 := ChOut [ 28 ] ;
                          ChBin2 := UpCase ( ChBin2 ) ;

                          If ( ChBin <> ' ' )
                            Then
                              Begin { á†§†≠† · Å„™¢Æ© }
                                If ( ChBin = ChBin2 )  Then
                                  Begin
                                    DetBin := True ;
                                    ChOutBuf := ChOut ;
                                  End ;
                              End
                            Else
                              Begin { á†§†≠† °•ß Å„™¢Î, ≠Æ ™p†‚≠†Ô }
                                If (    ( ChBin2 = ' ')
                                     Or ( ChBin2 = 'D')  )  Then
                                  Begin
                                    DetBin := True ;
                                    If ( ChBin2 = 'D') Then
                                       DmDel := True ;
                                    ChOutBuf := ChOut ;
                                  End ;
                              End ;

                        End ;

                      If ( DetBin )
                        Then
                          Begin  { Det Bin Find }
                            S := '' ;
                            For I :=  1  To  25   Do
                              S := S + ChOutBuf [ I ] ;

                            S1 := S [ 1 ] + S [ 2 ] ;
                            Val ( S1, RaH, Code ) ;

                            S1 := S [ 4 ] + S [ 5 ] ;
                            Val ( S1, RaM, Code ) ;

                            S1 := S [ 7 ] + S [ 8 ] + S [ 9 ] + S [ 10 ] ;
                            Val ( S1, RaS, Code ) ;
{
                            RaS :=  R / 10.0 ;
}

                            DeclSig := S [ 12 ] ;

                            S1 := S [ 13 ] + S [ 14 ] ;
                            Val ( S1, DeclG, Code ) ;

                            S1 := S [ 16 ] + S [ 17 ] ;
                            Val ( S1, DeclM, Code ) ;

                            S1 := S [ 19 ] + S [ 20 ] ;
                            Val ( S1, DeclS, Code ) ;

                          End
                        Else
                            Flag := False ;

                    End    { DM ™p†‚≠†Ô }
                           { ƒƒƒƒƒƒƒƒƒƒ }
                   Else
                     Flag := False ;

              End  { DeclNum <= DeclNumMax }
            Else
              Begin
                Flag := False ;
              End ;

        End ; { DmExist }
              { ƒƒƒƒƒƒƒ }


   Close  ( Fpd1   ) ;
   Close  ( Fpd2   ) ;
   Close  ( FGrani ) ;


 End ; { DmExist }
       { ƒƒƒƒƒƒƒ }

End ;  { à¨Ô DM }
       { ƒƒƒƒƒƒ }


  { ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ }


     Procedure StarNumb (     DmStr               : String  ;
                          Var RaH, RaM            : Integer ;
                          Var RaS                 : Double  ;
                          Var DeclSig             : Char    ;
                          Var DeclG, DeclM        : Integer ;
                          Var DeclS               : Double  ;
                          Var Flag                : Boolean   ) ;
Var

    S1         : String [ 80 ] ;
    NameIdent  : String [  8 ] ;

    I,J,K      : Integer ;

Begin

  S1 := DmStr ;

  For I := 1 To Length ( S1 ) Do
    S1 [ I ] := UpCase ( S1 [ I ] ) ;

  While (     ( Length ( S1 ) >  0  )
          And ( S1 [ 1 ]      = ' ' )  )  Do
    Delete ( S1, 1, 1 ) ;


  I := Pos ( ' ', S1 ) ;
  J := Pos ( '+', S1 ) ;
  K := Pos ( '-', S1 ) ;
  If (     ( J > 0 )
       And ( J < I ) )  Then
    I := J ;
  If (     ( K > 0 )
       And ( K < I ) )  Then
    I := K ;

  If ( I > 1 )
    Then  S1 := Copy ( S1, 1, I-1 )
    Else  S1 := '' ;
  {
  While (     ( Length ( S1 ) >  0                 )
          And (    ( S1 [ Length ( S1 ) ] < 'A' )
                Or ( S1 [ Length ( S1 ) ] > 'Z' )  )
                                                        )  Do
    Delete ( S1, Length ( S1 ), 1 ) ;
  }


  FlagFindGsc := False ;
  FlagFindSao := False ;
  FlagFindDm  := False ;


  If ( S1 = 'GSC' )  Then
    Begin
      FlagFindGsc := True  ;
      GscNumb ( DmStr, CatalogDir.GSC  ,
                RaH, RaM, RaS          ,
                DeclSig                ,
                DeclG, DeclM,DeclS     ,
                GscFlag                  )
    End ;


  If ( S1 = 'SAO' )  Then
    Begin
      FlagFindSao := True ;
      SaoNumb ( DmStr, CatalogDir.Ppm  ,
                RaH, RaM, RaS          ,
                DeclSig                ,
                DeclG, DeclM,DeclS     ,
                SaoFlag               ) ;
    End ;



  If (    ( S1 = 'BD' )
       Or ( S1 = 'SD' )
       Or ( S1 = 'CD' )
       Or ( S1 = 'CP' )  )  Then
    Begin
      FlagFindDm  := True  ;
      DmNumb ( DmStr, CatalogDir.DM   ,
               RaH, RaM, RaS          ,
               DeclSig                ,
               DeclG, DeclM,DeclS     ,
               DmFlag                   ) ;
    End ;


{
  If ( S1 [ 1 ] = 'G' )
    Then
      Begin
           FlagFindGsc := True  ;
           GscNumb ( DmStr, CatalogDir.GSC  ,
                     RaH, RaM, RaS          ,
                     DeclSig                ,
                     DeclG, DeclM,DeclS     ,
                     GscFlag                  )
      End
    Else
      Begin
            DmNumb ( DmStr, CatalogDir.DM   ,
                     RaH, RaM, RaS          ,
                     DeclSig                ,
                     DeclG, DeclM,DeclS     ,
                     DmFlag                   ) ;
      End ;
}

End ; { StarNumb }






Procedure EnterSputnikNum ( Var SN : Integer; Var Flag : boolean );
Label BS;

Var
 SDialog  : PDialog      ;
 Bruce    : PView        ;
 R        : TRect        ;
 SSN      : String[  5 ] ;
 RetCode,
 EC,t     : Word         ;

Begin

Str( SN , SSN );

R.Assign( 1, 1, 31, 7 );
SDialog := New( PDialog, Init( R,' Satellite number ', jcCentered ));

With SDialog^ do
 Begin

  R.Assign( 12, 2, 19, 3 );
  Bruce := New ( PInputLine, Init( R, 5 ));
  Insert( Bruce );

  R.Assign( 2, 4, 15, 5);
  Insert( New( PButton, Init( R, 'Ok',bfNormal, cmOk )));

  R.Assign( 16, 4, 29, 5);
  Insert( New( PButton, Init( R, 'Cancel',bfNormal, cmCancel )));

  SetData( SSN );

  InsFlag := False;

BS:;

  RetCode := Run;

  Flag := False;

  If RetCode <> cmCancel Then
   Begin

    Flag := true;

    GetData( SSN );

    For t := 1 to Length( SSN )  do
     Begin
      case  SSN [ t ] of
       '1','2',
       '3','4',
       '5','6',
       '7','8',
       '9','0',
       ' ','-' :;
       Else
        Begin

         EnterParamError;
         GoTo BS ;

        End;
      End;
     End;


     Val( SSN, SN, EC );

   End;

 End;

Dispose( Sdialog, Done );

End;{ EnterSputnikNum }


Procedure EnterDMNum ( Var DM : String20; Var Flag : boolean );
Label BS;

Var
 SDialog  : PDialog       ;
 Bruce    : PView         ;
 R        : TRect         ;
 SSN      : String [ 30 ] ;
 DMN      : String [ 30 ] ;
 RetCode,
 EC,t     : Word          ;

Begin

SSN := DmNumber ;

R.Assign( 1, 1, 38, 12 );

{
SDialog := New( PDialog, Init( R,' DM number ', jcCentered ));
}


SDialog := New ( PDialog, Init ( R,' Star number ', jcCentered ));
With SDialog^ do
 Begin

  R.Assign( 3, 2, 34, 4 );
  Bruce := New ( PStaticText, Init( R,
                             'Format'                         + #13 +
                             '  DM : BD(SD,CD,CP) +23 1501 A' + #13 +
                             '  GSC: GSC 3201.576 (NPL.NSTAR)'+ #13 +
                             '  SAO: SAO 1531'                        ));
  Insert( Bruce );

  R.Assign( 3, 7, 35, 8 );
  Bruce := New( PInputLine, Init( R, 21 ));
  Insert( Bruce );

  R.Assign(  3,  9, 14, 10 );
  Insert( New( PButton, Init( R, 'Ok',bfNormal, cmOk )));

  R.Assign( 16,  9, 27, 10 );
  Insert( New( PButton, Init( R, 'Cancel',bfNormal, cmCancel )));

  SetData( SSN );

  InsFlag := False;


BS:;


  RetCode := Run;

  Flag := False;

  If RetCode <> cmCancel Then
   Begin

     Flag := True;

     GetData ( SSN );

     While (     ( Length ( SSN ) >  0  )
             And ( SSN [ 1 ]      = ' ' ) )  Do
       Delete ( SSN, 1, 1 ) ;

     If ( SSN = '' )
       Then
         Begin
           Sound ( 1000 ) ;  Delay ( 300 ) ; NoSound ;
           Error( 1, 1, 35, 6, #13+ ^C + 'No star number' + #13 );
           Goto BS;
         End
       Else
         Begin
           StarNumb ( SSN,
                      RaH, RaM, RaS       ,
                      DeclSig             ,
                      DeclG, DeclM,DeclS  ,
                      DMFlag                 ) ;

           If (     ( FlagFindGsc = False )
                And ( FlagFindSao = False )
                And ( FlagFindDm  = False ) )  Then
             Begin
               Sound ( 1000 ) ;  Delay ( 300 ) ; NoSound ;
               Error( 1, 1, 35, 6, #13+ ^C + 'Incorrect catalog name' + #13 );
               Goto BS;
             End


         End ;



     If (     ( FlagFindSao      )
          And ( Not NumFileExist ) )  Then
       Begin
         Sound ( 1000 ) ;  Delay ( 300 ) ; NoSound ;
         Error( 1, 1, 35, 6, #13+ ^C + 'SAO number files not found' + #13 );
         Goto BS;
       End ;


     If (     ( FlagFindSao  )
          And ( Not NumExist ) )  Then
       Begin
         Sound ( 1000 ) ;  Delay ( 300 ) ; NoSound ;
         Error( 1, 1, 35, 6, #13+ ^C + 'Sao number not exist' + #13 );
         Goto BS;
       End ;




     If (     ( FlagFindGsc      )
          And ( Not NumFileExist ) )  Then
       Begin
         Sound ( 1000 ) ;  Delay ( 300 ) ; NoSound ;
         Error( 1, 1, 35, 6, #13+ ^C + 'GSC number files not found' + #13 );
         Goto BS;
       End ;


     If (     ( FlagFindGsc  )
          And ( Not NumExist ) )  Then
       Begin
         Sound ( 1000 ) ;  Delay ( 300 ) ; NoSound ;
         Error( 1, 1, 35, 6, #13+ ^C + 'GSC number not exist' + #13 );
         Goto BS;
       End ;


     If (     ( FlagFindGsc      )
          And ( NumberMultError  ) )  Then
       Begin
         Sound ( 1000 ) ;  Delay ( 300 ) ; NoSound ;
         Error( 1, 1, 35, 6, #13+ ^C + 'GSC number not double' + #13 );
         Goto BS;
       End ;


     If (     ( FlagFindGsc      )
          And ( Not SrtFileExist ) )  Then
       Begin
         Sound ( 1000 ) ;  Delay ( 300 ) ; NoSound ;
         Error( 1, 1, 35, 6, #13+ ^C + 'GSC catalog files not found' + #13 );
         Goto BS;
       End ;


     If (     ( FlagFindGsc  )
          And ( GscMult      ) )   Then
       Begin
         Sound ( 1000 ) ;  Delay ( 300 ) ; NoSound ;
         If ( NMult = 2 )
           Then Error( 1, 1, 35, 7,
              #13+ ^C + 'Two object for one number GSC' + #13 +
              ^C + 'Enter ''A'' or ''B'' after number ' + #13 )
           Else Error( 1, 1, 35, 7,
              #13+ ^C + 'Three object for one number GSC' + #13 +
              ^C + 'Enter ''A'',''B'' or ''C'' after number ' + #13 );
         Goto BS;
       End ;





     If (     ( DMFlag = False  )
          And ( FlagFindDm      )
                                    ) Then
       Begin
         Sound ( 1000 ) ;  Delay ( 300 ) ; NoSound ;
         Error( 1, 1, 35, 6, #13+ ^C + 'DM Number not found' + #13 );
         GoTo BS ;
       End ;


     DmNumber := SSN ;


   End;

 End;

Dispose ( Sdialog, Done );

End;{ EnterDMNum }




Begin

 If TerraFlag
   Then  y := 1
   Else  y := 0 ;

 If SatellitFlag Then
   Y := Y + 1;

 If ( DmExecFlag )  Then
   Y := Y + 1 ;  { Ñ´Ô DM Number }

 OO :=  CP;

 If ( Not TerraFlag) And ( CP > 2 ) Then
   CP := CP - 1 ;


 R.Assign( 1, 1, 32, 14 + y);
 Dialog := New( PDialog , Init( R, Title, jcCentered ));

 With Dialog^ do
  Begin

   R.Assign( 3, 2, 20, 12 + y);
   Bruce := New( PRadioButton, Init( R ));
   With Bruce^ do
    Begin

     M := 0;

     NewSItem('Mercury'); Inc( M );
     NewSItem('Venus'  ); Inc( M );

     If TerraFlag Then
      Begin

       NewSItem('Earth');
       Inc( M );

      End;

     NewSItem ( 'Marth'    );   Inc( M );
     NewSItem ( 'Jupiter'  );   Inc( M );
     NewSItem ( 'Saturn'   );   Inc( M );
     NewSItem ( 'Uran'     );   Inc( M );
     NewSItem ( 'Neptun'   );   Inc( M );
     NewSItem ( 'Pluto'    );   Inc( M );
     NewSItem ( 'Moon'     );   Inc( M );
     NewSItem ( 'Sun'      );   Inc( M );


     If SatellitFlag Then
      Begin
       NewSItem ( 'Satellite' );
       Inc( M );
      End;

     If ( DmExecFlag )  Then
       Begin
{
         NewSItem ( 'DM Number' );
}
{
         NewSItem ( 'DM or GSC #' );
}
         NewSItem ( 'Star number' );
         Inc( M );

       End ;

    End;

   Insert( Bruce );

   R.Assign( 22,2,31,3);
   Bruce := New( PButton, Init( R,'Ok', bfNormal, cmOk ));
   Insert( Bruce );

   R.Assign( 22,4,31,5);
   Bruce := New( PButton, Init( R,'Cancel', bfNormal, cmCancel ));
   Insert( Bruce );

   SetData( CP );


      { Ñ´Ô GscNumber }

   For  N := 1  To  288  Do
     Begin
       RR := ( StepGr * N - StepGr / 2.0 ) * GR ;
       SinRaFild  [ N ] := Sin ( RR ) ;
       CosRaFild  [ N ] := Cos ( RR ) ;
     End ;

   For  N := 1  To  144  Do
     Begin
       RR := ( StepGr * N - StepGr / 2.0 - 90.0 ) * GR  ;
       SinDecFild [ N ] := Sin ( RR ) ;
     End ;


BegDialog:;

   ExitCode := Run ;

   If ExitCode <> cmCancel Then
    Begin

     GetData( CP );

     If (    (     ( CP =  M - 1    )
               And ( SatellitFlag   )
               And ( DmExecFlag     )   )
          Or (     ( CP =  M        )
               And ( SatellitFlag   )
               And ( Not DmExecFlag )   )
                                            )  Then
      Begin

       EnterSputnikNum ( SputnikNum, EFlag );

       If ( SputnikNum < -20 ) Or ( EFlag = False ) Then
        Begin

         GoTo BegDialog;

        End;

      End;


     If (     ( CP =  M    )
          And ( DmExecFlag )  )   Then
      Begin

       EnterDmNum ( DMNumber, DMFlag );

       If ( DMFlag = False )
         Then
           GoTo BegDialog
         Else
           Begin  { H†©§•≠Î ™ÆÆp§®≠†‚Î DM }

             OptOsOrient := 1 ;  { ù™¢. äÆÆp§. }

             With EkvCoord do
               Begin

                 Param1.BChar := ' ';
                 Param1.PI1   := RaH;
                 Param1.PI2   := RaM;
                 Param1.PD    := RaS;

                 Param2.BChar := DeclSig;
                 Param2.PI1   := DeclG;
                 Param2.PI2   := DeclM;
                 Param2.PD    := DeclS;

               End;


             With EpohaElementov do
               Begin

                 Month    :=    1 ;
                 Day      :=    1 ;
                 Year     := 2000 ;

                 Hour     :=    0 ;
                 Minute   :=    0 ;
                 Sec      :=    0 ;

               End;

             SatellitFlag := False ;

           End ;

      End;


     If ( Not TerraFlag ) Then
       Begin
         If  ( CP > 2 )  Then  CP := CP + 1 ;
       End;


    End;

   If ExitCode = cmCancel
      Then
          CP := OO
      Else
        Begin
          If ( SatellitFlag )  Then
            OptOsOrient := 4 ;
        End ;


  End;

 Dispose( Dialog, Done );

End;{ TMApp.SetObject }

End.