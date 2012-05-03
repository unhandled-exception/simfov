

          Program  CompDet ;

Const
    Pi2 : Double = Pi + Pi ;

Var

    DeclSig                  : Char    ;

    N,
    Code,
    NOS1,
    Month                    : Integer ;

    Num, Year, NStar         : LongInt ;

    Ra, Decl, Mv,
    PmRa, PmDecl,
    RaAc, DeclAc, MvAc,
    PmRaAc, PmDeclAc,
    RRN,
    Day, Jd, Epoch,
    DRa, DDecl
                             : Double  ;

    Inp ,
    Out                      : Text ;

    ObjectString,
    ObjectS,
    NameInp,
    NameOut           : String ;

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



Begin

  If ParamCount <> 4 Then
    Begin
      Writeln ( ' DayEpObs,  MonthEpObs,  YearEpObs,  NameFile  ' ) ;
      Halt ( 1 ) ;
    End ;

  ObjectS := ParamStr ( 1 ) ;
  Val (  ObjectS , Day ,  Code  ) ;

  ObjectS := ParamStr ( 2 ) ;
  Val (  ObjectS , Month ,  Code  ) ;

  ObjectS := ParamStr ( 3) ;
  Val (  ObjectS , Year ,  Code  ) ;
  If ( Year < 100 )  Then
    Year := Year + 1900 ;

  Jd8 ( Year, Month, Day, Jd ) ;
  Epoch := ( Jd  - 2451545.0 ) / 365.25 ;

  NameInp := ParamStr ( 4 ) ;
  NameOut := 'ResComp.Dat' ;

  Assign  ( Inp , NameInp ) ;
  Reset   ( Inp ) ;


  Assign  ( Out , NameOut ) ;
    {$I-}
  Reset ( Out ) ;
    {$I+}
  If IOResult = 0
    Then
      Begin
        Close  ( Out ) ;
        Append ( Out ) ;
      End
    Else
      Begin
        ReWrite ( Out ) ;
      End ;


  DRa    := 0 ;
  DDecl  := 0 ;
  NStar  := 0 ;

  While Not Eof ( Inp )  Do
    Begin

      ReadLn ( Inp , ObjectString ) ;


                                { R. A. }
                                { ----- }

                       While (  ObjectString[1] = ' ' )  Do
                                Delete ( ObjectString, 1 , 1 ) ;
                       NOS1 := Pos ( ' ' , ObjectString ) ;

                       ObjectS := Copy ( ObjectString , 1 , NOS1 - 1 ) ;
                       Delete ( ObjectString, 1 , NOS1 - 1 ) ;

                       Val ( ObjectS , N ,  Code  ) ;

                       Ra :=  N * 3600.0 ;


                       While (  ObjectString[1] = ' ' )  Do
                                Delete ( ObjectString, 1 , 1 ) ;
                       NOS1 := Pos ( ' ' , ObjectString ) ;

                       ObjectS := Copy ( ObjectString , 1 , NOS1 - 1 ) ;
                       Delete ( ObjectString, 1 , NOS1 - 1 ) ;

                       Val ( ObjectS , N ,  Code  ) ;

                       Ra :=  Ra + N * 60.0 ;



                       While (  ObjectString[1] = ' ' )  Do
                                Delete ( ObjectString, 1 , 1 ) ;
                       NOS1 := Pos ( ' ' , ObjectString ) ;

                       ObjectS := Copy ( ObjectString , 1 , NOS1 - 1 ) ;
                       Delete ( ObjectString, 1 , NOS1 - 1 ) ;

                       Val ( ObjectS , RRN ,  Code  ) ;

                       Ra :=  ( Ra + RRN ) * 15 / 206264.806247 ;

                       If ( Ra > Pi2 )  Then
                            Ra := Ra - Pi2 ;

                                { Decl }
                                { ---- }

                       DeclSig := ' ' ;

                       While (  ObjectString[1] = ' ' )  Do
                                Delete ( ObjectString, 1 , 1 ) ;
                       If ( ObjectString[1] = '+' ) Then  DeclSig := '+' ;
                       If ( ObjectString[1] = '-' ) Then  DeclSig := '-' ;
                       If ( DeclSig <> ' ' ) Then
                         Begin
                           ObjectString[1] := ' ' ;
                           While (  ObjectString[1] = ' ' )  Do
                                Delete ( ObjectString, 1 , 1 ) ;
                         End ;


                       NOS1 := Pos ( ' ' , ObjectString ) ;

                       ObjectS := Copy ( ObjectString , 1 , NOS1 - 1 ) ;
                       Delete ( ObjectString, 1 , NOS1 - 1 ) ;

                       Val ( ObjectS , N ,  Code  ) ;

                       Decl :=  N * 3600.0 ;



                       While (  ObjectString[1] = ' ' )  Do
                                Delete ( ObjectString, 1 , 1 ) ;
                       NOS1 := Pos ( ' ' , ObjectString ) ;

                       ObjectS := Copy ( ObjectString , 1 , NOS1 - 1 ) ;
                       Delete ( ObjectString, 1 , NOS1 - 1 ) ;

                       Val ( ObjectS , N ,  Code  ) ;

                       Decl :=  Decl + N * 60.0 ;


                       While (  ObjectString[1] = ' ' )  Do
                                Delete ( ObjectString, 1 , 1 ) ;
                       NOS1 := Pos ( ' ' , ObjectString ) ;

                       ObjectS := Copy ( ObjectString , 1 , NOS1 - 1 ) ;
                       Delete ( ObjectString, 1 , NOS1 - 1 ) ;

                       Val ( ObjectS , RRN ,  Code  ) ;

                       Decl :=  ( Decl + RRN ) / 206264.806247 ;

                       If ( DeclSig = '-' )
                            Then  Decl := - Decl ;



                                { Mv }
                                { -- }

                       While (  ObjectString[1] = ' ' )  Do
                                Delete ( ObjectString, 1 , 1 ) ;
                       NOS1 := Pos ( ' ' , ObjectString ) ;

                       If ( NOS1 = 0 )
                         Then
                             ObjectS := ObjectString
                         Else
                           Begin
                             ObjectS := Copy ( ObjectString , 1 , NOS1 - 1 ) ;
                             Delete ( ObjectString, 1 , NOS1 - 1 ) ;
                           End ;

                       Val ( ObjectS , Mv ,  Code  ) ;


            { Žâ®¦¤¥áâ¢«¥­¨¥ }
            { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                       NOS1 := Pos ( ':' , ObjectString    ) ;
                       Delete ( ObjectString, 1 , NOS1 + 1 ) ;

                                { R. A. }
                                { ----- }

                       While (  ObjectString[1] = ' ' )  Do
                                Delete ( ObjectString, 1 , 1 ) ;
                       NOS1 := Pos ( ' ' , ObjectString ) ;

                       ObjectS := Copy ( ObjectString , 1 , NOS1 - 1 ) ;
                       Delete ( ObjectString, 1 , NOS1 - 1 ) ;

                       Val ( ObjectS , N ,  Code  ) ;

                       RaAc :=  N * 3600.0 ;


                       While (  ObjectString[1] = ' ' )  Do
                                Delete ( ObjectString, 1 , 1 ) ;
                       NOS1 := Pos ( ' ' , ObjectString ) ;

                       ObjectS := Copy ( ObjectString , 1 , NOS1 - 1 ) ;
                       Delete ( ObjectString, 1 , NOS1 - 1 ) ;

                       Val ( ObjectS , N ,  Code  ) ;

                       RaAc :=  RaAc + N * 60.0 ;



                       While (  ObjectString[1] = ' ' )  Do
                                Delete ( ObjectString, 1 , 1 ) ;
                       NOS1 := Pos ( ' ' , ObjectString ) ;

                       ObjectS := Copy ( ObjectString , 1 , NOS1 - 1 ) ;
                       Delete ( ObjectString, 1 , NOS1 - 1 ) ;

                       Val ( ObjectS , RRN ,  Code  ) ;

                       RaAc :=  ( RaAc + RRN ) * 15 / 206264.806247 ;

                       If ( RaAc > Pi2 )  Then
                            RaAc := RaAc - Pi2 ;

                                { Decl }
                                { ---- }

                       DeclSig := ' ' ;

                       While (  ObjectString[1] = ' ' )  Do
                                Delete ( ObjectString, 1 , 1 ) ;
                       If ( ObjectString[1] = '+' ) Then  DeclSig := '+' ;
                       If ( ObjectString[1] = '-' ) Then  DeclSig := '-' ;
                       If ( DeclSig <> ' ' ) Then
                         Begin
                           ObjectString[1] := ' ' ;
                           While (  ObjectString[1] = ' ' )  Do
                                Delete ( ObjectString, 1 , 1 ) ;
                         End ;


                       NOS1 := Pos ( ' ' , ObjectString ) ;

                       ObjectS := Copy ( ObjectString , 1 , NOS1 - 1 ) ;
                       Delete ( ObjectString, 1 , NOS1 - 1 ) ;

                       Val ( ObjectS , N ,  Code  ) ;

                       DeclAc :=  N * 3600.0 ;



                       While (  ObjectString[1] = ' ' )  Do
                                Delete ( ObjectString, 1 , 1 ) ;
                       NOS1 := Pos ( ' ' , ObjectString ) ;

                       ObjectS := Copy ( ObjectString , 1 , NOS1 - 1 ) ;
                       Delete ( ObjectString, 1 , NOS1 - 1 ) ;

                       Val ( ObjectS , N ,  Code  ) ;

                       DeclAc :=  DeclAc + N * 60.0 ;


                       While (  ObjectString[1] = ' ' )  Do
                                Delete ( ObjectString, 1 , 1 ) ;
                       NOS1 := Pos ( ' ' , ObjectString ) ;

                       ObjectS := Copy ( ObjectString , 1 , NOS1 - 1 ) ;
                       Delete ( ObjectString, 1 , NOS1 - 1 ) ;

                       Val ( ObjectS , RRN ,  Code  ) ;

                       DeclAc :=  ( DeclAc + RRN ) / 206264.806247 ;

                       If ( DeclSig = '-' )
                            Then  DeclAc := - DeclAc ;



                                { Mv }
                                { -- }

                       While (  ObjectString[1] = ' ' )  Do
                                Delete ( ObjectString, 1 , 1 ) ;
                       NOS1 := Pos ( ' ' , ObjectString ) ;

                       If ( NOS1 = 0 )
                         Then
                             ObjectS := ObjectString
                         Else
                           Begin
                             ObjectS := Copy ( ObjectString , 1 , NOS1 - 1 ) ;
                             Delete ( ObjectString, 1 , NOS1 - 1 ) ;
                           End ;

                       Val ( ObjectS , MvAc ,  Code  ) ;

                       ObjectS := Copy ( ObjectString , 1 , 7 ) ;
                       Val ( ObjectS , PmRaAc ,  Code  ) ;
                       PmRaAc := PmRaAc / 206264.806247 ;

                       ObjectS := Copy ( ObjectString , 8 , 7 ) ;
                       Val ( ObjectS , PmDeclAc ,  Code  ) ;
                       PmDeclAc := PmDeclAc / 206264.806247 ;

       DRa   := DRa    +  RaAc   + ( PmRaAc   * Epoch ) - Ra   ;
       DDecl := DDecl  +  DeclAc + ( PmDeclAc * Epoch ) - Decl ;
       Inc ( NStar ) ;

    End ;

  DRa   := DRa   / NStar * 206264.806247 ;
  DDecl := DDecl / NStar * 206264.806247 ;

  Writeln ( Out ,               NameInp : 12     ,
                  '  DRa = '  , DRa     :  5 : 2 ,
                  '  DDecl = ', DDecl   :  5 : 2 ,
                  '  NStar = ', NStar   :  4       )  ;

  Close  ( Inp ) ;
  Close  ( Out ) ;

End.
