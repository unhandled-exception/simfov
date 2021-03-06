{$F+,O+}

Unit SSList;

Interface

Uses    Dos      , Crt     , PVar     ,
        PVarMenu , PWrParam , SSFile   ,
        SSVar    , SSError  , TStdObj  ,
        TDialogs , TUtil    , TDrivers ,
        TColors  , TMsgWin   ;

Const

  MaxParamFileRecord  =  200;
  StdConfigFileName   =  'USER.CFG';
  StdUserFileName     =  'USER.Par';
  ReadFileError       =  200;

  ListSelectFlag      : Boolean = False;

  PFLNormalText       : Byte =  White       + Blue   * 16 ;
  PFLAccentText       : Byte =  Black       + Cyan   * 16 ;
  PFLStatLineNorText  : Byte =  LightCyan   + Blue   * 16 ;
  PFLStatLineAccText  : Byte =  Yellow      + Blue   * 16 ;
  PFLHeaderText       : Byte =  Yellow      + Blue   * 16 ;



Type

   PParamFileRecord = ^TParamFileRecord;
   PParamUserRecord = ^ParamType;

   TParamFileRecord = Record

     ParamFileMemo  : String[ 76 ];

   End;{ ParamFileRecord }

{ 北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北 }
{ 北                                                                北 }
{ 北      庒 'オ� pс铋ī 岑ㄡ 錉┇ 癄p牞モp.     北 }
{ 北                                                                北 }
{ 北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北 }

   PParamFileList   =  ^TParamFileList ;
   TParamFileList   =  Object

     ConfigFileName : PathStr ; { 北北 埇� 錉┇� 岙ぅp楗． 岑ㄡ. 北北 }
     ConfigFile     : Text;     { 北北     敔┇ 岙ぅp楱� 岑ㄡ.   北北 }

     UserFileName   : PathStr ;          { 埇� 錉┇� 岙ぅp楗． 癄p牞モp� }
     UserFile       : File Of ParamType ;{     敔┇ 岙ぅp楱� 癄p牞モp�   }


     PFRecArray     : Array [ 1 .. MaxParamFileRecord ] Of PParamFileRecord ;
     PFUsrArray     : Array [ 1 .. MaxParamFileRecord ] Of PParamUserRecord ;


                                { 北北        懏♂猗キ 岑ㄡ.       北北 }
     ParamFileNum   : Word ;    { 北北  姰绁徕 幞� � 錉┇�.    北北 }
     ParamFileSel   : Word ;    { 北北   挜闋� ㈦牠瓲� 犰.     北北 }

     LastDirectory  : DirStr;

     OldRecSel      : Word;
     OldTSRec       : Word ;    { }
     OldParamFilenum: Word;

     RetCode        : Byte ;    { 北北    偖Бp犻牓� Л犵キē.       北北 }

     TSRec          : Word ;    { }

     PFLRect        : TRect;    { 北北       姰畃え瓲怆 瓲.          北北 }

     SVBuf          : Pointer;
     SVState        : WinState;

     constructor Init;

     Procedure DrawWindow;      { 北北          傠� 瓲.            北北 }
     Procedure DrawItem;        { 北北        傠� 幞�.           北北 }

     Procedure Run;             { 北北      悹‘鉅 岙 岑ㄡ�.         北北 }

     destructor Done;

     Procedure AddRecord;       { 北北   劗キē 屺 � 岑ㄡ.   北北 }
     Procedure EditRecord;      { 北北 惀╬牠ē 屺 ě 岑岐�. 北北 }
     Procedure DeleteRecord;    { 北北    摛牜キē 屺 ě 岑岐�.    北北 }

     Procedure SaveList;        { 北北      嚑犰 岑ㄡ獱 � 錉┇.      北北 }

     Procedure UnDrawWindow;    { 北北     摛牜キē 瓲 � 愍p牠�.     北北 }

   End;{ TParamFileList }

Var

  FileList : TParamFileList;

Procedure WFileList;

Implementation

Const

   VNum : Word = 0;

Procedure WFileList;
Begin

{ *************************************
  If VNum = 0  Then   VNum := VNum + 1;
 ************************************** }

  FileList.Init;
  FileList.Run;
  FileList.Done;


End;


constructor TParamFileList.Init;
Var

  PFRVar : TParamFileRecord;
  i      : Byte;
Begin

  ConfigFileName   :=  StdConfigFileName;
  UserFileName     :=  StdUserFileName;
  ParamFileNum     := 0;
  ParamFileSel     := 1;
  OldParamFileNum  := 1;
  OldRecSel        := 1;
  OldTSRec         := 1;
  TSRec            := 1;
  RetCode          := 0;

  PFLRect.Assign( 1,2,80,24 );

  LastDirectory   := '';

  Assign ( UserFile, UserFileName );
  Assign ( ConfigFile, ConfigFileName );

{$I-}
  Reset  ( ConfigFile );
{$I+}
  If IOResult <> 0 Then

    Begin  { ConfigFile Not Exist }
           { -------------------- }

      ReWrite  ( ConfigFile );
      ReWrite  ( UserFile );

      Exit;

    End    { ConfigFile Not Exist }
           { -------------------- }


   Else

    Begin  { ConfigFile Exist }
           { ---------------- }

       {$I-}
      Reset  ( UserFile );
       {$I+}

      If IOResult <> 0 Then

        Begin  { UserFile Not Exist }
               { -------------------- }

          RetCode := ReadFileError;

          Error( 45, 10, 31, 5 , #13^C'File ' + UserFileName +
                                            ' not found.'#13    );
          Exit;

        End ;  { UserFile Not Exist }
               { ------------------ }


    End ;  { ConfigFile Exist }
           { ---------------- }


       { 椻キē  ConfigFile }
       { 屯屯屯屯屯屯屯屯屯 }

  While ( Not Eof( ConfigFile ) ) and
        ( ParamFileNum < MaxParamFileRecord ) Do
    Begin

      ReadLn( ConfigFile, PFRVar.ParamFileMemo );

      Inc( ParamFileNum );

      New( PFRecArray[ ParamFileNum ] );
      PFRecArray[ ParamFileNum ]^ := PFRVar;

      Read ( UserFile , Param ) ;

      New( PFUsrArray[ ParamFileNum ] );
      PFUsrArray[ ParamFileNum ]^ := Param;

    End;

  Close( ConfigFile );
  Close( UserFile );


End;{ TParamFileList.Init }

{ 北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北� }

Procedure TParamFileList.DrawWindow;
Var
  W, H, I,size,t,n : Word;
  ST,st1     : String[8];

Begin

  With PFLRect Do
    Begin

      HiddenCursor;

      Window( A.X, A.Y, B.X, B.Y );
      FillWin( ' ', PFLNormalText  );

      W := B.X - A.X + 1;
      H := B.Y - A.Y + 1;

      WriteChar( 1, 1,     1, '�', PFLNormalText );
      WriteChar( 2, 1, W - 2, '�', PFLNormalText );
      WriteChar( W, 1,     1, '�', PFLNormalText );


      For I := 2 To h - 1 Do
        Begin

          WriteChar( 1, I, 1, '�', PFLNormalText );
          WriteChar( W, I, 1, '�', PFLNormalText );

        End;

 {     WriteChar( 2 , 3, W - 2,'�', PFLNormalText );
      WriteChar( 1, 3,    1, '�', PFLNormalText );
      WriteChar( W, 3,    1, '�', PFLNormalText );
  }

      WriteChar( 1, H,     1, '�', PFLNormalText );
      WriteChar( 2, H, W - 2, '�', PFLNormalText );
      WriteChar( W, H,     1, '�', PFLNormalText );

{      WriteChar( 2 , H - 2, W - 2,'�', PFLNormalText );
      WriteChar( 1, H - 2,    1, '�', PFLNormalText );
      WriteChar( W, H - 2,    1, '�', PFLNormalText );
 }
      WriteStr( 35,1,' Contents ', PFLHeaderText);

      Inc( WindMin, $0101 );
      Dec( WindMax, $0101 );

    End;

End;{ TParamFileList.Draw }

{ 北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北� }


Procedure TParamFileList.DrawItem;
Var
  W, H, I,size,t,n : Word;

Begin

  With PFLRect Do
    Begin

      H := 21 ;

      i := TSRec;

      If ParamFileNum = 0 Then
        Begin

          For N := 1 To H Do
            WriteChar( 1, N , 78, ' ', PFLNormalText );
          WriteStr( 34,10,'List is empty.', PFLNormalText );
          WriteStr( 18,12,' Please enter F2 for addition new parameters.', PFLNormalText );
          Exit;

        End;

       n := 1;
       i := 1 ;


      If ( ( OldRecSel <> ParamFileSel ) or ( OldParamFileNum <> ParamFileNum ) )
        { and ( OldRecSel <> 0 ) }Then
        begin
          WriteChar( 1, Byte( OldRecSel - OldTSRec + 1 ), 78, ' ', PFLNormalText  );
          WriteStr ( 2, Byte( OldRecSel - OldTSRec + 1 ), PFRecArray[ OldRecSel ]^.ParamFileMemo,
                                                         PFLNormalText );
        end;

      If ( TSRec <> OldTSRec ) or ( OldParamFileNum <> ParamFileNum ) Then
        Begin

          For N := 1 To H  Do
            WriteChar( 1, N, 78, ' ', PFLNormalText );

          n := 1;

          If ( ParamFileNum - TSRec + 1 ) >= h Then
            i := H
              else
                i := ParamFileNum;

          for n := 1 to i do
            Begin

              WriteChar( 1, n, 78, ' ', PFLNormalText  );
              WriteStr ( 2, n,PFRecArray[ TSRec - 1 + n ]^.ParamFileMemo,
                                                        PFLNormalText );
            End;
       end;


      If ( OldRecSel <> ParamFileSel ) or ( OldParamFileNum <> ParamFileNum ) Then
        begin
          WriteChar( 1, ParamFileSel - TSRec + 1, 78, ' ', PFLaccentText  );
          WriteStr ( 2, ParamFileSel - TSRec + 1, PFRecArray[ ParamFileSel ]^.ParamFileMemo,
                                                         PFLAccentText );
        end;

      If ( OldRecSel = ParamFileSel ) or ( OldParamFileNum = ParamFileNum ) Then
        begin
          WriteChar( 1, ParamFileSel - TSRec + 1, 78, ' ', PFLaccentText  );
          WriteStr ( 2, ParamFileSel - TSRec + 1, PFRecArray[ ParamFileSel ]^.ParamFileMemo,
                                                         PFLAccentText );
        end;

        End;



End;{ TParamFileList.Draw }

{ 北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北� }


Procedure TParamFileList.Run;
Var
  h   : byte;
  ch  : Word;
  PExitFlag : Boolean;

Begin

  PExitFlag := False;

{****************************************
  If VNum = 0 Then
    ParamFileNum := ParamFileNum - 1;
 **************************************** }

  H := 21;

  DrawWindow;
  DrawItem;


 While Not PExitFlag Do
   Begin

     OldRecSel       := ParamFileSel ;
     OldTSrec        := TSRec        ;
     OldParamFileNum := ParamFileNum ;

     ch := GetKey;
     Case ch Of

       kbEsc   : Begin

                   ListselectFlag := False;

                   UnDrawWindow;
                   Exit;

                 End;

       kbEnter : Begin

                   If ParamFileNum > 0 Then
                     Begin

                       With PFRecArray[ ParamFileSel ]^ Do
                         Begin

                           MainParamFileMemo := ParamFileMemo;
                           MainParamFileName := '';

                         End;

                       ListSelectFlag := False ;


                         { 椻キē 屺 ě 瑺後á� 癄p牞モp }
                         { 哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪� }

                       If ( DateOld )
                         Then  DateNew := False
                         Else  DateNew := True ;

                       Param := PFUsrArray [ ParamFileSel ]^ ;
                       SetVarParameters ;

                       DateNew := True ;

                       UnDrawWindow;
                       Exit;

                     End;

                 End;{ kbEnter }

    kbF1    :;

    kbF2    : Begin

                AddRecord;
                ParamFileSel := ParamFileNum;
                If ParamFileNum > H Then
                  TSRec := ParamFileNum - H + 1
                    else
                      TSRec := 1 ;

              End;

    kbF4    : Begin

                EditRecord;
                DrawItem;

              End;


    kbF8    : Begin

                DeleteRecord;

              End;

    kbDn    : Begin

             {   If ParamFileSel = ParamfileNum then
                  begin

                    ParamFileSel := 1;
                    TSRec        := 1;

                  end
                   else
              }
                If ParamFileSel < ParamFileNum Then
                  begin
                    Inc( ParamFileSel );

                    If ( ParamFileSel - TSRec + 1 ) > H Then
                     Inc( TSRec );
                 end;

              End; { kbDn }

    kbUp    : Begin

              {  If ParamFileSel = 1 then
                  Begin

                    ParamFileSel := ParamFileNum ;
                    If ParamFileSel > h Then
                      TSRec := ParamFileSel - H + 1
                        Else
                          TSRec :=  1;

                  End
                    else
               }

                If ParamFileSel > 1 Then
                  begin
                    Dec( ParamFileSel );

                    If ( ParamFileSel < TSRec ) Then
                     Dec ( TSRec );
                  end;


              End; { kbUp }

     kbHome  : Begin

                 ParamFileSel := 1;
                 TSRec        := 1;

               End;{ kbHome }

     kbEnd   : Begin

                 ParamFileSel := ParamFileNum ;
                 If ParamfileSel > h Then
                  TSRec := ParamFileSel - H + 1
                    Else
                      TSRec :=  1;

               End;{ kbEnd }

     kbPgUp  : Begin

                 If ParamFileSel <= H Then
                   Begin

                     ParamFileSel := 1;
                     TSRec        := 1;

                   End
                  else
                 If  ParamFileSel > H Then
                   Begin

                     ParamFileSel := ParamFileSel - H + 1;

                     If  TSRec <= H   Then
                       TSRec := 1;

                     If TSRec > H Then
                       TSRec := TSRec - H + 1;

                   End;

               End;{ kbPgUp }

     kbPgDn  : Begin

                 If ( ParamFileSel + H - 1 ) >= ParamFileNum Then
                   Begin

                     ParamFileSel := ParamFileNum;

                     If ( ParamFileSel - H + 1 ) > 0 Then
                       TSRec := ParamFileSel - H + 1
                         Else
                           TSRec := 1;

                   End;

                 If (( ParamFileSel + H - 1 ) < ParamFileNum ) Then
                   Begin

                     ParamFileSel := ParamFileSel + H - 1;

                     If ( ParamFileSel - TSRec + 1 ) <= 0  Then
                       TSRec := 1;

                     If (( ParamFileSel - TSRec + 1 )  >= H ) Then
                       TSRec := ParamFileSel - H + 1;

                     If ( ParamFileSel - TSrec + 1 ) < H Then
                       Begin

                         ParamFileSel := ParamFileNum;

                         TSRec := ParamFileSel - H + 1;

                       End;
                   End;

               End;{ kbPgDn }

     End;{ Case ch }

    DrawItem;

   End;{ While Not PExitFlag }


End;{ TParamFileList.Run }


{ 北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北� }



          {     Add  Record    }
          {     苘苘苘苘苘�    }



Procedure TParamFileList.AddRecord;
Label BeginDialogWork;
Var

  NewRecord   :  TParamFileRecord ;
  Dialog   : PDialog;
  R        : TRect;
  Bruce    : PView;
  ECode    : Word;
  BX, EX,
  BY, i, k : Word;

Begin

  With NewRecord Do
    Begin
{
      ParamFileMemo := 'Not content.';
}
      ParamFileMemo := MainParamFileMemo ;

    End;

  R.Assign( 1, 1, 64, 8 );
  Dialog := New( PDialog, Init( R, ' Add record in file ', jcCentered ));
  With Dialog^ Do
    Begin

      BX := 3 ;
      BY := 3;
      EX := BX + 58;

      R.Assign( BX, BY, EX , BY + 1 );
      Bruce := New( PInputLine, Init( R , 76 ));
      R.Assign( BX, BY - 1, EX , BY );
      Bruce^.InitLabel( R, 'Content' );
      Insert( Bruce );

      BX := 3 ;
      EX := BX + 12;
      BY := 5;

      R.Assign( BX, BY, EX, BY + 1 );
      Bruce := New( PButton, Init( R, 'Add' , bfNormal , cmOk ));
      Insert( Bruce );

      BX := EX + 2  ;
      EX := BX + 11;
      BY := 5;

      R.Assign( BX, BY, EX, BY + 1 );
      Bruce := New( PButton, Init( R, 'Cancel', bfNormal , cmCancel ));
      Insert( Bruce );


      SetData( NewRecord );

 BeginDialogWork:;

      ECode := Run;

      If ECode <> cmCancel  Then
        Begin

          GetData( NewRecord );

          k := 0;

          If  ParamFileNum < MaxParamFileRecord Then
            Begin

                  Inc( ParamFileNum );

                  New( PFRecArray[ ParamFileNum ] );

                  PFRecArray[ ParamFileNum ]^ := NewRecord;


                     { 劗キē 屺 � 錉┇ 癄p牞モp }
                     { 哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪� }

                  WriteVarParameters;
                  New( PFUsrArray[ ParamFileNum ] );
                  PFUsrArray [ ParamFileNum ]^ := Param ;

            End;

        End;

    End;{ With Dialog^ Do }

  Dispose( Dialog, Done );

  SaveList;

End;{ TParamFileList.AddRecord }


{ 北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北� }



          {   Edit  Record   }
          {   苘苘苘苘苘苘   }


Procedure TParamFileList.EditRecord;
Label BeginDialogWork;
Var

  ERecord   :  TParamFileRecord ;
  Dialog   : PDialog;
  R        : TRect;
  Bruce    : PView;
  ECode    : Word;
  BX, EX,
  BY, i, k : Word;
  DFile : Text;

Begin

  If ParamFileNum = 0 Then Exit;

  ERecord :=  PFRecArray[ ParamFileSel ]^;

  R.Assign( 1, 1, 64, 8 );
  Dialog := New( PDialog, Init( R, ' Edit record in list ', jcCentered ));
  With Dialog^ Do
    Begin


      BX := 3 ;
      BY := 3;
      EX := BX + 58;

      R.Assign( BX, BY, EX , BY + 1 );
      Bruce := New( PInputLine, Init( R , 65 ));
      R.Assign( BX, BY - 1, EX , BY );
      Bruce^.InitLabel( R, 'Content' );
      Insert( Bruce );

      BX := 3 ;
      EX := BX + 11;
      BY := 5;

      R.Assign( BX, BY, EX, BY + 1 );
      Bruce := New( PButton, Init( R, 'Change' , bfNormal , cmOk ));
      Insert( Bruce );

      BX := EX + 2  ;
      EX := BX + 11;
      BY := 5;

      R.Assign( BX, BY, EX, BY + 1 );
      Bruce := New( PButton, Init( R, 'Cancel', bfNormal , cmCancel ));
      Insert( Bruce );


      SetData( ERecord );

      BeginDialogWork:;

      ECode := Run;

      If ECode <> cmCancel  Then
        Begin

          GetData( ERecord );

          k := 0;

          PFRecArray[ ParamFileSel ]^ := ERecord;

            { 帯キē 屺 � 錉┇� 癄p牞モp }
            { 哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪 }

          WriteVarParameters;
          PFUsrArray [ ParamFileSel ]^ := Param ;

        End;

    End;{ With Dialog^ Do }

  Dispose( Dialog, Done );

  SaveList;

End;{ TParamFileList.EditRecord }

{ 北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北� }




         {   Delete  Record   }
         {   苘苘苘苘苘苘苘   }


Procedure TParamFileList.DeleteRecord;
Label BeginDialogWork;
Var

  Dialog   : PDialog;
  R        : TRect;
  Bruce    : PView;
  ECode    : Word;
  BX, EX,
  BY, i, k,H : Word;
  DFile : Text;

Begin

  If ParamFileNum = 0 Then Exit;

  h := 15;

  R.Assign( 1, 1, 75, 7 );
  Dialog := New( PDialog, Init( R, ' Delete record from list ', jcCentered ));
  With Dialog^ Do
    Begin

      BX := 3;
      BY := 1;
      EX := BX ;

      R.Assign( BX, BY, EX, BY + 1 );
      Bruce := New( PStaticText,
        Init( R,
        #13' ' + PFRecArray[ ParamFileSel ]^.ParamFileMemo +
        #13 + #13 ));

      Insert( Bruce );

      BX := 3;
      EX := BX + 11 ;
      BY := 4 ;

      R.Assign( BX, BY, EX, BY + 1 );
      Bruce := New( PButton, Init( R, 'Delete' , bfNormal , cmOk ));
      Insert( Bruce );

      BX := EX + 2  ;
      EX := BX + 11;
      BY := 4;

      R.Assign( BX, BY, EX, BY + 1 );
      Bruce := New( PButton, Init( R, 'Cancel', bfNormal , cmCancel ));
      Insert( Bruce );

      ECode := Run;

      If ECode <> cmCancel  Then
        Begin

          For i := ParamFileSel + 1 To ParamFileNum Do
            Begin

              PFRecArray [ i - 1 ]^ :=  PFRecArray [ i ]^ ;
              PFUsrArray [ i - 1 ]^ :=  PFUsrArray [ i ]^ ;

            End ;

          Dispose( PFRecArray[ ParamFileNum ] );
          Dispose( PFUsrArray[ ParamFileNum ] );

          If ParamFileSel <= ParamFileNum Then
             ParamFileSel := ParamFileSel - 1;

          If ParamFileSel  = 0 Then
             ParamFileSel := 1;

          ParamFileNum := ParamFileNum - 1;

          If TSRec > 1 Then
            TSRec := TSRec - 1;

        End;

    End;{ With Dialog^ Do }

  Dispose( Dialog, Done );

  SaveList;

End;{ TParamFileList.DeleteRecord }

{ 北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北� }

Procedure TParamFileList.SaveList;
Var

  i : Byte;

Begin

{$I-}
  ReWrite( ConfigFile );
{$I+}

  If IOResult <> 0  Then
    Begin

      Error( 45, 10, 36, 5 , #13^C'Error at save list file on disk.'#13 );
      Exit;

    End;

{$I-}
  ReWrite( UserFile   );
{$I+}

  If IOResult <> 0  Then
    Begin

      Error( 45, 10, 36, 5 , #13^C'Error at save param file on disk.'#13 );
      Exit;

    End;

  For i := 1 To ParamFileNum Do
    Begin

      With PFRecArray[ i ]^ Do
        WriteLn ( ConfigFile, ParamFileMemo );

      Param := PFUsrArray [ i ]^ ;
      Write ( UserFile , Param ) ;

    End;

  Close( ConfigFile );
  Close( UserFile   );

End;{ TParamFileList.SaveList }



{ 北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北� }

Procedure TParamFileList.UnDrawWindow;
Begin

  Window( 1, 2, 80, 24 );
  FillWin( DeskTopFillChar, DeskTopNormalText );
  Window( 1, 1, 80, 25 );

End;

{ 北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北� }

destructor TParamFileList.Done;
Var i : byte;
Begin

 For i := 1 To ParamFileNum  Do
   Begin
     Dispose( PFRecArray[ i ] );
     Dispose( PFUsrArray[ i ] );
   End ;

End;



End.

