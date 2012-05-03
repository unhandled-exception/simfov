{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿ }
{ ³                                                                    ³ }
{ ³    ASKYVIEW  Version 1.0a Copyright (c) 1991, 92 by ASTROSOFT.     ³ }
{ ³                                                                    ³ }
{ ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ }

{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿ }
{ ³                                                                    ³ }
{ ³  à®æ¥¤ãà  ãáâ ­®¢ª¨ ¤¨à¥ªâ®à¨© ¤«ï ¯®¨áª  ª â «®£®¢.              ³ }
{ ³                                                                    ³ }
{ ³  ˆ¬ï       : SetCatalogDir.                                        ³ }
{ ³                                                                    ³ }
{ ³   à ¬¥âàë : ­¥â.                                                  ³ }
{ ³                                                                    ³ }
{ ³  Ž¯¨á ­¨¥  : ¯à®æ¥¤ãà  ¯®§¢®«ï¥â ¢¢®¤¨âì ¤¨à¥ªâ®à¨¨ ¤«ï ª â «®£®¢  ³ }
{ ³              BS, HD, GCVS, AK, GSC, IRedCat, Import .              ³ }
{ ³                                                                    ³ }
{ ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ }


{$F+,O+}

Unit SSCatDir;

Interface

   Uses SSVar, TDialogs, TStdObj;

   Procedure SetCatalogDir  ;

Implementation


    Var
         S : String [ 80 ] ;


    Procedure DelProb ;
   {ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ}
 Begin

    While (     ( Length ( S ) > 0  )
            And ( S [ 1 ]      = ' ')  )  Do
      Delete ( S, 1, 1 ) ;

    If ( Pos ( ' ', S ) <> 0 )  Then
      S := Copy ( S, 1, Pos ( ' ', S ) - 1  ) ;

 End ;

   Procedure SetCatalogDir ;

Var

  Dialog     : PDialog ;
  Bruce      : PView   ;
  R          : TRect   ;
  ExitCode   : Word    ;
  Y,X        : Byte    ;
  XMaxOkno   : Byte    ;
  CatDirFile : Text    ;

Begin
{
 R.Assign( 1, 1, 59, 25 );
}

 XMaxOkno := 45 ;

 {
 R.Assign ( 1, 1, XMaxOkno + 2, 19 );
 }
 R.Assign ( 1, 1, XMaxOkno + 3, 20 );
 Dialog := New ( PDialog , Init ( R, ' Directories ', jcCentered ));

 With Dialog^ Do
  Begin

   Y := 2;
   X := 15;


   { *************** Hip **************** }

   R.Assign( X, Y, XMaxOkno, Y  );
   Bruce := New( PInputLine, Init( R, 79 ));
   R.Assign( 3, Y,  5, Y  );
   Bruce^.InitLabel(R,'HIP');
   Insert( Bruce );
   Inc ( Y, 1 ) ;

   { *************** Tyc **************** }

   R.Assign( X, Y, XMaxOkno, Y  );
   Bruce := New( PInputLine, Init( R, 79 ));
   R.Assign( 3, Y,  5, Y  );
   Bruce^.InitLabel(R,'TYC');
   Insert( Bruce );
   Inc ( Y, 1 ) ;

   { *************** PPM **************** }

   R.Assign( X, Y, XMaxOkno, Y  );
   Bruce := New( PInputLine, Init( R, 79 ));
   R.Assign( 3, Y,  5, Y  );
   Bruce^.InitLabel(R,'PPM SAO');
   Insert( Bruce );
   Inc ( Y, 1 ) ;

   { *************** BS **************** }

   R.Assign( X, Y, XMaxOkno, Y  );
   Bruce := New( PInputLine, Init( R, 79 ));
   R.Assign( 3, Y,  5, Y  );
   Bruce^.InitLabel(R,'BS');
   Insert( Bruce );
   Inc ( Y, 1 ) ;

   { *************** HD **************** }

   R.Assign( X, Y, XMaxOkno, Y  );
   Bruce := New( PInputLine, Init( R, 79 ));
   R.Assign( 3, Y,  5, Y  );
   Bruce^.InitLabel(R,'HD');
   Insert( Bruce );
   Inc ( Y, 1 ) ;

   { *************** GCVS **************** }

   R.Assign( X, Y, XMaxOkno, Y  );
   Bruce := New( PInputLine, Init( R, 79 ));
   R.Assign( 3, Y,  5, Y  );
   Bruce^.InitLabel(R,'GCVS');
   Insert( Bruce );
   Inc ( Y, 1 ) ;

   { *************** AK **************** }

   R.Assign( X, Y, XMaxOkno, Y  );
   Bruce := New( PInputLine, Init( R, 79 ));
   R.Assign( 3, Y,  5, Y  );
   Bruce^.InitLabel(R,'AC');
   Insert( Bruce );
   Inc ( Y, 1 ) ;

   { *************** NPM **************** }

   R.Assign( X, Y, XMaxOkno, Y  );
   Bruce := New( PInputLine, Init( R, 79 ));
   R.Assign( 3, Y,  5, Y  );
   Bruce^.InitLabel(R,'NPM');
   Insert( Bruce );
   Inc ( Y, 1 ) ;

   { *************** NLTT **************** }

   R.Assign( X, Y, XMaxOkno, Y  );
   Bruce := New( PInputLine, Init( R, 79 ));
   R.Assign( 3, Y,  5, Y  );
   Bruce^.InitLabel(R,'NLTT');
   Insert( Bruce );
   Inc ( Y, 1 ) ;

   { *************** A10 **************** }

   R.Assign( X, Y, XMaxOkno, Y  );
   Bruce := New( PInputLine, Init( R, 79 ));
   R.Assign( 3, Y,  5, Y  );
   Bruce^.InitLabel(R,'A2.0');
   Insert( Bruce );
   Inc ( Y, 1 ) ;

   { *************** GSC **************** }

   R.Assign( X, Y, XMaxOkno, Y  );
   Bruce := New( PInputLine, Init( R, 79 ));
   R.Assign( 3, Y,  5, Y  );
   Bruce^.InitLabel(R,'GSC');
   Insert( Bruce );
   Inc ( Y, 1 ) ;

   { ***************  DM  **************** }

   R.Assign( X, Y, XMaxOkno, Y  );
   Bruce := New( PInputLine, Init( R, 79 ));
   R.Assign( 3, Y,  5, Y  );
   Bruce^.InitLabel(R,'DM');
   Insert( Bruce );
   Inc ( Y, 1 ) ;


   { *************** Others **************** }

   R.Assign( X, Y, XMaxOkno, Y  );
   Bruce := New( PInputLine, Init( R, 79 ));
   R.Assign( 3, Y,  5, Y  );
   Bruce^.InitLabel(R,'Others');
   Insert( Bruce );
   Inc ( Y, 1 ) ;


   { ************* Satellits *************** }

   R.Assign( X, Y, XMaxOkno, Y  );
   Bruce := New( PInputLine, Init( R, 79 ));
   R.Assign( 3, Y,  5, Y  );
   Bruce^.InitLabel(R,'Satellites');
   Insert( Bruce );
   Inc ( Y, 2 ) ;


   R.Assign ( X+7, Y, X+18, Y + 1);
   Bruce := New ( PButton, Init( R,'Ok', bfNormal, cmQuit ));
   Insert( Bruce );

   R.Assign( x+20, Y, X+31, Y + 1);
   Bruce := New( PButton, Init( R,'Cancel', bfNormal, cmCancel ));
   Insert( Bruce );


   SetData ( CatalogDir );


   ExitCode := Run ;

   If ExitCode <> cmCancel Then
    Begin

     GetData ( CatalogDir ) ;

     Assign  ( CatDirFile, 'User.Dir' ) ;
     ReWrite ( CatDirFile             ) ;

     S := CatalogDir.Hip ;
     DelProb ;
     Writeln ( CatDirFile , S  ) ;

     S := CatalogDir.Tyc ;
     DelProb ;
     Writeln ( CatDirFile , S  ) ;

     S := CatalogDir.PPM ;
     DelProb ;
     Writeln ( CatDirFile , S  ) ;

     S := CatalogDir.BS  ;
     DelProb ;
     Writeln ( CatDirFile , S  ) ;

     S := CatalogDir.HD  ;
     DelProb ;
     Writeln ( CatDirFile , S  ) ;

     S := CatalogDir.Gcvs ;
     DelProb ;
     Writeln ( CatDirFile , S  ) ;

     S := CatalogDir.CDS ;
     DelProb ;
     Writeln ( CatDirFile , S  ) ;

     S := CatalogDir.Npm ;
     DelProb ;
     Writeln ( CatDirFile , S  ) ;

     S := CatalogDir.NLtt ;
     DelProb ;
     Writeln ( CatDirFile , S  ) ;

     S := CatalogDir.A20 ;
     DelProb ;
     Writeln ( CatDirFile , S  ) ;

     S := CatalogDir.GSC ;
     DelProb ;
     Writeln ( CatDirFile , S  ) ;

     S := CatalogDir.DM   ;
     DelProb ;
     Writeln ( CatDirFile , S  ) ;

     S := CatalogDir.Iras ;
     DelProb ;
     Writeln ( CatDirFile , S  ) ;

     S := CatalogDir.Satellits ;
     DelProb ;
     Writeln ( CatDirFile , S  ) ;

     Close   ( CatDirFile ) ;

    End;

  End;

 Dispose( Dialog, Done );

End;{ SetCatalogDir  }



End.