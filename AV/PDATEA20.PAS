
{$O+,F+}

 Unit  PDateA20 ;


  Interface

    Uses  PVar ;

    Procedure DateA20 ( S19 : S19Type ; Var S9 : S9Type ) ;


  Implementation

    Uses   PJd8, PDayJd, Dos ;

    Procedure DateA20 ( S19 : S19Type ; Var S9 : S9Type ) ;

      Const

        NameMonth : Array [ 1 .. 12 ] Of String [ 3 ] =
          (
            'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
            'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
          ) ;


      Var

        N1                    : Integer ;

        Year, Month           : LongInt ;

        Jd, JdB, JdR, Day     : Double  ;

        t, SMonth             : String  ;

      Begin

        t := '' ;
        For N1 := 1 To 2 Do
        t := t + S19.S19 [ N1 ] ;
        Val ( t, Day, Code ) ;

        SMonth := '' ;
        For N1 := 4 To 6 Do
          SMonth := SMonth + S19.S19 [ N1 ] ;
        Month := 1 ;
        While     ( SMonth <> NameMonth [ Month ] )
              And ( Month  <  12                  )  Do
          Inc ( Month ) ;

        t := '' ;
        For N1 := 8 To 9 Do
          t := t + S19.S19 [ N1 ] ;
        Val ( t, Year, Code ) ;
        Year := Year + 1900 ;

        Jd8 ( Year, Month, Day, JdB ) ;

        t := '' ;
        For N1 := 11 To 12 Do
        t := t + S19.S19 [ N1 ] ;
        Val ( t, Day, Code ) ;

        SMonth := '' ;
        For N1 := 14 To 16 Do
          SMonth := SMonth + S19.S19 [ N1 ] ;
        Month := 1 ;
        While     ( SMonth <> NameMonth [ Month ] )
              And ( Month  <  12                  )  Do
          Inc ( Month ) ;

        t := '' ;
        For N1 := 18 To 19 Do
          t := t + S19.S19 [ N1 ] ;
        Val ( t, Year, Code ) ;
        Year := Year + 1900 ;

        Jd8 ( Year, Month, Day, JdR ) ;


        Jd := ( JdB + JdR - 1.0 ) / 2.0 + 0.5 ;

        DayJd ( Jd, Year, Month, Day ) ;

        Str ( Round ( Day ) : 2, t ) ;
        For N1 := 1 To 2 Do
          S9.S9 [ N1 ] := t [ N1 ] ;

        t := NameMonth [ Month ] ;
        For N1 := 1 To 3 Do
          S9.S9 [ N1 + 3 ] := t [ N1 ] ;

        Str ( ( Year - 1900 ) : 2, t ) ;
        For N1 := 1 To 2 Do
          S9.S9 [ N1 + 7 ] := t [ N1 ] ;

        S9.S9 [  3 ] := ' ' ;
        S9.S9 [  7 ] := ' ' ;

      End ;

 End.