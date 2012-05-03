
{$O+,F+}


  UNIT PJD8 ;

  INTERFACE

   Procedure JD8 (     IY : LONGINT ;
                       IM : INTEGER ;
		        D : DOUBLE  ;
		   Var JD : Double    ) ;



  IMPLEMENTATION


   Procedure JD8 (     IY : LONGINT ;
                       IM : INTEGER ;
		        D : DOUBLE  ;
		   Var JD : Double    ) ;


 VAR

	JN, IYY, IMM, IA, IB, IS : LONGINT ;
			   GRDAT : DOUBLE  ;

 BEGIN

	IF ( IM > 2 )  THEN
	  BEGIN
	    IYY := IY;
	    IMM := IM + 1;
	  END
	 ELSE
	  BEGIN
	    IYY := IY - 1;
	    IMM := IM + 13;
	  END;

	IF ( IYY = 0 ) THEN IS := 1
	  ELSE
	    BEGIN
		IS  := TRUNC ( IYY / ABS ( IYY ) ) ;
		IYY := ABS ( IYY );
	    END;

	GRDAT := IYY * 10000.0 + IMM * 100.0 + D;

	IF ( IS > 0 )  THEN
	  BEGIN
	    IB := 0;

	    IF ( GRDAT >= 15821015.0 )  THEN
	      BEGIN
		IA := TRUNC ( IYY / 100 ) * IS;
		IB := 2 - IA + TRUNC ( ABS ( IA ) / 4 ) * IS;
	      END;

	    JD := 1720994.5 + D +
     		 TRUNC ( 365.25   * IYY ) +
     		 TRUNC (  30.6001 * IMM ) + IB;
	  END

	ELSE

	    JD := 1720994.5 + D -
     		 TRUNC ( 365.25   * IYY + 0.75 ) +
     		 TRUNC (  30.6001 * IMM ) ;


  END;


 END.
