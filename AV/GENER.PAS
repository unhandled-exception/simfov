

         Program  GeneratorSatellits ;
        {ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ}

 Uses Dos ;

(*
       1       
       3      H®¬¥p æ¥­âp «ì­®© ¯« ­¥âë
    5 24 91   H H  :          
 13 23 37.56  H H  :       H  H
   19000         ( H AP )                                (   KM   )
   18500                                                (   KM   )
      65                                        (  )
      37       .                            (  )
      10      H                                        (  )
       0      H                                         (  )
       5.0     H    HH . .   ( W/(M*M)/p)
       5      .  H                            ( M * M  )
*)
 Var
   SatFile     : Text ;
   NSat, I     : Integer ;

Begin

  Assign  ( SatFile, 'SatDat.Gen' ) ;
  Rewrite ( SatFile               ) ;
  NSat := 0 ;


        { H¨§ª¨¥ }
        { ÄÄÄÄÄÄ }

  For  I := 1  To  500 Do
    Begin

      Inc ( NSat ) ;

      Writeln ( SatFile , NSat : 13 ) ;
      Writeln ( SatFile , '': 12, '3' ) ;
      Writeln ( SatFile , ' 05  12  1994' ) ;
      Writeln ( SatFile , ' 00  00  00.0' ) ;
      Writeln ( SatFile , 500 + 100 * Random : 13 : 1 ) ;
      Writeln ( SatFile , 300 + 100 * Random : 13 : 1 ) ;

      Writeln ( SatFile ,        90 * Random : 13 : 1 ) ;
      Writeln ( SatFile ,       360 * Random : 13 : 1 ) ;
      Writeln ( SatFile ,       360 * Random : 13 : 1 ) ;
      Writeln ( SatFile ,       360 * Random : 13 : 1 ) ;

      Writeln ( SatFile ,   3 +   4 * Random : 13 : 1 ) ;
      Writeln ( SatFile ,   3 +  10 * Random : 13 : 1 ) ;

    End ;


       { ëá®ª¨¥ }
       { ÄÄÄÄÄÄÄ }

  For  I := 1  To  300 Do
    Begin

      Inc ( NSat ) ;

      Writeln ( SatFile , NSat : 13 ) ;
      Writeln ( SatFile , '': 12, '3' ) ;
      Writeln ( SatFile , ' 05  12  1994' ) ;
      Writeln ( SatFile , ' 00  00  00.0' ) ;
      Writeln ( SatFile ,1000 + 6000 * Random : 13 : 1 ) ;
      Writeln ( SatFile , 500 +  100 * Random : 13 : 1 ) ;

      Writeln ( SatFile ,        90 * Random : 13 : 1 ) ;
      Writeln ( SatFile ,       360 * Random : 13 : 1 ) ;
      Writeln ( SatFile ,       360 * Random : 13 : 1 ) ;
      Writeln ( SatFile ,       360 * Random : 13 : 1 ) ;

      Writeln ( SatFile ,   3 +   4 * Random : 13 : 1 ) ;
      Writeln ( SatFile ,   3 +  10 * Random : 13 : 1 ) ;

    End ;



       { â æ¨®­ pë }
       { ÄÄÄÄÄÄÄÄÄÄ }

  For  I := 1  To  200 Do
    Begin

      Inc ( NSat ) ;

      Writeln ( SatFile , NSat : 13 ) ;
      Writeln ( SatFile , '': 12, '3' ) ;
      Writeln ( SatFile , ' 05  12  1994' ) ;
      Writeln ( SatFile , ' 00  00  00.0' ) ;
      Writeln ( SatFile , 36786.12 : 13 : 2 ) ;
      Writeln ( SatFile , 36786.12 : 13 : 2 ) ;

      Writeln ( SatFile ,         2 - 4 * Random : 13 : 1 ) ;
      Writeln ( SatFile ,       360 * Random : 13 : 1 ) ;
      Writeln ( SatFile ,       360 * Random : 13 : 1 ) ;
      Writeln ( SatFile ,       360 * Random : 13 : 1 ) ;

      Writeln ( SatFile ,   3 +   4 * Random : 13 : 1 ) ;
      Writeln ( SatFile ,   3 +  10 * Random : 13 : 1 ) ;

    End ;



  Close ( SatFile ) ;

End.
