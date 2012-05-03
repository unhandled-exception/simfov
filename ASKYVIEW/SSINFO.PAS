{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿ }
{ ³                                                                ³ }
{ ³    ASKYVIEW  Version 1.0a Copyright (c) 1992 by ASTROSOFT.     ³ }
{ ³                                                                ³ }
{ ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ }

{$F+,O+}

Unit SSInfo;

Interface

Uses SSVar, TDialogs, TStdObj, Dos , TUtil, TInfo ;


Procedure SystemInformation;

Implementation

Const

   CoProcArr : Array[ 1 .. 5 ] of String[6] = ( 'i8087','i80287','i80387','i80487','i80587');

Procedure SystemInformation;
Var

  Dialog : PDialog;
  Bruce  : PView;
  R      : TRect;
  ECode  : Word;

  CurDir : String[69];
  CurDrv : char;
  DosVer,DV1, DV2 : String;

  DSize,
  DFree  : String;

  PFS    : PathStr;

  CoProc,
  Computer,
  Proc    : String[20];

begin

  GetDir( 0, CurDir );
  CurDrv :=  CurDir[1];

  Str( DiskSize( 0 ) div 1024 : 8, DSize );
  Str( DiskFree( 0 ) div 1024 : 8, DFree );

  PFS := UpString( MainParamFileName );

  Proc := GetCPU;

  Computer := GetComputer;

{  If CoProcessor Then
    CoProc := 'present.'
      else
        CoProc := 'not present.';
 }

  If Test8087 = 0 Then
    CoProc := 'not present.'
      else
        CoProc := CoProcArr[ Test8087 ];



  R.Assign( 1, 1, 75, 16 );
  Dialog := New( PDialog, Init( R, ' Information ', jcCentered ));
  With Dialog^ do
    begin

      R.Assign( 3,2,1,1 );
      Bruce := New( PStaticText, Init( R,
        'Current directory : ' + CurDir + #13 +
        'Parameters file   : ' + PFS  + #13 +
        #13#13) );
      Insert( Bruce );

      R.Assign( 3,5,1,1 );
      Bruce := New( PStaticText, Init( R,
        'ÄÄÄÄÄÄÄÄÄÄÄÄ Disk ' + CurDrv + ': ÄÄÄÄÄÄÄÄÄÄ' + #13 +

        #13 + '  Total on disk  : ' + DSize + ' K' +
        #13 + '  Free           : ' + DFree + ' K' +
        #13 + '  DOS version    :      ' + GetDOSVersion +
        #13#13) );
      Insert( Bruce );

      R.Assign( 34,5,1,1 );
      Bruce := New( PStaticText, Init( R,
        '  ÄÄÄÄÄÄÄÄÄÄÄÄÄ Computer ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ' + #13 +
        #13 +'   Computer type : ' + Computer +
        #13 +'   Processor     : ' + Proc +
        #13 +'   Co-processor  : ' + CoProc +
        #13 +
        #13#13) );
      Insert( Bruce );

      R.Assign( 3,11,1,1 );
      Bruce := New( PStaticText, Init( R,
        'ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ'#13) );
      Insert( Bruce );

      R.Assign( 33, 13, 33 + 9, 14 );
      Bruce := New( PButton, Init( R, '~O~k', bfDefault, cmOk ));
      Insert( Bruce );

      ECode := Run;

    end;

  Dispose( Dialog, Done );

end;

end.