{$O+,F+}

Unit  PRdSat ;


 Interface
{‹‹‹‹‹‹‹‹‹}


   Procedure  ReadSatFile ;


 Implementation
{‹‹‹‹‹‹‹‹‹‹‹‹‹‹}

   Uses PVar, PJd8, Dos ;


   Procedure  ReadSatFile ;

     Var
         Year         : Integer        ;
         Day, T0      : Double         ;

         II           : LongInt        ;
         I, J, K,
         Code         : Integer        ;
         FInp         : Text           ;
         NameFInp     : String [  24 ] ;

         S, t,
         S1, S2, S3   : String [ 128 ] ;

         NameFile     : SearchRec      ;

     Begin

       FSplit ( SatFileName, DStr, NStr, EStr );


       Assign ( SatElemFile , SatElementFileName   ) ;
       Assign ( SatNameFile , SatNameFileName      ) ;

       ReWrite ( SatElemFile ) ;
       ReWrite ( SatNameFile ) ;

       MaxSatellitsInFile := 0 ;

       FindFirst ( SatFileName, AnyFile, NameFile ) ;
       While ( DosError = 0 ) Do
         Begin

           If NameFile.Attr And Directory <> 0 Then
             Begin
               FindNext ( NameFile );
               Continue;
             End;

           NameFInp := NameFile.Name ;

           FileMode := 0 ;

           Assign ( FInp, DStr + NameFInp ) ;
           Reset  ( FInp );

           While ( Not ( Eof ( FInp ) ) )  Do
             Begin { Read Str Inp }


               ReadLn ( FInp, S1 ) ;
               ReadLn ( FInp, S2 ) ;
               ReadLn ( FInp, S3 ) ;

               SatElementRec.NSat := MaxSatellitsInFile ;

                    { Names }
                    { ƒƒƒƒƒ }


               S := Copy ( S2, 3, 5 )     ;
               Val ( S, II, Code )        ;
               SatNameRec.NumberSat := II ;


               While (     ( Length ( S1 )        >  0  )
                       And ( S1 [ Length ( S1 ) ] = ' ' )  )  Do
                 Begin
                   If ( S1 [ Length ( S1 ) ] = ' ' )  Then
                     Delete ( S1, Length ( S1 ), 1 ) ;
                 End ;

               If ( S1 [ 1 ] = '*' )  Then
                 Begin { ØÆ¨•Á•≠Î© ·Ø„‚≠®™ }
                   SatNameRec.NumberSat := - SatNameRec.NumberSat ;
                   Delete ( S1, 1, 1 ) ;
                   While (     ( S1 [ 1 ]      = ' ' )
                           And ( Length ( S1 ) >  1  )  )  Do
                     Delete ( S1, 1, 1 ) ;
                 End ;

               For I := 1 To Length ( S1 ) Do
                 S1 [ I ] := UpCase ( S1 [ I ] ) ;

               SatNameRec.NameSat := S1 ;


               S := Copy ( S2, 10, 8 ) ;
               While (     ( Length ( S )       >  0  )
                       And ( S [ Length ( S ) ] = ' ' )  )  Do
                 Begin
                   If ( S [ Length ( S ) ] = ' ' )  Then
                     Delete ( S, Length ( S ), 1 ) ;
                 End ;

               For I := 1 To Length ( S ) Do
                 S [ I ] := UpCase ( S [ I ] ) ;

               SatNameRec.InternDes := S ;



                   { Epoc }
                   { ƒƒƒƒ }

               S := Copy ( S2, 19, 2 ) ;
               Val ( S, Year, Code ) ;

               If ( Year < 50 )
                 Then Year := 2000 + Year
                 Else Year := 1900 + Year ;

               Jd8 ( Year, 1, 0, T0 ) ;

               S := Copy ( S2, 21, 12 ) ;
               Val ( S, Day, Code ) ;

               T0 := T0 + Day ;

               SatElementRec.T0 := T0 ;


                  { dMot/dT }
                  { ƒƒƒƒƒƒƒ }

               S := Copy ( S2, 34, 10 ) ;
               If ( S [ 2 ] = ' ' )  Then
                 S [ 2 ] := '0' ;
               Val ( S, Mot1, Code ) ;
               SatElementRec.Mot1 := Mot1 * 360.0 / RG ;


                  { dMot/dT2 }
                  { ƒƒƒƒƒƒƒƒ }

               S := Copy ( S2, 45, 8 ) ;
               If ( S [ 1 ] = ' ' )  Then
                 S [ 1 ] := '.' ;
               S := '0' + S ;
               Insert ( 'e', S, Pos ( '-', S ) ) ;
               Val ( S, Mot2, Code ) ;
               SatElementRec.Mot2 := Mot2 * 360.0 / RG  ;



                  { BStar }
                  { ƒƒƒƒƒ }

               S := Copy ( S2, 54, 8 ) ;
               If ( S [ 1 ] = ' ' )  Then
                 S [ 1 ] := '.' ;
               S := '0' + S ;
               Insert ( 'e', S, Pos ( '-', S ) ) ;
               Val ( S, BStar, Code ) ;
               SatElementRec.BStar := BStar ;


                 { Inclination }
                 { ƒƒƒƒƒƒƒƒƒƒƒ }

               S := Copy ( S3, 9, 8 ) ;
               Val ( S, ISat, Code ) ;
               SatElementRec.ISat := ISat / RG ;



                 { R.A.Node }
                 { ƒƒƒƒƒƒƒƒ }

               S := Copy ( S3, 18, 8 ) ;
               Val ( S, OmG, Code ) ;
               SatElementRec.OmG := OmG / RG ;



                 { Excentr. }
                 { ƒƒƒƒƒƒƒƒ }

               S := Copy ( S3, 27, 7 ) ;
               S := '0.' + S ;
               Val ( S, Eksc, Code ) ;
               SatElementRec.Eksc := Eksc ;



                 { Arg of Per }
                 { ƒƒƒƒƒƒƒƒƒƒ }

               S := Copy ( S3, 35, 8 ) ;
               Val ( S, OmL, Code ) ;
               SatElementRec.OmL := OmL / RG ;



                 { Mean Anomaly }
                 { ƒƒƒƒƒƒƒƒƒƒƒƒ }

               S := Copy ( S3, 44, 8 ) ;
               Val ( S, M0, Code ) ;
               SatElementRec.M0 := M0 / RG ;



                 { Mean Motion }
                 { ƒƒƒƒƒƒƒƒƒƒƒ }

               S := Copy ( S3, 53, 11 ) ;
               Val ( S, Mot, Code ) ;
               SatElementRec.Mot := Mot * 360.0 / RG ;

               If ( Abs ( SatElementRec.Mot1 ) < 0.9 )  Then
                 Begin

                   Write ( SatElemFile, SatElementRec  ) ;
                   Write ( SatNameFile, SatNameRec     ) ;

                   Inc ( MaxSatellitsInFile ) ;

                 End ;

             End ; { Read Str Inp }

           Close ( FInp );
           FileMode := 2 ;

           FindNext ( NameFile ) ;

         End ;

       Close ( SatElemFile ) ;
       Close ( SatNameFile ) ;


     End;

 End.