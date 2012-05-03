
{$O+,F+}

Unit Info;

Interface

Uses  V_Catal, Graph, PVar ;

var

 Clas_w  ,
 Opt_w   , ras_w, dcs_w,
 mv_w    , sp_w , cns_w  : mwtype;


Procedure ObjectInfo  ;
Procedure InitInfo    ;
Procedure CloseInfo   ;


Implementation

Uses

   Crt, Screen, Curs, Find,
   PInform, MLib  ;

Const

 ClassId_Opt = 1;
 ClassId_Pln = 2;
 ClassId_Sat = 3;
 ClassId_Non = 4;

 bc        = lightgray ;
 fc        = black     ;


Procedure showepoch( x, y : integer );
var vp : viewporttype;
    jd : double      ;
    s  : string[4]   ;
    c  : integer     ;
Begin
 getviewsettings(vp); setviewport(0,0,getmaxx,getmaxy,clipon); c:=getcolor;

 setusercharsize(4,3,2,3);

 JD := (JDOut - 2415020.5) / 365.2422 + 1900.0;
 Str(jd:4:0,s);
 settextstyle(SmallFont, HorizDir, 0);
 setcolor(lightgray);
 outtextxy( x , y + 5, s);

 setusercharsize(1,1,1,1);
 settextstyle(DefaultFont,HorizDir,0);
 With vp Do setviewport(x1,y1,x2,y2,clip); setcolor(c);
End;


 Procedure InitInfo ;
{================== }

const
 LS = 18 ;
 bc = blue;
 fc = lightgray;
Begin

 clearmw ( prw )     ;
 optinf_w := iopt    ;
 initmw ( optinf_w ) ;

 If LastObject = -1 Then
   LastObject := ClassId_Opt ;


 With Opt_w Do
   Begin                        { Сведения из Opt }
     case LastObject Of
          ClassId_Opt :  hd:='  N  ';
          ClassId_Pln :  hd:='Diam ';
          ClassId_Sat :  hd:='N Ser';
     End;

   With wnd Do
     Begin
       x1:=optinf_w.wnd.x1+3;
       y1:=optinf_w.wnd.y1+textheight('1')+8;
       x2:=x1+textwidth(hd) ;
       y2:=y1+textheight('1')       ;
     End;

   puts(Opt_w.wnd,false,bc,fc,lefttext,centertext,hd);

   With wnd Do
     Begin
       x1 := x2 + 4 ;
       x2:= x1 + LS * textwidth('1');
     End;
 End;


 With ras_w Do
   Begin
     If ( B_Gal )
       Then hd := '  L'+'  '
       Else hd := chr ( 251)+'    ';
     With wnd Do
       Begin
         x1:=optinf_w.wnd.x1+3     ;
         y1:=Opt_w.wnd.y2+5      ;
         x2:=x1+textwidth(hd);
         y2:=y1+textheight('1')       ;
       End;
     puts(ras_w.wnd,false,bc,fc,lefttext,centertext,hd) ;

     If ( Not B_Gal ) Then
     showepoch(wnd.x2-2*textwidth('1'), wnd.y2-4);
     With wnd Do
       Begin
         x1 := x2 + 4 ;
         x2:= x1 + LS * textwidth('1');
       End;
   End;

 With dcs_w Do
   Begin
     If ( B_Gal )
       Then hd := '  B'+'  '
       Else hd := chr ( 252)+'    ';
     With wnd Do
       Begin
         x1:=optinf_w.wnd.x1+3     ;
         y1:=ras_w.wnd.y2+5       ;
         x2:=x1+textwidth(hd);
         y2:=y1+textheight('1')       ;
       End;
     puts(dcs_w.wnd,false,bc,fc,lefttext,centertext,hd) ;

     If ( Not B_Gal ) Then
     showepoch(wnd.x2-2*textwidth('1'), wnd.y2-4);

     With wnd Do
       Begin
         x1 := x2 + 4 ;
         x2:= x1 + LS * textwidth('1');
       End;
   End;


 With mv_w Do
   Begin
     hd:=' Magn';
     With wnd Do
       Begin
         x1:=optinf_w.wnd.x1+3;
         y1:=dcs_w.wnd.y2+5          ;
         x2:=x1+textwidth(hd) ;
         y2:=y1+textheight('1')       ;
       End;
     puts(mv_w.wnd,false,bc,fc,lefttext,centertext,hd) ;
     With wnd Do
       Begin
         x1 := x2 + 4 ;
         x2:= x1 + LS * textwidth('1');
       End;
   End;

 With sp_w Do
   Begin
     case LastObject Of
          ClassId_Opt :  hd:='   Sp';
          ClassId_Pln :  hd:='Phase';
          ClassId_Sat :  hd:='Dist ';
     End;

     With wnd Do
       Begin
         x1:=optinf_w.wnd.x1+3;
         y1:=mv_w.wnd.y2+5            ;
         x2:=x1+textwidth(hd) ;
         y2:=y1+textheight('1')       ;
       End;
     puts(sp_w.wnd,false,bc,fc,lefttext,centertext,hd) ;
     With wnd Do
       Begin
         x1 := x2 + 4 ;
         x2:= x1 + LS * textwidth('1');
       End;
   End;

 With cns_w Do
   Begin
     hd:='Const';
     With wnd Do
       Begin
         x1:=optinf_w.wnd.x1+3;
         y1:=sp_w.wnd.y2+5            ;
         x2:=x1+textwidth(hd) ;
         y2:=y1+textheight('1')       ;
       End;
     puts(cns_w.wnd,false,bc,fc,lefttext,centertext,hd) ;
     With wnd Do
       Begin
         x1 := x2 + 4 ;
         x2 := x1 + LS * textwidth('1');
       End;
   End;

 With clas_w Do
   Begin                        { Классификация }
     hd:='';
     With wnd Do
       Begin
         x1:=optinf_w.wnd.x1+3;
         y1:=cns_w.wnd.y2+5;
         x2:=optinf_w.wnd.x2-3;
         y2:=y1+10;
       End;
   End;

End; { initinfo }
     { -------- }


Procedure CloseInfo;
Begin
 clearmw(optinf_w);
 menu_w:=imenuw;
 initmw(menu_w);
End;



  Procedure ObjectInfo ;
{ ==================== }

Var
 SelPoint     : PointType    ;
 BRepeat      : Boolean      ;
 Found        : Boolean      ;
 Searching    : Boolean      ;
 ModPoint     : PointType    ;
 SelectedItem : Integer      ;
 Vp           : ViewPortType ;
 Ch           : Char         ;

Begin

 getviewsettings ( vp ) ;

 With sw Do
   setviewport ( x1, y1, x2, y2, clipon ) ;

 InitInfo;

 Searching  := False;

 SelPoint.X := StartX - PointerWidth   ;
 SelPoint.Y := StartY - PointerWidth_Y ;

 PointPrima := True  ;
 Marking    := False ;

 Repeat

   Searching := Select ( SelPoint );

   If ( Searching )   Then
     Begin

       If ( PointerMark <> Nil )  Then
         PutImage ( SelPoint.X, SelPoint.Y, PointerMark^, XORPut ) ;

       If ( Not F4Key )
         Then
           Begin

             ModPoint.X := SelPoint.X + PointerWidth   ;
             ModPoint.Y := SelPoint.Y + PointerWidth_Y ;

             Found := FindObject ( ModPoint.X, ModPoint.Y, SelectedItem );

             If ( Found )
              Then
               Begin

                 If ( A_Pressed )
                   Then
                     Begin
                       If ( NFound > 1 )
                         Then
                           InfoAllInCursor
                         Else
                           Begin
                             If (     ( SelectedItem >= IndCat [ CatOthers ].NBeg )
                                  And ( SelectedItem <= IndCat [ CatOthers ].NEnd ) ) Then
                             InfoOthers ( SelectedItem, 0 ) ;
                           End ;
                       A_Pressed := False ;
                     End
                   Else
                     Inform ( SelectedItem, ModPoint );

               End  { Found }
              Else
                Inform ( SelectedItem, ModPoint );

           End

         Else

           Begin
             InitInfo;
             F4Key := False ;
           End ;


       Repeat
       Until KeyPressed;

       If ( PointerMark <> Nil )  Then
         PutImage ( SelPoint.X, SelPoint.Y, PointerMark^, XORPut ) ;

     End;


   Until Not Searching;



 CloseInfo;

 With Vp Do
   SetViewPort ( x1, y1, x2, y2, clipon ) ;


End;

End.