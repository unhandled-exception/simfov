
{$O+,F+}

Unit PDrawSat;
Interface
Procedure DrawSat;
Implementation
Uses
 Graph, PVar ;


Var
 XAsp, YAsp : Word;

Procedure ShowSat( X, Y, Sig : DOUBLE );
var
 SToNRat  : Single      ;
 SRInd,Ind: Byte        ;
Begin

  SToNRat := 0.0;

 If (SToNRat <= 0.5)                     Then SRInd:=1;
 If (SToNRat >  0.5) And (SToNRat < 5.0) Then SRInd:=2;
 If (SToNRat >  5.0)                     Then SRInd:=3;


 SetWriteMode(XORPut); SetColor(LightMagenta);
 Rectangle(Trunc(X-SRInd*4.0), Trunc(Y - SRInd * 4.0 * XAsp / YAsp),
           Trunc(X+SRInd*4.0), Trunc(Y + SRInd * 4.0 * XAsp / YAsp));
 SetWriteMode(NormalPut);
End ;

Procedure DrawSat;
Var
 SX, SY   : DOUBLE        ;
 Ind      : Integer     ;
 vp       : viewporttype;
 ccol     : byte        ;

Begin
 getviewsettings(vp); ccol:=getcolor; getaspectratio(xasp,yasp);
 with sw do setviewport(x1,y1,x2,y2,clipon);

 For Ind:=1 To NumberOfSatellits do
 If Satellit[Ind].Visible then    { In field ! }
  With Satellit[Ind] do
   Begin
  { Экранные координаты из идеальных }

    SX:= Trunc(  0.5 * (sw.x2-sw.x1+1)
                + (X-CenterX) * GScale / XMAX  * (sw.x2-sw.x1+1) / 2 );
    SY:= Trunc(  0.5 * (sw.y2-sw.y1+1)
                - (Y-CenterY) * GScale / YMAX  * (sw.y2-sw.y1+1) / 2 );

    NowVisible := (  ( Sx > 0 ) And ( Sx < (sw.x2-sw.x1) )
                 And ( Sy > 0 ) And ( Sy < (sw.y2-sw.y1) ) );
    If NowVisible Then
     ShowSat(SX,SY,FL);
   End;
 with vp do setviewport(x1,y1,x2,y2,clipon); setcolor(ccol);
End; { Рисование спутников }
End.