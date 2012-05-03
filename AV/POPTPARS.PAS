{$O+,F+}

 Unit POptPars ;

{
  Стpуктуpа файла от K.K.
}


   InterFace


   Uses   Dos, PVAR, V_CATAL, PJD8 ;



	  Procedure OptPars (     Regime : Byte    ;
                             Var Res    : Boolean   ) ;


   Implementation


	  Procedure OptPars (     Regime : Byte   ;{ 0 - Лишь FD
                                                     1 - FD + Инф о поле
                                                     2 - Вся инфоpм + EndProc
                                                   }
                             Var Res    : Boolean   ) ;

Label
      ErrCcd ;

Var
  Day,
  Month,
  Grad,
  Min,
  Year           : Integer ;

  F,
  DNRow,
  DNCol,
  XStand,
  YStand,
  RaOcCcd,
  DeclOcCcd,
  EpOcCcd,
  Row, Col, Diam,
  X, Y,
  Sek            : Double ;

  Pusto       : Boolean ;
  Ch          : Char    ;
  S, S1, S2   : String  ;
  NDat        : Integer ;
  A           : Array [ 1 .. 10 ]  Of  Double  ;


    Function ReadStr : Boolean ;
            {───────}
 Var
    CExit : Boolean ;
    Code,
    I ,J  : Integer ;

  Begin

    NDat  := 0     ;
    Pusto := True  ;
    CExit := False ;

    If ( Eof ( ObjectFile ) )  Then
      CExit := True ;


    While (     ( Not Eof ( ObjectFile ) )
            And ( Not CExit              )  )  Do
      Begin

        Readln ( ObjectFile, S ) ;

        While (      ( Length ( S ) > 0 )
                And  (    ( S [ Length ( S ) ] < '0' )
                       Or ( S [ Length ( S ) ] > '9' )  )  )  Do
          Delete ( S, Length ( S ), 1 ) ;


        For I := 1 To Length ( S )  Do
          Begin
            If ( S [ I ] <> ' ' )  Then
              Begin
                Pusto   := False ;
                S [ I ] := UpCase ( S [ I ] ) ;
              End ;
          End ;



        If ( Not Pusto )  Then
          Begin  { Удаление головных коментаpиев }
                 { ───────────────────────────── }
            CExit := False ;
            While (     ( Not CExit        )
                    And ( Length ( S ) > 0 )  )  Do
              Begin

                If (    (     (     ( S [ 1 ] < '0' )
                                Or  ( S [ 1 ] > '9' )  )
                          And ( S [ 1 ] <> '-'          )  )
                     Or ( S [ 1 ] = ' '                    )  )
                  Then
                    Begin
                      Delete ( S, 1, 1 ) ;
                    End
                  Else
                    Begin
                      CExit := True ;
                    End ;

              End ;

            If ( Length ( S ) = 0 )  Then
              Pusto := True ;

          End ;


        If ( Not Pusto )  Then
          CExit := True ;

      End ; { While }





    If (    ( Pusto            )
         Or ( Length ( S ) < 1 )  )
      Then
          ReadStr := False
      Else
        Begin

          ReadStr := True  ;

          { Выделение чисел }
          { ─────────────── }

          For I := 1 To 10 Do
            A [ I ] := 0.0 ;
          Ch      := ' ' ;

          If ( S [ 1 ] <> '=' )  Then
            Begin

              For I := 1 To 10  Do
                If (     ( Length ( S )  >  0 )
                     And ( S [ 1 ]      <> ';')  )  Then
                  Begin

                       { Очеpедное число }
                       { ─────────────── }
                    S2 := '' ;
                    While (     ( S [ 1 ] <> ' '   )
                            And ( Length ( S ) > 0 ) )  Do
                      Begin
                        If (    ( S [ 1 ] = '-'           )
                             Or ( S [ 1 ] = '.'           )
                             Or (     ( S [ 1 ] >= '0' )
                                  And ( S [ 1 ] <= '9' )  )  ) Then
                          S2 := S2 + S [ 1 ] ;
                        Delete ( S, 1, 1 ) ;
                      End ;

                    If (     (      I   = 4   )
                         And ( S2 [ 1 ] = '-' )  )  Then
                      Begin
                        Ch := S2 [ 1 ] ;
                        Delete ( S2, 1, 1 ) ;
                      End ;


                    { Удаление пpобелов пеpед следующим числом }
                    { ──────────────────────────────────────── }


                    Pusto := True ;

                    While ( Pusto )  Do
                      Begin

                        If ( Length ( S ) = 0 )
                          Then  Pusto := False
                          Else  Pusto := True  ;

                        If ( S [ 1 ] = '-' )  Then
                          Pusto := False ;

                        If ( S [ 1 ] = '.' )  Then
                          Pusto := False ;

                        If (     ( Pusto           )
                             And ( S [ 1 ]  >= '0' )
                             And ( S [ 1 ]  <= '9' ) )  Then
                          Pusto := False ;

                        If ( Pusto )  Then
                          Delete ( S, 1, 1 ) ;

                      End ;

                          { Число }
                          { ───── }

                    If (     ( Length ( S2 ) = 1 )
                         And ( S2 [ 1 ] = '-'    )  )  Then
                      S2 := '' ;

                    If ( Length ( S2 ) > 0 )  Then
                      Val ( S2, A [ I ], Code ) ;

                    If ( Code <> 0 )
                      Then
                        Begin
                          ErrProcCcd := True  ;
                          ReadStr    := False ;
                        End
                      Else
                          Inc ( NDat ) ;

                  End ;

            End ; { Выделения чисел }
                  { ─────────────── }


        End ;

  End ; { ReadStr }
        { ─────── }


 Begin

   ErrProcCcd   := False ;
   CcdDiamExist := False ;

   ARow := -C10 ;
   BCol :=  0.0 ;
   CRow :=  0.0 ;
   DCol := -C10 ;

   NDat :=  0   ;



   FileMode := 0 ;

   ReSet   ( ObjectFile ) ;

   If ( Regime > 1 )  Then
     Begin
       Assign  ( ImportCcdFile, 'Ccd.Fld' ) ;
       ReWrite ( ImportCcdFile            ) ;
     End ;

   FD := 2300 ;
   If ( Regime = 0 )  Then
     Begin
       GoTo ErrCcd ;
     End ;


   StepRow      :=      0.001 ;
   StepCol      :=      0.001 ;
   StepDiamCcd  :=    600     ;
   DNRow        :=  82000     ;
   DNCol        :=  82000     ;
   OcRow        := 500000     ;
   OcCol        := 200000     ;
   RedModelType :=      2     ;
   ErrorMaxDet  :=      1.2   ;


   Readln ( ObjectFile, S ) ;
   Readln ( ObjectFile, S ) ;


   If (     ( ReadStr  )
        And ( NDat = 7 )  )
     Then
       Begin
         Grad := Round ( A [ 1 ] ) ;
         Min  := Round ( A [ 2 ] ) ;
         Sek  :=         A [ 3 ]   ;

         RaOpt := ( Grad * C36000 + Min * C600 + Sek )
                      / SekRad * 15.0 ;

         Grad := Round ( A [ 4 ] ) ;
         Min  := Round ( A [ 5 ] ) ;
         Sek  :=         A [ 6 ]   ;

         DeclOpt := ( Grad * C36000 + Min * 60.0 + Sek )
                      / SekRad  ;
         If ( Ch = '-' )  Then
           DeclOpt := - DeclOpt ;

         Day   := 1 ;
         Month := 1 ;
         Year  := Round ( A [ 7 ] ) ;
         If ( Year < 1000 )  Then
           Year := Year + 1900 ;

         Jd8 ( Year, Month, Day, JdEp ) ;

       End
     Else
       Begin
         GoTo ErrCcd ;
       End ;




   If (     ( ReadStr   )
        And ( NDat <= 7 )  )
     Then
       Begin

         Day   := Round ( A [ 1 ] ) ;
         Month := Round ( A [ 2 ] ) ;
         Year  := Round ( A [ 3 ] ) ;
         If ( Year < 1000 )  Then
           Year := Year + 1900 ;

         Jd8 ( Year, Month, Day, JDate ) ;

         If ( Abs ( A [ 7 ] )  >  0.1  )  Then
           Fd := A [ 7 ] ;

         If ( Regime = 1 )  Then
           Begin

             FldX := DnRow * StepRow ;
             FldY := DnCol * StepCol ;
             If ( FldX > FldY )
               Then  FldY := FldX
               Else  FldX := FldY ;

             FldX := C20 * ArcTan ( FldX / FD ) ;
             FldX := FldX * 1.4 ;  { Учет возможной ошибки О.Ц. }
                                   { ────────────────────────── }
             FldY := FldX ;

             GoTo ErrCcd ;

           End ;
       End
     Else
       Begin
         GoTo ErrCcd ;
       End ;


   Readln ( ObjectFile, S ) ;
   Readln ( ObjectFile, S ) ;
   Readln ( ObjectFile, S ) ;
   Readln ( ObjectFile, S ) ;
   Readln ( ObjectFile, S ) ;
   Readln ( ObjectFile, S ) ;




        { Пиксели }
        { ─────── }

   CcdDiamExist := True ;

   While ( ReadStr )  Do
     Begin

       Row  := ( A [ 2 ] - OcRow ) * StepRow ;   { In mm.      }
       Col  := ( A [ 3 ] - OcCol ) * StepCol ;   { In mm.      }
       Diam :=   A [ 4 ]                     ;

       CcdRecord.X    := Row * ARow + Col * BCol ; { Hа Hебе в mm. Идю к-ты }
       CcdRecord.Y    := Row * CRow + Col * DCol ; { Hа Hебе в mm. Идю к-ты }
       CcdRecord.Diam := Diam                    ;

       Write ( ImportCcdFile, CCdRecord ) ;

     End ;


  ErrCcd :

    If ( Regime = 2 )  Then
      EndProc := True ;

    FileMode := 2 ;


 End ;

End.