
{$F+,O+}

Unit GLib;

Interface

Uses
 Dos;

Const
  NULL     =   #0  ;     { Keys for GetKey & UnGetKey }
  ESCKEY   =  #27  ;
  BSKEY    =   #8  ;
  PUSTO    =  ' '  ;
  CRKEY    =  #13  ;
  HOMEKEY  = #199  ;
  ENDKEY   = #207  ;
  UPKEY    = #200  ;
  DOWNKEY  = #208  ;
  PGUPKEY  = #201  ;
  PGDNKEY  = #209  ;
  LEFTKEY  = #203  ;
  INSKEY   = #210  ;
  RIGHTKEY = #205  ;
  DELKEY   = #211  ;
  F1       = #187  ;
  F2       = #188  ;
  F3       = #189  ;
  F4       = #190  ;
  F5       = #191  ;
  F6       = #192  ;
  F7       = #193  ;
  F8       = #194  ;
  F9       = #195  ;
  F10      = #196  ;
  UserGlass  = 'G' ;

Function Max( a,b : Integer ) : Integer;
Function Min( a,b : Integer ) : Integer;
Function GetKey : Char;
Function ToUpper( Ch : Char ) : Char;
Function Exist( Name : PathStr ) : Boolean;
Function ValidFileName( Path : PathStr ) : Boolean;

Function Word2( LWord, HWord : Word ) : LongInt;
Function LoWord( L : LongInt ) : Word;
Function HiWord( L : LongInt ) : Word;

Implementation
Uses
 Crt;

Function Exist( Name : PathStr ) : Boolean;
Begin
 Exist:= ( FSearch ( Name,'') <> '' );
End;

Function ValidFileName( Path : PathStr ) : Boolean;
var
 l, i : byte; bad : boolean;
begin
 l:=length(Path); i:=1; bad:=false;
 while ( NOT bad AND ( i<=l ) ) do
 begin
  bad := NOT ( ( path[i] >= '0' ) AND ( path[i] <= '9' ) );
  bad := bad AND NOT ( path[i] In ['.',':','\','+','-','_'] );
  bad := bad AND ( ( path[i] < 'A') OR ( path[i] > 'z' ) );
  if ( NOT bad ) then inc(i);
 end;
 ValidFileName := NOT bad;
end;

Function Max( a,b : Integer ) : Integer;
Begin
 If a > b Then Max:=a Else Max:=b;
End;

Function Min( a,b : Integer ) : Integer;
Begin
 If a < b then Min:=a else min:=b;
End;

Function GetKey : Char;
var
  C : Char;
begin
  C := ReadKey;
  repeat
    if C = NULL then
    begin
      C := ReadKey;
      if Ord(C) > 127 then
        C := NULL
      else
        GetKey := Chr(Ord(C) + 128);
    end
    else
      GetKey := C;
  until C <> NULL;
end; { GetKey }


Function ToUpper( Ch : Char ) : Char;
Begin
  If ( Ord(Ch) < Ord(' ') )
  Then
   ToUpper:=UpCase(Ch)
  Else
   Begin
    If ( Ord(Ch) <= Ord('¯') )
    Then
     ToUpper:=Chr(Ord(Ch)-32)
    Else
     ToUpper:=Chr(Ord(Ch)-80);
   End;
End;

Function LoWord( L : LongInt ) : Word;
Var
 W : Word;
begin
 W := L Mod 65536; LoWord := W;
end;

Function HiWord( L : LongInt ) : Word;
Var
 W : Word;
begin
 W := L Div 65536; HiWord := W;
end;

Function Word2( LWord, HWord : Word ) : LongInt;
Var
 L : longint;
begin
 L := longint(LWord) + longint(HWord*65536); Word2:= L;
end;

End.