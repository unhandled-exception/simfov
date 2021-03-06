
{$O+,F+}

 Unit  InitVMn ;


        { ���樠������ ��p������� ���� ����� }
        { ����������������������������������� }



  InterFace

    Procedure  InitVarMenu ;

  Implementation

    Uses

         Dos, PVarMenu ;

    Var
         S : String [ 80 ] ;



    Procedure DelProb ;
   {�����������������}
 Begin

    While (     ( Length ( S ) > 0  )
            And ( S [ 1 ]      = ' ')  )  Do
      Delete ( S, 1, 1 ) ;

    If ( Pos ( ' ', S ) <> 0 )  Then
      S := Copy ( S, 1, Pos ( ' ', S ) - 1  ) ;

 End ;


    Procedure  InitVarMenu ;
   {����������������������}

 Var
     CatDirFile : Text ;

 Begin

   With  Param  Do

     Begin


 { � � � � � }
 { ��������� }

                  { H�����H��   ����H� }
                  { ������������������ }

                 TimeYear     :=       1950 ;
                 TimeMon      :=          1 ;
                 TimeDay      :=          1 ;

                 TimeH        :=          0 ;
                 TimeMin      :=          0 ;
                 TimeSek      :=       0.01 ;


               { ��� �� �p����� � ᥪ㭤�� }
               { ������������������������� }

                 StepTime      :=        0.01;


               { ����� ��砫��� ������⮢ }
               { ������������������������� }

                 InputYear     :=       1950 ;
                 InputMon      :=          1 ;
                 InputDay      :=          1 ;

                 InputH        :=          0 ;
                 InputMin      :=          0 ;
                 InputSek      :=        0.0 ;


                  { ����� p�����⮢  }
                  { �����������������  }

                 EpOut         :=          1 ;  {1 - EpRez, 2 - JDate}

                 OutYear       :=       1950 ;
                 OutMon        :=          1 ;
                 OutDay        :=          1 ;

                 OutH          :=          0 ;
                 OutMin        :=          0 ;
                 OutSek        :=        0.0 ;



{ � � � � � � � � }
{ ��������������� }


                  { ��������� ��������� }
                  { ������������������� }


                 NPl0          :=          3 ;

                 Earth_Space   :=          1 ;   { 1 - Earth, 2 - Space }

                        { ����� }
                        { ����� }

                 LongSig       :=         '+';
                 LongG         :=         37 ;
                 LongM         :=         41 ;
                 LongS         :=       54.0 ;

                 LatSig        :=         '+';
                 LatG          :=         55 ;
                 LatM          :=          0 ;
                 LatS          :=        0.0 ;

                 Alt           :=      0.000 ;


                      { ��ᬮ� }
                      { ������ }

                 ElemFile      :=          1 ; { 1 - �p�����, 2 - �������� }

                 HAp           := 200000.000 ;
                 HPer          := 100000.000 ;
                 ISat          :=     30.000 ;
                 OmG           :=     55.000 ;
                 OmL           :=     31.000 ;
                 ArgLat        :=     62.000 ;


                     { ����   ���H�� }
                     { ������������� }

                 FldX          :=      1.000 ;
                 FldY          :=      1.000 ;

                  { �������⥫쭠�  p���� }
                  { - - - - - - - - - - - }
                 RRX           :=      0.000 ;
                 RRY           :=      0.000 ;

                 NPolFix       :=          1 ;

                 XOrient       :=          1 ;
                 YOrient       :=          1 ;

                 RSun          :=       30.0 ;
                 RMon          :=       10.0 ;

                    { ��⮯p������ }
                    { ������������ }

                 MvMax         :=       21.0 ;

                 Period_X_Min  :=      3.000 ;
                 Period_Y_Min  :=      3.000 ;

                 Pixel_X_Min   :=      2.000 ;
                 Pixel_Y_Min   :=      2.000 ;

                 N_Pixel_X     :=         10 ;
                 N_Pixel_Y     :=         10 ;



{ � � � � � � � � � �    � � �  }
{ ����������������������������  }



                { ����H����� ����᪮� �� }
                { ������������������������� }


                 OptAxOrient    :=          1 ;   { 1 - Eq  , 2 - Gor ,
                                                    3 - Orb , 4 - Obj  }


               { �����p����� ���p������  }
               { �������������������������  }

                 RaOptH         :=          0 ;
                 RaOptM         :=          0 ;
                 RaOptS         :=       0.00 ;

                 DeclOptSig     :=         '+';
                 DeclOptG       :=          0 ;
                 DeclOptM       :=          0 ;
                 DeclOptS       :=       0.00 ;

               { ��p����⠫�� ���p������ }
               { ������������������������� }

                 ASig           :=         '+';
                 AG             :=          0 ;
                 AM             :=          0 ;
                 AS             :=       0.00 ;

                 HOptType       :=          1 ; { 1 - ��p��,
                                                  2 - ���� � ��p������ }

                 HSig           :=         '+';
                 HG             :=          0 ;
                 HM             :=          0 ;
                 HS             :=       0.00 ;


             { �⭮�⥫쭮 ����p� ᪮p��� ( � �p����� ) }
             { ����������������������������� }

                 Tangag         :=     38.300 ;
                 Ryskanie       :=   -135.700 ;

                     { �� ��ꥪ�� }
                     { ���������� }

                 NObj           :=          1 ;  { 1 - Plan, 2 - Sat }
                 NPlan          :=         13 ;
                 NSat           :=          1 ;



{ � � � � � � }
{ ����������� }


                    { ������ p����� }
                    { ������������� }


                 EarthIzo      :=          0 ;
                 Corr_Fot_Sys  :=          0 ;
                 OutFOV        :=          0 ;
                 Object_Tracks :=          0 ;
                 DetCdc        :=          0 ;
                 ImportStar    :=          0 ; { 0 - H� ������� }
                 DetImp        :=          0 ; { 0 - H� �⮦�,  1 - �� }
                 StopNoDet     :=          0 ; { 0 - H� Stop,   1 - Stop �p� ����. }
                 PzsInFOV      :=          0 ;

               { H���p  ���. �p㯯� ����p��� ��ꥪ⮢ }
               { - - - - - - - - - - - - - - - - - - - }

                 NGrImportBeg  :=          1 ;


                 DMvDet        :=        -2.0 ;


                 { �������  �⮦���⢫���� }
                 { - - - - - - - - - - - - }

                 RoPPMDet      :=        3.0 ;
                 RoBsDet       :=        5.0 ;
                 RoHdDet       :=       12.0 ;
                 RoGcvsDet     :=       90.0 ;
                 RoCdcDet      :=        5.0 ; { ������ ��p������� �p㯯 ����� }
                 RoGscDet      :=        5.0 ;
                 RoIrasDet     :=       60.0 ;
                 RoDmDet       :=       60.0 ;
                 RDetImp       :=       20.0 ;



{ � � � � � � � �   �  ����� ������ }
{ ���������������                   }


                  { �ᯮ��㥬� �������� }
                  { ��������������������� }

                 PPM           :=          0 ;
                 Bs            :=          0 ;
                 Hd            :=          0 ;
                 Gcvs          :=          0 ;
                 Cdc           :=          0 ;
                 Gsc           :=          0 ;
                 Iras          :=          0 ;
                 Dm            :=          0 ;
                 Satellits     :=          0 ;

                  { ���������� ��⠫���� }
                  { �������������������� }

                 ParamDir.HipDir         := 'C:\Catalog\Hip'   ;
                 ParamDir.TycDir         := 'C:\Catalog\Tyc'   ;
                 ParamDir.PPMDir         := 'C:\Catalog\PPM'   ;
                 ParamDir.BsDir          := 'C:\Catalog\Bs'    ;
                 ParamDir.HdDir          := 'C:\Catalog\Hd'    ;
                 ParamDir.GcvsDir        := 'C:\Catalog\Gcvs'  ;
                 ParamDir.CdcDir         := 'C:\Catalog\Ak'    ;
                 ParamDir.NpmDir         := 'C:\Catalog\Npm1'  ;
                 ParamDir.NLttDir        := 'C:\Catalog\NLtt'  ;
                 ParamDir.A20Dir         := 'C:\Catalog\A_2_0' ;
                 ParamDir.GscDir         := 'C:\Catalog\Gsc'   ;
                 ParamDir.DmDir          := 'C:\Catalog\Dm'    ;
                 ParamDir.IrasDir        := 'C:\Catalog\Others';
                 ParamDir.SatDir         := 'C:\Catalog\Sat_El';


                  { �����  ���H� ������ }
                  { - - - - - - - - - - }

                 Param.SatellitsDir      := '*.txt' ;
                 Param.ImportStarDir     := ''      ;
                 Param.PzsDir            := ''      ;
                 Param.FotSysDir         := ''      ;


          If  ( FSearch ( 'User.Dir' ,'')<> '') Then
            Begin  { CatDirFile Exist }
                   { ���������������� }

              Assign ( CatDirFile, 'User.Dir' );
                {$I-}
              ReSet  ( CatDirFile ) ;
              Close  ( CatDirFile ) ;
                {$I+}

              If ( IOResult = 0 )  Then
                Begin

                  ReSet ( CatDirFile );

                  ReadLn ( CatDirFile , S ) ;
                  DelProb ;
                  ParamDir.HipDir  := S ;

                  ReadLn ( CatDirFile , S ) ;
                  DelProb ;
                  ParamDir.TycDir  := S ;

                  ReadLn ( CatDirFile , S ) ;
                  DelProb ;
                  ParamDir.PPMDir  := S ;

                  ReadLn ( CatDirFile , S ) ;
                  DelProb ;
                  ParamDir.BsDir   := S ;

                  ReadLn ( CatDirFile , S ) ;
                  DelProb ;
                  ParamDir.HdDir   := S ;

                  ReadLn ( CatDirFile , S ) ;
                  DelProb ;
                  ParamDir.GcvsDir := S ;

                  ReadLn ( CatDirFile , S ) ;
                  DelProb ;
                  ParamDir.CdcDir  := S ;

                  ReadLn ( CatDirFile , S ) ;
                  DelProb ;
                  ParamDir.NpmDir  := S ;

                  ReadLn ( CatDirFile , S ) ;
                  DelProb ;
                  ParamDir.NLttDir  := S ;

                  ReadLn ( CatDirFile , S ) ;
                  DelProb ;
                  ParamDir.A20Dir  := S ;

                  ReadLn ( CatDirFile , S ) ;
                  DelProb ;
                  ParamDir.GscDir  := S ;

                  ReadLn ( CatDirFile , S ) ;
                  DelProb ;
                  ParamDir.DmDir   := S ;

                  ReadLn ( CatDirFile , S ) ;
                  DelProb ;
                  ParamDir.IrasDir := S ;

                  If ( Not Eof ( CatDirFile ) )  Then
                    Begin
                      ReadLn ( CatDirFile , S ) ;
                      DelProb ;
                      ParamDir.SatDir := S ;
                    End ;

                  Close  ( CatDirFile );

                End ;

            End ;

     End ; { With  Param }

 End ;  {  Pro  InitVarMenu  }

End.

