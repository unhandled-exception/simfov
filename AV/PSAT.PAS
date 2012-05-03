
{$O+,F+}



Unit PSAT;
Interface
   Procedure SAT ( JD, JDREZ : DOUBLE; Var L, B, R, X, Y, Z : DOUBLE );
Implementation



   Procedure SAT ( JD, JDREZ : DOUBLE; Var L, B, R, X, Y, Z : DOUBLE );

{       COMPUTATION OF SATURN  HELIOCENTRIC COORDINATES
	***********************************************

	JD    - TIME MOMENT
	JDREZ - RESULTING COORDINTES SYSTEM
	L, B  - ECLIPTICAL COORDINATES
	X,Y,Z - EQUATORIAL COORDINATES

}

Var
	M, N,
	PI2, CP, EPS, SEPS, CEPS, G, G1, G2, G3, G4, G5, DL, DZ, DR, F,
	SB, CB, TB, V, U, E,
	T, TE, TCP, P, PP, DT, AA, BB, C1, SL, CL : DOUBLE;



Begin


	PI2  := 3.14159265359 * 2.0 ;
	CP   := 206264.806247       ;

	T    := ( JD - 2415020.0 ) / 36525.0;
	TB   := T;

	T  := ( JD - 2396758.0 ) / 365.250;

	M  := 0.03394769 * T;

	G  := 2.58366097 + 0.529691136 * T;
	G  := G - TRUNC ( G / PI2 ) * PI2;

	G1 := 4.969245 + 0.2132996 * T;
	G1 := G1 - TRUNC ( G1 / PI2 ) * PI2;

	G2 := 3.842683 + 0.0747862 * T;
	G2 := G2 - TRUNC ( G2 / PI2 ) * PI2;

	Z  := T + 23.29702;
 	DZ := 0.0;


	DZ := DZ +  65776.0 * SIN (       G1           + 4.1536 ) * M;
	DZ := DZ +   1344.0 * SIN ( 2.0 * G1           + 4.1536 ) * M;
	DZ := DZ +  10041.0 * SIN (          -       G + 1.5144 );
	DZ := DZ +   5977.0 * SIN (       G1 -       G + 3.3089 );
	DZ := DZ + 350470.0 * SIN ( 2.0 * G1 -       G + 3.1665 );
	DZ := DZ +   1021.0 * SIN ( 2.0 * G1 -       G + 2.1372 ) * M;
	DZ := DZ +  27834.0 * SIN ( 3.0 * G1 -       G + 2.1158 );
	DZ := DZ +  21710.0 * SIN ( 3.0 * G1 - 2.0 * G + 2.3661 );
	DZ := DZ + 567852.0 * SIN ( 4.0 * G1 - 2.0 * G + 4.8415 );
	DZ := DZ +  26600.0 * SIN ( 2.0 * G1 - 2.0 * G + 2.7397 );
	DZ := DZ +   4045.0 * SIN ( 4.0 * G1 - 2.0 * G + 3.1343 ) * M;
	DZ := DZ +2415265.0 * SIN ( 5.0 * G1 - 2.0 * G + 4.3129 - 0.000398 * T );
	DZ := DZ +   3425.0 * SIN ( 5.0 * G1 - 2.0 * G + 1.1713 - 0.000390 * T ) * M;
	DZ := DZ +    505.0 * SIN ( 6.0 * G1 - 2.0 * G + 2.1990 ) * M;
	DZ := DZ +   5410.0 * SIN ( 3.0 * G1 - 3.0 * G + 4.0908 );
	DZ := DZ +   3820.0 * SIN ( 4.0 * G1 - 3.0 * G + 3.5476 );
	DZ := DZ +   5189.0 * SIN ( 7.0 * G1 - 3.0 * G + 0.5481 );
	DZ := DZ +   7330.0 * SIN ( 9.0 * G1 - 4.0 * G + 2.8572 );
	DZ := DZ +  22255.0 * SIN (10.0 * G1 - 4.0 * G + 2.3321 - 0.000718 * T );

	DZ := DZ +   6604.0 * SIN (       G2 -       G1 + 1.3794 );
	DZ := DZ +   6313.0 * SIN ( 2.0 * G2 -       G1 + 6.1834 );
	DZ := DZ +  10175.0 * SIN ( 2.0 * G2 - 2.0 * G1 + 5.8769 );
	DZ := DZ +  23440.0 * SIN ( 3.0 * G2 -       G1 + 5.6160 );
	DZ := DZ +  19196.0 * SIN ( 3.0 * G2 - 2.0 * G1 + 2.0827 );
	DZ := DZ +  23778.0 * SIN ( 6.0 * G1 - 2.0 * G  + 0.1210 - 3.0 * G2 );

	Z := Z + DZ / 100000.0 / 365.25;

	DR := 1826.0 + 12.0 * M;

	DR := DR +  187.0 * COS (       G1           + 5.1559 );
	DR := DR +  835.0 * COS (       G1           + 1.0120 ) * M;
	DR := DR + 3783.0 * COS (       G1 -       G + 1.3919 );
	DR := DR + 2443.0 * COS ( 2.0 * G1 -       G + 3.0725 );
	DR := DR +  241.0 * COS ( 3.0 * G1 -       G + 5.3391 );
	DR := DR +  644.0 * COS ( 2.0 * G1 - 2.0 * G + 2.7328 );
	DR := DR +  421.0 * COS ( 3.0 * G1 - 2.0 * G + 2.4778 );
	DR := DR + 7005.0 * COS ( 4.0 * G1 - 2.0 * G + 4.8391 );
	DR := DR + 1142.0 * COS ( 5.0 * G1 - 2.0 * G + 1.0965 - 0.00043 * T );
	DR := DR +  235.0 * COS ( 3.0 * G1 - 2.0 * G + 2.0786 );
	DR := DR +  147.0 * COS ( 3.0 * G1 - 3.0 * G + 4.0829 );
	DR := DR +   50.0 * COS ( 4.0 * G1 - 2.0 * G + 3.1353 ) * M;
	DR := DR +   23.0 * COS ( 2.0 * G1           + 1.0240 ) * M;

	DR := EXP( LN(10.0) * ( DR / 10000000.0 ) );

	N := 0.2132996 * Z;

	F := N + ( 23118.0 * SIN (       N ) ) / CP ;
     	F := F + (   809.0 * SIN ( 2.0 * N ) ) / CP ;
     	F := F - (    39.0 * SIN ( 3.0 * N ) ) / CP ;

	L := 1.572733 + F;

	B := 0.0435189 * SIN ( L - 1.96084 );
	B := B + 24.27 / CP * M * SIN ( F + 1.3450 );

	L := L + ( 98.0 * SIN ( 2.0 * F + 2.3654 ) + 50.2647 * T ) / CP;

	R := 9.508864 / ( 1.0 + 0.0560608 * COS ( F ) );

	R := R * DR;

	SB := B;
	CB := SQRT ( 1.0 - SB * SB );
	B  := ARCTAN ( SB / CB );


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
