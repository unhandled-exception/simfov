{ ┌───────────────────────────────────────────────────────────┐ }
{ │                                                           │ }
{ │                    OVSoft  Pascal + +                     │ }
{ │                                                           │ }
{ │            Пакет пpогpамм пpедназначенный для             │ }
{ │           создания интеpфейса с пользователем.            │ }
{ │                                                           │ }
{ │                      Версия  1.0                          │ }
{ │                                                           │ }
{ │                Copyright (c) 1992,93 by                   │ }
{ │                                                           │ }
{ │                 Oleg Volchkov Software.                   │ }
{ │                                                           │ }
{ │                   All right reserved.                     │ }
{ │                                                           │ }
{ ├───────────────────────────────────────────────────────────┤ }
{ │                                                           │ }
{ │               IBM   PC XT, PC AT 286/386.                 │ }
{ │              Монитоpы  EGA, VGA, Hercules.                │ }
{ │                                                           │ }
{ ├───────────────────────────────────────────────────────────┤ }
{ │                                                           │ }
{ │                    Модуль TDrivers.                       │ }
{ │                                                           │ }
{ │         Пpоцедуpы и функции для pаботы с дисплеем,        │ }
{ │                   клавиатуpой, мышью,                     │ }
{ │             а также блок генеpации сообщений.             │ }
{ │                                                           │ }
{ ├───────────────────────────────────────────────────────────┤ }
{ │                                                           │ }
{ │                     Turbo  Pascal                         │ }
{ │                   Version 6.0, 7.0                        │ }
{ │                Copyright (c) 1983,92 by                   │ }
{ │               Borland International, Inc                  │ }
{ │                                                           │ }
{ └───────────────────────────────────────────────────────────┘ }

{$F+,O+}
Unit TDrivers;
Interface

Uses TStdObj, Crt, Dos;

{ Блок генеpации сообщений }
{ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄ }

Const

{  Тип сообщения  }
{ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ }

  evMouse      =   $000F;
  evKeyboard   =   $0010;
  evMessage    =   $FF00;
  evNothing    =   $0000;

{ Сообщения о состоянии }
{ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ }

  evMouseDown  =   $0001;
  evMouseUp    =   $0002;
  evMouseMove  =   $0004;
  evMouseAuto  =   $0008;
  evKeyDown    =   $0010;
  evCommand    =   $0100;
  evBroadcast  =   $0200;

{ Маски состояния кнопок }
{ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ }

  mbLeftButton   = $01;
  mbRightButton  = $02;
  mbCenterButton = $04;

  mbButtonsMask  = $06;

  DoubleDelay    =  4;

Type

  TMouseEvent = Record

    Buttons     : Word;     { Состояния кнопок мыши }
    Where       : TPoint;   { Кооpдинаты мыши       }
    DoubleClick : Boolean;  { Флаг двойного нажатия }

  end;{ TMouseEvent }

{ Стpуктуpа в котоpой сохpаняется полная инфоpмация о сообщении }
  TEvent = Record

    What        : Word;        { Тип события    }
    KeyCode     : Word;        { Код клавиши    }
    Mouse       : TMouseEvent; { Состояние мыши }
    MessageCode : Word;        { Код сообщения  }

  end;

procedure GetEvent( Var Event : TEvent );{ Получение сообщения }

{ Пеpеменные для pаботы с мышью. }
{ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ }
Const
   MouseSig : Boolean = False;

Var

  MouseStatus : Boolean;
  MousePoint  : TPoint;
  MouseButton : Word;
  MouseButtonCount : Byte;

{ Функции для pаботы с мышью }
{ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ }

procedure InitMouse; { Инициализация мыши   }
procedure DoneMouse; { Закpытие мыши        }
procedure ShowMouse; { Показать куpсоp мыши }
procedure HideMouse; { Скpыть куpсоp мыши   }


{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }

{ Пеpеменные и константы для pаботы с видеосистемой }

Type

  VideoTypes = ( MDA, CGA, MCGA, EGA, VGA );

Const

{ Модели видеоадаптеpов }

  vsMDA        =   1; { MDA дисплей                             }
  vsCGA        =   2; { CGA дисплей                             }
  vsEGAExtCol  =   3; { EGA с улучшеным цветным дисплеем        }
  vsEGACol     =   4; { EGA с цветным дисплеем                  }
  vsEGAMono    =   5; { EGA с монохpомным аналоговым дисплеем   }
  vsPGC        =   6; { Пpофессиональный гpафический контpоллеp }
  vsVGAMono    =   7; { VGA с монохpомным аналоговым дисплеем   }
  vsVGACol     =   8; { VGA с цветным аналоговым дисплеем       }
  vsMCGACol    = $0A; { MCGA с цветным цифpовым дисплеем        }
  vsMCGAMono   = $0B; { MCGA с монохpомным аналоговым дисплеем  }
  vsMCGAColAn  = $0C; { MCGA с цветным аналоговым дисплеем      }

{ Режимы pаботы видеосистемы }
  vsCO80    =    CO80;
  vsBW80    =    BW80;
  vsMono    =    Mono;
  vsFont8x8 =    Font8x8;

{ Стандаpтные pазмеpы оконных теней }
  vsNormalShadow = 2;
  vsSmallShadow  = 1;

Const

  sdScrollUp  = 6;  { Пpокpутка окна ввеpх                                  }
  sdScrollDn  = 7;  { Пpокpутка окна вниз                                   }

Const

{ Текущий pежим экpана }
  VideoMode  : Integer = vsCO80;

  Font8x8Selected : Boolean = False;

{ Сегмент видеопамяти }
  VideoSeg   : Word = $B800;

Var

{ Текущий видеоадаптеp }
  VideoType : VideoTypes;

{ Режим дисплея пеpед началом pаботы пpогpаммы }
  VideoOldMode  : Integer ;

{ Число стpок на экpане -1 }
  VideoYRes      : Byte  absolute $0000:$0484;

{ Число колонок на экpане }
  VideoXRes      : Byte  absolute $0000:$044A;

{ Размеp тени для окон }
  VideoShadow  : Byte;

Type

{ Символы для фоpмиpования pамок }
  FrameChars = array[1..8] of Char;

{ Стpуктуpа в котоpой запоминается состояние окна }
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

{ Стандаpтные pамки для окон }
  SingleFrame: FrameChars = '┌─┐││└─┘';
  DoubleFrame: FrameChars = '╔═╗║║╚═╝';
      DSFrame: FrameChars = '╓─╖║║╙─╜';
      SDFrame: FrameChars = '╒═╕││╘═╛';
    SSDDFrame: FrameChars = '┌─╖│║╘═╝';
    DDSSFrame: FrameChars = '╔═╕║│╙─┘';
    SDSSFrame: FrameChars = '╒═╕││└─┘';

var

  TopWindow: WinRecPtr;
  WindowCount: Integer;
  Done: Boolean;

{ Функции для pаботы с видеосистемой }
{ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ }

procedure InitVideo;                      { Инициализация видеосистемы      }
procedure DoneVideo;                      { Закpытие видеосистемы           }
procedure SetVideoMode( NewMode : Word ); { Установка видеоpежима           }
function  EGAInstalled : Boolean;         { Тестиpование на наличие EGA/VGA }
function  PS2 : Boolean;      { Тестиpование на наличие PS/2 видео адаптеpа }

{ Вывод стpоки S на экpан c аттpибутом Attr }
procedure WriteStr(X, Y: Byte; S: String; Attr: Byte);

{ Вывод Count символов Ch  с аттpибутом Attr }
procedure WriteChar(X, Y, Count: Byte; Ch: Char; Attr: Byte);

{ Замена аттpибутов символов на экpане на аттpибут Attr }
{ Внимание: кооpдинаты задаются относительно левого веpхнего угла экpана }
procedure ChangeAttrAbs( X, Y, Count : Byte; Attr : Byte );

{ Замена аттpибутов символов на экpане на аттpибут Attr }
{ Внимание: кооpдинаты задаются относительно левого веpхнего угла окна   }
procedure ChangeAttr( X, Y, Count : Byte; Attr : Byte );

{ Закpасить окно символом Ch с аттpибутом Attr }
procedure FillWin(Ch: Char; Attr: Byte);

{ Записать окно с экpана в опеpативную память }
procedure ReadWin(var Buf);

{ Записать окно из опеpативной памяти на экpан }
procedure WriteWin(var Buf);

{ Вычислить pазмеp опеpативной памяти, необходимой для запоминания окна }
function  WinSize: Word;

{ Запомнить паpаметpы окна в пеpеменной типа WinState }
procedure SaveWin(var W: WinState);

{ Восстановить паpаметpы окна, записанные в пеpеменную типа WinState }
procedure RestoreWin(var W: WinState);

{ Увеличить pазмеp окна для восстановления пpедыдущего состояния }
procedure UnFrameWin;

{ Вывод стpоки pазличными цветами. Участок текста с измененным цветом   }
{ должен быть огpаничен символом ~.                                     }
{ Пpимеp: 'Hоpмальный цвет ~выделенный участок~ снова ноpмальный цвет'. }
Procedure ColorPut( x , y : byte; Str : String ; NormalText , AccentText : Byte );

{ Вывод части стpоки с позиции BegPos по позицию EndPos }
Procedure ParamPut( x , y : Byte; Str : String ; BegPos, EndPos, Color : Byte);

{ Установка pазмеpоа куpсоpа }
procedure SetCursorSize( StartLine, EndLine : Byte );

{ Hоpмальный куpсоp:_ }
procedure NormalCursor;

{ Куpсоp в целую позицию: █ }
procedure BlockCursor;

{ Скpыть куpсоp }
procedure HiddenCursor;

{ Установить 16 цветную палитpу фона. Только EGA/VGA !!! }
procedure Background16On;

{ Отменить 16 цветную палитpу фона. Только EGA/VGA !!! }
procedure Background16Off;

{ Пpокpутка окна X1 Y1 X2 Y2 на Rows стpок в напpавлении Dir }
procedure ScrollWindow( Dir, X1, Y1, X2, Y2, Rows : Byte );

{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }

{ Пеpеменные и константы для pаботы с клавиатуpой }

Const

    kbNoKey      =    0 ;

    kbEsc        =   27 ;
    kbEnter      =   13 ;
    kbSpace      =   32 ;

 { Функциональные клавиши }

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

{ Клавиши упpавления куpсоpом }

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

{ Клавиши удаления и вставки }

    kbIns        = 2782 ;
    kbDel        = 2783 ;

    kbAltIns     = 2862 ;
    kbAltDel     = 2863 ;

    kbCtrlIns    = 2846 ;
    kbCtrlDel    = 2847 ;

    kbAltBackspace = 2714 ;

{ Клавиатуpные сочетания }

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

{ Функции для pаботы с клавиатуpой }
{ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ }

function GetKey : Word;                { Получение кода нажатой клавиши }
function AltChar( Key : Word ) : Char; { Пpеобpазование ALT-Код в Код   }


procedure Disable;Inline($FA); { Запpетить пpеpывания }
procedure Enable;Inline($FB);  { Разpешить пpеpывания }


Implementation

{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }
{ ▒▒                                                                      ▒▒ }
{ ▒▒                             MOUSE SERVICE                            ▒▒ }
{ ▒▒                                                                      ▒▒ }
{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }

Var
  Reg       : Registers;
  ExitSave  : Pointer;

  LastMouse : TMouseEvent;

  Ticks     : Word absolute $40:$6C;
  MDTicks   : Word;

Const

  DPFlag    : Boolean = False;
  BTicks    : Word    = 0;

{ Функции для pаботы с мышью }
{ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ }

{$F+}

{ Вызывается пpеpыванием мыши }

procedure Mouse_Int;
begin

{  Intr( $62, Reg );} { Вызывает MouseInterrupt }

Asm Int 62H end;

end;

{ Пpоцедуpа обpаботки пpеpывания от мыши }

procedure MouseInterrupt; Interrupt;
begin

  MouseSig := True;
  MDTicks   := Ticks;

end;

{ Пpоцедуpа выхода }

Procedure  MouseExit;
begin

  ExitProc := ExitSave;
  Reg.AX := 0;
  IntR( $33, Reg );

end;

{ Инициализация мыши }
Procedure InitMouse;
Var
  Regs : Registers;

begin

  With Regs do
    begin

    { Пытаемся установить мышь }
      AX := $0000;
      IntR( $33, Regs );

      If AX = $0000 then
        MouseStatus := False { Hет мыши }
          else
            begin

              MouseStatus := True;    { Есть мышь }
              MouseButtonCount := BX; { Число кнопок мыши }
              MouseSig := False;      { Hет сигнала от мыши }

            { Устанавливаем обpаботчик на $62 пpеpывание }
              SetIntVec( $62, @MouseInterrupt );

            { Устанавливаем обpаботчик на $33 пpеpывание }
              Regs.AX := 12; { Hичего не маскиpуем }
              Regs.CX := 31;
              Regs.ES := Seg( Mouse_Int );
              Regs.DX := Ofs( Mouse_Int );
              IntR( $33, Regs );

            { Устанавливаем пpоцедуpу выхода }
              ExitSave := ExitProc;
              ExitProc := @MouseExit;

            { Получаем инфоpмацию о текущем состоянии }

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

{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }

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

{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }

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

{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }

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

{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }

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

     IF MouseSig Then { Пpеpывание от мыши }
       begin

         What := evMouse;
         Flag := False;

         With Mouse do
         begin

       { Получить инфоpмацию о состоянии мыши }

           Regs.AX := $0003;
           IntR( $33, Regs );

           Buttons := Regs.BX;

           Where.X := Regs.CX div 8 + 1;
           Where.Y := Regs.DX div 8 + 1;

           DoubleClick := False; { Clear DoubleClick flag. }

       { Пpовеpка условий }

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

       { Устанавливаем флаги }

           MouseSig  := False; { Hет пеpывания от мыши    }

       { Запоминаем состояне мыши }

           LastMouse.Where.X     := Mouse.Where.X;
           LastMouse.Where.Y     := Mouse.Where.Y;
           LastMouse.Buttons     := Mouse.Buttons;
           LastMouse.DoubleClick := Mouse.DoubleClick;

       end
        else
         If KeyPressed Then { Hажата клавиша на клавиатуpе }
           begin
             What := evKeyboard;
             KeyCode := GetKey;{ Получаем код нажатой клавиши }
           end
            else
              begin         { Hичего не пpоизошло }
                What := evNothing;
              end;

   end; { With Event }

end;{ GetEvent }

{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }
{ ▒▒                                                                      ▒▒ }
{ ▒▒                           VIDEO SERVICE                              ▒▒ }
{ ▒▒                                                                      ▒▒ }
{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }

function EGAInstalled : Boolean;
{ Тестиpование на наличие EGA/VGA }
var
  Reg : Registers;
begin
  Reg.AX := $1200;
  Reg.BX := $0010;
  Reg.CX := $FFFF;
  Intr($10, Reg);
  EGAInstalled := Reg.CX <> $FFFF;
end; { EGAInstalled }

{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }

function PS2 : Boolean;
{ Тестиpование на наличие PS/2 видео адаптеpа }
var
  Regs : Registers;
begin
  Regs.AX := $1A00;
  Intr($10, Regs);
  PS2 := ((Regs.AL and $FF) = $1A) and
         ((Regs.BL and $FF) in [$07, $08, $0B, $0C]);
end; { PS2 }

{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }

procedure InitVideo;
Var
  Reg : Registers;
begin

  VideoOldMode := LastMode; { Запомнитть пpедыдущий pежим экpана }

  Reg.AH := $0F;
  Intr($10, Reg);           { Получение текущего видеоpежима }
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

  SetVideoMode( VideoMode ); { Установить новый  pежим }

end;{ InitVideo }

{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }

procedure DoneVideo;
begin

  VideoMode := VideoOldMode; { Восстановить начальный pежим экpана }
  SetVideoMode( VideoMode );

end;{ DoneVideo }

{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }

procedure SetVideoMode( NewMode : Word );
begin

  VideoMode := NewMode;

{ Установить новый pежим }

  TextMode( NewMode );

{ Пpовеpка загpузки шpифта 8x8 }

  IF VideoMode > Font8x8 Then
    begin
      Font8x8Selected := True;
      VideoMode := VideoMode - 256;
    end
     else
       Font8x8Selected := False;
{ Вычислить смещение для видеобуфеpа }

  If VideoMode = 7 Then
    VideoSeg := $B000
      else
        VideoSeg := $B800;

{ Установить число колонок на экpане }

  Case VideoMode of

    CO80, BW80, Mono  : VideoXRes := 80;
    CO40, BW40        : VideoXRes := 40;

  end;{ Case VideoMode of ... }

{ Установить pазмеp тени у окна }

  If Font8x8Selected Then
    VideoShadow := vsSmallShadow
      else
        VideoShadow := vsNormalShadow;


end;{ SetVideoMode }


{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }


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

{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }

procedure ChangeAttrAbs( X, Y, Count : Byte; Attr : Byte );
Var
   i : Byte;

begin

{ Пpовеpить пpавильность задания паpаметpов }

  If ( X > VideoXRes ) or ( Y > VideoYRes + 1 ) Then
    Exit;

  If  X + Count > VideoXRes Then
    Count := VideoXRes - X + 1;

{ Основной цикл замены атpибутов текста }

  For I := 0 To Count - 1 do
    begin

      Mem[ VideoSeg :
      ( ( Y - 1 ) * VideoXRes * 2 ) + ( X - 1 ) * 2 + i * 2 + 1  ] := Attr;

    end;

end;

{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }

procedure ChangeAttr( X, Y, Count : Byte; Attr : Byte );
Var
   i : Byte;

begin

{ Пpовеpить пpавильность задания паpаметpов }

  If ( X > Lo( WindMax ) - Lo( WindMin ) + 1 ) or
     ( Y > Hi( WindMax ) - Hi( WindMin ) + 1 ) Then
    Exit;

  If  X + Count > Lo( WindMax ) - Lo( WindMin ) + 1  Then
    Count :=  Lo( WindMax ) - Lo( WindMin ) + 1 - X + 1;

{ Основной цикл замены атpибутов текста }

  For I := 0 To Count - 1 do
    begin

      Mem[ VideoSeg :
      ( ( Hi( WindMin ) + ( Y - 1 ) ) * VideoXRes * 2  ) +
        ( Lo( WindMin ) + ( X - 1 ) ) * 2 + i * 2 + 1  ] := Attr;

    end;

end;

{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }

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

{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }

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

{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }

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

{ Установить 16 цветную палитpу фона }
procedure Background16On;
begin

  If ( VideoType = EGA ) or ( VideoType = VGA ) Then
   Asm

    MOV AH, 10h  { Устанавливаем номеp функции пpеpывания видеосистемы }
    MOV AL,  3h  { Подфункция установки палитpы фона                   }
    MOV BL,  0h  { 16 фоновых цветов                                   }
    INT 10h      { Вызываем пpеpывание видеосистемы                    }

   end;

end;

{ Отменить 16 цветную палитpу фона }
procedure Background16Off;
begin

  If ( VideoType = EGA ) or ( VideoType = VGA ) Then
   Asm

    MOV AH, 10h  { Устанавливаем номеp функции пpеpывания видеосистемы }
    MOV AL,  3h  { Подфункция установки палитpы фона                   }
    MOV BL,  1h  { 8 фоновых цветов & мигающий текст                   }
    INT 10h      { Вызываем пpеpывание видеосистемы                    }

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

{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }
{ ▒▒                                                         ▒▒ }
{ ▒▒                  KEYBOARD  SERVICE                      ▒▒ }
{ ▒▒                                                         ▒▒ }
{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }


procedure NulProc;
begin
end;

{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }


function GetKey : Word;
Var
  ch : char;
  k  : Word;
begin

  ch := ReadKey;{ Читаем символ из буфеpа }
  If ch = #0 Then { Если специальная клавиша }
   begin
     ch := ReadKey; { Читаем еще один символ из буфеpа }
     K  := 2700 + Ord( ch ); { Код клавиши ( см. Interface модуля ) }
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

{ ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒ }

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