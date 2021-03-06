
        Program  PeredPar ;


 Type
{����}



ParamTypeOld = Record


                  {  H�砫��  ������ }
                  { ������������������ }

                 TimeYear     : LongInt ;
                 TimeMon      : Integer ;
                 TimeDay      : Integer ;

                 TimeH        : Integer ;
                 TimeMin      : Integer ;
                 TimeSek      : Double  ;



                   { ��� �� �p����� }
                   { �������������� }

                 StepTime      : Double  ;



               { ���� ��砫��� ������⮢ }
               { ������������������������� }

                 InputYear     : LongInt ;
                 InputMon      : Integer ;
                 InputDay      : Integer ;

                 InputH        : Integer ;
                 InputMin      : Integer ;
                 InputSek      : Double  ;


                  { ���� p�����⮢ }
                  { ����������������� }

                 EpOut         : Byte    ; { 1 - EpRez, 2 - JDate }

                 OutYear       : LongInt ;
                 OutMon        : Integer ;
                 OutDay        : Integer ;

                 OutH          : Integer ;
                 OutMin        : Integer ;
                 OutSek        : Double  ;


                  { ��������� ⥫�᪮�� }
                  { ������������������� }


                 NPl0          : Integer ;

                 Earth_Space   : Byte    ;  { 1 - Ear,  2 - Space }


                        { ����� }
                        { ����� }

                 LongSig       : Char    ;
                 LongG         : Byte    ;
                 LongM         : Byte    ;
                 LongS         : Single  ;

                 LatSig        : Char    ;
                 LatG          : Byte    ;
                 LatM          : Byte    ;
                 LatS          : Single  ;

                 Alt           : Double  ;



                      { ��ᬮ� }
                      { ������ }

                 ElemFile      : Byte    ; { 1 - �p�����, 2 - �������� }
                                           { 4 - ����᪮� �� ���⭨��
                                                 H���p = ISat          }
                 HAp   ,
                 HPer  ,
                 ISat  ,
                 OmG   ,
                 OmL   ,
                 ArgLat        : Double  ;



              { ��p���p��⨪� ���� �p���� }
              { �������������������������� }

                 FldX ,
                 FldY ,
                 RRX  ,
                 RRY            : Double  ;

                 NPolFix        : Byte    ;

                 XOrient,
                 YOrient        : Integer ;

                 RSun,
                 RMon           : Double  ;


                    { ��⮯p������ }
                    { ������������ }

                 MvMax          : Single  ;

                 Period_X_Min ,
                 Period_Y_Min ,
                 Pixel_X_Min  ,
                 Pixel_Y_Min    : Single  ;
                 N_Pixel_X    ,
                 N_Pixel_Y      : Word    ;


                { �p������ ����᪮� �� }
                { ������������������������� }


                 OptAxOrient   : Byte    ;  { 1 - Eq  , 2 - Gor ,
                                              3 - Orb , 4 - Obj  }


                { �����p����� ���p������ }
                { ������������������������� }

                 RaOptH         : Integer ;
                 RaOptM         : Byte    ;
                 RaOptS         : Single  ;

                 DeclOptSig     : Char    ;
                 DeclOptG       : Byte    ;
                 DeclOptM       : Byte    ;
                 DeclOptS       : Single  ;


                { ��p����⠫�� ���p������ }
                { ������������������������� }

                 ASig           : Char    ;
                 AG             : Byte    ;
                 AM             : Byte    ;
                 AS             : Single  ;

                 HOptType       : Byte    ; { 1 - ��p��,  2 - ���� � ��p�� }

                 HSig           : Char    ;
                 HG             : Byte    ;
                 HM             : Byte    ;
                 HS             : Single  ;



                { �⭮�⥫쭮 ����p� ᪮p��� }
                { ����������������������������� }

                 Tangag,
                 Ryskanie       : Double  ;


                     { �� ��ꥪ�� }
                     { ���������� }

                 NObj           : Word    ;  { 1 - Plan, 2 - Sat }

                 NPlan          : Word    ;
                 NSat           : Word    ;



                    { ������ p����� }
                    { ������������� }


                 EarthIzo      : Byte    ;
                 Corr_Fot_Sys  : Byte    ; { 0 - H� �������, 1 - ������� }
                 OutFOV        : Byte    ;
                 Object_Tracks : Byte    ;
                 DetCdc        : Byte    ;
                 ImportStar    : Byte    ; { 0 - H� �������         }
                 DetImp        : Byte    ; { 0 - H� �⮦�,  1 - �� }
                 StopNoDet     : Byte    ; { 0 - H� Stop, 1 - Stop �p� ���� }
                 PzsInFOV      : Byte    ;


                { H���p  ���. �p㯯� ���. }
                { - - - - - - - - - - - - }

{
                 NGrImportBeg  : Integer ;
}
                 NGrImportBeg  : LongInt ;
                 DMvDet        : Single  ;


                  { �ᯮ��㥬� ��⠫��� }
                  { ��������������������� }

                 PPM         ,
                 Bs          ,
                 Hd          ,
                 Okpz        ,
                 Cdc         ,
                 Gsc         ,
                 Iras        ,
                 Satellits      : Byte   ;


                { ����� �����  䠩��� }
                { - - - - - - - - - - }

                 SatellitsDir   ,
                 ImportStarDir  ,
                 PzsDir         ,
                 FotSysDir      :  String [ 12 ] ;



                { �������  �⮦���⢫���� }
                { - - - - - - - - - - - - }

                 RoPPMDet   ,
                 RoBsDet    ,
                 RoHdDet    ,
                 RoOkpzDet  ,
                 RoCdcDet   ,
                 RoGscDet   ,
                 RoIrasDet  ,
                 RDetImp     : Single  ;


               End ;




ParamTypeNew = Record


                  {  H�砫��  ������ }
                  { ������������������ }

                 TimeYear     : LongInt ;
                 TimeMon      : Integer ;
                 TimeDay      : Integer ;

                 TimeH        : Integer ;
                 TimeMin      : Integer ;
                 TimeSek      : Double  ;



                   { ��� �� �p����� }
                   { �������������� }

                 StepTime      : Double  ;



               { ���� ��砫��� ������⮢ }
               { ������������������������� }

                 InputYear     : LongInt ;
                 InputMon      : Integer ;
                 InputDay      : Integer ;

                 InputH        : Integer ;
                 InputMin      : Integer ;
                 InputSek      : Double  ;


                  { ���� p�����⮢ }
                  { ����������������� }

                 EpOut         : Byte    ; { 1 - EpRez, 2 - JDate }

                 OutYear       : LongInt ;
                 OutMon        : Integer ;
                 OutDay        : Integer ;

                 OutH          : Integer ;
                 OutMin        : Integer ;
                 OutSek        : Double  ;


                  { ��������� ⥫�᪮�� }
                  { ������������������� }


                 NPl0          : Integer ;

                 Earth_Space   : Byte    ;  { 1 - Ear,  2 - Space }


                        { ����� }
                        { ����� }

                 LongSig       : Char    ;
                 LongG         : Byte    ;
                 LongM         : Byte    ;
                 LongS         : Single  ;

                 LatSig        : Char    ;
                 LatG          : Byte    ;
                 LatM          : Byte    ;
                 LatS          : Single  ;

                 Alt           : Double  ;



                      { ��ᬮ� }
                      { ������ }

                 ElemFile      : Byte    ; { 1 - �p�����, 2 - �������� }
                                           { 4 - ����᪮� �� ���⭨��
                                                 H���p = ISat          }
                 HAp   ,
                 HPer  ,
                 ISat  ,
                 OmG   ,
                 OmL   ,
                 ArgLat        : Double  ;



              { ��p���p��⨪� ���� �p���� }
              { �������������������������� }

                 FldX ,
                 FldY ,
                 RRX  ,
                 RRY            : Double  ;

                 NPolFix        : Byte    ;

                 XOrient,
                 YOrient        : Integer ;

                 RSun,
                 RMon           : Double  ;


                    { ��⮯p������ }
                    { ������������ }

                 MvMax          : Single  ;

                 Period_X_Min ,
                 Period_Y_Min ,
                 Pixel_X_Min  ,
                 Pixel_Y_Min    : Single  ;
                 N_Pixel_X    ,
                 N_Pixel_Y      : Word    ;


                { �p������ ����᪮� �� }
                { ������������������������� }


                 OptAxOrient   : Byte    ;  { 1 - Eq  , 2 - Gor ,
                                              3 - Orb , 4 - Obj  }


                { �����p����� ���p������ }
                { ������������������������� }

                 RaOptH         : Integer ;
                 RaOptM         : Byte    ;
                 RaOptS         : Single  ;

                 DeclOptSig     : Char    ;
                 DeclOptG       : Byte    ;
                 DeclOptM       : Byte    ;
                 DeclOptS       : Single  ;


                { ��p����⠫�� ���p������ }
                { ������������������������� }

                 ASig           : Char    ;
                 AG             : Byte    ;
                 AM             : Byte    ;
                 AS             : Single  ;

                 HOptType       : Byte    ; { 1 - ��p��,  2 - ���� � ��p�� }

                 HSig           : Char    ;
                 HG             : Byte    ;
                 HM             : Byte    ;
                 HS             : Single  ;



                { �⭮�⥫쭮 ����p� ᪮p��� }
                { ����������������������������� }

                 Tangag,
                 Ryskanie       : Double  ;


                     { �� ��ꥪ�� }
                     { ���������� }

                 NObj           : Word    ;  { 1 - Plan, 2 - Sat }

                 NPlan          : Word    ;
                 NSat           : Word    ;



                    { ������ p����� }
                    { ������������� }


                 EarthIzo      : Byte    ;
                 Corr_Fot_Sys  : Byte    ; { 0 - H� �������, 1 - ������� }
                 OutFOV        : Byte    ;
                 Object_Tracks : Byte    ;
                 DetCdc        : Byte    ;
                 ImportStar    : Byte    ; { 0 - H� �������         }
                 DetImp        : Byte    ; { 0 - H� �⮦�,  1 - �� }
                 StopNoDet     : Byte    ; { 0 - H� Stop, 1 - Stop �p� ���� }
                 PzsInFOV      : Byte    ;


                { H���p  ���. �p㯯� ���. }
                { - - - - - - - - - - - - }

{
                 NGrImportBeg  : Integer ;
}
                 NGrImportBeg  : LongInt ;
                 DMvDet        : Single  ;


                  { �ᯮ��㥬� ��⠫��� }
                  { ��������������������� }

                 PPM         ,
                 Bs          ,
                 Hd          ,
                 Okpz        ,
                 Cdc         ,
                 Gsc         ,
                 Iras        ,
                 Dm          ,
                 Satellits      : Byte   ;


                { ����� �����  䠩��� }
                { - - - - - - - - - - }

                 SatellitsDir   ,
                 ImportStarDir  ,
                 PzsDir         ,
                 FotSysDir      :  String [ 12 ] ;



                { �������  �⮦���⢫���� }
                { - - - - - - - - - - - - }

                 RoPPMDet   ,
                 RoBsDet    ,
                 RoHdDet    ,
                 RoOkpzDet  ,
                 RoCdcDet   ,
                 RoGscDet   ,
                 RoIrasDet  ,
                 RoDmDet    ,
                 RDetImp     : Single  ;


               End ;



 Var
{���}

         ParamOld : ParamTypeOld ;
         Param    : ParamTypeNew ;

         UserParOld : File Of ParamTypeOld ;
         UserParNew : File Of ParamTypeNew ;

         UserRecOld : ParamTypeOld ;
         UserRecNew : ParamTypeNew ;


Begin

  Assign  ( UserParOld , 'User.Par'  ) ;
  Reset   ( UserParOld               ) ;

  Assign  ( UserParNew , 'UserN.Par' ) ;
  ReWrite ( UserParNew               ) ;


  While ( Not Eof ( UserParOld ) )  Do
    Begin

      Read ( UserParOld , UserRecOld ) ;


      UserRecNew.TimeYear      :=   UserRecOld.TimeYear     ;
      UserRecNew.TimeMon       :=   UserRecOld.TimeMon      ;
      UserRecNew.TimeDay       :=   UserRecOld.TimeDay      ;

      UserRecNew.TimeH         :=   UserRecOld.TimeH        ;
      UserRecNew.TimeMin       :=   UserRecOld.TimeMin      ;
      UserRecNew.TimeSek       :=   UserRecOld.TimeSek      ;

      UserRecNew.StepTime      :=   UserRecOld.StepTime     ;

      UserRecNew.InputYear     :=   UserRecOld.InputYear    ;
      UserRecNew.InputMon      :=   UserRecOld.InputMon     ;
      UserRecNew.InputDay      :=   UserRecOld.InputDay     ;

      UserRecNew.InputH        :=   UserRecOld.InputH       ;
      UserRecNew.InputMin      :=   UserRecOld.InputMin     ;
      UserRecNew.InputSek      :=   UserRecOld.InputSek     ;

      UserRecNew.EpOut         :=   UserRecOld.EpOut        ;

      UserRecNew.OutYear       :=   UserRecOld.OutYear      ;
      UserRecNew.OutMon        :=   UserRecOld.OutMon       ;
      UserRecNew.OutDay        :=   UserRecOld.OutDay       ;

      UserRecNew.OutH          :=   UserRecOld.OutH         ;
      UserRecNew.OutMin        :=   UserRecOld.OutMin       ;
      UserRecNew.OutSek        :=   UserRecOld.OutSek       ;


      UserRecNew.NPl0          :=   UserRecOld.NPl0         ;

      UserRecNew.Earth_Space   :=   UserRecOld.Earth_Space  ;


      UserRecNew.LongSig       :=   UserRecOld.LongSig      ;
      UserRecNew.LongG         :=   UserRecOld.LongG        ;
      UserRecNew.LongM         :=   UserRecOld.LongM        ;
      UserRecNew.LongS         :=   UserRecOld.LongS        ;

      UserRecNew.LatSig        :=   UserRecOld.LatSig       ;
      UserRecNew.LatG          :=   UserRecOld.LatG         ;
      UserRecNew.LatM          :=   UserRecOld.LatM         ;
      UserRecNew.LatS          :=   UserRecOld.LatS         ;

      UserRecNew.Alt           :=   UserRecOld.Alt          ;


      UserRecNew.ElemFile      :=   UserRecOld.ElemFile     ;

      UserRecNew.HAp           :=   UserRecOld.HAp          ;
      UserRecNew.HPer          :=   UserRecOld.HPer         ;
      UserRecNew.ISat          :=   UserRecOld.ISat         ;
      UserRecNew.OmG           :=   UserRecOld.OmG          ;
      UserRecNew.OmL           :=   UserRecOld.OmL          ;
      UserRecNew.ArgLat        :=   UserRecOld.ArgLat       ;


      UserRecNew.FldX          :=   UserRecOld.FldX         ;
      UserRecNew.FldY          :=   UserRecOld.FldY         ;
      UserRecNew.RRX           :=   UserRecOld.RRX          ;
      UserRecNew.RRY           :=   UserRecOld.RRY          ;

      UserRecNew.NPolFix       :=   UserRecOld.NPolFix      ;

      UserRecNew.XOrient       :=   UserRecOld.XOrient      ;
      UserRecNew.YOrient       :=   UserRecOld.YOrient      ;

      UserRecNew.RSun          :=   UserRecOld.RSun         ;
      UserRecNew.RMon          :=   UserRecOld.RMon         ;

      UserRecNew.MvMax         :=   UserRecOld.MvMax        ;

      UserRecNew.Period_X_Min  :=   UserRecOld.Period_X_Min ;
      UserRecNew.Period_Y_Min  :=   UserRecOld.Period_Y_Min ;
      UserRecNew.Pixel_X_Min   :=   UserRecOld.Pixel_X_Min  ;
      UserRecNew.Pixel_Y_Min   :=   UserRecOld.Pixel_Y_Min  ;
      UserRecNew.N_Pixel_X     :=   UserRecOld.N_Pixel_X    ;
      UserRecNew.N_Pixel_Y     :=   UserRecOld.N_Pixel_Y    ;


      UserRecNew.OptAxOrient   :=   UserRecOld.OptAxOrient  ;

      UserRecNew.RaOptH        :=   UserRecOld.RaOptH       ;
      UserRecNew.RaOptM        :=   UserRecOld.RaOptM       ;
      UserRecNew.RaOptS        :=   UserRecOld.RaOptS       ;

      UserRecNew.DeclOptSig    :=   UserRecOld.DeclOptSig   ;
      UserRecNew.DeclOptG      :=   UserRecOld.DeclOptG     ;
      UserRecNew.DeclOptM      :=   UserRecOld.DeclOptM     ;
      UserRecNew.DeclOptS      :=   UserRecOld.DeclOptS     ;


      UserRecNew.ASig          :=   UserRecOld.ASig         ;
      UserRecNew.AG            :=   UserRecOld.AG           ;
      UserRecNew.AM            :=   UserRecOld.AM           ;
      UserRecNew.AS            :=   UserRecOld.AS           ;

      UserRecNew.HOptType      :=   UserRecOld.HOptType     ;

      UserRecNew.HSig          :=   UserRecOld.HSig         ;
      UserRecNew.HG            :=   UserRecOld.HG           ;
      UserRecNew.HM            :=   UserRecOld.HM           ;
      UserRecNew.HS            :=   UserRecOld.HS           ;

      UserRecNew.Tangag        :=   UserRecOld.Tangag       ;
      UserRecNew.Ryskanie      :=   UserRecOld.Ryskanie     ;


      UserRecNew.NObj          :=   UserRecOld.NObj         ;

      UserRecNew.NPlan         :=   UserRecOld.NPlan        ;
      UserRecNew.NSat          :=   UserRecOld.NSat         ;


      UserRecNew.EarthIzo      :=   UserRecOld.EarthIzo     ;
      UserRecNew.Corr_Fot_Sys  :=   UserRecOld.Corr_Fot_Sys ;
      UserRecNew.OutFOV        :=   UserRecOld.OutFOV       ;
      UserRecNew.Object_Tracks :=   UserRecOld.Object_Tracks;
      UserRecNew.DetCdc        :=   UserRecOld.DetCdc       ;
      UserRecNew.ImportStar    :=   UserRecOld.ImportStar   ;
      UserRecNew.DetImp        :=   UserRecOld.DetImp       ;
      UserRecNew.StopNoDet     :=   UserRecOld.StopNoDet    ;
      UserRecNew.PzsInFOV      :=   UserRecOld.PzsInFOV     ;


      UserRecNew.NGrImportBeg  :=   UserRecOld.NGrImportBeg ;
      UserRecNew.DMvDet        :=   UserRecOld.DMvDet       ;


      UserRecNew.PPM           :=   UserRecOld.PPM          ;
      UserRecNew.Bs            :=   UserRecOld.Bs           ;
      UserRecNew.Hd            :=   UserRecOld.Hd           ;
      UserRecNew.Okpz          :=   UserRecOld.Okpz         ;
      UserRecNew.Cdc           :=   UserRecOld.Cdc          ;
      UserRecNew.Gsc           :=   UserRecOld.Gsc          ;
      UserRecNew.Iras          :=   UserRecOld.Iras         ;
      UserRecNew.Dm            :=   0                       ;
      UserRecNew.Satellits     :=   UserRecOld.Satellits    ;

      UserRecNew.SatellitsDir  :=   UserRecOld.SatellitsDir ;
      UserRecNew.ImportStarDir :=   UserRecOld.ImportStarDir;
      UserRecNew.PzsDir        :=   UserRecOld.PzsDir       ;
      UserRecNew.FotSysDir     :=   UserRecOld.FotSysDir    ;


      UserRecNew.RoPPMDet      :=   UserRecOld.RoPPMDet     ;
      UserRecNew.RoBsDet       :=   UserRecOld.RoBsDet      ;
      UserRecNew.RoHdDet       :=   UserRecOld.RoHdDet      ;
      UserRecNew.RoOkpzDet     :=   UserRecOld.RoOkpzDet    ;
      UserRecNew.RoCdcDet      :=   UserRecOld.RoCdcDet     ;
      UserRecNew.RoGscDet      :=   UserRecOld.RoGscDet     ;
      UserRecNew.RoIrasDet     :=   UserRecOld.RoIrasDet    ;
      UserRecNew.RoDmDet       :=   90.0                    ;
      UserRecNew.RDetImp       :=   UserRecOld.RDetImp      ;


      Write ( UserParNew , UserRecNew ) ;

    End ;

  Close   ( UserParOld               ) ;
  Close   ( UserParNew               ) ;

  Erase   ( UserParOld               ) ;
  Rename  ( UserParNew , 'User.Par'  ) ;


End.