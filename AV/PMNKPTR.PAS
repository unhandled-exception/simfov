
{$O+,F+}


 Unit  PMnkPtr ;

{
   ���ᮡ ��������� ����p�⮢ ��� �������� ��⥬� � �������᪮� �����;
   ����������������������������������������������������������������������

                 �室�� ��p����p�:
                 �����������������
      NEq  - �᫮ �p�������, �p���塞�� � p�襭��,
      NVar - �᫮ ����������,
      SM - ���p�� ��⥬�. �p������� ������ p�ᯮ�������� � ������p���
           ���ᨢ� SM ��p��� �� ��p����, ������ �p������� ������ ᮤ�p-
           ���� NVar + 1 �ᥫ. ��᫥���� �� ��� - ᢮����� 童� � ⥬
           ������, ���p� �� ����� � �p���� ��� �p�������,
      XMnk^- ���ᨢ, ᮤ�p��騩 �p������ ����祭�� ������� �⮫�� (�������
          �������⭮��) � p�襭��. ��� I-��� �⮫�� ������ ���� XMnk(I)=1,
          �᫨ �������⭮� ����砥��� � p�襭��, � XMnk(I)=0, �᫨ ���.
          �p��������: ����� �᪫���� ���������, �� ����� ��⥬�,
      Epsmax - ���ᨬ��쭮� ����᪠���� ����筮� 㪫������. �p�������
        ��p����뢠���� �� ������ �� �� ��p, ���� ���ᨬ��쭮� 㪫���-
        ��� �� �⠭�� ����� Epsmax. �᫨ ��p������ �� �㦭�, ��������
        Epsmax = 0. �p��������: �᪫�祭�� �p��� �訡��, �᫨ �筮���
        ��室��� ������ �p������⥫쭮 �����⭠,
      Idef^- ���ᨢ, ᮤ�p��騩 �p������ ����祭�� ������� �p������� �
        p�襭��. �p������� � ����p�� I ����砥��� � p�襭��, �����
        Idef(I) = 0. ��p�� ��p�饭��� � �p�楤�p� �p�᢮���
        Idef(1 : NEq) = 0. �p��������: ����� �᪫���� I-�� �p�������,
        ������� Idef(I) = 1.

              ��室�� ��p����p�:
              ������������������
      XMnk^- ���ᨢ ����������, XMnk ᮤ�p��� ���祭�� ����������,
        XMnk^( NVar + 1) � XMnk^( NVar + 2) - �������쭮� � ���ᨬ��쭮� ���-
        ��� 㪫������ ᮮ⢥��⢥���,
      OX^- ���ᨢ �訡�� ����������. OX^( NVar + 1) ᮤ�p��� �p�����
         ����p������ �訡�� ������� ���,
      V - ���ᨢ ������� 㪫������. �᫨ �p������� ��p�������, ���-
        ᨢ ᮤ�p��� � ����筮� 㪫������, ���p�� ����稫��� � ��-
        ᫥���� 蠣� p�襭��, � ���p�� �� �p������� ���⢮����,
      HS^- ����p��樮���� ���p�� ����������,
      Imax - ����p �p�������, ����饣� �������襥 ����筮� 㪫������,
      Idef^- ���ᨢ, ᮤ�p��騩 �p������ ��p��������� �p�������. �᫨
          I-�� �p������� ��p�������, Idef(I) ᮤ�p��� ���㫥��� 楫��,
          �᫨ �p������� ��諮 � p�襭��, Idef(I) = 0,
      Isolve -
          p�襭�� ����p訫��� ��㤠筮, Isolve = 0 ( -1 �᫨ ���� ����� ),
          ���� Isolve = 1,
      NVarTrue - �᫮ ����������, ����祭��� � p�襭�� � ᮮ⢥��⢨� �
          ��砫�� �������� ��p��� NVar ���祭�� � ���ᨢ� XMnk,
      NEqTrue - �᫮ �p�������, ��⠢���� ��᫥ ��p������, �.�. ��襤-
          �� � p�襭��. ����� ��� �㫥��� ������⮢ � ���ᨢ� Idef,
      Idef^- �᫨ Idef(I) = 0, � I-�� �p������� ��諮 � p�襭��, ����
          �᪫�祭� �p� ��p������ ��� �� ��p�饭�� � �p�楤�p�.
             �p���砭��:
       - ���ᨢ� XMnk, OX ������ ����� ����� �� ����� NVar + 3,
       - 楫�ᮮ�p���� ��⠭����� �㦭�� ����� ���ᨢ�� � ᮮ⢥��⢨�
         � ���ᨬ���� �������� �᫮� ���������� � �p�������,
       - �᫨ 楫� ������ ���� ���� �� p��p������, �������� ���ᠭ��
         Integer*1 �� Integer*2 ��� Integer.
      ���p���p�: ����p�� ��p�饭�� ���p��� �����⢮��� �� �����:
      ������ᮭ, �����, ��p���筨� ����p�⬮� �� �몥 �����, 1976,
      ��p. 53, �p�楤�p� Gidef1.


      ���p �p��p����     - �.�.�㨬��,  1975 - 1991 �.�.
      ���������������������������������������������������
      ��p���� �� 'Paskal' - �.�.���窮�, 1995 - 1996 �.�.
      ���������������������������������������������������
}

 
 Interface

 Uses  PVar ;


     Procedure MnkPtr (        Epsmax : Double    ;
                        Var    Isolve : Integer   ;
                        Var  NEqTrue  : Integer     ) ;


 Implementation

   Type

     SmArrType    = Array [ 0 .. NEqMaxMnk - 1 ] Of Single ;
     VArrType     = Array [ 0 .. NEqMaxMnk - 1 ] Of Single ;

     NVar_3Type   = Array [ 1 ..               NVarMnk + 3   ] Of Double   ;
     HsMnkType    = Array [ 1 .. NVarMnk  ,    1 .. NVarMnk  ] Of Double   ;
     XmMnkType    = Array [ 1 ..               NVarMnk + 1   ] Of Double   ;
     IDefMnkType  = Array [ 1 .. NEqMaxMnk                   ] Of ShortInt ;
     IDeffMnkType = Array [ 1 ..               NVarMnk + 1   ] Of Integer  ;

     SmPtrType    = ^SmArrType     ;
     VPtrType     = ^VArrType      ;
     NVar_3Ptr    = ^NVar_3Type    ;
     HsMnkPtr     = ^HsMnkType     ;
     XmMnkPtr     = ^XmMnkType     ;
     IDefMnkPtr   = ^IDefMnkType   ;
     IDeffMnkPtr  = ^IDeffMnkType  ;



   Procedure SysMake ; { �p�楤�p� ᮧ����� ��⥬� �p������� ���짮��⥫� }
     Begin
     End;




   Procedure MnkPtr (        Epsmax : Double    ;
                      Var    Isolve : Integer   ;
                      Var  NEqTrue  : Integer     ) ;



    Label 666, 777 ;


Var

    SmPtr    : SmPtrType    ;
    VPtr     : VPtrType     ;
    XMnk     : NVar_3Ptr    ;
    OX       : NVar_3Ptr    ;
    HS       : HsMnkPtr     ;
    Idef     : IDefMnkPtr   ;
    XM       : XmMnkPtr     ;
    IDeff    : IdeffMnkPtr  ;
    IDeffInp : IdeffMnkPtr  ;

    DelEq                       : Boolean   ;

    NEq                         : Integer   ;

    I, J, K, L,
    M1, M2,
    Imax,
    NVarTrue,
    II, JJ, Ik,
    MTrue1, MTrue2              : LongInt   ;

    SSS, NSig,
    C, CC, Epsm,
    S, SS, F, FF, P, Q          : Double    ;


Begin

L := 0 ;

L := L + SizeOf ( SmPtrType   )  ;
L := L + SizeOf ( VPtrType    )  ;
L := L + SizeOf ( NVar_3Ptr   )  ;
L := L + SizeOf ( NVar_3Ptr   )  ;
L := L + SizeOf ( HsMnkPtr    )  ;
L := L + SizeOf ( IDefMnkPtr  )  ;
L := L + SizeOf ( XmMnkPtr    )  ;
L := L + SizeOf ( IdeffMnkPtr )  ;
L := L + SizeOf ( IdeffMnkPtr )  ;


If ( MaxAvail > L )
Then
 Begin { ����� �����筮 }

  GetMem ( SmPtr    , SizeOf ( SmPtrType   )  ) ;
  GetMem ( VPtr     , SizeOf ( VPtrType    )  ) ;
  GetMem ( XMnk     , SizeOf ( NVar_3Ptr   )  ) ;
  GetMem ( OX       , SizeOf ( NVar_3Ptr   )  ) ;
  GetMem ( HS       , SizeOf ( HsMnkPtr    )  ) ;
  GetMem ( Idef     , SizeOf ( IDefMnkPtr  )  ) ;
  GetMem ( XM       , SizeOf ( XmMnkPtr    )  ) ;
  GetMem ( IDeff    , SizeOf ( IdeffMnkPtr )  ) ;
  GetMem ( IDeffInp , SizeOf ( IdeffMnkPtr )  ) ;

  NEq := 0 ;

  SysMake ;  { ����⮢����� ��⥬� }
 {�������}

  Isolve := 1 ;

  M1 := NVarMnk + 1 ;
  M2 := NVarMnk + 2 ;
  NVarTrue := 0 ;

  For I := 1 To NVarMnk  Do
    Begin
      IDeffInp^ [ I ] := Round ( XMnk^  [ I ] ) ;
      If ( Round ( XMnk^  [ I ] ) <> 0 ) Then
        Begin
          Inc   ( NVarTrue ) ;
          Ideff^ [ NVarTrue ] := I ;
        End ;
    End ;

  If ( NVarTrue = 0)  Then
    Begin
      Isolve := 0 ;
      GoTo 777 ;
    End ;

  Mtrue1 := NVarTrue + 1 ;
  Mtrue2 := NVarTrue + 2 ;
  Ideff^ [ Mtrue1 ] := M1 ;
  If ( NEq = NVarMnk ) Then
     Epsmax := 0.0 ;

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
      For L := 1 To NEq  Do
        If ( Idef^[ L ] = 0 ) Then  
          Inc ( NEqTrue ) ;

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

      For I := 1 To NVarTrue Do
        Begin

          K  := 0 ;
          II := Ideff^ [ I ] ;
          F := 0 ;
          For L := 1 To NEq  Do
            Begin
              If ( Idef^[ L ] = 0 ) Then
                FF := Abs ( SmPtr^ [ K + II - 1 ] ) ;
                If ( FF > F )  Then
                  F := FF ;
                K := K + M1 ;
            End ;

          XM^[ I ] := C10 / ( F * S ) ;

        End ;


      XM^[ Mtrue1 ] := 1 ;


      { ��p��p������ ��p���쭮� ��⥬� }
      { ������������������������������� }

      For I := 1 To NVarTrue  Do
        For J := I To MTrue1  Do
          Begin
            II := Ideff^ [ I ] ;
            JJ := Ideff^ [ J ] ;
            S  := 0.0 ;
            K  := 0   ;
            For L := 1 To NEq  Do
              Begin
                If ( Idef^[ L ] = 0 )  Then
                  S := S +   ( SmPtr^ [ K + II - 1 ]  *  XM^ [ I ] ) 
                           * ( SmPtr^ [ K + JJ - 1 ]  *  XM^ [ J ] ) ;
                K := K + M1 ;
              End ;

            If ( J = Mtrue1 ) 
              Then
                OX^[ I ] := S
              Else
                Begin
                  HS^[ I, J ] := S ;
                  HS^[ J, I ] := S ;
                End 

          End ; { ��p��p������ ��p���쭮� ��⥬� }



          { ��p�饭�� ���p��� ��p���쭮� ��⥬� }
          { ������������������������������������ }

      For K := NVarTrue DownTo 1 Do
        Begin

          P := HS^[ 1, 1 ] ;
          If ( P <= 0 ) Then
            Begin
              { ���p�� � MHK ���� ��p������ }
              Isolve := 0 ;
              GoTo 777 ;
            End ;

          For I := 2 To NVarTrue Do
            Begin

              Q := HS^[ I, 1 ] ;

              If ( I > K ) 
                Then  XMnk^ [ I ] :=  Q / P
                Else  XMnk^ [ I ] := -Q / P ;

              For J := 2 To I  Do
                HS^[ I - 1, J - 1 ] := HS^[ I, J ] + Q * XMnk^ [ J ] ;

            End ;


          HS^[ NVarTrue, NVarTrue ] := C10 / P ;

          For I := 2 To NVarTrue Do
            HS^[ NVarTrue, I - 1 ] := XMnk^ [ I ] ;

        End ;


      For I := 1 To NVarTrue Do
        For J := I + 1 To NVarTrue  Do
          HS^[ I, J ] := HS^[ J, I ] ;


       { ���᫥��� ���������� }
       { ���������������������� }

      For I := 1 To NVarTrue Do
        Begin
          S := 0.0 ;
          For J := 1 To NVarTrue Do
            S := S + HS^[ I, J ] * OX^[ J ] ;
          XMnk^ [ I ] := S ;
        End ;


        { ����⠡�p������ ���������� }
        { ��������������������������� }

      For I := 1 To NVarTrue  Do
        XMnk^ [ I ] := XMnk^ [ I ] * XM^[ I ] ;


        { ������ 㪫������ }
        { �������������������� }

      XMnk^ [ Mtrue1 ] := -1     ;
      C            := 1.0e24 ;
      CC           := - C    ;
      Imax         := 0      ;
      K            := 0      ;
      Epsm         := 0.0    ;
      F            := 0.0    ;
      SS           := 0.0    ;

      For L := 1 To NEq  Do
        Begin

          If ( Idef^[ L ] = 0 )  Then
            Begin

              S := 0.0 ;

              For I := 1 To Mtrue1 Do
                Begin
                  II := Ideff^ [ I ] ;
                  S := S + ( SmPtr^ [ K + II - 1 ] * XMnk^ [ I ] ) ;
                End ;

              VPtr^ [ L - 1 ] := S ;

              If S < C  Then C  := S ;
              If S > CC Then CC := S ;
              S := Abs ( S ) ;
              If ( S > Epsm)  Then
                Begin
                  Imax := L ;
                  Epsm := S ;
                End ;

            End ;

          K := K + M1 ;

        End ;


      XMnk^ [ Mtrue1 ] := C  ;
      XMnk^ [ Mtrue2 ] := CC ;

      SS := 0.0 ;
      If (     ( Epsm <> 0     )  
           And ( NEq  <> NVarTrue ) )  Then
        Begin    
          For L := 1 To Neq Do
            Begin
              If ( Idef^[ L ] = 0 ) Then
                Begin
                  SS := SS + Sqr ( VPtr^ [ L - 1 ]  / Epsm ) ;
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

          If ( Idef^[ L ] = 0 )  Then
            Begin

              S := VPtr^ [ L - 1 ] ;

              If (    ( Abs ( S ) > SSS    )
                   Or ( Abs ( S ) > EpsMax )  )
                Then
                  Begin
                    DelEq := True ;
                    Idef^[ L ] := 1 ;
                  End ;

            End ;

        End ;


      If (    ( Epsmax = 0      ) 
           Or ( DelEq  = False  )
                                   )  Then 
         GoTo  666 ;


    End ; { 横�� �� ��p������ �p������� }



  If ( NEq <> NVarMnk ) Then
    Begin
{     ���� ��p������ ����� ����p����� ��� �����⢥����� ��室�
       ⮫쪮 �p� NVarMnk = NEq ��� �p� ��㤠筮� ��p������           }
      Isolve := 0 ;
      GoTo 777 ;

    End ;


666:;

      SS := 0.0 ;

      If (     ( Epsm <> 0     )  
           And ( NEq  <> NVarTrue ) )  Then
        Begin    
          For L := 1 To Neq Do
            Begin
              If ( Idef^[ L ] = 0 ) Then
                Begin
                  SS := SS + Sqr ( VPtr^ [ L - 1 ] / Epsm ) ;
                End ;
            End ;
          SS := ( SS / ( NEqTrue - NVarTrue ) ) * Sqr ( Epsm ) ;
        End ;


    { �����p��樮���� � ��pp���樮���� ���p��� }
    { ���������������������������������������� }

      For I := 1 To NVarTrue  Do
        OX^[ I ] := Sqrt ( HS^[ I, I ] ) ;

      For I := 1 To NVarTrue  Do
        For J := 1 To NVarTrue  Do
          Begin
            S := HS^[ I, J ] ;
{
            CM [ I, J ] := S / ( OX^[ I ] * OX^[ J ] )      ;
}
            HS^[ I, J ] := S *   XM^[ I ] * XM^[ J ]   * SS ;
          End ;

      For I := 1 To NVarTrue  Do
        OX^[ I ] := Sqrt ( HS^[ I, I ] ) ;

      OX^[ Mtrue1 ] := Sqrt ( SS ) ;

      Epsmax := Epsm ;


     { ��p���� ���������� � �� �訡�� � ��⮬ �ᯮ��㥬�� �⮫�殢 }
     { �������������������������������������������������������������� }

      XMnk^ [ NVarMnk + 1 ] := XMnk^ [ Mtrue1 ] ;
      XMnk^ [ NVarMnk + 2 ] := XMnk^ [ Mtrue2 ] ;

      For I := Mtrue1 DownTo 1 Do
        Begin
          II := Ideff^ [ I ] ;
          XMnk^ [ II ] := XMnk^ [ I ] ;
          OX^   [ II ] := OX^   [ I ] ;
        End ;

      For I := 1 To NVarMnk Do
        Begin
          If ( IdeffInp^ [ I ] = 0 )   Then
            Begin
              XMnk^ [ I ] := 0.0 ;
              OX^   [ I ] := 0.0 ;
            End ;
        End ;


 777:;

  If ( SmPtr <> Nil )  Then
    FreeMem ( SmPtr    , SizeOf ( SmPtrType   )  ) ;
  SmPtr := Nil ;

  If ( VPtr <> Nil )  Then
    FreeMem ( VPtr     , SizeOf ( VPtrType    )  ) ;
  VPtr := Nil ;

  If ( XMnk <> Nil )  Then
    FreeMem ( XMnk     , SizeOf ( NVar_3Ptr   )  ) ;
  XMnk := Nil ;

  If ( OX <> Nil )  Then
    FreeMem ( OX       , SizeOf ( NVar_3Ptr   )  ) ;
  OX := Nil ;

  If ( HS <> Nil )  Then
    FreeMem ( HS       , SizeOf ( HsMnkPtr    )  ) ;
  HS := Nil ;

  If ( Idef <> Nil )  Then
    FreeMem ( Idef     , SizeOf ( IDefMnkPtr  )  ) ;
  Idef := Nil ;

  If ( XM <> Nil )  Then
    FreeMem ( XM       , SizeOf ( XmMnkPtr    )  ) ;
  XM := Nil ;

  If ( IDeff <> Nil )  Then
    FreeMem ( IDeff    , SizeOf ( IdeffMnkPtr )  ) ;
  IDeff := Nil ;

  If ( IDeffInp <> Nil )  Then
    FreeMem ( IDeffInp , SizeOf ( IdeffMnkPtr )  ) ;
  IDeffInp := Nil ;


 End  { ����� �����筮 }
Else
 Begin  { ����� ���� }
   ISolve := -1 ;
 End ;

End ;



End.