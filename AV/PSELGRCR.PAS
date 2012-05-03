
{$O+,F+}

 Unit PSelGrCrd ;

      { Селеногpафические кооpдинаты телескопа и поз. угол оси Луны }
      { *********************************************************** }


   InterFace


   Uses   PVAR ;


	  Procedure SelGrCrd  ;


   Implementation


	  Procedure SelGrCrd  ;
        { ****************** }



 Var

           Px22, Px23,
           Px32, Px33  : Double ;


     Pz11, Pz12,
     Pz21, Pz22
                       : Double ;

     Px11 : Double  ;
     Px12 : Double  ;
     Px13 : Double  ;
     Px21 : Double  ;
     Px31 : Double  ;

     Pz13 : Double  ;
     Pz23 : Double  ;
     Pz31 : Double  ;
     Pz32 : Double  ;
     Pz33 : Double  ;

     I, Om, LMon          : Double ;

     XEkv, YEkv, ZEkv     : Double ;
     XEkl, YEkl, ZEkl     : Double ;
     XSel, YSel, ZSel     : Double ;

     XSel1, YSel1, ZSel1  : Double ;
     RSel, REkv           : Double ;

     RaPolMoon,
     DeclPolMoon          : Double ;

     PozPolMoon,
     LSatSelenogr,
     BSatSelenogr,
     SP, CP               : Double ;

    Begin  { SelGrCrd }
           { ======== }


     Px11 := C10 ;
     Px12 := 0.0 ;
     Px13 := 0.0 ;
     Px21 := 0.0 ;
     Px31 := 0.0 ;

     Pz13 := 0.0 ;
     Pz23 := 0.0 ;
     Pz31 := 0.0 ;
     Pz32 := 0.0 ;
     Pz33 := C10 ;


      T := ( JDateFld - 2451545.0 ) / 36525.0;

      EPS:= ( 84381.448 - 46.8150   * T
                        -  0.00059  * T*T
                        +  0.001813 * T*T*T  ) / SEKRAD ;

      SEPS := SIN ( EPS );
      CEPS := COS ( EPS );


      { Селеноцентpические Экватоpиальные кооpдинаты спутника }
      { ----------------------------------------------------- }

      XEkv := - RectCoordPl [ 10 , 1 ] ;
      YEkv := - RectCoordPl [ 10 , 2 ] ;
      ZEkv := - RectCoordPl [ 10 , 3 ] ;


      { Селеноцентpические Эклиптические  кооpдинаты }
      { -------------------------------------------- }

      XEkl :=   XEkv                                ;
      YEkl :=           YEkv * CEps  +  ZEkv * SEps ;
      ZEkl :=         - YEkv * SEps  +  ZEkv * CEps ;


          { Селеногpафические кооpдинаты }
          { ---------------------------- }


      T := ( JDateFld - 2415020.0 ) / 36525.0;

      Om :=      (  259.0 + 10.0 / C600 + 59.79 / C36000 ) * GR         ;
      Om := Om - ( 1934.0 +  8.0 / C600 + 31.23 / C36000 ) * GR * T     ;
      Om := Om +                           7.48 / C36000   * GR * T * T ;

      LMon :=        (    270.0 + 26.0 / C600 +  2.99 / C36000 ) * GR        ;
      LMon := LMon + ( 481267.0 + 52.0 / C600 + 59.32 / C36000 ) * GR * T    ;
      LMon := LMon -                             4.08 / C36000   * GR * T * T;

      I := ( C10 + 32.0 / C600 + 20.0 / C36000 ) * GR ;


      Pz11 := Cos ( Om ) ;
      Pz12 := Sin ( Om ) ;
      Pz21 :=    - Pz12  ;
      Pz22 :=      Pz11  ;

      XSel := Pz11 * XEkl  +  Pz12 * YEkl  + Pz13 * ZEkl ;
      YSel := Pz21 * XEkl  +  Pz22 * YEkl  + Pz23 * ZEkl ;
      ZSel := Pz31 * XEkl  +  Pz32 * YEkl  + Pz33 * ZEkl ;


      Px22 := Cos ( - I ) ;
      Px23 := Sin ( - I ) ;
      Px32 :=     - Px23  ;
      Px33 :=       Px22  ;

      XSel1 := Px11 * XSel  +  Px12 * YSel  + Px13 * ZSel ;
      YSel1 := Px21 * XSel  +  Px22 * YSel  + Px23 * ZSel ;
      ZSel1 := Px31 * XSel  +  Px32 * YSel  + Px33 * ZSel ;

      Pz11 := Cos ( Pi + LMon - Om ) ;
      Pz12 := Sin ( Pi + LMon - Om ) ;
      Pz21 :=    - Pz12  ;
      Pz22 :=      Pz11  ;

      XSel := Pz11 * XSel1  +  Pz12 * YSel1  + Pz13 * ZSel1 ;
      YSel := Pz21 * XSel1  +  Pz22 * YSel1  + Pz23 * ZSel1 ;
      ZSel := Pz31 * XSel1  +  Pz32 * YSel1  + Pz33 * ZSel1 ;

      RSel := Sqrt ( XSel*XSel + YSel*YSel + ZSel*ZSel ) ;

      XSel := XSel / RSel ;
      YSel := YSel / RSel ;
      ZSel := ZSel / RSel ;


          { Сфеpические Селеногpафические кооpдинаты }
          { ======================================== }


      LSatSelenogr := ArcTan ( YSel / XSel ) ;

          IF (         XSel < 0.0 ) Then LSatSelenogr := LSatSelenogr + PI  ;
          IF ( LSatSelenogr < 0.0 ) Then LSatSelenogr := LSatSelenogr + PI2 ;

      BSatSelenogr := ArcTan ( ZSel / SQRT ( C10 - ZSel * ZSel ) ) ;


                    { ------------  *  ------------  }



           { Вычислим экватоpиальные кооpдинаты полюса Луны }
           { ============================================== }

      XSel1 := 0.0 ;
      YSel1 := 0.0 ;
      ZSel1 := R_PLANETS [ 10 ] ;


      Pz11 := Cos ( Pi - LMon + Om ) ;
      Pz12 := Sin ( Pi - LMon + Om ) ;
      Pz21 :=    - Pz12  ;
      Pz22 :=      Pz11  ;

      XSel := Pz11 * XSel1  +  Pz12 * YSel1  + Pz13 * ZSel1 ;
      YSel := Pz21 * XSel1  +  Pz22 * YSel1  + Pz23 * ZSel1 ;
      ZSel := Pz31 * XSel1  +  Pz32 * YSel1  + Pz33 * ZSel1 ;


      Px22 := Cos ( I ) ;
      Px23 := Sin ( I ) ;
      Px32 :=   - Px23  ;
      Px33 :=     Px22  ;

      XSel1 := Px11 * XSel  +  Px12 * YSel  + Px13 * ZSel ;
      YSel1 := Px21 * XSel  +  Px22 * YSel  + Px23 * ZSel ;
      ZSel1 := Px31 * XSel  +  Px32 * YSel  + Px33 * ZSel ;



      Pz11 := Cos ( - Om ) ;
      Pz12 := Sin ( - Om ) ;
      Pz21 :=      - Pz12  ;
      Pz22 :=        Pz11  ;

      XEkl := Pz11 * XSel1  +  Pz12 * YSel1  + Pz13 * ZSel1 ;
      YEkl := Pz21 * XSel1  +  Pz22 * YSel1  + Pz23 * ZSel1 ;
      ZEkl := Pz31 * XSel1  +  Pz32 * YSel1  + Pz33 * ZSel1 ;

      Px22 := Cos ( - Eps ) ;
      Px23 := Sin ( - Eps ) ;
      Px32 :=       - Px23  ;
      Px33 :=         Px22  ;

      XEkv := Px11 * XEkl  +  Px12 * YEkl  + Px13 * ZEkl ;
      YEkv := Px21 * XEkl  +  Px22 * YEkl  + Px23 * ZEkl ;
      ZEkv := Px31 * XEkl  +  Px32 * YEkl  + Px33 * ZEkl ;

      REkv := Sqrt ( XEkv*XEkv + YEkv*YEkv + ZEkv*ZEkv ) ;

      XEkv := XEkv / REkv ;
      YEkv := YEkv / REkv ;
      ZEkv := ZEkv / REkv ;

          { Сфеpические Селеногpафические кооpдинаты }
          { ======================================== }


      RaPolMoon := ArcTan ( YEkv / XEkv ) ;

          IF (     XEkv  < 0.0 ) Then RaPolMoon := RaPolMoon + PI  ;
          IF ( RaPolMoon < 0.0 ) Then RaPolMoon := RaPolMoon + PI2 ;

      DeclPolMoon := ArcTan ( ZEkv / SQRT ( C10 - ZEkv * ZEkv ) ) ;


          { Позиционный угол полюса }
          { ----------------------- }

      CP := DeclPolMoon - RezPl [ 10 , 2 ] ;
      SP := ( RaPolMoon - RezPl [ 10 , 1 ] ) * Cos ( RezPl [ 10 , 2 ] ) ;

      PozPolMoon  := ARCTAN ( SP / CP ) ;

 	IF ( CP         < 0.0 )  THEN  PozPolMoon := PozPolMoon + PI  ;
	IF ( PozPolMoon < 0.0 )  THEN  PozPolMoon := PozPolMoon + PI2 ;

      PozPolMoon := PozPolMoon + PozNP ;
      If ( PozPolMoon > Pi2 )  Then
         PozPolMoon := PozPolMoon - Pi2 ;

    End ;  { SelGrCrd }
           { ======== }

End.