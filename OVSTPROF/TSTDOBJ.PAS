{ ������������������������������������������������������������Ŀ }
{ �                                                            � }
{ �                    OVSoft  Pascal + +                      � }
{ �                                                            � }
{ �            ����� �p��p��� �p�������祭�� ���              � }
{ �           ᮧ����� ���p䥩� � ���짮��⥫��.             � }
{ �                                                            � }
{ �                      �����  1.0                           � }
{ �                                                            � }
{ �                Copyright (c) 1992,93 by                    � }
{ �                                                            � }
{ �                 Oleg Volchkov Software.                    � }
{ �                                                            � }
{ �                   All right reserved.                      � }
{ �                                                            � }
{ ������������������������������������������������������������Ĵ }
{ �                                                            � }
{ �               IBM   PC XT, PC AT 286/386.                  � }
{ �              �����p�  EGA, VGA, Hercules.                 � }
{ �                                                            � }
{ ������������������������������������������������������������Ĵ }
{ �                                                            � }
{ �                    ����� TStdObj.                         � }
{ �                                                            � }
{ � �⠭��p�� ⨯�, ����⠭�� � ��ꥪ�� ��� ����� OVSTPROF. � }
{ �                                                            � }
{ ������������������������������������������������������������Ĵ }
{ �                                                            � }
{ �                     Turbo  Pascal                          � }
{ �                   Version 6.0, 7.0                         � }
{ �                Copyright (c) 1983,90 by                    � }
{ �               Borland International, Inc                   � }
{ �                                                            � }
{ �������������������������������������������������������������� }


{$F+,O+}
Unit TStdObj;
Interface

Const

    Yes          = 1  ;
    No           = 2  ;


  { �⠭����� �㭪樨. }
  { �������������������� }

    cmNoAlt     = 0  ;

    cmQuit      = 1  ;

    cmCancel    = 2  ;
    cmOk        = 3  ;

    cmYes       = 4  ;
    cmNo        = 5  ;


    hcNoContext = 0  ;


    MainHelpContext  : Word = 0;

Type

   TitleStringType = String [ 60 ];

   PStr   = ^String;

   TPoint = Object

     X , Y : Integer ;

   end;

   { ���न���� ����. }
   { ���������������� }

    PRect        = ^TRect;
    TRect        = Object

          A, B : TPoint;

          Procedure  Assign ( WSX, WSY, WEX, WEY : Integer );
          Procedure  Move   ( NewStartX , NewStartY : Integer );
          Procedure  GetStartCoords ( Var GStartX, GStartY : Integer );

     end; { TRect }

     PMain       = ^TMain;
     TMain       = Object

       constructor Init;
       destructor Done;
       procedure HandleEvent( ECommand : Word );

     end;{ TMain }

  { ������������������������������������������������������������������������ }

     PListItem = ^TListItem;
     TListItem = Record
        Item : Pointer;
        Prev : PListItem;
        Next : PListItem;
     end;

     PList       = ^TList;
     TList       = Object

       Count      : Word;
       Size       : Word;

       ActiveItem : PListItem;

       Head       : PListItem;
       Tile       : PListItem;

       constructor Init;
       procedure Add( Item : Pointer );virtual;
       procedure Insert( PrevItem,Item : Pointer );virtual;
       destructor Done;

     end;


Const

  CheckKey : Boolean = True;

Implementation

{����������������������������������������������������������������������������}
{��                                                                        ��}
{��                  ��楤��� � �㭪樨 ��ꥪ� TRect                     ��}
{��                                                                        ��}
{����������������������������������������������������������������������������}

Procedure  TRect.Assign( WSX, WSY, WEX, WEY : Integer );
 Begin
         A.X  :=  WSX ;
         A.Y  :=  WSY ;
         B.X  :=  WEX ;
         B.Y  :=  WEY ;

 End;{ Assign }

{ ���������������������������������������������������� }

Procedure  TRect.Move( NewStartX , NewStartY : Integer );

 Var

   DeltaX , DeltaY  : Integer ;

 Begin

         DeltaX   := NewStartX - A.X ;
         DeltaY   := NewStartY - A.Y ;

         A.X  := NewStartX ;
         A.Y  := NewStartY ;
         B.X  := B.X + DeltaX ;
         B.Y  := B.Y + DeltaY ;

 End;{ Move }

{ ���������������������������������������������������� }

Procedure  TRect.GetStartCoords ( Var GStartX , GStartY : Integer );
Begin

    GStartX := A.X ;
    GStartY := A.Y ;

End; { GetStartCoords }


{����������������������������������������������������������������������������}
{��                                                                        ��}
{��                  ��楤��� � �㭪樨 ��ꥪ� TMain                     ��}
{��                                                                        ��}
{����������������������������������������������������������������������������}

constructor TMain.Init;
begin
end;{ TMain.Init }

{ ������������������������������������������������������������������������� }

destructor TMain.Done;
begin
end;{ TMain.Done }

{ ������������������������������������������������������������������������� }

procedure TMain.HandleEvent( ECommand : Word );
begin
end;{ TMain.HandleEvent }

{ ������������������������������������������������������������������������� }


{����������������������������������������������������������������������������}
{��                                                                        ��}
{��                  ��楤��� � �㭪樨 ��ꥪ� TList                     ��}
{��                                                                        ��}
{����������������������������������������������������������������������������}

constructor TList.Init;
begin

  Count       := 0;
  Size        := 0;
  ActiveItem  := Nil;
  Head        := Nil;
  Tile        := Nil;

end;{ TList.Init }

{����������������������������������������������������������������������������}

procedure TList.Add( Item : Pointer );
Var
  NewItem : PListItem;
begin

 If Size = 0 Then
   begin

     New( Head );
     New( Tile );
     Head^.Item := Item;
     Tile := Head;
     Size := 1;

   end
     else
       begin

         New( NewItem );

         NewItem^.Prev := Tile;
         NewItem^.Item := Item;
         NewItem^.Next := Nil;

         Tile^.Next := NewItem;
         Tile := NewItem;

         Inc( Size );

       end;

end;{ TList.Add }

{����������������������������������������������������������������������������}

procedure TList.Insert( PrevItem, Item : Pointer );
Var
  I  : Word;
  IT : PListItem;
  NewItem : PListItem;
begin

  IT := Head^.Item;
  While ( I <= Size ) and ( IT^.Item <> Item ) do
    begin
     Inc( I );
     IT := IT^.Next;
    end;

  New( NewItem );

  IF IT^.Item = Item Then
    begin

      IT^.Next := NewItem;
      NewItem^.Prev := IT;
      NewItem^.Item := Item;

      If Tile = IT Then
        Tile := NewItem;

    end;


end;{ TList.Insert }

{ ������������������������������������������������������������������������� }

destructor TList.Done;
Var
  I : Word;

begin

end;{ TList.Done }

End.