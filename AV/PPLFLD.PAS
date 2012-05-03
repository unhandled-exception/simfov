
{$O+,F+}

Unit PPlFld ;   { €’€ ‘ ‹€…’€Œˆ }
                { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }


  Interface


    Procedure PlFld ;


  ImPlementation

    Uses  PVAR, PVarMenu, V_CATAL , PPlPro , PProFld, PPRENew,
          PAtan2, PRefr , PMem   {, PSelGrCrd} ;


    Procedure PlFld ;
   {ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}



    Var

     I, J                    : Integer ;

     XUgol,
     YUgol,
     RRRR,
     Index,
     HPlan,
     Xst, Yst,
     X, Y, Z,
     MVP, DD, FF, PP, RPE,
     ROPl, HOOPl, R_Izo,
     RASun, DeclSun,
     RAMon, DeclMon,
     SDeclSun, CDeclSun,
     SDeclMon, CDeclMon,
     RAPl,   DeclPl,
     SD, CD, SR, CR,
     SH, CH, SA, CA,
     ST, CT, SDA, CDA,
     SPoz, CPoz, TGRO,
     CRoSun,   SROSun,
     CRoMon,   CRoEAR,
     CRoSunMax,
     CRoMonMax,
     CRoEARMax,
     PhaseEarth, PhaseMoon,
     DA, R_Sat                  : DOUBLE   ;




     Begin  { PRO PlFld }

        {
        Povorot ( JdateFld, SPozNp1, CPozNp1 ) ;
        }

        CBlockPlanet := 0 ;

        CRoSunMax := Cos ( Param.RSun * GR ) ;
        CRoMonMax := Cos ( Param.RMon * GR ) ;



        XSAE := XS / AE ;
        YSAE := YS / AE ;
        ZSAE := ZS / AE ;



        NPl := 0 ;  { ‚‘… ‹€…’› }
                    { ÄÄÄÄÄÄÄÄÄÄÄ }

        PlPro ( False,
                JDate, JDateFld, NPl0, XSAE, YSAE, ZSAE,
                NPl, RezPl, RectCoordPl, PhaseMoon, PhaseEarth );


        Max_Pl_PPlFld := 15 ;



        R_Sat := Sqrt ( Sqr ( XSAE ) + Sqr ( YSAE ) + Sqr ( ZSAE ) ) ;

        If ( ( NPl0 <> 3 )  Or  ( R_Sat > 0.1 ) )    Then
           Begin   { …’ ‘“’ˆŠ‚ ˆ’…€, …‘‹ˆ ‹…’€…Œ „€‹…Š ’ ‡…Œ‹ˆ }
                   { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                    Max_Pl_PPlFld  := 11 ;

           End ;



        { ‚…Š€ ‡€‘‚…’Šˆ ‘‹–…Œ ˆ ‹“‰ }
        { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

        POM_FLD   := 0   ;

        NPl := 11 ;  { Sun }
                     { ÄÄÄ }

        If ( NPl <> NPlOpt )  Then
          Begin

	    RaSun    := RezPl [ NPl , 1 ];
	    DeclSun  := RezPl [ NPl , 2 ];

            SDeclSun := Sin ( DeclSun ) ;
            CDeclSun := Cos ( DeclSun ) ;


            CRoSun :=            SDeclOPT * SDeclSun                         ;
            CRoSun := CRoSun  +  CDeclOPT * CDeclSun * Cos ( RaOPT - RaSun ) ;

            If ( Abs ( CRoSun ) > C10 )  Then
              Begin
                If ( CRoSun > 0.0 )
                  Then  CRoSun :=   C10
                  Else  CRoSun := - C10 ;
              End ;

            SRoSun := Sqrt ( C10 - Sqr ( CRoSun ) ) ;

            ROSun  := ATan2 ( SRoSun , CRoSun ) ;

            If ( CRoSun > CRoSunMax )  Then
               POM_FLD := 1  ;

          End

         Else

            ROSun := 0 ;



        NPl := 10 ;  { MOON }
                     { ÄÄÄÄ }

        If ( NPl <> NPlOpt )  Then
          Begin

            RaMon   := RezPl [ NPl , 1 ];
	    DeclMon := RezPl [ NPl , 2 ];

            SDeclMon := Sin ( DeclMon ) ;
            CDeclMon := Cos ( DeclMon ) ;


            CRoMon :=            SDeclOPT * SDeclMon ;
            CRoMon := CRoMon  +  CDeclOPT * CDeclMon * Cos ( RaOPT - RaMon ) ;

            If ( Abs ( CRoMon ) > C10 )  Then
              Begin
                If ( CRoMon > 0.0 )
                  Then  CRoMon :=   C10
                  Else  CRoMon := - C10 ;
              End ;


            ROMon  := ArcTan ( Sqrt ( C10 - CRoMon * CRoMon ) / CRoMon ) ;
            If ( CRoMon < 0.0 )  Then
               ROMon := ROMon + PI  ;
            If (  ROMon < 0.0 )  Then
               ROMon := ROMon + PI2 ;


            If ( CRoMon > CRoMonMax )  Then
              POM_FLD := POM_FLD + 10  ;

          End

         Else

            ROMon := 0 ;





          { ‚› ‹€…’ ‚ ‹… ‡…ˆŸ }
          { ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ }



        PozNp  := 0.0 ;
        NPlSUM := 0   ;


        For NPl := 0 To Max_Pl_PPlFld  DO

         If (    ( NPl <> NPl0 )
              Or ( NPl =  NPl0 ) And ( Not B_Surf )  )   Then
         Begin  { FIND PlANETS }

          If  ( NPl > 0  )  Then
            Begin

              RaPl    := RezPl [ NPl , 1 ]      ;
              DeclPl  := RezPl [ NPl , 2 ]      ;
              MVP     := RezPl [ NPl , 3 ]      ;
	      FF      := RezPl [ NPl , 5 ]      ;
	      PP      := RezPl [ NPl , 6 ]      ;
              RPE     := RezPl [ NPl , 7 ]      ;

              SD      := Sin  ( DeclPl        ) ;
              CD      := Sqrt ( C10 - SD * SD ) ;
              SR      := Sin  ( RaPl )          ;
              CR      := Cos  ( RaPl )          ;

	      DD      := Sin ( RezPl [ NPl , 4 ] / C20 ) /
                         Cos ( RezPl [ NPl , 4 ] / C20 ) * C20 * Fd ;
            End
           Else
            Begin { POSANG NORD POL }
                  { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

              If (    ( NPolFix  )
                   Or ( NPl0 = 3 ) )  Then
                Begin  { N Pol }
                       { ÄÄÄÄÄ }
                  SD := C10 ;
                  CD := 0.0 ;
                  SR := 0.0 ;
                  CR := C10 ;

                  If ( Abs ( STEPTIME ) >= 100 )  Then
                    Begin  { Poz NP ->  JDateFld }
                           { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                      SD := Pid2 ;
                      SR := 0.0  ;

                      If ( Abs ( JDate - JdEp ) >= 100 )   Then
                        PRENew ( JdEp , JDate , SR, SD );

                      CD := Cos ( SD ) ;
                      SD := Sin ( SD ) ;
                      CR := Cos ( SR ) ;
                      SR := Sin ( SR ) ;

                    End ;

                End
               Else
                Begin  { Pol Ekl }
                       { ÄÄÄÄÄÄÄ }
                  {
                  SR := - C10 ;
                  CR :=   0.0 ;
                  SD :=  CEps ;
                  Cd :=  SEps ;
                  }
                  NPolFix := True ;

                  SD := C10 ;
                  CD := 0.0 ;
                  SR := 0.0 ;
                  CR := C10 ;

                End ;


            End ; { POSANG NORD POL }
                  { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

          ST := SSTime * CR  -  CSTime * SR ;
          CT := CSTime * CR  +  SSTime * SR ;

          SH := SD * SFIS + CD * CFIS * CT ;
          If ( Abs ( SH ) > C10 )
            Then
              Begin
                CH := 0.0 ;
                If ( SH > 0.0 )
                  Then SH :=   C10
                  Else SH := - C10 ;
              End
            Else
              Begin
                If ( Abs ( SH ) > 1.0e-15 )
                  Then CH := Sqrt ( C10 - Sqr ( SH ) )
                  Else CH := C10 ;
              End ;


          If ( CH > 1.0e-15 )
            Then
              Begin
                SA :=     CD * ST / CH ;
                CA := ( - SD * CFIS + CD * SFIS * CT ) / CH ;
              End
            Else
              Begin
                SA := ST ;
                CA := CT ;
              End ;

          SDA := SAOPT * CA  -  CAOPT  * SA ;
          CDA := CAOPT * CA  +  SAOPT  * SA ;
          If ( CDA > 1.0 )  Then
            CDA := 1.0 ;
          If ( CDA < -1.0 )  Then
            CDA := -1.0 ;

	  CRo := SHOpt * SH  +  CHOpt * CH * CDA   ;
          If ( Abs ( CRo ) > 1.0e-15 )
            Then
              Begin
                If ( CRo > C10 )  Then
                  CRo := C10 ;
                SRO := Sqrt ( C10 - Sqr ( CRo ) )
              End
            Else
                SRO := C10 ;


          If ( Abs ( SRO ) > 1.0e-15 )
            Then
              Begin
                SPoz  :=   CH * SDA / SRO ;
                CPoz  := ( SH * CHOpt  -  CH * SHOpt * CDA ) / SRO ;
              End
            Else
              Begin
                {
                SPoz  :=   CH * SDA  ;
                CPoz  := ( SH * CHOpt  -  CH * SHOpt * CDA )  ;
                RRRR := ATan2 ( SPoz, CPoz ) ;
                SPoz := Sin ( RRRR ) ;
                CPoz := Cos ( RRRR ) ;
                }

                SPoz  := SDa ;
                CPoz  := CDa ;

              End ;


          If  ( NPl > 0 )  Then
             Begin

               If ( Sqrt ( C10 - Sqr ( Sh ) )  >  1.0e-10 )
                 Then
                   HPlan := ArcTan ( Sh / Sqrt ( C10 - Sqr ( Sh ) ) )
                 Else
                   Begin
                     HPlan := Pi / C20 ;
                     If ( Sh < 0.0 ) Then
                       HPlan := - HPlan ;
                   End ;

               If ( Refr )  Then
                 HPlan := HApparent ( HPlan ) ;

               HPlan := HPlan + RezPl [ NPl , 4 ] / C20 ;



               If ( Abs ( CRo ) > 1.0e-6 )
                   Then
                     Begin
	               Xst := - Fd * SPoz * SRO / CRo ;
	               Yst :=   Fd * CPoz * SRO / CRo ;
                     End
                   Else
                     Begin
                       Xst := 1.0e6 ;
                       Yst := 1.0e6 ;
                     End ;


               If ( NPolFix )   Then
                   Begin
                     Index := Xst ;
                     Xst   :=    Xst  * CPozNp  +  Yst * SPozNp ;
                     Yst   := - Index * SPozNp  +  Yst * CPozNp ;
                   End ;


               If ( Sqrt ( Abs ( C10 - Sqr ( CRo ) ) ) > 1.5e-7 )
                Then
                  Begin

                   If ( CRo >  0 )
                     Then
                       Begin

                         R_Izo := Sqrt ( Sqr ( Xst ) + Sqr ( Yst ) );
                         ROPl   := ArcTan ( R_Izo / Fd );

                            { “£®«  O.C. - ‹¨¬¡ }
                            { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                         HOOPl  := ROPl - RezPl [ NPl , 4 ] / C20 ;

                         R_Izo := R_Izo - Fd * Sin ( HOOPl ) / Cos ( HOOPl );

                       End
                     Else
                       Begin

                         R_Izo := RezPl [ NPl , 4 ] / C20 ;
                         R_Izo := Fd * Sin ( R_Izo ) / Cos ( R_Izo ) ;

                       End ;

                  End
                 Else
                  Begin

                       R_Izo := RezPl [ NPl , 4 ] / C20 ;
                       R_Izo := Fd * Sin ( R_Izo ) / Cos ( R_Izo ) ;

                       Xst := 0.0 ;
                       Yst := 0.0 ;

                  End ;

              End ; {  NPl > 0 }



            If (  NPl  In [ 0, 10, 11 ]  )    Then
                Begin

                  If ( NPl = 0 )  Then
                    Begin  { ‡ˆ–ˆ›‰ “ƒ‹ ‘…‚…ƒ ‹‘€ }
                      {
                      If ( Not B_Gal )
                        Then
                          Begin
                      }
                            {
                            If ( Abs ( CPoz ) > 1.0e-11 )
                              Then  PozNp := ArcTan ( SPoz / CPoz )
                              Else  PozNp := 0.0                    ;

                            If (  CPoz < 0.0 )  Then  PozNp := PozNp + PI  ;
                            If ( PozNp < 0.0 )  Then  PozNp := PozNp + PI2 ;
                            If ( PozNp > PI2 )  Then  PozNp := PozNp - PI2 ;

                            SPozNp := Sin   ( PozNp ) ;
                            CPozNp := Cos   ( PozNp ) ;
                            }

                            PozNp  := ATan2 ( SPoz , CPoz ) ;

                            SPozNp := SPoz ;
                            CPozNp := CPoz ;

                    End ; { ‡ˆ–ˆ›‰ “ƒ‹ ‘…‚…ƒ ‹‘€ }


                  If   ( NPl = 10 )   Then
                   Begin  { ‡ˆ–ˆ›‰ “ƒ‹ ‹“› }

                     If ( NPlOpt <> 10 )  Then
                     Begin

                        (*
                        { ‘¥«¥­®£p. ª-âë }
                        { ÜÜÜÜÜÜÜÜÜÜÜÜÜÜ }

                            SelGrCrd  ;
                           {ÄÄÄÄÄÄÄÄ}
                        *)

                      PozMon := ATan2 ( SPoz , CPoz ) ;


                      If ( NPolFix )  Then
                        Begin
                          PozMon := PozMon - PozNp ;
                          If ( PozMon < 0.0 )  Then  PozMon := PozMon + PI2 ;
                        End ;

                      PozMon := Abs ( PI2 - PozMon ) ;

                     End

                    Else

                     Begin

                      PozMon := 0.0 ;

                     End ;

                   End ; { MOON }


                  If   ( NPl = 11 )   Then
                   Begin  { ‡ˆ–ˆ›‰ “ƒ‹ ‘‹–€ }

                    If ( NPlOpt <> 11 )  Then
                     Begin

                      PozSun := ATan2 ( SPoz , CPoz ) ;

                      If ( NPolFix )  Then
                        Begin
                          PozSun := PozSun - PozNp ;
                          If ( PozSun < 0.0 )  Then
                            PozSun := PozSun + PI2 ;
                        End ;

                      PozSun := Abs ( PI2 - PozSun ) ;

                     End
                    Else
                     Begin
                      PozSun := 0.0 ;
                     End ;


                     If ( Sqrt ( C10 - Sqr ( Sh ) )  >  1.0e-10 )
                       Then
                           HSun := ArcTan ( Sh / Sqrt ( C10 - Sqr ( Sh ) ) )
                       Else
                         Begin
                           HSun := Pi / C20 ;
                           If ( Sh < 0.0 ) Then
                             HSun := - HSun ;
                         End ;


                     If ( Refr )  Then
                       HSun := HApparent ( HSun ) ;

                     ASun := ATan2 ( Sa , Ca ) ;


                   End ; { Sun }

                End ; { 0, 10, 11 }



                If ( NPl > 0 )  Then
                   Begin

                     PlanetRecord.Visible := False ;


                     If (     ( Abs ( Xst ) <= XMax          )
                          And ( Abs ( Yst ) <= YMax + R_Izo  ) )  Then
                       PlanetRecord.Visible := True ;


                     If (     ( Abs ( Yst ) <= YMax          )
                          And ( Abs ( Xst ) <= XMax + R_Izo  ) )  Then
                       PlanetRecord.Visible := True ;


                     For I := -1 To 1 Do
                       For J := -1 To 1 Do
                         Begin
                           If (     ( I <> 0 )
                                And ( J <> 0 )  )  Then
                             Begin

                               XUgol := I * XMax ;
                               YUgol := J * YMax ;

                               If ( Sqrt (   Sqr ( Xst - XUgol )
                                           + Sqr ( Yst - YUgol ) )
                                    <= R_Izo )  Then
                                 PlanetRecord.Visible := True ;

                             End ;
                         End ;


                     If ( CRo <= 0.0 )  Then
                       PlanetRecord.Visible := False ;


                     If (     ( CRo >  0.0           )
                          And ( PlanetRecord.Visible )  )  Then
                       Begin  { Xst, Yst  < X(Y)Max }

                         If ( Not NPolFix )  Then
                            PP := PP + PozNp ;
                         If ( PP > PI2    )  Then
                            PP := PP - PI2   ;

                         PlanetRecord.D_IZO :=  R_Izo * C20 ;



                         If (     ( B_Surf     )
                              And ( HPlan < 0  )
                              And ( Not B_Geoc ) )
                           Then
                             PlanetRecord.Visible := False
                           Else
                             Begin

                               If (       B_Geoc
                                    And (     ( NPl = NPl0      )
                                          And ( Not B_From_Star )  )
                                                                      )
                                 Then
                                   PlanetRecord.Visible   := False
                                 Else
                                   PlanetRecord.Visible   := True ;

                             End ;
                         (*
                         If (     ( PlanetRecord.Visible )
                              And ( NPl = 11             )
                              And ( B_Object_Tracks      )
                              {
                              And ( Sun_Izo_Track > 0    )
                              }
                                                           )  Then
                           Begin
                             {
                             Inc ( Sun_Izo_Track ) ;
                             }
                             PlanetRecord.Visible := False ;
                           End ;
                         *)

                         PlanetRecord.Nr    := NPl      ;
		         PlanetRecord.X	    := Xst      ;
		         PlanetRecord.Y	    := Yst      ;
		         PlanetRecord.R	    := RPE * AE ;
		         PlanetRecord.M	    := MVP      ;
		         PlanetRecord.Phase := FF       ;


                       End ;  { Xst, Yst  < X(Y)Max }


                     PlanetRecord.NowVisible := PlanetRecord.Visible ;

                     If  ( NPl Mod PlanetBlockSize = 0 )  Then
                       CBlockPlanet :=  NPl Div PlanetBlockSize ;

                     If (    ( PlanetAllocFlag [ CBlockPlanet ] )
                          Or ( AllocBlockPlanet                 )  )  Then
                       PlanetPtr [ NPl Div PlanetBlockSize ]^
                                 [ NPl Mod PlanetBlockSize ] :=
                                 PlanetRecord ;

                   End ; { NPl > 0 }

         End ; { FIND PlANETS }

     End ;  { PRO PlFld }

End.

