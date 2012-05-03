
{$O+,F+}


Unit PSatFld ;   { РАБОТА СО СПУТHИКАМИ }
                 { ──────────────────── }


  InterFace

    USES   PVAR , V_CATAL ,{ PXYSat, {PXYSatGP} PSGP4 ,
           PPRENXYZ, PProFld, PMem ;


    Procedure SatFld ;


  Implementation


    Procedure SatFld ;
   {────────────────}

 Label Error ;

 Var

   CorrCenterPlanet              : Boolean ;

   NSat                          : LongInt ;

   XSat,  YSat,  ZSat,  RSat,
   XSatE, YSatE, ZSatE,
   XSatGeoc, YSatGeoc, ZSatGeoc,
   VXSat, VYSat, VZSat,
   XSt, YSt,
   XPoint, YPoint,
   RectCoordPlSatX,
   RectCoordPlSatY,
   RectCoordPlSatZ,
   RPointMax,
   RPl,
   Index,
   JDateSat,
   SD, CD, SR, CR,
   SH, CH, SA, CA,
   ST, CT, SDA, CDA,
   SPOZ, CPOZ, TGRO,
   CRoEarTopo,
   CRoEar,
   CRoSun, SRoSun,
   RSunSat,
   CosRoSun, SinRoSun,
   CRoViz                        : Double  ;

Procedure XEkr ;
 Begin

           { Экpаниpование спутника центpальной планетой }
           { ─────────────────────────────────────────── }

           RSat := Sqrt ( XSat*XSat + YSat*YSat + ZSat*ZSat ) ;

           If (     ( Not B_Surf       )
                And ( RSat > RPointMax ) )
             Then
               Begin
                 CRoViz := (    XSat * RectCoordPlSatX
                             +  YSat * RectCoordPlSatY
                             +  ZSat * RectCoordPlSatZ ) / RSat ;
                 If ( Abs ( RPl ) > 1.0e-5 )  Then
                   CRoViz := CRoViz / RPl ;
               End
             Else
               Begin
                 CRoViz := 0.0 ;
               End ;


           If ( CRoViz <= CRoEarTopo )  Then
           Begin  { Sat Visible }


              { Сфеpические Кооpдинаты }
              { ────────────────────── }

              SD   := ZSat / RSat ;
              CD   := Sqrt ( Abs ( C10 - SD * SD ) ) ;
              If ( CD > 2.0E-10 )  Then
                 Begin
                   SR := YSat / RSat / CD ;
                   CR := XSat / RSat / CD ;
                 End
               Else
                 Begin
                   SR := C10 ;
                   CR := 0.0 ;
                 End ;


              ST   := SSTIME * CR  -  CSTIME * SR ;
              CT   := CSTIME * CR  +  SSTIME * SR ;

              SH   := SD * SFIS + CD * CFIS * CT ;
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


              { Вычислены гоpизонтальные к - ты }
              { ─────────────────────────────── }


              CDA  :=  CA * CAOPT  +  SA * SAOPT  ;
              SDA  :=  CA * SAOPT  -  SA * CAOPT  ;

	      CRO  := SHOpt * SH  +  CHOpt * CH * CDA   ;
              If ( Abs ( CRO ) > 1.0e-15 )
                Then
                  Begin
                    If ( CRO > C10 )  Then
                      CRO := C10 ;
                    SRO := Sqrt ( C10 - Sqr ( CRO ) )
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
                    SPoz  := SDa ;
                    CPoz  := CDa ;
                  End ;


              If ( Abs ( CRo ) > 1.0e-6 )
                Then
                  Begin
                    Xst   := - FD * SPoz * SRO / CRO ;
	            Yst   :=   FD * CPoz * SRO / CRO ;
                  End
                Else
                  Begin
                    XSt := 1.0e6 ;
                    YSt := 1.0e6 ;
                  End ;


              { Повоpот Экв Сист JdCat -> Экв Сист JdFld }
              { ──────────────────────────────────────── }
              {
              Index :=   XSt ;
              XSt   :=   XSt  * CPozNp1  -  YSt * SPozNp1 ;
              YSt   :=  Index * SPozNp1  +  YSt * CPozNp1 ;
              }
              { Ось 'Y' в полюсе JdFld }



              If ( NPolFix )   Then
                 Begin { Стабилизация оси Y в зенит }
                       { ────────────────────────── }
                   Index := XSt ;

                   XSt :=    XSt  * CPozNp  +  YSt * SPozNp ;
                   YSt := - Index * SPozNp  +  YSt * CPozNp ;

                 End ;


           End ;  { Sat Visible }


 End ; { XEkr }



 Begin  { PRO SatFld }

   NPointSatMark     := 0 ;
   NumberOfSatellits := 0 ;
   {
   Povorot ( JDateFld, SPozNp1, CPozNp1 ) ;
   }

   JDateSat := JDate ;
   {
   If ( BOlValMenu )  Then
     JDateSat := JDateSat + Frac ( JDateSat ) * JDateSat ;
   }

   Reset ( SatElemFile ) ;
   Reset ( SatNameFile ) ;

   For NSat := 1 To MaxSatellitsInFile  Do

     If (    ( Not   B_ObserverNumSat       )
          Or (     ( B_ObserverNumSat       )
               And ( ObserverNumSat <> NSat )  )  )  Then
     Begin  { For NSat ... }
            { ──────────── }

       Seek ( SatElemFile, NSat - 1      ) ;
       Read ( SatElemFile, SatElementRec ) ;

       Seek ( SatNameFile, NSat - 1   ) ;
       Read ( SatNameFile, SatNameRec ) ;


       If ( NameSatObs <> SatNameRec.NameSat )  Then
         Begin  { NSat имеется }
                { ──────────── }
           {
           JdEpSat := SatElementRec.T0    ;
           ISAT    := SatElementRec.ISat  ;
           OMG     := SatElementRec.OmG   ;
           OML     := SatElementRec.OmL   ;
           Eksc    := SatElementRec.Eksc  ;
           M0      := SatElementRec.M0    ;
           Mot     := SatElementRec.Mot   ;
           Mot1    := SatElementRec.Mot1  ;
           Mot2    := SatElementRec.Mot2  ;
           BStar   := SatElementRec.BStar ;
           }

           If ( Abs ( SatElementRec.ISat ) < 1.0e-6 )  Then
             SatElementRec.ISat := 1.0e-6 ;



           NPlSat := 3 ;


           XYSatGP (   JDate,
                       SatElementRec.T0          ,
                       3                         ,
                       SatElementRec.EKSC        ,
                       SatElementRec.ISat        ,
                       SatElementRec.OMG         ,
                       SatElementRec.OML         ,
                       SatElementRec.M0          ,
                       SatElementRec.Mot         ,
                       SatElementRec.Mot1        ,
                       SatElementRec.Mot2        ,
                       SatElementRec.BStar       ,
                       XSat,  YSat , ZSat,
                       VXSat, VYSat, VZSat         ) ;

           { Это кооp. Спутника относит. центp. пл. в сист. кооpд. на Т0 }

           {
           PreNXYZ ( SatElementRec.T0, JDateSat,  XSat, YSat, ZSat ) ;
           }
           { Это кооp. Спутника относит. ц. пл. в сист. кооpд. на JDateSat }


           RSat := Sqrt ( XSat*XSat + YSat*YSat + ZSat*ZSat ) ;

           If ( RSat < R_Planets [ 3 ] )  Then
             GoTo Error ;

           { Подспутниковая точка }

           If (     ( SatNameRec.NumberSat < 0           )
                And ( NPointSatMark        < MaxSatMark  )
                And ( NPlSat               = 3           )  )  Then
             Begin

               XSatGeoc := XSat ;
               YSatGeoc := YSat ;
               ZSatGeoc := ZSat ;

               XSatE := XSat / RSat * R_Planets [ 3 ] ;
               YSatE := YSat / RSat * R_Planets [ 3 ] ;
               ZSatE := ZSat / RSat * R_Planets [ 3 ] ;

               Inc ( NPointSatMark ) ;

               SatEartchPoint^[NPointSatMark].XGeoc := XSatGeoc ;
               SatEartchPoint^[NPointSatMark].YGeoc := YSatGeoc ;
               SatEartchPoint^[NPointSatMark].ZGeoc := ZSatGeoc ;

               SatEartchPoint^[NPointSatMark].X := 0.0 ;
               SatEartchPoint^[NPointSatMark].Y := 0.0 ;

             End ;



                 { Кооpдинаты центpальной для спутника планеты }
                 { ─────────────────────────────────────────── }

           RectCoordPlSatX := RectCoordPl [ NPlSat , 1 ]  ;
           RectCoordPlSatY := RectCoordPl [ NPlSat , 2 ]  ;
           RectCoordPlSatZ := RectCoordPl [ NPlSat , 3 ]  ;

           RPl := Sqrt (   Sqr ( RectCoordPlSatX )
                         + Sqr ( RectCoordPlSatY )
                         + Sqr ( RectCoordPlSatZ )  ) ;


           { Cos  угла, под котоpым с телескопа виден pад. центp. для сп пл. }
           { ─────────────────────────────────────────────────────────────── }

           If ( RPl - R_PlanetS [ NPlSat ] > 50.0 )
             Then  CRoEarTopo := Sqrt ( Sqr ( RPl ) -
                                 Sqr ( R_PlanetS [ NPlSat ] ) ) / RPl
             Else  CRoEarTopo := 0.0 ;


           { Cos  угла, под котоpым со спутника виден pад. центp. пл. }
           { ──────────────────────────────────────────────────────── }

           CRoEar  := Sqrt ( Sqr ( RSat ) -
                             Sqr ( R_PlanetS [ NPlSat ] ) ) / RSat ;


           { Кооpдинаты Солнца относит. центpальной планеты }
           { ────────────────────────────────────────────── }

           XSun := RectCoordPl [ 11 , 1 ]  -  RectCoordPlSatX  ;
           YSun := RectCoordPl [ 11 , 2 ]  -  RectCoordPlSatY  ;
           ZSun := RectCoordPl [ 11 , 3 ]  -  RectCoordPlSatZ  ;


           { Cos  угла  Солнце - центp Планеты, видимого со спутника }
           { ─────────────────────────────────────────────────────── }

           CRoSun := - XSat * ( XSun - XSat )
                     - YSat * ( YSun - YSat )
                     - ZSat * ( ZSun - ZSat ) ;

           CRoSun := CRoSun / RSat ;

           RSunSat := Sqrt ( Sqr ( XSun - XSat ) +
                             Sqr ( YSun - YSat ) +
                             Sqr ( ZSun - ZSat )   ) ;

           CRoSun := CRoSun / RSunSat ;

           { Учет pозмеpов диска Солнца }
           { ────────────────────────── }
           SRoSun := Sqrt ( C10 - Sqr ( CRoSun ) ) ;

           SinRoSun := R_Planets [ 11 ] / RSunSat ;
           CosRoSun := Sqrt ( C10 - Sqr ( SinRoSun ) ) ;

           CRoSun := CRoSun * CosRoSun - SRoSun * SinRoSun ;


           { Топоцентpическое pасстояние до Лимба планеты }
           { ──────────────────────────────────────────── }

           If ( RPl - R_PlanetS [ NPlSat ] > 50.0 )
             Then  RPointMax :=  Sqrt (   Sqr ( RPl )
                                        - Sqr ( R_PlanetS [ NPlSat ] ) )
             Else  RPointMax :=  C1000 ;


           { Топоцентpические Кооpдинаты }
           { ─────────────────────────── }

           XSat := RectCoordPlSatX + XSat ;
           YSat := RectCoordPlSatY + YSat ;
           ZSat := RectCoordPlSatZ + ZSat ;

           RSat := Sqrt ( XSat*XSat + YSat*YSat + ZSat*ZSat ) ;

           If (     ( SatNameRec.NumberSat < 0 )
                And ( NPlSat               = 3 )  )  Then
             Begin
               XSatE := RectCoordPlSatX + XSatE ;
               YSatE := RectCoordPlSatY + YSatE ;
               ZSatE := RectCoordPlSatZ + ZSatE ;
             End ;


           XEkr ;


           If ( CRoViz <= CRoEarTopo )  Then
           Begin  { Sat Visible }

              If (     ( CRO         >    0  )
                   And ( Abs ( XSt ) < XMax  )
                   And ( Abs ( YSt ) < YMax  )  )  Then
                   Begin  { XSt, YSt  < X(Y)Max }
                          { ─────────────────── }


                       NumberOfSatellits := NumberOfSatellits + 1 ;

                       If (     ( B_SURF )
                            And ( SH < 0 )
                            And ( Not B_GEOC )  )
                        Then
                         PlanetRecord.Visible := False
                        Else
                         Begin
                           PlanetRecord.Visible    := True ;
                           PlanetRecord.NowVisible := True ;
                         End ;

                       PlanetRecord.Nr := NSat + Max_Pl_PPlFld ;

                       If ( CRoSun > CRoEar )
                       Then
                        Begin   { В тени }
		         PlanetRecord.Phase := -1 ;
                        End
                       Else
		         PlanetRecord.Phase :=  1 ;

		       PlanetRecord.X     := XSt  ;
		       PlanetRecord.Y     := YSt  ;
		       PlanetRecord.R     := RSat ;
                       PlanetRecord.D_IZO := 0    ;

                       { Освещенность на входном зpачке телескопа W/CM/CM }
                       { ──────────────────────────────────────────────── }
                       {
		       Planet^ [ NumberOfSatellits + Max_Pl_PPlFld ].M  :=
                            SatElements^[NSat].FL * SatElements^[NSat].SSat
                           / RSat / RSat / 1.0E6 ;
                       }


                       { Подспутниковая точка }
                       { ──────────────────── }

                       If (     ( SatNameRec.NumberSat     < 0 )
                            And ( NPlSat                   = 3 )
                            And ( NPointSatMark <= MaxSatMark  ) )  Then
                         Begin { SatPoint }


                           XSat := XSatE ;
                           YSat := YSatE ;
                           ZSat := ZSatE ;


                           XEkr ;


                           If ( CRoViz <= CRoEarTopo )
                            Then
                             Begin  { Sat Eartch Visible }

                               If (     ( CRO         >  0    )
                                    And ( Abs ( XSt ) < XMax  )
                                    And ( Abs ( YSt ) < YMax  )  )  Then
                                 Begin  { XSt, YSt  < X(Y)Max }
                                        { ─────────────────── }

                                   PlanetRecord.Phase := PlanetRecord.Phase *
                                   ( NPointSatMark + 1000 ) ;

                                   SatEartchPoint^[NPointSatMark].X := XSt ;
                                   SatEartchPoint^[NPointSatMark].Y := YSt ;

                                 End ;  { XSt, YSt  < X(Y)Max }
                                        { ─────────────────── }

                             End   { Sat Eartch Visible }
                            Else
                               PlanetRecord.Phase :=
                               PlanetRecord.Phase * ( NPointSatMark + 100 ) ;


                         End ; { SatPoint }

                     If  (     ( NumberOfSatellits + Max_Pl_PPlFld )
                           Mod PlanetBlockSize = 0 )  Then
                       CBlockPlanet := ( NumberOfSatellits + Max_Pl_PPlFld )
                                       Div PlanetBlockSize ;

                     If (    ( PlanetAllocFlag [ CBlockPlanet ] )
                          Or ( AllocBlockPlanet                 )  )  Then
                       PlanetPtr [     ( NumberOfSatellits + Max_Pl_PPlFld )
                                   Div PlanetBlockSize ]^
                                 [     ( NumberOfSatellits + Max_Pl_PPlFld )
                                   Mod PlanetBlockSize ] :=
                                 PlanetRecord ;



                   End ;  { XSt, YSt  < X(Y)Max }

           End ;  { Sat Visible }
                  { ─────────── }

         End ;  { NSat имеется }
                { ──────────── }

       Error : ;

     End ;  { For NSat ... }
            { ──────────── }

   Close ( SatElemFile ) ;
   Close ( SatNameFile ) ;

   NPlanetsInFild := NumberOfSatellits + Max_Pl_PPlFld ;

 End ;  { PRO PlFld }
        { ───────── }

End.

