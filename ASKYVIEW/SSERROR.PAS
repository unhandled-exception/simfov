{$F+,O+}
Unit SSError;
Interface

Uses TMsgWin;

Procedure EnterParamError ;
Procedure ErrorIncorectFileName ;
Procedure ErrorReadFile( FName : String );
Procedure ErrorOpenFile( FName : String );

Procedure ErrorMonthRange;
Procedure ErrorDayRange( FebFlag, VisYear : Boolean );
Procedure ErrorHourRange;
Procedure ErrorMinuteRange;
Procedure ErrorSecRange;

Implementation

Uses TUtil;

Procedure EnterParamError ;
Begin

 Error ( 1, 1, 33, 5 ,
         #13 + ^C'Incorect parameters.' + #13);

End;{ EnterParamError }

{ 北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北 }

Procedure ErrorIncorectFileName ;
Begin

 Error( 1, 1, 33, 5 ,
         #13 + ^C'Incorrect file name.' + #13);

End;{ ErrorIncorectFileName }

{ 北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北 }

Procedure ErrorReadFile( FName : String );
Var W : Byte;
Begin

 FName := Upstring( FName );

 W :=  Length( FName ) + 2 ;

 If W < 33 Then W := 33;

 Error( 1, 1, W, 7 ,
         #13 +
         ^C'Read file error. File:' + #13 +
         ^C + FName + #13 +
         #13);

End;{ ErrorReadFile }

{ 北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北 }

Procedure ErrorOpenFile( FName : String );
Var W : Byte;
Begin

 FName := Upstring( FName );

 W :=  Length( FName ) + 2 ;

 If W < 33 Then W := 33;

 Error( 1, 1, W, 7 ,
         #13 +
         ^C'Open file error. File:' + #13 +
         ^C + FName + #13 +
         #13);

End;{ ErrorReadFile }

{ 北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北 }

Procedure ErrorMonthRange;
Begin

  Error( 1,1, 40, 7 , #13 +
                ^C'Month out of range' + #13 +
                       ^C'( month range  1 .. 12 ) ' + #13);

End;{ ErrorMonthRange }

{ 北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北 }

Procedure ErrorDayRange( FebFlag, VisYear : Boolean );
Var VN : String[2];
Begin

 If Not FebFlag Then
   Begin

     If VisYear Then VN := '31';
     If Not VisYear Then VN := '30';

   End;

 If FebFlag Then
   Begin

     If VisYear Then VN := '29';
     If Not VisYear Then VN := '28';

   End;

 Error( 1,1, 36, 7 , #13 +
          ^C'Day out of range' + #13 +
             ^C'( day range 1 .. ' + VN + ' )'+ #13);

End;{ ErrorDayRange }

{ 北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北 }

Procedure ErrorHourRange;
Begin

 Error( 1,1, 36, 7 , #13 +
          ^C'Hour out of range' + #13 +
             ^C'( hour range 0 .. 23 )'+ #13);

End;{ ErrorHourRange }

{ 北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北 }

Procedure ErrorMinuteRange;
Begin

 Error( 1,1, 36, 7 , #13 +
          ^C'Minute out of range' + #13 +
             ^C'( minute range 0 .. 59 )'+ #13);

End;{ ErrorHourRange }

{ 北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北 }

Procedure ErrorSecRange;
Begin

 Error( 1,1, 36, 7 , #13 +
          ^C'Sec out of range' + #13 +
             ^C'( sec range 0.000 .. 59.999 )'+ #13);

End;{ ErrorHourRange }

End.