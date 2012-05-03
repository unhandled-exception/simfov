{$O+,F+}
Unit MLib; { Menu Procedures Library, 8.01.90 }
Interface
Uses
 Crt, Graph, Glib, MDef;

Procedure InitMVars;

Procedure AllocMenu( MenuItems : Byte; Var M : MenuType );
Procedure FreeMenu ( MenuItems : Byte; Var M : MenuType );

Procedure Store  ( CLevel : Byte );
Procedure Restore( CLevel : Byte );

Procedure SetFWindow;
Procedure MWindow( ulx,uly,lrx,lry : Byte ;  BackC : Byte; Erase : Boolean );
Procedure MenuBox( ulx,uly,lrx,lry,BoxT,BackC,BoxC : Byte; Erase : Boolean );
Procedure ConnectBoxes( Show : Boolean; CLevel : Byte );

Procedure WriteS( x,y : Byte; S : String );
Procedure WriteA( x,y : Byte; S, A : String );

Procedure MGotoXY( X,Y : Byte );
Procedure Clear( X, Y, Count, Attr : Byte );

Function  Mmod( a : Integer; b : Byte ) : Byte;

Function  GetKey : Char;
Function  GetCh  : Char;
Procedure UnGetCh( Ch : Char );


Implementation

Procedure AllocMenu( MenuItems : Byte; Var M : MenuType );
Var
 Ind : Byte;
Begin
 If ( MaxAvail < MenuItems * sizeof(OrdinaryItemType) )
   Then
     Halt(1)
   Else
     For Ind:=1 To MenuItems Do
       GetMem ( M [Ind], SizeOf ( OrdinaryItemType ) ) ;
End;

Procedure FreeMenu ( MenuItems : Byte; Var M : MenuType );
Var
 Ind : Byte;
Begin
 For Ind:=1 To MenuItems Do
   FreeMem(M[Ind],SizeOf(OrdinaryItemType));
End;

Procedure Store( CLevel : Byte );
Var
 L,C      : Byte;
 CharSize : Byte;
 x1, y1   ,
 x2, y2   : Integer;
Begin
 If ( CLevel > 2 ) Then
 Begin
 L:=CLevel-2; C:=CLevel; CharSize :=FontCharSize[CFont];
 x1:=(Lo(UpperLeft [C])-1)*8; y1:=(Hi(UpperLeft[C] )-1)*CharSize;
 x2:=(Lo(LowerRight[C])+1)*8; y2:=(Hi(LowerRight[C])+1)*CharSize;
 x1:=Max(x1,0); y1:=Max(y1,0); x2:=Min(x2,GetMaxX); y2:=Min(y2, GetMaxY);
 Size[L]:=ImageSize(x1,y1,x2,y2);

 GetMem(Area[L], Size[L]);
 GetImage(x1,y1,x2,y2,Area[L]^);
 End;
End;

Procedure Restore( CLevel : Byte );
Var
 L,C      : Byte;
 CharSize : Byte;
 x1, y1   : Integer;
Begin
 If ( CLevel > 2 ) Then
 Begin
  L:=CLevel-2; C:=CLevel; CharSize :=FontCharSize[CFont];
  x1:=(Lo(UpperLeft[C])-1)*8 ; y1:=(Hi(UpperLeft[C])-1)*CharSize ;
  x1:=Max(x1,0); y1:=Max(y1,0);
  PutImage(x1,y1, Area[L]^, NormalPut);
  FreeMem(Area[L], Size[L]);
 End;
End;

Function GetKey : Char;
var
  C : Char;
begin
  C := ReadKey;
  repeat
    if C = NULL then
    begin
      C := ReadKey;
      if Ord(C) > 127 then
        C := NULL
      else
        GetKey := Chr(Ord(C) + 128);
    end
    else
      GetKey := C;
  until C <> NULL;
end; { GetKey }


Function GetCh : Char;
Begin
 If ( Length ( Keys ) = 0 )
   Then
     GetCh := GetKey
   Else
     Begin
       GetCh:=Keys[1];
       Delete(Keys,1,1);
     End;
End; { GetCh }

Procedure UnGetCh ( ch : Char );
Begin
 Keys := Keys + ch ;
End;

Function Mmod( a : Integer; b : Byte ) : Byte;
Begin
 If a <= 0
   Then Mmod := b
   Else
     If a = b
       Then Mmod := b
       Else Mmod := a Mod b;
End;

Procedure SetFWindow;
Begin
 SetViewPort(0,0,GetMaxX,GetMaxY,ClipOn);
End;

Procedure MenuBox( ulx,uly,lrx,lry,BoxT,BackC,BoxC : Byte; Erase : Boolean );
Var
 CharSize      ,
 CColor        ,
 BColor        : Byte;
 Vp            : ViewPortType;

Begin
 { Box Type }
 If (  BoxT > 4  ) Then
   BoxT:=1;

 If ( BoxT <> 0 ) Then
   Begin

     CharSize :=FontCharSize[CFont];
     CColor :=GetColor; SetColor(BoxC);

     If ( Erase ) Then
       Begin
         SetFillStyle(SolidFill,BackC);
         Bar((2*ulx-1) * 4,(2*uly-1)*CharSize Div 2,
             (2*lrx-1) * 4,(2*lry-1)*CharSize Div 2);
       End;

     Rectangle((2*ulx-1) * 4,(2*uly-1)*CharSize Div 2,
               (2*lrx-1) * 4,(2*lry-1)*CharSize Div 2);
     If ( BoxT > 1 ) Then
       Rectangle((2*ulx-1) * 4 + 2,(2*uly-1)*CharSize Div 2 + 2,
                 (2*lrx-1) * 4 - 2,(2*lry-1)*CharSize Div 2 - 2);

     SetColor(CColor);
   End;
End;

{ Connects menu boxes on the screen }
Procedure ConnectBoxes( Show : Boolean; CLevel : Byte );
Var
 FromH      : Boolean;
 ToRight    : Boolean;
 Middle     : Array [1..2,1..2] of Byte; { 1 - x,y; 2 - x,y }
 CColor     : Byte;
 CharSize   : Byte;
 Vp         : ViewPortType;
Begin
 { Destinations }
 CharSize:=FontCharSize[CFont];
 FromH := PHor[CLevel-1];

 ToRight :=
 ( Lo(UpperLeft[CLevel-1]) + Lo(LowerRight[CLevel-1]) )
 <
 ( Lo(UpperLeft[CLevel  ]) + Lo(LowerRight[CLevel  ]) );

 { First box }
 If ( FromH )
   Then
     Begin
       Middle[1,1] := Lo(UpperLeft [CLevel-1]) + PItem[CLevel-1];
       Middle[1,2] := Hi(Lowerright[CLevel-1]);
     End
   Else
     Begin

       If ( ToRight )
         Then
           Middle[1,1] := Lo(LowerRight[CLevel-1])
         Else
           Middle[1,1] := Lo(UpperLeft[CLevel-1]) ;

       Middle[1,2] := Hi(UpperLeft [CLevel - 1]) + PItem[CLevel-1];

     End;

 { Second Box }
  Middle[2,1] := ( Lo(UpperLeft[CLevel]) + Lo(LowerRight[CLevel]) ) Div 2;
  Middle[2,2] :=   Hi(UpperLeft[CLevel]);

 CColor:=GetColor;
 If ( Show )
   Then SetColor((PAttr[CLevel-1] * 16 ) Div 16 )
   Else SetColor(GetBkColor);

 GetViewSettings(Vp);
 SetFWindow;

 Line((2*Middle[1,1]-1)*4,(2*Middle[1,2]-1)*CharSize Div 2,
      (2*Middle[2,1]-1)*4,(2*Middle[1,2]-1)*CharSize Div 2);
 Line((2*Middle[2,1]-1)*4,(2*Middle[1,2]-1)*CharSize Div 2,
      (2*Middle[2,1]-1)*4,(2*Middle[2,2]-1)*CharSize Div 2);
 SetColor(CColor);
 With Vp Do
 SetViewPort(x1,y1,x2,y2,ClipOn);
End;

Procedure WriteS( x,y : Byte; S : String );
Begin
 OutTextXY((2*x-1)*4,(2*y-1)*FontCharSize[CFont] Div 2,S);
End;

Procedure WriteA( x,y : Byte; S,A : String );
Var
 Ind : Byte;
 BCol, CCol : Byte;
 CX  , CY   : Word;
 FI         : FillSettingsType;
 TS         : TextSettingsType;
 CS2        : Byte;
 CharSize   : Byte;
Begin
 CharSize :=FontCharSize[CFont];
 BCol:=GetBkColor; CCol:=GetColor; GetFillSettings(FI);
 GetTextSettings(TS); SetTextJustify(CenterText,CenterText);
 CS2:= CharSize Div 2; CX:=(x-1)*CharSize ; CY := (y-1) * CharSize;
 For Ind:=1 To Length(A) Do
  Begin
    SetFillStyle(SolidFill,Ord(A[Ind]) Div 16);
    Bar(CX,CY,CX+CharSize,CY+CharSize); SetColor((Ord(A[Ind]) * 16) Div 16);
    OutTextXY(CX-CS2,CY+CS2,S[Ind]);
    CX:=CX+CharSize;
  End;

  For Ind:=Length(A)+1 To Length(S) Do
  Begin
   Bar(CX,CY,CX+CharSize,CY+CharSize); OutTextXY(CX-CS2,CY+CS2,S[Ind]);
   CX:= CX + CharSize;
  End;

  SetFillStyle(FI.Pattern,FI.Color); SetBkColor(BCol); SetColor(CCol);
  SetTextJustify(TS.Horiz, TS.Vert);
End;

Procedure MGoToXY( X,Y : Byte );
Begin
 MoveTo((2*x-1)*4 , (2*y-1)*FontCharSize[Cfont] Div 2);
End;

Procedure Clear( x, y, Count, Attr : Byte );
Var
 FS : FillSettingsType;
Begin
 GetFillSettings(FS);
 SetFillStyle(SolidFill,Attr Div 16 );

 Bar((2*x        -1)*4, (y-1)*FontCharSize[CFont],
     (2*(x+Count)-1)*4,  y   *FontCharSize[CFont]);
 SetFillStyle(FS.Pattern,FS.Color);
End;


Procedure MWindow ( ulx,uly,lrx,lry : Byte;
                              BackC : Byte;
                              Erase : Boolean );
Var
 Fs    : FillSettingsType;
Begin
   SetFWindow ;
   If ( Erase ) Then
     Begin
       GetFillSettings ( Fs ) ;
       SetFillStyle ( SolidFill, BackC ) ;
       Bar ( (ulx-1)*8  , (uly-1)*FontCharSize[CFont],
              lrx   *8-1,  lry   *FontCharSize[CFont]-1);
       SetFillStyle ( Fs.Pattern, Fs.Color ) ;
     End;
   SetViewPort((ulx-1)*8  , (uly-1)*FontCharSize[CFont]  ,
                lrx   *8-1,  lry   *FontCharSize[CFont]-1,ClipOn);
End;


Procedure InitMVars;
Var
 Vp : ViewPortType;
Begin
 GetViewSettings(Vp);
 With Vp Do
   Begin
     UpperLeft [Level]:= (     x1 Div COLS [ CFont ] )
                           + ( y1 Div ROWS [ CFont ] ) * 256;
     LowerRight[Level]:= (     x2 Div COLS [ CFont ] )
                           + ( y2 Div ROWS [ CFont ] ) * 256;
   End;
 PAttr[Level]:= GetBkColor * 16 + GetColor;
 PPage     [Level]:=0;
 PHor      [Level]:=False;
 PType     [Level]:=0;
 PItem     [Level]:=0;
End;

End.