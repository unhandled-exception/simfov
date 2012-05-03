
{$F+,O+}


Unit PEndOpt ;

InterFace

  Procedure EndOpt  ;

Implementation

  Uses  PVar, PVarMenu, V_Catal, PSortImp, PMem,
        Curs, PPreNew, PGalEkv, PProFld, Font, Graph, Greek_f, Dos ;



  Procedure EndOpt  ;

Var
 deg, min : integer;
 sec      : Double ;
 cneg     : boolean;
 s1       : String [ 8 ] ;

Begin


      If (     ( B_ObjOut        )
           And ( Not CatNotFound )  )  Then
        Begin

          IFirst := IndCat [ CatImp ] . NBeg ;
          ILast  := IndCat [ CatImp ] . NEnd ;

          SortImpSerNumb ( IFirst, ILast );
         {ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}


          For N := IFirst  To  ILast  Do
            Begin

              Code := Objectptr [ N Div ObjectBlockSize ] ^
                                [ N Mod ObjectBlockSize ].NRecC Mod 1000000000 ;

              Code := Abs ( Code ) ;

              Seek ( OutStarFile , Code - 1 ) ;
              Seek ( OutDetFile  , Code - 1 ) ;

              Read ( OutStarFile , OutStarString ) ;
              Read ( OutDetFile  , OutDetString  ) ;

              Str    ( NGrImport : 7 , s1 ) ;
              OutStarString := OutStarString + S1 + ' ' ;

              If ( Length ( OutDetString ) > 0 )
                Then
                  Begin
                    Write   ( ObjectOutFile , OutStarString ) ;
                    Writeln ( ObjectOutFile , OutDetString  ) ;
                  End
                Else
                  Begin
                    Writeln ( ObjectOutFile , OutStarString ) ;
                  End ;
            End ;

          Close    ( ObjectOutFile ) ;

        End ;


           { “¤ «¥­¨¥ ¢p¥¬¥­­ëå ä ©«®¢ }
           { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

            {$I-}
      Reset   ( ImportStarFile  ) ;
            {$I+}
      If ( IoResult = 0 )  Then
        Begin
          Close ( ImportStarFile ) ;
          Erase ( ImportStarFile ) ;
        End ;

            {$I-}
      Reset   ( OutDetFile  ) ;
            {$I+}
      If ( IoResult = 0 )  Then
        Begin
          Close ( OutDetFile ) ;
          Erase ( OutDetFile ) ;
        End ;

            {$I-}
      Reset   ( OutStarFile  ) ;
            {$I+}
      If ( IoResult = 0 )  Then
        Begin
          Close ( OutStarFile ) ;
          Erase ( OutStarFile ) ;
        End ;




      If ( B_PPM )  Then
        Begin
            {$I-}
          Reset   ( PPMFile  ) ;
            {$I+}
          If ( IoResult = 0 ) Then
            Close ( PPMFile ) ;
            {$I-}
          Reset   ( PPMKeyFile  ) ;
            {$I+}
          If ( IoResult = 0 ) Then
            Close ( PPMKeyFile ) ;

        End ; { PPM }


      If ( B_Npm )  Then
        Begin
            {$I-}
          Reset   ( NpmFile  ) ;
            {$I+}
          If ( IoResult = 0 ) Then
            Close ( NpmFile ) ;
            {$I-}
          Reset   ( NpmKeyFile  ) ;
            {$I+}
          If ( IoResult = 0 ) Then
            Close ( NpmKeyFile ) ;

        End ; { Npm }


     If ( B_BS )  Then
       Begin
            {$I-}
          Reset   ( BsFile  ) ;
            {$I+}
          If ( IoResult = 0 ) Then
            Close ( BsFile ) ;
            {$I-}
          Reset   ( BsKeyFile  ) ;
            {$I+}
          If ( IoResult = 0 ) Then
            Close ( BsKeyFile ) ;

       End ; { Bs }



     If ( B_Gcvs )  Then
       Begin

          If ( B_Gcvs2000 )
            Then
              Begin
                {$I-}
                Reset   ( Gcvs2000File  ) ;
                {$I+}
                If ( IoResult = 0 ) Then
                  Close ( Gcvs2000File ) ;
              End
            Else
              Begin
                {$I-}
                Reset   ( GcvsFile  ) ;
                {$I+}
                If ( IoResult = 0 ) Then
                  Close ( GcvsFile ) ;
              End ;


            {$I-}
          Reset   ( GcvsKeyFile  ) ;
            {$I+}
          If ( IoResult = 0 ) Then
            Close ( GcvsKeyFile ) ;


       End ; { Gcvs }




     If ( NameCatCdcExist )  Then
       Begin
            {$I-}
          Reset   ( CdcFile  ) ;
            {$I+}
          If ( IoResult = 0 ) Then
            Close ( CdcFile ) ;
            {$I-}
          Reset   ( CdcKeyFile  ) ;
            {$I+}
          If ( IoResult = 0 ) Then
            Close ( CdcKeyFile ) ;

       End ;


     (*
            {$I-}
     Reset   ( GscFile  ) ;
            {$I+}
     If ( IoResult = 0 ) Then
       Close ( GscFile ) ;

            {$I-}
     Reset   ( GscKeyFile  ) ;
            {$I+}
     If ( IoResult = 0 ) Then
       Close ( GscKeyFile ) ;

            {$I-}
     Reset   ( GscAddFile  ) ;
            {$I+}
     If ( IoResult = 0 ) Then
       Close ( GscAddFile ) ;
     *)



            {$I-}
     Reset   ( A20DateNFile  ) ;
            {$I+}
     If ( IoResult = 0 ) Then
       Close ( A20DateNFile ) ;

            {$I-}
     Reset   ( A20DateSFile  ) ;
            {$I+}
     If ( IoResult = 0 ) Then
       Close ( A20DateSFile ) ;






     If ( B_Import_Fld )  Then
       Begin
            {$I-}
          Reset   ( ObjectFile  ) ;
            {$I+}
          If ( IoResult = 0 ) Then
            Close ( ObjectFile ) ;

            {$I-}
          Reset   ( ImportCcdFile  ) ;
            {$I+}
          If ( IoResult = 0 ) Then
            Begin
              Close ( ImportCcdFile ) ;
              Erase ( ImportCcdFile ) ;
            End ;

       End ;



            {$I-}
      Reset   ( NlttFile  ) ;
            {$I+}
      If ( IoResult = 0 ) Then
        Close ( NlttFile ) ;

            {$I-}
      Reset   ( NlttKeyFile  ) ;
            {$I+}
      If ( IoResult = 0 ) Then
        Close ( NlttKeyFile ) ;



      If ( B_Cdc_Cat )  Then
        Begin

            {$I-}
          Reset   ( CdcFile  ) ;
            {$I+}
          If ( IoResult = 0 ) Then
            Close ( CdcFile ) ;

            {$I-}
          Reset   ( CdcKeyFile  ) ;
            {$I+}
          If ( IoResult = 0 ) Then
            Close ( CdcKeyFile ) ;

         End ;


      If ( FSearch ( 'DE200.Dat','') <> '') Then
        Begin
            {$I-}
          Reset   ( DE200File  ) ;
            {$I+}
          If ( IoResult = 0 ) Then
            Close ( DE200File ) ;

        End ;


(*
      If ( GScale > 1.00001 )  Then
        Begin

          If ( Not B_Gal )  Then
            Begin
              PreNew ( JDateFld, JdEp, RaOptGlass, DeclOptGlass );
              RaOptGlass := RaOptGlass / 15.0 ;
            End ;


          RadToGms ( RaOptGlass, cneg, deg, min, sec ) ;

          Param.RaOptH := Deg ;
          Param.RaOptM := Min ;
          Param.RaOptS := Sec ;


          RadToGms( DeclOptGlass, cneg, deg, min, sec);

          Param.DeclOptG := Deg ;
          Param.DeclOptM := Min ;
          Param.DeclOptS := Sec ;
          If ( CNeg )
             Then Param.DeclOptSig := '-'
             Else Param.DeclOptSig := ' ' ;

        End ; { GScale > 1.0001 }

*)

      FreeAll;
     {ÜÜÜÜÜÜÜ}

      If ( BPointerMark )  Then
        FreeMarker;


      If ( Not CatNotFound )  Then
        Begin

          {
          unld8x8;
          Unload_greek;
          }

          Unload_greek;

          RestoreCrtMode;
          CloseGraph;

        End ;


End;

End.