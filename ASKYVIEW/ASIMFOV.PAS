{ ����������������������������������������������������������������������Ŀ }
{ �                                                                      � }
{ �                            S I M   F O V                             � }
{ �                                                                      � }
{ �         ���⥬� ������p������ ���� �p���� ����᪨� �p���p��.       � }
{ �                                                                      � }
{ � SimFov Version 2.0a Copyright (c) 1992,..,1998 by Sternberg Institut.� }
{ �                                                                      � }
{ ������������������������������������������������������������������������ }

{$F+}

Program ASimFOV;

{ ������������� ����� �ᯮ��㥬�� ���㫥�. �������������� }

Uses

{ ����������� �⠭����� ���㫨 Turbo Pascal. ����������� }

{$IFNDEF DPMI}

   Overlay,

{$ENDIF}

{ ��������� �������⥫�� ���㫨 ( ��������� ). ��������� }

   TStdObj  , TApp     , TMsgWin  , TDialogs ,
   Crt,       TDrivers , {TProtect ,}

   PVarMenu ,


   SSVar    , SSError  , SSCatFlg , SSCatDir , SSObject ,
   SSStdRec , SSEpoh   , SSTelPos , SSKosOrb , SSFotPri ,
   SSPoleZr , SSFotHar , SSList   , SSFile   , SSRegims ,
   SSInfo   , SSEDir   , SSTOrbit , SSBegDat , SSHead   ,
   SSFont   , SSEpInf  , SSRadDet , SSOrient ,

   { ������������������������������������������������������� }

   OptSatMc ,  InitVMn   ,  PVar;


{ ���������� �⠭����� ���㫨 ����� OVSTPROF. ��������� }

{ ����������        OVSTPROF Version 2.0         ��������� }
{ ����������    Copyright(c) 1992 by OVSoft.     ��������� }

{$IFNDEF DPMI}

{$O TStdObj  } { �᭮��� ��।������ ��� ����� OVSTPROF.      }
{$O TApp     } { �᭮���� ��ꥪ� ����� OVSTPROF.               }
{$O TDialogs } { �࣠������ ���������� ���� � ����� OVSTPROF. }
{$O TMsgWin  } { �⠭����� ��������� ���� OVSTPROF.          }

{ �������� ���㫨 �ᯮ��㥬� � ������ �ணࠬ��. ������� }


{$O SSBegDat } { ��⠭���� ��砫쭮�� ������ � 蠣�.     }{ SetBeginDate }
{$O SSCatDir } { ��⠭���� �ᯮ��㥬�� ��४�਩.       }{ SetCatalogDir  }
{$O SSCatFlg } { ��⠭���� �ᯮ��㥬�� ��⠫����.        }{ SetCatalogFlag }
{$O SSEDir   } { ��⠭���� �������⥫��� ��४�਩.     }{ SetEDir  }
{$O SSEpInf  }
{$O SSEpoh   } { ** ���ᠭ�� � ���㫥.                    }{ SetEpoh        }
{$O SSError  } { �뤠� ᮮ�饭�� �� �訡���.             }{}
{$O SSFile   } { ** ���ᠭ�� � ���㫥.                    }{}
{$O SSFont   }
{$O SSFotHar } { ��⠭���� �⮬����᪨� �ࠪ���⨪. }{ SetFotometrHar }
{$O SSFotPri } { ��⮯ਥ����.                            }{ SetFotoPriemnik }
{$O SSHead   } 
{$O SSInfo   } { �뤠� ���p��樨 � ��⥬��� p���p��.  }{ SysInfo }
{$O SSKosOrb } { ��⠭���� ��ࠬ��஢ �ࡨ��.             }{ SetKosmosOrbita }
{$O SSList   } { ����� � ᯨ᪮� 䠩��� ��p����p��.     }{ WFileList }
{$O SSObject } { ��⠭���� 業�ࠫ쭮�� ��ꥪ�.          }{ SetObject      }
{$O SSOrient }
{$O SSPoleZr } { ��⠭���� ���� �७��.                   }{ SetPoleZr      }
{$O SSRadDet }
{$O SSRegims } { ��⠭���� p������  p�����.               }{ SetRegims }
{$O SSStdRec } { ** ���ᠭ�� � ���㫥.                    }{ SetStdRec      }
{$O SSTOrbit } { ���ᮡ ������� �p����.                   }{ SetOrbitType }
{$O SSTelPos } { ��⠭���� ����樨 ⥫�᪮��.             }{ SetTeleskopPosition }




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


{ ������ �⠭����� ����⠭�� �ணࠬ�� SimFOV. ������ }


Const

  OvrExtraSize  =  0 ;

  CmRunSatellit =  10000 ;


{ �������������������� ��㦥���� ����. ������������������� }

   cmAbout                 =  1001 ;

{ ���������������������� ���� ����. ���������������������� }

   cmFileList              =  1101 ;
   cmFileLoad              =  1102;
   cmFileSave              =  1103;
   cmSystemInformation     =  1105 ;


{ ������������������� ���� ���������. �������������������� }

   cmBeginDate             =  1011 ;
   cmRegims                =  1012 ;

{ ������������ ���� ����⥫�. ������� �����. ���������� }

   cmSetTeleskopPosition   =  1024 ;

{ ����������� ���� ����⥫�. ������� ��ᬮ�. ���������� }

   cmKosmosCentralTelo     = 1033 ;
   cmKosmosOrbitType       = 1034 ;
   cmKosmosOrbita          = 1035 ;
   cmOtnVecSpeed           = 1036 ;
   cmKosmosEpohaElem       = 1037 ;

{ �������������������� ���� ����᪮�. �������������������� }

   cmPoleZr                =  1041 ;
   cmFotometrHar           =  1042 ;
   cmFotoPriemnik          =  1044 ;
   cmEkvCoord              =  1045 ;
   cmHorCoord              =  1046 ;
   cmOrbCoord              =  1047 ;
   cmObject                =  1050 ;

{ �������������������� ����  ��ꥪ��. �������������������� }

   cmSetCatalogFlag        =  1051 ;
   cmSetCatalogDir         =  1052 ;
   cmSetEDir               =  1053 ;
   cmSetIdentRad           =  1056 ;
   cmEpIzobr               =  1054 ;
   cmEpInf                 =  1055 ;



Type

{ �������������� ������ ��ꥪ� �ணࠬ��. ��������������� }

 TMApp = Object ( TApplication )

  { ����� ���樠������ �ணࠬ��. ����� }

    constructor Init ;

  { �������� ���樠����� ����. �������� }

    procedure InitMenu ;virtual;

  { ���� ��ࠡ�⪠ ����⢨� �� �롮� � ����. ���� }

    procedure HandleEvent( ECommand : Word ); virtual ;

    procedure Draw; virtual;

 End;

Var

  SymFOVApp  : TMApp   ;
  ExitFlag   : Boolean ;
  Size       : Longint ;

{ ������������������������������������������������ }
{ ����                                        ���� }
{ ����         ���樠������ �ணࠬ��.       ���� }
{ ����                                        ���� }
{ ������������������������������������������������ }

constructor TMApp.Init ;

Var
  X,Y,i   : Byte    ;

Begin

 CheckBreak := False;

{ ��������������������������������������������������������������� }

  TApplication.Init;


                  { ������� ��� LapTop }
                  { ������������������ }

{}
                        LoadFont;
{}

  TMApp.InitMenu ;

End;

{ ������������������������������������������������ }
{ ����                                        ���� }
{ ����     ����p����� �������⥫��� ����.    ���� }
{ ����                                        ���� }
{ ������������������������������������������������ }

procedure TMApp.Draw;
Begin

  HeadRun;

End;


{ ������������������������������������������������ }
{ ����                                        ���� }
{ ����           ���樠����� ����.           ���� }
{ ����                                        ���� }
{ ������������������������������������������������ }

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

         End;{ ����᪠� ��� }

      NewItem( '~F~ield of view ...', cmPoleZr , hcNoContext, False );
      NewItem( '~P~hotometry ...', cmFotometrHar , hcNoContext, False );

{
      If PassW Then
         NewItem( '~C~CD in Fov ...', cmFotoPriemnik  , hcNoContext, False );
}
     End;{ ����᪮� }



   NewSubMenu( '~O~bjects in FOV', hcNoContext );
    With SubMenuArray[ SubMenuNum ]^ do
     Begin

      NewItem( '~C~atalogs ...', cmSetCatalogFlag , hcNoContext, False );
      NewItem( '~I~dentification radii ...', cmSetIdentRad , hcNoContext, False );
      NewItem( 'Catalog ~D~irectories ...', cmSetCatalogDir , hcNoContext, False );
      NewItem( '~E~xtension Files ...', cmSetEDir , hcNoContext, False );

     End;{ ��⠫��� }

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

            End;{ ��ᬮ� }
        End ;

     End;{ NewSubMenu( ' ����⥫� ', hcNoContext ) }



   NewLine;
   NewItem( '~M~odes ...', cmRegims , hcNoContext, False );
   NewItem( '~P~arameters equinox ...', cmKosmosEpohaElem  , hcNoContext, False );
   NewItem( '~I~nformation equinox ...', cmEpInf , hcNoContext, False );
   NewItem( '~S~tarting date ...', cmBeginDate  , hcNoContext, False );


  End;{ ' ��p����p� ' }
    NewSubMenu( ' ~H~elp ' , hcNoContext );
    With SubMenuArray[ SubMenuNum ]^ do
     Begin

      NewItem( '~A~bout ...  ', cmAbout    , hcNoContext , True);
    {  NewItem( '~G~et info ...', cmSystemInformation    , hcNoContext , True);
     }
     End;

  End;
End;

{ ������������������������������������������������ }
{ ����                                        ���� }
{ ����  ��ࠡ�⪠ ����⢨� �� �롮� � ����.  ���� }
{ ����                                        ���� }
{ ������������������������������������������������ }

procedure TMApp.HandleEvent( ECommand : Word );


{ ����������������������������������������������������� }
{ ���                                               ��� }
{ ���  ���������� ���� " ���ଠ�� � �ணࠬ�� ".  ��� }
{ ���                                               ��� }
{ ����������������������������������������������������� }

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

{ ��������������������������������������� }
{ ���                                 ��� }
{ ���  ��砫� ��楤��� HandleEvent.  ��� }
{ ���                                 ��� }
{ ��������������������������������������� }

Begin



 TApplication.HandleEvent( ECommand );


{ ��������������������������������������� }
{ ���                                 ��� }
{ ���     ��ࠡ�⪠ �㭪⮢ ����.     ��� }
{ ���                                 ��� }
{ ��������������������������������������� }


 case ECommand of

 cmRunSatellit :
{�������������}

   Begin

     ExitFlag := False;
     TApplication.HandleEvent( cmQuit );
     WriteVarParameters;

   End;


 cmQuit : ExitFlag := True;
{������}



{ �������������������� ���� Help . ������������������� }


  cmAbout  :
 {�������}


    Begin
      DeskTop^.StatusLine('About SIMFOV.');
      About;
    End;

  cmSystemInformation :
 {�������������������}


    Begin
      DeskTop^.StatusLine('Get information about your computer.');
      SystemInformation;
    End;

{ ���������������������� ���� ����. ���������������������� }


  cmFileList :
 {����������}

    Begin
      {
      DeskTop^.StatusLine(' ~F2~ - Add file  ~F4~ - Edit record ~F8~ - Delete file ~'+#17+'��~ - Select ~ESC~ - Exit');
      }
      DeskTop^.StatusLine(' ~F2~ - Add rec.  ~F4~ - Edit rec.  ~F8~ - Delete rec.  ~'+#17+'��~ - Select  ~ESC~ - Exit');
      WFileList;

      DeskTop^.StatusLine('');

      If ListSelectFlag Then
         PFLoad( ListParamFileName, False );

    End;


  cmFileLoad  :
 {����������}

    Begin

      DeskTop^.StatusLine('~'#17'��~ - load file  ~ESC~ - cancel');
      PFLoad( MainParamFileName, True );

    End;


  cmFileSave :
 {����������}

    Begin

      DeskTop^.StatusLine('~'#17'��~ - Save file  ~ESC~ - cancel');
      PFSave( MainParamFileName, True );

    End;


{ ������������������� ���� ���������. �������������������� }


  cmBeginDate  :
 {�����������}

    Begin
      DeskTop^.StatusLine('~'#17'��~ - set parameters  ~ESC~ - cancel');
      SetBeginDate;
    End;


  cmRegims  :
 {��������}

    Begin
      DeskTop^.StatusLine('~'#17'��~ - set modes.  ~ESC~ - cancel');
      Setregims;
    End;


  cmEpInf :
 {�������}

    Begin
      DeskTop^.StatusLine('~'#17'��~ - set parameters  ~ESC~ - cancel');
      SetEpochInformation;
    End;


  cmKosmosEpohaElem :
 {�����������������}

    Begin

      DeskTop^.StatusLine('~'#17'��~ - set parameters  ~ESC~ - cancel');
      SetEpoh (' Parameters equinox ' , EpohaElementov );

    End;


  cmSetTeleskopPosition  :
 {���������������������}

    Begin

      DeskTop^.StatusLine('~'#17'��~ - set parameters  ~ESC~ - cancel');
      SetTeleskopPosition;

    End;

{ ����������� ���� ����⥫�. ������� ��ᬮ�. ���������� }



 cmKosmosOrbitType  :
 {����������������}

   Begin

     DeskTop^.StatusLine('~'#17'��~ - set parameters  ~ESC~ - cancel');

     SetOrbitType;

   End;



  cmKosmosOrbita  :
 {��������������}

    Begin

      DeskTop^.StatusLine('~'#17'��~ - set parameters  ~ESC~ - cancel');
      SetKosmosOrbita;

    End;


  cmKosmosCentralTelo :
 {�������������������}

    Begin

      DeskTop^.StatusLine('~'#17'��~ - set parameters  ~ESC~ - cancel');
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
              Then  TPCP := 1 ;  { ���� �� ������ � ����p�. ���� p����� }
                                 { ---------------------------------------- }
            If ( NObjectSputnikNum = 0 )
              Then  NObjectSputnikNum := 1 ; { H�� ��� ��� ��������� ����. }
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
               Then  NObjectSputnikNum := 1 ; { H�� ��� ��� ��������� ����. }
          End
        Else
          Begin
            If  ( KosmosCentralTelo <> 3 )  Then
              Begin
                TPCP := 1 ;
                If ( NObjectSputnikNum = 0 )
                   Then  NObjectSputnikNum := 1 ; { H�� ��� ��� ���������
                                                                ����.     }
              End ;
          End ;



    End;


  cmOtnVecSpeed :
 {�������������}
     Begin

       DeskTop^.StatusLine('~'#17'��~ - set parameters  ~ESC~ - cancel');

     End;



{ �������������������� ���� ����᪮�. �������������������� }


  cmPoleZr :
 {��������}

    Begin
      DeskTop^.StatusLine('~'#17'��~ - set parameters  ~ESC~ - cancel');
      SetPoleZr;
    End;


  cmFotometrHar :
 {�������������}

    Begin
      DeskTop^.StatusLine('~'#17'��~ - set parameters  ~ESC~ - cancel');
      SetFotometrHar;
    End;


  cmFotoPriemnik  :
 {��������������}

    Begin
      DeskTop^.StatusLine('~'#17'��~ - set parameters  ~ESC~ - cancel');
      SetFotoPriemnik;
    End;


  cmEkvCoord :
 {����������}

    Begin

      DeskTop^.StatusLine('~'#17'��~ - set parameters  ~ESC~ - cancel');
      If ( Regims.DetCdc = 0 )
        Then  SetStdRec( ' Equatorial coordinates ','Right ascension',
                          'Declination' ,EkvCoord, False, True )
        Else  SetStdRec( ' Galactic coordinates ','Longitude',
                          'Latitude   ' ,EkvCoord, False, True );

    End;


  cmHorCoord :
 {����������}

    Begin

      DeskTop^.StatusLine('~'#17'��~ - set parameters  ~ESC~ - cancel');
      SetStdRec( ' Horizontal coordinates ','Azimuth  ',
                'Height' ,HorCoord,True,True );

    End;


  cmOrbCoord :
 {����������}

    Begin

      DeskTop^.StatusLine('~'#17'��~ - set parameters  ~ESC~ - cancel');
      SetIdentificationOrient;

    End;


  cmObject :
 {��������}

    Begin

      DeskTop^.StatusLine('~'#17'��~ - set parameters  ~ESC~ - cancel');

      SetObject( ' Object ', NObject, NObjectSputnikNum,
                 ((Space_Earth_Flag = 2 ) Or ( KosmosCentralTelo <> 3 )),
                                       True, True );

    End;


{ �������������������� ����  ��ꥪ��. �������������������� }



  cmSetCatalogFlag :
 {����������������}

    Begin

      DeskTop^.StatusLine('~'#17'��~ - set parameters  ~ESC~ - cancel');
      SetCatalogFlag    ;

    End;


  cmSetIdentRad :
 {�������������}

    Begin
      DeskTop^.StatusLine('~'#17'��~ - set parameters  ~ESC~ - cancel');
      SetIdentificationRadii;
    End;


  cmSetCatalogDir :
 {���������������}

    Begin
      DeskTop^.StatusLine('~'#17'��~ - set parameters  ~ESC~ - cancel');
      SetCatalogDir     ;
    End;



  cmSetEDir :
 {���������}

    Begin
      DeskTop^.StatusLine('~'#17'��~ - set parameters  ~ESC~ - cancel');
      SetEDir     ;
    End;


 End;

 HeadRun;

End;

{ ����������������������������������� }
{ ���                             ��� }
{ ���  ��砫� ������� �ணࠬ��.  ��� }
{ ���                             ��� }
{ ����������������������������������� }

Label BeginRun;

Begin

 Exitflag        := False ;

 DateOld         := False ;  { H� �ᯮ�짮���� ⥪���� ����
                               ��� ������ ��p���� }
 SatElementsOld  := False ;  { H�� ��p�� ������⮢ �p��� ��⭨��� }


{$IFNDEF DPMI}

{ ������������������������������������� }
{ �  ���樠������ �����p� ���p����. � }
{ ������������������������������������� }


    If ( OvrExtraSize  = 0 )
      Then
        OvrInit ( 'F:\Temp\ASimFOV.OVR' )
        {
        OvrInit ( 'C:\Temp\ASimFOV.OVR' )
        OvrInit ( 'E:\Temp\ASimFOV.OVR' )
        }
      Else
        OvrInit (  ParamStr ( 0 )  ) ; { ���  Copy /b  Name.Exe + Name.Ovr }
                                       { ��������������������������������� }


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


 { ������������������������ }
 {
 PassW := True ;
 PassW := False ;
 }
 { ������������������������ }


 InitVarMenu ;
 SetVarParameters;

{ *************************************************************
 PFLoad( '0', False );
   ************************************************************* }


 { ����� ���樠������ �ணࠬ��. ����� }

BeginRun:;
             SymFOVApp.Init;

 { �������� ����� �ணࠬ��. ��������� }


             SymFOVApp.Run;

 { ������ ����p襭�� �ணࠬ��. ������� }

             SymFOVApp.Done;


 If Not ExitFlag Then
   Begin

     OptSatMultCat  (  MainParamFileName, False );
     If ( Not Stop )  Then
       SetVarParameters;
     GoTo BeginRun;

   End;


      { �᢮�������� ����� ��� ������⠬� ��⭨��� }
      { �������������������������������������������� }


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
 Write  ( '     ������������������������������������������������  ');
 Write  ( Version );
 WriteLn( ' ����ͻ');
 {
 WriteLn( '     ������������������������������������������������  17 Nov 1998 ����ͻ');
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
 WriteLn( '     �                 �ᯮ�짮����� �������쭮� �����                  �');
 WriteLn( '     �                �p������ � �訡���  p�����⠬                 �');
 WriteLn( '     �                                                                  �');
 }
 WriteLn( '     ������������������������������������������������������������������ͼ');

End.