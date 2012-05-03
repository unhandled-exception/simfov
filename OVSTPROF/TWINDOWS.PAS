UNIT TWindows;

INTERFACE

Uses TStdObj, TDrivers, Crt;

Const

  woTitleCenter  =     1;
  woTitleRight   =     2;
  woTitleLeft    =     4;
  woShadow       =     8;
  woCentered     =    16;

  woNormal       = woTitleCenter or woShadow;

Type

  PWindow   = ^TWindow;
  TWindow   = Object ( TMain )

    WRect       : TRect;
    WTitle      : String[ 78 ];
    WOptions    : Word;
    WBorder     : String[ 8 ];

    Cursor      : TPoint;

    OldWindow   : TRect;
    OldCursor   : TPoint;

    CNormal     : Byte;
    CBorder     : Byte;
    CTitle      : Byte;
    CShadow     : Byte;

    constructor Init( WR : TRect; WT : String; WO : Word );
    procedure   SetOptions( CN, CB, CT, CS : Byte; WB : String );
    procedure   Draw;
    procedure   Activate;
    procedure   DeActivate;
    destructor  Done;

   Private

    Buffer       : Pointer;
    BufSize      : Word;
    BufAllocate  : Boolean;

  end;{ TWindow }

IMPLEMENTATION

constructor TWindow.Init( WR : TRect; WT : String; WO : Word );
Var
  Width, Height : Byte;
begin

  WRect     := WR;
  WTitle    := WT;
  WOptions  := WO;
  WBorder   := '…Õª∫∫»Õº';

  CNormal   := White      + Blue  * 16;
  CBorder   := White      + Blue  * 16;
  CTitle    := Yellow     + Blue  * 16;
  CShadow   := LightGray  + Black * 16;

  Buffer      := Nil;
  BufSize     :=  0;
  BufAllocate := False;

  With WRect do
  begin

    Width   := B.X - A.X + 1;
    Height  := B.Y - A.Y + 1;

    If WOptions and woCentered <> 0 Then
      begin

        A.X := ( VideoXRes - Width ) div 2;
        B.X := A.X + Width - 1;

        A.Y := ( VideoYRes - Height ) div 2;
        B.Y := A.Y + Height - 1;

      end;

  end;{ With WRect }

  Cursor.X := 1;
  Cursor.Y := 1;

end;{ TWindow.Init }

procedure TWindow.SetOptions( CN, CB, CT, CS : Byte; WB : String );
Var
  Width, Height : Byte;
begin

  CNormal  := CN;
  CBorder  := CB;
  CTitle   := CT;
  CShadow  := CS;

  WBorder  := WB;

  BufSize  :=  0;

end;{ TWindow.SetOptions }


procedure TWindow.Draw;
Var
  Width, Height, I, KX, KY  : Byte;

begin

 With WRect do
 begin


  Width   := B.X - A.X + 1;
  Height  := B.Y - A.Y + 1;

  If WOptions and woShadow <> 0 Then
    begin

      KX := 0;
      KY := 0;

      If ( B.X + VideoShadow ) > VideoXRes Then
        KX := B.X + VideoShadow - VideoXRes;

      If ( B.Y + 1 ) > ( VideoYRes + 1 ) Then
        KY := 1;

      If Not BufAllocate Then
       begin

         BufSize :=  ( Width + VideoShadow - KX ) * 2 * ( Height + 1 - KY );

         Window( A.X, A.Y, B.X + VideoShadow - KX , B.Y + 1 );
         If Buffer = Nil Then
           GetMem( Buffer, BufSize );

       end;

    end
     else
      If Not BufAllocate Then
       begin
         BufSize := Width * 2 * Height;
         Window( A.X, A.Y, B.X, B.Y );
         If Buffer = Nil Then
            GetMem( Buffer, BufSize );
       end;

  If Not BufAllocate Then
    begin
      ReadWin( Buffer^ );
      BufAllocate := True;
    end;
  Window( A.X, A.Y, B.X, B.Y );

  FillWin( ' ', CNormal );

  WriteChar( 1    , 1     , 1, WBorder[ 1 ], CBorder );
  WriteChar( Width, 1     , 1, WBorder[ 3 ], CBorder );
  WriteChar( 1    , Height, 1, WBorder[ 6 ], CBorder );
  WriteChar( Width, Height, 1, WBorder[ 8 ], CBorder );

  WriteChar( 2    , 1     , Width - 2, WBorder[ 2 ], CBorder );
  WriteChar( 2    , Height, Width - 2, WBorder[ 7 ], CBorder );

  For I := 2 To Height - 1 do
    begin

      WriteChar( 1    , I, 1, WBorder[ 4 ], CBorder );
      WriteChar( Width, I, 1, WBorder[ 5 ], CBorder );

    end;


  If WOptions and woTitleRight <> 0 Then
    WriteStr( ( Width - Length( WTitle ) ) - 1, 1, WTitle, CTitle )
   else
  If WOptions and woTitleLeft <> 0 Then
    WriteStr( 3, 1, WTitle, CTitle )
   else
    WriteStr( ( Width - Length( WTitle ) + 1) div 2, 1, WTitle, CTitle );

  If WOptions and woShadow <> 0 Then
    begin

      For I := 1 to Height do
        ChangeAttrAbs( B.X + 1, A.Y + I, VideoShadow, CShadow );

      ChangeAttrAbs( A.X + VideoShadow, B.Y + 1, Width, CShadow );

    end;

  Window( A.X + 1, A.Y + 1, B.X - 1, B.Y - 1 );

 end;{ With WRect }

 TextAttr := CNormal;

end;{ TWindow.Draw }

procedure TWindow.Activate;
begin

  With OldWindow do
  begin

    A.X := Lo( WindMin ) + 1;
    A.Y := Hi( WindMin ) + 1;
    B.X := Lo( WindMax ) + 1;
    B.Y := Hi( WindMax ) + 1;

  end;

  With OldCursor do
  begin

    X := WhereX;
    Y := WhereY;

  end;

  With WRect do
    Window( A.X + 1, A.Y + 1, B.X - 1, B.Y - 1 );

  GotoXY( Cursor.X, Cursor.Y );

end;{ TWindow.Activate }

procedure TWindow.DeActivate;
begin

  Cursor.X := WhereX;
  Cursor.Y := WhereY;

  With OldWindow do
    Window( A.X, A.Y, B.X, B.Y );

  With OldCursor do
    GotoXY( X, Y );

end;{ TWindow.Activate }

destructor TWindow.Done;
Var
  KX, KY : Byte;
begin

 With WRect do
 begin
  If WOptions and woShadow <> 0 Then
    begin

      KX := 0;
      KY := 0;

      If ( B.X + VideoShadow ) > VideoXRes Then
        KX := B.X + VideoShadow - VideoXRes;

      If ( B.Y + 1 ) > ( VideoYRes + 1 ) Then
        KY := 1;

      Window( A.X, A.Y, B.X + VideoShadow - KX , B.Y + 1 - KY )

    end
     else
       begin
         Window( A.X, A.Y, B.X, B.Y );
       end;

  WriteWin( Buffer^ );

  FreeMem( Buffer, BufSize );

 end; { With WRect }
end;

END.
