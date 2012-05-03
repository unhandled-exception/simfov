
{$O+,F+}


Unit PJUP;
Interface
   Procedure JUP ( JD, JDREZ : DOUBLE; Var L, B, R, X, Y, Z : DOUBLE );
Implementation



   Procedure JUP ( JD, JDREZ : DOUBLE; Var L, B, R, X, Y, Z : DOUBLE );

{       COMPUTATION OF JUPITER HELIOCENTRIC COORDINATES
	***********************************************

	JD    - TIME MOMENT
	JDREZ - RESULTING COORDINTES SYSTEM
	L, B  - ECLIPTICAL COORDINATES
	X,Y,Z - EQUATORIAL COORDINATES

}


Var
	M, N,
	EPS, SEPS, CEPS, G, G1, G2, G3, G4, G5, DL, DZ, DR, F,
	SB, CB, TB, V, U, E, Pi2, Cp,
	T, TE, TCP, P, PP, DT, AA, BB, C1, SL, CL : DOUBLE;



Begin

	PI2 := 3.14159265359 * 2.0 ;
	CP  := 206264.806247       ;

	T  := ( JD - 2415020.0 ) / 36525.0;
	TB := T;

	T := ( JD - 2396758.0 ) / 365.25;
	M := 0.08430296 * T;

	G  := 2.58366097  + 0.529691136  * T;
	G  := G - TRUNC ( G / PI2 ) * PI2;

	G1 := 4.969245 + 0.2132996 * T;
	G1 := G1 - TRUNC ( G1 / PI2 ) * PI2 ;

	G2 := 3.842683 + 0.0747862 * T;
	G2 := G2 - TRUNC ( G2 / PI2 ) * PI2 ;

	Z  := T + 4.877675;
 	DZ := 0.0;

	DZ := DZ +  39928.0 * SIN (          -       G + 3.969972 ) * M;
	DZ := DZ +  37294.0 * SIN (       G1           + 2.634308 );
	DZ := DZ + 266919.0 * SIN (       G1 -       G + 1.382349 );
	DZ := DZ +  22776.0 * SIN ( 2.0 * G1           + 2.161241 );
	DZ := DZ + 411235.0 * SIN ( 2.0 * G1 -       G + 0.024660 );
	DZ := DZ + 650670.0 * SIN ( 2.0 * G1 - 2.0 * G + 5.879958 );
	DZ := DZ +  46930.0 * SIN ( 3.0 * G1 -       G + 5.448768 );
	DZ := DZ + 276299.0 * SIN ( 3.0 * G1 - 2.0 * G + 2.223234 );
	DZ := DZ +  54251.0 * SIN ( 3.0 * G1 - 3.0 * G + 1.007312 );
	DZ := DZ +  56290.0 * SIN ( 4.0 * G1 - 2.0 * G + 1.718587 );
	DZ := DZ +  50072.0 * SIN ( 4.0 * G1 - 3.0 * G + 0.454571 );
	DZ := DZ + 538023.0 * SIN ( 5.0 * G1 - 3.0 * G + 3.079881 );
	DZ := DZ +   1888.0 * SIN ( 5.0 * G1 - 3.0 * G + 1.411884 ) * M;
	DZ := DZ +  36853.0 * SIN (10.0 * G1 - 4.0 * G + 5.4748  +
							 0.00071 * T );
	DZ := DZ + ( 3998745.0 - 2213.0 * M ) *
       		    SIN (  5.0 * G1 - 2.0 * G + 1.171968 -
     					        0.00039740 * T );
	DZ := DZ +  28956.0 * SIN (  6.0 * G1 - 2.0 * G + 3.27831 -
     				     3.0 * G2			    );

	Z := Z + DZ / 1000000.0 / 365.25;

	DR := 0.0;

	DR := DR +  126.0 * COS (          -       G + 3.9698 ) * M;
	DR := DR +  545.0 * COS (       G1 -       G + 1.3821 );
	DR := DR +   61.0 * COS ( 2.0 * G1           + 5.3265 );
	DR := DR +  383.0 * COS ( 2.0 * G1 -       G + 6.2167 );
	DR := DR + 2303.0 * COS ( 2.0 * G1 - 2.0 * G + 5.8800 );
	DR := DR +   62.0 * COS ( 2.0 * G1 - 3.0 * G + 5.8151 );
	DR := DR +   56.0 * COS ( 3.0 * G1 -       G + 2.3220 );
	DR := DR +  738.0 * COS ( 3.0 * G1 - 2.0 * G + 2.2095 );
	DR := DR +  241.0 * COS ( 3.0 * G1 - 3.0 * G + 1.0213 );
	DR := DR +   85.0 * COS ( 4.0 * G1 - 2.0 * G + 1.6416 );
	DR := DR +  193.0 * COS ( 4.0 * G1 - 3.0 * G + 0.4714 );
	DR := DR +   60.0 * COS ( 4.0 * G1 - 4.0 * G + 2.2314 );
	DR := DR +  229.0 * COS ( 5.0 * G1 - 2.0 * G + 4.1520 );
	DR := DR + 1679.0 * COS ( 5.0 * G1 - 3.0 * G + 3.0787 );
	DR := DR +   65.0 * COS ( 5.0 * G1 - 4.0 * G + 2.4648 );

	DR  := EXP ( LN ( 10.0 ) * ( DR / 10000000.0 ) );

	N := 109256.6 / CP * Z;

	F := N  + 19900.0 / CP * SIN (       N ) ;
     	F := F  +   600.0 / CP * SIN ( 2.0 * N ) ;
      	F := F  +    25.0 / CP * SIN ( 3.0 * N ) ;

	L := 0.207824 + F;

	B :=  0.02289         * SIN ( L - 1.7267 ) ;
     	B :=  B + 4.4 * M /CP * SIN ( F + 0.62   ) ;

	L := L + 27.0 / CP * SIN ( 2.0 * L + 5.9711 ) + 50.265 * T / CP;

	R := 5.1906885 / ( 1.0 + 0.0482538 * COS ( F ) );
	R := R * DR;


	SB := B;
	CB := SQRT ( 1.0 - SB * SB );
	B  := ARCTAN ( SB / CB );



	TE  := ( JDREZ - 2415020.0 ) / 36525.0;

	TCP := ( TB + TE ) / 2.0;
	P   := ( 5025.6        + 2.2       * TCP ) / CP;
	PP  :=        3.036015 + 0.0159358 * TCP;

	DT := TB - TE;
	AA :=  P * DT;
	BB := 47.1 / CP * DT;
	C1 := L + PI2 / 2.0 - 0.5 * AA - PP;

	L := L - AA + BB * COS ( C1 ) * SB / CB;
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
