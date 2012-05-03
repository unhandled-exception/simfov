{$F+,O+}
Unit SSOrient;
Interface

procedure SetIdentificationOrient ;

Implementation

Uses TDialogs, TSTDObj, SSVar;

Type

 COrientDet = Record
    Tangag      : String[ 10 ] ;
    Ryskanie    : String[ 10 ] ;
  end;

procedure SetIdentificationOrient ;
Var
  R : Trect;
  Dialog : PDialog;
  ExitCode : Word;
  RCD : COrientDet;
  BRUCE : PView;
  X1, Y1,
  X2 : Byte;

  Rec : COrientDet;

begin


  Str ( OrientDet.Tangag    : 10 : 3  , Rec.Tangag    ) ;
  Str ( OrientDet.Ryskanie  : 10 : 3  , Rec.Ryskanie  ) ;


  R.Assign( 1,1,44,7 );
  Dialog := New( PDialog, Init( R, ' Orientation at velocity vector ',
                                                            jcCentered ));

  With Dialog^ do
  begin

    x1 := 13 ;
    X2 := 27 ;
    Y1 :=  2 ;

    R.Assign( X1, y1, x2, y1 + 1 );
    Bruce := New( PInputLine, Init( R, 10 ) );
    R.Assign( 3, y1, x1, y1 + 1 );
    Bruce^.InitLabel( R, 'Tangage' );
    Insert( BRUCE );
    Inc( Y1, 2 );

    R.Assign( X1, y1, x2, y1 + 1 );
    Bruce := New( PInputLine, Init( R, 10 ) );
    R.Assign( 3, y1, x1, y1 + 1 );
    Bruce^.InitLabel( R, 'Course' );
    Insert( BRUCE );
    Inc( Y1, 2 );


    R.Assign ( X2 + 3, 2, X2 + 16, 2 + 1 );
    Bruce := New( PButton, Init( R, 'Ok', bfNormal, cmOk  ) );
    Insert( BRUCE );

    R.Assign ( X2 + 3, 4, X2 + 16, 4 + 1 );
    Bruce := New( PButton, Init( R, 'Cancel', bfNormal, cmCancel  ) );
    Insert( BRUCE );

    SetData( REC );

    InsFlag := False;

    ExitCode := Run;

    If ExitCode <> cmCancel Then
      begin

       GetData( REC );

       Val( Rec.Tangag    , OrientDet.Tangag    , ExitCode );
       Val( Rec.Ryskanie  , OrientDet.Ryskanie  , ExitCode );

       OptOsOrient      := 3;
       Space_Earth_Flag := 2;

      end;

  end;{ dialog }


  Dispose( Dialog, Done );

end;

end.
