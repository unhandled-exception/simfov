
{$O+,F+}

Unit CMenu;
Interface

Procedure CrsMenu;

Implementation
Uses
 Dos, Graph, GLib, MLib, MDef, PMenu,
 Screen, Curs, Info, PVar, Glass, Reverse ;

Var
 NoTrace : TraceType    ;
 CHelp   : CHelpType    ;
 ExitCrsM: Boolean      ;
 i       : byte         ;

Procedure SetExitTrue;
 Begin
   ExitCrsM:=True;
 End;

Procedure SHelp( Msg : DirStr );
Begin
 With menucolor Do
   puts ( mess_w, True, hbackc, hforec, centertext, centertext, msg );
End;

Procedure ExeGlass;
var
 cpoint : pointtype   ;
 vp     : viewporttype;
Begin
 getviewsettings(vp);
 With sw Do
   setviewport(x1,y1,x2,y2,clipon);
 With cpoint Do
 Begin
   x := trunc ( CInfoX - pointerwidth   ) ;
   y := trunc ( CInfoY - pointerwidth_y ) ;
 End;

 If ( PointerMark <> Nil )  Then
   PutImage ( CPoint.X, CPoint.Y, PointerMark^, XORPut ) ;

 With vp Do
   setviewport(x1,y1,x2,y2,clipon);

 clearmw(menu_w);
 gcx := CInfoX;
 gcy := CInfoY;

 DoGlass;

 initmw(menu_w);

 UnGetCh(ESCKEY);
 UnGetCh(ENDKEY);
 UnGetCh(CRKEY);

 getviewsettings(vp);

 With sw Do
   setviewport(x1,y1,x2,y2,clipon);

 With cpoint Do
   Begin
     x:=trunc(CInfoX-pointerwidth);
     y:=trunc(CInfoY-pointerwidth_y);
   End;

 If ( PointerMark <> Nil )  Then
   PutImage ( CPoint.X, CPoint.Y, PointerMark^, XORPut ) ;

 With vp Do
   setviewport(x1,y1,x2,y2,clipon);

End ;

Procedure ExeXrev;
var
 cpoint : pointtype   ;
 vp     : viewporttype;
Begin
 getviewsettings(vp);
 With sw Do setviewport(x1,y1,x2,y2,clipon);
 With cpoint Do
   Begin
     x:=trunc(CInfoX-pointerwidth);
     y:=trunc(CInfoY-pointerwidth_y);
   End;

 If ( PointerMark <> Nil )  Then
   PutImage ( CPoint.X, CPoint.Y, PointerMark^, XORPut ) ;

 With vp Do setviewport(x1,y1,x2,y2,clipon);

 clearmw ( menu_w ) ;
 {
 CalcVectDiagr := False ;
 }
 ClearScr := True ;
 DoReverse ( True, False );

 initmw(menu_w);

 UnGetCh(ESCKEY);
 UnGetCh(ENDKEY);
 UnGetCh(CRKEY);

 getviewsettings(vp);
 With sw Do setviewport(x1,y1,x2,y2,clipon);
 With cpoint Do
   Begin
     x := trunc ( CInfoX - pointerwidth   ) ;
     y := trunc ( CInfoY - pointerwidth_y ) ;
   End;

 If ( PointerMark <> Nil )  Then
   PutImage ( CPoint.X, CPoint.Y, PointerMark^, XORPut ) ;

 With vp Do setviewport(x1,y1,x2,y2,clipon);
End ;


Procedure ExeYrev;
var
 cpoint : pointtype   ;
 vp     : viewporttype;
Begin
 getviewsettings(vp);
 With sw Do
   setviewport(x1,y1,x2,y2,clipon);
 With cpoint Do
   Begin
     x:=trunc(CInfoX-pointerwidth);
     y:=trunc(CInfoY-pointerwidth_y);
   End;

 If ( PointerMark <> Nil )  Then
   PutImage ( CPoint.X, CPoint.Y, PointerMark^, XORPut ) ;

 With vp Do setviewport(x1,y1,x2,y2,clipon);

 clearmw ( menu_w );
 {
 CalcVectDiagr := False ;
 }
 ClearScr := True ;
 DoReverse ( False, True ) ;

 initmw(menu_w);

 UnGetCh(ESCKEY);
 UnGetCh(ENDKEY);
 UnGetCh(CRKEY);

 getviewsettings(vp); With sw Do setviewport(x1,y1,x2,y2,clipon);
 With cpoint Do
 Begin x:=trunc(CInfoX-pointerwidth);  y:=trunc(CInfoY-pointerwidth_y); End;

 If ( PointerMark <> Nil )  Then
   PutImage ( CPoint.X, CPoint.Y, PointerMark^, XORPut ) ;

 With vp Do setviewport(x1,y1,x2,y2,clipon);
End ;


Procedure ExeUnDo;
var
 cpoint : pointtype   ;
 vp     : viewporttype;
Begin

 getviewsettings(vp); With sw Do setviewport(x1,y1,x2,y2,clipon);
 With cpoint Do
 Begin x:=trunc(CInfoX-pointerwidth);  y:=trunc(CInfoY-pointerwidth_y); End;

 If ( PointerMark <> Nil )  Then
   PutImage ( CPoint.X, CPoint.Y, PointerMark^, XORPut ) ;

 With vp Do setviewport(x1,y1,x2,y2,clipon);

 clearmw(menu_w);
 gcx:= CInfoX;
 gcy:= CInfoY;

 UndoGlass;

 initmw  ( menu_w );
 UnGetCh ( ESCKEY );
 UnGetCh ( ENDKEY );
 UnGetCh ( CRKEY  );

 getviewsettings(vp);
 With sw Do
   setviewport(x1,y1,x2,y2,clipon);
 With cpoint Do
   Begin
     x := trunc ( CInfoX - pointerwidth  );
     y := trunc ( CInfoY - pointerwidth_y);
   End;

 If ( PointerMark <> Nil )  Then
   PutImage ( CPoint.X, CPoint.Y, PointerMark^, XORPut ) ;

 With vp Do
   setviewport(x1,y1,x2,y2,clipon);

End ;

Procedure ExeUnDoFull;
var
 cpoint : pointtype   ;
 vp     : viewporttype;
Begin

 getviewsettings(vp);

 With sw Do
   setviewport(x1,y1,x2,y2,clipon);

 With cpoint Do
   Begin
     x:=trunc(CInfoX-pointerwidth);
     y:=trunc(CInfoY-pointerwidth_y);
   End;

 If ( PointerMark <> Nil )  Then
   PutImage ( CPoint.X, CPoint.Y, PointerMark^, XORPut ) ;

 With vp Do
   setviewport(x1,y1,x2,y2,clipon);

 clearmw(menu_w);

 gcx:= CInfoX;
 gcy:= CInfoY;

 NScaleArr := 0 ;

 UndoGlass;

 initmw(menu_w);
 UnGetCh(ESCKEY);
 UnGetCh(ENDKEY);
 UnGetCh(CRKEY);

 getviewsettings(vp);
 With sw Do
   setviewport(x1,y1,x2,y2,clipon);
 With cpoint Do
   Begin
     x := trunc ( CInfoX - pointerwidth   ) ;
     y := trunc ( CInfoY - pointerwidth_y ) ;
   End;

 If ( PointerMark <> Nil )  Then
   PutImage ( CPoint.X, CPoint.Y, PointerMark^, XORPut ) ;

 With vp Do
   setviewport(x1,y1,x2,y2,clipon);

End ;

Procedure CrsMenu;
Var
 CD     : MenuDescType;
 CM     : MenuType    ;
 Ind    : Byte        ;
 EscH   : Boolean     ;
 fc,bc  : byte        ;
 vp     : viewporttype;
 icount : byte        ;
 CMItems: Byte        ;
Begin

 CMItems := 6;

 NoTrace.Required := False;

 With CHelp Do
   Begin
     present := True  ;
     proc    := SHelp ;
   End;


 {  Расположение меню }
 getviewsettings(vp); setviewport(0,0,getmaxx,getmaxy,clipon);
 clearmw(optinf_w);
 menu_w:=imenuw;
 menu_w.hd:='Инфо '+ menu_w.hd;
 initmw(menu_w);
 ExitCrsM:=False;

 With CD Do
   Begin
    con := False;
    ulx := menu_w.wnd.x1 div 8 + 1 ;
    lrx := ulx+15;
    uly := ( menu_w.wnd.y1 + 3 * textheight('1') ) div 10 ;
   End ;

 AllocMenu ( CMItems, CM ) ;

 icount := 1 ;

 With CM [ icount ]^ Do
 Begin
  TextString:='Zoom';
  HelpText  :='Zoom part of FoV';
  Activity  :=mn_exe;
  Proc := exeglass ;
  Inc ( ICount ) ;
 End;

 If ( NScaleArr > 1 ) Then
 With Cm [ ICount ]^ Do
 Begin
  TextString:='Back Cascade';
  HelpText  :='Restore pred. FoV';
  Activity  :=mn_exe;
  Proc := ExeUndo;
  Inc ( ICount ) ;
 End;

 If ( NScaleArr > 0 ) Then
 With Cm [ ICount ]^ Do
 Begin
  TextString:='Back';
  HelpText  :='Restore orig. FoV';
  Activity  :=mn_exe;
  Proc := ExeUndoFull;
  Inc ( ICount ) ;
 End;

 With Cm [ ICount ]^ Do
 Begin
  TextString:='X-reverse';
  HelpText  :='';
  Activity  :=mn_exe;
  Proc := ExeXrev;
  Inc ( ICount ) ;
 End;

 With CM [ icount ]^ Do
 Begin
  TextString:='Y-reverse';
  HelpText  :='';
  Activity  :=mn_exe;
  Proc := ExeYrev ;
  Inc ( ICount ) ;
 End;


 With CM [ icount ]^ Do
 Begin
  TextString:= 'Info';
  HelpText  := 'Return to info mode';
  Activity  := mn_ext;
  Proc      := SetExitTrue;
 End;


 InitMVars;
 CD.lry := CD.uly + icount + 1 ;

 Repeat
   Ind := Menu ( CD, MenuColor, icount, NoTrace, CHelp, CM, EscH );
   If ( ( Level > 2 ) And ( EscH ) )  Then
     SetExitTrue;
 Until ExitCrsM;

 freemenu ( CMItems, CM );
 clearmw  ( menu_w );
 menu_w.hd := imenuw.hd;
 initmw ( optinf_w );
 With vp Do
   setviewport ( x1, y1, x2, y2, clipon );

End;  { CrsMenu }


End.
