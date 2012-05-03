
{$O+,F+}


UNIT  ProOut ;



  Interface

    Uses   PVAR , V_CATAL ;

    Procedure ShellNRec     ( Low , High : LongInt );

    Procedure ShellNMarking ( Low , High : LongInt );

    Function  HourString ( h, m : Word; s : Double ) : String ;

    Function  DegrString ( n : Boolean; g, m : Word; s : Double ) : String ;

    Function  DateString ( d, m ,y : Word ) : String ;

    Function  TimeString ( h, m ,s : Word ) : String ;


  Implementation





Function DateString( d, m ,y : Word ) : String ;
Var
 s      : String [10];
 t      : String [ 4];
Begin
     t:=''; s:='';
     str(d:0, s); If length(s) = 1 Then s:='0'+s;
     str(m:0, t); If length(t) = 1 Then t:='0'+t; s:=s+'.'+t; t:='';
     str(y:4, t);                                 s:=s+'.'+t;
     DateString := s;
End ;

Function TimeString( h, m ,s : Word ) : String ;
Var
 u      : String [ 8];
 t      : String [ 2];
Begin
     t:=''; u:='';
     str(h:0, u); If length(u) = 1 Then u:='0'+u;
     str(m:0, t); If length(t) = 1 Then t:='0'+t; u:=u+':'+t; t:='';
     str(s:0, t); If length(t) = 1 Then t:='0'+t; u:=u+':'+t;
     TimeString := u;
End ;

Function HourString( h, m : Word; s : Double ) : String ;
Var
 u      : String [12];
 t      : String [ 6];
 i      : Integer   ;
Begin
     t := '' ;
     u := '' ;
     str(h:0  , u); If length(u) = 1 Then u:='0'+u;
     str(m:0  , t); If length(t) = 1 Then t:='0'+t; u:=u+' '+t; t:='';
     str(s:6:3, t);
     For i:=1 To 6 Do  If t[i]=' ' Then t[i]:='0';
     u := u + ' ' + t ;
     HourString := u;
End ;

Function DegrString( n : Boolean; g, m : Word; s : Double ) : String ;
Var
 u      : String [12];
 t      : String [ 6];
 i      : Integer   ;
Begin
     t:='';
     If n
       Then u:='-'
       Else u:='+';
     str(g:0  , t);
     If length(t) = 1 Then
       t:='0'+t;
     u:=u+t;
     str(m:0  , t);
     If length(t) = 1 Then
       t:='0'+t;
     u:=u+' '+t; t:='';
     str(s:5:2, t);
     For i:=1 To 5 Do
       If t[i]=' ' Then
         t[i]:='0';
     u:=u+' '+t;
     DegrString := u;
End ;



Procedure ShellNRec ( Low , High : LongInt );
         {ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ}

var
 n, ni, in1, j, l ,
 i1, i2,
 i1d, i1m, i2d, i2m,
 k1, k2             : LongInt   ;
 Key1, Key2         : LongInt   ;
 Dummy              : objecttype;
 Ordered            : boolean   ;
Begin

 n := high - low + 1;
 If ( n > 1 ) Then
 Begin

  ni := 1;
  While ( 9 * ni < n ) Do ni:= 3 * ni + 1;

  While ( ni >= 1 ) Do
  Begin
   in1 := ni + 1;
   For j:=in1 To n Do
   Begin
    l := j - ni;
    Ordered := False;

    While ( l >= 1 ) And Not Ordered Do
    Begin

      i1   := l + low - 1      ;
      i2   := l + low - 1 + ni ;

      i1d  := i1 Div ObjectBlockSize ;
      i1m  := i1 Mod ObjectBlockSize ;

      i2d  := i2 Div ObjectBlockSize ;
      i2m  := i2 Mod ObjectBlockSize ;

      Key1 := ObjectPtr [i1d]^[i1m].NRecC ;
      Key2 := ObjectPtr [i2d]^[i2m].NRecC ;

      If ( Key1 > Key2 )  Then
       Begin
            { swap records }
        Dummy := ObjectPtr [i1d]^[i1m];
        ObjectPtr [i1d]^[i1m] := ObjectPtr [i2d]^[i2m];
        ObjectPtr [i2d]^[i2m] := Dummy;
        l := l- ni;
       End
      Else
        Ordered :=True;
    End;
   End;
   ni := Trunc(ni / 3 );
  End;
 End;
End;


Procedure ShellNMarking ( Low , High : LongInt );
         {ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ}

var
 n, ni, in1, j, l ,
 i1, i2,
 i1d, i1m, i2d, i2m,
 k1, k2             : LongInt   ;
 Key1, Key2         : LongInt   ;
 Dummy              : objecttype;
 Ordered            : boolean   ;
Begin

 n := high - low + 1;
 If ( n > 1 ) Then
 Begin

  ni := 1;
  While ( 9 * ni < n ) Do ni := 3 * ni + 1;

  While ( ni >= 1 ) Do
  Begin
   in1 := ni + 1;
   For j:=in1 To n Do
   Begin
    l := j - ni;
    Ordered := False;

    While ( l >= 1 ) And Not Ordered Do
    Begin

      i1 := l + low - 1      ;
      i2 := l + low - 1 + ni ;

      i1d := i1 Div ObjectBlockSize ;
      i1m := i1 Mod ObjectBlockSize ;

      i2d := i2 Div ObjectBlockSize ;
      i2m := i2 Mod ObjectBlockSize ;

      Key1:= ObjectPtr [i1d]^[i1m].Date ;
      Key2:= ObjectPtr [i2d]^[i2m].Date ;

      If ( Key1 > Key2 )  Then
       Begin
            { swap records }
        Dummy := ObjectPtr [i1d]^[i1m];
        ObjectPtr [i1d]^[i1m] := ObjectPtr [i2d]^[i2m];
        ObjectPtr [i2d]^[i2m] := Dummy;
        l := l- ni;
       End
      Else
        Ordered := True;
    End;
   End;
   ni := Trunc ( ni / 3 ) ;
  End;
 End;
End;


End.

