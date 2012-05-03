{$O+,F+}

Unit CSpectra;       { Таблица цветов для отобpажения спектpов }

Interface
Uses Graph, PVar, V_Catal, PVarMenu ;


Procedure SpectraLine;
Procedure NumbStarCatal ;

Implementation

Procedure SpectraLine;
var
 val: double          ;
 i  : integer         ;
 fs : fillsettingstype;
 vp : viewporttype    ;
 ts : textsettingstype;
 ax ,
 sx ,
 lx : integer         ;

begin

 getviewsettings(vp);
 getfillsettings(fs);
 gettextsettings(ts);

 with plw do
   begin
     setviewport(x1,y1,x2,y2,clipon);
     sx := trunc((x2-x1+1) / length(SpectraName));
     lx:= trunc(sx*0.8);
     i:=(sx-lx) div 2;
     sx:=lx;
     lx:=i;
     ax:=trunc(((x2-x1+1)-length(SpectraName)*(sx+2*lx))/2);
   end;

 setcolor(15);
 settextstyle(SMALLFONT,HORIZDIR,0);
 settextjustify(CENTERTEXT,BOTTOMTEXT);

 for i:=1 to length(SpectraName) do
   begin
     setfillstyle(SOLIDFILL,SpectraCol[i-1]);
     bar(ax+(2*i-1)*lx+(i-1)*sx,2,ax+(2*i-1)*lx+i*sx,2+textheight('1') div 2);
     outtextxy(ax+(2*i-1)*lx+(i-1)*sx+sx div 2, plw.y2-plw.y1-2, SpectraName[i]);
   end;

 with fs do setfillstyle(pattern,color)  ;
 with vp do setviewport(x1,y1,x2,y2,clip);
 with ts do
   begin
     settextstyle(font,direction,charsize);
     settextjustify(horiz,vert);
   end;
end;



Procedure NumbStarCatal ;  { Число Звезд по каталогам }
                           { ------------------------ }
Var


 s,
 s1  : string [ 24 ]   ;
 val : double          ;
 NDel,
 i ,
 IndCatOut,
 Ns  : integer         ;
 fs  : fillsettingstype;
 vp  : viewporttype    ;
 ts  : textsettingstype;
 ax ,
 sx ,
 XOut,
 YOut,
 lx         : integer         ;
 len        : Word;
 OldStyle   : LineSettingsType;

Begin

 GetLineSettings(OldStyle);
 getviewsettings(vp);
 getfillsettings(fs);
 gettextsettings(ts);

 with plw do
   begin

     setviewport(x1,y1,x2,y2,clipon);
     sx := trunc((x2-x1+1) / length(SpectraName));
     lx:= trunc(sx*0.8);
     i:=(sx-lx) div 2;
     sx:=lx;
     lx:=i;
     ax:=trunc(((x2-x1+1)-length(SpectraName)*(sx+2*lx))/2);

   end;

 setcolor ( LightGray ) ;
 settextstyle(DefaultFONT,HORIZDIR,1);
 settextjustify( LeftText, CenterText );

 SetFillStyle( SolidFill, Blue );

 Len  :=  0 ;
 S    := '' ;


      { Число звезд }
      { ----------- }

 Bar( 2, 2, TextWidth('H') * 52 + 6, TextHeight('H')*2 );


 XOut := plw.X1 ;
 YOut := plw.y2 - plw.y1 - TextHeight('H') ;



 If ( B_Import_Sat )  Then
   Begin

     If ( NSatInFild > 0 ) Then
       Begin

         S := ' Sat' ;
         SetColor ( Cyan ) ;
         OutTextXY ( XOut, YOut , S )   ;
         Inc ( XOut , TextWidth ( S ) ) ;

         Str ( NSatInFild , S1 ) ;
         While Pos (' ', S1 ) > 0  Do
           Delete ( S1 , Pos ( ' ', S1 ), 1 ) ;

         S :=  ' ' + S1 ;

         SetColor ( LightGray ) ;
         OutTextXY ( XOut, YOut , S )   ;
         Inc ( XOut , TextWidth ( S ) ) ;

       End ;
   End ;


 If ( B_Import_Fld )  Then
    Begin   { B_Import_Fld }
      If ( B_Inport_Ccd )
        Then
            S1 := NameImpCcd
        Else
          Begin
            Str ( NGrImport : 5 , s1 ) ;
            While Pos (' ', S1 ) > 0  Do
              Delete ( S1 , Pos ( ' ', S1 ), 1 ) ;
          End ;
      {
      s := ' NGrImp ' ;
      }
      s := ' Imp ' ;
      OutTextXY ( XOut, YOut , S )   ;
      Inc ( XOut , TextWidth ( S ) ) ;

      SetColor ( LightGreen ) ;
      s := s1 + ' ' ;
      OutTextXY ( XOut, YOut , S )   ;
      Inc ( XOut , TextWidth ( S ) ) ;
      SetColor ( LightGray ) ;


      SetColor ( LightCyan ) ;
      OutTextXY ( XOut, YOut , NameImp )   ;
      Inc ( XOut , TextWidth ( NameImp ) ) ;
      SetColor ( LightGray ) ;

    End ;  { B_Import_Fld }




 For IndCatOut :=  1  To  CatIzoMax  Do
   Begin
     {
     I := PrioritetIzo [ IndCatOut ] ;
     If  (     ( I                 <= CatMax  )
           And ( I                 <>  0      )
           And ( IndCat [ I ].NEnd >  -1      )  )   Then
         Begin
     }

     I := PrioritetIzo [ IndCatOut ] ;

     If  (     ( I <= CatMax  )
           And ( I <>  0      )  )   Then
         Begin

           If ( IndCat [ I ].NEnd > -1 )
             Then  Ns := IndCat [ I ].NStarInFild
             Else  Ns := 0                        ;

           If (     ( I = CatImp     )
                And ( B_Import_Fld   )
                And ( NStarGrMax = 1 ) )
              Then Ns := 0 ;

           If ( Ns > 0 )  Then
             Begin

               S1 := NameCat [ I ] ;
               While Pos (' ', S1 ) > 0  Do
                     Delete ( S1 , Pos ( ' ', S1 ), 1 ) ;

               If ( B_Tyc_Sai And ( S1 = 'Tyc' ) ) Then
                 S1 := 'TRC' ;

               If ( B_Tyc_2 And ( S1 = 'Tyc' ) ) Then
                 S1 := 'Tc2' ;

               S := ' ' + S1 ;

               SetColor ( Cyan ) ;
               OutTextXY ( XOut, YOut , S )   ;
               Inc ( XOut , TextWidth ( S ) ) ;

               Str ( Ns , S1 ) ;
               While Pos (' ', S1 ) > 0  Do
                  Delete ( S1 , Pos ( ' ', S1 ), 1 ) ;

               S :=  ' ' + S1 ;

               SetColor ( LightGray ) ;
               OutTextXY ( XOut, YOut , S )   ;
               Inc ( XOut , TextWidth ( S ) ) ;

               If (IndCat [ I ] . NoDetInFild > 0 )  Then
                 Begin

                   Str ( Abs ( IndCat [ I ] . NoDetInFild ) ,  S1 ) ;
                   While Pos (' ', S1 ) > 0  Do
                         Delete ( S1 , Pos ( ' ', S1 ), 1 ) ;

                   S := ' ( ' ;
                   OutTextXY ( XOut, YOut , S )   ;
                   Inc ( XOut , TextWidth ( S ) ) ;

                   SetColor ( White ) ;
                   S := S1 ;
                   OutTextXY ( XOut, YOut , S )   ;
                   Inc ( XOut , TextWidth ( S ) ) ;
                   SetColor ( LightGray ) ;

                   S := ' )' ;
                   OutTextXY ( XOut, YOut , S )   ;
                   Inc ( XOut , TextWidth ( S ) ) ;

                 End ;

             End ;

         End ;

   End;


 with fs do setfillstyle(pattern,color)  ;
 with vp do setviewport(x1,y1,x2,y2,clip);

 with OldStyle do
   SetLineStyle(LineStyle, Pattern,
                Thickness);

 with ts do
   begin
     settextstyle(font,direction,charsize);
     settextjustify(horiz,vert);
   end;

End;

end.