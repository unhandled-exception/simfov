
{$O+,F+}

Unit Service;


Interface

Procedure Orient;
Procedure OrientSectPM;
Procedure Profile( npo : Integer );
Procedure History ;
{
Procedure Vector( Angle : DOUBLE; rangle : DOUBLE );
}

Implementation

Uses graph, screen, pvar;

Const
 hist_len    =        50 ;
 h_Color     = LightRed  ;
 ac   : Byte = LightGray ;
 vc   : Byte = Yellow    ;
 bc   : Byte = LightGray ;
 fc   : Byte = Black     ;

Var
 p_hist   : Array [1..hist_len] Of Integer;
 hist_vp  : ViewPortType                  ;






  Procedure History ;
{ ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ }

Var
 vp    : ViewPortType;
 i,j,
 c     : Byte        ;
 lx    : Integer     ;
 v1,
 v2,
 minv,
 maxv  : Double        ;
 s     : String [ 10 ] ;
Begin
 With hist_vp Do
   Begin
     clip:=true;
     x1:=prw.wnd.x1+4;
     x2:=prw.wnd.x2-4;
     y1:=prw.wnd.y1+TextHeight('1')+2;
     y2:=(prw.wnd.y1+TextHeight('1')+prw.wnd.y2) Div 2 - 2;
   End;

 GetViewSettings(vp);
 c:=GetColor;
 lx := 7*TextWidth('1');

 SetTextStyle(smallfont,horizdir,0);
 With hist_vp Do
  Begin

       SetViewPort(x1,y1,x2,y2,clip); clearViewPort;
       SetColor(LightGray);
       Line(lx, 2, lx, (y2-y1-1) );
       Line(lx, y2-y1-1,(x2-x1), y2-y1-1);

            { Draw history }

       minv:=p_hist[1];
       maxv:=p_hist[1];

       For j := 2 To hist-1 Do
         Begin
           If ( p_hist[j] > maxv ) Then
             maxv:=p_hist[j];
           If ( p_hist[j] < minv ) Then
             minv:=p_hist[j];
         End;


       SetColor(White);
       SetTextJustify(rightText,bottomText);
       Str(minv:6:0,s);
       OutTextxy(lx-1, y2-y1-1, s);

       SetTextJustify(rightText,topText)   ;
       Str(maxv:6:0,s);
       OutTextxy(lx-1, 1, s);

       If ( maxv <> minv ) Then

       For j:=1 To hist-2 Do

        Begin
           SetColor(h_Color);
           v1:=p_hist[j]; v2:=p_hist[j+1];

           v1 := ( C10 - ( v1-minv ) / ( maxv-minv ) ) * ( y2-y1-1);
           v2 := ( C10 - ( v2-minv ) / ( maxv-minv ) ) * ( y2-y1-1);

           Line(lx+trunc((x2-x1-1-lx)/hist_len*(j-1)),trunc(v1),
                lx+trunc((x2-x1-1-lx)/hist_len*j    ),trunc(v2));
        End;
  End;
        
 With vp Do SetViewPort(x1,y1,x2,y2,clip); SetColor(c);
 SetTextStyle(defaultfont,horizdir,0);

End;




  Procedure Profile ( npo : Integer ) ;
{ ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ }

Var
 si : Integer;
Begin
 If ( hist = hist_len+1 ) Then
 Begin
  For si:=1 To hist_len-1 Do
    p_hist[si]:=p_hist[si+1];

  p_hist[hist_len]:=npo;
 End
 Else
 Begin
   p_hist[hist]:=npo;
   inc(hist);
 End;

  history;

End;

(*
  Procedure Vector ( Angle : DOUBLE; rangle : DOUBLE ) ;
{ ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ }

Var
 vp   ,
 avp  : ViewPortType    ;
 ls   : LineSettingsType;
 c    : Byte            ;
 vlx  ,
 vly  : Integer         ;
 s    : String[4]       ;
Begin

 If ( rangle > 1.0E-5 ) Then
   Begin

      { From vertical downright }
     Angle:=450.0-Angle;

     GetViewSettings(vp);
     GetLineSettings(ls);
     c:=GetColor;

     With dw.wnd Do
       Begin

         x2  := x2 - 4;

         vly := (-y1-4-TextHeight('1')+y2) Div 2;

         vlx := trunc (vly * yasp / xasp);

         SetViewPort( x2 - 2 * vlx , (y1+TextWidth('1')+1+y2) Div 2 - vly ,
                      x2           , (y1+TextWidth('1')+1+y2) Div 2 + vly ,
                                                                   clipon ) ;
         clearViewPort;

       End;

     SetViewPort(0,0,Getmaxx,Getmaxy,clipon);

     With dw.wnd Do
       Begin
         SetColor(ac);

         Line ( x2 - 2 * vlx,(y1+TextWidth('1')+y2) Div 2,
                x2          ,(y1+TextWidth('1')+y2) Div 2);
         Line ( x2 -     vlx, (y1+TextHeight('1')+y2) Div 2 -vly,
                x2 -     vlx, (y1+TextHeight('1')+y2) Div 2 +vly);

         SetColor(vc);
         SetLineStyle(solidln,0,thickWidth);

         Line (         x2 - vlx , (y1+TextHeight('1')+y2) Div 2,
                Round ( x2 - vlx +vlx*cos(Angle*Pi/180.0)),
                Round ( ( y1+TextHeight('1')+y2 ) / C20
                        - vly*sin(Angle*Pi/180.0 ) ) ) ;
       End;

     inc(dw.wnd.x2,4);
     SetColor(c);

     With ls Do SetLineStyle(LineStyle,pattern,thickness);

            { Angle }
      { From vertical downright }
     Angle:=450.0-Angle;

     Str((round(Angle) Mod 360):3,s);
     s:=s+chr(243);
     With avp Do
       Begin
         clip:=true;
         x2 := dw.wnd.x2 - 2*(vlx+1+TextWidth('1'));
         x1 := x2 - 4 * TextWidth('1');
         y1 :=( dw.wnd.y1 + TextHeight('1') + dw.wnd.y2 ) Div 2
                          - TextHeight('1') Div 2;
         y2 :=( dw.wnd.y1 + TextHeight('1') + dw.wnd.y2 ) Div 2
                          + TextHeight('1') Div 2;
       End;

     puts(avp,true,bc,fc,CenterText,CenterText,s);

 End;

End;
*)


  Procedure OrientSectPM;
{ ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ }

{ Reports  Orientation Sectors P.M. }
{ ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

Const
     letColor =  White    ;
     linColor =  LightGray;
Var
 vp   : ViewPortType    ;
 ti   : TextSettingsType;
 ls   : LineSettingsType;
 fs   : fillSettingsType;
 cp   : PointType       ;
 c,b  : Integer         ;
 I    : Integer         ;
 Arg  : Double          ;
 Sx,
 Sy   : Integer         ;
 xp   ,
 yp   : Array [1..2] Of PointType;
Begin

 GetViewSettings(vp);
 GetLineSettings(ls);
 GetTextSettings(ti);
 GetfillSettings(fs);
 c := GetColor  ;
 b := getbkColor;

 SetViewPort(0,0,Getmaxx,Getmaxy,clipon);

 With dw.wnd, cp Do
   Begin
     x := ( x1 + x2 ) Div 2 ;
     y := ( y1 + y2 ) Div 2 ;
     SetfillStyle(interleavefill, Black);
     Bar(x1,y1,x2,y2);
   End;

 SetColor(letColor);
 SetTextJustify(CenterText, bottomText);

 SetTextJustify(CenterText, topText);
 MoveTo  ( cp.x, cp.y);
 MoveRel (    0,  4 * TextHeight('N') Div 2);

 With yp[2] Do
   Begin
     x:= GetX;
     y:= GetY-TextHeight('1') Div 2;
   End;

 With yp[1] Do
   Begin
     x:= GetX;
     y:= Cp.y - ( yp[2].y - Cp.y ) ;
   End;

 SetTextJustify(rightText, CenterText);
 MoveTo  (      cp.x         , cp.y );
 MoveRel ( 4 * TextWidth('N'),    0 );

 With xp[2] Do
   Begin
     x:= GetX - 2 * TextWidth('W') ;
     y:= GetY;
   End;

  With xp[1] Do
    Begin
      x := Cp.x - ( xp[2].x - Cp.x ) ;
      y := GetY;
    End;


 For I := 1 To 12 Do
   Begin

     Arg := Pi / 6 * ( I - 1 ) ;
     Sx  := Cp.X + Round ( ( xp[2].x - cp.x ) * 2 * Cos ( Arg ) ) ;
     Sy  := Cp.Y + Round ( ( cp.y - yp[2].y ) * 2 * Sin ( Arg ) ) ;

     SetColor ( LinColor ) ;
     Line ( Cp.x, Cp.y, Sx, Sy ) ;
     SetColor ( MarkingCol [ I ] ) ;
     Circle ( Sx, Sy, 7 ) ;

     SetFillStyle ( SolidFill , MarkingCol [ I ] ) ;
     FloodFill    ( Sx  , Sy  , MarkingCol [ I ] ) ;

   End ;


 SetColor   ( c ) ;
 SetBkColor ( b ) ;

 With fs Do SetfillStyle(Pattern, Color);
 With ti Do
   Begin
     SetTextStyle(Font, Direction, CharSize);
     SetTextJustify(Horiz, Vert);
   End ;

 With ls Do
   SetLineStyle(LineStyle , Pattern, Thickness);
 With vp Do
   SetViewPort(x1,y1,x2,y2, clip);

 PMScale := False ;

End;






  Procedure Orient;
{ ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ }

{ Reports field orientation }
{ ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

Const
     LengthAxX : Integer =  20        ;
     DxText    : Integer =  12        ;
     letColor            =  White     ;
     linColor            =  LightGray ;
Var
 vp   : ViewPortType     ;
 ti   : TextSettingsType ;
 ls   : LineSettingsType ;
 fs   : fillSettingsType ;
 cp   : PointType        ;
 c    : Integer          ;
 I    : Integer          ;
 X, Y : Integer          ;
 xp   ,
 yp     : Array [1..2] Of PointType ;
 xpText,
 ypText : Array [1..2] Of PointType ;
 TextXp,
 TextYp : Array [1..2] Of Char      ;

Begin

 GetViewSettings(vp);
 GetLineSettings(ls);
 GetTextSettings(ti);
 GetfillSettings(fs);
 c:=GetColor;

 SetViewPort(0,0,Getmaxx,Getmaxy,clipon);

 With dw.wnd, cp Do
 Begin
  x := ( x1 + x2 ) Div 2 ;
  y := ( y1 + y2 ) Div 2 ;
  SetfillStyle(interleavefill, blue);
  Bar(x1,y1,x2,y2);
 End;

 SetColor(letColor);


 Case yOrient Of
    1: Begin
         TextYp [ 1 ] := 'N' ;
         TextYp [ 2 ] := 'S' ;
       End ;
   -1: Begin
         TextYp [ 1 ] := 'S' ;
         TextYp [ 2 ] := 'N' ;
       End
 End ;


 Case ( xOrient ) Of
    1: Begin
         TextXp [ 1 ] := 'E' ;
         TextXp [ 2 ] := 'W' ;
       End ;
   -1: Begin
         TextXp [ 1 ] := 'W' ;
         TextXp [ 2 ] := 'E' ;
       End ;
 End ;


 Xp [ 1 ].X := - LengthAxX ;
 Xp [ 2 ].X :=   LengthAxX ;
 Xp [ 1 ].Y :=           0 ;
 Xp [ 2 ].Y :=           0 ;

 Yp [ 1 ].X :=           0 ;
 Yp [ 2 ].X :=           0 ;
 Yp [ 1 ].Y := - LengthAxX ;
 Yp [ 2 ].Y :=   LengthAxX ;


 XpText [ 1 ].X := - LengthAxX - DxText ;
 XpText [ 2 ].X :=   LengthAxX + DxText ;
 XpText [ 1 ].Y :=                    0 ;
 XpText [ 2 ].Y :=                    0 ;

 YpText [ 1 ].X :=                    0 ;
 YpText [ 2 ].X :=                    0 ;
 YpText [ 1 ].Y := - LengthAxX - DxText ;
 YpText [ 2 ].Y :=   LengthAxX + DxText ;



    { èÆ¢ÆpÆ‚ é·•© ≠† PozNP }
    { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

  If ( Not ( NPolFix ) )   Then
    Begin

        For I := 1 To 2  Do
            Begin

              X := Xp [ I ].X ;
              Y := Xp [ I ].Y ;

              Xp [ I ].X := Round ( X *     CPozNp   + Y * SPozNp ) ;
              Xp [ I ].Y := Round ( X * ( - SPozNp ) + Y * CPozNp ) ;

              X := Yp [ I ].X ;
              Y := Yp [ I ].Y ;

              Yp [ I ].X := Round ( X *     CPozNp   + Y * SPozNp ) ;
              Yp [ I ].Y := Round ( X * ( - SPozNp ) + Y * CPozNp ) ;



              X := XpText [ I ].X ;
              Y := XpText [ I ].Y ;

              XpText [ I ].X := Round ( X *     CPozNp   + Y * SPozNp ) ;
              XpText [ I ].Y := Round ( X * ( - SPozNp ) + Y * CPozNp ) ;

              X := YpText [ I ].X ;
              Y := YpText [ I ].Y ;

              YpText [ I ].X := Round ( X *     CPozNp   + Y * SPozNp ) ;
              YpText [ I ].Y := Round ( X * ( - SPozNp ) + Y * CPozNp ) ;


            End ;

    End ;



 SetColor ( LinColor ) ;

 Line ( Cp.X + Xp [ 1 ].X, Cp.Y + Round ( XAsp / YAsp * Xp [ 1 ].Y ) ,
        Cp.X + Xp [ 2 ].X, Cp.Y + Round ( XAsp / YAsp * Xp [ 2 ].Y ) ) ;

 Line ( Cp.X + Yp [ 1 ].X, Cp.Y + Round ( XAsp / YAsp * Yp [ 1 ].Y ) ,
        Cp.X + Yp [ 2 ].X, Cp.Y + Round ( XAsp / YAsp * Yp [ 2 ].Y )  ) ;



 SetTextJustify ( CenterText, CenterText );


              { E - W }
              { ƒƒƒƒƒ }

 If ( TextXp [ 1 ] = 'E' )
   Then  SetColor ( Yellow      )
   Else  SetColor ( LightGreen  ) ;

 MoveTo ( Cp.X +                       XpText [ 1 ].X,
          Cp.Y + Round ( XAsp / YAsp * XpText [ 1 ].Y ) ) ;
 OutText ( TextXp [ 1 ] );


 If ( TextXp [ 2 ] = 'E' )
   Then  SetColor ( Yellow      )
   Else  SetColor ( LightGreen  ) ;

 MoveTo ( Cp.X +                       XpText [ 2 ].X,
          Cp.Y + Round ( XAsp / YAsp * XpText [ 2 ].Y ) ) ;
 OutText ( TextXp [ 2 ] );


              { N - S }
              { ƒƒƒƒƒ }


 If ( TextYp [ 1 ] = 'N' )
   Then  SetColor ( LightBlue )
   Else  SetColor ( LightRed  ) ;

 MoveTo ( Cp.X +                       YpText [ 1 ].X,
          Cp.Y + Round ( XAsp / YAsp * YpText [ 1 ].Y ) ) ;
 OutText ( TextYp [ 1 ] );


 If ( TextYp [ 2 ] = 'N' )
   Then  SetColor ( LightBlue )
   Else  SetColor ( LightRed  ) ;

 MoveTo ( Cp.X +                       YpText [ 2 ].X,
          Cp.Y + Round ( XAsp / YAsp * YpText [ 2 ].Y ) ) ;
 OutText ( TextYp [ 2 ] );



        { Reset Graph }
        { ƒƒƒƒƒƒƒƒƒƒƒ }

 SetColor(c);

 With fs Do SetfillStyle(Pattern, Color);

 With ti Do
   Begin
     SetTextStyle(Font, Direction, CharSize);
     SetTextJustify(Horiz, Vert);
   End ;

 With ls Do SetLineStyle(LineStyle , Pattern, Thickness);
 With vp Do SetViewPort(x1,y1,x2,y2, clip);

End;



End.
