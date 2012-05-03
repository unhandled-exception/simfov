
{$O+,F+}


UNIT POutFld ;   { ÇõÇéÑ èéãü áêÖHàü }
                 { ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ }


  Interface

    Var
       NpmOpen,
       PpmOpen,
       HipOpen,
       TycOpen,
       SaoOpen,
       CdcCatOpen,
       BsOpen,
       NLttOpen,
       HdEOpen,
       GcvsOpen,
       OutNoDetCdc        : Boolean       ;



    Procedure  OutZagol ;
    Procedure  OutputFieldData ;
    (*
    Procedure  OutFld ;          { å†‚p®Ê† ß†·¢•‚Æ™ Ø®™·•´•© }
    *)


  Implementation

    Uses   Crt, PVAR , V_CATAL, SCREEN, MLib,
           PProFld, PPreNew,
           {PDetCrst, Shl_X_Ac, }
           PE_Cns,
           P_O_Add, PClOpen,
           Dos, Check, Shell_X, PSortRa, PVarName, ProOut ,
           PVarMenu, PGalEkv, PJd8, PObjOut, PDateA20 ;

Var

  B_Hip_NoCrd,
  PMExist,
  PMRed,
  BSortSc,
  POut               : Boolean        ;
  S, St, Stt, t      : String  [ 64 ] ;
  S2                 : String         ;
  cH, cM , cS, cS100 : Word           ;
  cY, cMn, cD, cDW   : Word           ;

  Ind, IndSer        : Integer        ;
  NPF, Ipl           : Integer        ;
  TypeCoord          : Word           ;
  Rs                 : Double         ;
  Xs, Ys             : Double         ;
  nx, ny             : Double         ;

  R1,
  X, Y, Z,
  BmV,
  XSt, YSt,
  SiseFOV            : Double         ;

  NOS1,
  NOS2               : Word           ;

  SRA, CRA,
  SDecl, CDecl       : Double         ;


  Xp,Yp,Rp : Array [ 1 .. 15 ] Of Double ;


Procedure  OutZagol ;

 Begin

             If ( FlagF9 )  Then
               FlagFieldZagol := True ;

             Writeln ( OutFile ) ;

             R1 := ( JdOut - 2415020.5 ) / 365.2422 + 1900.0 ;
             Str ( R1 :7:1, Stt ) ;

             Write ( OutFile , ' Center' , Stt, ' ='  ) ;

             With ParVar.Ra0 Do
                  Write  ( OutFile , ' ',HourString (      Deg, Min, Sec));
             With ParVar.Dc0 Do
                  Write  ( OutFile , ' ',DegrString ( Neg, Deg, Min, Sec));


             Write ( OutFile , ' Size' ) ;

             If ( FlagF9 )
               Then SiseFOV := ParConst.HG
               Else SiseFOV := ParConst.HG / GScale ;

             Stt := '¯' ;
             If ( SiseFOV < C10 )  Then
               Begin
                 SiseFOV := SiseFOV * C600 ;
                 Stt := '''' ;
                 If ( SiseFOV < C10 )  Then
                   Begin
                     SiseFOV := SiseFOV * C600 ;
                     Stt := '"' ;
                   End ;
               End ;

             Write ( OutFile , Stt ) ;
             Write ( OutFile , SiseFOV     : 7:3 ) ;
             Write ( OutFile , ' MMax ', Param.MvMax : 4:1 ) ;

             Write    ( OutFile ,  ' Date');
             R1 := ( Jdate - 2415020.5 ) / 365.2422 + 1900.0 ;
             Str ( R1 :7:1, Stt ) ;
             Write  ( OutFile , Stt );

             Writeln ( OutFile ) ;
             Writeln ( OutFile ) ;

 End ;


Procedure  RedPM ( Cat : Byte;  Var PmRaArcSec, PmDeclArcSec, X, Y : Double ) ;

 Var PmRa, PmDecl, XSt, YSt : Double ;

  Begin

    PmRa   := PmRaArcSec   / SekRad * FD ;
    PmDecl := PmDeclArcSec / SekRad * FD ;


    XYEpOut ( Cat, PmRa, PmDecl, X, Y ) ;

    If ( PmDecl < C10000 )
      Then
        Begin
          PmRaArcSec   :=  PmRa   / Fd * SekRad ;
          PmDeclArcSec :=  PmDecl / Fd * SekRad ;
        End
      Else
          PmExist := False ;

  End ;



Procedure OutNoDetAkZ ;

     Begin  { ÇÎ¢Æ§ ≠•Æ‚Æ¶§•·‚¢´•≠®© ä†p‚Î H•°† }
            { ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ }
(*
       OutNoDetCdc := True ;

       If  ( NoDetCdcExist )   Then

         Begin

           WriteLn ( OutFile ) ;

           If  ParVar.DC0.Neg
             Then  Write ( OutFile, '- ' )
             Else  Write ( OutFile, '+ ' ) ;

           WriteLn ( OutFile , Trunc (  ParVar.DC0.Deg
                                      + ParVar.DC0.Min / C600 + 0.5  ) : 2 ,
                               ParVar.RA0.Deg : 4 ,
                               ParVar.RA0.Min : 3 ,
                               ExtFileAk      : 6   ) ;

           WriteLn ( OutFile, 'ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ' ) ;


           NColStr := 0 ;

           For SClass := 1 To CatMax Do
             Begin { SClass }

               IFirst := IndCat[ SClass ].NBeg ;
               ILast  := IndCat[ SClass ].NEnd ;

               If ( SClass = CatCdc )  Then
                 Begin

                   If ( IFirst > -1 ) Then

                   If ( CatSort [ SClass ] = False ) Then
                     Begin
                       ShellNrec ( IFirst , ILast ) ;
                     End ;

                      { ëÆp‚®pÆ¢™† Ä§p•·Æ¢ è´†·‚®≠™® ØÆ 'X' }
                      { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

{ ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ }
                   FlagAcMainNumAlloc := False ;
                   ShellXAcMain ( IFirst , ILast );
{  ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ }

                            { ƒƒƒƒƒƒƒƒƒƒƒ }



                   IndSer := 1 ;

                   For Ind := IFirst  To  ILast  Do

                   With ObjectPtr [ Ind div ObjectBlockSize ]^
                                  [ Ind mod ObjectBlockSize ] Do

                     Begin  { ObjectPtr }

                       If ( Sp Div 10 = 5 )
                         Then  { å„´Ï‚®é‚Æ¶§•·‚¢´•≠≠Î• Cdc }
                               { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
                             NDetCdcMultSum := NDetCdcMultSum + 1 ;


                       If ( Not (    ( Sp Div 10 = 7 )
                                  Or ( Sp Div 10 = 5 ) )  )
                         Then  { H•Æ‚Æ¶§•·‚¢´•≠≠Î• Cdc }
                               { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
                           Begin

                             NRecCOut := NRecC ;

                             {
                             WriteLn ( OutFile ) ;
                             WriteLn ( OutFile ) ;

                             RI := ( NRecC Mod 1000000000 ) Div 1000  ;

                             If  ( RI Mod 10 > 0 )  Then
                                Begin
                                  Write ( OutFile ,
                                          RI  div  10                     :8,
                                          Chr ( Ord('a')+ (RI mod 10 - 1)):1);
                                End
                               Else
                                   Write ( OutFile , RI Div 10 :8, ' ' ) ;
                             }


                             { é‚Æ¶§•·‚¢´•≠®• ØÆ 'äp•·‚„" }
                             { ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ }

                             OutCdc       := False ;

                             DetCrest ( CatCdcMoz , Ind  );
                            {‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹}


                             If ( B_PPM )  Then
                               DetCrest ( CatPPM , Ind  );
                              {‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹}


                             DetCrest ( CatNLTT , Ind  );
                            {‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹}


                             If ( B_GSC )  Then
                               DetCrest ( CatGsc , Ind  );
                              {‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹}


                             NNoDetCdcSum   := NNoDetCdcSum + 1 ;

                           End ;

                     End ;  { ObjectPtr }

                 End ;  { CatCdc }

             End ; { SClass }


           If ( NColStr > 0 )  Then    Writeln ( OutFile ) ;


         End ;


       If ( FlagAcMainNumAlloc )  Then
          FreeMem ( AcMainNum , SizeOf ( AcMainNumArr ) );
       FlagAcMainNumAlloc := False ;
*)

     End ;  { ÇÎ¢Æ§ ≠•Æ‚Æ¶§•·‚¢´•≠®© ä†p‚Î H•°† }
            { ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ }






Procedure OutputFieldData;
         {‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹}

Label Prer ;

Const

 NameMonth : Array [ 1 .. 12 ] Of String [ 3 ] =
  (
    'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',  
    'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC' 
  ) ;


Var

       SPp,
       NColStr            : Byte          ;

       CNeg,
       FileExist          : Boolean ;

       NmS, NDm,
       NAdd, NSer, NDecl,
       Year, Month,
       RI, n1, n2         : LongInt       ;

       I,
       IndCatOut,
       NDel,
       Nf,
       g, mnt             : Integer       ;

       ORa, ODc,
       R1, R2, MAl, MDel,
       TT, N,
       SA, CA,
       PmRaArcSec,
       PmDeclArcSec,
       SDecl, CDecl, TD   : Double        ;

       Day                : Double        ;
       JdGsc              : Double        ;
       JdGsc0             : Double        ;
       YearGsc            : Double        ;
       Sec                : Double        ;

       OFN                : PathStr       ;

       BsSrcRecord        : BSSrcType     ;

       S9                 : S9Type        ;
       S19                : S19Type       ;

       SMonth             : String [ 3 ]  ;

       FFormat            : Text          ;
       AddOthers          : Boolean       ;

Begin


        message ( 'Write Outfile ...', true ) ;


         { ÇÆ··‚†≠Æ¢®¨ à§•†´Ï≠Î• äÆÆ‡§®≠†‚Î Æ°Í•™‚Æ¢ }
         { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
        {
        ResetObjects ;
        }
        OutNoDetCdc := False ;


       { éíäêõíàÖ îÄâãÄ }
       { ÕÕÕÕÕÕÕÕÕÕÕÕÕÕ }

       OFN := OutFileName ;
       {
       If  ( B_Det_Cdc )
         Then  OFN := AkNoDteFileName
         Else  OFN := OutFileName     ;
       }
       FileMode := 2 ;
       If ( Exist ( OFN ) )
       Then
           Begin
              Assign ( OutFile  ,  OFN ) ;
              Append ( OutFile         ) ;
           End
       Else
           Begin
              Assign  ( OutFile  ,  OFN ) ;
              ReWrite ( OutFile         ) ;
           End;
       FileMode := 0 ;



       { ÇõÇéÑ ìëíÄçéÇéóçõï ÑÄççõï }
       { ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ }
    {
    If  (    (  ( Not B_Det_Cdc ) And ( NStarGrMax > 1 ) )
          Or ( B_Import_Fld                               )  )  Then
    }
    If  (    ( NStarGrMax > 1 )
          Or ( B_Import_Fld   )  )  Then
     Begin

       If ( B_Import_Fld )
         Then
           Begin
             WriteLn  ( OutFile ) ;
           End
         Else
           Begin

                   { Coordinates of field center }
                   { ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ }

              If ( Not FlagFieldZagol )  Then
                OutZagol ;

           End ;

     End

    Else

     { ÇÎ¢Æ§ ≠•Æ‚Æ¶§•·‚¢´•≠®© ä†p‚Î H•°† }

      OutNoDetAkZ ;




              {  Planets  &  Satellits  in  Field  }
              {  ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ  }

     If ( Not  OutNoDetCdc  )  Then
       Begin  { Not  OutNoDetCdc }

       IndSer := NPlanetsInFild ;
       NPF    := 0          ;

       If ( NPlanetsInFild > 0 )  Then
       Begin

        For  Ind := 1 To  IndSer  Do


        If ( PlanetPtr [ Ind Div PlanetBlockSize ]^
                       [ Ind Mod PlanetBlockSize ].NowVisible )  Then
         Begin   { IndSatOut }


          PlanetRecord := PlanetPtr [ Ind Div PlanetBlockSize ]^
                                    [ Ind Mod PlanetBlockSize ] ;

          Xs := PlanetRecord.X  ;
          Ys := PlanetRecord.Y  ;

          If ( ReCalcPlanets )
            Then
              Begin
                ScToId ( Xs, Ys, nX, nY ) ;
                X := nX ;
                Y := nY ;
              End
            Else
              Begin
                X := Xs ;
                Y := Ys ;
              End ;


           POut := True ;

           If (     ( PlanetRecord.Nr <= Max_PL_PPLFLD )
                And ( PlanetRecord.Nr <> NPl0          )  )   Then
             Begin

               For Ipl := 1 To NPF  Do
                 Begin
                   Rs := Sqrt ( Sqr ( X - Xp [ Ipl ] ) +
                                Sqr ( Y - Yp [ Ipl ] )    );
                   If ( Rs + PlanetRecord.D_Izo / 2 < Rp [ Ipl ] )  Then
                        POut := False ;
                 End ;

               If ( POut )   Then
                 Begin
                   NPF        := NPF + 1 ;
                   Xp [ NPF ] :=   X     ;
                   Yp [ NPF ] :=   Y     ;
                   Rp [ NPF ] := PlanetRecord.D_Izo / 2 ;
                 End ;

             End ;


           If ( POut )  Then
             Begin
               {
               IdToEq ( x, y, npolfix, spoznp, cpoznp, ora, odc );
               }
               IdToEq1 ( x, y, ora, odc );

                        { R.A. }
                        { ƒƒƒƒ }
               radtohms ( ora, g, mnt,sec);
               Write ( OutFile, ' ', HourString(g, mnt, sec) );

                        { Decl }
                        { ƒƒƒƒ }
               radtogms(odc,cneg,g,mnt,sec);
               Write ( OutFile, '  ', DegrString(cneg, g, mnt, sec),' ' );

                         { Mv }
                         { ƒƒ }
               If ( PlanetRecord.Nr <= Max_PL_PPLFLD )
                 Then  Write ( OutFile, PlanetRecord.M : 6 : 1 )
                 Else
                   Begin
                     Write ( OutFile, '      ') ;
                   End ;


                        { à¨Ô }
                        { ƒƒƒ }
               If ( PlanetRecord.Nr > Max_PL_PPLFLD )
                 Then
                   Begin  { Satellit }

                     IPl := PlanetRecord.Nr - Max_Pl_PPlFld ;

                     Reset ( SatNameFile             ) ;
                     Seek  ( SatNameFile, IPl - 1    ) ;
                     Read  ( SatNameFile, SatNameRec ) ;
                     Close ( SatNameFile             ) ;

                     St := ' ' + SatNameRec.NameSat ;
                     While ( Length ( St ) < 18 )  Do
                       St := St + ' ' ;
                     St := St + SatNameRec.InternDes ;

                   End
                 Else
                   Begin  { Planet^}
                     St := PlanetName [ PlanetRecord.Nr ] ;
                     Write ( OutFile , ' ': 18 ) ;
                   End ;

               WriteLn ( OutFile , St  ) ;

             End ;  { POut }

         End ;  { IndSatOut }

       End ;  { NPlanetsInFild > 0 }



              {  Stars in Field  }
              {  ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ  }

       TT := ( JDOut - 2451545.0 ) / 36525.0 ;
       N  := ( 2004.3109  - 0.85330  * TT ) / SekRad ;

       BSortSc  := False ;


       For IndCatOut := 1 To CatIzoMax Do
         Begin { SClass }

           BsOpen   := False ;
           NLttOpen := False ;
           NpmOpen  := False ;
           PpmOpen  := False ;
           HipOpen  := False ;
           TycOpen  := False ;
           SaoOpen  := False ;
           HdEOpen  := False ;
           GcvsOpen := False ;

           SClass := PrioritetIzo [ IndCatOut ] ;

           If (     ( SClass <> 0       )
                And ( SClass <= CatMax  )  )
             Then
               Begin
                 IFirst    := IndCat [ SClass ].NBeg      ;
                 ILast     := IndCat [ SClass ].NEnd      ;
                 TypeCoord := IndCat [ SClass ].TypeCoord ;
               End
             Else
                 IFirst := -1 ;


           If ( IFirst > -1 )  Then
             Begin  { IFirst > -1 }

               If ( NMarkingField = 0 )
                 Then
                   Begin
                     If (     ( SClass = CatCdc )
                          And ( Not B_Cdc_Cat   ) )
                       Then
                         Begin
                           ShellNrec ( IFirst, ILast ) ;
                           BSortSc := True ;
                         End
                       Else
                         Begin
                           If ( CatSort [ SClass ] = False )  Then
                             Begin
                               ShellX ( IFirst, ILast ) ;
                               CatSort [ SClass ] := True ;
                             End ;
                         End ;
                     {
                     Sort_By_Ra  ( IFirst , ILast ) ;
                     }
                   End
                 Else
                   Begin
                     ShellNMarking ( IFirst, ILast ) ;
                     BSortSc := True ;
                   End ;


               BsOpen := False  ;
               If ( SClass = CatBs )  Then
                 Begin
                   FileMode := 0;  { Set File access to read only }
                   Reset (    BsFile ) ;
                   Reset ( BsSrcFile ) ;
                   BsOpen := True   ;
                 End ;


               NlttOpen := False  ;
               If ( SClass = CatNltt )  Then
                 Begin
                   FileMode := 0;  { Set File access to read only }
                   Reset ( NlttFile ) ;
                   NlttOpen := True   ;
                 End ;


               NpmOpen := False  ;
               If ( SClass = CatNpm )  Then
                 Begin
                   FileMode := 0;  { Set File access to read only }
                   Reset ( NpmFile ) ;
                   NpmOpen := True   ;
                 End ;


               PpmOpen := False ;
               If ( SClass = CatPpm )  Then
                 Begin
                   FileMode := 0;  { Set File access to read only }
                   Reset ( PpmFile ) ;
                   PpmOpen := True   ;
                 End ;


               HipOpen := False ;
               If ( SClass = CatHip )  Then
                 Begin
                   FileMode := 0;  { Set File access to read only }
                   Reset ( HipFile ) ;
                   HipOpen := True   ;
                   If ( B_HIP_Add )  Then
                     Begin
                       FileMode := 0 ;
                       Reset ( HipAddFile ) ;
                     End ;
                 End ;


               TycOpen := False ;
               If ( SClass = CatTyc )  Then
                 Begin
                   FileMode := 0;  { Set File access to read only }
                   Reset ( TycFile    ) ;
                   If ( B_Tyc_2_Add )  Then
                     Reset ( TycAddFile ) ;
                   TycOpen := True      ;
                 End ;


               SaoOpen := False ;
               If ( SClass = CatSao )  Then
                 Begin
                   FileMode := 0;  { Set File access to read only }
                   Reset ( SaoFile ) ;
                   SaoOpen := True   ;
                 End ;



               HdEOpen := False ;
               If ( SClass = CatHd )  Then
                 Begin
                   FileMode := 0;  { Set File access to read only }
                   Reset ( HdFile  ) ;
                   Reset ( HdEFile ) ;
                   HdEOpen := True   ;
                 End ;


               GcvsOpen := False ;
               If ( SClass = CatGcvs )  Then
                 Begin
                   FileMode := 0;  { Set File access to read only }
                   If ( B_Gcvs2000 )
                     Then  Reset ( Gcvs2000File )
                     Else  Reset ( GcvsFile     ) ;
                   GcvsOpen := True   ;
                 End ;



             IndSer := 1 ;

             For Ind := IFirst  To  ILast  Do
               With ObjectPtr [ Ind div ObjectBlockSize ]^
                              [ Ind mod ObjectBlockSize ] Do
                 Begin  { ObjectPtr }


                   If ( KeyPressed )  Then
                     Begin
                       UserKey := GetCh ;
                       If ( UserKey = EscKey )  Then
                         GoTo Prer ;
                     End ;


                   If ( TypeCoord <> IdCoord )
                     Then
                       Begin
                         nX := X ;
                         nY := Y ;
                         ScToId ( nX, nY, Xs, Ys ) ;
                       End
                     Else
                       Begin
                         Xs := X ;
                         Ys := Y ;
                       End ;



                    { èpÆ¢•p™† Ì™p†≠®pÆ¢†≠®Ô Ø´†≠•‚†¨® }
                    { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

                   POut := True ;

                   For Ipl := 1 To NPF  Do
                     Begin
                       Rs := Sqrt ( Sqr ( Xs - Xp [ Ipl ] ) +
                                    Sqr ( Ys - Yp [ Ipl ] )    );
                       If ( Rs < Rp [ Ipl ] )  Then
                           POut := False ;
                     End ;




                   If (     ( NRecC >= 0                               )
                        And (     ( NMarkingField = 0                )
                               Or (     ( NMarkingField > 0        )
                                    And ( NRecC Div 1000000000 = 1 ) ) )
                        And ( POut )
                                                                         )
                   Then
                     Begin { VM > 0 }

                      XSt     := Xs ;
                      YSt     := Ys ;

                      PMRed   := False ;
                      PMExist := False ;



                      If (     ( SClass = CatCdc )
                           And ( B_Cdc_Cat       )  )  Then
                        Begin
                          Seek ( CdcFile , ( NRecC Mod 1000000000 ) - 1 ) ;
                          Read ( CdcFile , CdcRecord ) ;
                          If ( CdcRecord.MuRa <> 32123 )
                            Then
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



                      If ( SClass = CatPpm )  Then
                        Begin
                          Seek  ( PpmFile , ( NRecC Mod 1000000000 ) - 1 ) ;
                          Read  ( PpmFile , PpmRecord ) ;
                          PmRaArcSec   := PpmRecord.MuRa  / 3000.0 ;
                          PmDeclArcSec := PpmRecord.MuDec / 3000.0 ;
                          PMExist      := True                     ;
                          PMRed        := True                     ;
                        End ;



                      If ( SClass = CatHip )  Then
                        Begin
                          Seek  ( HipFile , ( NRecC Mod 1000000000 ) - 1 ) ;
                          Read  ( HipFile , HipRecord ) ;
                          PmRaArcSec   := HipRecord.PmRa   / C10000 ;
                          PmDeclArcSec := HipRecord.PmDecl / C10000 ;
                          PMExist      := True                      ;
                          PMRed        := True                      ;
                          If ( B_HIP_Add )  Then
                            Begin
                              Seek  ( HipAddFile , ( NRecC Mod 1000000000 ) - 1 ) ;
                              Read  ( HipAddFile , HipAddRecord ) ;
                              If ( Abs ( HipRecord.NSerInFile ) Div 1000000 = 1 )
                                Then
                                  Begin
                                    B_Hip_NoCrd := True  ;
                                    PmExist     := False ;
                                  End
                                Else
                                  Begin
                                    B_Hip_NoCrd := False ;
                                    PmRaArcSec   := HipAddRecord.PmRa   ;
                                    PmDeclArcSec := HipAddRecord.PmDecl ;
                                  End ;
                            End ;
                        End ;



                      If ( SClass = CatTyc )  Then
                        Begin

                          Seek  ( TycFile , ( NRecC Mod 1000000000 ) - 1 ) ;
                          Read  ( TycFile , HipRecord ) ;

                          If ( B_Tyc_2_Add )  Then
                            Begin
                              Seek  ( TycAddFile , ( NRecC Mod 1000000000 ) - 1 ) ;
                              Read  ( TycAddFile , TycAddRecord ) ;
                            End ;

                          If ( HipRecord.PmRa > (-32000.0+1.0) )
                            Then
                              Begin
                                If ( B_Tyc_2_Add )  Then
                                  Begin
                                    PmRaArcSec   := TycAddRecord.PmRa   ;
                                    PmDeclArcSec := TycAddRecord.PmDecl ;
                                  End
                                 Else
                                  Begin
                                    PmRaArcSec   := HipRecord.PmRa   / C10000 ;
                                    PmDeclArcSec := HipRecord.PmDecl / C10000 ;
                                  End ;

                                 PMExist      := True                      ;
                                 PMRed        := True                      ;

                              End
                            Else
                              Begin
                                PmRaArcSec   := HipRecord.PmRa   ;
                                PmDeclArcSec := HipRecord.PmDecl ;
                                PMExist      := False            ;
                                PMRed        := False            ;
                              End ;

                        End ;



                      If ( SClass = CatSao )  Then
                        Begin

                          Seek  ( SaoFile , ( NRecC Mod 1000000000 ) - 1 ) ;
                          Read  ( SaoFile , SaoRecord ) ;

                          PmRaArcSec   := SaoRecord.MuRa  / 0.6
                                              / 1000000000.0 * SekRad ;
                          PmDeclArcSec := SaoRecord.MuDec / 0.6
                                              / 1000000000.0 * SekRad ;

                          PMExist      := True  ;
                          PmRed        := True  ;

                        End ;



                      HdE := False ;
                      If ( SClass = CatHd )  Then
                        Begin  { CatHd }
                          If ( Sp >= 100 )  Then
                            Begin
                              HdE := True ;
                              Seek  ( HdEFile, ( NRecC Mod 1000000000 ) - 1 ) ;
                              Read  ( HdEFile, HdERecord  ) ;
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
                              HdE := False ;
                              Seek  ( HdFile, ( NRecC Mod 1000000000 ) - 1 ) ;
                              Read  ( HdFile, HdRecord  ) ;
                            End ;
                        End ;  { CatHd }




                      If ( SClass = CatBs )  Then
                        Begin
                          Seek  ( BsFile , ( NRecC Mod 1000000000 ) - 1 ) ;
                          Read  ( BsFile , BSRecord ) ;
                          NmS   := BSRecord.Sao ;
                          Seek  ( BsSrcFile , NmS - 1     ) ;
                          Read  ( BsSrcFile , BsSrcRecord ) ;
                          PmRaArcSec   := BsRecord.MURA  / 0.6
                                            / 1000000000.0 * SekRad ;
                          PmDeclArcSec := BsRecord.MUDEC / 0.6
                                            / 1000000000.0 * SekRad ;
                          PMExist      := True  ;
                          PMRed        := True  ;
                        End ;



                      If ( SClass = CatNpm )  Then
                        Begin
                          Seek  ( NpmFile , ( NRecC Mod 1000000000 ) - 1 ) ;
                          Read  ( NpmFile , NpmRecord ) ;
                          PmRaArcSec   := NpmRecord.MuRa   ;
                          PmDeclArcSec := NpmRecord.MuDec  ;
                          PMExist      := True             ;
                          PmRed        := True             ;
                        End ;



                      If ( SClass = CatNltt )  Then
                        Begin

                          Seek  ( NlttFile , ( NRecC Mod 1000000000 ) - 1 ) ;
                          Read  ( NlttFile , NlttRecord ) ;

                          PmRaArcSec   := NlttRecord.MuRa  / 0.6
                                              / 1000000000.0 * SekRad ;
                          PmDeclArcSec := NlttRecord.MuDec / 0.6
                                              / 1000000000.0 * SekRad ;

                          PMExist      := True  ;
                          PmRed        := True  ;

                        End ;


                      If (     ( SClass = CatGcvs )
                           And ( B_Gcvs2000       )  )  Then
                        Begin
                          Seek ( Gcvs2000File , ( NRecC Mod 1000000000 ) - 1 ) ;
                          Read ( Gcvs2000File , Gcvs2000Record               ) ;
                          If ( Gcvs2000Record.PmRa <> -32000 )
                            Then
                              Begin  { Ö·‚Ï  P.M. }
                                PmRaArcSec   := Gcvs2000Record.PmRa   / C10000 ;
                                PmDeclArcSec := Gcvs2000Record.PmDecl / C10000 ;
                                PMExist      := True                           ;
                                PMRed        := True                           ;
                              End
                            Else
                              Begin
                                PmRaArcSec   :=   0.0 ;
                                PmDeclArcSec :=   0.0 ;
                                PMExist      := False ;
                                PmRed        := False ;
                              End ;
                        End ;






                         { è•p•¢Æ§ ™ÆÆp§®≠†‚ ≠† Out ÌØÆÂ„ ß† P.M. }
                         { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

                      If ( PMRed ) Then
                        Begin

                          RedPM ( SClass, PmRaArcSec, PmDeclArcSec, XSt, YSt ) ;

                          { ìÁ´® ¢´®Ô≠®• P.M. · JDate -> JdOut. }

                        End ;




                      If ( OptRd )
                        Then
                          Begin
                            IdToEq1 ( XSt, YSt, ORa, ODc ) ;
                            If ( B_Gal )  Then
                              Begin
                                GalEkv ( ORa, ODc,
                                         ORa, ODc,
                                         SRa, CRa,
                                         SDecl, CDecl ) ;
                                PreNew ( JDateFld, JDOut, ORa, ODc ) ;
                              End ;
                          End
                        Else
                          Begin
                            {
                            IdToEq ( XSt,YSt, NPolFix, SPozNp, CPozNp, ORa, ODc);
                            }
                            IdToEq1 ( XSt, YSt, ORa, ODc ) ;
                            PreNew ( JDateFld, JDOut, ORa, ODc ) ;
                          End ;

                      Identify ( JdOut, ORa,ODc, SCnst )    ;
                      SCnst [ 1 ] := UpCase ( SCnst [ 1 ] ) ;
                      SCnst [ 2 ] := UpCase ( SCnst [ 2 ] ) ;
                      SCnst [ 3 ] := UpCase ( SCnst [ 3 ] ) ;

                      Write ( OutFile, SCnst, ' ' );


                              { R.A. }
                              { ƒƒƒƒ }
                      If ( SClass = CatA20 )  Then
                        Begin
                          Rs  := ORa * SekRad / 15.0 ;
                          Rs  := ( Round ( Rs * 100.0 ) ) / 100.0 ;
                          ORa := Rs * 15.0 / SekRad ;
                        End ;

                      RadToHMS ( ora, g, mnt,sec);


                      If ( SClass = CatA20 )
                        Then
                          Begin
                            S := HourString ( g, mnt, sec ) ;
                            S [ Length ( S ) ] := ' ';
                            Write ( OutFile, ' ', S ) ;
                          End
                        Else
                          Write ( OutFile, ' ', HourString ( g, mnt, sec ) );

                              { Decl }
                              { ƒƒƒƒ }
                      If ( SClass = CatA20 )  Then
                        Begin
                          Rs  := ODc * SekRad ;
                          Rs  := ( Round ( Rs * 10.0 ) ) / 10.0 ;
                          ODc := Rs / SekRad ;
                        End ;

                      RadToGMS ( odc, cneg, g, mnt, sec ) ;

                      If ( SClass = CatA20 )
                        Then
                          Begin
                            S := DegrString ( cneg, g, mnt, sec ) ;
                            S [ Length ( S ) ] := ' ';
                            Write ( OutFile, '  ', S, '  ' ) ;
                          End
                        Else
                            Write ( OutFile, '  ',
                              DegrString ( cneg, g, mnt, sec ), '  ' );



                      (* *)

                      (*
                       { Out Rect. Coords }
                       { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
                      Write ( OutFile, ' ', Xs : 12:4, Y : 14:4, '  ' );
                      *)


                      IF (    ( Sclass = CatOthers )
                           Or ( Sclass = CatGcvs   )  )
                        Then
                          Begin
                            Write ( OutFile, '     ' ) ;
                          End
                        Else
                          Begin
                            If (     ( SClass = CatImp )
                                 And ( B_Inport_Ccd    )  )
                              Then
                                Begin
                                  Seek ( ImportCcdFile,
                                         ( NRecC Mod 1000000000 ) - 1 ) ;
                                  Read ( ImportCcdFile, CCdRecord ) ;
                                  Write ( OutFile, CcdRecord.Diam : 5 : 0 );
                                End
                              Else
                                Begin
                                  If (     ( SClass = CatHd )
                                       And ( Not HdE        )  )
                                    Then
                                      Write ( OutFile, HdRecord.Mv/100 : 5:1 )
                                    Else
                                      If ( SClass = CatNltt )
                                        Then  Write ( OutFile,
                                                NlttRecord.Mv / C100 : 5 : 1 )
                                        Else
                                          Begin
                                            If ( SClass = CatA20 )
                                              Then
                                                Begin

                                                  Str ( M / C100 : 5:1, S ) ;
                                                  Write ( OutFile, S ) ;

                                                End
                                              Else
                                                Begin
                                                  If (     ( SClass = CatTyc )
                                                       And ( B_Tyc_2         ) )
                                                    Then
                                                      Begin
                                                        Str ( HipRecord.Mv / C100 : 5 : 1, S ) ;
                                                        Write ( OutFile, S ) ;
                                                      End
                                                    Else
                                                        Write ( OutFile,
                                                        M / 10 - 5 : 5 : 1 ) ;
                                                End ;
                                          End ;
                                End ;
                          End ;



                           { èÆpÔ§™Æ¢Î© ≠Æ¨•p }
                           { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

                     Write ( OutFile , IndSer : 6 ) ;
                     IndSer := IndSer + 1 ;


                            { å†p™®pÆ¢ÆÁ≠Î© ≠Æ¨•p }
                            { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

                     If ( NMarkingField > 0 )
                       Then  Write ( OutFile, NumbMarkingBegin + Date : 6 )
                       Else  Write ( OutFile , '' : 6 ) ;




                               { Sp }
                               { ƒƒ }

                      S := '      ' ;

                      If ( SClass = CatA20 )  Then
                        Begin

                          RR  := Frac ( NRecC / C10000 ) * C1000 ;
                          If ( RR <= 99.8 )
                            Then  Str ( RR : 5 : 1 , S )
                            Else  S := '     ' ;

                        End ;


                      If (    ( Sclass = CatPPM          )
                           Or ( Sclass = CatBs           )
                           Or ( Sclass = CatSao          )
                                                           )  Then
                        Begin

                          S := '  ' + SpectraName [ ( Sp Mod 100 ) div 10 + 1 ];

                          If ( Sp Mod 100 ) div 10 <> 7
                            Then
                              Begin
                                str( Sp mod 10 : 1 , St );
                                s := s + St ;
                              End
                            Else
                                s := s + ' ' ;

                          Write ( OutFile, S, '  ' ) ;
                          S := '' ;

                        End ;


                      If (     ( Sclass = CatHd   )
                           And ( HdE              ) )  Then
                        Begin
                          S := '  ' + HdERecord.Sp ;
                          Write ( OutFile, S, '  ' ) ;
                          S := '' ;
                        End ;


                      If (     ( Sclass = CatHd   )
                           And ( Not HdE          ) )  Then
                        Begin
                          S := '  ' + HdRecord.Sp ;
                          Write ( OutFile, S, ' ' ) ;
                          S := '' ;
                        End ;


                      If ( Sclass = CatNLtt )  Then
                        Begin
                          S := '  ' + NLttRecord.Sp ;
                          Write ( OutFile, S, ' ' ) ;
                          S := '' ;
                        End ;


                      If ( SClass = CatNpm )
                        Then
                          Begin
                            BmV := NpmRecord.BmV / C100 ;
                            If ( NpmRecord.BmV <> -100 )
                              Then  Str ( BmV : 5:1, S )
                              Else  S := '     ' ;
                            Write ( OutFile, S , ' '  ) ;
                            S := '' ;
                          End ;



                      If ( SClass = CatOthers )  Then
                        Begin
                          Write ( OutFile, '' : 6 ) ;
                          S := '' ;
                        End ;

                      If ( SClass = CatHip ) Then
                        Begin
                          Write ( OutFile, '' : 6 ) ;
                          S := '' ;
                        End ;

                      If ( SClass = CatTyc ) Then
                        Begin
                          If ( B_Tyc_2 )
                            Then
                              Begin
                                If  ( HipRecord.MV / C100 > C1000 )
                                  Then  S := ' B'
                                  Else  S := ' V';
                                 Write ( OutFile, S, '' : 2 ) ;
                              End
                            Else
                                 Write ( OutFile, '' : 6 ) ;
                          S := '' ;
                        End ;

                      Write ( OutFile, S ) ;




                         { à¨Ô ™†‚†´Æ£† }
                         { ƒƒƒƒƒƒƒƒƒƒƒƒ }

                      S := NameCat [ Sclass ] ;
                      If ( Length ( S ) < 4 )  Then
                        For I := Length ( S ) To 4 Do
                          S := S + ' ';

                      If (     ( SClass = CatHd )
                           And ( HdE            )  )  Then
                        S := 'HDE ' ;


                      If (     ( SClass = CatHd )
                           And ( Not HdE        )  )  Then
                        S := 'HD  '+HdRecord.Remarks ;


                      If  ( SClass = CatPpm )  Then
                        Begin
                          If  ( ( SP Div 100 ) Mod 2 = 1 )
                            Then  S [ 4 ] := '-' ;
                        End ;


                      If  ( SClass = CatHip )  Then
                        Begin
            		  If ( HipRecord.NSerInFile < 0 )
              		    Then
                              Begin
                                If ( B_Hip_Add )
                                  Then
                                    Begin
                                      If ( Abs ( HipRecord.NSerInFile )
                                               Div 1000000 = 1 )
                                        Then S := 'hip- '
                                        Else S := 'HIP- ' ;
                                    End
                                  Else S := 'HIP- ' ;
                              End
                            Else
                              S := 'HIP  '     ;
                        End ;

                      If  ( SClass = CatTyc )  Then
                        Begin
            		  If ( HipRecord.NSerInFile < 0 )
                            Then
                              Begin
                                If ( B_Tyc_Sai ) Then
                                  S := 'TRC  ' ;
                                If ( B_Tyc_0 ) Then
                                  S := 'Tyc- ' ;
                                If ( B_Tyc_2 ) Then
                                  S := 'Tyc2-' ;
                              End
                            Else
                              Begin
                                If ( B_Tyc_Sai ) Then
                                  S := 'TRC  ' ;
                                If ( B_Tyc_0 ) Then
                                  S := 'Tyc  ' ;
                                If ( B_Tyc_2 ) Then
                                  S := 'Tyc2 ' ;
                              End ;
                        End ;


                      If  ( SClass = CatGsc )  Then
                        Begin
                          If  (    ( SP Mod 10  = 0 )
                                Or ( SP Mod 10 >= 6 )  )
                            Then  S [ 4 ] :=  '*'
                            Else  S [ 4 ] :=  ' ' ;
                        End ;



                      If  ( SClass = CatA20 )  Then
                        Begin

                          Nf := ( NRecC Div 1000 ) Mod 1000 ;
                          {
                          If ( NRecC Div 10000000 = 1 )  Then
                            S [ 4 ] := 'G' ;
                          }
                          If ( ( Sp Div 10 ) = 8 )  Then
                            S [ 4 ] := 'g' ;

                          If ( ( ( Sp Mod 10 ) And 1 ) = 1 )  Then
                            S [ 5 ] := '?' ;

                          S := ' ' + S ;

                          If ( Nf <> 0 )  Then
                            Begin

                              Str ( Nf : 3, Stt ) ;
                              If ( Stt [ 1 ]  = ' ' )  Then
                                   Stt [ 1 ] := '0';
                              If ( Stt [ 2 ]  = ' ' )  Then
                                   Stt [ 2 ] := '0';

                              If ( Sp Mod 10 ) And 2 = 2
                                Then
                                  Begin
                                    Seek ( A20DateSFile, Nf - 1 ) ;
                                    Read ( A20DateSFile, S19    ) ;
                                    DateA20 ( S19, S9 ) ;
                                    St := 's';
                                  End
                                Else
                                  Begin
                                    Seek ( A20DateNFile, Nf - 1 ) ;
                                    Read ( A20DateNFile, S9     ) ;
                                    St := 'n';
                                  End ;


                              S := S + ' Plate '+ St + Stt + ' ' ;

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

                              S := S + t ;

                              {
                              For N1 := 1 To 9 Do
                                S := S + S9.S9 [ N1 ] ;
                              }
                            End ;

                          S := S + '     ' ;

                        End ;



                      If  (     ( SClass = CatCdc )
                            And ( B_Cdc_Cat       )  )  Then
                        Begin
                          If ( SP >= 100 ) Then
                             S [ 3 ] := '+' ;
                        End ;

                      If ( SClass <> CatNLtt )
                        Then  S := S + ' '
                        Else  S := Copy ( S, 1, 3 ) ;


                      If  ( SClass = CatDm )   Then
                        Begin
                          S := '' ;
                        End ;


                      If (     ( SClass <> CatCdc  )
                           And ( SClass <> CatNpm  )
                           And ( SClass <> CatNLtt )
                           And ( SClass <> CatDm   )
                           And ( SClass <> CatGsc  ) )  Then
                         Begin
                           If (     ( SClass = CatTyc )
                                And ( B_Tyc_2         )  )
                             Then S := S + ''
                             Else S := S + '  ' ;
                         End ;


                      If ( SClass = CatGcvs )  Then
                        Begin

                          If ( B_Gcvs2000 )
                            Then
                              Begin

                                Seek  ( Gcvs2000File , ( NRecC Mod 1000000000 ) - 1 ) ;
                                Read  ( Gcvs2000File , Gcvs2000Record               ) ;

                                GcvsRecord.SdRa    := Gcvs2000Record.SdRa    ;
                                GcvsRecord.SdDec   := Gcvs2000Record.SdDec   ;
                                GcvsRecord.NameStr := Gcvs2000Record.NameStr ;
                                GcvsRecord.MStr    := Gcvs2000Record.MStr    ;
                                GcvsRecord.SpStr   := Gcvs2000Record.SpStr   ;

                              End
                            Else
                              Begin

                                Seek  ( GcvsFile , ( NRecC Mod 1000000000 ) - 1 ) ;
                                Read  ( GcvsFile , GcvsRecord                   ) ;

                              End ;

                          {
                          n2 := GcvsRecord.Num ;
                          n1 := n2 div 10000;
                          n2 := n2 - longint(n1) * 10000;

                          If  ( GcvsRecord.Num < 1000000)
                            Then  S := 'GCVS' + '  '
                            Else  S := 'NSV ' + '  ' ;
                          }

                          S := 'GCVS' + '    ' ;

                        End ;


                      If  (     ( SClass = CatImp       )
                            And ( Not ( B_Inport_Ccd )  )  )  Then
                        Begin

                          NRecObjectOutFile := NRecC Mod 1000000000 ;

                            { Find Number Imp }
                            { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
                          Seek  ( OutStarFile , NRecObjectOutFile - 1 ) ;
                          Read  ( OutStarFile , ObjectString          ) ;

                          For NDel := 1 To 7  Do
                            Begin
                              While (    ( ObjectString[1] = ' ' )
                                      Or ( ObjectString[1] = '-' )
                                      Or ( ObjectString[1] = '+' )
                                                                   )  Do
                                Delete ( ObjectString, 1 , 1 ) ;
                              NOS1 := Pos ( ' ' , ObjectString ) ;
                              Delete ( ObjectString, 1 , NOS1 - 1 ) ;
                            End ;

                          While (  ObjectString[1] = ' ' )  Do
                            Delete ( ObjectString, 1 , 1 ) ;
                          NOS1 := Pos ( ' ' , ObjectString ) ;
                          If ( NOS1 > 0 )
                            Then  ObjectS := Copy ( ObjectString , 1 , NOS1 - 1 )
                            Else  ObjectS := ObjectString ;

                          S := S + ' ' + ObjectS  ;

                        End ;


                      Write ( OutFile , S ) ;



                             { HÆ¨•p ß¢•ß§Î }
                             { ƒƒƒƒƒƒƒƒƒƒƒƒ }
                      {
                      If (     ( SClass = CatCdcMoz )
                           And ( Not B_Det_Cdc      ) )  Then
                      }
                      If ( SClass = CatCdcMoz )  Then
                        Begin

                          N1         := NRecC Mod 1000 ;
                          AkZagolRec := PlateZagol ^ [ N1 ] ;

                          Str ( AkZagolRec.DcG : 3 , St ) ;
                          If ( St[2] = ' ' )  Then
                               St[2] := '0' ;
                          If ( St[2] = '-' )  Then
                             Begin
                               St[2] := '0' ;
                               St[1] := '-' ;
                             End ;
                          If ( St[1] = ' ' ) Then
                               St[1] := '+' ;
                          S := St + ' ' ;

                          Str ( AkZagolRec.RaH : 2 , St ) ;
                          If ( St[1] = ' ' ) Then
                               St[1] := '0' ;
                          S := S + St ;

                          Str ( AkZagolRec.RaM : 2 , St ) ;
                          If ( St[1] = ' ' ) Then
                               St[1] := '0' ;
                          S := S + ' ' + St ;

                           { HÆ¨•p ≠† è´†·‚®≠™• }
                           { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
                          RI := ( NRecC Mod 1000000000 ) Div 1000  ;

                          Str ( RI Div 10 : 7, St ) ;
                          If  ( RI Mod 10 > 0 )
                            Then St := St + Chr ( Ord('a')+ (RI mod 10 - 1))
                            Else St := St + ' ' ;
                          S := S + St ;

                           { Ñ†‚† H†°´Ó§•≠®Ô }
                           { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
                          Str ( AkZagolRec.Year : 5 , St ) ;
                          S := S + St ;
                          Month := AkZagolRec.Mon ;
                          If ( ( Month > 12 ) Or ( Month < 1 ) )
                             Then  Month := 13 ;
                          S := S + ' ' + MonthName [ Month ] ;
                          Str ( AkZagolRec.Day  : 3 , St ) ;
                          S := S + St ;


                          { èp®ß≠†™® à·Øp†¢´•≠®© }
                          { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
                          N1 := Sp Mod 10 ;

                          If ( N1 Mod 2 = 1 )
                            Then  S := S + ' x?'
                            Else  S := S + '   ' ;

                          If ( ( N1 Mod 4 ) Div 2 = 1 )
                            Then  S := S + ' y?'
                            Else  S := S + '   ' ;



                          Write ( OutFile, S ) ;

                        End ;

                      (*
                      If ( SClass = CatHicBin )  Then
                        Begin
                          Assign ( HicBinFile    , 'E:\Catalog\Hic\' +
                                   CatFile.HicBinFileName );

                          FileExist := True ;
                               {$I-}
                          FileMode := 0;  { Set File access to read only }
                          Reset  ( HicBinFile );
                               {$I+}
                          If ( IOResult <> 0 )
                            Then  FileExist := False ;

                          If ( FileExist )  Then
                            Begin  { FileExist }
                              Seek  ( HicBinFile , ( NRecC Mod 1000000000 ) - 1 ) ;
                              Read  ( HicBinFile , HicBinRecord ) ;
                              Close ( HicBinFile );
                              Write ( OutFile,
                              HicBinRecord.Numb : 6 , '   ' ) ;
                            End ;

                        End ;
                      *)

                      S := '' ;

                      If (    ( SClass = CatPPM          )
                           Or ( SClass = CatHip          )
                           Or ( SClass = CatTyc          )
                           Or ( SClass = CatSao          )
                           Or ( SClass = CatNpm          )
                           Or ( SClass = CatNLtt         )
                           Or ( SClass = CatBs           )
                           Or ( SClass = CatGsc          )
                           Or ( SClass = CatHd           )
                           Or ( SClass = CatOthers       )
                           Or ( SClass = CatGcvs         )
                           Or ( Sclass = CatDm           )
                           Or (     ( B_Cdc_Cat        )
                                And ( SClass = CatCdc  ) ) )
                        Then
                          Begin

                            If ( SClass = CatPPM )  Then
                              Begin
                                Write ( OutFile,
                                  PPMRecord.PPM Mod 1000000 : 8 ) ;
                              End ;


                            If ( SClass = CatHip )  Then
                              Begin
                                If ( Not ( B_Hip_Add ) )
                                  Then
                                    Begin
                                      NRecC := Abs ( HipRecord.NSerInFile ) Mod 2000000 ;
                                      Str ( NRecC : 8 , S );
                                      Write ( OutFile, S ) ;
                                    End
                                  Else
                                    Begin
                                      Write ( OutFile, HipAddRecord.HipNumber : 8 ) ;
                                    End ;
                              End ;


                            If ( SClass = CatTyc )  Then
                              Begin

                                If ( B_Tyc_0 ) Then
                                  Begin
                                    NRecC := Abs ( HipRecord.NSerInFile ) Mod 2000000 ;
                                    Str ( NRecC : 8 , S );
                                    Write ( OutFile, S ) ;
                                  End ;

                                If ( B_Tyc_Sai ) Then
                                  Begin
                                    NRecC := Abs ( HipRecord.NSerInFile ) Div 100000 ;
                                    Str ( NRecC  : 4 , S ) ;
                                    NRecC := Abs ( HipRecord.NSerInFile ) Mod 100000 ;
                                    Str ( NRecC  : 5 , St ) ;
                                    S := S + St ;
                                    If ( HipRecord.NSerInFile < 0 )
                                      Then  S := S + '2'
                                      Else  S := S + '1' ;
                                    Write ( OutFile, S ) ;
                                  End ;

                                If ( B_Tyc_2 ) Then
                                  Begin
                                    NRecC := Abs ( HipRecord.NSerInFile ) Div 100000 ;
                                    Str ( NRecC  : 4 , S ) ;
                                    NRecC := Abs ( HipRecord.NSerInFile ) Mod 100000 ;
                                    Str ( NRecC  : 6 , St ) ;
                                    S := S + St ;
                                    St := ' 1' ;
                                    If ( HipRecord.Cat And 4 = 4 ) Then
                                      St := ' 2';
                                    If ( HipRecord.Cat And 8 = 8 ) Then
                                      St := ' 3';
                                    S := S + St ;
                                    Write ( OutFile, S ) ;
                                  End ;

                              End ;


                            If ( SClass = CatSao )  Then
                              Begin
                                Write ( OutFile,
                                  SaoRecord.Sao  : 8 ) ;
                              End ;


                            If ( SClass = CatNpm )  Then
                              Begin

                                NmS := NpmRecord.Num ;

                                Str ( Abs ( NmS ) / 10000  : 8 : 4 , S ) ;

                                If  ( S [ 2 ] = ' ' )  Then
                                  S [ 2 ] := '0' ;

                                If ( Nms > 0 )
                                  Then S [ 1 ] := '+'
                                  Else S [ 1 ] := '-' ;


                                Write ( OutFile, S : 10 ) ;

                              End ;



                            If ( SClass = CatNLtt )  Then
                              Begin

                                S := NLttRecord.Name ;

                                Write ( OutFile, S : 14 ) ;

                              End ;



                            If ( SClass = CatBs )  Then
                              Begin

                                Seek  ( BsSrcFile , BSRecord.SAO - 1     ) ;
                                Read  ( BsSrcFile , BsSrcRecord          ) ;

                                Write ( OutFile,
                                   BsSrcRecord.Bs : 8  ) ;

                              End ;


                            If ( SClass = CatCdc )  Then
                              Begin

                                SPp := ( CdcRecord.Cat Div 4 ) Mod 15;
                                Str ( SPp : 6 , S ) ;
                                S := S + ' obs' ;
                                Write ( OutFile , S ) ;

                              End ;



                            If ( SClass = CatHd )  Then
                              Begin
                                If ( Not HdE )
                                  Then
                                    Begin
                                      S := '       ' ;
                                      RI := 0 ;
                                      If ( HdRecord.Mv / C1000 ) > 19.9 Then
                                        RI := Round ( HdRecord.Mv / C1000 ) ;
                                      If ( HdRecord.Mp / C1000 ) > 19.9 Then
                                        RI := Round ( HdRecord.Mp / C1000 ) ;
                                      If ( RI > 0 )  Then
                                        Begin
                                          Case RI Of
                                            20 : S := '  Neb  ' ;
                                            30 : S := '  Var  ' ;
                                            40 : S := '  Nov  ' ;
                                            50 : S := '  Cl   ' ;
                                          End ;
                                        End ;

                                      Write ( OutFile,
                                                  HdRecord.Num : 8,
                                        '   Mp:', HdRecord.Mp / 100 : 5:1,
                                        ' '     , HdRecord.Dm     ,
                                        S );

                                    End
                                  Else
                                    Begin
                                      Str ( HdERecord.Num Div 10 : 9 , s ) ;
                                      N1 := HdERecord.Num Mod 10 ;
                                      If ( N1 > 0 )
                                        Then  S := S +  Chr ( N1 - 1 + Ord ( 'A')  )
                                        Else  S := S + ' ' ;
                                      Write ( OutFile, S ) ;
                                    End ;
                              End ;



                            IF ( Sclass = CatOthers )  Then
                              Begin

                                S2 := CatNameKutcha
                                      [ ( NRecC Mod 1000000000 ) Mod 20 ] ;

                                Write ( OutFile, S2 : 9 );

                                If  ( S2 = 'PSC'   )
                                 Or ( S2 = 'FSC'   )
                                 Or ( S2 = 'RAFGL' )
                                                   Then
                                  Begin
                                    NameIras ( NRecC, S2 ) ;
                                    S2 := Copy ( S2, 1, 11 ) ;
                                    Write ( OutFile, S2 : 13 );
                                  End ;

                                If  ( S2 = 'TMSS' )  Then
                                  Begin
                                    NameIras ( NRecC, S2 ) ;
                                    S2 := Copy ( S2, 1, 6 ) ;
                                    S2 := S2 + '     ' ;
                                    Write ( OutFile, S2 : 13 );
                                  End ;

                                If  ( S2 = 'RAFGL' )  Then
                                  Begin
                                    NameIras ( NRecC, S2 ) ;
                                    S2 := Copy ( S2, 1, 5 ) ;
                                    S2 := S2 + '      ' ;
                                    Write ( OutFile, S2 : 13 );
                                  End ;

                              End ;



                            If ( SClass = CatGsc )  Then
                              Begin
                                If ( GscAddExist )
                                  Then
                                    Begin

                                      If ( GscNew )
                                        Then
                                          Write ( OutFile ,
                                            NRecC Mod 1000000000 /
                                            100000.0 :  10:5 )
                                        Else
                                          Write ( OutFile ,
                                            NRecC Mod 1000000000 /
                                            10000.0  :  10:4 ) ;

                                      If ( SP Mod 10 >= 6 )
                                        Then
                                          Write ( OutFile,'     V 1.1' )
                                        Else
                                          If  ( NMarkingField = 0 )  Then
                                            Begin
                                              RR := Date / C10000 + 1950.0 ;
                                              If ( RR >= 1951.486 )  Then
                                                Begin
                                                  Str ( RR : 10:3 , St ) ;
                                                  Write ( OutFile, St ) ;
                                                End ;
                                            End ;
                                      {
                                      If  ( NMarkingField = 0 )  Then
                                        Begin
                                          If ( SP Mod 10 >= 6 )
                                            Then
                                              Write ( OutFile,' V 1.1 ','':4 )
                                            Else
                                              Begin
                                                RR := Date / C10000 + 1950.0 ;
                                                Str ( RR : 6:1, St ) ;
                                                Write ( OutFile, St : 7 , '':4 )
                                              End ;
                                        End ;
                                      }
                                    End ;
                                  {
                                  Else
                                      Write ( OutFile , '':11 ) ;
                                  }
                              End ;


                            If ( SClass = CatGcvs )  Then
                              Begin { SClass = CatGcvs }

                               (*
                               n2 := GcvsRecord.Num ;
                               n1 := n2 div 10000;
                               n2 := n2 - longint(n1) * 10000;

                               If  ( GcvsRecord.Num < 1000000)
                                 Then
                                   Begin { éäèá }
                                         { ƒƒƒƒ }

                                     If ( n2 <= 334 )
                                       Then
                                         S  := '    ' +
                                               Argelan [ n2 ] + ' ' +
                                               AbbName [ n1 ]
                                       Else
                                         Begin
                                           Str ( n2 : 6, S );
                                           S := S + ' ' + AbbName [ n1 ]  ;
                                         End ;

                                   End   { éäèá }
                                         { ƒƒƒƒ }
                                 Else

                                   Begin { äáè }
                                         { ƒƒƒ }

                                     n1 := GcvsRecord.Num  div 1000000 ;
                                     n2 := GcvsRecord.Num  -
                                           LongInt(n1) * 1000000 ;

                                     Str ( n2 : 6 , S );

                                   End ;

                               Write ( OutFile, S : 10, '':18 ) ;
                               *)

                               S :=   '  '
                                    + GcvsRecord.NameStr + ' '
                                    + GcvsRecord.MStr    + ' '
                                    + GcvsRecord.SpStr    ;

                               If ( Length ( S ) < 54 )  Then
                                 For N1 := Length ( S ) To 54 Do
                                   S := S + ' ' ;

                               Write ( OutFile, S  ) ;



                              End ; { SClass = CatGcvs }



                            If ( SClass = CatDm )  Then
                              Begin

                                NmS   := NRecC Mod 1000000000 ;
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
                                      Str ( Abs ( NDecl ) : 4 , S ) ;
                                      S [ 2 ] := '+' ;
                                    End
                                  Else
                                    Begin
                                      Inc ( NDecl ) ;
                                      Str ( Abs ( NDecl ) : 4 , S ) ;
                                      S [ 2 ] := '-' ;
                                    End ;

                                S := '    ' + S ;

                                If (     ( NameDm [ NDm ] = 'SD' )
                                     And ( NDecl < -1            )  )
                                  Then  S := NameDm [ NDm - 1 ] + S
                                  Else  S := NameDm [ NDm     ] + S ;

                                Str ( NSer : 6 , St ) ;
                                S := S + St + NDmAdd [ NAdd ] ;

                                Write ( OutFile , S, '':17 ) ;

                              End ;

                          End  ;



                             { Prop. Mou. }
                             { ƒƒƒƒƒƒƒƒƒƒ }
                      If (     (       Sclass = CatPPM    )
                            Or (       Sclass = CatHip    )
                            Or (       Sclass = CatTyc    )
                            Or (       Sclass = CatSao    )
                            Or (       Sclass = CatNpm    )
                            Or (       Sclass = CatBs     )
                            Or (       Sclass = CatNltt   )
                            Or (       HdE                )
                            Or (     ( Sclass = CatCdc    )
                                 And ( B_Cdc_Cat        ) )
                            Or (     ( Sclass = CatGcvs   )
                                 And ( B_Gcvs2000       ) )
                           {
                           And (       PmExist            )
                           }
                                                             )  Then
                        Begin


                          If ( SClass = CatPPM )  Then
                            Begin
                              Write ( OutFile , PmRaArcSec   : 8 : 3,
                                                PmDeclArcSec : 9 : 3, '  ' ) ;
                            End ;


                          If ( SClass = CatTyc )  Then
                            Begin
                              If ( PmExist )
                                Then
                                  If ( B_Tyc_2 )
                                    Then  Write ( OutFile, PmRaArcSec   : 9 : 4,
                                                           PmDeclArcSec : 9 : 4, '   ' )
                                    {
                                    Then  Write ( OutFile, PmRaArcSec   : 8 : 3,
                                                           PmDeclArcSec : 8 : 3, '  ' )
                                    }
                                    Else  Write ( OutFile, PmRaArcSec   : 9 : 3,
                                                           PmDeclArcSec : 9 : 3, '   ' )
                                Else
                                  If ( B_Tyc_2 )
                                    Then Write ( OutFile , ' ': 21 )
                                    Else Write ( OutFile , ' ': 21 ) ;
                            End ;


                          If ( SClass = CatHip ) Then
                            Begin
                              If ( PmExist )
                                Then
                                  If ( B_HIP_Add )
                                    Then  Write ( OutFile, PmRaArcSec   : 10 : 5,
                                                           PmDeclArcSec :  9 : 5, ' ' )
                                    Else  Write ( OutFile, PmRaArcSec   : 10 : 3,
                                                           PmDeclArcSec :  9 : 3, ' ' )
                                Else
                                  Begin
                                  If ( B_HIP_Add )
                                    Then Write ( OutFile , ' ': 20 )
                                    Else Write ( OutFile , ' ': 20 ) ;
                                  End ;
                            End ;


                          If ( SClass = CatSao )  Then
                            Begin
                              Write ( OutFile , PmRaArcSec   : 8 : 3,
                                                PmDeclArcSec : 9 : 3, ' ' ) ;
                            End ;


                          If (     ( SClass = CatHd )
                               And ( HdE            )
                                                       ) Then
                            Begin
                              If ( HdERecord.MURA < 32000 )
                               Then
                                Begin
                                  Write ( OutFile ,
                                          PmRaArcSec   : 7 : 3,
                                          PmDeclArcSec : 8 : 3, '  ','':13 ) ;
                                End
                               Else
                                Begin { Ep HdE }
                                  Write ( OutFile , '  Ep = ',
                                    HdERecord.MUDEC / C100 + 1900 :6:2,
                                    '   ', '':13 );
                                End ;
                            End ;



                          If ( Sclass = CatNpm )  Then
                            Begin
                              Write ( OutFile , PmRaArcSec   : 9 : 4,
                                                PmDeclArcSec : 9 : 4, ' ' ) ;
                            End ;



                          If ( SClass = CatBs )  Then
                            Begin
                              Write ( OutFile , PmRaArcSec   : 8 : 3,
                                                PmDeclArcSec : 9 : 3, ' ' ) ;
                            End ;



                          If ( SClass = CatCdc )  Then
                            Begin

                              If ( CdcRecord.MuRa <> 32123 )
                                Then
                                  Begin
                                    Write ( OutFile ,
                                            PmRaArcSec   : 8 : 3,
                                            PmDeclArcSec : 9 : 3, ' ' ) ;
                                  End
                                Else
                                  Begin { Ep AK }
                                    Write ( OutFile , '                   Ep = ',
                                        CdcRecord.MUDEC / C1000 + 1900 :7:2, '   ' );
                                  End ;

                            End ;



                          If ( SClass = CatNltt )  Then
                            Begin

                              Write ( OutFile , PmRaArcSec   : 7 : 3 ,
                                                PmDeclArcSec : 9 : 3 , ' ') ;

                            End ;


                           If (     ( Sclass = CatGcvs   )
                                And ( B_Gcvs2000       ) ) Then
                             Begin
                              If ( PmExist )
                                Then
                                  Write ( OutFile ,
                                          PmRaArcSec   : 8 : 3,
                                          PmDeclArcSec : 8 : 3, '  ' )
                                Else
                                  Write ( OutFile , '                  ' );

                             End ;



                      If (     ( SClass = CatTyc )
                           And ( B_Tyc_2_Add     ) )  Then
                          Begin
                            Out_Add_Inform
                          End ;


                      If (     ( SClass = CatHip )
                           And ( B_Hip_Add       ) )  Then
                          Begin
                            Out_Add_Inform
                          End ;


                        End
                       Else  { á†ØÆ´≠Ô•¨ P.M. ØpÆ°•´†¨® }
                        Begin
                        End ;


          { ************************************************************* }

                      WriteLn ( OutFile ) ;




                      IF ( Sclass = CatOthers )  Then
                        Begin

                          S := CatNameKutcha [ ( NRecC Mod 1000000000 ) Mod 20 ] ;
                          AddOthers := True ;

                          Assign ( FFormat, S + '.fmt') ;
                          {$I-}
                          FileMode := 0 ;
                          Reset  ( FFormat );
                          Close  ( FFormat );
                          {$I+}
                          If ( IOResult = 0 ) Then
                            Begin
                              Reset  ( FFormat );
                              AddOthers := False ;
                              While (     (  Not Eof ( FFormat ) )
                                      And (  AddOthers = False   )  )  Do
                                Begin
                                  Readln ( FFormat, S ) ;
                                  For I := 1 To Length ( S ) Do
                                    If ( S [ I ] <> '' )  Then
                                      AddOthers := True ;
                                End ;
                              Close  ( FFormat );
                            End ; { IOResult = 0 }

                          If ( AddOthers )  Then
                            Begin
                              Writeln    ( OutFile  ) ;
                              InfoOthers ( Ind, 1   ) ;
                              Writeln    ( OutFile  ) ;
                            End ;

                        End ;

                     End ; { VM <> 0 }

                 End; { ObjectPtr }

             End ;  { IFirst > -1 }


           If (     ( BSortSc     )
                And ( IFirst > -1 )  ) Then
             ShellX ( IFirst , ILast ) ;

           CloseOpen ;


         End ; { SClass }

       End ;  { Not  OutNoDetCdc }

 Prer : ;

    CloseOpen ;

    Close ( OutFile );

End ;  { OutputFieldData }


  (*
  Procedure  OutFld;
            {‹‹‹‹‹‹}


     Var

                { äéÑàêéÇäÄ ùãÖåÖHíéÇ  åÄíêàñ }
                { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
                {    126 * ( 4100 * 4100 )    }

       { ( NumMatrix * 4100 + NumPixX ) * 4100 + NumPixY }
       { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

       NumPixel                                  : LongInt ;

       WriteOutFile,
       Matrix_FInd                               : Boolean ;

       SClassOut                                 : Byte    ;

       IndOut , IndCOut, IndConstOut             : LongInt ;
       NumPixelY, NumPixelX, IndF                : Integer ;
       IndSatOut, NumMatrix                      : LongInt ;
       NPPMBeg, NPPMEnd                          : LongInt ;

       XXOut, YYOut, FFOut                       : Double  ;
       X_Matrix_Center, Y_Matrix_Center          : Double  ;
       XPixelOut, YPixelOut                      : Double  ;

       Ra, Dc                                    : Double  ;

       NumStr                                    : String  [  5 ] ;




     Begin  { Pro OutFld }


       { ÇÆ··‚†≠Æ¢®¨ à§•†´Ï≠Î• äÆÆ‡§®≠†‚Î Æ°Í•™‚Æ¢ }
       { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

       {
       ResetObjects ;
       }


       { éíäêõíàÖ îÄâãÄ }
       { ÕÕÕÕÕÕÕÕÕÕÕÕÕÕ }

       FileMode := 2 ;
       If ( Exist( OutFileName  ) )
       Then
           Begin
                Assign( OutFile    ,  OutFileName ) ;
                Append( OutFile    ) ;
           End
       Else
           Begin
                Assign  ( OutFile    ,  OutFileName ) ;
                ReWrite ( OutFile );
           End;
       FileMode := 0 ;

       WriteLn( OutFile );




       { ÇõÇéÑ ìëíÄçéÇéóçõï ÑÄççõï }
       { ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ }


                   { Coordinates of field center }
                   { ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ }

       Writeln ( OutFile ) ;

       R1 := ( JdOut - 2415020.5 ) / 365.2422 + 1900.0 ;
       Str ( R1 :7:1, Stt ) ;

       Write ( OutFile , ' Center' , Stt, ' ='  ) ;

       With ParVar.Ra0 Do
            Write  ( OutFile , ' ',HourString (      Deg, Min, Sec));
       With ParVar.Dc0 Do
            Write  ( OutFile , ' ',DegrString ( Neg, Deg, Min, Sec));


       Write ( OutFile , '  Size' ) ;
       SiseFOV := ParConst.HG / GScale ;
       Stt := '¯ : ' ;
       If ( SiseFOV < C10 )  Then
          Begin
            SiseFOV := SiseFOV * C600 ;
            Stt := ''' : ' ;
            If ( SiseFOV < C10 )  Then
               Begin
                 SiseFOV := SiseFOV * C600 ;
                 Stt := '" : ' ;
               End ;
          End ;

       Write ( OutFile , Stt ) ;
       Write ( OutFile , SiseFOV     : 6:3 ) ;
       Write ( OutFile , '  MvMax : ', Param.MvMax : 4:1 ) ;

       Writeln ( OutFile ) ;

        { DATE }
        { ƒƒƒƒ }

       Write    ( OutFile ,  ' Date   ');
       With ParVar.Date  Do
       Write  ( OutFile , DateString ( Day, Month , Year ), '  ' );

        { TIME }
        { ƒƒƒƒ }

       With ParVar.Time Do
       Write  ( OutFile , TimeString ( Hour, Min, Round(Sec) ) );

       Writeln ( OutFile ) ;


       Writeln ( OutFile ) ;


              {  Planets  in  Field  }
              {  ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ  }


       IndSer := NPlanetsInFild ;
       NPF    := 0          ;

       For  Ind := 1 To  IndSer  Do
       If ( Planet^[Ind].NowVisible )  Then
         Begin   { IndSatOut }

          Xs := Planet^ [ Ind ] .X  ;
          Ys := Planet^ [ Ind ] .Y  ;

          If ( ReCalcPlanets )
            Then
              Begin
                ScToId ( Xs, Ys, nX, nY ) ;
                X := nX ;
                Y := nY ;
              End
            Else
              Begin
                X := Xs ;
                Y := Ys ;
              End ;


           POut := True ;

           If (     ( Planet^ [ Ind ].Nr <= Max_PL_PPLFLD )
                And ( Planet^ [ Ind ].Nr <> NPl0          )  )   Then
             Begin

               For Ipl := 1 To NPF  Do
                 Begin
                   Rs := Sqrt ( Sqr ( X - Xp [ Ipl ] ) +
                                Sqr ( Y - Yp [ Ipl ] )    );
                   If ( Rs + Planet^ [ Ind ].D_Izo / 2 < Rp [ Ipl ] )  Then
                        POut := False ;
                 End ;

               If ( POut )   Then
                 Begin
                   NPF        := NPF + 1 ;
                   Xp [ NPF ] :=   X     ;
                   Yp [ NPF ] :=   Y     ;
                   Rp [ NPF ] := Planet^ [ Ind ].D_Izo / 2 ;
                 End ;

             End ;


         End ;  { IndSatOut }



         { èpÆ·¨Æ‚p ä†‚†´Æ£Æ¢ }
         { ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ }

       For SClass := 1 To CatMax Do
         Begin { SClass }
               { ƒƒƒƒƒƒ }

         NPPMBeg   := IndCat [ SClass ].NBeg ;
         NPPMEnd   := IndCat [ SClass ].NEnd ;
         TypeCoord := IndCat [ SClass ].TypeCoord ;

         If ( NPPMBeg > -1 ) Then
         For IndCOut := NPPMBeg  To  NPPMEnd   Do
           With ObjectPtr [ IndCOut Div ObjectBlockSize ]^
                          [ IndCOut Mod ObjectBlockSize ] Do
           Begin

             If ( TypeCoord <> IdCoord )
               Then
                 Begin
                   nX := X ;
                   nY := Y ;
                   ScToId ( nX, nY, Xs, Ys ) ;
                   XXOut := Xs ;
                   YYOut := Ys ;
                 End
               Else
                 Begin
                   XXOut := X ;
                   YYOut := Y ;
                 End ;


             Matrix_FInd := False ;
             NumMatrix   :=   1   ;

                    { èpÆ¢•p™† Ì™p†≠®pÆ¢†≠®Ô Ø´†≠•‚†¨® }
                    { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

             POut := True ;

             For Ipl := 1 To NPF  Do
               Begin

                 Rs := Sqrt ( Sqr ( XXOut - Xp [ Ipl ] ) +
                              Sqr ( YYOut - Yp [ Ipl ] )    );

                 If ( Rs < Rp [ Ipl ] )  Then
                        POut := False ;

               End ;


             While (     ( NumMatrix <= N_Matrix )
                     And ( Not Matrix_FInd       )
                     And ( POut                  )  ) Do

               Begin
                 {
                 X_Matrix_Center  :=  MatrixCenter [ NumMatrix ] . X  ;
                 Y_Matrix_Center  :=  MatrixCenter [ NumMatrix ] . Y  ;
                 }
                 If ( ( Abs ( XXOut - X_Matrix_Center ) <= X_Max_Matrix )
                   And
                      ( Abs ( YYOut - Y_Matrix_Center ) <= Y_Max_Matrix )  )
                    Then
                       Matrix_FInd := True
                    Else
                       NumMatrix := NumMatrix + 1 ;
               End ;


             If ( Matrix_FInd )  Then
             Begin {Matrix_FInd }

               XXOut   := XXOut - X_Matrix_Center ;
               YYOut   := YYOut - Y_Matrix_Center ;

               NumPixelX := 1 + Trunc ( (   XXOut + X_Max_Matrix )
                                          / Period_X_mm ) ;
               NumPixelY := 1 + Trunc ( (   YYOut + Y_Max_Matrix )
                                          / Period_Y_mm ) ;

               XPixelOut := - X_Max_Matrix + ( NumPixelX - 1 ) * Period_X_mm
                                           +   PerXd2 ;

               YPixelOut := - Y_Max_Matrix + ( NumPixelY - 1 ) * Period_Y_mm
                                           +   PerYd2 ;


               If (     ( Abs ( XXOut - XPixelOut ) <  PixXd2 )
                  And
                        ( Abs ( YYOut - YPixelOut ) <  PixYd2 ) )  Then
                 Begin

                  NRecC    := ( NumMatrix * 4100 + NumPixelX ) * 4100
                                                 + NumPixelY ;

                  X := ( XXOut - XPixelOut ) / PixXd2 / 2 ;
                  Y := ( YYOut - YPixelOut ) / PixYd2 / 2 ;

                 End

                Else  NRecC := 0 ;

             End {Matrix_FInd }

             Else

                NRecC := 0 ;


           End ; { With ObjectPtr }


         End ; { SClass }
               { ƒƒƒƒƒƒ }






           {  ÇõÇéÑ  Ç  îÄâã  }
           {  ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ  }


       ShellNRec ( 0 , NumberOfStars - 1 ) ;
      {ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ}

       BSortSc := True  ;

       NumPixel := 0 ;

       WriteLn ( OutFile, '  NMatr Nx   Ny    DxCp    DyCp   Mv Sp' ) ;
       WriteLn ( OutFile ) ;

       For IndCOut := 0  To  NumberOfStars - 1  Do
         With ObjectPtr [ IndCOut Div ObjectBlockSize ]^
                        [ IndCOut Mod ObjectBlockSize ] Do
           Begin

             If ( NRecC > 0 )  Then
             Begin  { áÇÖáÑÄ HÄ èàäëÖãÖ }
                    { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

                 NumPixel  :=   NRecC ;

                 NumPixelY :=   NumPixel Mod 4100 ;
                 NumPixel  := ( NumPixel - NumPixelY ) Div 4100 ;
                 NumPixelX :=   NumPixel Mod 4100 ;
                 NumPixel  := ( NumPixel - NumPixelX ) Div 4100 ;
                 NumMatrix :=   NumPixel Mod 4100 ;

                 S := '   ' ;

                 If (     ( Sp >= 0 )
                      And ( Sp < 80 ) )   Then

                     Begin

                       S := ' ' + SpectraName [ ( Sp Mod 100 ) div 10 + 1 ];

                       If ( Sp Mod 100 ) div 10 <> 7
                         Then
                           Begin
                             str( Sp mod 10 : 1 , St );
                             s := s + St ;
                           End
                         Else
                             s := s + ' ' ;
                     End ;

                 WriteLn ( OutFile , NumMatrix : 5,
                                     NumPixelX : 5,
                                     NumPixelY : 5,
                                     X         : 8:3,
                                     Y         : 8:3,
                                     M/10-5    : 6:1,
                                     S         : 3    ) ;

             End ;  { áÇÖáÑÄ HÄ èàäëÖãÖ }
                    { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

           End ;  { With }
                  { ƒƒƒƒ }


           { Satellits }
           { ƒƒƒƒƒƒƒƒƒ }

       If ( NumberOfSatellits > 0 )  Then

         Begin   { Out Satellits }

           For  Ind := 1 To  NPlanetsInFild  Do
            If (      ( Planet^ [ Ind ].NowVisible         )
                 And  ( Planet^ [ Ind ].Nr > Max_PL_PPLFLD ) )  Then
              Begin   { IndSatOut }

               IndSatOut := Planet^[ Ind ].Nr - Max_Pl_PPlFld ;
               XXOut     := Planet^[ Ind ] .X  ;
               YYOut     := Planet^[ Ind ] .Y  ;
               FFOut     := Planet^[ Ind ] .M * 1.0e6 / 1.0e-10 ;

               Matrix_FInd := False ;
               NumMatrix   :=   1   ;

                    { èpÆ¢•p™† Ì™p†≠®pÆ¢†≠®Ô Ø´†≠•‚†¨® }
                    { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

               POut := True ;

               For Ipl := 1 To NPF  Do
                 Begin
                   Rs := Sqrt ( Sqr ( XXOut - Xp [ Ipl ] ) +
                                Sqr ( YYOut - Yp [ Ipl ] )    );
                   If ( Rs < Rp [ Ipl ] )  Then
                          POut := False ;
                 End ;


               While (     ( NumMatrix <= N_Matrix )
                       And ( Not Matrix_FInd       )
                       And ( POut                  )  ) Do

                 Begin
                   {
                   X_Matrix_Center  :=  MatrixCenter [ NumMatrix ] . X  ;
                   Y_Matrix_Center  :=  MatrixCenter [ NumMatrix ] . Y  ;
                   }
                   If ( ( Abs ( XXOut - X_Matrix_Center ) <= X_Max_Matrix )
                     And
                        ( Abs ( YYOut - Y_Matrix_Center ) <= Y_Max_Matrix )  )
                      Then
                         Matrix_FInd := True
                      Else
                         NumMatrix := NumMatrix + 1 ;
                 End ;


               If ( Matrix_FInd )  Then
               Begin {Matrix_FInd }

                 XXOut   := XXOut - X_Matrix_Center ;
                 YYOut   := YYOut - Y_Matrix_Center ;

                 NumPixelX := 1 + Trunc ( (   XXOut + X_Max_Matrix )
                                            / Period_X_mm ) ;
                 NumPixelY := 1 + Trunc ( (   YYOut + Y_Max_Matrix )
                                            / Period_Y_mm ) ;

                 XPixelOut := - X_Max_Matrix + ( NumPixelX - 1 ) * Period_X_mm
                                             +   PerXd2 ;

                 YPixelOut := - Y_Max_Matrix + ( NumPixelY - 1 ) * Period_Y_mm
                                             +   PerYd2 ;


                 If (     ( Abs ( XXOut - XPixelOut ) <  PixXd2 )
                      And ( Abs ( YYOut - YPixelOut ) <  PixYd2 ) )  Then
                   Begin

                    XXOut := ( XXOut - XPixelOut ) / PixXd2 / 2 ;
                    YYOut := ( YYOut - YPixelOut ) / PixYd2 / 2 ;


                    WriteLn ( OutFile , NumMatrix : 5,
                                        NumPixelX : 5,
                                        NumPixelY : 5,
                                        XXOut     : 8:3,
                                        YYOut     : 8:3,
                                        FFOut     : 10:5, ' w/cm/cm * 1e-10',
                           '   Sat #',  IndSatOut : 3    ) ;
                   End ;

               End ; {Matrix_FInd }

             End ;  { IndSatOut }

         End ; { Out Satellits }


       WriteLn ( OutFile ) ;
       Close   ( OutFile ) ;
       {
       RecalcObjects ;
       }
       FileMode := 2 ;

     End ;  { Pro OutFld }

  *)

End.
