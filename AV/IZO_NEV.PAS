

         Program Izo_Nev ;
        {ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}

{
    ¨á®¢ ­¨¥ áp¥¤­¨å ­¥¢ï§®ª â¥«¥áª®¯®¢
    ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
}


Uses

 Crt, Graph, Dos, PRedGsc ;

 Const
{ÜÜÜÜÜ}

  Telescop = 'N' ;

  NxMax   = 190    ;
  NxMaxDx = 177    ;
  StepMm  =  15.0  ;
  NyMax   = NxMax  ;
  MaxVect = 1.5    ;

  MaxIndUzla = Trunc ( NxMaxDx / StepMm ) ;

  MvBeg  =  8   ;
  MvEnd  = 11   ;
  StepMv =  0.5 ;

  Interval : Double = 0.5 ;   { ‚¥«¨ç¨­  è £  Dx, Dy ¢ á¥ªã­¤ å ¤ã£¨ }
                              { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }


Type

 ArrMeanType = Record
                 N      : Word    ;
                 Dx,
                 Dy     : Single  ;
               End ;


Var

  Out,
  Inp            : Text    ;
  
  B_Nev,
  MakeIzo        : Boolean ;

  NameFile,
  SMv, S1        : String  ;

  ObsRed         : NameStr ;

  Ch             : Char    ;


  I, J,
  Im, Ix, Iy,
  Nm, N,
  Mv,
  IndMv,
  DeclG,
  Code,
  dXScr, dYScr,
  Page,
  IndR,
  grDriver,
  grMode,
  XScr, YScr,
  ErrCode        : Integer;

  NObs,
  IMvIzo,
  Xasp, Yasp,
  XText,
  Xc  , Yc
                 : Word    ;

  NDxMean,
  NMean,
  NStar,
  NMqeStar,
  Ppm,
  NStarSum       : LongInt ;

  MvIzo,
  DxMean,
  DyMean,
  MqeDx,
  MqeDy,
  MqeDxStar,
  MqeDyStar,
  MqeStar,
  Mx, My,
  MvR,
  R,
  DeclBeg,
  DeclEnd,
  Ra, Decl, MvPpm,
  XMean, YMean,
  DxN, DxS,
  DyN, DyS,
  Dx1, Dy1,
  X, Y, Dx, Dy   : Double  ;

  Sw             : ViewPortType ;

  ArrMeanRec  : ArrMeanType ;
  ArrMeanRec1 : ArrMeanType ;
  ArrMean     : Array [ -MaxIndUzla .. MaxIndUzla, 
                        -MaxIndUzla .. MaxIndUzla ] Of ArrMeanType ;
{
  ArrMean1    : Array [ -15 .. 15, -15 .. 15 ] Of ArrMeanType ;
}

function FileExists(FileName: String): Boolean;
{ Boolean function that returns True if the file exists;otherwise,
 it returns False. Closes the file if it exists. }
var
 F: file;
begin
 {$I-}
 Assign(F, FileName);
 FileMode := 0;  { Set file access to read only }
 Reset(F);
 Close(F);
 FileMode := 2 ;
 {$I+}
 FileExists := (IOResult = 0) and (FileName <> '');
end;  { FileExists }



  Procedure EGAVGADriverProc; external;
   {$L EGAVGA.OBJ}




Procedure InitGr;
         {ÜÜÜÜÜÜ}
Var
 GDriver, GMode : Integer;

Begin

{ Register EGA/VGA driver }

  If RegisterBGIdriver(@EGAVGADriverProc) < 0 Then
    Begin
      Writeln('EGA/VGA');
      Halt ( 1 ) ;
    End ;
{ Register TScript font     }
{
  TFont := InstallUserFont( 'TScr' );
  if RegisterBGIfont(@TScrFontProc) < 0 then
      Abort('TScript Font');
 GDriver := EGA;
 GMode   := EGAHi;
}

 GDriver := Detect;
 InitGraph( GDriver,GMode,'' );

 If GraphResult < 0 Then
   Begin
     TextMode(LastMode);
     WriteLn(GraphErrorMsg(GraphResult));
   End;

  getaspectratio(xasp,yasp);
  setcolor   ( DarkGray ) ;
  SetBkColor ( White ) ;

End;




  Procedure Frame ;

    Begin

      SetViewPort ( 0, 0, GetMaxX, GetMaxY,  True ) ;
      ClearViewPort ;


      With sw Do
        Begin

          x1 := 0;
          y1 := 0;
          y2 := GetMaxY ;
          x2 := x1 + Trunc ( ( y2 - y1 ) / (XAsp/YAsp) ) ;

{
          SetColor ( LightGray ) ;
}
          Line      (x1,y1,GetMaxX,y1) ;
          Line      (x1,y2,GetMaxX,y2) ;
          RectAngle (x1,y1,x2,y2) ;

          Inc ( x1 ) ;
          Inc ( y1 ) ;
          Dec ( x2 ) ;
          Dec ( y2 ) ;

          If ( ( x2 - x1 ) Mod 2 = 0 ) Then  Dec ( x2 ) ;

          SetViewPort ( x1, y1, x2, y2, True ) ;
          ClearViewPort ;

          DxScr := ( x2 - x1 ) Div 2 ;
          DyScr := ( y2 - y1 ) Div 2 ;

          Xc   := ( x2 + x1 ) Div 2 ;
          Yc   := ( y2 + y1 ) Div 2 ;

          Mx := DxScr / NxMax ;
          My := DyScr / NyMax ;

          XText := x2 +  10 ;

        End ;
{
      SetColor ( LightRed      ) ;
}
      Circle ( Xc, Yc, 6 ) ;


    End ;




Begin
{
  If RegisterBGIDriver( @EGAVGADriverProc ) < 0 Then
    begin

      WriteLn( 'EGA\VGA Driver not present.' );
      Halt( 1 );

    end;

  GrDriver := Detect;
  InitGraph ( grDriver, grMode,'');

  ErrCode := GraphResult;

  If ErrCode <> 0 Then
     Begin
       TextMode(LastMode);
       WriteLn(GraphErrorMsg(ErrCode));
       Halt ( 1 ) ;
     End ;


  GetAspectRatio ( Xasp, Yasp ) ;
}

  If ( ParamCount < 1 )  Then
    Begin
      Writeln ( '  H¥ ãª § ­® ¨¬ï ä ©«  ­¥¢ï§®ª  ' ) ;
      Halt ( 1 ) ;
    End ;


  If Telescop = 'N' 
    Then
      Begin
        DeclBeg :=    7.0 ;
        DeclEnd :=   90.0 ;
      End
    Else
      Begin
        DeclBeg := - 90.0 ;
        DeclEnd := -  7.0 ;
      End ;


  If ( ParamCount = 2 )  Then
    Begin
      Val ( ParamStr ( 2 ) , Interval, Code ) ;
    End ;

  S1 := ParamStr ( 1 ) ;
  For I := 1 To Length ( S1 ) Do
    S1 [ I ] := UpCase ( S1 [ I ] ) ;

  If ( Pos ( '.NEV', S1 ) > 0 )  Then
    Begin
      B_Nev := True ;
      S1 := Copy ( S1, 1, Pos ( '.NEV', S1 ) - 1 ) ;
    End ;

  If ( Pos ( '.NES', S1 ) > 0 )  Then
    Begin
      B_Nev := False ;
      S1 := Copy ( S1, 1, Pos ( '.NES', S1 ) - 1 ) ;
    End ;

  ObsRed := S1 [ 1 ] ;


  InitGr;

  If ( B_Nev )
    Then  NameFile := S1 + '.Nev'
    Else  NameFile := S1 + '.Nes' ;

  If FileExists ( NameFile )  Then
    Begin  { FileExists }
       

      Assign ( Inp, NameFile ) ;
{
      Reset  ( Inp ) ;
}
      If ( Not B_Nev )  Then
        Begin
          Assign  ( Out, S1 + '.Grt' ) ;
          ReWrite ( Out              ) ;
        End ;

      DxMean  := 0.0 ;
      DyMean  := 0.0 ;
      NDxMean := 0   ;
{
      While Not Eof ( Inp )  Do
        Begin

          ReadLn ( Inp, Nm, N, X, Y, Dx, Dy ) ;

          If  ( N  > 0 ) Then
            Begin
              DxMean := ( DxMean * NDxMean - Dx ) / ( NDxMean + 1 ) ;
              DyMean := ( DyMean * NDxMean - Dy ) / ( NDxMean + 1 ) ;
              Inc ( NDxMean ) ;
            End ;

        End ;
}

(* *)

      If ( B_Nev )  Then
      For Mv := MvBeg To MvEnd Do
        Begin { Mv }

          Reset ( Inp ) ;

          Frame ;

          NStar   := 0     ;
          MqeDx   := 0.0   ;
          MqeDy   := 0.0   ;
          NDxMean := 0     ;
          MakeIzo := False ;



          While ( Not Eof ( Inp ) )  Do
            Begin

              ReadLn ( Inp, Nm, N, X, Y, Dx, Dy )  ;

              If (      ( N  > 0  )
                   And  ( Nm = Mv )  ) Then
                Begin

                  Dx := - Dx - DxMean ;
                  Dy := - Dy - DyMean ;

                  Ix := Round ( X ) ;
                  Iy := Round ( Y ) ;

                  R    := Sqrt (  Sqr ( X ) + Sqr ( Y )  ) ;
                  IndR := Round ( R / 10.0 ) ;

                  Inc ( NDxMean ) ;
                  NStar := NStar + N ;

                  MqeDx := MqeDx + Sqr ( Dx ) ;
                  MqeDy := MqeDy + Sqr ( Dy ) ;


                  XScr := Xc - Round ( X * Mx ) ;
                  YScr := Yc - Round ( Y * My ) ;

                  SetColor ( LightGray ) ;
                  Circle   ( XScr, YScr, 1 ) ;
                  SetColor ( DarkGray ) ;

                  Line     ( XScr, YScr,
                             XScr - Round ( Dx / Interval * StepMm * Mx ) ,
                             YScr - Round ( Dy / Interval * StepMm * My )   ) ;

                End ;

            End ;


          SetViewPort ( 0, 0, GetMaxX, GetMaxY,  True ) ;

          S1 := ParamStr ( 1 ) ;
          For I := 1 To Length ( S1 ) Do
            S1 [ I ] := UpCase ( S1 [ I ] ) ;
          If ( Pos ( '.NEV', S1 ) > 0 )  Then
            S1 := Copy ( S1, 1, Pos ( '.NEV', S1 ) - 1 ) ;

          MoveTo   ( XText, 15  ) ;
          OutText  ( S1 ) ;


          MoveTo   ( XText, 35 ) ;
          Str      ( Interval : 5:2 , SMv ) ;

          SMv := 'Step   =' + SMv + '"' ;
          OutText  ( SMv   ) ;

          MoveTo   ( XText, 55 ) ;
          Str      ( Mv : 5 , SMv ) ;

          SMv := 'Mv     =' + SMv ;
          OutText  ( SMv   ) ;

          MoveTo   ( XText, 105 ) ;
          Str      ( Sqrt ( ( MqeDx ) / ( NDxMean - 1 ) ) : 7:3 , SMv ) ;

          SMv := 'MqeDx  =' + SMv +'"' ;
          OutText  ( SMv   ) ;

          MoveTo   ( XText, 115 ) ;
          Str      ( Sqrt ( ( MqeDy ) / ( NDxMean - 1 ) ) : 7:3 , SMv ) ;

          SMv := 'MqeDy  =' + SMv +'"' ;
          OutText  ( SMv   ) ;

          MoveTo   ( XText, 155 ) ;
          Str      ( NStar : 7 , SMv ) ;

          SMv := 'N Star =' + SMv ;
          OutText  ( SMv   ) ;


          If ( NStar > 0 )  Then
            Begin
              Repeat  Until  KeyPressed ;
                Begin
                  Ch := ReadKey ;
                  If Ch = #0  Then
                    Ch := ReadKey ;
                End ;
            End ;

        End ; { Mv }

(* *)


If ( Not B_Nev )  Then
 For  IndMv  :=  1  To  8  Do
  Begin { Mv }

      MvR := MvBeg + StepMv * ( IndMv - 1 ) ;

      Reset ( Inp ) ;

      Frame ;

      ArrMeanRec.N   := 0   ;
      ArrMeanRec.dX  := 0.0 ;
      ArrMeanRec.dY  := 0.0 ;

      For I := -MaxIndUzla  To  MaxIndUzla  Do
        For J := -MaxIndUzla  To  MaxIndUzla  Do
          ArrMean [ I, J ] := ArrMeanRec ;



      NStar   := 0   ;
      MqeDx   := 0.0 ;
      MqeDy   := 0.0 ;
      NDxMean := 0   ;
      MakeIzo := False ;

      MqeDxStar := 0.0 ;
      MqeDyStar := 0.0 ;
      MqeStar   := 0.0 ;
      NMqeStar  := 0   ;


      Reset ( Inp ) ;


      While ( Not Eof ( Inp ) )  Do
        Begin

          If ( B_Nev )
            Then
                ReadLn ( Inp, Nm, N, X, Y, Dx, Dy ) 
            Else
              Begin
{
                ReadLn ( Inp, X, Y, Dx, Dy, MvPpm, Ra, Decl, Ppm ) ;
}
{
20  6 53.802  87 58 48.45 10.3   3531 -102.24   30.28   0.01   0.52  12.5052  88.7698
}
                ReadLn ( Inp,  R, R, R,  DeclG, R, R,   MvPpm,   R, 
                              X, Y, Dx, Dy ) ;
                N := 1 ;
              End ;

          If ( N  >  0 )   Then
            Begin

              I := Round ( X / StepMm ) ;
              J := Round ( Y / StepMm ) ;

              If (     ( Abs ( I )  <  MaxIndUzla             )
                   And ( Abs ( J )  <  MaxIndUzla             )  
                   And ( Abs ( Dx ) <= MaxVect                )
                   And ( Abs ( Dy ) <= MaxVect                )
                   And ( Abs ( MvR - MvPpm ) <= StepMv / 2.0  )
                   And ( DeclG >= DeclBeg                     )
                   And ( DeclG <= DeclEnd                     )
                                                                )  Then
                Begin
{
                  If ( Not B_Nev )  Then
                    WriteLn ( Out, 
                                          X            : 7 : 2 ,
                                          Y            : 8 : 2 ,
                                          Dx           : 7 : 2 ,
                                          Dy           : 7 : 2 ,
                                          MvPpm        : 6 : 1 ,
                                          Ra           : 7 : 2 ,
                                          Decl         : 7 : 2 ,
                                          Ppm          : 8 
                          ) ;
}

                  MqeDxStar := MqeDxStar +   Sqr ( Dx )                 ;
                  MqeDyStar := MqeDyStar +   Sqr ( Dy )                 ;
                  MqeStar   := MqeStar   + ( Sqr ( Dx ) + Sqr ( Dy ) )  ;
                  Inc ( NMqeStar ) ;

                  ArrMeanRec := ArrMean [ I, J ] ;

                  NMean := ArrMeanRec.N ;

                  ArrMeanRec.dX := ( ArrMeanRec.dX * NMean + dX * N ) / 
                                   ( NMean + N ) ;
                  ArrMeanRec.dY := ( ArrMeanRec.dY * NMean + dY * N ) / 
                                   ( NMean + N ) ;

                  ArrMeanRec.N  := NMean + N ;

                  ArrMean [ I, J ] := ArrMeanRec ;


                End ;

            End ;

        End ;

      Close  ( Inp ) ;



      For I := -MaxIndUzla To MaxIndUzla  Do
        For J := -MaxIndUzla To MaxIndUzla  Do
          Begin

            ArrMeanRec := ArrMean [ I, J ] ;

            N  := ArrMeanRec.N     ;
            X  := I * StepMm       ;
            Y  := J * StepMm       ;
            dX := ArrMeanRec.dX    ;
            dY := ArrMeanRec.dY    ;

            If ( N  > 0  )  Then
                Begin

                  Dx := - Dx ;
                  Dy := - Dy ;

                  Ix := Round ( X ) ;
                  Iy := Round ( Y ) ;

                  Inc ( NDxMean ) ;
                  NStar := NStar + N ;

                  MqeDx := MqeDx + Sqr ( Dx ) ;
                  MqeDy := MqeDy + Sqr ( Dy ) ;


                  XScr := Xc - Round ( X * Mx ) ;
                  YScr := Yc - Round ( Y * My ) ;


                  SetColor ( LightGray ) ;
                  Circle   ( XScr, YScr, 1 ) ;
                  SetColor   ( DarkGray ) ;

                  Line     ( XScr, YScr,
                             XScr - Round ( Dx / Interval * StepMm * Mx ) ,
                             YScr - Round ( Dy / Interval * StepMm * My )   ) ;

                End ;

          End ;


          SetViewPort ( 0, 0, GetMaxX, GetMaxY,  True ) ;

          MoveTo   ( XText, 25  ) ;

          S1 := ParamStr ( 1 ) ;
          For I := 1 To Length ( S1 ) Do
            S1 [ I ] := UpCase ( S1 [ I ] ) ;
          If ( Pos ( '.NEV', S1 ) > 0 )  Then
            S1 := Copy ( S1, 1, Pos ( '.NEV', S1 ) - 1 ) ;

          S1 := S1 + '     ' + Telescop ;

          OutText  ( S1 ) ;



          MoveTo   ( XText, 45 ) ;
          Str      ( MvR : 5:1 , SMv ) ;

          SMv := 'Mv     =' + SMv ;
          OutText  ( SMv   ) ;



          MoveTo   ( XText, 65 ) ;
          Str      ( Interval : 5:2 , SMv ) ;

          SMv := 'Step   =' + SMv + '"' ;
          OutText  ( SMv   ) ;


          MoveTo   ( XText, 105 ) ;
          Str      ( Sqrt ( ( MqeDx ) / ( NDxMean - 1 ) ) : 7:3 , SMv ) ;

          SMv := 'MqeDx  =' + SMv +'"' ;
          OutText  ( SMv   ) ;

          MoveTo   ( XText, 115 ) ;
          Str      ( Sqrt ( ( MqeDy ) / ( NDxMean - 1 ) ) : 7:3 , SMv ) ;

          SMv := 'MqeDy  =' + SMv +'"' ;
          OutText  ( SMv   ) ;

          MoveTo   ( XText, 155 ) ;
          Str      ( NStar : 7 , SMv ) ;

          SMv := 'N Star =' + SMv ;
          OutText  ( SMv   ) ;


          If ( Not B_Nev )  Then
            Begin

              MoveTo   ( XText, 185 ) ;
              Str      ( Sqrt ( ( MqeDxStar ) / ( NMqeStar - 1 ) ) : 6:3 , SMv ) ;

              SMv := 'MqeDxStar =' + SMv +'"' ;
              OutText  ( SMv   ) ;

              MoveTo   ( XText, 195 ) ;
              Str      ( Sqrt ( ( MqeDyStar ) / ( NMqeStar - 1 ) ) : 6:3 , SMv ) ;

              SMv := 'MqeDyStar =' + SMv +'"' ;
              OutText  ( SMv   ) ;

              MoveTo   ( XText, 215 ) ;
              Str      ( Sqrt ( ( MqeStar ) / 
                       ( 2.0 * ( NMqeStar - 1 ) ) )  : 6:3 , SMv ) ;

              SMv := 'MqeStar   =' + SMv +'"' ;
              OutText  ( SMv   ) ;

            End ;


          Repeat  Until  KeyPressed ;
            Begin
              Ch := ReadKey ;
              If Ch = #0  Then
                Ch := ReadKey ;
            End ;


    End ; { Mv }

    End ; { FileExists }





      { Model }
      { ÜÜÜÜÜ }

      MqeDx   := 0.0 ;
      MqeDy   := 0.0 ;
      NDxMean := 0   ;

      Frame ;


      For I := - MaxIndUzla  To  MaxIndUzla  Do
        For J := - MaxIndUzla  To  MaxIndUzla  Do
         If ( ArrMean [ I, J ].N > 0 )  Then
          Begin

            X  := I * StepMm       ;
            Y  := J * StepMm       ;

            ReducGsc ( X, Y, ObsRed, Dx, Dy ) ;

            Dx := - Dx ;
            Dy := - Dy ;

            Ix := Round ( X ) ;
            Iy := Round ( Y ) ;

            Inc ( NDxMean ) ;
            NStar := NStar + N ;

            MqeDx := MqeDx + Sqr ( Dx ) ;
            MqeDy := MqeDy + Sqr ( Dy ) ;


            XScr := Xc - Round ( X * Mx ) ;
            YScr := Yc - Round ( Y * My ) ;


            SetColor ( LightGray ) ;
            Circle   ( XScr, YScr, 1 ) ;
            SetColor   ( DarkGray ) ;

            Line     ( XScr, YScr,
                       XScr - Round ( Dx / Interval * StepMm * Mx ) ,
                       YScr - Round ( Dy / Interval * StepMm * My )   ) ;


          End ;


          SetViewPort ( 0, 0, GetMaxX, GetMaxY,  True ) ;

          MoveTo   ( XText, 25  ) ;

          S1 := ParamStr ( 1 ) ;
          For I := 1 To Length ( S1 ) Do
            S1 [ I ] := UpCase ( S1 [ I ] ) ;
          If ( Pos ( '.NEV', S1 ) > 0 )  Then
            S1 := Copy ( S1, 1, Pos ( '.NEV', S1 ) - 1 ) ;

          OutText  ( S1 [ 1 ] + '  ( Model ) ' ) ;


          MoveTo   ( XText, 65 ) ;
          Str      ( Interval : 5:2 , SMv ) ;

          SMv := 'Step   =' + SMv + '"' ;
          OutText  ( SMv   ) ;

          MoveTo   ( XText, 105 ) ;
          Str      ( Sqrt ( ( MqeDx ) / ( NDxMean - 1 ) ) : 7:3 , SMv ) ;

          SMv := 'MqeDx  =' + SMv +'"' ;
          OutText  ( SMv   ) ;

          MoveTo   ( XText, 115 ) ;
          Str      ( Sqrt ( ( MqeDy ) / ( NDxMean - 1 ) ) : 7:3 , SMv ) ;

          SMv := 'MqeDy  =' + SMv +'"' ;
          OutText  ( SMv   ) ;

          MoveTo   ( XText, 155 ) ;
          Str      ( NStar : 7 , SMv ) ;


          Repeat  Until  KeyPressed ;
            Begin
              Ch := ReadKey ;
              If Ch = #0  Then
                Ch := ReadKey ;
            End ;





      { Model - Obs }
      { ÜÜÜÜÜÜÜÜÜÜÜ }

      MqeDx   := 0.0 ;
      MqeDy   := 0.0 ;
      NDxMean := 0   ;

      Frame ;


      For I := - MaxIndUzla  To  MaxIndUzla  Do
        For J := - MaxIndUzla  To  MaxIndUzla  Do
         If ( ArrMean [ I, J ].N > 0 )  Then
          Begin

            X  := I * StepMm       ;
            Y  := J * StepMm       ;

            ReducGsc ( X, Y, ObsRed, Dx, Dy ) ;

            ArrMeanRec := ArrMean [ I, J ] ;

            dX1 := ArrMeanRec.dX    ;
            dY1 := ArrMeanRec.dY    ;

            Dx := Dx - Dx1 ;
            Dy := Dy - Dy1 ;

            Dx := - Dx ;
            Dy := - Dy ;

            Ix := Round ( X ) ;
            Iy := Round ( Y ) ;

            Inc ( NDxMean ) ;
            NStar := NStar + N ;

            MqeDx := MqeDx + Sqr ( Dx ) ;
            MqeDy := MqeDy + Sqr ( Dy ) ;


            XScr := Xc - Round ( X * Mx ) ;
            YScr := Yc - Round ( Y * My ) ;


            SetColor ( LightGray ) ;
            Circle   ( XScr, YScr, 1 ) ;
            SetColor   ( DarkGray ) ;

            Line     ( XScr, YScr,
                       XScr - Round ( Dx / Interval * StepMm * Mx ) ,
                       YScr - Round ( Dy / Interval * StepMm * My )   ) ;


          End ;


          SetViewPort ( 0, 0, GetMaxX, GetMaxY,  True ) ;

          MoveTo   ( XText, 25  ) ;

          S1 := ParamStr ( 1 ) ;
          For I := 1 To Length ( S1 ) Do
            S1 [ I ] := UpCase ( S1 [ I ] ) ;
          If ( Pos ( '.NEV', S1 ) > 0 )  Then
            S1 := Copy ( S1, 1, Pos ( '.NEV', S1 ) - 1 ) ;

          OutText  ( S1 [ 1 ] + '  ( Model - Obs. ) ' ) ;


          MoveTo   ( XText, 65 ) ;
          Str      ( Interval : 5:2 , SMv ) ;

          SMv := 'Step   =' + SMv + '"' ;
          OutText  ( SMv   ) ;

          MoveTo   ( XText, 105 ) ;
          Str      ( Sqrt ( ( MqeDx ) / ( NDxMean - 1 ) ) : 7:3 , SMv ) ;

          SMv := 'MqeDx  =' + SMv +'"' ;
          OutText  ( SMv   ) ;

          MoveTo   ( XText, 115 ) ;
          Str      ( Sqrt ( ( MqeDy ) / ( NDxMean - 1 ) ) : 7:3 , SMv ) ;

          SMv := 'MqeDy  =' + SMv +'"' ;
          OutText  ( SMv   ) ;

          MoveTo   ( XText, 155 ) ;
          Str      ( NStar : 7 , SMv ) ;


          Repeat  Until  KeyPressed ;
            Begin
              Ch := ReadKey ;
              If Ch = #0  Then
                Ch := ReadKey ;
            End ;



  If ( Not B_Nev )  Then
    Close ( Out ) ;


  CloseGraph;

End.
