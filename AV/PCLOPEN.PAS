
{$O+,F+}


Unit  PClOpen ;

 InterFace

	Procedure  CloseOpen ;


 Implementation

   Uses PVar, POutFld ;

	Procedure  CloseOpen ;
 Begin

       If ( BsOpen )  Then
         Begin
           Close ( BsFile    ) ;
           Close ( BsSrcFile ) ;
           BsOpen := False ;
         End ;

       If ( NpmOpen )  Then
        Begin
          Close ( NpmFile ) ;
          NpmOpen := False  ;
        End ;

       If ( PpmOpen )  Then
        Begin
          Close ( PpmFile ) ;
          PpmOpen := False  ;
        End ;

       If ( HipOpen )  Then
         Begin
           Close ( HipFile ) ;
           If ( B_Hip_Add ) Then
             Close ( HipAddFile ) ;
           HipOpen := False ;
         End ;

       If ( TycOpen )  Then
        Begin
          Close ( TycFile ) ;
          If ( B_Tyc_2_Add )  Then
            Close ( TycAddFile ) ;
          TycOpen := False ;
        End ;

       If ( SaoOpen )  Then
        Begin
          Close ( SaoFile ) ;
          SaoOpen := False  ;
        End ;

       If ( NlttOpen )  Then
        Begin
          Close ( NlttFile ) ;
          NlttOpen := False  ;
        End ;

       If ( HdEOpen )  Then
         Begin
          Close ( HdFile  ) ;
          Close ( HdEFile ) ;
          HdeOpen := False  ;
         End ;

       If ( GcvsOpen )  Then
         Begin
           If ( B_Gcvs2000 )
             Then  Close ( Gcvs2000File )
             Else  Close ( GcvsFile     ) ;
           GcvsOpen := False ;
         End ;




 End ;

End.
