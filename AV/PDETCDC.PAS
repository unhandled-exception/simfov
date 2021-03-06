
{$O+,F+}


UNIT PDetCdc ;


   {  �⮦���⢫����  Cdc  c  Gsc  }
   {  ***************************  }


INTERFACE

     Procedure  DetCdc ( CatDet : Byte ) ;

IMPLEMENTATION


USES

  SHELL_X ,
  PVAR    ,
  V_Catal  ;


     Procedure  DetCdc ( CatDet : Byte ) ;


VAR


  CExit, CdcDet            : BOOLEAN ;

  NDetGsc, SpCdc          : Byte    ;

  NDetCdc   ,
  IndGscDet ,
  IndCdc , IndGsc  ,
  ICdcBeg, ICdcEnd ,
  IGscBeg, IGscEnd ,
  IId    , IIm     ,
  IRd    , IRm     ,
  I, I1, I2               : LongInt ;

  NumCdc , NumGsc         : Longint ;

  R0, R, ROld             : Double    ;
  XMin, XMax              : Double    ;
  DMv, MvCdc, DMvDetCdc   : Double    ;
  MvGsc , MvGscDet        : Double    ;
  X0 , Y0                 : Double    ;
  X  , Y                  : Double    ;




  Begin { PRO DetStar }



    ICdcBeg := IndCat [ CatCdc ] . NBeg ;
    ICdcEnd := IndCat [ CatCdc ] . NEnd ;

    IGscBeg := IndCat [ CatDet ] . NBeg ;
    IGscEnd := IndCat [ CatDet ] . NEnd ;

    R0 := IndCat [ CatDet ].RoDet / SekRad * FD ; { R0 , MM }
                                                  { ------- }

    DMvDetCdc := DMvDet ;
(*
    If ( CatDet = CatCdcMoz )
       Then  DMvDetCdc := 20.0     { ��� ������� �p���p塞 ���� p����� }
       Else  DMvDetCdc := DMvDet ;
*)
    If ( CatSort [ CatCdc ] = False ) Then
       Begin
          SHELLX ( ICdcBeg , ICdcEnd ) ;
          CatSort [ CatCdc ] := True ;
       End ;

    If ( CatSort [ CatDet ] = False ) Then
       Begin
          SHELLX ( IGscBeg , IGscEnd ) ;
          CatSort [ CatDet ] := True ;
       End ;


          {  ���� Cdc  }
          {  ---------  }


    NDetCdc := 0 ;

    For IndCdc := ICdcBeg  TO  ICdcEnd  DO

     Begin  { IndCdc }
            { ------ }


      IId := IndCdc Div ObjectBlockSize ;
      IIm := IndCdc Mod ObjectBlockSize ;

      NumCdc := Objectptr [ IId ]^[ IIm ] . NRecC Mod 1000000000 ;

      SpCdc := Objectptr [ IId ]^[ IIm ].Sp ;

      CdcDet  := True ;

 { *****************************************************
      If  ( ( NumCdc > 0 ) And ( SpCdc = 11 ) )  Then
   ***************************************************** }

      If  ( NumCdc > 0 )  Then

      Begin  { Cdc ������ }
             { ---------- }


        X0 := Objectptr [ IId ]^[ IIm ] . X;
        Y0 := Objectptr [ IId ]^[ IIm ] . Y;

        MvCdc := Objectptr [ IId ]^[ IIm ] . M / 10 - 5 ;

        CdcDet := False ;



        NDetGsc := 0 ; { ��᫮ �⮦�. �� Gsc }
                       { ------------------- }

        XMin   := X0 - R0    ;
        XMax   := X0 + R0    ;



              { FInd Ind. Gsc }
              { ------------- }

        I1 := IGscBeg  ;
        I2 := IGscEnd  ;


        While ( (I2-I1) > 1 ) DO

          Begin  { I2-I1 > 1 }

            I :=  ( I1 + I2 )  Div  2 ;

            X := Objectptr [ I div ObjectBlockSize ]^
                           [ I mod ObjectBlockSize ].X;

            If  ( X <= XMin )
              Then
                I1 := I
              Else
                I2 := I ;

          End ; { I2-I1 > 1 }


        CExit :=  False ;



           { ����  Gsc ����� Cdc  }
           { --------------------- }

        ROld := 1000.0 ;
        IndGsc :=  I1 - 1 ;

        While (     ( NOT  CExit        )
                And ( IndGsc < IGscEnd )  )    Do

           Begin  { �p�ᬮ�p� Gsc }
                  { ------------- }

             IndGsc := IndGsc + 1 ;

             IRd := IndGsc Div ObjectBlockSize ;
             IRM := IndGsc Mod ObjectBlockSize ;

             X := Objectptr [ IRd ]^[ IRM ] . X;

             CExit := X > XMax ;

             If ( Not CExit )  Then

               Begin  { NOT CExit }

                 Y := Objectptr [ IRd ]^[ IRM ] . Y;

                 R := SQRT ( ( X - X0 ) * ( X - X0 ) +
                             ( Y - Y0 ) * ( Y - Y0 ) ) ;


                 MvGsc := Objectptr [ IRd ] ^ [ IRM ].M / 10 - 5 ;
                 DMv   := MvCdc - MvGsc ;


                 If (      ( R           <= R0        )
                       And ( Abs ( DMv ) <= DMvDetCdc )  )  Then

                    Begin  { Gsc ������ � �p� }
                           { ----------------- }

                      If ( R < ROld )  Then
                        Begin
                          IndGscDet := IndGsc ;
                          MvGscDet  := MvGsc  ;
                          ROld      := R      ;
                        End ;


                      NDetGsc := NDetGsc + 1 ; { N �⮦�. ⥪. ���. }
                                               { ------------------ }
                      CdcDet  := True ; { �p� ������ �⮦�. Cdc }
                                        { --------------------- }
                    End ;  { Gsc ������ � �p� }
                           { ----------------- }

               End ;  { NOT CExit }
                      { -------- }

           End ;  { �p�ᬮ�p� Gsc }
                  { ------------- }


                   { ��⠭���� 梥� Cdc }
                   { ------------------- }

         If  ( NDetGsc > 0 )  Then
           Begin  { N �⮦�. �� 0 }
                    { ------------- }

             If ( CatDet = CatGsc )  Then
              Begin { Gsc }

                   { ���� �⮦���⢫����� Gsc }
                   { ------------------------ }

                IRd := IndGscDet Div ObjectBlockSize ;
                IRM := IndGscDet Mod ObjectBlockSize ;

                SpCdc := Objectptr [ IRd ]^[ IRm ].Sp ;

                If ( SpCdc Mod 10 = 0 )
                   Then
                     Begin
                       If ( NDetGsc > 1 )
                         Then  SpCdc := SpCdc Mod 10 + 50 { ������ -> �p��� }
                         Else  SpCdc := SpCdc Mod 10 + 40;{ ������ -> �����  }
                     End
                   Else
                     Begin
                       If ( NDetGsc > 1 )
                         Then  SpCdc := SpCdc Mod 10 + 51 { H� ������ -> �p��� }
                         Else  SpCdc := SpCdc Mod 10 + 41;{ H� ������ -> �����  }
                     End ;

                Objectptr [ IRd ]^[ IRm ].Sp := SpCdc ;

              End ; { Gsc }


             NDetCdc := NDetCdc + 1 ;

                     { �p��� ����� �⮦���⢫����� AC }
                     { ------------------------------ }

             SpCdc := Objectptr [ IId ]^[ IIm ].Sp ;

             SpCdc := SpCdc Mod 10 + 70            ;  { ��p� }
                                                      { ----- }
             Objectptr [ IId ]^[ IIm ].Sp := SpCdc ;


           End ;  { N �⮦�. �� 0 }
                    { ------------- }

      End ;  { Cdc ������ }
             { ---------- }

    End ;  { IndCdc }
           { ------ }

    IndCat [ CatCdc ] . NDet := NDetCdc ;


  End ;  { PRO DetStar }


End.
