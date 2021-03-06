
{$O+,F+}


UNIT PDelDet ;


   {  ��������  ���������������  ��������  ��  ����  ������  }
   {  *****************************************************  }


INTERFACE

     Procedure DelDet (  CatImp : BYTE ;  ROkr : Double    { ArcSec } ) ;

IMPLEMENTATION


USES

  SHELL_X ,
  PVAR    ,
  DATA    ;


     Procedure DelDet (  CatImp : BYTE ;  ROkr : Double    { ArcSec } ) ;


VAR

  CExit, ImpDet            : BOOLEAN ;

  CatRep                  : BYTE    ;
  NDetRep                 : Byte    ;

  IndImp , IndRep  ,
  IImpBeg, IImpEnd ,
  IRepBeg, IRepEnd ,
  IId    , IIm     ,
  IRd    , IRm     ,
  I, I1, I2               : INTEGER ;

  NumImp , NumRep         : Longint ;
  R0, R                   : Double    ;
  XMin, XMax              : Double    ;
  X0 , Y0                 : Double    ;
  X  , Y                  : Double    ;



  Begin { PRO IDSTARS }

    R0      := ROkr / SekRad * FD ;   {  R0  ,  MM  }
                                      { ----------- }

    IImpBeg := IndCat [ CatImp ] . NBeg ;
    IImpEnd := IndCat [ CatImp ] . NEnd ;

    If ( CatSort [ CatImp ] = False ) Then
      Begin
        SHELLX ( IImpBeg , IImpEnd ) ;
        CatSort [ CatImp ] := True ;
      End ;


          {  ����� ������H��� ��'����  }
          {  ------------------------  }


    For IndImp := IImpBeg  TO  IImpEnd  DO

      Begin  { IndImp }
             { ------ }


        IId := IndImp Div ObjectBlockSize ;
        IIm := IndImp Mod ObjectBlockSize ;

        NumImp := Objectptr [ IId ]^[ IIm ] . NRecCat ;

        X0 := Objectptr [ IId ]^[ IIm ] . X;
        Y0 := Objectptr [ IId ]^[ IIm ] . Y;


        XMin   := X0 - R0    ;
        XMax   := X0 + R0    ;

        ImpDet := False ;

        For  CatRep := 1  To  CatMax  Do
          Begin { CatRep }
                { ------ }

            IRepBeg := IndCat [ CatRep ] . NBeg ;

            If (     ( CatRep  <> CatImp )
                 And ( IRepBeg <> -1    )  )  Then

               Begin  { ��⠫�� ���� }
                      { ------------ }

                 NDetRep := 0 ; { ��᫮ �⮦�. �� ⥪�饬� ��⠫��� }
                                { --------------------------------- }

                 IRepEnd := IndCat [ CatRep ] . NEnd ;

                 If ( CatSort [ CatRep ] = False ) Then
                   Begin
                     SHELLX ( IRepBeg , IRepEnd ) ;
                     CatSort [ CatRef ] := True ;
                   End ;




                   { FInd Ind. Rep }
                   { ------------- }

                 I1 := IRepBeg  ;
                 I2 := IRepEnd  ;


                 While ( (I2-I1) > 1 ) DO

                   Begin  { I2-I1 > 1 }

                     I :=  ( I1 + I2 )  Div  2 ;

                     X := Objectptr [ I div ObjectBlockSize ]^
                                    [ I mod ObjectBlockSize ].X;

                     If  ( X <= XMin )  Then
                         I1 := I
                       Else
                         I2 := I ;

                   End ; { I2-I1 > 1 }


                 CExit :=  False ;



                   { ����  ���p��� ��ꥪ⮢ ����� �⮦���⢫塞��  }
                   { ---------------------------------------------- }

                 IndRep :=  I1 - 1 ;

                 While (     ( NOT  CExit        )
                         And ( IndRep < IRepEnd )  )    Do

                   Begin  { �p�ᬮ�p� ⥪�饣� ��⠫��� }
                          { --------------------------- }

                     IndRep := IndRep + 1 ;

                     IRd := IndRep Div ObjectBlockSize ;
                     IRM := IndRep Mod ObjectBlockSize ;

                     X := Objectptr [ IRd ]^[ IRM ] . X;

                     CExit := X > XMax ;

                     If ( Not CExit )  Then

                       Begin  { NOT CExit }

                         Y := Objectptr [ IRd ]^[ IRM ] . Y;

                         R := SQRT ( ( X - X0 ) * ( X - X0 ) +
                                     ( Y - Y0 ) * ( Y - Y0 ) ) ;

                         If ( R <= R0 )  Then

                            Begin  { ����p��� ������ � �p� }
                                   { ---------------------- }

                              NDetRep := NDetRep + 1 ; { N �⮦�. ⥪. ���. }
                                                       { ------------------ }
                              ImpDet  := True ; { �p� ������ �⮦�. Imp }
                                                { --------------------- }
                            End ;  { ����p��� ������ � �p� }
                                   { ---------------------- }

                       End ;  { NOT CExit }
                              { -------- }

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

                              Objectptr [ IId ]^[ IIm ].Sp := 40 ; { ����� }
                                                                   { ------ }
                           End ;

                     End

                   Else

                     Begin

                       { �⮦�. �����⢥���� : ��p� 梥� }
                       { -------------------------------- }

                       Objectptr [ IId ]^[ IIm ] . Sp := 70 ;

                     End ;

               End ;  { ��⠫�� ���� }
                      { ------------ }


          End ; { CatRep }
                { ------ }


          { �⮦�. �� �뫮 ��� ������p�⭮� �� ��� ��⠫��� }
          { -------------------------------------------------- }

        If ( ImpDet = False )  Then  B_Menu := True ;



      End ;  { IndImp }
             { ------ }


  End ;  { PRO  DelRep }

End.
