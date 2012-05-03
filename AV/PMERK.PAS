
{$O+,F+}

Unit PMerk;
Interface
   Procedure MERK ( JD, JDREZ : DOUBLE; Var L, B, R, X, Y, Z : DOUBLE );
Implementation



   Procedure MERK ( JD, JDREZ : DOUBLE; Var L, B, R, X, Y, Z : DOUBLE );

{       COMPUTATION OF MERCURY HELIOCENTRIC COORDINATES
	***********************************************

	JD    - TIME MOMENT
	JDREZ - RESULTING COORDINTES SYSTEM
	L, B  - ECLIPTICAL COORDINATES
	X,Y,Z - EQUATORIAL COORDINATES

}

Var
	M, N,
	PI2, GR, RGR, CP,
	EPS, SEPS, CEPS, G, G1, G2, G3, G4, G5, DL, DZ, DR, F,
	SB, CB, TB, V, U,
	T, TE, TCP, P, PP, DT, AA, BB, C1, SL, CL : DOUBLE;



Begin


	PI2 := 3.14159265359 * 2.0 ;
	CP  := 206264.806247       ;

	T := ( JD - 2415020.0 ) / 36525.0;

	GR  := 1.78511195 + 2608.787533 * T;

	RGR := GR / PI2;
	G   := GR - TRUNC ( RGR ) * PI2;

	R := -407563.61 + 0.92 * T;

	R := R - COS (       G ) * ( 87878.82 + 8.46 * T );
	R := R - COS ( 2.0 * G ) * ( 13416.31 + 2.60 * T );
	R := R - COS ( 3.0 * G ) * (  2579.08 + 0.75 * T );
	R := R - COS ( 4.0 * G ) *     548.05;
	R := R - COS ( 5.0 * G ) *     123.22;
	R := R - COS ( 6.0 * G ) *      28.74;
	R := R - COS ( 7.0 * G ) *       6.87;
	R := R - COS ( 8.0 * G ) *       1.68;

	V := 0.0;
	V := V + SIN (       G ) * ( 84377.7 + 8.3 * T );
	V := V + SIN ( 2.0 * G ) * ( 10732.8 + 2.1 * T );
	V := V + SIN ( 3.0 * G ) * (  1892.1 + 0.6 * T );
	V := V + SIN ( 4.0 * G ) *     381.1;
	V := V + SIN ( 5.0 * G ) *      82.6;
	V := V + SIN ( 6.0 * G ) *      18.7;
	V := V + SIN ( 7.0 * G ) *       4.4;
	V := V + SIN ( 8.0 * G ) *       1.0;

	L := G + V / CP + 1.324700 + 0.027148 * T + 0.000005 * T * T;

        DL := 0.0;
	DR := 0.0;

	G2 := 3.7095 + 1021.3258 * T;
	G5 := 3.9333 +   52.9663 * T;

	DL := DL + 3.7  * COS ( 2.0 * G2  -        G  -  2.8046 );
	DL := DL + 2.1  * COS ( 2.0 * G2  -  2.0 * G  -  2.8126 );
	DL := DL + 1.3  * COS ( 3.0 * G2  -  2.0 * G  -  1.8288 );
	DL := DL + 2.8  * COS ( 5.0 * G2  -  3.0 * G  -  6.1063 );
	DL := DL + 7.6  * COS ( 5.0 * G2  -  2.0 * G  -  6.0699 );
	DL := DL + 1.5  * COS ( 5.0 * G2  -        G  -  6.0685 );
	DL := DL + 3.3  * COS ( 2.0 * G5  -        G  -   0.6458 );

	DR := DR + 0.71 * COS ( 2.0 * G2  -  3.0 * G  -  1.2413 );
	DR := DR + 2.37 * COS ( 2.0 * G2  -  2.0 * G  -  1.2425 );
	DR := DR + 0.90 * COS ( 2.0 * G2  -        G  -  1.2303 );
	DR := DR + 0.76 * COS ( 2.0 * G2              -  4.3633 );
	DR := DR + 1.16 * COS ( 3.0 * G2  -  2.0 * G  -  0.2590 );
	DR := DR + 0.85 * COS ( 5.0 * G2  -  4.0 * G  -  4.5293 );
	DR := DR + 2.95 * COS ( 5.0 * G2  -  3.0 * G  -  4.5364 );
	DR := DR + 1.55 * COS ( 5.0 * G2  -        G  -  1.3570 );
	DR := DR + 0.71 * COS (       G5  -        G  -  1.5949 );
	DR := DR + 1.18 * COS ( 2.0 * G5  -  2.0 * G  -  5.3576 );
	DR := DR + 3.27 * COS ( 2.0 * G5  -        G  -  5.3579 );

	R := ( R + DR ) / 1000000.0;
	R := EXP( LN(10.0) * R );


	L := L + DL / CP;

	U := L - 0.822852 - 0.020686 * T;

	L := L - ( 772.2 * SIN ( 2 * U ) + 1.4 * SIN ( 4 * U ) ) / CP;

	SB := SIN ( 0.122223 + 0.000032 * T ) * SIN ( U );
	CB := SQRT ( 1.0 - SB * SB );
	B  := ARCTAN ( SB / CB );

	B  :=  B  -  6.7 / CP * SIN ( U );


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
        EPS  := ( 23.0 * 3600.0 + 27.0 * 60.0 +  8.260 - 46.845 * T  ) / CP ;
        SEPS := SIN ( EPS ) ;
        CEPS := COS ( EPS ) ;

	X := R * CB *   CL;
	Y := R * CB * ( SL * CEPS - TB * SEPS );
	Z := R * CB * ( SL * SEPS + TB * CEPS );


END;

End.

