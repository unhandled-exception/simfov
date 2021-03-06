
{$O+,F+}


UNIT PDetCcd ;


   {  ��������������  CCD-��������  �  ����  ������  }
   {  ���������������������������������������������  }


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

          {  ����� ������H��� ��'����  }
          {  ------------------------  }

    For IndImp := IImpBeg  To  IImpEnd  Do
     Begin  { IndImp }
            { ------ }

      CObjectImp := Objectptr [ IndImp Div ObjectBlockSize ]^
                              [ IndImp Mod ObjectBlockSize ] ;

      NumImp := CObjectImp . NRecC Mod 1000000000 ;
      CObjectImp.Date := 0 ;


      If ( NumImp > 0 )  Then
      Begin  { Imp ������ }
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
        Begin { �p�ᬮ�p� ��⠫���� }
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

               Begin  { ��⠫�� ���� }
                      { ------------ }

                 If ( CatRep = CatCdc )  Then
                   PMCdcDetExist := False ;


                 IRepEnd := IndCat [ CatRep ]. NEnd ;

                 NDetRep := 0 ; { ��᫮ �⮦�. �� ⥪�饬� ��⠫��� }
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



                   { ����  ���p��� ��ꥪ⮢ ����� �⮦���⢫塞�� }
                   { --------------------------------------------- }

                 If ( Not CExit ) Then
                 IndRep := I1 ;


                 While (     ( Not  CExit        )
                         And ( IndRep <= IRepEnd )  )    Do

                   Begin  { �p�ᬮ�p� ⥪�饣� ��⠫��� }
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

                            Begin  { ����p��� ������ � �p� }
                                   { ---------------------- }

                              If (     ( CatRep = CatCdc )
                                   And ( NDetRep > 0     )  )  Then
                                Begin  { ������ �� }

                                  If (     ( PmCdcNewExist = False )
                                       And ( PmCdcDetExist = True  ) )  Then
                                      { ��⠢�塞 AK � P.M. }
                                     R := RFind * C20 ;

                                  If (     ( PmCdcNewExist = True  )
                                       And ( PmCdcDetExist = False ) )  Then
                                    Begin  { �����塞 �� �����⢥���� �⮦�.
                                             �� ��⠫��� �� � P.M. }
                                      RFind   := R * C20 ;
                                      NDetRep := 0       ;
                                    End ;

                                End ;  { ������ �� }



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


                              Inc ( NDetRep ) ; { N �⮦�. ⥪. ���. }
                                                { ------------------ }
                              ImpDet := True ;  { �p� �� �⮦�. }
                                                { ---------------- }

                            End ;  { ����p��� ������ � �p� }
                                   { ---------------------- }

                       End ;  { Not CExit }
                              { -------- }

                     Inc ( IndRep ) ;

                   End ;  { �p�ᬮ�p� ⥪�饣� ��⠫��� }
                          { --------------------------- }


                   { ��⠭���� 梥� ����p⭮� }
                   { ------------------------- }

                 If ( NDetRep <> 1 )  Then
                     Begin  { N �⮦�. �� 1 }
                            { ------------- }

                        If ( NDetRep > 1 )  Then

                           Begin  { ������p�⭮� �⮦�. }
                                  { ------------------- }

                              ImpDet := False ; { �p� �� ������p. �⮦�. }
                                                { ------------------------- }

                              CObjectImp.Sp := 40 ; { ����� }
                                                    { ------ }
                              Objectptr [ IndImp Div ObjectBlockSize ]^
                                        [ IndImp Mod ObjectBlockSize ] :=
                                          CObjectImp ;
                           End ;

                     End

                   Else

                     Begin

                       { �⮦�. �����⢥���� : ��p� 梥� }
                       { -------------------------------- }

                       CObjectImp. Sp   := 70        ;
                       CObjectImp. Date := IndRepDet ;

                       Objectptr [ IndImp Div ObjectBlockSize ]^
                                 [ IndImp Mod ObjectBlockSize ] :=
                                   CObjectImp ;

                     End ;


                        { ������ �⮦���⢫���� }
                        { --------------------- }

                   If ( NDetRep > 0 )  Then
                     Begin

                       EndDet := True ;


                     End ;  { ����� �⮦���⢫���� }
                            { --------------------- }

               End ;  { ��⠫�� ���� }
                      { ------------ }

          End ; { CatRep }
                { ------ }

        End ; { �p�ᬮ�p� ��⠫���� }
              { ------------------- }


          { �⮦�. �� �뫮 ��� ������p�⭮� �� ��� ��⠫��� }
          { -------------------------------------------------- }

        If ( ImpDet = False )  Then
             B_Menu := True ;



      End ;  { Imp ������ }
             { ---------- }


    End ;  { IndImp }
           { ------ }

    RecalcObjects ;


  End ;  { PRO DetStar }

End.
