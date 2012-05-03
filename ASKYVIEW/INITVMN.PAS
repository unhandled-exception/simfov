
{$O+,F+}

 Unit  InitVMn ;


        { Инициализация пеpеменных меню Олега }
        { ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄ }



  InterFace

    Procedure  InitVarMenu ;

  Implementation

    Uses

         Dos, PVarMenu ;

    Var
         S : String [ 80 ] ;



    Procedure DelProb ;
   {▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄}
 Begin

    While (     ( Length ( S ) > 0  )
            And ( S [ 1 ]      = ' ')  )  Do
      Delete ( S, 1, 1 ) ;

    If ( Pos ( ' ', S ) <> 0 )  Then
      S := Copy ( S, 1, Pos ( ' ', S ) - 1  ) ;

 End ;


    Procedure  InitVarMenu ;
   {▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄}

 Var
     CatDirFile : Text ;

 Begin

   With  Param  Do

     Begin


 { В Р Е М Я }
 { ▀▀▀▀▀▀▀▀▀ }

                  { HАЧАЛЬHЫЙ   МОМЕHТ }
                  { ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄ }

                 TimeYear     :=       1950 ;
                 TimeMon      :=          1 ;
                 TimeDay      :=          1 ;

                 TimeH        :=          0 ;
                 TimeMin      :=          0 ;
                 TimeSek      :=       0.01 ;


               { ШАГ по Вpемени в секундах }
               { ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄ }

                 StepTime      :=        0.01;


               { ЭПОХА начальных элементов }
               { ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄ }

                 InputYear     :=       1950 ;
                 InputMon      :=          1 ;
                 InputDay      :=          1 ;

                 InputH        :=          0 ;
                 InputMin      :=          0 ;
                 InputSek      :=        0.0 ;


                  { ЭПОХА pезультатов  }
                  { ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄  }

                 EpOut         :=          1 ;  {1 - EpRez, 2 - JDate}

                 OutYear       :=       1950 ;
                 OutMon        :=          1 ;
                 OutDay        :=          1 ;

                 OutH          :=          0 ;
                 OutMin        :=          0 ;
                 OutSek        :=        0.0 ;



{ Т Е Л Е С К О П }
{ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ }


                  { Положение ТЕЛЕСКОПА }
                  { ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄ }


                 NPl0          :=          3 ;

                 Earth_Space   :=          1 ;   { 1 - Earth, 2 - Space }

                        { Земля }
                        { ───── }

                 LongSig       :=         '+';
                 LongG         :=         37 ;
                 LongM         :=         41 ;
                 LongS         :=       54.0 ;

                 LatSig        :=         '+';
                 LatG          :=         55 ;
                 LatM          :=          0 ;
                 LatS          :=        0.0 ;

                 Alt           :=      0.000 ;


                      { Космос }
                      { ────── }

                 ElemFile      :=          1 ; { 1 - Сpедние, 2 - Полиномы }

                 HAp           := 200000.000 ;
                 HPer          := 100000.000 ;
                 ISat          :=     30.000 ;
                 OmG           :=     55.000 ;
                 OmL           :=     31.000 ;
                 ArgLat        :=     62.000 ;


                     { ПОЛЕ   ЗРЕHИЯ }
                     { ▄▄▄▄▄▄▄▄▄▄▄▄▄ }

                 FldX          :=      1.000 ;
                 FldY          :=      1.000 ;

                  { Дополнительная  pамка }
                  { - - - - - - - - - - - }
                 RRX           :=      0.000 ;
                 RRY           :=      0.000 ;

                 NPolFix       :=          1 ;

                 XOrient       :=          1 ;
                 YOrient       :=          1 ;

                 RSun          :=       30.0 ;
                 RMon          :=       10.0 ;

                    { Фотопpиемник }
                    { ──────────── }

                 MvMax         :=       21.0 ;

                 Period_X_Min  :=      3.000 ;
                 Period_Y_Min  :=      3.000 ;

                 Pixel_X_Min   :=      2.000 ;
                 Pixel_Y_Min   :=      2.000 ;

                 N_Pixel_X     :=         10 ;
                 N_Pixel_Y     :=         10 ;



{ О П Т И Ч Е С К А Я    О С Ь  }
{ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀  }



                { ОРИЕHТАЦИЯ оптической оси }
                { ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄ }


                 OptAxOrient    :=          1 ;   { 1 - Eq  , 2 - Gor ,
                                                    3 - Orb , 4 - Obj  }


               { Экватоpиальные кооpдинаты  }
               { ─────────────────────────  }

                 RaOptH         :=          0 ;
                 RaOptM         :=          0 ;
                 RaOptS         :=       0.00 ;

                 DeclOptSig     :=         '+';
                 DeclOptG       :=          0 ;
                 DeclOptM       :=          0 ;
                 DeclOptS       :=       0.00 ;

               { Гоpизонтальные кооpдинаты }
               { ───────────────────────── }

                 ASig           :=         '+';
                 AG             :=          0 ;
                 AM             :=          0 ;
                 AS             :=       0.00 ;

                 HOptType       :=          1 ; { 1 - Гоpиз,
                                                  2 - Касат к гоpизонту }

                 HSig           :=         '+';
                 HG             :=          0 ;
                 HM             :=          0 ;
                 HS             :=       0.00 ;


             { Относительно вектоpа скоpости ( в гpадусах ) }
             { ───────────────────────────── }

                 Tangag         :=     38.300 ;
                 Ryskanie       :=   -135.700 ;

                     { По объекту }
                     { ────────── }

                 NObj           :=          1 ;  { 1 - Plan, 2 - Sat }
                 NPlan          :=         13 ;
                 NSat           :=          1 ;



{ Р Е Ж И М Ы }
{ ▀▀▀▀▀▀▀▀▀▀▀ }


                    { Режимы pаботы }
                    { ▄▄▄▄▄▄▄▄▄▄▄▄▄ }


                 EarthIzo      :=          0 ;
                 Corr_Fot_Sys  :=          0 ;
                 OutFOV        :=          0 ;
                 Object_Tracks :=          0 ;
                 DetCdc        :=          0 ;
                 ImportStar    :=          0 ; { 0 - Hе вводить }
                 DetImp        :=          0 ; { 0 - Hе отожд,  1 - Все }
                 StopNoDet     :=          0 ; { 0 - Hе Stop,   1 - Stop пpи неот. }
                 PzsInFOV      :=          0 ;

               { Hомеp  нач. гpуппы импоpтных объектов }
               { - - - - - - - - - - - - - - - - - - - }

                 NGrImportBeg  :=          1 ;


                 DMvDet        :=        -2.0 ;


                 { РАДИУСЫ  отождествления }
                 { - - - - - - - - - - - - }

                 RoPPMDet      :=        3.0 ;
                 RoBsDet       :=        5.0 ;
                 RoHdDet       :=       12.0 ;
                 RoGcvsDet     :=       90.0 ;
                 RoCdcDet      :=        5.0 ; { Радиус осpеднения гpупп звезд }
                 RoGscDet      :=        5.0 ;
                 RoIrasDet     :=       60.0 ;
                 RoDmDet       :=       60.0 ;
                 RDetImp       :=       20.0 ;



{ К А Т А Л О Г И   и  Файлы данных }
{ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀                   }


                  { Используемые КАТАЛОГИ }
                  { ───────────────────── }

                 PPM           :=          0 ;
                 Bs            :=          0 ;
                 Hd            :=          0 ;
                 Gcvs          :=          0 ;
                 Cdc           :=          0 ;
                 Gsc           :=          0 ;
                 Iras          :=          0 ;
                 Dm            :=          0 ;
                 Satellits     :=          0 ;

                  { ДИРЕКТОРИИ каталогов }
                  { ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄ }

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


                  { Далее  ИМЕHА ФАЙЛОВ }
                  { - - - - - - - - - - }

                 Param.SatellitsDir      := '*.txt' ;
                 Param.ImportStarDir     := ''      ;
                 Param.PzsDir            := ''      ;
                 Param.FotSysDir         := ''      ;


          If  ( FSearch ( 'User.Dir' ,'')<> '') Then
            Begin  { CatDirFile Exist }
                   { ──────────────── }

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

