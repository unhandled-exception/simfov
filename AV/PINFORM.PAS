
{$O+,F+}

Unit PInform ;

Interface

Uses  V_Catal, Graph ;

Var

    PMRed,
    B_Hip_NoCrd,
    PmExist      : Boolean ;
    {
    SClass       : Byte    ;
    }
    SpCrd        : Integer ;

    NmS,
    NRecCrd      : LongInt ;

    PmRaArcSec,
    PmDeclArcSec : Double  ;

    BsSrcRecord  : BSSrcType  ;


Procedure Inform ( Item : Integer; Point : pointtype ) ;


Implementation

Uses

   Crt,  Screen, PObjOut, PProFld,
   PVar, Pe_Cns, PPreNew, PVarName, PGalEkv, Info, PPlInfo,
   PRdCrd, PJd8, PVarMenu, PDateA20  ;

Const

 ClassId_Opt = 1;
 ClassId_Pln = 2;
 ClassId_Sat = 3;
 ClassId_Non = 4;


 ClassName   : Array [1..4] of string[15] = (
  'Opt ','            ','Sat. ','No object' );

 NameMonth : Array [ 1 .. 12 ] Of String [ 3 ] =
  (
    'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
    'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
  ) ;

 bc        = lightgray ;
 fc        = black     ;




Procedure Inform ( Item : Integer; Point : pointtype );

var
 {
 B_Hip_NoCrd : Boolean   ;
 }
 CObject : ObjectType    ;

 SVar    : String        ;
 S, S2   : String        ;
 S9      : S9Type        ;
 S19     : S19Type       ;
 S1,t    : String [ 40 ] ;
 NameCat : String [ 15 ] ;
 SMonth  : String [  3 ] ;
 SName   : String [ 12 ] ;

 Spp,
 class,
 NDm    : Byte   ;
 Nf,
 NDel   : Integer;
 ind	: Integer;
 I, I1  : Integer;
 NAdd,
 NSer,
 NDecl,
 N      : longint;
 n1, n2 : longint;
 NRec   : LongInt;

 {
 PMRed,
 PmExist,
 }
 cneg   : boolean;
 g,mnt  : Integer;
 sec    : Double ;
 Mv,
 BmV,
{
 PmRaArcSec,
 PmDeclArcSec,
}
 PmRa, PmDecl,
 NoX,NoY: Double ;
 R,
 Ra,
 Decl,
 ORa    ,
 ODc    : double ;
 diam   : double ;
 RR     : Double ;
 RI     : LongInt;
 Jd     : Double ;
 Year   : Longint;
 Month  : Integer;
 DateInf: Word   ;
 NZagol : Word   ;
 Day    : Double ;
 JdGsc  : Double ;
 JdGsc0 : Double ;
 YearGsc: Double ;
 {
 NmS    : LongInt;
 }

Begin



 If Item >= 0 Then
   Begin

    Sclass := 255 ;

    For Ind := 1 To CatMax Do
      Begin
        If (      ( Item >= IndCat[Ind].NBeg )
             And  ( Item <= IndCat[Ind].NEnd )  )
          Then  Sclass := Ind ;
      End ;

      If ( SClass <= CatMax )
         Then  Class := ClassId_Opt;

   End
 Else
 Begin
  If ( Item = -100 ) Then
       Class := ClassId_Non
     Else
       Begin
        PlanetRecord := PlanetPtr [ -Item Div PlanetBlockSize ]^
                                  [ -Item Mod PlanetBlockSize ] ;
        If ( PlanetRecord.Nr > Max_PL_PPLFLD )
          Then  class := ClassId_Sat
          Else  class := ClassId_Pln ;
       End;
 End;


 If class <> lastobject Then
   Begin

     lastobject := class ;

     InitInfo ;

     If ( Out_Mess_AV )  Then
       MessageAV ( S_mess_AV, B_Color_Mess_Av );

   End;


 Case Class of


  ClassId_Opt :

   Begin    {  Opt Cat  }

    NoOpticsData;

    SClassInfo   := SClass ;
    IndClassInfo := Item   ;

    B_Hip_NoCrd  := False  ;

    CObject := ObjectPtr [ Item Div ObjectBlockSize ]^
                         [ Item Mod ObjectBlockSize ] ;
    With CObject Do
     Begin

       If ( SClass = CatOthers )  Then
         NameCat := CatNameKutcha [ ( NRecC Mod 1000000000 ) Mod 20 ] ;

       SVar := '' ;

            { ù™¢†‚Æp®†´Ï≠Î• äÆÆp§®≠†‚Î }
            { ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ }


       ScToId ( x,y,NoX,NoY );

       NRecCrd := NRecC ;
       SpCrd   := Sp    ;

       RdCrd ;

       PmRa   := PmRaArcSec   / SekRad * Fd ;
       PmDecl := PmDeclArcSec / SekRad * Fd ;

       (*

       PMRed   := False ;
       PmExist := False ;

       PmRaArcSec   := 0.0 ;
       PmDeclArcSec := 0.0 ;

       If (    ( ( Sclass = CatCdc )  And  ( B_Cdc_Cat )  )
            Or (   Sclass = CatHip                        )
            Or (   Sclass = CatTyc                        )
            Or (   Sclass = CatPpm                        )
            Or (   Sclass = CatSao                        )
            Or (   Sclass = CatNltt                       )
            Or (   Sclass = CatBs                         )
            Or (   Sclass = CatNpm                        )  )
          Then
            Begin
              If ( B_Import_Fld Or OptRd )
                 Then  PmRed := True  ;
            End ;


       If ( ( Sclass = CatCdc )  And  ( B_Cdc_Cat )  )  Then
         Begin
           Seek  ( CdcFile , ( NRecC Mod 1000000000 ) - 1 ) ;
           Read  ( CdcFile , CdcRecord ) ;
           If ( CdcRecord.MuRa <> 32123 )  Then
             Begin  { Ö·‚Ï  P.M. }
               PmRaArcSec   := CdcRecord.MuRa  / C10000 ;
               PmDeclArcSec := CdcRecord.MuDec / C10000 ;
               PmExist      := True                     ;
             End ;
         End ;


       If ( SClass = CatBs )  Then
         Begin

           FileMode := 0 ;

           Reset ( BsFile                                ) ;
           Seek  ( BsFile , ( NRecC Mod 1000000000 ) - 1 ) ;
           Read  ( BsFile , BSRecord ) ;
           Close ( BsFile                                ) ;
           NmS := BSRecord.Sao ;
           Reset ( BsSrcFile ) ;
           Seek  ( BsSrcFile , NmS - 1     ) ;
           Read  ( BsSrcFile , BsSrcRecord ) ;
           Close ( BsSrcFile ) ;
           PmRaArcSec   := BsRecord.MURA  / 0.6 / 1000000000.0 * SekRad ;
           PmDeclArcSec := BsRecord.MUDEC / 0.6 / 1000000000.0 * SekRad ;
           PMExist      := True  ;
         End ;


       If ( SClass = CatHd )  Then
         Begin  { CatHd }
           If ( Sp >= 100 )
             Then
               Begin
                 HdE := True ;
                 FileMode := 0 ;
                 ReSet ( HdeFile ) ;
                 Seek  ( HdEFile, ( NRecC Mod 1000000000 ) - 1 ) ;
                 Read  ( HdEFile, HdERecord  ) ;
                 Close ( HdeFile             ) ;
                 If ( HdERecord.MuRa < 32000 )  Then
                   Begin
                     PmRaArcSec   := HdERecord.MuRa  / C10000 ;
                     PmDeclArcSec := HdERecord.MuDec / C10000 ;
                     PMExist      := True                     ;
                   End ;
               End
             Else
               Begin
                 FileMode := 0 ;
                 ReSet ( HdFile )                                ;
                 Seek  ( HdFile, ( NRecC Mod 1000000000 ) - 1 )  ;
                 Read  ( HdFile, HdRecord  )                     ;
                 Close ( HdFile            )                     ;
                 HdE := False                                    ;
               End ;
         End ;  { CatHd }



       If ( Sclass = CatHip )  Then
         Begin
           FileMode := 0 ;
           Reset ( HipFile                                ) ;
           Seek  ( HipFile , ( NRecC Mod 1000000000 ) - 1 ) ;
           Read  ( HipFile , HipRecord                    ) ;
           Close ( HipFile                                ) ;
           PmRaArcSec   := HipRecord.PmRa   / C10000 ;
           PmDeclArcSec := HipRecord.PmDecl / C10000 ;
           PmExist      := True                      ;
           If ( B_HIP_Add )  Then
             Begin
               FileMode := 0 ;
               Reset ( HipAddFile ) ;
               Seek  ( HipAddFile , ( NRecC Mod 1000000000 ) - 1 ) ;
               Read  ( HipAddFile , HipAddRecord ) ;
               Close ( HipAddFile ) ;
               If ( Abs ( HipRecord.NSerInFile ) Div 1000000 = 1 )
                 Then
                   Begin
                     B_Hip_NoCrd := True  ;
                     PmExist     := False ;
                   End
                 Else
                     B_Hip_NoCrd := False ;
             End ;
         End ;


       If ( Sclass = CatTyc )  Then
         Begin
           FileMode := 0 ;
           Reset ( TycFile ) ;
           Seek  ( TycFile , ( NRecC Mod 1000000000 ) - 1 ) ;
           Read  ( TycFile , HipRecord ) ;
           Close ( TycFile ) ;
           If ( HipRecord.PmRa > (-32000.0+1.0) )  Then
             Begin
               PmRaArcSec   := HipRecord.PmRa   / C10000 ;
               PmDeclArcSec := HipRecord.PmDecl / C10000 ;
               PmExist      := True                      ;
             End ;
           If ( B_Tyc_2_Add )  Then
             Begin
               FileMode := 0 ;
               Reset ( TycAddFile ) ;
               Seek  ( TycAddFile , ( NRecC Mod 1000000000 ) - 1 ) ;
               Read  ( TycAddFile , TycAddRecord ) ;
               Close ( TycAddFile ) ;
               PmRaArcSec   := TycAddRecord.PmRa   ;
               PmDeclArcSec := TycAddRecord.PmDecl ;
             End ;
         End ;


       If ( Sclass = CatPpm )  Then
         Begin
           FileMode := 0 ;
           Reset ( PpmFile ) ;
           Seek  ( PpmFile , ( NRecC Mod 1000000000 ) - 1 ) ;
           Read  ( PpmFile , PpmRecord ) ;
           Close ( PpmFile ) ;
           PmRaArcSec   := PpmRecord.MuRa  / 3000.0 ;
           PmDeclArcSec := PpmRecord.MuDec / 3000.0 ;
           PmExist      := True                     ;
         End ;


       If ( Sclass = CatSao )  Then
         Begin
           FileMode := 0 ;
           Reset ( SaoFile ) ;
           Seek  ( SaoFile , ( NRecC Mod 1000000000 ) - 1 ) ;
           Read  ( SaoFile , SaoRecord ) ;
           Close ( SaoFile ) ;
           PmRaArcSec   := SaoRecord.MuRa  / 0.6 / 1000000000.0 * SekRad ;
           PmDeclArcSec := SaoRecord.MuDec / 0.6 / 1000000000.0 * SekRad ;
           PmExist      := True  ;
         End ;


       If ( Sclass = CatNltt )  Then
         Begin
           FileMode := 0 ;
           Reset ( NlttFile ) ;
           Seek  ( NlttFile , ( NRecC Mod 1000000000 ) - 1 ) ;
           Read  ( NlttFile , NlttRecord ) ;
           Close ( NlttFile ) ;
           PmRaArcSec   := NlttRecord.MuRa  / 0.6 / 1000000000.0 * SekRad ;
           PmDeclArcSec := NlttRecord.MuDec / 0.6 / 1000000000.0 * SekRad ;
           PmExist      := True  ;
         End ;


       If ( Sclass = CatNpm )  Then
         Begin
           FileMode := 0 ;
           Reset ( NpmFile                                 ) ;
           Seek  ( NpmFile , ( NRecC Mod 1000000000 ) - 1  ) ;
           Read  ( NpmFile , NpmRecord                     ) ;
           Close ( NpmFile                                 ) ;
           PmRaArcSec   := NpmRecord.MuRa   ;
           PmDeclArcSec := NpmRecord.MuDec  ;
           PmExist      := True             ;
         End ;


       PmRa   := PmRaArcSec   / SekRad * Fd ;
       PmDecl := PmDeclArcSec / SekRad * Fd ;

       *)
       If (     ( PmRed     )
            And ( PmExist   )
            And ( Not B_Gal )  )  Then
          Begin  { è•p•¢Æ§ ™ÆÆp§®≠†‚ ≠† ÌØÆÂ„ ß† P.M. }
                 { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

            XYEpOut ( Sclass, PmRa, PmDecl, NoX, NoY ) ;

            If ( PmDecl < C10000 )
              Then
                Begin
                  PmRaArcSec   :=  PmRa   / Fd * SekRad ;
                  PmDeclArcSec :=  PmDecl / Fd * SekRad ;
                End
              Else
                  PmExist := False ;

          End ;

       {
       If ( B_Import_Fld Or OptRd )
       }

       If ( OptRd )
         Then
           Begin
             IdToEq1 ( NoX, NoY, ORa, ODc ) ;
           End
         Else
           Begin
             {
             IdToEq ( NoX,NoY,NPolFix,SPozNp,CPozNp,ORa,ODc );
             }
             IdToEq1 ( NoX, NoY, ORa, ODc ) ;
             PreNew ( JDateFld, JDOut, ORa, ODc ) ;
           End ;

                 { è‡. ¢Æ·ÂÆ¶§•≠®• }
                 { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

       If ( Not B_Gal )
         Then
           Begin
             RadToHms ( ORa, g, mnt, sec );
             Str(g  :3,s)  ;  s:=s  +chr(240) + ' ';
             Str(mnt:2,t)  ;  s:=s+t+chr(241)+ ' ';
             Str(sec:6:3,t);  s:=s+t+chr(242)+ ' ';
           End
         Else
           Begin
             RadToGMS ( ORa, cneg, g, mnt, sec ) ;
             Str(g  :3,s)  ;  s:=s      +chr(243)+ ' ';
             Str(mnt:2,t)  ;  s:=s+t    +chr(244)+ ' ';
             Str(sec:5:2,t);  s:=s+t+' '+chr(245)+ ' ';
           End ;

       If ( B_Hip_NoCrd )
         Then
           Begin
             PutS ( ras_w.wnd ,true,LightRed,fc,righttext,centertext, s )
           End
         Else
             PutS ( ras_w.wnd ,true,bc,fc,righttext,centertext, s );

                    { ë™´Æ≠•≠®• }
                    { ƒƒƒƒƒƒƒƒƒ }

       RadToGMS ( ODc,cneg,g,mnt,sec ) ;
       Str(g  :3,s);   s:=s      +chr(243)+ ' ';
       Str(mnt:2,t);   s:=s+t    +chr(244)+ ' ';
       Str(sec:5:2,t); s:=s+t+' '+chr(245)+ ' ';
       If cneg Then
         s[1]:='-';


       If ( B_Hip_NoCrd )
         Then
           Begin
             PutS ( dcs_w.wnd ,true,LightRed,fc,righttext,centertext, s )
           End
         Else
             PutS ( dcs_w.wnd ,true,bc,fc,righttext,centertext, s );




            { Magnitude }
            { ‹‹‹‹‹‹‹‹‹ }

             If ( Sclass = CatDm )
               Then
                 Begin
                   Mv := M / C100 - 5 ;
                   If ( Mv ) < 13.0
                     Then
                       Begin
                         Str ( Mv : 4 : 1 , s ) ;
                       End
                     Else
                       Begin
                         S := ' ? ' ;
                         Case ( Round ( Frac ( Mv ) * C100 ) )  Of

                           2 : S := S + 'Neb ' ;
                           3 : S := S + 'Var ' ;
                           4 : S := S + 'Nova' ;
                           5 : S := S + 'Cum ' ;

                         End ;
                       End ;
                 End
               Else
                 Begin

                   If (    ( SClass = CatCdc    )
                        Or ( SClass = CatCdcMoz )  )
                     Then
                       Begin
                         If ( ( M / C100 - 5 ) > 17.0 )
                           Then S := ''
                           Else Str ( M / C100 - 5 : 4:1 , s ) ;
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
                               Str  ( CcdRecord.Diam : 6 : 0, s ) ;
                             End
                           Else
                             Begin

                               If ( SClass = CatA20 )
                                 Then
                                   Begin

                                     NmS := NRecC Mod 1000000000 ;
                                     RR  := Frac ( NRecC / C10000 ) * C1000 ;
                                     Nf  := ( NmS Div 1000 ) Mod 1000 ;


                                     Str ( M / C100 : 4 : 1 , S ) ;

                                     If ( Nf <> 0 )  Then
                                       S := 'B ' + S ;


                                     If ( RR <= 99.8 )
                                       Then
                                         Begin
                                           If ( Abs ( M/C100 - RR ) < C100 )
                                             Then
                                               Begin
                                                 Str ( M/C100 - RR : 5 : 1 , S1 ) ;
                                                 S := S + '  B-R' + S1 ;
                                               End
                                             Else
                                               Begin
                                                 Str ( RR : 4 : 1 , S1 ) ;
                                                 S := S + '  R ' + S1 ;
                                               End ;

                                         End
                                       Else
                                         S := S + '         ' ;

                                   End
                                 Else
                                   Begin
                                     Str ( M / C100 - 5 : 4 : 1 , S ) ;
                                   End ;


                               If ( SClass = CatNpm )  Then
                                 Begin
                                   BmV := NpmRecord.BmV / C100 ;
                                   Str ( BmV : 5:1, s1 ) ;
                                   While ( s1 [ 1 ] = ' ' )  Do
                                     Delete ( s1, 1, 1 ) ;
                                   If ( NpmRecord.BmV <> -100 )
                                     Then  s := 'B ' + s + '  B-V ' + s1
                                     Else  s := 'B ' + s ;
                                 End ;

                               If ( SClass = CatSao )  Then
                                 Begin
                                   Str ( SaoRecord.Mp / C100 : 5:1, s1 ) ;
                                   While ( s1 [ 1 ] = ' ' )  Do
                                     Delete ( s1, 1, 1 ) ;

                                   If ( SaoRecord.Mp <> 999 )
                                     Then  S := 'Mv ' + s + '  Mp ' + s1
                                     Else  S := 'Mv ' + s                ;

                                 End ;
                             End ;
                       End ;

                 End ;




       If ( Sclass = CatGcvs )  Then
         Begin

           FileMode := 0 ;

           If ( B_Gcvs2000 )
             Then
               Begin

                 Reset ( Gcvs2000File                                ) ;
                 Seek  ( Gcvs2000File , ( NRecC Mod 1000000000 ) - 1 ) ;
                 Read  ( Gcvs2000File , Gcvs2000Record               ) ;
                 Close ( Gcvs2000File                                ) ;

                 GcvsRecord.SdRa    := Gcvs2000Record.SdRa    ;
                 GcvsRecord.SdDec   := Gcvs2000Record.SdDec   ;
                 GcvsRecord.NameStr := Gcvs2000Record.NameStr ;
                 GcvsRecord.MStr    := Gcvs2000Record.MStr    ;
                 GcvsRecord.SpStr   := Gcvs2000Record.SpStr   ;

               End
             Else
               Begin

                 Reset ( GcvsFile                                ) ;
                 Seek  ( GcvsFile , ( NRecC Mod 1000000000 ) - 1 ) ;
                 Read  ( GcvsFile , GcvsRecord                   ) ;
                 Close ( GcvsFile                                ) ;

               End ;

           S := GcvsRecord.MStr ;
           S := Copy ( GcvsRecord.NameStr, 14, 1 ) + S ;

         End ;



       If (     ( SClass = CatHd )
            And ( Not HdE        )  )  Then
         Begin
           Str ( HdRecord.Mv / C1000 : 4 : 1, s ) ;
           Str ( HdRecord.Mp / C1000 : 4 : 1, t ) ;
           If ( S[1] = ' ' )  Then
             Delete ( S, 1, 1 ) ;
           If ( t[1] = ' ' )  Then
             Delete ( t, 1, 1 ) ;
           S := 'Mv ' + s + '  Mp ' + t ;
         End ;


       If ( SClass = CatNLtt )  Then
         Str ( NLttRecord.Mv / C100 : 4 : 1, s ) ;


       If ( SClass = CatOthers )  Then
         Begin
           S := '' ;
           If (    ( NameCat = 'HIP')
                Or ( NameCat = 'TYC') )  Then
             Str ( M / C100 - 5.0  : 4 : 1, s ) ;
         End ;


       If ( SClass = CatHip ) Then
         Begin
           If ( HipRecord.MV / C100 > C1000 )  Then
             S := S + ' V Johns.';
         End ;



       If (     ( SClass = CatHip )
            And ( B_Hip_Add       )  )  Then
         Begin

           If ( HipAddRecord.VT <> -32000 )
             Then
               Begin
                 Str ( HipAddRecord.VT    / C10000 : 5:2, S ) ;
                 S := 'VT ' + S ;
               End
             Else
               Begin
                 If ( HipAddRecord.BT <> -32000 )
                   Then
                     Begin
                       Str ( HipAddRecord.BT    / C10000 : 5:2, S ) ;
                       S := 'BT ' + S ;
                     End
                   Else
                     Begin
                       S := '';
                       Str ( M / C100 - 5.0  : 4 : 1, s ) ;
                       If ( HipRecord.MV / C100 > C1000 )  Then
                         S := 'VJ ' + S ;
                     End
               End ;

           If ( HipAddRecord.BmV <> -32000 )
             Then
               Begin
                 Str ( HipAddRecord.BmV / C10000 : 5:2, t ) ;
                 S :=  S + '  b-v' + t ;
               End
             Else
               Begin

                 If (     ( HipAddRecord.BT <> -32000 )
                      And ( HipAddRecord.VT <> -32000 ) )
                   Then
                     Begin
                       Str ( (   HipAddRecord.BT
                               - HipAddRecord.VT ) / C10000 : 5:2, t ) ;
                       S :=  S + '  B-V' + t ;
                     End
                   Else
                     Begin
                       If ( HipAddRecord.VmI <> -32000 )  Then
                         Begin
                           Str ( HipAddRecord.VmI / C1000 : 5:2, t ) ;
                           S :=  S + '  v-i' + t ;
                         End ;
                     End ;

               End ;

         End ;




       If (     ( SClass = CatTyc )
            And ( B_Tyc_Sai       )  )  Then
         Begin
           If ( HipRecord.MV / C100 > C1000 )  Then
             S := S + ' V Johns.';
         End ;


       If (     ( SClass = CatTyc )
            And ( B_Tyc_2         )  )  Then
         Begin

           If ( B_Tyc_2_Add )
             Then
               Begin

                 If ( TycAddRecord.VT <> -32000 )
                   Then
                     Begin
                       Str ( TycAddRecord.VT    / C10000 : 6:3, S ) ;
                       Str ( TycAddRecord.MqeVT / C10000 : 5:3, t ) ;
                       Delete ( t, 1, 1) ;
                       S := 'V   ' + S + ' Er' + t ;
                     End
                   Else
                     Begin
                       If ( TycAddRecord.BT <> -32000 )
                         Then
                           Begin
                             Str ( TycAddRecord.BT    / C10000 : 6:3, S ) ;
                             Str ( TycAddRecord.MqeBT / C10000 : 5:3, t ) ;
                             Delete ( t, 1, 1) ;
                             S := 'B   ' + S + ' Er' + t ;
                           End
                         Else
                           Begin
                             S := '';
                           End
                     End
               End
             Else
               Begin

                 If ( HipRecord.MV / C100 > C1000 )
                   Then  S := 'B ' + S
                   Else  S := 'V ' + S ;

               End ;

         End ;



       If ( SClass <> CatA20 )  Then
         While (     ( Length ( S ) > 0 )
                 And ( S [ 1 ] = ' '    )  )  Do
           Delete ( S, 1, 1 ) ;



       If (     ( SClass = CatA20  )
            And ( ( ( Sp Mod 10 ) And 1 ) = 1 )  )
         Then PutS ( mv_w.wnd, true, LightRed, fc, centertext, centertext, s )
         Else PutS ( mv_w.wnd, true, bc,       fc, centertext, centertext, s ) ;





       { HÆ¨•p + ä´†··®‰®™†Ê®Ô Æ°Í•™‚† + N Æ°Í•™‚Æ¢ ¢ Æ·p•§≠•≠®® }
       { ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ }


       If (      ( Sclass = CatPPM          )
              Or ( Sclass = CatHip          )
              Or ( Sclass = CatTyc          )
              Or ( Sclass = CatNpm          )
              Or ( Sclass = CatSao          )
              Or ( Sclass = CatNLtt         )
              Or ( Sclass = CatBs           )
              Or ( Sclass = CatHd           )
              Or ( Sclass = CatCdc          )
              Or ( Sclass = CatCdcMoz       )
              Or ( Sclass = CatGsc          )
              Or ( Sclass = CatA20          )
              Or ( Sclass = CatDm           )
              Or ( Sclass = CatGcvs         )
              Or ( Sclass = CatOthers       )
                                              )  Then
         Begin

             NmS := NRecC Mod 1000000000 ;
             s := '' ;


             If ( SClass = CatSao )  Then
               Begin

                 If ( NRecC Div 1000000000 <> 1 )
                   Then
                     Begin
                       NmS := SaoRecord.Sao ;
                       Str ( NmS  : 6 , S ) ;
                       If ( SaoRecord.GcStr <> '     ' )  Then
                         S := S + ' GC: ' + SaoRecord.GcStr ;
                     End
                   Else
                     Begin  { Sao Marking }
                       NmS := Date + NumbMarkingBegin ;
                       Str ( Abs ( NmS ) : 8 , s ) ;
                     End ;  { Sao Marking }

               End ;


             If ( SClass = CatHip )  Then
               Begin

                 If ( NRecC Div 1000000000 <> 1 )
                   Then
                     Begin
                       If ( B_Hip_Add )
                         Then
                           Begin
                             NmS := HipAddRecord.HipNumber ;
                           End
                         Else
                           Begin
                             NmS := Abs ( HipRecord.NSerInFile ) Mod 2000000  ;
                           End ;
                       Str ( NmS  : 7 , s ) ;
                     End
                   Else
                     Begin  { Hip Marking }
                       NmS := Date + NumbMarkingBegin ;
                       Str ( Abs ( NmS ) : 8 , s ) ;
                     End ;  { Hip Marking }

               End ;


             If ( SClass = CatTyc )  Then
               Begin

                 If ( NRecC Div 1000000000 <> 1 )
                   Then
                     Begin

                       If ( B_Tyc_0 ) Then
                         Begin
                           NmS := Abs ( HipRecord.NSerInFile ) Mod 2000000 ;
                           Str ( NmS  : 7 , s ) ;
                         End ;

                       If ( B_Tyc_Sai ) Then
                         Begin
                           NmS := Abs ( HipRecord.NSerInFile ) Div 100000 ;
                           Str ( NmS  : 4 , s ) ;
                           NmS := Abs ( HipRecord.NSerInFile ) Mod 100000 ;
                           Str ( NmS  : 6 , t ) ;
                           S := S + t ;
                           If ( HipRecord.NSerInFile < 0 )
                             Then  S := S + ' 2'
                             Else  S := S + ' 1' ;
                         End ;

                       If ( B_Tyc_2 ) Then
                         Begin
                           NmS := Abs ( HipRecord.NSerInFile ) Div 100000 ;
                           Str ( NmS  : 4 , s ) ;
                           NmS := Abs ( HipRecord.NSerInFile ) Mod 100000 ;
                           Str ( NmS  : 6 , t ) ;
                           S := S + t ;
                           t := ' 1' ;
                           If ( HipRecord.Cat And 4 = 4 ) Then
                             t := ' 2';
                           If ( HipRecord.Cat And 8 = 8 ) Then
                             t := ' 3';
                           S := S + t ;
                         End ;

                     End
                   Else
                     Begin  { Tyc Marking }
                       NmS := Date + NumbMarkingBegin ;
                       Str ( Abs ( NmS ) : 8 , s ) ;
                     End ;  { Tyc Marking }

               End ;


             If ( SClass = CatPPM )  Then
               Begin

                 If ( NRecC Div 1000000000 <> 1 )
                   Then
                     Begin
                       NmS := PPMRecord.PPM Mod 1000000  ;
                       Str ( NmS  : 8 , s ) ;
                     End
                   Else
                     Begin  { PPM Marking }
                       NmS := Date + NumbMarkingBegin ;
                       Str ( Abs ( NmS ) : 8 , s ) ;
                     End ;  { PPM Marking }

               End ;


             If ( SClass = CatNpm )  Then
               Begin

                 If ( NRecC Div 1000000000 <> 1 )
                   Then
                     Begin

                       NmS := NpmRecord.Num ;

                       Str ( Abs ( NmS ) / 10000  : 8 : 4 , s ) ;

                       If  ( S [ 2 ] = ' ' )  Then
                         S [ 2 ] := '0' ;

                       If ( Nms > 0 )
                         Then S [ 1 ] := '+'
                         Else S [ 1 ] := '-' ;

                       S := 'NPM ' + S ;

                     End
                   Else
                     Begin  { Npm Marking }
                       NmS := Date + NumbMarkingBegin ;
                       Str ( Abs ( NmS ) : 8 , s ) ;

                       S := 'NPM ' + S ;

                     End ;  { Npm Marking }

               End ;


             If ( SClass = CatNLtt )  Then
               Begin

                 If ( NRecC Div 1000000000 <> 1 )
                   Then
                     Begin

                       S := NLttRecord.Name ;

                     End
                   Else
                     Begin  { Npm Marking }

                       NmS := Date + NumbMarkingBegin ;
                       Str ( Abs ( NmS ) : 8 , s ) ;

                       S := 'NPM ' + S ;

                     End ;  { Npm Marking }

               End ;


             If ( SClass = CatBs )  Then
               Begin
                 If ( NRecC Div 1000000000 <> 1 )
                   Then
                     Begin

                       FileMode := 0 ;

                       Reset ( BsFile                                ) ;
                       Seek  ( BsFile , ( NRecC Mod 1000000000 ) - 1 ) ;
                       Read  ( BsFile , BSRecord             ) ;
                       Close ( BsFile                        ) ;
                       NmS := BSRecord.SAO ;
                       Reset ( BsSrcFile ) ;
                       Seek  ( BsSrcFile , NmS - 1     ) ;
                       Read  ( BsSrcFile , BsSrcRecord ) ;
                       Close ( BsSrcFile ) ;
                       Str   ( BsSrcRecord.Bs  : 8 , s ) ;
                     End
                   Else
                     Begin  { Bs  Marking }
                       NmS := Date + NumbMarkingBegin ;
                       Str ( Abs ( NmS ) : 8 , s ) ;
                     End ;  { Bs  Marking }
               End ;



             If ( SClass = CatDm )  Then
               Begin

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


                 If (     ( NameDm [ NDm ] = 'SD' )
                      And ( NDecl < -1            )  )
                   Then  S := NameDm [ NDm - 1 ] + ' ' + S
                   Else  S := NameDm [ NDm     ] + ' ' + S ;
                 Str ( NSer : 6 , t ) ;
                 S := S + t + NDmAdd [ NAdd ] ;

                 S := '   ' + S ;


                 If ( NRecC Div 1000000000 = 1 )
                     Then
                       Begin  { Dm Marking }
                         NmS := Date + NumbMarkingBegin ;
                         Str ( Abs ( NmS ) : 8 , s ) ;
                       End    { Dm Marking }

               End ;



             If (      ( SClass = CatCdc    )
                   Or  ( SClass = CatCdcMoz )  )   Then
               Begin

                 t := '';
                 S := t ;

                 If ( Not B_Cdc_Cat )
                   Then
                     Begin  { CatCdcMoz }

                       RI := ( NRecC Mod 1000000000 ) Div 1000  ;

                       If  ( RI Mod 10 > 0 )
                         Then
                           Begin
                             Str ( RI Div 10  : 7 , t ) ;
                             t := t + Chr ( Ord('a')+ (RI Mod 10 - 1)) ;
                           End
                         Else
                             Str ( RI Div 10 : 7   , t ) ;


                          { èp®ß≠†™® à·Øp†¢´•≠®© }
                          { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
                          N1 := Sp Mod 10 ;

                          If ( N1 Mod 2 = 1 )
                            Then  t := t + ' X?' ;

                          If ( ( N1 Mod 4 ) Div 2 = 1 )
                            Then  t := t + ' Y?'

                     End
                   Else
                     Begin

                      If ( NRecC Div 1000000000 = 1 )
                        Then
                          Begin  { Marking }
                            NmS := Date + NumbMarkingBegin ;
                            Str ( Abs ( NmS ) : 8 , s ) ;
                          End    { Marking }
                        Else
                          Begin
                            SPp := ( CdcRecord.Cat Div 4 ) Mod 15;
                            Str ( SPp : 2 , t ) ;
                            t := t + ' obs' ;
                          End ;

                     End ;

                 S := S + t + ' ' ;

               End ;  { Cdc }



             If ( SClass = CatGsc )    Then
                Begin  { CatGsc }

                  If ( NRecC Div 1000000000 = 1 )
                     Then
                       Begin  { Gsc Marking }
                         NmS := Date + NumbMarkingBegin ;
                         Str ( Abs ( NmS ) : 8 , s ) ;
                       End    { Gsc Marking }
                     Else
                       Begin  { Gsc Not Marking }
                         If ( GscAddExist )   Then
                            Begin

                              If ( GscNew )
                                Then
                                  Begin
                                    RR := NmS / 100000.0  ;
                                    Str ( RR : 10:5 , s ) ;
                                  End
                                Else
                                  Begin
                                    RR := NmS /  10000.0 ;
                                    Str ( RR : 9:4 , s ) ;
                                  End ;

                              While ( Pos ( '.0', S ) > 0 )  Do
                                Delete ( S, Pos ( '.0', S ) + 1, 1 ) ;

                            End ;
                       End ;   { Gsc Not Marking }

                End ;  { CatGsc }


             If ( SClass = CatA20 )    Then
                Begin  { CatA10 }

                  S := '' ;

                  If ( NRecC Div 1000000000 = 1 )
                     Then
                       Begin  { A10 Marking }
                         NmS := Date + NumbMarkingBegin ;
                         Str ( Abs ( NmS ) : 8 , s ) ;
                       End ;  { A10 Marking }


                  If ( Nf <> 0 )  Then
                    Begin

                      If ( Sp Mod 10 ) And 2 = 2
                        Then
                          Begin
                            Seek ( A20DateSFile, Nf - 1 ) ;
                            Read ( A20DateSFile, S19    ) ;
                            DateA20 ( S19, S9 ) ;
                          End
                        Else
                          Begin
                            Seek ( A20DateNFile, Nf - 1 ) ;
                            Read ( A20DateNFile, S9     ) ;
                          End ;

                      If ( Length ( S ) > 0 )  Then
                        S := S + '  ' ;


                      t := '' ;
                      For N1 := 1 To 2 Do
                        t := t + S9.S9 [ N1 ] ;
                      Val ( t, Day, Code ) ;

                      SMonth := '' ;
                      For N1 := 4 To 6 Do
                        SMonth := SMonth + S9.S9 [ N1 ] ;
                      Month := 1 ;
                      While     ( SMonth <> NameMonth [ Month ] )
                            And ( Month  <  12                  )  Do
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

                End ;


             If ( SClass = CatGcvs )    Then
                Begin  { CatGcvs }
                  If ( NRecC Div 1000000000 = 1 )
                     Then
                       Begin  { Gcvs Marking }
                         NmS := Date + NumbMarkingBegin ;
                         Str ( Abs ( NmS ) : 8 , s ) ;
                       End    { Gcvs Marking }
                     Else
                       Begin
                         If (     ( B_Gcvs2000                    )
                              And ( Gcvs2000Record.PmRa <> -32000 ) ) Then
                           Begin
                             Str ( Gcvs2000Record.PmRa   / 1000.0 : 7:3, S ) ;
                             Str ( Gcvs2000Record.PmDecl / 1000.0 : 7:3, t ) ;
                             S := 'PM" ' + S + t ;
                           End ;
                       End ;

                End ;  { CatGcvs }



             If ( SClass = CatHd )    Then
                Begin  { CatHd }
                  If ( Sp < 100 )
                    Then
                      Begin
                        Str ( HdRecord.Num : 6 , s ) ;
                        If ( HdRecord.Remarks <> ' ' )  Then
                          S := S + ' ' + HdRecord.Remarks ;
                      End
                    Else
                      Begin
                        Str ( HdERecord.Num Div 10 : 6 , s ) ;
                        N1 := HdERecord.Num Mod 10 ;
                        If ( N1 > 0 )  Then
                          S := S + ' ' + Chr ( N1 - 1 + Ord ( 'A')  ) ;
                      End ;

                End ;  { CatHd }



             If ( SClass = CatOthers )  Then
               Begin

                 S := CatNameKutcha [ ( NRecC Mod 1000000000 ) Mod 20 ];

                 If ( S = 'PSC' ) Or ( S = 'FSC' )  Then
                   Begin
                     NameIras ( CObject.NRecC, S2 ) ;
                     If ( S = 'PSC' )  Then
                       If ( Length ( S2 ) > 11 )  Then
                         Begin
                           SVar := Copy ( S2, 12, 2 ) ;
                           SVar := 'Var ' + SVar + '%' ;
                         End ;
                     S2 := Copy ( S2, 1, 11 ) ;
                     S := S + ' ' + S2 ;
                   End ;


                 If ( S = 'TMSS' )  Then
                   Begin
                     NameIras ( CObject.NRecC, S2 ) ;
                     S2 := Copy ( S2, 1, 6 ) ;
                     S := S + ' ' + S2 ;
                   End ;


                 If ( S = 'RAFGL' )  Then
                   Begin
                     NameIras ( CObject.NRecC, S2 ) ;
                     S2 := Copy ( S2, 1, 5 ) ;
                     S := S + '  ' + S2 ;
                   End ;


                 If ( NRecC Div 1000000000 = 1 ) Then
                   Begin  { Iras  Marking }
                     NmS := Date + NumbMarkingBegin ;
                     Str ( Abs ( NmS ) : 8 , s ) ;
                   End ;  { Iras  Marking }

                 If ( SVar <> '' )  Then
                   PutS ( mv_w.wnd, true, bc, fc, centertext, centertext, SVar ) ;

               End ;



             While (     ( Length ( S ) > 0 )
                     And ( S [ 1 ] = ' '    )  )  Do
               Delete ( S, 1, 1 ) ;



             If ( SClass <> CatDm )  Then
               PutS ( Opt_w.wnd , true, bc, fc, centertext, centertext, s );





         End ; { HÆ¨•p + ä´†··®‰®™†Ê®Ô Æ°Í•™‚† + N Æ°Í•™‚Æ¢ ¢ Æ·p•§≠•≠®® }


                    { ëØ•™‚p }
                    { ‹‹‹‹‹‹ }

       If (    ( Sclass = CatPpm       )
            Or ( Sclass = CatSao       )
            Or ( Sclass = CatBs        )
            Or ( Sclass = CatHd        )
            Or (     ( Sclass = CatTyc )
                 And ( B_Tyc_2_Add     ) )
            Or (     ( Sclass = CatHip )
                 And ( B_Hip_Add       ) )
            Or ( Sclass = CatGcvs      )
            Or ( Sclass = CatNltt      )
                                         )  Then
         Begin

             S := '' ;

             If ( ( Sp Mod 100 ) div 10 + 1 ) < 8  Then
               Begin

                 S := SpectraName [ ( Sp Mod 100 ) div 10 + 1 ];

                 If ( Sp Mod 100 ) div 10 <> 7  Then
                   Begin
                     Str ( Sp mod 10:1,t);
                     S := S + t ;
                   End;

               End ;



             If (     ( SClass = CatHip )
                  And ( B_Hip_ADD       ) )  Then
               Begin
                 S := HipAddRecord.Spectr ;
                 While (     ( Length ( S ) > 0 )
                         And ( S [ Length ( S ) ] = ' ')  ) Do
                   Delete ( S, Length ( S ), 1 ) ;
               End ;


             If ( SClass = CatGcvs )  Then
               S := GcvsRecord.SpStr ;


             If (     ( SClass = CatTyc )
                  And ( B_Tyc_2         )  )  Then
               Begin

                 S := '' ;

                 If ( B_Tyc_2_Add )  Then
                   Begin
                     If (     ( TycAddRecord.BT <> -32000 )
                          And ( TycAddRecord.VT <> -32000 ) )
                       Then
                         Begin
                           Str ( ( TycAddRecord.BT / C10000 -
                                   TycAddRecord.VT / C10000   ) : 6:3, S ) ;
                           R := Sqrt (   Sqr ( TycAddRecord.MqeBT / C10000 )
                                       + Sqr ( TycAddRecord.MqeVT / C10000 ));
                           Str ( R : 5:3, t ) ;
                           Delete ( t, 1, 1 ) ;
                           If ( S [ 1 ] <> '-' )  Then
                             S [ 1 ] := '+' ;
                           S := 'B-V '+S+' Er' + t ;
                         End
                       Else
                         Begin
                           S := '' ;
                         End
                   End ;

               End ;



             If ( Sclass = CatSao )  Then
               Begin
                 S :=     ' ' + SaoRecord.SpStr ;
                 If ( SaoRecord.DmStr <> '             ' )  Then
                   S := S + ' ' + SaoRecord.DmStr ;
               End ;


             If ( Sclass = CatHd )  Then
               Begin
                  If ( Hde )
                    Then  S := HdeRecord.Sp
                    Else  S := HdRecord.Sp ;
               End ;


             If ( SClass = CatNltt )  Then
               S := NlttRecord.Sp ;

             PutS(sp_w.wnd,true,bc,fc,centertext,centertext,s);


         End ; { ëØ•™‚p }



         { à¨Ô ä†‚†´Æ£† ® ëÆ°·‚¢•≠≠Î• Ñ¢®¶•≠®Ô }
         { ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ }

       Case Sclass Of


        CatHip  :
          Begin
            If ( HipRecord.NSerInFile < 0 )
              Then  S := 'HIP- '
              Else  S := 'HIP  '     ;
            If ( B_Hip_NoCrd )  Then
              S := S + '  Coord: Inp. Cat.' ;
            If ( PmExist )  Then
              Begin
                S := S + 'Pm'+ chr ( 245 ) + ':' ;
                Str ( PmRaArcSec   : 7 : 3 , t ) ;
                S := S + t ;
                Str ( PmDeclArcSec : 7 : 3 , t ) ;
                S := S + t ;
              End ;
          End ; { HIP }



        CatTyc  :
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
                    S := 'Tc2 ' ;
                    {
                    S := 'Tyc2 ' ;
                    }
                End ;

            If ( PmExist )  Then
              Begin
                If ( B_Tyc_2_Add )
                  Then
                    Begin { é·‚†¢®´ 0.001, ‚.™. ¨†´Æ ¨•·‚† }
                      S := S + 'Pm'+ chr ( 245 ) + ':' ;
                      Str ( PmRaArcSec   : 8 : 4 , t ) ;
                      S := S + t ;
                      Str ( PmDeclArcSec : 8 : 4 , t ) ;
                      S := S + t ;
                    End
                  Else
                    Begin
                      S := S + 'Pm'+ chr ( 245 ) + ':' ;
                      Str ( PmRaArcSec   : 7 : 3 , t ) ;
                      S := S + t ;
                      Str ( PmDeclArcSec : 7 : 3 , t ) ;
                      S := S + t ;
                    End ;
              End ;

          End ; { Tyc }



        CatPPM  :
          Begin
            If ( ( SP Div 100 ) Mod 2 = 1 )
              Then  S := 'PPM- '
              Else  S := 'PPM  '     ;
            If ( PmExist )  Then
              Begin
                S := S + 'Pm'+ chr ( 245 ) + ':' ;
                Str ( PmRaArcSec   : 7 : 3 , t ) ;
                S := S + t ;
                Str ( PmDeclArcSec : 7 : 3 , t ) ;
                S := S + t ;
              End ;
          End ; { PPM }



        CatSao  :
          Begin
            S := 'Sao  ' ;
            If ( PmExist )  Then
              Begin
                S := S + 'Pm'+ chr ( 245 ) + ':' ;
                Str ( PmRaArcSec   : 7 : 3 , t ) ;
                S := S + t ;
                Str ( PmDeclArcSec : 7 : 3 , t ) ;
                S := S + t ;
              End ;
          End ; { PPM }



        CatNpm  :
         If ( PmExist )  Then
          Begin
            S := 'Pm'+ chr ( 245 ) + ': ' ;
            Str ( PmRaArcSec   : 8 : 4 , t ) ;
            While ( t [ 1 ] = ' ' )  Do
              Delete ( t, 1, 1 ) ;
            If ( t [ 1 ] <> '-' )  Then
              t := '+' + t ;
            S := S + t ;
            Str ( PmDeclArcSec : 8 : 4 , t ) ;
            While ( t [ 1 ] = ' ' )  Do
              Delete ( t, 1, 1 ) ;
            If ( t [ 1 ] <> '-' )  Then
              t := '+' + t ;
            S := S + ' ' + t ;
          End ; { Npm }


        CatBs   :
          Begin
            S := 'Bs '     ;
            If ( PmExist )  Then
              Begin
                S := S + 'Pm'+ chr ( 245 ) + ':' ;
                Str ( BsRecord.MuRa  / 0.6 / 1000000000.0 * SekRad : 7:3, t);
                S := S + t ;
                Str ( BsRecord.MuDec / 0.6 / 1000000000.0 * SekRad : 7:3, t);
                S := S + t ;
              End ;
          End ; { Bs }


        CatHd   :
          Begin
            If Not ( HdE )
              Then
                Begin

                  S  := 'Hd : ' ;
                  S  := S + HdRecord.Dm ;

                  RI := 0 ;
                  If ( HdRecord.Mv / C1000 ) > 19.9 Then
                    RI := Round ( HdRecord.Mv / C1000 ) ;
                  If ( HdRecord.Mv / C1000 ) > 19.9 Then
                    RI := Round ( HdRecord.Mv / C1000 ) ;
                  If ( RI > 0 )  Then
                    Begin
                      Case RI Of
                        20 : S := S + ' Neb' ;
                        30 : S := S + ' Var' ;
                        40 : S := S + ' Nov' ;
                        50 : S := S + ' Cl ' ;
                      End ;
                    End ;

                End
              Else
                Begin

                  S := 'HdE ' ;

                  If ( HdERecord.MuRa < 32000 )
                    Then
                      Begin
                        If ( PmExist )  Then
                          Begin
                            S := S + 'Pm'+ chr ( 245 ) + ':' ;
                            Str ( HdERecord.MuRa  / C10000 : 7:3, t);
                            S := S + t ;
                            Str ( HdERecord.MuDec / C10000 : 7:3, t);
                            S := S + t ;
                          End ;
                      End
                    Else
                      Begin
                        S := S + 'Ep = ' ;
                        Str ( HdERecord.MuDec / C100 + 1900 : 6:1, t) ;
                        S := S + t ;
                      End ;

                End ;
          End ;


        CatNLTT :
          Begin
            S := 'Lt '     ;
            If ( PmExist )  Then
              Begin
                S := S + 'Pm'+ chr ( 245 ) + ':' ;
                Str ( PmRaArcSec   : 7 : 3 , t ) ;
                S := S + t ;
                Str ( PmDeclArcSec : 7 : 3 , t ) ;
                S := S + t ;
              End ;
          End ;  { Nltt }


        CatImp  :
         Begin

            S := 'Imp '  ;
            Str ( NGrImport  : 5 , t ) ;
            S := S + t + ' ';
            Str ( NRecC Mod 1000000000  : 4 , t ) ;
            S := S + t ;

            NRecObjectOutFile := NRecC Mod 1000000000 ;
            (*
                   { Find Number Imp }
                   { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
            Seek  ( OutStarFile , NRecObjectOutFile - 1 ) ;
            Read  ( OutStarFile , ObjectString          ) ;

            For NDel := 1 To 7  Do
              Begin
                While (  ObjectString[1] = ' ' )  Do
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

            S := S + '(' + ObjectS + ')' ;
            *)

            If (    ( B_ObjOut )
                 Or ( B_Export )  )  Then
              Begin
                If ( NRecObjectOutFileOld <> NRecObjectOutFile )  Then
                  Begin
                    NRecObjectOutFileOld := NRecObjectOutFile    ;
                    Seek  ( OutDetFile , NRecObjectOutFile - 1 ) ;
                    Read  ( OutDetFile , OutDetStringOld       ) ;
                  End ;
              End ;

         End ; { CatImp }



        CatGcvs :

         Begin

          (*
          N := GcvsRecord.Num ;

          n1 := N Div 10000;
          n2 := N - longint(n1) * 10000;

          If  ( N < 1000000)   Then

              Begin { éäèá }
                    { ƒƒƒƒ }

                If ( n2 <= 334 )
                  Then
                      S  := Argelan [ n2 ] + ' ' + AbbName [ n1 ]
                  Else
                    Begin
                      Str ( n2 :5, S );
                      S := S + ' ' + AbbName [ n1 ]  ;
                    End ;

                S := 'GCVS  ' + S ;

              End   { éäèá }
                    { ƒƒƒƒ }

            Else

              Begin { äáè }
                    { ƒƒƒ }

                      n1 := N Div 1000000 ;
                      n2 := N - longint(n1) * 1000000 ;

                      Str ( n2 :6, S );
                      S := 'NSV  ' + S ;

              End ;
          *)

          S :=  GcvsRecord.NameStr ;
          Delete ( S, 14, 1 ) ;

         End ;



        CatCdc :

           Begin

             If ( B_Cdc_Cat )
               Then
                 Begin

                   If ( Sp >= 100 )
                     Then
                       Begin
                         S := 'AC+ ' ;
                         Sp := Sp - 100 ;
                       End
                     Else
                         S := 'AC  ' ;

                   If ( CdcRecord.MuRa <> 32123 )
                     Then
                       Begin
                         If ( PmExist )  Then
                           Begin
                             S := S + 'Pm'+ chr ( 245 ) + ':' ;
                             Str ( PmRaArcSec   : 7 : 3 , t ) ;
                             S := S + t ;
                             Str ( PmDeclArcSec : 7 : 3 , t ) ;
                             S := S + t ;
                           End ;
                       End
                     Else
                       Begin { Ep AK }
                         Str ( CdcRecord.MUDEC / C1000 + 1900 : 7 : 2 , t ) ;
                         S := S + '  Ep = ' + t ;
                       End ;

                 End
               Else
                 Begin

                   S := 'AC (centr) ' ;

                   Year := NRecC Mod 1000 ;

                   If ( Year > 0 )  Then
                     Begin  { Date Exist }

                       Month := Year Mod 13 ;
                       Year  := Year Div 13 + 1890 ;

                       Str ( Year : 6 , t ) ;
                       S := S + ' ' + t + ' ' ;

                       If ( ( Month > 12 ) Or ( Month < 1 ) )
                          Then  Month := 13 ;

                       S := S + MonthName [ Month ] ;

                     End ; { Date Exist }

                 End ;

           End ;



        CatCdcMoz :

           Begin

                 NZagol     := NRecC Mod 1000 ;
                 AkZagolRec := PlateZagol ^ [ NZagol ] ;

                 Str ( AkZagolRec.DcG : 4 , t ) ;
                 If ( t[3] = ' ' )  Then t[3] := '0' ;
                 If ( t[3] = '-' )  Then
                   Begin
                     t[3] := '0' ;
                     t[2] := '-' ;
                   End ;
                 If ( t[2] = ' ' )  Then t[2] := '+' ;
                 S := 'AC' + t + ' ' ;

                 Str ( AkZagolRec.RaH : 2 , t ) ;
                 If ( t[1] = ' ' )  Then  t[1] := '0' ;
                 S := S + t ;

                 Str ( AkZagolRec.RaM : 2 , t ) ;
                 If ( t[1] = ' ' )  Then  t[1] := '0' ;
                 S := S + '.' + t ;


                 Year  := AkZagolRec.Year ;
                 Month := AkZagolRec.Mon  ;

                 Str ( Year : 5 , t ) ;
                 S := S + ' ' + t + ' ' ;

                 S := S + MonthName [ Month ] ;

           End ;



        CatA20  :

           Begin

             S := 'A2.0' ;

             NmS := NRecC Mod 1000000000 ;

             If ( ( NmS Div 10000000 ) = 1 )  Then
               Begin
                 If ( Sp Div 10 = 8 ) Then
                   S :=     '( GSC ? )' ;
               End ;


             If ( Nf <> 0 )   Then
               Begin

                 Str ( Nf : 3, S1 ) ;
                 While (     ( Length ( S1 ) > 0 )
                         And ( S1 [ 1 ] = ' '    ) )  Do
                   Delete ( S1, 1, 1 ) ;

                 If ( Sp Mod 10 ) And 2 = 2
                   Then  t := 's'
                   Else  t := 'n' ;

                 S := S + '  NPl = ' + t + S1 ;

               End ;

           End ;


        CatGsc  :

           Begin

             S := ' ';

             Case  Sp Mod 10  Of
                     0 : S := 'Star    ' + S ;
                     1 : S := 'Galaxy  ' + S ;
                     2 : S := 'Blend   ' + S ;
                     3 : S := 'Non Star' + S ;
                     4 : S := '        ' + S ;
                     5 : S := 'Artifact' + S ;
                     6 : S := 'Star  Ver 1.1' + S ;
                     9 : S := 'Non Star  Ver 1.1' + S ;
             End ; { Case Sp }

             S := 'Gsc  ' + S ;


             If ( GscAddExist )  Then
               Begin

                If ( SP Mod 10 >= 6 )
                  Then
                    S := S + ' V 1.1 '
                  Else
                    Begin
                      If ( NRecC Div 1000000000 <> 1 )
                        Then
                          Begin
                            RR := Date / C10000 + 1950.0 ;
                            If ( RR >= 1951.486 )
                              Then
                                Begin
                                  Str ( RR : 10:3, t ) ;
                                  S := S + t ;
                                End
                              Else
                                  S := S + '          ' ;
                          End
                        Else
                          S := S + '          ' ;
                    End ;

               End ;


           End ;




        CatOthers :

           Begin
             S := 'Others' ;
           End ;



       End ; { à¨Ô ä†‚†´Æ£† ® ëÆ°·‚¢•≠≠Î• Ñ¢®¶•≠®Ô }


     PutS ( clas_w.wnd, true, bc, fc, centertext, centertext, S ) ;




     If (     (    ( B_ObjOut )
                Or ( B_Export )              )
          And ( NRecObjectOutFile <>   0     )
          And ( Sclass            <> CatImp  )  )  Then

       Begin

         OutDetString := OutDetStringOld ;

         ObjectOut ( Item, Sclass, False, NDm, OutDetString ) ;

         Seek  ( OutDetFile , NRecObjectOutFile - 1 ) ;
         Write ( OutDetFile , OutDetString          ) ;

         NRecObjectOutFileOld := 65000 ;

       End ;



     End ;  { With ObjectPtr }


   End;  { Opt }




              {  ëØ„‚≠®™  }

  ClassId_Sat :    PlInfo ( Item, Class, Point ) ;


              {  è´†≠•‚†  }

  ClassId_Pln :    PlInfo ( Item, Class, Point ) ;



             { H•‚ é°Í•™‚† }

  ClassId_Non :    PlInfo ( Item, Class, Point ) ;



 End ; { Case }




     { éèêÖÑÖãÖHàÖ ëéáÇÖáÑàü }
     { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

 ScToId ( Point.x, Point.y, NoX, NoY ) ;

 If ( OptRd )
   Then
     Begin
       IdToEq1 ( NoX, NoY, ORa, ODc ) ;
     End
   Else
     Begin
       {
       IdToEq ( NoX,NoY,NPolFix,SPozNp,CPozNp,ORa,ODc );
       }
       IdToEq1 ( NoX, NoY, ORa, ODc ) ;
       PreNew ( JDateFld, JDOut, ORa, ODc ) ;
     End ;


 Identify ( JDATEFld, ORa, ODc, S ) ;

 If ( SClass = CatSao )  Then
   Begin
     If ( Copy ( SaoRecord.HdStr, 1, 6 ) <> '      ' )  Then
       S := S + ' HD ' + Copy ( SaoRecord.HdStr, 1, 6 )
              + ' '    + Copy ( SaoRecord.HdStr, 7, 1 ) + ' ' ;
   End ;

 PutS ( cns_w.wnd, true, bc, fc, centertext, centertext, s ) ;


 FileMode := 2 ;


End;

End.
