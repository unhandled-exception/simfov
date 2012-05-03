Unit Strings;

Interface

Procedure ToLower( Var S : String );
Procedure ToUpper( Var S : String );
Function  IsValid ( mask,str : string ):boolean;

Implementation

Procedure ToLower( Var S : String );
Var
  I : Byte;
Begin
  For I := 1 to Ord( S[ 0 ] ) do
    Case S[ I ] of
      'A'..'Z' : S[ I ] := Chr( Ord( S[ I ] ) + 32 );
      'Ä'..'è' : S[ I ] := Chr( Ord( S[ I ] ) + 32 );
      'ê'..'ü' : S[ I ] := Chr( Ord( S[ I ] ) + 80 );
    end;
End;

Procedure ToUpper( Var S : String );
Var
  I : Byte;
Begin
  For I := 1 to Ord( S[ 0 ] ) do
    Case S[ I ] of
      #112      : S[ I ] := #144;
      'a'..'z'  : S[ I ] := Chr( Ord( S[ I ] ) - 32 );
      '†'..'Ø'  : S[ I ] := Chr( Ord( S[ I ] ) - 32 );
      #224..'Ô' : S[ I ] := Chr( Ord( S[ I ] ) - 80 );
    end;
End;

Function IsValid;
Var
     i,j   :   integer;
Begin
   i:=1;j:=1;
   isvalid:=true;

   if ((pos('*',mask)=0) and (length(mask)<>length(str)))
     then  begin
               IsValid:=False;
               exit;
           end;

   repeat
    if ((mask[i]='?') or (mask[i]=str[i]))
      then begin
                inc(i);
                inc(j);
           end
       else
    if mask[i]='*'
      then break
      else begin
                isvalid:=false;
                exit;
           end;
   until ((i>length(mask)) or (j>length(str)));
End;

End.
