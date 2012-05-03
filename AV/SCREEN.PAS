
{$O+,F+}

Unit Screen;

Interface

Uses
 PVar, graph, extfonts, POscreen, Curs;


Procedure InitGr;
Procedure InitMw ( Var mw : mwtype );
Procedure ClearMw( Var mw : mwtype );
Procedure InitIw;
Procedure InitAw;
Procedure InitGw;
Procedure Puts       ( ovp : ViewPortType; do_fill : Boolean;
                       back, fore, horj, verj : Byte; s : String  );
Procedure PutsMessAv ( ovp : ViewPortType; do_fill : Boolean;
                       back, fore, horj, verj : Byte; s : String  );
Procedure Warning ( S : String; Var Ch1, Ch2 : Char  );
Procedure Help ;
Procedure FindSat ;
Procedure InfoAllInCursor ;
Procedure InfoOthers ( IndStar : LongInt;
                       Regim   : Byte     { 0 - Screen,
                                            1 - Simfov.Out }
                     ) ;
Procedure Message   ( msg : String ; bright : Boolean );
Procedure MessageAV ( msg : String ; bright : Boolean );
Procedure ReportI;
Procedure ReportP;
Procedure ReportGc ( x, y : Double ) ;
Procedure ReportGs ( w, h : Double ) ;
Procedure ReportFs;

Implementation

Uses
 Crt, {font,} Greek_f, PVarMenu, BGIDriv, CSpectra, PObjOut, GLib, MLib,
 PProFld, Service, PPreNew, PE_Cns, Check, POutFld, PGalEkv, PXYFLHJ ;



Const

 bc  : Byte = lightgray     ;
 fc  : Byte = black         ;
 abc : Byte = lightred      ;
 afc : Byte = white         ;


 O_HA_W  =  1;
 O_HP_W  =  2;
 O_OM_W  =  3;
 O_IN_W  =  4;
 M_DT_W  =  5;
 M_TI_W  =  6;
 M_AN_W  =  7;
 M_HG_W  =  8;
 C_RA_W  =  9;
 C_DC_W  = 10;
 C_AZ_W  = 11;
 C_ZR_W  = 12;
 F_W     = 13;
 N_W     = 14;
 S_RO_W  = 15;
 S_PA_W  = 16;
 M_RO_W  = 17;


 Width : Array [1..17] Of Byte = (
          9, { HA }
          9, { HP }
          8, { Om }
          8, { I  }
         10, { date }
          8, { time }
          8, { anom }
          8, { HT   }
         10, { Az   }
         10, { Zr   }
          8, { RA   }
          8, { Dc   }
          9, { Field}
          7, { Net  }
          8, { Sun r}
          8, { Sun p}
          8  { Moon }            );



Var

    SRA, CRA,
    SDecl, CDecl,
    Jd                : Double       ;

    SXS, SYS, SZS,
    SVXS , SVYS ,  SVZS ,
    SR_Planet, SFiSGeoc, SSTime : Double ;


Procedure Abort ( Msg : String  );
         {‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹}
Begin
  Writeln(Msg, ': ', GraphErrorMsg(GraphResult));
  Halt(1);
End;



Procedure InitGr;
         {‹‹‹‹‹‹}
Var
 GDriver, GMode : Integer;

Begin

{ Register EGA/VGA driver }

  If RegisterBGIdriver(@EGAVGADriverProc) < 0 Then
    Abort('EGA/VGA');
{ Register TScript font     }

  TFont := InstallUserFont( 'TScr' );
  if RegisterBGIfont(@TScrFontProc) < 0 then
      Abort('TScript Font');

 GDriver := EGA;
 GMode   := EGAHi;

 InitGraph( GDriver,GMode,'' );

 If GraphResult < 0 Then
   Begin
     TextMode ( LastMode );
     WriteLn  ( GraphErrorMsg ( GraphResult ) ) ;
   End;

  getaspectratio(xasp,yasp);
  {
  If ( Not BOlValMenu )  Then
  }
  {
  Load8x8;
  }
  Load_greek ;

  SetColor(LightGray);

End;



Procedure InitMw ( Var mw : mwtype );
         {‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ }

Var
 vp  : ViewPortType;
 c,b : Byte;
 OldStyle   : LineSettingsType;

Begin

 GetViewSettings ( vp );
 c := GetColor;
 b := GetBkColor;
 GetLineSettings(OldStyle);

 SetLineStyle  ( SolidLn,0,1 );

 SetViewPort ( 0, 0, getmaxx, getmaxy, clipon );

 With mw Do
   Begin

     inc ( Count );
     SetColor ( CBox );

     With wnd Do
       Begin

         rectangle ( x1, y1, x2, y2 ) ;
         inc ( x1, 2 );
         inc ( y1, 2 );
         dec ( y2, 2 );
         dec ( x2, 2 );
         SetViewPort  ( x1, y1, x2, y2, Clip  );
         SetFillStyle ( interleavefill, CBack );
         Bar ( 0, 0, x2-x1+1, y2-y1+1 );

         If ( hd <> '' ) Then
           Begin
             SetColor ( CFore ) ;
             SetTextJustify ( centertext, bottomtext );
             outtextxy ( ( x2-x1 ) Div 2, TextHeight ( '1' ) +1, hd ) ;
           End;
       End;
   End;


 With vp Do
   SetViewPort ( x1, y1, x2, y2, Clip );

 With OldStyle Do
   SetLineStyle(LineStyle, Pattern,
                Thickness);
 SetBkColor ( b );
 SetColor   ( c );

End;



Procedure ClearMw ( Var mw : mwtype );
         {‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹}

Var
 vp  : ViewPortType;
 c,b : Byte;

Begin

  GetViewSettings(vp);
  c := GetColor;
  b := GetBkColor;

  SetViewPort(0,0,getmaxx,getmaxy,clipon);

  With mw Do
    Begin
      With wnd Do
        Begin
          dec(x1,2*Count);
          dec(y1,2*Count);
          inc(y2,2*Count);
          inc(x2,2*Count);
          SetFillStyle(solidfill,darkgray);
          Bar(x1,y1,x2,y2);
        End;
      Count := 0;
    End;


  With vp Do SetViewPort(x1,y1,x2,y2,Clip);
  SetBkColor(b);
  SetColor(c);

End;



Procedure InitAw;
         {‹‹‹‹‹‹}
const
 bc : Byte = Blue     ;
 fc : Byte = LightGray;

Var
 y   : Integer;
 ts  : TextSettingsType;

Begin

 { é‡°®‚† , ¢Î·Æ‚† ¢ †ØÆ£•• ® Ø•‡®£••, ≠†™´Æ≠ Æ‡°®‚Î ® §Æ´£Æ‚† ¢Æ·Â. „ß´† }
 { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

 With o_haw Do
   Begin Count := 0;
   hd := ' ';
(*
     If ( B_Surf )  Then  hd := ' '  Else  hd := 'HA';
                                                 {ƒƒƒƒ}
*)
     With wnd Do
       Begin
         x1 := ow.wnd.x1+4 ;
         y1 := ow.wnd.y1 +  TextHeight ( '1' ) +2;
         x2 := x1+ TextWidth ( hd ) ;
         y2 := y1+ TextHeight ( '1' ) ;
       End;

     Puts ( wnd, false, bc, fc, lefttext, centertext, hd ) ;

     With wnd Do
       Begin
         x1 := x2 + 4 ;
         x2 := x1 + Width [ O_HA_W ] * TextWidth ( '1' ) ;
       End;
   End;


If (     ( Not B_Geoc Or ( NPl0 <> 3 ) )
     Or  (     B_From_Star             )  )  Then
Begin { B_Geoc And ( NPl0 <> 3 ) }


 With o_hpw Do
   Begin
     Count := 0;
     hd := 'H';
(*
     If ( B_Surf )  Then  hd := 'H' Else  hd := 'HP' ;
                                                {ƒƒƒƒ}
*)
     With wnd Do
       Begin
         x1 := ow.wnd.x1+4    ;
         y1 := o_haw.wnd.y2 +  TextHeight ( '1' )  Div 2;
         x2 := x1+ TextWidth ( hd ) ;
         y2 := y1+ TextHeight ( '1' )            ;
       End;

     Puts(wnd,false,bc,fc,lefttext,centertext,hd);

     With wnd Do
       Begin
         x1 := x2 + 4 ;
         x2 := x1 + Width[O_HP_W]*TextWidth ( '1' ) ;
       End;

   End;

 With o_omw Do
   Begin
     Count := 0;
     hd := Chr ( 254 ) ;
{
     If ( B_Surf )
       Then  hd := Chr ( 254 )
       Else  hd := Chr(ord('Ø')+1);
}
     With wnd Do
       Begin
         x1 := ow.wnd.x2 - 2 - TextWidth ( '1' ) *(2+length(hd)+Width[O_OM_W]);
         y1 := o_haw.wnd.y1                 ;
         x2 := x1+ TextWidth ( hd ) ;
         y2 := y1+ TextHeight ( '1' )            ;
       End;

     Puts(wnd,false,bc,fc,lefttext,centertext,hd);

     With wnd Do
       Begin
         x1 := x2 + 4 ;
         x2 := x1 + Width[O_OM_W]*TextWidth ( '1' ) ;
       End;
   End;

 With o_inw Do
   Begin
     Count := 0;
     hd := Chr ( 253 ) ;
{
     If ( B_Surf )
       Then  hd := Chr ( 253 )
       Else  hd := Chr(ord('Ø')+2);
}
     With wnd Do
       Begin
         x1 := ow.wnd.x2 - 2 - TextWidth ( '1' ) *(2+length(hd)+Width[O_IN_W]);
         y1 := o_hpw.wnd.y1                 ;
         x2 := x1+ TextWidth ( hd ) ;
         y2 := y1+ TextHeight ( '1' )            ;
       End;

     Puts(wnd,false,bc,fc,lefttext,centertext,hd);

     With wnd Do
       Begin
         x1 := x2 + 4 ;
         x2 := x1 + Width[O_IN_W]*TextWidth ( '1' ) ;
       End;

   End;

 End  { B_Geoc And ( NPl0 <> 3 ) }
Else
 With o_haw Do
   Begin Count := 0;
   {
   If ( Not B_From_Star )
     Then   Hd := '        GeoCenter'
     Else   Hd := '        From Star' ;
   }

   Hd := '        GeoCenter' ;
     With wnd Do
       Begin
         x1 := ow.wnd.x1+4    ;
         y1 := o_haw.wnd.y2 +  TextHeight ( '1' )  Div 2 - 6 ;
         x2 := x1+ TextWidth ( hd ) ;
         y2 := y1+ TextHeight ( '1' )            ;
       End;

     Puts(wnd,false,bc,fc,lefttext,centertext,hd);


 End ;


 { åÆ¨•≠‚ - ØÆ´Æ¶•≠®• ≠† Æ‡°®‚• ® ¢Æ ¢‡•¨•≠®  }
 { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ  }

 With m_dtw Do
   Begin
     Count := 0;
     hd    := '';

     With wnd Do
       Begin
         x1 := mw.wnd.x1 + 1 ;
         y1 := mw.wnd.y1 +  TextHeight ( '1' ) + 2 ;
         x2 := x1+ TextWidth ( hd ) ;
         y2 := y1+ TextHeight ( '1' ) ;
       End;

     Puts ( wnd, false, bc, fc, lefttext, centertext, hd ) ;

     With wnd Do
       Begin
         x1 := x2 ;
         x2 := x1 + Width [ M_DT_W ]     * TextWidth ( '1' )
                                     + 2 * TextWidth ( '1' ) - 2 ;
       End;
   End;

 With m_tmw Do
   Begin
     Count := 0;
     hd    := '';
     With wnd Do
       Begin
         x1 := mw.wnd.x1+4    ;
         y1 := m_dtw.wnd.y2 +  TextHeight ( '1' )  Div 2;
         x2 := x1 + TextWidth  ( hd ) ;
         y2 := y1 + TextHeight ( '1' ) ;
       End;

     Puts(wnd,false,bc,fc,lefttext,centertext,hd);

     With wnd Do
       Begin
         x1 := x2 + 4 ;
         x2 := x1 + Width[M_TI_W] * TextWidth ( '1' )
                               + 2 * TextWidth ( '1' ) ;
       End;
   End;
(*
 With m_anw Do
   Begin
     Count := 0;
     If ( B_Surf )
       Then  hd := ' '
       Else
         Begin
           If ( B_STAC )
               Then  hd := Chr ( 254 )
               Else  hd := 'M';
                           {ƒƒƒ}
         End ;

     With wnd Do
       Begin
         x1 := mw.wnd.x2 - 2 - TextWidth ( '1' ) *(2+length(hd)+Width[M_HG_W]);
         y1 := m_dtw.wnd.y1                 ;
         x2 := x1+ TextWidth ( hd ) ;
         y2 := y1+ TextHeight ( '1' )            ;
       End;

     Puts(wnd,false,bc,fc,lefttext,centertext,hd);

     With wnd Do
       Begin
         x1 := x2 + 4 ;
         x2 := x1 + Width[M_AN_W]*TextWidth ( '1' ) ;
       End;
   End;
*)
(*
 With m_hgw Do
   Begin
     Count := 0;
     If ( B_Surf )
       Then  hd := ' '
       Else  hd := 'H';
                  {ƒƒƒ}
       With wnd Do
         Begin
           x1 := mw.wnd.x2 - 2 - TextWidth ( '1' ) *(2+length(hd)+Width[M_HG_W]);
           y1 := m_tmw.wnd.y1                 ;
           x2 := x1+ TextWidth ( hd ) ;
           y2 := y1+ TextHeight ( '1' )            ;
         End;
       Puts(wnd,false,bc,fc,lefttext,centertext,hd);
       With wnd Do
         Begin
           x1 := x2 + 4 ;
           x2 := x1 + Width[M_HG_W]*TextWidth ( '1' ) ;
         End;
     End;
*)
 { ñ•≠‚‡ - Ø‡Ô¨Æ• ¢Æ·ÂÆ¶§•≠®• ® ·™´Æ≠•≠®• ¢ £‡†§„·≠Æ© ¨•‡• ®
   Æ‡®•≠‚†Ê®Ô Æ·® ¢®ß®‡Æ¢†≠®Ô - †ß®¨„‚ ® ß•≠®‚≠Æ• ‡†··‚ÆÔ≠®• }

 With c_raw Do
   Begin
     Count := 0;
     If ( B_Gal )
       Then hd := 'l'
       Else hd := Chr(251);
     With wnd Do
       Begin
         x1 := cw.wnd.x1+4    ;
         y1 := cw.wnd.y1 +  TextHeight ( '1' ) +2;
         x2 := x1+ TextWidth ( hd ) ;
         y2 := y1+ TextHeight ( '1' )            ;
       End;
{
     Puts(wnd,false,bc,fc,lefttext,centertext,hd);
}
     Puts(wnd,false,bc,LightGreen,lefttext,centertext,hd);
     With wnd Do
       Begin
         x1 := x2 + 4 ;
         x2 := x1 + Width[C_RA_W]*TextWidth ( '1' ) ;
       End;
   End;

 With c_dcw Do
   Begin
     Count := 0;
     If ( B_Gal )
       Then hd := 'b'
       Else hd := Chr(252);
     With wnd Do
       Begin
         x1 := cw.wnd.x1+4    ;
         y1 := c_raw.wnd.y2 +  TextHeight ( '1' )  Div 2;
         x2 := x1+ TextWidth ( hd ) ;
         y2 := y1+ TextHeight ( '1' )            ;
       End;
     {
     Puts(wnd,false,bc,fc,lefttext,centertext,hd);
     }
     Puts(wnd,false,bc,LightGreen,lefttext,centertext,hd);
     With wnd Do
       Begin
         x1 := x2 + 4 ;
         x2 := x1 + Width[C_DC_W]*TextWidth ( '1' ) ;
       End;
   End;

 With c_azw Do
   Begin
     Count := 0;
     If ( B_From_Star )
       Then hd := ' '
       Else hd    := 'A';
                    {ƒƒƒ}
     With wnd Do
       Begin
         x1 := cw.wnd.x2 - 2 - TextWidth ( '1' ) *(2+length(hd)+Width[C_AZ_W]);
         y1 := c_raw.wnd.y1;
         x2 := x1+ TextWidth ( hd )    ;
         y2 := y1+ TextHeight ( '1' ) ;
       End;
     Puts(wnd,false,bc,fc,lefttext,centertext,hd);
     With wnd Do
       Begin
         x1 := x2 + 4 ;
         x2 := x1 + Width[C_AZ_W]*TextWidth ( '1' ) ;
       End;
   End;

 With c_zrw Do
   Begin
     Count := 0;
     hd := ' ';
     If Not ( B_From_Star )  Then
       Begin
         If ( B_Surf )
           Then  hd := 'H'
                      {ƒƒƒ}
           Else  hd := 'Z';
                      {ƒƒƒ}
       End ;
     With wnd Do
       Begin
         x1 := cw.wnd.x2 - 2 - TextWidth ( '1' ) *(2+length(hd)+Width[C_ZR_W]);
         y1 := c_dcw.wnd.y1;
         x2 := x1+ TextWidth ( hd )    ;
         y2 := y1+ TextHeight ( '1' ) ;
       End;
     Puts(wnd,false,bc,fc,lefttext,centertext,hd);
     With wnd Do
       Begin
         x1 := x2 + 4 ;
         x2 := x1 + Width[C_ZR_W]*TextWidth ( '1' ) ;
       End;
   End;

 { ì£´Æ¢Æ• ‡†··‚ÆÔ≠®• ® ØÆß®Ê®Æ≠≠Î© „£Æ´ ëÆ´≠Ê† }

 With  s_row Do
   Begin
     Count := 0;
     hd    := Char ( 213 ) + ' ' ;
     With wnd Do
       Begin
         x1 := p_snw.wnd.x1+4   ;
         y1 := p_snw.wnd.y1 +  TextHeight ( '1' )  + 2;
         x2 := x1+ TextWidth ( hd )    ;
         y2 := y1+ TextHeight ( '1' )               ;
       End;
     Puts(wnd,false,bc,fc,lefttext,centertext,hd);
     With wnd Do
       Begin
         x1 := x2 + 4 ;
         x2 := x1 + Width[S_RO_W]*TextWidth ( '1' ) ;
       End;
   End;

 With  s_paw Do
   Begin
     Count := 0;
     hd    := 'p ';
             {ƒƒƒ}
     With wnd Do
       Begin
         x1 := p_snw.wnd.x1+4   ;
         y1 := s_row.wnd.y2 +  TextHeight ( '1' ) ;
         x2 := x1+ TextWidth ( hd )    ;
         y2 := y1 +  TextHeight ( '1' )           ;
       End;
     Puts(wnd,false,bc,fc,lefttext,centertext,hd);
     With wnd Do
       Begin
         x1 := x2 + 4 ;
         x2 := x1 + Width[S_PA_W]*TextWidth ( '1' ) ;
       End;
   End;


 { ì£´Æ¢Æ• ‡†··‚ÆÔ≠®• ® ØÆß®Ê®Æ≠≠Î© „£Æ´ ã„≠Î }

 With m_row Do
   Begin
     Count := 0;
     If (     ( B_Surf          )
          And ( Not B_Geoc      )
          And ( NPl0 = 3        )
          And ( Not B_From_Star )
                                  )
       Then  hd := 'A '
       Else  hd := Char ( 213 ) + ' '  ;
     With wnd Do
       Begin
         x1 := p_mnw.wnd.x1+4  ;
         y1 := p_mnw.wnd.y1 +  TextHeight ( '1' )  + 2 ;
         x2 := x1+ TextWidth ( hd )  ;
         y2 := y1 +      TextHeight ( '1' )            ;
       End;
     Puts(wnd,false,bc,fc,lefttext,centertext,hd);
     With wnd Do
       Begin
         x1 := x2 + 4 ;
         x2 := x1 + Width[M_RO_W]*TextWidth ( '1' ) ;
       End;
   End;

 With  m_paw Do
   Begin
     Count := 0;
     If (     ( B_Surf          )
          And ( Not B_Geoc      )
          And ( NPl0 = 3        )
          And ( Not B_From_Star )
                                  )
       Then  hd := 'H '
       Else  hd := 'p ';

     With wnd Do
       Begin
         x1 := p_mnw.wnd.x1+4    ; y1 := m_row.wnd.y2 +  TextHeight ( '1' ) ;
         x2 := x1+ TextWidth ( hd )   ; y2 := y1 +  TextHeight ( '1' )           ;
       End;
     Puts(wnd,false,bc,fc,lefttext,centertext,hd);
     With wnd Do
       Begin
         x1 := x2 + 4 ;
         x2 := x1 + Width [S_PA_W]*TextWidth ( '1' ) ;
       End;
   End;

End;




Procedure InitIw;
         {‹‹‹‹‹‹}

Begin
 getaspectratio ( Xasp, Yasp );

 With sw Do
   Begin
     x1 := 0;
     y1 := 0;
     y2 := getmaxy - 2 *  TextHeight ( '1' )  - 4;
     x2 := trunc ( C10 * y2 * yasp/xasp ) ;
   End;

 With plw Do
   Begin
     x1 := 0;
     y1 := sw.y2+2;
     x2 := sw.x2;
     y2 := y1 + 2 *  TextHeight ( '1' )  + 2;
   End;

 With iw Do
   Begin
     Count := 0;
     hd    := '';
     CBack := black   ;
     CBox  := LightGray;
     CFore := White;
     With wnd Do
       Begin
         Count := 0;
         Clip  := true;
         x1    := sw.x2+3;
         x2    := getmaxx;
         y1    := 0;
         y2    := getmaxy;
       End;
   End;

 With ow Do
   Begin
     Count := 0;
     hd := 'Observer coords' ;
(*
     If ( B_Surf )
       Then  hd := 'Observer coords'
       Else  hd := 'Orbit elements';
*)
     CBack := Blue     ;
     CBox  := LightGray;
     CFore := White    ;
     With wnd Do
       Begin
         Clip := true;
         x1   := iw.wnd.x1+3;
         x2   := iw.wnd.x2-3;
         y1   := iw.wnd.y1+2;
         y2   := y1+4* TextHeight ( '1' ) +4;
       End;
   End;

 With mw Do
   Begin
     Count := 0;
     (*
     hd    := 'Date/Time';
              {ƒƒƒƒƒƒƒƒƒ}
     *)
     If ( Not FlagTCivil )
       Then hd := 'UT'
       Else
         Begin
           Str ( DtGrTopo:2, hd ) ;
           If hd [ 1 ] = ' ' Then
             Delete ( hd, 1, 1 ) ;
           hd := 'TCiv:' + ' UT+' + hd + Chr(240) ;
         End ;

     CBack := Blue;
     CBox := LightGray;
     CFore := White;
     With wnd Do
       Begin
         Clip := true;
         x1   := iw.wnd.x1+3;
         x2   := x1 + 25 * textwidth('1') Div 2 ;
         y1   := ow.wnd.y2+ TextHeight ( '1' )  Div 2;
         y2   := y1+4* TextHeight ( '1' ) +4;
       End;
   End;

 With fw Do
   Begin
     Count := 0;
     hd    := 'FoV size';
              {ƒƒƒƒƒƒƒƒ}
     CBack := Blue;
     CBox  := LightGray;
     CFore := LightGreen ;
     With wnd Do
       Begin
         Clip := true;
         x1   := iw.wnd.x1+3;
         x2   := (iw.wnd.x2-iw.wnd.x1) Div 2 - 2 + iw.wnd.x1;
         y1   := mw.wnd.y2+ TextHeight ( '1' )  Div 2;
         y2   := y1+3* TextHeight ( '1' ) +4;
       End;
   End;

 With dw Do
   Begin
       Count := 0;
{
       hd    := 'FoV orient';
}
                {ƒƒƒƒƒƒƒƒƒƒ}
       hd    := '';

       CBack := Blue;
       CBox  := LightGray;
       CFore := White;
       With wnd Do
         Begin
           Clip := true;
           x1   := fw.wnd.x2+3 ;
           x2   := iw.wnd.x2-3 ;
           y1   := mw.wnd.y1   ;
           y2   := fw.wnd.y2   ;
         End;
     End;



 With cw Do
   Begin
     Count := 0;
     hd    := 'of Date' ;
              {ƒƒƒƒƒƒƒ}

     If ( Param.EpOut <> 2 )  Then
       Begin
         JD := (JDOut - 2415020.5) / 365.2422 + 1900.0;
         Str (jd:6:1,hd) ;
       End ;

     hd := 'FoV center ' + hd ;
           {ƒƒƒƒƒƒƒƒƒƒ}

     CBack := Blue;
     CBox := LightGray;
     CFore := LightGreen ;
     With wnd Do
       Begin
         Clip := true;
         x1   := iw.wnd.x1+3;
         x2   := iw.wnd.x2-3;
         y1   := fw.wnd.y2+ TextHeight ( '1' )  Div 2;
         y2   := y1+4* TextHeight ( '1' ) +4;
       End;
   End;

 With ww Do
   Begin
       Count := 0;
       hd    := 'å min  max';
                {ƒƒƒƒƒƒƒƒƒƒƒ}
       CBack := Blue;
       CBox  := LightGray;
       CFore := LightGreen ;

       With wnd Do
         Begin
           Clip := true;
           x1   := iw.wnd.x1+3;
           x2   := (iw.wnd.x1+iw.wnd.x2) Div 2 - 1;
           y1   := cw.wnd.y2+ TextHeight ( '1' )  Div 2;
           y2   := y1+3* TextHeight ( '1' ) +4;
         End;
     End;

 With pxw Do
   Begin
     Count := 0;
     hd    := 'Constelln';
              {ƒƒƒƒƒƒƒƒƒ}
     CBack := Blue;
     CBox  := LightGray;
     CFore := White;
     With wnd Do
       Begin
         Clip := true;
         x1   := ww.wnd.x2+2;
         x2   := iw.wnd.x2-3;
         y1   := ww.wnd.y1 ;
         y2   := ww.wnd.y2;
       End;
   End;

 With pxsw Do
   Begin
     Count := 0;
     hd    := '';
     CBack := Blue;
     CBox  := LightGray;
     CFore := White;
     With wnd Do
       Begin
         Clip := true;
         x1   := pxw.wnd.x1+2    ;
         x2   := x1+8*TextWidth ( '1' ) ;
         y1   := pxw.wnd.y1+ TextHeight ( '1' ) +4;
         y2   := pxw.wnd.y2-4;
       End;
   End;

 With pxiw Do
   Begin
     Count := 0;
     hd    := '';
     CBack := Blue;
     CBox  := LightGray;
     CFore := White;
     With wnd Do
       Begin
         Clip := true;
         x2   := pxw.wnd.x2-4    ;
         x1   := pxsw.wnd.x2 + 4;
         y1   := pxw.wnd.y1+ TextHeight ( '1' ) +4;
         y2   := pxw.wnd.y2-4;
       End;
   End;

 With p_snw Do
   Begin
     Count := 0;
     hd    := '    Sun  ';

     CBack := Blue;
     CBox  := LightGray;
     CFore := White;
     With wnd Do
       Begin
         Clip := true;
         x1   := iw.wnd.x1+3;
         x2   := (iw.wnd.x2-iw.wnd.x1-12) Div 2 - 3 + x1;
         y1   := ww.wnd.y2+ TextHeight ( '1' )  Div 2;
         y2   := y1+5* TextHeight ( '1' ) ;
       End;
   End;

 With p_mnw Do
   Begin
     Count := 0;

     If (     ( B_Surf     )
          And ( Not B_Geoc )
          And ( NPl0 = 3   )  )
       Then  hd := ' Sun AltAz'
       Else  hd := 'Moon';

     If ( B_From_Star )  Then
       hd := 'Moon';

     CBack := Blue;
     CBox  := LightGray;
     CFore := White;
     With wnd Do
       Begin
         Clip := true;
         x1   := p_snw.wnd.x2 + 3;
         x2   := iw.wnd.x2    - 3;
         y1   := ww.wnd.y2    + TextHeight ( '1' )  Div 2;
         y2   := y1 + 5 * TextHeight ( '1' ) ;
       End;
   End;

 With prw Do
   Begin
     Count := 0;
     If ( Not B_VectDiagr )
       Then  hd := '   # of stars in FOV'
       Else  hd := ''          ;
     CBack := Blue;
     CBox  := LightGray;
     CFore := White;
     With wnd Do
       Begin
         Clip := true;
         x1   := iw.wnd.x1    + 3 ;
         x2   := iw.wnd.x2    - 3 ;
         y1   := p_snw.wnd.y2 + TextHeight ( '1' )  Div 2;
         y2   := iw.wnd.y2    - 2 ;
       End;
   End;

   { Menu and Info windows }

 menu_w   := prw ;
 optinf_w := prw ;
 chat_w   := prw ;

 With menu_w Do
   Begin
     Count := 0;
     hd    := 'Menu ';
              {ƒƒƒƒƒ}
   End;

 With optinf_w Do
   Begin
     hd := '    Identification';
           {ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ}
     Count := 0;
   End;


     { ã„Ø† }
     { ƒƒƒƒ }

 With chat_w Do
   Begin
     Count := 0    ;
     hd    := 'Zoom';
               {ƒƒƒƒ}
   End;

 gcent_w := chat_w;
 gsize_w := chat_w;

 With gcent_w Do
   Begin
     Count := 0;
     hd    := 'Center';
              {ƒƒƒƒƒƒ}
     With wnd Do
       Begin
         x1 := chat_w.wnd.x1 + 4                      ;
         x2 := chat_w.wnd.x2 - 4                      ;
         y1 := chat_w.wnd.y1 + 2* TextHeight ( '1' )  ;
         y2 := y1 + 5 *  TextHeight ( '1' )           ;
       End;
   End;

 With gsize_w Do
   Begin
     Count := 0;
     hd    := 'Size';
              {ƒƒƒƒ}
     With wnd Do
       Begin
         x1 := gcent_w.wnd.x1;
         x2 := gcent_w.wnd.x2;
         y2 := chat_w.wnd.y2- TextHeight ( '1' )   ;
         y1 := y2 - 5 *  TextHeight ( '1' )           ;
       End;
   End;


 iprw   := prw      ;
 imenuw := menu_w   ;
 iopt   := optinf_w ;

 With mess_w Do
   Begin
     x1 := menu_w.wnd.x1 + 5 ;
     x2 := menu_w.wnd.x2 - 4 ;
     y2 := menu_w.wnd.y2 - 2 ;
     y1 := y2 - 8            ;
   End;

 With mess_AV Do
   Begin
     x1 := menu_w.wnd.x1 + 5 ;
     x2 := menu_w.wnd.x2 - 4 ;
     y2 := menu_w.wnd.y2 - 2 ;
     y1 := y2 - 8            ;
   End;

 SetColor( LightGray );


 With sw Do
   Begin
     x1 := 0;
     y1 := 0;
     y2 := getmaxy - 2 *  TextHeight ( '1' )  - 4;
     x2 := trunc ( C10 * y2 * yasp / xasp ) ;
     If ( ( YMax / XMax ) < C10 )
        Then
          Begin
            xWord := trunc ( ( y2 - ( y2 * YMax / XMax ) ) / 2 ) ;
            y1    := y1 + xWord ;
            y2    := y2 - xWord ;
          End
        Else
          Begin
            xWord := trunc ( ( x2 - ( x2 * XMax / YMax  ) ) / 2 ) ;
            x1    := x1 + xWord ;
            x2    := x2 - xWord ;
          End ;
   End;


 With sw  Do
   Begin
     rectangle(x1,y1,x2,y2);
     inc(x1);
     inc(y1);
     dec(x2);
     dec(y2);
   End;


 SetColor( LightGray );
 With plw Do
   Begin
     rectangle(x1,y1,x2,y2);
   End;

 initmw ( iw    ) ;
 initmw ( ow    ) ;
 initmw ( mw    ) ;
 initmw ( cw    ) ;
 initmw ( fw    ) ;
 initmw ( ww    ) ;
 initmw ( dw    ) ;
 initmw ( pxw   ) ;
 initmw ( p_snw ) ;
 initmw ( p_mnw ) ;

 If ( Not CalcVectDiagr )  Then
    initmw ( prw   ) ;

 initaw;

End;



Procedure InitGw;
         {‹‹‹‹‹‹}

const
 bc : Byte = Blue     ;
 fc : Byte = LightGray;

Begin

 initmw ( chat_w  ) ;
 initmw ( gcent_w ) ;
 initmw ( gsize_w ) ;

 With gsized_w.wnd Do
   Begin
     y1 := gsize_w.wnd.y1 + 2 * TextHeight ( '1' ) ;
     y2 := gsize_w.wnd.y2 -     TextHeight ( '1' ) ;
     x1 := gsize_w.wnd.x1 + 4                      ;
     x2 := gsize_w.wnd.x2 - 4                      ;
   End ;

 With gra_w Do
   Begin
     Count := 0 ;
     hd    := '';
     With wnd Do
       Begin
         x1 := gcent_w.wnd.x1+4                 ;
         y1 := gcent_w.wnd.y1+2* TextHeight ( '1' )  ;
         x2 := x1+ TextWidth ( hd )                  ;
         y2 := y1+ TextHeight ( '1' )                ;
       End;
     Puts(wnd,false,bc,fc,lefttext,centertext,hd);

     With wnd Do
       Begin
         x1 := x2 +  4 ;
         x2 := x1 + 11 * TextWidth ( '1' ) ;
       End;

   End;


 With gdc_w Do
   Begin
     Count := 0;
     hd    := '';
       With wnd Do
         Begin
           x1 := (gcent_w.wnd.x1+gcent_w.wnd.x2) Div 2 + 2                 ;
           y1 := gcent_w.wnd.y1+2* TextHeight ( '1' )                           ;
           x2 := x1+ TextWidth ( hd ) ;
           y2 := y1+ TextHeight ( '1' )               ;
         End;

       Puts(wnd,false,bc,fc,lefttext,centertext,hd);

       With wnd Do
         Begin
           x1 := x2 +  2 ;
           x2 := x1 + 11 * TextWidth ( '1' ) ;
         End;
   End;

End ;



 Procedure Puts ( ovp                     : ViewPortType ;
{‹‹‹‹‹‹‹‹‹‹‹‹‹‹}  do_fill                 : Boolean      ;
                  back, fore, horj, verj  : Byte         ;
                  s                       : String          );
Var
 vp  : ViewPortType    ;
 fs  : FillSettingsType;
 ts  : TextSettingsType;
 b,c : Byte;
Begin

 GetViewSettings ( vp ) ;
 c := GetColor;
 b := GetBkColor;
 GetFillSettings ( fs ) ;
 GetTextSettings ( ts ) ;

 If Do_fill Then
   SetFillStyle ( SolidFill, Back ) ;
 SetTextJustify ( Horj, Verj ) ;

 With ovp Do
   Begin

    Clip := True ; { H• °Î´Æ ÆØp•§•´•≠Æ. Ç·‚†¢®´ Ä.Ç. }
                   { ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ }

    SetViewPort ( x1, y1, x2, y2, Clip ) ;

    If do_fill Then
      Bar ( 0, 0, x2-x1+1, y2-y1+1 ) ;

    SetColor ( Fore ) ;

    OutTextXy ( Horj*(x2-x1+1) Div 2, Verj*(y2-y1+1) Div 2 + 1, s ) ;

   End;

 With fs Do SetFillStyle   ( Pattern, Color       ) ;
 With ts Do SetTextJustify ( Horiz  , Vert        ) ;
 With vp Do SetViewPort    ( x1, y1, x2, y2, Clip ) ;

 SetColor   ( c ) ;
 SetBkColor ( b ) ;

End;




 Procedure PutsMessAv ( ovp                     : ViewPortType ;
{‹‹‹‹‹‹‹‹‹‹‹‹‹‹}        do_fill                 : Boolean      ;
                        back, fore, horj, verj  : Byte         ;
                        s                       : String          );
Var
 vp  : ViewPortType     ;
 fs  : FillSettingsType ;
 ts  : TextSettingsType ;
 b,c : Byte             ;
Begin

 GetViewSettings ( vp ) ;
 c := GetColor;
 b := GetBkColor;
 GetFillSettings ( fs ) ;
 GetTextSettings ( ts ) ;

 If Do_fill Then
   SetFillStyle ( InterLeaveFill, Back ) ;
 SetTextJustify ( Horj, Verj ) ;

 With ovp Do
   Begin

    Clip := True ; { H• °Î´Æ ÆØp•§•´•≠Æ. Ç·‚†¢®´ Ä.Ç. }
                   { ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ }

    SetViewPort ( x1, y1, x2, y2, Clip ) ;

    If do_fill Then
      Bar ( 0, 0, x2-x1+1, y2-y1+1 ) ;

    SetColor ( Fore ) ;

    OutTextXy ( Horj*(x2-x1+1) Div 2, Verj*(y2-y1+1) Div 2 + 1, s ) ;

   End;

 With fs Do SetFillStyle   ( Pattern, Color       ) ;
 With ts Do SetTextJustify ( Horiz  , Vert        ) ;
 With vp Do SetViewPort    ( x1, y1, x2, y2, Clip ) ;

 SetColor   ( c ) ;
 SetBkColor ( b ) ;

End;




 Procedure  Warning ( S : String; Var Ch1, Ch2 : Char  );

Const
 horj = CenterText ;
 verj = CenterText ;

Var
 vp  : ViewPortType    ;
 fs  : FillSettingsType;
 ts  : TextSettingsType;
 b,c : Byte;
Begin

 GetViewSettings(vp);
 c := GetColor;
 b := GetBkColor;
 GetFillSettings(fs);
 GetTextSettings(ts);

 SetFillStyle ( solidfill, Blue );
 SetTextJustify(horj, verj);

 With plw Do
   Begin
    SetViewPort(x1,y1,x2,y2,True);
    Bar( 2, 2, TextWidth('H') * 52 + 6, TextHeight('H')*2 );
    SetColor ( LightGreen );
    outtextxy(horj*(x2-x1+1) Div 2, verj*(y2-y1+1) Div 2 + 1, s);
   End;

 With fs Do SetFillStyle   ( pattern, color );
 With ts Do SetTextJustify ( horiz  , vert  );
 With vp Do SetViewPort    ( x1, y1, x2, y2, Clip );

 SetColor   ( c ) ;
 SetBkColor ( b ) ;

 Sound ( 500 ) ;
 Delay (  30 ) ;
 NoSound ;

 Repeat  Until  KeyPressed ;
 Ch1 := GetKey ;

 NumbStarCatal ;

End;



Procedure Help ;

 Const HelpText : Array [ 1 .. 26 ] Of String  [ 80 ] =
  (
    '  F4  : Zooming field of viev.',
    '          Dimension new field        :  Grey +  or  Grey -',
    '          Step position & dimension  :  1 .. 9 ',
    '',
    '         Only in mode INFO :',
    '         -----------------',
    '  A   : List all stars in cursor if > 1 star found',
    '        Full info for Others stars',
    '  F2  : Marking pairs for reduction',
    '  F3  : End marking pairs.',
    '  F5  : Marking all stars in field.',
    '  F8  : Erase all stars marking in field.',
    '  F10 : Find satellit name.',
    '',
    '         In Vector Diagram of P.M.:',
    '         -------------------------',
    '  F6  : Selected stars in proper motion sector.',
    '         Grey +    : next      sector ',
    '         Grey -    : previous  sector ',
    '         Esc, Esc  : Cancel regime ',
    '  F7  : Marking all proper motion sectors.',
    '',
    '         In Zooming mode :',
    '         --------------- ',
    '  F9  : Output in Simfov.Out  R.A., Decl, Lgalactic, Bgalactic',
    '        zooming screen center.'
  );

Var
 I       : Integer          ;
 Ch      : Char             ;
 PageNew : Byte             ;
 vp      : ViewPortType     ;
 fs      : FillSettingsType ;
 ts      : TextSettingsType ;
 b,c     : Byte             ;

Begin

  GetViewSettings ( vp );
  c := GetColor;
  b := GetBkColor;
  GetFillSettings ( fs );
  GetTextSettings ( ts );

  If ( NGPages = 1 )
    Then
      Begin
        If ( Page = 0 )
          Then PageNew := 1
          Else PageNew := 0 ;
      End
    Else
      Begin
        PageNew := ( Page + NGPages - 1 ) Mod 2;
      End ;

  SetActivePage ( PageNew ) ;
  SetViewPort ( 0, 0, GetMaxX, GetMaxY, ClipOn );
  ClearViewPort ;

  SetFillStyle ( SolidFill, Blue );
  Bar ( 0, 0, GetMaxX, GetMaxY );

  SetColor( White );
  Rectangle( 5, 5, GetMaxX - 5 , GetMaxY - 5 );

  SetFillStyle ( SolidFill, Blue );
  Bar ( 20, 0, 140, 15 );

  SetColor( Yellow );
  SetTextJustify ( CenterText, CenterText );
  OutTextXY( 80, 7, 'SIMFOV Help' );


  SetFillStyle ( Solidfill, Blue );
  Bar ( GetMaxX - 230, GetMaxY - 10, GetMaxX - 10, GetMaxY);

  SetColor( Yellow );
  SetTextJustify ( CenterText, CenterText );
  OutTextXY ( GetMaxX - 120, GetMaxY - 4, 'Press any key to continue' );

  SetTextJustify ( LeftText, CenterText );
  SetColor ( LightCyan );


  For I := 1 To  26  Do
    Begin
      OutTextXY ( 50, 14 + I * 12, HelpText [ I ] ) ;
      {
      OutTextXY ( 50, 10 + I * 12, HelpText [ I ] ) ;
      }
    End ;

  SetVisualPage ( PageNew ) ;

  Repeat  Until  KeyPressed ;
  Ch := GetKey ;


  If ( NGPages = 1 )
    Then
      Begin
        SetVisualPage ( Page ) ;
        SetActivePage ( Page ) ;
      End
    Else
      Begin

        SetVisualPage ( Page    ) ;
        SetActivePage ( PageNew ) ;

        SetViewPort(0,0,getmaxx,getmaxy,clipon);
        SetFillStyle(emptyfill,0);
        Bar(0,0,getmaxx,getmaxy);
        Initiw;
        ReportI;
        SetActivePage ( Page ) ;

      End ;


  With fs Do SetFillStyle   ( pattern, color );
  With ts Do SetTextJustify ( horiz  , vert  );
  With vp Do SetViewPort    ( x1, y1, x2, y2, Clip );

  SetColor   ( c ) ;
  SetBkColor ( b ) ;

End ;




Procedure FindSat ;

 Const HelpText : Array [ 1 .. 2 ] Of String  [ 60 ] =
  (
    'Enter Satellite Name or International Designator:',
    'Satellite not found '
  );
Label ExitFindSat,
      NextName     ;

Var

 NSat,
 I, I1, J : Integer          ;
 Ch       : Char             ;
 PageNew  : Byte             ;
 vp       : ViewPortType     ;
 fs       : FillSettingsType ;
 ts       : TextSettingsType ;
 b,c      : Byte             ;
 StartX,
 StartY   : Word             ;
 S        : String [ 24 ]    ;
 Name,
 NameFind : Boolean          ;

Begin

  GetViewSettings ( vp );
  c := GetColor;
  b := GetBkColor;
  GetFillSettings ( fs );
  GetTextSettings ( ts );

  If ( NGPages = 1 )
    Then
      Begin
        If ( Page = 0 )
          Then PageNew := 1
          Else PageNew := 0 ;
      End
    Else
      Begin
        PageNew := ( Page + NGPages - 1 ) Mod 2;
      End ;

  SetActivePage ( PageNew ) ;
  SetViewPort ( 0, 0, GetMaxX, GetMaxY, ClipOn );
  ClearViewPort ;

  SetFillStyle ( SolidFill, Blue );
  Bar ( 0, 0, GetMaxX, GetMaxY );

  SetColor( White );
  Rectangle( 5, 5, GetMaxX - 5 , GetMaxY - 5 );

  SetFillStyle ( SolidFill, Blue );
  {
  Bar ( 20, 0, 140, 15 );
  }
  Bar ( 20, 0, 180, 15 );

  SetColor( Yellow );
  SetTextJustify ( CenterText, CenterText );
  {
  OutTextXY( 80, 7, 'Find satellite name' );
  }
  OutTextXY( 100, 7, 'Find satellite' );

  SetFillStyle ( Solidfill, Blue );
  Bar ( GetMaxX - 250, GetMaxY - 10, GetMaxX - 10, GetMaxY);

  SetColor( Yellow );
  SetTextJustify ( CenterText, CenterText );
  OutTextXY ( GetMaxX - 130, GetMaxY - 4, 'Press Enter or Esc to exit' );

  SetTextJustify ( LeftText, CenterText );
  SetColor ( LightCyan );

  SetVisualPage ( PageNew ) ;

  J := 50 ;

  NextName :;

  OutTextXY ( 20, J, HelpText [ 1 ] ) ;

  S  := '' ;
  I  := Length ( HelpText [ 1 ] ) ;

  Repeat
    Begin

      Ch := GetKey ;

      If ( Ch = EscKey )  Then
        GoTo ExitFindSat ;

      If ( Ch = CrKey )  Then
        Begin

          If ( Length ( S ) > 0 )  Then
            Begin { Find Sat Name }

             NameFind := False ;

             While ( Pos ( '_', S ) <> 0 ) Do
               S [ Pos ( '_', S ) ] := ' ' ;

             FileMode := 2 ;
             Reset ( SatNameFile ) ;

             For NSat := 1 To MaxSatellitsInFile Do
               Begin

                 Read ( SatNameFile, SatNameRec ) ;

                 If ( SatNameRec.NameSat [ 1 ] = '*' ) Then
                   Delete ( SatNameRec.NameSat, 1, 1 ) ;

                 If ( S [ 1 ] >= 'A') And ( S [ 1 ] <= 'Z')
                   Then Name := True
                   Else Name := False ;

                 If    (  Name         And ( SatNameRec.NameSat   = S ) )
                    Or (  Not ( Name ) And ( SatNameRec.InternDes = S ) ) Then
                   Begin

                     SatNameRec.NumberSat := - Abs ( SatNameRec.NumberSat ) ;

                     Seek  ( SatNameFile, NSat - 1    ) ;
                     Write ( SatNameFile, SatNameRec  ) ;

                     NameFind := True ;

                   End ;

               End ;

             FileMode := 0 ;
             Close ( SatNameFile ) ;

             If ( Not ( NameFind ) ) Then
               Begin

                 OutTextXY ( 20, J+ 10, HelpText [ 2 ] ) ;
                 J := J + 30 ;
                 GoTo NextName ;

               End ;

            End ; { Find Sat Name }

          GoTo ExitFindSat ;

        End ;

      If ( Ch = BsKey )
        Then
          Begin

            If ( Length ( S ) > 0 )  Then
              Begin

                Delete ( S, Length ( S ), 1 ) ;

                ClearViewPort ;

                SetFillStyle ( SolidFill, Blue );
                Bar ( 0, 0, GetMaxX, GetMaxY );

                SetColor( White );
                Rectangle( 5, 5, GetMaxX - 5 , GetMaxY - 5 );

                SetFillStyle ( SolidFill, Blue );
                Bar ( 20, 0, 140, 15 );

                SetColor( Yellow );
                SetTextJustify ( CenterText, CenterText );
                OutTextXY( 80, 7, 'Find sat' );


                SetFillStyle ( Solidfill, Blue );
                Bar ( GetMaxX - 230, GetMaxY - 10, GetMaxX - 10, GetMaxY);

                SetColor( Yellow );
                SetTextJustify ( CenterText, CenterText );
                OutTextXY ( GetMaxX - 120, GetMaxY - 4, 'Press Enter to exit' );

                SetTextJustify ( LeftText, CenterText );
                SetColor ( LightCyan );


                OutTextXY ( 20, J, HelpText [ 1 ] ) ;

                OutTextXY    ( 70+I*8, J, S ) ;

                {
                SetTextStyle (      0,  0, 2 ) ;
                S [ Length ( S ) ] := ' ' ;
                OutTextXY    ( 70+I*8, J, S ) ;
                Delete ( S, Length ( S ), 1 ) ;
                SetTextStyle (      0,  0, 1 ) ;
                }

              End ;

          End
        Else
          Begin
            If ( Ch = ' ' )  Then
              Ch := '_' ;
            S := S + UpCase ( Ch ) ;
            OutTextXY    ( 70+I*8, J, S ) ;
          End ;

    End
  Until KeyPressed ;
  {
  UserKey  := GetCh ;
  }

  ExitFindSat : ;

  SetTextStyle ( 0, 0, 1 ) ;

  If ( NGPages = 1 )
    Then
      Begin
        SetVisualPage ( Page ) ;
        SetActivePage ( Page ) ;
      End
    Else
      Begin

        SetVisualPage ( Page    ) ;
        SetActivePage ( PageNew ) ;

        SetViewPort(0,0,getmaxx,getmaxy,clipon);
        SetFillStyle(emptyfill,0);
        Bar(0,0,getmaxx,getmaxy);

        Initiw;
        ReportI;
        SetActivePage ( Page ) ;

      End ;


  With fs Do SetFillStyle   ( pattern, color );
  With ts Do SetTextJustify ( horiz  , vert  );
  With vp Do SetViewPort    ( x1, y1, x2, y2, Clip );

  SetColor   ( c ) ;
  SetBkColor ( b ) ;


  If ( NameFind )  Then
    Begin
      ClearScr := True ;
      SetActivePage ( Page ) ;
      SetVisualPage ( Page ) ;
      Initiw;
      ReportI;
      Oscreen ;
      PutImage ( CursX, CursY, PointerMark^, XORPut ) ; { Erase previous one }
    End ;


End ; { FindSat }



Procedure  OutRed  ( IndStar : LongInt ;
                     Regim   : Byte    ;
                     StepY   : Integer ;
                     NStr    : Byte      ) ;

Var

  Neg,
  FileExist1,
  FileExist2 : Boolean          ;

  Ch         : Char             ;

  b,c        : Byte             ;
  PageNew    : Byte             ;

  X,
  IndOut,
  Code,
  G,H,M,
  I, I1, I2  : Integer          ;

  NRec       : LongInt          ;

  Sec,
  Par,
  Ra, Decl,
  CDecl,
  PmRa, PmDecl : Double ;

  S, S1, S2, S3,
  NameCat,
  SFormat,
  SOut,
  StarString : String   ;

  Buf : Array [ 1 .. 2000 ] Of Char ;

  CObject : ObjectType  ;

  vp : ViewPortType     ;
  fs : FillSettingsType ;
  ts : TextSettingsType ;


  FFormat   : Text ;
  FData     : File ;
  CioUnit   : Text ;


Begin

  If ( Regim = 0 )  Then
    Begin
      {
      SetFillStyle ( SolidFill, Blue );
      Bar ( 10, 15, GetMaxX - 10, GetMaxY-12 );

      SetTextJustify ( LeftText, CenterText );
      SetColor ( LightCyan );
      }

      ClearViewPort ;

      SetFillStyle ( SolidFill, Blue );
      Bar(0,0,getmaxx,getmaxy);

      SetColor( White );
      Rectangle( 5, 5, GetMaxX - 5 , GetMaxY - 5 );

      SetFillStyle ( SolidFill, Blue );
      Bar ( 110, 0, 330, 15 );

      SetColor( White );
      SetTextJustify ( CenterText, CenterText );
      OutTextXY( 220, 7, 'Others  Obgect  Info' );

      SetFillStyle ( SolidFill, Blue );
      Bar ( GetMaxX - 550, GetMaxY - 10, GetMaxX - 40, GetMaxY);

      SetColor( White );
      SetColor ( LightCyan );
      SetTextJustify ( LeftText, CenterText );
      S1:=   Chr(24)
           + ' , '
           + Chr(25)
           + ' - Previouse or Next Object,  Esc - Continue View List';

      OutTextXY( GetMaxX - 530, GetMaxY - 5, S1 ) ;

      SetTextJustify ( LeftText, CenterText );
      SetColor ( LightCyan );

    End ;

  CObject := ObjectPtr [ IndStar Div ObjectBlockSize ]^
                       [ IndStar Mod ObjectBlockSize ] ;

  NameCat := CatNameKutcha [ ( CObject.NRecC Mod 1000000000 ) Mod 20 ] ;
  NRec    := ( CObject.NRecC Mod 1000000000 ) Div 20 ;



  FileExist1 := False ;
  FileExist2 := False ;

  Assign ( FFormat , NameCat + '.Fmt') ;
            {$I-}
  FileMode := 0 ;
  Reset  ( FFormat );
            {$I+}
  If ( IOResult = 0 )  Then
    FileExist1 := True  ;


  If ( Not ( FileExist1 ) )  Then
    Begin

      Assign ( FFormat , ParamDir.IrasDir + '\' + NameCat + '.Fmt'    ) ;
            {$I-}
      FileMode := 0 ;
      Reset  ( FFormat );
            {$I+}
      If ( IOResult = 0 )  Then
        FileExist1 := True  ;

    End ;


  I1 := CatKutchaRecL [ ( CObject.NRecC Mod 1000000000 ) Mod 20 ] ;



  Assign ( FData, ParamDir.IrasDir + '\' + NameCat + '.Dat' ) ;
            {$I-}
  FileMode := 0 ;
  Reset  ( FData, I1 );
  FileMode := 2 ;
            {$I+}
  If ( IOResult = 0 )
    Then  FileExist2 := True  ;


  (*
  If (     (    ( NameCat = 'HIP' )
             Or ( NameCat = 'TYC' )  )
       And ( Not FileExist2          )  )  Then
    Begin

        { àÈ•¨ ≠† CD }
        { ƒƒƒƒƒƒƒƒƒƒ }

      Assign ( FData, ParamDir.HipDir + '\' + NameCat + '_Main.Dat' ) ;
            {$I-}

      FileMode := 0 ;
      Reset  ( FData, I1 );
      FileMode := 2 ;

            {$I+}
      If ( IOResult = 0 )
        Then  FileExist2 := True  ;

    End ;
  *)


  If ( FileExist1 And FileExist2 )
    Then
      Begin

        Seek       ( FData, NRec - 1      ) ;
        BlockRead  ( FData, Buf, 1        ) ;
        Close      ( FData                ) ;
        {
        StarString := '' ;
        For I := 1 To I1 - 2 Do
          StarString := StarString + Buf [ I ] ;
        }
        IndOut := 0 ;
        If ( Regim = 0 )  Then
          Begin
            SetColor ( LightGreen );
            OutTextXY ( 20, 20, NameCat ) ;
            If ( NStr <> 0 )  Then
              Begin
                Str ( NStr:3, SOut ) ;
                SetColor ( LightCyan );
                OutTextXY ( GetMaxX - 45, 20, SOut ) ;
              End ;
          End ;
        Inc ( IndOut ) ;



        While ( Not Eof ( FFormat ) )  Do
          Begin

            ReadLn ( FFormat, SFormat ) ;

            While (     ( Length ( SFormat ) > 0 )
                    And ( SFormat [ 1 ] = ' '    )  )  Do
              Delete ( SFormat, 1, 1 ) ;

            While (     ( Length ( SFormat ) > 0 )
                    And ( SFormat [ Length ( SFormat ) ] = ' '    )  )  Do
              Delete ( SFormat, Length ( SFormat ), 1 ) ;

            SOut := '' ;
            X    := 20 ;


            If ( Regim = 1 )
              Then Write ( OutFile, ' ' ) ;

            While ( Length ( SFormat ) > 0 )  Do
              Begin

                I := Pos ( ';', SFormat ) ;
                S := Copy ( SFormat, 1, I-1 ) ;
                Delete ( SFormat, 1, I ) ;

                While (     ( Length ( S ) > 0 )
                        And ( S [ 1 ] = ' '    )  )  Do
                  Delete ( S, 1, 1 ) ;
                Delete ( S, 1, 1 ) ;

                I  := Pos  ( '''', S ) ;

                S1 := Copy ( S , 1  , I-1 ) ;
                Delete     ( S , 1  , I   ) ;

                If ( S1 [ 1 ] <> '*' )
                  Then
                    Begin

                      SOut := S1 + ' ' ;

                      SetColor ( White );
                      SetTextJustify ( LeftText, CenterText );
                      If ( Regim = 0 )
                        Then OutTextXY ( X, 30 + ( IndOut * StepY ), SOut )
                        Else Write ( OutFile, SOut ) ;
                      X := X + 8 * Length ( SOut ) ;

                      While ( Pos ( ' ', S ) > 0 )  Do
                        Delete ( S, Pos ( ' ', S ), 1 ) ;

                      I := Pos ( ',', S ) ;
                      If ( I = 1 )  Then
                        Delete ( S, 1, 1 ) ;

                      S1 := Copy ( S, 1, I-1 ) ;
                      Delete ( S, 1, I ) ;
                      Val ( S1, I1, Code ) ;


                      Val ( S, I2, Code ) ;

                      S1 := '' ;
                      I1 := I1 - 1 ;
                      For I := 1 To I2 Do
                        S1 := S1 + Buf [ I1 + I ] ;


                      If (     ( NameCat                   = 'CIO' )
                           And ( Pos ( 'Flux_Unit', SOut ) <> 0    ) )  Then
                        Begin
                          Assign ( CioUnit, ParamDir.IrasDir + '\' + NameCat + '.Unt' ) ;
                          {$I-}
                          FileMode := 0 ;
                          Reset  ( CioUnit );
                          FileMode := 2 ;
                          {$I+}
                          If ( IOResult = 0 )  Then
                          Begin
                            While (     ( Not Eof ( CioUnit ) )
                                    And ( Length ( S1 ) = 1   )  )   Do
                              Begin

                                Readln ( CioUnit, S2 ) ;

                                S3 := Copy ( S2, Pos ( '''', S2 ) +1, 1 ) ;

                                If ( S1 = S3 )  Then
                                  Begin
                                    Delete ( S2, 1, Pos ( '''', S2 ) + 2 ) ;
                                    While (     ( S2 [ 1 ] = ' '    )
                                            And ( Length ( S2 ) > 0 ) )  Do
                                      Delete ( S2, 1, 1 ) ;
                                    S1 := S2 ;
                                  End ;
                              End ;
                            Close ( CioUnit );
                          End ;

                        End ; { CIO }


                      SOut := S1 ;

                      SetColor( Yellow );
                      SetTextJustify ( LeftText, CenterText );
                      If ( Regim = 0 )
                        Then OutTextXY ( X, 30 + ( IndOut * StepY ), SOut )
                        Else Write ( OutFile, SOut ) ;
                      X := X + 8 * Length ( SOut ) ;
                      SetColor ( White );

                    End
                  Else
                    Begin { Coord Hip or Hip }


                      SOut :=
                      '     R.A.            Decl.       PmRa"/y  PmDc"/y    Par "';
                      SetColor( White  );
                      SetTextJustify ( LeftText, CenterText );
                      If ( Regim = 0 )
                        Then OutTextXY ( X, 30 + ( IndOut * StepY ), SOut )
                        Else WriteLn ( OutFile, SOut ) ;
                      X := X + 8 * Length ( SOut ) ;
                      SetColor ( White );

                      Inc ( IndOut ) ;
                      X := 20 ;



                      SOut :=  '';

                      S1 := '' ;
                      For I := 52 To 63 Do
                        S1 := S1 + Buf [ I ] ;
                      Val ( S1, Ra, Code ) ;

                      S1 := '' ;
                      For I := 65 To 76 Do
                        S1 := S1 + Buf [ I ] ;
                      Val ( S1, Decl, Code ) ;


                      S1 := '' ;
                      For I := 88 To 95 Do
                        S1 := S1 + Buf [ I ] ;
                      While (     ( Length ( S1 ) > 0 )
                              And ( S1 [ Length ( S1 ) ] = ' ' )  )  Do
                        Delete ( S1, Length ( S1 ), 1 ) ;
                      Val ( S1, PmRa, Code ) ;



                      S1 := '' ;
                      For I := 97 To 104 Do
                        S1 := S1 + Buf [ I ] ;
                      While (     ( Length ( S1 ) > 0 )
                              And ( S1 [ Length ( S1 ) ] = ' ' )  )  Do
                        Delete ( S1, Length ( S1 ), 1 ) ;
                      Val ( S1, PmDecl, Code ) ;


                      S1 := '' ;
                      For I := 80 To 86 Do
                        S1 := S1 + Buf [ I ] ;
                      While (     ( Length ( S1 ) > 0 )
                              And ( S1 [ Length ( S1 ) ] = ' ' )  )  Do
                        Delete ( S1, Length ( S1 ), 1 ) ;
                      Val ( S1, Par, Code ) ;





                      Ra     := Ra     * Gr     ;
                      Decl   := Decl   * Gr     ;

                      PmRa   := PmRa   / C10000 / SekRad ;
                      PmDecl := PmDecl / C10000 / SekRad ;


                      RaDcHip  ( Ra, Decl, PmRa, PmDecl ) ;


                      CDecl := Cos ( Decl ) ;

                      RadToHms ( Ra, H, M, Sec );

                      Str(H  : 2, s ) ;
                      If ( S[2] = ' ' ) Then S[2] := '0';
                      SOut := SOut + S ;

                      Str(M:3,s) ;
                      If ( S[2] = ' ' ) Then S[2] := '0';
                      SOut := SOut + S ;

                      Str(Sec:8:4,s);
                      If ( s[2] = ' ' ) Then s[2] := '0';
                      SOut := SOut + S ;

                      SOut := SOut + '  ' ;


                      RadToGms ( Decl, Neg, G, M, Sec );

                      Str(g  :4,s);
                      If ( S[3] = ' ' ) Then S[3] := '0';
                      If Neg Then S[2]:='-';
                      SOut := SOut + S ;

                      Str(M:3,s);
                      If ( s[2] = ' ' ) Then s[2] := '0';
                      SOut := SOut + S ;

                      Str(Sec:8:4,s);
                      If ( s[2] = ' ' ) Then s[2] := '0';
                      SOut := SOut + S ;

                      SOut := SOut + ' ';

                      If ( Abs ( PmRa ) < C10000 )
                        Then  Str ( PmRa * SekRad : 9:4 , s )
                        Else  S := '         ' ;
                      SOut := SOut + S ;

                      If ( Abs ( PmDecl ) < C10000 )
                        Then  Str ( PmDecl * SekRad : 9:4 , s )
                        Else  S := '         ' ;
                      SOut := SOut + S ;

                      Str ( Par / C10000 : 9:4 , s );
                      SOut := SOut + S ;



                      If ( Regim = 1 )  Then
                        Write ( OutFile, ' ' ) ;
                      SetColor( Yellow );
                      SetTextJustify ( LeftText, CenterText );
                      If ( Regim = 0 )
                        Then OutTextXY ( X, 30 + ( IndOut * StepY ), SOut )
                        Else WriteLn ( OutFile, SOut ) ;
                      X := X + 8 * Length ( SOut ) ;
                      SetColor ( White );

                      Inc ( IndOut ) ;
                      X := 20 ;




                        { Coordinats Error }
                        { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

                      If ( Regim = 1 )  Then
                        Write ( OutFile, ' ' ) ;

                      SOut := 'Err' ;

                      SetColor( White  );
                      SetTextJustify ( LeftText, CenterText );
                      If ( Regim = 0 )
                        Then OutTextXY ( X, 30 + ( IndOut * StepY ), SOut )
                        Else Write ( OutFile, SOut ) ;
                      X := X + 8 * Length ( SOut ) ;
                      SetColor ( White );





                      SOut :=  '';

                      S1 := '' ;
                      For I := 106 To 111 Do
                        S1 := S1 + Buf [ I ] ;
                      While (     ( Length ( S1 ) > 0 )
                              And ( S1 [ Length ( S1 ) ] = ' ' )  )  Do
                        Delete ( S1, Length ( S1 ), 1 ) ;
                      Val ( S1, Ra, Code ) ;

                      S1 := '' ;
                      For I := 113 To 118 Do
                        S1 := S1 + Buf [ I ] ;
                      While (     ( Length ( S1 ) > 0 )
                              And ( S1 [ Length ( S1 ) ] = ' ' )  )  Do
                        Delete ( S1, Length ( S1 ), 1 ) ;
                      Val ( S1, Decl, Code ) ;


                      S1 := '' ;
                      For I := 127 To 132 Do
                        S1 := S1 + Buf [ I ] ;
                      While (     ( Length ( S1 ) > 0 )
                              And ( S1 [ Length ( S1 ) ] = ' ' )  )  Do
                        Delete ( S1, Length ( S1 ), 1 ) ;
                      Val ( S1, PmRa, Code ) ;



                      S1 := '' ;
                      For I := 134 To 139 Do
                        S1 := S1 + Buf [ I ] ;
                      While (     ( Length ( S1 ) > 0 )
                              And ( S1 [ Length ( S1 ) ] = ' ' )  )  Do
                        Delete ( S1, Length ( S1 ), 1 ) ;
                      Val ( S1, PmDecl, Code ) ;



                      S1 := '' ;
                      For I := 120 To 125 Do
                        S1 := S1 + Buf [ I ] ;
                      While (     ( Length ( S1 ) > 0 )
                              And ( S1 [ Length ( S1 ) ] = ' ' )  )  Do
                        Delete ( S1, Length ( S1 ), 1 ) ;
                      Val ( S1, Par, Code ) ;


                      Str ( Ra / CDecl / 15.0 / C10000 : 10:4 , s );
                      SOut := SOut + S ;

                      Str ( Decl    / C10000 : 17:4 , s );
                      SOut := SOut + S ;

                      Str ( PmRa    / C10000 : 10:4 , s );
                      SOut := SOut + S ;

                      Str ( PmDecl  / C10000 : 9:4 , s );
                      SOut := SOut + S ;

                      Str ( Par     / C10000 : 9:4 , s );
                      SOut := SOut + S ;



                      SetColor( Yellow );
                      SetTextJustify ( LeftText, CenterText );
                      If ( Regim = 0 )
                        Then OutTextXY ( X, 30 + ( IndOut * StepY ), SOut )
                        Else Write ( OutFile, SOut ) ;
                      X := X + 8 * Length ( SOut ) ;
                      SetColor ( White );

                      Inc ( IndOut ) ;



                    End ; { Coord Hip or Hip }

              End ;

            Inc ( IndOut ) ;

            If ( Regim = 1 )  Then
              WriteLn ( OutFile ) ;

          End ;

        Close  ( FFormat ) ;

      End
    Else
      Begin

        S := 'File  '+ ParamDir.IrasDir + '\' + NameCat + '.Fmt'+ ' Not Exist';
        If ( Not FileExist1 )  Then
          OutTextXY ( 10, 30,  S  ) ;

        S := 'File  '+ ParamDir.IrasDir + '\' + NameCat + '.Dat'+ ' Not Exist';
        If ( Not FileExist2 )  Then
          OutTextXY ( 10, 30,  S  ) ;

      End ;

            {$I-}
     Reset   ( FData ) ;
            {$I+}
     If ( IoResult = 0 ) Then
       Close ( FData ) ;


            {$I-}
     Reset   ( FFormat ) ;
            {$I+}
     If ( IoResult = 0 ) Then
       Close ( FFormat ) ;



End ; { OutRed }






Procedure InfoAllInCursor ;

Label MRepeat ;

Var

  CExit      : Boolean          ;

  NMax,
  IndOut,
  IndOutRed,
  IndSerPage,
J,  I, I1, I2  : Integer          ;

  Ch         : Char             ;
  PageNew    : Byte             ;
  vp         : ViewPortType     ;
  fs         : FillSettingsType ;
  ts         : TextSettingsType ;
  b,c        : Byte             ;
  S1,
  StarString : String           ;
  NDet       : Byte             ;


Begin

  GetViewSettings(vp);
  c := GetColor;
  b := GetBkColor;
  GetFillSettings(fs);
  GetTextSettings(ts);

  If ( NGPages = 1 )
    Then
      Begin
        If ( Page = 0 )
          Then PageNew := 1
          Else PageNew := 0 ;
      End
    Else
      Begin
        PageNew := ( Page + NGPages - 1 ) Mod 2;
      End ;

  SetActivePage ( PageNew ) ;
  SetViewPort(0,0,getmaxx,getmaxy,clipon);

  I1 :=  1 ;
  I2 := 26 ;
  If ( I2 > NFound )  Then
    I2 := NFound ;

  NMax := NFound ;

  If ( NMax > 100 )  Then
    NMax := 100 ;

  IndOut := I1;


MRepeat : ;


  ClearViewPort ;

  SetFillStyle ( SolidFill, Blue );
  Bar(0,0,getmaxx,getmaxy);

  SetColor( White );
  Rectangle( 5, 5, GetMaxX - 5 , GetMaxY - 5 );

  SetFillStyle ( SolidFill, Blue );
  Bar ( 60, 0, 380, 15 );

  SetColor( Yellow );
  SetTextJustify ( CenterText, CenterText );
  OutTextXY( 220, 7, 'Star list at cursor  ( <= 100 stars )' );

  SetFillStyle ( SolidFill, Blue );
  Bar ( GetMaxX - 500, GetMaxY - 10, GetMaxX - 30, GetMaxY);

  SetColor( Yellow );
  SetTextJustify ( CenterText, CenterText );
  S1:=   Chr(24)
       + ' , '
       + Chr(25)
       + ' - Previouse or Next Page,  Any key - Return Info';

  OutTextXY( GetMaxX - 265, GetMaxY - 5, S1 ) ;

  SetTextJustify ( LeftText, CenterText );
  SetColor ( LightCyan );





  IndSerPage := 1 ;

  For I := I2 DownTo  I1  Do
    Begin

          NDet := 1 ;
          ObjectOut ( NumberStarCursor [ I ],
                      CatStarCursor    [ I ],
                      False, NDet, StarString ) ;
          Delete ( StarString, Pos ( '>', StarString ) -1, 2 ) ;
          Delete ( StarString, 8 , 1 ) ;
          Delete ( StarString, Pos ( ';', StarString )   , 1 ) ;
          If ( Pos ( 'Dm', StarString ) > 0 )  Then
            Begin
              S1 :=  ' ' ;
              Insert ( S1, StarString, 15 ) ;
              S1 :=  '                          ' ;
              Insert ( S1, StarString,  6 ) ;
            End ;

          Str  ( IndOut : 3, S1 ) ;
          StarString := S1 + StarString ;
          OutTextXY ( 10, 10 + ( IndSerPage * 12 ), StarString ) ;
          Inc ( IndOut     ) ;
          Inc ( IndSerPage ) ;

    End ;



  { Ñ´Ô ÆØp•§•´•≠®Ô ™Æ§† ·®¨¢Æ´† }
  {
  For J := 1 to 16 Do
    Begin
      For I := 1 To 16 Do
       Begin
        S1 := '' + Char((J-1)*16+I)+ ' ';
        OutTextXY ( 10*I, 10+10*J, S1 ) ;
       End ;
    End ;
  }

  IndOut := I1;

  If (    ( NMax   > I2 )
       Or ( NFound > I2 ) )  Then
    Begin
      StarString := '  . . . . . . . . . . . . . . . . . . . . . ' ;
      OutTextXY ( 0, 10 + ( IndSerPage * 12 ), StarString ) ;
    End ;


  SetVisualPage ( PageNew ) ;


    { List RedStars }

  Repeat  Until  KeyPressed ;
  Ch := GetKey ;


  If (    ( Ch = 'A' )
       Or ( Ch = 'a' ) )  Then
    Begin

      CExit     := False ;
      I         := I2    ;
      IndOutRed := I1    ;

      While ( Not ( CExit ) )  Do
        Begin

          If ( CatStarCursor [ I ] = CatOthers )
           Then
            Begin

              OutRed ( NumberStarCursor [ I ], 0, 13, IndOutRed ) ;

              Repeat  Until  KeyPressed ;
              Ch := GetKey ;

              If ( Ch = ESCKEY )
                Then
                  Begin
                    CExit := True ;
                  End
                Else
                  Begin

                    If (    ( Ch = DownKey )
                         Or ( Ch = PgDnKey ) )  Then
                      Begin
                        Dec ( I ) ;
                        Inc ( IndOutRed ) ;
                      End ;

                    If (    ( Ch = UpKey   )
                         Or ( Ch = PgUpKey ) )  Then
                      Begin
                        Inc ( I ) ;
                        Dec ( IndOutRed ) ;
                      End ;

                  End ;

            End
           Else
            Begin

              If (     ( Ch <> UpKey   )
                   And ( Ch <> PgUpKey ) )  Then
                Begin
                  Dec ( I ) ;
                  Inc ( IndOutRed ) ;
                End ;

              If (    ( Ch = UpKey   )
                   Or ( Ch = PgUpKey ) )  Then
                Begin
                  Inc ( I ) ;
                  Dec ( IndOutRed ) ;
                End ;

            End ;


          If (    ( I < I1 )
               Or ( I > I2 )  )  Then
            CExit := True ;

        End ; { Not ( CExit ) }


      GoTo MRepeat ;

    End ; { Ch = 'A' }



  If (    ( Ch = DownKey )
       Or ( Ch = PgDnKey ) )  Then
    Begin

      If ( NMax > I2 )
        Then
          Begin
            If ( I2 < NMax ) Then
              I1 := I1 + 26 ;
            I2 := I1 + 26 - 1 ;
            If ( I2 > NMax ) Then
                I2 := NMax ;
            IndOut := I1 ;
          End
        Else
            IndOut := I1 ;

      GoTo MRepeat ;

    End ;


  If (    ( Ch = UpKey   )
       Or ( Ch = PgUpKey ) )  Then
    Begin

      If ( I1 > 1 )
        Then
          Begin
            I1 := I1 - 26 ;
            If ( I1 <  1 )  Then
              I1 := 1 ;
            I2 := I1 + 26 - 1 ;
            If ( I2 > NMax ) Then
                I2 := NMax ;
            IndOut := I1 ;
          End
        Else
            IndOut := I1 ;

      GoTo MRepeat ;

    End ;




  If ( NGPages = 1 )
    Then
      Begin
        SetVisualPage ( Page ) ;
        SetActivePage ( Page ) ;
      End
    Else
      Begin

        SetVisualPage ( Page    ) ;
        SetActivePage ( PageNew ) ;

        SetViewPort ( 0, 0, getmaxx, getmaxy, clipon );
        SetFillStyle ( emptyfill, 0 );
        Bar ( 0, 0, getmaxx, getmaxy );
        Initiw;
        ReportI;
        SetActivePage ( Page ) ;

      End ;

  With fs Do SetFillStyle   ( pattern, color );
  With ts Do SetTextJustify ( horiz  , vert  );
  With vp Do SetViewPort    ( x1, y1, x2, y2, Clip );

  SetColor   ( c ) ;
  SetBkColor ( b ) ;

End ;







Procedure InfoOthers ( IndStar : LongInt ;
                       Regim   : Byte        { 0 - Screen,
                                               1 - Simfov.Out }
                     ) ;

Var

  FileExist1,
  FileExist2 : Boolean          ;

  Ch         : Char             ;

  b,c        : Byte             ;
  PageNew    : Byte             ;

  X,
  StepY,
  IndOut,
  Code,
  I, I1, I2  : Integer          ;

  NRec       : LongInt          ;

  S, S1, S2, S3,
  NameCat,
  SFormat,
  SOut,
  StarString : String   ;
  {
  Buf : Array [ 1 .. 256 ] Of Char ;
  }
  CObject : ObjectType  ;

  vp : ViewPortType     ;
  fs : FillSettingsType ;
  ts : TextSettingsType ;


  FFormat   : Text ;
  CioUnit   : Text ;


Begin

  StepY := 13 ;

  c := GetColor;
  b := GetBkColor;

  If ( Regim = 0 )  Then
    Begin

      GetViewSettings(vp);
      GetFillSettings(fs);
      GetTextSettings(ts);

      If ( NGPages = 1 )
        Then
          Begin
            If ( Page = 0 )
              Then PageNew := 1
              Else PageNew := 0 ;
          End
        Else
          Begin
            PageNew := ( Page + NGPages - 1 ) Mod 2;
          End ;

      SetActivePage ( PageNew ) ;
      SetViewPort(0,0,getmaxx,getmaxy,clipon);


      ClearViewPort ;

      SetFillStyle ( SolidFill, Blue );
      Bar(0,0,getmaxx,getmaxy);

      SetColor( White );
      Rectangle( 5, 5, GetMaxX - 5 , GetMaxY - 5 );

      SetFillStyle ( SolidFill, Blue );
      Bar ( 60, 0, 380, 15 );

      SetColor( Yellow );
      SetTextJustify ( CenterText, CenterText );
      OutTextXY( 220, 7, 'Others Catalogue Information' );


      SetFillStyle ( SolidFill, Blue );
      Bar ( GetMaxX, GetMaxY - 10, GetMaxX, GetMaxY);


      SetTextJustify ( LeftText, CenterText );
      SetColor ( LightCyan );


      SetVisualPage ( PageNew ) ;

    End ; { Regim = 0 }


  OutRed ( IndStar, Regim, StepY, 0 ) ;

  If ( Regim = 0 )  Then
    Begin

      Repeat  Until  KeyPressed ;
      Ch := GetKey ;

      If ( NGPages = 1 )
        Then
          Begin
            SetVisualPage ( Page ) ;
            SetActivePage ( Page ) ;
          End
        Else
          Begin

            SetVisualPage ( Page    ) ;
            SetActivePage ( PageNew ) ;

            SetViewPort ( 0, 0, getmaxx, getmaxy, clipon );
            SetFillStyle ( emptyfill, 0 );
            Bar ( 0, 0, getmaxx, getmaxy );
            Initiw;
            ReportI;
            SetActivePage ( Page ) ;

          End ;

      With fs Do SetFillStyle   ( pattern, color );
      With ts Do SetTextJustify ( horiz  , vert  );
      With vp Do SetViewPort    ( x1, y1, x2, y2, Clip );

    End ; { Regim = 0 }

  SetColor   ( c ) ;
  SetBkColor ( b ) ;

End ;




Procedure Message ( msg : String ; bright : Boolean );
         {‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹}
const

 brbc = Blue      ;
 brfc = LightGray ;
 nrbc = LightGray ;
 nrfc = Blue      ;

Begin
 If Bright
   Then Puts ( mess_w, True, brbc, brfc, centertext, centertext, msg )
   Else Puts ( mess_w, True, nrbc, nrfc, centertext, centertext, msg );
 End;


Procedure MessageAV ( msg : String ; bright : Boolean );
         {‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹}
const

 brbc = Red        ;
 brfc = Yellow     ;
 nrbc = Blue       ;
 nrfc = Blue       ;

Begin
 If Bright
   Then Puts       ( mess_AV, True, brbc, brfc, centertext, centertext, msg )
   Else PutsMessAV ( mess_AV, True, nrbc, nrfc, centertext, centertext, msg );
 End;


Procedure ReportI ;        { ç•®ß¨•≠Ô•¨Î• Ø†‡†¨•‚‡Î }
                           { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
Var
 v     : Double     ;
 CNeg  : Boolean    ;
 g,mnt : Integer    ;
 Sec   : Double     ;
 S , T : String[20] ;

Begin

With ParConst Do
 Begin


 { ê†ß¨•‡Î ØÆ´Ô }
 { ƒƒƒƒƒƒƒƒƒƒƒƒ }

 With fw.wnd Do
   Begin
     x1 := x1 + 2;
     x2 := x2 - 2;
     y1 := y1 + 3 * textheight('1') Div 2;
     y2 := y2 -     textheight('1') Div 2;
   End;


 { Ñ´®≠Î ¢Æ´≠ }
 { ƒƒƒƒƒƒƒƒƒƒ }

 With ww.wnd Do
  Begin
    x1 := x1 + 2;
    x2 := x2 - 2;
    y1 := y1 +textheight('1') + 2 ;
    y2 := y2 -2;
  End;

 Str   ( MVMax : 5:1, S ) ;
 PutS ( ww.wnd, True, bc, fc, CenterText, CenterText, S ) ;


 { è†‡†¨•‚‡Î Æ‡°®‚Î }
 { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

(*
 If ( Not B_Surf )  Then
   Begin
     If ( ha <= 999999 )
       Then
         Begin
           Str (ha:(Width[O_HA_W]-3):0,S) ; S:=S+' ™¨';
         End
        Else
         Begin
           Str (ha/AE:5:2,S) ; S:=S+' au';
         End;
     PutS ( o_haw.wnd,True,bc,fc,CenterText,CenterText,S) ;
   End ;
*)

If ( Not B_Geoc Or ( NPl0 <> 3 ) )  Then
Begin { Not B_Geoc And ( NPl0 = 3 ) }
 If  ( B_Surf   )  Then
   Begin  { Earth }

     Str  ( Alt : 3:2, S ) ;
     S := S + ' km' ;

   End ;  { Earth }
(*
  Else

   Begin  { Space }

     If ( hp <= 999999 )
       Then
         Begin
           Str (hp:(Width[O_HP_W]-3):0,S) ; S:=S+' ™¨';
         End
       Else
         Begin
           Str (hp/AE:5:2,S) ; S:=S+' au';
         End ;
   End ; { Space }
*)
 PutS ( o_hpw.wnd, True, bc, fc, CenterText, CenterText, S ) ;



 V := ParConst.i * GR ;

 RadToGMS ( v  , CNeg, g, mnt, Sec) ;
 If CNeg
   Then S := '-'
   Else S := ' ' ;
 Mnt := Round ( Mnt + Sec / C600 ) ;
 G   := G + Mnt Div 60 ;
 Mnt :=     Mnt Mod 60 ;
 Str  ( g  :3, T )      ;
 S := S + T + Chr(243) ;
 Str  ( mnt:2, T )      ;
 S := S + T + Chr(244) ;

 PutS ( o_inw.wnd, True, bc, fc, CenterText, CenterText, S ) ;

 V := ParConst.OmG * GR ;
 RadToGMS ( v  , CNeg, g, mnt, Sec ) ;
 If CNeg
   Then S := '-'
   Else S := ' ' ;
 Mnt := Round ( Mnt + Sec / C600 ) ;
 G   := G + Mnt Div 60 ;
 Mnt :=     Mnt Mod 60 ;
 Str ( g  :3, T )       ;
 S := S + T + Chr(243) ;
 Str  ( mnt:2, T)       ;
 S := S + T + Chr(244) ;

 PutS ( o_omw.wnd, True, bc, fc, CenterText, CenterText, S ) ;

End ; { Not B_Geoc And ( NPl0 = 3 ) }

 With pxw.wnd Do
   Begin
     x1 := x1 + 2               ;
     x2 := x2-2                 ;
     y1 := y1+textheight('1')+2 ;
     y2 := y2-2                 ;
   End;

 PutS ( pxw.wnd, True, bc, fc,CenterText,CenterText,'') ;

End;

End;



Procedure ReportP;
Var
 S,T     : String ;
 Ind     : Integer;
 CNeg    : Boolean;
 g,mnt   : Integer;
 Sec     : Double ;
 RR,
 RaRep,
 DeclRep : Double ;

Begin


   { èp•§•´Ï≠†Ô á¢•ß§≠†Ô Ç•´®Á®≠† }
   { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

Str  ( MVMin : 4:1, T ) ;
Str  ( MVMax : 6:1, S ) ;
S := T + S ;
PutS ( ww.wnd,True,bc,fc,CenterText,CenterText,S) ;

If ( Not CalcVectDiagr )  Then
Begin { Not CalcVectDiagr }

 { Ñ†‚† }
 { ƒƒƒƒ }

 With ParVar.Date Do
  Begin
   If ( ABS ( JDATE - 2451545 ) / 365.2422 < 3000 ) Then
     Begin

       S:='';

       Str  ( day  :2,S) ;
       S := S +     ':' ;
       S := S + MonthName [ Month ] + ':' ;

       T:=''; Str (year {Mod 100:2},T) ; S:=S+T ;
       For Ind:=1 To Length (S) Do
         If ( S[Ind]=' ' )
           Then S[Ind]:='0' ;
       For Ind:=1 To Length (S) Do
         If ( S[Ind]=':' )
           Then S[Ind]:=' ' ;

     End
    Else
     Begin
       Str  (  ROUND ( 2000 + ( JDATE - 2451545 ) / 365.2422 ) : 8, S ) ;
     End ;

   PutS ( m_dtw.wnd, True, bc, fc, CenterText, CenterText, S ) ;

  End; { Date }

 { Ç‡•¨Ô }
 { ƒƒƒƒƒ }

 With ParVar.time Do
  Begin

   S:='';
   Str  ( hour:2,S) ; S := S +     ':' ;
   Str  ( Min :2,T) ; S := S + T + ':' ;
   T:='';
   Str  ( Sec :2:0,T) ; S:=S+T ;

   For Ind:=1 To Length (S) Do
     If ( S[Ind]=' ' ) Then
       S[Ind]:='0' ;

   PutS ( m_tmw.wnd, True, bc, fc, CenterText, CenterText, S ) ;

  End; { Time }



             { ê†ß¨•‡Î ØÆ´Ô }
             { ƒƒƒƒƒƒƒƒƒƒƒƒ }

 If ( Not CalcVectDiagr )  Then
 With ParConst Do
 Begin

 If ( ( Wg / GScale ) > 1 )
  Then
   Begin
     Str  ( Wg / GScale :4:1,S) ;
     S := S + Chr(243) + 'x' ;
   End
  Else
   Begin
     If ( ( Wg / GScale  * 60 ) > 1 )  Then
       Begin
         Str ( Wg / GScale  * 60 :4:1,S) ;
         S := S + Chr(244) + 'x' ;
       End
      Else
       Begin
         Str ( Wg / GScale  * 3600 :4:1,S) ;
         S := S + Chr(245) + 'x' ;
       End ;
   End ;

 If ( ( Hg / GScale )  > 1 )
  Then
   Begin
     Str ( Hg / GScale :4:1,T) ;
     S := S + T + Chr(243) ;
   End
  Else
   Begin
     If ( ( Hg / GScale  * 60 ) > 1 )  Then
       Begin
         Str ( Hg / GScale  * 60 :4:1,T) ;
         S := S + T + Chr(244) ;
       End
      Else
       Begin
         Str ( Hg / GScale  * 3600 :4:1,T) ;
         S := S + T + Chr(245) ;
       End ;
   End ;

  PutS ( fw.wnd, True, bc, fc, CenterText, CenterText, S ) ;

 End ;



           { è‡Ô¨Æ• ¢Æ·ÂÆ¶§•≠®• ® ·™´Æ≠•≠®• Ê•≠‚‡† }
           { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

 If ( Not B_Gal )
 Then
  Begin
   With ParVar.ra0 Do
    Begin
     S:=''; T:='';
     Str (Deg:3,S) ; S:=S     + Chr(240) ;
     Str (Min:2,T) ; S:=S + T + Chr(241) ;
     Str (Sec:2,T) ; S:=S + T + Chr(242) ;
     For Ind:=3 To Length (S) Do
       If ( S[Ind]=' ' ) Then
         S[Ind] := '0';
    End;
  End
 Else
  Begin
   With ParVar.ra0 Do
    Begin
     S:=''; T:='';
     Str (Deg:3,S) ; S := S     + Chr(243) ;
     Str (Min:2,T) ; S := S + T + Chr(244) ;
     Str (Sec:2,T) ; S := S + T + Chr(245) ;
     For Ind:=3 To Length (S) Do
       If ( S[Ind]=' ' )  Then
         S[Ind] := '0';
    End;
  End ;

 PutS ( c_raw.wnd, True, bc, fc, CenterText, CenterText, S ) ;

 With ParVar.Dc0 Do
   Begin
     S:='';
     T:='';
     Str (Deg:2,S) ; S:=S     + Chr(243) ;
     Str (Min:2,T) ; S:=S + T + Chr(244) ;
     Str (Sec:2,T) ; S:=S + T + Chr(245) ;
     For Ind:=2 To Length (S) Do
       If ( S[Ind]=' ' ) Then
         S[Ind] := '0';
     If ( Neg )
       Then S:='-'+S
       Else S:='+'+S;
     PutS ( c_dcw.wnd, True, bc, fc, CenterText, CenterText, S ) ;
   End;  { Dc }


(* *************************************************************************
*
 {  ÇÎ·Æ‚† ® ·‡. †≠Æ¨†´®Ô }
 {  ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

If (    ( Not B_Surf                )
     Or (     ( B_Geoc Or B_Surf )
          And ( NPl0 <> 3        )  )  )  Then
Begin
 With ParVar Do Begin

 If (     ( B_Geoc Or B_Surf )
      And ( NPl0 <> 3        )  )
   Then  RadToGMS (LONGS ,CNeg,g,mnt,Sec)    { LongS }
   Else  RadToGMS (M*GR  ,CNeg,g,mnt,Sec) ;

   Str (g  :3,S) ; S:=S+  Chr(243) ;
   Str (mnt:2,T) ; S:=S+T+Chr(244) ;

 PutS ( m_anw.wnd,True,bc,fc,righttext,CenterText,S) ;

 S:='';
 If ( h < 1.5e7 )
   Then
     Begin
       Str (h:(Width[M_HG_W]-2):0,S) ; S:=S+' ™¨';
     End
    Else
     Begin
       Str (h/AE:4:1,S) ; S:=S+' au';
     End;
 PutS ( m_hgw.wnd,True,bc,fc,righttext,CenterText,S) ;           End;  { M & H }
End ;

 ************************************************************************* *)

If (    ( Not B_Surf                )
     Or (     ( B_Surf Or B_Geoc )
          And ( NPl0 <> 3        )  )  )  Then
If ( Not B_Geoc Or ( NPl0 <> 3 ) ) Then
Begin
 With ParVar Do
   Begin

     RR := LongS ;
     If ( RR > Pi ) Then
       RR := RR - Pi * C20 ;

     RadToGMS ( RR, CNeg, g, mnt, Sec ) ;   { Long }

     If ( Sec > 30.0 )  Then
       Inc ( Mnt ) ;
     If ( Mnt = 60 )  Then
       Begin
         Mnt := 0 ;
         Inc ( G ) ;
         G := G Mod 360 ;
       End ;

     Str (g  :3,S) ; S:=S+  Chr(243) ;
     Str (mnt:2,T) ; S:=S+T+Chr(244) ;
     If ( CNeg )  Then
       S := '-' + S ;

     PutS ( o_omw.wnd, True, bc, fc, righttext, CenterText, S ) ;

     S:='';

     RadToGMS ( FISGEOC, CNeg, g, mnt, Sec ) ;   { Lat }

     If ( Sec > 30.0 )  Then
       Inc ( Mnt ) ;
     If ( Mnt = 60 )  Then
       Begin
         Mnt := 0 ;
         Inc ( G ) ;
       End ;

     Str (g  :3,S) ; S:=S+  Chr(243) ;
     Str (mnt:2,T) ; S:=S+T+Chr(244) ;
     If ( CNeg )  Then
       S := '-' + S ;

     PutS ( o_inw.wnd, True, bc, fc, righttext, CenterText, S ) ;

     XYFLHJ  ( FiSGeoc, LongS, 0.0, JDate,
               SXS, SYS, SZS,
               SVXS , SVYS ,  SVZS ,
               SR_Planet, SFiSGeoc, SSTime ) ;

     If ( ( RosGeoc - SR_Planet ) <= 999999 )
       Then
         Begin
           Str  ( RosGeoc - SR_Planet : ( Width [ O_HP_W ] -3 ) : 0, S );
           S := S + ' ™¨' ;
         End
       Else
         Begin
           If  ( ( RosGeoc - SR_Planet ) / AE  < 999 )
             Then Str  ( ( RosGeoc - SR_Planet ) / AE : 5 : 2,S)
             Else Str  ( ( RosGeoc - SR_Planet ) / AE : 5 : 0,S) ;
           S := S + ' au' ;
         End ;
     {
     If ( ( RosGeoc - R_Planets [ 3 ] ) <= 999999 )
       Then
         Begin
           Str  ( RosGeoc - R_Planets [ 3 ] : ( Width [ O_HP_W ] -3 ) : 0, S );
           S := S + ' ™¨' ;
         End
       Else
         Begin
           If  ( ( RosGeoc - R_Planets [ 3 ] ) / AE  < 999 )
             Then Str  ( ( RosGeoc - R_Planets [ 3 ] ) / AE : 5 : 2,S)
             Else Str  ( ( RosGeoc - R_Planets [ 3 ] ) / AE : 5 : 0,S) ;
           S := S + ' au' ;
         End ;
     }
     PutS ( o_hpw.wnd, True, bc, fc, CenterText, CenterText, S ) ;



   End;  { M & H }

End ;

                { Äß®¨„‚ ® ¢Î·Æ‚† }
                { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

 With ParVar Do
 Begin

  With A0 Do
   Begin
     If (     (     B_Surf      )
          And ( Not B_Geoc      )
          And ( Not B_From_Star )  )
       Then
         Begin
           S:='';
           Str ( Deg : 2, S ) ; S := S     +Chr ( 243 ) ;
           Str ( Min : 2, T ) ; S := S + T +Chr ( 244 ) ;
           If Neg
             Then S:='-'+S
             Else S:=' '+S ;
         End
       Else
         S := '       ' ;
     PutS ( c_azw.wnd, True, bc, fc, righttext, CenterText, S ) ;
   End;

  With Z0 Do
   Begin

     If (     (     B_Surf      )
          And ( Not B_Geoc      )
          And ( Not B_From_Star )  )
       Then
         Begin

           If ( B_Surf )
             Then
               Begin
                 If Neg
                   Then S := '-'
                   Else S := ' ';
               End
             Else
               S := '' ;

           Str  ( Deg:2,T ) ; S:=S+T+Chr(243) ;
           Str  ( Min:2,T ) ; S:=S+T+Chr(244) ; S:=' '+S;

         End
       Else
         S := '        ' ;


     PutS ( c_zrw.wnd, True, bc, fc, righttext, CenterText, S ) ;

   End;

 End;  { Az & H }




      { èÆß®Ê®Æ≠≠Î© „£Æ´ ® p†··‚ÆÔ≠®• ëÆ´≠Ê† }
      { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }


 RadToGMS (RoSun ,CNeg,g,mnt,Sec) ;
 Str (g  :3,S) ; S:=S+  Chr(243) ;
 Str (mnt:2,T) ; S:=S+T+Chr(244) ;
 If ( pom_fld Mod 10 = 1 )
   Then PutS ( s_row.wnd, True, abc, afc, righttext, CenterText, S )
   Else PutS ( s_row.wnd, True,  bc,  fc, righttext, CenterText, S ) ;

 RadToGMS (PozSun ,CNeg,g,mnt,Sec) ;
 Str (g  :3,S) ; S:=S+  Chr(243) ;
 Str (mnt:2,T) ; S:=S+T+Chr(244) ;
 PutS ( s_paw.wnd, True, bc, fc, righttext, CenterText, S ) ;
                                                               { Sun Ro&P }


      { èÆß®Ê®Æ≠≠Î© „£Æ´ ® p†··‚ÆÔ≠®• ã„≠Î }
      { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }



 If (     ( B_Surf          )
      And ( Not B_Geoc      )
      And ( NPl0 = 3        )
      And ( Not B_From_Star )
                               )
   Then
     Begin

       RadToGMS ( ASun, CNeg, g, mnt, Sec ) ;

       If ( Sec > 30.0 )  Then
         Begin
           Inc ( mnt ) ;
           If ( mnt = 60 )  Then
             Begin
               mnt := 0 ;
               Inc ( g ) ;
               g := g Mod 360 ;
             End ;
         End ;

       Str ( g   : 3, S ) ;    S := S +     Chr ( 243 ) ;
       Str ( mnt : 2, T ) ;    S := S + T + Chr ( 244 ) ;

       PutS ( m_row.wnd,True, bc, fc,righttext,CenterText,S) ;



       RadToGMS ( HSun, CNeg, g, mnt, Sec ) ;

       If ( Sec > 30.0 )  Then
         Begin
           Inc ( mnt ) ;
           If ( mnt = 60 )  Then
             Begin
               mnt := 0 ;
               Inc ( g ) ;
             End ;
         End ;


       Str ( g   : 3, S ) ;    S := S +     Chr ( 243 ) ;
       Str ( mnt : 2, T ) ;    S := S + T + Chr ( 244 ) ;

       If ( HSun < 0.0 )  Then
         S := '-' + S ;

       If ( HSun * Rg > - 6.0 )
         Then  PutS ( m_paw.wnd, True, abc, afc, righttext, CenterText, S )
         Else  PutS ( m_paw.wnd, True,  bc,  fc, righttext, CenterText, S ) ;

     End
   Else
     Begin

       RadToGMS ( RoMon  ,CNeg,g,mnt,Sec) ;

       Str (g  :3,S) ; S:=S+  Chr(243) ;
       Str (mnt:2,T) ; S:=S+T+Chr(244) ;

       If ( Pom_fld Div 10 = 1 )
         Then PutS ( m_row.wnd,True,abc,afc,righttext,CenterText,S)
         Else PutS ( m_row.wnd,True, bc, fc,righttext,CenterText,S) ;

       RadToGMS ( PozMon  ,CNeg,g,mnt,Sec) ;

       Str (g  :3,S) ; S:=S+  Chr(243) ;
       Str (mnt:2,T) ; S:=S+T+Chr(244) ;

       PutS ( m_paw.wnd,True,bc,fc,righttext,CenterText,S) ;

     End ;




                 { è‡Æ‰®´Ï }
                 { ƒƒƒƒƒƒƒ }
 If ( BReportOScreen )  Then
   Begin { BReportOScreen }
         { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
     If ( Not B_VectDiagr )  Then
        Profile ( ParVar.nst ) ;

   End ; { BReportOScreen }
         { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }


                 { Ç•™‚Æ‡ }
                 { ƒƒƒƒƒƒ }

 { vector(ParVar.vc, ParVar.RC) ; }



      { ép®•≠‚†Ê®Ô ·®·‚•¨Î ™ÆÆp§®≠†‚ }
      { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

 Orient;

 { ëÆß¢•ß§®•, ¢ ™Æ‚ÆpÆ¨ ≠†ÂÆ§®‚·Ô Ê•≠‚p ØÆ´Ô }
 { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

 PutS ( pxw.wnd, True, bc, fc, CenterText, CenterText, '' ) ;

 RaRep   := RaOpt ;
 DeclRep := DeclOpt ;
 PreNew ( JDATEFLD, JDOut, RaRep, DeclRep ) ;

 Identify ( JDOut, RaRep, DeclRep, S ) ;
 PutS ( pxw.wnd, True, bc, fc, CenterText, CenterText, S ) ;

End ; { Not CalcVectDiagr }



 If ( CalcVectDiagr )  Then
   Begin

     Str  ( Param.RRX * 2 / GScale : 5 : 3 , S ) ;
     S := S + ' "/y' ;

     PutS ( fw.wnd, True, bc, fc, CenterText, CenterText, S ) ;

   End ;



     { ó®·´Æ ß¢•ß§ ¢¨•·‚Æ ¢Î§†Á® ·Ø•™‚p† }
     { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

 NumbStarCatal ;

End;



Procedure ReportGc ( x, y : Double ) ;
Var
 S , T,
 SOut     : String ;
 L, B,
 Ra, Dc   : Double ;
 Deg, Min : Integer;
 Sec      : Double ;
 CNeg     : Boolean;
 IndReg,
 Ind      : Byte   ;
 Nx, Ny   : Double ;
Begin

 { è‡Ô¨Æ• ¢Æ·ÂÆ¶§•≠®• ® ·™´Æ≠•≠®• Ê•‚‡† Æ™≠† GLASS }
 { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }

 If ( Not CalcVectDiagr )  Then
 Begin  { Not CalcVectDiagr }

 ScToId ( x, y, Nx, Ny ) ;
 {
 If ( OptRd )
   Then
     Begin
       IdToEq1 ( Nx, Ny, Ra, Dc ) ;
     End
   Else
     Begin
       IdToEq ( Nx,Ny,NPolFix,SPozNp,CPozNp,Ra,Dc ) ;
       PreNew ( JDateFld, JDOut, Ra, Dc ) ;
     End ;
 }

 IdToEq1 ( Nx, Ny, Ra, Dc ) ;



 RaOptGlass   := Ra ;
 DeclOptGlass := Dc ;


 If ( Not B_Gal )
  Then
   Begin

     S:='';
     T:='';

     RadToGMS ( Ra/15, CNeg, Deg, Min, Sec) ;

     If Round(Sec*10) = 600 Then
       Begin
         Sec :=       0 ;
         Min := Min + 1 ;
         If Min = 60 Then
           Begin
             Min :=       0 ;
             Deg := Deg + 1 ;
           End ;
       End ;

     Str (Deg:2,S) ;        S:=S     + Chr(240) ;
     Str (Min:2,T) ;        S:=S + T + Chr(241) ;
     Str (Sec:4:1,T) ;      S:=S + T + Chr(242) ;

   End
  Else
   Begin

     RadToGMS ( Ra, CNeg, Deg, Min, Sec ) ;

     S:=''; T:='';
     Str (Deg:2,S) ;         S:= S     + Chr(243) ;
     Str (Min:2,T) ;         S:= S + T + Chr(244) ;
     Str (Round(Sec):2,T) ;  S:= S + T + Chr(245) ;

     For Ind := 2 To Length (S) Do
       If ( S[Ind]=' ' ) Then
         S[Ind] := '0';
     S:= ' ' + S;

   End ;


 PutS ( gra_w.wnd, True, bc, fc, CenterText, CenterText, S ) ;


 RadToGMS (Dc, CNeg, Deg, Min, Sec) ;
 S := '' ;
 T := '' ;

 If Round(Sec) = 60 Then
   Begin
     Sec :=       0 ;
     Min := Min + 1 ;
     If Min = 60 Then
       Begin
         Min :=       0 ;
         Deg := Deg + 1 ;
       End ;
   End ;

 Str (Deg:2,S) ;         S := S     + Chr(243) ;
 Str (Min:2,T) ;         S := S + T + Chr(244) ;
 Str (Round(Sec):2,T) ;  S := S + T + Chr(245) ;

 For Ind:=2 To Length (S) Do
   If ( S[Ind]=' ' ) Then
     S[Ind] := '0';

 If ( CNeg )
   Then S := '-' + S
   Else S := '+' + S ;

 PutS ( gdc_w.wnd, True, bc, fc, CenterText, CenterText, S ) ;



    { ÇÎ¢Æ§ ¢ ‰†©´ Ê•≠‚p† Æ™≠† 'Glass' }
    { ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹  }


 If ( OutPoint )  Then
   Begin  { ÇÎ¢Æ§ ¢ ‰†©´ Ê•≠‚p† Æ™≠† 'Glass' }

     FileMode := 2 ;

     If ( Exist ( OutFileName  ) )
       Then
         Begin
           Assign  ( OutFile,  OutFileName ) ;
           Append  ( OutFile               ) ;
         End
       Else
         Begin
           Assign  ( OutFile,  OutFileName ) ;
           ReWrite ( OutFile               ) ;
         End;

     FileMode := 0 ;

     If ( Not FlagFieldZagol )  Then
       OutZagol ;


     Inc ( NMarking ) ;
     Write ( OutFile, NumbMarkingBegin + 1 : 5, '.',
                      NMarking : 3, '  '             ) ;


     If ( B_Gal )
       Then
         Begin
           L := Ra ;
           B := Dc ;
           GalEkv ( L, B, Ra, Dc, SRa, CRa, SDecl, CDecl ) ;
         End
       Else
         Begin
           EkvGal ( Ra, Dc, L, B ) ;
         End ;


     For  IndReg := 1 To 2 Do
       Begin

         If ( IndReg = 1 )
           Then  RadToGMS ( Ra/15, CNeg, Deg, Min, Sec )
           Else  RadToGMS ( L    , CNeg, Deg, Min, Sec ) ;

         If Round(Sec*10) = 600 Then
            Begin
              Sec :=       0 ;
              Min := Min + 1 ;
              If Min = 60 Then
                 Begin
                   Min :=       0 ;
                   Deg := Deg + 1 ;
                 End ;
            End ;

         If ( IndReg = 1 )
           Then
             Begin
               Str (Deg:2,SOut) ;     SOut := SOut     + ' ' ;
               If ( SOut [ 1 ] = ' ' )  Then
                 SOut [ 1 ] := '0' ;
               Str (Min:2,T) ;        SOut := SOut + T + ' ' ;
               Str (Sec:4:1,T) ;      SOut := SOut + T       ;
             End
           Else
             Begin
               Str (Deg:3,SOut) ;     SOut := SOut     + ' ' ;
               Str (Min:2,T) ;        SOut := SOut + T + ' ' ;
               Str (Round(Sec):2,T) ; SOut := SOut + T       ;
             End ;

         Write ( OutFile,  SOut ) ;


         If ( IndReg = 1 )
           Then  RadToGMS ( Dc , CNeg, Deg, Min, Sec )
           Else  RadToGMS ( B  , CNeg, Deg, Min, Sec ) ;


         If Round ( Sec*10 ) = 600 Then
            Begin
              Sec :=       0 ;
              Min := Min + 1 ;
              If Min = 60 Then
                 Begin
                   Min :=       0 ;
                   Deg := Deg + 1 ;
                 End ;
            End ;


         Str (Deg:2,SOut) ;       SOut := SOut     + ' ' ;
         Str (Min:2,T) ;          SOut := SOut + T + ' ' ;
         Str (Round(Sec):2,T) ;   SOut := SOut + T       ;
         If ( CNeg )
            Then SOut := '-' + SOut
            Else SOut := '+' + SOut ;

         Write ( OutFile, ' ', SOut, '  ' ) ;

       End ;

     Writeln ( OutFile ) ;
     Close   ( OutFile ) ;

   End ;  { ÇÎ¢Æ§ ¢ ‰†©´ Ê•≠‚p† Æ™≠† 'Glass' }

 End ;  { Not CalcVectDiagr }



If ( CalcVectDiagr )  Then
  Begin  { CalcVectDiagr }

    ScToId ( x, y, Nx, Ny ) ;

    Str  ( - Nx / XMax * Param.RRX : 6:3, S ) ;
    S := S + ' "/y' ;
    PutS ( gra_w.wnd, True, bc, fc, CenterText, CenterText, S ) ;

    Str  ( Ny / YMax * Param.RRY : 6:3, S ) ;
    S := S + ' "/y' ;
    PutS ( gdc_w.wnd, True, bc, fc, CenterText, CenterText, S ) ;

  End ;  { CalcVectDiagr }



End ;


Procedure ReportGs ( w, h : Double ) ; { í•™„È®© p†ß¨•p Æ™≠† }
                                       { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
Var
 S, T : String[20];
 w1   : Double ;
Begin


 If ( CalcVectDiagr )  Then
   Begin

     w1 := sw.x2 - sw.x1 ;

     Str  ( Param.RRX * 2 / GScale * ( w / w1 ) : 5 : 3 , S ) ;
     S := S + ' "/y' ;

   End ;



 If ( Not CalcVectDiagr )  Then
 Begin

  w1:=sw.x2-sw.x1+1;

  If ( (ParConst.Wg / GScale * ( w / w1 ) ) > 1 )
   Then
    Begin
      Str ((ParConst.Wg / GScale * ( w / w1 )):4:1,S) ;
      S:=S+Chr(243)+' x ';
    End
   Else
    Begin
     If ( (ParConst.Wg / GScale * ( w / w1 ) * 60 ) > 1 )
     Then
      Begin
        Str ((ParConst.Wg / GScale * ( w / w1 ) * 60 ):4:1,S) ;
        S:=S+Chr(244)+' x ';
      End
     Else
      Begin
        Str ((ParConst.Wg / GScale * ( w / w1 ) * 3600 ):4:2,S) ;
        S:=S+Chr(245)+' x ';
      End ;
    End ;


  w1 := ( sw.y2-sw.y1+1 ) / ( ( 1 + XAsp ) / YAsp ) ;

  If ( (ParConst.Hg / GScale * ( w / w1 ) ) > 1 )
   Then
    Begin
      Str ((ParConst.Hg / GScale * ( w / w1 )):4:1,T) ;
      S:=S+T+Chr(243) ;
    End
   Else
    Begin
     If ( (ParConst.Hg / GScale * ( w / w1 ) * 60 ) > 1 )
     Then
      Begin
        Str ((ParConst.Hg / GScale * ( w / w1 ) * 60 ):4:1,T) ;
        S:=S+T+Chr(244) ;
      End
     Else
      Begin
        Str ((ParConst.Hg / GScale * ( w / w1 ) * 3600 ):4:2,T) ;
        S:=S+T+Chr(245) ;
      End ;
    End ;

 End ; { Not CalkVectDiagr }

 PutS ( gsized_w.wnd, True, bc, fc, CenterText, CenterText, S ) ;

End ;



Procedure ReportFs; { í•™„È®© p†ß¨•p ØÆ´Ô ® ·Æß¢•ß§®• }
                    { ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ }
Var
 S , T    : String ;
 Ra, Dc   : Double ;
 Deg, Min : Integer;
 Sec      : Double ;
 CNeg     : Boolean;
 Ind      : Byte   ;

Begin

 With ParConst Do
 Begin

 If ( Not CalcVectDiagr )  Then
  If ( (ParConst.Wg / GScale ) > 1 )
   Then
    Begin
      Str ((ParConst.Wg / GScale ):4:1,S) ;
      S:=S+Chr(243)+'x';
    End
   Else
    Begin
     If ( (ParConst.Wg / GScale * 60 ) > 1 )
     Then
      Begin
        Str ((ParConst.Wg / GScale * 60 ):4:1,S) ;
        S:=S+Chr(244)+'x';
      End
     Else
      Begin
        Str ((ParConst.Wg / GScale * 3600 ):4:1,S) ;
        S:=S+Chr(245)+'x';
      End ;
    End ;


 If ( Not CalcVectDiagr )  Then
  If ( (ParConst.Hg / GScale  ) > 1 )
   Then
    Begin
      Str ((ParConst.Hg / GScale ):4:1,T) ;
      S:=S+T+Chr(243) ;
    End
   Else
    Begin
     If ( (ParConst.Hg / GScale * 60 ) > 1 )
     Then
      Begin
        Str ((ParConst.Hg / GScale * 60 ):4:1,T) ;
        S:=S+T+Chr(244) ;
      End
     Else
      Begin
        Str ((ParConst.Hg / GScale * 3600 ):4:1,T) ;
        S:=S+T+Chr(245) ;
      End ;
    End ;

 If ( CalcVectDiagr )  Then
   Begin

     Str  ( Param.RRX * 2 / GScale : 5 : 3 , S ) ;
     S := S + ' "/y' ;

   End ;

  PutS ( fw.wnd, True, bc, fc, CenterText, CenterText, S ) ;

 If ( GScale > 1.000001 )
   Then
     Begin
       Ra := RaOptGlass   ;
       Dc := DeclOptGlass ;
       PreNew ( JDateFld , JDOut , Ra, Dc ) ;
     End
   Else
     Begin

       If ( B_Gal )
         Then
           Begin
             Ra := RaOptGal   ;
             Dc := DeclOptGal ;
           End
         Else
           Begin
             Ra := RaOpt   ;
             Dc := DeclOpt ;
             PreNew ( JDateFld , JDOut , Ra, Dc ) ;
           End ;

     End ;

 Identify ( JDOut, Ra, Dc,  S ) ;
 PutS ( pxw.wnd, True, bc, fc, CenterText, CenterText, S ) ;

 FileMode := 2 ;


 End ;

End;


End.