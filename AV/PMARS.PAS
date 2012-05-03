
{$O+,F+}


Unit PMARS;
Interface
   Procedure MARS ( JD, JDREZ : DOUBLE; Var L, B, R, X, Y, Z : DOUBLE );
Implementation



   Procedure MARS ( JD, JDREZ : DOUBLE; Var L, B, R, X, Y, Z : DOUBLE );

{       COMPUTATION OF MARS HELIOCENTRIC COORDINATES
	********************************************

	JD    - TIME MOMENT
	JDREZ - RESULTING COORDINTES SYSTEM
	L, B  - ECLIPTICAL COORDINATES
	X,Y,Z - EQUATORIAL COORDINATES

}

Var
	M, N,
	PI2, GR, RGR, CP,
	EPS, SEPS, CEPS, G, G1, G2, G3, G4, G5, DL, DZ, DR, F,
	SB, CB, TB, V, U, E,
	T, TE, TCP, P, PP, DT, AA, BB, C1, SL, CL : DOUBLE;



Begin


	PI2 := 3.14159265359 * 2.0 ;
	CP  := 206264.806247       ;

	T := ( JD - 2415020.0 ) / 36525.0;

	GR := 5.57666100  + 334.053549  * T + 0.316E-5 * T * T;
	G  := GR - TRUNC ( GR / PI2 ) * PI2;

	G2 := 3.7069 + 1021.3208 * T;
	G2 := G2 - TRUNC ( G2 / PI2 ) * PI2;

	G3 := 6.2555 +  628.2998 * T;
	G3 := G3 - TRUNC ( G3 / PI2 ) * PI2;

	G5 := 3.9306 +   52.9614 * T + 0.0058 * SIN ( 2.3457 + 0.672 * T );
	G5 := G5 - TRUNC ( G5 / PI2 ) * PI2;

	DL := 52.5 * SIN ( 0.8287 + 0.3451 * T );

	G := G + DL / CP;

	R := 0.1828970;

	DR := 946.3 + 1.8 * T;

	DR := DR - COS (       G ) * ( 40391.7 + 39.0 * T );
	DR := DR - COS ( 2.0 * G ) * (  2820.9 +  5.4 * T );
	DR := DR - COS ( 3.0 * G ) * (   248.1 +  0.7 * T );
	DR := DR - COS ( 4.0 * G ) *      24.1;
	DR := DR - COS ( 5.0 * G ) *       2.5;

	R := R + DR / 1000000.0;

	V :=     SIN (       G ) * ( 38450.9 + 37.3 * T );
	V := V + SIN ( 2.0 * G ) * (  2237.7 +  4.3 * T );
	V := V + SIN ( 3.0 * G ) * (   180.6 +  0.5 * T );
	V := V + SIN ( 4.0 * G ) *      16.6;
	V := V + SIN ( 5.0 * G ) *       1.7;

	L := G + V / CP + 5.833208 + 6626.7 / CP *T;

	G := 5.576851 + 334.05356 * T;
	G := G - TRUNC ( G / PI2 ) * PI2;

	DL := 0.0;
	DR := 0.0;

	DL := DL +  6.4 * COS ( -       G2 + 3.0 * G - 1.0053 );
	DL := DL +  8.6 * COS ( -       G3 +       G - 0.6126 );
	DL := DL + 14.0 * COS ( -       G3 + 2.0 * G - 0.3577 );
	DL := DL +  7.4 * COS ( - 2.0 * G3 + 3.0 * G - 2.7688 );
	DL := DL +  4.9 * COS ( - 2.0 * G3 + 4.0 * G - 2.6894 );
	DL := DL +  2.6 * COS ( - 3.0 * G3 + 5.0 * G - 4.8970 );
	DL := DL +  3.1 * COS (         G5 - 2.0 * G - 0.8165 );
	DL := DL + 25.4 * COS (         G5 -       G - 0.8545 );
	DL := DL +  3.7 * COS (         G5           - 5.9757 );
	DL := DL +  2.1 * COS (   2.0 * G5 - 3.0 * G - 3.3637 );
	DL := DL + 16.0 * COS (   2.0 * G5 - 2.0 * G - 3.3492 );
	DL := DL + 21.9 * COS (   2.0 * G5 -       G - 3.2873 );
	DL := DL +  2.6 * COS (   3.0 * G5 - 2.0 * G - 3.9864 );
	DL := DL +  3.2 * COS (   3.0 * G5 -       G - 3.6164 );
	DL := DL +  1.6 * COS ( - 8.0 * G3 +15.0 * G - 2.9694 );
	DL := DL +  1.5 * COS ( -       G3 + 3.0 * G - 0.3871 );
	DL := DL +  1.5 * COS (   2.0 * G5           - 3.3103 );
	DL := DL +  1.3 * COS (   3.0 * G5 - 3.0 * G - 2.9369 );
	DL := DL +  1.2 * COS ( - 4.0 * G3 + 7.0 * G - 0.7268 );

	DR := DR +  7.0 * COS ( -       G3 +       G - 0.6126 );
	DR := DR +  2.9 * COS ( -       G3 + 2.0 * G - 1.9757 );
	DR := DR +  6.4 * COS ( - 2.0 * G3 + 3.0 * G - 1.1977 );
	DR := DR +  3.9 * COS (         G5 - 2.0 * G - 5.5220 );
	DR := DR + 23.1 * COS (         G5 -       G - 5.5653 );
	DR := DR +  3.0 * COS (   2.0 * G5 - 3.0 * G - 1.7957 );
	DR := DR + 22.1 * COS (   2.0 * G5 - 2.0 * G - 1.7801 );
	DR := DR + 16.6 * COS (   2.0 * G5 -       G - 1.7162 );
	DR := DR +  3.4 * COS (   3.0 * G5 - 2.0 * G - 2.4389 );

	R  := EXP( LN(10.0) * ( R + DR / 1000000.0 ) );

	L  := L + DL / CP;

	U := L - 0.851483 - 0.0134565 * T;
	L := L - 53.8/CP * SIN ( 2.0 * U );

	SB := SIN ( 0.032293 - 0.000012 * T ) * SIN ( U );
	CB := SQRT ( 1.0 - SB * SB );
	B  := ARCTAN ( SB / CB );

	B := B - 2.25 / CP * SIN ( U );



	TB  := T;
	TE  := ( JDREZ - 2415020.0 ) / 36525.0;

	TCP := ( TB + TE ) / 2.0;
	P   := ( 5025.6 + 2.2 * TCP ) / CP;
	PP  :=   3.036015 + 0.0159358 * TCP;

	DT := TB - TE;
	AA := P * DT;
	BB := 47.1 / CP * DT;
	C1 := L + PI2 / 2.0 - 0.5 * AA - PP;

	L := L - AA + BB * COS ( C1 ) * SB/CB;
	B := B -      BB * SIN ( C1 );


	SB := SIN ( B );
	CB := COS ( B );
	TB := SB / CB  ;
	L  := L - TRUNC ( L / PI2 ) * PI2 ;

	SL := SIN ( L );
	CL := COS ( L );

        T    := ( JDREZ - 2415020.0 ) / 36525.0;
        EPS  := ( 23.0 * 3600.0 + 27.0 * 60.0 + 8.260 - 46.845 * T  ) / CP ;
        SEPS := SIN ( EPS ) ;
        CEPS := COS ( EPS ) ;

	X := R * CB *   CL;
	Y := R * CB * ( SL * CEPS - TB * SEPS );
	Z := R * CB * ( SL * SEPS + TB * CEPS );


END;

End.
