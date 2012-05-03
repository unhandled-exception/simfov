{$F+,O+}
Unit SSRadDet;
Interface

procedure SetIdentificationRadii;

Implementation

Uses TDialogs, TSTDObj, SSVar;

Type

 CRCatDet = Record
    RoPPMDet       : String[ 7 ] ;
    RoGscDet       : String[ 7 ] ;
    RoCdcDet       : String[ 7 ] ;
    RoBsDet        : String[ 7 ] ;
    RoHdDet        : String[ 7 ] ;
    RoGcvsDet      : String[ 7 ] ;
    RoDmDet        : String[ 7 ] ;
    RoIrasDet      : String[ 7 ] ;
    RoImpDet       : String[ 7 ] ;
  End;

procedure SetIdentificationRadii;
Var
  R        : Trect    ;
  Dialog   : PDialog  ;
  ExitCode : Word     ;
  BRUCE    : PView    ;
  X1, Y1,
  X2       : Byte     ;

  Rec      : CRCatDet ;

Begin

  Str( RCatDet.RoPPMDet  : 6 : 1  , Rec.RoPPMDet   ) ;
  Str( RCatDet.RoGscDet  : 6 : 1  , Rec.RoGscDet   ) ;
  Str( RCatDet.RoCdcDet  : 6 : 1  , Rec.RoCdcDet   ) ;
  Str( RCatDet.RoBsDet   : 6 : 1  , Rec.RoBsDet    ) ;
  Str( RCatDet.RoHdDet   : 6 : 1  , Rec.RoHdDet    ) ;
  Str( RCatDet.RoGcvsDet : 6 : 1  , Rec.RoGcvsDet  ) ;
  Str( RCatDet.RoDmDet   : 6 : 1  , Rec.RoDmDet    ) ;
  Str( RCatDet.RoIrasDet : 6 : 1  , Rec.RoIrasDet  ) ;
  Str( RCatDet.RoImpDet  : 6 : 1  , Rec.RoImpDet   ) ;


  R.Assign( 1, 1, 47, 21 );
  Dialog := New( PDialog, Init( R, ' Identification radii (ArcSec) ', jcCentered ));
  With Dialog^ do
  Begin

    X1 := 23;
    X2 := 31;
    Y1 := 2;

    R.Assign( X1, y1, x2, y1 + 1 );
    Bruce := New( PInputLine, Init( R, 7 ) );
    R.Assign( 3, y1, x1, y1 + 1 );
    Bruce^.InitLabel( R, 'HIP, TYC, PPM, NPM' );
    Insert( BRUCE );
    Inc( Y1, 2 );

    R.Assign( X1, y1, x2, y1 + 1 );
    Bruce := New( PInputLine, Init( R, 7 ) );
    R.Assign( 3, y1, x1, y1 + 1 );
    Bruce^.InitLabel( R, '         A2.0, GSC' );
    Insert( BRUCE );
    Inc( Y1, 2 );

    R.Assign( X1, y1, x2, y1 + 1 );
    Bruce := New( PInputLine, Init( R, 7 ) );
    R.Assign( 3, y1, x1, y1 + 1 );
    Bruce^.InitLabel( R, '                AC' );
    Insert( BRUCE );
    Inc( Y1, 2 );

    R.Assign( X1, y1, x2, y1 + 1 );
    Bruce := New( PInputLine, Init( R, 7 ) );
    R.Assign( 3, y1, x1, y1 + 1 );
    Bruce^.InitLabel( R, '           SAO, BS' );
    Insert( BRUCE );
    Inc( Y1, 2 );

    R.Assign( X1, y1, x2, y1 + 1 );
    Bruce := New( PInputLine, Init( R, 7 ) );
    R.Assign( 3, y1, x1, y1 + 1 );
    Bruce^.InitLabel( R, '            HD, LT' );
    Insert( BRUCE );
    Inc( Y1, 2 );

    R.Assign( X1, y1, x2, y1 + 1 );
    Bruce := New( PInputLine, Init( R, 7 ) );
    R.Assign( 3, y1, x1, y1 + 1 );
    Bruce^.InitLabel( R, '              GCVS' );
    Insert( BRUCE );
    Inc( Y1, 2 );

    R.Assign( X1, y1, x2, y1 + 1 );
    Bruce := New( PInputLine, Init( R, 7 ) );
    R.Assign( 3, y1, x1, y1 + 1 );
    Bruce^.InitLabel( R, '                DM' );
    Insert( BRUCE );
    Inc( Y1, 2 );

    R.Assign( X1, y1, x2, y1 + 1 );
    Bruce := New( PInputLine, Init( R, 7 ) );
    R.Assign( 3, y1, x1, y1 + 1 );
    Bruce^.InitLabel( R, '            Others' );
    Insert( BRUCE );
    Inc( Y1, 2 );

    R.Assign( X1, y1, x2, y1 + 1 );
    Bruce := New( PInputLine, Init( R, 7 ) );
    R.Assign( 3, y1, x1, y1 + 1 );
    Bruce^.InitLabel( R, '            Import             (Size FOV)' );
    Insert( BRUCE );
    Inc( Y1, 2 );


    R.Assign( X2 + 3, 2, X2 + 14, 2 + 1 );
    Bruce := New( PButton, Init( R, 'Ok', bfNormal, cmOk  ) );
    Insert( BRUCE );

    R.Assign( X2 + 3, 4, X2 + 14, 4 + 1 );
    Bruce := New( PButton, Init( R, 'Cancel', bfNormal, cmCancel  ) );
    Insert( BRUCE );

    SetData( REC );

    InsFlag := False;

    ExitCode := Run;

    If ExitCode <> cmCancel Then
      Begin

       GetData( REC );

       Val (  Rec.RoPPMDet  ,  RCatDet.RoPPMDet  ,  ExitCode  ) ;
       Val (  Rec.RoGscDet  ,  RCatDet.RoGscDet  ,  ExitCode  ) ;
       Val (  Rec.RoCdcDet  ,  RCatDet.RoCdcDet  ,  ExitCode  ) ;
       Val (  Rec.RoBsDet   ,  RCatDet.RoBsDet   ,  ExitCode  ) ;
       Val (  Rec.RoHdDet   ,  RCatDet.RoHdDet   ,  ExitCode  ) ;
       Val (  Rec.RoGcvsDet ,  RCatDet.RoGcvsDet ,  ExitCode  ) ;
       Val (  Rec.RoDmDet   ,  RCatDet.RoDmDet   ,  ExitCode  ) ;
       Val (  Rec.RoIrasDet ,  RCatDet.RoIrasDet ,  ExitCode  ) ;
       Val (  Rec.RoImpDet  ,  RCatDet.RoImpDet  ,  ExitCode  ) ;

      End;

  End;{ dialog }


  Dispose( Dialog, Done );

End;

End.
