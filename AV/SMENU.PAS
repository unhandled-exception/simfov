
{$F+}

Unit SMenu;

Interface

Function SatMenu( Var stp : Double; page : byte ) : boolean;
Procedure WriteFieldData;

Implementation
Uses
 Dos, Crt, Graph, PVar,
 GLib, MLib, MDef, PMenu, Screen, Info, PProFld, POutFld, Service, POscreen ;

Const
 SMItems : Word = 5 ;

Var
 SatDir  : Integer      ;
 NoTrace : TraceType    ;
 CHelp   : CHelpType    ;
 Desc    : MenuDescType ;
 ExitSatM: Boolean      ;
 I       : byte         ;
 icount  : byte         ;
 IndSM   : Byte         ;
 VMvMax,
 VMvMin  : Double       ;


Procedure SetExitTrue ;
Begin

   If ( CalcVectDiagr ) Then
     Begin
       CalcVectDiagr := False      ;
       ClearScr      := True       ;
       GScale        := VScale     ;
       NScaleArr     := NVScaleArr ;
       CenterX       := VCenterX   ;
       CenterY       := VCenterY   ;
       MvMax         := VMvMax     ;
       MvMin         := VMvMin     ;
       For I := 1 To NVScaleArr Do
         Begin
           GScaleArr   [ I ] := VScaleArr   [ I ] ;
           GScaleArrCx [ I ] := VScaleArrCx [ I ] ;
           GScaleArrCy [ I ] := VScaleArrCy [ I ] ;
         End ;
     End ;


  If ( B_Object_Tracks )  Then
     NStepTracks  := 1    ;

  ExitSatM     := True ;

End;


Procedure WriteFieldData;
Begin
   message ( 'Write Outfile...', True ) ;
   {
   If ( B_Matrix )
     Then  OutFld
     Else  OutputFieldData;
   }
   OutputFieldData;
   message ( 'End Write Outfile...', False ) ;
   Sound ( 1000 ) ;
   Delay (   20 ) ;
   NoSound        ;
End ;


Procedure InfoChoice;
Begin
 ObjectInfo;
 UngetCh(ESCKEY);
End;


Procedure WriteVectDiagr ;
Begin

 CalcVectDiagr := Not CalcVectDiagr ;

 If ( CalcVectDiagr )
   Then
     Begin
       VScale     := GScale    ;
       NVScaleArr := NScaleArr ;
       VCenterX   := CenterX   ;
       VCenterY   := CenterY   ;
       VMvMax     := MvMax     ;
       VMvMin     := MvMin     ;
       For I := 1 To  NScaleArr  Do
         Begin
           VScaleArr   [ I ] := GScaleArr   [ I ] ;
           VScaleArrCx [ I ] := GScaleArrCx [ I ] ;
           VScaleArrCy [ I ] := GScaleArrCy [ I ] ;
         End ;

       CenterX    := 0.0  ;
       CenterY    := 0.0  ;
       GScale     := C10  ;
       NScaleArr  := 0    ;
       ClearScr   := True ;

       OScreen  ;

     End
   Else
     Begin

       GScale     := VScale     ;
       NScaleArr  := NVScaleArr ;
       CenterX    := VCenterX   ;
       CenterY    := VCenterY   ;
       MvMax      := VMvMax     ;
       MvMin      := VMvMin     ;
       For I := 1 To NVScaleArr Do
         Begin
           GScaleArr   [ I ] := VScaleArr   [ I ] ;
           GScaleArrCx [ I ] := VScaleArrCx [ I ] ;
           GScaleArrCy [ I ] := VScaleArrCy [ I ] ;
         End ;
       ClearScr   := True ;
       OScreen  ;
     End ;

 NStepTracks := 1 ;

 UngetCh ( ESCKEY );

End;

Procedure SHelp ( Msg : DirStr );
Begin
 With MenuColor Do
   PutS ( mess_w, true, hbackc, hforec, CenterText, CenterText, msg ) ;
End;

Procedure StepForward ;
Begin
 SatDir   :=  1   ;
 Reenter  := True ;
 ExitSatM := True ;
 CalcVectDiagr := False ;
End;

Procedure StepBackward;
Begin
 SatDir   :=  -1  ;
 Reenter  := True ;
 ExitSatM := True ;
 CalcVectDiagr := False ;
End;


Procedure StepMenu;

const
 StepItems = 2;

Var
 stepm : menutype    ;
 stepd : menudesctype;
 Ind   : byte        ;
 EscH  : Boolean     ;

Begin

 With stepd Do
 Begin
  con := False;
  ulx := desc.ulx+4;
  uly := desc.uly+5;
  lrx := ulx+20    ;
  lry := uly+2     ;
 End;

 AllocMenu ( stepitems, stepm );

 With stepm[1]^ Do
 Begin
  TextString:='Forward';
  HelpText  :='';
  Activity  := mn_ext;
  Proc      := StepForward;
 End;

 With stepm[2]^ Do
 Begin
  TextString:='Backward';
  HelpText  :='';
  Activity  := mn_ext;
  Proc      := StepBackward;
 End;

 Ind := Menu(stepd,MenuColor,StepItems,NoTrace,CHelp,stepm,EscH);
 FreeMenu(StepItems,stepm);
 shelp('');
End;


Function SatMenu( Var stp : Double; page : byte ) : boolean;
Var
 SM     : MenuType    ;
 EscH   : Boolean     ;
 fc,bc  : byte        ;
Begin

 If ( B_VectDiagr )
    Then  SMItems := 6
    Else  SMItems := 5 ;


 {  Расположение Главного меню }

 menu_w := imenuw  ;
 initmw ( menu_w ) ;
 ExitSatM := False ;

 if stp > 0.0
    then SatDir :=   1
    else SatDir := - 1 ;

 Reenter:=False;

 With Desc Do
 Begin
  con := False;
  ulx := menu_w.wnd.x1 div 8 + 1 ;
  lrx := ulx+14;
  uly := (menu_w.wnd.y1 + 3 * textheight('1')) div 10   ;
  lry :=  uly + SMItems + 1;
 End ;

 AllocMenu ( SMItems, SM ) ;

 icount := 1 ;

 With SM [ ICount ]^ Do
 Begin
  TextString := 'Continue';
  HelpText   := '';
  Activity   :=  mn_ext  ;
  Proc       :=  SetExitTrue;
  Inc ( ICount ) ;
 End;


 With SM [ ICount ]^ Do
 Begin
  TextString := 'Info';
  HelpText   := 'Get objects info';
  Activity   :=  mn_exe;
  Proc       :=  InfoChoice  ;
  Inc ( ICount ) ;
 End;


 If ( B_VectDiagr )  Then
 With SM [ ICount ]^ Do
 Begin
  TextString := 'Diag P.M.';
  HelpText   := 'Vector diagram P.M.';
  Activity   :=  mn_ext;
  Proc       :=  WriteVectDiagr;
  Inc ( ICount ) ;
 End;


 With SM [ ICount ]^ Do
 Begin
  TextString := 'Step';
  HelpText   := 'Time - step';
  Activity   :=  mn_ext;
  Proc       :=  StepMenu;
  Inc ( ICount ) ;
 End;


 With SM [ ICount ]^ Do
 Begin
  TextString := 'Output';
  HelpText   := 'Data output';
  Activity   :=  mn_exe;
  Proc       :=  WriteFieldData;
  Inc ( ICount ) ;
 End;


 With SM [ ICount ]^ Do
 Begin
  TextString := 'Exit';
  HelpText   := 'Exit in main menu';
  Activity   :=  mn_ext;
  Proc       :=  SetExitTrue;
  Inc ( ICount ) ;
 End;

 InitMVars;

 Repeat
   IndSM := Menu ( Desc, MenuColor, SMItems, NoTrace, CHelp, SM,EscH ) ;
 Until ExitSatM;

 FreeMenu ( SMItems, SM ) ;

 ClearMw ( menu_w ) ;

 For  I := 0  To NGPages - 1  Do
  Begin
    SetActivePage ( I ) ;
    prw := iprw ;
    initmw ( prw ) ;
  End;

 If ( IndSM <> SMItems )  Then
   Begin

     OScreen  ;
{
     History;
}
   End ;

 Stp     := Abs ( Stp ) * SatDir ;
 SatMenu := ( IndSM = SMItems ) ;


End;  { SatMenu }

Begin

 NoTrace.Required := False;

 With CHelp Do
  Begin
    present := true;
    proc    := SHelp;
  End;

 Reenter := False;

End.
