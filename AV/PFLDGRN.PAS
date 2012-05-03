
{$O+,F+}


Unit PFldGrn ;

 InterFace

   Uses  PVAR, PPRENew, PProFld ;

   Procedure FldGrn (     Cat            : Integer ;
                          DtMu           : Double  ;
                      Var NumRa, NumDec  : LongInt ;
                      Var DecMin, DecMax,
                          RaMin1, RaMax1,
                          RaMin2, RaMax2
                                         : Double    ) ;

 Implementation

   Procedure FldGrn (     Cat            : Integer ;
                          DtMu           : Double  ;
                      Var NumRa, NumDec  : LongInt ;
                      Var DecMin, DecMax,
                          RaMin1, RaMax1,
                          RaMin2, RaMax2
                                         : Double    ) ;


   Var

     N1, N2         : LongInt ;

     DDeclPm,
     SDD,
     DRA,
     ADECC          : Double  ;


   Begin


          { ®§¨æ¨®­­ë© ã£®« ‘¥¢¥p­®£® ®«îá  }
          { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }


        Povorot ( JdCat [ Cat ], SPozNp1, CPozNp1 ) ;

        IndCat [ Cat ].JdCat   := JdCat [ Cat ] ;

        IndCat [ Cat ].SPozNp1 := SPozNp1  ;
        IndCat [ Cat ].CPozNp1 := CPozNp1  ;


        RaOptFld   := RaOpt   ;
        DeclOptFld := DeclOpt ;

        PRENew ( JDateFld, JdCat [ Cat ], RaOptFld, DeclOptFld );
       {ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

        SDeclOptFld := Sin ( DeclOptFld ) ;
        CDeclOptFld := Cos ( DeclOptFld ) ;

        SRaOptFld   := Sin ( RaOptFld   ) ;
        CRaOptFld   := Cos ( RaOptFld   ) ;

        IndCat [ Cat ].SRaOpt    := SRaOptFld   ;
        IndCat [ Cat ].CRaOpt    := CRaOptFld   ;
        IndCat [ Cat ].SDeclOpt  := SDeclOptFld ;
        IndCat [ Cat ].CDeclOpt  := CDeclOptFld ;



        { Ž…„…‹…ˆ… ƒ€ˆ– Ž‹€‘’ˆ ‚ Š€’€‹Žƒ… }
        { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

            NUMRA  := 1 ;
            ADecC  := ABS ( DeclOptFld ) ;

            DecMIN := DeclOptFld - ROMAX ;
            DecMAX := DeclOptFld + ROMAX ;

            If ( B_Import_Fld )
              Then  DDeclPM := C100 / SekRad * Abs ( DtMu )
              Else  DDeclPm :=  0.0 ;

            DecMin  := DecMin - DDeclPm ;
            DecMax  := DecMax + DDeclPm ;


	    If ( ADecC  >  DecCKR )  Then
              Begin  {  POL  }
                     {  ÄÄÄ  }

                  SDD := CROMAX * ABS ( SDeclOptFld ) ;
                  SDD := SDD - SROMAX * CDeclOptFld * YMAX / XMAX ;

	          DecMIN := ARCTAN ( SDD / Sqrt ( C10 - SDD * SDD ) ) ;
	          DecMAX := ABS ( DeclOptFld ) + ROMAX ;

                  DecMin  := DecMin - DDeclPm ;
                  DecMax  := DecMax + DDeclPm ;

                  If ( DeclOptFld < 0.0 )  Then
                     Begin

                      DecMAX := - DecMIN ;
                      DecMIN := - R90    ;

                     End

                   Else

                     DecMAX := R90 ;


 	          RAMIN1 := 0.0;
	          RAMAX1 := R359;

              End  { ABS ( DeclOptFld ) > DecCKR }

            Else

              Begin  { NO POLE }
                     { ÄÄÄÄÄÄÄ }

                DRA := SROMAX / CDeclOptFld;
	        DRA := ARCTAN ( DRA / Sqrt ( C10 - DRA * DRA ) );
                DRa := DRa + DDeclPm ;

	        RAMIN1 := RaOptFld - DRA;
	        RAMAX1 := RaOptFld + DRA;


	        If ( RAMIN1 <  0.0 )  Then
                  RAMIN1 := RAMIN1 + R360;
	        If ( RAMAX1 > R360 )  Then
                  RAMAX1 := RAMAX1 - R360;

	        If ( RAMIN1 > RAMAX1 )  Then
                  Begin  { RAMIN1 > RAMAX1 }

	            RAMIN2 := RAMIN1;
	            RAMIN1 := 0.0;
	            RAMAX2 := R359;
	            NUMRA  := 2;

                  End ;  { RAMIN1 > RAMAX1 }

              End ;  { ABS ( DeclOptFld )  <=  DecCKR }




	    N1 := TRUNC ( ( DecMIN * RG + 90.0 ) / STEPGR ) - 1;
	    N2 := TRUNC ( ( DecMAX * RG + 90.0 ) / STEPGR ) - 1;

	    NUMDec := N2 - N1 + 1;


        { ŠŽ…–  Ž…„…‹…ˆŸ  ƒ€ˆ–  Ž‹€‘’ˆ  ‚  Š€’€‹Žƒ… }
        { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }



   End ;

End.



