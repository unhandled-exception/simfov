{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴� }
{ �                                                           � }
{ �                 OVSoft Text Professional.                 � }
{ �                                                           � }
{ �            룧ぅ� 칛�즤젹� 칛ⅳ췅㎛좂���硫 ㄻ�             � }
{ �           貰ℓ젺⑨ Þ收p芯⒰� � ��レ㎜쥯收ゥ�.            � }
{ �                                                           � }
{ �                      궏褻⑨  2.0                          � }
{ �                                                           � }
{ �                  Copyright (c) 1992 by                    � }
{ �                                                           � }
{ �                 Oleg Volchkov Software.                   � }
{ �                                                           � }
{ �                   All right reserved.                     � }
{ �                                                           � }
{ 쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴� }
{ �                                                           � }
{ �               IBM   PC XT, PC AT 286/386.                 � }
{ �              뙫�ⓥ췴�  EGA, VGA, Hercules.                � }
{ �                                                           � }
{ 쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴� }
{ �                                                           � }
{ �                     뙫ㅳレ TUtil.                         � }
{ �                                                           � }
{ �            꽡��キⓥ�レ�瑜 �昔璵ㅳ贍 � 押�ゆĿ.            � }
{ �                                                           � }
{ 쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴� }
{ �                                                           � }
{ �                     Turbo  Pascal                         � }
{ �                      Version 6.0                          � }
{ �                Copyright (c) 1983,90 by                   � }
{ �               Borland International, Inc                  � }
{ �                                                           � }
{ 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴� }
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

{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇� }

Function UpString( IStr : String ) : String;
Var
  i : byte;
Begin

  For I := 1 to Length( IStr ) do
     IStr[ i ] := UpCase( IStr[ i ] );

  UpString := IStr;

End;{ UpString }

{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇� }

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


{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇� }

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