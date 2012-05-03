{$O+,F+}

Unit  PRdFormt ;


 Interface
{ÜÜÜÜÜÜÜÜÜ}


   Procedure  ReadFormatImp ;


 Implementation
{ÜÜÜÜÜÜÜÜÜÜÜÜÜÜ}

   Uses PVar, PVarMenu ;


   Procedure  ReadFormatImp ;

     Var

         MExist       : Boolean        ;

         I, J, K,
         P1, P2, P3,
         Code         : Integer        ;
         FImp         : Text           ;
         S            : String [ 128 ] ;
         S1           : String [   3 ] ;

     Begin

       {$I-}
       Assign ( FImp, 'Format.Imp');
       FileMode := 0 ;
       Reset  ( FImp );
       Close  ( FImp );
       {$I+}

       If ( IOResult = 0 )  Then
         Begin

           Assign ( FImp, 'Format.Imp');
           FileMode := 0 ;
           Reset  ( FImp );

           MExist := True ;

           While Not Eof ( FImp )  Do
             Begin

               ReadLn ( FImp, S ) ;

               For I := 1 To Length ( S )  Do
                 S [ I ] := UpCase ( S [ I ] ) ;

               P1 := 0 ;
               P2 := 0 ;

               While (     ( S [ 1 ] = ' '    )
                       And ( Length ( S ) > 0 )  )   Do
                 Delete ( S, 1, 1 ) ;


               Case S [ 1 ]  Of

                 'R' :  Begin
                          P1 := Pos ( '-', S ) ;
                          P1 := Pos ( 'S', S ) ;
                          If (     ( P1 > 0 )
                               And ( P2 > 0 )  )  Then
                          FormatImport [ 1 ] := 0 ;
                        End ;

                 'D' :  Begin
                          P1 := Pos ( '-', S ) ;
                          P1 := Pos ( 'S', S ) ;
                          If (     ( P1 > 0 )
                               And ( P2 > 0 )  )  Then
                          FormatImport [ 2 ] := 0 ;
                        End ;

                 'P' :  Begin
                          P1 := Pos ( 'S', S ) ;
                          If ( P1 = 0 )
                            Then  FormatImport [ 3 ] :=   1
                            Else  FormatImport [ 3 ] := - 1 ;
                          P1 := Pos ( 'E', S ) ;
                          If ( P1 = 0 )
                            Then  FormatImport [ 6 ] := 0
                            Else  FormatImport [ 6 ] := 1 ;
                        End ;

                 'M' :  Begin
                          If ( Pos ( '-', S ) > 0 )  Then
                            MExist := False ;
                        End ;

                 'N' :  Begin

                          While (     ( S [ 1 ] <> ' '   )
                                  And ( Length ( S ) > 0 )  )   Do
                            Delete ( S, 1, 1 ) ;

                          While (     ( S [ 1 ] = ' '    )
                                  And ( Length ( S ) > 0 )  )   Do
                            Delete ( S, 1, 1 ) ;

                          If ( Length ( S ) = 0 )
                            Then
                              Begin { –¨äp®¢®© ­®¬¥p }
                                FormatImport [ 5 ] :=  0 ;
                                FormatImport [ 6 ] :=  0 ;
                              End
                            Else
                              Begin { ‘¨¬¢®«ì­ë© ­®¬¥p }

                                S1 := '' ;

                                While (     ( S [ 1 ] <> ' '   )
                                        And ( Length ( S ) > 0 )  )   Do
                                  Begin
                                    S1 := S1 + S [ 1 ] ;
                                    Delete ( S, 1, 1 ) ;
                                  End ;

                                Val ( S1, P1, Code ) ;
                                If  ( Code <> 0 )  Then
                                  P1 := 0 ;


                                While (     ( S [ 1 ] = ' '    )
                                        And ( Length ( S ) > 0 )  )   Do
                                  Delete ( S, 1, 1 ) ;


                                S1 := '' ;

                                While (     ( S [ 1 ] <> ' '   )
                                        And ( Length ( S ) > 0 )  )   Do
                                  Begin
                                    S1 := S1 + S [ 1 ] ;
                                    Delete ( S, 1, 1 ) ;
                                  End ;

                                Val ( S1, P2, Code ) ;
                                If  ( Code <> 0 )  Then
                                  P2 := 10 ;

                                FormatImport [ 5 ] := P1 ;
                                FormatImport [ 6 ] := P2 ;

                              End ;

                        End ;

                 'G' :  Begin
                          FormatImport [ 8 ] := 1 ;
                        End ;

               End ; { Case }

             End ; { While Not Eof  FInp )  }


           If ( Not MExist )   Then
             Begin
               FormatImport [ 4 ] :=  0            ;
               Param.DMvDet       := 25            ;
               DMvDet             := Param.DMvDet  ;
             End ;


           Close  ( FImp );

         End ;

       FileMode := 2 ;

     End;

 End.