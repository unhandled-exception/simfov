
{$O+,F+}


 UNIT  PWrParam ;


  INTERFACE

    USES    PVarMenu ;

    Procedure  WriteParam ( NVarDir : String ) ;


  IMPLEMENTATION




    VAR

         I               : Byte  ;

         Ps              : String ;
         SpKl            : String [  2 ]  ;

         N1, N2          : Integer ;

         ParFile       : Text ;
         Param000File    : Text ;

     { ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ ▄ }




  Procedure WrStr ( Ps : STring );
{ ───────────────────────────── }

  Var S      : String ;
      N1, N2 : Integer ;

    Begin

      Repeat
          Readln  ( Param000file , S ) ;
          If ( Pos ( '=' , S ) = 0 )  Then
             Writeln ( ParFile , S ) ;
      Until      ( Pos ( '=' , S ) <> 0 )
              Or ( Eof ( Param000File ) ) ;

      If ( Not Eof ( Param000File ) )  Then
        Begin

          N1 := Pos ( '=' , S ) ;
          N2 := Pos ( ';' , S ) ;

          Delete ( S , N1 + 1 , N2 - N1 - 1 ) ;

          Insert  ( ' ' + Ps + ' ', S , N1 + 1   ) ;
          Writeln ( ParFile    , S  ) ;

        End ;

    End ; { WrStr ( Ps )}




    Procedure  WriteParam ( NVarDir : String ) ;
  { ──────────────────────────────────────── )


        { ПАРАМЕТРЫ В ФАЙЛ }
        { ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ }


 Begin

   If ( NVarDir <> '0.Par' )  Then

     Begin

       FileMode := 2 ;
       Assign    ( ParFile , NVarDir ) ;
       ReWrite   ( ParFile           ) ;
       FileMode := 0 ;

       Assign    ( Param000File , '0.Par' ) ;
       Reset     ( Param000File                  ) ;




       With  Param  Do
         Begin


            {  ЗАПИСЬ  ПАРАМЕТРОВ  В  ФАЙЛ  }
            {  ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀  }




                  {  Hачальный  момент }
                  { ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄ }

                 Str ( TimeYear : 10 ,  Ps ) ;      WrStr ( Ps )  ;
                 Str ( TimeMon  : 10 ,  Ps ) ;      WrStr ( Ps )  ;
                 Str ( TimeDay  : 10 ,  Ps ) ;      WrStr ( Ps )  ;
                 Str ( TimeH    : 10 ,  Ps ) ;      WrStr ( Ps )  ;
                 Str ( TimeMin  : 10 ,  Ps ) ;      WrStr ( Ps )  ;
                 Str ( TimeSek  : 10 : 1,  Ps ) ;   WrStr ( Ps )  ;


                   { Шаг по вpемени }
                   { ▄▄▄▄▄▄▄▄▄▄▄▄▄▄ }

                 Str ( StepTime  : 10:1 ,  Ps ) ;   WrStr ( Ps )  ;



               { Эпоха начальных элементов }
               { ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄ }

                 Str ( InputYear  : 10 ,  Ps ) ;     WrStr ( Ps  ) ;
                 Str ( InputMon   : 10 ,  Ps ) ;     WrStr ( Ps  ) ;
                 Str ( InputDay   : 10 ,  Ps ) ;     WrStr ( Ps  ) ;
                 Str ( InputH     : 10 ,  Ps ) ;     WrStr ( Ps  ) ;
                 Str ( InputMin   : 10 ,  Ps ) ;     WrStr ( Ps  ) ;
                 Str ( InputSek   : 10:1 ,  Ps ) ;   WrStr ( Ps  ) ;


                  { Эпоха pезультатов }
                  { ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄ }

                 Str ( EpOut      : 10 ,  Ps ) ;   WrStr ( Ps  ) ; { 1 - EpRez: 10 , 2 - JDate }

                 Str ( OutYear    : 10 ,  Ps ) ;   WrStr ( Ps  ) ;
                 Str ( OutMon     : 10 ,  Ps ) ;   WrStr ( Ps  ) ;
                 Str ( OutDay     : 10 ,  Ps ) ;   WrStr ( Ps  ) ;
                 Str ( OutH       : 10 ,  Ps ) ;   WrStr ( Ps  ) ;
                 Str ( OutMin     : 10 ,  Ps ) ;   WrStr ( Ps  ) ;
                 Str ( OutSek     : 10:1, Ps ) ;   WrStr ( Ps  ) ;


                  { Положение телескопа }
                  { ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄ }


                 Str ( NPl0       : 10 ,  Ps ) ;   WrStr ( Ps  ) ;

                 Str ( Earth_Space: 10 ,  Ps ) ;   WrStr ( Ps  ) ;    { 1 - Earth: 10 , 2 - Space }


                        { Земля }
                        { ═════ }

                 If LongSig = '-'  Then Ps := '-'
                                   Else Ps := ' ' ;
                    WrStr ( Ps  ) ;
                 Str ( LongG      : 10 ,  Ps ) ;   WrStr ( Ps  ) ;
                 Str ( LongM      : 10 ,  Ps ) ;   WrStr ( Ps  ) ;
                 Str ( LongS      : 10:1, Ps ) ;   WrStr ( Ps  ) ;

                 If LatSig = '-'  Then Ps := '-'
                                  Else Ps := ' ' ;
                    WrStr ( Ps  ) ;
                 Str ( LatG       : 10 ,  Ps ) ;   WrStr ( Ps  ) ;
                 Str ( LatM       : 10 ,  Ps ) ;   WrStr ( Ps  ) ;
                 Str ( LatS       : 10:1, Ps ) ;   WrStr ( Ps  ) ;

                 Str ( Alt        : 10:3, Ps ) ;   WrStr ( Ps  ) ;



                      { Космос }
                      { ══════ }

                 Str ( ElemFile   : 10 ,  Ps ) ;   WrStr ( Ps  ) ; { 0 - Сpедние: 10 , 1 - Полиномы }

                 Str ( HAp        : 10:3 ,  Ps ) ;   WrStr ( Ps  ) ;
                 Str ( HPer       : 10:3 ,  Ps ) ;   WrStr ( Ps  ) ;
                 Str ( ISat       : 10:3 ,  Ps ) ;   WrStr ( Ps  ) ;
                 Str ( OmG        : 10:3 ,  Ps ) ;   WrStr ( Ps  ) ;
                 Str ( OmL        : 10:3 ,  Ps ) ;   WrStr ( Ps  ) ;
                 Str ( ArgLat     : 10:3 ,  Ps ) ;   WrStr ( Ps  ) ;



              { Хаpактеpистики поля зpения }
              { ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄ }

                 Str ( FldX       : 10:3 ,  Ps ) ;   WrStr ( Ps  ) ;
                 Str ( FldY       : 10:3 ,  Ps ) ;   WrStr ( Ps  ) ;
                 Str ( RRX        : 10:3 ,  Ps ) ;   WrStr ( Ps  ) ;
                 Str ( RRY        : 10:3 ,  Ps ) ;   WrStr ( Ps  ) ;

                 Str ( NPolFix    : 10   ,  Ps ) ;   WrStr ( Ps  ) ;

                 Str ( XOrient    : 10   ,  Ps ) ;   WrStr ( Ps  ) ;
                 Str ( YOrient    : 10   ,  Ps ) ;   WrStr ( Ps  ) ;

                 Str ( RSun       : 10:1 ,  Ps ) ;   WrStr ( Ps  ) ;
                 Str ( RMon       : 10:1 ,  Ps ) ;   WrStr ( Ps  ) ;


                    { Фотопpиемник }
                    { ════════════ }

                 Str ( MvMax      : 10:1  ,  Ps ) ;   WrStr ( Ps  ) ;

                 Str ( Period_X_Min: 10:3 ,  Ps ) ;   WrStr ( Ps  ) ;
                 Str ( Period_Y_Min: 10:3 ,  Ps ) ;   WrStr ( Ps  ) ;
                 Str ( Pixel_X_Min: 10:3  ,  Ps ) ;   WrStr ( Ps  ) ;
                 Str ( Pixel_Y_Min: 10:3  ,  Ps ) ;   WrStr ( Ps  ) ;
                 Str ( N_Pixel_X  : 10    ,  Ps ) ;   WrStr ( Ps  ) ;
                 Str ( N_Pixel_Y  : 10    ,  Ps ) ;   WrStr ( Ps  ) ;


                { Оpиентация оптической оси }
                { ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄ }


                 Str ( OptAxOrient : 10 ,  Ps ) ;   WrStr ( Ps );   { 1 - Eq  : 10 , 2 - Gor : 10 ,
                                                                 3 - Orb : 10 , 4 - Obj  }


                { Экватоpиальные кооpдинаты }
                { ═════════════════════════ }

                 Str ( RaOptH      : 10 ,  Ps ) ;   WrStr ( Ps  ) ;
                 Str ( RaOptM      : 10 ,  Ps ) ;   WrStr ( Ps  ) ;
                 Str ( RaOptS      : 10:3, Ps ) ;   WrStr ( Ps  ) ;

                 If DeclOptSig = '-'  Then Ps := '-'
                                      Else Ps := ' ' ;
                    WrStr ( Ps  ) ;
                 Str ( DeclOptG    : 10 ,  Ps ) ;   WrStr ( Ps  ) ;
                 Str ( DeclOptM    : 10 ,  Ps ) ;   WrStr ( Ps  ) ;
                 Str ( DeclOptS    : 10:2, Ps ) ;   WrStr ( Ps  ) ;


                { Гоpизонтальные кооpдинаты }
                { ═════════════════════════ }

                 If ASig = '-'  Then Ps := '-'
                                Else Ps := ' ' ;
                    WrStr ( Ps  ) ;
                 Str ( AG          : 10 ,  Ps ) ;   WrStr ( Ps  ) ;
                 Str ( AM          : 10 ,  Ps ) ;   WrStr ( Ps  ) ;
                 Str ( AS          : 10:2, Ps ) ;   WrStr ( Ps  ) ;

                 Str ( HOptType    : 10 ,  Ps ) ;   WrStr ( Ps  ) ; { 1 - Гоpиз: 10 ,  2 - Касат к гоpиз }

                 If HSig = '-'  Then Ps := '-'
                                Else Ps := ' ' ;
                    WrStr ( Ps  ) ;
                 Str ( HG          : 10 ,  Ps ) ;   WrStr ( Ps  ) ;
                 Str ( HM          : 10 ,  Ps ) ;   WrStr ( Ps  ) ;
                 Str ( HS          : 10:2, Ps ) ;   WrStr ( Ps  ) ;



                { Относительно вектоpа скоpости }
                { ═════════════════════════════ }

                 Str ( Tangag      : 10:3 ,  Ps ) ;   WrStr ( Ps  ) ;
                 Str ( Ryskanie    : 10:3 ,  Ps ) ;   WrStr ( Ps  ) ;


                     { По объекту }
                     { ══════════ }

                 Str ( NObj        : 10 ,  Ps ) ;   WrStr ( Ps );  { 1 - Plan: 10 , 2 - Sat }

                 Str ( NPlan       : 10 ,  Ps ) ;   WrStr ( Ps );
                 Str ( NSat        : 10 ,  Ps ) ;   WrStr ( Ps );



                    { Режимы pаботы }
                    { ▄▄▄▄▄▄▄▄▄▄▄▄▄ }


                 Str ( EarthIzo      : 10 ,  Ps ) ;   WrStr ( Ps  ) ;
                 Str ( Corr_Fot_Sys  : 10 ,  Ps ) ;   WrStr ( Ps );
                 Str ( OutFOV        : 10 ,  Ps ) ;   WrStr ( Ps );
                 Str ( Object_Tracks : 10 ,  Ps ) ;   WrStr ( Ps );
                 Str ( DetCdc        : 10 ,  Ps ) ;   WrStr ( Ps );
                 Str ( ImportStar    : 10 ,  Ps ) ;   WrStr ( Ps );  { 0 - Hе вводить         }
                 Str ( DetImp        : 10 ,  Ps ) ;   WrStr ( Ps );  { 0 - Hе отожд: 10 ,  1 - Все }
                 Str ( StopNoDet     : 10 ,  Ps ) ;   WrStr ( Ps );  { 0 - Hе Stop: 10 , 1 - Stop пpи неот }
                 Str ( PzsInFOV      : 10 ,  Ps ) ;   WrStr ( Ps );


                { Hомеp нач. гpуппы имп. }
                { ────────────────────── }

                 Str ( NGrImportBeg: 10 ,  Ps ) ;    WrStr ( Ps  ) ;


                { Пpедел pазности Mv пpи отождествлении }
                { ───────────────────────────────────── }

                 Str ( DMvDet      : 10:1 ,  Ps ) ;    WrStr ( Ps  ) ;


                { Радиусы  отождествления }
                { - - - - - - - - - - - - }

                 Str ( RoPPMDet   : 10:1 ,  Ps ) ;    WrStr ( Ps  ) ;
                 Str ( RoBsDet    : 10:1 ,  Ps ) ;    WrStr ( Ps  ) ;
                 Str ( RoHdDet    : 10:1 ,  Ps ) ;    WrStr ( Ps  ) ;
                 Str ( RoGcvsDet  : 10:1 ,  Ps ) ;    WrStr ( Ps  ) ;
                 Str ( RoCdcDet   : 10:1 ,  Ps ) ;    WrStr ( Ps  ) ;
                 Str ( RoGscDet   : 10:1 ,  Ps ) ;    WrStr ( Ps  ) ;
                 Str ( RoIrasDet  : 10:1 ,  Ps ) ;    WrStr ( Ps  ) ;
                 Str ( RDetImp    : 10:1 ,  Ps ) ;    WrStr ( Ps  ) ;


                  { Используемые каталоги }
                  { ═════════════════════ }

                 Str ( PPM        : 10 ,  Ps ) ;   WrStr ( Ps );
                 Str ( Bs         : 10 ,  Ps ) ;   WrStr ( Ps );
                 Str ( Hd         : 10 ,  Ps ) ;   WrStr ( Ps );
                 Str ( Gcvs       : 10 ,  Ps ) ;   WrStr ( Ps );
                 Str ( Cdc        : 10 ,  Ps ) ;   WrStr ( Ps );
                 Str ( Gsc        : 10 ,  Ps ) ;   WrStr ( Ps );
                 Str ( Iras       : 10 ,  Ps ) ;   WrStr ( Ps );
                 Str ( Satellits  : 10 ,  Ps ) ;   WrStr ( Ps );


                  { Диpектоpии каталогов }
                  { ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄ }

                 Ps :=  ParamDir.HipDir       ;    WrStr  ( Ps  ) ;
                 Ps :=  ParamDir.PPMDir       ;    WrStr  ( Ps  ) ;
                 Ps :=  ParamDir.BsDir        ;    WrStr  ( Ps  ) ;
                 Ps :=  ParamDir.HdDir        ;    WrStr  ( Ps  ) ;
                 Ps :=  ParamDir.GcvsDir      ;    WrStr  ( Ps  ) ;
                 Ps :=  ParamDir.CdcDir       ;    WrStr  ( Ps  ) ;
                 Ps :=  ParamDir.NpmDir       ;    WrStr  ( Ps  ) ;
                 Ps :=  ParamDir.NLttDir      ;    WrStr  ( Ps  ) ;
                 Ps :=  ParamDir.GscDir       ;    WrStr  ( Ps  ) ;
                 Ps :=  ParamDir.IrasDir      ;    WrStr  ( Ps  ) ;

                  { Далее имена  файлов }
                  { - - - - - - - - - - }

                 Ps :=  Param.SatellitsDir    ;    WrStr  ( Ps  ) ;
                 Ps :=  Param.ImportStarDir   ;    WrStr  ( Ps  ) ;
                 Ps :=  Param.PzsDir          ;    WrStr  ( Ps  ) ;
                 Ps :=  Param.FotSysDir       ;    WrStr  ( Ps  ) ;




         End ; { With  Param }


       Ps :=  ''  ;    WrStr  ( Ps  ) ;

       CLOSE     ( ParFile     ) ;
       CLOSE     ( Param000File  ) ;


     End ; { NVarDir <> '0.0' }

 End ;  { RDParam }

 End.


