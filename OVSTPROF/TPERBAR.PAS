Unit TPerBar;
Interface

Uses TDrivers, TStdObj, TWindows, CRT;

Const

   ccPBWindow          : Byte = White     + Blue * 16;
   ccPBBorder          : Byte = White     + Blue * 16;
   ccPBTitle           : Byte = Yellow    + Blue * 16;
   ccPBNormalBar       : Byte = White     + Blue * 16;
   ccPBAccentBar       : Byte = White     + Blue * 16;
   ccPBPercentStr      : Byte = White     + Blue * 16;

   fcPBNormalBar       : Char = '°';
   fcPBAccentBar       : Char = 'Û';

Type

   PPercentBar = ^TPercentBar;
   TPercentBar = Object

     PBWindow   : PWindow;
     R          : TRect;

     AFlag      : Boolean;

     Size       : Word;
     Number     : Word;

     BLen       : Byte;

     constructor Init( AR : TRect; Title : String; ASize : Word );
     procedure SetNumber( ANumber : Word );
     procedure Draw;
     destructor Done;
   end;

Implementation

constructor TPercentBar.Init( AR : TRect; Title : String; ASize : Word );
begin

  R := AR;

  With R do
  begin
    B.Y := A.Y + 4;
    BLen := B.X - A.X + 1 - 6 ;
  end;

  PBWindow := New( PWindow, Init( R, Title, woShadow ));
  PBWindow^.SetOptions( ccPBWindow, ccPBBorder, ccPBTitle,
                                LightGray + Black * 16, DoubleFrame );
  Size   := ASize;
  If Size = 0 Then
    Size := 1;
  Number := 0;
  AFlag  := False;

end;{ TPercentBar.Init }

procedure TPercentBar.SetNumber( ANumber : Word );
Var
  S : String;
  I : Integer;
begin

  Number := ANumber;
  If AFlag Then
  begin

    PBWindow^.Activate;

{    WriteChar( 3, 2, BLen, fcPBNormalBar, ccPBNormalBar );
 }
    IF Number > 0 Then
      WriteChar( 3, 2, Byte( trunc ( BLen * ( Number / Size ) ) ),
                                              fcPBAccentBar, ccPBAccentBar );

    I := Trunc( Number / Size * 100 );
    Str( I : 3, S );
    WriteStr( ( R.B.X - R.A.X + 1 ) div 2 - 2 , 3, S + '%', ccPBPercentStr );

    PBWindow^.DeActivate;

  end;

end;{ TPercenBar.SetNumber }

procedure TPercentBar.Draw;
Var
  S : String;
  I : Integer;
begin

  PBWindow^.Draw;
  AFlag := True;

  WriteChar( 3, 2, BLen, fcPBNormalBar, ccPBNormalBar );
{
  IF Number > 0 Then
    WriteChar( 3, 2, Trunc( BLen * ( Number / Size ) ),
                                              fcPBAccentBar, ccPBAccentBar );
  I := Trunc( Number / Size * 100 );
  Str( I, S );
  WriteStr( ( R.B.X - R.A.X + 1 ) div 2 , 3, S + '%', ccPBPercentStr );
 }
  SetNumber( 0 );

end; { TPercentBar }

destructor TPercentBar.Done;
begin

  Dispose( PBWindow, Done );

end;

end. { TPerBar }
