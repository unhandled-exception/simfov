
{$O+,F+}



Unit PMONDIA;
Interface
   Procedure MONDIA ( JD, JDREZ : DOUBLE; Var L, B, R, X, Y, Z : DOUBLE );
Implementation



   Procedure MONDIA ( JD, JDREZ : DOUBLE; Var L, B, R, X, Y, Z : DOUBLE );

{       COMPUTATION OF MONDIA  HEOCENTRIC COORDINATES
	*********************************************

	JD    - TIME MOMENT
	JDREZ - RESULTING COORDINTES SYSTEM
	L, B  - ECLIPTICAL COORDINATES
	X,Y,Z - EQUATORIAL COORDINATES

}
 VAR

	PAR, M, N,
	PI2, T2, GR,
	EPS, SEPS, CEPS, G, G1, G2, G3, G4, G5, DL, DZ, DR, F,
	SB, CB, TB, V, U,
	T, TE, TCP, P, PP, DT, AA, BB, CP, C1, SL, CL,
	L1, M1, D, E, OM, OM1, OM2, BV, SA : DOUBLE ;

 BEGIN

	CP  := 206264.806247;

	PI2 := 3.14159265359 * 2.0;
	GR  := PI2 / 360.0 ;

	T  := ( JD - 2415020.0  ) / 36525.0 ;
	T2 := T * T ;
	TB := T     ;


{
	fundamentalxnye argumenty
	*************************
}

	L1 := 270.4342  + 481267.8831  * T -0.0011  * T2 ;
	M  := 358.4758  +  35999.0498  * T -0.0002  * T2 ;
	M1 := 296.1046  + 477198.8491  * T +0.0092  * T2 ;
	D  := 350.7375  + 445267.1142  * T -0.0014  * T2 ;
	F  :=  11.2509  + 483202.0251  * T -0.0032  * T2 ;

	L1 := L1 - Trunc ( L1 / 360.0 ) * 360.0;
	M  := M  - Trunc ( M  / 360.0 ) * 360.0;
	M1 := M1 - Trunc ( M1 / 360.0 ) * 360.0;
	D  := D  - Trunc ( D  / 360.0 ) * 360.0;
	F  := F  - Trunc ( F  / 360.0 ) * 360.0;

	OM := 259.1833  -   1934.1420  * T +0.0021  * T2 ;
	SA := ABS ( OM );
	IF ( SA > 360.0 ) THEN
	  BEGIN
	    BV := OM / SA ;
	    OM := ( SA - Trunc ( SA / 360.0 ) * 360.0 ) * BV;
	  END;

{
	additiwnye ~leny
	----------------
}

	SA := SIN ( (51.2 + 20.2 * T ) * GR );

	M  := M  -0.0018 * SA;
	M1 := M1 +0.0008 * SA;
	D  := D  +0.0020 * SA;

	BV := 0.0040 * SIN ( ( 346.560 + 132.870 * T ) * GR );

	L1 := L1 + BV;
	M1 := M1 + BV;
	D  := D  + BV;
	F  := F  + BV;	

	SA := SIN ( OM * GR );

	L1 := L1 + 0.0020 * SA;
	M1 := M1 + 0.0025 * SA;
	D  := D  + 0.0020 * SA;
	F  := F  - 0.0247 * SA;

	F  := F  - 0.0043 * SIN ( ( OM + 275.05 - 2.3 * T ) * GR );

	E  := 1.0 - 0.002495 * T - 0.0000075 * T * T;


	L := L1;

	L1 := L1 * GR;
	M  := M  * GR;
	M1 := M1 * GR;
	D  := D  * GR;
	F  := F  * GR;
	OM := OM * GR;


{
	dolgota, {irota i parallaks luny ( widimye na datu )
	****************************************************
}

	L := L +  6.2888 * SIN ( M1 );
	L := L +  1.2740 * SIN ( 2.0 * D - M1 );
	L := L +  0.6583 * SIN ( 2.0 * D );
	L := L +  0.2136 * SIN ( 2.0 * M1 );
	L := L -  0.1856 * SIN ( M ) * E;
	L := L -  0.1143 * SIN ( 2.0 * F );
	L := L +  0.0588 * SIN ( 2.0 * ( D - M1 ) );
	L := L +  0.0572 * SIN ( 2.0 * D - M - M1 ) * E;
	L := L +  0.0533 * SIN ( 2.0 * D + M1 );
	L := L +  0.0459 * SIN ( 2.0 * D - M ) * E;
	L := L +  0.0410 * SIN ( M1 - M ) * E;
	L := L -  0.0347 * SIN ( D );
	L := L -  0.0305 * SIN ( M + M1 ) * E;
	L := L +  0.0153 * SIN ( 2.0 * ( D - F ) );
	L := L -  0.0125 * SIN ( 2.0 * F + M1 );
	L := L -  0.0110 * SIN ( 2.0 * F - M1 );
	L := L +  0.0107 * SIN ( 4.0 * D - M1 );
	L := L +  0.0100 * SIN ( 3.0 * M1 );
	L := L +  0.0085 * SIN ( 4.0 * D - 2.0 * M1 );
	L := L -  0.0079 * SIN ( M - M1 + 2.0 * D );
	L := L -  0.0068 * SIN ( 2.0 * D + M );
	L := L +  0.0052 * SIN ( M1 - D );
	L := L +  0.0050 * SIN ( M + D );
	L := L +  0.0040 * SIN ( M1 - M + 2.0 * D );
	L := L +  0.0040 * SIN ( 2.0 * ( M1 + D ) );
	L := L +  0.0039 * SIN ( 4.0 * D );
	L := L +  0.0037 * SIN ( 2.0 * D - 3.0 * M1 );
	L := L +  0.0027 * SIN ( 2.0 * M1 - M );
	L := L +  0.0026 * SIN ( M1 - 2.0 * F - 2.0 * D );
	L := L +  0.0024 * SIN ( 2.0 * D - M - 2.0 * M1 );
	L := L -  0.0023 * SIN ( M1 + D );
	L := L +  0.0022 * SIN ( 2.0 * D - 2.0 * M );
	L := L -  0.0021 * SIN ( 2.0 * M1 + M );
	L := L -  0.0021 * SIN ( 2.0 * M );
	L := L +  0.0021 * SIN ( 2.0 * D - M1 - 2.0 * M );
	L := L -  0.0018 * SIN ( M1 + 2.0 * D - 2.0 * F );
	L := L -  0.0016 * SIN ( 2.0 * F + 2.0 * D );
	L := L +  0.0012 * SIN ( 4.0 * D - M - M1 );
	L := L -  0.0011 * SIN ( 2.0 * M1 + 2.0 * F );
	L := L +  0.0009 * SIN ( M1 - 3.0 * D );
	L := L -  0.0008 * SIN ( M + M1 + 2.0 * D );
	L := L +  0.0008 * SIN ( 4.0 * D - M - 2.0 * M1 );
	L := L +  0.0007 * SIN ( M1 - 2.0 * M );
	L := L +  0.0007 * SIN ( M1 - 2.0 * M - 2.0 * D );
	L := L +  0.0007 * SIN ( M  - 2.0 * M1 + 2.0 * D );
	L := L +  0.0006 * SIN ( 2.0 * D - M - 2.0 * F );
	L := L +  0.0006 * SIN ( M1 + 4.0 * D );
	L := L +  0.0005 * SIN ( 4.0 * M1 );
	L := L +  0.0005 * SIN ( 4.0 * D - M );
	L := L +  0.0005 * SIN ( 2.0 * M1 - D );


	B :=  0.0;

	B := B +  5.128 * SIN ( F );
	B := B +  0.281 * SIN ( M1 + F );
	B := B +  0.278 * SIN ( M1 - F );
	B := B +  0.173 * SIN ( 2.0 * D - F );
	B := B +  0.055 * SIN ( 2.0 * D + F - M1 );
	B := B +  0.046 * SIN ( 2.0 * D - F - M1 );
	B := B +  0.033 * SIN ( 2.0 * D + F );
	B := B +  0.017 * SIN ( 2.0 * M1 + F );
	B := B +  0.009 * SIN ( 2.0 * D + M1 - F );
	B := B +  0.009 * SIN ( 2.0 * M1 - F );
	B := B +  0.008 * SIN ( 2.0 * D - M - F );
	B := B +  0.004 * SIN ( 2.0 * D - F - 2.0 * M1 );
	B := B +  0.004 * SIN ( 2.0 * D + F + M1 );
	B := B +  0.003 * SIN ( F - M - 2.0 * D );
	B := B +  0.002 * SIN ( 2.0 * D + F - M - M1 );
	B := B +  0.002 * SIN ( 2.0 * D + F - M );
	B := B +  0.002 * SIN ( 2.0 * D - F - M - M1 );
	B := B +  0.002 * SIN ( F - M + M1 );
	B := B +  0.002 * SIN ( 4.0 * D - F - M1 );
	B := B -  0.002 * SIN ( F + M );
	B := B -  0.002 * SIN ( 3.0 * F );
	B := B +  0.002 * SIN ( M1 - M - F );
	B := B -  0.001 * SIN ( F + D );
	B := B -  0.001 * SIN ( F + M + M1 );
	B := B +  0.001 * SIN ( F - M - M1 );
	B := B +  0.001 * SIN ( F - M );
	B := B +  0.001 * SIN ( F - D );
	B := B +  0.001 * SIN ( F + 3.0 * M1 );
	B := B +  0.001 * SIN ( 4.0 * D - F );
	B := B +  0.001 * SIN ( F + 4.0 * D - M1 );
	B := B +  0.001 * SIN ( M1 - 3.0 * F );
	B := B +  0.001 * SIN ( F + 4.0 * D - 2.0 * M1 );
	B := B +  0.001 * SIN ( 2.0 * D - 3.0 * F );
	B := B +  0.001 * SIN ( 2.0 * D + 2.0 * M1 - F );

	OM1 := 0.0004664 * COS ( OM );
	OM2 := 0.0000754 * COS ( OM + 275.05 - 2.30 * T );

	B := B * ( 1.0 - OM1 - OM2 );



	PAR := 0.950724;

	PAR := PAR + 0.051818 * COS ( M1 );
	PAR := PAR + 0.009531 * COS ( 2.0 * D - M1 );
	PAR := PAR + 0.007843 * COS ( 2.0 * D );
	PAR := PAR + 0.002824 * COS ( 2.0 * M1 );
	PAR := PAR + 0.000857 * COS ( 2.0 * D + M1 );
	PAR := PAR + 0.000533 * COS ( 2.0 * D - M );
	PAR := PAR + 0.000401 * COS ( 2.0 * D - M - M1 );
	PAR := PAR + 0.000320 * COS ( M1 - M );
	PAR := PAR - 0.000271 * COS ( D );
	PAR := PAR - 0.000264 * COS ( M + M1 );
	PAR := PAR - 0.000198 * COS ( 2.0 * F - M1 );
	PAR := PAR + 0.000173 * COS ( 3.0 * M1 );
	PAR := PAR + 0.000167 * COS ( 4.0 * D - M1 );
	PAR := PAR - 0.000111 * COS ( M );
	PAR := PAR + 0.000103 * COS ( 4.0 * D - 2.0 * M1 );
	PAR := PAR - 0.000084 * COS ( 2.0 * M1 - 2.0 * D );
	PAR := PAR - 0.000083 * COS ( 2.0 * D + M );
	PAR := PAR + 0.000079 * COS ( 2.0 * D + 2.0 * M1 );
	PAR := PAR + 0.000072 * COS ( 4.0 * D );
	PAR := PAR + 0.000064 * COS ( 2.0 * D - M + M1 );
	PAR := PAR - 0.000063 * COS ( 2.0 * D + M - M1 );
	PAR := PAR + 0.000041 * COS ( M + D );
	PAR := PAR + 0.000035 * COS ( 2.0 * M1 - M );
	PAR := PAR - 0.000033 * COS ( 3.0 * M1 - 2.0 * D );
	PAR := PAR - 0.000030 * COS ( M1 + D );
	PAR := PAR - 0.000029 * COS ( 2.0 * F - 2.0 * D );
	PAR := PAR - 0.000029 * COS ( 2.0 * M1 + M );
	PAR := PAR + 0.000026 * COS ( 2.0 * D - 2.0 * M );
	PAR := PAR - 0.000023 * COS ( 2.0 * F - 2.0 * D + M1 );
	PAR := PAR + 0.000019 * COS ( 4.0 * D - M - M1 );


	L   := L   * GR;
	B   := B   * GR;
	PAR := PAR * GR;


	R := 6378.14 / SIN ( PAR ) / 149.59787E+6 ;


	SB := SIN ( B );
	CB := COS ( B );

{
	perewod TB -> TE
	----------------
}

	TE  := ( JDREZ - 2415020.0 ) / 36525.0;

	TCP := ( TB + TE ) / 2.0;
	P   := ( 5025.6 + 2.2 * TCP ) / CP;
	PP  :=   3.036015 +  0.0159358 * TCP;

	DT := TB - TE;
	AA := P * DT;
	BB := 47.1 / CP * DT;
	C1 := L + PI2 / 2.0 -  0.5 * AA - PP;

	L := L - AA + BB * COS ( C1 ) * SB/CB;
	B := B -      BB * SIN ( C1 );


	SB := SIN ( B );
	CB := COS ( B );
	TB := SB / CB  ;
	L  := L - Trunc ( L / PI2 ) * PI2 ;

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

