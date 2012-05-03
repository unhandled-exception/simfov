
{$O+,F+}

Unit PRdCrd ;

Interface


Procedure RdCrd ;


Implementation

Uses

   PInform, V_Catal, Graph, PVar  ;

Procedure RdCrd ;
  Begin

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
           Seek  ( CdcFile , ( NRecCrd Mod 1000000000 ) - 1 ) ;
           Read  ( CdcFile , CdcRecord ) ;
           If ( CdcRecord.MuRa <> 32123 )  Then
             Begin  { Есть  P.M. }
               PmRaArcSec   := CdcRecord.MuRa  / C10000 ;
               PmDeclArcSec := CdcRecord.MuDec / C10000 ;
               PmExist      := True                     ;
             End ;
         End ;


       If ( SClass = CatBs )  Then
         Begin

           FileMode := 0 ;

           Reset ( BsFile                                ) ;
           Seek  ( BsFile , ( NRecCrd Mod 1000000000 ) - 1 ) ;
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
           If ( SpCrd >= 100 )
             Then
               Begin
                 HdE := True ;
                 FileMode := 0 ;
                 ReSet ( HdeFile ) ;
                 Seek  ( HdEFile, ( NRecCrd Mod 1000000000 ) - 1 ) ;
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
                 Seek  ( HdFile, ( NRecCrd Mod 1000000000 ) - 1 )  ;
                 Read  ( HdFile, HdRecord  )                     ;
                 Close ( HdFile            )                     ;
                 HdE := False                                    ;
               End ;
         End ;  { CatHd }



       If ( Sclass = CatHip )  Then
         Begin
           FileMode := 0 ;
           Reset ( HipFile                                ) ;
           Seek  ( HipFile , ( NRecCrd Mod 1000000000 ) - 1 ) ;
           Read  ( HipFile , HipRecord                    ) ;
           Close ( HipFile                                ) ;
           PmRaArcSec   := HipRecord.PmRa   / C10000 ;
           PmDeclArcSec := HipRecord.PmDecl / C10000 ;
           PmExist      := True                      ;
           If ( B_HIP_Add )  Then
             Begin
               FileMode := 0 ;
               Reset ( HipAddFile ) ;
               Seek  ( HipAddFile , ( NRecCrd Mod 1000000000 ) - 1 ) ;
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
           Seek  ( TycFile , ( NRecCrd Mod 1000000000 ) - 1 ) ;
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
               Seek  ( TycAddFile , ( NRecCrd Mod 1000000000 ) - 1 ) ;
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
           Seek  ( PpmFile , ( NRecCrd Mod 1000000000 ) - 1 ) ;
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
           Seek  ( SaoFile , ( NRecCrd Mod 1000000000 ) - 1 ) ;
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
           Seek  ( NlttFile , ( NRecCrd Mod 1000000000 ) - 1 ) ;
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
           Seek  ( NpmFile , ( NRecCrd Mod 1000000000 ) - 1  ) ;
           Read  ( NpmFile , NpmRecord                     ) ;
           Close ( NpmFile                                 ) ;
           PmRaArcSec   := NpmRecord.MuRa   ;
           PmDeclArcSec := NpmRecord.MuDec  ;
           PmExist      := True             ;
         End ;



  End ;
End.