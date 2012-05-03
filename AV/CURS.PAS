
{$O+,F+}

Unit Curs;               { Šãàá®à ¤«ï ¯®¨áª  ®¡ê¥ªâ®¢ ­  íªà ­¥ }

Interface

Uses PVar, Graph, POscreen, POutPV, PMnkHard ;

Var

 PointerMark    : pointer ;    { Mark & .... }
 PMSize         : Word    ;
 BPointerMark   : Boolean ;

 StartX,
 StartY         : Integer ;

 CInfoX,
 CInfoY         : Single  ;

 MarkRegionLeft  ,
 MarkRegionRight ,
 MarkRegionTop   ,
 MarkRegionBottom  : Integer;


Procedure  InitPtr;
Procedure  FreeMarker;
Function   Select ( Var Point : PointType ) : Boolean;


Implementation

Uses
 V_Catal, Crt, GLib, MDef, Screen, CMenu, Glass, Service,
 Info, PDetCcd, PProFld, PATan2  ;




Var

     Ch1, Ch2     : Char    ;

     Ind, IndC    : LongInt ;

     Isolve,
     NPairs       : Integer ;



Procedure  InitPtr;
Var       {ÄÄÄÄÄÄÄ}
 vp : ViewPortType;
Begin

 GetViewSettings ( vp ) ;

 With sw Do
   SetViewPort ( x1, y1, x2, y2, clipon ) ;

 SetColor ( White ) ;

 PointerWidth_Y  := Round ( PointerWidth * C10 * XAsp / Yasp ) ;
 MarkRegionLeft  := PointerWidth                               ;
 MarkRegionRight := sw.x2-sw.x1-PointerWidth                   ;
 MarkRegionTop   := PointerWidth_Y                             ;
 MarkRegionBottom:= sw.y2-sw.y1-PointerWidth_Y                 ;

 StartX := ( -sw.x1+sw.x2+1 ) Div 2;
 StartY := ( -sw.y1+sw.y2+1 ) Div 2;

 SetLineStyle ( SolidLn, 0, NormWidth ) ;

 Rectangle ( StartX-PointerWidth, StartY-PointerWidth_Y,
             StartX+PointerWidth, StartY+PointerWidth_Y  ) ;

 PMSize := ImageSize ( StartX-PointerWidth, StartY-PointerWidth_Y,
                       StartX+PointerWidth, StartY+PointerWidth_Y  ) ;

 GetMem ( PointerMark, PMSize );
 BPointerMark := True ;

 If ( PointerMark <> Nil )  Then
 GetImage ( StartX-PointerWidth, StartY-PointerWidth_Y,
            StartX+PointerWidth, StartY+PointerWidth_Y,PointerMark^ ) ;

 If ( PointerMark <> Nil )  Then
 PutImage ( StartX-PointerWidth, StartY-PointerWidth_Y, PointerMark^, XORPut );

 With vp Do
   SetViewPort(x1,y1,x2,y2,clipon);

End;



Procedure EraseSelectedStars ;
         {ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Var

 CCol         : Byte    ;
 NRecC        : LongInt ;
 Cx, Cy       : Integer ;
 dx, dy       : Double  ;
 DxSc, DySc   : Double  ;
 DxObj,DyObj  : Double  ;

Begin

 CCol := GetColor;
 {
 SetColor ( LightRed ) ;
 SetWriteMode ( XorPut ) ;
 }
 With sw Do
   Begin { sw }

     Dx := ( x2 - x1 + 1 ) / C20 ;
     Dy := ( y2 - y1 + 1 ) / C20 ;

     DxSc := XOrient * GScale * Dx / XMax  ;
     DySc := YOrient * GScale * Dy / YMax  ;

   End ;


 For Ind := 0  To  NumberOfStars - 1  Do
   Begin

     ObjectRecord := ObjectPtr [ Ind Div ObjectBlockSize ]^
                               [ Ind Mod ObjectBlockSize ] ;
     {
     NRecC := Abs ( ObjectRecord.NRecC ) ;
     }
     NRecC := ObjectRecord.NRecC ;

     If ( NRecC > 0 )  Then
       Begin

         If ( NRecC Div 1000000000 = 1 )  Then
           Begin

             ObjectRecord.NRecC := NRecC Mod 1000000000 ;
             ObjectRecord.Date  := 0 ;
             Dec ( NMarkingStars ) ;

             ObjectPtr [ Ind Div ObjectBlockSize ]^
                       [ Ind Mod ObjectBlockSize ] := ObjectRecord ;

           End ;

       End ; { NRecC > 0 }

   End ;

 {
 SetWriteMode ( NormalPut ) ;
 SetColor ( CCol ) ;
 }


 If ( NScaleArr = 0 )
   Then
     Begin  { H¥ã¢¥«¨ç¥­­®¥ ¯®«¥ }
       NMarkingStars := 0 ;
       NMarkingField := 0 ;
       NMarking      := 0 ;
     End
   Else
     Begin
       NMarkingField := 0 ;
     End ;


 If ( NMarkingStars <= 0 )  Then
   Begin
     NMarkingStars := 0 ;
     NMarkingField := 0 ;
     NMarking      := 0 ;
   End ;

 ClearScr        := True  ;
 PMScale         := False ;
 BReportOScreen  := False ;
 {
 OutPV ;
 }
 Oscreen  ;

 BReportOScreen  := True  ;
 CloseInfo ;
 InitInfo  ;

End ;




Procedure MarkingStarsInField ;
         {ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Var

 SClas ,
 CCol         : Byte    ;
 NRecC        : LongInt ;
 Cx, Cy       : Integer ;
 X, Y,
 dx, dy       : Double  ;
 DxSc, DySc   : Double  ;
 DxObj,DyObj  : Double  ;

Begin
 {
 EraseSelectedStars ;
 }
 CCol := GetColor;
 If ( NGrMarking = 0 )
   Then SetColor ( LightRed )
   Else SetColor ( MarkingCol [ NGrMarking ] ) ;
 {
 SetWriteMode ( XorPut ) ;
 }
 With sw Do
   Begin { sw }

     Dx := ( x2 - x1 + 1 ) / C20 ;
     Dy := ( y2 - y1 + 1 ) / C20 ;

     DxSc := XOrient * GScale  *  Dx / XMax  ;
     DySc := YOrient * GScale  *  Dy / YMax  ;

   End ;

 NMarkingField := 0 ;

 For IndC := 1 To CatMax Do
   Begin { IndC }
         { ÄÄÄÄ }

     SClas  := CatMax - IndC + 1 ;

     IFirst := IndCat [ SClas  ].NBeg ;
     ILast  := IndCat [ SClas  ].NEnd ;

     IndCat [ SClas  ].NStarInFild := 0 ;
     IndCat [ SClas  ].NoDetInFild := 0 ;


     If (     (    ( CalcVectDiagr And (    ( SClas  = CatCdc    )
                                         Or ( SClas  = CatHip    )
                                         Or ( SClas  = CatTyc    )
                                         Or ( SClas  = CatPpm    )
                                         Or ( SClas  = CatOthers )
                                         Or ( SClas  = CatNpm    )
                                       )
                   )
                Or ( Not CalcVectDiagr )
              )
          And ( IFirst > -1 )
        ) Then
       Begin  { IFirst > -1 }


         For Ind := IFirst  To  ILast  Do
           Begin

             ObjectRecord := ObjectPtr [ Ind Div ObjectBlockSize ]^
                                       [ Ind Mod ObjectBlockSize ] ;
             X     := ObjectRecord.X     ;
             Y     := ObjectRecord.Y     ;
             NRecC := ObjectRecord.NRecC ;


             If ( NRecC >= 0 )  Then
               Begin

                 Inc ( NMarkingStars ) ;
                 Inc ( NMarkingField ) ;

                 ObjectRecord.NRecC := NRecC Mod 1000000000 + 1000000000 ;
                 ObjectRecord.Date  := NGrMarking ;

                 ObjectPtr [ Ind Div ObjectBlockSize ]^
                           [ Ind Mod ObjectBlockSize ] := ObjectRecord ;

                 If ( CalcVectDiagr )  Then
                   Begin

                     DxObj :=   ( PmVect^[Ind].PmX / C1270 * XMax - CenterX )
                              * DxSc ;
                     DyObj :=   ( PmVect^[Ind].PmY / C1270 * YMax - CenterY )
                              * DySc ;

                     X :=  Dx + DxObj  ;
                     Y :=  Dy - DyObj  ;

                   End ;

                 Cx := Round ( X ) ;
                 Cy := Round ( Y ) ;

                 Triangle [ 1 ].X := Cx - 8 ;
                 Triangle [ 2 ].X := Cx     ;
                 Triangle [ 3 ].X := Cx + 8 ;
                 Triangle [ 4 ].X := Cx - 8 ;

                 Triangle [ 1 ].Y := Cy + 4 ;
                 Triangle [ 2 ].Y := Cy - 7 ;
                 Triangle [ 3 ].Y := Cy + 4 ;
                 Triangle [ 4 ].Y := Cy + 4 ;

                 DrawPoly ( SizeOf ( Triangle  ) Div
                            SizeOf ( PointType ), Triangle);

               End ;

           End ;

       End ;  { IFirst > -1 }

   End ; { IndC }

 {
 SetWriteMode ( NormalPut ) ;
 }
 SetColor ( CCol ) ;

End ;




Procedure MarkingSectorsPM ;
         {ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Var

 IndCol       : Byte    ;
 CCol         : Byte    ;
 NRecC        : LongInt ;
 Cx, Cy       : Integer ;
 dx, dy       : Double  ;
 DxSc, DySc   : Double  ;
 DxObj,DyObj  : Double  ;
 Pm, PmX, PmY : Double  ;
 MmSek        : Double  ;
 Direct       : Double  ;
 StepDirect   : Double  ;

Begin

 MmSek := C10 / C1270 * PmMaxMm / Fd * SekRad ;
 StepDirect := Pi / 6.0 ;
 NGrMarking := 12 ;

 CCol := GetColor;

 With sw Do
   Begin { sw }

     Dx := ( x2 - x1 + 1 ) / C20 ;
     Dy := ( y2 - y1 + 1 ) / C20 ;

     DxSc := XOrient * GScale  *  Dx / XMax  ;
     DySc := YOrient * GScale  *  Dy / YMax  ;

   End ;


 NMarkingStars := 0 ;
 NMarkingField := 0 ;


 For Ind := 0  To  NumberOfStars - 1  Do
   Begin

     ObjectRecord := ObjectPtr [ Ind Div ObjectBlockSize ]^
                               [ Ind Mod ObjectBlockSize ] ;

     NRecC := ObjectRecord.NRecC ;
     ObjectRecord.NRecC := NRecC Mod 1000000000 ;

     PmX :=   PmVect^[Ind].PmX * MmSek ;
     PmY :=   PmVect^[Ind].PmY * MmSek ;
     Pm  :=   Sqrt ( Sqr ( PmX ) + Sqr ( PmY )  ) ;

     If (      ( Pm    >= PMMarkingMin )
          And  ( NRecC >= 0            )  )  Then
       Begin

         Direct := ATan2 ( PmY , PmX ) ;

         IndCol := 1 + Trunc ( Direct / StepDirect + 0.5 ) ;
         If ( IndCol > 12 )  Then
           IndCol := 1 ;

         Inc ( NMarkingStars ) ;
         Inc ( NMarkingField ) ;

         ObjectRecord.NRecC := NRecC Mod 1000000000 + 1000000000 ;
         ObjectRecord.Date  := IndCol ;

         ObjectPtr [ Ind Div ObjectBlockSize ]^
                   [ Ind Mod ObjectBlockSize ] := ObjectRecord ;

       End ;

   End ;

 SetColor ( CCol ) ;

 ClearScr := True ;
 PmScale  := True ;
 OutPV ;
 OScreen  ;


End ;



Procedure StepMarkingSectorsPM ;
         {ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Var

 CExit        : Boolean ;
 Ch           : Char    ;
 IndCol       : Byte    ;
 CCol         : Byte    ;
 NRecC        : LongInt ;
 IndIzo       : Integer ;
 Cx, Cy       : Integer ;
 dx, dy       : Double  ;
 DxSc, DySc   : Double  ;
 DxObj,DyObj  : Double  ;
 Pm, PmX, PmY : Double  ;
 MmSek        : Double  ;
 Direct       : Double  ;
 StepDirect   : Double  ;


Begin

 MmSek := C10 / C1270 * PmMaxMm / Fd * SekRad ;
 StepDirect := Pi / 6.0 ;
 NGrMarking := 12 ;
 StepSectorMarkIzo := True ;

 CCol := GetColor;

 With sw Do
   Begin { sw }

     Dx := ( x2 - x1 + 1 ) / C20 ;
     Dy := ( y2 - y1 + 1 ) / C20 ;

     DxSc := XOrient * GScale  *  Dx / XMax  ;
     DySc := YOrient * GScale  *  Dy / YMax  ;

   End ;

 IndIzo := 0 ;
 CExit := False ;

 While ( Not CExit )  Do
 Begin

 NMarkingStars := 0 ;
 NMarkingField := 0 ;

 IndIzo := IndIzo Mod 12 ;

 For Ind := 0  To  NumberOfStars - 1  Do
   Begin

     ObjectRecord := ObjectPtr [ Ind Div ObjectBlockSize ]^
                               [ Ind Mod ObjectBlockSize ] ;

     NRecC := Abs ( ObjectRecord.NRecC );
     ObjectRecord.NRecC := NRecC Mod 1000000000 ;

     PmX :=   PmVect^[Ind].PmX * MmSek ;
     PmY :=   PmVect^[Ind].PmY * MmSek ;
     Pm  :=   Sqrt ( Sqr ( PmX ) + Sqr ( PmY )  ) ;

     If (      ( Pm    >= PMMarkingMin )
          And  ( NRecC >= 0            )  )  Then
       Begin

         Direct := ATan2 ( PmY , PmX ) ;

         IndCol := 1 + Trunc ( Direct / StepDirect + 0.5 ) ;
         If ( IndCol > 12 )  Then
           IndCol := 1 ;

         If ( IndCol = IndIzo + 1 )  Then
           Begin

             Inc ( NMarkingStars ) ;
             Inc ( NMarkingField ) ;

             ObjectRecord.NRecC := NRecC Mod 1000000000 + 1000000000 ;
             ObjectRecord.Date  := IndCol ;

           End ;

       End ;

     ObjectPtr [ Ind Div ObjectBlockSize ]^
               [ Ind Mod ObjectBlockSize ] := ObjectRecord ;

   End ;

 SetColor ( CCol ) ;

 ClearScr := True ;
 PmScale  := True ;
 OutPV ;
 OScreen          ;

 Ch := GetKey ;
 If ( Ch = EscKey )  Then
   CExit := True ;

 If ( Ch = #45 )
    Then  Dec ( IndIzo )
    Else  Inc ( IndIzo ) ;

 If ( IndIzo < 0 )  Then
      IndIzo := IndIzo + 12 ;

 End ; { While }

 StepSectorMarkIzo := False ;

End ;





Function Select ( Var Point : PointType) : Boolean;
        {ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}

Var
 X1,Y1,
 X2,Y2,
 Dx,Dy        : Integer;
 Ch           : Char;
 Speed        : Integer;
 Selected     : Boolean;
 Quit         : Boolean;
 DoMove       : Boolean;
 Code         : Integer;
 MPoint       : PointType;
 SOut,
 SOut1        : String [ 80 ] ;
 MqeMnk,
 XImp,
 YImp         : Double     ;
 CObjectImp   : ObjectType ;
 CExit        : Boolean    ;
 NStarsDetMin : Word       ;


Procedure  MoveMark ( x1,y1 : Integer; Var x2,y2 : Integer);
Var
 x,
 y : Integer;
 CHelp : CHelpType;
Begin

 x := x1 + PointerWidth   ;
 y := y1 + PointerWidth_Y ;

 If ( ( x >= MarkRegionLeft  ) And
      ( x <= MarkRegionRight ) And
      ( y >= MarkRegionTop   ) And
      ( y <= MarkRegionBottom )    )
 Then
   Begin
     If ( PointerMark <> Nil )  Then
       PutImage ( x1, y1, PointerMark^, XORPut ) ; { Erase previous one }
    End ;

 x := x2 + PointerWidth                        ;
 y := y2 + PointerWidth*LongInt(XAsp) Div Yasp ;
 If ( ( x >= MarkRegionLeft  ) And
      ( x <= MarkRegionRight ) And
      ( y >= MarkRegionTop   ) And
      ( y <= MarkRegionBottom )    )
   Then
    Begin
      If ( PointerMark <> Nil )  Then
        PutImage(x2,y2,PointerMark^,XORPut)  { Put new image }
    End
   Else
    Begin
      If ( PointerMark <> Nil )  Then
        PutImage(x1,y1,PointerMark^,XORPut); { Put new image at old place }
      x2:=x1;
      y2:=y1;
    End;

End;



Begin

 Selected       := False ;
 Quit           := False ;
 BReportOScreen := True  ;

 X1 := Point.X;
 Y1 := Point.Y;

 CursX := X1 ;
 CursY := Y1 ;

 Dx    := 0 ;
 Dy    := 0 ;
 Speed := 4 ;

 If ( PointerMark <> Nil )  Then
   PutImage ( Point.X, Point.Y, PointerMark^, XORPut ) ;

 CInfoX := X1 + PointerWidth   ;
 CInfoY := Y1 + PointerWidth_Y ;

 Repeat
  {
  If ( UserKey = UserGlass )
    Then  Ch := F4
    Else
      If ( KeyPressed )
        Then  Ch := GetKey
        Else  Ch := ' '    ;
  }

  If ( UserKey = UserGlass )
    Then  Ch := F4
    Else  Ch := GetKey ;

  DoMove    := False ;
  F4Key     := False ;
  A_Pressed := False ;

  Case Ch of

   LeftKey  : Begin
               DoMove := True ;  Dx :=-Speed ;  Dy :=   0;
              End;
   RightKey : Begin
               DoMove := True ;  Dx := Speed ;  Dy :=   0;
              End;
   UpKey    : Begin
               DoMove := True ;  Dx :=  0 ;     Dy := - Speed;
              End;
   DownKey  : Begin
               DoMove := True ;  Dx :=  0 ;     Dy :=   Speed;
              End;
   PgUpKey  : Begin
               DoMove := True ;  Dx :=  Speed ; Dy := - Speed;
              End;
   PgDnKey  : Begin
               DoMove := True ;  Dx :=  Speed ; Dy :=   Speed;
              End;
   HomeKey  : Begin
               DoMove := True ;  Dx := -Speed ; Dy := - Speed;
              End;
   EndKey   : Begin
               DoMove := True ;  Dx := -Speed ; Dy :=   Speed;
              End;


   '1'..'9' : Val ( Ch, Speed, Code );


   'A', 'a' : Begin
                A_Pressed := True ;
                Selected  := True ;
              End ;

   F1       :  Begin
                 Help ;
               End ;


   F10      :  Begin
                 FindSat ;
               End ;


   F2       : Begin

                If ( IndCat [ CatImp ].NBeg < 0 )
                  Then
                    Begin

                      Warning ( 'CCD Pixels not Present', Ch1, Ch2 ) ;
                      MarkingRepStars := False ;

                    End
                  Else
                    Begin

                      If (     ( ReductionExist      )
                           And ( Not ImportReduction )  )
                        Then
                          Begin { Old Reduction }

                            Warning ( 'Use Old Reduction?  ( Y )', Ch1, Ch2 ) ;
                            If (    ( Ch1 = 'Y'   )
                                 Or ( Ch1 = 'y'   )
                                 Or ( Ch1 = CrKey )  )
                              Then
                                Begin  { Use Old Reduction }

                                  CExit  := False ;
                                  ISolve := 1     ;

                                  While (     ( ISolve = 1 )
                                          And ( Not CExit  )  )  Do
                                    Begin  { While }

                                      For Ind := IndCat [ CatImp ].NBeg
                                              To IndCat [ CatImp ].NEnd  Do
                                        ObjectPtr [ Ind Div ObjectBlockSize]^
                                                  [ Ind Mod ObjectBlockSize].Date := 0 ;
                                      DetCcd ;


                                      Mnk1 ( RedModelType,
                                             ErrorMaxDet / SekRad * FD,
                                             Isolve,
                                             NPairs,
                                             MqeMnk,
                                             AxImp,
                                             BxImp,
                                             CxImp,
                                             AyImp,
                                             ByImp,
                                             CyImp,
                                             DImp,
                                             EImp,
                                             DistImp
                                           ) ;



                                      If ( ISolve < 1 )
                                        Then
                                          Begin
                                            Warning ( 'Bad System', Ch1, Ch2 ) ;
                                            CExit := True ;
                                          End
                                        Else
                                          Begin

                                            ReductionExist  := False ;

                                            SOut := '' ;

                                            Str ( NPairs Div 2 : 3, SOut1 ) ;
                                            While ( SOut1 [ 1 ] = ' ' )  Do
                                              Delete ( SOut1, 1, 1 ) ;
                                            SOut := SOut + 'Numb Det = '
                                                         + SOut1 ;

                                            Str ( MqeMnk / FD * SekRad : 10:3,
                                                  SOut1 ) ;
                                            While ( SOut1 [ 1 ] = ' ' )  Do
                                              Delete ( SOut1, 1, 1 ) ;
                                            SOut := SOut + '   MQE = '
                                                         + SOut1 + '"' ;

                                            SOut := SOut + '   End Det All? (Y)' ;

                                            Warning ( SOut, Ch1, Ch2 ) ;
                                            If (    ( Ch1 = 'Y'   )
                                                 Or ( Ch1 = 'y'   )
                                                 Or ( Ch1 = CrKey )  )  Then
                                              Begin

                                                CExit := True ;

                                                ReductionExist := True ;

                                                Assign  ( ConstCcdFile, ConstCcdFileName ) ;
                                                ReWrite ( ConstCcdFile                   ) ;

                                                If ( RedModelType = 1 )
                                                  Then  WriteLn ( ConstCcdFile, 6 : 8 )
                                                  Else  WriteLn ( ConstCcdFile, 9 : 8 ) ;

                                                WriteLn ( ConstCcdFile, AxImp  : 20 : 11 ) ;
                                                WriteLn ( ConstCcdFile, BxImp  : 20 : 11 ) ;
                                                WriteLn ( ConstCcdFile, CxImp  : 20 : 11 ) ;

                                                WriteLn ( ConstCcdFile, AyImp  : 20 : 11 ) ;
                                                WriteLn ( ConstCcdFile, ByImp  : 20 : 11 ) ;
                                                WriteLn ( ConstCcdFile, CyImp  : 20 : 11 ) ;

                                                If ( RedModelType = 2 )  Then
                                                  Begin

                                                    WriteLn ( ConstCcdFile, DImp        : 20 : 11,
                                                                            ErrDImp     : 15 : 11 ) ;
                                                    WriteLn ( ConstCcdFile, EImp        : 20 : 11,
                                                                            ErrEImp     : 15 : 11 ) ;
                                                    WriteLn ( ConstCcdFile, DistImp     : 20 : 11,
                                                                            ErrDistImp  : 15 : 11 ) ;

                                                  End ;

                                                WriteLn ( ConstCcdFile, MqeMnk / FD * SekRad   : 12 :  3 ) ;
                                                WriteLn ( ConstCcdFile, Fd                     : 12 :  3 ) ;
                                                WriteLn ( ConstCcdFile, RaOptVar   * Rg / 15.0 : 20 : 11 ) ;
                                                WriteLn ( ConstCcdFile, DeclOptVar * Rg        : 20 : 11 ) ;
                                                WriteLn ( ConstCcdFile, JdOut                  : 12 :  3 ) ;

                                                WriteLn ( ConstCcdFile, StepRow    : 12 :  3 ) ;
                                                WriteLn ( ConstCcdFile, StepCol    : 12 :  3 ) ;
                                                WriteLn ( ConstCcdFile, OcRow      : 12 :  3 ) ;
                                                WriteLn ( ConstCcdFile, OcCol      : 12 :  3 ) ;

                                                WriteLn ( ConstCcdFile, ARow       :  8 :  0 ) ;
                                                WriteLn ( ConstCcdFile, BCol       :  8 :  0 ) ;
                                                WriteLn ( ConstCcdFile, CRow       :  8 :  0 ) ;
                                                WriteLn ( ConstCcdFile, DCol       :  8 :  0 ) ;

                                                Close  ( ConstCcdFile ) ;

                                                MarkingRepStars := False ;

                                                ReSetObjects ;

                                                For Ind := IndCat [ CatImp ].NBeg
                                                    To IndCat [ CatImp ].NEnd  Do
                                                  Begin

                                                    CObjectImp :=
                                                      ObjectPtr [ Ind Div ObjectBlockSize]^
                                                                [ Ind Mod ObjectBlockSize] ;

                                                    XImp := CObjectImp.X ;
                                                    YImp := CObjectImp.Y ;

                                                    CObjectImp.X :=   XImp * AxImp
                                                                    + YImp * BxImp
                                                                    +        CxImp
                                                                    + Sqr ( XImp ) * DImp
                                                                    + XImp * YImp  * EImp
                                                                    + XImp * ( Sqr ( XImp ) + Sqr ( YImp ) )
                                                                           * DistImp  ;

                                                    CObjectImp.Y :=   XImp * AyImp
                                                                    + YImp * ByImp
                                                                    +        CyImp
                                                                    + XImp * YImp  * DImp
                                                                    + Sqr ( YImp ) * EImp
                                                                    + YImp * ( Sqr ( XImp ) + Sqr ( YImp ) )
                                                                           * DistImp ;

                                                    CObjectImp.Date := 0 ;

                                                    ObjectPtr [ Ind Div ObjectBlockSize]^
                                                              [ Ind Mod ObjectBlockSize] := CObjectImp ;

                                                  End ;

                                                ImportReduction := True ;

                                                OScreen ;

                                                EraseSelectedStars  ;

                                                NGrMarking := 0 ;

                                                If ( PointerMark <> Nil )  Then
                                                PutImage ( X1, Y1, PointerMark^,
                                                           XORPut ) ;

                                              End ;

                                          End ; { ISolve >= 1 }

                                    End ; { While }


                                End    { Use Old Reduction }
                              Else
                                Begin  { Not Use Old Reduction }

                                  If ( Not MarkingRepStars )  Then
                                    For Ind := IndCat [ CatImp ].NBeg
                                      To IndCat [ CatImp ].NEnd  Do
                                        ObjectPtr [ Ind Div ObjectBlockSize]^
                                                  [ Ind Mod ObjectBlockSize].Date := 0 ;

                                  MarkingRepStars := True  ;
                                  IndCatPairs     := 0     ;
                                  ReductionExist  := False ;

                                End ;  { Not Use Old Reduction }

                          End   { Old Reduction }
                        Else
                          Begin { No Old Reduction }

                            If ( ImportReduction )
                              Then
                                Begin
                                  Warning ( 'Import Stars are Reducted', Ch1, Ch2 ) ;
                                End
                              Else
                                Begin

                                  Warning ( 'Marking Pairs ( Cat -> Imp ) ?  ( Y )', Ch1, Ch2 ) ;
                                  If (    ( Ch1 = 'Y'   )
                                       Or ( Ch1 = 'y'   )
                                       Or ( Ch1 = CrKey )  )   Then
                                    Begin

                                      If ( Not MarkingRepStars )  Then
                                        For Ind := IndCat [ CatImp ].NBeg
                                          To IndCat [ CatImp ].NEnd  Do
                                            ObjectPtr [ Ind Div ObjectBlockSize]^
                                                      [ Ind Mod ObjectBlockSize].Date := 0 ;

                                      MarkingRepStars := True  ;
                                      IndCatPairs     := 0     ;

                                    End ;

                                End ;

                          End ; { No Old Reduction }

                    End ;

              End ;



   F3       : Begin

                If ( IndCat [ CatImp ].NBeg < 0 )
                  Then
                    Begin

                      Warning ( 'CCD Import not Present', Ch1, Ch2 ) ;
                      MarkingRepStars := False ;

                    End
                  Else
                    If ( Not ImportReduction )
                    Then
                    Begin { CCD Pixels Present }

                      NPairs := 0 ;
                      ISolve := 0 ;

                      For Ind := IndCat [ CatImp ].NBeg
                              To IndCat [ CatImp ].NEnd  Do
                        Begin
                          If ( ObjectPtr [ Ind Div ObjectBlockSize]^
                                         [ Ind Mod ObjectBlockSize].Date
                                            > 0 )  Then
                            Inc ( NPairs ) ;
                        End ;

                      If (     ( NPairs = 0          )
                           And ( Not ReductionExist  )  )
                        Then
                          Begin
                            Warning ( 'No Marking Pairs', Ch1, Ch2 ) ;
                          End
                        Else
                          If ( NPairs > 0 )
                          Then
                          Begin { Marking Exists }

                            Warning ( 'End Marking Pairs ?  ( Y )', Ch1, Ch2 ) ;
                            If (    ( Ch1 = 'Y' )
                                 Or ( Ch1 = 'y' )
                                 Or ( Ch1 = CrKey ) )
                              Then
                                Begin { End Marking 'Y' }

                                  If ( RedModelType = 1 )
                                    Then  NStarsDetMin := 4
                                    Else  NStarsDetMin := 6 ;

                                  If ( NPairs < ( NStarsDetMin Div 2 ) )
                                    Then
                                      Begin
                                        Str ( NStarsDetMin : 2, SOut ) ;
                                        SOut := 'Pairs <' + SOut ;
                                        Warning (  SOut, Ch1, Ch2 ) ;
                                      End
                                    Else
                                      Begin  { NPairs >= NVar }

                                        Mnk1 ( RedModelType ,
                                               ErrorMaxDet / SekRad * FD,
                                               Isolve,
                                               NPairs,
                                               MqeMnk,
                                               AxImp,
                                               BxImp,
                                               CxImp,
                                               AyImp,
                                               ByImp,
                                               CyImp,
                                               DImp,
                                               EImp,
                                               DistImp
                                             ) ;

                                        If ( ISolve < 1 )
                                          Then
                                            Begin
                                              Warning ( 'Bad System', Ch1, Ch2 ) ;
                                            End
                                          Else
                                            Begin  { Good System }

                                              ReductionExist := True ;

                                              SOut := '' ;

                                              Str ( NPairs Div 2 : 3, SOut1 ) ;
                                              While ( SOut1 [ 1 ] = ' ' )  Do
                                                Delete ( SOut1, 1, 1 ) ;
                                              SOut := SOut +
                                               'Numb Det = ' + SOut1 ;

                                              Str ( MqeMnk / FD * SekRad : 10:3,
                                                    SOut1 ) ;
                                              While ( SOut1 [ 1 ] = ' ' )  Do
                                                Delete ( SOut1, 1, 1 ) ;
                                              SOut := SOut +
                                               '   MQE = ' + SOut1 + '"' ;

                                              SOut := SOut + '  Det. All Stars? (Y)' ;
                                              Warning ( SOut, Ch1, Ch2 ) ;

                                              If (    ( Ch1 = 'Y'   )
                                                   Or ( Ch1 = 'y'   )
                                                   Or ( Ch1 = CrKey )  )
                                                Then
                                                  Begin { Det All }

                                                    CExit := False ;

                                                    While (     ( ISolve = 1 )
                                                            And ( Not CExit  )  )  Do
                                                      Begin  { While }

                                                        DetCcd ;

                                                        Mnk1 ( RedModelType,
                                                               ErrorMaxDet / SekRad * FD,
                                                               Isolve,
                                                               NPairs,
                                                               MqeMnk,
                                                               AxImp,
                                                               BxImp,
                                                               CxImp,
                                                               AyImp,
                                                               ByImp,
                                                               CyImp,
                                                               DImp,
                                                               EImp,
                                                               DistImp
                                                             ) ;

                                                        If ( ISolve < 1 )
                                                          Then
                                                            Begin
                                                              Warning ( 'Bad System', Ch1, Ch2 ) ;
                                                              CExit := True ;
                                                            End
                                                          Else
                                                            Begin

                                                              ReductionExist  := False ;

                                                              SOut := '' ;

                                                              Str ( NPairs Div 2 : 3, SOut1 ) ;
                                                              While ( SOut1 [ 1 ] = ' ' )  Do
                                                                Delete ( SOut1, 1, 1 ) ;
                                                              SOut := SOut +
                                                                'Numb Det= ' + SOut1 ;

                                                              Str ( MqeMnk / FD * SekRad : 10:3,
                                                                    SOut1 ) ;
                                                              While ( SOut1 [ 1 ] = ' ' )  Do
                                                                Delete ( SOut1, 1, 1 ) ;
                                                              SOut := SOut +
                                                                '   MQE = ' + SOut1 + '"' ;

                                                              SOut := SOut + '   End Det All? (Y)' ;
                                                              Warning ( SOut, Ch1, Ch2 ) ;

                                                              If (    ( Ch1 = 'Y'   )
                                                                   Or ( Ch1 = 'y'   )
                                                                   Or ( Ch1 = CrKey )  )   Then
                                                                Begin

                                                                  CExit := True ;

                                                                  ReductionExist := True ;

                                                                  Assign  ( ConstCcdFile, ConstCcdFileName ) ;
                                                                  ReWrite ( ConstCcdFile                   ) ;

                                                                  If ( RedModelType = 1 )
                                                                    Then  WriteLn ( ConstCcdFile, 6 : 8 )
                                                                    Else  WriteLn ( ConstCcdFile, 9 : 8 ) ;

                                                                  WriteLn ( ConstCcdFile, AxImp  : 20 : 11 ) ;
                                                                  WriteLn ( ConstCcdFile, BxImp  : 20 : 11 ) ;
                                                                  WriteLn ( ConstCcdFile, CxImp  : 20 : 11 ) ;

                                                                  WriteLn ( ConstCcdFile, AyImp  : 20 : 11 ) ;
                                                                  WriteLn ( ConstCcdFile, ByImp  : 20 : 11 ) ;
                                                                  WriteLn ( ConstCcdFile, CyImp  : 20 : 11 ) ;

                                                                  If ( RedModelType = 2 )  Then
                                                                    Begin

                                                                      WriteLn ( ConstCcdFile, DImp        : 20 : 11,
                                                                                              ErrDImp     : 15 : 11 ) ;
                                                                      WriteLn ( ConstCcdFile, EImp        : 20 : 11,
                                                                                              ErrEImp     : 15 : 11 ) ;
                                                                      WriteLn ( ConstCcdFile, DistImp     : 20 : 11,
                                                                                              ErrDistImp  : 15 : 11 ) ;

                                                                    End ;

                                                                  WriteLn ( ConstCcdFile, MqeMnk / FD * SekRad   : 12 :  3 ) ;
                                                                  WriteLn ( ConstCcdFile, Fd                     : 12 :  3 ) ;
                                                                  WriteLn ( ConstCcdFile, RaOptVar   * Rg / 15.0 : 20 : 11 ) ;
                                                                  WriteLn ( ConstCcdFile, DeclOptVar * Rg        : 20 : 11 ) ;
                                                                  WriteLn ( ConstCcdFile, JdOut                  : 12 :  3 ) ;

                                                                  WriteLn ( ConstCcdFile, StepRow    : 12 :  3 ) ;
                                                                  WriteLn ( ConstCcdFile, StepCol    : 12 :  3 ) ;
                                                                  WriteLn ( ConstCcdFile, OcRow      : 12 :  3 ) ;
                                                                  WriteLn ( ConstCcdFile, OcCol      : 12 :  3 ) ;

                                                                  WriteLn ( ConstCcdFile, ARow       :  8 :  0 ) ;
                                                                  WriteLn ( ConstCcdFile, BCol       :  8 :  0 ) ;
                                                                  WriteLn ( ConstCcdFile, CRow       :  8 :  0 ) ;
                                                                  WriteLn ( ConstCcdFile, DCol       :  8 :  0 ) ;

                                                                  Close  ( ConstCcdFile ) ;



                                                                  { Begin  Recalc }

                                                                  MarkingRepStars := False ;

                                                                  ReSetObjects ;

                                                                  For Ind := IndCat [ CatImp ].NBeg
                                                                    To IndCat [ CatImp ].NEnd  Do
                                                                    Begin

                                                                      CObjectImp :=
                                                                        ObjectPtr [ Ind Div ObjectBlockSize]^
                                                                                  [ Ind Mod ObjectBlockSize] ;

                                                                      XImp := CObjectImp.X ;
                                                                      YImp := CObjectImp.Y ;

                                                                      CObjectImp.X :=   XImp * AxImp
                                                                                      + YImp * BxImp
                                                                                      +        CxImp
                                                                                      + Sqr ( XImp ) * DImp
                                                                                      + XImp * YImp  * EImp
                                                                                      + XImp * ( Sqr ( XImp ) + Sqr ( YImp ) )
                                                                                             * DistImp  ;

                                                                      CObjectImp.Y :=   XImp * AyImp
                                                                                      + YImp * ByImp
                                                                                      +        CyImp
                                                                                      + XImp * YImp  * DImp
                                                                                      + Sqr ( YImp ) * EImp
                                                                                      + YImp * ( Sqr ( XImp ) + Sqr ( YImp ) )
                                                                                             * DistImp ;

                                                                      CObjectImp.Date := 0 ;

                                                                      ObjectPtr [ Ind Div ObjectBlockSize]^
                                                                                [ Ind Mod ObjectBlockSize] := CObjectImp ;

                                                                    End ;


                                                                  ImportReduction := True ;
                                                                  {
                                                                  DetCcd ;
                                                                  }
                                                                  OScreen ;

                                                                  EraseSelectedStars  ;

                                                                  NGrMarking := 0 ;

                                                                  If ( PointerMark <> Nil )  Then
                                                                  PutImage ( X1, Y1, PointerMark^,
                                                                                     XORPut ) ;

                                                                  { End  Recalc }


                                                                End ;

                                                            End ; { ISolve >= 1 }

                                                      End ; { While }

                                                  End ; { Det All }

                                            End ; { Good System Manu }

                                      End ; { NPairs >= NVar }

                                  (*
                                  If (     ( NPairs >= NStarsDetMin )
                                       And ( ReductionExist         )
                                       And ( ISolve >= 1            )  )  Then
                                    Begin  { Red Exist }

                                      Warning ( 'Recalc All Stars?  ( Y ) ', Ch1, Ch2 ) ;
                                      If (    ( Ch1 = 'Y'   )
                                           Or ( Ch1 = 'y'   )
                                           Or ( Ch1 = CrKey )  )   Then


                                    End ;  { Red Exist }

                                  *)
                                End ; { End Marking Manu }

                          End   { Marking Exists }
                          Else
                            Begin
                              Warning ( 'No Marking Stars', Ch1, Ch2 ) ;
                            End ;

                    End  { CCD Pixels Present & Not Reducted }

              End ; { F3 }



   F5       : Begin
                If ( NMarkingField > 0 )
                  Then
                    Begin
                      Warning ( 'Marking All Stars in Field ?  ( Y )', Ch1, Ch2 ) ;
                      If (    ( Ch1 = 'Y'   )
                           Or ( Ch1 = 'y'   )
                           Or ( Ch1 = CrKey )  )   Then
                        Begin

                          Inc ( NGrMarking ) ;

                          If  ( NGrMarking > 12 )  Then
                            NGrMarking := 1 ;

                          MarkingStarsInField ;

                        End ;
                    End
                  Else
                    Begin

                      Inc ( NGrMarking ) ;

                      If  ( NGrMarking > 12 )  Then
                        NGrMarking := 1 ;

                      MarkingStarsInField ;

                    End ;

              End ;


   F6       : If ( B_VectDiagr )  Then
              Begin
                If ( NMarkingStars > 0 )
                  Then
                    Begin
                      Warning ( 'Marking  Sektor  Prop. Mou. ?  ( Y )', Ch1, Ch2 ) ;
                      If (    ( Ch1 = 'Y'   )
                           Or ( Ch1 = 'y'   )
                           Or ( Ch1 = CrKey )  )   Then
                        Begin
                          StepMarkingSectorsPM  ;
                        End ;
                    End
                  Else
                    Begin
                      StepMarkingSectorsPM  ;
                    End ;

              End ;

   F7       : If ( B_VectDiagr )  Then
              Begin
                If ( NMarkingStars > 0 )
                  Then
                    Begin
                      Warning ( 'Marking  All Sektors  Prop. Mou. ?  ( Y )', Ch1, Ch2 ) ;
                      If (    ( Ch1 = 'Y'   )
                           Or ( Ch1 = 'y'   )
                           Or ( Ch1 = CrKey )  )   Then
                        Begin
                          If ( PointerMark <> Nil )  Then
                          PutImage(x1,y1,PointerMark^,XORPut); { Erase previous one }
                          MarkingSectorsPM  ;
                          If ( PointerMark <> Nil )  Then
                          PutImage(x1,y1,PointerMark^,XORPut); { Erase previous one }
                        End ;
                    End
                  Else
                    Begin
                      If ( PointerMark <> Nil )  Then
                      PutImage(x1,y1,PointerMark^,XORPut); { Erase previous one }
                      MarkingSectorsPM  ;
                      If ( PointerMark <> Nil )  Then
                      PutImage(x1,y1,PointerMark^,XORPut); { Erase previous one }
                    End ;

              End ;

   F8       : Begin
                If ( NMarkingField > 0 )
                  Then
                    Begin
                      Warning ( 'Erase All Marking ?  ( Y )', Ch1, Ch2 ) ;
                      If (    ( Ch1 = 'Y'   )
                           Or ( Ch1 = 'y'   )
                           Or ( Ch1 = CrKey )  )   Then
                        Begin
                          EraseSelectedStars  ;
                          NGrMarking := 0 ;
                          If ( PointerMark <> Nil )  Then
                          PutImage ( X1, Y1, PointerMark^, XORPut ) ;
                        End ;
                    End
                  Else
                    Begin
                      EraseSelectedStars  ;
                      NGrMarking := 0 ;
                      If ( PointerMark <> Nil )  Then
                      PutImage ( X1, Y1, PointerMark^, XORPut ) ;
                    End ;

              End ;



   F4       : Begin
               CrsMenu   ;
               F4Key    := True ;
               Selected := True ;
              End ;

   CrKey    : Selected := True;

   EscKey   :
              Quit := True;

  End;


 NFound := 0 ;
 MessageAV ( '', False ) ;


  If ( DoMove )  Then
   Begin

    X2 := X1+Dx;
    Y2 := Y1+Dy;

    X2 := Max ( MarkRegionLeft   - PointerWidth  , X2 );
    X2 := Min ( MarkRegionRight  - PointerWidth  , X2 );

    Y2 := Max ( MarkRegionTop    - PointerWidth_Y, Y2 );
    Y2 := Min ( MarkRegionBottom - PointerWidth_Y, Y2 );

    MoveMark ( X1, Y1,  X2, Y2 );

    X1 := X2 ;
    Y1 := Y2 ;

    CursX := X1 ;
    CursY := Y1 ;


    { ’¥ªãé¥¥ ¯®«®¦¥­¨¥ ¤«ï ‹ã¯ë }

    CInfoX := X1 + PointerWidth   ;
    CInfoY := Y1 + PointerWidth_Y ;

   End;

 Until ( Selected Or Quit );

 Select := Not Quit;

 If (     ( Point.X = X1 )
      And ( Point.Y = Y1 ) )
    Then
      Begin
        If ( Not PointPrima )  Then
          Marking := True ;   { ®¢â®p­®¥ ­ ¦ â¨¥ CR -> Œ pª¨p®¢ª  ®¡ê¥ªâ  }
      End
    Else
          Marking := False ;

 Point.X := X1 ;
 Point.Y := Y1 ;

 If ( PointerMark <> Nil )  Then
   PutImage ( Point.X, Point.Y, PointerMark^, XORPut ) ;

 PointPrima := False ;


End; { Function Select }

Procedure  FreeMarker;
Begin
 If ( PointerMark <> Nil )  Then
   FreeMem ( PointerMark, PMSize );
 PointerMark := Nil ;
End;

End.