
{$O+,F+}

Unit PSOL;
Interface
   Procedure SOL ( JD, JDREZ : Double;  Var L, B, R, X, Y, Z : Double );
Implementation



   Procedure SOL ( JD, JDREZ : Double;  Var L, B, R, X, Y, Z : Double );

{       COMPUTATION OF SUN HEOCENTRIC COORDINATES
	*****************************************

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
	T, TE, TCP, P, PP, DT, AA, BB, C1, SL, CL : Double;



Begin


	PI2 := 3.14159265359 * 2.0;
	CP  := 206264.806247      ;

	T := ( JD - 2415020.0 ) / 36525.0;


	GR :=     6.25658358
              + 628.301946    * T
              -   0.00000262  * T * T
              -   5.82e-8     * T * T * T ;

	G   := GR - TRUNC ( GR / PI2 ) * PI2;

	E  := 0.1675104E-1 - 0.418E-4 * T;

	G := G + 0.31E-4 * SIN ( 4.0350 + 0.3526 * T ) +
     		 0.91E-5 * SIN ( 0.9990 + 2.6227 * T );

	V := G + ( 0.0335009 - 0.8358E-4 * T ) * SIN (       G ) ;
     	V := V + ( 0.3507E-3 - 0.175E-5  * T ) * SIN ( 2.0 * G ) ;
        V := V +   0.511E-5                    * SIN ( 3.0 * G ) ;

	L := V + 4.908229 + 0.03000526 * T + 0.79E-5 * T * T;

	G2 := 3.7080 + 1021.3229 * T;
	G4 := 5.5777 +  334.0556 * T;
	G5 := 3.9319 +   52.9635 * T;

	DR := 13.4 * COS ( 6.1215 + 7771.38 * T );

	L := L +  0.312E-4 * SIN ( 6.1215 + 7771.38 * T );

	L := L + 0.2346E-4 * COS ( 5.2203 +       G2 -       G );
	L := L + 0.2679E-4 * COS ( 2.5886 + 2.0 * G2 - 2.0 * G );
	L := L + 0.1211E-4 * COS ( 5.5143 + 2.0 * G2 - 3.0 * G );
	L := L + 0.756E-5  * COS ( 6.0258 + 3.0 * G2 - 4.0 * G );
	L := L + 0.496E-5  * COS ( 5.5528 + 3.0 * G2 - 5.0 * G );
	L := L + 0.990E-5  * COS ( 6.0020 - 2.0 * G4 + 2.0 * G );
	L := L + 0.858E-5  * COS ( 3.4977 - 2.0 * G4 +       G );
	L := L + 0.3495E-4 * COS ( 3.1334 -       G5 +       G );
	L := L + 0.1261E-4 * COS ( 4.5940 -       G5           );
	L := L + 0.1324E-4 * COS ( 1.5210 - 2.0 * G5 + 2.0 * G );
	L := L + 0.781E-5  * COS ( 1.9110 - 2.0 * G5 +       G );

	DR := DR + 2.4 * COS ( 3.6491 +       G2 -       G );
	DR := DR + 6.8 * COS ( 1.0178 + 2.0 * G2 - 2.0 * G );
	DR := DR + 1.0 * COS ( 1.5284 + 3.0 * G2 - 3.0 * G );
	DR := DR + 1.5 * COS ( 4.4550 + 3.0 * G2 - 4.0 * G );
	DR := DR + 2.1 * COS ( 4.4301 - 2.0 * G4 + 2.0 * G );
	DR := DR + 7.1 * COS ( 1.5629 -       G5 +       G );
	DR := DR + 4.0 * COS ( 6.2327 - 2.0 * G5 + 2.0 * G );
	DR := DR + 1.5 * COS ( 0.3398 - 2.0 * G5 +       G );


	DR := EXP( LN(10.0) * DR / 1000000.0 );

	R := 1.0 + E*E/2.0 + COS (G)  * ( 3.0 * E*E*E / 8.0 - E );
	R := R   -       E*E   / 2.0 * COS (     G+G );
        R := R   - 3.0 * E*E*E / 8.0 * COS ( 3.0 * G );

	R := R * DR;



	TB  := T;
	TE  := ( JDREZ - 2415020.0 ) / 36525.0;

	TCP := ( TB + TE ) / 2.0;
	P   := ( 5025.6 + 2.2 * TCP ) / CP;
	PP  :=   3.036015 + 0.0159358 * TCP;

	DT := TB - TE;
	AA := P * DT;
	BB := 47.1 / CP * DT;
	C1 := L + PI2 / 2.0 - 0.5 * AA - PP;

	L := L - AA ;
	B :=   - BB * SIN ( C1 );


	SB := SIN ( B );
        CB := COS ( B );
	TB := SB / CB ;
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
