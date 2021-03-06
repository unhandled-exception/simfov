{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커 }
{ �                                                            � }
{ �                    OVSoft  Pascal + +                      � }
{ �                                                            � }
{ �            룧ぅ� 칛�즤젹� 칛ⅳ췅㎛좂���硫 ㄻ�              � }
{ �           貰ℓ젺⑨ Þ收p芯⒰� � ��レ㎜쥯收ゥ�.             � }
{ �                                                            � }
{ �                      궏褻⑨  1.0                           � }
{ �                                                            � }
{ �                Copyright (c) 1992,93 by                    � }
{ �                                                            � }
{ �                 Oleg Volchkov Software.                    � }
{ �                                                            � }
{ �                   All right reserved.                      � }
{ �                                                            � }
{ 쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑 }
{ �                                                            � }
{ �               IBM   PC XT, PC AT 286/386.                  � }
{ �              뙫�ⓥ췴�  EGA, VGA, Hercules.                 � }
{ �                                                            � }
{ 쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑 }
{ �                                                            � }
{ �                    뙫ㅳレ TStdObj.                         � }
{ �                                                            � }
{ � 묅젺쩆p狩瑜 殊��, ぎ�飡젺瞬 � �↔ⅹ瞬 ㄻ� 캙ぅ收 OVSTPROF. � }
{ �                                                            � }
{ 쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑 }
{ �                                                            � }
{ �                     Turbo  Pascal                          � }
{ �                   Version 6.0, 7.0                         � }
{ �                Copyright (c) 1983,90 by                    � }
{ �               Borland International, Inc                   � }
{ �                                                            � }
{ 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸 }


{$F+,O+}
Unit TStdObj;
Interface

Const

    Yes          = 1  ;
    No           = 2  ;


  { 묅젺쩆設�瑜 押�ゆĿ. }
  { 컴컴컴컴컴컴컴컴컴컴 }

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

   { 뒶�西Þ졻� �ぎ�. }
   { 컴컴컴컴컴컴컴컴 }

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

  { 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇 }

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

{굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇}
{굇                                                                        굇}
{굇                  뤲�璵ㅳ贍 � 押�ゆĿ �↔ⅹ�� TRect                     굇}
{굇                                                                        굇}
{굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇}

Procedure  TRect.Assign( WSX, WSY, WEX, WEY : Integer );
 Begin
         A.X  :=  WSX ;
         A.Y  :=  WSY ;
         B.X  :=  WEX ;
         B.Y  :=  WEY ;

 End;{ Assign }

{ 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴 }

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

{ 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴 }

Procedure  TRect.GetStartCoords ( Var GStartX , GStartY : Integer );
Begin

    GStartX := A.X ;
    GStartY := A.Y ;

End; { GetStartCoords }


{굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇}
{굇                                                                        굇}
{굇                  뤲�璵ㅳ贍 � 押�ゆĿ �↔ⅹ�� TMain                     굇}
{굇                                                                        굇}
{굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇}

constructor TMain.Init;
begin
end;{ TMain.Init }

{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇� }

destructor TMain.Done;
begin
end;{ TMain.Done }

{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇� }

procedure TMain.HandleEvent( ECommand : Word );
begin
end;{ TMain.HandleEvent }

{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇� }


{굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇}
{굇                                                                        굇}
{굇                  뤲�璵ㅳ贍 � 押�ゆĿ �↔ⅹ�� TList                     굇}
{굇                                                                        굇}
{굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇}

constructor TList.Init;
begin

  Count       := 0;
  Size        := 0;
  ActiveItem  := Nil;
  Head        := Nil;
  Tile        := Nil;

end;{ TList.Init }

{굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇}

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

{굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇}

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

{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇� }

destructor TList.Done;
Var
  I : Word;

begin

end;{ TList.Done }

End.