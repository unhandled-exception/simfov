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
{ ³                     Œ®¤ã«ì TUtil.                         ³ }
{ ³                                                           ³ }
{ ³            „®¯®«­¨â¥«ì­ë¥ ¯à®æ¥¤ãàë ¨ äã­ªæ¨¨.            ³ }
{ ³                                                           ³ }
{ ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ }
{ ³                                                           ³ }
{ ³                     Turbo  Pascal                         ³ }
{ ³                      Version 6.0                          ³ }
{ ³                Copyright (c) 1983,90 by                   ³ }
{ ³               Borland International, Inc                  ³ }
{ ³                                                           ³ }
{ ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ }
Unit TUtil;
Interface

Uses Crt, TDrivers;

Type

  Param4Record  = Record

    BChar : Char;
    PI1   : Integer;
    PI2   : Integer;
    PD    : Real;

  end;


Function  BSqr     ( B : Word; ST : Byte ) : Word ;
Function  UpString ( IStr : String ) : String;

procedure RVal     (     VS : string; Var P4R : Param4Record );
procedure RStr     ( Var VS : string;     P4R : Param4Record );



 Implementation

Function BSqr ( B : Word; ST : Byte ) : word ;
Var
 i,s : word;
Begin

  s := 1;

  For i := 1 to ST do
   s := s * B;

  BSqr := s;

End;

{ ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }

Function UpString( IStr : String ) : String;
Var
  i : byte;
Begin

  For I := 1 to Length( IStr ) do
     IStr[ i ] := UpCase( IStr[ i ] );

  UpString := IStr;

End;{ UpString }

{ ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }

procedure RVal( VS : string; Var P4R : Param4Record );
Var
  S : String[ 20 ];
  I,K,
  b,e : byte;
  code : integer;
  BFlag : Boolean;

begin

  BFlag := False;

  With P4R do
  begin

    BChar := ' ';
    PI1   := 0;
    PI2   := 0;
    PD    := 0;

  end;

  i := Pos( '-',VS );
  If i <> 0 Then
    begin

      P4R.BChar := '-';
      Delete( VS, i, 1 );

    end
      else
        P4R.BChar := ' ';


  k := 1;
  i := 1;

  While K <= 3 do
    begin

      Case VS[ i ] of

         ' ': begin

                If BFlag = True Then
                  begin

                    e := i;

                    S := Copy( VS, b, e - b );

                    Case k of

                      1 : Val( S, P4R.PI1, code );
                      2 : Val( S, P4R.PI2, code );
                      3 : Val( S, P4R.PD , code );

                    end;

                    BFlag := False;

                    Inc( k );

                  end;

              end;
         else
           begin

             If BFlag = False Then
               begin

                 BFlag := True;
                 B := i;

               end;

           end;

      end;{ Case VS[ i ] }

      Inc( i );

    end;

end;


{ ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }

procedure RStr( Var VS : string; P4R : Param4Record );
Var
  S : String[ 20 ];

begin

  With P4R do
  begin

    VS := '';
    VS := VS + BChar;

    Str( PI1:2, S );
    VS := VS + S + ' ';

    Str( PI2:2, S );
    VS := VS + S + ' ';

    Str( Pd : 6 : 3, S );
    VS := VS + S;

  end;

end;{ RStr }


End.