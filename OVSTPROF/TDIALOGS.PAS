{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿ }
{ ³                                                           ³ }
{ ³                 OVSoft Text Professional.                 ³ }
{ ³                                                           ³ }
{ ³             ª¥â ¯p®£p ¬¬ ¯p¥¤­ §­ ç¥­­ë© ¤«ï             ³ }
{ ³           á®§¤ ­¨ï ¨­â¥pä¥©á  á ¯®«ì§®¢ â¥«¥¬.            ³ }
{ ³                                                           ³ }
{ ³                      ‚¥àá¨ï  2.0                          ³ }
{ ³                                                           ³ }
{ ³                  Copyright (c) 1992 by                    ³ }
{ ³                                                           ³ }
{ ³                 Oleg Volchkov Software.                   ³ }
{ ³                                                           ³ }
{ ³                   All right reserved.                     ³ }
{ ³                                                           ³ }
{ ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ }
{ ³                                                           ³ }
{ ³               IBM   PC XT, PC AT 286/386.                 ³ }
{ ³              Œ®­¨â®pë  EGA, VGA, Hercules.                ³ }
{ ³                                                           ³ }
{ ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ }
{ ³                                                           ³ }
{ ³                    Œ®¤ã«ì TDialogs.                       ³ }
{ ³                                                           ³ }
{ ³      à®æ¥¤ãàë ¨ äã­ªæ¨¨ ¤«ï à ¡®âë á ®ª­ ¬¨ ¤¨ «®£ .     ³ }
{ ³                                                           ³ }
{ ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ }
{ ³                                                           ³ }
{ ³                     Turbo  Pascal                         ³ }
{ ³                      Version 6.0                          ³ }
{ ³                Copyright (c) 1983,90 by                   ³ }
{ ³               Borland International, Inc                  ³ }
{ ³                                                           ³ }
{ ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ }

{$F+,O+,R-}

Unit TDialogs;

Interface

Uses Crt, TUtil, TDrivers,
     TStdObj, TColors;

Const


  { ‘â ­¤ àâ­ë¥ ª®­áâ ­âë ¤¨ «®£ . }
  { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

    MaxDialogItems  = 70 ;
    MaxRadioButtons = 40 ;
    MaxCheckBoxes   = 40 ;

  { ‘â ­¤ àâ­ë¥ í«¥¬¥­âë ¤¨ «®£ . }
  { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }


    DInputLine   = 1000 ;
    DCheckBoxes  = 1100 ;
    DRadioButton = 1200 ;
    DButton      = 1300 ;

  { ‚ëà ¢­¨¢ ­¨¥ ®ª®­. }
  { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

    jcNormal   = 1000 ;

    jcCentered = 1  ;
    jcRight    = 2  ;
    jcLeft     = 4  ;
    jcUp       = 8  ;
    jcDn       = 16 ;

    jcLeftUp   = jcLeft or jcUp ;
    jcLeftDn   = jcLeft or jcDn ;
    jcRightUp  = jcRight or jcUp ;
    jcRightDn  = jcRight or jcDn ;

  { ‘â ­¤ àâ­ë¥ äã­ªæ¨¨ íªà ­­ëå ª­®¯®ª. }
  { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

    bfDefault   = 3000 ;
    bfNormal    = 3100 ;
    bfRightJust = 3200 ;
    bfLeftJust  = 3300 ;

   { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

    InsFlag : Boolean = True;

Type

 { ˆ¬ï ¬¥âª¨. }
 { ÄÄÄÄÄÄÄÄÄÄ }

   LString      =  String[ 78 ] ;
  TDWString    =  String[ 40 ] ;



 { ƒ« ¢­ë© ®¡ê¥ªâ ¤«ï í«¥¬¥­â®¢ ¤¨ «®£ . }
 { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

   PView        = ^TView;
   TView        = Object

      ObjType              : Word   ;

      TitleFlag            : Byte    ;
      TitleRect            : TRect   ;
      TitleString          : LString ;

      procedure InitLabel( R : Trect; LText : LString );
      procedure Draw ; virtual;
      procedure Run  ; virtual;
      procedure NewSItem( LString : String );Virtual;
      procedure GetData( var GData : pointer; var Size : byte );  virtual;
      procedure SetData( Var SData );  virtual;
      function  GetSize : Byte ; virtual;
      destructor Done; virtual;
    End;


 { ‘âà®ª  ¢¢®¤ . }
 { ÄÄÄÄÄÄÄÄÄÄÄÄÄ }

   PInputLine   = ^TInputLine;
   TInputLine   = Object ( TView )

      InputLineCoords      : TRect   ;
      InputLineLength      : Byte    ;
      InputLineString      : ^String  ;

      CharNum              : Byte    ;
      CoordNum             : Byte    ;
      Status               : Byte    ;

      constructor Init( R : TRect; SLength : byte  );
      destructor Done;virtual;
      procedure Draw ; virtual;
      procedure NewDraw;
      procedure Run  ; virtual;
      procedure SetData( Var SData );  virtual;
      procedure GetData( var GData  : pointer; var Size : byte );  virtual;
      function  GetSize : Byte ; virtual;

     End; { TinputLine }


  { ‡ ¢¨á¨¬ë¥ ª­®¯ª¨. }
  { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

   RBItems       =  Record

      ItemsString : String ;
      ItemsX ,
      ItemsY      : Byte   ;

     End; { RBItems }


   PRadioButton  = ^TRadioButton ;
   TRadioButton  =  Object ( TView )

      TRBCoord     : TRect      ;

      ButtonsNum   : Byte       ;
      ButtonsItem  : Byte       ;
      MaxLength    : Word       ;

      RadioButtons : Array [ 1 .. MaxRadioButtons ] of ^RBItems;

      constructor Init( R : TRect );
      destructor Done;virtual;
      procedure NewSItem( LString : String );virtual;
      procedure Draw; virtual;
      procedure Run ; virtual;
      procedure GetData( var GData  : pointer; var Size : byte );  virtual;
      procedure SetData( Var SData );  virtual;


     End;{ TRadioButton }


  { H¥§ ¢¨á¨¬ë¥ ª­®¯ª¨. }
  { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

   CBItems       =  Record

      ItemsString : String ;
      ItemsX ,
      ItemsY      : Byte   ;
      ItemsStatus : Byte   ;

     End; { CBItems }


   PCheckBoxes  =  ^TCheckBoxes ;
   TCheckBoxes  =  Object ( TView )

      TCBCoord     : TRect      ;

      ButtonsNum   : Byte       ;
      ButtonsItem  : Byte       ;
      MaxLength    : Word       ;

      CBData       : Word       ;

      CheckBoxes : Array [ 1 .. MaxCheckBoxes ] of ^CBItems;

      constructor Init( R : TRect );
      destructor Done;virtual;
      procedure NewSItem( LString : String );virtual;
      procedure Draw; virtual;
      procedure Run ; virtual;
      procedure GetData( var GData : pointer; var Size : byte );  virtual;
      procedure SetData( Var SData );  virtual;


     End;{ TCheckBoxes }

  { ªp ­­ë¥ ª­®¯ª¨. }
  { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

    PButton = ^TButton;
    TButton = Object ( TView )


      TBCoord       :  TRect    ;
      ButtonString  :  String   ;

      BSX           :  Word     ;

      ItemsEvent    :  Word     ;
      ItemsCommand  :  Word     ;

      BFlag         :  Boolean  ;

      constructor Init( R : TRect; BString : String; IEvent, ICommand : Word );
      destructor Done; virtual;
      procedure Draw ; virtual;
      procedure Run  ; virtual;

    End;

  { ‘â â¨ç¥áª¨© â¥ªáâ. }
  { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

  PStaticText = ^TStaticText ;
  TStaticText = Object( TView )

      TSTR             : TRect  ;

      StaticTextString : String ;

      STAttr             : byte;

      constructor Init( R : TRect; STString : String );
      destructor Done; virtual;
      procedure Draw; virtual;
      procedure Run ; virtual;

  end; 


  { á­®¢­®© ®¡ê¥ªâ ¤«ï à ¡®âë á ®ª­ ¬¨ ¤¨ «®£ . }
  { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

   PDialog = ^TDialog;
   TDialog = Object

         DWCoord            : TRect ;     { Š®®p¤¨­ âë ®ª­     }

         Options            : Word  ;     { ‚ëp ¢­¨¢ ­¨¥ ®ª­ . }

         WindowTitle        : TDWString;  { ‡ £®«®¢®ª ®ª­ .    }

         DialogItemsNum     : Word  ;     { Š®«¨ç¥áâ¢® í«¥¬¥­â®¢ ¤¨ «®£ . }
         NumDialogSelect    : Word  ;     { ’¥ªãé¨© í«¥¬¥­â ¤¨ «®£ .       }

         ItemsType          : Word  ;

         DialogItems        : Array [ 1 .. MaxDialogItems ] of PView ;

        { “áâ ­®¢ª  ¯ p ¬¥âp®¢ ®ª­ . }
        { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

         constructor Init( R : TRect; DWTitle : TDWString; WOptions : Word );

        { „®¡ ¢«¥­¨¥ í«¥¬¥â ¤¨ «®£ . }
        { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

         procedure Insert( DItems : PView );

        { ®áâp®¥­¨¥ ®ª­  á í«¥¬¥­â¢¬¨ ¤¨ «®£ . }
        { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

         procedure Draw ;
         procedure StatusLine( SStr : String );
         procedure PutOptions( OStr : String );


        { “­¨çâ®¦¥­¨¥ ®ª­ . }
        { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

         destructor Done;

        {  ¡®â  á ®ª­®¬ ¤¨ «®£ . }
        { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

         function Run : Word;

        { ®«ãç¥­¨¥ ¤ ­­ëå ¨§ ®ª­ . }
        { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

         procedure GetData( Var DData );

         procedure SetData( Var SData );  virtual;


     End;

Implementation
Var

  DialogKey  : Word ;
  DialogItem : Word ;
  DWNum      : Word;

{ à®æ¥¤ãàë ¨ äã­ªæ¨¨ ®¡ê¥ªâ  TView }
{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

procedure TView.Draw;
Begin
End;{ Draw }

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }
Procedure TView.InitLabel( R : TRect; LText : LString );
Begin

 TitleFlag     :=  Yes   ;
 TitleRect     :=  R     ;
 TitleString   :=  LText ;

End;{ InitLable }

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

procedure TView.Run;
Begin
End;{ Run }

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

procedure TView.GetData( var GData : pointer ; var Size : byte );
Begin
End;{ TView.GetData }

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

procedure TView.SetData( Var SData );
Begin
End;{ TView.SetData }

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

procedure TView.NewSItem( LString : String );
Begin
End;{ TView. NewSItem }


destructor TView.Done;
Begin
End;{ Done }


{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

function TView.GetSize : Byte ;
Begin

 GetSize := 0;

End;{ TView. NewSItem }

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }


{ à®æ¥¤ãàë ¨ äã­ªæ¨¨ ®¡ê¥ªâ  TInputLine. }
{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

constructor TInputLine.Init( R : TRect; SLength : byte );
Var i : byte;
Begin

   ObjType           := DInputLine   ;

   CharNum           :=  1 ;
   CoordNum          :=  1 ;
   Status            :=  0 ;

   InputLineCoords   :=  R ;
   InputLineLength   :=  SLength ;

   InsFlag := True;

   GetMem( InputLineString , InputLineLength );

   FillChar( InputLineString^, InputLineLength , ' ');
   InputLineString^[ 0 ] := #0;

   TitleFlag  := No;

End; { Init }


{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

procedure TInputLine.NewDraw;
Begin

 If TitleFlag = Yes Then
   ColorPut( TitleRect.A.X , TitleRect.A.Y, TitleString,
             TLableAccentText,  TLableAccentAcText );

   With InputLineCoords do
    Begin

     WriteChar( A.X, A.Y, B.X - A.X ,' ',InputLineNormalText);

      if ( B.X - A.X - 2 ) <= Length ( InputLineString^ ) then
        ParamPut( A.X + 1, A.Y, InputLineString^, 1, B.X - A.X - 2 ,
                                                       InputLineNormalText)
        else
          ParamPut( A.X +1 , A.Y, InputLineString^, 1, Length (InputLineString^) ,
                                                       InputLineNormalText);

     if ( Length( InputLineString^ ) > 0 )
      and ( Length( InputLineString^ )  >  B.X - A.X - 2)
       and ( InputLineLength >  B.X - A.X - 2 ) then
        WriteChar( B.X-1, A.Y, 1, #16, InputLineOptionText )

    End;{ With }

End;{ NewDraw }

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

procedure TInputLine.Draw;
Begin

   If TitleFlag = Yes Then
    ColorPut( TitleRect.A.X , TitleRect.A.Y, TitleString,
                              TLableNormalText,  TLableNormalAcText );

   With InputLineCoords do
    Begin

     WriteChar( A.X, A.Y, B.X - A.X ,' ',InputLineNormalText);

      if ( B.X - A.X - 2 ) <= Length ( InputLineString^ ) then
        ParamPut( A.X + 1, A.Y, InputLineString^, 1, B.X - A.X - 2 ,
                                                       InputLineNormalText)
        else
          ParamPut( A.X +1 , A.Y, InputLineString^, 1, Length (InputLineString^) ,
                                                       InputLineNormalText);

     if ( Length( InputLineString^ ) > 0 )
      and ( Length( InputLineString^ )  >  B.X - A.X - 2)
       and ( InputLineLength >  B.X - A.X - 2 ) then
        WriteChar( B.X-1, A.Y, 1, #16, InputLineOptionText )

    End;{ With }

End;{ NewDraw }

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

procedure TInputLine.Run;
var
    i,k,n,x : Byte;
    c1 : Word;
Begin

 if Not InsFlag  Then
  BlockCursor
   else
    NormalCursor;

 NewDraw;
{ If TitleFlag = Yes Then
   ColorPut( TitleRect.A.X , TitleRect.A.Y, TitleString,
             TLableAccentText,  TLableAccentAcText );
 }

With InputLineCoords do
 Begin

 i := 1;
 k := 1;
 n := 0;
 x := 1;

 if ( B.X - A.X - 2 ) <= Length ( InputLineString ^) then
  ParamPut(A.X+1,A.Y,InputLineString^,1,B.X - A.X - 2 ,
                                                    InputLineSelectText)
  else
   ParamPut(A.X+1,A.Y,InputLineString^,1,Length (InputLineString^) ,
                                                     InputLineSelectText);

 GotoXY(A.X + i,A.Y);

 if length( InputLineString ^) >= 0 then
  c1 := GetKey ;
  case c1 of
   kbEnter : Begin
              HiddenCursor;
              DialogKey := kbEnter;
              Exit;
             End;

   kbEsc   : Begin
              HiddenCursor;
              DialogKey := kbEsc;
              Exit;
             End;

   kbTab,
   kbDn   : Begin

              Draw;
              HiddenCursor;
              DialogKey := kbTab ;
              Exit;

             End;

   127,8 : Begin
              i := 2 ;
              Draw;
           End;

   kbHome : NewDraw;

   kbEnd : begin

             i := Length(InputLineString^)+1;

             if i >= ( B.X - A.X - 2 ) then
               k := i - ( B.X - A.X - 2 )
                else k := 1;
                  WriteChar( A.X , A.Y, B.X - A.X,' ',InputLineNormalText );

             if ( B.X - A.X - 2 ) < Length ( InputLineString^ ) then
              Begin

                ParamPut(A.X+1,A.Y,InputLineString^, k, i-1,
                                                      InputLineNormalText);
                GotoXY( B.X - 1, A.Y);

              End
               else
                Begin

                  ParamPut(A.X+1,A.Y,InputLineString^, k, i-1,
                                                      InputLineNormalText);
                  GotoXY( A.X + i - k + 1 , A.Y );
                End;
          END;

  kbShiftTab,
  kbUp     : Begin

               Draw;
               HiddenCursor;;
               DialogKey := kbShiftTab ;
               Exit;

             End; { kbShiftTab }
  kbRight ,
  kbLeft : Begin
             if Length( InputLineString^ ) > 0 Then
               Begin
                 if c1 = kbRight then
                   i := 2 ;
                 NewDraw;
              {   If TitleFlag = Yes Then
                   ColorPut( TitleRect.A.X , TitleRect.A.Y, TitleString,
                              TLableAccentText,  TLableAccentAcText );
               }
               End;
           End;

   kbIns  : begin

              if InsFlag  Then
                begin
                  InsFlag := False;
                  BlockCursor;
                end
                  else
                    begin
                      InsFlag := True;
                      NormalCursor;
                    end;

              NewDraw;

            end;

 kbDel : Begin
           InputLineString^  := '';
           NewDraw;
         end;

   Else
    Begin
     InputLineString^  := '';

     If C1 < 2700 Then
      If Length( InputLineString^ ) = 0 Then
       begin

        InputLineString^ :=  InputLineString^ + Chr( c1 );
        i := i + 1;

       end;

     NewDraw;

    End;{ case c1 of ... else }
   End;{ case c1 }

 GotoXY(A.X + i,A.Y);

{ If TitleFlag = Yes Then
  ColorPut( TitleRect.A.X , TitleRect.A.Y, TitleString,
     TLableAccentText,  TLableAccentAcText );
 }

 { NewDraw;
  }

   if ( Length( InputLineString^ ) > 0 )
    and (( Length( InputLineString^ ) - k )  >  B.X - A.X - 2)
     and ( InputLineLength >  B.X - A.X - 2 )
      then
       WriteChar( B.X-1, A.Y, 1, #16, InputLineOptionText )
        else
         WriteChar( B.X-1 , A.Y, 1, ' ' , InputLineOptionText ) ;

   if ( k > 1 ) and ( InputLineLength >  B.X - A.X - 2 ) then
     WriteChar( A.X, A.Y, 1, #17, InputLineOptionText )
      else
       WriteChar( A.X , A.Y, 1, ' ' , InputLineOptionText ) ;

 While n < 1 do
  Begin

    c1 := GetKey;

    case c1 of
      kbEnter : Begin
                 HiddenCursor;;
                 DialogKey := kbEnter;
                 Exit;
                End;
      kbEsc   : Begin
                 HiddenCursor;;
                 DialogKey := kbEsc;
                 Exit;
                End;

      kbTab,
      kbDn   : Begin

                 Draw;
                 HiddenCursor;;
                 DialogKey := kbTab ;
                 Exit;

                End;


      127,8 : if i > 1 then
                Begin

                 Delete( InputLineString^, i - 1, 1);

                 {if i = k + 1 then k := k - 1;
                  }

                 If K > 1 Then
                   begin
                     k := k - 1;
                   end;

                 if i = 1 then
                  GotoXY(A.X + 1, A.Y );

                 if k + B.X - A.X - 2  <= Length(InputLineString^) then
                  x := k + B.X - A.X - 2
                   else
                     x := Length( InputLineString^ )  ;


                  if k <= 0 Then k := 1;

                  If k = i Then
                   begin

                    k := k - 2;
                    x := x - 2;

                   end;

                  WriteChar(A.X,A.Y,B.X - A.X,' ',InputLineNormalText);
                  ParamPut(A.X + 1 , A.Y, InputLineString^, k , x,InputLineNormalText );

                 i := i - 1;

                 GotoXY( A.X + i - k + 1, A.Y);


                End
                 else
                   Begin
                    GotoXY ( A.X + 1, A.Y );
                   End;


     kbShiftTab,
     kbUp      : Begin

                         Draw;
                         HiddenCursor;
                         DialogKey := kbShiftTab ;
                         Exit;

                        End; { kbShiftTab }

            kbIns  : begin

                      if InsFlag  Then
                       begin
                        InsFlag := False;
                        BlockCursor;
                       end
                       else
                        begin
                         InsFlag := True;
                         NormalCursor;
                        end;

                     end;
            kbDel  : if ( i <= length ( InputLineString^ )) Then
                        Begin

                       Delete( InputLineString^, i, 1);


                       x := i;

                       if k + B.X - A.X - 2  < Length(InputLineString^) then
                        x := k + B.X - A.X - 2
                         else
                          x := Length( InputLineString^ )  ;


                       if k <= 0 Then k := 1;


                       WriteChar(A.X,A.Y,B.X-A.X,' ',InputLineNormalText);
                       ParamPut(A.X + 1 , A.Y, InputLineString^, k , x,InputLineNormalText );


                      End;

            kbLeft : Begin

                       if i > 1 then
                        Begin


                       if i = k  then  k := k - 1;

                        if k <= 0 Then
                         Begin
                          k := 1;
                         End;

                        if i = k + 1 Then
                         Begin
                          if k + B.X - A.X - 2 <= Length( InputLineString^) then
                           x := k + B.X - A.X - 2 - 1
                            else
                             x := length ( InputLineString^ );


                           WriteChar(A.X,A.Y,B.X-A.X,' ',InputLineNormalText);
                           ParamPut(A.X + 1 , A.Y, InputLineString^, k,x,InputLineNormalText );

                         End;

                        i := i - 1;

                       if i = k + 1 then
                        GotoXY( A.X + 2  , A.Y)
                         else
                          GotoXY( A.X + i - k + 1 , A.Y);


                        End; { If i > 1 }

                     End;{ Left }

            kbRight : Begin

                       if (i <= length(InputLineString^)) then
                        Begin


                        if ( ( A.X + i - k + 2) >= B.X )
                         then
                          Begin

                           k := k + 1;

                           if k + B.X - A.X - 2 < Length( InputLineString^) then
                            x := k + B.X - A.X - 2 - 1
                             else
                              x := length ( InputLineString^ );

                           WriteChar(A.X,A.Y,B.X-A.X,' ',InputLineNormalText);
                           ParamPut(A.X + 1 , A.Y, InputLineString^, k,x,InputLineNormalText );


                          End;

                          i := i + 1;

                          GotoXY( A.X + i - k + 1, A.Y);

                         End;
                      End;


            kbHome  : If i <> 1 Then
                       Begin

                       k := 1;
                       i := 1;

                       WriteChar( A.X , A.Y, B.X - A.X,' ',InputLineNormalText );

                       if ( B.X - A.X - 2 ) <= Length ( InputLineString^ ) then
                        ParamPut(A.X+1,A.Y,InputLineString^,1,B.X - A.X - 2 ,
                                                      InputLineNormalText)
                         else
                          ParamPut(A.X+1,A.Y,InputLineString^,1,Length (InputLineString^) ,
                                                      InputLineNormalText);

                       GotoXY( A.X + 1, A.Y );

                      End;

            kbEnd    : If i <>  Length(InputLineString^)+1 Then
                       Begin

                        i := Length(InputLineString^)+1;

                        if i >= ( B.X - A.X - 2 ) then k := i - ( B.X - A.X - 2 )
                         else k := 1;

                        WriteChar( A.X , A.Y, B.X - A.X,' ',InputLineNormalText );

                        if ( B.X - A.X - 2 ) < Length ( InputLineString^ ) then
                         Begin
                          ParamPut(A.X+1,A.Y,InputLineString^, k, i-1,
                                                      InputLineNormalText);
                          GotoXY( B.X - 1, A.Y);

                         End
                          else
                           Begin
                            ParamPut(A.X+1,A.Y,InputLineString^, k, i-1,
                                                      InputLineNormalText);
                            GotoXY( A.X + i - k + 1 , A.Y );
                           End;

                       End;

    else
      If c1 < 2700 Then
      Begin

       If Length( InputLineString^ ) < InputLineLength Then
        begin

         if i = Length(InputLineString^)+1  Then
          Begin

           InputLineString^ := InputLineString^ + Chr( c1 );

           i := Length( InputLineString^ ) + 1;

           if ( i - k ) > ( B.X - A.X - 2 )  then  k := k + 1;


           if k + B.X - A.X - 2 <= Length( InputLineString^) then
            x := k + B.X - A.X - 2
             else
              x := length ( InputLineString^ );

            WriteChar(A.X,A.Y,B.X-A.X,' ',InputLineNormalText);
            ParamPut(A.X+1,A.Y,InputLineString^,k,x,InputLineNormalText);


           GotoXY( A.X + i - k + 1, A.Y);

          End

           else

            if InsFlag  Then
             Begin

              Insert( Chr( c1 ), InputLineString^, i);


              if i - k >= B.X - A.X - 2  then k := k + 1;

              if k + B.X - A.X - 2 <= Length( InputLineString^ ) then
               x := k + B.X - A.X - 2 - 1
                else
                 x := Length( InputLineString^);

              if k <= 0 Then k := 1;


              WriteChar(A.X,A.Y,B.X-A.X,' ',InputLineNormalText);
              ParamPut(A.X+1,A.Y,InputLineString^,k,x,InputLineNormalText);

              i := i + 1;

              GotoXY(A.X + i - k + 1 , A.Y);

             End;
         End;

         If ( I <> Length(InputLineString^)+1 ) and Not InsFlag Then
          begin

           InputLineString^[ i ] := Chr( c1 );

           if i - k >= B.X - A.X - 2  then k := k + 1;

           if k + B.X - A.X - 2 <= Length( InputLineString^ ) then
            x := k + B.X - A.X - 2 - 1
             else
              x := Length( InputLineString^);

           if k <= 0 Then k := 1;


           WriteChar(A.X,A.Y,B.X-A.X,' ',InputLineNormalText);
           ParamPut(A.X+1,A.Y,InputLineString^,k,x,InputLineNormalText);

           i := i + 1;

           GotoXY(A.X + i - k + 1 , A.Y);
          end;

      End;
    End;{ Case c2 }

   if ( Length( InputLineString^ ) > 0 )
    and (( Length( InputLineString^ ) - k )  >  B.X - A.X - 2)
     and ( InputLineLength >  B.X - A.X - 2 )
      then
       WriteChar( B.X-1, A.Y, 1, #16, InputLineOptionText )
        else
         WriteChar( B.X-1 , A.Y, 1, ' ' , InputLineOptionText ) ;


   if ( k > 1 ) and ( InputLineLength >  B.X - A.X - 2 ) then
     WriteChar( A.X, A.Y, 1, #17, InputLineOptionText )
      else
       WriteChar( A.X , A.Y, 1, ' ' , InputLineOptionText ) ;


  End;{ While }

End;{ With }

End;{ Run }

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

function TInputLine.GetSize : Byte ;
Begin

 GetSize := InputLineLength + 1;

End;{ TView. NewSItem }

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

procedure TInputLine.GetData( var GData  : pointer; var Size : Byte  );

Type
    PString      = ^String ;

Var
    PS           : PString ;
    i            : Word ;
    ISeg , IOfs,
    OSeg , OOfs  : Word ;

Begin

 Size  := InputLineLength + 1 ;


 GetMem( PS,Size );

 PS^ := InputLineString^ ;

 GData := PS ;


End;

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

procedure TInputLine.SetData( var SData );

Type
    PString      = ^String ;

Var
    PS           : PString ;
    ISeg , IOfs,
    OSeg , OOfs,
    i,l          : Word ;

Begin

   i := 0;

   OSeg := Seg( SData );
   OOfs := Ofs( SData );

   ISeg := Seg( InputLineString^ );
   IOfs := Ofs( InputLineString^ );

{   If Mem[ OSeg : OOfs ] <> 0 Then
     }

     For i := 0 to InputLineLength    do
       Mem[ ISeg : IOfs + i ] := Mem[ OSeg : OOfs + i ];


End;

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }
destructor TInputLine.Done;
begin

  FreeMem( InputLineString , InputLineLength );


end;


{ à®æ¥¤ãàë ¨ äã­ªæ¨¨ ®¡ê¥ªâ  TRadioButton . }
{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

constructor TRadioButton.Init( R : TRect ); { TitleStr : String; TX , TY : Word ); }
Begin

 TitleFlag := No ;

 ObjType   := DRadioButton  ;

 TitleFlag := No ;

 TRBCoord     :=  R ;
 ButtonsNum   :=  0 ;
 ButtonsItem  :=  1 ;

 MaxLength    :=  0 ;

End;

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

procedure TRadioButton.NewSItem( LString : String );
Begin

 inc( ButtonsNum );

 New ( RadioButtons [ ButtonsNum ] );

 With TRBCoord do
  Begin


 With RadioButtons [ ButtonsNum ]^ do
  Begin

   ItemsString := LString ;

   if (Length( LString ) > MaxLength) and ( ButtonsNum <= B.Y - A.Y )Then MaxLength := Length( LString );

     If ( ButtonsNum <= B.Y - A.Y ) Then
      Begin

        ItemsX := A.X + 1          ;
        ItemsY := A.Y + ButtonsNum - 1 ;

      End;

    If ( ButtonsNum  > B.Y - A.Y  ) then
     Begin

        ItemsX := A.X + MaxLength + 6 + 1         ;
        ItemsY := A.Y + ButtonsNum - ( B.Y - A.Y ) - 1;


    if ItemsX >= B.X  then  ItemsX := 0;


     End;


    End;

  End; { With }


End;{ NewSItem }

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

procedure TRadioButton.Draw;
Var
  i : Byte ;

Begin
 If TitleFlag = Yes Then
  ColorPut( TitleRect.A.X , TitleRect.A.Y, TitleString,
                              TLableNormalText,  TLableNormalAcText );


 With TRBCoord do
  Begin

   For i := A.Y to B.Y - 1 do
    WriteChar( A.X, i, B.X - A.X, ' ', RadioButtonNormalText );

   i := 1;

   For i := 1 to ButtonsNum  do
    Begin
     With RadioButtons [ i ]^ do
      Begin
       if ItemsX <> 0 Then
        Begin

         WriteStr( ItemsX    , ItemsY, '( ) ', CheckBoxesNormalText );
         if i = ButtonsItem  Then
          WriteStr( ItemsX    , ItemsY, '('#7') ', CheckBoxesNormalText );

         WriteStr( ItemsX + 4, ItemsY, ItemsString, CheckBoxesNormalText );


        End;

      End; { With }
    end; { For }
  End;


End; { Draw }

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

procedure TRadioButton.Run;

var i,k : Byte ;
    ch  : Word ;

Begin

ch := 1 ;
k := 0;
i := ButtonsItem;

If TitleFlag = Yes Then
 ColorPut( TitleRect.A.X , TitleRect.A.Y, TitleString,
                              TLableAccentText,  TLableAccentAcText );


With TRBCoord do
 With RadioButtons[ i ]^ do
  Begin
   WriteStr( ItemsX    , ItemsY, '('#7') ', RadioButtonAccentText );
   WriteStr( ItemsX + 4, ItemsY, ItemsString, RadioButtonAccentText );
  End;

While K <> 1 do
 Begin

  ch := GetKey;
  case ch of
   kbEnter : Begin
              HiddenCursor;
              DialogKey := kbEnter;
              Exit;
             End;


   kbEsc   : Begin
               DialogKey := kbEsc ;
               Exit;
              End;

   kbTab   : Begin
              HiddenCursor;
              DialogKey := kbTab ;
              Draw;
              Exit;
             End;

   kbShiftTab : Begin

                  HiddenCursor;
                  DialogKey := kbShiftTab ;
                  Draw;
                  Exit;

                End;

   kbDn : begin
            If  ButtonsItem < ButtonsNum Then inc( ButtonsItem )
              else
                ButtonsItem := 1;

          end;

   kbUp : begin

            If  ( ButtonsItem <= ButtonsNum ) and ( ButtonsItem > 1 ) Then dec( ButtonsItem )
              else
                ButtonsItem := ButtonsNum;

          end;

   kbRight : Begin
               With TRBCoord do
                 Begin

                   if ButtonsNum <= B.Y - A.Y  Then
                    { If  ButtonsItem < ButtonsNum Then inc( ButtonsItem );}
                    begin
                      HiddenCursor;
                      DialogKey := kbTab ;
                      Draw;
                      Exit;
                    end;

                   if ButtonsNum > B.Y - A.Y  Then
                     Begin

                       If ButtonsItem + B.Y - A.Y  < ButtonsNum then
                         ButtonsItem := ButtonsItem + B.Y - A.Y
                           else
                             if  ButtonsItem + B.Y - A.Y  = ButtonsNum Then
                                ButtonsItem := ButtonsNum;
                     End;
                 End;
             End; { kbRight }

   kbLeft : Begin
              With TRBCoord do
                Begin

                  if ( ButtonsNum <= B.Y - A.Y ) Then
                  {  If  ( ButtonsItem <= ButtonsNum ) and ( ButtonsItem > 1 ) Then
                      dec( ButtonsItem ) ;
                   }
                    begin
                      HiddenCursor;
                      DialogKey := kbShiftTab ;
                      Draw;
                      Exit;
                    end;

                  if ( ButtonsNum > B.Y - A.Y )
                    and ( ButtonsItem  > ( B.Y - A.Y ) ) Then
                     Begin
                       If ButtonsItem - (B.Y - A.Y) > 1  then
                         ButtonsItem := ButtonsItem -( B.Y - A.Y )
                           else
                             if  ButtonsItem - (B.Y - A.Y)  =  1 Then
                               ButtonsItem := 1 ;
                     End;

                End;
            End; { kbLeft }

  End;


  With TRBCoord do
   Begin


    With RadioButtons[ i ]^ do
     Begin

      WriteStr( ItemsX    , ItemsY, '( ) ', RadioButtonNormalText );
      WriteStr( ItemsX + 4, ItemsY, ItemsString, RadioButtonNormalText );

     End;{ RadioButtons[ i ]^ }

    With RadioButtons[ ButtonsItem ]^ do
     Begin

      WriteStr( ItemsX    , ItemsY, '('#7') ', RadioButtonAccentText );
      WriteStr( ItemsX + 4, ItemsY, ItemsString, RadioButtonAccentText );

     End;{ RadioButtons[ ButtonsItem ]^ }


  End;{ With TRBCoord }

 i := ButtonsItem;


 End;{ While }



End;{ Run }

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

procedure TRadioButton.GetData( var GData  : pointer; var Size : byte );
Type
   PByte  = ^Byte;
Var
   pb : pbyte;

Begin

  New( pb );

  pb^ := ButtonsItem;

  Size := 1;

  GData := pb;


End;{ TRadioButton.GetData }

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

procedure TRadioButton.SetData( var SData );

Var

  ISeg, IOfs,
  OSeg, OOfs : word;


Begin


  ISeg := Seg( SData );
  IOfs := Ofs( SData );

  OSeg := Seg( ButtonsItem );
  OOfs := Ofs( ButtonsItem );

  Mem[ OSeg : OOfs ] := Mem[ ISeg : IOfs ];



End;{ TRadioButton.GetData }

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }
destructor TRadioButton.Done;
Var i : byte;
begin

For i := 1 to ButtonsNum do
 Dispose( RadioButtons[ i ] );
end;{ Done }



{ à®æ¥¤ãàë ¨ äã­ªæ¨¨ ®¡ê¥ªâ  TCheckBoxes . }
{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

constructor TCheckBoxes.Init( R : TRect );
Begin

 ObjType      := DCheckBoxes  ;

 TitleFlag    := No ;

 TCBCoord     :=  R ;
 ButtonsNum   :=  0 ;
 ButtonsItem  :=  1 ;

 MaxLength    :=  0 ;

 CBData       :=  0 ;

End;

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

procedure TCheckBoxes.NewSItem( LString : String );
Begin

 inc( ButtonsNum );

 New ( CheckBoxes [ ButtonsNum ] );

With TCBCoord do
 Begin


 With CheckBoxes [ ButtonsNum ]^ do
  Begin

   ItemsString := LString ;
   ItemsStatus := No ;

   if (Length( LString ) > MaxLength) and ( ButtonsNum <= B.Y - A.Y )
              Then MaxLength := Length( LString );

     If ( ButtonsNum <= B.Y - A.Y ) Then
      Begin

        ItemsX := A.X + 1          ;
        ItemsY := A.Y + ButtonsNum - 1 ;

      End;

    If ( ButtonsNum  > B.Y - A.Y  ) then
     Begin

        ItemsX := A.X + MaxLength + 6 + 1         ;
        ItemsY := A.Y + ButtonsNum - ( B.Y - A.Y ) - 1;


    if ItemsX >= B.X  then  ItemsX := 0;


     End;


    End;

  End; { With }


End;{ NewSItem }

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

procedure TCheckBoxes.Draw;
var i : Byte ;
Begin


 If TitleFlag = Yes Then
  ColorPut( TitleRect.A.X , TitleRect.A.Y, TitleString,
                              TLableNormalText,  TLableNormalAcText );

 With TCBCoord do
  Begin

   For i := A.Y to B.Y - 1 do
    WriteChar( A.X, i, B.X - A.X, ' ', CheckBoxesNormalText );

   i := 1;

   For i := 1 to ButtonsNum  do
    Begin
     With CheckBoxes [ i ]^ do
      Begin
       if ItemsX <> 0 Then
        Begin

         WriteStr( ItemsX    , ItemsY, '[ ] ', CheckBoxesNormalText );
         WriteStr( ItemsX + 4, ItemsY, ItemsString, CheckBoxesNormalText );

         If  ItemsStatus = Yes  Then
           WriteStr( ItemsX + 1, ItemsY, 'X', CheckBoxesNormalText );


        End;

      End; { With }
    End; { For }
  End;


End; { Draw }

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

procedure TCheckBoxes.Run;

var i,k,s : Byte ;
    ch  : word ;

Begin

NormalCursor;

If DialogKey = kbTab Then
 ButtonsItem := 1;

If DialogKey = kbShiftTab Then
 ButtonsItem := ButtonsNum;

k := 0;
i := ButtonsItem;

 If TitleFlag = Yes Then
  ColorPut( TitleRect.A.X , TitleRect.A.Y, TitleString,
                              TLableAccentText,  TLableAccentAcText );


With TCBCoord do
 With CheckBoxes[ i ]^ do
  Begin
   WriteStr( ItemsX    , ItemsY, '[ ]', CheckBoxesAccentText );
   WriteStr( ItemsX + 4, ItemsY, ItemsString, CheckBoxesAccentText );
   If  ItemsStatus = Yes  Then
    WriteStr( ItemsX + 1, ItemsY, 'X', CheckBoxesAccentText );

   GoToXY( ItemsX + 1, ItemsY );

  End;

While K <> 1 do
 Begin

  ch := GetKey;
  case ch of
   kbEnter : Begin
              DialogKey := kbEnter;

              CBData := 0;

              for s := 1 to ButtonsNum do
               if CheckBoxes[ s ]^.ItemsStatus = Yes then
                CBData := CBData + BSqr( 2, s-1 );
              HiddenCursor;
              Exit;
             End;
   kbEsc   : Begin
              DialogKey := kbEsc ;

              CBData := 0;

              for s := 1 to ButtonsNum do
               if CheckBoxes[ s ]^.ItemsStatus = Yes then
                CBData := CBData + BSqr( 2, s-1 );

              HiddenCursor;
              Exit;
             End;

   kbTab   : Begin
              DialogKey := kbTab ;
              Draw ;

              CBData := 0;

              for s := 1 to ButtonsNum do
               if CheckBoxes[ s ]^.ItemsStatus = Yes then
                CBData := CBData + BSqr( 2, s-1 );

              HiddenCursor;
              Exit;
             End;

   kbSpace : Begin
              if CheckBoxes[ ButtonsItem ]^.ItemsStatus  = No then
               CheckBoxes[ ButtonsItem ]^.ItemsStatus  := Yes
                else CheckBoxes[ ButtonsItem ]^.ItemsStatus := No;

              CBData := 0;

              for s := 1 to ButtonsNum do
               if CheckBoxes[ s ]^.ItemsStatus = Yes then
                CBData := CBData + BSqr( 2, s-1 );

             End;

    kbShiftTab: Begin
                  DialogKey := kbShiftTab ;
                  Draw ;

                  CBData := 0;

                  for s := 1 to ButtonsNum do
                    if CheckBoxes[ s ]^.ItemsStatus = Yes then
                      CBData := CBData + BSqr( 2, s-1 );

                  HiddenCursor;
                  Exit;
                End;

    kbDn : Begin

             if ButtonsItem < ButtonsNum Then
               begin
                 i := ButtonsItem;
                 Inc( ButtonsItem );
               end
                else
                 begin

                   DialogKey := kbTab ;
                   Draw ;

                   CBData := 0;

                   for s := 1 to ButtonsNum do
                     if CheckBoxes[ s ]^.ItemsStatus = Yes then
                       CBData := CBData + BSqr( 2, s-1 );

                   HiddenCursor;
                   Exit;

                 end;
           End;

    kbUp : Begin

             i := ButtonsItem;
             Dec( ButtonsItem );

             If ButtonsItem = 0 Then
               begin

                 DialogKey := kbShiftTab ;
                 Draw ;

                 CBData := 0;

                 for s := 1 to ButtonsNum do
                   if CheckBoxes[ s ]^.ItemsStatus = Yes then
                     CBData := CBData + BSqr( 2, s-1 );

                 HiddenCursor;
                 Exit;

              end;

           End;

    kbRight : Begin
                With TCBCoord do
                  Begin

                    if ButtonsNum < B.Y - A.Y  Then
                      If  ButtonsItem < ButtonsNum Then inc( ButtonsItem );

                    if ButtonsNum > B.Y - A.Y  Then
                      Begin

                        If ButtonsItem + B.Y - A.Y  < ButtonsNum then
                          ButtonsItem := ButtonsItem + B.Y - A.Y
                            else
                              if  ButtonsItem + B.Y - A.Y  = ButtonsNum Then
                                   ButtonsItem := ButtonsNum;

                      End;

                   End;
              End; { kbRight }

     kbLeft : Begin
                With TCBCoord do
                  Begin

                    if ( ButtonsNum < B.Y - A.Y ) Then
                      If  ( ButtonsItem <= ButtonsNum ) and ( ButtonsItem > 1 ) Then
                        dec( ButtonsItem ) ;

                    if ( ButtonsNum > B.Y - A.Y )
                      and ( ButtonsItem  > ( B.Y - A.Y ) ) Then
                        Begin

                          If ButtonsItem - (B.Y - A.Y) > 1  then
                            ButtonsItem := ButtonsItem -( B.Y - A.Y )

                              else
                                if  ButtonsItem - (B.Y - A.Y)  =  1 Then
                                  ButtonsItem := 1 ;
                        End;

                  End;
              End; { kbLeft }

  End;


  With TCBCoord do
   Begin


    With CheckBoxes[ i ]^ do
     Begin

      WriteStr( ItemsX    , ItemsY, '[ ] ', CheckBoxesNormalText );
      WriteStr( ItemsX + 4, ItemsY, ItemsString, CheckBoxesNormalText );

      if ItemsStatus = Yes Then
       WriteChar( ItemsX + 1, ItemsY, 1, 'X', CheckBoxesNormalText );

     End;{ CheckBoxes[ i ]^ }

    With CheckBoxes[ ButtonsItem ]^ do
     Begin

      WriteStr( ItemsX    , ItemsY, '[ ] ', CheckBoxesAccentText );
      WriteStr( ItemsX + 4, ItemsY, ItemsString, CheckBoxesAccentText );

      if ItemsStatus = Yes Then
       WriteChar( ItemsX + 1, ItemsY, 1, 'X', CheckBoxesAccentText );

      GoToXY( ItemsX + 1, ItemsY );

     End;{ CheckBoxes[ ButtonsItem ]^ }


  End;{ With TCBCoord }

 i := ButtonsItem;

 End;{ While }



End; { Run }

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }
procedure TCheckBoxes.GetData( var GData  : pointer; var Size : byte );
Type
   PWord  = ^Word;
Var
   PW : PWord;

Begin

  GetMem( PW, 2 );

  PW^ := CBData ;

  Size := 2;

  GData := PW;


End;{ TCheckBoxes.GetData }

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }
procedure TCheckBoxes.SetData( var SData );
Var

  i          : Byte ;

  ISeg, IOfs,
  OSeg, OOfs : word;

  SCBData    : Word;

Begin


  ISeg := Seg( SData );
  IOfs := Ofs( SData );

  OSeg := Seg( CBData );
  OOfs := Ofs( CBData );

  MemW[ OSeg : OOfs ] := MemW[ ISeg : IOfs ];

  SCBData := CBData ;

  For i := 1 to ButtonsNum do
   Begin

     If ( SCBData  mod 2 ) = 1 then
      CheckBoxes[ i ]^.ItemsStatus := Yes
       else
        CheckBoxes[ i ]^.ItemsStatus := No ;

     SCBData := SCBData div 2;

   End; { For i := 1 to ButtonsNum do }


End;{ TCheckBoxes.SetData }

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }
destructor TCheckBoxes.Done;
Var i : byte;
begin

 For i := 1 to ButtonsNum do
  Dispose( CheckBoxes[ i ] );

end;{ Done }


{ à®æ¥¤ãàë ¨ äã­ªæ¨¨ ®¡ê¥ªâ  TButton . }
{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

constructor TButton.Init( R : TRect; BString : String; IEvent, ICommand : Word );
Begin

  ObjType       := DButton   ;

  TBCoord       := R         ;
  ButtonString  := BString   ;
  ItemsEvent    := IEvent    ;
  ItemsCommand  := ICommand  ;

  BFlag         := False ;


End;{ Init }

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

Procedure TButton.Draw;
var
  i,sx,sy,l : Byte;

Begin
 With TBCoord do
  Begin

    sy := 0;

    bsx := 0;

    l := 0;

   If Pos('~',ButtonString ) = 0 then l := 2;

   If B.X - A.X < Length( ButtonString ) - l Then
     B.X := A.X + Length( ButtonString ) - l + 1;

   If Length( ButtonString ) - l >= ( B.X - A.X ) then
    B.X := A.X + Length( ButtonString ) ;

   If Length( ButtonString ) - l < ( B.X - A.X ) then
    bsx := ( B.X - A.X - Length( ButtonString ) - l ) div 2;

   If Length( ButtonString ) - l = ( B.X - A.X ) then
    bsx := 0;

   If ( B.Y - A.Y  ) > 2 Then
    sy := A.Y + ( B.Y - A.Y - 1 ) div 2 - 2;

   for i:= 0 to B.Y - A.Y - 1 do
    WriteChar( A.X , A.Y + i , B.X - A.X - 1, ' ', TButtonNormalText);

   if ( B.Y - A.Y ) >= 1  Then
    Begin

     WriteChar( A.X + 1, B.Y , B.X - A.X - 1, 'ß', TButtonTText );
     WriteChar( B.X - 1 , A.Y, 1, 'Ü', TButtonTText );

    End;

   if ( B.Y - A.Y ) > 1 then
    for i := 1 to B.Y - A.Y - 1 do
     WriteChar( B.X - 1, A.Y + i,1,'Û',TButtonTText);

   if not BFlag then
    Begin
     ColorPut( A.X + bsx + 1 , A.Y + sy , ButtonString, TButtonNormalText, TButtonAccentText);
     if ItemsEvent = bfDefault then
      ColorPut( A.X + bsx + 1,A.Y + sy ,ButtonString, TButtonDefaultText, TButtonAccentText);
    End;

   if BFlag then
    Begin
     ColorPut( A.X + bsx + 1 , A.Y + sy , ButtonString, TButtonRunText, TButtonAccentText);
     if ItemsEvent = bfDefault then
      ColorPut( A.X + bsx + 1,A.Y + sy ,ButtonString, TButtonRunText, TButtonAccentText);

     WriteChar( A.X, A.Y + SY, 1, #16, TButtonRunText );
     WriteChar( B.X-2, A.Y + SY, 1, #17, TButtonRunText );
    End;


  End;
End;{ Draw }

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

Procedure TButton.Run;
const
 k : byte = 1 ;
var
 i  : Byte;
 ch : Word ;

Begin

 With TBCoord do
  Begin

 BFlag := True ;
 Draw ;

 While k = 1 do
  Begin

   ch := GetKey;
   case ch of
    kbEsc   : Begin
               DialogKey := kbEsc ;
               Exit;
              End;
    kbTab   : Begin

               DialogKey := kbTab;
               BFlag := False;
               Draw;
               Exit;

              End;

    kbEnter : Begin

              { ˆ¬¬¨â æ¨ï ­ ¦ â¨ï ­  ª­®¯ªã. }
              { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

               for i := 1 to B.Y - A.Y+ 1 do
                WriteChar( A.X  , A.Y + i - 1, B.X - A.X+1, ' ', TDialogNormalText);

               for i := 1 to B.Y - A.Y do
                WriteChar( A.X + 1 , A.Y + i - 1   , B.X - A.X - 1, ' ', TButtonNormalText);

               ColorPut( A.X + bsx + 2,A.Y,ButtonString, TButtonRunText, TButtonAccentText);

              { ‡ ¤¥p¦ª . }
              { ÄÄÄÄÄÄÄÄÄ }

               Delay( 65 );

              { ˆ¬¬¨â æ¨ï ®â¯ãáª ­¨ï ª¯®­ª¨. }
              { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

               for i := 1 to B.Y - A.Y+ 1 do
                WriteChar( A.X  , A.Y + i - 1, B.X - A.X + 1, ' ', TDialogNormalText);

               Draw;

               Delay( 50 );

               DialogKey := kbEnter;
               DialogItem :=  ItemsCommand ;
               Exit;

              End;

    kbShiftTab,
    kbUp,
    kbLeft     : Begin

                   DialogKey := kbShiftTab;
                   BFlag := False;
                   Draw;

                   Exit;

                 End;
    kbDn,
    kbRight : Begin

                DialogKey := kbTab;
                BFlag := False;
                Draw;
                Exit;

              End;

   End; { case }
  End;{ While k = 1 }


 End;{ With TBCoord }

End;

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }
destructor TButton.Done;
begin

end;{ Done }


{ à®æ¥¤ãàë ¨ äã­ªæ¨¨ ®¡ê¥ªâ  TStaticText . }
{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

constructor TStaticText.Init( R : TRect; STString : String );
begin

 TSTR := R;

 StaticTextString := STString;

 STAttr := TStaticTextNormalAttr ;


end; { TStaticText.Init }

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

procedure TStaticText.Draw;
Var
 I, X, Y, K, M, L   : Byte;

begin

 With TSTR do
  begin

   X := A.X;
   Y := A.Y;

   For I := 1 to Length( StaticTextString ) do
    begin

     If ( StaticTextString[ I ] <> #13 )
      and ( StaticTextString[ I ] <> ^C ) Then
       begin

         WriteChar( X, Y, 1, StaticTextString[ I ], STAttr );
         Inc( X );

       end;{ if ( StaticTextString[ I ] <> #13 ) and ... }

     If ( StaticTextString[ I ] = #13 )  Then
      begin

       Inc( Y );
       X := A.X;

      end;

     If  StaticTextString[ I ] = ^C  Then
      begin

       K := I;
       L := 0;

       Inc( K );

       While ( StaticTextString[ K ] <> #13 )  do
        begin

         Inc( L );
         Inc( K );

        end;

       If L > ( Lo( WindMax ) - Lo( WindMin ) + 2) Then
        X := 1;

       If L <= ( Lo( WindMax ) - Lo( WindMin ) + 2 ) Then
        X := 1 + (( Lo( WindMax ) - Lo( WindMin )) - L + 2 ) div 2 ;

      end;


    end; { For i := 0 to ... }
  end;{ With TSTR }

end;{ TStaticText.Draw }

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

procedure TStaticText.Run;
begin

end;{ TStaticText.Run }

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }
destructor TStaticText.Done;
begin

end;{ Done }


{ à®æ¥¤ãàë ¨ äã­ªæ¨¨ ®¡ê¥ªâ  TDialog . }
{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

constructor TDialog.Init( R : TRect; DWTitle : TDWString; WOptions : Word );
Var
   ww ,
   hw   : Word ;

Begin

  DWCoord         := R         ;
  Options         := WOptions  ;

  DWNum := 0;


  With DWCoord do
   Begin

    ww      := B.X - A.X + 1; { ˜¨p¨­  ®ª­ . }
    hw      := B.Y - A.Y + 1; { ‚ëá®â  ®ª­ . }


    If ww < 5 Then
     begin

      B.X   := A.X + 5 ;

     end;

    If hw < 2 Then
     begin

      B.Y   := A.Y + 2;

     end;

    If hw > 24 Then
     begin

      A.Y := 2 ;
      B.Y := VideoYRes ;

      hw      := B.Y - A.Y + 1; { ‚ëá®â  ®ª­ . }

     end;

    If ww > VideoXRes - 2 Then
     begin

      A.X := 1 ;
      B.X := VideoXRes - 2 ;

      ww  := B.X - A.X + 1; { ˜¨p¨­  ®ª­ . }

     end;

   End;

  If Options and jcCentered <> 0 Then
   Begin

    With DWCoord do
     Begin

       { H®¢ë¥ ª®®p¤¨­ âë. }
       { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

       A.X := (VideoXRes - ww + 1) div 2 + 1;
       B.X   := A.X + ww - 1;
       A.Y := ( VideoYRes + 1 - hw ) div 2 + 1;
       B.Y   := A.Y + hw  ;

     End;{ With DWCoord }

   End; { if Options = jcCentered  }


  If Options and jcLeft <> 0 Then
   Begin

    With DWCoord do
     Begin

       ww      := B.X - A.X + 1 ; { ˜¨p¨­  ®ª­ . }
       hw      := B.Y - A.Y + 1 ; { ‚ëá®â  ®ª­ . }

       { H®¢ë¥ ª®®p¤¨­ âë. }
       { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

       A.X := 1     ;
       B.X := ww      ;

     End;{ With DWCoord }

   End; { if Options = jcLeft  }

  If Options and jcRight <> 0 Then
   Begin

    With DWCoord do
     Begin

       ww      := B.X - A.X + 1 ; { ˜¨p¨­  ®ª­ . }
       hw      := B.Y - A.Y + 1 ; { ‚ëá®â  ®ª­ . }

       { H®¢ë¥ ª®®p¤¨­ âë. }
       { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

       A.X   := VideoXRes - 2 - WW + 1;
       B.X   := VideoXRes - 2      ;

     End;{ With DWCoord }

   End; { if Options = jcRight  }


  WindowTitle     := DWTitle   ;

  DialogItemsNum  := 0         ;
  NumDialogSelect  := 1        ;


End;{ TDialog.Init }

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

procedure TDialog.Insert( DItems : PView );
Begin

  Inc( DialogItemsNum );

  DialogItems [ DialogItemsNum ] := DItems ;


End;

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

procedure  TDialog.Draw;
var
  W  : WinRecPtr ;
  i  : Byte      ;

procedure DialogFrameWin( Title: TDWString; var Frame: FrameChars;
  FrameAttr, SelAttr : Byte);

var
  W, H, Y, X: Word;

Begin

  W := Lo(WindMax) - Lo(WindMin) + 1;
  H := Hi(WindMax) - Hi(WindMin) + 1;

 { ®áâp®¨âì ¢¥på p ¬ª¨ ®ª­ . }
 { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

  WriteChar(1, 1, 1, Frame[1], FrameAttr);
  WriteChar(2, 1, W - 3, Frame[2], FrameAttr);
  WriteChar(W - 2, 1, 1, Frame[3], FrameAttr);

  WriteChar(3,1,1,'[',FrameAttr);
  WriteChar(4,1,1,#254,SelAttr);
  WriteChar(5,1,1,']',FrameAttr);

 { ‚ë¢¥áâ¨ § £®«®¢®ª ®ª­ . }
 { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

  if Length(Title) > W - 2 then Title[0] := Chr(W - 2);
   WriteStr((W - Length(Title) + 1) Div 2, 1, Title, FrameAttr);

 { ®áâp®¨âì ¡®ª®¢ë¥ áâ®p®­ë p ¬ª¨ ®ª­ . }
 { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

  for Y := 2 to H - 2 do
  Begin
    WriteChar(1, Y, 1, Frame[4], FrameAttr);
    WriteChar(W-2, Y, 1, Frame[5], FrameAttr);
  End;

 { ®áâp®¨âì ­¨§ p ¬ª¨ ®ª­ . }
 { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

  WriteChar(1, H - 1, 1, Frame[6], FrameAttr);
  WriteChar(2, H - 1, W - 3, Frame[7], FrameAttr);
  WriteChar(W-2, H - 1, 1, Frame[8], FrameAttr);

 { ®áâp®¨âì â¥­ì ®ª­ . }
 { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

  ChangeAttr( 3, H , W - 2 , LightGray + Black * 16 );

    For Y := 2 to H do
      ChangeAttr( W - 1, Y, 2, LightGray + Black * 16 );


 { “áâ ­®¢¨âì ­®¢ë¥ p §¬¥pë ®ª­ . }
 { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

  Inc(WindMin, $0101);
  Dec(WindMax, $0203);

 { ‡ ªâ á¨âì ®ª­®. }
 { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

  FillWin(' ', TDialogNormalText);

End;

Begin

If DWNum = 0 Then
  begin

  New(W);

  with W^ do
  Begin

   With DWCoord do
   Begin

    Next := TopWindow;

    SaveWin(State);

    GetMem(Title, Length( WindowTitle ) + 1);

    Title^ := WindowTitle ;

    FrameAttr := TDialogFrameAttr  ;
    TitleAttr := TDialogAccentAttr ;

    Window( A.X, A.Y, B.X + 2, B.Y );

    GetMem(Buffer, WinSize);
    ReadWin(Buffer^);

    DialogFrameWin( WindowTitle , DoubleFrame, FrameAttr ,TitleAttr );

   End;

  End;

  TopWindow := W;
  Inc(WindowCount);

  Inc( DWNum );


 If DialogItemsNum > 0 Then
  For i := 1  to DialogItemsNum do
    DialogItems[ i ]^.Draw;

  end;

End; { TDialog.Draw }

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

destructor TDialog.Done;
Var
  i : byte ;
  W: WinRecPtr;

Begin

  Inc(WindMax, $0102);

  if TopWindow <> nil then
  begin
    W := TopWindow;
    with W^ do
    begin
      UnFrameWin;
      WriteWin(Buffer^);
      FreeMem(Buffer, WinSize);
      FreeMem(Title, Length(Title^) + 1);
      RestoreWin(State);
      TopWindow := Next;
    end;
    Dispose(W);
    Dec(WindowCount);
  end;

  If DialogItemsNum > 0 Then
   For i := 1  to DialogItemsNum do
    Dispose( DialogItems[ i ], Done );


End;

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

function TDialog.Run : Word;
Label BegRun;
Const

    EndFlag : Boolean = False ;

Var
  ch1, ch2 : char ;
  i        : byte ;


Begin

 If DialogItemsNum = 0 Then
   begin

     Run := cmCancel;
     Exit;

   end;

 Draw ;

 DialogKey := kbTab ;

 HiddenCursor;

BegRun:;

  DialogItem := cmOk ;
  DialogItems[ NumDialogSelect ]^. Run ;

   if DialogKey = kbTab Then
    Begin

     Inc ( NumDialogSelect ) ;

     If NumDialogSelect > DialogItemsNum Then
      NumDialogSelect :=  1 ;

     goto  BegRun ;

    End;

   if DialogKey = kbShiftTab Then
    Begin

     Dec( NumDialogSelect );

     If NumDialogSelect < 1 Then
      NumDialogSelect := DialogItemsNum ;

     goto BegRun ;

    End;

 If DialogKey = kbEsc Then
  DialogItem := cmCancel ;

 Run := DialogItem ;


End;{ TDialog.Run }

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

procedure TDialog.GetData( Var DData );

Var

  TBuf    : Pointer ;

  TBSeg,
  TBOfs   : Word;

  i, k,
  Size    : Byte;
  MSize   : Word ;

  RSeg,
  ROfs,
  TOfs,
  LOfs    : Word ;

Begin

  RSeg := Seg( DData );
  ROfs := Ofs( DData );

  TOfs := 0 ;

  for  i := 1 to DialogItemsNum do
   Begin

     if DialogItems[ i ]^.ObjType = DInputLine then
      Begin

       LOfs := 0;

       MSize := DialogItems[ i ]^.GetSize;

       DialogItems[ i ]^.GetData( TBuf, Size );

       TBSeg := Seg( TBuf^ );
       TBOfs := Ofs( TBuf^ );

       for LOfs := 0 to MSize - 1  do
        Mem[ RSeg : ROfs + TOfs + LOfs ] :=  Mem[ TBSeg : TBOfs + LOfs ];


       FreeMem( TBuf , MSize);

       Inc( TOfs, MSize );

      End; { if ... = DInputLine then }

     if DialogItems[ i ]^.ObjType = DRadioButton then
      Begin

       DialogItems[ i ]^.GetData( TBuf, Size );

       TBSeg := Seg( TBuf^ );
       TBOfs := Ofs( TBuf^ );

       Mem [ RSeg : ROfs + TOfs ] := Mem [ TBSeg : TBOfs ];

       Inc( TOfs, Size );

      End;{ if ... = DRadioButton then }


     if DialogItems[ i ]^.ObjType = DCheckBoxes then
      Begin

       DialogItems[ i ]^.GetData( TBuf, Size );

       TBSeg := Seg( TBuf^ );
       TBOfs := Ofs( TBuf^ );

       MemW [ RSeg : ROfs + TOfs ] := MemW [ TBSeg : TBOfs ];

       Inc( TOfs, Size );

      End;{ if ... = DCheckBoxes then }

   End;



End;{ TDialog.GetData }

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

procedure TDialog.SetData( Var SData );

Var

  TBuf    : Pointer ;

  TBSeg,
  TBOfs   : Word;

  i, k,
  Size,
  RBB     : Byte ;

  CBB     : Word ;

  RSeg,
  ROfs,
  TOfs,
  LOfs    : Word ;

begin

  RSeg := Seg( SData );
  ROfs := Ofs( SData );

  TOfs := 0 ;

  for  i := 1 to DialogItemsNum do
   begin

     if DialogItems[ i ]^.ObjType = DInputLine then
      begin

       LOfs := 0;

       Size := DialogItems[ i ]^.GetSize;

       GetMem( TBuf, Size );

       TBSeg := Seg( TBuf^ );
       TBOfs := Ofs( TBuf^ );

       for LOfs := 0 to Size - 1  do
        Mem[ TBSeg : TBOfs + LOfs ] :=  Mem[ RSeg : ROfs + TOfs + LOfs ];

       DialogItems[ i ]^.SetData( TBuf^ );

       FreeMem( TBuf, Size );


       Inc( TOfs, Size );

      end; { if ... = DInputLine then }


    { ******************************************************* }

     if DialogItems[ i ]^.ObjType = DRadioButton then
      begin


       RBB := Mem [ RSeg : ROfs + TOfs ];

       DialogItems[ i ]^.SetData( RBB );

       Inc( TOfs, 1 );

      end;{ if ... = DRadioButton then }

    { ******************************************************* }

     if DialogItems[ i ]^.ObjType = DCheckBoxes then
      begin

       CBB := MemW [ RSeg : ROfs + TOfs ];

       DialogItems[ i ]^.SetData( CBB );

       Inc( TOfs, 2 );


      end;{ if ... = DCheckBoxes then }

   end;
end;{ TDialog.SetData }

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

procedure TDialog.StatusLine( SStr : String );
Var
  WMin, WMax : Word;
begin

  WMin := WindMin;
  WMax := WindMax;

  Window( 1, 1, VideoXRes, VideoYRes + 1 );

  WriteChar( 1, VideoYRes + 1 , VideoXRes,' ', TDialogStatLineText);

  If Length( SStr ) = 0 Then
    begin
      Window( Lo( WMin ) + 1, Hi( WMin ) + 1,
              Lo( WMax ) + 1, Hi( WMax ) + 1);
      exit;
    end;

  ColorPut( 2, VideoYRes +  1, SStr , TDialogStatLineText,TDialogStatLineAcText );

  Window( Lo( WMin ) + 1, Hi( WMin ) + 1,
          Lo( WMax ) + 1, Hi( WMax ) + 1);

end;

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

procedure TDIalog.PutOptions( OStr : String );
begin

  WriteChar(70,25,20,' ', TDialogLineText);

  If Length( OStr ) = 0 Then exit;

  WriteStr(  70 , 25, ' ' + OStr + ' ', TDialogOptText );

end;

End.{ Dialog }