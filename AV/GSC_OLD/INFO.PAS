{$O+,F+}

Unit Info;

Interface

Uses  V_Catal, Graph ;


Procedure ObjectInfo  ;
Procedure InitInfo;
Procedure Inform ( item : integer; point : pointtype ) ;


Implementation

Uses

   Sort , TCrt, Screen  , Curs , Find , PObjOut, PProFld, PDayJD ,
   PVar , Pe_Cns , PPreNew , CSpectra , PVarName , Shell_X ;

Const

 ClassId_Opt = 1;
 ClassId_Pln = 2;
 ClassId_Sat = 3;
 ClassId_Non = 4;


 ClassName   : array [1..4] of string[15] = (
  'Opt ','            ','Sat. ','No object' );


 bc        = lightgray;
 fc        = black    ;

var

 clas_w  ,
 Opt_w   , ras_w, dcs_w,
 mv_w    , sp_w , cns_w  : mwtype;


Procedure showepoch( x, y : integer );
var vp : viewporttype;
    jd : double      ;
    s  : string[4]   ;
    c  : integer     ;
Begin
 getviewsettings(vp); setviewport(0,0,getmaxx,getmaxy,clipon); c:=getcolor;

 setusercharsize(4,3,2,3);

 JD := (JDOut - 2415020.5) / 365.2422 + 1900.0;
 str(jd:4:0,s);
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

 clearmw(prw);
 optinf_w:=iopt;
 initmw(optinf_w);

 If LastObject = -1 Then LastObject := ClassId_Opt ;


 With Opt_w Do
   Begin                        { Сведения из Opt }
     case LastObject Of
          ClassId_Opt :  hd:='  N  ';
          ClassId_Pln :  hd:='Diam ';
          ClassId_Sat :  hd:='     ';
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
     hd:=chr(251)+'    ';
     With wnd Do
       Begin
         x1:=optinf_w.wnd.x1+3     ;
         y1:=Opt_w.wnd.y2+5      ;
         x2:=x1+textwidth(hd);
         y2:=y1+textheight('1')       ;
       End;
     puts(ras_w.wnd,false,bc,fc,lefttext,centertext,hd) ;
     showepoch(wnd.x2-2*textwidth('1'), wnd.y2-4);
     With wnd Do
       Begin
         x1 := x2 + 4 ;
         x2:= x1 + LS * textwidth('1');
       End;
   End;

 With dcs_w Do
   Begin
     hd:=chr(252)+'    ';
     With wnd Do
       Begin
         x1:=optinf_w.wnd.x1+3     ;
         y1:=ras_w.wnd.y2+5       ;
         x2:=x1+textwidth(hd);
         y2:=y1+textheight('1')       ;
       End;
     puts(dcs_w.wnd,false,bc,fc,lefttext,centertext,hd) ;
     showepoch(wnd.x2-2*textwidth('1'), wnd.y2-4);
     With wnd Do
       Begin
         x1 := x2 + 4 ;
         x2:= x1 + LS * textwidth('1');
       End;
   End;


 With mv_w Do
   Begin
     hd:=' Mv  ';
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
          ClassId_Opt :  hd:='Klass';
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
         x2:= x1 + LS * textwidth('1');
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


Procedure closeinfo;
Begin
 clearmw(optinf_w); menu_w:=imenuw; initmw(menu_w);  End;


Procedure noopticsdata;
Begin
 puts(Opt_w.wnd ,true,bc,fc,righttext,centertext,'');
 puts(ras_w.wnd ,true,bc,fc,righttext,centertext,'');
 puts(dcs_w.wnd ,true,bc,fc,righttext,centertext,'');
 puts(mv_w.wnd  ,true,bc,fc,righttext,centertext,'');
 puts(sp_w.wnd  ,true,bc,fc,righttext,centertext,'');
 puts(cns_w.wnd,true,bc,fc,centertext,centertext,'');
End;


Procedure inform( item : integer; point : pointtype );

var
 s,ss,t : string [40];
 class	: byte   ;
 sclass	: byte   ;
 ind	: integer;
 N      : longint;
 n1, n2 : longint;
 cneg   : boolean;
 g,mnt  : integer;
 sec    : single ;
 nox,noy: single ;
 ora    ,
 odc    : double ;
 diam   : double ;
 RR     : Double ;
 RI     : LongInt;
 Jd     : Double ;
 Year   : Longint;
 Month  : Integer;
 NZagol : Word   ;
 Day    : Double ;
 NmS    : LongInt;

Begin
 If item >= 0 Then
   Begin

    Sclass := 255 ;

    For Ind := 1 To CatMax Do
      Begin
        If ( ( Item >= IndCat[Ind].NBeg )  And  ( Item <= IndCat[Ind].NEnd ) )
          Then  Sclass := Ind ;
      End ;

      If ( SClass <= CatMax )  Then  Class := ClassId_Opt;

   End
 Else
 Begin
  If ( item = -100 ) Then
       Class:=ClassId_Non
     Else
       Begin
        If ( Planet[-Item].Nr > Max_PL_PPLFLD )
          Then  class:=ClassId_Sat
          Else  class:=ClassId_Pln;
       End;
 End;


 If class <> lastobject Then
   Begin
     lastobject:=class;
     initinfo;
   End;


 Case Class of


   ClassId_Opt : Begin    {  Opt Cat  }

    noopticsdata;

    With objectptr[item div objectblocksize]^
                  [item mod objectblocksize] Do
     Begin



        { Каталог + Классификация объекта + N объектов в осpеднении }
        { --------------------------------------------------------- }

     If (        ( Sclass = CatPPM     )
              Or ( Sclass = CatBs      )
              Or ( Sclass = CatHd      )
              Or ( Sclass = CatCdc     )
              Or ( Sclass = CatCdcMoz  )
                                         )  Then
           Begin

             NmS := NRecC Mod 1000000000 ;

             If ( SClass = CatPPM )  Then
               Begin
                 Seek ( PPMFile , NmS       ) ;
                 Read ( PPMFile , PPMRecord ) ;
                 NmS := PPMRecord.PPM ;
               End ;


             If ( SClass = CatBs )  Then
               Begin
                 Seek ( BsFile , NmS      ) ;
                 Read ( BsFile , BSRecord ) ;
                 NmS := BSRecord.SAO ;
               End ;


             If (      ( SClass = CatCdc    )
                   Or  ( SClass = CatCdcMoz )  )   Then
               Begin

                 RI := ( NRecC Mod 1000000000 ) Div 1000  ;

                 If  ( RI Mod 10 > 0 )
                   Then
                     Begin
                       Str ( RI Div 10  : 7 , t ) ;
                       t := t + Chr ( Ord('a')+ (RI mod 10 - 1)) ;
                     End
                   Else  Str ( RI Div 10 : 7   , t ) ;

                 S := t ;

                 Str ( SP MOD 10 : 2 , t ) ;
                 If ( t [ 2 ] = '1' )  Then  t [ 2 ] := ' ' ;

                 S := S + t + ' ' ;

               End
              Else
               Begin
                 str( Abs ( NmS ) : 6 , s ) ;
               End ;

             puts(Opt_w.wnd ,true,bc,fc,centertext,centertext,s);


           End ;


     If (        ( Sclass = CatPPM     )
              Or ( Sclass = CatBs      )
              Or ( Sclass = CatHd      )
                                         )  Then
           Begin

             s := SpectraName [ Sp div 10 + 1 ];

             If Sp div 10 <> 7  Then
               Begin
                 str( Sp mod 10:1,t);
                 s := s + t ;
               End;

             puts(sp_w.wnd,true,bc,fc,centertext,centertext,s);

           End ;


     Case Sclass of

        CatPPM  :  S := 'PPM '     ;
        CatBs   :  S := 'Bs  '     ;
        CatHd   :  S := 'Hd  '     ;
        CatNLTT :  S := 'Lt  '     ;



        CatImp  :
         Begin

            S := 'Import  '  ;
            Str ( NGrImport  : 5 , t ) ;
            S := S + t + ' : ';
            Str ( NRecC Mod 1000000000  : 3 , t ) ;
            S := S + t ;

            NRecObjectOutFile := NRecC Mod 1000000000 ;


            If ( NRecObjectOutFileOld <> NRecObjectOutFile )  Then

              Begin

                NRecObjectOutFileOld := NRecObjectOutFile    ;
                Seek  ( OutDetFile , NRecObjectOutFile - 1 ) ;
                Read  ( OutDetFile , OutDetStringOld       ) ;

              End ;


         End ; { CatImp }



        CatOkpz :

         Begin

          N := NRecC Mod 1000000000 ;

          n1 := N div 10000;
          n2 := N - longint(n1) * 10000;

          If  ( N < 1000000)   Then

              Begin { ОКПЗ }
                    { ---- }

                If ( n2 <= 334 )
                  Then
                      S  := Argelan [ n2 ] + ' ' + AbbName [ n1 ]
                  Else
                    Begin
                      Str ( n2 :5, S );
                      S := S + ' ' + AbbName [ n1 ]  ;
                    End ;

                S := 'GCVS  ' + S ;

              End   { ОКПЗ }
                    { ---- }

            Else

              Begin { КЗП }
                    { --- }

                      n1 := N div 1000000 ;
                      n2 := N - longint(n1) * 1000000 ;

                      Str ( n2 :6, S );
                      S := 'NSV  ' + S ;

              End ;


         End ;


        CatCdc :

           Begin

                 S := 'AC (centr) ' ;

                 Year := NRecC Mod 1000 ;

                 Month := Year Mod 13 ;
                 Year  := Year Div 13 + 1890 ;

                 Str ( Year : 6 , t ) ;
                 S := S + ' ' + t + ' ' ;

                 If ( ( Month > 12 ) Or ( Month < 1 ) )
                    Then  Month := 13 ;

                 S := S + MonthName [ Month ] ;

           End ;


        CatCdcMoz :

           Begin


                 NZagol := NRecC Mod 1000 ;
                 AkZagolRec := PlateZagol [ NZagol ] ;

                 Str ( AkZagolRec.DcG : 4 , t ) ;
                 If ( t[2] = ' ' )  Then t[2] := '+' ;
                 S := 'AC' + t + ' ' ;

                 Str ( AkZagolRec.RaH : 2 , t ) ;
                 If ( t[1] = ' ' )  Then  t[1] := '0' ;
                 S := S + t ;

                 Str ( AkZagolRec.RaM : 2 , t ) ;
                 If ( t[1] = ' ' )  Then  t[1] := '0' ;
                 S := S + '.' + t ;

                 Year  := AkZagolRec.Year ;
                 Month := AkZagolRec.Mon  ;

                 Str ( Year : 5 , t ) ;
                 S := S + ' ' + t + ' ' ;

                 S := S + MonthName [ Month ] ;

           End ;



        CatGsc  :

           Begin

                       S := ' ';

                   If  ( SP Mod 10 = 0 )
                      Then  S := 'Star    ' + S
                      Else  S := 'Non Star' + S ;

                   S := 'Gsc  ' + S ;

                   If ( ( NRecC Mod 1000000000 ) < 0.01 )
                     Then  RR := 1951.5
                     Else  RR := ( NRecC Mod 1000000000 ) / 10.0 + 1970.0 ;

                   Str ( RR : 10:1, t ) ;
                   S := S + t ;

           End ;



        CatIras :

           Begin

                   g := ( NRecC Mod 1000000000 )  Mod 8 ;

                   str  ( Abs ( ( NRecC Mod 1000000000 )Div 8 ) : 6 , s ) ;
                   puts ( Opt_w.wnd ,true,bc,fc,centertext,centertext,s );

                   If ( g = 1 )
                     Then
                       Begin
                         S := 'Iras' + ' ( SAO' ;
                         If ( SP Mod 10 ) = 1  Then
                           S := S + ' , Spectr' ;
                         S := S + ' )' ;
                       End
                     Else
                       Begin
                         S := 'Iras' ;
                         If ( SP Mod 10 ) = 1  Then
                           S := S + ' ( Spectr )' ;
                       End ;

           End ;



     End ;

     puts ( clas_w.wnd,true,bc,fc,centertext,centertext,S ) ;

     sctoid ( x,y,nox,noy );
     idtoeq ( nox,noy,npolfix,spoznp,cpoznp,ora,odc );
     PreNew ( JDateFld, JDOut, ORA, ODC ) ;

{ *****************************
     If ( B_SURF ) Then
       Begin
  ***************************** }

        radtogms(ora/15,cneg,g,mnt,sec);
        str(g  :3,s)  ; ss :=             s ;  s:=s+  chr(240)+ ' ';
        str(mnt:2,t)  ; ss :=  ss + ' ' + t ;  s:=s+t+chr(241)+ ' ';
        str(sec:6:3,t); ss :=  ss + ' ' + t ;  s:=s+t+chr(242)+ ' ';

{ *************************************************************************
       End
      Else
       Begin
        radtogms(ora,cneg,g,mnt,sec) ;
        str(g  :3,s)  ; ss :=             s ;  s:=s+  chr(243)+ ' ';
        str(mnt:2,t)  ; ss :=  ss + ' ' + t ;  s:=s+t+chr(244)+ ' ';
        str(sec:2:0,t); ss :=  ss + ' ' + t ;  s:=s+t+chr(245)+ ' ';
       End ;
  ************************************************************************* }

     puts(ras_w.wnd ,true,bc,fc,righttext,centertext,s ); { Пр. восхождение }
                                                          { --------------- }
     radtogms(odc,cneg,g,mnt,sec);
       str(g  :3,s);   ss :=             s ;  s:=s+  chr(243)+ ' ';
       str(mnt:2,t);   ss :=  ss + ' ' + t ;  s:=s+t+chr(244)+ ' ';
       str(sec:5:2,t); ss :=  ss + ' ' + t ;  s:=s+t+' '+chr(245)+ ' ';

     If cneg Then s[1]:='-';
     puts(dcs_w.wnd ,true,bc,fc,righttext,centertext,s ); { Склонение }
                                                          { --------- }

           { M }
           { - }

     If ( Sclass = CatIras )
        Then
          Begin
            str ( M/10 - 9 : 4 : 1 , s ) ;
            s := '12 мкм : ' + s ;
          End
        Else  str ( M/10 - 5 : 4 : 1 , s ) ;

     puts(mv_w.wnd,true,bc,fc,centertext,centertext,s);

     If (       B_ObjOut
          And ( NRecObjectOutFile <>   0     )
          And ( Sclass            <> CatImp  )  )  Then

       Begin

         OutDetString := OutDetStringOld ;

         ObjectOut ( Item, Sclass, False, OutDetString ) ;

         Seek  ( OutDetFile , NRecObjectOutFile - 1 ) ;
         Write ( OutDetFile , OutDetString          ) ;

         NRecObjectOutFileOld := 65000 ;

       End ;

     End ;

   End;  { Opt }


                         

              {  Спутник  }
              {  *******  }

     ClassId_Sat :

      Begin   {  Спутник  }
              {  -------  }


         With planet[-item] Do
          Begin
           s:=ClassName[ClassId_Sat];
           str(Nr-Max_PL_PPLFLD:4,t); s:=s+t+' ';               { Hомеp }
           puts(clas_w.wnd,true,bc,fc,centertext,centertext,s);

           str(R:8:0,s); s:=s+' km ';                          { Расстояние }
           puts(sp_w.wnd,true,bc,fc,righttext,centertext,s);

           s:= ' ';
           puts(mv_w.wnd,true,bc,fc,righttext,centertext,s);

          End ;

    With planet[-item] Do

     sctoid(x,y,nox,noy);
     idtoeq(nox,noy,npolfix,spoznp,cpoznp,ora,odc);
     PreNew ( JDateFld, JDOut, ORA, ODC ) ;

{ ***********************************************
     If ( B_SURF )  Then
       Begin
  *********************************************** }

         radtogms(ora/15,cneg,g,mnt,sec);
         str(g  :3,s);        s:=s+  chr(240);
         str(mnt:2,t);        s:=s+t+chr(241);
         str(Round(sec):2,t); s:=s+t+chr(242);
{ ***********************************************
       End
      Else
       Begin
         radtogms(ora,cneg,g,mnt,sec);
         str(g  :3,s);   s:=s+  chr(243);
         str(mnt:2,t);   s:=s+t+chr(244);
         str(sec:2:0,t); s:=s+t+chr(245);
       End ;
  *********************************************** }


     puts(ras_w.wnd ,true,bc,fc,righttext,centertext,s ); { Пр. восхождение }

     radtogms(odc,cneg,g,mnt,sec); str(g  :3,s);        s:=s+  chr(243);
		 	           str(mnt:2,t);        s:=s+t+chr(244);
                                   str(Round(sec):2,t); s:=s+t+chr(245);
     If cneg Then s[1]:='-';
     puts(dcs_w.wnd ,true,bc,fc,righttext,centertext,s ); { Склонение       }



    End ;    {  Спутник  }
             {  -------  }



                {  Планета  }
                {  *******  }


     ClassId_Pln :         

      Begin   { Планета }
              { ------- }


                     { Расстояние }
                     { ---------- }

        S := PlanetName [ Planet [ -Item ].Nr ] ;

        RR := planet[-item].R ;
        If ( RR < 1.0e6 )
          Then
            Begin
              str ( RR:8:0 , t ); s := s + t + ' km ' ;
            End
          Else
            Begin
              str ( RR/Ae:7:2 , t ); s := s + t + ' au ' ;
            End ;

        puts(clas_w.wnd,true,bc,fc,centertext,centertext,s);


             { Диаметp }
             { ------- }

        With planet[-item] Do
        Begin
          Diam:= ArcTan ( D_IZO / FD ) * RG * 60.0;
          If diam < 1.0 Then
            Begin
             Diam:=Diam * 60.0;
             str(Diam:8:1,s); s:=s+chr(245);
            End
           Else
            Begin
             If ( Diam < 60.0 )  Then
               Begin
                mnt := trunc ( Diam ) ;
                sec := ( Diam - mnt ) * 60 ;
                str(mnt:2,s)  ; s:=s     + chr(244);
                str(sec:2:0,t); s:=s + t + chr(245);
               End
              Else
               Begin
                g   := trunc ( Diam       / 60.0 ) ;
                Diam:= Diam - g * 60.0 ;
                mnt := trunc ( Diam ) ;
                sec :=       ( Diam - mnt ) * 60.0 ;
                str(g  :3,s)  ; s:=s+  chr(243);
                str(mnt:2,t)  ; s:=s+t+chr(244);
                str(sec:2:0,t); s:=s+t+chr(245);
               End ;
            End;

          puts(Opt_w.wnd,true,bc,fc,righttext,centertext,s);


              { Mv }
              { -- }

          str(M:8:1,s); s:=s+' ';
          puts(mv_w.wnd,true,bc,fc,righttext,centertext,s);


              { Фаза }
              { ---- }

          radtogms(F,cneg, g,mnt,sec); str(g  :3,s); s:=s  +chr(243);
                                       str(mnt:2,t); s:=s+t+chr(244);
          puts(sp_w.wnd,true,bc,fc,righttext,centertext,s);

          nox:=point.x;
          noy:=point.y;

        End ;


    With planet[-item] Do

     sctoid(x,y,nox,noy);
     idtoeq(nox,noy,npolfix,spoznp,cpoznp,ora,odc);
     PreNew ( JDateFld, JDOut, ORA, ODC ) ;


          { Пр. восхождение планеты }
          { ----------------------- }

     radtogms(ora/15,cneg,g,mnt,sec);
     str(g  :3,s);   s:=s+  chr(240);
     str(mnt:2,t);   s:=s+t+chr(241);
     str(sec:5:2,t); s:=s+t+chr(242);

     puts(ras_w.wnd ,true,bc,fc,righttext,centertext,s );


             { Склонение планеты }
             { ----------------- }

(* *************************************************************

         { Это для Стационаpа }
         { ------------------ }

     If ( Planet[-Item].Nr <> 10 )
       Then
         radtogms(odc,cneg,g,mnt,sec)
       Else
         radtogms(BSatSelenogr,cneg,g,mnt,sec);
   ************************************************************* *)

       radtogms(odc,cneg,g,mnt,sec) ;

       str(g  :3,s);   s:=s+  chr(243);
       str(mnt:2,t);   s:=s+t+chr(244);
       str(sec:4:1,t); s:=s+t+chr(245)+ ' ';
       If cneg Then s[1]:='-';

     puts(dcs_w.wnd ,true,bc,fc,righttext,centertext,s ); 



    End  ;  { Планета }
            { ------- }





   ClassId_Non :
   Begin
          { Обнуление неотождествления импоpтной звезды }
          { ------------------------------------------- }

    If ( B_ObjOut And ( NRecObjectOutFile <> 0 ) )  Then
       Begin
         Seek  ( OutDetFile , NRecObjectOutFile - 1 ) ;
         Write ( OutDetFile, OutDetStringOld ) ;
         NRecObjectOutFileOld := 65000 ;
       End ;

    NRecObjectOutFile := 0 ;

              { ------------  *  ------------- }

    noopticsdata;
    s:=ClassName[ClassId_Non];

    puts(clas_w.wnd,true,bc,fc,centertext,centertext,s); { Классификация }

    nox:=point.x;
    noy:=point.y;
    sctoid(nox,noy,nox,noy);
    idtoeq(nox,noy,npolfix,spoznp,cpoznp,ora,odc);
    PreNew ( JDateFld, JDOut, ORA, ODC ) ;

{ **************************************************
    If ( B_SURF )  Then
      Begin
  ************************************************** }

        radtogms(ora/15,cneg,g,mnt,sec);
        str(g  :3,s); s:=s+  chr(240);
        str(mnt:2,t); s:=s+t+chr(241);

{ **************************************************
      End
     Else
      Begin
        radtogms(ora,cneg,g,mnt,sec);
        str(g  :3,s); s:=s+  chr(243);
        str(mnt:2,t); s:=s+t+chr(244);
      End ;
  ************************************************** }


     puts(ras_w.wnd ,true,bc,fc,righttext,centertext,s ); { Пр. восхождение }


     radtogms(odc,cneg,g,mnt,sec); str(g  :3,s); s:=s+  chr(243);
		 	           str(mnt:2,t); s:=s+t+chr(244);
     If cneg Then s[1]:='-';
     puts(dcs_w.wnd ,true,bc,fc,righttext,centertext,s ); { Склонение       }

     nox:=point.x; noy:=point.y;

{    s:=' ';
     puts(isp_w.wnd ,true,bc,fc,centertext,centertext,s); }

   End;
 End;


     { ОПРЕДЕЛЕHИЕ СОЗВЕЗДИЯ }
     { --------------------- }

 nox:=point.x;
 noy:=point.y;
 sctoid(nox,noy,nox,noy);
 idtoeq(nox,noy,npolfix,spoznp,cpoznp,ora,odc);
 PreNew ( JDateFld, JDOut, ORA, ODC ) ;
 Identify ( 1900+(JDATEFld-2415020)/365.25, ORa,ODc, S ) ;
 puts(cns_w.wnd,true,bc,fc,centertext,centertext,s );


End;



  Procedure ObjectInfo ;
{ ==================== }

var
 Found        : Boolean  ;
 Searching    : boolean  ;
 ModPoint     : PointType;
 SelPoint     : PointType;
 SelectedItem : integer  ;
 vp           : viewporttype;

Begin

 If ( Not ReCalc ) Then RecalcObjects ;

 getviewsettings(vp);

 With sw Do setviewport(x1,y1,x2,y2,clipon);

 InitInfo;

 Searching  :=False;

 SelPoint.X :=StartX - PointerWidth  ;
 SelPoint.Y :=StartY - PointerWidth_Y;

 Repeat

  Searching := Select ( SelPoint );
  If ( Searching )
  Then
  Begin

   EraseMark(SelPoint);

   ModPoint.X := SelPoint.X + PointerWidth   ;
   ModPoint.Y := SelPoint.Y + PointerWidth_Y ;

   Found := FindObject ( ModPoint.X, ModPoint.Y, SelectedItem );

   Inform ( SelectedItem, ModPoint );

   Repeat
   Until KeyPressed;

   EraseMark(SelPoint)  ;

  End;

 Until NOT Searching;

 closeinfo;

 With vp Do setviewport(x1,y1,x2,y2,clipon);

End;

End.
