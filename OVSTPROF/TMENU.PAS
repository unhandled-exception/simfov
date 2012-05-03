{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿ }
{ ³                                                           ³ }
{ ³                 OVSoft Text Professional.                 ³ }
{ ³                                                           ³ }
{ ³             ª¥â ¯p®£p ¬¬ ¯p¥¤­ §­ ç¥­­ë© ¤«ï             ³ }
{ ³           á®§¤ ­¨ï ¨­â¥pä¥©á  á ¯®«ì§®¢ â¥«¥¬.            ³ }
{ ³                                                           ³ }
{ ³                      ‚¥àá¨ï  2.0                          ³ }
{ ³                                                           ³ }
{ ³                  Copyright (c) 1992 by                    ³ }
{ ³                                                           ³ }
{ ³                 Oleg Volchkov Software.                   ³ }
{ ³                                                           ³ }
{ ³                   All right reserved.                     ³ }
{ ³                                                           ³ }
{ ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ }
{ ³                                                           ³ }
{ ³               IBM   PC XT, PC AT 286/386.                 ³ }
{ ³              Œ®­¨â®pë  EGA, VGA, Hercules.                ³ }
{ ³                                                           ³ }
{ ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ }
{ ³                                                           ³ }
{ ³                     Œ®¤ã«ì TMenu.                         ³ }
{ ³                                                           ³ }
{ ³   à®æ¥¤ãàë ¨ äã­ªæ¨¨ ¤«ï à ¡®âë á ¨¥à àå¨ç¥áª¨¬¨ ¬¥­î    ³ }
{ ³                   áâp®ª ¬¨ áâ âãá .                       ³ }
{ ³                                                           ³ }
{ ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ }
{ ³                                                           ³ }
{ ³                     Turbo  Pascal                         ³ }
{ ³                      Version 6.0                          ³ }
{ ³                Copyright (c) 1983,90 by                   ³ }
{ ³               Borland International, Inc                  ³ }
{ ³                                                           ³ }
{ ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ }
   

{$F+,O+}

Unit TMenu;

Interface

Uses Crt,    Dos,  TStdObj,
     TUtil, TDrivers,
     TColors;

const

   MaxVMenuItem = 20 ;
   MaxMenuLine  = 10 ;
   MaxHMenuItem = 15 ;
   MaxStatusLineItem = 100;
   MenuStatusString  : String = '~'#24#25#26#27'~ - move in menu  ~'#17'ÄÙ~ - select from menu';

Type

 TMString = String[ 70 ];
 TSLString = String[ 40 ];
 FLString = String[ MaxVMenuItem ];


{ ¯¨á ­¨¥ áâ®pª¨ £« ¢­®£® ¬¥­î }
{ ----------------------------- }

 MMItem = record

     MenuString : String[80];   { ‘âp®ª  £« ¢­®£® ¬¥­î           }
     HelpIndex  : Word      ;   { H®¬¥p ¯®¬®é¨ ¤«ï £« ¢­®£® ¬¥­î }

     ItemsCoord : Word      ;

     End;


 SubMenuPtr = ^SubMenuObject;


 { ¯¨á ­¨¥ £« ¢­®£® ¬¥­î }


  MainMenuObject = Object

     SubMenuArray     : Array[1..MaxHMenuItem] of SubMenuPtr;
     MenuRecArray     : Array[1..MaxHMenuItem] of MMItem;

     SubMenuNum      : Word ;
     MMNumSelectItem  : Word;

     FLS               : FLString;

     constructor Init;
     procedure NewSubMenu ( MString : String; HelpContext : Word );
     Function GetNumItems:Word;
     procedure Draw;
     function MainMenuSelect : Word ;
     procedure ActivateMenuItem( MI : Word; Active : boolean );

   End;{ MainMenuObject }

{ ¯¨á ­¨¥ áâp®ª¨ ¯®¤¬¥­î }
{ ----------------------- }

 SMItem = record

     MenuString : String[70];   { ‘âp®ª  ¯®¤¬¥­î              }
     HelpIndex  : Word      ;   { H®¬¥p ¯®¬®é¨ ¤«ï ¯®¤¬¥­î    }

     CloseFlag  : Boolean   ;   { }

     ItemsEvent : Word      ;   {}
     ItemsKey   : Word      ;   { Š« ¢¨è  ¤«ï ¡ëáâp®£® ¢ë¡®p  }

     ItemsCoord : Word      ;

     ActivateFlag : Boolean;

     End;



{ ¯¨á ­¨¥ ¯®¤¬¥­î }
{ ---------------- }

 SubMenuObject = Object

     SubMenuYesOrNo    : array[1..MaxVMenuItem] of Byte;
     SubMenuArray      : array[1..MaxVMenuItem] of SubMenuPtr;

     MenuRecArray      : array[1..MaxVMenuItem] of SMItem;
     MenuLineArray     : array[1..MaxMenuLine] of Byte;

     FLS               : FLString;

  { Š®®p¤¨­ âë ®ª­  ¯®¤¬¥­î }
  { ----------------------- }

     MCoordX1 ,
     MCoordX2 ,
     MCoordY1 ,
     MCoordY2          : Word;

     BufForSaveWindow  : Pointer;


     SubMenuNum        : Word;
     SubMenuLine       : Word;
     SMNumSelectItem   : Word;
     SMSMNum           : Word;
     MSMenuNum         : Word;

     constructor Init ( x , y : Word );

     procedure NewItem( MString : TMString; EventNum , HelpContext : Word;
                                                          CFlag : Boolean );
     procedure NewSubMenu( MString : TMString; HelpContext : Word );
     procedure NewLine;
     function  GetNumItems : Word ;
     procedure Draw;
     procedure SubMenuSelect ;
     procedure GetNextMenuCoord(var x,y:word);
     procedure ActivateMenuItem( MI : Word; Active : boolean );


   End; { SubMenu }

var

   MReturnSelectItem : Word ;


Implementation


const

  KN = 0;
  KR = 1;
  KL = 2;
  KE = 3;
  KA = 4;

  AddCount : Byte = 4;

  MenuActivateFlag : Boolean = False;

  SMN : Byte = 0;

var
   i,k,n,x,y,KT : byte ;

   MenuCloseFlag : Boolean ;
   MenuExitFlag  : Boolean ;

{   MReturnSelectItem : Word ;
 }
   TFLS : FLString;

   KAC : Char;

   MMS : Byte;

procedure CloseMenuWindow;
Var

  W: WinRecPtr;

begin

  Inc(WindMax, $0103);
  WindMin := WindMin - 1;

  if TopWindow <> nil then
  begin

    W := TopWindow;

    with W^ do
      begin

        UnFrameWin;
        WriteWin(Buffer^);
        FreeMem(Buffer, WinSize);
        FreeMem(Title, Length(Title^) + 1);
        RestoreWin(State);
        TopWindow := Next;

      end;

    Dispose(W);
    Dec(WindowCount);

 end;

end;

constructor SubMenuObject.Init( x,y : Word );
Begin

   SubMenuNum  :=  0  ;
   SubMenuLine :=  0  ;

   FLS         :=  '' ;

   MCoordX1    :=  x      ;
   MCoordY1    :=  y      ;
   MCoordY2    :=  y + 1  ;
   MCoordX2    :=  x + 1  ;
   SMNumSelectItem := 1   ;
   SMSMNum     := 0;
   MSMenuNum   := 0;

End;

procedure SubMenuObject.GetNextMenuCoord ( var x,y : Word );
Begin

  x :=  MCoordX1 + 2;
  y :=  MCoordy1 +  SubMenuNum + SubMenuLine + 1 ;


End;



procedure SubMenuObject.NewItem( MString : TMString; EventNum ,
                                      HelpContext : Word; CFlag : Boolean );
Var FL : Byte;
Begin

  If MString = '' Then
    MString := ' ';

  If SubMenuNum = 0 Then
    Begin

     MCoordX2 := McoordX1 + Length(MString) + AddCount + 3;

    End

  else
     if (MCoordX2 - MCoordX1 - 6) <=  Length(MString) then
       begin

         MCoordX2 := McoordX1 + Length(MString) + AddCount ;

       end;

 If ( MSMenuNum > 0 ) then
   MCoordX2 := MCoordX2 + 1;

  If MCoordX2 + 2 > 80 Then
    Begin

      MCoordX1 := MCoordX1 - (MCoordX2-80 + 2 );
      MCoordX2 := 80 - 2;


    End;

  Inc(MCoordY2);

  IF MCoordY2 + 1 > 24 Then
   Begin

    MCoordY1 := MCoordY1 - ( MCoordY2 -  24 + 1 );
    MCoordY2 := 24 - 1;

   End;



  SubMenuNum := SubMenuNum  + 1;


  SubMenuYesOrNo[ SubMenuNum ] :=  No;

  With MenuRecArray[ SubMenuNum ] do
     Begin

        MenuString :=  MString      ;
        HelpIndex  :=  HelpContext  ;

        CloseFlag  :=  CFlag        ;

        ItemsEvent :=  EventNum     ;
        ActivateFlag := True;
        ItemsCoord :=  SubMenuNum + SubMenuLine  ;

        FL := Pos( '~', MenuString );
        If FL <> 0 Then
          FLS := FLS + UpCase( MenuString[ FL + 1 ] )
            else
              FLS := FLS + ' ';

     End;



End;


procedure SubMenuObject.NewSubMenu( MString : TMString; HelpContext : Word );
var
  c,x,y : Word;
  FL    : byte;
Begin

  If MString = '' Then
    MString := ' ';

  Inc( MSMenuNum );

  If SubMenuNum = 0 Then
    Begin

     MCoordX2 := McoordX1 + Length(MString) + AddCount + 6 ;

    End;


  if (MCoordX2 - MCoordX1 - 6 ) <=  Length(MString) then
    MCoordX2 := McoordX1 + Length(MString) + AddCount;


  If MCoordX2 + 2  > 80  Then
     Begin

      MCoordX1 := MCoordX1 - (MCoordX2 - ( 80 - 2 ));
      MCoordX2 := 80 - 2;

     End;

  Inc(MCoordY2);

  IF MCoordY2 + 1 > 24 Then
   Begin

    MCoordY1 := MCoordY1 - ( MCoordY2 - ( 24 - 1 ) );
    MCoordY2 := 24 - 1;

   End;

  SubMenuNum := SubMenuNum  + 1;


  SubMenuYesOrNo[ SubMenuNum ] :=  Yes;

  With MenuRecArray[ SubMenuNum ] do
     Begin

        MenuString :=  MString      ;
        HelpIndex  :=  HelpContext  ;

        ItemsCoord :=  SubMenuNum + SubMenuLine  ;
        ActivateFlag := True;

        FL := Pos( '~', MenuString );
        If FL <> 0 Then
          FLS := FLS + UpCase( MenuString[ FL + 1 ] )
            else
              FLS := FLS + ' ';

     End;

  c := SubMenuNum + SubMenuLine ;

  x := MCoordX1+2;
  y := MCoordY1+c+1;

  New(SubMenuArray[ SubMenuNum ]);

  With SubMenuArray[ SubMenuNum ]^ do
    Begin

      Init(x ,y );

    End;

End;



procedure SubMenuObject.NewLine;
Begin

  inc(SubMenuLine);

  MenuLineArray [ SubMenuLine ] :=  SubMenuNum + SubMenuLine ;

  inc(MCoordY2);

  IF MCoordY2 + 1 > 24 Then
   Begin

    MCoordY1 := MCoordY1 - ( MCoordY2 - ( 24 - 1 ) );
    MCoordY2 := 24 - 1;

   End;

End;



Procedure SubMenuObject.Draw;
          {******************}

var num : byte;
    Ws   : WinRecPtr ;
    i   : Byte      ;
    W, H, Y, X, k: Word;

Begin

  New(WS);

  with WS^ do
  Begin

    Next := TopWindow;

    SaveWin(State);

    FrameAttr := MenuFrameColor  ;
    GetMem(Title, 1 );
    Title^ := '';

    Window( MCoordX1 , MCoordY1, MCoordX2 + 2, MCoordY2 + 1 );

    GetMem(Buffer, WinSize);
    ReadWin(Buffer^);

  { ®áâp®¥­¨¥ ®ª­  ¤«ï ¬¥­î. }
  { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

    W := Lo(WindMax) - Lo(WindMin) + 1;
    H := Hi(WindMax) - Hi(WindMin) + 1;

  { ®áâp®¨âì ¢¥på p ¬ª¨ ®ª­ . }
  { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

    WriteChar(2, 1, 1, 'Ú', FrameAttr);
    WriteChar(3, 1, W - 6, 'Ä', FrameAttr);
    WriteChar(W - 3, 1, 1, '¿', FrameAttr);

  { ®áâp®¨âì ¡®ª®¢ë¥ áâ®p®­ë p ¬ª¨ ®ª­ . }
  { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

    for Y := 2 to H - 2 do
    Begin
     WriteChar(2, Y, 1, '³', FrameAttr);
     WriteChar(W-3, Y, 1, '³', FrameAttr);
    End;

    for Y := 1 to H - 1 do
    Begin
     WriteChar(1, Y, 1, ' ', FrameAttr);
     WriteChar(W-2, Y, 1, ' ', FrameAttr);
    End;

    For k := 1 to SubMenuLine do
     Begin
      WriteChar(2, MenuLineArray[ k ] + 1 , 1 ,'Ã',FrameAttr);
      WriteChar(W-3, MenuLineArray[ k ] + 1 , 1 ,'´',FrameAttr);
     End;


  { ®áâp®¨âì ­¨§ p ¬ª¨ ®ª­ . }
  { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

    WriteChar(2, H - 1, 1, 'À', FrameAttr);
    WriteChar(3, H - 1, W - 6, 'Ä', FrameAttr);
    WriteChar(W - 3, H - 1, 1, 'Ù', FrameAttr);

  { ®áâp®¨âì â¥­ì ®ª­ . }
  { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }
{
    ChangeAttrAbs( MCoordX1 + 2, MCoordY2 + 1, W - 2, MenuShadowColor );
    For Y := 2 to H do
      ChangeAttrAbs( MCoordX2 + 1 , MCoordY1 + Y -1 ,  2 , MenuShadowColor );
}
    ChangeAttr( 3, H , W - 1, MenuShadowColor );
    For Y := 2 to H do
      ChangeAttr( W - 1 , Y ,  2 , MenuShadowColor );


  { “áâ ­®¢¨âì ­®¢ë¥ p §¬¥pë ®ª­ . }
  { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

    Inc(WindMin, $0102);
    Dec(WindMax, $0204);

  { ‡ ªâ á¨âì ®ª­®. }
  { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

    FillWin(' ', MenuNormalText);


 End;

  TopWindow := WS;
  Inc(WindowCount);


  For num := 1 to SubMenuNum do
    With  MenuRecArray[num] do
     Begin
       ColorPut(2,ItemsCoord,MenuString,MenuNormalText,MenuNormalAcText);
       if SubMenuYesOrNo [ num ] = Yes Then
         WriteChar(MCoordX2-MCoordX1-4,ItemsCoord,1,#16,MenuNormalText);

       If Not ActivateFlag Then
         begin
           ColorPut(2,ItemsCoord,MenuString,MenuDisabledText,MenuDisabledAcText);
           if SubMenuYesOrNo [ num ] = Yes Then
             WriteChar(MCoordX2-MCoordX1-4,ItemsCoord,1,#16,MenuDisabledText);
         end;

     End;
  For num := 1 to SubMenuLine do
     WriteChar(1,MenuLineArray[num],MCoordX2-MCoordX1 - 3,'Ä',MenuFrameColor);


End;

procedure SubMenuObject.ActivateMenuItem( MI : Word; Active : boolean );
Var i : byte;
begin

end;

Function SubMenuObject.GetNumItems : Word ;
Begin

  GetNumItems := SubMenuNum;

End;

procedure SubMenuObject.SubMenuSelect;
var i,n,k,p : word;
    ch    : Word;
    FL,FK : Byte;
Begin

  k := 1;

  ch := 0;
  i := SMNumSelectItem ;
  n := SMNumSelectItem ;

  Inc( SMN );

  Draw;

  With MenuRecArray[ n ] do
   Begin
    WriteChar( 1, ItemsCoord , MCoordX2 - MCoordX1,' ',MenuAccentText);
    ColorPut ( 2, ItemsCoord , MenuString,MenuAccentText,MenuAccentAcText);

    if SubMenuYesOrNo [ i ] = Yes Then
     WriteChar(MCoordX2-MCoordX1-4,ItemsCoord,1,#16, MenuAccentText);

    If Not ActivateFlag Then
      begin
        ColorPut(2,ItemsCoord,MenuString,MenuDisabledAccentText,MenuDisabledAccentAcText);
        if SubMenuYesOrNo [ i ] = Yes Then
          WriteChar(MCoordX2-MCoordX1-4,ItemsCoord,1,#16,MenuDisabledAccentText);
      end;


   End;


  If MenuCloseFlag = False  Then
   if SubMenuYesOrNo [ SMNumSelectItem ] = Yes Then
    Begin

     SubMenuArray[ SMNumSelectItem ]^.SubMenuSelect;

  If MenuExitFlag Then
   Begin

    CloseMenuWindow;
    Dec(SMN);
    Exit ;

   End;


  If (KT = KL) or (KT = KR) or ( KT = KA ) Then
   Begin
    SMNumSelectItem  := i;

    CloseMenuWindow;
    MenuCloseFlag := True ;
    Dec(SMN);
    Exit;

   End;


    End;

  MenuExitFlag := False ;

  While k = 1 do
   Begin
    ch := GetKey ;
     case ch of
       kbEsc   : Begin

                  SMNumSelectItem  := i;

                  CloseMenuWindow;

                  KT := KE;
                  MenuCloseFlag := True ;

                  Dec(SMN);

                  Exit;

                 End;

       kbAltQ .. kbAltP ,
       kbAltA .. kbAltL ,
       kbAltZ .. kbAltM ,
       kbAlt1 .. kbAlt0   :   Begin

                                p := Pos( AltChar( ch ), TFLS );

                                If ( P > 0 ) and (MMs <> P ) Then
                                  begin

                                    KAC :=  AltChar( ch ) ;

                                    KT := KA;
                                    SMNumSelectItem  := i;
                                    CloseMenuWindow;
                                    MenuCloseFlag := True ;
                                    Exit;

                                 end;

                                If ( P > 0 ) and (MMs = P ) and ( SMN <> 1 ) Then
                                  begin

                                    KAC :=  AltChar( ch ) ;

                                    KT := KA;
                                    SMNumSelectItem  := i;
                                    CloseMenuWindow;
                                    MenuCloseFlag := True ;
                                    Exit;

                                 end;

                              End;

       kbEnter : Begin
                  if SubMenuYesOrNo [ i ] = Yes Then
                   Begin
                    MenuCloseFlag := True ;
                    With SubMenuArray[ i ]^ do SubMenuSelect;
                   End;

                 If SubMenuYesOrNo [ i ] = No Then
                  Begin

                   MenuCloseFlag :=  MenuRecArray[ i ].CloseFlag ;
                   MenuExitFlag := True ;

                   MReturnSelectItem  :=  MenuRecArray[ i ].ItemsEvent ;

                   SMNumSelectItem  := i;

                   CloseMenuWindow;

                   Exit ;

                  End;

                 End;
       kbDn :
            Begin
              n := i;
              Inc(i);
              if i > SubMenuNum then i := 1 ;
             End;
       kbUp :
             Begin
              n := i;
              Dec(i);
              if i < 1 then i := SubMenuNum  ;
             End;

            kbRight : KT := KR;
            kbLeft  : KT := KL;
            kbHome  : begin

                       n := i;
                       i := 1;

                      end;

            kbEnd   : begin

                       n := i;
                       i := SubMenuNum;

                      end;

            else
              begin

                If Ch <= 256 Then
                  begin

                      FK := Pos( UpCase( Chr( Byte( Ch ) ) ), FLS );

                      If FK <> 0 Then
                       begin

                       N := i;
                       i := fk;

                       With MenuRecArray[ n ] do
                        Begin
                         WriteChar( 1, ItemsCoord , MCoordX2 - MCoordX1,' ',MenuNormalText);
                         ColorPut ( 2, ItemsCoord , MenuString,MenuNormalText,MenuNormalAcText);
                         if SubMenuYesOrNo [ n ] = Yes Then
                          WriteChar(MCoordX2-MCoordX1-4,ItemsCoord,1,#16,
                                                          MenuNormalText);
                         If Not ActivateFlag Then
                           begin
                             ColorPut(2,ItemsCoord,MenuString,MenuDisabledText,MenuDisabledAcText);
                             if SubMenuYesOrNo [ i ] = Yes Then
                               WriteChar(MCoordX2-MCoordX1-4,ItemsCoord,1,#16,MenuDisabledText);
                           end;

                        End;

                       With MenuRecArray[ i ] do
                        Begin
                         WriteChar( 1, ItemsCoord , MCoordX2 - MCoordX1,' ',MenuAccentText);
                         ColorPut ( 2, ItemsCoord , MenuString,MenuAccentText,MenuAccentAcText);

                         if SubMenuYesOrNo [ i ] = Yes Then
                          WriteChar(MCoordX2-MCoordX1-4,ItemsCoord,1,#16,
                                                           MenuAccentText);
                         if Not ActivateFlag Then
                           begin
                             ColorPut(2,ItemsCoord,MenuString,MenuDisabledAccentText,MenuDisabledAccentAcText);
                             if SubMenuYesOrNo [ i ] = Yes Then
                               WriteChar(MCoordX2-MCoordX1-4,ItemsCoord,1,#16,MenuDisabledAccentText);
                           end;

                        End;

                       if SubMenuYesOrNo [ i ] = Yes Then
                        Begin
                         MenuCloseFlag := True ;
                          With SubMenuArray[ i ]^ do SubMenuSelect;
                        End;

                       If SubMenuYesOrNo [ i ] = No Then
                        Begin

                         MenuCloseFlag :=  MenuRecArray[ i ].CloseFlag ;
                         MenuExitFlag := True ;

                         MReturnSelectItem  :=  MenuRecArray[ i ].ItemsEvent ;

                         SMNumSelectItem  := i;

                         CloseMenuWindow;
                         Dec(SMN);
                         Exit ;

                        End;

                     end;

                  end;

              end;

      End;{ Main Case }

  if MenuExitFlag = True Then
   Begin

    SMNumSelectItem  := i;

    CloseMenuWindow;
    Dec(SMN);
    Exit;

   End;

  If (KT = KL) or (KT = KR) or ( KT = KA ) Then
   Begin
    SMNumSelectItem  := i;
    CloseMenuWindow;
    MenuCloseFlag := True ;
    Dec(SMN);
    Exit;
   End;

  With MenuRecArray[ n ] do
   Begin
    WriteChar( 1, ItemsCoord , MCoordX2 - MCoordX1,' ',MenuNormalText);
    ColorPut ( 2, ItemsCoord , MenuString,MenuNormalText,MenuNormalAcText);
      if SubMenuYesOrNo [ n ] = Yes Then
                   WriteChar(MCoordX2-MCoordX1-4,ItemsCoord,1,#16,
                                                          MenuNormalText);
    If Not ActivateFlag Then
      begin
        ColorPut(2,ItemsCoord,MenuString,MenuDisabledText,MenuDisabledAcText);
        if SubMenuYesOrNo [ i ] = Yes Then
          WriteChar(MCoordX2-MCoordX1-4,ItemsCoord,1,#16,MenuDisabledText);
      end;

   End;

   With MenuRecArray[ i ] do
    Begin
     WriteChar( 1, ItemsCoord , MCoordX2 - MCoordX1,' ',MenuAccentText);
     ColorPut ( 2, ItemsCoord , MenuString,MenuAccentText,MenuAccentAcText);

       if SubMenuYesOrNo [ i ] = Yes Then
                    WriteChar(MCoordX2-MCoordX1-4,ItemsCoord,1,#16,
                                                           MenuAccentText);
    If Not ActivateFlag Then
      begin
        ColorPut(2,ItemsCoord,MenuString,MenuDisabledAccentText,MenuDisabledAccentAcText);
        if SubMenuYesOrNo [ i ] = Yes Then
          WriteChar(MCoordX2-MCoordX1-4,ItemsCoord,1,#16,MenuDisabledAccentText);
      end;

      End;

  End;


End;


{ p®æ¥¤ãpë ¤«ï £« ¢­®£® ¬¥­î }
{ *************************** }

constructor MainMenuObject.Init;
Begin

  SubMenuNum     := 0 ;
  MMNumSelectItem := 1 ;

  MenuCloseFlag  := True ;
  MenuExitFlag   := False ;

  FLS            := '';

End;

procedure MainMenuObject.ActivateMenuItem( MI : Word; Active : boolean );
Var i : byte;
begin

end;

procedure MainMenuObject.NewSubMenu ( MString : String; HelpContext : Word );
var
  c,k : word;
  FL  : Byte;
Begin

 inc( SubMenuNum );

 With MenuRecArray[ SubMenuNum ] do
   Begin

    MenuString := MString     ;
    HelpIndex  := HelpContext ;

    If SubMenuNum = 1 Then  ItemsCoord := 3 ;

    If SubMenuNum > 1 Then
     Begin
      ItemsCoord := MenuRecArray[ SubMenuNum - 1 ].ItemsCoord +
                       Length( MenuRecArray[ SubMenuNum - 1 ].MenuString  );

      k := Pos( '~', MenuRecArray[ SubMenuNum - 1 ].MenuString ) ;

      if k = 0 then
       ItemsCoord := ItemsCoord + 3 ;

     End;

    c := ItemsCoord ;


    k := 1 ;
    While MString[ k ] = ' ' do
     begin

      Inc( c );
      Inc( k );

     end;

    FL := Pos( '~', MenuString );
    If FL <> 0 Then
      FLS := FLS + UpCase( MenuString[ FL + 1 ] )
        else
          FLS := FLS + ' ';


    End;{ With }

  If C <= 3 Then C := 4;

  New(SubMenuArray[SubMenuNum]);
  SubMenuArray[SubMenuNum]^.
                        Init( c - 3, 2);


End;


Function MainMenuObject.GetNumItems : Word ;
Begin

  GetNumItems := SubMenuNum;

End;


procedure MainMenuObject.Draw;
Var
 i : word;

Begin

WriteChar(1,1,80,' ',MenuNormalText);

For  i := 1 to SubMenuNum do
  ColorPut( MenuRecArray[i].ItemsCoord ,1 ,
                  MenuRecArray[i].MenuString,
                   MenuNormalText,MenuNormalAcText);

End;


Function MainMenuObject.MainMenuSelect : Word;
label SMSEl;
var i,n,k,m : word;
    ch      : char;

Begin

  TFLS := FLS;

  SMN := 0;

  k := 1;

  ch := ' ';
  i := MMNumSelectItem ;
  n := MMNumSelectItem ;

  MMS := i;

  KT := KN;

  MenuExitFlag := False ;
  MenuActivateFlag := True;

  Draw;

  With MenuRecArray[ n ] do
   Begin

    m := Pos( '~', MenuString );

    if m = 0 Then
     WriteChar( ItemsCoord - 1, 1 , Length(MenuString) + 2,' ',MenuAccentText)
      else
       WriteChar( ItemsCoord - 1, 1 , Length(MenuString),' ',MenuAccentText);

    ColorPut ( ItemsCoord , 1 ,MenuString,MenuAccentText,
                                                    MenuAccentAcText);
   End;

  mms:= i;
  SMN := 0;
  With SubMenuArray[ i ]^ do  SubMenuSelect;


  If MenuExitFlag Then
   Begin

    MMNumSelectItem  := i;
    MenuExitFlag := False ;

    draw;

    MainMenuSelect := MReturnSelectItem;
    MenuActivateFlag := False;

    Exit;

   End;
  While k = 1 do
   Begin

  If (KT = Kl) or (KT = KR) or ( KT = KE ) Then
               goto SMSEL;

 {    ch := ReadKey ;
      case ch of
       kbEsc   : Begin
                  MMNumSelectItem  := i;
                  Draw;
                  MainMenuSelect := cmNoAlt ;
                  Exit;
                 End;

       kbEnter : Begin

                  With SubMenuArray[ i ]^ do
                        SubMenuSelect;

                 End;
       kbNoKey :
        Begin
         ch := ReadKey ;
          case ch of
            kbDn ,
            kbUp    :  Begin
                     With SubMenuArray[ i ]^ do
                          SubMenuSelect;
                    End;
            kbRight :
             Begin
              n := i;
              Inc(i);
              if i > SubMenuNum then i := 1 ;
             End;
            kbLeft  :
             Begin
              n := i;
              Dec(i);
              if i < 1 then i := SubMenuNum  ;
             End;

          End;
        End;
      End; }{ Main Case }

SMSEL:;

 If KT = KE Then
  begin

   MenuCloseFlag := True;
   KT := KE;

   n := i;
   if i > 1 then Dec( i );
   i := 1;

   If MenuExitFlag Then
    Begin

     MMNumSelectItem  := i;
     MenuExitFlag := False ;

     Draw;

     MainMenuSelect := MReturnSelectItem;
     MenuActivateFlag := False;

     Exit;

    End;

  end;

 If KT = Kl Then
   Begin
     n := i;
     Dec(i);
     if i < 1 then
       i := SubMenuNum  ;
   End;

 If KT = KR Then
   Begin
     n := i;
     Inc(i);
     if i > SubMenuNum then
      i := 1 ;
   End;

  If ( KT = KA ) Then
    begin

      n := i;

      i := Pos( KAC, FLS );

    end;

   With MenuRecArray[ n ] do
    Begin

     m := Pos( '~', MenuString );

     if m = 0 Then
      WriteChar( ItemsCoord - 1, 1 , Length(MenuString) + 2,' ',MenuNormalText)
       else
        WriteChar( ItemsCoord - 1, 1 , Length(MenuString),' ',MenuNormalText);

     ColorPut ( ItemsCoord , 1 ,MenuString,MenuNormalText,
                                                    MenuNormalAcText);
    End;

   With MenuRecArray[ i ] do
    Begin
     m := Pos( '~', MenuString );

     if m = 0 Then
      WriteChar( ItemsCoord - 1, 1 , Length(MenuString) + 2,' ',MenuAccentText)
       else
        WriteChar( ItemsCoord - 1, 1 , Length(MenuString),' ',MenuAccentText);

     ColorPut ( ItemsCoord , 1 ,MenuString,MenuAccentText,
                                                    MenuAccentAcText);
    End;

  If (KT = Kl) or (KT = KR) or (KT = KE) or ( KT = KA ) Then
     Begin

      KT := KN;

      mms:= i;
     SMN := 0;

      With SubMenuArray[ i ]^ do
        SubMenuSelect;

      If MenuExitFlag Then
       Begin

        MMNumSelectItem  := i;
        MenuExitFlag := False ;

        Draw;

        MainMenuSelect := MReturnSelectItem;
        MenuActivateFlag := False;

        Exit;

       End;


     End;


  End;


End;

End.
