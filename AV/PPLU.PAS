
{$O+,F+}


Unit PPLU ;
    {****}

Interface
   Procedure PLU ( JD, JDREZ : DOUBLE; Var L, B, RV : DOUBLE;
                                     VAR X, Y, Z  : DOUBLE );
Implementation



   Procedure PLU ( JD, JDREZ : DOUBLE; Var L, B, RV, X, Y, Z : DOUBLE );


{       COMPUTATION OF PLUTONS HELIOCENTRIC COORDINATES
	***********************************************

                      ERRORS <= 30'
                      ************


	JD    - TIME MOMENT
        JDREZ - TIME OF REZULTS COORDINATES SISTEM
	X,Y,Z - EQUATORIAL COORDINATES
        L, B  - ECLIPTICALS COORDINATES
        RV    - HELIOCENTRIC DISTANCE IN A.U.



}


  VAR

      C9,S9    : ARRAY [ 0..6] OF DOUBLE;
      C,S      : ARRAY [-3..2] OF DOUBLE;
      M5,M6,M9 : DOUBLE;
      DL,DR,DB : DOUBLE;
      I        : INTEGER;

      T,  TB, TE, TCP, DT       : DOUBLE ;
      GR, PI2, Cp               : DOUBLE ;
      EPS, SEPS, CEPS           : DOUBLE ;
      P, PP, AA, BB, C1         : DOUBLE ;
      SB, CB, SL, CL            : DOUBLE ;


  FUNCTION FRAC(X:DOUBLE):DOUBLE;
    BEGIN
      X:=X-TRUNC(X);
      IF (X<0) THEN X:=X+1.0;
      FRAC:=X ;
    END;

  PROCEDURE ADDTHE(C1,S1,C2,S2:DOUBLE; VAR C,S:DOUBLE);
    BEGIN
      C:=C1*C2-S1*S2;
      S:=S1*C2+C1*S2;
    END;

  PROCEDURE TERM(I9,I:INTEGER;DLC,DLS,DRC,DRS,DBC,DBS:DOUBLE);
    VAR U,V: DOUBLE;
    BEGIN
      ADDTHE(C9[I9],S9[I9],C[I],S[I],U,V);
      DL  :=  DL  +  DLC * U  +  DLS * V  ;
      DR  :=  DR  +  DRC * U  +  DRS * V  ;
      DB  :=  DB  +  DBC * U  +  DBS * V  ;
    END;

  PROCEDURE PERTJUP;  (* Keplerterme und Stoerungen durch Jupiter *)
    VAR I: INTEGER;
    BEGIN
      C[0]:=1.0;
      S[0]:=0.0;

      C[1]:=COS(M5);
      S[1]:=SIN(M5);

      FOR I:=0 DOWNTO -1 DO ADDTHE ( C[I], S[I], C[1], -S[1], C[I-1], S[I-1] );

      ADDTHE ( C[1], S[1], C[1], S[1], C[2], S[2] ) ;

      TERM(1, 0,   0.06,100924.08,-960396.0,15965.1,51987.68,-24288.76);
      TERM(2, 0,3274.74, 17835.12,-118252.2, 3632.4,12687.49, -6049.72);
      TERM(3, 0,1543.52,  4631.99, -21446.6, 1167.0, 3504.00, -1853.10);
      TERM(4, 0, 688.99,  1227.08,  -4823.4,  213.5, 1048.19,  -648.26);
      TERM(5, 0, 242.27,   415.93,  -1075.4,  140.6,  302.33,  -209.76);
      TERM(6, 0, 138.41,   110.91,   -308.8,  -55.3,  109.52,   -93.82);
      TERM(3,-1,  -0.99,     5.06,    -25.6,   19.8,    1.26,    -1.96);
      TERM(2,-1,   7.15,     5.61,    -96.7,   57.2,    1.64,    -2.16);
      TERM(1,-1,  10.79,    23.13,   -390.4,  236.4,   -0.33,     0.86);
      TERM(0, 1,  -0.23,     4.43,    102.8,   63.2,    3.15,     0.34);
      TERM(1, 1,  -1.10,    -0.92,     11.8,   -2.3,    0.43,     0.14);
      TERM(2, 1,   0.62,     0.84,      2.3,    0.7,    0.05,    -0.04);
      TERM(3, 1,  -0.38,    -0.45,      1.2,   -0.8,    0.04,     0.05);
      TERM(4, 1,   0.17,     0.25,      0.0,    0.2,   -0.01,    -0.01);
      TERM(3,-2,   0.06,     0.07,     -0.6,    0.3,    0.03,    -0.03);
      TERM(2,-2,   0.13,     0.20,     -2.2,    1.5,    0.03,    -0.07);
      TERM(1,-2,   0.32,     0.49,     -9.4,    5.7,   -0.01,     0.03);
      TERM(0,-2,  -0.04,    -0.07,      2.6,   -1.5,    0.07,    -0.02);

    END;

  PROCEDURE PERTSAT;  (* Stoerungen durch Saturn *)
    VAR I: INTEGER;
    BEGIN
      C[1]:=COS(M6);
      S[1]:=SIN(M6);

      FOR I:=0 DOWNTO -1 DO ADDTHE ( C[I], S[I], C[1], -S[1], C[I-1], S[I-1] );

      TERM(1,-1, -29.47,    75.97,   -106.4, -204.9,  -40.71,   -17.55);
      TERM(0, 1, -13.88,    18.20,     42.6,  -46.1,    1.13,     0.43);
      TERM(1, 1,   5.81,   -23.48,     15.0,   -6.8,   -7.48,     3.07);
      TERM(2, 1, -10.27,    14.16,     -7.9,    0.4,    2.43,    -0.09);
      TERM(3, 1,   6.86,   -10.66,      7.3,   -0.3,   -2.25,     0.69);
      TERM(2,-2,   4.32,     2.00,      0.0,   -2.2,   -0.24,     0.12);
      TERM(1,-2,  -5.04,    -0.83,     -9.2,   -3.1,    0.79,    -0.24);
      TERM(0,-2,   4.25,     2.48,     -5.9,   -3.3,    0.58,     0.02);
    END;


  PROCEDURE PERTJUS;  (* Stoerungen durch Jupiter und Saturn *)
    VAR PHI,X,Y: DOUBLE;

    BEGIN

      PHI:=(M5-M6);

      X:=COS(PHI);
      Y:=SIN(PHI);

      DL:=DL-9.11*X+0.12*Y;
      DR:=DR-3.4*X-3.3*Y;
      DB:=DB+0.81*X+0.78*Y;

      ADDTHE(X,Y,C9[1],S9[1],X,Y);

      DL:=DL+5.92*X+0.25*Y;
      DR:=DR+2.3*X-3.8*Y;
      DB:=DB-0.67*X-0.51*Y;

    END;


  BEGIN  { PPLU }
         { **** }

    PI2 := Pi * 2.0       ;
    CP  := 206264.806247  ;

    T  := ( JD - 2451545.0 ) / 36525.0 ;

    DL := 0.0 ;
    DR := 0.0 ;
    DB := 0.0 ;

    M5 := Pi2 * FRAC ( 0.0565314 + 8.4302963 * T ) ;
    M6 := Pi2 * FRAC ( 0.8829867 + 3.3947688 * T ) ;
    M9 := Pi2 * FRAC ( 0.0385795 + 0.4026667 * T ) ;

    C9[0] := 1.0 ;
    S9[0] := 0.0 ;

    C9[1] := COS ( M9 ) ;
    S9[1] := SIN ( M9 ) ;

    FOR I:=2 TO 6 DO ADDTHE(C9[I-1],S9[I-1],C9[1],S9[1],C9[I],S9[I]);

    PERTJUP ;
    PERTSAT ;
    PERTJUS ;

    GR   := PI / 180.0 ;

    L  := 360.0 * FRAC ( 0.6232469 + M9/Pi2 + DL/1296.0E3 ) * GR ;
    RV :=  40.7247248  +  DR * 1.0E-5 ;
    B  := ( -3.909434  +  DB / 3600.0 ) * GR ;




              {  PREC  =>  JDREZ   }
              {  ***************   }


    SB := SIN ( B ) ;
    CB := COS ( B ) ;



    TB   := 0.5 ;  { PLUTO -> 1950.0 }
    TE   := ( JDREZ - 2415020.0 ) / 36525.0 ;

    TCP := ( TB + TE ) / 2.0;
    P   := ( 5025.6 + 2.2 * TCP ) / CP ;
    PP  :=   3.036015 + 0.0159358 * TCP ;

    DT := TB - TE ;
    AA := P * DT ;
    BB := 47.1 / CP * DT ;
    C1 := L + PI2 / 2.0 - 0.5 * AA - PP ;

    L := L - AA + BB * COS ( C1 ) * SB/CB ;
    B := B -      BB * SIN ( C1 ) ;


    SB := SIN ( B ) ;
    CB := COS ( B ) ;
    TB := SB / CB   ;

    L  := L - TRUNC ( L / PI2 ) * PI2 ;

    SL := SIN ( L ) ;
    CL := COS ( L ) ;


    T    := ( JDREZ - 2415020.0 ) / 36525.0;
    EPS  := ( 23.0 * 3600.0 + 27.0 * 60.0 +  8.260 - 46.845 * T  ) / CP ;
    SEPS := SIN ( EPS ) ;
    CEPS := COS ( EPS ) ;

    X  := RV * CB *   CL ;
    Y  := RV * CB * ( SL * CEPS - TB * SEPS ) ;
    Z  := RV * CB * ( SL * SEPS + TB * CEPS ) ;


END;

End.
