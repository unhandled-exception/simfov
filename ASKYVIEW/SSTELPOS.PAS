{$F+,O+}

Unit SSTelPos;

Interface

Uses  SSVar, TDialogs, TStdObj, SSError, TMsgWin, TUtil;

procedure SetTeleskopPosition;


Implementation

procedure SetTeleskopPosition;

Label BegDialog;

Var

  Dialog   : PDialog ;

  Bruce    : PView   ;

  R        : TRect   ;

  ExitCode : Word    ;

  y,k,m,x,
  ACode,cp : Byte    ;

  DEscFlag : Boolean;


procedure EnterTCCoord( Var TP : TTeleskopPosition );
Label BS;
Type

 STeleskopPosition = Record

  Shirota : String[ 20 ] ;
  Dolgota : String[ 20 ] ;
  Height  : String[ 20 ] ;


 end;

Var
 SDialog  : PDialog     ;
 Bruce    : PView       ;
 R        : TRect       ;
 RetCode,
 EC,t,
 h,d,x,lx : Word        ;
 STP      : STeleskopPosition ;
 Old      : TTeleskopPosition ;

begin

Old := TP;

Str( TP.Height : 2 : 3, STP.Height );

{$V-}
RStr( STP.Shirota, TP.Shirota );
RStr( STP.Dolgota, TP.Dolgota );
{SV+}

R.Assign( 1, 1, 40 + 2, 11 );
SDialog := New( PDialog, Init( R,' TopoCentric coordinates ', jcCentered ));
With SDialog^ do
 begin

  h := 2;
  x := 17;
  lx := 3;

  R.Assign( x, h, x + 20 + 2, h + 1 );
  Bruce := New( PInputLine, Init( R, 20 ));
  R.Assign( lx, h, x - 2, h + 1 );
  Bruce^.InitLabel( R,'Latitude' );
  Insert( Bruce );
  inc( h,2 );

  R.Assign( x, h, x + 20 + 2, h + 1 );
  Bruce := New( PInputLine, Init( R, 20 ));
  R.Assign( lx, h, x - 2, h + 1 );
  Bruce^.InitLabel( R,'Longit. + '+chr(26)+' E' );
  Insert( Bruce );
  inc( h,2 );

  R.Assign( x, h, x + 20 + 2, h + 1 );
  Bruce := New( PInputLine, Init( R, 20 ));
  R.Assign( lx, h, x - 2, h + 1 );
  Bruce^.InitLabel( R,'Altitude' );
  Insert( Bruce );
  inc( h,2 );

  R.Assign( lx, h, lx + 13, h + 1);
  Insert( New( PButton, Init( R, 'Ok',bfNormal,cmOk )));

  R.Assign( lx + 14, h, lx + 14 + 13, h + 1);
  Insert( New( PButton, Init( R, 'Cancel',bfNormal, cmCancel )));

  SetData( STP );

  InsFlag := False;

BS:;

  RetCode := Run;


  If RetCode = cmCancel Then
    TP := Old;

  If RetCode <> cmCancel Then
   begin

    GetData( STP );

    d := 0;

    For t := 1 to Length( STP.Shirota )  do
     begin
       case STP.Shirota [ t ] of
        '1','2',
        '3','4',
        '5','6',
        '7','8',
        '9','0',
        '+','-',
        '.'      :Inc(D);
        ' '      :;
        else
         begin

          EnterParamError;
          GoTo BS ;

          end;
        end;
      end;

     if d = 0 Then
      begin

       EnterParamError;
       GoTo BS ;

      end;

    d := 0;

    For t := 1 to Length( STP.Dolgota )  do
     begin
       case STP.Dolgota [ t ] of
        '1','2',
        '3','4',
        '5','6',
        '7','8',
        '9','0',
        '+','-',
        '.'     :Inc(D);
        ' '      :;
        else
         begin

          EnterParamError;
          GoTo BS ;

          end;
        end;
      end;

     if d = 0 Then
      begin

       EnterParamError;
       GoTo BS ;

      end;


    d := 0;

    For t := 1 to Length( STP.Height )  do
     begin
       case STP.Height [ t ] of
        '1','2',
        '3','4',
        '5','6',
        '7','8',
        '9','0',
        '.'      :Inc(D);
        ' '      :;
        else
         begin

          EnterParamError;
          GoTo BS ;

          end;
        end;
      end;

     if d = 0 Then
      begin

       EnterParamError;
       GoTo BS ;

      end;

    RVal ( STP.Shirota, TP.Shirota     ) ;
    RVal ( STP.Dolgota, TP.Dolgota     ) ;
    Val  ( STP.Height , TP.Height , EC ) ;

    If ( TP.Dolgota.PI1 > 180 )  Then
      Begin

        If ( TP.Dolgota.Bchar = '-' )
          Then  TP.Dolgota.Bchar := ' '
          Else  TP.Dolgota.Bchar := '-' ;
        TP.Dolgota.PI1 := 359   - TP.Dolgota.PI1 ;
        TP.Dolgota.PI2 :=  59   - TP.Dolgota.PI2 ;
        TP.Dolgota.PD  :=  60.0 - TP.Dolgota.PD  ;

        If ( TP.Dolgota.PD > 59.95 )  Then
          Begin
            TP.Dolgota.PD := 0.0 ;
            Inc ( TP.Dolgota.PI2 ) ;
          End ;

        If ( TP.Dolgota.PI2 >= 60 )  Then
          Begin
            TP.Dolgota.PI2 := 0 ;
            Inc ( TP.Dolgota.PI1 ) ;
          End ;

      End ;

    DEscFlag := True;

   end;

  If RetCode = cmCancel Then
   DEscFlag := False ;


 end;

Dispose( Sdialog, Done );

end;{ EnterSputnikNum }


Begin

 DEscFlag := False ;

 cp := TPCP;

 R.Assign( 1, 1, 39, 8 );
 Dialog := New( PDialog , Init( R, ' Telescope position ', jcCentered ));

 With Dialog^ do
  Begin

   x := 36;

   R.Assign( 3, 2, x, 4 );
   Bruce := New( PRadioButton, Init( R ));
   With Bruce^ do
    Begin

     m := 0;

     NewSItem('PlanetoCentric Coordinates') ;  Inc ( M ) ;
     NewSItem('TopoCentric Coordinates'   ) ;  Inc ( M ) ;

    End;
   Insert( Bruce );


   R.Assign( 3, 5, 3 + 13, 6 );
   Bruce := New( PButton, Init( R,'Ok', bfNormal, cmOk ));
   Insert( Bruce );

   R.Assign( 3 + 14 , 5, 3 + 14 + 13, 6 );
   Bruce := New( PButton, Init( R,'Cancel', bfNormal, cmCancel ));
   Insert( Bruce );

   SetData( TPCP );

BegDialog:;

   DEscFlag := False ;

   ExitCode := Run ;

   If ( ExitCode <> cmCancel ) and ( ExitCode <> cmQuit ) Then
    Begin

     GetData( TPCP );

     If TPCP = 2 Then
      begin

       EnterTCCoord( TeleskopPosition );
       TeleskopHeoCenterFlag := False ;
       if Not DEscFlag Then
        begin
         GoTo BegDialog;
        end;

      end;

     If TPCP = 1 Then
     TeleskopHeoCenterFlag := True ;

     Space_Earth_Flag := 1 ;

    End;

  End;

 Dispose( Dialog, Done );

End;{ SetTeleskopPosition }

end.