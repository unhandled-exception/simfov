{$F+,O+}

Unit PMenu ;

Interface

Uses
 Graph, Crt, MDef, GLib, MLib, PVar, Screen ;

Function Menu ( MenuDesc   : MenuDescType ;
                MenuAttr   : MenuAttrType ;
                MenuItems  : Byte         ;
                Trace      : TraceType    ;
                CHelp      : CHelpType    ;
                Var Item   : MenuType     ;
                Var EscHit : Boolean        )    : Byte ;

Implementation

Function Menu ( MenuDesc   : MenuDescType ;
                MenuAttr   : MenuAttrType ;
                MenuItems  : Byte         ;
                Trace      : TraceType;
                CHelp      : CHelpType    ;
                Var Item   : MenuType     ;
                Var EscHit : Boolean        )    : Byte ;

Const

 { Action upon keyboard or other input }

 None     = 0 ;
 NewItem  = 1 ;
 NewPage  = 2 ;
 PickItem = 3 ;
 EscExit  = 4 ;

Var
 UserProc             : ProceduralType ;
 CurrentTrace         : TraceProcType  ;
 NoTrace              : TraceType      ;
 CRow,CCol,CPage      : Integer        ;
 NRow,NCol,NPage      : Integer        ;
 MaxItemLength        : Byte           ;
 NumberOfRows         ,
 NumberOfCols         ,
 NumberOfPages        : Byte           ;
 LRows,LCols          : Byte           ;
 RowsOnPage,
 ColsOnRow            : Byte           ;
 LastPageItems        : Byte           ;
 LastPageFull,
 Last                 : Boolean        ;
 Ind,I                : Integer        ;
 HorMenu              : Boolean        ;
 FChar                : String [ 80 ]  ;
 PosInFc              : Byte           ;
 PItemNumber,
 ItemNumber           : Byte           ;
 Ch                   : Char           ;
 FunctionKey          : Boolean        ;
 Picked               : Boolean        ;
 Action               : Byte           ;
 ExitMenu             : Boolean        ;
 Step                 : Byte           ;
 Left                 : Byte           ;
 SSN                  : Byte           ;


Procedure WriteMenuItem ( Row,Col : Integer; S : String; Active : Boolean );
Var
 Ind   : Byte;
 CAttr : Byte;
 CCol  : Byte;
 Ts    : TextSettingsType;
Begin

 GetTextSettings(Ts);
 SetTextJustify(LeftText,CenterText);
 { Write First Letter }

 With MenuAttr Do
 If Active
 Then CAttr := ABackC * 16 + FLFore
 Else CAttr := FLBack * 16 + FLFore;
 Clear ( Left + Step + ( Col - 1 ) * ( MaxItemLength + Step ),Row,1,CAttr);
 CCol:=GetColor; SetColor((CAttr Shl 4) Shr 4 );
 WriteS( Left + Step + ( Col - 1 ) * ( MaxItemLength + Step ),Row,Copy(S,1,1));
 { Write String }
 With MenuAttr Do
 If Active
 Then CAttr:= ABackC * 16 + AForeC
 Else CAttr:=  BackC * 16 +  ForeC;
 Clear ( Left + Step + ( Col - 1 ) * ( MaxItemLength + Step ) + 1,Row,Length(S)-1,CAttr);
 SetColor((CAttr Shl 4) Shr 4 );
 WriteS( Left + Step + ( Col - 1 ) * ( MaxItemLength + Step ) + 1,Row,Copy(S,2,Length(S)-1));
 With Ts Do
 SetTextJustify(Horiz,Vert);
 SetColor(CCol);
End; { WriteMenuItem }

Procedure WriteMenuPage(PageNumber : Byte );
Var
 Row,Col   : Byte;
 Active    : Boolean;
 Ind       : Integer;
 Rows,Cols : Byte;
Begin

 With MenuDesc,MenuAttr Do
  MWindow(ulx + 1,uly + 1,lrx - 1, lry - 1, BackC, True );

 FChar:='';
 If Last Then Rows:=LRows Else Rows:=NumberOfRows;
 For Row:=1 To Rows Do
 Begin
 If Last And ( Row = Rows ) Then Cols:=LCols Else Cols:=NumberOfCols;
 For Col:=1 To Cols Do
  Begin

   Active:= ( Row = 1 ) And ( Col = 1 );
   Ind   := ( PageNumber - 1 ) * NumberOfRows * NumberOfCols
                               +  ( Row - 1 ) * NumberOfCols
                               +    Col ;
   FChar:=FChar + Item[Ind]^.TextString[1];
   WriteMenuItem(Row,Col,Item[Ind]^.TextString,Active);
  End;
 End;
End; { WriteMenuPage }

Begin

 EscHit:=False;
 { Set NoTrace record }
 NoTrace.Required:=False;

 { Save current window parameters }
 Inc(Level);
 With MenuDesc,MenuAttr Do
 Begin
  UpperLeft [Level] :=uly * 256 + ulx;
  LowerRight[Level] :=lry * 256 + lrx;
  PAttr     [Level] :=BackC * 16 + BoxC;
  PType     [Level] :=BoxT;
 End;

 { Define menu window, store it's contents And draw box }
 With MenuDesc,MenuAttr Do
 Begin
  MWindow(1,1,COLS[CFont],ROWS[CFont],0, False);
  If ( Level > 2 ) Then Store(Level);
  MenuBox(ulx,uly,lrx,lry,Boxt,BackC,BoxC,True);
  If Con Then   ConnectBoxes(True,Level);
 End;
 { Connect boxes }


  With MenuDesc,MenuAttr Do
   MWindow(ulx+1,uly+1,lrx-1,lry-1,BackC, True);

 { Define MaxItemLength }

 MaxItemLength:=0;
 For Ind:=1 To MenuItems Do
 Begin
 { set And show }
 If ( Item[Ind]^.Activity = mn_ssh )
 Then
  Begin
  If ( Item[Ind]^.SShVar^ )
  Then Item[Ind]^.TextString:=Item[Ind]^.TextString+'+'
  Else Item[Ind]^.TextString:=Item[Ind]^.TextString+'-';
  End;
 If Length(Item[Ind]^.TextString) > MaxItemLength
 Then MaxItemLength:=Length(Item[Ind]^.TextString);
 End;

 { Align Items And get first chars }
 For Ind:=1 To MenuItems Do
  With Item[Ind]^ Do
  Begin
   For I:=Length(TextString) + 1 To MaxItemLength Do
   TextString:=TextString + ' ';
  End;

 Step:=1;
 { Define number Of rows,columns And pages }
 With MenuDesc Do
 Begin
  If ( MenuItems * ( MaxItemLength + Step ) < ( lrx - ulx - 1 - Step ) )
  Then
   NumberOfCols := MenuItems
  Else
   NumberOfCols := ( ( lrx - ulx - 1 - Step ) Div ( MaxItemLength + Step ) );
  Step:= ( lrx - ulx - 3 - NumberOfCols * MaxItemLength ) Div ( NumberOfCols + 1 );
  Left:= ( lrx - ulx - Step - NumberOfCols * ( MaxItemLength+Step) ) Div 2;
  HorMenu      := ( lry - uly = 2 );
  If ( HorMenu )
  Then
    NumberOfRows:=1
  Else
    If ( MenuItems <= ( lry - uly - 1 ) )
    Then
     NumberOfRows:= MenuItems
    Else
     NumberOfRows:= ( lry - uly - 1 );

   NumberOfPages:= ( MenuItems Div ( NumberOfRows * NumberOfCols ) );
   LastPageItems:= MenuItems Mod ( NumberOfRows * NumberOfCols );
   If ( LastPageItems <> 0 )
   Then
    Begin
     LastPageFull:=False;Inc(NumberOfPages);
     LRows:= LastPageItems Div NumberOfCols;
     LCols:= LastPageItems - LRows * NumberOfCols;
     Inc(LRows);
    End
   Else
    LastPageFull:=True;
 End;

 { Store inf on menu type }
 PHor[Level]:=HorMenu;

 { Draw first page }
 Last:= ( Not LastPageFull ) And ( NumberOfPages = 1 );
 WriteMenuPage(1);

 CPage := 1 ;
 CRow  := 1 ;
 CCol  := 1 ;

 ExitMenu:=False;
 If ( CHelp.Present )  Then
   CHelp.Proc ( Item[1]^.Helptext ) ;

 Repeat   { Main Menu Loop }

  ExitMenu := False ;
  Picked   := False ;

  Repeat

  If ( HorMenu )
  Then
   PItem[Level]:= Step + ( CCol - 1 ) * ( MaxItemLength + Step )
                + MaxItemLength Div 2
  Else
   PItem[Level]:= CRow;

  ItemNumber:= ( CPage - 1 ) * NumberOfCols * NumberOfRows
             + ( CRow  - 1 ) * NumberOfCols
             +   CCol;

  NPage:=CPage;NRow:=CRow;NCol:=CCol;
  Last := ( Not LastPageFull ) And ( CPage = NumberOfPages );
  If Last
  Then
   Begin
    RowsOnPage:=LRows;
    If ( CRow = LRows ) Then ColsOnRow:= LCols Else ColsOnRow:=NumberOfCols;
   End
  Else
   Begin
    RowsOnPage := NumberOfRows ;
    ColsOnRow  := NumberOfCols ;
   End;

    { Get key from keyboard or Keys-string }

    If (     ( Level   = 3         )
         And ( UserKey = UserGlass )  )
      Then
        Begin
          UserKey := Null ;
          Ch      := F4   ;
        End
      Else
          Ch := GetCh ;

    Case Ch Of

      LEFTKEY     : If ( ColsOnRow > 1 )
	            Then
                     Begin
			 Action := NewItem;
                         NCol := Mmod(CCol-1,ColsOnRow);
                     End
                    Else
                     Action := None;

      RIGHTKEY    : If ( ColsOnRow > 1)
                    Then
                     Begin
	  		 Action := NewItem;
                         NCol := Mmod(CCol+1,ColsOnRow);
                     End
                    Else
		     Action := None;

      UPKEY       : If ( RowsOnPage > 1)
                    Then
                     Begin
		 	 Action := NewItem;
		         NRow := Mmod(CRow-1,RowsOnPage);
                     End
                    Else
		     Action := None;

      DOWNKEY     : If ( RowsOnPage > 1 )
		    Then
                     Begin
		       Action := NewItem;
		       NRow   := Mmod ( CRow+1, RowsOnPage );
                     End
                    Else
		       Action := None;

      HOMEKEY     : Begin
                      Action := NewItem;
		      NRow := 1;
                      NCol := 1;
                    End;

      ENDKEY      : Begin
                      Action := NewItem;
		      NRow   := RowsOnPage ;
                      If ( Last )
                        Then NCol := LCols
                        Else NCol := ColsOnRow ;
		    End;

      PGUPKEY     : If ( NumberOfPages <> 1 )
                    Then
                     Begin
		       Action := NewPage;
		       NPage  := Mmod ( CPage-1, NumberOfPages );
                     End
                    Else
                       Action := None;

      PGDNKEY     : If ( NumberOfPages <> 1 )
                      Then
                        Begin
		          Action := NewPage;
		          NPage  := Mmod(CPage+1,NumberOfPages);
                        End
                      Else
                          Action := None;

      F1          :  Begin
                       Help ;
                     End ;

      F4          :  Begin
                       If ( Level = 2 )  Then
                         Begin
                           UserKey := UserGlass ;
                           Keys := Keys + HomeKey + DownKey + CrKey ;
                         End ;
                       If ( Level = 3 )  Then
                         Begin
                           UserKey := Null ;
                           Keys := Keys + HomeKey ;
                           If ( ( Abs ( GScale ) - C10 ) < 0.1e-6 )
                             Then  Keys := Keys + CrKey ;
                         End ;
                     End  ;

       CRKEY      : Begin

                     SSN:= ( NPage - 1 ) * NumberOfCols * NumberOfRows
                         + ( NRow  - 1 ) * NumberOfCols + NCol;

                     If ( Item[SSN]^.Activity = mn_ssh )
                       Then
                         Begin

                           Item [ SSN ]^.SShVar^ :=
                              Not Item [ SSN ]^.SShVar^ ;

                           If ( Item[SSN]^.SShVar^ )
                             Then
                               Item [ SSN ]^.
                                 TextString [
                                   Length ( Item [ SSn ]^.TextString )
                                            ] := '+'
                             Else
                               Item [ SSN ]^.
                                 TextString [
                                   Length ( Item [ SSN ]^.TextString)
                                            ] := '-';
                           Action := NewItem ;
                           NRow   := CRow    ;
                           NCol   := CCol    ;
                         End
                     Else
                       Begin
                         Action := PickItem ;
                         Picked := True     ;
                       End;

                    End;

       ESCKEY     : Begin
                     Action := EscExit;
                     EscHit := True;
                     Picked := True;
                    End;

   Else
    Begin
     { Ordinary Key }
       Ch := ToUpper ( Ch );
       PosInFc := Pos(Ch,FChar);
       If ( PosInFc <> 0 )
       Then
        Begin
         { First Letter Of Some Item on current page }
         Action:=NewItem;
         If ( NumberOfCols=1 )
         Then
          NRow := PosInFc
         Else
          NRow := ( PosInFc Div NumberOfCols ) + 1;
         NCol  := ( PosInFc - ( NRow - 1 ) * NumberOfCols );
         NPage :=   CPage;
         UnGetCh ( CRKEY );
        End
     End;
   End; { Case }

  If ( HorMenu )
  Then
   PItem[Level]:= Step + ( NCol - 1 ) * ( MaxItemLength + Step )
                + MaxItemLength Div 2
  Else
   PItem[Level]:= NRow;

  Last := ( Not LastPageFull ) And ( NPage = NumberOfPages );
  If Last
  Then
   Begin
    RowsOnPage:=LRows;
    If ( NRow = LRows ) Then ColsOnRow:= LCols Else ColsOnRow:=NumberOfCols;
   End
  Else
   Begin
    RowsOnPage:=NumberOfRows;ColsOnRow:=NumberOfCols;
   End;

  { Action }
   Case Action Of
    None        : ;

    NewItem     : Begin
                   WriteMenuItem(CRow,CCol,Item[ItemNumber]^.TextString,False);
                   PItemNumber:=ItemNumber;
                   ItemNumber:= ( NPage - 1 ) * NumberOfCols * NumberOfRows
                              + ( NRow  - 1 ) * NumberOfCols
                              +   NCol;
                   WriteMenuItem(NRow,NCol,Item[ItemNumber]^.TextString,True);
                   CPage := NPage ;
                   CCol  := NCol  ;
                   CRow  := NRow  ;
                  End;

   NewPage      : Begin
                   WriteMenuPage(NPage);
                   CRow   := 1     ;
                   CCol   := 1     ;
                   CPage  := NPage ;
                  End;

   EscExit      : Begin
                   Picked   := True ;
                   ExitMenu := True ;
                  End;

  End; { Case }

  { Help }
  If ( ( Action <> None ) And CHelp.Present )  Then
    CHelp.Proc ( Item [ ItemNumber ]^.HelpText );

  If (     ( Action = NewItem )
       And ( Trace.Required   ) )  Then
    Trace.Proc.Name(Trace.Proc.L1,Trace.Proc.L2,PItemNumber,ItemNumber);

 Until Picked;

 If ( Not ExitMenu )
 Then
 Begin

  Case Item[ItemNumber]^.Activity Of
  mn_exe  : Begin
             UserProc:=Item[ItemNumber]^.Proc;
             UserProc;
            End;
  mn_ext  : Begin
             UserProc:=Item[ItemNumber]^.EProc;
             UserProc; ExitMenu:=True;
            End;
  mn_ret  : Begin
             Menu:=ItemNumber;
             ExitMenu:=True;
            End;
  mn_set  : Begin
             With Item[ItemNumber]^.SetVar Do
             Variable^:=Value;
             ExitMenu:=True;
            End;
  End;
 End;

Until ExitMenu;

Menu:=ItemNumber;
{ Erase Current Menu }
 With MenuDesc Do
 Begin
  MWindow(ulx+1,uly+1,lrx-1,lry-1, MenuAttr.BackC, True);
  If ( Level > 2 ) Then
  Begin
   MWindow(1,1,COLS[CFont],ROWS[CFont],0,False);
   If ( Con ) Then ConnectBoxes(False,Level);
   Restore(Level);
  End;
  If ( Level > 1 )
  Then
   Begin
    Dec(Level);
    TextAttr:=PAttr[Level];
    If (     ( LowerRight [ Level ] >   0 )
         And ( LowerRight [ Level ] < 255 )
         And ( UpperLeft  [ Level ] >   0 )
         And ( UpperLeft  [ Level ] < 255 )  )    Then
      MWindow ( Lo ( UpperLeft  [ Level ] ) + 1,
                Hi ( UpperLeft  [ Level ] ) + 1,
                Lo ( LowerRight [ Level ] ) - 1,
                Hi ( LowerRight [ Level ] ) - 1,
                MenuAttr.BackC, False ) ;
   End
  Else
   Begin
     MWindow(1,1,COLS[CFont],ROWS[CFont],Black,True);
   End;
 End;
End; { Menu }

End.
