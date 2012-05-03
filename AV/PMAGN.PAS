
{$O+,F+}



Unit PMAGN;
Interface
   Procedure MAGN (     N                        : INTEGER     ;
		        RP, RPE, RE, JD, X, Y, Z : DOUBLE        ;
		    VAR RM                       : DOUBLE      ) ;
Implementation



   Procedure MAGN (     N                        : INTEGER     ;
		        RP, RPE, RE, JD, X, Y, Z : DOUBLE        ;
		    VAR RM                       : DOUBLE      ) ;

{
		wy~islenie  zwezdnyh  weli~in  planet
		*************************************


		w h o d :
		=======

	N     -	nomer planety
	RP    -	geliocentri~eskoe rasstoqnie planety
	RPE   -	rasstoqnie planeta  - teleskop
	RE    -	geliocentri~eskoe rasstoqnie teleskopa
	JD    -	`lianskaq data
	X,Y,Z - prqmougolxnye geocentri~eskie k-ty planety


		w y h o d :
		=========

	RM   -	zwezdnaq weli~ina planety
}


 TYPE AR = ARRAY [ 1 .. 15 ] OF DOUBLE;

 VAR

	P , F , R1, R2, R3, SA, CA, SD, CD, RN 	: DOUBLE ;


 CONST

	RM0 : AR = ( -0.38, -4.41, -3.9, -1.51, -9.40, -8.88, -7.19, -6.87, -C10, 0.23, -26.7, -1.9, -1.5, -2.2, -1.2  );
        CF1 : AR = ( 0.0380, 0.01314,   0.0,  0.01486, 0.0, 0.0, 0.0, 0.0, 0.0, 0.026, 0.0, 0.04, 0.03, 0.03, 0.07 );
	AF1 : AR = ( 0.0,               0.0,      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 );
	CF2 : AR = ( 0.000273,          0.0,      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 );
	AF2 : AR = ( 0.0,               0.0,      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 );
	CF3 : AR = ( 0.000002, 0.0000004351,      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 );
        {
	RM0 : AR = ( 1.16, -4.0 ,-3.9, -1.3, -8.93, -8.68, -6.85, -7.05, -C10, 0.23, -26.7, -1.9, -1.5, -2.2, -1.2  );
	CF1 : AR = ( 0.02838, 0.01322, 0.014, 0.01486, 0.0, 0.0, 0.0, 0.0, 0.0, 0.026, 0.0, 0.04, 0.03, 0.03, 0.07 );
	AF1 : AR = ( -50.0,             0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 );
	CF2 : AR = ( 0.0001023,         0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 );
	AF2 : AR = ( -50.0,             0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 );
	CF3 : AR = ( 0.0, 0.0000004247, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 );
        }
 BEGIN

        IF ( N = 11 ) THEN

          BEGIN

	    RM := RM0 [ N ] + 5.0 * Ln ( RPE ) / 2.30259;

          END

         ELSE

          BEGIN


 	  { wy~islenie fazy }
	  { =============== }


	    P  := ( RPE + RP + RE ) / 2.0;

            IF ( ( P - RE ) <= 0 )  THEN
                R1 := 0.0
              ELSE
	        R1 := ( ( P - RP ) * ( P - RPE ) / ( ( P - RE ) * P ) );

	    F  := 2.0 * ARCTAN ( R1 ) * 206264.806 / 3600.0 ;


          { zawisimostx ot rasstoqnij }
	  { ========================= }


	    RM := RM0 [ N ] + 5.0 * LN ( RP * RPE ) / 2.30259;



	  { zawisimomtx ot fazy }
	  { =================== }


	    RM := RM + CF1 [ N ] * ( F + AF1 [ N ] );
	    RM := RM + CF2 [ N ] * ( F + AF2 [ N ] ) * ( F + AF2 [ N ] );
	    RM := RM + CF3 [ N ] *   F * F * F;

	    IF ( N = 6 )  THEN

	      BEGIN

	      {	|ffekt kolxca saturna }
	      {	===================== }


		R1 := ( JD - 2433282.42 ) / 36524.22;
		RN := 2.241289 + 0.073827 * R1          +
				 0.004086 * R1 * R1     +
				 0.000185 * R1 * R1 * R1  ;

		R2 := 0.116756 - 0.007613 * R1 + 0.000224 * R1 * R1;
		R3 := COS ( RN );

		SD := Z / RPE;
		CD := SQRT ( C10 - SD * SD );
		CA := RPE * CD;
		SA := Y / CA;
		CA := X / CA;

		R3 := - COS ( R2 ) * SD +
		        SIN ( R2 ) * CD *
				     ( SA * R3 - CA * SQRT ( C10 - R3 * R3 ));

		RM := RM - 2.60 * ABS ( R3 ) +
			   1.25 * R3 * R3 + 0.044 * ABS ( F );

	      END;

          END;

 END;

End.
