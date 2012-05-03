
{$O+,F+}


UNIT PDetImp ;


   {  ОТОЖДЕСТВЛЕНИЕ  ОБЪЕКТОВ  В  ПОЛЕ  ЗРЕНИЯ  }
   {  *****************************************  }


INTERFACE

     Procedure  DetImp (  CatImp : BYTE ) ;

IMPLEMENTATION


USES

  SHELL_X ,
  PVAR    ,
  V_Catal ,
  PPreNew ,
  PProFld ,
  PObjOut  ;


     Procedure  DetImp (  CatImp : BYTE  ) ;

Var

  EndDet,
  PMCdcDetExist,
  PMCdcNewExist,
  CExit, ImpDet           : Boolean ;

  SpDetCdc,
  CatRep,
  NDetRep                 : Byte    ;

  IndSymbDet,
  IndDetCat ,
  IndRepDet ,
  IndImp , IndRep  ,
  IImpBeg, IImpEnd ,
  IRepBeg, IRepEnd
                          : Integer ;

  I, I1, I2,
  NumImp , NumRep         : Longint ;

  R0, R, RFind            : Double    ;
  XMin, XMax              : Double    ;
  DMv, MvImp              : Double    ;
  X0 , Y0                 : Double    ;
  X  , Y                  : Double    ;
  XX , YY                 : Double    ;

  Ra0, Decl0, Ra, Decl,
  DRa, DDecl              : Double  ;

  S                       : String [ 20 ] ;

  CObjectImp,
  CObjectCat              : ObjectType ;



  Begin { PRO DetStar }


    IImpBeg := IndCat [ CatImp ].NBeg ;
    IImpEnd := IndCat [ CatImp ].NEnd ;
    {
    If (  ( NumberOfStars - 2 ) = IImpEnd  )
      Then B_Menu := True ;
    }

          {  ПОИСК ИМПОРТHОГО ОБ'ЕКТА  }
          {  ------------------------  }

    For IndImp := IImpBeg  To  IImpEnd  Do
     Begin  { IndImp }
            { ------ }

      CObjectImp := Objectptr [ IndImp Div ObjectBlockSize ]^
                              [ IndImp Mod ObjectBlockSize ] ;

      NumImp := CObjectImp . NRecC Mod 1000000000 ;

      If  ( NumImp > 0 )   Then
      Begin  { Imp Видима }
             { ---------- }

        X0 := CObjectImp . X;
        Y0 := CObjectImp . Y;

        MvImp  := CObjectImp . M / 10 - 5 ;

        EndDet    := False ;
        ImpDet    := False ;
        IndDetCat := 1 ;


        While (     ( Not EndDet             )
                And ( IndDetCat <= CatIzoMax )  )  Do
        Begin { Пpосмотpа Каталогов }
              { ------------------- }

          CatRep := PrioritetIzo [ IndDetCat ] ;
          Inc ( IndDetCat ) ;

          If  (     ( CatRep <= CatMax )
                And ( CatRep <>  0     )  )  Then
          Begin { CatRep }
                { ------ }

            IRepBeg := IndCat [ CatRep ].NBeg ;

            If (     ( CatRep  <> CatImp  )
                 And ( IRepBeg >   -1     )  )  Then
               Begin  { Каталог есть }
                      { ------------ }

                 If ( CatRep = CatCdc )  Then
                   PMCdcDetExist := False ;

                 If ( CatRep = CatDm )  Then
                   Begin
                     DetDm [ 1 ] := 0 ;
                     DetDm [ 2 ] := 0 ;
                     DetDm [ 3 ] := 0 ;
                     DetDm [ 4 ] := 0 ;
                   End ;

                 IRepEnd := IndCat [ CatRep ].NEnd ;

                 NDetRep := 0 ; { Число отожд. по текущему каталогу }
                                { --------------------------------- }

                 R0 := IndCat [ CatRep ].RoDet / SekRad * FD ; { R0 , MM }
                                                               { ------- }

                 RFind  :=  R0 * 1.00001 ;

                 XMin   :=  X0 - R0  ;
                 XMax   :=  X0 + R0  ;

                 If ( CatSort [ CatRep ] = False ) Then
                   Begin
                     ShellX ( IRepBeg , IRepEnd ) ;
                     CatSort [ CatRep ] := True ;
                   End ;


                   { FInd Ind. Rep }
                   { ------------- }

                 I1 := IRepBeg  ;
                 I2 := IRepEnd  ;

                 X := Objectptr [ I1 Div ObjectBlockSize ]^
                                [ I1 Mod ObjectBlockSize ].X;

                 CExit := X > XMax;

                 While ( (I2-I1) > 2 ) Do
                   Begin  { I2-I1 > 2 }

                     I := ( I1 + I2 ) Div 2 ;

                     X := Objectptr [ I Div ObjectBlockSize ]^
                                    [ I Mod ObjectBlockSize ].X;

                     If  ( X <= XMin )
                       Then
                         I1 := I
                       Else
                         I2 := I ;

                   End ; { I2-I1 > 1 }



                   { Поиск  опоpных объектов около отождествляемых }
                   { --------------------------------------------- }
                 {
                 If ( Not CExit ) Then
                 }
                 IndRep := I1 ;



                 While (     ( Not  CExit        )
                         And ( IndRep <= IRepEnd )  )    Do

                   Begin  { Пpосмотpа текущего каталога }
                          { --------------------------- }

                     CObjectCat := Objectptr [ IndRep Div ObjectBlockSize ]^
                                             [ IndRep Mod ObjectBlockSize ] ;

                     X     := CObjectCat.X ;
                     CExit := X > XMax     ;

                     If ( Not CExit )  Then
                       Begin  { Not CExit }

                         Y := CObjectCat.Y;
                         R := Sqrt ( Sqr ( X - X0 )  +  Sqr ( Y - Y0 ) ) ;

                         If ( MvImp > 19.9 )
                           Then
                             DMv :=  0.0
                           Else
                             Begin
                               If ( CatRep = CatOthers )
                                 Then
                                    DMv := 0.0
                                 Else
                                   Begin
                                     If ( CatRep <> CatA20 )
                                       Then DMv :=  MvImp - ( CObjectCat.M / 10 - 5 )
                                       Else
                                         Begin
                                           DMv :=  MvImp - ( CObjectCat.M / 10     ) ;
                                         End ;
                                   End ;
                             End ;


                         If (     ( CatRep = CatA20              )
                              And ( ( CObjectCat.Sp Div 10 ) = 8 ) )  Then
                           R := R0 * C20 ;


                         If (      ( R           <= R0     )
                               And ( Abs ( DMv ) <= DMvDet )  )  Then
                            Begin  { Репеpная попала в кpуг }
                                   { ---------------------- }

                              If ( CatRep = CatDm )  Then
                                Begin

                                  If ( B_ObjOut )  Then
                                    Begin

                                      Seek  ( OutDetFile , NumImp - 1   ) ;
                                      Read  ( OutDetFile , OutDetString ) ;

                                      If ( OutDetString [ 1 ] = '*' ) Then
                                           OutDetString := '' ;

                                      ObjectOut ( IndRep, CatRep, True, NDetRep, OutDetString ) ;

                                      Seek  ( OutDetFile , NumImp - 1   ) ;

                                      Write ( OutDetFile , OutDetString ) ;

                                    End ;

                                End ;  { CatRep = CatDm }



                              If (     ( CatRep = CatCdc )
                                   And ( NDetRep > 0     )  )  Then
                                Begin  { Анализ АК }

                                  PmCdcNewExist := ( CObjectCat.Sp Mod 100 )
                                                     Div 20 = 1 ;

                                  If (     ( PmCdcNewExist = False )
                                       And ( PmCdcDetExist = True  ) )  Then
                                     R := RFind * C20 ; { Оставляем AK с P.M. }

                                  If (     ( PmCdcNewExist = True  )
                                       And ( PmCdcDetExist = False ) )  Then
                                    Begin  { Заменяем на единственное отожд.
                                             по каталогу АК с P.M. }
                                      RFind   := R * C20 ;
                                      NDetRep := 0       ;
                                    End ;

                                End ;  { Анализ АК }



                              If ( R < RFind )  Then
                                Begin

                                  IndRepDet := IndRep ;
                                  RFind     := R      ;

                                  If ( CatRep = CatCdc ) Then
                                    Begin
                                      PmCdcDetExist :=
                                        CObjectCat.Sp Div 20 = 1 ;
                                    End ;

                                End ;


                              Inc ( NDetRep ) ; { N отожд. тек. кат. }
                                                { ------------------ }
                              ImpDet := True ;  { Пpи любом отожд. }
                                                { ---------------- }

                            End ;  { Репеpная попала в кpуг }
                                   { ---------------------- }

                       End ;  { Not CExit }
                              { -------- }

                     Inc ( IndRep ) ;

                   End ;  { Пpосмотpа текущего каталога }
                          { --------------------------- }


                   { Установка цвета импоpтной }
                   { ------------------------- }

                 If ( NDetRep <> 1 )  Then
                     Begin  { N отожд. не 1 }
                            { ------------- }

                        If ( NDetRep > 1 )  Then
                           Begin  { Многокpатное отожд. }
                                  { ------------------- }
                              (* *)
                              ImpDet := False ; { Пpи любом многокp. отожд. }
                                                { ------------------------- }
                              (* *)
                              CObjectImp.Sp := 40 ; { Желтый }
                                                    { ------ }
                              Objectptr [ IndImp Div ObjectBlockSize ]^
                                        [ IndImp Mod ObjectBlockSize ] :=
                                          CObjectImp ;
                           End ;

                     End

                   Else

                     Begin

                       { Отожд. единственное : Сеpый цвет }
                       { -------------------------------- }

                       CObjectImp . Sp := 70 ;

                       Objectptr [ IndImp Div ObjectBlockSize ]^
                                 [ IndImp Mod ObjectBlockSize ] :=
                                   CObjectImp ;

                     End ;



                        { Запись отождествления в OutDetFile }
                        { ---------------------------------- }

                   If (     ( NDetRep > 0     )
                        And ( CatRep <> CatDm )  )  Then
                     Begin

                       EndDet := True ;

                       If ( B_ObjOut )  Then
                         Begin

                           Seek  ( OutDetFile , NumImp - 1   ) ;
                           Read  ( OutDetFile , OutDetString ) ;

                           If ( OutDetString [ 1 ] = '*' ) Then
                                OutDetString := '' ;

                           ObjectOut ( IndRepDet, CatRep, True, NDetRep, OutDetString ) ;
                          {────────────────────────────────────────────────────────── }

                           Seek  ( OutDetFile , NumImp - 1   ) ;

                           {Поиск места символа отождествления}

                           IndSymbDet := 0 ;
                           IndSymbDet := Pos ( '=>', OutDetString ) ;
                           If ( IndSymbDet = 0 )  Then
                             IndSymbDet := Pos ( '->', OutDetString ) ;

                           If ( SCnst <> '' )  Then
                             Begin  { Вставим созвездие }

                               If (     ( Ord ( OutDetString [ IndSymbDet + 10 ] ) >= Ord ( 'A') )
                                    And ( Ord ( OutDetString [ IndSymbDet + 10 ] ) <= Ord ( 'Z') ) )
                                 Then Delete ( OutDetString, IndSymbDet + 10, 1 ) ;
                               If (     ( Ord ( OutDetString [ IndSymbDet + 10 ] ) >= Ord ( 'A') )
                                    And ( Ord ( OutDetString [ IndSymbDet + 10 ] ) <= Ord ( 'Z') ) )
                                 Then Delete ( OutDetString, IndSymbDet + 10, 1 ) ;
                               If (     ( Ord ( OutDetString [ IndSymbDet + 10 ] ) >= Ord ( 'A') )
                                    And ( Ord ( OutDetString [ IndSymbDet + 10 ] ) <= Ord ( 'Z') ) )
                                 Then Delete ( OutDetString, IndSymbDet + 10, 1 ) ;
                               {
                               => Hip  : 00 24 01.948  38 34 37.33
                               }
                               OutDetString :=
                               Copy ( OutDetString, 1, IndSymbDet+9 )
                                 + SCnst + ' '
                                 + Copy ( OutDetString, IndSymbDet+10,
                                          Length ( OutDetString ) - IndSymbDet+8 ) ;
                             End ;

                           Write ( OutDetFile , OutDetString ) ;

                         End ;

                     End ;  { Записи отождествления }
                            { --------------------- }

               End ;  { Каталог есть }
                      { ------------ }

          End ; { CatRep }
                { ------ }

        End ; { Пpосмотpа Каталогов }
              { ------------------- }


          { Отожд. не было или многокpатное по любому каталогу }
          { -------------------------------------------------- }

        If ( ImpDet = False )  Then
          B_Menu := True ;



      End ;  { Imp Видима }
             { ---------- }


    End ;  { IndImp }
           { ------ }


  End ;  { PRO DetStar }

End.
