{$O+,F+}

 Unit POptCcd ;

{
  ��᫮ � ��������� ������ ��p�� �� ��p���祭�.
  �� ��� ��p����, �p��� ���p��樨 � ���ᥫ��, ᫮�� ��p�� �᫠��
� ��᫥ �ᥫ �p���᪠����. �p���᪠���� ⠪�� � ��p���, �� ᮤ�p��騥
�� ����� ��p�.
  ����⢥��� ��p���p� ��p�� 'XStand' � 'YStand': ������ �p�����⢮����
���� '=' � �� ����� �㪢� 'R' ��� 'C' �� ���. �� �⨬ �㪢�� ����������
���p�� �p���p�������� ��p�� � �⮫�殢 � ������� ( �⠭��p�� )
���p������, �.�. �p������ ����p�⥫��� �ᥩ ���p����� �� ����.
  � ��p���� ���p��樨 � ���ᥫ�� �p��쨬 ��p����p�� ����� ��������
������p� ����p������. �᫨ ������p� �� ������ - �� ��ꥪ�� ����p�������
�� ��p��� �p㦪��� ���������� p����p��.
  �� p����p� �������� � �������p��.
  � �⮬ ���� ����� �������� ⠪�� � p������� ����p���� �⮯���⨭��
�� ����p�⥫��� �p���p��. �����p� 蠣�� �� ��� � �⮬ ��砥 ������
����稭� ������ ����p���� � �������p��. �� ��p�� ���p��樨 �� ����p�����
���p������ �롨p����� ���� �p� ��p��� �᫠. � ��砥 �ᯮ�짮�����
'p����' ����p���� ����稭 ������p�� ����� �� ����. � �⮬ ��砥 ��᫥
���� ���祭�� ���p����� ������ �p�����⢮���� �� �p����� ��p� ���� �p����,
� ���� ';', 㪠�뢠�騩 �� ������⢨� ������ � ������p��. �p��� �p��
����稭 � ��p���� ����� ᮤ�p������ � ���� ���p����, �� ��� �p� p����
�⮩ �p��p���� ����p�p����.


  ��p���p� ���p��樨 � ���p�� ( ��� ����p���� ���p������ ) :
  ������������������������������������������������������������

F           44.49

StepRow      0.023
StepCol      0.027
StepDiam     0.001       ����� ��������� ������p�.
                         �������� p�ᮢ���� 25 ����⮢

DNumbRow   187           ��᫮ ���ᥫ�� �� 業�p� �� �p�� ���p���
DNumbCol   121           ��᫮ ���ᥫ�� �� 業�p� �� �p�� ���p���

OptCRow    188
OptCCol    121.5

XStand = - Row           ����� ����祭�� ��. ���p������ 'X'
YStand = - Col           ����� ����祭�� ��. ���p������ 'Y'

RedModelType    1        1 - 6 ����., 2 - 9 ����: 1 + ���. �. + ����p��
MaxError       60        ���ᨬ��쭮 �����⨬�� �訡�� � ᥪ. �㣨

DateObs     25 09 1995

R.A. Opt.C  20 16 30
Decl.Opt.C  37 52 24

Equinox.Opt.C   1950


  Row    Col
  36.0   53.0
  85.0   50.0
  85.0  147.0
 129.0  151.0
 129.0  105.0
 149.0   91.0
 155.0   12.0

}


   InterFace


   Uses   Dos, PVAR, V_CATAL, PJD8 ;



	  Procedure OptCcd (     Regime : Byte    ;
                             Var Res    : Boolean   ) ;


   Implementation


	  Procedure OptCcd (     Regime : Byte   ;{ 0 - ���� FD
                                                    1 - FD + ��� � ����
                                                    2 - ��� ���p� + EndProc
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
  A           : Array [ 1 .. 3 ]  Of  Double  ;


    Function ReadStr : Boolean ;
            {�������}
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

        For I := 1 To Length ( S )  Do
          Begin
            If ( S [ I ] <> ' ' )  Then
              Begin
                Pusto   := False ;
                S [ I ] := UpCase ( S [ I ] ) ;
              End ;
          End ;



        If ( Not Pusto )  Then
          Begin  { �������� �������� ������p��� }
                 { ����������������������������� }
            CExit := False ;
            While (     ( Not CExit        )
                    And ( Length ( S ) > 0 )  )  Do
              Begin

                If (    (     (     ( S [ 1 ] >= 'A' )
                                And ( S [ 1 ] <= 'Z' )  )
                          And ( S [ 1 ] <> '='          )  )
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

          { �뤥����� �ᥫ }
          { ��������������� }

          A [ 1 ] := 0.0 ;
          A [ 2 ] := 0.0 ;
          A [ 3 ] := 0.0 ;
          Ch      := ' ' ;

          If ( S [ 1 ] <> '=' )  Then
            Begin

              For I := 1 To 3  Do
                If (     ( Length ( S )  >  0 )
                     And ( S [ 1 ]      <> ';')  )  Then
                  Begin

                       { ��p����� �᫮ }
                       { ��������������� }
                    S2 := '' ;
                    While (     ( S [ 1 ] <> ' '   )
                            And ( Length ( S ) > 0 ) )  Do
                      Begin
                        S2 := S2 + S [ 1 ] ;
                        Delete ( S, 1, 1 ) ;
                      End ;

                    If (     (      I   = 1   )
                         And ( S2 [ 1 ] = '-' )  )  Then
                      Begin
                        Ch := S2 [ 1 ] ;
                        Delete ( S2, 1, 1 ) ;
                      End ;

                    { �������� �p������ ��p�� ᫥���騬 �᫮� }
                    { ���������������������������������������� }
                    While (     ( S [ 1 ] = ' '    )
                            And ( Length ( S ) > 0 ) )  Do
                      Begin
                        Delete ( S, 1, 1 ) ;
                      End ;

                          { ��᫮ }
                          { ����� }
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

            End ; { �뤥����� �ᥫ }
                  { ��������������� }


        End ;

  End ; { ReadStr }
        { ������� }




 Begin

   ErrProcCcd   := False ;
   CcdDiamExist := False ;

   ARow := 0.0 ;
   BCol := 0.0 ;
   CRow := 0.0 ;
   DCol := 0.0 ;


   FileMode := 0 ;

   ReSet   ( ObjectFile ) ;

   If ( Regime > 1 )  Then
     Begin
       Assign  ( ImportCcdFile, 'Ccd.Fld' ) ;
       ReWrite ( ImportCcdFile            ) ;
     End ;

   If (     ( ReadStr  )
        And ( NDat = 1 )  )
     Then
       Begin
         FD := A [ 1 ] ;
         If ( Regime = 0 )  Then
           Begin
             GoTo ErrCcd ;
           End ;
       End
     Else
       Begin
         GoTo ErrCcd ;
       End ;


   If (     ( ReadStr  )
        And ( NDat = 1 )  )
     Then
       Begin
         StepRow := A [ 1 ] ;
       End
     Else
       Begin
         GoTo ErrCcd ;
       End ;


   If (     ( ReadStr  )
        And ( NDat = 1 )  )
     Then
       Begin
         StepCol := A [ 1 ] ;
       End
     Else
       Begin
         GoTo ErrCcd ;
       End ;


   If (     ( ReadStr  )
        And ( NDat = 1 )  )
     Then
       Begin
         StepDiamCcd := A [ 1 ] ;
         If ( Ch = '-' ) Then
           StepDiamCcd := - StepDiamCcd ;
       End
     Else
       Begin
         GoTo ErrCcd ;
       End ;


   If (     ( ReadStr  )
        And ( NDat = 1 )  )
     Then
       Begin
         DNRow := Round ( A [ 1 ] ) ;
       End
     Else
       Begin
         GoTo ErrCcd ;
       End ;


   If (     ( ReadStr  )
        And ( NDat = 1 )  )
     Then
       Begin
         DNCol := Round ( A [ 1 ] ) ;
       End
     Else
       Begin
         GoTo ErrCcd ;
       End ;


   If (     ( ReadStr  )
        And ( NDat = 1 )  )
     Then
       Begin
         OcRow := A [ 1 ] ;
       End
     Else
       Begin
         GoTo ErrCcd ;
       End ;


   If (     ( ReadStr  )
        And ( NDat = 1 )  )
     Then
       Begin
         OcCol := A [ 1 ] ;
       End
     Else
       Begin
         GoTo ErrCcd ;
       End ;


   If  ( ReadStr  )
     Then
       Begin
         If ( Pos ( 'R', S ) <> 0 )
           Then
             Begin
               ARow := C10 ;
               BCol := 0.0 ;
               If ( Pos ( '-', S ) <> 0 )  Then
                 ARow := - C10 ;
             End
           Else
             Begin
               ARow := 0.0 ;
               BCol := C10 ;
               If ( Pos ( '-', S ) <> 0 )  Then
                 BCol := - C10 ;
             End ;
       End
     Else
       Begin
         GoTo ErrCcd ;
       End ;


   If  ( ReadStr  )
     Then
       Begin
         If ( Pos ( 'R', S ) <> 0 )
           Then
             Begin
               CRow := C10 ;
               DCol := 0.0 ;
               If ( Pos ( '-', S ) <> 0 )  Then
                 CRow := - C10 ;
             End
           Else
             Begin
               CRow := 0.0 ;
               DCol := C10 ;
               If ( Pos ( '-', S ) <> 0 )  Then
                 DCol := - C10 ;
             End ;
       End
     Else
       Begin
         GoTo ErrCcd ;
       End ;


   If (     ( ReadStr  )
        And ( NDat = 1 )  )
     Then
       Begin
         RedModelType := Round ( A [ 1 ] ) ;
       End
     Else
       Begin
         GoTo ErrCcd ;
       End ;



   If (     ( ReadStr  )
        And ( NDat = 1 )  )
     Then
       Begin
         ErrorMaxDet := A [ 1 ] ;
       End
     Else
       Begin
         GoTo ErrCcd ;
       End ;



   If (     ( ReadStr  )
        And ( NDat = 3 )  )
     Then
       Begin
         Day   := Round ( A [ 1 ] ) ;
         Month := Round ( A [ 2 ] ) ;
         Year  := Round ( A [ 3 ] ) ;
         Jd8 ( Year, Month, Day, JDate ) ;
       End
     Else
       Begin
         GoTo ErrCcd ;
       End ;


   If (     ( ReadStr  )
        And ( NDat = 3 )  )
     Then
       Begin
         Grad := Round ( A [ 1 ] ) ;
         Min  := Round ( A [ 2 ] ) ;
         Sek  :=         A [ 3 ]   ;

         RaOpt := ( Grad * C36000 + Min * C600 + Sek )
                      / SekRad * 15.0 ;
       End
     Else
       Begin
         GoTo ErrCcd ;
       End ;


   If (     ( ReadStr  )
        And ( NDat = 3 )  )
     Then
       Begin
         Grad := Round ( A [ 1 ] ) ;
         Min  := Round ( A [ 2 ] ) ;
         Sek  :=         A [ 3 ]   ;

         DeclOpt := ( Grad * C36000 + Min * C600 + Sek )
                      / SekRad  ;
         If ( Ch = '-' )  Then
           DeclOpt := - DeclOpt ;

       End
     Else
       Begin
         GoTo ErrCcd ;
       End ;


   If (     ( ReadStr  )
        And ( NDat = 1 )  )
     Then
       Begin
         Day   := 1 ;
         Month := 1 ;
         Year  := Round ( A [ 1 ] ) ;
         Jd8 ( Year, Month, Day, JdEp ) ;

         If ( Regime = 1 )  Then
           Begin

             FldX := DnRow * StepRow ;
             FldY := DnCol * StepCol ;
             If ( FldX > FldY )
               Then  FldY := FldX
               Else  FldX := FldY ;

             FldX := 2.0 * ArcTan ( FldX / FD ) ;
             FldX := FldX * 1.4 ;  { ��� ��������� �訡�� �.�. }
                                   { �������������������������� }
             FldY := FldX ;

             GoTo ErrCcd ;

           End ;
       End
     Else
       Begin
         GoTo ErrCcd ;
       End ;



        { ���ᥫ� }
        { ������� }

   While (     ( ReadStr  )
           And ( NDat >= 2 )  )  Do
     Begin

       If ( NDat = 3 )  Then
         CcdDiamExist := True ;

       Row  := ( A [ 1 ] - OcRow ) * StepRow ;   { In mm.      }
       Col  := ( A [ 2 ] - OcCol ) * StepCol ;   { In mm.      }
       Diam :=   A [ 3 ]                     ;

       CcdRecord.X    := Row * ARow + Col * BCol ; { H� H��� � mm. ��� �-�� }
       CcdRecord.Y    := Row * CRow + Col * DCol ; { H� H��� � mm. ��� �-�� }
       CcdRecord.Diam := Diam                    ;

       Write ( ImportCcdFile, CCdRecord ) ;

     End ;


  ErrCcd :

    If ( Regime = 2 )  Then
      EndProc := True ;


    FileMode := 2 ;


 End ;

End.