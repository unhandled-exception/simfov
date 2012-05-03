
{$O+,F+}


  UNIT PDAYJD ;

   INTERFACE

      Procedure DAYJD (       RJD   : DOUBLE  ;
	                 VAR  IYEAR : LongInt ;
	                 VAR  MON   : LongInt ;
		         VAR  DAY   : DOUBLE       ) ;

   IMPLEMENTATION

      Procedure DAYJD (       RJD   : DOUBLE  ;
	                 VAR  IYEAR : LongInt ;
	                 VAR  MON   : LongInt ;
		         VAR  DAY   : DOUBLE       ) ;

  VAR

	JD, F                             : DOUBLE  ;
	IZ, IAL, IAL4, IA, IB, IC, ID, IE : LONGINT ;

  BEGIN

	JD := RJD + 0.5 ;

	IZ := TRUNC ( JD );
	F  := JD - IZ;


	IF ( IZ < 2299161 )  THEN
	    IA := IZ
	  ELSE
	    BEGIN
		IAL  := TRUNC ( ( IZ - 1867216.25 ) / 36524.25 );
        	IAL4 := TRUNC ( IAL / 4 );
		IA   := IZ + 1 + IAL - IAL4;
	    END;

	IB := IA + 1524;
	IC := TRUNC ( ( IB - 122.1 ) / 365.25 );
	ID := TRUNC ( 365.25 * IC );
	IE := TRUNC ( ( IB - ID ) / 30.6001 );

	DAY := F + IB - ID - TRUNC ( IE * 30.6001 );

	IF ( IE  <=  13 )  THEN
	    MON := IE - 1
	  ELSE
	    MON := IE - 13;

	IF ( MON  >  2 )  THEN
	    IYEAR := IC - 4716
	  ELSE
	    IYEAR := IC - 4715;


  END;

END.