
{$O+,F+}

Unit glass;
Interface

Type
 RealPointType = Record
                   x, y : Double ;
                 End;

Var
 gcx, gcy : Double ;

Procedure DoGlass  ;
Procedure UndoGlass;
Implementation

Uses
 Screen, PVar, Graph, GLib, PProFld, PPreNew, POScreen, Curs;



 Procedure DoGlass;
{컴컴컴컴컴컴컴컴�}

Var
 S_Cent   ,
 S_Size   : RealPointType;

 C        : Byte     ;
 Vp       : ViewPortType;

 Dx, Dy   ,
 Dw, Dh   : Double   ;

 doincdec ,
 domove   ,
 selected ,
 Quit     : Boolean  ;

 Speed  : Byte     ;
 Ch     : Char     ;
 Rat    : Double   ;
 Cx, Cy : Double   ;
 CScale : Double   ;
 i      : Integer  ;
 OldStyle   : LineSettingsType;

Begin

 InitGw;
 SetWriteMode(XORPut)   ;
 Getviewsettings(Vp);
 GetLineSettings(OldStyle);
 C:=GetColor;

 SetColor     ( LightCyan                ) ;
 SetLineStyle ( SolidLn   , 0, NormWidth ) ;

 With Sw Do
 Begin

  Rat:= ( C10 * XAsp ) / YAsp * YMax / XMax;

  Cx := ( x2 - x1 + 1 ) / C20 ;
  Cy := ( y2 - y1 + 1 ) / C20 ;

  S_Cent.x := gcx ;
  S_Cent.y := gcy ;
  S_Size.x := PointerWidth  ;
  S_Size.y := S_Size.x * Rat;
  ReportGs ( 2 * S_Size.x, 2 * S_Size.y );
  ReportGc ( S_Cent.x, S_Cent.y );

  SetViewPort(x1,y1,x2,y2,clipon);

  RectAngle ( Round ( S_Cent.x - S_Size.x ), Round ( S_Cent.y - S_Size.y ),
              Round ( S_Cent.x + S_Size.x ), Round ( S_Cent.y + S_Size.y ) );

  Selected := False;
  Quit:=False;
  Dx:=0;
  Dy:=0;
  Dw:=0;
  Dh:=0;
  Speed:=4;

 Repeat

  Ch := GetKey;

  DoMove   := False ;
  DoIncDec := False ;
  OutPoint := False ;

  Case Ch Of
                          { 맆㎚�贍 }
   InsKey, #43       :
                       If ( (S_Cent.x+S_Size.x + Speed < 2 * Cx)
                        And (S_Cent.x-S_Size.x - Speed > 0     )
                        And (S_Cent.y+S_Size.y + Speed*Rat < 2 * Cy)
                        And (S_Cent.y-S_Size.y - Speed*Rat > 0     ) )  Then
                           Begin
                             DoIncDec := True     ;
                             Dw       := Speed    ;
                             Dh       := Dw * Rat ;
                           End;

   DelKey, #45       :
                       If ( (S_Size.x > Speed    +2)
                        And (S_Size.y > Speed*Rat+1) )   Then
                          Begin
                           DoIncDec := True     ;
                           Dw       := -Speed   ;
                           Dh       := Dw * Rat ;
                          End;

                           { 뼢�循 }
   UpKey             : If ( (S_Cent.y-S_Size.y-Speed*Rat) > 0   )  Then
                        Begin
                         DoMove :=  True      ;
                         Dy     := -Speed*Rat ;
                         Dx     :=  0         ;
                        End;

   DownKey           : If ( (S_Cent.y+S_Size.y+Speed*Rat) < 2*Cy ) Then
                        Begin
                         DoMove :=  True      ;
                         Dy     :=  Speed*Rat ;
                         Dx     :=  0         ;
                        End;

   LeftKey           : If ( (S_Cent.x-S_Size.x-Speed) > 0    )  Then
                         Begin
                          DoMove :=  True  ;
                          Dx     := -Speed ;
                          Dy     :=  0     ;
                         End;

   RightKey          : If ( (S_Cent.x+S_Size.x+Speed) < 2*Cx )   Then
                        Begin
                         DoMove :=  True  ;
                         Dx     :=  Speed ;
                         Dy     :=  0     ;
                        End;

   F9                :  Begin
                         DoMove   := True  ;
                         OutPoint := True  ;
                         Dx       :=  0    ;
                         Dy       :=  0    ;
                         FlagF9   := True  ;
                        End;

   F1       :  Begin
                 Help ;
               End ;

   '1'..'9' : Val ( Ch, Speed, Code )  ;

   CrKey    : Selected := True    ;

   EscKey   : Quit     := True    ;

  End; { case }

  If DoMove Then
    Begin

      RectAngle ( Round ( S_Cent.x - S_Size.x ), Round ( S_Cent.y - S_Size.y ),
                  Round ( S_Cent.x + S_Size.x ), Round ( S_Cent.y + S_Size.y ) );

      S_Cent.x := S_Cent.x + Dx ;
      S_Cent.y := S_Cent.y + Dy ;
      RectAngle ( Round ( S_Cent.x - S_Size.x ), Round ( S_Cent.y - S_Size.y ),
                  Round ( S_Cent.x + S_Size.x ), Round ( S_Cent.y + S_Size.y ) );

      ReportGc ( S_Cent.x, S_Cent.y ) ;

      If ( OutPoint )  Then
        Begin
          SetColor ( LightGreen ) ;
          Line ( Trunc ( S_Cent.x - 2 ) , Trunc ( S_Cent.y     ) ,
                 Trunc ( S_Cent.x + 2 ) , Trunc ( S_Cent.y     )   ) ;
          Line ( Trunc ( S_Cent.x     ) , Trunc ( S_Cent.y - 2 ) ,
                 Trunc ( S_Cent.x     ) , Trunc ( S_Cent.y + 2 )   ) ;
          SetColor ( LightCyan  ) ;
        End ;
    End ;

  If DoIncDec Then
    Begin
      RectAngle ( Round ( S_Cent.x - S_Size.x ), Round ( S_Cent.y - S_Size.y ),
                  Round ( S_Cent.x + S_Size.x ), Round ( S_Cent.y + S_Size.y ) );

      S_Size.x := S_Size.x + Dw ;
      S_Size.y := S_Size.y + Dh ;
      RectAngle ( Round ( S_Cent.x - S_Size.x ), Round ( S_Cent.y - S_Size.y ),
                  Round ( S_Cent.x + S_Size.x ), Round ( S_Cent.y + S_Size.y ) );

      ReportGs( 2*S_Size.x, 2*S_Size.y );
    End ;

 Until ( Selected Or Quit );

   { End Repeat }
   { 컴컴컴컴컴 }


 Selected := Not Quit;

 End ;

 {  뒶�ζ 咨�젺��� �젩�瞬; ��誓��� 璵�循� � 쵟訟�젩ⓣ�쥯���  }
 {  컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�  }

If ( Not Quit )  Then
Begin  { Not Quit }
       { 컴컴컴컴 }

 ScToId ( S_Cent.x, S_Cent.y, Cx, Cy) ;

 CScale := ( Sw.x2 - Sw.x1 + C10 ) / ( 2 * S_Size.x + 1 ) ;


 { 궙遜�젺�˘� Ħ쪧レ�瑜 ぎ�西Þ졻� �↔ⅹ獸� }
 { 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴� }
 ResetObjects ;


 { 뜮�瑜 璵�循 � 쵟訟�젩 }
 { 컴컴컴컴컴컴컴컴컴컴� }
 CenterX := Cx ;
 CenterY := Cy ;

 GScale  := GScale * CScale;

 If ( NScaleArr < 19 )  Then
   Begin
     Inc ( NScaleArr ) ;
     GScaleArr   [ NScaleArr ] := GScale    ;
     GScaleArrCx [ NScaleArr ] := Cx        ;
     GScaleArrCy [ NScaleArr ] := Cy        ;
     ClearScr    := True ;
     NStepTracks := 1 ;
   End ;

 { 뿨飡첓 }
 { 컴컴컴 }
 RectAngle ( Round ( S_Cent.x - S_Size.x ), Round ( S_Cent.y - S_Size.y ),
             Round ( S_Cent.x + S_Size.x ), Round ( S_Cent.y + S_Size.y ) );

 SetWriteMode ( NormalPut ) ;
 SetColor ( C ) ;

 With Vp Do
   SetViewPort(x1,y1,x2,y2,clipon);

 With OldStyle Do
   SetLineStyle(LineStyle,Pattern,Thickness);


 { 룯誓淞β }
 { 컴컴컴컴 }
 ReCalcObjects ;


 OScreen ;

End    { Not Quit }
       { 컴컴컴컴 }


Else

Begin  { Quit }
       { 컴컴 }


 { 뿨飡첓 }
 { 컴컴컴 }

 RectAngle ( Round ( S_Cent.x - S_Size.x ), Round ( S_Cent.y - S_Size.y ),
             Round ( S_Cent.x + S_Size.x ), Round ( S_Cent.y + S_Size.y ) );

 SetWriteMode(NormalPut);
 SetColor(C);
 With Vp Do
   SetViewPort(x1,y1,x2,y2,clipon);
 With OldStyle Do
   SetLineStyle(LineStyle,Pattern,Thickness);

End ;  { Quit }
       { 컴컴 }



 ReportFs;
 SetActivePage(( Page + NGPages - 1 ) Mod 2);
 clearmw(gcent_w) ;
 clearmw(gsize_w) ;
 clearmw(chat_w)  ;
 SetActivePage(Page);
 LastObject :=-1;

End;



 Procedure UndoGlass;
{複複複複複複複複複�}

Var
  Ra, Dc : Double ;

Begin

 { 궙遜�젺�˘� ぎ�西Þ졻� �↔ⅹ獸� }
 { 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴� }
 ResetObjects ;

 { 뜮�瑜 璵�循 � 쵟訟�젩 }
 { 컴컴컴컴컴컴컴컴컴컴� }

 If ( NScaleArr > 1 )
   Then
     Begin
       Dec ( NScaleArr ) ;
       GScale      := GScaleArr   [ NScaleArr ] ;
       CenterX     := GScaleArrCx [ NScaleArr ] ;
       CenterY     := GScaleArrCy [ NScaleArr ] ;
       ClearScr    := True ;
       NStepTracks := 1 ;

       If ( B_Import_Fld Or OptRd )
         Then
           Begin
             IdToEq1 ( CenterX, CenterY, Ra, Dc ) ;
           End
         Else
           Begin
             {
             IdToEq ( CenterX, CenterY, NPolFix, SPozNp, CPozNp, Ra, Dc );
             }
             IdToEq1 ( CenterX, CenterY, Ra, Dc ) ;
             PreNew ( JDateFld, JDOut, Ra, Dc ) ;
           End ;

       RaOptGlass   := Ra ;
       DeclOptGlass := Dc ;

     End
   Else
     Begin
       GScale      := C10 ;
       CenterX     := 0.0 ;
       CenterY     := 0.0 ;
       NScaleArr   := 0   ;
       ClearScr    := True ;
       NStepTracks := 1 ;
     End ;



 If ( B_Import_Fld Or OptRd )
   Then
     Begin
       IdToEq1 ( CenterX, CenterY, Ra, Dc ) ;
     End
   Else
     Begin
       {
       IdToEq ( CenterX, CenterY, NPolFix, SPozNp, CPozNp, Ra, Dc );
       }
       IdToEq1 ( CenterX, CenterY, Ra, Dc ) ;
       PreNew ( JDateFld, JDOut, Ra, Dc ) ;
     End ;

 RaOptGlass   := Ra ;
 DeclOptGlass := Dc ;



 { 룯誓淞β }
 { 컴컴컴컴 }

 ReCalcObjects ;

 OScreen ;


 { 맆㎚쩺 렕췅 }
 { 컴컴컴컴컴� }
 ReportFs;

 LastObject := -1 ;

End ;

End.