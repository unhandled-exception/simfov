
{$O+,F+}


Unit PURAN;
Interface
   Procedure URAN ( JD, JDREZ : DOUBLE; Var L, B, R, X, Y, Z : DOUBLE );
Implementation



   Procedure URAN ( JD, JDREZ : DOUBLE; Var L, B, R, X, Y, Z : DOUBLE );

{       COMPUTATION OF URAN  HELIOCENTRIC COORDINATES
	*********************************************

	JD    - TIME MOMENT
	JDREZ - RESULTING COORDINTES SYSTEM
	L, B  - ECLIPTICAL COORDINATES
	X,Y,Z - EQUATORIAL COORDINATES

}
 VAR
	PI2, T2, GR,
	DL, DR, U,
	CP, T, TB, T1, T11, EPS, SEPS, CEPS,
	GJ, GS, GU, GN,
	C0, C1, S1, C2, S2, C3, S3, AR, CA, SA,
	TE, TCP, P, PP, DT, AA, BB, SB, CB, SL, CL : DOUBLE;

BEGIN

	CP  := 206264.806247;
	PI2 := 3.14159265359 * 2.0;

	T  := ( JD - 2415020.0 ) / 36525.0;
	TB := T;
	T1 := T + 0.4999863;


	GJ := 3.9343 + 52.9691 * T;
	GS := 3.0675 + 21.3299 * T;
	GU := 1.2970 +  7.4788 * T;
	GN := 0.7215 +  3.8130 * T;

	L  := 4.247475 + 7.503143 * T + 0.00017 * T * T;

	DL := 0.0;
	DR := 0.0;

	C0 := 0.0;
	C1 := 0.0;
	S1 := 0.0;
	C2 := 0.0;
	S2 := 0.0;
	C3 := 0.0;
	S3 := 0.0;

	AR := GU - GN;
	CA := COS ( AR );
	SA := SIN ( AR );

	C0 := C0 - 29.0 * CA + 20.0 * SA;
	C1 := C1  - 5.0 * CA +  4.0 * SA;

	AR := 2.0 * ( GU - GN );
	CA := COS ( AR );
	SA := SIN ( AR );

	C0 := C0 + 29.0 * CA + 10.0 * SA;

	AR := 3.0 * ( GU - GN );
	CA := COS ( AR );
	SA := SIN ( AR );

	C0 := C0 +  4.0 * CA + 14.0 * SA;
	S1 := S1 - 16.0 * CA +  8.0 * SA;
	C1 := C1  + 9.0 * CA + 18.0 * SA;

	AR := GS - GU;
	CA := COS ( AR );
	SA := SIN ( AR );

	C0 := C0 - 19.0 * CA + 13.0 * SA;
	S3 := S3 -  5.0 * CA +  3.0 * SA;
	C3 := C3 +  3.0 * CA +  5.0 * SA;

	AR := GJ - GU;
	CA := COS ( AR );
	SA := SIN ( AR );

	C0 := C0 - 21.0 * CA - 49.0 * SA;
	S1 := S1 +  4.0 * CA -  2.0 * SA;

	AR := GS - 2.0 * GU;
	CA := COS ( AR );
	SA := SIN ( AR );

	C0 := C0 + 20.0 * CA + 143.0 * SA;

	AR := 3.0 * GU - GS;
	CA := COS ( AR );
	SA := SIN ( AR );

	C0 := C0 + 76.0 * CA - 102.0 * SA;

	S1 := S1 + 112.0 * T -  2.0 * T * T;
	C1 := C1 -  68.0 * T - 10.0 * T * T;
	S2 := S2 +   7.0 * T;
	C2 := C2 -   4.0 * T;

	T11 := T + 1.0;
	C0 := C0 - 22.0 + 17.0 * T11 / 2.0 + 7.0 * T11 * T11 / 4.0;
	S1 := S1 - 8.0;
	C1 := C1 + 4.0 * T11;

	DL := DL + C0;

	DL := DL + S1 * SIN (       GU ) + C1 * COS (       GU );
	DL := DL + S2 * SIN ( 2.0 * GU ) + C2 * COS ( 2.0 * GU );
	DL := DL + S3 * SIN ( 3.0 * GU ) + C3 * COS ( 3.0 * GU );

	DL := DL + 19402.0 * SIN (       GU ) +
     	             570.0 * SIN ( 2.0 * GU ) +
     		      23.0 * SIN ( 3.0 * GU );

	L := L + DL / CP;

	U := L - 1.2826 - 0.0089 * T;

	S1 := -  71.0 * T;
	C1 := - 130.0 * T;

	DR := DR +    S1 * SIN (       GU      ) +   C1 * COS ( GU      );
	DR := DR -  76.0 * SIN (       GU - GS );
	DR := DR - 133.0 * COS ( 2.0 * GU - GS );
	DR := DR - 103.0 * COS (       GU - GJ ) - 45.0 * SIN ( GU - GJ );

	R :=   - 20414.0 * COS (      GU ) ;
     	R := R -   720.0 * COS ( 2.0 * GU );

	R :=  1.283294 + ( R + DR ) / 1000000.0;
	R := EXP( LN(10.0) * R );

	B := 0.013485 * SIN ( U );

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
