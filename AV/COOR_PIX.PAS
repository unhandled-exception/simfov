
               Program  Coor_Pixel ;
              {───────────────────}

{
     Вычисление экватоpиальных кооpдинат пикселей с использованием
     данных о pедукции матpицы.
}

Uses Dos ;



	Function Atan2 ( X, Y : Double ) : Double  ;


  Var
    A, Pi2, Pid2  : Double ;

  Begin

    Pi2  : Double = Pi * C20 ;
    Pid2 : Double = Pi / C20 ;

    If ( ( X = 0.0 ) And ( Y = 0.0 ) )
      Then
        Begin
          ATan2 := 0.0 ;
        End
      Else
        Begin
          If ( Abs ( X ) <= Abs ( Y ) )
            Then
              Begin
                A := ArcTan ( X / Y ) ;
              End
            Else
              Begin
                If ( ( Y / X ) < 0.0 )
                  Then  A := - Pid2 - ArcTan ( Y / X )
                  Else  A :=   Pid2 - ArcTan ( Y / X ) ;
              End ;

          If ( Y < 0 )  Then
            A := A + Pi ;

          If ( A < 0.0 )  Then
            A := A + Pi2 ;

          If ( A > Pi2 )  Then
            A := A - Pi2 ;

          ATan2 := A ;

        End ;

  End ;




  Procedure  ReadConst ( NameFile : String;
                         Var  Ax,
                              Bx,
                              Cx,
                              Ay,
                              By,
                              Cy,
                              MqeMnk,
                              Fd,
                              RaOpt,
                              DeclOpt,
                              JDateFld,
                              StepRow,
                              StepCol,
                              OcRow,
                              OcCol,
                              ARow,
                              BCol,
                              CRow,
                              DCol
                                         : Double
                       ) ;

Const

    SekRad = 206264.8062470964 ;
    GR     : Double = 3600.0 / SekRad   ;
    RG     : Double = SekRad / 3600.0   ;

Var
    ConstFile : Text    ;
    NConst    : Integer ;

Begin

  Assign ( ConstFile, NameFile ) ;
  Reset  ( ConstFile           ) ;

  ReadLn ( ConstFile, NConst ) ;

  ReadLn ( ConstFile, Ax  ) ;
  ReadLn ( ConstFile, Bx  ) ;
  ReadLn ( ConstFile, Cx  ) ;

  ReadLn ( ConstFile, Ay  ) ;
  ReadLn ( ConstFile, By  ) ;
  ReadLn ( ConstFile, Cy  ) ;

  ReadLn ( ConstFile, MqeMnk     ) ;
  ReadLn ( ConstFile, Fd         ) ;
  ReadLn ( ConstFile, RaOpt      ) ;
  ReadLn ( ConstFile, DeclOpt    ) ;

  RaOpt   := RaOpt   / RG * 15.0   ;
  DeclOpt := DeclOpt / Rg          ;

  ReadLn ( ConstFile, JDateFld   ) ;

  ReadLn ( ConstFile, StepRow    ) ;
  ReadLn ( ConstFile, StepCol    ) ;
  ReadLn ( ConstFile, OcRow      ) ;
  ReadLn ( ConstFile, OcCol      ) ;

  ReadLn ( ConstFile, ARow       ) ;
  ReadLn ( ConstFile, BCol       ) ;
  ReadLn ( ConstFile, CRow       ) ;
  ReadLn ( ConstFile, DCol       ) ;


  Close  ( ConstFile ) ;

End ; { ReadConst }





Procedure RadToGms( x : Double  ; Var neg  : boolean ;
                                Var g, m : integer ;
                                Var s    : Double   );
Const
 C : Double = 206264.806247;
Var
 Sign : Integer;
Begin
 If ( x < 0 )
   Then Sign:= -1
   Else Sign:=  1 ;
 neg := ( Sign = -1 );
 x := ( Sign * x ) * C;
 g := Trunc( x / 3600.0 );
 x := x - g * 3600.0;
 m := Trunc( x / 60.0 );
 s := x - m * 60.0;
 If ( ( Round ( s * 10.0 ) / 10.0 ) >= 60.0 )
   Then
     Begin
       s := s - 60.0;
       Inc(m);
     End
   Else
     If ( s > 59.9 ) Then
          s := 59.9;
 If ( m >= 60 )
   Then
     Begin
       m := m-60;
       g := g+ 1;
     End;

End;



Procedure RadToHms ( X : Double  ; Var h,m : Integer; Var s : Double );

Const
 C : Double = 206264.806247;
Begin
 x:=x * ( C / 15.0 );
 h:=Trunc( x / 3600.0 );
 x:= x - h * 3600.0;
 m:=Trunc( x / 60.0 );
 s:= x - m * 60.0;

 If ( ( Round (s * 10.0) / 10.0 ) >= 60.00 )
   Then
     Begin
       s:=s - 60.0;
       Inc(m);
     End
   Else
     If ( S > 59.99 ) Then
       s:=59.99;

 If ( m >= 60 )
   Then
     Begin
       m:=m-60;
       Inc(h);
     End;

 If ( ( h = 24 ) And ( m = 0 ) ) Then
   Begin
     h:=0;
     m:=0;
   End;

End;


   Procedure JD8 (     IY : Integer ;
                       IM : INTEGER ;
		        D : DOUBLE  ;
		   Var JD : Double    ) ;


 Var

	JN, IYY, IMM, IA, IB, IS : LONGINT ;
			   GRDAT : DOUBLE  ;

 Begin

	If ( IM > 2 )  Then
	  Begin
	    IYY := IY;
	    IMM := IM + 1;
	  End
	 Else
	  Begin
	    IYY := IY - 1;
	    IMM := IM + 13;
	  End;

	If ( IYY = 0 ) Then IS := 1
	  Else
	    Begin
		IS  := TRUNC ( IYY / ABS ( IYY ) ) ;
		IYY := ABS ( IYY );
	    End;

	GRDAT := IYY * 10000.0 + IMM * 100.0 + D;

	If ( IS > 0 )  Then
	  Begin
	    IB := 0;

	    If ( GRDAT >= 15821015.0 )  Then
	      Begin
		IA := TRUNC ( IYY / 100 ) * IS;
		IB := 2 - IA + TRUNC ( ABS ( IA ) / 4 ) * IS;
	      End;

	    JD := 1720994.5 + D +
     		 TRUNC ( 365.25   * IYY ) +
     		 TRUNC (  30.6001 * IMM ) + IB;
	  End

	Else

	    JD := 1720994.5 + D -
     		 TRUNC ( 365.25   * IYY + 0.75 ) +
     		 TRUNC (  30.6001 * IMM ) ;


  End;




 { ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄ }





  Procedure CoorPixel (  Row, Col,        { Входные кооpдинаты на CCD     }
                         Fd,              { Фокусное pасстояние           }
                         RaOpt, DeclOpt,  { Кооpдинаты Опт. Ц. в Grad и h }
                         JDateFld,        { Jd Опт. Ц.                    }
                         JdOut,           { Jd Выходных кооpдинат         }
                         ARow, BCol,      { Матpица пеpехода от пиксельных  }
                         CRow, DCol,      { кооpдинат к кооpдинатам на небе }
                         StepRow, StepCol,{ Пеpиоды матpицы по осям       }
                         OCRow, OCCol,    { Положение Опт.Ц. на матpице   }
                         Ax, Bx, Cx,      { Редукция от пpямоугольных к   }
                         Ay, By, Cy       { идеальным кооpдинатам         }
                                           : Double ;
                    Var  RaPix, DeclPix,  { R.A. и Decl.       на JdOut   }
                         LGalPix, BGalPix { Галактические к-ты на JdOut   }
                                           : Double ) ;

{
  Линейные величины в милиметpах.
  Угловые  величины в pадианах  .
}




Const

    SekRad = 206264.8062470964 ;
    GR     : Double = 3600.0 / SekRad   ;
    RG     : Double = SekRad / 3600.0   ;



Var

 MqeMnk,
 AxImp, BxImp, CxImp,
 AyImp, ByImp, CyImp,
 SRaOpt, CRaOpt, SDeclOpt, CDeclOpt,
 XSt, YSt, X, Y
                                       : Double  ;




    Procedure IdToEq ( Fd, SRaOpt, CRaOpt, SDeclOpt, CDeclOpt : Double ;
                                                     XSt, YSt : Double ;
                                            Var    Ra,   Decl : Double   ) ;

Var

    P, S, Sr, Cr, Sd, Cd,
    Sp, Cp, Ss, Cs,
    SDa, CDa,
    SPoz, CPoz, SG, CG
                           : Double ;

Begin

  XSt := - XSt ;

  P := Sqrt ( XST * XST + YST*YST ) ;
  S := P / FD ;

  If ( S < 1.0E-9 )  Then
      Begin

        SR := SRaOpt ;
        CR := CRaOpt ;

        SD := SDeclOpt ;
        CD := CDeclOpt ;

      End
    Else
      Begin

        CP :=  YSt / P ;
        SP :=  XSt / P ;

        SS := S / Sqrt ( C10  +  S * S ) ;
        CS := Sqrt ( C10 - SS * SS )     ;

        SD := CS * SDeclOpt + SS * CDeclOpt * CP ;
        CD := Sqrt ( C10 - SD * SD ) ;

        If ( Abs ( CD ) < 1.0E-9 )
          Then

            Begin

              SR  := SRaOpt ;
              CR  := CRaOpt ;

              SDA := SDeclOpt ;
              CDA := CDeclOpt ;

            End

          Else

            Begin

              SDA := ( SS * SP ) / CD ;
              CDA := ( CS * CDeclOpt - SS * SDeclOpt * CP ) / CD ;

              SR  := SDA * CRaOpt + CDA * SRaOpt ;
              CR  := CDA * CRaOpt - SDA * SRaOpt ;

            End ;

      End ;

  Ra   := ATan2 ( Sr, Cr ) ;
  Decl := ATan2 ( Sd, Cd ) ;


End;




	Procedure PreNew (     JDE1, JDE2  : DOUBLE ;
                          Var    RA, DECL  : DOUBLE   ) ;
{ ---------------------------------------------------------------
     J2000.0  2451545.0
     B1900.0  2415020.313516463
     B1950.0  2433282.423455513
            Пpoдoлжитeльнocть юлиaнcкoгo cтoлeтия 36525 днeй.
            Бecceлeвa эпoxa для J2000:  2000.001278.
  --------------------------------------------------------------- }

   Const

     HY   : Double =    36525.0           ;
     T0   : Double =  2451545.0           ;
     SR   : Double =   206264.8062470964  ;
     Pi2  : Double = Pi + Pi              ;

     CC1  : Double =  2306.2181     ;
     CC2  : Double =     1.39656    ;
     CC3  : Double =     0.000139   ;
     CC4  : Double =     0.30188    ;
     CC5  : Double =     0.000344   ;
     CC6  : Double =     0.017998   ;
     CC7  : Double =     1.09468    ;
     CC8  : Double =     0.000066   ;
     CC9  : Double =     0.018203   ;
     CC10 : Double =  2004.3109     ;
     CC11 : Double =     0.85330    ;
     CC12 : Double =     0.000217   ;
     CC13 : Double =     0.42665    ;
     CC14 : Double =     0.000217   ;
     CC15 : Double =     0.041833   ;


   Var


     DT,DT2,DT3,T,T2,S1,S2,S3,C1,C2,C3,
     X, Y, Z,
     SRA, CRA,
     XEkl, YEkl, ZEkl, Eps, SEps, CEps ,
     LEkl, BEkl                              : Double ;

   Begin

      T   := ( JDE1 - T0   ) / HY ;
      DT  := ( JDE2 - JDE1 ) / HY ;

      Z   := SIN  ( DECL ) ;
      Y   := SQRT ( C10 - Z * Z ) ;
      SRA := SIN  ( RA ) ;
      CRA := COS  ( RA ) ;
      X   := CRA * Y ;
      Y   := SRA * Y ;


      T2  := T   * T  ;
      DT2 := DT  * DT ;
      DT3 := DT2 * DT ;

      S2  :=      (  CC1  +  CC2 * T         -  CC3 * T2  ) * DT  ;
      S1  := S2 + (  CC4  -  CC5 * T ) * DT2 +  CC6 * DT3         ;
      S3  := S2 + (  CC7  +  CC8 * T ) * DT2 +  CC9 * DT3         ;
      S2  :=      ( CC10  - CC11 * T         - CC12 * T2  ) * DT  ;
      S2  := S2 - ( CC13  + CC14 * T ) * DT2 - CC15 * DT3         ;

      S1  := S1 / SR ;
      S2  := S2 / SR ;
      S3  := S3 / SR ;

      C1  := COS ( S1 ) ;
      C2  := COS ( S2 ) ;
      C3  := COS ( S3 ) ;

      S1  := SIN ( S1 ) ;
      S2  := SIN ( S2 ) ;
      S3  := SIN ( S3 ) ;




      DT  :=  X   * C1  -  Y   * S1  ;
      DT2 :=  X   * S1  +  Y   * C1  ;
      DT3 :=  Z                      ;

      X   :=  DT  * C2  -  DT3 * S2  ;
      Y   :=  DT2                    ;
      Z   :=  DT  * S2  +  DT3 * C2  ;

      DT  :=  X   * C3  -  Y   * S3  ;
      DT2 :=  X   * S3  +  Y   * C3  ;
      DT3 :=  Z                      ;

      X   :=  DT  ;
      Y   :=  DT2 ;
      Z   :=  DT3 ;

      Ra   := ATan2 ( Y , X ) ;
      Decl := Atan2 ( Z , Sqrt ( Sqr ( X ) + Sqr ( Y ) )  ) ;
      If ( Decl > Pi )  Then
        Decl := Decl - Pi2 ;


   End ;  { PreNew }




 Procedure  EkvGal ( Ra, Decl, JDateFld : Double;  Var  L, B : Double ) ;
{─────────}

 Const

    SekRad       = 206264.8062470964 ;
    RaGalPol50   = 192.25 / SekRad * 3600.0 ;
    DeclGalPol50 =   27.4 / SekRad * 3600.0 ;
    Pi2          = Pi * 2.0 ;
    Pid2         = Pi / 2.0 ;
    dLNewOld     = 33.0 * 3600.0 / SekRad ;


 Var

    SRaGalPol50, SDeclGalPol50,
    CRaGalPol50, CDeclGalPol50,
    dRa, CdRa, SDecl, CDecl, Sl, Cl, Sb, Cb  : Double ;

  Begin

    If ( Abs ( JDateFld - 2433282.423455513 ) > 3 )  Then
      PreNew ( JDateFld, 2433282.423455513, Ra, Decl ) ;

    SDecl := Sin ( Decl ) ;
    CDecl := Sqrt ( C10 - Sqr ( SDecl )  );
    dRa   := Ra - RaGalPol50 ;
    CdRa  := Cos ( dRa ) ;

    SRaGalPol50   := Sin ( RaGalPol50   )  ;
    CRaGalPol50   := Cos ( RaGalPol50   )  ;
    SDeclGalPol50 := Sin ( DeclGalPol50 )  ;
    CDeclGalPol50 := Cos ( DeclGalPol50 )  ;

    Sb := SDeclGalPol50 * SDecl  +  CDeclGalPol50 * CDecl * CdRa ;
    Cb := Sqrt ( C10 - Sqr ( Sb )  ) ;

    Cl := CDecl * Sin ( dRa ) ;
    Sl := CDeclGalPol50 * SDecl  -  SDeclGalPol50 * CDecl * CdRa ;

    B := ATan2 ( Sb, Cb ) ;
    L := ATan2 ( Sl, Cl ) ;

    L := L + dLNewOld ;

    If ( L > Pi2 )  Then
      L := L - Pi2 ;

  End;




  Begin  { Pro CoorPixel }

    Row  := ( Row - OcRow ) * StepRow ;   { In mm.      }
    Col  := ( Col - OcCol ) * StepCol ;   { In mm.      }

    X  := - ( Row * ARow + Col * BCol )  ; { Hа Hебе в mm. Ид. к-ты }
    Y  :=     Row * CRow + Col * DCol ; { Hа Hебе в mm. Ид. к-ты }

    XSt :=   X * Ax  +  Y * Bx  +  Cx ;
    YSt :=   X * Ay  +  Y * By  +  Cy ;


    SRaOpt   := Sin ( RaOpt   ) ;
    CRaOpt   := Cos ( RaOpt   ) ;
    SDeclOpt := Sin ( DeclOpt ) ;
    CDeclOpt := Cos ( DeclOpt ) ;

    IdToEq ( Fd, SRaOpt, CRaOpt, SDeclOpt, CDeclOpt, XSt, YSt, RaPix, DeclPix ) ;
    EkvGal ( RaPix, DeclPix, JDateFld, LGalPix, BGalPix ) ;

    If ( Abs ( JDateFld - JdOut ) > 3 )  Then
      PreNew ( JDateFld, JdOut, RaPix, DeclPix ) ;

  End ;  { CoorPixel }





 { ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄ }







  Var

       NameFile, NameOut          : String ;

       DrStr: DirStr;
       NmStr: NameStr;
       ExStr: ExtStr;

       CNeg                       : Boolean ;

       Year,
       Code,
       G, Mnt,
       IRow, ICol                 : Integer ;


       Sek,
       Row, Col,
       Ax, Bx, Cx,
       Ay, By, Cy,
       MqeMnk,
       Fd,
       RaOpt, DeclOpt,
       JdOpt, JdOut  ,
       StepRow, StepCol,
       OcRow,   OcCol,
       ARow, BCol, CRow, DCol,
       RaPix, DeclPix,
       LGalPix, BGalPix
                                  : Double ;
  Out : Text ;


Begin  { Program }


  If ( ParamCount < 1 )  Then
    Begin

      Writeln ;
      Writeln ( ' Паpаметpы : 1 : NameFileRedConst ' ) ;
      Writeln ( '             2 : Равноденствие выходных R.A. и Decl. ') ;
      Writeln ( '                 Пpи отсутствии 2 паpаметpа JdOut = JdConst' )  ;
      Writeln ;

      Halt ( 1 ) ;

    End ;

  If ( ParamCount = 2 )  Then
    Begin
      Val ( ParamStr ( 2 ), Year, Code )  ;
      If ( Code <> 0 )  Then
        Begin
          Writeln ;
          Writeln ( ' Error In ParamStr : ' , ParamStr ( 1 ), '  '
                                            , ParamStr ( 2 )       ) ;
          Halt ( 1 ) ;
        End ;
      JD8 ( Year, 1, 0.0, JdOut ) ;
    End ;

  NameFile := ParamStr ( 1 ) ;
  FSplit ( NameFile, DrStr, NmStr, ExStr ) ;
  NameOut := DrStr + NmStr + '.Rez' ;
{
  NameFile := '3248.Red' ;
}
  ReadConst ( NameFile,
                        Ax,   Bx,   Cx,
                        Ay,   By,   Cy,
                        MqeMnk,
                        Fd,
                        RaOpt,   DeclOpt,
                        JdOpt,
                        StepRow, StepCol,
                        OcRow,   OcCol,
                        ARow,    BCol,
                        CRow,    DCol
                                                    ) ;

  If ( ParamCount = 1 )  Then
    JdOut := JdOpt ;


  Assign  ( Out, NameOut ) ;
  Rewrite ( Out          ) ;

  Writeln ;
  Writeln ;
  Writeln ( ' Input : ',NameFile,
  '      YearOutCoord = ', 2000 + Round ( ( JdOut - 2451545 ) / 365.25 ): 4 ) ;
  Writeln ;
  WriteLn ;

  For  IRow := 1 To 375  Do
    Begin

      Write ( IRow : 8 ) ;

      For ICol := 1 To 242 Do
        Begin

            Row := IRow * C10 ;
            Col := ICol * C10  ;

            CoorPixel (  Row, Col,        { Входные кооpдинаты на CCD     }
                         Fd,              { Фокусное pасстояние           }
                         RaOpt, DeclOpt,  { Кооpдинаты Опт. Ц. в Grad и h }
                         JdOpt,           { Jd Опт. Ц.                    }
                         JdOut,           { Jd Выходных кооpдинат         }
                         ARow, BCol,      { Матpица пеpехода от пиксельных  }
                         CRow, DCol,      { кооpдинат к кооpдинатам на небе }
                         StepRow, StepCol,{ Пеpиоды матpицы по осям       }
                         OCRow, OCCol,    { Положение Опт.Ц. на матpице   }
                         Ax, Bx, Cx,      { Редукция от пpямоугольных к   }
                         Ay, By, Cy,      { идеальным кооpдинатам         }
                         RaPix, DeclPix,  { R.A. и Decl.       на JdOut   }
                         LGalPix, BGalPix { Галактические к-ты на JdOut   }
                      ) ;


            RadtoHms ( RaPix, G, Mnt, Sek ) ;

            Write  ( Out,    IRow              : 6     ,
                             ICol              : 4     ,
                             G                 : 8     ,
                             Mnt               : 3     ,
                             Sek               : 6 : 2   ) ;

            RadtoGms ( DeclPix, CNeg, G, Mnt, Sek ) ;

            If ( CNeg )
               Then Write  ( Out,'  -' )
               Else Write  ( Out,'  +' ) ;

            Write  ( Out,
                         G                 : 2     ,
                         Mnt               : 3     ,
                         Sek               : 5 : 1   ) ;



            RadtoGms ( LGalPix, CNeg, G, Mnt, Sek ) ;

            Write  ( Out,
                             G                 : 8     ,
                             Mnt               : 3     ,
                             Sek               : 5 : 1   ) ;

            RadtoGms ( BGalPix, CNeg, G, Mnt, Sek ) ;

            If ( CNeg )
               Then Write  ( Out,'  -' )
               Else Write  ( Out,'  +' ) ;

            Write  ( Out,
                         G                 : 2     ,
                         Mnt               : 3     ,
                         Sek               : 5 : 1   ) ;

            Writeln ( Out ) ;

        End ;

    End ;

  Close   ( Out ) ;


End.
