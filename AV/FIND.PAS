
{$F+,O+}

Unit Find;
Interface

Function FindObject( OX,OY : Integer; var Ident : integer ) : boolean;

{            Поиск объекта среди звезд и планет.
             ──────────────────────────────────
  Возвращается - 1. Номер звезды ( 0 - NumberofStars - 1)
                 2. Hoмер планеты со знаком минус
                 3. -(Hомеp спутника+число планет)
                 4. -100, если не найден.
}


Implementation
Uses
 Crt , Graph, Curs, Screen, PVar, V_Catal, Shell_X ;

Function FindObject ( OX, OY : integer; var Ident : integer ) : boolean;

var

 Found,
 CExit,
 FoundPln,
 FoundStr     : Boolean ;

 Ch1, Ch2     : Char    ;
 CCol         : Byte    ;

 Cx, Cy,
 IndCatOut,
 NSat         : Integer ;

 NRecC,
 Ind,
 IndC,
 IndCFound,
 CatFind,
 I1, I2       : LongInt ;

 IndFind      : Word    ;

 FX,
 D1,D2,
 XMinFind,
 XMaxFind,
 RR, RR1,
 RRx, RRy     : Double  ;

 D,
 X, Y, Z,
 dx, dy       : Double  ;
 DxSc, DySc   : Double  ;
 DxObj,DyObj  : Double  ;

 S            : String  ;

Begin

 FoundPln := False ;
 FoundStr := False ;

 S_mess_AV       := ''     ;
 B_Color_Mess_Av := False  ;
 If ( Out_Mess_AV )  Then
   MessageAV ( '', False ) ;
 Out_Mess_AV := False  ;

{ Поиск планеты, если оные изображаются }
{ ───────────────────────────────────── }

 {
 Ind := 0 ;

 Repeat

   Inc ( Ind ) ;

   If (     ( Planet^[Ind].Visible    )
        And ( Planet^[Ind].NowVisible )  )  Then
     With Planet^[Ind] Do
       Begin

         D  := D_IZO * GScale / PVar.XMax * ( sw.x2 - sw.x1 + 1 ) / C20;

         RR := D / C20 + PointerWidth;
         D1 := ( X - OX ) / RR;

         RR := RR * XAsp / YAsp ;
         D2 := ( Y - OY ) / RR   ;

         RR := Sqrt (  Sqr ( D1 ) + Sqr ( D2 )  ) ;

         FoundPln := ( RR <= C10 );

       End;

 Until  (    ( FoundPln              )
          Or ( Ind >= NPlanetsInFild )  )  ;
 }

 Ind := 0 ;

 Repeat

   Inc ( Ind ) ;

   If ( Ind <= NPlanetsInFild )  Then
     PlanetRecord := PlanetPtr [ Ind Div PlanetBlockSize ]^
                               [ Ind Mod PlanetBlockSize ] ;

   If (     ( PlanetRecord.Visible    )
        And ( PlanetRecord.NowVisible )  )  Then
     With PlanetRecord Do
       Begin

         D  := D_IZO * GScale / PVar.XMax * ( sw.x2 - sw.x1 + 1 ) / C20;

         RR := D / C20 + PointerWidth;
         D1 := ( X - OX ) / RR;

         RR := RR * XAsp / YAsp ;
         D2 := ( Y - OY ) / RR   ;

         RR := Sqrt (  Sqr ( D1 ) + Sqr ( D2 )  ) ;

         FoundPln := ( RR <= C10 );

       End;

 Until  (    ( FoundPln              )
          Or ( Ind >= NPlanetsInFild )  )  ;



 If ( FoundPln )  Then
   Begin

     FindObject:=True;
     Ident:=-Ind;

     NSat := PlanetRecord.Nr - Max_Pl_PPlFld ;

     If (     ( Marking  )
          And ( NSat > 0 )  ) Then
       Begin
         With PlanetRecord  Do
           Begin

             Cx := Round ( X ) ;
             Cy := Round ( Y ) ;

             SetWriteMode ( XORPut ) ;
             CCol := GetColor;

             If ( Phase > 0 )
                Then SetColor ( White    )
                Else SetColor ( LightRed ) ;

             Line ( Cx - 4 , Cy     , Cx + 4 , Cy     ) ;
             Line ( Cx     , Cy - 3 , Cx     , Cy + 3 ) ;

             SetColor ( CCol ) ;
             SetWriteMode ( NormalPut ) ;

             Reset ( SatNameFile             ) ;
             Seek  ( SatNameFile, NSat - 1   ) ;
             Read  ( SatNameFile, SatNameRec ) ;

             SatNameRec.NumberSat := - SatNameRec.NumberSat ;

             FileMode := 2 ;
             Seek  ( SatNameFile, NSat - 1    ) ;
             Write ( SatNameFile, SatNameRec  ) ;
             FileMode := 0 ;

             Close ( SatNameFile              ) ;

           End ;

       End ;

   End;



 If  Not  FoundPln   Then
   Begin  { Поищем звезду }
          { ───────────── }

     With sw Do
       Begin { sw }

         Dx := ( x2 - x1 + 1 ) / C20 ;
         Dy := ( y2 - y1 + 1 ) / C20 ;

         DxSc := XOrient * GScale  *  Dx / XMax  ;
         DySc := YOrient * GScale  *  Dy / YMax  ;

       End ;



     IndCatOut :=     1  ;
     NFound    :=     0  ;
     FoundStr  := False  ;
     CatFind   :=   - 1  ;

     {
     While (     ( IndCatOut <= CatIzoMax )
             And ( Not FoundStr           )  )  Do
     }
     While ( IndCatOut <= CatIzoMax )  Do
       Begin  { IndC }
              { ──── }

         IndC := PrioritetIzo [ IndCatOut ] ;

         IFirst := IndCat [ IndC ].NBeg ;
         ILast  := IndCat [ IndC ].NEnd ;

         If ( IFirst > -1 ) Then
           Begin { ILast >= IFirst }
                 { ─────────────── }

             If (     ( Not CalcVectDiagr        )
                  And ( CatSort [ IndC ] = False )  )  Then
               Begin
                 Message ('Sorting objects in FoV', True );
                 ShellX  ( IFirst , ILast ) ;
                 CatSort [ IndC ] := True ;
                 Puts(mess_w,True,1,1,centertext,centertext,'');
               End ;

             DMvOScr :=  0 ;



                    { FIND Ind. }
                    { ───────── }

             XMinFind := OX - PointerWidth - 2 ;
             XMaxFind := OX + PointerWidth + 2 ;

             I1  := IFirst ;
             I2  := ILast  ;
             Ind := 0      ;

             If ( Not CalcVectDiagr )  Then
               While ( (I2-I1) > 1 ) Do
                 Begin  { I2-I1 > 1 }

                   Ind := ( I1 + I2 ) Div 2 ;

                   FX := Objectptr [ Ind Div ObjectBlockSize ]^
                                   [ Ind Mod ObjectBlockSize ].X;

                   If  ( FX <= XMinFind )
                     Then  I1 := Ind
                     Else  I2 := Ind ;

                 End ; { I2-I1 > 1 }


             Ind      := I1 - 1  ;
             CExit    := False   ;
             {
             FoundStr := False   ;
             NFound   := 0       ;
             RRx      := 1 + PointerWidth  ;
             }
             RRx      := PointerWidth       ;
             RRy      := RRx * XAsp / YAsp  ;
             RR       := 100000.0           ;



             While (     ( Not CExit   )
                     And ( Ind < ILast )  )  Do
               Begin

                 Inc ( Ind ) ;

                 If ( CalcVectDiagr )
                   Then
                     Begin

                       DxObj := ( PmVect^[Ind].PmX / C1270 * XMax - CenterX )
                                * DxSc ;
                       DyObj := ( PmVect^[Ind].PmY / C1270 * YMax - CenterY )
                                * DySc ;

                       X :=  Dx + DxObj  ;
                       Y :=  Dy - DyObj  ;

                       NRecC := ObjectPtr [ Ind Div ObjectBlockSize ]^
                                          [ Ind Mod ObjectBlockSize ].NRecC ;
                     End
                   Else
                     Begin
                       ObjectRecord :=
                           ObjectPtr [ Ind Div ObjectBlockSize ]^
                                     [ Ind Mod ObjectBlockSize ] ;
                       X     := ObjectRecord.X     ;
                       Y     := ObjectRecord.Y     ;
                       NRecC := ObjectRecord.NRecC ;
                     End ;


                 If ( NRecC >= 0 )  Then
                   Begin

                     If ( Not CalcVectDiagr )  Then
                       CExit := X > XMaxFind ;

                     D1 := X - OX ;
                     D2 := Y - OY ;

                     If (     ( Abs ( D1 ) <= RRx )
                          And ( Abs ( D2 ) <= RRy )  )   Then
                       Begin

                         Inc ( NFound ) ;

                         If ( NFound <= 100 )  Then
                           Begin
                             NumberStarCursor [ NFound ] := Ind  ;
                             CatStarCursor    [ NFound ] := IndC ;
                             IndCFound                   := IndC ;
                           End ;

                         RR1 := Sqrt ( Sqr ( D1 ) + Sqr ( D2 ) ) ;

                         If  ( RR1 < RR )  Then
                           Begin

                             If ( CatFind < 0 )  Then
                               CatFind  := IndC ;

                             If ( IndC = CatFind )  Then
                               Begin
                                 RR       := RR1  ;
                                 IndFind  := Ind  ;
                                 FoundStr := True ;
                               End ;

                           End ;

                       End ;

                   End ; { NRecC >= 0 }

               End ;  { While }

           End ; { ILast >= IFirst }
             { ─────────────── }
       {
       IndC   := IndC + 1 ;
       }
       Inc ( IndCatOut ) ;

     End ;  { IndC }
            { ──── }



   If ( FoundStr )   Then
     Begin

       If ( NFound > 1 )  Then
         Begin
           Str ( NFound : 4, S ) ;
           While (     ( S [ 1 ]      = ' ' )
                   And ( Length ( S ) > 1   )  )  Do
             Delete ( S, 1, 1 ) ;

           S_mess_AV       :=  S + ' stars found' ;
           B_Color_Mess_Av :=  True               ;
           Out_Mess_AV     :=  True               ;

           MessageAV ( S_mess_AV, B_Color_Mess_Av );

           Sound ( 1000 ) ;
           Delay (  100 ) ;
           NoSound        ;


         End ;


       Dec ( IndC ) ;
       Ind        := IndFind ;
       FindObject := True    ;
       Ident      := Ind     ;

       If (     ( Marking    )
            And ( NFound = 1 )  ) Then
         Begin
           With ObjectPtr [ Ind Div ObjectBlockSize ]^
                          [ Ind Mod ObjectBlockSize ]  Do
             Begin

               I1 := NRecC Div 1000000000 ;
               I1 := ( I1 + 1 ) Mod 2 ;
               NRecC := NRecC Mod 1000000000 + I1 * 1000000000 ;

               If ( I1 = 1 )
                 Then
                   Begin

                     Inc ( NMarkingStars ) ;
                     Inc ( NMarkingField ) ;
                     Inc ( NMarking      ) ;

                     If (     ( IndCFound = CatImp          )
                          And (    ( Not ReductionExist  )
                                Or ( Not ImportReduction )  )  )
                       Then
                         Begin
                           If ( IndCatPairs = 0 )
                             Then
                               Begin
                                 Warning ( 'Marking Pairs: First Star -> Catalogue', Ch1, Ch2 ) ;
                               End
                             Else
                                 Date := IndCatPairs ;
                         End
                       Else
                         Begin
                           Date        := NMarking ;
                           IndCatPairs := Ind      ;
                         End ;

                   End
                 Else
                   Begin

                     If (     ( IndC = CatImp               )
                          And (    ( Not ReductionExist  )
                                Or ( Not ImportReduction )  )  )
                       Then
                         Begin
                           Date := 0 ;
                         End
                       Else
                         Begin
                           If ( Date = NMarking )  Then
                             Dec ( NMarking ) ;
                         End ;

                        Dec ( NMarkingStars ) ;
                        Dec ( NMarkingField ) ;

                   End ;

             End ;   { ObjectPtr }




           If ( CalcVectDiagr )
             Then
               Begin

                 DxObj := ( PmVect^[Ind].PmX / C1270 * XMax - CenterX ) * DxSc ;
                 DyObj := ( PmVect^[Ind].PmY / C1270 * YMax - CenterY ) * DySc ;

                 X :=  Dx + DxObj  ;
                 Y :=  Dy - DyObj  ;

                 Cx := Round ( X ) ;
                 Cy := Round ( Y ) ;

               End
             Else
               Begin

                 ObjectRecord := ObjectPtr [ Ind Div ObjectBlockSize ]^
                                           [ Ind Mod ObjectBlockSize ] ;
                 Cx := Round ( ObjectRecord.X ) ;
                 Cy := Round ( ObjectRecord.Y ) ;

               End ;


           CCol := GetColor;
           SetColor ( LightRed ) ;
           SetWriteMode ( XorPut ) ;

           Triangle [ 1 ].X := Cx - 8 ;
           Triangle [ 2 ].X := Cx     ;
           Triangle [ 3 ].X := Cx + 8 ;
           Triangle [ 4 ].X := Cx - 8 ;

           Triangle [ 1 ].Y := Cy + 4 ;
           Triangle [ 2 ].Y := Cy - 7 ;
           Triangle [ 3 ].Y := Cy + 4 ;
           Triangle [ 4 ].Y := Cy + 4 ;

           DrawPoly ( SizeOf ( Triangle ) Div
                      SizeOf ( PointType ), Triangle);

           SetWriteMode ( NormalPut ) ;
           SetColor ( CCol ) ;

         End ;

       End
     Else
       Begin
         FindObject :=  False ;
         Ident      := - 100  ;
       End;

   End ; { Поискали звезду }
         { ─────────────── }



 If ( Not (    ( FoundPln )
            Or ( FoundStr )  )  )  Then
   Begin

     FindObject :=   False ;
     Ident      := - 100   ;
     DateNoObj  := -   1   ;

     If ( Marking )  Then
       Begin  { Маpкиpовка пустого места  ->  пpопуск номеpа }
         Inc ( NMarking ) ;
         DateNoObj := NMarking ;
         Marking   := False    ;
       End ;

   End;

End;

End.
