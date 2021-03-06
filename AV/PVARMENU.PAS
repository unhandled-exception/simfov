
Unit PVarMenu ;  { ��p������ ��� ������ � ��⥬�� ���� }
                 { ������������������������������������� }

Interface

 Type
{����}


   ParamType = Record



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
                 NSat           : Integer ;



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
                 Gcvs        ,
                 Cdc         ,
                 Gsc         ,
                 Iras        ,
                 Dm          ,
                 Satellits
                                : Byte   ;


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
                 RoGcvsDet  ,
                 RoCdcDet   ,
                 RoGscDet   ,
                 RoIrasDet  ,
                 RoDmDet    ,
                 RDetImp
                               : Single  ;


               End ;


 ParamDirCatType  = Record

                  { ��p���p�� ��⠫���� }
                  { �������������������� }

                 HipDir         ,
                 TycDir         ,
                 PPMDir         ,
                 BsDir          ,
                 HdDir          ,
                 GcvsDir        ,
                 CdcDir         ,
                 NpmDir         ,
                 NLttDir        ,
                 A20Dir         ,
                 GscDir         ,
                 DmDir          ,
                 IrasDir,
                 SatDir           :  String [ 79 ] ;

               End ;

 Var
{���}

         Param    : ParamType ;
         ParamDir : ParamDirCatType ;

Implementation
End.
