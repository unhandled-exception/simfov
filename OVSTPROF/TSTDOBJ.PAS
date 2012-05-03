{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿ }
{ ³                                                            ³ }
{ ³                    OVSoft  Pascal + +                      ³ }
{ ³                                                            ³ }
{ ³             ª¥â ¯p®£p ¬¬ ¯p¥¤­ §­ ç¥­­ë© ¤«ï              ³ }
{ ³           á®§¤ ­¨ï ¨­â¥pä¥©á  á ¯®«ì§®¢ â¥«¥¬.             ³ }
{ ³                                                            ³ }
{ ³                      ‚¥àá¨ï  1.0                           ³ }
{ ³                                                            ³ }
{ ³                Copyright (c) 1992,93 by                    ³ }
{ ³                                                            ³ }
{ ³                 Oleg Volchkov Software.                    ³ }
{ ³                                                            ³ }
{ ³                   All right reserved.                      ³ }
{ ³                                                            ³ }
{ ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ }
{ ³                                                            ³ }
{ ³               IBM   PC XT, PC AT 286/386.                  ³ }
{ ³              Œ®­¨â®pë  EGA, VGA, Hercules.                 ³ }
{ ³                                                            ³ }
{ ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ }
{ ³                                                            ³ }
{ ³                    Œ®¤ã«ì TStdObj.                         ³ }
{ ³                                                            ³ }
{ ³ ‘â ­¤ pâ­ë¥ â¨¯ë, ª®­áâ ­âë ¨ ®¡ê¥ªâë ¤«ï ¯ ª¥â¥ OVSTPROF. ³ }
{ ³                                                            ³ }
{ ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ }
{ ³                                                            ³ }
{ ³                     Turbo  Pascal                          ³ }
{ ³                   Version 6.0, 7.0                         ³ }
{ ³                Copyright (c) 1983,90 by                    ³ }
{ ³               Borland International, Inc                   ³ }
{ ³                                                            ³ }
{ ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ }


{$F+,O+}
Unit TStdObj;
Interface

Const

    Yes          = 1  ;
    No           = 2  ;


  { ‘â ­¤ àâ­ë¥ äã­ªæ¨¨. }
  { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

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

   { Š®®à¤¨­ âë ®ª®­. }
   { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

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

  { ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }

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

{±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±}
{±±                                                                        ±±}
{±±                  à®æ¥¤ãàë ¨ äã­ªæ¨¨ ®¡ê¥ªâ  TRect                     ±±}
{±±                                                                        ±±}
{±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±}

Procedure  TRect.Assign( WSX, WSY, WEX, WEY : Integer );
 Begin
         A.X  :=  WSX ;
         A.Y  :=  WSY ;
         B.X  :=  WEX ;
         B.Y  :=  WEY ;

 End;{ Assign }

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

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

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

Procedure  TRect.GetStartCoords ( Var GStartX , GStartY : Integer );
Begin

    GStartX := A.X ;
    GStartY := A.Y ;

End; { GetStartCoords }


{±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±}
{±±                                                                        ±±}
{±±                  à®æ¥¤ãàë ¨ äã­ªæ¨¨ ®¡ê¥ªâ  TMain                     ±±}
{±±                                                                        ±±}
{±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±}

constructor TMain.Init;
begin
end;{ TMain.Init }

{ ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }

destructor TMain.Done;
begin
end;{ TMain.Done }

{ ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }

procedure TMain.HandleEvent( ECommand : Word );
begin
end;{ TMain.HandleEvent }

{ ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }


{±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±}
{±±                                                                        ±±}
{±±                  à®æ¥¤ãàë ¨ äã­ªæ¨¨ ®¡ê¥ªâ  TList                     ±±}
{±±                                                                        ±±}
{±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±}

constructor TList.Init;
begin

  Count       := 0;
  Size        := 0;
  ActiveItem  := Nil;
  Head        := Nil;
  Tile        := Nil;

end;{ TList.Init }

{±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±}

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

{±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±}

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

{ ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }

destructor TList.Done;
Var
  I : Word;

begin

end;{ TList.Done }

End.