
     Program  PerGSCFot ;
    {******************}

{ ********************
1858258+8846570822+107
1958009+8840061047+042
1851305+8839551117+053
1851421+8835191182+051
1905297+8840331248+127
1926076+8836551307+060
1919306+8838261308+140

0037516+8457460955+050
0039139+8449421076+062
 *********************}

 Var

    InpStr    : String  ;
    OutStr    : String  ;
    SS        : String  ;

    I         : Integer ;

    InpFile   : Text ;
    OutFile   : Text ;


  Begin

    Assign  ( InpFile , 'D:\catalog\Gsc_Fot\Gsc_Fot.Nes' ) ;
    Assign  ( OutFile , 'D:\catalog\Gsc_Fot\Gsc_Fot.Dat' ) ;

    Reset   ( InpFile ) ;
    ReWrite ( OutFile ) ;


    While ( Not Eof ( InpFile ) )  Do

      Begin

        ReadLn ( InpFile , InpStr ) ;

        If ( Length ( InpStr ) < 3 )  Then

          Begin  { γαβ ο αβp®ª  }
                 { ------------- }

            OutStr := InpStr ;

          End

         Else

          Begin

            SS := Copy ( InpStr , 1, 2 ) ;  OutStr :=          SS + ' '  ;
            SS := Copy ( InpStr , 3, 2 ) ;  OutStr := OutStr + SS + ' '  ;
            SS := Copy ( InpStr , 5, 2 ) ;  OutStr := OutStr + SS + '.' +
                                                      InpStr [7]  + '  ' ;

            OutStr := OutStr + InpStr [ 8 ] ;

            SS := Copy ( InpStr ,  9, 2 ) ;  OutStr := OutStr + SS + ' '  ;
            SS := Copy ( InpStr , 11, 2 ) ;  OutStr := OutStr + SS + ' '  ;
            SS := Copy ( InpStr , 13, 2 ) ;  OutStr := OutStr + SS + '  ' ;

            SS := Copy ( InpStr , 15, 2 ) ;  OutStr := OutStr + SS + '.'  ;
            SS := Copy ( InpStr , 17, 2 ) ;  OutStr := OutStr + SS + ' '  ;


            SS := Copy ( InpStr , 19, 2 ) ;  OutStr := OutStr + SS + '.'  ;
            SS := Copy ( InpStr , 21, 2 ) ;  OutStr := OutStr + SS        ;


          End ;

        Writeln ( OutFile , OutStr ) ;


      End ;  { While Not Eof }
             { ------------- }

    Close ( InpFile ) ;
    Close ( OutFile ) ;

  End.