{$F+,O+}

Unit SSStdRec;

Interface


{ ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }
{ ±±                                                                    ±± }
{ ±±                   Ž¯¨á ­¨¥ ¯p®æ¥¤ãpë SetStdRec.                    ±± }
{ ±±                                                                    ±± }
{ ±±   ˆ¬ï         : SetStdRec.                                         ±± }
{ ±±                                                                    ±± }
{ ±±    p ¬¥âpë   : Title     - § £®«®¢®ª ®ª­ ;                        ±± }
{ ±±                 Sp1 ¨ Sp1 - § £®«®¢ª¨ ¯®«¥© ( á¬. ¤ «¥¥ );         ±± }
{ ±±                 StdRec    - ¢®§¢p é ¥¬ ï § ¯¨áì ( á¬. ¤ «¥¥ );     ±± }
{ ±±                 ZFlag     - ä« £ ¯p®¢¥pª¨ §­ ç¥­¨© ( á¬. ¤ «¥¥ );  ±± }
{ ±±                                                                    ±± }
{ ±±   Ž¯¨á ­¨¥    : p®æ¥¤ãp  ¯p¥¤­ §­ ç¥­­  ¤«ï ¢¢®¤  ¢ ¤¨ «®£®¢®¬    ±± }
{ ±±                 p¥¦¨¬¥ § ¯¨á¨ â¨¯  TStdRec. ¯p¨ íâ®¬ ®ª­® ¨¬¥¥â    ±± }
{ ±±                 ¢¨¤:                                               ±± }
{ ±±                                                                    ±± }
{ ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }


Uses  SSVar, TDialogs, TUtil, TStdObj, SSError;

procedure SetStdRec( Title , Sp1, Sp2 : String; Var StdRec : TStdRec;
                                             ZFlag1,ZFlag2 : boolean  ) ;


Implementation

procedure SetStdRec( Title , Sp1, Sp2 : String; Var StdRec : TStdRec;
                                             ZFlag1,ZFlag2 : boolean );

Label BegDialog ;

Type

  STStdRec = Record
    p1 : String[20];
    p2 : String[20];
  end;

Var

  Dialog   : PDialog ;

  Bruce    : PView   ;

  R        : TRect   ;

  X,   Y,
  LX, LY,
  L,  BX,
  ml,ww,
  i,d,m    : Byte    ;

  ExitCode : Word    ;

  TSR      : STStdRec;

  s        : String[20];

  Old : TStdRec;

Begin

 Old := StdRec;

{$V-}

 With TSR do
 begin

   RStr( p1 , StdRec.Param1 );
   RStr( p2 , StdRec.Param2 );

 end;

{$V+}

 ml := Length( Sp1 );
 If Length( Sp2 ) > ml Then
    ml := Length( Sp2 );

 WW := Length( Title ) + 8 + 2;

 if WW  < ml + 2 + 2 + 20 + 2 + 1  then
    WW := ml + 2 + 2 + 20 + 2 + 1 ;

 if WW - 2 < 30 then
    WW := 30 ;

 L  := 20;

 X  := ml + 3;
 Y  := 2;

 LX := 2;
 LY := 2;

 BX := ( WW - 2 - 28 ) div 2 + 2;

 R.Assign( 1, 1, ww, 9 );
 Dialog := New( PDialog , Init( R, Title, jcCentered ));

 With Dialog^ do
  Begin


   R.Assign( X, Y, X + L + 2, Y+1 );
   Bruce := New( PInputLine, Init( R, L ));
   R.Assign( LX, LY, X , LY+1 );
   Bruce^.InitLabel( R, Sp1 );
   Insert( Bruce );
   Inc( Y, 2 );
   Inc( LY, 2 );


   R.Assign( X, Y, X + L + 2, Y+1 );
   Bruce := New( PInputLine, Init( R, L ));
   R.Assign( LX, LY, X , LY+1 );
   Bruce^.InitLabel( R, Sp2 );
   Insert( Bruce );
   Inc( Y, 2 );
   Inc( LY, 2 );


   R.Assign( WW - 24, LY, WW - 24 + 11, LY+1 );
   Bruce := New( PButton, Init( R,'Ok', bfNormal, cmQuit ));
   Insert( Bruce );

   R.Assign( WW - 12, LY, WW - 1, LY+1 );
   Bruce := New( PButton, Init( R,'Cancel', bfNormal, cmCancel ));
   Insert( Bruce );
{
   R.Assign( BX,LY,BX + 13,LY+1);
   Bruce := New( PButton, Init( R,'    Ok    ', bfNormal, cmQuit ));
   Insert( Bruce );

   R.Assign( BX + 15,LY,BX + 15 + 13,LY+1);
   Bruce := New( PButton, Init( R,' Cancel ', bfNormal, cmCancel ));
   Insert( Bruce );
}
   SetData( TSR );

   InsFlag := False;

BegDialog:;

   ExitCode := Run ;


   If ExitCode = cmCancel Then
     StdRec := Old;

   If ExitCode <> cmCancel Then
    Begin

     GetData( TSR );

     d := 0;
     m := 0;

     For i := 1 to Length( TSR.p1 )  do
      begin
        case  TSR.P1[ i ] of
         '1','2',
         '3','4',
         '5','6',
         '7','8',
         '9','0',
         '+','.'  : Inc(D);
         '-'      : Inc(m);
         ' '      :       ;
         else
          begin

           EnterParamError;
           GoTo BegDialog ;

          end;
        end;
      end;

     If ( m > 0 ) and Not ZFlag1 then
      begin

       EnterParamError;
       GoTo BegDialog ;

      end;

     If M > 1 Then
      begin

       EnterParamError;
       GoTo BegDialog ;

      end;

     if ( d = 0 ) Then
      begin

       EnterParamError;
       GoTo BegDialog ;

      end;


     d := 0;
     m := 0;

     For i := 1 to Length( TSR.p2 )  do
      begin
        case  TSR.P2[ i ] of
         '1','2',
         '3','4',
         '5','6',
         '7','8',
         '9','0',
         '+','.'  : Inc(D);
         '-'      : Inc(m);
         ' '      :;
         else
          begin

           EnterParamError;
           GoTo BegDialog ;

          end;
        end;
      end;

     if ( m > 0 ) and Not ZFlag2 then
      begin

       EnterParamError;
       GoTo BegDialog ;

      end;

     If M > 1 Then
      begin

       EnterParamError;
       GoTo BegDialog ;

      end;

     if ( d = 0 ) Then
      begin

       EnterParamError;
       GoTo BegDialog ;

      end;

     With StdRec do
     begin

      RVal( TSR.p1, param1 );
      RVal( TSR.p2, param2 );

     end;

     If  ZFlag1
       Then  OptOsOrient := 2
       Else  OptOsOrient := 1 ;

    End;  { ExitCode <> cmCancel }

   End;

 Dispose( Dialog, Done );

End;{ TMApp.SetStdRec }



end.

