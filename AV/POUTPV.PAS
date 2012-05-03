
{$O+,F+}


UNIT POutPV ;


   {  ‚ë¢®¤ ¯ p ¬¥âp®¢ ¤«ï p¨á®¢ ­¨ï ª pâ¨­ª¨  }
   {  ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ  }


INTERFACE

     Procedure  OutPV ;

IMPLEMENTATION


USES

  PVar    ,
  PVarMenu,
  PGalEkv ,
  PPreNew ,
  PProFld ,
  PRefr ;


     Procedure  OutPV ;

 Var

     CNeg                : Boolean ;

     Sec,
     HOptOut             : Double  ;

     g, mnt,
     HH, IMin, ISek      : Integer ;

 Begin


        { DATE }
        { ÄÄÄÄ }


        ParVar.Date.Year  := YearDate          ;
        ParVar.Date.Month := MonthDate         ;
        ParVar.Date.Day   := Trunc ( DayDate ) ;

        If ( DateOld )  Then
          Begin
            Param.TimeYear    := YearDate          ;
            Param.TimeMon     := MonthDate         ;
            Param.TimeDay     := Trunc ( DayDate ) ;
          End ;


        { TIME }
        { ÄÄÄÄ }

        If ( JDate > 0 )  Then
          Begin

            Sek := Abs ( JDate + DtGrTopo / 24.0 ) -
                   LongInt ( Trunc ( Abs ( JDate + DtGrTopo / 24.0  )  ) ) ;

            Sek := ( Sek + 0.5 ) * 24.0 * C36000  ;
            {
            If ( Sek >= H24 )  Then
              Sek := Sek - H24 ;
            }
            Hh   := Trunc(Sek / C36000);
            Sek := Sek - Hh   * C36000 ;
            IMin := Trunc ( Sek / C600);
            Sek := Sek - IMin *   C600 ;

            ISek := Round ( Sek * C100 )     ;
            IMin := IMin + ISek Div 600      ;
            Sek  := ( ISek Mod  600 ) / C100 ;
            Hh   := Hh   + IMin Div 60 ;
            IMin :=        IMin Mod 60 ;
            Hh   := Hh Mod 24 ;

            If ( DateOld )  Then
              Begin
                Param.TimeH    := Hh   ;
                Param.TimeMin  := IMin ;
                Param.TimeSek  := Sek  ;
              End ;

            ISek := Round ( Sek ) ;
            IMin := IMin + ISek Div 60 ;
            ISek :=        ISek Mod 60 ;
            Hh   := Hh   + IMin Div 60 ;
            IMin :=        IMin Mod 60 ;
            Hh   := Hh Mod 24 ;

          End
        Else
          Begin
            Hh   := 0 ;
            IMin := 0 ;
            ISek := 0 ;
          End ;

        ParVar.Time.Hour := Hh   ;
        ParVar.Time.Min  := IMin ;
        ParVar.Time.Sec  := ISek ;

        If ( DateOld )  Then
          Param.StepTime := StepTime * C36000 * 24.0 ;



        If ( Not B_Gal )
          Then
            Begin

              If ( GScale > 1.000001 )
                Then
                  Begin
                    {
                    If ( B_Import_Fld Or OptRd )
                      Then  IdToEq1 ( CenterX, CenterY,
                                      RaOptGlass, DeclOptGlass )
                      Else  IdToEq  ( CenterX, CenterY,
                                      NPolFix, SPozNp,CPozNp,
                                      RaOptGlass, DeclOptGlass );
                    }
                    IdToEq1 ( CenterX, CenterY, RaOptGlass, DeclOptGlass ) ;

                    RaOptVar   := RaOptGlass   ;
                    DeclOptVar := DeclOptGlass ;

                  End
                Else
                  Begin

                    RaOptVar   := RaOpt   ;
                    DeclOptVar := DeclOpt ;

                  End ;

              PreNew ( JDateFld , JDOut , RaOptVar, DeclOptVar ) ;

            End
          Else
            Begin
              RaOptVar   := RaOptGal   ;
              DeclOptVar := DeclOptGal ;
            End ;


               { RaOpt }
               { ÄÄÄÄÄ }

        If ( Not B_Gal )
           Then   RaOptVar := RaOptVar / 15.0 ;

        RadToGMS ( RaOptVar, CNeg, g, mnt, Sec ) ;


        ParVar.Ra0.Neg  :=  False         ;
        ParVar.Ra0.Deg  :=  g             ;
        ParVar.Ra0.Min  :=  mnt           ;
        ParVar.Ra0.Sec  :=  Round ( Sec ) ;




               { DeclOpt }
               { ÄÄÄÄÄÄÄ }


        RadToGMS ( DeclOptVar, CNeg, g, mnt, Sec ) ;


        ParVar.Dc0.Neg  := CNeg           ;
        ParVar.Dc0.Deg  := g              ;
        ParVar.Dc0.Min  := mnt            ;
        ParVar.Dc0.Sec  := Round ( Sec )  ;



        { AOpt }
        { ÄÄÄÄ }


       RadToGMS ( AOpt, CNeg, g, mnt, Sec ) ;

       If ( Sec > 30.0 )  Then
         Begin
           Inc ( mnt ) ;
           If ( mnt = 60 )  Then
             Begin
               mnt := 0 ;
               Inc ( g ) ;
               g := g Mod 360 ;
             End ;
         End ;


        ParVar.A0.Neg  :=  False  ;
        ParVar.A0.Deg  :=  g      ;
        ParVar.A0.Min  :=  mnt    ;



        { HOpt }
        { ÄÄÄÄ }

        If ( B_Surf )
          Then
            Begin

              If ( Refr )
                Then  HOptOut := HApparent ( HOpt )
                Else  HOptOut :=             HOpt   ;

              ParVar.ZOpt := HOptOut * RG ;
              RadToGMS ( HOptOut, CNeg, g, mnt, Sec ) ;

            End
          Else
            Begin
              ParVar.ZOpt := ( PID2 - HOpt ) * RG ;
              RadToGMS ( ParVar.ZOpt, CNeg, g, mnt, Sec ) ;
            End ;



       If ( Sec > 30.0 )  Then
         Begin
           Inc ( mnt ) ;
           If ( mnt = 60 )  Then
             Begin
               mnt := 0 ;
               Inc ( g ) ;
               g := g Mod 360 ;
             End ;
         End ;


        ParVar.Z0.Neg  := CNeg ;
        ParVar.Z0.Deg  := g    ;
        ParVar.Z0.Min  := mnt  ;



        ParVar.VC   := VOpt * RG  ;
        ParVar.RC   := ROpt       ;
        ParVar.M    := 0.0        ;

        ParVar.H    := Sqrt ( XS*XS + YS*YS + ZS*ZS ) - R_PLANET ;


        ParVar.NST  := NumberOfStars ;
        ParVar.NPL  := NPLSUM;
        ParVar.MINT := 0.0;



 End ;

End.