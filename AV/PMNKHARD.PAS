
{$O+,F+}


 Unit  PMnkHard ;
{

                     � 㤠������ ��p��� �p�������
                     ����������������������������


   ���ᮡ ��������� ����p�⮢ ��� �������� ��⥬� � 䠩�� �pאַ�� ����㯠;
   ������������������������������������������������������������������������

                 �室�� ��p����p�:
                 �����������������
      NEq  - �᫮ �p�������, �p���塞�� � p�襭��,
      NVar - �᫮ ����������,
      SM - ���p�� ��⥬�. �p������� ������ p�ᯮ�������� � ������p���
           ���ᨢ� SM ��p��� �� ��p����, ������ �p������� ������ ᮤ�p-
           ���� NVar + 1 �ᥫ. ��᫥���� �� ��� - ᢮����� 童� � ⥬
           ������, ���p� �� ����� � �p���� ��� �p�������,
      XMnk1 - ���ᨢ, ᮤ�p��騩 �p������ ����祭�� ������� �⮫�� (�������
          �������⭮��) � p�襭��. ��� I-��� �⮫�� ������ ���� XMnk1(I)=1,
          �᫨ �������⭮� ����砥��� � p�襭��, � XMnk1(I)=0, �᫨ ���.
          �p��������: ����� �᪫���� ���������, �� ����� ��⥬�,
      Epsmax - ���ᨬ��쭮� ����᪠���� ����筮� 㪫������. �p�������
        ��p����뢠���� �� ������ �� �� ��p, ���� ���ᨬ��쭮� 㪫���-
        ��� �� �⠭�� ����� Epsmax. �᫨ ��p������ �� �㦭�, ��������
        Epsmax = 0. �p��������: �᪫�祭�� �p��� �訡��, �᫨ �筮���
        ��室��� ������ �p������⥫쭮 �����⭠,
      Idef - ���ᨢ, ᮤ�p��騩 �p������ ����祭�� ������� �p������� �
        p�襭��. �p������� � ����p�� I ����砥��� � p�襭��, �����
        Idef(I) = 0. ��p�� ��p�饭��� � �p�楤�p� �p�᢮���
        Idef(1 : NEq) = 0. �p��������: ����� �᪫���� I-�� �p�������,
        ������� Idef(I) = 1.

              ��室�� ��p����p�:
              ������������������
      XMnk1 - ���ᨢ ����������, XMnk1 ᮤ�p��� ���祭�� ����������,
        XMnk1 ( NVar + 1) � XMnk1 ( NVar + 2) - �������쭮� � ���ᨬ��쭮� ���-
        ��� 㪫������ ᮮ⢥��⢥���,
      OX - ���ᨢ �訡�� ����������. OX ( NVar + 1) ᮤ�p��� �p�����
         ����p������ �訡�� ������� ���,
      V - ���ᨢ ������� 㪫������. �᫨ �p������� ��p�������, ���-
        ᨢ ᮤ�p��� � ����筮� 㪫������, ���p�� ����稫��� � ��-
        ᫥���� 蠣� p�襭��, � ���p�� �� �p������� ���⢮����,
      HS - ����p��樮���� ���p�� ����������,
      Imax - ����p �p�������, ����饣� �������襥 ����筮� 㪫������,
      Idef - ���ᨢ, ᮤ�p��騩 �p������ ��p��������� �p�������. �᫨
          I-�� �p������� ��p�������, Idef(I) ᮤ�p��� ���㫥��� 楫��,
          �᫨ �p������� ��諮 � p�襭��, Idef(I) = 0,
      Isolve - �᫨ p�襭�� ����p訫��� ��㤠筮, Isolve = 0,
          ���� Isolve = 1,
      NVarTrue - �᫮ ����������, ����祭��� � p�襭�� � ᮮ⢥��⢨� �
          ��砫�� �������� ��p��� NVar ���祭�� � ���ᨢ� XMnk1,
      NEqTrue - �᫮ �p�������, ��⠢���� ��᫥ ��p������, �.�. ��襤-
          �� � p�襭��. ����� ��� �㫥��� ������⮢ � ���ᨢ� Idef,
      Idef - �᫨ Idef(I) = 0, � I-�� �p������� ��諮 � p�襭��, ����
          �᪫�祭� �p� ��p������ ��� �� ��p�饭�� � �p�楤�p�.
             �p���砭��:
       - ���ᨢ� XMnk1, OX ������ ����� ����� �� ����� NVar + 3,
       - 楫�ᮮ�p���� ��⠭����� �㦭�� ����� ���ᨢ�� � ᮮ⢥��⢨�
         � ���ᨬ���� �������� �᫮� ���������� � �p�������,
       - �᫨ 楫� ������ ���� ���� �� p��p������, �������� ���ᠭ��
         Integer*1 �� Integer*2 ��� Integer.
      ���p���p�: ����p�� ��p�饭�� ���p��� �����⢮��� �� �����:
      ������ᮭ, �����, ��p���筨� ����p�⬮� �� �몥 �����, 1976,
      ��p. 53, �p�楤�p� Gidef1.

      ���p �p��p���� - �.�.�㨬��, 1975 - 1991 �.�.
      ����������������������������������������������
}

 Interface


     Procedure Mnk1 (        RedModelType : Byte      ;
                             Epsmax       : Double    ;
                      Var    Isolve       : Integer   ;
                      Var  NEqTrue        : Integer   ;
                      Var      MQE        : Double    ;
                      Var    AxMnk,
                             BxMnk,
                             CxMnk,
                             AyMnk,
                             ByMnk,
                             CyMnk,
                              DMnk,
                              EMnk,
                           DistMnk
                               : Double
                    ) ;


 Implementation

 Uses PProFld, PVar, V_Catal ;


     Procedure Mnk1 (        RedModelType : Byte      ;
                             Epsmax       : Double    ;
                      Var    Isolve       : Integer   ;
                      Var  NEqTrue        : Integer   ;
                      Var      MQE        : Double    ;
                      Var    AxMnk,
                             BxMnk,
                             CxMnk,
                             AyMnk,
                             ByMnk,
                             CyMnk,
                              DMnk,
                              EMnk,
                           DistMnk
                               : Double
                    ) ;

    Label 666, 777 ;


 Const

        NVar        =  9 ;
        NDelMax     =  2 ;

 Type

   SmRecType = Array  [ 0 .. NVar                ] Of Single  ;

   D13Mnk1   = Array  [ 1 ..          NVar + 3   ] Of Double  ;
   HsMnk1    = Array  [ 1 .. NVar ,   1 .. NVar  ] Of Double  ;
   XmMnk1    = Array  [ 1 ..          NVar + 1   ] Of Double  ;
   IDeffMnk1 = Array  [ 1 ..          NVar + 1   ] Of Integer ;

   IDefType = Record
                IDef : ShortInt ;
              End ;

  Var

    NDel,
    Ind      : LongInt  ;

    SvX, SvY : Double   ;

    XMnk1,
    OX       : D13Mnk1  ;
    HS       : HsMnk1   ;
    CM       : HsMnk1   ;

    XM       : Array [ 1 .. NVar + 1 ]  Of   Double  ;
    XF       : Array [ 1 .. NVar + 1 ]  Of   Double  ;
    NS       : Array [ 1 .. NVar + 2 ,  1 .. NVar + 2 ] Of Double  ;

    SmRec    : SmRecType ;
    VRec     : Integer   ;
    IDefRec  : IDefType  ;

    SmFile   : File Of SmRecType ;
    VFile    : File Of Integer   ;
    IDefFile : File Of IDefType  ;

    IDeff                       : IdeffMnk1 ;
    IDeffInp                    : IdeffMnk1 ;

    DelEq                       : Boolean   ;

    NEq,
    Imax,
    NVarTrue,
    I, J, K, L,
    M1, M2,
    II, JJ, Ik,
    MTrue1, MTrue2              : LongInt   ;

    SSS, NSig,
    C, CC, Epsm,
    S, SS, F, FF, P, Q          : Double    ;


   Procedure SysMake ; { �p�楤�p� ᮧ����� ��⥬� �p������� ���짮��⥫� }

 Var
     Ind, IndSm         : LongInt ;
     XImp, YImp,
     XCat, YCat         : Double  ;

     CObjectImp,
     CObjectCat  : ObjectType ;

     Begin

       ResetObjects ;

       For Ind := IndCat [ CatImp ].NBeg  To IndCat [ CatImp ].NEnd  Do
         Begin

           If ( ObjectPtr [ Ind Div ObjectBlockSize]^
                          [ Ind Mod ObjectBlockSize].Date > 0 )  Then
             Begin

               CObjectImp := ObjectPtr [ Ind Div ObjectBlockSize]^
                                       [ Ind Mod ObjectBlockSize]  ;
               CObjectCat := ObjectPtr [ CObjectImp.Date Div ObjectBlockSize]^
                                       [ CObjectImp.Date Mod ObjectBlockSize];

               XImp := CObjectImp.X ;
               YImp := CObjectImp.Y ;

               XCat := CObjectCat.X ;
               YCat := CObjectCat.Y ;


               SmRec [ 0 ] := C10  ;
               SmRec [ 1 ] := XImp ;
               SmRec [ 2 ] := YImp ;
               SmRec [ 3 ] := 0.0  ;
               SmRec [ 4 ] := 0.0  ;
               SmRec [ 5 ] := 0.0  ;
               SmRec [ 6 ] :=  Sqr ( XImp ) ;
               SmRec [ 7 ] := XImp * YImp   ;
               SmRec [ 8 ] := XImp * ( Sqr ( XImp ) + Sqr ( YImp ) ) ;
               SmRec [ 9 ] := XCat ;

               Inc   ( NEq ) ;
               Write ( SmFile, SmRec ) ;

               SmRec [ 0 ] := 0.0  ;
               SmRec [ 1 ] := 0.0  ;
               SmRec [ 2 ] := 0.0  ;
               SmRec [ 3 ] := C10  ;
               SmRec [ 4 ] := XImp ;
               SmRec [ 5 ] := YImp ;
               SmRec [ 6 ] := XImp * YImp   ;
               SmRec [ 7 ] :=  Sqr ( YImp ) ;
               SmRec [ 8 ] := YImp * ( Sqr ( XImp ) + Sqr ( YImp ) )  ;
               SmRec [ 9 ] := YCat ;

               Inc   ( NEq ) ;
               Write ( SmFile, SmRec ) ;

             End ;

         End ;


       For Ind := 1 To NVar Do
         XMnk1 [ Ind ] := 1 ;

       If ( RedModelType = 1 )  Then
         For Ind := 7 To NVar Do
           XMnk1 [ Ind ] := 0 ;

       RecalcObjects ;

     End;


Begin

  Isolve   := 1        ;
  M1       := NVar + 1 ;
  M2       := NVar + 2 ;
  NVarTrue := 0        ;
  NEq      := 0        ;


  Assign  ( SmFile   , 'SmMnk.Dat'   ) ;
  ReWrite ( SmFile                   ) ;

  Assign  ( VFile    , 'VMnk.Dat'    ) ;
  ReWrite ( VFile                    ) ;

  Assign  ( IDefFile , 'IDefMnk.Dat' ) ;
  ReWrite ( IDefFile                 ) ;

  SysMake ;

  AxMnk   := 0.0 ;
  BxMnk   := 0.0 ;
  CxMnk   := 0.0 ;
  AyMnk   := 0.0 ;
  ByMnk   := 0.0 ;
  CyMnk   := 0.0 ;
  DMnk    := 0.0 ;
  EMnk    := 0.0 ;
  DistMnk := 0.0 ;


  IdefRec.IDef := 0 ;
  Seek ( IDefFile , 0 ) ;

  For I := 1 To NEq Do
    Write ( IDefFile, IDefRec ) ;


  Isolve := 1 ;

  M1       := NVar + 1 ;
  M2       := NVar + 2 ;
  NVarTrue :=        0 ;

  For I := 1 To NVar  Do
    Begin
      IDeffInp [ I ] := Round ( XMnk1 [ I ] ) ;
      If ( Round ( XMnk1 [ I ] ) <> 0 ) Then
        Begin
          Inc   ( NVarTrue ) ;
          Ideff [ NVarTrue ] := I ;
        End ;
    End ;



  If ( NVarTrue = 0)  Then
    Begin
      Isolve := 0 ;
      GoTo 777 ;
    End ;

  Mtrue1 := NVarTrue + 1 ;
  Mtrue2 := NVarTrue + 2 ;
  Ideff [ Mtrue1 ] := M1 ;
  If ( NEq = NVar ) Then
     Epsmax := 0.0 ;

  NDel := 0 ;

{
     ���� �� ��p������ �p�������, ���� �� ��⠭����
     �᫮ �p�������, p����� ��� ����������;
}


  For Ik := NEq DownTo NVarTrue Do
    Begin
{
       ��᫮ �p�������, �������� � p�襭��
       ��������������������������������������
}

      NEqTrue := 0 ;
      Seek ( IDefFile , 0 ) ;
      For L := 1 To NEq  Do
        Begin
          Read ( IDefFile, IDefRec ) ;
          If ( IdefRec.IDef = 0 ) Then
             Inc ( NEqTrue ) ;
        End ;


      If ( NEqTrue < NVarTrue )  Then
        Begin
          Isolve := 0 ;
          GoTo 777 ;
        End ;
{
       ���᫥��� ����⠡�p���� �����⥫�� XM
       ���������������������������������������
}
      S := Sqrt ( NEqTrue / 3.0 ) ;

      For I := 1 To NVar Do
        XF [ I ] := 0 ;


      Seek ( SmFile   , 0 ) ;
      Seek ( IDefFile , 0 ) ;

      For L := 1 To NEq  Do
        Begin

          Read ( SmFile   , SmRec   ) ;
          Read ( IDefFile , IDefRec ) ;

          If ( IdefRec.IDef = 0 ) Then
            Begin

              For I := 1 To NVarTrue Do
                Begin

                  II := Ideff [ I ] - 1 ;

                  FF := Abs ( SmRec [ II ] ) ;
                  If ( FF > XF [ I ] )  Then
                    Begin
                      XF [ I ] := FF ;
                      XM [ I ] := C10 / ( XF [ I ] * S ) ;
                    End ;

                End ;

            End ;

        End ;

{
      For I := 1 To NVarTrue Do
        Begin

          K  := 0 ;
          II := Ideff [ I ] - 1 ;
          F  := 0 ;

          Seek ( SmFile   , 0 ) ;
          Seek ( IDefFile , 0 ) ;

          For L := 1 To NEq  Do
            Begin

              Read ( SmFile   , SmRec   ) ;
              Read ( IDefFile , IDefRec ) ;

              If ( IdefRec = 0 ) Then
                Begin
                  FF := Abs ( SmRec [ II ] ) ;
                  If ( FF > F )  Then
                    F := FF ;
                End ;

            End ;

          XM [ I ] := C10 / ( F * S ) ;

        End ;
}

      XM [ Mtrue1 ] := 1 ;

For I := 1 To MTrue1 Do
  XM [ I ] := 1 ;

      { ��p��p������ ��p���쭮� ��⥬� }
      { ������������������������������� }

      For I := 1 To NVarTrue  Do
        For J := 1 To MTrue1  Do
          Begin
            NS [ I, J ] := 0.0 ;
          End ;

      Seek ( SmFile   , 0 ) ;
      Seek ( IDefFile , 0 ) ;

      For L := 1 To NEq  Do
        Begin

          Read ( SmFile   , SmRec   ) ;
          Read ( IDefFile , IDefRec ) ;

          If ( IdefRec.IDef = 0 ) Then

            Begin

              For I := 1 To NVarTrue  Do
                Begin

                  II := Ideff [ I ] - 1 ;

                  For J := I To MTrue1  Do
                    Begin

                      JJ := Ideff [ J ] - 1 ;

                      NS [ I, J ] :=   NS [ I, J ] 
                                     +   ( SmRec [ II ] * XM [ I ] )
                                       * ( SmRec [ JJ ] * XM [ J ] ) ;

                    End ;

                End ;

            End ;

        End ;


      For  I := 1  To  NVarTrue  Do
        For  J := I  To  MTrue1    Do
          Begin

            If ( J = Mtrue1 )
              Then
                OX [ I ] := NS [ I, J ]
              Else
                Begin
                  HS [ I, J ] := NS [ I, J ] ;
                  HS [ J, I ] := NS [ I, J ] ;
                End

          End ;


(*
      For I := 1 To NVarTrue  Do
        Begin

        For J := I To MTrue1  Do
          Begin

            II := Ideff [ I ] - 1 ;
            JJ := Ideff [ J ] - 1 ;
            S  := 0.0 ;

            Seek ( SmFile   , 0 ) ;
            Seek ( IDefFile , 0 ) ;

            For L := 1 To NEq  Do
              Begin

                Read ( SmFile   , SmRec   ) ;
                Read ( IDefFile , IDefRec ) ;

                If ( IdefRec = 0 ) Then
                  S := S +   ( SmRec [ II ] * XM [ I ] )
                           * ( SmRec [ JJ ] * XM [ J ] ) ;

              End ;

            If ( J = Mtrue1 )
              Then
                OX [ I ] := S
              Else
                Begin
                  HS [ I, J ] := S ;
                  HS [ J, I ] := S ;
                End

          End ;

        End ; { ��p��p������ ��p���쭮� ��⥬� }
*)


          { ��p�饭�� ���p��� ��p���쭮� ��⥬� }
          { ������������������������������������ }

      For K := NVarTrue DownTo 1 Do
        Begin

          P := HS [ 1, 1 ] ;
          If ( P <= 0 ) Then
            Begin
              { ���p�� � MHK ���� ��p������ }
              Isolve := 0 ;
              GoTo 777 ;
            End ;

          For I := 2 To NVarTrue Do
            Begin

              Q := HS [ I, 1 ] ;

              If ( I > K )
                Then  XMnk1 [ I ] :=  Q / P
                Else  XMnk1 [ I ] := -Q / P ;

              For J := 2 To I  Do
                HS [ I - 1, J - 1 ] := HS [ I, J ] + Q * XMnk1 [ J ] ;

            End ;


          HS [ NVarTrue, NVarTrue ] := C10 / P ;

          For I := 2 To NVarTrue Do
            HS [ NVarTrue, I - 1 ] := XMnk1 [ I ] ;

        End ;


      For I := 1 To NVarTrue Do
        For J := I + 1 To NVarTrue  Do
          HS [ I, J ] := HS [ J, I ] ;


       { ���᫥��� ���������� }
       { ���������������������� }

      For I := 1 To NVarTrue Do
        Begin
          S := 0.0 ;
          For J := 1 To NVarTrue Do
            S := S + HS [ I, J ] * OX [ J ] ;
          XMnk1 [ I ] := S ;
        End ;


        { ����⠡�p������ ���������� }
        { ��������������������������� }

      For I := 1 To NVarTrue  Do
        XMnk1 [ I ] := XMnk1 [ I ] * XM [ I ] ;


        { ������ 㪫������ }
        { �������������������� }

      XMnk1 [ Mtrue1 ] := -1     ;
      C            := 1.0e24 ;
      CC           := - C    ;
      Imax         := 0      ;
      K            := 0      ;
      Epsm         := 0.0    ;
      F            := 0.0    ;
      SS           := 0.0    ;
      SvX          := 0.0    ;
      SvY          := 0.0    ;

      Seek ( SmFile   , 0 )  ;
      Seek ( IDefFile , 0 )  ;
      Seek ( VFile    , 0 )  ;


      For L := 1 To NEq  Do
        Begin

          Read ( SmFile   , SmRec   ) ;
          Read ( IDefFile , IDefRec ) ;

          If ( IdefRec.IDef = 0 ) Then
            Begin

              S := 0.0 ;

              For I := 1 To Mtrue1 Do
                Begin
                  II := Ideff [ I ] ;
                  S := S + ( SmRec [ II - 1 ] * XMnk1 [ I ] ) ;
                End ;

              If ( L Mod 2 = 1 )
                Then  SvX := SvX + S 
                Else  SvY := SvY + S ;

              If ( Abs ( S ) < 5.0 )
                 Then  VRec := Round ( Abs ( S ) * 6000.0 ) 
                 Else  VRec := 32767 ;

              If ( S < 0.0 )  Then
                VRec := - VRec ;

              If S < C  Then C  := S ;
              If S > CC Then CC := S ;
              S := Abs ( S ) ;
              If ( S > Epsm)  Then
                Begin
                  Imax := L ;
                  Epsm := S ;
                End ;

            End ;

          Write ( VFile, VRec ) ;

        End ;



      XMnk1 [ Mtrue1 ] := C  ;
      XMnk1 [ Mtrue2 ] := CC ;

      SS := 0.0 ;

      If (     ( Epsm <> 0     )
           And ( NEq  <> NVarTrue ) )  Then
        Begin

          Seek ( VFile    , 0 ) ;
          Seek ( IDefFile , 0 ) ;


          For L := 1 To Neq Do
            Begin

              Read ( IDefFile , IDefRec ) ;
              Read ( VFile    , VRec    ) ;

              If ( IdefRec.IDef = 0 ) Then
                Begin
                  SS := SS + Sqr ( VRec / 6000.0 / Epsm ) ;
                End ;

            End ;

          SS := ( SS / ( NEqTrue - NVarTrue ) ) * Sqr ( Epsm ) ;

        End ;


          { ��p��뢠�� �� > 3 sig }
          { ����������������������� }

      NSig  := 3.0 ;
      SSS   := NSig * Sqrt ( SS ) ;
      DelEq := False ;

      For L := 1 To NEq  Do
        Begin

          Seek ( VFile    , L - 1 ) ;
          Seek ( IDefFile , L - 1 ) ;

          Read ( IDefFile , IDefRec ) ;
          Read ( VFile    , VRec    ) ;


          If ( IdefRec.IDef = 0 ) Then
            Begin

              S := VRec / 6000.0 ;

              If (    ( Abs ( S ) > SSS    )
                   Or ( Abs ( S ) > EpsMax )  )
                Then
                  Begin
                    DelEq := True ;

                    Seek ( IDefFile , L - 1 ) ;
                    IDefRec.IDef := 1 ;
                    Write ( IDefFile , IDefRec ) ;
{
                     �������� ��p��� �p�������
                     �������������������������
}
                      If ( L Mod 2 = 0 )
                        Then
                          Begin
                            Seek ( IDefFile , L - 2 ) ;
                          End
                        Else
                          Begin
                            Seek ( IDefFile , L ) ;
                          End ;

                      Write ( IDefFile, IDefRec ) ;

                  End ;

            End ;


        End ;

      Inc ( NDel ) ;

      If (    ( Epsmax = 0       )
           Or ( DelEq  = False   )
           Or ( NDel  >= NDelMax )
                                    )  Then
         GoTo  666 ;


    End ; { 横�� �� ��p������ �p������� }



  If ( NEq <> NVar ) Then
    Begin
{     ���� ��p������ ����� ����p����� ��� �����⢥����� ��室�
       ⮫쪮 �p� NVar = NEq ��� �p� ��㤠筮� ��p������           }
      Isolve := 0 ;
      GoTo 777 ;

    End ;


666:;

      SS  := 0.0 ;
      SvX := 0.0 ;
      SvY := 0.0 ;


      If (     ( Epsm <> 0     )
           And ( NEq  <> NVarTrue ) )  Then
        Begin

          Seek ( VFile    , 0 ) ;
          Seek ( IDefFile , 0 ) ;

          For L := 1 To Neq Do
            Begin

              Read ( IDefFile , IDefRec ) ;
              Read ( VFile    , VRec    ) ;

              If ( IdefRec.IDef = 0 ) Then
                Begin
                  SS := SS + Sqr ( VRec / 6000.0 / Epsm ) ;
                  If ( L Mod 2 = 1 )
                     Then  SvX := SvX + VRec / 6000.0 
                     Else  SvY := SvY + VRec / 6000.0 ;
                End ;
            End ;


          SS := ( SS / ( NEqTrue - NVarTrue ) ) * Sqr ( Epsm ) ;

        End ;


    { �����p��樮���� � ��pp���樮���� ���p��� }
    { ���������������������������������������� }

      For I := 1 To NVarTrue  Do
        OX [ I ] := Sqrt ( HS [ I, I ] ) ;

      For I := 1 To NVarTrue  Do
        For J := 1 To NVarTrue  Do
          Begin
            S := HS [ I, J ] ;
            CM [ I, J ] := S / ( OX [ I ] * OX [ J ] )      ;
            HS [ I, J ] := S *   XM [ I ] * XM [ J ]   * SS ;
          End ;

      For I := 1 To NVarTrue  Do
        OX [ I ] := Sqrt ( HS [ I, I ] ) ;

      OX [ Mtrue1 ] := Sqrt ( SS ) ;
      MQE           := Sqrt ( SS ) ;

      Epsmax := Epsm ;


     { ��p���� ���������� � �� �訡�� � ��⮬ �ᯮ��㥬�� �⮫�殢 }
     { �������������������������������������������������������������� }

      XMnk1 [ NVar + 1 ] := XMnk1 [ Mtrue1 ] ;
      XMnk1 [ NVar + 2 ] := XMnk1 [ Mtrue2 ] ;

      For I := Mtrue1 DownTo 1 Do
        Begin
          II := Ideff [ I ] ;
          XMnk1 [ II ] := XMnk1 [ I ] ;
          OX    [ II ] := OX    [ I ] ;
        End ;

      For I := 1 To NVar Do
        Begin
          If ( IdeffInp [ I ] = 0 )   Then
            Begin
              XMnk1 [ I ] := 0.0 ;
              OX    [ I ] := 0.0 ;
            End ;
        End ;

      AxMnk   := XMnk1 [ 2 ] ;
      BxMnk   := XMnk1 [ 3 ] ;
      CxMnk   := XMnk1 [ 1 ] ;

      AyMnk   := XMnk1 [ 5 ] ;
      ByMnk   := XMnk1 [ 6 ] ;
      CyMnk   := XMnk1 [ 4 ] ;

      If ( RedModelType = 2 )
        Then
          Begin
            DMnk       :=  XMnk1 [ 7 ] ;
            ErrDImp    :=  OX    [ 7 ] ;
            EMnk       :=  XMnk1 [ 8 ] ;
            ErrEImp    :=  OX    [ 8 ] ;
            DistMnk    :=  XMnk1 [ 9 ] ;
            ErrDistImp :=  OX    [ 9 ] ;
          End
        Else
          Begin
            DMnk       := 0.0 ;
            EMnk       := 0.0 ;
            DistMnk    := 0.0 ;
            ErrDImp    := 0.0 ;
            ErrEImp    := 0.0 ;
            ErrDistImp := 0.0 ;
          End ;


 777:;


  Close ( SmFile    ) ;
  Close ( VFile     ) ;
  Close ( IDefFile  ) ;

  Erase ( SmFile    ) ;
  Erase ( VFile     ) ;
  Erase ( IDefFile  ) ;


End ;

End.