
{$O+,F+}

 UNIT POptImp ;

   INTERFACE


   USES   DOS, PVAR,  PMem, V_CATAL, PSortImp, PAtan2 ;


	  PROCEDURE OptImp  ;


   IMPLEMENTATION


	  PROCEDURE OptImp ;
        { **************** }

   VAR

        EndReadFile,
        PmExist,
        Ext, Pusto          : Boolean ;

        DeclSig, Cs         : Char    ;

        NOS1,
        NOS2,
        NWrite              : Word    ;

        I, N,
        Code,
        NNoDet,
        SigDecl             : Integer ;

        RaMin, RaMax,
        DeclMin, DeclMax,
        Ra,   Decl,
        X, Y, Z,
        DtMu,
        Mr, Md,
        SRaSt, CRaSt,
        SDecSt, CDecSt,
        XMin, XMax,
        YMin, YMax,
        Mv,
        Rrn                 : Double  ;

        S1                  : String [ 8 ] ;
        Kvadrant            : Array  [ 1 .. 4 ]  Of  Byte ;

        Label ObxRMS, ObxDMS ;

    Begin


                   If (  ( B_ObjOut )  And  ( NOF > 0  )  )  Then
                     Begin { ¨è¥¬ ¯p¥¤ë¤ãéãî ®â®¦¤¥áâ¢«¥­­ãî £pã¯¯ã }
                           { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                       IFirst := IndCat [ CatImp ] . NBeg ;
                       ILast  := IndCat [ CatImp ] . NEnd ;

                       SortImpSerNumb ( IFirst, ILast );
                      {ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ }

                       NWrite := 0 ;

                       For N := IFirst  To  ILast  Do
                         Begin

                           Code := Objectptr [ N Div ObjectBlockSize ] ^
                                             [ N Mod ObjectBlockSize ].
                                               NRecC Mod 1000000000 ;

                           Code := Abs ( Code ) ;

                           Seek ( OutStarFile , Code - 1 ) ;
                           Seek ( OutDetFile  , Code - 1 ) ;

                           Read ( OutStarFile , OutStarString ) ;
                           Read ( OutDetFile  , OutDetString  ) ;

                           Str  ( NGrImport : 7 , s1 ) ;
                           OutStarString := OutStarString + S1 + ' ' ;

                           If ( Length ( OutDetString ) > 0 )
                             Then
                               Begin
                                 Write   ( ObjectOutFile , OutStarString ) ;
                                 Writeln ( ObjectOutFile , OutDetString  ) ;
                                 NWrite := NWrite + 1 ;
                               End
                             Else
                               Begin
                                 Writeln ( ObjectOutFile , OutStarString ) ;
                                 NWrite := NWrite + 1 ;
                               End ;

                         End ; { ¨è¥¬ ¯p¥¤ë¤ãéãî ®â®¦¤¥áâ¢«¥­­ãî £pã¯¯ã }
                               { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }



                       If ( ( NWrite > 0 ) And ( NStarGrMax > 1 ) ) Then
                         Writeln  ( ObjectOutFile, '' ) ;

                       IndCat [ CatImp ] . NBeg := -1 ;
                       IndCat [ CatImp ] . NEnd := -2 ;

                     End ;


                 DtMu := ( JDate - JdEp ) / 365.25 ;

                 NOF := 0 ;

                 RaMin   :=   C1000 ;
                 RaMax   := - C1000 ;
                 DeclMin :=   C1000 ;
                 DeclMax := - C1000 ;

                 Seek  ( ImportStarFile, 0 ) ;
                 EndReadFile  := False ;

                 For  N :=  1  To  4  Do
                   Kvadrant [ N ] := 0 ;



                   { —¨â ¥¬ ®ç¥p¥¤­ãî £pã¯¯ã ®¡ê¥ªâ®¢ }
                   { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                 If (    ( B_ObjOut )
                      Or ( B_Export )  )  Then
                   Begin
                     Seek ( OutDetFile, 0  ) ;
                   End ;


                 Seek ( OutStarFile, 0 ) ;

                 If ( NGrImportBeg > 0 )  Then
                   Begin  { —¨â ¥¬ ä ©« ®¡ê¥ªâ®¢ }
                          { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                   NNoDet := 0 ;


                   If ( Eof ( ObjectFile ) )  Then
                    Begin
                      EndProc     := True ;
                      EndReadFile := True ;
                      If ( NOF = 0 )
                         Then  CalcFild := False ;
                    End ;


                   While  (     ( Not EndReadFile        )
                            And ( Not Eof ( ObjectFile ) )  )  Do
                    Begin { While }

                     ReadLn ( ObjectFile , ObjectString ) ;

                     N     := Length  ( ObjectString )  ;
                     I     := 1                         ;
                     Ext   := False                     ;
                     Pusto := True                      ;

                     While  ( ( I <= N ) And ( Not Ext ) )  Do
                       Begin { ¤ ­­ë¥ - ª®¬¥­â p¨©? }
                         Cs := ObjectString [ I ] ;
                         If ( Cs <> ' ' )  Then
                           Begin
                             Ext := True ;
                             {
                             If ( ( Cs < '0' )  Or  ( Cs > '2' ) )
                               Then  Pusto := True
                               Else  Pusto := False ;
                             }
                             If (    ( Cs < '0' )
                                  Or ( ( FormatImport [ 8 ] = 0 ) And ( Cs > '2' ) )
                                  Or ( ( FormatImport [ 8 ] = 1 ) And ( Cs > '9' ) )
                                 )
                               Then  Pusto := True
                               Else  Pusto := False ;
                           End ;
                         Inc ( I ) ;
                       End ;



                     If (      ( B_ObjOut         )
                          And  ( Pusto            )
                          And  ( NOF = 0          ) )  Then
                       Writeln ( ObjectOutFile, ObjectString );



                     If  ( Not Pusto  )   Then
                     Begin  { ‘âp®ª  á ¨­ä®p¬ æ¨¥© }
                            { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                        { ‚ë¡®p áãé¥áâ¢ãîé¨å ®â®¦¤¥áâ¢«¥­¨© }
                        { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                       NOS1 := Pos ( ' =>' , ObjectString ) ;
                       If ( NOS1 = 0 )  Then
                          NOS1 := Pos ( ' ->' , ObjectString ) ;

                       If ( NOS1 > 0 )
                         Then
                           Begin { Det Exist }
                                 { ÄÄÄÄÄÄÄÄÄ }

                             OutDetString :=
                                    Copy  ( ObjectString, 1, NOS1-1 );
                             Write ( OutStarFile,  OutDetString ) ;

                             OutDetString := ObjectString ;
                             Delete ( OutDetString, 1 , NOS1 - 1 ) ;

                           End
                         Else
                           Begin { Det Not Exist }
                                 { ÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                             OutDetString := ''   ;
                             NNoDet := NNoDet + 1 ;

                             Write ( OutStarFile ,  ObjectString ) ;

                           End ;




                       If (    ( B_ObjOut )
                            Or ( B_Export )  )  Then
                         Begin
                           Write ( OutDetFile , OutDetString ) ;
                         End ;



                                { R. A. }
                                { ÄÄÄÄÄ }

                       While (     ( ObjectString[1]         = ' ' )
                               And ( Length ( ObjectString ) >  0  )  )  Do
                         Delete ( ObjectString, 1 , 1 ) ;

                       NOS1 := Pos ( ' ' , ObjectString ) ;

                       ObjectS := Copy ( ObjectString , 1 , NOS1 - 1 ) ;
                       Delete ( ObjectString, 1 , NOS1 - 1 ) ;

                       Val ( ObjectS , RRN ,  Code  ) ;

                       OFRecord.Ra :=  RRN * C36000 ;


                       If ( FormatImport [ 8 ] = 1 )  Then
                         GoTo ObxRMS ;

                       While (     ( ObjectString[1]         = ' ' )
                               And ( Length ( ObjectString ) >  0  )  )  Do
                         Delete ( ObjectString, 1 , 1 ) ;

                       NOS1 := Pos ( ' ' , ObjectString ) ;

                       ObjectS := Copy ( ObjectString , 1 , NOS1 - 1 ) ;
                       Delete ( ObjectString, 1 , NOS1 - 1 ) ;

                       Val ( ObjectS , RRN ,  Code  ) ;

                       OFRecord.Ra :=  OFRecord.Ra + RRN * C600 ;


                       If ( FormatImport [ 1 ] = 1 )  Then
                         Begin

                           While (     ( ObjectString[1]         = ' ' )
                                   And ( Length ( ObjectString ) >  0  )  )  Do
                             Delete ( ObjectString, 1 , 1 ) ;

                           NOS1 := Pos ( ' ' , ObjectString ) ;

                           ObjectS := Copy ( ObjectString , 1 , NOS1 - 1 ) ;
                           Delete ( ObjectString, 1 , NOS1 - 1 ) ;

                           Val ( ObjectS , RRN ,  Code  ) ;

                           OFRecord.Ra :=  ( OFRecord.Ra + RRN ) ;

                         End ;


                       OFRecord.Ra := OFRecord.Ra * 15 ;

                       ObxRMS :;

                       OFRecord.Ra := OFRecord.Ra / SekRad ;

                       If ( OFRecord.Ra > Pi2 )  Then
                         OFRecord.Ra := OFRecord.Ra - Pi2 ;


                                { Decl }
                                { ÄÄÄÄ }

                       DeclSig := ' ' ;

                       While (     ( ObjectString[1]         = ' ' )
                               And ( Length ( ObjectString ) >  0  )  )  Do
                         Delete ( ObjectString, 1 , 1 ) ;

                       If ( ObjectString[1] = '+' ) Then  DeclSig := '+' ;
                       If ( ObjectString[1] = '-' ) Then  DeclSig := '-' ;
                       If ( DeclSig <> ' ' ) Then
                         Begin
                           ObjectString[1] := ' ' ;
                           While (     ( ObjectString[1]         = ' ' )
                                   And ( Length ( ObjectString ) >  0  )  )  Do
                             Delete ( ObjectString, 1 , 1 ) ;

                         End ;


                       NOS1 := Pos ( ' ' , ObjectString ) ;
                       If ( NOS1 = 0 ) Then
                         NOS1 := Length ( ObjectString ) + 1 ;

                       ObjectS := Copy ( ObjectString , 1 , NOS1 - 1 ) ;
                       Delete ( ObjectString, 1 , NOS1 - 1 ) ;

                       Val ( ObjectS , RRN ,  Code  ) ;

                       OFRecord.Decl :=  RRN * C36000 ;


                       If ( FormatImport [ 8 ] = 1 )  Then
                         GoTo ObxDMS ;



                       While (     ( ObjectString[1]         = ' ' )
                               And ( Length ( ObjectString ) >  0  )  )  Do
                         Delete ( ObjectString, 1 , 1 ) ;

                       NOS1 := Pos ( ' ' , ObjectString ) ;
                       If ( NOS1 = 0 ) Then
                         NOS1 := Length ( ObjectString ) + 1 ;

                       ObjectS := Copy ( ObjectString , 1 , NOS1 - 1 ) ;
                       Delete ( ObjectString, 1 , NOS1 - 1 ) ;

                       Val ( ObjectS , RRN ,  Code  ) ;

                       OFRecord.Decl :=  OFRecord.Decl + RRN * C600 ;



                       If ( FormatImport [ 2 ] = 1 )  Then
                         Begin

                           While (     ( ObjectString[1]         = ' ' )
                                   And ( Length ( ObjectString ) >  0  )  )  Do
                             Delete ( ObjectString, 1 , 1 ) ;

                           NOS1 := Pos ( ' ' , ObjectString ) ;
                           If ( NOS1 = 0 ) Then
                             NOS1 := Length ( ObjectString ) + 1 ;

                           ObjectS := Copy ( ObjectString , 1 , NOS1 - 1 ) ;
                           Delete ( ObjectString, 1 , NOS1 - 1 ) ;

                           Val ( ObjectS , RRN ,  Code  ) ;

                           OFRecord.Decl := ( OFRecord.Decl + RRN ) ;

                         End ;


                       ObxDMS :;

                       OFRecord.Decl := OFRecord.Decl / SekRad ;

                       If ( DeclSig = '-' )
                         Then  OFRecord.Decl := - OFRecord.Decl ;



                              {  P. M.  }
                              {  ÄÄÄÄÄ  }

                       OFRecord.PmRa   :=   0.0 ;
                       OFRecord.PmDecl :=   0.0 ;
                       PmExist         := False ;

                       If (     ( Length ( ObjectString )    >= 3 )
                            And ( Abs ( FormatImport [ 3 ] ) =  1 )  )  Then
                         Begin  { Exists P.M. }

                           PmExist := True ;

                           While (     ( ObjectString[1]         = ' ' )
                                   And ( Length ( ObjectString ) >  0  )  )  Do
                             Delete ( ObjectString, 1 , 1 ) ;

                           NOS1 := Pos ( ' ' , ObjectString ) ;

                           ObjectS := Copy ( ObjectString , 1 , NOS1 - 1 ) ;
                           Delete ( ObjectString, 1 , NOS1 - 1 ) ;

                           Val ( ObjectS , RRN,  Code  ) ;
                           OFRecord.PmRa := RRN / SekRad ;

                           If ( FormatImport [ 3 ] < 0 )  Then
                             OFRecord.PmRa := OFRecord.PmRa
                                              / 15.0 * Cos ( OFRecord.Decl ) ;



                           While (     ( ObjectString[1]         = ' ' )
                                   And ( Length ( ObjectString ) >  0  )  )  Do
                             Delete ( ObjectString, 1 , 1 ) ;

                           NOS1 := Pos ( ' ' , ObjectString ) ;

                           If ( NOS1 = 0 )
                             Then
                               ObjectS := ObjectString
                             Else
                               Begin
                                 ObjectS := Copy ( ObjectString , 1 , NOS1 - 1 ) ;
                                 Delete ( ObjectString, 1 , NOS1 - 1 ) ;
                               End ;

                           Val ( ObjectS , RRN,  Code  ) ;
                           OFRecord.PmDecl := RRN / SekRad ;



                         End ;  { Exists P.M. }


                       If PmExist Then
                         Begin { P.M. Reduction Coord }

                           If ( FormatImport [ 6 ] = 1 )  Then
                             Begin { Epoc Observation }

                               While (     ( ObjectString[1]         = ' ' )
                                       And ( Length ( ObjectString ) >  0  )  )  Do
                                 Delete ( ObjectString, 1 , 1 ) ;

                               NOS1 := Pos ( ' ' , ObjectString ) ;

                               ObjectS := Copy ( ObjectString , 1 , NOS1 - 1 ) ;
                               Delete ( ObjectString, 1 , NOS1 - 1 ) ;

                               Val ( ObjectS , RRN,  Code  ) ;
                               RRN := 2451545.0 + ( RRN - 2000.0 ) * 365.25 ;

                               DtMu := ( JDate - RRN ) / 365.25 ;

                             End ; { Epoc Observation }

                           Mr := OFRecord.PmRa   * DtMu ;
                           Md := OFRecord.PmDecl * DtMu ;

                           SRaSt  := Sin ( OFRecord.Ra   ) ;
                           CRaSt  := Cos ( OFRecord.Ra   ) ;
                           SDecSt := Sin ( OFRecord.Decl ) ;
                           CDecSt := Cos ( OFRecord.Decl ) ;

                           X := CRaSt * CDecSt - Md * SDecSt * CRaSt - Mr * SRaSt ;
                           Y := SRaSt * CDecSt - Md * SDecSt * SRaSt + Mr * CRaSt ;
                           Z := SDecSt         + Md * CDecSt                      ;

                           OfRecord.Ra   := ATan2 ( Y , X ) ;
                           OfRecord.Decl := Atan2 ( Z , Sqrt ( Sqr ( X ) + Sqr ( Y ) )  ) ;
                           If ( OfRecord.Decl > Pi )  Then
                             OfRecord.Decl := OfRecord.Decl - Pi2 ;

                         End ;


                                { Mv }
                                { ÄÄ }

                       Mv := 10.0 ;

                       If ( FormatImport [ 4 ] = 1 )  Then
                         Begin

                           While (     ( ObjectString[1]         = ' ' )
                                   And ( Length ( ObjectString ) >  0  )  )  Do
                             Delete ( ObjectString, 1 , 1 ) ;

                           NOS1 := Pos ( ' ' , ObjectString ) ;

                           If ( NOS1 = 0 )
                             Then
                               Begin
                                 ObjectS := ObjectString ;
                                 ObjectString := '' ;
                               End
                             Else
                               Begin
                                 ObjectS := Copy ( ObjectString , 1 , NOS1 - 1 ) ;
                                 Delete ( ObjectString, 1 , NOS1 - 1 ) ;
                               End ;

                           Val ( ObjectS , Mv ,  Code  ) ;

                           If ( Mv  > 20.5 )  Then
                                Mv := 20.5 ;

                         End ;

                       OFRecord.Mv := Round ( ( Mv + 5 ) * 10 ) ;



                               { NameImp }
                               { ÄÄÄÄÄÄÄ }

                       NameImp := '' ;

                       If ( FormatImport [ 6 ] > 0 )
                         Then
                           Begin
                             For  N := 1 To FormatImport [ 5 ] Do
                               If ( Length ( ObjectString ) > 0 ) Then
                               Delete ( ObjectString, 1 , 1 ) ;
                             If ( Length ( ObjectString ) > FormatImport [ 6 ] ) Then
                               NameImp := Copy ( ObjectString,
                                                 1, FormatImport [ 6 ] ) ;
                           End
                         Else
                           Begin
                             While (     ( ObjectString[1]         = ' ')
                                     And ( Length ( ObjectString ) > 0  ) ) Do
                               Delete ( ObjectString, 1 , 1 ) ;
                               NOS1 := Pos ( ' ' , ObjectString ) ;
                               If ( NOS1 = 0 )  Then
                                 NOS1 := Length ( ObjectString ) ;
                               If ( Length ( ObjectString ) > 0 ) Then
                                 NameImp := Copy ( ObjectString, 1, NOS1 - 1 ) ;
                           End ;



                       Write ( ImportStarFile, OFRecord ) ;

                       Inc ( NOF ) ;

                       If ( NOF >= NStarGrMax )
                         Then  EndReadFile := True ;



                              { p¥¤¥«ë ¯®«ï §p¥­¨ï }
                              { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                       N := Trunc ( OFRecord.Ra / PiD2 ) + 1 ;
                       Kvadrant [ N ] := 1 ;


                       If ( OFRecord.Ra > RaMax )
                            Then  RaMax := OFRecord.Ra ;

                       If ( OFRecord.Ra < RaMin )
                            Then  RaMin := OFRecord.Ra ;

                       If ( OFRecord.Decl > DeclMax )
                            Then  DeclMax := OFRecord.Decl ;

                       If ( OFRecord.Decl < DeclMin )
                            Then  DeclMin := OFRecord.Decl ;


                     End    { ‘âp®ª  á ¨­ä®p¬ æ¨¥© }
                            { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                    Else

                     Begin  { H¥¨­ä®p¬ æ¨®­­ ï ‘âp®ª  }
                            { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                       If  (     ( NNoDet = 0    )
                             And ( Not B_Det_Imp ) )  Then

                         Begin  { NNoDet = 0 }
                                { ÄÄÄÄÄÄÄÄÄÄ }

                           If ( B_ObjOut )  Then
                             Begin  { ¥p¥¯¨áë¢ ¥¬ ¢ ¢ëå. ä. ¡¥§ ®â®¦¤. }
                                    { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                               Seek  ( OutStarFile, 0 ) ;
                               Seek  ( OutDetFile , 0 ) ;

                               For N := 1  To  NOF  Do
                                 Begin

                                   Read ( OutStarFile  , OutStarString ) ;
                                   Read ( OutDetFile   , OutDetString  ) ;

                                   If ( Length ( OutDetString ) > 0 )
                                     Then
                                       Begin
                                         Write   ( ObjectOutFile ,
                                                   OutStarString) ;
                                         Writeln ( ObjectOutFile ,
                                                   OutDetString ) ;
                                       End
                                     Else
                                       Writeln ( ObjectOutFile ,
                                                 OutStarString ) ;

                                 End ;

                             End ;  { ¥p¥¯¨áë¢ ¥¬ ¢ ¢ëå. ä. ¡¥§ ®â®¦¤. }
                                    { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                           If (    ( B_ObjOut )
                                Or ( B_Export )  )  Then
                             Begin
                               Seek  ( OutDetFile    , 0 ) ;
                               Seek  ( ImportStarFile, 0 ) ;
                             End ;

                           Seek ( OutStarFile, 0 ) ;

                           NOf     :=     0   ;
                           RaMin   :=   C1000 ;
                           RaMax   := - C1000 ;
                           DeclMin :=   C1000 ;
                           DeclMax := - C1000 ;

                           For  N :=  1  To  4  Do
                             Kvadrant [ N ] := 0 ;


                         End    { NNoDet = 0 }
                                { ÄÄÄÄÄÄÄÄÄÄ }
                        Else

                         Begin

                           If ( NOF > 0 )  Then
                             EndReadFile := True ;

                         End ;


                     End ;  { H¥¨­ä®p¬ æ¨®­­ ï ‘âp®ª  }
                            { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }


                    End ; { While }



                     If ( Eof ( ObjectFile ) )  Then
                        Begin
                           EndProc     := True ;
                           EndReadFile := True ;
                           If ( NOF = 0 )
                              Then  CalcFild := False ;
                        End ;



                   If ( CalcFild )  Then
                    Begin  { CalcFild }
                           { ÄÄÄÄÄÄÄÄ }


                         { –¥­âp ¯®«ï }
                         { ÄÄÄÄÄÄÄÄÄÄ }

                     If (    ( ( Kvadrant [1] = 1 ) And ( Kvadrant [3] = 1 ) )
                          Or ( ( Kvadrant [2] = 1 ) And ( Kvadrant [4] = 1 ) ) )
                       Then
                      Begin { «¨§ª® ®â ¯®«îá  }
                            { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                        Seek  ( ImportStarFile , 0          ) ;
                        Read  ( ImportStarFile ,  OFRecord  ) ;

                        If ( OFRecord.Decl > 0 )
                          Then SigDecl :=   1
                          Else SigDecl := - 1 ;

                        RaOpt := 0.0  ;

                        For Code := 1 To 12 Do
                          Begin

                            XMin :=   Pi2 ;
                            XMax := - Pi2 ;
                            YMin :=   Pi2 ;
                            YMax := - Pi2 ;

                            Seek ( ImportStarFile, 0 ) ;

                            For  N := 1  To  NOF  Do
                              Begin

                                Read ( ImportStarFile ,  OFRecord  ) ;

                                Decl := PiD2 - ( Abs ( OFRecord.Decl ) ) ;
                                Ra   := OFRecord.Ra - RaOpt   ;

                                X := Decl * Cos ( Ra ) ;
                                Y := Decl * Sin ( Ra ) ;

                                If ( X > XMax )  Then  XMax := X ;
                                If ( Y > YMax )  Then  YMax := Y ;

                                If ( X < XMin )  Then  XMin := X ;
                                If ( Y < YMin )  Then  YMin := Y ;

                              End ;

                            X := ( XMin + XMax ) / C20 ;
                            Y := ( YMin + YMax ) / C20 ;

                            Ra := ArcTan ( Y / X ) ;
                              If ( X  < 0.0 )  Then  Ra := Ra + Pi  ;
                              IF ( Ra < 0.0 )  Then  Ra := Ra + Pi2 ;

                            RaOpt := RaOpt + Ra ;
                              IF ( RaOpt < 0.0 )  Then  RaOpt := RaOpt + Pi2 ;
                              IF ( RaOpt > Pi2 )  Then  RaOpt := RaOpt - Pi2 ;

                            DeclOpt := PiD2 - Abs ( X ) ;

                          End ;

                        DeclOpt := DeclOpt * SigDecl ;

                      End   { «¨§ª® ®â ¯®«îá  }
                            { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                     Else


                      Begin { „ «¥ª® ®â ¯®«îá  }
                            { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                        RaOpt := ( RaMax + RaMin ) / C20 ;

                        If ( RaMax - Ramin ) > Pi Then
                         Begin
                          If ( RaOpt < Pi )
                            Then  RaOpt := RaOpt + Pi
                            Else  RaOpt := RaOpt - Pi ;
                         End ;


                        DeclOpt := ( DeclMin + DeclMax ) / C20 ;

                      End ; { „ «¥ª® ®â ¯®«îá  }
                            { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                    End ;  { CalcFild }
                           { ÄÄÄÄÄÄÄÄ }


                    B_X_Max := True ;

                    NGrImport  :=  NGrImport  +  1 ;


                   End ;  { —¨â ¥¬ ä ©« ®¡ê¥ªâ®¢ }
                          { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }


    End ;

 End.
