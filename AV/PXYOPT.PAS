
{$O+,F+}



UNIT PXYOPT ;   { X , Y  Ž’ˆ—…‘ŠŽ‰ Ž‘ˆ }
                { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }


  INTERFACE

    USES PVAR ;


    PROCEDURE XYOPT ;



  IMPLEMENTATION


    PROCEDURE XYOPT;
   {===============}

   Var

    SH, CH, SA, CA,
    ST, CT, SDA, CDA, SPOZ, CPOZ, TGRO,
    SAOPT, CAOPT, SHOPT, CHOPT : Double ;



     BEGIN  { PRO XYOPT }


            ST := SSTIME * CRAOPTOLD  -  CSTIME * SRAOPTOLD ;
            CT := CSTIME * CRAOPTOLD  +  SSTIME * SRAOPTOLD ;

            SH := SDECLOPTOLD * SFISGEOC + CDECLOPTOLD * CFISGEOC * CT ;

            SA :=   CDECLOPTOLD * ST ;
            CA := - SDECLOPTOLD * CFISGEOC + CDECLOPTOLD * SFISGEOC * CT ;

            CDA :=  CA   * CAOPT  +  SA   * SAOPT  ;
	    CRO := SHOPT *  SH    + CHOPT *  CDA   ;

            ROPT := 0.0 ;

            IF  ( CRO >= CROMAX )  THEN
               BEGIN  { CRO >= CROMAX }
                      { ------------- }

	          SDA   := SAOPT * CA  -  CAOPT  * SA ;

		  SPOZ  := SDA;
		  CPOZ  := SH * CHOPT  -  SHOPT * CDA ;

	          YOPT  :=   FD * CPOZ / CRO ;
		  XOPT  := - FD * SPOZ / CRO ;


                  IF ( NPOLFIX )  THEN
                    BEGIN
                      ROPT :=   XOPT ;
                      XOPT :=   XOPT * CPOZNP + YOPT * SPOZNP ;
                      YOPT := - ROPT * SPOZNP + YOPT * CPOZNP ;
                    END ;

                  ROPT  := SQRT  (  XOPT * XOPT  +  YOPT * YOPT  ) ;

               END ;  { CRO >= CROMAX }


     END ;  { PRO PLFLD }


END.

