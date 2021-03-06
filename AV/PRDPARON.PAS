
{$O+,F+}

 Unit  PrdParOn ;


  InterFace

  Uses PVar ;

  Procedure RDParamOnly ( NVarDir : String ) ;

  Implementation

    Uses

         PVarMenu, V_Catal, Check, PJd8, PDefPar, Dos ;

    Var

         I               : Byte  ;

         RI              : Integer ;
         RR              : Double  ;

         Ps              : String ;
         SpKl            : String [  2 ]  ;



     { ���������������������� }




  Procedure RdStr ( Var Ps : String ) ;
{ ��������������� }

  Var
    S : String ;
    N1, N2 : Integer ;

    Begin

      Repeat
        Readln ( Paramfile , S ) ;
      Until Pos ( '=' , S ) <> 0 ;

      N1 := Pos ( '=' , S ) ;
      N2 := Pos ( ';' , S ) ;

      Ps := Copy ( S , N1 + 1 , N2 - N1 - 1 ) ;

      While Pos ( ' ' , Ps ) > 0 Do
        Begin
          Delete ( Ps , Pos ( ' ' , Ps ), 1 ) ;
        End ;
      
    End ; { RdInt }



     { ���������������������� }



  Function RdInt : LongInt ;
{ ������������������������ }

  Var I : Longint ;

    Begin

      RdStr ( Ps ) ;
      Val ( Ps , I, Code ) ;
      RdInt := I ;

    End ; { RdInt }



     { ���������������������� }



  Function RdReal : Double ;
{ ������������������������ }

  Var I : Double ;

    Begin

      RdStr ( Ps ) ;
      Val ( Ps , I, Code ) ;
      RdReal := I ;

    End ; { RdInt }



     { ���������������������� }



  Function RdChar : Char ;
{ ���������������������� }

    Begin

      RdStr ( Ps ) ;
      If ( Length ( Ps ) = 0 )
        Then  RdChar := '+'
        Else  RdChar := Ps [ 1 ] ;

    End ; { RdInt }



     { ���������������������� }


  Function RdDir : String ;
    Begin

      RdStr ( Ps ) ;
      If ( Ps [ Length ( Ps ) ] = '\' )  Then
        Delete ( Ps, Length ( Ps ), 1 ) ;
      RdDir :=  Ps ;

    End ; { RdInt }



     { ���������������������� }


  Procedure RDParamOnly ( NVarDir : String ) ;


            {  ���H��  ����������  ��  �����  }
            {  �����������������������������  }

 Begin

  CheckFile ( NVarDir ) ;
  If ( Not CatNotFound )  Then
    Begin { Not CatNotFound }

      Assign    ( ParamFile , NVarDir ) ;
      FileMode := 0 ;
      Reset     ( ParamFile ) ;

      With  Param  Do
        Begin

{
  � � � � �
  ���������
}


                  { H�����H��   ����H� }
                  { ������������������ }


           If ( DateOld )
             Then
               Begin
                 RI := RdInt  ;
                 RI := RdInt  ;
                 RI := RdInt  ;
                 RI := RdInt  ;
                 RI := RdInt  ;
                 RR := RdReal ;
                 RR := RdReal ;
               End
             Else
               Begin

                 TimeYear     := RdInt   ;
                 TimeMon      := RdInt   ;
                 TimeDay      := RdInt   ;
                 TimeH        := RdInt   ;
                 TimeMin      := RdInt   ;
                 TimeSek      := RdReal  ;


                { ��� �� �p����� � ᥪ㭤�� }
                { ������������������������� }

                 StepTime := RdReal  ;

                 DateOld  := True    ;

               End ;

                   { �����  �����H��� }
                   { ���������������� }

                 InputYear     := RdInt  ;
                 InputMon      := RdInt  ;
                 InputDay      := RdInt  ;
                 InputH        := RdInt  ;
                 InputMin      := RdInt  ;
                 InputSek      := RdReal ;


                  { ����� ����������� }
                  { ����������������� }

                 EpOut         := RdInt  ; { 1 - EpRez, 2 - JDate }

                 OutYear       := RdInt  ;
                 OutMon        := RdInt  ;
                 OutDay        := RdInt  ;
                 OutH          := RdInt  ;
                 OutMin        := RdInt  ;
                 OutSek        := RdReal ;

{
  � � � � � � � �
  ���������������
}

                  { ������H�� ⥫�᪮�� }
                  { ������������������� }


                 NPl0          := RdInt  ;

                 Earth_Space   := RdInt  ;    { 1 - Earth, 2 - Space }


                        { ����� }
                        { ����� }

                 LongSig       := RdChar ;
                 LongG         := RdInt  ;
                 LongM         := RdInt  ;
                 LongS         := RdReal ;

                 LatSig        := RdChar ;
                 LatG          := RdInt  ;
                 LatM          := RdInt  ;
                 LatS          := RdReal ;

                 Alt           := RdReal ;


                      { ��ᬮ� }
                      { ������ }

                 ElemFile      := RdInt  ; { 0 - �p�����, 1 - �������� }

                 HAp           := RdReal ;
                 HPer          := RdReal ;
                 ISat          := RdReal ;
                 OmG           := RdReal ;
                 OmL           := RdReal ;
                 ArgLat        := RdReal ;



                  {  ����   ���H��  }
                  {  �������������� }


                 FldX          := RdReal ;
                 FldY          := RdReal ;
                 RRX           := RdReal ;
                 RRY           := RdReal ;

                 NPolFix       := RdInt  ;

                 XOrient       := RdInt  ;
                 YOrient       := RdInt  ;

                 RSun          := RdReal ;
                 RMon          := RdReal ;


                    { ��⮯p������ }
                    { ������������ }

                 MvMax         := RdReal ;

                 Period_X_Min  := RdReal ;
                 Period_Y_Min  := RdReal ;
                 Pixel_X_Min   := RdReal ;
                 Pixel_Y_Min   := RdReal ;
                 N_Pixel_X     := RdInt  ;
                 N_Pixel_Y     := RdInt  ;

{

  � � � � � � � � � �    � � �
  ����������������������������

}


                { ����H�����  ����᪮�  �� }
                { ��������������������������� }


                 OptAxOrient    := RdInt ;   { 1 - Eq  , 2 - Gor ,
                                               3 - Orb , 4 - Obj  }


                { �����������H�� ���p������ }
                { ������������������������� }

                 RaOptH         := RdInt  ;
                 RaOptM         := RdInt  ;
                 RaOptS         := RdReal ;

                 DeclOptSig     := RdChar ;
                 DeclOptG       := RdInt  ;
                 DeclOptM       := RdInt  ;
                 DeclOptS       := RdReal ;


                { ������H����H�� ���p������ }
                { ������������������������� }

                 ASig           := RdChar ;
                 AG             := RdInt  ;
                 AM             := RdInt  ;
                 AS             := RdReal ;

                 HOptType       := RdInt  ; { 1 - ��p��,  2 - ���� � ��p�� }

                 HSig           := RdChar ;
                 HG             := RdInt  ;
                 HM             := RdInt  ;
                 HS             := RdReal ;



                { �⭮�⥫쭮 ������� ��������  � �p����� }
                { ����������������������������������������� }

                 Tangag         := RdReal ;
                 Ryskanie       := RdReal ;


                     { �� ������� }
                     { ���������� }

                 NObj           := RdInt ;  { 1 - Plan, 2 - Sat }

                 NPlan          := RdInt ;
                 NSat           := RdInt ;

{

  � � � � � �
  �����������

}


                    { ������ p����� }
                    { ������������� }


                 EarthIzo      := RdInt  ;
                 Corr_Fot_Sys  := RdInt ;
                 OutFOV        := RdInt ;
                 Object_Tracks := RdInt ;
                 DetCdc        := RdInt ;
                 ImportStar    := RdInt ;  { 0 - H� �������         }
                 DetImp        := RdInt ;  { 0 - H� �⮦�,  1 - �� }
                 StopNoDet     := RdInt ;  { 0 - H� Stop, 1 - Stop �p� ���� }
                 PzsInFOV      := RdInt ;


                { H���p  ���. �p㯯� ����p��� ��ꥪ⮢ }
                { ���������������������� }

                 NGrImportBeg  :=  RdInt  ;


                { �p���� p������ Mv �p� �⮦���⢫���� }
                { ������������������������������������� }

                 DMvDet        :=  RdReal ;


                { �������  �⮦���⢫���� }
                { ����������������������� }

                 RoPPMDet      :=  RdReal ;
                 RoGscDet      :=  RdReal ;
                 RoCdcDet      :=  RdReal ; { ������ �����H�H�� �p㯯 ����� }
                 RoBsDet       :=  RdReal ;
                 RoHdDet       :=  RdReal ;
                 RoGcvsDet     :=  RdReal ;
                 RoDmDet       :=  RdReal ;
                 RoIrasDet     :=  RdReal ;
                 RDetImp       :=  RdReal ;


{
  � � � � � � � �   �  ����� ������
  ���������������
}

                 { ������������ ��⠫��� }
                 { ��������������������� }

                 PPM           := RdInt ;
                 Bs            := RdInt ;
                 Hd            := RdInt ;
                 Gcvs          := RdInt ;
                 Cdc           := RdInt ;
                 Gsc           := RdInt ;
                 Iras          := RdInt ;
                 Dm            := RdInt ;
                 Satellits     := RdInt ;


                  { ���������� ��⠫���� }
                  { �������������������� }

                 ParamDir.HipDir         :=  RdDir  ;
                 ParamDir.TycDir         :=  RdDir  ;
                 ParamDir.PPMDir         :=  RdDir  ;
                 ParamDir.BsDir          :=  RdDir  ;
                 ParamDir.HdDir          :=  RdDir  ;
                 ParamDir.GcvsDir        :=  RdDir  ;
                 ParamDir.CdcDir         :=  RdDir  ;
                 ParamDir.NpmDir         :=  RdDir  ;
                 ParamDir.NLttDir        :=  RdDir  ;
                 ParamDir.A20Dir         :=  RdDir  ;
                 ParamDir.GscDir         :=  RdDir  ;
                 ParamDir.DmDir          :=  RdDir  ;
                 ParamDir.IrasDir        :=  RdDir  ;

                  {  ���H�  䠩���  }
                  {  �������������  }

                 Param.SatellitsDir      :=  RdDir  ;
                 Param.ImportStarDir     :=  RdDir  ;
                 Param.PzsDir            :=  RdDir  ;
                 Param.FotSysDir         :=  RdDir  ;



        End ; { With  Param }

      Close ( ParamFile ) ;

      FileMode := 2 ;


    End ; { Not CatNotFound }

 End ;  { RDParamOnly }
        { ����������� }

End.