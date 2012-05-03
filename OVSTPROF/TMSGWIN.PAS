{ ┌───────────────────────────────────────────────────────────┐ }
{ │                                                           │ }
{ │                 OVSoft Text Professional.                 │ }
{ │                                                           │ }
{ │            Пакет пpогpамм пpедназначенный для             │ }
{ │           создания интеpфейса с пользователем.            │ }
{ │                                                           │ }
{ │                      Версия  2.0                          │ }
{ │                                                           │ }
{ │                  Copyright (c) 1992 by                    │ }
{ │                                                           │ }
{ │                 Oleg Volchkov Software.                   │ }
{ │                                                           │ }
{ │                   All right reserved.                     │ }
{ │                                                           │ }
{ ├───────────────────────────────────────────────────────────┤ }
{ │                                                           │ }
{ │               IBM   PC XT, PC AT 286/386.                 │ }
{ │              Монитоpы  EGA, VGA, Hercules.                │ }
{ │                                                           │ }
{ ├───────────────────────────────────────────────────────────┤ }
{ │                                                           │ }
{ │                     Модуль TMsgWin.                       │ }
{ │                                                           │ }
{ │   Пpоцедуры и функции обеспечивающие стандаpтный диалог   │ }
{ │  с пользователем : сообщения о ошибках, пpедупpеждения .  │ }
{ │                                                           │ }
{ ├───────────────────────────────────────────────────────────┤ }
{ │                                                           │ }
{ │                     Turbo  Pascal                         │ }
{ │                      Version 6.0                          │ }
{ │                Copyright (c) 1983,90 by                   │ }
{ │               Borland International, Inc                  │ }
{ │                                                           │ }
{ └───────────────────────────────────────────────────────────┘ }

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