
{$O+,F+}

UNIT POptCdc ;


  INTERFACE

    USES  DOS, V_CATAL, PVAR, PVarMenu, PPreOld, PPreNew,
          PJd8 , PMem, PFk4Fk5 ;


    PROCEDURE OptCdc ;


  IMPLEMENTATION





    PROCEDURE OptCdc ;
   {****************}


 Var

     Tag                                : Char    ;

     DeclAkCg , RaAkCH , RaAkCM,
     NSerAkZagol                        : Byte    ;

     AkZagolExist, FoundPlate           : Boolean ;

     DeclOptG                           : Integer ;
     NRecZagol                          : Integer ;

     Ss,
     RACD, DECCD                        : Double ;


     RStr           : PathStr ;

     AkZagolFile    : File  Of  AkInfType   ;
     ConstFile      : File  Of  ConstType   ;
     ConstRec       :           ConstType   ;


     BEGIN  { PRO CdcFld }
            { ÜÜÜÜÜÜÜÜÜÜ }



           { H ©¤¥¬ ¯« áâ¨­ªã ¢ ” ©«¥ ‡ £®«®¢ª®¢ }
           { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }


        DeclOptG := Param.DeclOptG ;
        If ( PaRam.DeclOptSig = '-' )  Then
          DeclOptG := - DeclOptG ;

        If ( Param.DeclOptM = 0 )  Then

          Begin
            For N := 1 To 19  Do
              Begin
                If (     ( DeclOptG >= ZoneObs1B [ N ] )
                     And ( DeclOptG <= ZoneObs1E [ N ] ) )
                  Then
                    Begin
                      ExtFileAk := NameObs [ N ] ;
                    End ;
              End ;

          End

         Else

          Begin
            For N := 1 To 19  Do
              Begin
                If (     ( DeclOptG >= ZoneObs2B [ N ] )
                     And ( DeclOptG <= ZoneObs2E [ N ] ) )
                  Then
                    Begin
                      ExtFileAk := NameObs [ N ] ;
                    End ;
              End ;

          End ;



        Str ( Param.DeclOptG : 2 , RStr ) ;
           If ( RStr [ 1 ] = ' ' )  Then  RStr [ 1 ] := '0' ;
           If (  DeclOptG <= 0 )
             Then RStr := 's' + RStr
             Else RStr := 'n' + RStr ;


        AkZagolFileName := ParamDir.CdcDir + '\' + RStr +
                           'plist.' + ExtFileAk ;
        AkNoDteFileName := RStr + '_' + ExtFileAk + '.Nod' ;


             { —â¥­¨¥ áâp®ª¨ ‡ £®«®¢ª  }
             { ----------------------- }

        EndProc := True ;

        Assign ( AkZagolFile    , AkZagolFileName   )  ;
        {$I-}  Reset  ( AkZagolFile ) ;  {$I+}

        If ( IOResult = 0 )  Then
          Begin  { IOResult = 0 }

            EndProc := False ;

            NRecZagol := FileSize ( AkZagolFile ) ;

            If ( NGrImport > NRecZagol )  Then
               Begin
                 EndProc := True ;
                 Close ( AkZagolFile ) ;
               End
              Else
               Begin

                 Seek ( AkZagolFile , NGrImport - 1 ) ;
                 Read ( AkZagolFile , AkZagolRec ) ;
                 Close  ( AkZagolFile   ) ;

                 AkZagolRec.Tag := UpCase ( AkZagolRec.Tag ) ;
                 Tag := AkZagolRec.Tag ;

                 RaOpt   := ( AkZagolRec.RaH   +
                              AkZagolRec.RaM   / C600 ) * Gr * 15.0 ;

                 DeclOpt :=   PaRam.DeclOptG  * Gr ;
                 If ( PaRam.DeclOptSig = '-' )  Then  DeclOpt := - DeclOpt ;

                 RACD  := RaOpt   ;
                 DECCD := DeclOpt ;


                       { ¥p¥å®¤   1900  ->  1950  }
                       { ************************  }


                 PREOLD ( 2415020.3135 , 2433282.4234, RACD, DECCD ) ;
                {**************************************************}


                       { ¥p¥å®¤   1950  ->  2000  }
                       { ************************  }

                 FK4FK5 (  RACD, DECCD ) ;
                {**********************}

                 RaOpt   := RACD  ;
                 DeclOpt := DECCD ;


                             { „ â  ¯« áâ¨­ª¨ }
                             { ************** }

  	         JD8 ( AkZagolRec.Year, AkZagolRec.Mon, AkZagolRec.Day, JDate );


               End ;

          End ;  { IOResult = 0 }


               { ”®p¬¨p®¢ ­¨¥ ¨¬¥­¨ ä ©«  ª®®p¤¨­ â }
               { ---------------------------------- }

        If ( Not EndProc )  Then
          Begin   { FoundPlate }
                  { ---------- }

            ConstFileName     := ParamDir.CdcDir + '\' + RStr +
                                 'ACNST.' + ExtFileAk ;
            RectCoordFileName := ParamDir.CdcDir + '\' + RStr +
                                 'PData.' + ExtFileAk ;

            Assign ( ConstFile , ConstFileName    ) ;
            Reset  ( ConstFile                    ) ;
            Seek   ( ConstFile , NGrImport - 1    ) ;
            Read   ( ConstFile , ConstRec         ) ;
            Close  ( ConstFile                    ) ;

            AX := ConstRec.Ax ;
            BX := ConstRec.Bx ;
            CX := ConstRec.Cx ;

            AY := ConstRec.Ay ;
            BY := ConstRec.By ;
            CY := ConstRec.Cy ;

            D  := ConstRec.D  ;
            E  := ConstRec.E  ;

            MeanMPPM    := ConstRec.MeanMPPM    ;
            MeanMAcPPM  := ConstRec.MeanMAcPPM  ;
            PRedK0PPM   := ConstRec.K0PPM       ;
            PRedK1PPM   := ConstRec.K1PPM       ;
            PRedK2PPM   := ConstRec.K2PPM       ;

            MeanMGSC    := ConstRec.MeanMGSC    ;
            MeanMAcGSC  := ConstRec.MeanMAcGSC  ;
            PRedK0GSC   := ConstRec.K0GSC       ;
            PRedK1GSC   := ConstRec.K1GSC       ;
            PRedK2GSC   := ConstRec.K2GSC       ;

            NGrImport := NGrImport + 1 ;

          End ;   { FoundPlate }
                  { ---------- }

    END ;  { PRO SAOFLD }

END.

