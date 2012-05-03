
{$O+,F+}

 Unit  PCalCons ;

  Interface

    Procedure  CalCons ;

  Implementation

    Uses

         PVar,  V_Catal, About, PJD8, PVarMenu, Check, Dos, Crt,
         POptCcd, POptPars, PElStRct, MLib ;

    Procedure  CalCons ;


  Var

       FlagError,
       CoordExist, ReadSatEl                           : Boolean ;

       Ch                                              : Char    ;

       PBeg, ColorPixel                                : Byte    ;

       I, J, K,
       IndSer,
       NSat,
       KCalCons,
       NPlSat,
       NBeg                                            : Integer ;

       Year,
       NRecDE200                                       : Longint ;

       T,
       LX, LY,
       SSATEF, Fl,
       BETCalCons, VCalCons,
       SQRCalCons, BETSKCalCons,
       RX, RY, JdVisocReal                             : Double  ;

       IndBufOrd : Integer ;
       S         : String  ;
       F         : Text    ;

       BufNameCat : Array [ 1 .. CatIzoMax ]  Of String [ 4 ] ;
       BufOrd     : Array [ 1 .. CatIzoMax ]  Of Integer      ;

  Begin


    NPLSUM   :=     0    ;
{
    PRDate   :=     0    ;
}
    ROpt     :=     0    ;
    VOpt     :=     0    ;
    Stop     :=   False  ;
    GscNew   :=   True   ;

    R360     := 360.0  * GR   ;
    R359     := 359.0  * GR   ;
    R90      :=  89.0  * GR   ;
    StepRad  := StepGr * GR   ;




        { ЦЕНТРЫ ЯЧЕЕК КАТАЛОГА }
        { ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄ }


    ConstDSin := Trunc ( 65535.0 / ( StepRad / C20 ) ) ;
    NRaMax    := Trunc (   360.0 / StepGr + 0.01 ) ;
    NDecMax   := Trunc (   180.0 / StepGr + 0.01 ) ;


    For  N := 1  To  NRaMax  Do
       Begin
          RR := ( StepGr * N - StepGr / C20 ) * GR ;
          SinRaFild  [ N ] := Sin ( RR ) ;
          CosRaFild  [ N ] := Cos ( RR ) ;
       End ;

    For  N := 1  To  NDecMax  Do
       Begin
          RR := ( StepGr * N - StepGr / C20 - 90.0 ) * GR  ;
          SinDecFild [ N ] := Sin ( RR ) ;
       End ;


    SRaGalPol50   := Sin (   RaGalPol50 )  ;
    CRaGalPol50   := Cos (   RaGalPol50 )  ;
    SDeclGalPol50 := Sin ( DeclGalPol50 )  ;
    CDeclGalPol50 := Cos ( DeclGalPol50 )  ;



     RealTimeDate := False ;
     RealTimeStep := False ;


         { Анализ момента в Паpаметpах }
         { ─────────────────────────── }

     StepTime := Param.StepTime ;
     If ( Abs ( StepTime ) < 1.0E-8 )  Then
       Begin
         RealTimeStep := True ;  { Шаг в pеальном вpемени }
       End ;

     StepTime := StepTime / C36000 / 24.0 ;



     { Разность Местного и Гpинв. вpемени }
     { ────────────────────────────────── }
     DtGrTopo   := Param.TimeMin Div 100 ;
     FlagTCivil := False ;
     If ( DtGrTopo > 0 )  Then
       Begin
         DtGrTopo      := Param.TimeMin Mod 100 ;
         Param.TimeMin := 0                     ;
         Param.TimeSek := 0                     ;
         FlagTCivil    := True                  ;
       End ;




           { Hачальный момент }
           { ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄ }


     GetDate ( TimerYear, TimerMonth, TimerDay, TimerDayOfWeek ) ;

     Repeat
       GetTime ( TimerHour, TimerMin  , TimerSec, TimerSec100    ) ;
     Until (    ( TimerSEC100 > 95 )
             Or ( TimerSEC100 <  5 ) )  ;

     If ( TimerSec100 >= 95 )
       Then TimerSec100 := 2
       Else TimerSec100 := 1 ;

     IY := TimerYear              ;
     IM := TimerMonth             ;
     ID := TimerDay               ;
     JD8 ( IY, IM, ID, JDTimer2 ) ;

     If ( Param.TimeH >= 100 )
       Then
         Begin

           JDate :=   JDTimer2
                    + ( ( Param.TimeH Mod 100 ) * C36000 ) / C864000
                    - DtGrTopo / 24.0 ;

           JDTimer2Param :=   JDTimer2
                            + ( TimerHour * C36000
                            +   TimerMin  *   C600  ) / C864000
                            + ( TimerSec + TimerSec100 ) / C864000
                            - DtGrTopo / 24.0 ;

         End
       Else
         Begin

           JDTimer2 :=   JDTimer2
                         + (   TimerHour * C36000
                             + TimerMin  *   C600  ) / C864000
                         + (   TimerSec + TimerSec100 ) / C864000 ;

           JDTimer2 := JDTimer2 - ( DtGrTopo / 24.0 ) ;

           JdTimer2Param := JDTimer2 ;
           JDate         := JDTimer2 ;

         End ;


     If ( Param.TimeYear <> 0 )
       Then
         Begin  { Дата из Паpаметpов }

           JD8 ( Param.TimeYear, Param.TimeMon, Param.TimeDay, JDate ) ;

           If (     ( ( Param.TimeH   Div 100 ) = 0 )
                And ( ( Param.TimeMin Div 100 ) = 0 )  )
             Then
               Begin
                 T := (   Param.TimeH
                        + Param.TimeMin / C600  ) / 24.0 ;
                 If ( RealTimeStep )
                   Then T := T + ( Trunc ( Param.TimeSek ) / C36000 ) / 24.0
                   Else T := T + Param.TimeSek / C36000 / 24.0 ;
               End
             Else
                 T := ( Param.TimeH Mod 100 ) / 24.0 ;

           JDateParam   := JDate + T                        ;
           JDateParam   := JDateParam - ( DtGrTopo / 24.0 ) ;
           JDate        := JDateParam                       ;

           RealTimeDate := False                            ;

         End
       Else
         Begin

           RealTimeDate   := True ;
           JDate          := JDTimer2   ; {Дата с Таймеpа}
           JDate          := JDate - ( DtGrTopo / 24.0 ) ;

           Param.TimeYear := TimerYear  ;
           Param.TimeMon  := TimerMonth ;
           Param.TimeDay  := TimerDay   ;

           If ( Param.TimeH >= 100 )
             Then
               Begin
                 Param.TimeH   := Param.TimeH Mod 100 - Round ( DtGrTopo ) ;
                 Param.TimeMin := 0 ;
                 Param.TimeSek := 0 ;
                 JDateParam    := JDate ;
                 RealTimeDate  := False ;
               End
             Else
               Begin
                 Param.TimeH   := TimerHour - Round ( DtGrTopo ) ;
                 Param.TimeMin := TimerMin                       ;
                 Param.TimeSek := TimerSec                       ;
               End ;
         End ;


     JDate0 := JDate ;



       { Високосный ? }
       { ──────────── }
{
     PWisocY  := False ;
}
{
     Ws := ProgAuth [ 3 ] ;
     While (     ( Ws [ 1 ] < '0' )
             Or  ( Ws [ 1 ] > '9' )   )  Do
         Delete ( Ws , 1 , 1 ) ;
     Ws1 := Copy ( Ws , 1 , 2 ) ;
     Val ( Ws1, Id, Code ) ;
     Delete ( Ws , 1 , 2 ) ;
     While (     ( Ws [ 1 ] < '0' )
             Or  ( Ws [ 1 ] > '9' )   )  Do
         Delete ( Ws , 1 , 1 ) ;
     Ws1 := Copy ( Ws , 1 , 2 ) ;
     Val ( Ws1, Im, Code ) ;
     Delete ( Ws , 1 , 2 ) ;
     While (     ( Ws [ 1 ] < '0' )
             Or  ( Ws [ 1 ] > '9' )   )  Do
         Delete ( Ws , 1 , 1 ) ;
     Val ( Ws, IY, Code ) ;
     If ( Iy < 100 )  Then
        Iy := Iy + 100 ;
     JD8 ( IY, IM, ID, JdVisocReal ) ;
}
{
     If ( JdTimer2 - JdVisocReal ) >= JdVisocRealT
       Then PWisocY := True  ;
}

           { Эпоха pезультата }
           { ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄ }


     JD8 ( Param.OutYear, Param.OutMon, Param.OutDay, JdOut ) ;
    {───────────────────────────────────────────────────────}

     T := ( Param.OutH + Param.OutMin / C600 + Param.OutSek / C36000 )
                                                            /   24.0   ;
     JdOut := JdOut + T ;

     If ( Abs ( JdOut - J2000 ) < 3 )  Then
       JdOut := J2000 ;
     If ( Abs ( JdOut -  JD50 ) < 3 )  Then
       JdOut :=  JD50 ;




           { Эпоха элементов }
           { ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄ }


     JD8 ( Param.InputYear, Param.InputMon, Param.InputDay, JdEp ) ;
    {────────────────────────────────────────────────────────────}

     T := ( Param.InputH + Param.InputMin / C600 + Param.InputSek / C36000 )
                                                                  /   24.0  ;
     JdEp := JdEp + T ;

     JdEpSat := JdEp ;


     If ( Not B_Surf )  Then
        Begin  { SatELLIT }
               { ──────── }
          JdEp := JdOut ;
        End ;


     If ( Abs ( JdEp - J2000 ) < 3 )  Then
       JdEp := J2000 ;
     If ( Abs ( JdEp -  JD50 ) < 3 )  Then
       JdEp :=  JD50 ;


    If ( Param.NPolFix = 1 )
      Then  NPolFix :=  True
      Else  NPolFix :=  False ;

    If ( Param.NObj = 1 )
      Then  NPlOpt  :=  Param.NPlan
      Else  NPlOpt  :=  Param.NSat  ;

{
    CRoSunMax := Cos ( Param.RSun * GR ) ;
    CRoMonMax := Cos ( Param.RMon * GR ) ;
}


       { ПОЛЕ ЗРЕНИЯ }
       { ▄▄▄▄▄▄▄▄▄▄▄ }


    MvMax := Param.MvMax ;
    MvMax := Round ( Abs ( Param.MvMax ) * 1000.0 + 0.5 ) / 1000.0 ;
    If ( Param.MvMax < 0 )  Then
      MvMax := - MvMax ;

    MvFloat := True ;

    If ( MvMax <= 0 )  Then
      Begin
        MvFloat := False         ;
        MvMax   := Abs ( MvMax ) ;
      End ;

    MvMaxParam := MvMax ;
    MvMinParam := MvMin ;


    XOrient := Param.XOrient ;
    YOrient := Param.YOrient ;

    FldX   := Param.FldX * GR ;
    FldY   := Param.FldY * GR ;

        { FD из CCD }
        { ───────── }
    If ( B_Inport_Ccd )
      Then
        Begin

          If ( B_Parsek )
            Then
              Begin
                OptPars ( 1, ErrProcCcd ) ;
              End
            Else
              Begin
                OptCcd ( 1, ErrProcCcd ) ;
              End ;

        End
      Else
        Begin

          FldX   := Param.FldX * GR ;
          FldY   := Param.FldY * GR ;

        End ;


    XMax   := FD * Sin ( FldX / C20 ) / Cos ( FldX / C20 ) ;
    YMax   := FD * Sin ( FldY / C20 ) / Cos ( FldY / C20 ) ;

    LX     := XMax * C20 ;
    LY     := YMax * C20 ;

    XMaxGR := FldX / C20 / GR ;
    YMaxGR := FldY / C20 / GR ;

    DHMax  := FldY / C20 ;

    RRX    := Param.RRX * GR ;
    RRY    := Param.RRY * GR ;


    If ( RRX > FldX )  Then
      RRX := C20 * FldX ;

    If ( RRY > FldY )  Then
      RRY := C20 * FldY ;


    RRX    :=  RRX / 2 ;
    RRY    :=  RRY / 2 ;


    RoMax  := ArcTan  (  Sqrt (  Sqr ( XMax )  +  Sqr ( YMax )  ) / FD  ) ;

    CRoMax := Cos  ( RoMax ) ;
    SRoMax := Sin  ( RoMax ) ;

    DecCKr := R90 - RoMax ;


          { МАТРИЦА }
          { ▄▄▄▄▄▄▄ }

    {
    Pixel_X_MM   := Param.Pixel_X_Min  / C600 * GR * FD ;
    Pixel_Y_MM   := Param.Pixel_Y_Min  / C600 * GR * FD ;

    Period_X_MM  := Param.Period_X_Min / C600 * GR * FD ;
    Period_Y_MM  := Param.Period_Y_Min / C600 * GR * FD ;
    }
    {
    N_Pixel_X    := Param.N_Pixel_X ;
    N_Pixel_Y    := Param.N_Pixel_Y ;
    }
    {
    X_Max_Matrix := Period_X_MM * N_Pixel_X / C20 ;
    Y_Max_Matrix := Period_Y_MM * N_Pixel_Y / C20 ;
    }
    {
    PERXD2       := Period_X_MM / C20 ;
    PERYD2       := Period_Y_MM / C20 ;

    PIXXD2       := Pixel_X_MM  / C20 ;
    PIXYD2       := Pixel_Y_MM  / C20 ;
    }
    {
    N_Matrix := 0 ;
    }
    (*
    If ( B_Matrix )  Then
      Begin  { B_Matrix }

        CheckFile ( MatrixFileName ) ;
        If ( Not CatNotFound )  Then
          Begin


            FileMode := 0 ;

            Assign    ( MatrixFile  ,  MatrixFileName ) ;
            Reset     ( MatrixFile                    ) ;

            While ( Not Eof ( MatrixFILE ) )  Do
              Begin  { Not Eof ( MatrixFILE ) }

                ReadLn ( MatrixFILE , XS, YS ) ;

                N_Matrix := N_Matrix + 1 ;

                XS := XS / 60 * GR ;
                YS := YS / 60 * GR ;

                MatrixCenter [ N_Matrix ]. X :=  FD * Sin ( XS ) / Cos ( XS ) ;
                MatrixCenter [ N_Matrix ]. Y :=  FD * Sin ( YS ) / Cos ( YS ) ;

              End ;  { Not Eof ( MatrixFILE ) }

            Close  ( MatrixFILE ) ;

          End ;

      End ;  { B_Matrix }
      *)


        {  Шиpота и Долгота  }
        {  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄  }


    FiSAstron  := ( Param.LatG +
                    Param.LatM /   C600 +
                    Param.LatS / C36000   ) * GR ;
    If ( Param.LatSig = '-' ) Then
      FiSAstron := - FiSAstron ;

    SFiSAstron := Sin ( FiSAstron ) ;
    CFiSAstron := Cos ( FiSAstron ) ;

    LongSAstron  := ( Param.LongG +
                      Param.LongM /   C600 +
                      Param.LongS / C36000   ) * GR ;
    If ( Param.LongSig = '-' ) Then
       LongSAstron := - LongSAstron ;

    Alt := Param.Alt ;


        {  Азимут и Высота Оптической Оси  }
        {  ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄  }


    AOpt0  := ( Param.AG +
                Param.AM /   C600 +
                Param.AS / C36000   ) * GR ;
    If ( Param.ASig = '-' ) Then
      AOpt0 := - AOpt0 ;

    HOpt0  := ( Param.HG +
                Param.HM / C600 +
                Param.HS / C36000 ) * GR ;
    If ( Param.HSig = '-' ) Then
      HOpt0 := - HOpt0 ;

    DAOpt0 := Param.Ryskanie * GR ;
    DHOpt0 := Param.Tangag   * GR ;





        { Подготовка  DE200 }
        { ───────────────── }

    If Exist ( 'DE200.Dat' )  Then
      Begin  { Есть файл DE200.Dat }
             { ─────────────────── }

        FileMode := 0 ;

        Assign ( DE200File , 'DE200.Dat' ) ;
        Reset  ( DE200File               ) ;

        If (  MaxAvail-GraphBuffSize > SizeOf ( DE200 ) )
          Then
            Begin  { Памяти достаточно }
                   { ───────────────── }

              GetMem ( DE200Buf , SizeOf ( DE200 ) );

                 { Гpаничные даты в файле }
                 { ────────────────────── }

              Read ( DE200File , JdBegDE200 ) ;

              NRecDE200 :=       FileSize ( DE200File )
                           Div (   SizeOf ( DE200 ) Div  8 );

              JdEndDE200 := JdBegDE200 + 32 * NRecDE200 - 1 ;

            End    { Памяти достаточно }
                   { ───────────────── }
           Else

            Begin  { Памяти недостаточно }
                   { ─────────────────── }
              Close ( DE200File ) ;

            End ;  { Памяти недостаточно }
                   { ─────────────────── }

      End ;  { Есть файл DE200.Dat }
             { ─────────────────── }




            { ЗЛЕМЕНТЫ ОРБИТЫ ТЕЛЕСКОПА }
            { ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄ }


    NameSatObs := '' ;

    If ( Not B_ObserverNumSat )
      Then
        Begin  { Элементы Спутника из Паpаметpов }

          NPl0     := Param.NPl0 ;
          R_Planet := R_Planets [ NPl0 ] ;  { РАДИУС ЦЕНТРАЛЬНОЙ ПЛАНЕТЫ В KM }

          If ( Param.ElemFile Mod 4 = 3 )
            Then
              Begin { Satellits Orbite RectAngular }
                ElSatRectAng ;
              End
            Else
              Begin

                ISAT   := Param.ISAT   * GR ;
                OMG    := Param.OMG    * GR ;
                OML    := Param.OML    * GR ;
                ARGLAT := Param.ARGLAT * GR ;

                HAp    := Param.HAp  ;
                HPer   := Param.HPer ;

              End ;

          A0     := ( HAp + HPer ) /                C20 + R_PLANET   ;
          EKSC   := ( HAp - HPer ) / ( HAp + HPer + C20 * R_PLANET ) ;

          M0 := 0 ;

          SQRCalCons   := Sqrt   ( C10 - Sqr ( EKSC ) ) ;
          BETCalCons   := EKSC / ( C10 + SQRCalCons   ) ;
          BETSKCalCons := C10                           ;
          VCalCons     := ARGLAT - OML                  ;
          M0           := VCalCons                      ;

          For KCalCons := 1 To 24 Do
            Begin

              BETSKCalCons := BETSKCalCons * ( - BETCalCons ) ;

              M0 := M0 + C20 * ( SQRCalCons + C10 / KCalCons )
                             *   BETSKCalCons
                             *   Sin ( KCalCons * VCalCons ) ;
            End ;


        End    { Элементы Спутника из Паpаметpов }
      Else
        Begin  { Элементы Спутника по номеpу спутника }

          If ( ObserverNumSat >= 1 )  Then
            Begin

              If ( ObserverNumSat > MaxSatellits )  Then
                Fatal ( 'Number Satellit Telescops too Great');

              CheckFile ( SatElementFileName                 ) ;
              Reset     ( SatElemFile                        ) ;
              Seek      ( SatElemFile, ObserverNumSat - 1    ) ;
              Read      ( SatElemFile, SatElementRec         ) ;
              Close     ( SatElemFile                        ) ;

              CheckFile ( SatNameFileName                    ) ;
              Reset     ( SatNameFile                        ) ;
              Seek      ( SatNameFile, ObserverNumSat - 1    ) ;
              Read      ( SatNameFile, SatNameRec            ) ;
              Close     ( SatNameFile                        ) ;

              NameSatObs := SatNameRec.NameSat  ;
              JdEpSatObs := SatElementRec.T0    ;
              ISATObs    := SatElementRec.ISat  ;
              OMGObs     := SatElementRec.OmG   ;
              OMLObs     := SatElementRec.OmL   ;
              EkscObs    := SatElementRec.Eksc  ;
              M0Obs      := SatElementRec.M0    ;
              MotObs     := SatElementRec.Mot   ;
              Mot1Obs    := SatElementRec.Mot1  ;
              Mot2Obs    := SatElementRec.Mot2  ;
              BStarObs   := SatElementRec.BStar ;

              NPl0     := 3 ;
              R_Planet := R_Planets [ NPl0 ];{ РАДИУС ЦЕНТРАЛЬНОЙ ПЛАНЕТЫ В KM }

              PaRam.NPl0 := NPl0 ;

            End ;

        End ;  { Элементы Спутника по номеpу спутника }




      { OutParamConst }
      { ▄▄▄▄▄▄▄▄▄▄▄▄▄ }


    ParConst.HA     := HAp                  ;
    ParConst.HP     := HPer                 ;

    If ( B_Surf ) Then
      Begin
        ParConst.I    := FiSAstron    / GR  ;
        ParConst.OMG  := LongSAstron  / GR  ;
      End
     Else
      Begin
        ParConst.I    := ISAT  / GR  ;
        ParConst.OMG  := OMG   / GR  ;
      End ;

    ParConst.DAOPT  := Param.Ryskanie / GR  ;
    ParConst.WG     := 2 * XMaxGR           ;
    ParConst.HG     := 2 * YMaxGR           ;

    ParConst.PERX   := Param.Period_X_Min         ;
    ParConst.PERY   := Param.Period_Y_Min         ;
    ParConst.PIXX   := Param.Pixel_X_Min          ;
    ParConst.PIXY   := Param.Pixel_Y_Min          ;
    ParConst.NPX    := Param.N_Pixel_X            ;
    ParConst.NPY    := Param.N_Pixel_Y            ;


    If (      (  B_VectDiagr                                   )
         And  (  MaxAvail-GraphBuffSize > SizeOf ( PmVectArr ) )  )
      Then
        Begin  { Памяти достаточно }
               { ───────────────── }

          GetMem ( PmVect , SizeOf ( PmVectArr ) );

        End
      Else
        Begin
          B_VectDiagr := False ;
        End ;




          { Файлы Пpиоpитетов Каталогов }
          { ═══════════════════════════ }


    For I := 1 To CatIzoMax Do
      Begin
        BufNameCat [ I ] := '' ;
      End ;


    For I := 1 To CatIzoMax Do
      For J := 1 To Length ( NameCat [ I ] )  Do
        Begin
          BufNameCat [ I ] :=   BufNameCat [ I ]
                              + UpCase ( NameCat [ I, J ] ) ;
        End ;



    If Exist ( 'User.Ord' )  Then
      Begin  { Есть файл UserOrd.Dat }
             { ───────────────────── }


        FileMode := 0 ;

        Assign ( F, 'User.Ord' ) ;
        ReSet  ( F             ) ;

        FlagError := False ;
        IndBufOrd :=     0 ;
        IndSer    :=     0 ;

        For I := 1 To CatIzoMax Do
          BufOrd [ I ] := 0 ;

        While (     ( Not Eof ( F ) )
                And ( Not FlagError ) )  Do
          Begin

            ReadLn ( F, S ) ;

            While (     ( Length ( S ) > 0 )
                    And ( S [ 1 ] = ' '    )  )  Do
              Delete ( S, 1, 1 ) ;

            If ( Length ( S ) > 0 )
              Then
                Begin { Есть символы }

                  Inc ( IndSer ) ;

                  I := Pos ( ' ', S ) ;

                  If (    ( I > 5                    )
                       Or (     ( I            = 0 )
                            And ( Length ( S ) > 4 ) )  )
                    Then
                      Begin

                        FlagError := True ;
                        Str ( IndSer : 2, S ) ;

                        Fatal ( 'Error in '+ S + ' string file  User.Ord') ;

                        Repeat  Until  KeyPressed ;
                        Ch := GetCh ;

                      End
                    Else
                      Begin  { Выделяем имя каталога }
                        If ( I > 0 )  Then
                          S := Copy ( S, 1, I-1 ) ;
                      End ;




                  If ( Not FlagError ) Then
                    Begin { Not FlagError }

                     { Пеpеводим имя в большие буквы }
                     { ───────────────────────────── }
                      For I := 1 To Length ( S )  Do
                        S [ I ] := UpCase ( S [ I ] ) ;


                      N := 0 ;
                      For I := 1 To CatIzoMax Do
                        Begin

                          If ( S = BufNameCat [ I ] )  Then
                            Begin
                              N := I ;
                              Inc ( IndBufOrd ) ;
                              BufOrd [ IndBufOrd ] := I ;
                            End ;


                        End ;

                      If ( N = 0 )  Then
                        Begin

                          FlagError := True ;

                          Fatal (   'Catalog '
                                  +  S
                                  + ' (in User.Ord) not exist in SimFOV') ;

                          Repeat  Until  KeyPressed ;
                          Ch := GetCh ;

                        End ;

                    End ; { Not FlagError }



                End   { Есть символы }
              Else
                Begin { Пустая стpока }
                End ; { Пустая стpока }

          End ; { Not Eof ( F ) }


        Close  ( F ) ;


        { Пеpенос в массив PrioritetIzo }
        { ───────────────────────────── }

        If ( Not FlagError )  Then
          Begin  { Not FlagError }

            For I := 1 To CatIzoMax Do
              Begin

                J := PrioritetIzo [ I ] ;
                N := 0 ;

                For K := 1 To CatIzoMax Do
                  Begin
                    If ( J = BufOrd [ K ] )  Then
                      N := K ; { Name Found }
                  End ;

                If ( N = 0 )  Then
                  Begin  { Name Not Found }
                    Inc ( IndBufOrd ) ;
                    BufOrd [ IndBufOrd ] := J ;
                  End ;

              End ;


            For I := 1 To CatIzoMax Do
              PrioritetIzo [ I ] := BufOrd [ I ] ;

          End ;  { Not FlagError }



      End ;  { Есть файл OrdDet.Dat }
             { ──────────────────── }

     FileMode := 2 ;


   End ;  { CalCons }

  End.

