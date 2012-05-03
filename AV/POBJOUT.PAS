
{$O+,F+}

 UNIT PObjOut ;

   INTERFACE


    Procedure NameIras ( NRecC : LongInt; Var S1 : String ) ;

    Procedure ObjectOut (     IndStar : Integer ;
                              Cat     : Byte    ;
                              Auto    : Boolean ;
                          Var NDet    : Byte    ;
                          Var SDetOut : String    ) ;



   IMPLEMENTATION

   USES   DOS, PVAR, PVarMenu, V_CATAL,
          PPreNew, PProFld, PVarName, PJd8, PE_Cns, PDateA20 ;

   Procedure  NameIras ( NRecC : LongInt; Var S1 : String ) ;
    Var
        S2,
        SName,
        NameCat : String  ;
        I, I1   : Integer ;
        NRec    : LongInt ;
        FData   : File    ;
        Buf     : Array [ 1 .. 2000 ] Of Char ;

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
            If ( SName = 'PSC' ) Or ( SName = 'TMSS' )
              Then I1 := 0
              Else I1 := 1 ;

            If ( SName = 'RAFGL' ) Then
              I1 := 73 ;

            S1 := '' ;
            For I := 1 To 11 Do
              S1 := S1 + Buf [ I1 + I ] ;

            If ( SName = 'PSC' ) Then
              Begin
                S2 := '' ;
                For I := 1 To 2 Do
                  S2 := S2 + Buf [ 116 + I ] ;
                If ( S2 <> '-1' )  Then
                  S1 := S1 + S2 ;
              End ;

          End ;

      End ;



    Procedure ObjectOut (     IndStar : Integer ;
                              Cat     : Byte    ;
                              Auto    : Boolean ;
                          Var NDet    : Byte    ;
                          Var SDetOut : String    ) ;


     { èÆ§£Æ£‚Æ¢™† ·‚pÆ™® §´Ô ¢Î¢Æ§† ®≠‰Æp¨†Ê®® ¢ ‰†©´ }
     { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

 Const
   NameMonth : Array [ 1 .. 12 ] Of String [ 3 ] =
    (
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
    ) ;


 Var

  S, S1, S2, t            : String        ;
  SOut                    : String        ;
  S9                      : S9Type        ;
  S19                     : S19Type       ;
  SMonth                  : String [  3 ] ;

  B_Cnst_New,
  B_Hip_NoCrd,
  PMExist,
  PMRed,
  CNeg                    : BOOLEAN ;

  NDm,
  NPosAuto, NPosManu,
  LengthSOut              : Byte    ;

  I,
  Nf,
  Id, Im,
  g , mnt                 : Integer ;

  RI,
  N1,
  N2,
  Nms,
  NAdd,
  NSer,
  NDecl,
  NRecC                   : LongInt ;

  PmRaArcSec,
  PmDeclArcSec,
  PmRa, PmDecl,
  XSt, YSt,
  Nox , Noy,
  JdGsc0, JdGsc,
  YearGsc,
  Sec                     : Double  ;

  Mv,
  RaRep ,  DeclRep ,
  ORa   ,  ODc            : Double  ;

  BsSrcRecord             : BSSrcType  ;

  Year   : Longint;
  Month  : Integer;
  DateInf: Word   ;
  NZagol : Word   ;
  Day    : Word   ;
  Spp    : Byte   ;



 Begin

        Id := IndStar Div ObjectBlockSize ;
        Im := IndStar Mod ObjectBlockSize ;
        ObjectRecord := Objectptr[Id]^[Im];

        PMRed      := False ;
        PMExist    := False ;
        B_Cnst_New := False ;

        HdE := False ;
        If ( Cat = CatHd )
          Then
            Begin  { CatHd }
              If ( ObjectRecord.Sp >= 100 )  Then
                Begin
                  HdE := True ;
                  FileMode := 0 ;
                  Reset ( HdEFile ) ;
                  Seek  ( HdEFile, ( ObjectRecord.NRecC Mod 1000000000 ) - 1 ) ;
                  Read  ( HdEFile, HdERecord  ) ;
                  Close ( HdEFile             ) ;
                  If ( HdERecord.MuRa < 32000 )  Then
                    Begin
                      PmRaArcSec   := HdERecord.MuRa  / C10000 ;
                      PmDeclArcSec := HdERecord.MuDec / C10000 ;
                      PMExist      := True                     ;
                      PmRed        := True                     ;
                    End ;
                End
              Else
                Begin
                  FileMode := 0 ;
                  ReSet ( HdFile ) ;
                  Seek  ( HdFile, ( ObjectRecord.NRecC Mod 1000000000 ) - 1 )  ;
                  Read  ( HdFile, HdRecord  ) ;
                  Close ( HdFile            ) ;
                  HdE := False                ;
                End ;
          End ;  { CatHd }


        B_Hip_NoCrd := False ;

        If ( Cat = CatHip )  Then
          Begin
            FileMode := 0 ;
            Reset ( HipFile ) ;
            Seek  ( HipFile , ( ObjectRecord.NRecC Mod 1000000000 ) - 1 ) ;
            Read  ( HipFile , HipRecord ) ;
            Close ( HipFile ) ;
            PmRaArcSec   := HipRecord.PmRa   / C10000 ;
            PmDeclArcSec := HipRecord.PmDecl / C10000 ;
            PMExist      := True                      ;
            PMRed        := True                      ;
            If ( B_Hip_Add )  Then
              Begin
                FileMode := 0 ;
                Reset ( HipAddFile ) ;
                Seek  ( HipAddFile , ( ObjectRecord.NRecC Mod 1000000000 ) - 1 ) ;
                Read  ( HipAddFile , HipAddRecord ) ;
                Close ( HipAddFile ) ;
                If ( Abs ( HipRecord.NSerInFile ) Div 1000000 = 1 )
                  Then
                    Begin
                      PmExist := False ;
                      B_Hip_NoCrd := True  ;
                    End
                  Else
                    Begin
                      If (     ( HipAddRecord.PmRa   > -30000 )
                           And ( HipAddRecord.PmDecl > -30000 ) )
                        Then
                          Begin
                            PmRaArcSec   := HipAddRecord.PmRa   ;
                            PmDeclArcSec := HipAddRecord.PmDecl ;
                          End
                        Else
                            PmExist := False ;
                    End ;
              End ;
          End ;




        SOut := NameCat [ Cat ] ;
        If ( Length ( SOut ) < 4 )
          Then
            Begin
              For I := Length ( SOut ) To 4 Do
                SOut := SOut + ' ';
            End
          Else
                SOut := SOut + ' ';

        If (     ( Cat = CatHip )
             And ( B_Hip_NoCrd  ) )  Then
          SOut := 'hip- ' ;


        If ( Cat = CatTyc )  Then
          Begin
            FileMode := 0 ;
            Reset ( TycFile ) ;
            Seek  ( TycFile , ( ObjectRecord.NRecC Mod 1000000000 ) - 1 ) ;
            Read  ( TycFile , HipRecord ) ;
            Close ( TycFile ) ;
            If ( B_Tyc_2_Add )  Then
              Begin
                Reset ( TycAddFile ) ;
                Seek  ( TycAddFile , ( ObjectRecord.NRecC Mod 1000000000 ) - 1 ) ;
                Read  ( TycAddFile , TycAddRecord ) ;
                Close ( TycAddFile ) ;
              End ;
            If ( HipRecord.PmRa > (-32000.0+1.0) )  Then
              Begin
                If ( B_Tyc_2_Add )
                  Then
                    Begin
                      PmRaArcSec   := TycAddRecord.PmRa   ;
                      PmDeclArcSec := TycAddRecord.PmDecl ;
                    End
                  Else
                    Begin
                      PmRaArcSec   := HipRecord.PmRa   / C10000 ;
                      PmDeclArcSec := HipRecord.PmDecl / C10000 ;
                    End ;
                PmExist      := True                      ;
                PMRed        := True                      ;
              End ;
          End ;



        If ( Cat = CatTyc )  Then
          Begin
            If ( B_Tyc_Sai )  Then
              Begin
                SOut [ 2 ] := 'R';
                SOut [ 3 ] := 'C';
              End ;
            If ( B_Tyc_2 )  Then
              Begin
                SOut := 'TC2  ' ;

                If ( HipRecord.NSerInFile < 0 )  Then
                  SOut := 'TYC2-' ;

              End ;
          End ;



        If  ( Cat = CatA20 )  Then
          Begin
            {
            If ( ( ObjectRecord.NRecC Mod 1000000000 ) Div 10000000 = 1 )  Then
              SOut [ 4 ] := 'G' ;
            }
            If ( ( ObjectRecord.Sp Div 10 ) = 8 )  Then
              SOut [ 4 ] := 'g' ;

          End ;


        If ( Cat = CatGsc )  Then
          Begin
            If  (    ( ObjectRecord.Sp Mod 10  = 0 )
                  Or ( ObjectRecord.Sp Mod 10 >= 6 )  )
              Then  SOut [ 4 ] :=  '*' ;
          End ;


        If (     ( Cat = CatHd )
             And ( HdE            )  )
          Then  SOut := 'HDE  ' ;


        If (     ( Cat = CatHd )
             And ( Not HdE     )  )  Then
          SOut := 'HD  '+HdRecord.Remarks ;




        If (     ( Cat = CatCdc )
             And ( B_Cdc_Cat    )  )  Then
           Begin
             If ( ObjectRecord.Sp >= 100 )  Then
               SOut [ 3 ] := '+' ;
           End ;

        If ( Cat = CatPpm )   Then
           Begin
             If ( ( ObjectRecord.Sp Div 100 ) Mod 2 = 1 )
                Then  SOut [ 4 ] := '-' ;
           End ;


        If ( Cat = CatGcvs )  Then
           Begin

             FileMode := 0 ;

             If ( B_Gcvs2000 )
               Then
                 Begin

                   Reset ( Gcvs2000File                                             ) ;
                   Seek  ( Gcvs2000File , ( ObjectRecord.NRecC Mod 1000000000 ) - 1 ) ;
                   Read  ( Gcvs2000File ,   Gcvs2000Record                          ) ;
                   Close ( Gcvs2000File                                             ) ;

                   GcvsRecord.SdRa    := Gcvs2000Record.SdRa    ;
                   GcvsRecord.SdDec   := Gcvs2000Record.SdDec   ;
                   GcvsRecord.NameStr := Gcvs2000Record.NameStr ;
                   GcvsRecord.MStr    := Gcvs2000Record.MStr    ;
                   GcvsRecord.SpStr   := Gcvs2000Record.SpStr   ;

                   If ( Gcvs2000Record.PmRa <> -32000 )
                     Then
                       Begin
                         PmRaArcSec   := Gcvs2000Record.PmRa   / C10000 ;
                         PmDeclArcSec := Gcvs2000Record.PmDecl / C10000 ;
                         PMExist      := True                           ;
                         PMRed        := True                           ;
                       End
                     Else
                       Begin
                         PMExist      := False                          ;
                         PMRed        := False                          ;
                       End ;
                 End
               Else
                 Begin
                   Reset ( GcvsFile                                             ) ;
                   Seek  ( GcvsFile , ( ObjectRecord.NRecC Mod 1000000000 ) - 1 ) ;
                   Read  ( GcvsFile ,   GcvsRecord                              ) ;
                   Close ( GcvsFile                                             ) ;
               End ;

             SOut := 'GCVS ' ;

           End ;



        If  ( Auto )
           Then  SOut := SOut + ':'
           Else  SOut := SOut + '+' ;



        If ( ( Cat = CatCdc )  And  ( B_Cdc_Cat )  )  Then
          Begin
            Seek ( CdcFile , ( ObjectRecord.NRecC Mod 1000000000 ) - 1 ) ;
            Read ( CdcFile , CdcRecord ) ;
            If ( CdcRecord.MuRa <> 32123 )  Then
                Begin  { Ö·‚Ï  P.M. }
                  PmRaArcSec   := CdcRecord.MuRa  / C10000 ;
                  PmDeclArcSec := CdcRecord.MuDec / C10000 ;
                  PMExist      := True                     ;
                  PMRed        := True                     ;
                End
              Else
                Begin
                  PmRaArcSec   :=   0.0 ;
                  PmDeclArcSec :=   0.0 ;
                  PMExist      := False ;
                  PmRed        := False ;
                End ;
          End ;


        If ( Cat = CatPpm )  Then
          Begin
            FileMode := 0 ;
            Reset ( PpmFile ) ;
            Seek  ( PpmFile , ( ObjectRecord.NRecC Mod 1000000000 ) - 1 ) ;
            Read  ( PpmFile , PpmRecord ) ;
            Close ( PpmFile ) ;
            PmRaArcSec   := PpmRecord.MuRa  / 3000.0 ;
            PmDeclArcSec := PpmRecord.MuDec / 3000.0 ;
            PMExist      := True                     ;
            PMRed        := True                     ;
          End ;


        If ( Cat = CatTyc )  Then
          Begin
            FileMode := 0 ;
            Reset ( TycFile ) ;
            Seek  ( TycFile , ( ObjectRecord.NRecC Mod 1000000000 ) - 1 ) ;
            Read  ( TycFile , HipRecord ) ;
            Close ( TycFile ) ;
            If ( B_Tyc_2_Add )  Then
              Begin
                Reset ( TycAddFile ) ;
                Seek  ( TycAddFile , ( ObjectRecord.NRecC Mod 1000000000 ) - 1 ) ;
                Read  ( TycAddFile , TycAddRecord ) ;
                Close ( TycAddFile ) ;
              End ;
            If ( HipRecord.PmRa > (-32000.0+1.0) )  Then
              Begin
                If ( B_Tyc_2_Add )
                  Then
                    Begin
                      PmRaArcSec   := TycAddRecord.PmRa   ;
                      PmDeclArcSec := TycAddRecord.PmDecl ;
                    End
                  Else
                    Begin
                      PmRaArcSec   := HipRecord.PmRa   / C10000 ;
                      PmDeclArcSec := HipRecord.PmDecl / C10000 ;
                    End ;
                PmExist      := True                      ;
                PMRed        := True                      ;
              End ;
          End ;


        If ( Cat = CatSao )  Then
          Begin
            FileMode := 0 ;
            Reset ( SaoFile ) ;
            Seek  ( SaoFile , ( ObjectRecord.NRecC Mod 1000000000 ) - 1 ) ;
            Read  ( SaoFile , SaoRecord ) ;
            Close ( SaoFile ) ;
            PmRaArcSec   := SaoRecord.MuRa  / 0.6 / 1000000000.0 * SekRad ;
            PmDeclArcSec := SaoRecord.MuDec / 0.6 / 1000000000.0 * SekRad ;
            PMExist      := True             ;
            PmRed        := True             ;
          End ;



        If ( Cat = CatBs )  Then
          Begin
            FileMode := 0 ;
            Reset ( BsFile ) ;
            Seek  ( BsFile , ( ObjectRecord.NRecC Mod 1000000000 ) - 1 ) ;
            Read  ( BsFile , BSRecord ) ;
            Close ( BsFile ) ;
            NRecC := BSRecord.Sao ;
            Reset ( BsSrcFile ) ;
            Seek  ( BsSrcFile , NRecC - 1   ) ;
            Read  ( BsSrcFile , BsSrcRecord ) ;
            Close ( BsSrcFile ) ;
            PmRaArcSec   := BsRecord.MURA  / 0.6 / 1000000000.0 * SekRad ;
            PmDeclArcSec := BsRecord.MUDEC / 0.6 / 1000000000.0 * SekRad ;
            PMExist      := True  ;
            PMRed        := True  ;
          End ;



        If ( Cat = CatNpm )  Then
          Begin
            FileMode := 0 ;
            Reset ( NpmFile ) ;
            Seek  ( NpmFile , ( ObjectRecord.NRecC Mod 1000000000 ) - 1 ) ;
            Read  ( NpmFile , NpmRecord ) ;
            Close ( NpmFile ) ;
            PmRaArcSec   := NpmRecord.MuRa   ;
            PmDeclArcSec := NpmRecord.MuDec  ;
            PMExist      := True             ;
            PmRed        := True             ;
          End ;


        If ( Not Auto )
          Then
            Begin
              ScToId ( ObjectRecord.X ,
                       ObjectRecord.Y ,  NoX, NoY ) ;
            End
          Else
            Begin
              NoX := ObjectRecord.X ;
              NoY := ObjectRecord.Y ;
            End ;

        XSt := NoX ;
        YSt := NoY ;




       If ( Cat = CatNltt )  Then
         Begin

           FileMode := 0 ;
           Reset ( NlttFile ) ;
           Seek  ( NlttFile , ( ObjectRecord.NRecC Mod 1000000000 ) - 1 ) ;
           Read  ( NlttFile , NlttRecord ) ;
           Close ( NlttFile ) ;

           PmRaArcSec   := NlttRecord.MuRa  / 0.6 / 1000000000.0 * SekRad ;
           PmDeclArcSec := NlttRecord.MuDec / 0.6 / 1000000000.0 * SekRad ;

           PMExist      := True  ;
           PmRed        := True  ;

         End ;


        If ( PMRed ) Then
          Begin  { è•p•¢Æ§ ™ÆÆp§®≠†‚ ≠† Out ÌØÆÂ„ ß† P.M. }
                 { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

            PmRa   := PmRaArcSec   / SekRad * FD ;
            PmDecl := PmDeclArcSec / SekRad * FD ;

            XSt := NoX ;
            YSt := NoY ;

            XYEpOut ( Cat, PmRa, PmDecl, XSt, YSt ) ;

            If ( Abs ( PmDecl ) < C10000 )
              Then
                Begin
                  PmRaArcSec   :=  PmRa   / Fd * SekRad ;
                  PmDeclArcSec :=  PmDecl / Fd * SekRad ;
                End
              Else
                  PmExist := False ;
            {
             ìÁ´® ¢´®Ô≠®• P.M. · JDate -> JdOut.
            }
          End ;



        If ( Cat <> CatDm )  Then
          Begin

            IdToEq1  ( XSt, YSt, ORa, ODc ) ;  { Coord ≠† EpOut }
                                               { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
            Identify ( JdOut, ORa,ODc, SCnst )    ;
            SCnst [ 1 ] := UpCase ( SCnst [ 1 ] ) ;
            SCnst [ 2 ] := UpCase ( SCnst [ 2 ] ) ;
            SCnst [ 3 ] := UpCase ( SCnst [ 3 ] ) ;

            RadToHMS ( ORa , g, mnt, sec);

            Str(g  :3,s) ;
            If ( S[2] = ' ' ) Then
              S[2] := '0';
            SOut := SOut + S ;

            Str(mnt:3,s) ;
            If ( S[2] = ' ' ) Then
              S[2] := '0';
            SOut := SOut + S ;


            Str(sec:7:3,s);
            If ( s[2] = ' ' ) Then
              s[2] := '0';
            SOut := SOut + S ;

            RadToGMS ( ODc , Cneg , g , mnt , sec );

            Str(g  :4,s);
            If ( S[3] = ' ' ) Then S[3] := '0';
            If CNeg Then S[2]:='-';
            SOut := SOut + S ;

            Str(mnt:3,s);
            If ( s[2] = ' ' ) Then s[2] := '0';
            SOut := SOut + S ;

            Str(sec:6:2,s);
            If ( s[2] = ' ' ) Then
              s[2] := '0';
            SOut := SOut + S + ' ' ;

        End ;



        IF ( Cat = CatOthers )
          Then
            Begin

              S  := CatNameKutcha [ ( ObjectRecord.NRecC Mod 1000000000 ) Mod 20 ] ;

              S2 := '';

              If ( S = 'PSC' ) Or ( S = 'FSC' )  Then
                Begin
                  NameIras ( ObjectRecord.NRecC, S2 ) ;
                  S2 := Copy ( S2, 1, 11 ) ;
                End ;

              If ( S = 'TMSS' )  Then
                Begin
                  NameIras ( ObjectRecord.NRecC, S2 ) ;
                  S2 := Copy ( S2, 1, 6 ) ;
                  S2 := S2 + '     ' ;
                End ;

              If ( S = 'RAFGL' )  Then
                Begin
                  NameIras ( ObjectRecord.NRecC, S2 ) ;
                  S2 := Copy ( S2, 1, 5 ) ;
                  S2 := ' ' + S2 + '     ' ;
                End ;


              While ( Length ( S ) < 8 )  Do
                S := ' ' + S ;


              Str ( ( ObjectRecord.NRecC Mod 1000000000 ) Div 20 : 8, t ) ;

              If ( S2 = '' )
                Then S := S + t
                Else S2 := S2 + '        ';

              S := S + ' ' + S2 ;

            End
          Else
            Begin
              If ( Cat <> CatDm )
                Then
                  If ( Cat = CatNpm )
                    Then
                      Begin
                        Str ( ObjectRecord.M / C100 - 5 : 5 : 1 , s  ) ;
                        If  ( NpmRecord.BmV = -100 )
                          Then s1 := ' -9.9'
                          Else Str ( NpmRecord.BmV / C100 : 5 : 1 , s1 ) ;
                        S := S + S1 ;
                      End
                    Else
                      Begin
                        If (     ( Cat = CatHd )
                             And ( Not HdE     )  )
                          Then
                            Begin
                              Str ( HdRecord.Mv / C1000 : 5 : 1, s ) ;
                            End
                          Else
                            Begin
                               If ( Cat = CatA20 )
                                 Then
                                   Begin

                                     NmS := ObjectRecord.NRecC Mod 1000000000 ;
                                     RR  := Frac ( ObjectRecord.NRecC / C10000 ) * C1000 ;
                                     Nf := ( NmS Div 1000 ) Mod 1000 ;
                                     {
                                     If ( Nf = 0 )
                                       Then
                                         Begin
                                           S := '     '
                                         End
                                       Else
                                         Begin
                                           Str ( ObjectRecord.M / C100 : 5 : 1 , S ) ;
                                         End ;
                                     }

                                     Str ( ObjectRecord.M / C100 : 5 : 1 , S ) ;

                                     If ( RR < 99.8 )
                                       Then  Str ( RR : 5 : 1 , S1 )
                                       Else  S1 := '     ' ;
                                     S := S + S1 ;

                                   End
                                 Else
                                   Begin
                                     If (     ( Cat = CatImp )
                                          And ( B_Inport_Ccd )  )
                                       Then
                                         Str ( ObjectRecord.M * Abs ( StepDiamCcd ) : 5 : 0 , S )
                                       Else
                                         Str ( ObjectRecord.M / C100 - 5 : 5 : 1 , S ) ;
                                   End ;

                            End ;
                      End
                Else
                  Begin  { CatDm }
                    Mv := ObjectRecord.M / C100 - 5 ;
                    If ( Mv ) < 13.0
                      Then
                        Begin
                          Str ( Mv : 6 : 1 , s ) ;
                          S1 := '';
                        End
                      Else
                        Begin
                          S := '  20.0' ;
                          Case ( Round ( Frac ( Mv ) * C100 ) )  Of
                            2 : S1 :=  '  Neb ' ;
                            3 : S1 :=  '  Var ' ;
                            4 : S1 :=  '  Nova' ;
                            5 : S1 :=  '  Cum ' ;
                          End ;
                       End ;
                  End ;

            End ;


       If ( Cat = CatNLtt )  Then
         Str ( NLttRecord.Mv / C100 : 5 : 1, s ) ;


       If (     ( Cat = CatGcvs )
            And ( A_Pressed     ) )  Then
         S := '     ' ;


       If (     ( Cat = CatTyc )
            And ( B_Tyc_2      )  )  Then
         Begin
           If ( Not ( B_Tyc_2_Add ) )
             Then
               Begin
                 Str ( HipRecord.Mv / C100 : 6 : 2, S ) ;
                 If  ( HipRecord.Mv / C100 > C1000 )
                   Then  S := S + ' B'
                   Else  S := S + ' V';
               End
             Else
               Begin
                 If ( TycAddRecord.VT <> -32000 )
                   Then
                     Begin
                       Str ( TycAddRecord.VT / C10000 : 6 : 2, S ) ;
                       S := S + ' V';
                     End
                   Else
                     Begin
                       If ( TycAddRecord.BT <> -32000 )
                         Then
                           Begin
                             Str ( TycAddRecord.BT / C10000 : 6 : 2, S ) ;
                             S := S + ' B';
                           End
                         Else
                           Begin
                           End ;
                     End ;
               End ;
         End ;


        SOut := SOut + ' ' + S ;




                     { Sp }
                     { -- }

        If (    ( Cat = CatCdcMoz )
             Or ( Cat = CatA20    ) )
          Then  S := ''
          Else  S := '     ' ;

       If (     ( Cat = CatTyc )
            And ( B_Tyc_2      )  )  Then
         S := '  ' ;


        If (    ( Cat = CatPPM )
             Or ( Cat = CatSao )
             Or ( Cat = CatBs  )
                                  )  Then
          Begin

            S := '   ' + SpectraName [ ( ObjectRecord.Sp Mod 100 ) Div 10 + 1 ];

            If ( ObjectRecord.Sp Mod 100 ) Div 10 <> 7
              Then
                Begin
                  str( ObjectRecord.Sp Mod 10 : 1 , t );
                  s := s + t ;
                End
              Else
                  s := s + ' ' ;

          End ;


        {
        If ( Cat = CatSao  )   Then
          S := '  ' + SaoRecord.SpStr ;
        }

        If (     ( Cat = CatHd   )
             And ( HdE           ) )  Then
          S := '   ' + HdERecord.Sp ;


        If (     ( Cat = CatHd   )
             And ( Not HdE       ) )  Then
          S := '   ' + HdRecord.Sp ;


        If ( Cat = CatNLtt )  Then
          S := '  ' + NLttRecord.Sp + ' ' ;


        If ( Cat = CatNpm ) Then
          S := '' ;


        SOut := SOut + S  ;





               { P. M. }
               { ƒƒƒƒƒ }

        If (     ( ( Cat = CatCdc )  And  ( B_Cdc_Cat )  )
             Or  (   Cat = CatNpm                        )
             Or  (   Cat = CatNltt                       )
             Or  (   Cat = CatBs                         )
             Or  (   HdE                                 )
             Or  (   Cat = CatPpm                        )
             Or  (   Cat = CatHip                        )
             Or  (   Cat = CatTyc                        )
             Or  (   Cat = CatSao                        )
             And (   PmExist                             )  )  Then
           Begin
             If ( PmExist )
               Then
                 Begin { PmExist }
                   If ( Cat = CatNpm )
                     Then
                       Begin
                         Str ( PmRaArcSec   : 8:4 , S ) ;
                         SOut := SOut + S ;
                         Str ( PmDeclArcSec : 8:4 , S ) ;
                         SOut := SOut + ' ' + S ;
                       End
                     Else
                       Begin
                         If (     ( Cat = CatHip )
                              And ( B_Hip_Add    ) )
                           Then
                             Begin
                               {
                               Str ( PmRaArcSec   : 8:4 , S ) ;
                               SOut := SOut + S ;
                               Str ( PmDeclArcSec : 8:4 , S ) ;
                               SOut := SOut + S ;
                               }
                               Str ( PmRaArcSec   : 9:5 , S ) ;
                               SOut := SOut + S ;
                               Str ( PmDeclArcSec : 9:5 , S ) ;
                               SOut := SOut + S ;
                             End
                           Else
                             Begin
                               If (     ( Cat = CatTyc )
                                    And ( B_Tyc_2_Add  ) )
                                 Then
                                   Begin
                                     Str ( PmRaArcSec   : 8:4 , S ) ;
                                     SOut := SOut + S ;
                                     Str ( PmDeclArcSec : 8:4 , S ) ;
                                     SOut := SOut + ' ' + S ;
                                   End
                                 Else
                                   Begin
                                     If ( Cat = CatNLtt )
                                       Then Str ( PmRaArcSec   : 6:3 , S )
                                       Else Str ( PmRaArcSec   : 7:3 , S ) ;
                                     SOut := SOut + S ;
                                     Str ( PmDeclArcSec : 8:3 , S ) ;
                                     SOut := SOut +' '+ S ;
                                    End ;
                             End ;
                       End
                 End   { PmExist }
               Else
                 Begin { Pm Not Exist }

                   If ( Cat = CatCdc )  Then
                     Begin
                       Str ( CdcRecord.MUDEC / C1000 + 1900 : 9:2, S );
                       SOut := SOut + '                                ' + S ;
                     End ;

                   If (     ( Cat = CatTyc )
                        And ( B_Tyc_2      )  )  Then
                     SOut := SOut + '                 ';

                   If (     ( Cat = CatHip )
                        And ( B_Hip_Add    ) ) Then
                     SOut := SOut + '                  ';

                 End ; { Pm Not Exist }
           End ;



        If ( Cat = CatA20 )  Then
          Begin

            Nf := ( ObjectRecord.NRecC Div 1000 ) Mod 1000 ;

            If ( Nf <> 0 )  Then
              Begin

                If ( ObjectRecord.Sp Mod 10 ) And 2 = 2
                  Then
                    Begin
                      Seek ( A20DateSFile, Nf - 1 ) ;
                      Read ( A20DateSFile, S19    ) ;
                      DateA20 ( S19, S9 ) ;
                      t := 's';
                    End
                  Else
                    Begin
                      Seek ( A20DateNFile, Nf - 1 ) ;
                      Read ( A20DateNFile, S9     ) ;
                      t := 'n';
                    End ;

                SOut := SOut + '  ' ;

                t := '' ;
                For N1 := 1 To 2 Do
                  t := t + S9.S9 [ N1 ] ;
                Val ( t, Day, Code ) ;

                SMonth := '' ;
                For N1 := 4 To 6 Do
                  SMonth := SMonth + S9.S9 [ N1 ] ;
                Month := 1 ;
                While ( SMonth <> NameMonth [ Month ] )  Do
                  Inc ( Month ) ;

                t := '' ;
                For N1 := 8 To 9 Do
                  t := t + S9.S9 [ N1 ] ;
                Val ( t, Year, Code ) ;
                Year := Year + 1900 ;

                Jd8 ( Year, 0    , 0         , JdGsc0 ) ;
                Jd8 ( Year, Month, Day + 0.75, JdGsc  ) ;
                YearGsc := ( JdGsc0 - 2451545.0 ) / 365.25 + 2000.0 ;
                YearGsc := YearGsc + ( JdGsc - JdGsc0 ) / 365.25 ;
                Str ( YearGsc : 9:3 , t ) ;

                If ( A_Pressed )
                  Then
                    SOut := SOut + ' ' + t
                  Else
                    SOut := SOut + '                              ' + t ;

                Str ( Nf : 3, S1 ) ;
                While (     ( Length ( S1 ) > 0 )
                        And ( S1 [ 1 ] = ' '    ) )  Do
                  Delete ( S1, 1, 1 ) ;

                If ( ObjectRecord.Sp Mod 10 ) And 2 = 2
                  Then  t := 's'
                  Else  t := 'n' ;

                If ( S1 [ 1 ]  = ' ' )  Then
                     S1 [ 1 ] := '0';

                If ( S1 [ 2 ]  = ' ' )  Then
                     S1 [ 2 ] := '0';

                If ( Not B_Det_Imp )
                  Then  SOut := SOut + ' Plate ' + t + S1
                  Else  SOut := SOut + '           ' ;

              End ;


             If ( ( ( ObjectRecord.Sp Mod 10 ) And 1 ) = 1 )  Then
               SOut := SOut + ' m?' ;


          End ;


        If (     ( Cat = CatGsc )
             And ( GscAddExist  )  )  Then
          Begin { Number DSC }

            NRecC := Abs ( ObjectRecord.NRecC Mod 1000000000 ) ;

            If ( GscNew )
              Then
                Begin
                  Str ( NRecC / 100000.0  : 10:5 , S ) ;
                End
              Else
                Begin
                  Str ( NRecC / 10000.0   :  9:4 , S ) ;
                  S := S + ' ';
                End ;

            SOut := SOut + '                    ' + S ;

          End ; { Number DSC }


        If (     ( Cat = CatGsc     )
             And ( Not GscAddExist  )  )  Then
          SOut := SOut + '                              ';



        If (     ( Cat = CatGsc )
             And ( GscAddExist  )  )  Then
          Begin
            If ( ObjectRecord.SP Mod 10 >= 6 )
              Then
                SOut := SOut + ' V 1.1 '
              Else
                Begin
                  If ( ObjectRecord.NRecC Div 1000000000 <> 1 )
                    Then
                      Begin
                        RR := ObjectRecord.Date / C10000 + 1950.0 ;
                        If ( RR >= 1951.486 )
                          Then
                            Begin
                              Str ( RR : 11:3, S ) ;
                              SOut := SOut + S ;
                            End
                          Else
                              SOut := SOut + '           ' ;
                      End
                    Else
                        SOut := SOut + '           ' ;
                End ;
          End ;


        If ( Hde ) And ( Not PmExist )  Then
          Begin
            Str ( HdERecord.MuDec / C100 + 1900.0 : 8:1, S ) ;
            SOut := SOut + S + '        ' ;
          End ;


            { Number Star }
            { ƒƒƒƒƒƒƒƒƒƒƒ }

        If ( Cat = CatPPM )  Then
          Begin
            NRecC := PPMRecord.PPM Mod 1000000 ;
            Str ( NRecC : 6 , S );
            SOut := SOut + '        ' + S ;
          End ;



        If ( Cat = CatHip ) Then
          Begin
            If ( Not ( B_Hip_Add ) )
              Then
                Begin
                  NRecC := Abs ( HipRecord.NSerInFile ) Mod 2000000 ;
                End
              Else
                Begin
                  NRecC := HipAddRecord.HipNumber ;
                End ;
            Str ( NRecC : 7 , S );
            SOut := SOut + '     ' + S ;
          End ;


        If ( Cat = CatTyc )  Then
          Begin

            If ( B_Tyc_0 ) Then
              Begin
                NRecC := Abs ( HipRecord.NSerInFile ) Mod 2000000 ;
                Str ( NRecC : 7 , S );
                SOut := SOut + '     ' + S ;
              End ;

            If ( B_Tyc_Sai ) Then
              Begin
                NRecC := Abs ( HipRecord.NSerInFile ) Div 100000 ;
                Str ( NRecC  : 4 , S ) ;
                NRecC := Abs ( HipRecord.NSerInFile ) Mod 100000 ;
                Str ( NRecC  : 5 , t ) ;
                S := S + t ;
                If ( HipRecord.NSerInFile < 0 )
                  Then  S := S + '2'
                  Else  S := S + '1' ;
                SOut := SOut + '   ' + S ;
              End ;

            If ( B_Tyc_2 ) Then
              Begin
                NRecC := Abs ( HipRecord.NSerInFile ) Div 100000 ;
                Str ( NRecC  : 4 , S ) ;
                NRecC := Abs ( HipRecord.NSerInFile ) Mod 100000 ;
                Str ( NRecC  : 5 , t ) ;
                S := S + t ;
                t := ' 1';
                If ( HipRecord.Cat And 4 = 4 )
                  Then  t := ' 2';
                If ( HipRecord.Cat And 8 = 8 )
                  Then  t := ' 3';
                SOut := SOut + '  ' + S + t ;
              End ;

          End ;

        If ( Cat = CatSao )  Then
          Begin
            NRecC := SaoRecord.Sao ;
            Str ( NRecC : 6 , S );
            SOut := SOut + '        ' + S ;
          End ;


        If ( Cat = CatCdcMoz )  Then
          Begin

                 NZagol     := ObjectRecord.NRecC Mod 1000 ;
                 AkZagolRec := PlateZagol ^ [ NZagol ] ;

                 Str ( AkZagolRec.DcG : 4 , t ) ;
                 If ( t[3] = ' ' )  Then
                   t[3] := '0' ;
                 If ( t[3] = '-' )  Then
                   Begin
                     t[3] := '0' ;
                     t[2] := '-' ;
                   End ;
                 If ( t[2] = ' ' )  Then
                   t[2] := '+' ;
                 S := t + ' ' ;

                 Str ( AkZagolRec.RaH : 2 , t ) ;
                 If ( t[1] = ' ' )  Then  t[1] := '0' ;
                 S := S + t ;

                 Str ( AkZagolRec.RaM : 2 , t ) ;
                 If ( t[1] = ' ' )  Then  t[1] := '0' ;
                 S := S + '.' + t ;

                 Year  := AkZagolRec.Year ;
                 Month := AkZagolRec.Mon  ;
                 Day   := AkZagolRec.Day  ;

                 Str ( Year : 5 , t ) ;
                 S := S + t + ' ' ;

                 S := S + MonthName [ Month ] ;

                 Str ( Day : 2 , t ) ;
                 S := S + ' ' + t + ' ' ;

                 SOut := SOut + S ;


                 t := '';
                 S := t ;


                 RI := ( ObjectRecord.NRecC Mod 1000000000 ) Div 1000  ;

                 Str ( RI Div 10  : 6 , t ) ;

                 If  ( RI Mod 10 > 0 )
                   Then  t := t + Chr ( Ord('a')+ (RI Mod 10 - 1))
                   Else  t := t + ' ' ;



                       { èp®ß≠†™® à·Øp†¢´•≠®© }
                       { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
                 N1 := ObjectRecord.Sp Mod 10 ;

                 If ( N1 Mod 2 = 1 )
                   Then  t := t + ' X?' ;

                 If ( ( N1 Mod 4 ) Div 2 = 1 )
                   Then  t := t + ' Y?' ;


                 S := S + t ;



                 SOut := SOut + ' ' + S ;


          End ;


        If ( Cat = CatNPM )  Then
          Begin
            NRecC := NpmRecord.Num ;
            Str ( Abs ( NRecC ) / 10000  : 8 : 4 , s ) ;
            If  ( S [ 2 ] = ' ' )  Then
              S [ 2 ] := '0' ;
            If ( NRecC > 0 )
              Then S [ 1 ] := '+'
              Else S [ 1 ] := '-' ;
            SOut := SOut + '     ' + S ;
          End ;

        If ( Cat = CatBs )  Then
          Begin
            Str   ( BsSrcRecord.Bs : 6 , S );
            SOut := SOut + '        ' + S ;
          End ;


        If ( Cat = CatNLtt )  Then
          Begin
            SOut := SOut + '     ' + NLttRecord.Name ;
          End ;


        If ( Cat = CatHd )    Then
          Begin  { CatHd }
            If ( Not HdE )
              Then
                Begin

                  S  := HdRecord.Dm ;

                  Str ( HdRecord.Num : 6 , t ) ;
                  S := S + '  ' + t ;

                  Str ( HdRecord.Mp / C1000 : 5 : 1, t ) ;
                  S := S + ' Mp:' + t ;

                  RI := 0 ;
                  If ( HdRecord.Mv / C1000 ) > 19.9 Then
                    RI := Round ( HdRecord.Mv / C1000 ) ;
                  If ( HdRecord.Mp / C1000 ) > 19.9 Then
                    RI := Round ( HdRecord.Mp / C1000 ) ;
                  If ( RI > 0 )  Then
                    Begin
                      Case RI Of
                           20 : S := S + ' Neb' ;
                           30 : S := S + ' Var' ;
                           40 : S := S + ' Nov' ;
                           50 : S := S + ' Cl ' ;
                      End ;
                    End ;

                  SOut := SOut + ' ' + S ;

                End
              Else
                Begin
                  Str ( HdERecord.Num Div 10 : 6 , s ) ;
                  N1 := HdERecord.Num Mod 10 ;
                  If ( N1 > 0 )  Then
                  S := S + ' ' + Chr ( N1 - 1 + Ord ( 'A')  ) ;
                  SOut := SOut + ' ' + S ;
                End ;

          End ;  { CatHd }



        If ( Cat = CatGcvs )  Then
           Begin

             S :=   GcvsRecord.NameStr
                  + GcvsRecord.MStr
                  + GcvsRecord.SpStr    ;

             SOut := SOut + ' ' + S ;

             If ( Length ( S ) < 50 ) Then
               For I := Length ( S ) To 50 Do
                 SOut := SOut + ' ' ;

             If ( PmExist )  Then
               Begin
                 Str ( PmRaArcSec   : 7:3 , S ) ;
                 SOut := SOut + S ;
                 Str ( PmDeclArcSec : 8:3 , S ) ;
                 SOut := SOut + S ;
               End ;

           End ;


        If ( Cat = CatDm )  Then
          Begin

                 Nms := ObjectRecord.NRecC Mod 1000000000 ;

                 NAdd  := Nms   Mod     10 ;
                 NSer  := Nms   Div     10 ;
                 NDecl := NSer  Div 100000 ;
                 NSer  := NSer  Mod 100000 ;
                 NDm   := Trunc ( NDecl Div 200 ) ;
                 NDecl := NDecl - NDm * 200       ;
                 NDecl := NDecl - 100 ;

                 If ( NDecl >= 0 )
                   Then
                     Begin
                       Str ( Abs ( NDecl ) : 3 , S ) ;
                       S [ 1 ] := '+' ;
                     End
                   Else
                     Begin
                       Inc ( NDecl ) ;
                       Str ( Abs ( NDecl ) : 3 , S ) ;
                       S [ 1 ] := '-' ;
                     End ;

                 S := ' ' + S ;

                 If (     ( NameDm [ NDm ] = 'SD' )
                      And ( NDecl < -1            )  )
                   Then  S := NameDm [ NDm - 1 ] + S
                   Else  S := NameDm [ NDm     ] + S ;

                 Str ( NSer : 6, t ) ;

                 S := S + t + NDmAdd [ NAdd ] ;

                 SOut := SOut + ' ' + S + S1 ;

                 If ( DetDm [ NDm ] = 1 )
                   Then NDet := 1
                   Else NDet := 0 ;
                 DetDm [ NDm ] := 1 ;

          End ;




        If (     ( Cat = CatTyc  )
             And ( B_Tyc_2_Add   )
             And ( Not A_Pressed ) )  Then
          Begin

            SOut := SOut + '             ';

            If ( TycAddRecord.MqePmRa > -30000 )
              Then Str ( TycAddRecord.MqePmRa   /   10.0  : 5:1, S )
              Else S := '     ' ;
            SOut := SOut + S ;

            If ( TycAddRecord.MqePmDecl > -30000 )
              Then Str ( TycAddRecord.MqePmDecl /   10.0  : 5:1, S )
              Else S := '     ' ;
            SOut := SOut + S ;

            If ( TycAddRecord.VT > -30000 )
              Then Str ( TycAddRecord.VT        / 1000.0  : 8:3, S )
              Else S := '        ' ;
            SOut := SOut + S ;

            If ( TycAddRecord.BT > -30000 )
              Then Str ( TycAddRecord.BT        / 1000.0  : 8:3, S )
              Else S := '        ' ;
            SOut := SOut + S ;

            If ( TycAddRecord.MqeVT > -30000 )
              Then Str ( TycAddRecord.MqeVT     / 1000.0  : 8:3, S )
              Else S := '        ' ;
            SOut := SOut + S ;

            If ( TycAddRecord.MqeBT > -30000 )
              Then Str ( TycAddRecord.MqeBT     / 1000.0  : 8:3, S )
              Else S := '        ' ;
            SOut := SOut + S ;


          End ;



        If (     ( Cat = CatHip  )
             And ( B_Hip_Add     )
             And ( Not A_Pressed ) )  Then
          Begin

            SOut := SOut + '            ';

            If ( HipAddRecord.Par > -30000 )
              Then  Str ( HipAddRecord.Par * 1000.0  : 7:2, S  )
              Else  S := '       ' ;
            SOut := SOut + S ;

            If ( HipAddRecord.MqePar > -30000 )
              Then  Str ( HipAddRecord.MqePar / 100.0  : 7:2, S  )
              Else  S :=  '       ' ;
            SOut := SOut + S ;

            If ( HipAddRecord.MqePmRa > -30000 )
              Then  Str ( HipAddRecord.MqePmRa / 100.0  : 7:2, S  )
              Else  S :=  '       ' ;
            SOut := SOut + S ;

            If ( HipAddRecord.MqePmDecl > -30000 )
              Then  Str ( HipAddRecord.MqePmDecl / 100.0  : 7:2, S  )
              Else  S :=  '       ' ;
            SOut := SOut + S ;

            If ( HipAddRecord.CorrPmRaPmDecl > -30000 )
              Then  Str ( HipAddRecord.CorrPmRaPmDecl / 1000.0  : 7:2, S  )
              Else  S :=  '       ' ;
            SOut := SOut + S ;

            If ( HipAddRecord.VT > -30000 )
              Then  Str ( HipAddRecord.VT / 1000.0  : 7:3, S  )
              Else  S :=  '       ' ;
            SOut := SOut + S ;

            If ( HipAddRecord.BT > -30000 )
              Then  Str ( HipAddRecord.BT / 1000.0  : 7:3, S  )
              Else  S :=  '       ' ;
            SOut := SOut + S ;

            If ( HipAddRecord.BmV > -30000 )
              Then  Str ( HipAddRecord.BmV / 1000.0  : 7:3, S  )
              Else  S :=  '       ' ;
            SOut := SOut + S ;

            If ( HipAddRecord.VmI > -30000 )
              Then  Str ( HipAddRecord.VmI /  100.0  : 6:2, S  )
              Else  S :=  '      '  ;
            SOut := SOut + S ;

            SOut := SOut + '  ' + HipAddRecord.RefFlgColInd ;
            SOut := SOut        + HipAddRecord.FlgVar       ;
            SOut := SOut        + HipAddRecord.SrcBmV       ;
            SOut := SOut        + HipAddRecord.SrcVmI       ;
            SOut := SOut        + HipAddRecord.SrcSp        ;
            SOut := SOut + '  ' + HipAddRecord.Spectr       ;


          End ;



           { End  Det String }
           { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
        {
        If ( ( Cat = CatCdc )  And  ( B_Cdc_Cat )  )
          Then SOut := SOut + '  ;'
          Else SOut := SOut + '  ;'  ;
        }
        SOut := SOut + '  ;'  ;


        If  ( Auto )
          Then
            Begin
              If (     (  ( Cat =  CatDm ) And ( NDet > 0 ) )
                   Or  (  ( Cat <> CatDm ) And ( NDet > 1 ) )  )
              Then  SOut :=  ' -> '  +  SOut
              Else  SOut :=  ' => '  +  SOut ;
            End
          Else
               SOut :=  ' => '  +  SOut ;
        {
        If ( ( Auto )  And ( NDet > 0 ) )
           Then  SOut :=  ' -> '  +  SOut
           Else  SOut :=  ' => '  +  SOut ;
        }


        NPosAuto := Pos ( ':' , SDetOut ) ;
        NPosManu := Pos ( '+' , SDetOut ) ;


        If ( Auto )
          Then  { èp•§ÍÔ¢´•≠Æ †¢‚Æ¨†‚®Á•·™Æ• Æ‚Æ¶§•·‚¢´•≠®• }
                { ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ }
            Begin  { Auto }

              If ( NPosAuto > 0 )
                Then
                  Begin  { ê†≠•• °Î´Æ †¢‚Æ¨†‚®Á•·™Æ• }
                         { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

                  { é·‚†¢´Ô•¨ ·‚†pÆ• §´Ô Æ°•·Ø•Á•≠®Ô '™†·™†§≠Æ·‚®' Æ‚Æ¶§. }
                  { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

                    If ( Cat = CatDm )
                      Then
                        Begin
                          If ( Length ( SDetOut + SOut ) < 254 )
                            Then
                              Begin
                                SDetOut := SDetOut + SOut ; { Dm §Æ°†¢´Ô•¨ }
                                B_Cnst_New := True ;
                              End
                            Else
                              If ( Length ( SDetOut ) < 254 )  Then
                                SDetOut := SDetOut + '~' ;
                        End
                  End
                Else
                  Begin  { ê†≠•• ≠• °Î´Æ †¢‚Æ¨†‚®Á•·™Æ£Æ }
                         { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
                    If ( NPosManu = 0 )  Then
                        Begin  { ê†≠•• ≠• °Î´Æ 'p„Á≠Æ£Æ'}
                               { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
                            { ì·‚†≠†¢´®¢†•¨ †¢‚Æ¨†‚®Á•·™Æ• }
                            { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
                          If ( Cat = CatDm )
                            Then
                              Begin
                                If ( Length ( SDetOut + SOut ) < 254 )
                                  Then
                                    Begin
                                      SDetOut := SDetOut + SOut ; { Dm §Æ°†¢´Ô•¨ }
                                      B_Cnst_New := True ;
                                    End
                                  Else
                                    If ( Length ( SDetOut ) < 254 ) Then
                                      SDetOut := SDetOut + '~' ;
                              End
                            Else
                              Begin
                                SDetOut := SOut ;
                                B_Cnst_New := True ;
                              End ;
                        End
                      Else
                        Begin  { ê†≠•• °Î´Æ 'p„Á≠Æ•'}
                               { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
                          { 'ê„Á≠Æ¨„' Øp®Æp®‚•‚. H† †¢‚Æ ≠• ß†¨•≠Ô•¨ }
                          { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
                        End ;

                  End ;

            End    { Auto }

          Else  { èp•§ÍÔ¢´•≠Æ 'p„Á≠Æ•' Æ‚Æ¶§•·‚¢´•≠®• }
                { ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ }

            Begin  { Manu }

              { á†¨•≠®¨ ´Ó°Æ• ≠† 'p„Á≠Æ•':  'ê„Á≠Æ¨„' Øp®Æp®‚•‚ }
              { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

               SDetOut := SOut ;
               B_Cnst_New := True ;

            End ;  { Manu }

     If ( B_Cnst_New = False ) Then
       SCnst := '' ;


     FileMode := 2 ;


 End ;  { ObjectOut }
        { ƒƒƒƒƒƒƒƒƒ }

 End.