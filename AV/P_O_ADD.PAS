
{$O+,F+}


Unit  P_O_Add ;

 InterFace

	Procedure  Out_Add_Inform  ;


 Implementation

   Uses PVar ;

	Procedure  Out_Add_Inform ;
 Begin

   If (     ( SClass = CatTyc )
        And ( B_Tyc_2_Add     ) )  Then
     Begin
       Write ( OutFile,
                         TycAddRecord.MqePmRa   /   10.0  : 5:1,
                         TycAddRecord.MqePmDecl /   10.0  : 5:1,
                         TycAddRecord.VT        / 1000.0  : 8:3,
                         TycAddRecord.BT        / 1000.0  : 8:3,
                         TycAddRecord.MqeVT     / 1000.0  : 8:3,
                         TycAddRecord.MqeBT     / 1000.0  : 8:3  ) ;
     End ;



   If (     ( SClass = CatHip )
        And ( B_Hip_Add       ) )  Then
     Begin

      If ( HipAddRecord.Par > -30000 )
        Then Write ( OutFile,  HipAddRecord.Par               * 1000.0  : 7:2  )
        Else Write ( OutFile,  '       '                                       );

      If ( HipAddRecord.MqePar > -30000 )
        Then Write ( OutFile,  HipAddRecord.MqePar               / 100.0  : 7:2  )
        Else Write ( OutFile,  '       '                                       );

      If ( HipAddRecord.MqePmRa > -30000 )
        Then Write ( OutFile,  HipAddRecord.MqePmRa               / 100.0  : 7:2  )
        Else Write ( OutFile,  '       '                                       );

      If ( HipAddRecord.MqePmDecl > -30000 )
        Then Write ( OutFile,  HipAddRecord.MqePmDecl               / 100.0  : 7:2  )
        Else Write ( OutFile,  '       '                                       );

      If ( HipAddRecord.CorrPmRaPmDecl > -30000 )
        Then Write ( OutFile,  HipAddRecord.CorrPmRaPmDecl         / 1000.0  : 7:2  )
        Else Write ( OutFile,  '       '                                       );

      If ( HipAddRecord.VT > -30000 )
        Then Write ( OutFile,  HipAddRecord.VT                / 1000.0  : 7:3  )
        Else Write ( OutFile,  '       '                                       );

      If ( HipAddRecord.BT > -30000 )
        Then Write ( OutFile,  HipAddRecord.BT                / 1000.0  : 7:3  )
        Else Write ( OutFile,  '       '                                       );

      If ( HipAddRecord.BmV > -30000 )
        Then Write ( OutFile,  HipAddRecord.BmV               / 1000.0  : 7:3  )
        Else Write ( OutFile,  '       '                                       );

      If ( HipAddRecord.VmI > -30000 )
        Then Write ( OutFile,  HipAddRecord.VmI               /  100.0  : 6:2  )
        Else Write ( OutFile,  '      '                                       );

        Write ( OutFile,  HipAddRecord.RefFlgColInd                : 3    );
        Write ( OutFile,  HipAddRecord.FlgVar                      : 1    );
        Write ( OutFile,  HipAddRecord.SrcBmV                      : 1    );
        Write ( OutFile,  HipAddRecord.SrcVmI                      : 1    );
        Write ( OutFile,  HipAddRecord.SrcSp                       : 1    );

        Write ( OutFile,  HipAddRecord.Spectr                      : 14   );

     End ;


 End ;

End.
