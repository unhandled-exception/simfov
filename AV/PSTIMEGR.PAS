
{$F+,O+}



 UNIT PSTIMEGR ;
     {*******}



     { êÄëóÖí S Ép®≠¢®Á† ≠† ¨Æ¨•≠‚ JD }
     { ------------------------------ }


 INTERFACE

   PROCEDURE  STIMEGR ( JD  : DOUBLE  ;  VAR  S0   : DOUBLE   ) ;


 IMPLEMENTATION

   PROCEDURE  STIMEGR ( JD  : DOUBLE  ;  VAR  S0   : DOUBLE   ) ;



      CONST

            SEKRAD : DOUBLE =   180.0 * 3600.0 / 3.1415926535897932385 ;
            PI2    : DOUBLE =   3.1415926535897932385 * 2.0 ;


      VAR

        D1, T, EPS,
        OM, L, L1, F, D, DPSI, DEPS,
        CEPST                            : DOUBLE ;



         BEGIN



             {  çìíÄñàü Ç ÑéãÉéíÖ à Ç çÄäãéçÖ  }
             {  -----------------------------  }


	   T    := ( JD - 2415020.0 ) / 36525.0 ;

	   EPS  := ( 84428.26 - 46.845 * T - 0.06 * T * T ) / SEKRAD ;

	   OM   := 4.52364  - T *   33.75715 ;
	   L    := 5.168131 + T * 8328.691   ;
	   L1   := 6.256584 + T *  628.3019  ;
	   F    := 0.19632  + T * 8433.466   ;
	   D    := 6.1215   + T * 7771.377   ;


	   DPSI := (-17.233 -0.017*T) * SIN ( OM )
                    - 1.273           * SIN ( 2.0 * ( OM + F - D ) ) ;

	   DPSI := DPSI + 0.209 * SIN ( 2.0 *  OM    )
                        - 0.204 * SIN ( 2.0 * (OM+F) ) ;

	   DPSI := DPSI + 0.126 * SIN ( L1 ) ;



	   DEPS :=  9.210 * COS ( OM )
                  + 0.552 * COS ( 2.0 * ( OM + F - D ) ) ;

	   DEPS := DEPS - 0.090 * COS ( 2.0 *   OM       )
                        + 0.088 * COS ( 2.0 * ( OM + F ) ) ;

	   DPSI := DPSI / SEKRAD ;
	   DEPS := DEPS / SEKRAD ;



           CEPST := COS ( EPS + DEPS ) ;


           D1 := (JD - 2451545.0)/36525.0 ;

           S0 := ( 67310.54841 + D1 *
                ( 3164400184.812866 + D1 * ( 0.093104 + D1 * -6.2E-6 )))
                 /86400.0 ;

           S0 := S0 - TRUNC ( S0 ) ;
           IF ( S0 < 0 )  THEN S0 := S0 + 1 ;


           S0 := S0 * PI2  +  DPSI * CEPST ;


         END ;


 END.
