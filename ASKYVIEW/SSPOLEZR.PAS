{$F+,O+}

Unit SSPoleZr;

Interface

Uses Crt, SSVar, TDialogs,
     TStdObj, SSError, TMsgWin,
     TColors;

procedure SetPoleZr;

Implementation

procedure SetPoleZr;
Label
 BegDialog;
Type

 SSPZ          = Record

  RazmPolX        : String[ 7 ];
  RazmPolY        : String[ 7 ];

  OrientX        : String[ 7 ];
  OrientY        : String[ 7 ];

  RazmDopRamkX    : String[ 7 ];
  RazmDopRamkY    : String[ 7 ];

 end;

Var
  Dialog : PDialog;
  Bruce  : PView  ;
  R      : TRect  ;

  SPZ    : SSPZ ;

  X,Y,
  LX,LY,
  BX,BY,
  L,LLX,
  i,
  d1,d2,
  d3,d4,
  d5,d6    : Byte ;

  ExitCode : Word;

  Old : TPoleZr;

begin

 Old := PoleZr;

 If ( PoleZr.RazmPolX >= 1.0 )
   Then  Str( PoleZr.RazmPolX :7:3, SPZ.RazmPolX )
   Else  Str( PoleZr.RazmPolX :7:5, SPZ.RazmPolX );
 If ( PoleZr.RazmPolY >= 1.0 )
   Then  Str( PoleZr.RazmPolY :7:3, SPZ.RazmPolY )
   Else  Str( PoleZr.RazmPolY :7:5, SPZ.RazmPolY );

 Str( PoleZr.OrientX :7, SPZ.OrientX );
 Str( PoleZr.OrientY :7, SPZ.OrientY );

 If ( PoleZr.RazmDopRamkX >= 1.0 )
   Then Str( PoleZr.RazmDopRamkX :7:3, SPZ.RazmDopRamkX )
   Else Str( PoleZr.RazmDopRamkX :7:5, SPZ.RazmDopRamkX );
 If ( PoleZr.RazmDopRamkY >= 1.0 )
   Then Str( PoleZr.RazmDopRamkY :7:3, SPZ.RazmDopRamkY )
   Else Str( PoleZr.RazmDopRamkY :7:5, SPZ.RazmDopRamkY );

 R.Assign( 1, 1, 47, 15 );
{
 Dialog := New( PDialog , Init( R, ' ®«¥ §à¥­¨ï( ¢ £à ¤ãá å ). ' , jcCentered ));
}
 Dialog := New( PDialog , Init( R, ' Field of view (in degree) ' , jcCentered ));


 With Dialog^ do
  Begin

   BX := 17;
   BY := 8;

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
                      'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ             ÄÄÄÄÄÄÄÄÄÄÄÄ¿'#13 +
                      '³                                        ³'#13 +
                      'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'#13 )));

   TStaticTextNormalAttr  :=  Magenta + LightGray * 16;
   R.Assign( LLX + 16, LY, LLX + 10, Y+1 );
{
   Insert(New(PStaticText,Init(R,' §¬¥à ¯®«ï'#13 )));
}
   Insert(New(PStaticText,Init(R,'  Dimension  '#13 )));


   Inc( LY );

   L := 7;

   R.Assign( X, Y, X + L + 2, Y+1 );
   Bruce := New( PInputLine, Init( R, L ));
   R.Assign( LX, LY, X , LY+1 );
   Bruce^.InitLabel( R, '   Ax X' );

   Insert( Bruce );

   L := 7;

   R.Assign( X + L + 2 + 2 + 9         ,   Y,
             X + L + 2 + 2 + 9 + L + 2 , Y+1 );
   Bruce := New( PInputLine, Init( R, L ));
   R.Assign( X + L + 2 + 2, LY, X , LY+1 );
   Bruce^.InitLabel( R, '   Ax Y' );
   Insert( Bruce );
   Inc(LY,2);
   Inc( Y, 3 );


{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

   TStaticTextNormalAttr  :=  Black + LightGray * 16;

   R.Assign( LLX, LY, LLX + 10, Y+1 );
   Insert(New(PStaticText,Init(R,
                      'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ               ÄÄÄÄÄÄÄÄÄÄÄ¿'#13 +
                      '³                                        ³'#13 +
                      'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'#13 )));

   TStaticTextNormalAttr  :=  Magenta + LightGray * 16;
   R.Assign( LLX + 17, LY, LLX + 10, Y+1 );
   Insert(New(PStaticText,Init(R,'Orientation'#13 )));

   Inc( LY );

   L := 7;

   R.Assign( X, Y, X + L + 2, Y+1 );
   Bruce := New( PInputLine, Init( R, L ));
   R.Assign( LX, LY, X , LY+1 );
   Bruce^.InitLabel( R, '   Ax X' );
   Insert( Bruce );

   L := 7;

   R.Assign( X + L + 2 + 2 + 9         ,   Y,
             X + L + 2 + 2 + 9 + L + 2 , Y+1 );
   Bruce := New( PInputLine, Init( R, L ));
   R.Assign( X + L + 2 + 2, LY, X , LY+1 );
   Bruce^.InitLabel( R, '   Ax Y' );
   Insert( Bruce );
   Inc(LY,2);
   Inc( Y, 3 );


{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

   TStaticTextNormalAttr  :=  Black + LightGray * 16;

   R.Assign( LLX, LY, LLX + 10, Y+1 );
   Insert(New(PStaticText,Init(R,
                      'ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ                 ÄÄÄÄÄÄÄÄÄÄ¿'#13 +
                      '³                                        ³'#13 +
                      'ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ'#13 )));

   TStaticTextNormalAttr  :=  Magenta + LightGray * 16;
   R.Assign( LLX + 15, LY, LLX + 10, Y+1 );
   If (    ( Regims.PzsInFOV      = 1 )
        Or ( Regims.Object_Tracks = 1 )  )
     Then Insert(New(PStaticText,Init(R,' Max P.M. ArcSec '#13 )))
     Else Insert(New(PStaticText,Init(R,'Frame additional '#13 )));

   Inc( LY );

   L := 7;

   R.Assign( X, Y, X + L + 2, Y+1 );
   Bruce := New( PInputLine, Init( R, L ));
   R.Assign( LX, LY, X , LY+1 );
   Bruce^.InitLabel( R, '   Ax X' );
   Insert( Bruce );

   L := 7;

   R.Assign( X + L + 2 + 2 + 9         ,   Y,
             X + L + 2 + 2 + 9 + L + 2 , Y+1 );
   Bruce := New( PInputLine, Init( R, L ));
   R.Assign( X + L + 2 + 2, LY, X , LY+1 );
   Bruce^.InitLabel( R, '   Ax Y' );
   Insert( Bruce );

   Inc(LY,2);
   Inc( Y, 3 );


   R.Assign( X+5,Y,X + 18,Y + 1);
   Bruce := New( PButton, Init( R,'OK', bfNormal, cmOk ));
   Insert( Bruce );

   R.Assign( X + 19 ,Y,X + 14 + 18, Y + 1);
   Bruce := New( PButton, Init( R,'Cancel', bfNormal, cmCancel ));
   Insert( Bruce );


{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }


   InsFlag := False;
   TStaticTextNormalAttr  :=  Black + LightGray * 16;

   SetData( SPZ );

BegDialog: ;

   ExitCode := Run;

   If ExitCode = cmCancel Then
     PoleZr := Old;

   If ExitCode <> cmCancel Then
    begin

     GetData( SPZ );

     d1 := 0;
     d2 := 0;
     d3 := 0;
     d4 := 0;
     d5 := 0;
     d6 := 0;


     For i := 1 to 7  do
      begin

       IF  I <= Length( SPZ.RazmPolX ) then
        case SPZ.RazmPolX [ i ] of
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

       IF  I <= Length( SPZ.RazmPolY ) then
        case SPZ.RazmPolY [ i ] of
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

       IF  I <= Length( SPZ.OrientX ) then
        case SPZ.OrientX [ i ] of
         '1','2',
         '3','4',
         '5','6',
         '7','8',
         '9','0',
         '+','-','.',#0 :Inc(D5);
         ' '     :;
         else
          begin

           EnterParamError;
           GoTo BegDialog ;

          end;
        end;

       IF  I <= Length( SPZ.OrientY ) then
        case SPZ.OrientY [ i ] of
         '1','2',
         '3','4',
         '5','6',
         '7','8',
         '9','0',
         '+','-','.',#0 :Inc(D6);
         ' '     :;
         else
          begin

           EnterParamError;
           GoTo BegDialog ;

          end;

        end;

       IF  I <= Length( SPZ.RazmDopRamkX  ) then
        case SPZ.RazmDopRamkX   [ i ] of
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

       IF  I <= Length( SPZ.RazmDopRamkY  ) then
        case SPZ.RazmDopRamkY   [ i ] of
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

      if d5 = 0 Then
       begin

        EnterParamError;
        GoTo BegDialog ;

       end;

      if d6 = 0 Then
       begin

        EnterParamError;
        GoTo BegDialog ;

       end;

      Val( SPZ.RazmPolX , PoleZr.RazmPolX , ExitCode );
      Val( SPZ.RazmPolY , PoleZr.RazmPolY , ExitCode );

      Val( SPZ.OrientX , PoleZr.OrientX , ExitCode );
      Val( SPZ.OrientY , PoleZr.OrientY , ExitCode );

      Val( SPZ.RazmDopRamkX , PoleZr.RazmDopRamkX , ExitCode );
      Val( SPZ.RazmDopRamkY , PoleZr.RazmDopRamkY , ExitCode );


    end;

 end;{ With Dialog^ }

Dispose( Dialog, Done );

end;{ SetPoleZr }

end.