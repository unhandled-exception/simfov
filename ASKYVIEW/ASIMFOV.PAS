{ ┌──────────────────────────────────────────────────────────────────────┐ }
{ │                                                                      │ }
{ │                            S I M   F O V                             │ }
{ │                                                                      │ }
{ │         Система моделиpования поля зpения оптических пpибоpов.       │ }
{ │                                                                      │ }
{ │ SimFov Version 2.0a Copyright (c) 1992,..,1998 by Sternberg Institut.│ }
{ │                                                                      │ }
{ └──────────────────────────────────────────────────────────────────────┘ }

{$F+}

Program ASimFOV;

{ ▒▒▒▒▒▒▒▒▒▒▒▒▒ Имена используемых модулей. ▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }

Uses

{ ▒▒▒▒▒▒▒▒▒▒▒ Стандартные модули Turbo Pascal. ▒▒▒▒▒▒▒▒▒▒▒ }

{$IFNDEF DPMI}

   Overlay,

{$ENDIF}

{ ▒▒▒▒▒▒▒▒▒ Дополнительные модули ( заголовки ). ▒▒▒▒▒▒▒▒▒ }

   TStdObj  , TApp     , TMsgWin  , TDialogs ,
   Crt,       TDrivers , {TProtect ,}

   PVarMenu ,


   SSVar    , SSError  , SSCatFlg , SSCatDir , SSObject ,
   SSStdRec , SSEpoh   , SSTelPos , SSKosOrb , SSFotPri ,
   SSPoleZr , SSFotHar , SSList   , SSFile   , SSRegims ,
   SSInfo   , SSEDir   , SSTOrbit , SSBegDat , SSHead   ,
   SSFont   , SSEpInf  , SSRadDet , SSOrient ,

   { ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }

   OptSatMc ,  InitVMn   ,  PVar;


{ ▒▒▒▒▒▒▒▒▒▒ Стандартные модули пакета OVSTPROF. ▒▒▒▒▒▒▒▒▒ }

{ ▒▒▒▒▒▒▒▒▒▒        OVSTPROF Version 2.0         ▒▒▒▒▒▒▒▒▒ }
{ ▒▒▒▒▒▒▒▒▒▒    Copyright(c) 1992 by OVSoft.     ▒▒▒▒▒▒▒▒▒ }

{$IFNDEF DPMI}

{$O TStdObj  } { Основные определения дла пакета OVSTPROF.      }
{$O TApp     } { Основной объект пакета OVSTPROF.               }
{$O TDialogs } { Организация диалоговых окон в пакете OVSTPROF. }
{$O TMsgWin  } { Стандартные диалоговые окна OVSTPROF.          }

{ ▒▒▒▒▒▒▒▒ Модули используемые в данной программе. ▒▒▒▒▒▒▒ }


{$O SSBegDat } { Установка начального момента и шага.     }{ SetBeginDate }
{$O SSCatDir } { Установка используемых директорий.       }{ SetCatalogDir  }
{$O SSCatFlg } { Установка используемых каталогов.        }{ SetCatalogFlag }
{$O SSEDir   } { Установка дополнительных директорий.     }{ SetEDir  }
{$O SSEpInf  }
{$O SSEpoh   } { ** Описание в модуле.                    }{ SetEpoh        }
{$O SSError  } { Выдача сообщений об ошибках.             }{}
{$O SSFile   } { ** Описание в модуле.                    }{}
{$O SSFont   }
{$O SSFotHar } { Установка фотометрических характеристик. }{ SetFotometrHar }
{$O SSFotPri } { Фотоприемник.                            }{ SetFotoPriemnik }
{$O SSHead   } 
{$O SSInfo   } { Выдача инфоpмации о системных pесуpсах.  }{ SysInfo }
{$O SSKosOrb } { Установка параметров орбиты.             }{ SetKosmosOrbita }
{$O SSList   } { Работа со списком файлов паpаметpов.     }{ WFileList }
{$O SSObject } { Установка центрального объекта.          }{ SetObject      }
{$O SSOrient }
{$O SSPoleZr } { Установка поля зрения.                   }{ SetPoleZr      }
{$O SSRadDet }
{$O SSRegims } { Установка pежимов  pаботы.               }{ SetRegims }
{$O SSStdRec } { ** Описание в модуле.                    }{ SetStdRec      }
{$O SSTOrbit } { Способ задания оpбиты.                   }{ SetOrbitType }
{$O SSTelPos } { Установка позиции телескопа.             }{ SetTeleskopPosition }




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


{ ▒▒▒▒▒▒ Стандартные константы программы SimFOV. ▒▒▒▒▒▒ }


Const

  OvrExtraSize  =  0 ;

  CmRunSatellit =  10000 ;


{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ Служебное меню. ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }

   cmAbout                 =  1001 ;

{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ Меню ФАЙЛ. ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }

   cmFileList              =  1101 ;
   cmFileLoad              =  1102;
   cmFileSave              =  1103;
   cmSystemInformation     =  1105 ;


{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ Меню ПАРАМЕТРЫ. ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }

   cmBeginDate             =  1011 ;
   cmRegims                =  1012 ;

{ ▒▒▒▒▒▒▒▒▒▒▒▒ Меню Наблюдатель. Подменю Земля. ▒▒▒▒▒▒▒▒▒▒ }

   cmSetTeleskopPosition   =  1024 ;

{ ▒▒▒▒▒▒▒▒▒▒▒ Меню Наблюдатель. Подменю Космос. ▒▒▒▒▒▒▒▒▒▒ }

   cmKosmosCentralTelo     = 1033 ;
   cmKosmosOrbitType       = 1034 ;
   cmKosmosOrbita          = 1035 ;
   cmOtnVecSpeed           = 1036 ;
   cmKosmosEpohaElem       = 1037 ;

{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ Меню Телескоп. ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }

   cmPoleZr                =  1041 ;
   cmFotometrHar           =  1042 ;
   cmFotoPriemnik          =  1044 ;
   cmEkvCoord              =  1045 ;
   cmHorCoord              =  1046 ;
   cmOrbCoord              =  1047 ;
   cmObject                =  1050 ;

{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ Меню  Объекты. ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }

   cmSetCatalogFlag        =  1051 ;
   cmSetCatalogDir         =  1052 ;
   cmSetEDir               =  1053 ;
   cmSetIdentRad           =  1056 ;
   cmEpIzobr               =  1054 ;
   cmEpInf                 =  1055 ;



Type

{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒ Главный объект программы. ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }

 TMApp = Object ( TApplication )

  { ▒▒▒▒▒ Инициализация программы. ▒▒▒▒▒ }

    constructor Init ;

  { ▒▒▒▒▒▒▒▒ Инициаизация меню. ▒▒▒▒▒▒▒▒ }

    procedure InitMenu ;virtual;

  { ▒▒▒▒ Обработка действий от выбора в меню. ▒▒▒▒ }

    procedure HandleEvent( ECommand : Word ); virtual ;

    procedure Draw; virtual;

 End;

Var

  SymFOVApp  : TMApp   ;
  ExitFlag   : Boolean ;
  Size       : Longint ;

{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }
{ ▒▒▒▒                                        ▒▒▒▒ }
{ ▒▒▒▒         Инициализация программы.       ▒▒▒▒ }
{ ▒▒▒▒                                        ▒▒▒▒ }
{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }

constructor TMApp.Init ;

Var
  X,Y,i   : Byte    ;

Begin

 CheckBreak := False;

{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }

  TApplication.Init;


                  { Удалять для LapTop }
                  { ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄ }

{}
                        LoadFont;
{}

  TMApp.InitMenu ;

End;

{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }
{ ▒▒▒▒                                        ▒▒▒▒ }
{ ▒▒▒▒     Постpоение дополнительных окон.    ▒▒▒▒ }
{ ▒▒▒▒                                        ▒▒▒▒ }
{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }

procedure TMApp.Draw;
Begin

  HeadRun;

End;


{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }
{ ▒▒▒▒                                        ▒▒▒▒ }
{ ▒▒▒▒           Инициаизация меню.           ▒▒▒▒ }
{ ▒▒▒▒                                        ▒▒▒▒ }
{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }

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

         End;{ Оптическая ось }

      NewItem( '~F~ield of view ...', cmPoleZr , hcNoContext, False );
      NewItem( '~P~hotometry ...', cmFotometrHar , hcNoContext, False );

{
      If PassW Then
         NewItem( '~C~CD in Fov ...', cmFotoPriemnik  , hcNoContext, False );
}
     End;{ Телескоп }



   NewSubMenu( '~O~bjects in FOV', hcNoContext );
    With SubMenuArray[ SubMenuNum ]^ do
     Begin

      NewItem( '~C~atalogs ...', cmSetCatalogFlag , hcNoContext, False );
      NewItem( '~I~dentification radii ...', cmSetIdentRad , hcNoContext, False );
      NewItem( 'Catalog ~D~irectories ...', cmSetCatalogDir , hcNoContext, False );
      NewItem( '~E~xtension Files ...', cmSetEDir , hcNoContext, False );

     End;{ Каталоги }

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

            End;{ Космос }
        End ;

     End;{ NewSubMenu( ' Наблюлатель ', hcNoContext ) }



   NewLine;
   NewItem( '~M~odes ...', cmRegims , hcNoContext, False );
   NewItem( '~P~arameters equinox ...', cmKosmosEpohaElem  , hcNoContext, False );
   NewItem( '~I~nformation equinox ...', cmEpInf , hcNoContext, False );
   NewItem( '~S~tarting date ...', cmBeginDate  , hcNoContext, False );


  End;{ ' Паpаметpы ' }
    NewSubMenu( ' ~H~elp ' , hcNoContext );
    With SubMenuArray[ SubMenuNum ]^ do
     Begin

      NewItem( '~A~bout ...  ', cmAbout    , hcNoContext , True);
    {  NewItem( '~G~et info ...', cmSystemInformation    , hcNoContext , True);
     }
     End;

  End;
End;

{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }
{ ▒▒▒▒                                        ▒▒▒▒ }
{ ▒▒▒▒  Обработка действий от выбора в меню.  ▒▒▒▒ }
{ ▒▒▒▒                                        ▒▒▒▒ }
{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }

procedure TMApp.HandleEvent( ECommand : Word );


{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }
{ ▒▒▒                                               ▒▒▒ }
{ ▒▒▒  Диалоговое окно " Информация о программе ".  ▒▒▒ }
{ ▒▒▒                                               ▒▒▒ }
{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }

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
      ^C'V.V. Nesterov,  А.V. Kuzmin,  А.А. Volchkov' +
      #13 +
      ^C'О.А. Volchkov.'#13 +
      #13 +
      ^C'Copyright № 1992..1998 ' +
}
      ^C'Copyright № 1992..' + Copy ( Version, Length (Version) - 3, 4 ) +
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

{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }
{ ▒▒▒                                 ▒▒▒ }
{ ▒▒▒  Начало процедуры HandleEvent.  ▒▒▒ }
{ ▒▒▒                                 ▒▒▒ }
{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }

Begin



 TApplication.HandleEvent( ECommand );


{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }
{ ▒▒▒                                 ▒▒▒ }
{ ▒▒▒     Обработка пунктов меню.     ▒▒▒ }
{ ▒▒▒                                 ▒▒▒ }
{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }


 case ECommand of

 cmRunSatellit :
{─────────────}

   Begin

     ExitFlag := False;
     TApplication.HandleEvent( cmQuit );
     WriteVarParameters;

   End;


 cmQuit : ExitFlag := True;
{──────}



{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ Меню Help . ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }


  cmAbout  :
 {───────}


    Begin
      DeskTop^.StatusLine('About SIMFOV.');
      About;
    End;

  cmSystemInformation :
 {───────────────────}


    Begin
      DeskTop^.StatusLine('Get information about your computer.');
      SystemInformation;
    End;

{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ Меню ФАЙЛ. ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }


  cmFileList :
 {──────────}

    Begin
      {
      DeskTop^.StatusLine(' ~F2~ - Add file  ~F4~ - Edit record ~F8~ - Delete file ~'+#17+'─┘~ - Select ~ESC~ - Exit');
      }
      DeskTop^.StatusLine(' ~F2~ - Add rec.  ~F4~ - Edit rec.  ~F8~ - Delete rec.  ~'+#17+'─┘~ - Select  ~ESC~ - Exit');
      WFileList;

      DeskTop^.StatusLine('');

      If ListSelectFlag Then
         PFLoad( ListParamFileName, False );

    End;


  cmFileLoad  :
 {──────────}

    Begin

      DeskTop^.StatusLine('~'#17'─┘~ - load file  ~ESC~ - cancel');
      PFLoad( MainParamFileName, True );

    End;


  cmFileSave :
 {──────────}

    Begin

      DeskTop^.StatusLine('~'#17'─┘~ - Save file  ~ESC~ - cancel');
      PFSave( MainParamFileName, True );

    End;


{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ Меню ПАРАМЕТРЫ. ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }


  cmBeginDate  :
 {───────────}

    Begin
      DeskTop^.StatusLine('~'#17'─┘~ - set parameters  ~ESC~ - cancel');
      SetBeginDate;
    End;


  cmRegims  :
 {────────}

    Begin
      DeskTop^.StatusLine('~'#17'─┘~ - set modes.  ~ESC~ - cancel');
      Setregims;
    End;


  cmEpInf :
 {───────}

    Begin
      DeskTop^.StatusLine('~'#17'─┘~ - set parameters  ~ESC~ - cancel');
      SetEpochInformation;
    End;


  cmKosmosEpohaElem :
 {─────────────────}

    Begin

      DeskTop^.StatusLine('~'#17'─┘~ - set parameters  ~ESC~ - cancel');
      SetEpoh (' Parameters equinox ' , EpohaElementov );

    End;


  cmSetTeleskopPosition  :
 {─────────────────────}

    Begin

      DeskTop^.StatusLine('~'#17'─┘~ - set parameters  ~ESC~ - cancel');
      SetTeleskopPosition;

    End;

{ ▒▒▒▒▒▒▒▒▒▒▒ Меню Наблюдатель. Подменю Космос. ▒▒▒▒▒▒▒▒▒▒ }



 cmKosmosOrbitType  :
 {────────────────}

   Begin

     DeskTop^.StatusLine('~'#17'─┘~ - set parameters  ~ESC~ - cancel');

     SetOrbitType;

   End;



  cmKosmosOrbita  :
 {──────────────}

    Begin

      DeskTop^.StatusLine('~'#17'─┘~ - set parameters  ~ESC~ - cancel');
      SetKosmosOrbita;

    End;


  cmKosmosCentralTelo :
 {───────────────────}

    Begin

      DeskTop^.StatusLine('~'#17'─┘~ - set parameters  ~ESC~ - cancel');
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
              Then  TPCP := 1 ;  { Пока не наблюдаем с повеpхн. иных pланет }
                                 { ---------------------------------------- }
            If ( NObjectSputnikNum = 0 )
              Then  NObjectSputnikNum := 1 ; { Hет ИКО для внеземных набл. }
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
               Then  NObjectSputnikNum := 1 ; { Hет ИКО для внеземных набл. }
          End
        Else
          Begin
            If  ( KosmosCentralTelo <> 3 )  Then
              Begin
                TPCP := 1 ;
                If ( NObjectSputnikNum = 0 )
                   Then  NObjectSputnikNum := 1 ; { Hет ИКО для внеземных
                                                                набл.     }
              End ;
          End ;



    End;


  cmOtnVecSpeed :
 {─────────────}
     Begin

       DeskTop^.StatusLine('~'#17'─┘~ - set parameters  ~ESC~ - cancel');

     End;



{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ Меню Телескоп. ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }


  cmPoleZr :
 {────────}

    Begin
      DeskTop^.StatusLine('~'#17'─┘~ - set parameters  ~ESC~ - cancel');
      SetPoleZr;
    End;


  cmFotometrHar :
 {─────────────}

    Begin
      DeskTop^.StatusLine('~'#17'─┘~ - set parameters  ~ESC~ - cancel');
      SetFotometrHar;
    End;


  cmFotoPriemnik  :
 {──────────────}

    Begin
      DeskTop^.StatusLine('~'#17'─┘~ - set parameters  ~ESC~ - cancel');
      SetFotoPriemnik;
    End;


  cmEkvCoord :
 {──────────}

    Begin

      DeskTop^.StatusLine('~'#17'─┘~ - set parameters  ~ESC~ - cancel');
      If ( Regims.DetCdc = 0 )
        Then  SetStdRec( ' Equatorial coordinates ','Right ascension',
                          'Declination' ,EkvCoord, False, True )
        Else  SetStdRec( ' Galactic coordinates ','Longitude',
                          'Latitude   ' ,EkvCoord, False, True );

    End;


  cmHorCoord :
 {──────────}

    Begin

      DeskTop^.StatusLine('~'#17'─┘~ - set parameters  ~ESC~ - cancel');
      SetStdRec( ' Horizontal coordinates ','Azimuth  ',
                'Height' ,HorCoord,True,True );

    End;


  cmOrbCoord :
 {──────────}

    Begin

      DeskTop^.StatusLine('~'#17'─┘~ - set parameters  ~ESC~ - cancel');
      SetIdentificationOrient;

    End;


  cmObject :
 {────────}

    Begin

      DeskTop^.StatusLine('~'#17'─┘~ - set parameters  ~ESC~ - cancel');

      SetObject( ' Object ', NObject, NObjectSputnikNum,
                 ((Space_Earth_Flag = 2 ) Or ( KosmosCentralTelo <> 3 )),
                                       True, True );

    End;


{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ Меню  Объекты. ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }



  cmSetCatalogFlag :
 {────────────────}

    Begin

      DeskTop^.StatusLine('~'#17'─┘~ - set parameters  ~ESC~ - cancel');
      SetCatalogFlag    ;

    End;


  cmSetIdentRad :
 {─────────────}

    Begin
      DeskTop^.StatusLine('~'#17'─┘~ - set parameters  ~ESC~ - cancel');
      SetIdentificationRadii;
    End;


  cmSetCatalogDir :
 {───────────────}

    Begin
      DeskTop^.StatusLine('~'#17'─┘~ - set parameters  ~ESC~ - cancel');
      SetCatalogDir     ;
    End;



  cmSetEDir :
 {─────────}

    Begin
      DeskTop^.StatusLine('~'#17'─┘~ - set parameters  ~ESC~ - cancel');
      SetEDir     ;
    End;


 End;

 HeadRun;

End;

{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }
{ ▒▒▒                             ▒▒▒ }
{ ▒▒▒  Начало главной программы.  ▒▒▒ }
{ ▒▒▒                             ▒▒▒ }
{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }

Label BeginRun;

Begin

 Exitflag        := False ;

 DateOld         := False ;  { Hе использовать текущую дату
                               для нового ваpианта }
 SatElementsOld  := False ;  { Hет стаpых элементов оpбит спутников }


{$IFNDEF DPMI}

{ █▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█ }
{ █  Инициализация монитоpа овеpлеев. █ }
{ █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█ }


    If ( OvrExtraSize  = 0 )
      Then
        OvrInit ( 'F:\Temp\ASimFOV.OVR' )
        {
        OvrInit ( 'C:\Temp\ASimFOV.OVR' )
        OvrInit ( 'E:\Temp\ASimFOV.OVR' )
        }
      Else
        OvrInit (  ParamStr ( 0 )  ) ; { Для  Copy /b  Name.Exe + Name.Ovr }
                                       { ───────────────────────────────── }


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


 { ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄ }
 {
 PassW := True ;
 PassW := False ;
 }
 { ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ }


 InitVarMenu ;
 SetVarParameters;

{ *************************************************************
 PFLoad( '0', False );
   ************************************************************* }


 { ▒▒▒▒▒ Инициализация программы. ▒▒▒▒▒ }

BeginRun:;
             SymFOVApp.Init;

 { ▒▒▒▒▒▒▒▒ Работа программы. ▒▒▒▒▒▒▒▒▒ }


             SymFOVApp.Run;

 { ▒▒▒▒▒▒ Завеpшение программы. ▒▒▒▒▒▒▒ }

             SymFOVApp.Done;


 If Not ExitFlag Then
   Begin

     OptSatMultCat  (  MainParamFileName, False );
     If ( Not Stop )  Then
       SetVarParameters;
     GoTo BeginRun;

   End;


      { Освобождение памяти под элементами спутников }
      { ──────────────────────────────────────────── }


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
 Write  ( '     ╔═══════════════════════════════════════════════  ');
 Write  ( Version );
 WriteLn( ' ═════╗');
 {
 WriteLn( '     ╔═══════════════════════════════════════════════  17 Nov 1998 ═════╗');
 WriteLn( '     ║                                                                  ║');
 }
 WriteLn( '     ║                                                                  ║');
 WriteLn( '     ║                 System sIMulation Field Of View                  ║');
 WriteLn( '     ║    Copyright (c)1992..2002 by Anatoly Volchkov, Oleg Volchkov    ║');
 WriteLn( '     ║                      All rights reserved.                        ║');
 WriteLn( '     ║                         Moscow, Russia.                          ║');
 WriteLn( '     ║                   Phone: (007 095) 930-34-71                     ║');
 WriteLn( '     ║                       E-mail: av@proc.ru                     ║');
 WriteLn( '     ║                      http://www.simfov.ru                        ║');
 {
 WriteLn( '     ║                                                                  ║');
 WriteLn( '     ║                 Использование нелегальной копии                  ║');
 WriteLn( '     ║                пpиводит к ошибочным  pезультатам                 ║');
 WriteLn( '     ║                                                                  ║');
 }
 WriteLn( '     ╚══════════════════════════════════════════════════════════════════╝');

End.
