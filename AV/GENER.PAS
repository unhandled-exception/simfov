

         Program  GeneratorSatellits ;
        {ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ}

 Uses Dos ;

(*
       1      Œ… ˆ‘‡
       3      H®¬¥p æ¥­âp «ì­®© ¯« ­¥âë
    5 24 91   ŒŒ…H’ ‡€„€HˆŸ ‹…Œ…’‚ :   Œ…‘Ÿ–  —ˆ‘‹     ƒ„
 13 23 37.56  ŒŒ…H’ ‡€„€HˆŸ ‹…Œ…’‚ :    —€‘   ŒˆH“’€  ‘…Š“H„€
   19000      ‚›‘’€ €ƒ…Ÿ  ( H AP )                                (   KM   )
   18500      ‚›‘’€ …ˆƒ…Ÿ                                         (   KM   )
      65      €Š‹ ˆ’› Š Š‚€’“                               ( ƒ€„“‘ )
      37      ŸŒ… ‚‘•. ‚‘•„Ÿ™…ƒ “‡‹€                          ( ƒ€„“‘ )
      10      €ƒ“Œ…H’  …ˆƒ…Ÿ                                      ( ƒ€„“‘ )
       0      €ƒ“Œ…H’  ˜ˆ’›                                       ( ƒ€„“‘ )
       5.0    ŸŠ‘’œ ‚…•H‘’ˆ ˆ‘‡  ‚ ‡€„€HHŒ ‘…Š’. „ˆ€.   ( W/(M*M)/‘p)
       5      ””. ‹™€„œ ‚…•H‘’ˆ ˆ‘‡                           ( M * M  )
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


       { ‚ëá®ª¨¥ }
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



       { ‘â æ¨®­ pë }
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
