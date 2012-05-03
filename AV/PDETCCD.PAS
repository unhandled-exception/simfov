
{$O+,F+}


UNIT PDetCcd ;


   {  ОТОЖДЕСТВЛЕНИЕ  CCD-ОБЪЕКТОВ  В  ПОЛЕ  ЗРЕНИЯ  }
   {  ─────────────────────────────────────────────  }


INTERFACE

     Procedure  DetCcd ;

IMPLEMENTATION


USES

  SHELL_X ,
  PVAR    ,
  V_Catal ,
  PPreNew ,
  PProFld ,
  PObjOut  ;


     Procedure  DetCcd ;

Var

  EndDet,
  StarGood,
  PMCdcDetExist,
  PMCdcNewExist,
  CExit, ImpDet           : Boolean ;

  SpDetCdc,
  CatRep,
  NDetRep                 : Byte    ;

  IndDetCat ,
  IndRepDet ,
  IndImp , IndRep  ,
  IImpBeg, IImpEnd ,
  IRepBeg, IRepEnd ,
  IRd    , IRm            : Integer ;

  I, I1, I2,
  NumImp , NumRep         : Longint ;

  R0, R, RFind,
  XMin, XMax,
  DMv, MvImp,
  XImp, YImp,
  X0, Y0,
  X  , Y ,
  XX , YY                 : Double  ;

  Ra0, Decl0, Ra, Decl,
  DRa, DDecl              : Double  ;

  CObjectImp,
  CObjectCat              : ObjectType ;



  Begin { PRO DetStar }


    ResetObjects ;

    IImpBeg := IndCat [ CatImp ]. NBeg ;
    IImpEnd := IndCat [ CatImp ]. NEnd ;
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
      CObjectImp.Date := 0 ;


      If ( NumImp > 0 )  Then
      Begin  { Imp Видима }
             { ---------- }

        XImp := CObjectImp.X ;
        YImp := CObjectImp.Y ;

        X0 :=   XImp * AxImp
              + YImp * BxImp
              +        CxImp
              + Sqr ( XImp ) * DImp
              + XImp * YImp  * EImp
              + XImp * ( Sqr ( XImp ) + Sqr ( YImp ) )  *  DistImp  ;

        Y0 :=   XImp * AyImp
              + YImp * ByImp
              +        CyImp
              + XImp * YImp  * DImp
              + Sqr ( YImp ) * EImp
              + YImp * ( Sqr ( XImp ) + Sqr ( YImp ) )  *  DistImp ;


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
                And ( CatRep <> 0      )  )  Then
          Begin { CatRep }
                { ------ }

            IRepBeg := IndCat [ CatRep ] . NBeg ;

            If (     ( CatRep  <> CatDm      )
                 And ( CatRep  <> CatHD      )
                 And ( CatRep  <> CatGcvs    )
                 And ( CatRep  <> CatImp     )
                 And ( IRepBeg >   -1        )  )  Then

               Begin  { Каталог есть }
                      { ------------ }

                 If ( CatRep = CatCdc )  Then
                   PMCdcDetExist := False ;


                 IRepEnd := IndCat [ CatRep ]. NEnd ;

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

                 While ( (I2-I1) > 1 ) Do

                   Begin  { I2-I1 > 1 }

                     I :=  ( I1 + I2 )  Div  2 ;

                     X := Objectptr [ I Div ObjectBlockSize ]^
                                    [ I Mod ObjectBlockSize ].X;

                     If  ( X <= XMin )  Then
                         I1 := I
                       Else
                         I2 := I ;

                   End ; { I2-I1 > 1 }



                   { Поиск  опоpных объектов около отождествляемых }
                   { --------------------------------------------- }

                 If ( Not CExit ) Then
                 IndRep := I1 ;


                 While (     ( Not  CExit        )
                         And ( IndRep <= IRepEnd )  )    Do

                   Begin  { Пpосмотpа текущего каталога }
                          { --------------------------- }

                     IRd := IndRep Div ObjectBlockSize ;
                     IRm := IndRep Mod ObjectBlockSize ;

                     CObjectCat := Objectptr [ IndRep Div ObjectBlockSize ]^
                                             [ IndRep Mod ObjectBlockSize ] ;

                     X := CObjectCat.X;
                     CExit := X > XMax ;

                     StarGood := True ;

                     If ( CatRep = CatCdc )  Then
                       Begin

                         PmCdcNewExist := ( CObjectCat.Sp Mod 100 )
                                            Div 20 = 1 ;

                         If (     ( ErrorMaxDet  < 10.0 )
                              And ( Not PmCdcNewExist   ) )
                           Then  StarGood := False ;

                       End ;


                     If (     ( StarGood  )
                          And ( Not CExit )  )  Then
                       Begin  { Not CExit }

                         Y := CObjectCat.Y;

                         R := SQRT ( Sqr ( X - X0 )  +  Sqr ( Y - Y0 ) ) ;

                         If ( R <= R0 )  Then

                            Begin  { Репеpная попала в кpуг }
                                   { ---------------------- }

                              If (     ( CatRep = CatCdc )
                                   And ( NDetRep > 0     )  )  Then
                                Begin  { Анализ АК }

                                  If (     ( PmCdcNewExist = False )
                                       And ( PmCdcDetExist = True  ) )  Then
                                      { Оставляем AK с P.M. }
                                     R := RFind * C20 ;

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

                              ImpDet := False ; { Пpи любом многокp. отожд. }
                                                { ------------------------- }

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

                       CObjectImp. Sp   := 70        ;
                       CObjectImp. Date := IndRepDet ;

                       Objectptr [ IndImp Div ObjectBlockSize ]^
                                 [ IndImp Mod ObjectBlockSize ] :=
                                   CObjectImp ;

                     End ;


                        { Запись отождествления }
                        { --------------------- }

                   If ( NDetRep > 0 )  Then
                     Begin

                       EndDet := True ;


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

    RecalcObjects ;


  End ;  { PRO DetStar }

End.
