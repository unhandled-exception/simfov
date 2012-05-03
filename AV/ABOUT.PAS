
{$O+,F+}


Unit About;

Interface



Procedure SayNames;

Implementation
uses

 Graph, PVar, Crt ;


procedure SayNames;
var
 Ind  : byte             ;
 vp   : viewporttype     ;
 fs   : fillsettingstype ;
 c    : byte             ;
 x1,y1,
 x2,y2: integer          ;

 PSD,
 PSM,
 SizeM : LongInt      ;

 ObjectMaxBlocks : Word ;

 SPSD,
 SPSM : String [ 10 ] ;
 SStr : String [ 40 ] ;

 ProgAuth : Array [1..12] of string [ 70 ] ;

Begin


 ProgAuth [  1 ] := 'S  I  M     F  O  V';
 ProgAuth [  2 ] := '-----------------';
 ProgAuth [  3 ] := 'Version  ' + Version ;
 ProgAuth [  4 ] := '';
 ProgAuth [  5 ] := '';
 ProgAuth [  6 ] := 'HIPPARCOS   TYCHO';
 ProgAuth [  7 ] := 'PPM  SAO  BS  AC  GSC  A2.0  HD  HDE';
 ProgAuth [  8 ] := 'GCVS  NPM1  NLTT  DM  InfraRed'   ;

 ProgAuth [  9 ] := '';

 ProgAuth [ 10 ] := 'Anatoly Volchkov, Oleg Volchkov';




 getviewsettings(vp);
 c:=getcolor;
 getfillsettings(fs);
 setcolor(Black)    ;


 setusercharsize(10,8,11,8)             ;

 settextstyle ( TFont , horizdir ,3 );

 setviewport(0,0,getmaxx,getmaxy,clipon);

 x1:=0;
 x2:=getmaxx;
 y1:=0;
 y2:=getmaxy;

 SetVisualPage( 1 );

  setfillstyle( SolidFill , LightGray );
  bar(0,0,getmaxx,getmaxy);

  setfillstyle(solidfill,Green);

{  bar((x2-x1+1-textwidth(ProgAuth[7])) Div 2, (y2-y1+1-17*textheight('1')) Div 2,
      (x2-x1+1+textwidth(ProgAuth[7])) Div 2, (y2-y1+1+13*textheight('1')) Div 2 );

  setfillstyle(fs.pattern,Black);

  bar((x2-x1+1+textwidth(ProgAuth[7])) Div 2+ 1, (y2-y1+1-17*textheight('1')) Div 2+11,
      (x2-x1+1+textwidth(ProgAuth[7])) Div 2+11, (y2-y1+1+13*textheight('1')) Div 2+11);

  bar((x2-x1+1-textwidth(ProgAuth[7])) Div 2+11, (y2-y1+1+13*textheight('1')) Div 2+ 1,
      (x2-x1+1+textwidth(ProgAuth[7])) Div 2+11, (y2-y1+1+13*textheight('1')) Div 2+11);
}
  settextjustify(CenterText,CenterText)  ;

  SetColor( Black );

  For Ind:=1 To 10 Do
   Begin
     {
     outtextxy((x2-x1+1+3*TextWidth(' ')) Div 2 + 2,
     }
     OutTextXY((x2-x1+1+3*TextWidth(' ')) Div 2 ,
      (y2-y1+1) Div 2 - 6 * textheight('1')+(Ind-1)*(TextHeight('1')+1) + 2,
          ProgAuth[Ind]);
   End;

 SetColor( White );

  For Ind:=1 To 10 Do
   Begin
     outtextxy((x2-x1+1+3*TextWidth(' ')) Div 2 ,
      (y2-y1+1) Div 2 - 6 * textheight('1')+(Ind-1)*(TextHeight('1')+1) ,
          ProgAuth[Ind]);
   End;

        { Œ ªá¨¬ «ì­®¥ ç¨á«® §¢¥§¤ ¢ ¯®«¥ }
        { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

 SizeM := Trunc ( ( MaxAvail - GraphBuffSize ) /
                    SizeOf ( ObjectArrType ) * ObjectBlockSize ) ;

 ObjectMaxBlocks := SizeM Div ObjectBlockSize         ;
 SizeM           := ObjectMaxBlocks * ObjectBlockSize ;

 PSD  :=  SizeM Div 1000 ;
 PSM  :=  SizeM Mod 1000 ;

 Str( PSD : 3, SPSD );
 Str( PSM : 3, SPSM );

 If SPSM [ 1 ] = ' '  Then
    SPSM [ 1 ] := '0' ;
 If SPSM [ 2 ] = ' '  Then
    SPSM [ 2 ] := '0' ;


 SStr := '    <=   ' + SPSD + ' ' + SPSM + '  Stars  in  F O V     ' ;

 SetFillStyle( SolidFill, Blue );
 Bar( ( GetMaxX Div 2 ) - TextWidth( SStr ) Div 2, GetMaxY - TextHeight( 'H' ) - 25 ,
      ( GetMaxX Div 2 ) + TextWidth( SStr ) Div 2, GetMaxY                     - 20 );

 SetColor( White );
 SetTextJustify(CenterText,CenterText)  ;
  OutTextXY( GetMaxX Div 2 + 5, GetMaxY - ( TextHeight( 'H' )  ) Div 2 - 24 , SStr );


 SetVisualPage( 0 );

 setcolor(c);
 With fs Do setfillstyle(pattern, color);
 With vp Do setviewport(x1,y1,x2,y2,clipon);
 setusercharsize(1,1,1,1);
 settextstyle(defaultfont,0,1);

End ;

End.
