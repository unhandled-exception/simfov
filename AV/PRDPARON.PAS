
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



     { ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ }




  Procedure RdStr ( Var Ps : String ) ;
{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

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



     { ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ }



  Function RdInt : LongInt ;
{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

  Var I : Longint ;

    Begin

      RdStr ( Ps ) ;
      Val ( Ps , I, Code ) ;
      RdInt := I ;

    End ; { RdInt }



     { ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ }



  Function RdReal : Double ;
{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

  Var I : Double ;

    Begin

      RdStr ( Ps ) ;
      Val ( Ps , I, Code ) ;
      RdReal := I ;

    End ; { RdInt }



     { ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ }



  Function RdChar : Char ;
{ ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

    Begin

      RdStr ( Ps ) ;
      If ( Length ( Ps ) = 0 )
        Then  RdChar := '+'
        Else  RdChar := Ps [ 1 ] ;

    End ; { RdInt }



     { ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ }


  Function RdDir : String ;
    Begin

      RdStr ( Ps ) ;
      If ( Ps [ Length ( Ps ) ] = '\' )  Then
        Delete ( Ps, Length ( Ps ), 1 ) ;
      RdDir :=  Ps ;

    End ; { RdInt }



     { ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ }


  Procedure RDParamOnly ( NVarDir : String ) ;


            {  —’…Hˆ…  €€Œ…’‚  ˆ‡  ”€‰‹€  }
            {  ßßßßßßßßßßßßßßßßßßßßßßßßßßßßß  }

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
  ‚  … Œ Ÿ
  ßßßßßßßßß
}


                  { H€—€‹œH›‰   ŒŒ…H’ }
                  { ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ }


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


                { ˜€ƒ ¯® ¢p¥¬¥­¨ ¢ á¥ªã­¤ å }
                { ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ }

                 StepTime := RdReal  ;

                 DateOld  := True    ;

               End ;

                   { •€  ‹…Œ…H’‚ }
                   { ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ }

                 InputYear     := RdInt  ;
                 InputMon      := RdInt  ;
                 InputDay      := RdInt  ;
                 InputH        := RdInt  ;
                 InputMin      := RdInt  ;
                 InputSek      := RdReal ;


                  { •€ …‡“‹œ’€’‚ }
                  { ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ }

                 EpOut         := RdInt  ; { 1 - EpRez, 2 - JDate }

                 OutYear       := RdInt  ;
                 OutMon        := RdInt  ;
                 OutDay        := RdInt  ;
                 OutH          := RdInt  ;
                 OutMin        := RdInt  ;
                 OutSek        := RdReal ;

{
  ’ … ‹ … ‘ Š  
  ßßßßßßßßßßßßßßß
}

                  { ‹†…Hˆ… â¥«¥áª®¯  }
                  { ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ }


                 NPl0          := RdInt  ;

                 Earth_Space   := RdInt  ;    { 1 - Earth, 2 - Space }


                        { ‡¥¬«ï }
                        { ÄÄÄÄÄ }

                 LongSig       := RdChar ;
                 LongG         := RdInt  ;
                 LongM         := RdInt  ;
                 LongS         := RdReal ;

                 LatSig        := RdChar ;
                 LatG          := RdInt  ;
                 LatM          := RdInt  ;
                 LatS          := RdReal ;

                 Alt           := RdReal ;


                      { Š®á¬®á }
                      { ÄÄÄÄÄÄ }

                 ElemFile      := RdInt  ; { 0 - ‘p¥¤­¨¥, 1 - ®«¨­®¬ë }

                 HAp           := RdReal ;
                 HPer          := RdReal ;
                 ISat          := RdReal ;
                 OmG           := RdReal ;
                 OmL           := RdReal ;
                 ArgLat        := RdReal ;



                  {  ‹…   ‡…HˆŸ  }
                  {  ÜÜÜÜÜÜÜÜÜÜÜÜÜÜ }


                 FldX          := RdReal ;
                 FldY          := RdReal ;
                 RRX           := RdReal ;
                 RRY           := RdReal ;

                 NPolFix       := RdInt  ;

                 XOrient       := RdInt  ;
                 YOrient       := RdInt  ;

                 RSun          := RdReal ;
                 RMon          := RdReal ;


                    { ”®â®¯p¨¥¬­¨ª }
                    { ÄÄÄÄÄÄÄÄÄÄÄÄ }

                 MvMax         := RdReal ;

                 Period_X_Min  := RdReal ;
                 Period_Y_Min  := RdReal ;
                 Pixel_X_Min   := RdReal ;
                 Pixel_Y_Min   := RdReal ;
                 N_Pixel_X     := RdInt  ;
                 N_Pixel_Y     := RdInt  ;

{

    ’ ˆ — … ‘ Š € Ÿ     ‘ œ
  ßßßßßßßßßßßßßßßßßßßßßßßßßßßß

}


                { ˆ…H’€–ˆŸ  ®¯â¨ç¥áª®©  ®á¨ }
                { ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ }


                 OptAxOrient    := RdInt ;   { 1 - Eq  , 2 - Gor ,
                                               3 - Orb , 4 - Obj  }


                { Š‚€’ˆ€‹œH›… ª®®p¤¨­ âë }
                { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                 RaOptH         := RdInt  ;
                 RaOptM         := RdInt  ;
                 RaOptS         := RdReal ;

                 DeclOptSig     := RdChar ;
                 DeclOptG       := RdInt  ;
                 DeclOptM       := RdInt  ;
                 DeclOptS       := RdReal ;


                { ƒˆ‡H’€‹œH›… ª®®p¤¨­ âë }
                { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                 ASig           := RdChar ;
                 AG             := RdInt  ;
                 AM             := RdInt  ;
                 AS             := RdReal ;

                 HOptType       := RdInt  ; { 1 - ƒ®p¨§,  2 - Š á â ª £®p¨§ }

                 HSig           := RdChar ;
                 HG             := RdInt  ;
                 HM             := RdInt  ;
                 HS             := RdReal ;



                { â­®á¨â¥«ì­® ‚…Š’€ ‘Š‘’ˆ  ¢ £p ¤ãá å }
                { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                 Tangag         := RdReal ;
                 Ryskanie       := RdReal ;


                     { ® š…Š’“ }
                     { ÄÄÄÄÄÄÄÄÄÄ }

                 NObj           := RdInt ;  { 1 - Plan, 2 - Sat }

                 NPlan          := RdInt ;
                 NSat           := RdInt ;

{

   … † ˆ Œ ›
  ßßßßßßßßßßß

}


                    { …†ˆŒ› p ¡®âë }
                    { ÜÜÜÜÜÜÜÜÜÜÜÜÜ }


                 EarthIzo      := RdInt  ;
                 Corr_Fot_Sys  := RdInt ;
                 OutFOV        := RdInt ;
                 Object_Tracks := RdInt ;
                 DetCdc        := RdInt ;
                 ImportStar    := RdInt ;  { 0 - H¥ ¢¢®¤¨âì         }
                 DetImp        := RdInt ;  { 0 - H¥ ®â®¦¤,  1 - ‚á¥ }
                 StopNoDet     := RdInt ;  { 0 - H¥ Stop, 1 - Stop ¯p¨ ­¥®â }
                 PzsInFOV      := RdInt ;


                { H®¬¥p  ­ ç. £pã¯¯ë ¨¬¯®pâ­ëå ®¡ê¥ªâ®¢ }
                { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                 NGrImportBeg  :=  RdInt  ;


                { p¥¤¥« p §­®áâ¨ Mv ¯p¨ ®â®¦¤¥áâ¢«¥­¨¨ }
                { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                 DMvDet        :=  RdReal ;


                {  ¤¨ãáë  ®â®¦¤¥áâ¢«¥­¨ï }
                { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                 RoPPMDet      :=  RdReal ;
                 RoGscDet      :=  RdReal ;
                 RoCdcDet      :=  RdReal ; {  ¤¨ãá ‘…„H…HˆŸ £pã¯¯ §¢¥§¤ }
                 RoBsDet       :=  RdReal ;
                 RoHdDet       :=  RdReal ;
                 RoGcvsDet     :=  RdReal ;
                 RoDmDet       :=  RdReal ;
                 RoIrasDet     :=  RdReal ;
                 RDetImp       :=  RdReal ;


{
  Š € ’ € ‹  ƒ ˆ   ¨  ” ©«ë ¤ ­­ëå
  ßßßßßßßßßßßßßßß
}

                 { ˆ‘‹œ‡“…Œ›… ª â «®£¨ }
                 { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

                 PPM           := RdInt ;
                 Bs            := RdInt ;
                 Hd            := RdInt ;
                 Gcvs          := RdInt ;
                 Cdc           := RdInt ;
                 Gsc           := RdInt ;
                 Iras          := RdInt ;
                 Dm            := RdInt ;
                 Satellits     := RdInt ;


                  { „ˆ…Š’ˆˆ ª â «®£®¢ }
                  { ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ }

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

                  {  ˆŒ…H€  ä ©«®¢  }
                  {  ÄÄÄÄÄÄÄÄÄÄÄÄÄ  }

                 Param.SatellitsDir      :=  RdDir  ;
                 Param.ImportStarDir     :=  RdDir  ;
                 Param.PzsDir            :=  RdDir  ;
                 Param.FotSysDir         :=  RdDir  ;



        End ; { With  Param }

      Close ( ParamFile ) ;

      FileMode := 2 ;


    End ; { Not CatNotFound }

 End ;  { RDParamOnly }
        { ÄÄÄÄÄÄÄÄÄÄÄ }

End.