{$F+,O+}

Unit SSKosOrb;

Interface

Uses
  SSVar, TDialogs, TStdObj, SSError, TMsgWin, TUtil;

  Procedure SetKosmosOrbita ;

Implementation

  Uses PVar ;

  Procedure SetKosmosOrbita;

  Label BegDialog ;

 Type

 SKosmosOrbita = Record

  HeightAppoCentra   : String[ 14 ] ;
  HeightPeriCentra   : String[ 14 ] ;

  NaklOrbKEkv        : String[ 20 ] ;
  PrVoshVoshUzla     : String[ 20 ] ;
  ArgPeriCentra      : String[ 20 ] ;
  ArgShir            : String[ 20 ] ;

 End ;


Var

  SKO      : SKosmosOrbita   ;

  Dialog   : PDialog ;

  Bruce    : PView   ;

  R        : TRect   ;

  X,   Y,
  LX, LY,
  L,  BX,
  BY, i,d : Byte    ;

  ExitCode : Word    ;

  Old : TKosmosOrbita;

  HPer : Double ;


 Function NotEllipticOrbite : Boolean ;

  Var
    X, Y, Z, Vx, Vy, Vz,
    A, Mu, e, E0, M0,
    i, OmG, OmL, P, V, U,
    eSE, eCE, RVr,
    R1, R2, R3,
    R0, V0
                                : Double ;

  Begin

    NotEllipticOrbite := False ;

    Mu := FM [ KosmosCentralTelo ] / Sqr ( 86400.0 ) ;

    X  := KosmosOrbita.HeightAppoCentra ;
    Y  := KosmosOrbita.HeightPeriCentra ;
    Z  := KosmosOrbita.NaklOrbKEkv      ;

    Vx := KosmosOrbita.PrVoshVoshUzla   ;
    Vy := KosmosOrbita.ArgPeriCentra    ;
    Vz := KosmosOrbita.ArgShir          ;

    R0  := Sqrt ( Sqr ( X  ) + Sqr ( Y  ) + Sqr ( Z  )  ) ;
    V0  := Sqrt ( Sqr ( Vx ) + Sqr ( Vy ) + Sqr ( Vz )  ) ;
    RVr := X * Vx  +  Y * Vy  + Z * Vz ;

    A   := 1.0 / Abs ( 2.0 / R0 - V0*V0 / Mu ) ;

    eSE := RVr / ( Sqrt ( Mu ) * Sqrt ( A ) ) ;
    eCE := 1.0 - R0 / A ;

    e   := Sqrt  ( Sqr ( eSE ) + Sqr ( eCE ) ) ;

    P    := A * ( 1.0 - Sqr ( e ) )            ;
    HPer := A * ( 1.0 -       e   ) - R_Planets [ KosmosCentralTelo ] ;

    If (    ( V0   >= Sqrt ( 2.0 * Mu / R0 )  )
         Or ( e    >= 1.0                     )  )  Then
      NotEllipticOrbite := True  ;

  End ;


Begin


 Old := KosmosOrbita;

 Str( KosmosOrbita.HeightAppoCentra : 11 : 3 , SKO.HeightAppoCentra  );
 Str( KosmosOrbita.HeightPeriCentra : 11 : 3 , SKO.HeightPeriCentra  );

 Str( KosmosOrbita.NaklOrbKEkv    : 9 : 5, SKO.NaklOrbKEkv    );
 Str( KosmosOrbita.PrVoshVoshUzla : 9 : 5, SKO.PrVoshVoshUzla );
 Str( KosmosOrbita.ArgPeriCentra  : 9 : 5, SKO.ArgPeriCentra  );
 Str( KosmosOrbita.ArgShir        : 9 : 5, SKO.ArgShir        );

 R.Assign( 1, 1, 52, 14 );
 Dialog := New( PDialog , Init( R, ' Orbite ' , jcCentered ));

 With Dialog^ do
  Begin

   X  := 2;
   Y  := 3;

   LX := 2;
   LY := 2;

   BX := 24;
   BY := 11;

   L  := 14;
   R.Assign( X, Y, X + 20 + 2, Y+1 );
   Bruce := New( PInputLine, Init( R, L ));
   R.Assign( LX, LY, X , LY+1 );
   If ( SetOptOrbit Mod 4 = 1 )  Then
     Bruce^.InitLabel( R, 'H Apocenter km.' );
   If ( SetOptOrbit Mod 4 = 3 )  Then
     Bruce^.InitLabel( R, '   X km.' );
   Insert( Bruce );
   Inc( Y, 3 );
   Inc( LY, 3 );

   { 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴 }

   L  := 14;
   R.Assign( X, Y, X + 20+ 2, Y+1 );
   Bruce := New( PInputLine, Init( R, L ));
   R.Assign( LX, LY, X , LY+1 );
   If ( SetOptOrbit Mod 4 = 1 )  Then
     Bruce^.InitLabel( R, 'H Pericenter km.' );
   If ( SetOptOrbit Mod 4 = 3 )  Then
     Bruce^.InitLabel( R, '   Y km.' );
   Insert( Bruce );
   Inc( Y, 3 );
   Inc( LY, 3 );

   { 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴 }

   L  := 20;
   R.Assign( X, Y, X + L + 2, Y+1 );
   Bruce := New( PInputLine, Init( R, L ));
   R.Assign( LX, LY, X , LY+1 );
   If ( SetOptOrbit Mod 4 = 1 )  Then
     Bruce^.InitLabel( R, 'Inclination' );
   If ( SetOptOrbit Mod 4 = 3 )  Then
     Bruce^.InitLabel( R, '   Z km.' );
   Insert( Bruce );
   Inc( Y, 3 );
   Inc( LY, 3 );

   { 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴 }

   X  := 28;
   Y  := 3;
   LX := 28;
   LY := 2;

   L  := 20;
   R.Assign( X, Y, X + L + 2, Y+1 );
   Bruce := New( PInputLine, Init( R, L ));
   R.Assign( LX, LY, X , LY+1 );
   If ( SetOptOrbit Mod 4 = 1 )  Then
     Bruce^.InitLabel( R, 'R.A. Node Accept' );
   If ( SetOptOrbit Mod 4 = 3 )  Then
     Bruce^.InitLabel( R, '   Vx km/sek' );
   Insert( Bruce );
   Inc( Y, 3 );
   Inc( LY, 3 );

   { 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴 }

   L  := 20;
   R.Assign( X, Y, X + L + 2, Y+1 );
   Bruce := New( PInputLine, Init( R, L ));
   R.Assign( LX, LY, X , LY+1 );
   If ( SetOptOrbit Mod 4 = 1 )  Then
     Bruce^.InitLabel( R, 'Pericenters Argument' );
   If ( SetOptOrbit Mod 4 = 3 )  Then
     Bruce^.InitLabel( R, '   Vy km/sek' );
   Insert( Bruce );
   Inc( Y, 3 );
   Inc( LY, 3 );

   { 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴 }

   L  := 20;
   R.Assign( X, Y, X + L  + 2, Y+1 );
   Bruce := New( PInputLine, Init( R, L ));
   R.Assign( LX, LY, X , LY+1 );
   If ( SetOptOrbit Mod 4 = 1 )  Then
     Bruce^.InitLabel( R, 'Latituds Argument' );
   If ( SetOptOrbit Mod 4 = 3 )  Then
     Bruce^.InitLabel( R, '   Vz km/sek' );
   Insert( Bruce );
   Inc( Y, 3 );
   Inc( LY, 3 );

   { 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴 }

   R.Assign( BX,BY,BX + 13,BY + 1);
   Bruce := New( PButton, Init( R,'Ok', bfNormal, cmOk ));
   Insert( Bruce );

   R.Assign( BX + 14 ,BY,BX + 14 + 13, BY + 1);
   Bruce := New( PButton, Init( R,'Cancel', bfNormal, cmCancel ));
   Insert( Bruce );

   SetData( SKO );

   InsFlag := False;

BegDialog:;

   ExitCode := Run ;

   If ExitCode = cmCancel Then
     KosmosOrbita := Old;

   If ExitCode <> cmCancel Then
    Begin

     GetData( SKO );

     If ( SetOptOrbit Mod 4 <> 3 )  Then
       Begin

         d := Pos( '-', SKO.HeightAppoCentra  );
         If d <> 0 Then
           Begin
             EnterParamError;
             GoTo BegDialog ;
           End ;

         d := Pos( '-', SKO.HeightPeriCentra  );
         If d <> 0 Then
           Begin
             EnterParamError;
             GoTo BegDialog ;
           End ;

         d := Pos( '-', SKO.PrVoshVoshUzla  );
         If d <> 0 Then
           Begin
             EnterParamError;
             GoTo BegDialog ;
           End ;

         d := Pos( '-', SKO.ArgPeriCentra   );
         If d <> 0 Then
           Begin
             EnterParamError;
             GoTo BegDialog ;
           End ;

         d := Pos( '-', SKO.ArgShir   );
         If d <> 0 Then
           Begin
             EnterParamError;
             GoTo BegDialog ;
           End ;

       End ; { SetOptOrbit Mod 4 <> 3 }


     Val( SKO.HeightAppoCentra  , KosmosOrbita.HeightAppoCentra, ExitCode  );
     If ExitCode <> 0 Then
      Begin
       EnterParamError;
       GoTo BegDialog ;
      End ;


     Val( SKO.HeightPeriCentra  , KosmosOrbita.HeightPeriCentra, ExitCode  );
     If ExitCode <> 0 Then
      Begin
       EnterParamError;
       GoTo BegDialog ;
      End ;


     Val( SKO.NaklOrbKEkv   , KosmosOrbita.NaklOrbKEkv, ExitCode );
     If ExitCode <> 0 Then
      Begin
       EnterParamError;
       GoTo BegDialog ;
      End ;


     Val( SKO.PrVoshVoshUzla, KosmosOrbita.PrVoshVoshUzla, ExitCode);
     If ExitCode <> 0 Then
      Begin
       EnterParamError;
       GoTo BegDialog ;
      End ;


     Val( SKO.ArgPeriCentra , KosmosOrbita.ArgPeriCentra, ExitCode );
     If ExitCode <> 0 Then
      Begin
       EnterParamError;
       GoTo BegDialog ;
      End ;


     Val( SKO.ArgShir       , KosmosOrbita.ArgShir  , ExitCode     );
     If ExitCode <> 0 Then
      Begin
       EnterParamError;
       GoTo BegDialog ;
      End ;


    If (     ( SetOptOrbit Mod 4 = 3 )
         And ( NotEllipticOrbite     )  ) Then
      Error ( 1, 1, 33, 5 ,
              #13 + ^C'Orbite not Ellips' + #13);

    If (     ( SetOptOrbit Mod 4 = 3 )
         And ( HPer <= 0.0           )  ) Then
      Error ( 1, 1, 33, 5 ,
              #13 + ^C'H Pericenter < 0' + #13);


     TPCP := 2 ;
     Space_Earth_Flag := 2;

    End ;

   End ;

 Dispose( Dialog, Done );

End ;{ SetKosmosOrbita }

End.
