{$F+,O+}

Unit SSFotPri;

Interface

Uses Crt, SSVar, TDialogs,
     TStdObj, SSError, TMsgWin,
     TColors;

procedure SetFotoPriemnik;

Implementation

procedure SetFotoPriemnik;
Label
 BegDialog;
Type

 SFotoPriemnik  = Record

  PeriodMatrX     : String[ 7 ] ;
  PeriodMatrY     : String[ 7 ] ;

  RazmPixX        : String[ 7 ] ;
  RazmPixY        : String[ 7 ] ;

  KolElemX        : String[ 5 ] ;
  KolElemY        : String[ 5 ] ;


 end;

Var
  Dialog : PDialog;
  Bruce  : PView  ;
  R      : TRect  ;

  SFP    : SFotoPriemnik ;

  X,Y,
  LX,LY,
  BX,BY,
  L,LLX,
  i,
  d1,d2,
  d3,d4    : Byte ;

  ExitCode : Word;

  Old : TFotoPriemnik;

begin

 Old := FotoPriemnik;

 Str( FotoPriemnik.PeriodMatrX : 6 : 3, SFP.PeriodMatrX );
 Str( FotoPriemnik.PeriodMatrY : 6 : 3, SFP.PeriodMatrY );
 Str( FotoPriemnik.RazmPixX    : 6 : 3, SFP.RazmPixX    );
 Str( FotoPriemnik.RazmPixY    : 6 : 3, SFP.RazmPixY    );
 Str( FotoPriemnik.KolElemX    , SFP.KolElemX    );
 Str( FotoPriemnik.KolElemY    , SFP.KolElemY    );


 R.Assign( 1, 1, 48, 14 );
 Dialog := New( PDialog , Init( R, ' CCD  dimensions in ArcMin ' , jcCentered ));

 With Dialog^ do
  Begin

   BX := 17;
   BY := 11;

   LX := 5;
   LY := 2;

   L := 7;
   X := 14;
   Y := 3;

   LLX := 3;


{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }
   TStaticTextNormalAttr  :=  Black + LightGray * 16;

   R.Assign( LLX, LY, LLX + 10, Y+1 );
   Insert(New(PStaticText,Init(R,
                      'ÚÄÄÄÄÄÄÄÄÄÄÄÄ                 ÄÄÄÄÄÄÄÄÄÄÄ¿'#13 +
                      '³                                        ³'#13 +
                      'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'#13 )));

   TStaticTextNormalAttr  :=  Magenta + LightGray * 16;

   R.Assign( LLX + 14, LY, LLX + 10, Y+1 );
{
   Insert(New(PStaticText,Init(R,'¥p¨®¤ ¬ âp¨æë'#13 )));
}
   Insert(New(PStaticText,Init(R,' Matrix period'#13 )));

   Inc( LY );

   L := 7;

   R.Assign( X, Y, X + L + 2, Y+1 );
   Bruce := New( PInputLine, Init( R, L ));
   R.Assign( LX, LY, X , LY+1 );
   Bruce^.InitLabel( R, ' Ax  X ' );
   Insert( Bruce );

   L := 7;

   R.Assign( X + L + 2 + 2 + 9         ,   Y,
             X + L + 2 + 2 + 9 + L + 2 , Y+1 );
   Bruce := New( PInputLine, Init( R, L ));
   R.Assign( X + L + 2 + 2, LY, X , LY+1 );
   Bruce^.InitLabel( R, ' Ax  Y ' );
   Insert( Bruce );
   Inc(LY,2);
   Inc( Y, 3 );

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

   TStaticTextNormalAttr  :=  Black + LightGray * 16;
   R.Assign( LLX, LY, LLX + 30 + 2, Y+1 );
   Insert(New(PStaticText,Init(R,
                            'ÚÄÄÄÄÄÄÄÄÄÄÄÄ                 ÄÄÄÄÄÄÄÄÄÄÄ¿'#13 +
                            '³                                        ³'#13 +
                            'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'#13 )));

   TStaticTextNormalAttr  :=  Magenta + LightGray * 16;
   R.Assign( LLX + 14, LY, LLX + 10, Y+1 );
{
   Insert(New(PStaticText,Init(R,' §¬¥p ¯¨ªá¥«ï'#13 )));
}
   Insert(New(PStaticText,Init(R,'Pixel dimension'#13 )));

   Inc( LY );

   L := 7;

   R.Assign( X, Y, X + L + 2, Y+1 );
   Bruce := New( PInputLine, Init( R, L ));
   R.Assign( LX, LY, X , LY+1 );
   Bruce^.InitLabel( R, ' Ax  X ' );
   Insert( Bruce );

   L := 7;
   R.Assign( X + L + 2 + 2 + 9         ,   Y,
             X + L + 2 + 2 + 9 + L + 2 , Y+1 );

   Bruce := New( PInputLine, Init( R, L ));
   R.Assign( X + L + 2 + 2, LY, X , LY+1 );
   Bruce^.InitLabel( R, ' Ax  Y ' );
   Insert( Bruce );
   Inc( Y, 3 );
   Inc( LY, 2 );

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

   TStaticTextNormalAttr  :=  Black + LightGray * 16;
   R.Assign( LLX, LY, LLX + 30 + 2, Y+1 );
   Insert(New(PStaticText,Init(R,
                           'ÚÄÄÄÄÄÄÄÄÄÄÄ                  ÄÄÄÄÄÄÄÄÄÄÄ¿'#13 +
                           '³                                        ³'#13 +
                           'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'#13 )));

   TStaticTextNormalAttr  :=  Magenta + LightGray * 16;
   R. Assign( LLX + 11, LY, LLX + 10, Y+1 );
{
   Insert(New(PStaticText,Init(R,'Š®«¨ç¥áâ¢® í«¥¬¥­â®¢'#13 )));
}
   Insert(New(PStaticText,Init(R,'  Number of pixels'#13 )));

   Inc( LY );

   L := 5;

   R.Assign( X, Y, X + L + 2, Y+1 );
   Bruce := New( PInputLine, Init( R, L ));
   R.Assign( LX, LY, X , LY+1 );
   Bruce^.InitLabel( R, ' Ax  X ' );
   Insert( Bruce );

   L := 5;

   R.Assign( X + L + 2 + 4 + 9         ,   Y,
             X + L + 2 + 4 + 9 + L + 2 , Y+1 );
   Bruce := New( PInputLine, Init( R, L ));
   R.Assign( X + L + 4 + 2, LY, X + L + 2 + 4 + 9 + L + 2 , LY+1 );
   Bruce^.InitLabel( R, ' Ax  Y ' );
   Insert( Bruce );
   Inc( Y, 3 );
   Inc( LY, 2 );

{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

   R.Assign( BX,BY,BX + 13,BY + 1);
   Bruce := New( PButton, Init( R,' Ok ', bfNormal, cmOk ));
   Insert( Bruce );

   R.Assign( BX + 14 ,BY,BX + 14 + 13, BY + 1);
   Bruce := New( PButton, Init( R,' Cancel ', bfNormal, cmCancel ));
   Insert( Bruce );

   SetData(SFP);
   InsFlag := False;
   TStaticTextNormalAttr  :=  Black + LightGray * 16;

BegDialog: ;

   ExitCode := Run;

   If ExitCode = cmCancel Then
     FotoPriemnik := Old;


   If ExitCode <> cmCancel Then
    begin

     GetData(SFP);

     d1 := 0;
     d2 := 0;
     d3 := 0;
     d4 := 0;

     For i := 1 to 7  do
      begin

       IF  I <= Length( SFP.PeriodMatrX ) then
        case SFP.PeriodMatrX [ i ] of
         '1','2',
         '3','4',
         '5','6',
         '7','8',
         '9','0',
         '+','.',#0 :Inc(D1);
         ' '     :;
         else
          begin

           EnterParamError;
           GoTo BegDialog ;

          end;
        end;

       IF  I <= Length( SFP.PeriodMatrY ) then
        case SFP.PeriodMatrY [ i ] of
         '1','2',
         '3','4',
         '5','6',
         '7','8',
         '9','0',
         '+','.',#0 :Inc(D2);
         ' '     :;
         else
          begin

           EnterParamError;
           GoTo BegDialog ;

          end;

        end;

       IF  I <= Length( SFP.RazmPixX ) then
        case SFP.RazmPixX  [ i ] of
         '1','2',
         '3','4',
         '5','6',
         '7','8',
         '9','0',
         '+','.',#0 :Inc(D3);
         ' '     :;
         else
          begin

           EnterParamError;
           GoTo BegDialog ;

          end;

        end;

       IF  I <= Length( SFP.RazmPixY ) then
        case SFP.RazmPixY  [ i ] of
         '1','2',
         '3','4',
         '5','6',
         '7','8',
         '9','0',
         '+','.',#0 :Inc(D4);
         ' '     :;
         else
          begin

           EnterParamError;
           GoTo BegDialog ;

          end;

        end;

      end;

      if d1 = 0 Then
       begin

        EnterParamError;
        GoTo BegDialog ;

       end;

      if d2 = 0 Then
       begin

        EnterParamError;
        GoTo BegDialog ;

       end;

      if d3 = 0 Then
       begin

        EnterParamError;
        GoTo BegDialog ;

       end;

      if d4 = 0 Then
       begin

        EnterParamError;
        GoTo BegDialog ;

       end;

     d1 := 0;
     d2 := 0;

     For i := 1 to 5  do
      begin

       if i <= Length( SFP.KolElemX ) Then
        begin
        case SFP.KolElemX[ i ] of
         '1','2',
         '3','4',
         '5','6',
         '7','8',
         '9','0',
         '+' ,#0 :Inc(D1);
         ' '     :;
         else
          begin

           EnterParamError;
           GoTo BegDialog ;

          end;

        end;

       end;


       if  I <= Length( SFP.KolElemY )  Then
        begin
        case SFP.KolElemY[ i ] of
         '1','2',
         '3','4',
         '5','6',
         '7','8',
         '9','0',
         '+',#0 :Inc(D2);
         ' '     :;
         else
          begin

           EnterParamError;
           GoTo BegDialog ;

          end;

        end;
       end;

      if d1 = 0 Then
       begin

        EnterParamError;
        GoTo BegDialog ;

       end;

      if d2 = 0 Then
       begin

        EnterParamError;
        GoTo BegDialog ;

       end;
     end;
     Val( SFP.PeriodMatrX, FotoPriemnik.PeriodMatrX , ExitCode);
     Val( SFP.PeriodMatrY, FotoPriemnik.PeriodMatrY , ExitCode);
     Val( SFP.RazmPixX   , FotoPriemnik.RazmPixX    , ExitCode);
     Val( SFP.RazmPixY   , FotoPriemnik.RazmPixY    , ExitCode);
     Val( SFP.KolElemX   , FotoPriemnik.KolElemX    , ExitCode);
     Val( SFP.KolElemY   , FotoPriemnik.KolElemY    , ExitCode);

     end;
  end;

Dispose( Dialog,Done );

TStaticTextNormalAttr  :=  Black       +  LightGray * 16   ;

end;{ SetFotoPriemnik }


end.