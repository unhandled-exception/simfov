
{$O+,F+}

Unit PSatElCh ;

InterFace


 Uses   PVar, Check, Dos ;


 Type

        FEf = Double ;

        AD3      = Array [ 1 ..  3            ]  Of  FEf ;
        AD6      = Array [ 1 ..  6            ]  Of  FEf ;
        AD13     = Array [ 1 .. 13            ]  Of  FEf ;
        AD6_13   = Array [ 1 ..  6 , 1 .. 13  ]  Of  FEf ;



     Procedure SatElCheb  ( Jd : Double;
                            Var A0, EKSC, ISAT, OMG, OML, M0 : Double ) ;

     Procedure CLCH ( M : Integer;
                      TN, TK : Double ;
                      Var  AL : AD6_13; Var  T : Double ; Var  DL : AD6 ) ;

     Procedure  CLAP ( M : Integer;  X: Double ; Var P : AD13 ) ;


Implementation


     Procedure SatElCheb  ( Jd : Double;
    {ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }  Var A0, EKSC, ISAT, OMG, OML, M0 : Double ) ;


 Var

	DDLL,
        DDU           : AD6     ;
        APU           : AD6_13  ;
        POLC          : AD13    ;

        Exist         : Boolean ;
        NRec, NRecInp : Longint ;

        I, J          : Integer ;
        MPol, NPol    : Integer ;

        TSN, TSK      : Double  ;
        DJTSN, DJStep : Double  ;

        EfRec         : FEf     ;

        Stp           : Text        ;
        Efemst        : Text        ;

        Efems         : File Of FEf ;


   Begin


        FileMode := 0 ;

        Assign    ( Stp , 'Efems.Stp' ) ;
        Reset     ( Stp               ) ;

        Read ( Stp,  MPol  ) ;
        Read ( Stp,  NPol  ) ;
        Read ( Stp, DJTSN  ) ;
        Read ( Stp, DJStep ) ;

        Close     ( Stp ) ;

        FileMode := 2 ;


	DjTsN := DjTsN + 2400000.5 ;    { “ — §®¢  MJd }
        				{ ÄÄÄÄÄÄÄÄÄÄÄÄ }
        If  ( Jd >= DJTSN )   Then
          Begin  { Jd ¡®«ìè¥ ­ ç «  ¯®«¨­®¬®¢ }
                 { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

            Exist:= ( FSearch ( 'Efems.Bin','')<> '');

            If ( Not Exist )  Then
              Begin

                Assign    ( Efemst , 'Efems.Dat' ) ;
                Reset     ( Efemst               ) ;

                FileMode := 2 ;
                Assign    ( Efems  , 'Efems.Bin' ) ;
                Rewrite   ( Efems                ) ;
                FileMode := 0 ;

                While Not Eof ( Efemst )  Do
                  Begin
                    Readln  ( Efemst, EfRec ) ;
                    Write   ( Efems , EfRec ) ;
                  End ;

                Close ( Efemst ) ;
                Close ( Efems  ) ;

              End ;

            Assign    ( Efems , 'Efems.Bin' ) ;
            Reset     ( Efems               ) ;

            NRecInp   := FileSize ( Efems ) ;

            NRec := Trunc ( ( Jd - DJTSN ) / DJStep ) ;

            TSN := DJTSN + NRec * DJStep ;
            TSK := TSN   + DJStep ;


            NRec := NRec * NPol * 6 ;

            If ( NRec < NRecInp )  Then
              Begin
                Seek ( Efems , NRec ) ;

                For I := 1  To  6  Do
                  For J := 1  To  NPol  Do
                    Read ( Efems , APU [ I , J ] ) ;



	        CLCH ( MPOL, TSN, TSK, APU, Jd, DDU ) ;
               {ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

	        A0   := DDU [ 1 ] ;     { in km     }
	        Eksc := DDU [ 2 ] ;
	        ISAT := DDU [ 3 ] ;     { in radian }

	        OMG  := DDU [ 4 ] ;     { in radian }
	        OML  := DDU [ 5 ] ;     { in radian }
	        M0   := DDU [ 6 ] ;     { in radian }

              End  { Jd ¡®«ìè¥ ­ ç «  ¯®«¨­®¬®¢ }
                   { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }
             Else

              Begin  { Jd ¡®«ìè¥ ª®­æ  ¤ â ¯®«¨­®¬®¢ }
                     { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                A0 := - A0 ;

              End ;  { Jd ¡®«ìè¥ ª®­æ  ¤ â ¯®«¨­®¬®¢ }
                     { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

            Close ( Efems ) ;

          End    { Jd ¢ ¨­â¥p¢ «¥ ¤ â ¯®«¨­®¬®¢ }
                 { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }
         Else

          Begin  { Jd ¬¥­ìè¥ ­ ç «  ¤ â ¯®«¨­®¬®¢ }
                 { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

            A0 := - A0 ;

          End ;  { Jd ¬¥­ìè¥ ­ ç «  ¤ â ¯®«¨­®¬®¢ }
                 { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

   End ;




  Procedure CLCH  (      M  : Integer ;
 {ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}    TN, TK : Double  ;
                    Var  AL : AD6_13  ;
                    Var   T : Double  ;
                    Var  DL : AD6       ) ;

  Var
	P           : AD13    ;
        SX, TM, X   : Double  ;
        I, J        : Integer ;

    Begin

	N := M + 1 ;

	SX := 0.5 * ( TN + TK ) ;
	TM := 0.5 * ( TK - TN ) ;
	X  := ( T - SX ) / TM   ;

	CLAP ( M, X, P ) ;
       {ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}

	For J := 1 To 6 Do
          Begin

            DL [ J ] := 0.0 ;

	    For I := 1 To N  Do
    		DL [ J ] :=  DL [ J ] + AL [ J , I ] * P [ I ] ;

          End ;

    End ;


  Procedure  CLAP ( M : Integer;  X: Double ; Var P : AD13 ) ;
 {ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}

    Var
        I, I1, I2, N : Integer ;

      Begin

	N := M + 1 ;

	P [1] := C10 ;
	P [2] := X   ;

	For I :=  3  To  N  Do
          Begin

            I1 := I-1 ;
	    I2 := I-2 ;

            P[I] := C20  *  X  *  P [ I1 ]  -  P [ I2 ] ;

          End ;

    End ;

End.