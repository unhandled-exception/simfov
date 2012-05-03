
{$O+,F+}


Unit PPlInfo ;

InterFace

  Uses

   V_Catal, Graph ;

  Procedure NoOpticsData ;
  Procedure PlInfo ( Item, Class : Integer ; Point : PointType  ) ;

Implementation

  Uses


   Crt,  Screen, PObjOut, PProFld,
   PVar, Pe_Cns, PPreNew, PVarName, PGalEkv, Info  ;

  Const

   bc        = lightgray ;
   fc        = black     ;




  Procedure NoOpticsData;
    Begin
      PutS ( Opt_w.wnd , True, bc, fc, RightText , CenterText, '' ) ;
      PutS ( ras_w.wnd , True, bc, fc, RightText , CenterText, '' ) ;
      PutS ( dcs_w.wnd , True, bc, fc, RightText , CenterText, '' ) ;
      PutS ( mv_w.wnd  , True, bc, fc, RightText , CenterText, '' ) ;
      PutS ( sp_w.wnd  , True, bc, fc, RightText , CenterText, '' ) ;
      PutS ( cns_w.wnd , True, bc, fc, CenterText, CenterText, '' ) ;
    End;





  Procedure PlInfo ( Item, Class : Integer ; Point : PointType  ) ;


Const

 ClassId_Opt = 1 ;
 ClassId_Pln = 2 ;
 ClassId_Sat = 3 ;
 ClassId_Non = 4 ;


 ClassName   : Array [ 1 .. 4 ] Of String [ 15 ] =  (
  'Opt ', '            ', 'Sat. ', 'No object'   );




Var

 S, S1 : String      ;
 T     : String [40] ;

 CNeg        : Boolean;

 G, Mnt      : Integer;

 Sec,
 NoX, NoY,
 ORa,
 ODc,
 Diam,
 RR          : Double ;

 NmS         : LongInt;


Begin


  Case Class Of


    ClassId_Sat :

      Begin   {  Спутник  }
              {  ───────  }

         PlanetRecord := PlanetPtr [ -Item Div PlanetBlockSize ]^
                                   [ -Item Mod PlanetBlockSize ] ;

         With PlanetRecord Do
           Begin

             {
             S := ClassName [ ClassId_Sat ] ;
             }
                       { Hомеp }

             Reset ( SatNameFile                         ) ;
             Seek  ( SatNameFile, Nr - Max_PL_PPLFLD - 1 ) ;
             Read  ( SatNameFile, SatNameRec             ) ;
             Close ( SatNameFile                         ) ;

             S := SatNameRec.NameSat ;
             {
             S := S + T ;
             }
             While (     ( Length ( S ) > 0 )
                     And ( S [ 1 ] = ' '    )  )  Do
               Delete ( S, 1, 1 ) ;


             T := SatNameRec.InternDes ;

             If ( Length ( S + T ) <= 24 )  Then
               S := S + ' ' + T ;

             While (     ( Length ( S ) > 0 )
                     And ( S [ 1 ] = ' '    )  )  Do
               Delete ( S, 1, 1 ) ;



             PutS ( clas_w.wnd, True, bc, fc, CenterText, CenterText, S ) ;


                     { Расстояние }

             If ( R < 1.0e6 )
               Then
                 Begin
                   Str ( R : 9:0 , S1 );
                   S :=     Copy ( S1,  1, 3 ) + ' ' ;
                   S := S + Copy ( S1,  4, 3 ) + ' ' ;
                   S := S + Copy ( S1,  7, 3 ) + ' ' ;
                   While (     ( Length ( S ) > 0 )
                           And ( S [ 1 ] = ' '    )  )  Do
                     Delete ( S, 1, 1 ) ;
                   S := S + ' km' ;
                 End
               Else
                 Begin
                   Str ( R / Ae : 8:3 , S );
                   While (     ( Length ( S ) > 0 )
                           And ( S [ 1 ] = ' '    )  )  Do
                     Delete ( S, 1, 1 ) ;
                   S := S + ' au' ;
                 End ;

             PutS ( sp_w.wnd, True, bc, fc, CenterText, CenterText, S );

             S := ' ' ;
             PutS ( mv_w.wnd, True, bc, fc, RightText,  CenterText, S );


             ScToId ( x, y, NoX, NoY );


           End ;


         If ( B_Import_Fld Or OptRd )
           Then
             Begin
               IdToEq1 ( NoX, NoY, ORa, ODc ) ;
             End
           Else
             Begin
               {
               IdToEq ( NoX, NoY, NPolFix, SPozNp, CPozNp, ORa, ODc );
               }
               IdToEq1 ( NoX, NoY, ORa, ODc ) ;
               PreNew ( JDateFld, JDOut, ORa, ODc ) ;
             End ;


                 { Пр. восхождение }


         If ( Not B_Gal )
           Then
             Begin
               RadToGMS ( ORa/15, CNeg, G, Mnt, Sec ) ;
               Str ( G   : 3,  S )  ;  S := S     + Chr(240) + ' ' ;
               Str ( Mnt : 2,  T )  ;  S := S + T + Chr(241) + ' ' ;
               Str ( Sec : 6:3,T )  ;  S := S + T + Chr(242) + ' ' ;
             End
           Else
             Begin
               RadToGMS(ORa,CNeg,G,Mnt,Sec) ;
               Str ( G   : 3  ,S)  ;   S := S           + Chr(243) + ' ' ;
               Str ( Mnt : 2  ,T)  ;   S := S + T       + Chr(244) + ' ' ;
               Str ( Sec : 5:2,T)  ;   S := S + T + ' ' + Chr(245) + ' ' ;
             End ;

         PutS ( ras_w.wnd, True, bc, fc, RightText, CenterText, S ) ;


                    { Склонение }

         RadToGMS ( ODc, CNeg, G, Mnt, Sec );
         Str ( G   : 3  ,S );   S := S           + Chr(243) + ' ' ;
         Str ( Mnt : 2  ,T );   S := S + T       + Chr(244) + ' ' ;
         Str ( Sec : 5:2,T );   S := S + T + ' ' + Chr(245) + ' ' ;
         If CNeg Then
           S[1]:='-';

         PutS ( dcs_w.wnd, True, bc, fc, RightText, CenterText, S );


             { N Ser }
             { ───── }


         Str ( PlanetRecord.Nr - Max_PL_PPLFLD, S ) ;

         While (     ( Length ( S ) > 0 )
                 And ( S [ 1 ] = ' '    )  )  Do
           Delete ( S, 1, 1 ) ;

         PutS ( Opt_w.wnd, True, bc, fc, CenterText, CenterText, S ) ;



      End ;    {  Спутник  }
               {  ───────  }





    ClassId_Pln :

    If ( NPlanetsInFild > 0 )  Then
      Begin   { Планета }
              { ─────── }


          { Расстояние }
          { ────────── }

        PlanetRecord := PlanetPtr [ -Item Div PlanetBlockSize ]^
                                  [ -Item Mod PlanetBlockSize ] ;

        RR := PlanetRecord.R ;
        If ( RR < 1.0e6 )
          Then
            Begin
              Str ( RR : 9:0 , S1 );
              S :=     Copy ( S1,  1, 3 ) + ' ' ;
              S := S + Copy ( S1,  4, 3 ) + ' ' ;
              S := S + Copy ( S1,  7, 3 ) + ' ' ;
              While (     ( Length ( S ) > 0 )
                      And ( S [ 1 ] = ' '    )  )  Do
                Delete ( S, 1, 1 ) ;
              S := PlanetName [ PlanetRecord.Nr ] + ' ' + S + 'km' ;
            End
          Else
            Begin
              Str ( RR / Ae : 8:3 , S );
              While (     ( Length ( S ) > 0 )
                      And ( S [ 1 ] = ' '    )  )  Do
                Delete ( S, 1, 1 ) ;
              S := PlanetName [ PlanetRecord.Nr ] + ' ' + S + ' au' ;
            End ;


        PutS ( clas_w.wnd, True, bc, fc, CenterText, CenterText, S ) ;


             { Диаметp }
             { ─────── }

        PlanetRecord := PlanetPtr [ -Item Div PlanetBlockSize ]^
                                  [ -Item Mod PlanetBlockSize ] ;
        With PlanetRecord Do
          Begin

            Diam := R_PLANETS [ PlanetRecord.Nr ] ;
            Diam := C20 * ArcTan ( Diam / Sqrt ( Sqr ( RR ) - Sqr ( Diam ) ) ) * RG * C600;

            If Diam < 1.0
              Then
                Begin
                  Diam:=Diam * C600;
                  Str ( Diam : 8:2, S);
                  S := S + Chr ( 245 );
                End
              Else
                Begin
                  If ( Diam < C600 )
                    Then
                      Begin
                        Mnt := Trunc ( Diam ) ;
                        Sec := ( Diam - Mnt ) * 60 ;
                        Str ( Mnt : 2  , S ) ;   S := S     + Chr ( 244 ) ;
                        Str ( Sec : 2:0,T) ;  S := S + T + Chr(245) ;
                      End
                    Else
                      Begin
                        G   := Trunc ( Diam       / C600 ) ;
                        Diam:= Diam - G * C600 ;
                        Mnt := Trunc ( Diam ) ;
                        Sec :=       ( Diam - Mnt ) * C600 ;
                        Str ( G   : 3  ,S) ;  S := S +     Chr(243) ;
                        Str ( Mnt : 2  ,T) ;  S := S + T + Chr(244) ;
                        Str ( Sec : 2:0,T) ;  S := S + T + Chr(245) ;
                      End ;

                End;


            While (     ( Length ( S ) > 0 )
                    And ( S [ 1 ] = ' '    )  )  Do
              Delete ( S, 1, 1 ) ;

            PutS ( Opt_w.wnd, True, bc, fc, CenterText, CenterText, S ) ;



                    { Mv }
                    { ── }


            Str ( M : 8:1, S ) ;

            While (     ( Length ( S ) > 0 )
                    And ( S [ 1 ] = ' '    )  )  Do
              Delete ( S, 1, 1 ) ;

            PutS ( mv_w.wnd, True, bc, fc, CenterText, CenterText, S );


                      { Фаза }
                      { ──── }

            RadToGMS ( Phase, CNeg, G, Mnt, Sec ) ;
            Str ( G   : 3, S ); S := S     + Chr(243) ;
            Str ( Mnt : 2, T ); S := S + T + Chr(244) ;

            PutS ( sp_w.wnd, True, bc, fc, CenterText, CenterText, S ) ;



            ScToId ( x, y, NoX, NoY ) ;


          End ;


        {
        IdToEq ( NoX, NoY, NPolFix, SPozNp, CPozNp, ORa, ODc );
        }
        IdToEq1 ( NoX, NoY, ORa, ODc ) ;
        PreNew ( JDateFld, JDOut, ORa, ODc ) ;


          { Пр. восхождение планеты }
          { ─────────────────────── }


        If ( Not B_Gal )
          Then
            Begin
              RadToGMS ( ORa/15, CNeg, G, Mnt, Sec );
              Str ( G   : 3  ,S)  ;  S := S     + Chr(240) + ' ' ;
              Str ( Mnt : 2  ,T)  ;  S := S + T + Chr(241) + ' ' ;
              Str ( Sec : 6:3,T)  ;  S := S + T + Chr(242) + ' ' ;
            End
          Else
            Begin
              RadToGMS(ORa,CNeg,G,Mnt,Sec) ;
              Str ( G   : 3  ,S)  ;  S := S           + Chr(243) + ' ' ;
              Str ( Mnt : 2  ,T)  ;  S := S + T       + Chr(244) + ' ' ;
              Str ( Sec : 5:2,T)  ;  S := S + T + ' ' + Chr(245) + ' ' ;
            End ;


        PutS ( ras_w.wnd, True, bc, fc, RightText, CenterText, S );


             { Склонение планеты }
             { ───────────────── }

        (* *************************************************************

         { Это для Стационаpа }
         { ────────────────── }

         If ( Planet[-Item].Nr <> 10 )
           Then
             RadToGMS ( ODc, CNeg, G, Mnt, Sec )
           Else
             RadToGMS ( BSatSelenogr, CNeg, G, Mnt, Sec );
         ************************************************************* *)

        RadToGMS ( ODc, CNeg, G, Mnt, Sec ) ;

        Str ( G   : 3  ,S);   S:=S      +Chr(243)+ ' ';
        Str ( Mnt : 2  ,T);   S:=S+T    +Chr(244)+ ' ';
        Str ( Sec : 5:2,T);   S:=S+T+' '+Chr(245)+ ' ';
        If CNeg Then
          S[1]:='-';

        PutS ( dcs_w.wnd, True, bc, fc, RightText, CenterText, S ) ;



      End  ;  { Планета }
              { ─────── }





    ClassId_Non :

      Begin

          { Обнуление неотождествления импоpтной звезды }
          { ─────────────────────────────────────────── }

        If (     (    ( B_ObjOut )
                   Or ( B_Export )        )
             And ( NRecObjectOutFile <> 0 ) )  Then
          Begin
            Seek  ( OutDetFile , NRecObjectOutFile - 1 ) ;
            Write ( OutDetFile , OutDetStringOld       ) ;
            NRecObjectOutFileOld := 65000 ;
          End ;

        NRecObjectOutFile := 0 ;

              { ────────────  *  ───────────── }

        NoOpticsData ;
        S := ClassName [ ClassId_Non ] ;

                  { Классификация }
        PutS ( clas_w.wnd, True, bc, fc, CenterText, CenterText, S ) ;


        If ( DateNoObj >= 0 )
          Then
            Begin
              NmS := DateNoObj + NumbMarkingBegin ;
              Str ( Abs ( NmS ) : 8 , S ) ;
            End
          Else
              S := '' ;

        PutS ( Opt_w.wnd , True, bc, fc, CenterText, CenterText, S );


        ScToId ( Point.x, Point.y, NoX, NoY );
        {
        If ( B_Import_Fld Or OptRd )
        }
        If ( OptRd )
          Then
            Begin
              IdToEq1 ( NoX, NoY, ORa, ODc ) ;
            End
          Else
            Begin
              {
              IdToEq ( NoX, NoY, NPolFix, SPozNp, CPozNp, ORa, ODc );
              }
              IdToEq1 ( NoX, NoY, ORa, ODc ) ;
              PreNew ( JDateFld, JDOut, ORa, ODc ) ;
            End ;


            { Пр. восхождение }

        If ( Not B_Gal )
          Then
            Begin
              RadToGMS ( ORa/15,CNeg,G,Mnt,Sec ) ;
              Str ( G   : 3  , S );   S := S     + Chr(240) + ' ' ;
              Str ( Mnt : 2  , T );   S := S + T + Chr(241) + ' ' ;
              Str ( Sec : 6:3, T );   S := S + T + Chr(242) + ' ' ;
            End
          Else
            Begin
              RadToGMS ( ORa,CNeg,G,Mnt,Sec ) ;
              Str ( G   : 3  , S );   S := S           + Chr(243) + ' ' ;
              Str ( Mnt : 2  , T );   S := S + T       + Chr(244) + ' ' ;
              Str ( Sec : 5:2, T );   S := S + T + ' ' + Chr(245) + ' ' ;
            End ;

        PutS ( ras_w.wnd, True, bc, fc, RightText, CenterText, S ) ;


              { Склонение }

        RadToGMS ( ODc,CNeg,G,Mnt,Sec);
        Str ( G   : 3  , S );   S := S           + Chr(243) + ' ' ;
        Str ( Mnt : 2  , T );   S := S + T       + Chr(244) + ' ' ;
        Str ( Sec : 5:2, T );   S := S + T + ' ' + Chr(245) + ' ' ;
        If CNeg Then
          S[1]:='-';

        PutS ( dcs_w.wnd, True, bc, fc, RightText, CenterText, S ) ;

        {
        S:=' ';
        PutS(isp_w.wnd ,True,bc,fc,CenterText,CenterText,S);
        }

      End;

 End ; { Case }

End ;

End.


