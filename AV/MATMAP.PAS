
{$F+,O+}

Unit MatMap;

Interface

Procedure DrawMatMap;

Implementation
Uses
 Graph, PVar ;


Procedure DrawMatMap;
Var
 Cx, Cy, Sx, Sy : Integer         ;
 Fs             : FillSettingsType;
 Ind            : Integer         ;
 VidMatr        : Boolean         ;

Begin

 GetFillSettings (Fs);
 SetFillStyle ( SolidFill, DarkGray );


 For Ind:=1 To N_Matrix Do
 Begin

  With Sw Do
  Begin
   Sx := Trunc(X_MAX_MATRIX * GScale / XMAX * (x2-x1+1.0) / 2.0 );
   Sy := Trunc(Y_MAX_MATRIX * GScale / YMAX * (y2-y1+1.0) / 2.0 );
  End ;

  With Sw, MatrixCenter[Ind] Do
   Begin

    Cx := Trunc(( (x2-x1+1) + (X-CenterX) * GScale / XMAX * (x2-x1+1) ) / 2.0);
    Cy := Trunc(( (y2-y1+1) - (Y-CenterY) * GScale / YMAX * (y2-y1+1) ) / 2.0);

    IF ( GScale > 1 )  THEN
     BEGIN

       VidMatr := NOT (     ( ( Cx+Sx ) < X1 )   OR  ( ( Cx-Sx ) > X2 )
                        OR  ( ( Cy+Sy ) < Y1 )   OR  ( ( Cy-Sy ) > Y2 )  ) ;

       IF  VidMatr  THEN

         BEGIN

           IF ( Cx-Sx < X1 )  THEN
              BEGIN
                Sx := Round (  ( Cx + Sx - x1 ) / 2  ) ;
                Cx := x1 + Sx  ;
              END

            ELSE

              IF ( Cx+Sx > X2 )  THEN
                BEGIN
                  Sx := Round (  ( x2 - ( Cx - Sx )  ) / 2  ) ;
                  Cx := x2 - Sx ;
                END ;

           IF ( Cy-Sy < Y1 )  THEN
              BEGIN
                Sy := Trunc (  ( Cy + Sy - y1  ) / 2  ) ;
                Cy := y1 + Sy ;
              END

            ELSE

              IF ( Cy+Sy > Y2 )  THEN
                BEGIN
                  Sy := Trunc (  ( y2 - ( Cy - Sy )  ) / 2  ) ;
                  Cy := y2 - Sy ;
                END ;

           Bar( Cx-Sx, Cy-Sy, Cx+Sx, Cy+Sy) ;

         END ;


     END  { GScale > 1 }
          { ---------- }

    ELSE

       Bar( Cx-Sx, Cy-Sy, Cx+Sx, Cy+Sy) ;

  End ;

 End ;

 With Fs Do SetFillstyle(Color, Pattern);

End ;

End.