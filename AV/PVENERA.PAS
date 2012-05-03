
{$O+,F+}

Unit PVENERA;
Interface
   Procedure VENERA ( JD, JDREZ : DOUBLE; Var L, B, R, X, Y, Z : DOUBLE );
Implementation



   Procedure VENERA ( JD, JDREZ : DOUBLE; Var L, B, R, X, Y, Z : DOUBLE );

{       COMPUTATION OF VENERA HELIOCENTRIC COORDINATES
	**********************************************

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

	GR := 3.71062623 + 1021.32835 * T + 0.0000224 * T * T;

	G   := GR - TRUNC ( GR / PI2 ) * PI2;

	R := 5.1 - COS (       G ) * ( 2962.4 - 20.7 * T );
	R := R   - COS ( 2.0 * G ) *     15.2;
	R := R / 1000000.0 - 0.14066255;

	V := SIN (      G ) * ( 2813.72 - 19.69 * T ) +
     +	    SIN ( 2.0 * G ) * (   12.00 -   0.17 * T );

	L := G + V / CP + 2.271787 + ( 5068.9 * T - 3.5 * T * T ) / CP;

	G3 := 6.2593 + 628.3074 * T;
	G4 := 5.5805 + 334.0610 * T;
	G5 := 3.9345 +  52.9689 * T;

	DL := 0.0;
	DR := 0.0;

	DL := DL +  4.9 * COS (        G3  -       G  - 2.0788 );
	DL := DL + 11.3 * COS (  2.0 * G3  - 2.0 * G  - 2.5870 );
	DL := DL +  7.1 * COS (  3.0 * G3  - 3.0 * G  - 6.2384 );
	DL := DL +  3.4 * COS (  3.0 * G3  - 2.0 * G  - 2.3721 );
	DL := DL +  1.0 * COS (  4.0 * G3  - 4.0 * G  - 0.4632 );
	DL := DL +  1.6 * COS (  5.0 * G3  - 4.0 * G  - 3.3847 );
	DL := DL +  1.4 * COS (  5.0 * G3  - 3.0 * G  - 2.4099 );
	DL := DL +  2.8 * COS ( 13.0 * G3  - 8.0 * G  - 3.9784 );
	DL := DL +  1.2 * COS (  3.0 * G4  -       G  - 4.1464 );
	DL := DL +  3.0 * COS (        G5  -       G  - 3.6318 );
	DL := DL +  1.6 * COS (        G5             - 4.6829 );

	DL := DL +  2.8 * SIN ( 4.1406 + 2.6227 * T );

	L := L + DL / CP;

	DR := DR + 2.2 * COS (       G3  -       G  - 0.5081 );
	DR := DR + 9.8 * COS ( 2.0 * G3  - 2.0 * G  - 1.0159 );
	DR := DR + 8.3 * COS ( 3.0 * G3  - 3.0 * G  - 4.6674 );
	DR := DR + 0.7 * COS ( 3.0 * G3  - 2.0 * G  - 0.8268 );
	DR := DR + 1.4 * COS ( 4.0 * G3  - 4.0 * G  - 5.1747 );
	DR := DR + 0.5 * COS ( 5.0 * G3  - 5.0 * G  - 5.7009 );
	DR := DR + 1.6 * COS ( 5.0 * G3  - 4.0 * G  - 1.8188 );
	DR := DR + 0.7 * COS ( 3.0 * G4  - 2.0 * G  - 2.2969 );
	DR := DR + 3.0 * COS (       G5  -       G  - 2.0611 );
	DR := DR + 1.3 * COS ( 2.0 * G5  - 2.0 * G  - 0.9628 );

	R :=  R + DR / 1000000.0;
	R := EXP ( LN ( 10.0 )  *  R );


	U := L - 1.322604 - 0.015705 * T;
	L := L - 181.0 / CP * SIN ( 2.0 * U );

	SB := SIN ( 0.059230 + 0.000018 * T ) * SIN ( U );
	CB := SQRT ( 1.0 - SB * SB );
	B  := ARCTAN ( SB / CB );

	B := B + 3.6 / CP * SIN ( U );



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
