

                PROGRAM ExNod ;
               {ÜÜÜÜÜÜÜÜÜÜÜÜÜÜ}

      { ˆ§¢«¥ç¥­¨¥ ¨§ ä ©«  ®â®¦¤¥áâ¢«¥­¨© }
      { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

USES
 CRT , Dos ;

{
CONST


 InputName  = 'Nod.det' ;

}

 Var

   OutInfOK,
   OutInfNltt,
   OutInfBin,
   OutInfNoDet,
   Pusto        : Boolean ;

   L,
   NSerNoDet,
   NSerBin,
   NSerOK,
   Code         : Integer ;

   I,
   NRec         : LONGINT ;

   InputName,
   OutBinName,
   OutNodName,
   OKName,
   NlttName,
   SSer,
   S, S1, SInf,
   STemp        : String ;

   InpFile      : Text  ;
   NoDetFile    : Text  ;
   BinFile      : Text  ;
   OKFile       : Text  ;



Begin

 If ( ParamCount <> 1 )  Then  Halt ( 1 ) ;

 InputName := ParamStr ( 1 ) ;
 Code := Pos ( '.', InputName ) ;

 OutBinName := Copy ( InputName , 1 , Code ) + 'Bin'  ;
 OutNodName := Copy ( InputName , 1 , Code ) + 'Nod'  ;
 OKName     := Copy ( InputName , 1 , Code ) + 'OK'  ;

 Assign   ( InpFile  , InputName     ) ;
 Reset    ( InpFile                  ) ;

 Assign   ( NoDetFile  , OutNodName  ) ;
 ReWrite  ( NoDetFile                ) ;

 Assign   ( BinFile    , OutBinName  ) ;
 ReWrite  ( BinFile                  ) ;

 Assign   ( OKFile    , OKName  ) ;
 ReWrite  ( OKFile              ) ;



 { ßß  ßß  ßß  ßß  ßß  ßß  ßß  ßß  ßß  ßß  ßß  ßß  ßß  ßß  ßß  ßß  ßß  ßß }


 ClrScr ;

 NSerNoDet := 0 ;
 NSerBin   := 0 ;
 NSerOK    := 0 ;


 NRec := 1 ;

 While ( Not Eof ( InpFile ) )  Do
   Begin

     ReadLn ( InpFile , S1 ) ;

     STemp := S1 ;
     Pusto := False ;

     If ( Length ( S1 ) = 0 )  Then
        Pusto := True ;


     If ( Not Pusto )  Then
       Begin

         While ( STemp [ 1 ] = ' ' )  Do
           Delete ( STemp , 1 , 1 ) ;

         If (    ( STemp [ 1 ] = '0' )
              Or ( STemp [ 1 ] = '1' )
              Or ( STemp [ 1 ] = '2' ) )  
           Then
             Begin
               Pusto := False ;
             End
           Else
             Begin
               Pusto       := True ;
               SInf        := S1   ;
               OutInfNoDet := True ;
               OutInfBin   := True ;
               OutInfOK    := True ;
               Writeln ( SInf ) ;
             End ;
       End ;

     If ( Not Pusto )  Then
       Begin

         If  (     ( Pos ( '=>' , S1 ) = 0 )
               And ( Pos ( '->' , S1 ) = 0 )  )  Then
            Begin

              If ( OutInfNoDet )  Then
                Begin
                  Writeln ( NoDetFile ) ;
                  Inc ( NSerNoDet ) ;
                  Str ( NSerNoDet : 6 , SSer ) ;
                  Writeln ( NoDetFile , SInf, '  SerNoDet =', SSer ) ;
                  OutInfNoDet := False ;
                End ;

              WriteLn ( NoDetFile , S1 ) ;

            End ;


         If  ( Pos ( '->' , S1 ) <> 0 )   Then
            Begin

              If ( OutInfBin )  Then
                Begin
                  Writeln ( BinFile ) ;
                  Inc ( NSerBin ) ;
                  Str ( NSerBin : 6 , SSer ) ;
                  Writeln ( BinFile , SInf, '  SerBin =', SSer ) ;
                  OutInfBin := False ;
                End ;

              WriteLn ( BinFile , S1 ) ;

            End ;

         If  (     ( Pos ( '=>' , S1 ) <> 0 )
               And ( Pos ( '->' , S1 ) =  0 )  )    Then
            Begin
              {
              If ( OutInfOK )  Then
                Begin
                  Writeln ( OKFile ) ;
                  Inc ( NSerOk ) ;
                  Str ( NSerOk : 6 , SSer ) ;
                  Writeln ( OkFile , SInf, '  SerOk =', SSer ) ;
                  OutInfOK := False ;
                End ;
              }

              WriteLn ( OKFile , S1 ) ;

            End ;


       End ; { Not Pusto }

     Inc ( NRec ) ;

   End ;


 Close ( InpFile   ) ;
 Close ( NoDetFile ) ;
 Close ( BinFile   ) ;
 Close ( OKFile    ) ;


 For I := 1 To 30 Do
   Begin
    Sound ( I * 5 + 100 ) ;
    Delay ( 3 ) ;
    NoSound ;
   End ;

End.
