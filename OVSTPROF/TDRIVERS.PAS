{ 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴� }
{ �                                                           � }
{ �                    OVSoft  Pascal + +                     � }
{ �                                                           � }
{ �            룧ぅ� 칛�즤젹� 칛ⅳ췅㎛좂���硫 ㄻ�             � }
{ �           貰ℓ젺⑨ Þ收p芯⒰� � ��レ㎜쥯收ゥ�.            � }
{ �                                                           � }
{ �                      궏褻⑨  1.0                          � }
{ �                                                           � }
{ �                Copyright (c) 1992,93 by                   � }
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
{ �                    뙫ㅳレ TDrivers.                       � }
{ �                                                           � }
{ �         뢱�璵ㅳp� � 押�ゆĿ ㄻ� p젩�瞬 � ㄸ召ゥ��,        � }
{ �                   か젪쯄栒p��, щ夭�,                     � }
{ �             � �젶┘ ∥�� ％�쩺졿Ŀ 貰�↓��Ł.             � }
{ �                                                           � }
{ 쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴� }
{ �                                                           � }
{ �                     Turbo  Pascal                         � }
{ �                   Version 6.0, 7.0                        � }
{ �                Copyright (c) 1983,92 by                   � }
{ �               Borland International, Inc                  � }
{ �                                                           � }
{ 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴� }

{$F+,O+}
Unit TDrivers;
Interface

Uses TStdObj, Crt, Dos;

{ 겓�� ％�쩺졿Ŀ 貰�↓��Ł }
{ 複複複複複複複複複複複複 }

Const

{  뮜� 貰�↓��⑨  }
{ 賽賽賽賽賽賽賽� }

  evMouse      =   $000F;
  evKeyboard   =   $0010;
  evMessage    =   $FF00;
  evNothing    =   $0000;

{ 뫌�↓��⑨ � 貰飡�輾Ŀ }
{ 賽賽賽賽賽賽賽賽賽賽� }

  evMouseDown  =   $0001;
  evMouseUp    =   $0002;
  evMouseMove  =   $0004;
  evMouseAuto  =   $0008;
  evKeyDown    =   $0010;
  evCommand    =   $0100;
  evBroadcast  =   $0200;

{ 뙛稅� 貰飡�輾⑨ き���� }
{ 賽賽賽賽賽賽賽賽賽賽賽 }

  mbLeftButton   = $01;
  mbRightButton  = $02;
  mbCenterButton = $04;

  mbButtonsMask  = $06;

  DoubleDelay    =  4;

Type

  TMouseEvent = Record

    Buttons     : Word;     { 뫌飡�輾⑨ き���� щ鼇 }
    Where       : TPoint;   { 뒶췴ㄸ췅瞬 щ鼇       }
    DoubleClick : Boolean;  { 뵭젫 ㄲ�þ�． 췅쬊殊� }

  end;{ TMouseEvent }

{ 묅p丞栒p� � ぎ獸p�� 貰�p젺畑恂� ��キ좑 Þ兒p쵟與� � 貰�↓��Ŀ }
  TEvent = Record

    What        : Word;        { 뮜� 貰〓殊�    }
    KeyCode     : Word;        { 뒶� か젪②�    }
    Mouse       : TMouseEvent; { 뫌飡�輾�� щ鼇 }
    MessageCode : Word;        { 뒶� 貰�↓��⑨  }

  end;

procedure GetEvent( Var Event : TEvent );{ 룼ャ曄��� 貰�↓��⑨ }

{ 룯p�Д��瑜 ㄻ� p젩�瞬 � щ夭�. }
{ 賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }
Const
   MouseSig : Boolean = False;

Var

  MouseStatus : Boolean;
  MousePoint  : TPoint;
  MouseButton : Word;
  MouseButtonCount : Byte;

{ 붵�ゆĿ ㄻ� p젩�瞬 � щ夭� }
{ 賽賽賽賽賽賽賽賽賽賽賽賽賽 }

procedure InitMouse; { 댂ⓩ쯄エ쭬與� щ鼇   }
procedure DoneMouse; { 뇿챥淫�� щ鼇        }
procedure ShowMouse; { 룼첓쭬筍 ゃp貰p щ鼇 }
procedure HideMouse; { 뫇p淫� ゃp貰p щ鼇   }


{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇 }

{ 룯p�Д��瑜 � ぎ�飡젺瞬 ㄻ� p젩�瞬 � ˘ㄵ�歲飡�М� }

Type

  VideoTypes = ( MDA, CGA, MCGA, EGA, VGA );

Const

{ 뙫ㄵエ ˘ㄵ츫쩆�收p�� }

  vsMDA        =   1; { MDA ㄸ召ゥ�                             }
  vsCGA        =   2; { CGA ㄸ召ゥ�                             }
  vsEGAExtCol  =   3; { EGA � 乘晨蜈�臾 歟β�臾 ㄸ召ゥ��        }
  vsEGACol     =   4; { EGA � 歟β�臾 ㄸ召ゥ��                  }
  vsEGAMono    =   5; { EGA � М���p�Л臾 젺젷�．�臾 ㄸ召ゥ��   }
  vsPGC        =   6; { 뢱�芯遜Ŧ췅レ�硫 즤졽①αえ� ぎ��p�カ쩺 }
  vsVGAMono    =   7; { VGA � М���p�Л臾 젺젷�．�臾 ㄸ召ゥ��   }
  vsVGACol     =   8; { VGA � 歟β�臾 젺젷�．�臾 ㄸ召ゥ��       }
  vsMCGACol    = $0A; { MCGA � 歟β�臾 與�p��臾 ㄸ召ゥ��        }
  vsMCGAMono   = $0B; { MCGA � М���p�Л臾 젺젷�．�臾 ㄸ召ゥ��  }
  vsMCGAColAn  = $0C; { MCGA � 歟β�臾 젺젷�．�臾 ㄸ召ゥ��      }

{ 맓┬щ p젩�瞬 ˘ㄵ�歲飡�щ }
  vsCO80    =    CO80;
  vsBW80    =    BW80;
  vsMono    =    Mono;
  vsFont8x8 =    Font8x8;

{ 묅젺쩆p狩瑜 p젳Дp� �ぎ��音 收�ⅸ }
  vsNormalShadow = 2;
  vsSmallShadow  = 1;

Const

  sdScrollUp  = 6;  { 뢱�챥呻첓 �き� ⇔쩺�                                  }
  sdScrollDn  = 7;  { 뢱�챥呻첓 �き� ˛��                                   }

Const

{ 뮙ゃ蟯� pⅵº 咨p젺� }
  VideoMode  : Integer = vsCO80;

  Font8x8Selected : Boolean = False;

{ 뫁，��� ˘ㄵ�캙э殊 }
  VideoSeg   : Word = $B800;

Var

{ 뮙ゃ蟯� ˘ㄵ츫쩆�收p }
  VideoType : VideoTypes;

{ 맓┬� ㄸ召ゥ� �쩺ⅳ 췅�젷�� p젩�瞬 칛�즤젹щ }
  VideoOldMode  : Integer ;

{ 뿨笹� 飡p�� 췅 咨p젺� -1 }
  VideoYRes      : Byte  absolute $0000:$0484;

{ 뿨笹� ぎギ��� 췅 咨p젺� }
  VideoXRes      : Byte  absolute $0000:$044A;

{ 맆㎚쩺 收�� ㄻ� �ぎ� }
  VideoShadow  : Byte;

Type

{ 뫅Б�ル ㄻ� 兒pЖp�쥯�⑨ p젹�� }
  FrameChars = array[1..8] of Char;

{ 묅p丞栒p� � ぎ獸p�� 쭬��Ж췅β碎 貰飡�輾�� �き� }
  WinState = record
    WindMin, WindMax: Word;
    WhereX, WhereY: Byte;
    TextAttr: Byte;
  end;

  TitleStrPtr = ^TitleStr;
  TitleStr = string[63];

  WinRecPtr = ^WinRec;
  WinRec = record
    Next: WinRecPtr;
    State: WinState;
    Title: TitleStrPtr;
    TitleAttr, FrameAttr: Byte;
    Buffer: Pointer;
  end;

const

{ 묅젺쩆p狩瑜 p젹え ㄻ� �ぎ� }
  SingleFrame: FrameChars = '旼엿냅켸';
  DoubleFrame: FrameChars = '�敲볶훤�';
      DSFrame: FrameChars = '靈렉붉캭';
      SDFrame: FrameChars = '郞립넜槁';
    SSDDFrame: FrameChars = '旼럼붊暠';
    DDSSFrame: FrameChars = '�拷볐聃�';
    SDSSFrame: FrameChars = '郞립냅켸';

var

  TopWindow: WinRecPtr;
  WindowCount: Integer;
  Done: Boolean;

{ 붵�ゆĿ ㄻ� p젩�瞬 � ˘ㄵ�歲飡�М� }
{ 賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

procedure InitVideo;                      { 댂ⓩ쯄エ쭬與� ˘ㄵ�歲飡�щ      }
procedure DoneVideo;                      { 뇿챥淫�� ˘ㄵ�歲飡�щ           }
procedure SetVideoMode( NewMode : Word ); { 볚�젺�˚� ˘ㄵ췴ⅵº�           }
function  EGAInstalled : Boolean;         { 뮙飡쮘�쥯��� 췅 췅エ葉� EGA/VGA }
function  PS2 : Boolean;      { 뮙飡쮘�쥯��� 췅 췅エ葉� PS/2 ˘ㄵ� 젮젽收p� }

{ 귣¡� 飡p�え S 췅 咨p젺 c 졻�pÆ呻�� Attr }
procedure WriteStr(X, Y: Byte; S: String; Attr: Byte);

{ 귣¡� Count 歲Б�ギ� Ch  � 졻�pÆ呻�� Attr }
procedure WriteChar(X, Y, Count: Byte; Ch: Char; Attr: Byte);

{ 뇿Д췅 졻�pÆ呻�� 歲Б�ギ� 췅 咨p젺� 췅 졻�pÆ呻 Attr }
{ 궘º젺��: ぎ췴ㄸ췅瞬 쭬쩆荻碎 �狩�歲收レ�� ゥ¡． ´p耶ⅲ� 膝쳽 咨p젺� }
procedure ChangeAttrAbs( X, Y, Count : Byte; Attr : Byte );

{ 뇿Д췅 졻�pÆ呻�� 歲Б�ギ� 췅 咨p젺� 췅 졻�pÆ呻 Attr }
{ 궘º젺��: ぎ췴ㄸ췅瞬 쭬쩆荻碎 �狩�歲收レ�� ゥ¡． ´p耶ⅲ� 膝쳽 �き�   }
procedure ChangeAttr( X, Y, Count : Byte; Attr : Byte );

{ 뇿챥졹ⓥ� �き� 歲Б�ギ� Ch � 졻�pÆ呻�� Attr }
procedure FillWin(Ch: Char; Attr: Byte);

{ 뇿�ⓤ졻� �き� � 咨p젺� � ��쩺졻Ð�莘 캙э筍 }
procedure ReadWin(var Buf);

{ 뇿�ⓤ졻� �き� �� ��쩺졻Ð��� 캙э殊 췅 咨p젺 }
procedure WriteWin(var Buf);

{ 귣葉笹ⓥ� p젳Дp ��쩺졻Ð��� 캙э殊, ���▼�ㄸМ� ㄻ� 쭬��Ж췅�⑨ �き� }
function  WinSize: Word;

{ 뇿��Лⓥ� 캙p젹βp� �き� � �쩺�Д���� 殊캙 WinState }
procedure SaveWin(var W: WinState);

{ 궙遜�젺�˘筍 캙p젹βp� �き�, 쭬�ⓤ젺�瑜 � �쩺�Д��莘 殊캙 WinState }
procedure RestoreWin(var W: WinState);

{ 뱼�エ葉筍 p젳Дp �き� ㄻ� ¡遜�젺�˙��⑨ 칛ⅳ琉申ⅲ� 貰飡�輾⑨ }
procedure UnFrameWin;

{ 귣¡� 飡p�え p젳エ嶺臾� 歟β젹�. 볡졹獸� 收め�� � �㎚�����臾 歟β��   }
{ ㄾウ�� 〓筍 �즤젺①�� 歲Б�ギ� ~.                                     }
{ 뢱º쩺: 'H췴쵟レ�硫 歟β ~�琉�ゥ��硫 晨졹獸�~ 說�쥯 �췴쵟レ�硫 歟β'. }
Procedure ColorPut( x , y : byte; Str : String ; NormalText , AccentText : Byte );

{ 귣¡� �졹殊 飡p�え � ��㎤與� BegPos �� ��㎤與� EndPos }
Procedure ParamPut( x , y : Byte; Str : String ; BegPos, EndPos, Color : Byte);

{ 볚�젺�˚� p젳Дp츫 ゃp貰p� }
procedure SetCursorSize( StartLine, EndLine : Byte );

{ H췴쵟レ�硫 ゃp貰p:_ }
procedure NormalCursor;

{ 듽p貰p � 璵ャ� ��㎤與�: � }
procedure BlockCursor;

{ 뫇p淫� ゃp貰p }
procedure HiddenCursor;

{ 볚�젺�˘筍 16 歟β�莘 캙エ�p� 兒췅. 뮢レぎ EGA/VGA !!! }
procedure Background16On;

{ 롡Д�ⓥ� 16 歟β�莘 캙エ�p� 兒췅. 뮢レぎ EGA/VGA !!! }
procedure Background16Off;

{ 뢱�챥呻첓 �き� X1 Y1 X2 Y2 췅 Rows 飡p�� � 췅칛젪ゥ�Ŀ Dir }
procedure ScrollWindow( Dir, X1, Y1, X2, Y2, Rows : Byte );

{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇 }

{ 룯p�Д��瑜 � ぎ�飡젺瞬 ㄻ� p젩�瞬 � か젪쯄栒p�� }

Const

    kbNoKey      =    0 ;

    kbEsc        =   27 ;
    kbEnter      =   13 ;
    kbSpace      =   32 ;

 { 붵�ゆŦ췅レ�瑜 か젪②� }

    kbF1         = 2759 ;
    kbF2         = 2760 ;
    kbF3         = 2761 ;
    kbF4         = 2762 ;
    kbF5         = 2763 ;
    kbF6         = 2764 ;
    kbF7         = 2765 ;
    kbF8         = 2766 ;
    kbF9         = 2767 ;
    kbF10        = 2768 ;
    kbF11        = 2833 ;
    kbF12        = 2834 ;

    kbShiftF1    = 2784 ;
    kbShiftF2    = 2785 ;
    kbShiftF3    = 2786 ;
    kbShiftF4    = 2787 ;
    kbShiftF5    = 2788 ;
    kbShiftF6    = 2789 ;
    kbShiftF7    = 2790 ;
    kbShiftF8    = 2791 ;
    kbShiftF9    = 2792 ;
    kbShiftF10   = 2793 ;
    kbShiftF11   = 2835 ;
    kbShiftF12   = 2836 ;

    kbCtrlF1     = 2794 ;
    kbCtrlF2     = 2795 ;
    kbCtrlF3     = 2796 ;
    kbCtrlF4     = 2797 ;
    kbCtrlF5     = 2798 ;
    kbCtrlF6     = 2799 ;
    kbCtrlF7     = 2800 ;
    kbCtrlF8     = 2801 ;
    kbCtrlF9     = 2802 ;
    kbCtrlF10    = 2803 ;
    kbCtrlF11    = 2837 ;
    kbCtrlF12    = 2838 ;

    kbAltF1      = 2804 ;
    kbAltF2      = 2805 ;
    kbAltF3      = 2806 ;
    kbAltF4      = 2807 ;
    kbAltF5      = 2808 ;
    kbAltF6      = 2809 ;
    kbAltF7      = 2810 ;
    kbAltF8      = 2811 ;
    kbAltF9      = 2812 ;
    kbAltF10     = 2813 ;
    kbAltF11     = 2839 ;
    kbAltF12     = 2840 ;

{ 뒲젪②� 承p젪ゥ�⑨ ゃp貰p�� }

    kbRight      = 2777 ;
    kbLeft       = 2775 ;
    kbUp         = 2772 ;
    kbDn         = 2780 ;
    kbHome       = 2771 ;
    kbEnd        = 2779 ;
    kbPgUp       = 2773 ;
    kbPgDn       = 2781 ;
    kbTab        =    9 ;

    kbShiftTab   = 2715 ;

    kbAltUp      = 2852 ;
    kbAltLeft    = 2855 ;
    kbAltRight   = 2857 ;
    kbAltDn      = 2860 ;
    kbAltHome    = 2851 ;
    kbAltEnd     = 2859 ;
    kbAltPgUp    = 2853 ;
    kbAltPgDn    = 2861 ;
    kbAltTab     = 2865 ;

    kbCtrlUp     = 2841 ;
    kbCtrlLeft   = 2815 ;
    kbCtrlRight  = 2816 ;
    kbCtrlDn     = 2845 ;
    kbCtrlTab    = 2848 ;
    kbCtrlHome   = 2819 ;
    kbCtrlEnd    = 2817 ;
    kbCtrlPgUp   = 2832 ;
    kbCtrlPgDn   = 2818 ;

{ 뒲젪②� 蝨젷��⑨ � ㏇�젪え }

    kbIns        = 2782 ;
    kbDel        = 2783 ;

    kbAltIns     = 2862 ;
    kbAltDel     = 2863 ;

    kbCtrlIns    = 2846 ;
    kbCtrlDel    = 2847 ;

    kbAltBackspace = 2714 ;

{ 뒲젪쯄栒p�瑜 貰曄�젺⑨ }

    kbAltQ       = 2716  ;
    kbAltW       = 2717  ;
    kbAltE       = 2718  ;
    kbAltR       = 2719  ;
    kbAltT       = 2720  ;
    kbAltY       = 2721  ;
    kbAltU       = 2722  ;
    kbAltI       = 2723  ;
    kbAltO       = 2724  ;
    kbAltP       = 2725  ;

    kbAltA       = 2730  ;
    kbAltS       = 2731  ;
    kbAltD       = 2732  ;
    kbAltF       = 2733  ;
    kbAltG       = 2734  ;
    kbAltH       = 2735  ;
    kbAltJ       = 2736  ;
    kbAltK       = 2737  ;
    kbAltL       = 2738  ;

    kbAltZ       = 2744  ;
    kbAltX       = 2745  ;
    kbAltC       = 2746  ;
    kbAltV       = 2747  ;
    kbAltB       = 2748  ;
    kbAltN       = 2749  ;
    kbAltM       = 2750  ;

    kbAlt1       = 2820  ;
    kbAlt2       = 2821  ;
    kbAlt3       = 2822  ;
    kbAlt4       = 2823  ;
    kbAlt5       = 2824  ;
    kbAlt6       = 2825  ;
    kbAlt7       = 2826  ;
    kbAlt8       = 2827  ;
    kbAlt9       = 2828  ;
    kbAlt0       = 2829  ;


    kbCtrlA      = $0001 ;
    kbCtrlB      = $0002 ;
    kbCtrlC      = $0003 ;
    kbCtrlD      = $0004 ;
    kbCtrlE      = $0005 ;
    kbCtrlF      = $0006 ;
    kbCtrlG      = $0007 ;
    kbCtrlH      = $0008 ;
    kbCtrlI      = $0009 ;
    kbCtrlJ      = $000a ;
    kbCtrlK      = $000b ;
    kbCtrlL      = $000c ;
    kbCtrlM      = $000d ;
    kbCtrlN      = $000e ;
    kbCtrlO      = $000f ;
    kbCtrlP      = $0010 ;
    kbCtrlQ      = $0011 ;
    kbCtrlR      = $0012 ;
    kbCtrlS      = $0013 ;
    kbCtrlT      = $0014 ;
    kbCtrlU      = $0015 ;
    kbCtrlV      = $0016 ;
    kbCtrlW      = $0017 ;
    kbCtrlX      = $0018 ;
    kbCtrlY      = $0019 ;
    kbCtrlZ      = $001a ;

    kbGrayMinus  =   2774;
    kbGrayPlus   =   2778;
    kbGraySlash  =   2864;
    kbGrayStar   =   2755;

    kbCtrlGrayMinus  =   2842;
    kbCtrlGrayPlus   =   2844;
    kbCtrlGraySlash  =   2849;
    kbCtrlGrayStar   =   2850;

    kbKeypadIns  =   2846;
    kbKeypadDel  =   2847;

Type

  THelpProc = Procedure;

Var
  HelpKey  : Word;

procedure NulProc;

Const

  HelpFlag : Boolean = False;
  HelpProc : THelpProc = NulProc;

{ 붵�ゆĿ ㄻ� p젩�瞬 � か젪쯄栒p�� }
{ 賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽 }

function GetKey : Word;                { 룼ャ曄��� ぎ쩆 췅쬊獸� か젪②� }
function AltChar( Key : Word ) : Char; { 뢱��죖젳�쥯��� ALT-뒶� � 뒶�   }


procedure Disable;Inline($FA); { 뇿칛βⓥ� 칛쩺猶젺⑨ }
procedure Enable;Inline($FB);  { 맆쬹θⓥ� 칛쩺猶젺⑨ }


Implementation

{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇 }
{ 굇                                                                      굇 }
{ 굇                             MOUSE SERVICE                            굇 }
{ 굇                                                                      굇 }
{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇 }

Var
  Reg       : Registers;
  ExitSave  : Pointer;

  LastMouse : TMouseEvent;

  Ticks     : Word absolute $40:$6C;
  MDTicks   : Word;

Const

  DPFlag    : Boolean = False;
  BTicks    : Word    = 0;

{ 붵�ゆĿ ㄻ� p젩�瞬 � щ夭� }
{ 賽賽賽賽賽賽賽賽賽賽賽賽賽 }

{$F+}

{ 귣㏓쥯β碎 칛쩺猶젺��� щ鼇 }

procedure Mouse_Int;
begin

{  Intr( $62, Reg );} { 귣㏓쥯β MouseInterrupt }

Asm Int 62H end;

end;

{ 뢱�璵ㅳp� �죖젩�洙� 칛쩺猶젺⑨ �� щ鼇 }

procedure MouseInterrupt; Interrupt;
begin

  MouseSig := True;
  MDTicks   := Ticks;

end;

{ 뢱�璵ㅳp� �音�쩆 }

Procedure  MouseExit;
begin

  ExitProc := ExitSave;
  Reg.AX := 0;
  IntR( $33, Reg );

end;

{ 댂ⓩ쯄エ쭬與� щ鼇 }
Procedure InitMouse;
Var
  Regs : Registers;

begin

  With Regs do
    begin

    { 뤿�젰п� 信�젺�˘筍 щ夭 }
      AX := $0000;
      IntR( $33, Regs );

      If AX = $0000 then
        MouseStatus := False { Hβ щ鼇 }
          else
            begin

              MouseStatus := True;    { 끷筍 щ夭 }
              MouseButtonCount := BX; { 뿨笹� き���� щ鼇 }
              MouseSig := False;      { Hβ 歲－젷� �� щ鼇 }

            { 볚�젺젪エ쥯�� �죖젩�洵Ø 췅 $62 칛쩺猶젺�� }
              SetIntVec( $62, @MouseInterrupt );

            { 볚�젺젪エ쥯�� �죖젩�洵Ø 췅 $33 칛쩺猶젺�� }
              Regs.AX := 12; { H①ⅲ� �� 쵟稅쮘濕� }
              Regs.CX := 31;
              Regs.ES := Seg( Mouse_Int );
              Regs.DX := Ofs( Mouse_Int );
              IntR( $33, Regs );

            { 볚�젺젪エ쥯�� 칛�璵ㅳp� �音�쩆 }
              ExitSave := ExitProc;
              ExitProc := @MouseExit;

            { 룼ャ�젰� Þ兒p쵟與� � 收ゃ耀� 貰飡�輾Ŀ }

              Regs.AX := 3;
              IntR( $33, Regs );

              LastMouse.Buttons := BX;
              LastMouse.Where.X := CX;
              LastMouse.Where.Y := DX;

              Regs.AX := $0005;
              Regs.BX := $0003;
              IntR( $33, Regs );

            end;

    end;

end; { InitMouse }

{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇 }

Procedure DoneMouse;
Var
  Regs : Registers;

begin

  With Regs do
    begin

      AX := $0021;
      IntR( $33, Regs );

      If AX = $0000 then
        MouseStatus := False
          else
            begin
              MouseStatus := True;
              MouseButtonCount := BX;
            end;

    end;

end; { DoneMouse }

{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇 }

Procedure ShowMouse;
Var
  Regs : Registers;

begin

  With Regs do
    begin

      AX := 1;
      IntR( $33, Regs );

    end;

end; { ShowMouse }

{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇 }

Procedure HideMouse;
Var
  Regs : Registers;

begin

  With Regs do
    begin

      AX := 2;
      IntR( $33, Regs );

    end;

end; { HideMouse }

{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇� }

procedure GetEvent( var Event : TEvent );
Const
  Flag : Boolean = False;
Var
  Regs : Registers;
  CurMouse : TEvent;
begin

 With Event do
   begin

     What := 0;

     IF MouseSig Then { 뢱쩺猶젺�� �� щ鼇 }
       begin

         What := evMouse;
         Flag := False;

         With Mouse do
         begin

       { 룼ャ葉筍 Þ兒p쵟與� � 貰飡�輾Ŀ щ鼇 }

           Regs.AX := $0003;
           IntR( $33, Regs );

           Buttons := Regs.BX;

           Where.X := Regs.CX div 8 + 1;
           Where.Y := Regs.DX div 8 + 1;

           DoubleClick := False; { Clear DoubleClick flag. }

       { 뢱�´p첓 信ギ˘� }

           If ( Not Flag ) and ( Buttons <> 0 ) and ( LastMouse.Buttons = 0 ) Then
             begin

               What := evMouseDown;
               Flag := True;

               Regs.AX := $0005;
               Regs.BX := Buttons;
               IntR( $33, Regs );

               IF ( DPFlag ) and ( Regs.BX = LastMouse.Buttons )
                   and ( LastMouse.Where.X = Where.X )
                   and ( LastMouse.Where.Y = Where.Y ) and
                  ( ( MDTicks - BTicks ) < DoubleDelay ) Then
                 begin
                   DoubleClick := True;
                   MDTicks := Ticks;
                   DPFLag := False;
                 end
                   else
                     begin
                       DoubleClick := False;
                       DPFlag := True;
                       BTicks := Ticks;
                     end;
             end;

           If ( Not Flag ) and ( Buttons = 0 ) and ( LastMouse.Buttons <> 0 ) Then
             begin

               What := evMouseUp;
               Flag := True;
               LastMouse.Buttons := Buttons;

             end;

           If ( Not Flag ) and ( Buttons = 0 ) and
          (( Where.X <> LastMouse.Where.X ) or ( Where.Y <> LastMouse.Where.Y )) Then
             begin

               What := evMouseMove;
               Flag := True;

             end;

           If ( Not Flag ) and ( Buttons <> 0  ) and ( Buttons = LastMouse.Buttons ) and
          (( Where.X <> LastMouse.Where.x ) or ( Where.Y <> LastMouse.Where.Y )) Then
             begin

               What := evMouseAuto;
               Flag := True;

             end;

        end; { With Mouse }

       { 볚�젺젪エ쥯�� 氏젫� }

           MouseSig  := False; { Hβ �쩺猶젺⑨ �� щ鼇    }

       { 뇿��Ж췅�� 貰飡�輾� щ鼇 }

           LastMouse.Where.X     := Mouse.Where.X;
           LastMouse.Where.Y     := Mouse.Where.Y;
           LastMouse.Buttons     := Mouse.Buttons;
           LastMouse.DoubleClick := Mouse.DoubleClick;

       end
        else
         If KeyPressed Then { H젲졻� か젪②� 췅 か젪쯄栒p� }
           begin
             What := evKeyboard;
             KeyCode := GetKey;{ 룼ャ�젰� ぎ� 췅쬊獸� か젪②� }
           end
            else
              begin         { H①ⅲ� �� 칛��㎜獄� }
                What := evNothing;
              end;

   end; { With Event }

end;{ GetEvent }

{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇 }
{ 굇                                                                      굇 }
{ 굇                           VIDEO SERVICE                              굇 }
{ 굇                                                                      굇 }
{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇 }

function EGAInstalled : Boolean;
{ 뮙飡쮘�쥯��� 췅 췅エ葉� EGA/VGA }
var
  Reg : Registers;
begin
  Reg.AX := $1200;
  Reg.BX := $0010;
  Reg.CX := $FFFF;
  Intr($10, Reg);
  EGAInstalled := Reg.CX <> $FFFF;
end; { EGAInstalled }

{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇 }

function PS2 : Boolean;
{ 뮙飡쮘�쥯��� 췅 췅エ葉� PS/2 ˘ㄵ� 젮젽收p� }
var
  Regs : Registers;
begin
  Regs.AX := $1A00;
  Intr($10, Regs);
  PS2 := ((Regs.AL and $FF) = $1A) and
         ((Regs.BL and $FF) in [$07, $08, $0B, $0C]);
end; { PS2 }

{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇 }

procedure InitVideo;
Var
  Reg : Registers;
begin

  VideoOldMode := LastMode; { 뇿��Лⓥ筍 칛ⅳ琉申Ł pⅵº 咨p젺� }

  Reg.AH := $0F;
  Intr($10, Reg);           { 룼ャ曄��� 收ゃ耀． ˘ㄵ췴ⅵº� }
  if Reg.AL <> 7 then
  begin

    if EGAInstalled then
    begin
      if PS2 then
        VideoType := VGA
      else
        VideoType := EGA;
    end
    else
     begin
      if PS2 then
        VideoType := MCGA
      else
        VideoType := CGA;
     end;

    VideoMode := vsCO80;

  end
  else
   begin

    VideoType := MDA;
    VideoMode := Mono;

   end;

{  If VideoYRes > 24 Then
    VideoMode := VideoMode + Font8x8;
 }

  SetVideoMode( VideoMode ); { 볚�젺�˘筍 ���硫  pⅵº }

end;{ InitVideo }

{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇 }

procedure DoneVideo;
begin

  VideoMode := VideoOldMode; { 궙遜�젺�˘筍 췅�젷彛硫 pⅵº 咨p젺� }
  SetVideoMode( VideoMode );

end;{ DoneVideo }

{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇 }

procedure SetVideoMode( NewMode : Word );
begin

  VideoMode := NewMode;

{ 볚�젺�˘筍 ���硫 pⅵº }

  TextMode( NewMode );

{ 뢱�´p첓 쭬즤習え �pⓧ�� 8x8 }

  IF VideoMode > Font8x8 Then
    begin
      Font8x8Selected := True;
      VideoMode := VideoMode - 256;
    end
     else
       Font8x8Selected := False;
{ 귣葉笹ⓥ� 細ι���� ㄻ� ˘ㄵ�▲芯p� }

  If VideoMode = 7 Then
    VideoSeg := $B000
      else
        VideoSeg := $B800;

{ 볚�젺�˘筍 葉笹� ぎギ��� 췅 咨p젺� }

  Case VideoMode of

    CO80, BW80, Mono  : VideoXRes := 80;
    CO40, BW40        : VideoXRes := 40;

  end;{ Case VideoMode of ... }

{ 볚�젺�˘筍 p젳Дp 收�� � �き� }

  If Font8x8Selected Then
    VideoShadow := vsSmallShadow
      else
        VideoShadow := vsNormalShadow;


end;{ SetVideoMode }


{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇 }


{$L WIN}

procedure WriteStr(X, Y: Byte; S: String; Attr: Byte);
external {WIN};

procedure WriteChar(X, Y, Count: Byte; Ch: Char; Attr: Byte);
external {WIN};

procedure FillWin(Ch: Char; Attr: Byte);
external {WIN};

procedure WriteWin(var Buf);
external {WIN};

procedure ReadWin(var Buf);
external {WIN};

function WinSize: Word;
external {WIN};

procedure SaveWin(var W: WinState);
begin
  W.WindMin := WindMin;
  W.WindMax := WindMax;
  W.WhereX := WhereX;
  W.WhereY := WhereY;
  W.TextAttr := TextAttr;
end;

procedure RestoreWin(var W: WinState);
begin
  WindMin := W.WindMin;
  WindMax := W.WindMax;
  GotoXY(W.WhereX, W.WhereY);
  TextAttr := W.TextAttr;
end;

procedure UnFrameWin;
begin
  Dec(WindMin, $0101);
  Inc(WindMax, $0101);
end;

{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇 }

procedure ChangeAttrAbs( X, Y, Count : Byte; Attr : Byte );
Var
   i : Byte;

begin

{ 뢱�´pⓥ� 칛젪Œ彛�飡� 쭬쩆�⑨ 캙p젹βp�� }

  If ( X > VideoXRes ) or ( Y > VideoYRes + 1 ) Then
    Exit;

  If  X + Count > VideoXRes Then
    Count := VideoXRes - X + 1;

{ 롟��˛�� 與か 쭬Д�� 졻pÆ呻�� 收め�� }

  For I := 0 To Count - 1 do
    begin

      Mem[ VideoSeg :
      ( ( Y - 1 ) * VideoXRes * 2 ) + ( X - 1 ) * 2 + i * 2 + 1  ] := Attr;

    end;

end;

{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇 }

procedure ChangeAttr( X, Y, Count : Byte; Attr : Byte );
Var
   i : Byte;

begin

{ 뢱�´pⓥ� 칛젪Œ彛�飡� 쭬쩆�⑨ 캙p젹βp�� }

  If ( X > Lo( WindMax ) - Lo( WindMin ) + 1 ) or
     ( Y > Hi( WindMax ) - Hi( WindMin ) + 1 ) Then
    Exit;

  If  X + Count > Lo( WindMax ) - Lo( WindMin ) + 1  Then
    Count :=  Lo( WindMax ) - Lo( WindMin ) + 1 - X + 1;

{ 롟��˛�� 與か 쭬Д�� 졻pÆ呻�� 收め�� }

  For I := 0 To Count - 1 do
    begin

      Mem[ VideoSeg :
      ( ( Hi( WindMin ) + ( Y - 1 ) ) * VideoXRes * 2  ) +
        ( Lo( WindMin ) + ( X - 1 ) ) * 2 + i * 2 + 1  ] := Attr;

    end;

end;

{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇� }

Procedure ColorPut( x , y : byte; Str : String ; NormalText , AccentText : Byte );
var
   i,k,n : byte ;

Begin

  i := 1;
  k := 0;
  n := 0;

  While k <> 1 do
   Begin
    While Str[i] <> '~'  do
     Begin
      WriteChar(x+n ,y,1,Str[i],NormalText);
                                                                              inc(i);
      inc(n);
      if i > Length(str) then exit;
     End;
   inc(i);

   if Str[i-1] = '~' then
    While Str[i] <> '~'  do
     Begin

      WriteChar(x+n,y,1,Str[i],AccentText);
      inc(i);
      inc(n);
      if i > Length(str) then exit;

     End;

   inc(i);
   if i > Length(str) then exit;

   End;


End;

{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇� }

Procedure ParamPut( x , y : Byte; Str : String ; BegPos, EndPos, Color : Byte);
var
  i,k : Byte ;
  s   : String;

Begin

 if BegPos <> EndPos then
  Begin

   k := 0;

   If length( Str ) <= EndPos then EndPos := Length( Str );

   s := Copy( Str, BegPos, EndPos - BegPos + 1 );
   WriteStr( x + k, y, S, Color );

{   for i := BegPos to EndPos do
     Begin
      WriteChar( x + k, y, 1, Str[i], Color );
      inc(k);
     End;
    }
  End;

 if BegPos = EndPos Then WriteChar( x , y, 1, Str[Begpos],Color );

End;

{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇� }

procedure SetCursorSize( StartLine, EndLine : Byte );
Var
  Regs : Registers;
begin

  With Regs do
    begin

       AH := $01;
       CH := StartLine;
       CL := EndLine;

       IntR( $10, Regs );

    end;

end;

procedure BlockCursor;
begin

   IF  Font8x8Selected Then
    SetCursorSize( $00, $08 )
      else
        SetCursorSize( $00, $0F );

end;

procedure NormalCursor;
begin

  IF Font8x8Selected Then
    SetCursorSize( 6, 8 )
      else
        If VideoMode = 7 Then
          SetCursorSize( $0B, $0F )
           else
          SetCursorSize( $06, $07 )

end;

procedure HiddenCursor;
begin

  SetCursorSize( $20, $00 );

end;

{ 볚�젺�˘筍 16 歟β�莘 캙エ�p� 兒췅 }
procedure Background16On;
begin

  If ( VideoType = EGA ) or ( VideoType = VGA ) Then
   Asm

    MOV AH, 10h  { 볚�젺젪エ쥯�� ��Дp 押�ゆĿ 칛쩺猶젺⑨ ˘ㄵ�歲飡�щ }
    MOV AL,  3h  { 룼ㅴ勝ゆ⑨ 信�젺�˚� 캙エ�p� 兒췅                   }
    MOV BL,  0h  { 16 兒���音 歟β��                                   }
    INT 10h      { 귣㏓쥯�� 칛쩺猶젺�� ˘ㄵ�歲飡�щ                    }

   end;

end;

{ 롡Д�ⓥ� 16 歟β�莘 캙エ�p� 兒췅 }
procedure Background16Off;
begin

  If ( VideoType = EGA ) or ( VideoType = VGA ) Then
   Asm

    MOV AH, 10h  { 볚�젺젪エ쥯�� ��Дp 押�ゆĿ 칛쩺猶젺⑨ ˘ㄵ�歲飡�щ }
    MOV AL,  3h  { 룼ㅴ勝ゆ⑨ 信�젺�˚� 캙エ�p� 兒췅                   }
    MOV BL,  1h  { 8 兒���音 歟β�� & Ж짛迹Ł 收め�                   }
    INT 10h      { 귣㏓쥯�� 칛쩺猶젺�� ˘ㄵ�歲飡�щ                    }

   end;

end;

procedure ScrollWindow( Dir, X1, Y1, X2, Y2, Rows : Byte );
begin

  If Dir = sdScrollDn Then
   Asm

     MOV AH, 07H
     MOV CH, Y1
     MOV CL, X1
     MOV DH, Y2
     MOV DL, X2
     MOV AL, Rows
     XOR BH, BH
     INT 10H

   end;

  If Dir = sdScrollUp Then
   Asm

     MOV AH, 06H
     MOV CH, Y1
     MOV CL, X1
     MOV DH, Y2
     MOV DL, X2
     MOV AL, Rows
     XOR BH, BH
     INT 10H

   end;

end;{ Scroll }

{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇� }
{ 굇                                                         굇 }
{ 굇                  KEYBOARD  SERVICE                      굇 }
{ 굇                                                         굇 }
{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇� }


procedure NulProc;
begin
end;

{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇 }


function GetKey : Word;
Var
  ch : char;
  k  : Word;
begin

  ch := ReadKey;{ 뿨�젰� 歲Б�� �� ▲芯p� }
  If ch = #0 Then { 끷エ 召ζ쯄レ췅� か젪②� }
   begin
     ch := ReadKey; { 뿨�젰� ι� �ㄸ� 歲Б�� �� ▲芯p� }
     K  := 2700 + Ord( ch ); { 뒶� か젪②� ( 細. Interface Мㅳワ ) }
   end
    else
      begin
        K      := Ord( ch );
      end;

   If HelpFlag Then
     if K = HelpKey Then
       begin
         HelpProc;
         K      := 0;
       end;

  GetKey := K;

end; { GetKey }

{ 굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇� }

function AltChar( Key : Word ) : Char;
begin

  Case Key of

    kbAltA  : AltChar := 'A' ;
    kbAltB  : AltChar := 'B' ;
    kbAltC  : AltChar := 'C' ;
    kbAltD  : AltChar := 'D' ;
    kbAltE  : AltChar := 'E' ;
    kbAltF  : AltChar := 'F' ;
    kbAltG  : AltChar := 'G' ;
    kbAltH  : AltChar := 'H' ;
    kbAltI  : AltChar := 'I' ;
    kbAltJ  : AltChar := 'J' ;
    kbAltK  : AltChar := 'K' ;
    kbAltL  : AltChar := 'L' ;
    kbAltM  : AltChar := 'M' ;
    kbAltN  : AltChar := 'N' ;
    kbAltO  : AltChar := 'O' ;
    kbAltP  : AltChar := 'P' ;
    kbAltQ  : AltChar := 'Q' ;
    kbAltR  : AltChar := 'R' ;
    kbAltS  : AltChar := 'S' ;
    kbAltT  : AltChar := 'T' ;
    kbAltU  : AltChar := 'U' ;
    kbAltV  : AltChar := 'V' ;
    kbAltW  : AltChar := 'W' ;
    kbAltX  : AltChar := 'X' ;
    kbAltY  : AltChar := 'Y' ;
    kbAltZ  : AltChar := 'Z' ;

    kbAlt1  : AltChar := '1' ;
    kbAlt2  : AltChar := '2' ;
    kbAlt3  : AltChar := '3' ;
    kbAlt4  : AltChar := '4' ;
    kbAlt5  : AltChar := '5' ;
    kbAlt6  : AltChar := '6' ;
    kbAlt7  : AltChar := '7' ;
    kbAlt8  : AltChar := '8' ;
    kbAlt9  : AltChar := '9' ;
    kbAlt0  : AltChar := '0' ;

    Else
      AltChar := ' ';

  end;{ Case Key }

end;{ AltChar }


end. { TDrivers }