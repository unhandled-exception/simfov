
{$O+,F+}


Unit PSATJUP;
Interface
Type
 CoordArray = Array [1..4] of DOUBLE;

  Procedure SATJUP ( JD : DOUBLE; Var X,Y, DR : CoordArray );
Implementation


  Procedure SATJUP ( JD : DOUBLE; Var X,Y, DR : CoordArray );


{		 COORDINATES OF JUPITER SATELLITES
		 *********************************


	X (I) , Y (I) - COORDINATES IN ARCSECONDS

	X-AXES POINTS FROM JUP. CENTER TO THE WEST
	Y-AXES POINTS FROM JUP. CENTER TO THE NORTH
}


 VAR
	PI2, D, DU,
	M, N, J, K, KSI, L,
	GR, V, SV, A, B, RE, RJ, REJ,
        SKSI, DE, R1, R2, R3, R4,
	U1, U2, U3, U4, G, H, REKV, RSD, RJAE     : DOUBLE ;


 BEGIN


        RJAE := 0.0004660494 ;

	PI2 := 360.0;
	GR  := Pi / 180.0;

	D := JD - 2415020.0;

	V  := 134.63  + 0.001115870 ;
	V  := V - TRUNC ( V / PI2 ) * PI2 ;
	SV := SIN ( V * GR );

	M := 358.476 + 0.9856003 * D ;
	N := 225.328 + 0.0830853 * D + 0.33 * SV ;
	J := 221.647 + 0.9025179 * D - 0.33 * SV ;

	A := 1.916 * SIN ( M * GR ) + 0.020 * SIN ( 2.0 * M * GR );
	B := 5.552 * SIN ( N * GR ) + 0.167 * SIN ( 2.0 * N * GR );

	K := J + A - B;

	RE := 1.00014 - 0.01672 * COS (       M * GR ) -
     		        0.00014 * COS ( 2.0 * M * GR );

	RJ := 5.20867 - 0.25192 * COS (       N * GR ) -
     		        0.00610 * COS ( 2.0 * N * GR );

	REJ := SQRT ( RE * RE + RJ * RJ - 2.0 * RE * RJ * COS ( K * GR ) );

	SKSI := RE / REJ * SIN ( K * GR );

	KSI := ARCTAN ( SKSI / SQRT ( 1.0 - SKSI*SKSI ) ) / GR;

	L := 238.05 + 0.083091 * D + 0.33 * SIN ( V*GR ) + B;

	DE :=      3.07 * SIN ( ( L + 44.5 ) * GR ) ;
     	DE := DE - 2.15 * SIN ( KSI * GR ) * COS ( ( L + 24.0 ) * GR ) ;
     	DE := DE - 1.31 * SIN (  ( L - 99.4 ) * GR ) * ( RJ - REJ ) / REJ;

	R1 := KSI - B;
	DU := D -  REJ / 173.0 ;

	U1 :=  84.5506 + 203.4058630 * DU + R1;
	U2 :=  41.5015 + 101.2916323 * DU + R1;
	U3 := 109.9770 +  50.2345169 * DU + R1;
	U4 := 176.3586 +  21.4879802 * DU + R1;

	G := 187.3 + 50.310674 * DU  ;
	H := 311.1 + 21.569229 * DU  ;

	R1 :=  5.9061 - 0.0244 * COS ( 2.0 * ( U1 - U2 ) * GR );
	R2 :=  9.3972 - 0.0889 * COS ( 2.0 * ( U2 - U3 ) * GR );
	R3 := 14.9894 - 0.0227 * COS (            G      * GR );
	R4 := 26.3649 - 0.1944 * COS (            H      * GR );

	U1 := U1 + 0.472 * SIN ( 2.0 * ( U1 - U2 ) * GR );
	U2 := U2 + 1.073 * SIN ( 2.0 * ( U2 - U3 ) * GR );
	U3 := U3 + 0.174 * SIN (            G      * GR );
	U4 := U4 + 0.845 * SIN (            H      * GR );

	REKV := 98.37 / REJ;

	X [ 1 ] := - R1 * REKV * SIN ( U1 * GR );
	X [ 2 ] := - R2 * REKV * SIN ( U2 * GR );
	X [ 3 ] := - R3 * REKV * SIN ( U3 * GR );
	X [ 4 ] := - R4 * REKV * SIN ( U4 * GR );

	RSD := - REKV * SIN ( DE * GR );

	Y [ 1 ] := - R1 * COS ( U1 * GR ) * RSD;
	Y [ 2 ] := - R2 * COS ( U2 * GR ) * RSD;
	Y [ 3 ] := - R3 * COS ( U3 * GR ) * RSD;
	Y [ 4 ] := - R4 * COS ( U4 * GR ) * RSD;


	DR [ 1 ] := - R1 * COS ( U1 * GR ) * RJAE ;
	DR [ 2 ] := - R2 * COS ( U2 * GR ) * RJAE ;
	DR [ 3 ] := - R3 * COS ( U3 * GR ) * RJAE ;
	DR [ 4 ] := - R4 * COS ( U4 * GR ) * RJAE ;



END;

End.
