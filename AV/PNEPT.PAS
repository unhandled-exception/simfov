
{$O+,F+}


Unit PNEPT;
Interface
   Procedure NEPT ( JD, JDREZ : DOUBLE; Var L, B, R, X, Y, Z : DOUBLE );
Implementation



   Procedure NEPT ( JD, JDREZ : DOUBLE; Var L, B, R, X, Y, Z : DOUBLE );

{       COMPUTATION OF NEPTUN  HELIOCENTRIC COORDINATES
	***********************************************

	JD    - TIME MOMENT
	JDREZ - RESULTING COORDINTES SYSTEM
	L, B  - ECLIPTICAL COORDINATES
	X,Y,Z - EQUATORIAL COORDINATES

}
 VAR

	IK : INTEGER;

	I, M,
	CP, PI2, GR, T, T2, RR,
	U, V, P, Q, S, G, H, A, E, OM, OB, DZI, ET, TET, HR, AB,
	DE, DA, EAN, CEAN, SG, CG, EPS, SEPS, CEPS, TV, TL,
	TE, TCP, PP, DT, AA, BB, C1, SB, CB, TB, SL, CL, SV, CV : DOUBLE;

 BEGIN

	CP  := 206264.806247;
	PI2 := 3.14159265359 * 2.0;
	GR  := PI2 / 360.0;


	T := ( JD - 2415020.0 ) / 36525.0;

	V := T / 5.0 + 0.1;
	P :=  273.47555 + 3034.906  * T;
	Q :=  265.91650 + 1222.114  * T;
	S :=  243.51721 +  428.4617 * T;
	G :=   83.76922 +  218.4901 * T;
	H :=    2.0 * G - S;

	M  :=  37.73063    + 218.4613     * T;
	L  :=  84.45799    + 219.8859     * T + 0.0003   * T * T;
	A  :=  30.10957;
	E  :=   0.00899704 +   0.00000633 * T;
	I  :=   1.779242   -   0.009544   * T;
	OM := 276.0460     +   0.325639   * T + 0.000141 * T * T;
   	OB := 130.6814     +   1.098935   * T + 0.000250 * T * T;


	DZI := G - P;
	ET  := G - Q;
	TET := G - S;

	HR  := H * GR;

	AB  := ( -0.589833 + 0.001089 * V ) * SIN (       HR );
        AB  := AB +
     	       ( -0.056094 + 0.004658 * V ) * COS (       HR );
        AB  := AB -
     	 	  0.024286                  * SIN ( 2.0 * HR )   ;

	BB :=  0.024039 * SIN (       HR ) - 0.025303 * COS (       HR );
        BB :=  BB +
     	       0.006206 * SIN ( 2.0 * HR ) - 0.005992 * COS ( 2.0 * HR ) ;

{
	srednie dolgota i anomaliq
	--------------------------
}
	L := L + AB;
	M := M + AB - BB / E;

{
	|kscentrisitet
	--------------
}

	DE :=  4389.0 * SIN (       HR ) + 4262.0 * COS (       HR ) ;
        DE := DE +
     	       1129.0 * SIN ( 2.0 * HR ) + 1089.0 * COS ( 2.0 * HR )  ;

	E := E + DE / 10000000.0 ;

{
	bolx{aq poluosx
	---------------
}

	DA :=    -  817.0 * SIN (       HR ) ;
     	DA := DA + 8189.0 * COS (       HR ) ;
     	DA := DA +  781.0 * COS ( 2.0 * HR ) ;

	A := A + DA / 1000000.0 ;

{
	|kscentri~eskaq anomaliq: EAN
	-----------------------------
}

	EAN := M ;

	FOR IK := 1 TO 5 DO
	    EAN := M + E / GR * SIN ( EAN * GR );

{
	s~et dolgoty, {iroty i rad.-w.
	-----------------------------
}

	CEAN := COS ( EAN * GR );

	SV := A * SQRT ( 1.0 - E * E ) * SIN ( EAN * GR );
	CV := A * ( CEAN - E );

        TV := ABS ( SV / CV ) ;
	V  := ARCTAN ( TV )   ;
	V  := V  / GR;

        IF ( SV > 0.0 )  THEN
          BEGIN
            IF ( CV < 0.0 )  THEN  V := 180.0 - V
          END
        ELSE
          BEGIN
            IF ( CV < 0.0 )  THEN
                V := V + 180.0
              ELSE
                V := 360.0 - V
          END;

	R := A * ( 1.0 - E * CEAN );

	U := L + V - M - OB;

{
	priwedenie k |kliptike
	**********************


	geliocentri~eskaq dolgota
	-------------------------
}

	SL := COS ( I * GR ) * SIN ( U * GR );
	CL := COS ( U * GR );
        TL := ABS ( SL / CL );
        L  := ARCTAN ( TL ) / GR ;

        IF ( SL > 0.0 )  THEN
          BEGIN
            IF ( CL < 0.0 )  THEN  L := 180.0 - L
          END
        ELSE
          BEGIN
            IF ( CL < 0.0 )  THEN
                L := L + 180.0
              ELSE
                L := 360.0 - L
          END;

	L := OB + L ;

{
	geliocentri~eskaq {irota
	------------------------
}

	SB := SIN ( I * GR )  *  SIN ( U * GR );
	CB := SQRT ( 1.0 - SB * SB );
	B  := ARCTAN ( SB / CB ) / GR;

{
	okon~atelxnye zna~eniq koordtnat
	--------------------------------
}

	SG := SIN ( G * GR );
	CG := COS ( G * GR );

	L  := L - 0.009556 * SIN (       DZI * GR )     ;
        L  := L -
     		  0.005178 * SIN (        ET * GR )     ;
        L  := L +
     		  0.002572 * SIN ( 2.0 * TET * GR )     ;
        L  := L -
     		  0.002979 * COS ( 2.0 * TET * GR ) * SG;
        L  := L -
     		  0.002833 * SIN ( 2.0 * TET * GR ) * CG;



	B  := B + 0.000336 * COS ( 2.0 * TET * GR ) * SG +
     		  0.000364 * SIN ( 2.0 * TET * GR ) * CG   ;


     	RR  := 	       4992.0 * COS (       DZI * GR ) +
     		       2744.0 * COS (       ET  * GR );

        RR  := RR +    2044.0 * COS (       TET * GR ) +
     		       1051.0 * COS ( 2.0 * TET * GR ) ;

	R  := R + ( - 40596.0 + RR ) / 1000000.0 ;

	L := L * GR;
	B := B * GR;


{
	perewod TB -> TE
	----------------
}
	TB  := 	T;
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
