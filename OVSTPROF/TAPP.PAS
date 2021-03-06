{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴� }
{ �                                                           � }
{ �                 OVSoft Text Professional.                 � }
{ �                                                           � }
{ �            룧ぅ� 칛�즤젹� 칛ⅳ췅㎛좂���硫 ㄻ�             � }
{ �           貰ℓ젺⑨ Þ收p芯⒰� � ��レ㎜쥯收ゥ�.            � }
{ �                                                           � }
{ �                      궏褻⑨  2.0                          � }
{ �                                                           � }
{ �                  Copyright (c) 1992 by                    � }
{ �                                                           � }
{ �                 Oleg Volchkov Software.                   � }
{ �                                                           � }
{ �                   All right reserved.                     � }
{ �                                                           � }
{ 쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴� }
{ �                                                           � }
{ �               IBM   PC XT, PC AT 286/386.                 � }
{ �              뙫�ⓥ췴�  EGA, VGA, Hercules.                � }
{ �                                                           � }
{ 쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴� }
{ �                                                           � }
{ �                      뙫ㅳレ TApp.                         � }
{ �                                                           � }
{ �         뙫ㅳレ �‥召ηÐ좐蟯� p젩�栒 칛�즤젹щ.           � }
{ �                                                           � }
{ 쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴� }
{ �                                                           � }
{ �                     Turbo  Pascal                         � }
{ �                      Version 6.0                          � }
{ �                Copyright (c) 1983,90 by                   � }
{ �               Borland International, Inc                  � }
{ �                                                           � }
{ 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴� }
{$F+,O+}

Unit TApp;
Interface

Uses Crt,  Dos, TDrivers,
     TMenu, TStdObj,
     TUtil, TColors ;

Type

  PMainMenu      = ^MainMenuObject;

{  PStatusLine    = ^TStatusLine;
}

  PDeskTop = ^TDeskTop ;
  TDeskTop = Object

   ScreenMode     :  Word ;

   LastScreenMode :  Word ;  { 뢱ⅳ琉申Ł pⅵº 咨p젺�. }

   LastScreenAttr :  Byte ;  { 뢱ⅳ琉申Ł 졻pÆ呻 歲Б�ギ� 췅 咨p젺�. }

   MMark          :  Pointer;

   LWindMin,
   LWindMax       :  Word ;


   TWindMin,
   TWindMax       :  Word ;

   IDString       :  String ;

   constructor Init {( IStr : String )} ;

   procedure Draw ;

   destructor Done ;

   procedure PutOptions( OStr : String );
   procedure StatusLine( SStr : String );

   procedure MonoPalette;

  end;

  PApplication = ^TApplication;
  TApplication = Object

    DeskTop   : PDeskTop        ;
    AppMenu   : PMainMenu ;

    AppEvent  : Word;

    constructor Init {( IStr : String )} ;

    procedure HandleEvent( ECommand : Word ); virtual ;
	
    procedure InitMenu; virtual;

    procedure Run;

    procedure Draw; virtual;

    procedure Done ; virtual;

    procedure LFont;

  end;{ TApplication }


Implementation

Var
  WFlag : Boolean ;

{ 뢱�璵ㅳp� � 押�ゆĿ �↔ⅹ�� TDeskTop. }
{ 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴� }

constructor TDeskTop.Init {( IStr : String )} ;
begin

 SetCBreak( False );

 Mark( MMark );

{ LastScreenMode := LastMode ;

 ScreenMode     := CO80;

 LastScreenAttr := TextAttr ;
 
 LWindMin       := WindMin  ;
 LWindMax       := WindMax  ;

 TextMode( ScreenMode  );
}
  InitVideo;
   
end;{ TDeskTop.Init }

{ 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴 }

procedure TDeskTop.Draw ;
begin

 Window( 1, 1, VideoXRes, VideoYRes + 1 );

 TWindMin       := WindMin  ;
 TWindMax       := WindMax  ;

 FillWin( DeskTopFillChar, DeskTopNormalText );

 WriteChar( 1,1, VideoXRes, ' ', DeskTopLineText );
 WriteChar( 1,VideoYRes + 1, VideoXRes, ' ', DeskTopLineText );

{ WriteStr( 2, 25, IDString, DeskTopLineText );
 }

{ WriteStr( 61,25,' � 맓┬�:', DeskTopLineText );
 }
 HiddenCursor;

end;{ TDeskTop.Draw }

{ 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴 }
procedure TDeskTop.PutOptions( OStr : String );
begin

  WriteChar(70,25,20,' ',  DeskTopLineText);

  If Length( OStr ) = 0 Then exit;

{  WriteStr(  70 , 25, OStr , DeskTopOptText );
}
  WriteStr(  70 , 25, ' ' + OStr + ' ', DeskTopOptText );


end;

{ 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴� }

procedure TDeskTop.StatusLine( SStr : String );
begin

  WriteChar( 1, VideoYRes + 1, VideoXRes,' ',  DeskTopLineText);

  If Length( SStr ) = 0 Then exit;

  ColorPut( 2, videoYRes + 1, SStr , DeskTopStatLineText,DeskTopStatLineAcText );

end;

{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇  }

procedure TDeskTop.MonoPalette;
begin

  DeskTopNormalText       :=   Black      +  Black      *  16 ;
  DeskTopLineText         :=   Black      +  LightGray  *  16 ;
  DeskTopStatLineText     :=   Black      +  LightGray  *  16 ;
  DeskTopStatLineAcText   :=   White      +  LightGray    *  16 ;

end;

{ 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴 }

destructor TDeskTop.Done ;
begin

 DoneVideo;

{ TextMode( LastScreenMode  );


 Window( 1, 1, 80, 25 );;


 TextAttr := LastScreenAttr ;

 ClrScr;

 NormalCursor;
 }
 
 Release ( MMark );

 SetCBreak( True );

end;{ TDeskTop.Done }

{ 뢱�璵ㅳp� � 押�ゆĿ �↔ⅹ�� TApplication. }
{ 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴� }

constructor TApplication.Init{( IStr : String ) };
begin


  AppEvent := cmNoAlt ;

  DeskTop := New( PDeskTop, Init {( IStr )} );

end;{ TApplication.Init }

{ 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴 }

procedure TApplication.HandleEvent( ECommand : Word ) ;
begin

 If ECommand = cmQuit Then  WFlag := False ;

end;{ TApplication.HandleEvent }

{ 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴 }

procedure TApplication.InitMenu ;
begin

  AppMenu := New( PMainMenu, Init );

end;{ TApplication.InitMenu }

{ 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴 }

procedure TApplication.Draw ;
begin

end;

{ 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴 }

procedure TApplication.LFont ;
begin

end;

{ 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴 }

procedure TApplication.Run ;
Var SLEvent : Word;
begin

WFlag := True ;

DeskTop^.Draw;

Draw ;

If AppMenu <> nil Then
 While WFlag do
  begin

    Window( 1,1,VideoXRes,VideoYRes + 1 );
    DeskTop^.StatusLine( MenuStatusString );

    AppEvent := AppMenu^.MainMenuSelect ;

    DeskTop^.StatusLine('');

    HandleEvent( AppEvent );

  end;


end;{ TApplication.Run }


{ 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴 }

procedure TApplication.Done ;
begin

 if AppMenu <> nil then
  Dispose( AppMenu );

 Dispose( DeskTop, Done );

end;

end.
