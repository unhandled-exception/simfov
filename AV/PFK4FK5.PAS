
{$O+,F+}


 UNIT PFK4FK5 ;

 INTERFACE

      PROCEDURE  FK4FK5 (  Var  Ra, Decl : Double) ;


 IMPLEMENTATION

      PROCEDURE  FK4FK5 (  Var  Ra, Decl : Double) ;

{**

     Conversion of stellar position and proper motion from the
     ---------------------------------------------------------
        standart  epoch B1950.0 to J2000.0 and vice versa.
        -------------------------------------------------

     The Astronomical Almanac, 1989, p. B42 - B43.
     Standish E.M., (1982) Astron. Astrophys., v. 115, 20-22.

     Aoki,S., Soma,M., Kinoshita,H., Inoue,K., (1983),
     Astron. Astrophys., v. 128, 263-267.


    Ra, Decl - parallax, right ascension, declination in radians,


** }


  Const

      sr   = 206264.80624709636      ;
      Pi2  =      6.283185307179586  ;

      ax   =     -1.62557e-6         ;
      ay   =     -0.31919e-6         ;
      az   =     -0.13843e-6         ;


      P11  =      0.9999256782       ;
      P12  =     -0.0111820611       ;
      P13  =     -0.0048579477       ;
      P21  =      0.0111820610       ;
      P22  =      0.9999374784       ;
      P23  =     -0.0000271765       ;
      P31  =      0.0048579479       ;
      P32  =     -0.0000271474       ;
      P33  =      0.9999881997       ;


  Var

      Sa, Ca, Sd, Cd             : Double ;
      X, Y, Z, F, FF             : Double ;
      X1, Y1, Z1                 : Double ;


  Begin { F4FK5 }

      sa := sin(Ra) ;
      ca := cos(Ra) ;

      sd := sin(Decl) ;
      cd := cos(Decl) ;

      x := ca * cd ;
      y := sa * cd ;
      z := sd ;


   { Remove the effects of the E-terms of aberration }
   { ----------------------------------------------- }

      F  := x * ax  + y * ay  + z * az + 1 ;

      x1 := F * x - ax ;
      y1 := F * y - ay ;
      z1 := F * z - az ;


         {  B1950.0 > J2000  }
         {  ---------------  }

      x  := P11*x1 + P12*y1 + P13*z1 ;
      y  := P21*x1 + P22*y1 + P23*z1 ;
      z  := P31*x1 + P32*y1 + P33*z1 ;


         { Convert to spherical coordinates }
         { -------------------------------- }

      Ra  := ArcTan ( y / x ) ;
      If ( x  < 0.0 )  Then
        Ra := Ra + Pi  ;
      If ( Ra < 0.0 )  Then
        Ra := Ra + Pi2 ;

      Cd := Sqrt (  x * x  +  y * y  ) ;
      Decl := ArcTan ( z / cd ) ;



  End ; { F4FK5 }


 END.
