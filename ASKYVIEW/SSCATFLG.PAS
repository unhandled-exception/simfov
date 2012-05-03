{$F+,O+}

Unit SSCatFlg;
Interface

Uses SSVar, TDialogs, TStdObj;

procedure SetCatalogFlag ;


Implementation

procedure SetCatalogFlag ;

Var

  Dialog   : PDialog ;

  Bruce    : PView   ;

  R        : TRect   ;

  ExitCode : Word    ;

Begin

 R.Assign( 1, 1, 31, 20 );
 Dialog := New( PDialog , Init( R, ' Use catalogs ', jcCentered ));

 With Dialog^ do
  Begin
{
   R.Assign( 3, 2, 18, 15 );
   R.Assign( 3, 2, 18, 18 );
}
   R.Assign( 3, 2, 19, 18 );
   Bruce := New ( PCheckBoxes, Init ( R ) );
   With Bruce^ do
    Begin

     NewSItem ( 'HIP'       ) ;
     NewSItem ( 'TYC'       ) ;
     NewSItem ( 'PPM'       ) ;
     NewSItem ( 'SAO'       ) ;
     NewSItem ( 'BS'        ) ;
     NewSItem ( 'HD'        ) ;
     NewSItem ( 'GCVS'      ) ;
     NewSItem ( 'AC'        ) ;
     NewSItem ( 'NPM'       ) ;
     NewSItem ( 'NLTT'      ) ;
     NewSItem ( 'A20'       ) ;
     NewSItem ( 'GSC'       ) ;
     NewSItem ( 'DM'        ) ;
     NewSItem ( 'Others'    ) ;
     NewSItem ( 'Import'    ) ;
     NewSItem ( 'Satellites' ) ;
{ *******************************************
     NewSItem ( 'Ccd'       ) ;
  ******************************************* }

    End;

   Insert( Bruce );

   R.Assign( 21,2,30,3);
   Bruce := New( PButton, Init( R,'Ok', bfNormal, cmQuit ));
   Insert( Bruce );

   R.Assign( 21,4,30,5);

   Bruce := New( PButton, Init( R,'Cancel', bfNormal, cmCancel ));
   Insert( Bruce );

   SetData ( CCatalogFlag );

   ExitCode := Run ;

   If ExitCode <> cmCancel Then
    Begin

     GetData ( CCatalogFlag );

    End;

  End;

 Dispose( Dialog, Done );

End;{ SetCatalogFlag  }

end.