
{$O+,F+}

Unit PSortRa ;
Interface

procedure Sort_By_Ra ( Low , High : LongInt );

Implementation

Uses  PVar, PProFld, PPreNew ;


procedure Sort_By_Ra ( Low , High : LongInt );
var

 n, ni, in1, j, l ,
 i1, i2,
 i1d, i1m, i2d, i2m,
 k1, k2             : LongInt   ;

 X, Y,
 ORa, ODc,
 key1, key2         : Double    ;

 dummy              : objecttype;

 ordered            : boolean   ;

begin

 n := high - low + 1;
 if ( n > 1 ) then
 begin

  ni:=1;
  while ( 9 * ni < n ) do ni:= 3 * ni + 1;

  while ( ni >= 1 ) do
  begin
   in1 := ni + 1;
   for j:=in1 to n do
   begin
    l:= j - ni;
    ordered:=false;

    while ( l >= 1 ) AND NOT ordered do
    begin

      i1 := l + low - 1      ;
      i2 := l + low - 1 + ni ;

      i1d := i1 div objectblocksize ;
      i1m := i1 mod objectblocksize ;

      i2d := i2 div objectblocksize ;
      i2m := i2 mod objectblocksize ;

      X := ObjectPtr [i1d]^[i1m].X ;
      Y := ObjectPtr [i1d]^[i1m].Y ;
      {
      IdToEq ( x, y, npolfix, spoznp, cpoznp, ORa, ODc );
      }
      IdToEq1 ( x, y, ORa, ODc );
      PreNew ( JDateFld, JDOut, ORa, ODc ) ;
      Key1 := ORa ;

      X := ObjectPtr [i2d]^[i2m].X ;
      Y := ObjectPtr [i2d]^[i2m].Y ;
      {
      IdToEq ( x, y, npolfix, spoznp, cpoznp, ORa, ODc );
      }
      IdToEq1 ( x, y, ORa, ODc );
      PreNew ( JDateFld, JDOut, ORa, ODc ) ;
      Key2 := ORa ;

      if ( Key1 > Key2 )  then
       begin
            { swap records }

        dummy                := objectptr[i1d]^[i1m] ;
        objectptr[i1d]^[i1m] := objectptr[i2d]^[i2m] ;
        objectptr[i2d]^[i2m] := dummy                ;

        l := l- ni;

       end
      else
        ordered:=true;
    end;
   end;
   ni := trunc(ni / 3 );
  end;
 end;


end;
end.
