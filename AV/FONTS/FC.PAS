program fontconvert;

Uses Crt;

procedure Convert( SFI, SFO : String );
Var
  I, K,
  N, B    : Word;
  C       : Byte;
  FI      : File of Byte;
  FO      : Text ;
begin

 {$I-}

  Assign( FI, SFI );
  Reset( FI );

  Assign( FO, SFO );
  ReWrite( FO );

  K := FileSize( FI );
  N := K div 256;

  WriteLn( 'Font8x', N );

  TextAttr := LightGray + Black * 16 + Blink;
  WriteLn( 'Converting...' );

  WriteLn( FO, 'Unit TFont8x', N, ';');
  WriteLn( FO );
  WriteLn( FO, 'Interface' );
  WriteLn( FO );
  WriteLn( FO, 'Const' );
  Write( FO, '  Font8x', N, ' : Array[ 1 .. 256, 1 .. ' );
  WriteLn( FO, N, ' ] of Byte = ' );
  WriteLn( FO, '  (' );

  For I := 1 To 256 do
   begin
     Write( FO, '   {', I : 3, '}' );
     Write( FO, ' ( ' );
     For B := 1 to N do
      begin
        Read( FI, C );
        Write( FO, ' ', C : 3 );
        IF B < 8 Then
          Write( FO, ',' );
      end;
     Write( FO, ')' );
     If I < 256 Then
       WriteLn( FO, ',' );
   end;

  WriteLn( FO, '   );' );
  WriteLn( FO );
  WriteLn( FO );

  WriteLn( FO, 'Implementation' );
  WriteLn( FO );
  WriteLn( FO, 'End;' );

 {$I+}

  Close( FO );
  Close( FI );

end;{ Convert }

Var
  SI, SO : String;

begin

  ClrScr;

  IF ParamCount >= 2 Then
    begin

      SI := ParamStr( 1 );
      SO := ParamStr( 2 );

      WriteLn( 'Input  File: ', SI );
      WriteLn( 'Output File: ', SO );

    end
   else
     begin

       WriteLn('Convery font to pascal unit');
       WriteLn;
       Write('Input file name: ');
       ReadLn( SI );
       Write('Input pascal unit name: ');
       ReadLn( SO );
       WriteLn;
     end;

  Convert( SI, SO );

  WriteLn( 'Thats ALL!' );

end.{ FontConvert }