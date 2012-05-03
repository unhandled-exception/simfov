{$F+,O+}

Unit SSRegims;
Interface

Uses SSVar, TDialogs, TStdObj;

Procedure SetRegims ;


Implementation

Type

 CRegims   = Record

    OutFOV        : Word ;
    Object_Tracks : Word ;
    DetCdc        : Word ;
    DetImp        : Word ; { 0 - Hе отожд,  1 - Все           }
    StopNoDet     : Word ; { 0 - Hе Stop ,  1 - Stop пpи неот }
    PzsInFOV      : Word ;
    Corr_Fot_Sys  : Word ;
    Color_A1_0    : Word ;
    NPolFix       : Word ;

    NNGrImpBeg    : String [ 8 ] ;

    ImportStar    : Word    ; { 0 - Hе вводить }

 End;


Procedure SetRegims ;

Var

  Dialog   : PDialog ;

  Bruce    : PView   ;

  R        : TRect   ;

  Y        : Byte    ;
  ExitCode : Word    ;

  Rec  : CRegims ;

Begin

With Rec Do
Begin

    OutFOV        := Regims.OutFOV And 1  ;
    Object_Tracks := Regims.Object_Tracks ;
    DetCdc        := Regims.DetCdc        ;
    DetImp        := Regims.DetImp        ;
    PzsInFov      := Regims.PzsInFov      ;
    StopNoDet     := Regims.StopNoDet     ;
    Corr_Fot_Sys  := Regims.Corr_Fot_Sys  ;
    Color_A1_0    := ( Regims.OutFOV Div 2 ) Mod 2 ;
    NPolFix       := Regims.NPolFix       ;

    Str( NGrImpBeg, NNGrImpBeg );

End;

{
 R.Assign( 1, 1, 44, 15 );

 If ( PassW )
   Then  R.Assign( 1, 1, 46, 16 )
   Else  R.Assign( 1, 1, 46, 11 ) ;
}

 R.Assign( 1, 1, 46, 17 ) ;

 Dialog := New( PDialog , Init( R, ' Modes ', jcCentered ));

 Y := 2 ;

 With Dialog^ Do
  Begin

   R.Assign( 3, Y, 44, Y+1 );
   Inc ( Y ) ;
   Bruce := New( PCheckBoxes, Init( R ));
   With Bruce^ Do
    Begin

     NewSItem('Out field of view');

    End;
   Insert( Bruce );

{
   If ( PassW )  Then
     Begin
}
       R.Assign( 3, Y, 44, Y+1 );
       Inc ( Y ) ;
       Bruce := New( PCheckBoxes, Init( R ));
       With Bruce^ Do
         Begin
           NewSItem( 'Object tracks ');
         End;
       Insert( Bruce );

       R.Assign( 3, Y, 44, Y+1 );
       Inc ( Y ) ;
       Bruce := New( PCheckBoxes, Init( R ));
       With Bruce^ Do
         Begin
           NewSItem('Galactic coordinates');
         End;
       Insert( Bruce );


       R.Assign( 3, Y, 44, Y+1 );
       Inc ( Y ) ;
       Bruce := New( PCheckBoxes, Init( R ));
       With Bruce^ Do
         Begin
           NewSItem('Determination import stars');
         End;
       Insert( Bruce );

       R.Assign( 3, Y, 44, Y+1 );
       Inc ( Y ) ;
       Bruce := New( PCheckBoxes, Init( R ));
       With Bruce^ Do
         Begin
           NewSItem('Stop if exist not det. stars');
         End;
       Insert( Bruce );

       R.Assign( 3, Y, 44, Y+1 );
       Inc ( Y ) ;
       Bruce := New( PCheckBoxes, Init( R ));
       With Bruce^ Do
         Begin
           NewSItem('Vector diagram of P.M.');
{          NewSItem('CCD in field of view');  }
         End;
       Insert( Bruce );
(*
     End ; { PassW }
*)

   R.Assign( 3, Y, 44, Y+1 );
   Inc ( Y ) ;
   Bruce := New( PCheckBoxes, Init( R ));
   With Bruce^ Do
    Begin

     NewSItem('Reduction photometric');

    End;
   Insert( Bruce );


   R.Assign( 3, Y, 44, Y+1 );
   Inc ( Y ) ;
   Bruce := New( PCheckBoxes, Init( R ));
   With Bruce^ Do
    Begin
     NewSItem('Color A2.0');
    End;
   Insert( Bruce );


   R.Assign( 3, Y, 44, Y+1 );
   Inc ( Y ) ;
   Bruce := New( PCheckBoxes, Init( R ));
   With Bruce^ Do
    Begin
     NewSItem('North Pol Y');
    End;
   Insert( Bruce );

   Inc ( Y ) ;
   R.Assign( 34, Y, 44 , Y+1 );
   Bruce := New( PInputLine , Init( R, 8 ));
   R.Assign( 3, Y, 30, Y+1 );
   Bruce^.InitLabel( R, 'Start number import star group' );
   Insert( Bruce );
   Inc ( Y ) ;

   Inc ( Y ) ;
   R.Assign(  3, Y, 14, Y+1);
   Bruce := New( PButton, Init( R,'Ok', bfNormal, cmQuit ));
   Insert( Bruce );

   R.Assign( 15, Y, 26, Y+1);

   Bruce := New( PButton, Init( R,'Cancel', bfNormal, cmCancel ));
   Insert( Bruce );

   SetData( Rec );

   ExitCode := Run ;

   If ExitCode <> cmCancel Then
    Begin

     GetData( Rec );

     With Rec Do
     Begin

       Regims.OutFOV        := OutFOV + Color_A1_0 * 2 ;
       Regims.Object_Tracks := Object_Tracks ;
       Regims.DetCdc        := DetCdc        ;
       Regims.DetImp        := DetImp        ;
       Regims.StopNoDet     := StopNoDet     ;
       Regims.PzsInFOV      := PzsInFOV      ;
{
       If ( PzsInFOV = 1 )  Then
         Begin
           Regims.Object_Tracks := 0 ;
           Object_Tracks := 0 ;
         End ;
}
       Regims.Corr_Fot_Sys  := Corr_Fot_Sys  ;
       Regims.NPolFix       := NPolFix       ;

       Val ( NNGrImpBeg, NGrImpBeg, ExitCode );

End;

    End;

  End;

 Dispose ( Dialog, Done ) ;

End;{ SetRegims }



End.