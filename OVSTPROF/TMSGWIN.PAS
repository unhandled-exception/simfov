{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴� }
{ �                                                           � }
{ �                 OVSoft Text Professional.                 � }
{ �                                                           � }
{ �            룧ぅ� 칛�즤젹� 칛ⅳ췅㎛좂���硫 ㄻ�             � }
{ �           貰ℓ젺⑨ Þ收p芯⒰� � ��レ㎜쥯收ゥ�.            � }
{ �                                                           � }
{ �                      궏褻⑨  2.0                          � }
{ �                                                           � }
{ �                  Copyright (c) 1992 by                    � }
{ �                                                           � }
{ �                 Oleg Volchkov Software.                   � }
{ �                                                           � }
{ �                   All right reserved.                     � }
{ �                                                           � }
{ 쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴� }
{ �                                                           � }
{ �               IBM   PC XT, PC AT 286/386.                 � }
{ �              뙫�ⓥ췴�  EGA, VGA, Hercules.                � }
{ �                                                           � }
{ 쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴� }
{ �                                                           � }
{ �                     뙫ㅳレ TMsgWin.                       � }
{ �                                                           � }
{ �   뢱�璵ㅳ贍 � 押�ゆĿ �‥召ηÐ좐蟯� 飡젺쩆p狩硫 ㄸ젷��   � }
{ �  � ��レ㎜쥯收ゥ� : 貰�↓��⑨ � �鼇―졾, 칛ⅳ承pⅵㄵ�⑨ .  � }
{ �                                                           � }
{ 쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴� }
{ �                                                           � }
{ �                     Turbo  Pascal                         � }
{ �                      Version 6.0                          � }
{ �                Copyright (c) 1983,90 by                   � }
{ �               Borland International, Inc                  � }
{ �                                                           � }
{ 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴� }

{$F+,O+}
Unit TMsgWin ;
Interface

Uses Crt, TStdObj, TDialogs ;

Type

  TMsgWinString = String [ 40 ];

Procedure Error( EX, EY, W, H : Byte; ErrorString : String );
Procedure Message( MX, MY, W, H : Byte; MessageString : String );

Implementation

Procedure Error( EX, EY, W, H : Byte; ErrorString : String );
Var

 ErrorDialog : PDialog ;
 R           : TRect   ;

 ReturnCode  : Word    ;

 X,Y,N,I     : Byte    ;

Begin


 If W < 16 Then W := 16 ;
 If H < 6  Then H :=  6 ;

 R.Assign( EX, EY, EX + W, EY + H );
 ErrorDialog := New( PDialog, Init( R, ' Error ', jcCentered));
 With ErrorDialog^ do
  begin

   R.Assign( 1,1,2,2 );
   Insert( New( PStaticText, Init( R, ErrorString )));

   R.Assign( ( W div 2 ) - 5 + 1, H - 2, ( W div 2 ) + 5 + 2, H - 1 );
   Insert( New( PButton, Init( R, '~O~k', cmOk, bfNormal )));

   ReturnCode := Run;

  end;

 Dispose( ErrorDialog, Done );

End;{ Error }

Procedure Message( MX, MY, W, H : Byte; MessageString : String );
Var

 MessageDialog : PDialog ;
 R           : TRect   ;

 ReturnCode  : Word    ;

 X,Y,N,I     : Byte    ;

Begin


 If W < 16 Then W := 16 ;
 If H < 6  Then H :=  6 ;

 R.Assign( MX, MY, MX + W, MY + H );
 MessageDialog := New( PDialog, Init( R, ' Message ', jcCentered));
 With MessageDialog^ do
  begin

   R.Assign( 1,1,2,2 );
   Insert( New( PStaticText, Init( R, MessageString )));

   R.Assign( ( W div 2 ) - 5 + 1, H - 2, ( W div 2 ) + 5 + 2, H - 1 );
   Insert( New( PButton, Init( R, '~O~k', cmOk, bfNormal )));

   ReturnCode := Run;

  end;

 Dispose( MessageDialog, Done );

End;{ Message }




end.