{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커 }
{ �                                                                      � }
{ �                            S I M   F O V                             � }
{ �                                                                      � }
{ �         뫅飡�쵟 Мㄵエp�쥯�⑨ ��ワ 쬹��⑨ ��殊曄稅ⓨ 칛Æ췴��.       � }
{ �                                                                      � }
{ � SimFov Version 2.0a Copyright (c) 1992,..,1998 by Sternberg Institut.� }
{ �                                                                      � }
{ 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸 }

{$F+}

Program ASimFOV;

{ 굇굇굇굇굇굇� 닾�췅 ⓤ��レ㎯�щ� Мㅳゥ�. 굇굇굇굇굇굇굇 }

Uses

{ 굇굇굇굇굇� 묅젺쩆設�瑜 Мㅳエ Turbo Pascal. 굇굇굇굇굇� }

{$IFNDEF DPMI}

   Overlay,

{$ENDIF}

{ 굇굇굇굇� 꽡��キⓥ�レ�瑜 Мㅳエ ( 쭬．ギ˚� ). 굇굇굇굇� }

   TStdObj  , TApp     , TMsgWin  , TDialogs ,
   Crt,       TDrivers , {TProtect ,}

   PVarMenu ,


   SSVar    , SSError  , SSCatFlg , SSCatDir , SSObject ,
   SSStdRec , SSEpoh   , SSTelPos , SSKosOrb , SSFotPri ,
   SSPoleZr , SSFotHar , SSList   , SSFile   , SSRegims ,
   SSInfo   , SSEDir   , SSTOrbit , SSBegDat , SSHead   ,
   SSFont   , SSEpInf  , SSRadDet , SSOrient ,

   { 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇� }

   OptSatMc ,  InitVMn   ,  PVar;


{ 굇굇굇굇굇 묅젺쩆設�瑜 Мㅳエ 캙ぅ�� OVSTPROF. 굇굇굇굇� }

{ 굇굇굇굇굇        OVSTPROF Version 2.0         굇굇굇굇� }
{ 굇굇굇굇굇    Copyright(c) 1992 by OVSoft.     굇굇굇굇� }

{$IFNDEF DPMI}

{$O TStdObj  } { 롟��˛瑜 ��誓ㄵゥ�⑨ ㄻ� 캙ぅ�� OVSTPROF.      }
{$O TApp     } { 롟��˛�� �↔ⅹ� 캙ぅ�� OVSTPROF.               }
{$O TDialogs } { 롞짛��쭬與� ㄸ젷�．�音 �ぎ� � 캙ぅ收 OVSTPROF. }
{$O TMsgWin  } { 묅젺쩆設�瑜 ㄸ젷�．�瑜 �き� OVSTPROF.          }

{ 굇굇굇굇 뙫ㅳエ ⓤ��レ㎯�щ� � 쩆���� �昔｀젹Д. 굇굇굇� }


{$O SSBegDat } { 볚�젺�˚� 췅�젷彛�． МД��� � �젫�.     }{ SetBeginDate }
{$O SSCatDir } { 볚�젺�˚� ⓤ��レ㎯�щ� ㄸ誓も�黍�.       }{ SetCatalogDir  }
{$O SSCatFlg } { 볚�젺�˚� ⓤ��レ㎯�щ� 첓�젷�．�.        }{ SetCatalogFlag }
{$O SSEDir   } { 볚�젺�˚� ㄾ��キⓥ�レ�音 ㄸ誓も�黍�.     }{ SetEDir  }
{$O SSEpInf  }
{$O SSEpoh   } { ** 렞ⓤ젺�� � Мㅳゥ.                    }{ SetEpoh        }
{$O SSError  } { 귣쩆�� 貰�↓��Ł �� �鼇―졾.             }{}
{$O SSFile   } { ** 렞ⓤ젺�� � Мㅳゥ.                    }{}
{$O SSFont   }
{$O SSFotHar } { 볚�젺�˚� 兒獸Д循①αえ� �졷젶收黍飡Ø. }{ SetFotometrHar }
{$O SSFotPri } { 뵰獸�黍�ЛØ.                            }{ SetFotoPriemnik }
{$O SSHead   } 
{$O SSInfo   } { 귣쩆�� Þ兒p쵟與� � 歲飡�Л音 pα�p�졾.  }{ SysInfo }
{$O SSKosOrb } { 볚�젺�˚� 캙�젹β昔� �胥ⓥ�.             }{ SetKosmosOrbita }
{$O SSList   } { 맆‘�� 貰 召ⓤぎ� �젵ギ� 캙p젹βp��.     }{ WFileList }
{$O SSObject } { 볚�젺�˚� 璵�循젷彛�． �↔ⅹ��.          }{ SetObject      }
{$O SSOrient }
{$O SSPoleZr } { 볚�젺�˚� ��ワ ㏅��⑨.                   }{ SetPoleZr      }
{$O SSRadDet }
{$O SSRegims } { 볚�젺�˚� pⅵº��  p젩�瞬.               }{ SetRegims }
{$O SSStdRec } { ** 렞ⓤ젺�� � Мㅳゥ.                    }{ SetStdRec      }
{$O SSTOrbit } { 뫍�貰� 쭬쩆�⑨ 췴〃瞬.                   }{ SetOrbitType }
{$O SSTelPos } { 볚�젺�˚� ��㎤與� 收ゥ稅�캙.             }{ SetTeleskopPosition }




   {$O About     }
   {$O Ak_Moz    }
   {$O CMenu     }
   {$O CSpectra  }
   {$O Check     }
   {$O Curs      }
   {$O Find      }
   {$O Font      }
   {$O Glass     }
   {$O Glib      }
   {$O Greek_F   }
   {$O Info      }
   {$O InitVMn   }
   {$O MLib      }
   {$O OPTSATMC  }
   {$O PA20Fld   }
   {$O PBinObj   }
   {$O PBsFld    }
   {$O PCalCons  }
   {$O PCcdFld   }
   {$O PCdcCFld  }
   {$O PDayJd    }
   {$O PDefPar   }
   {$O PDetCCd   }
   {$O PDetImp   }
   {$O PDmFld    }
   {$O PE_Cns    }
   {$O PElStRct  }
   {$O PEndOpt   }
   {$O PFk4Fk5   }
   {$O PFldGrn   }
   {$O PGalEkv   }
   {$O PGcvsFld  }
   {$O PV200Fld  }
   {$O PGreek    }
   {$O PGscFld   }
   {$O PHdFld    }
   {$O PHipFld   }
   {$O PIko      }
   {$O PImpFld   }
   {$O PInform   }
   {$O PJD8      }
   {$O PJUP      }
   {$O PMARS     }
   {$O PMERK     }
   {$O PMONDIA   }
   {$O PMem      }
   {$O PMnkHard  }
   {$O PNEPT     }
   {$O PNLTTFld  }
   {$O PNpmFld   }
   {$O PNutNew   }
   {$O PObjOut   }
   {$O POptAx    }
   {$O POptCcd   }
   {$O POptImp   }
   {$O POptPars  }
   {$O POscreen  }
   {$O POthrFld  }
   {$O POutFld   }
   {$O POutPV    }
   {$O PPLU      }
   {$O PPlDraw   }
   {$O PPlFld    }
   {$O PPlInfo   }
   {$O PPlPro    }
   {$O PPlanet   }
   {$O PPpmFld   }
   {$O PPreNew   }
   {$O PPreOld   }
   {$O PProFld   }
   {$O PRdFormt  }
   {$O PRdParOn  }
   {$O PRdParam  }
   {$O PRedFin   }
   {$O PRefr     }
   {$O PSAT      }
   {$O PSATJUP   }
   {$O PSOL      }
   {$O PSaoFld   }
   {$O PSat      }
   {$O PSatElCh  }
   {$O PSatFld   }
   {$O PSortImp  }
   {$O PSortRa   }
   {$O PTycFld   }
   {$O PURAN     }
   {$O PVENERA   }
   {$O PVarName  }
   {$O PXYFLHJ   }
   {$O PXYSAT    }
   {$O PSGP4     }
   {$O PreBsIko  }
   {$O Screen    }
   {$O Service   }
   {$O Shell_X   }
   {$O Sort      }
   {$O P_O_Add   }
   {$O PClOpen   }
   {$O PRdSat    }
   {$O PRdCrd    }
   {$O PDateA20  }

(*
   {$O PATan2    }
   {$O PXYOpt    }
   {$O MatMap    }
   {$O PDetCdc   }
   {$O PCdcFld   }
   {$O PDetCrst  }
   {$O POptCdC   }
*)

{$ENDIF}


{ 굇굇굇 묅젺쩆設�瑜 ぎ�飡젺瞬 �昔｀젹щ SimFOV. 굇굇굇 }


Const

  OvrExtraSize  =  0 ;

  CmRunSatellit =  10000 ;


{ 굇굇굇굇굇굇굇굇굇굇 뫉拾ⅰ��� Д��. 굇굇굇굇굇굇굇굇굇� }

   cmAbout                 =  1001 ;

{ 굇굇굇굇굇굇굇굇굇굇굇 뙠�� ��뎸. 굇굇굇굇굇굇굇굇굇굇굇 }

   cmFileList              =  1101 ;
   cmFileLoad              =  1102;
   cmFileSave              =  1103;
   cmSystemInformation     =  1105 ;


{ 굇굇굇굇굇굇굇굇굇� 뙠�� ����똿뮁�. 굇굇굇굇굇굇굇굇굇굇 }

   cmBeginDate             =  1011 ;
   cmRegims                =  1012 ;

{ 굇굇굇굇굇굇 뙠�� 뜝∥在졻�レ. 룼ㄼ��� 눆Й�. 굇굇굇굇굇 }

   cmSetTeleskopPosition   =  1024 ;

{ 굇굇굇굇굇� 뙠�� 뜝∥在졻�レ. 룼ㄼ��� 뒶細��. 굇굇굇굇굇 }

   cmKosmosCentralTelo     = 1033 ;
   cmKosmosOrbitType       = 1034 ;
   cmKosmosOrbita          = 1035 ;
   cmOtnVecSpeed           = 1036 ;
   cmKosmosEpohaElem       = 1037 ;

{ 굇굇굇굇굇굇굇굇굇굇 뙠�� 뮙ゥ稅��. 굇굇굇굇굇굇굇굇굇굇 }

   cmPoleZr                =  1041 ;
   cmFotometrHar           =  1042 ;
   cmFotoPriemnik          =  1044 ;
   cmEkvCoord              =  1045 ;
   cmHorCoord              =  1046 ;
   cmOrbCoord              =  1047 ;
   cmObject                =  1050 ;

{ 굇굇굇굇굇굇굇굇굇굇 뙠��  렊蔚も�. 굇굇굇굇굇굇굇굇굇굇 }

   cmSetCatalogFlag        =  1051 ;
   cmSetCatalogDir         =  1052 ;
   cmSetEDir               =  1053 ;
   cmSetIdentRad           =  1056 ;
   cmEpIzobr               =  1054 ;
   cmEpInf                 =  1055 ;



Type

{ 굇굇굇굇굇굇굇 꺂젪�硫 �↔ⅹ� �昔｀젹щ. 굇굇굇굇굇굇굇� }

 TMApp = Object ( TApplication )

  { 굇굇� 댂ⓩ쯄エ쭬與� �昔｀젹щ. 굇굇� }

    constructor Init ;

  { 굇굇굇굇 댂ⓩ쯄�쭬與� Д��. 굇굇굇굇 }

    procedure InitMenu ;virtual;

  { 굇굇 렊�젩�洙� ㄵ⒰手Ł �� �濡��� � Д��. 굇굇 }

    procedure HandleEvent( ECommand : Word ); virtual ;

    procedure Draw; virtual;

 End;

Var

  SymFOVApp  : TMApp   ;
  ExitFlag   : Boolean ;
  Size       : Longint ;

{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇 }
{ 굇굇                                        굇굇 }
{ 굇굇         댂ⓩ쯄エ쭬與� �昔｀젹щ.       굇굇 }
{ 굇굇                                        굇굇 }
{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇 }

constructor TMApp.Init ;

Var
  X,Y,i   : Byte    ;

Begin

 CheckBreak := False;

{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇� }

  TApplication.Init;


                  { 뱾젷汀� ㄻ� LapTop }
                  { 複複複複複複複複複 }

{}
                        LoadFont;
{}

  TMApp.InitMenu ;

End;

{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇 }
{ 굇굇                                        굇굇 }
{ 굇굇     룼飡p����� ㄾ��キⓥ�レ�音 �ぎ�.    굇굇 }
{ 굇굇                                        굇굇 }
{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇 }

procedure TMApp.Draw;
Begin

  HeadRun;

End;


{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇 }
{ 굇굇                                        굇굇 }
{ 굇굇           댂ⓩ쯄�쭬與� Д��.           굇굇 }
{ 굇굇                                        굇굇 }
{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇 }

procedure TMApp.InitMenu ;
Begin

AppMenu := New( PMainMenu, Init );
 With AppMenu^ do
  Begin
    NewSubMenu( ' ~F~ile ' , hcNoContext );
    With SubMenuArray[ SubMenuNum ]^ do
     Begin

      NewItem( '~L~ist ...'   ,      cmFileList , hcNoContext , True);
      {
      If PassW Then
       Begin
         NewItem( 'Load ~f~ile ...'   , cmFileLoad , hcNoContext , True);
         NewItem( '~S~ave file ...'   , cmFileSave , hcNoContext , True);
       End ;
      }
      NewLine;
      NewItem( 'E~x~it to DOS'     , cmQuit     , hcNoContext , True);

     End;

   NewSubMenu( ' ~R~un ' , hcNoContext );
    With SubMenuArray[ SubMenuNum ]^ do
     Begin

      NewItem( '~S~how image ... ' , cmRunSatellit , hcNoContext , True);

     End;



   NewSubMenu(' ~P~arameters ', hcNoContext );
    With SubMenuArray[ SubMenuNum ]^ do
     Begin


   NewSubMenu( '~T~elescop parameters', hcNoContext );
    With SubMenuArray[ SubMenuNum ]^ do
     Begin

       NewSubMenu( '~A~x optic orientation', hcNoContext );
        With SubMenuArray[ SubMenuNum ]^ do
         Begin

          NewItem ( '~E~quatorial coordinates ...', cmEkvCoord  , hcNoContext, False );
          NewItem ( '~H~orizontal coordinates ...', cmHorCoord  , hcNoContext, False );
          NewItem ( '~O~bject ...', cmObject , hcNoContext, False );
          {
          If PassW Then
          }
            NewItem( 'O~r~bital coordinates ...', cmOrbCoord  , hcNoContext, False );

         End;{ 렞殊曄稅좑 �刷 }

      NewItem( '~F~ield of view ...', cmPoleZr , hcNoContext, False );
      NewItem( '~P~hotometry ...', cmFotometrHar , hcNoContext, False );

{
      If PassW Then
         NewItem( '~C~CD in Fov ...', cmFotoPriemnik  , hcNoContext, False );
}
     End;{ 뮙ゥ稅�� }



   NewSubMenu( '~O~bjects in FOV', hcNoContext );
    With SubMenuArray[ SubMenuNum ]^ do
     Begin

      NewItem( '~C~atalogs ...', cmSetCatalogFlag , hcNoContext, False );
      NewItem( '~I~dentification radii ...', cmSetIdentRad , hcNoContext, False );
      NewItem( 'Catalog ~D~irectories ...', cmSetCatalogDir , hcNoContext, False );
      NewItem( '~E~xtension Files ...', cmSetEDir , hcNoContext, False );

     End;{ 뒥�젷�（ }

   NewSubMenu( 'O~b~server position', hcNoContext );
    With SubMenuArray [ SubMenuNum ]^ do
     Begin
      NewItem( 'Sur~f~ace or PlanetoCenter ...', cmSetTeleskopPosition , hcNoContext, False );
      {
      If ( PassW )
        Then   NewItem ( '~P~lanet or Satellite number ...',
                       cmKosmosCentralTelo  , hcNoContext, False )
        Else   NewItem ( '~P~lanet ...',
                       cmKosmosCentralTelo  , hcNoContext, False );
      }

      NewItem ( '~P~lanet or Satellite number ...',
                cmKosmosCentralTelo  , hcNoContext, False ) ;

      {
      If PassW Then
      }
        Begin
          NewSubMenu( '~S~pace       ', hcNoContext );
           With SubMenuArray[ SubMenuNum ]^ do
            Begin

              NewItem( '~O~rbite ...', cmKosmosOrbita , hcNoContext, False );
              NewItem( 'Orbit ~t~ype ...',  cmKosmosOrbitType , hcNoContext, False );

            End;{ 뒶細�� }
        End ;

     End;{ NewSubMenu( ' 뜝∥滓졻�レ ', hcNoContext ) }



   NewLine;
   NewItem( '~M~odes ...', cmRegims , hcNoContext, False );
   NewItem( '~P~arameters equinox ...', cmKosmosEpohaElem  , hcNoContext, False );
   NewItem( '~I~nformation equinox ...', cmEpInf , hcNoContext, False );
   NewItem( '~S~tarting date ...', cmBeginDate  , hcNoContext, False );


  End;{ ' 룧p젹βp� ' }
    NewSubMenu( ' ~H~elp ' , hcNoContext );
    With SubMenuArray[ SubMenuNum ]^ do
     Begin

      NewItem( '~A~bout ...  ', cmAbout    , hcNoContext , True);
    {  NewItem( '~G~et info ...', cmSystemInformation    , hcNoContext , True);
     }
     End;

  End;
End;

{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇 }
{ 굇굇                                        굇굇 }
{ 굇굇  렊�젩�洙� ㄵ⒰手Ł �� �濡��� � Д��.  굇굇 }
{ 굇굇                                        굇굇 }
{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇 }

procedure TMApp.HandleEvent( ECommand : Word );


{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇� }
{ 굇�                                               굇� }
{ 굇�  꽙젷�．¡� �き� " 댂兒席졿⑨ � �昔｀젹Д ".  굇� }
{ 굇�                                               굇� }
{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇� }

procedure About;
Var
 Dialog  : PDialog ;
 R       : TRect   ;
 RetCode : Word    ;

Begin

 R.Assign( 1, 1, 55, 14 );
 Dialog := New( PDialog, Init( R, ' About ', jcCentered ));
 With Dialog^ do
  Begin

   R.Assign ( 1, 1, 40, 12 ) ;
   Insert ( New ( PStaticText,
    Init ( R,
      #13 +
      ^C'Simulation Field of View' +
      #13 +
      ^C'Version on ' + Version +
      #13#13+
{
      ^C'V.V. Nesterov,  �.V. Kuzmin,  �.�. Volchkov' +
      #13 +
      ^C'�.�. Volchkov.'#13 +
      #13 +
      ^C'Copyright � 1992..1998 ' +
}
      ^C'Copyright � 1992..' + Copy ( Version, Length (Version) - 3, 4 ) +
      #13 +
      ^C'by Anatoly Volchkov & Oleg Volchkov, Russia'+
      #13 +
      #13 +
      {
      ^C'Phone: (+7 095) 930-34-71' + #13 +
      }
      ^C'E-mail: av@proc.ru'+ #13 +
      ^C'http: //www.simfov.ru' +
      #13  ) ) );

   R.Assign( 23, 11, 34, 12 );
   Insert( New( PButton, Init( R, '~O~k', cmOk, bfNormal )));

   RetCode := Run ;

  End;

 Dispose( Dialog, Done );

End;{ About }

{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇� }
{ 굇�                                 굇� }
{ 굇�  뜝�젷� �昔璵ㅳ贍 HandleEvent.  굇� }
{ 굇�                                 굇� }
{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇� }

Begin



 TApplication.HandleEvent( ECommand );


{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇� }
{ 굇�                                 굇� }
{ 굇�     렊�젩�洙� �勝も�� Д��.     굇� }
{ 굇�                                 굇� }
{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇� }


 case ECommand of

 cmRunSatellit :
{컴컴컴컴컴컴�}

   Begin

     ExitFlag := False;
     TApplication.HandleEvent( cmQuit );
     WriteVarParameters;

   End;


 cmQuit : ExitFlag := True;
{컴컴컴}



{ 굇굇굇굇굇굇굇굇굇굇 뙠�� Help . 굇굇굇굇굇굇굇굇굇� }


  cmAbout  :
 {컴컴컴�}


    Begin
      DeskTop^.StatusLine('About SIMFOV.');
      About;
    End;

  cmSystemInformation :
 {컴컴컴컴컴컴컴컴컴�}


    Begin
      DeskTop^.StatusLine('Get information about your computer.');
      SystemInformation;
    End;

{ 굇굇굇굇굇굇굇굇굇굇굇 뙠�� ��뎸. 굇굇굇굇굇굇굇굇굇굇굇 }


  cmFileList :
 {컴컴컴컴컴}

    Begin
      {
      DeskTop^.StatusLine(' ~F2~ - Add file  ~F4~ - Edit record ~F8~ - Delete file ~'+#17+'켸~ - Select ~ESC~ - Exit');
      }
      DeskTop^.StatusLine(' ~F2~ - Add rec.  ~F4~ - Edit rec.  ~F8~ - Delete rec.  ~'+#17+'켸~ - Select  ~ESC~ - Exit');
      WFileList;

      DeskTop^.StatusLine('');

      If ListSelectFlag Then
         PFLoad( ListParamFileName, False );

    End;


  cmFileLoad  :
 {컴컴컴컴컴}

    Begin

      DeskTop^.StatusLine('~'#17'켸~ - load file  ~ESC~ - cancel');
      PFLoad( MainParamFileName, True );

    End;


  cmFileSave :
 {컴컴컴컴컴}

    Begin

      DeskTop^.StatusLine('~'#17'켸~ - Save file  ~ESC~ - cancel');
      PFSave( MainParamFileName, True );

    End;


{ 굇굇굇굇굇굇굇굇굇� 뙠�� ����똿뮁�. 굇굇굇굇굇굇굇굇굇굇 }


  cmBeginDate  :
 {컴컴컴컴컴�}

    Begin
      DeskTop^.StatusLine('~'#17'켸~ - set parameters  ~ESC~ - cancel');
      SetBeginDate;
    End;


  cmRegims  :
 {컴컴컴컴}

    Begin
      DeskTop^.StatusLine('~'#17'켸~ - set modes.  ~ESC~ - cancel');
      Setregims;
    End;


  cmEpInf :
 {컴컴컴�}

    Begin
      DeskTop^.StatusLine('~'#17'켸~ - set parameters  ~ESC~ - cancel');
      SetEpochInformation;
    End;


  cmKosmosEpohaElem :
 {컴컴컴컴컴컴컴컴�}

    Begin

      DeskTop^.StatusLine('~'#17'켸~ - set parameters  ~ESC~ - cancel');
      SetEpoh (' Parameters equinox ' , EpohaElementov );

    End;


  cmSetTeleskopPosition  :
 {컴컴컴컴컴컴컴컴컴컴�}

    Begin

      DeskTop^.StatusLine('~'#17'켸~ - set parameters  ~ESC~ - cancel');
      SetTeleskopPosition;

    End;

{ 굇굇굇굇굇� 뙠�� 뜝∥在졻�レ. 룼ㄼ��� 뒶細��. 굇굇굇굇굇 }



 cmKosmosOrbitType  :
 {컴컴컴컴컴컴컴컴}

   Begin

     DeskTop^.StatusLine('~'#17'켸~ - set parameters  ~ESC~ - cancel');

     SetOrbitType;

   End;



  cmKosmosOrbita  :
 {컴컴컴컴컴컴컴}

    Begin

      DeskTop^.StatusLine('~'#17'켸~ - set parameters  ~ESC~ - cancel');
      SetKosmosOrbita;

    End;


  cmKosmosCentralTelo :
 {컴컴컴컴컴컴컴컴컴�}

    Begin

      DeskTop^.StatusLine('~'#17'켸~ - set parameters  ~ESC~ - cancel');
      {
      If ( Not PassW )
        Then  SetObject( ' Observer  pos. ', KosmosCentralTelo,
                   KosmosCentralTeloSputnikNum, True, False, False )
        Else  SetObject( ' Observer  pos. ', KosmosCentralTelo ,
                                      KosmosCentralTeloSputnikNum ,
                                      True, True, False );
      }

      SetObject( ' Observer  pos. ', KosmosCentralTelo ,
                                     KosmosCentralTeloSputnikNum ,
                                     True, True, False );

      (*
      If ( ( KosmosCentralTelo <> 3 ) )
        Then
          Begin
            If ( Space_Earth_Flag = 2 )
              Then  TPCP := 1 ;  { 룼첓 �� 췅∥在젰� � ��´p耶. Þ音 p쳽�β }
                                 { ---------------------------------------- }
            If ( NObjectSputnikNum = 0 )
              Then  NObjectSputnikNum := 1 ; { Hβ 닁� ㄻ� ˛ⅶ�Л音 췅∥. }
                                             { --------------------------- }
          End ;
      *)

      If  ( KosmosCentralTelo = 12 )
        Then
          Begin
            KosmosCentralTelo := 3 ;
            KosmosOrbita.NaklOrbKEkv  :=  KosmosCentralTeloSputnikNum ;
            SetOptOrbit := 4 + SetOptOrbit Mod 4 ;
            Space_Earth_Flag := 2 ;
            TPCP := 0 ;
            If ( NObjectSputnikNum = 0 )
               Then  NObjectSputnikNum := 1 ; { Hβ 닁� ㄻ� ˛ⅶ�Л音 췅∥. }
          End
        Else
          Begin
            If  ( KosmosCentralTelo <> 3 )  Then
              Begin
                TPCP := 1 ;
                If ( NObjectSputnikNum = 0 )
                   Then  NObjectSputnikNum := 1 ; { Hβ 닁� ㄻ� ˛ⅶ�Л音
                                                                췅∥.     }
              End ;
          End ;



    End;


  cmOtnVecSpeed :
 {컴컴컴컴컴컴�}
     Begin

       DeskTop^.StatusLine('~'#17'켸~ - set parameters  ~ESC~ - cancel');

     End;



{ 굇굇굇굇굇굇굇굇굇굇 뙠�� 뮙ゥ稅��. 굇굇굇굇굇굇굇굇굇굇 }


  cmPoleZr :
 {컴컴컴컴}

    Begin
      DeskTop^.StatusLine('~'#17'켸~ - set parameters  ~ESC~ - cancel');
      SetPoleZr;
    End;


  cmFotometrHar :
 {컴컴컴컴컴컴�}

    Begin
      DeskTop^.StatusLine('~'#17'켸~ - set parameters  ~ESC~ - cancel');
      SetFotometrHar;
    End;


  cmFotoPriemnik  :
 {컴컴컴컴컴컴컴}

    Begin
      DeskTop^.StatusLine('~'#17'켸~ - set parameters  ~ESC~ - cancel');
      SetFotoPriemnik;
    End;


  cmEkvCoord :
 {컴컴컴컴컴}

    Begin

      DeskTop^.StatusLine('~'#17'켸~ - set parameters  ~ESC~ - cancel');
      If ( Regims.DetCdc = 0 )
        Then  SetStdRec( ' Equatorial coordinates ','Right ascension',
                          'Declination' ,EkvCoord, False, True )
        Else  SetStdRec( ' Galactic coordinates ','Longitude',
                          'Latitude   ' ,EkvCoord, False, True );

    End;


  cmHorCoord :
 {컴컴컴컴컴}

    Begin

      DeskTop^.StatusLine('~'#17'켸~ - set parameters  ~ESC~ - cancel');
      SetStdRec( ' Horizontal coordinates ','Azimuth  ',
                'Height' ,HorCoord,True,True );

    End;


  cmOrbCoord :
 {컴컴컴컴컴}

    Begin

      DeskTop^.StatusLine('~'#17'켸~ - set parameters  ~ESC~ - cancel');
      SetIdentificationOrient;

    End;


  cmObject :
 {컴컴컴컴}

    Begin

      DeskTop^.StatusLine('~'#17'켸~ - set parameters  ~ESC~ - cancel');

      SetObject( ' Object ', NObject, NObjectSputnikNum,
                 ((Space_Earth_Flag = 2 ) Or ( KosmosCentralTelo <> 3 )),
                                       True, True );

    End;


{ 굇굇굇굇굇굇굇굇굇굇 뙠��  렊蔚も�. 굇굇굇굇굇굇굇굇굇굇 }



  cmSetCatalogFlag :
 {컴컴컴컴컴컴컴컴}

    Begin

      DeskTop^.StatusLine('~'#17'켸~ - set parameters  ~ESC~ - cancel');
      SetCatalogFlag    ;

    End;


  cmSetIdentRad :
 {컴컴컴컴컴컴�}

    Begin
      DeskTop^.StatusLine('~'#17'켸~ - set parameters  ~ESC~ - cancel');
      SetIdentificationRadii;
    End;


  cmSetCatalogDir :
 {컴컴컴컴컴컴컴�}

    Begin
      DeskTop^.StatusLine('~'#17'켸~ - set parameters  ~ESC~ - cancel');
      SetCatalogDir     ;
    End;



  cmSetEDir :
 {컴컴컴컴�}

    Begin
      DeskTop^.StatusLine('~'#17'켸~ - set parameters  ~ESC~ - cancel');
      SetEDir     ;
    End;


 End;

 HeadRun;

End;

{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇� }
{ 굇�                             굇� }
{ 굇�  뜝�젷� ＋젪��� �昔｀젹щ.  굇� }
{ 굇�                             굇� }
{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇� }

Label BeginRun;

Begin

 Exitflag        := False ;

 DateOld         := False ;  { H� ⓤ��レ㎜쥯筍 收ゃ芋� 쩆栒
                               ㄻ� ��¡． 쥯p쯄��� }
 SatElementsOld  := False ;  { Hβ 飡쟰音 姉�Д�獸� 췴〃� 召呻�Ø�� }


{$IFNDEF DPMI}

{ 幡賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽� }
{ �  댂ⓩ쯄エ쭬與� М�ⓥ췴� �´pゥⅱ. � }
{ 白複複複複複複複複複複複複複複複複複� }


    If ( OvrExtraSize  = 0 )
      Then
        OvrInit ( 'F:\Temp\ASimFOV.OVR' )
        {
        OvrInit ( 'C:\Temp\ASimFOV.OVR' )
        OvrInit ( 'E:\Temp\ASimFOV.OVR' )
        }
      Else
        OvrInit (  ParamStr ( 0 )  ) ; { 꽞�  Copy /b  Name.Exe + Name.Ovr }
                                       { 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴� }


 If OvrResult <> OvrOk  Then
  Begin
   Writeln ( 'Overlay dont load.' ) ;
   Halt ( 1 );
  End ;


 OvrInitEms ;



 Size := OvrGetBuf + OvrExtraSize ;

 OvrSetBuf  ( Size ) ;

 If ( OvrExtraSize  > OvrGetBuf )
   Then OvrSetRetry ( Size  Div  3 ) ;

{$ENDIF}
 {
 If ( KeyPressed )
    Then
      Begin
        ChPassW := GetKey ;
        If ChPassW = KbPgDn
          Then  PassW := True
          Else  PassW := False ;
      End
    Else
        PassW := False ;
 }


 { 複複複複複複複複複複複複 }
 {
 PassW := True ;
 PassW := False ;
 }
 { 賽賽賽賽賽賽賽賽賽賽賽賽 }


 InitVarMenu ;
 SetVarParameters;

{ *************************************************************
 PFLoad( '0', False );
   ************************************************************* }


 { 굇굇� 댂ⓩ쯄エ쭬與� �昔｀젹щ. 굇굇� }

BeginRun:;
             SymFOVApp.Init;

 { 굇굇굇굇 맆‘�� �昔｀젹щ. 굇굇굇굇� }


             SymFOVApp.Run;

 { 굇굇굇 뇿´p蜈��� �昔｀젹щ. 굇굇굇� }

             SymFOVApp.Done;


 If Not ExitFlag Then
   Begin

     OptSatMultCat  (  MainParamFileName, False );
     If ( Not Stop )  Then
       SetVarParameters;
     GoTo BeginRun;

   End;


      { 롟¡‘┐���� 캙э殊 ��� 姉�Д��젹� 召呻�Ø�� }
      { 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴 }


            {$I-}
     Reset ( SatElemFile ) ;
            {$I+}
     If ( IoResult = 0 )  Then
        Begin
          Close ( SatElemFile ) ;
          Erase ( SatElemFile ) ;
        End ;

            {$I-}
     Reset ( SatNameFile ) ;
            {$I+}
     If ( IoResult = 0 )  Then
        Begin
          Close ( SatNameFile ) ;
          Erase ( SatNameFile ) ;
        End ;


     CBlockPlanet := 0 ;

     While PlanetAllocFlag [ CBlockPlanet ] Do
       Begin
         FreeMem ( PlanetPtr [ CBlockPlanet ], SizeOf ( PlanetArrType ));
         PlanetAllocFlag [ CBlockPlanet ] := False ;
         Inc ( CBlockPlanet ) ;
       End;
     NPlanetsInFild := 0 ;



 WriteLn ;
 Write  ( '     �袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴�  ');
 Write  ( Version );
 WriteLn( ' 袴袴敲');
 {
 WriteLn( '     �袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴�  17 Nov 1998 袴袴敲');
 WriteLn( '     �                                                                  �');
 }
 WriteLn( '     �                                                                  �');
 WriteLn( '     �                 System sIMulation Field Of View                  �');
 WriteLn( '     �    Copyright (c)1992..2002 by Anatoly Volchkov, Oleg Volchkov    �');
 WriteLn( '     �                      All rights reserved.                        �');
 WriteLn( '     �                         Moscow, Russia.                          �');
 WriteLn( '     �                   Phone: (007 095) 930-34-71                     �');
 WriteLn( '     �                       E-mail: av@proc.ru                     �');
 WriteLn( '     �                      http://www.simfov.ru                        �');
 {
 WriteLn( '     �                                                                  �');
 WriteLn( '     �                 댾��レ㎜쥯��� ��ゥ짛レ��� ぎ�Ŀ                  �');
 WriteLn( '     �                칛Ð�ㄸ� � �鼇‘嶺臾  pⅶ乘蚓졻젹                 �');
 WriteLn( '     �                                                                  �');
 }
 WriteLn( '     훤袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴暠');

End.
