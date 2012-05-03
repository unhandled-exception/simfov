{ �����������������������������������������������������������Ŀ }
{ �                                                           � }
{ �                    OVSoft  Pascal + +                     � }
{ �                                                           � }
{ �            ����� �p��p��� �p�������祭�� ���             � }
{ �           ᮧ����� ���p䥩� � ���짮��⥫��.            � }
{ �                                                           � }
{ �                      �����  1.0                          � }
{ �                                                           � }
{ �                Copyright (c) 1992,93 by                   � }
{ �                                                           � }
{ �                 Oleg Volchkov Software.                   � }
{ �                                                           � }
{ �                   All right reserved.                     � }
{ �                                                           � }
{ �����������������������������������������������������������Ĵ }
{ �                                                           � }
{ �               IBM   PC XT, PC AT 286/386.                 � }
{ �              �����p�  EGA, VGA, Hercules.                � }
{ �                                                           � }
{ �����������������������������������������������������������Ĵ }
{ �                                                           � }
{ �                    ����� TDrivers.                       � }
{ �                                                           � }
{ �         �p�楤�p� � �㭪樨 ��� p����� � ��ᯫ���,        � }
{ �                   ��������p��, �����,                     � }
{ �             � ⠪�� ���� ����p�樨 ᮮ�饭��.             � }
{ �                                                           � }
{ �����������������������������������������������������������Ĵ }
{ �                                                           � }
{ �                     Turbo  Pascal                         � }
{ �                   Version 6.0, 7.0                        � }
{ �                Copyright (c) 1983,92 by                   � }
{ �               Borland International, Inc                  � }
{ �                                                           � }
{ ������������������������������������������������������������� }

{$F+,O+}
Unit TDrivers;
Interface

Uses TStdObj, Crt, Dos;

{ ���� ����p�樨 ᮮ�饭�� }
{ ������������������������ }

Const

{  ��� ᮮ�饭��  }
{ ��������������� }

  evMouse      =   $000F;
  evKeyboard   =   $0010;
  evMessage    =   $FF00;
  evNothing    =   $0000;

{ ����饭�� � ���ﭨ� }
{ ��������������������� }

  evMouseDown  =   $0001;
  evMouseUp    =   $0002;
  evMouseMove  =   $0004;
  evMouseAuto  =   $0008;
  evKeyDown    =   $0010;
  evCommand    =   $0100;
  evBroadcast  =   $0200;

{ ��᪨ ���ﭨ� ������ }
{ ���������������������� }

  mbLeftButton   = $01;
  mbRightButton  = $02;
  mbCenterButton = $04;

  mbButtonsMask  = $06;

  DoubleDelay    =  4;

Type

  TMouseEvent = Record

    Buttons     : Word;     { ����ﭨ� ������ ��� }
    Where       : TPoint;   { ���p������ ���       }
    DoubleClick : Boolean;  { ���� �������� ������ }

  end;{ TMouseEvent }

{ ��p���p� � ���p�� ��p������ ������ ���p���� � ᮮ�饭�� }
  TEvent = Record

    What        : Word;        { ��� ᮡ���    }
    KeyCode     : Word;        { ��� ������    }
    Mouse       : TMouseEvent; { ����ﭨ� ��� }
    MessageCode : Word;        { ��� ᮮ�饭��  }

  end;

procedure GetEvent( Var Event : TEvent );{ ����祭�� ᮮ�饭�� }

{ ��p������ ��� p����� � �����. }
{ ������������������������������ }
Const
   MouseSig : Boolean = False;

Var

  MouseStatus : Boolean;
  MousePoint  : TPoint;
  MouseButton : Word;
  MouseButtonCount : Byte;

{ �㭪樨 ��� p����� � ����� }
{ �������������������������� }

procedure InitMouse; { ���樠������ ���   }
procedure DoneMouse; { ���p�⨥ ���        }
procedure ShowMouse; { �������� ��p�p ��� }
procedure HideMouse; { ��p��� ��p�p ���   }


{ ������������������������������������������������������������������ }

{ ��p������ � ����⠭�� ��� p����� � �������⥬�� }

Type

  VideoTypes = ( MDA, CGA, MCGA, EGA, VGA );

Const

{ ������ ����������p�� }

  vsMDA        =   1; { MDA ��ᯫ��                             }
  vsCGA        =   2; { CGA ��ᯫ��                             }
  vsEGAExtCol  =   3; { EGA � ���襭� 梥�� ��ᯫ���        }
  vsEGACol     =   4; { EGA � 梥�� ��ᯫ���                  }
  vsEGAMono    =   5; { EGA � �����p���� ��������� ��ᯫ���   }
  vsPGC        =   6; { �p���ᨮ����� �p���᪨� ����p����p }
  vsVGAMono    =   7; { VGA � �����p���� ��������� ��ᯫ���   }
  vsVGACol     =   8; { VGA � 梥�� ��������� ��ᯫ���       }
  vsMCGACol    = $0A; { MCGA � 梥�� ��p��� ��ᯫ���        }
  vsMCGAMono   = $0B; { MCGA � �����p���� ��������� ��ᯫ���  }
  vsMCGAColAn  = $0C; { MCGA � 梥�� ��������� ��ᯫ���      }

{ ������ p����� �������⥬� }
  vsCO80    =    CO80;
  vsBW80    =    BW80;
  vsMono    =    Mono;
  vsFont8x8 =    Font8x8;

{ �⠭��p�� p����p� ������� ⥭�� }
  vsNormalShadow = 2;
  vsSmallShadow  = 1;

Const

  sdScrollUp  = 6;  { �p��p�⪠ ���� ���p�                                  }
  sdScrollDn  = 7;  { �p��p�⪠ ���� ����                                   }

Const

{ ����騩 p���� ��p��� }
  VideoMode  : Integer = vsCO80;

  Font8x8Selected : Boolean = False;

{ ������� ���������� }
  VideoSeg   : Word = $B800;

Var

{ ����騩 ����������p }
  VideoType : VideoTypes;

{ ����� ��ᯫ�� ��p�� ��砫�� p����� �p��p���� }
  VideoOldMode  : Integer ;

{ ��᫮ ��p�� �� ��p��� -1 }
  VideoYRes      : Byte  absolute $0000:$0484;

{ ��᫮ ������� �� ��p��� }
  VideoXRes      : Byte  absolute $0000:$044A;

{ �����p ⥭� ��� ���� }
  VideoShadow  : Byte;

Type

{ ������� ��� �p��p������ p���� }
  FrameChars = array[1..8] of Char;

{ ��p���p� � ���p�� ������������ ���ﭨ� ���� }
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

{ �⠭��p�� p���� ��� ���� }
  SingleFrame: FrameChars = '�Ŀ�����';
  DoubleFrame: FrameChars = '�ͻ���ͼ';
      DSFrame: FrameChars = '�ķ���Ľ';
      SDFrame: FrameChars = '�͸���;';
    SSDDFrame: FrameChars = '�ķ���ͼ';
    DDSSFrame: FrameChars = '�͸�����';
    SDSSFrame: FrameChars = '�͸�����';

var

  TopWindow: WinRecPtr;
  WindowCount: Integer;
  Done: Boolean;

{ �㭪樨 ��� p����� � �������⥬�� }
{ ���������������������������������� }

procedure InitVideo;                      { ���樠������ �������⥬�      }
procedure DoneVideo;                      { ���p�⨥ �������⥬�           }
procedure SetVideoMode( NewMode : Word ); { ��⠭���� �����p�����           }
function  EGAInstalled : Boolean;         { ����p������ �� ����稥 EGA/VGA }
function  PS2 : Boolean;      { ����p������ �� ����稥 PS/2 ����� �����p� }

{ �뢮� ��p��� S �� ��p�� c ���p���⮬ Attr }
procedure WriteStr(X, Y: Byte; S: String; Attr: Byte);

{ �뢮� Count ᨬ����� Ch  � ���p���⮬ Attr }
procedure WriteChar(X, Y, Count: Byte; Ch: Char; Attr: Byte);

{ ������ ���p���⮢ ᨬ����� �� ��p��� �� ���p���� Attr }
{ ��������: ���p������ �������� �⭮�⥫쭮 ������ ��p孥�� 㣫� ��p��� }
procedure ChangeAttrAbs( X, Y, Count : Byte; Attr : Byte );

{ ������ ���p���⮢ ᨬ����� �� ��p��� �� ���p���� Attr }
{ ��������: ���p������ �������� �⭮�⥫쭮 ������ ��p孥�� 㣫� ����   }
procedure ChangeAttr( X, Y, Count : Byte; Attr : Byte );

{ ���p���� ���� ᨬ����� Ch � ���p���⮬ Attr }
procedure FillWin(Ch: Char; Attr: Byte);

{ ������� ���� � ��p��� � ���p�⨢��� ������ }
procedure ReadWin(var Buf);

{ ������� ���� �� ���p�⨢��� ����� �� ��p�� }
procedure WriteWin(var Buf);

{ ���᫨�� p����p ���p�⨢��� �����, ����室���� ��� ����������� ���� }
function  WinSize: Word;

{ ��������� ��p����p� ���� � ��p������� ⨯� WinState }
procedure SaveWin(var W: WinState);

{ ����⠭����� ��p����p� ����, ����ᠭ�� � ��p������� ⨯� WinState }
procedure RestoreWin(var W: WinState);

{ �������� p����p ���� ��� ����⠭������� �p����饣� ���ﭨ� }
procedure UnFrameWin;

{ �뢮� ��p��� p�����묨 梥⠬�. ���⮪ ⥪�� � ��������� 梥⮬   }
{ ������ ���� ��p���祭 ᨬ����� ~.                                     }
{ �p���p: 'H�p����� 梥� ~�뤥����� ���⮪~ ᭮�� ��p����� 梥�'. }
Procedure ColorPut( x , y : byte; Str : String ; NormalText , AccentText : Byte );

{ �뢮� ��� ��p��� � ����樨 BegPos �� ������ EndPos }
Procedure ParamPut( x , y : Byte; Str : String ; BegPos, EndPos, Color : Byte);

{ ��⠭���� p����p�� ��p�p� }
procedure SetCursorSize( StartLine, EndLine : Byte );

{ H�p����� ��p�p:_ }
procedure NormalCursor;

{ ��p�p � 楫�� ������: � }
procedure BlockCursor;

{ ��p��� ��p�p }
procedure HiddenCursor;

{ ��⠭����� 16 梥��� �����p� 䮭�. ���쪮 EGA/VGA !!! }
procedure Background16On;

{ �⬥���� 16 梥��� �����p� 䮭�. ���쪮 EGA/VGA !!! }
procedure Background16Off;

{ �p��p�⪠ ���� X1 Y1 X2 Y2 �� Rows ��p�� � ���p������� Dir }
procedure ScrollWindow( Dir, X1, Y1, X2, Y2, Rows : Byte );

{ ������������������������������������������������������������������ }

{ ��p������ � ����⠭�� ��� p����� � ��������p�� }

Const

    kbNoKey      =    0 ;

    kbEsc        =   27 ;
    kbEnter      =   13 ;
    kbSpace      =   32 ;

 { �㭪樮����� ������ }

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

{ ������ �p������� ��p�p�� }

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

{ ������ 㤠����� � ��⠢�� }

    kbIns        = 2782 ;
    kbDel        = 2783 ;

    kbAltIns     = 2862 ;
    kbAltDel     = 2863 ;

    kbCtrlIns    = 2846 ;
    kbCtrlDel    = 2847 ;

    kbAltBackspace = 2714 ;

{ ��������p�� ��⠭�� }

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

{ �㭪樨 ��� p����� � ��������p�� }
{ �������������������������������� }

function GetKey : Word;                { ����祭�� ���� ����⮩ ������ }
function AltChar( Key : Word ) : Char; { �p���p�������� ALT-��� � ���   }


procedure Disable;Inline($FA); { ���p���� �p�p뢠��� }
procedure Enable;Inline($FB);  { ���p���� �p�p뢠��� }


Implementation

{ �������������������������������������������������������������������������� }
{ ��                                                                      �� }
{ ��                             MOUSE SERVICE                            �� }
{ ��                                                                      �� }
{ �������������������������������������������������������������������������� }

Var
  Reg       : Registers;
  ExitSave  : Pointer;

  LastMouse : TMouseEvent;

  Ticks     : Word absolute $40:$6C;
  MDTicks   : Word;

Const

  DPFlag    : Boolean = False;
  BTicks    : Word    = 0;

{ �㭪樨 ��� p����� � ����� }
{ �������������������������� }

{$F+}

{ ��뢠���� �p�p뢠���� ��� }

procedure Mouse_Int;
begin

{  Intr( $62, Reg );} { ��뢠�� MouseInterrupt }

Asm Int 62H end;

end;

{ �p�楤�p� ��p���⪨ �p�p뢠��� �� ��� }

procedure MouseInterrupt; Interrupt;
begin

  MouseSig := True;
  MDTicks   := Ticks;

end;

{ �p�楤�p� ��室� }

Procedure  MouseExit;
begin

  ExitProc := ExitSave;
  Reg.AX := 0;
  IntR( $33, Reg );

end;

{ ���樠������ ��� }
Procedure InitMouse;
Var
  Regs : Registers;

begin

  With Regs do
    begin

    { ��⠥��� ��⠭����� ���� }
      AX := $0000;
      IntR( $33, Regs );

      If AX = $0000 then
        MouseStatus := False { H�� ��� }
          else
            begin

              MouseStatus := True;    { ���� ���� }
              MouseButtonCount := BX; { ��᫮ ������ ��� }
              MouseSig := False;      { H�� ᨣ���� �� ��� }

            { ��⠭�������� ��p����稪 �� $62 �p�p뢠��� }
              SetIntVec( $62, @MouseInterrupt );

            { ��⠭�������� ��p����稪 �� $33 �p�p뢠��� }
              Regs.AX := 12; { H�祣� �� ��᪨p㥬 }
              Regs.CX := 31;
              Regs.ES := Seg( Mouse_Int );
              Regs.DX := Ofs( Mouse_Int );
              IntR( $33, Regs );

            { ��⠭�������� �p�楤�p� ��室� }
              ExitSave := ExitProc;
              ExitProc := @MouseExit;

            { ����砥� ���p���� � ⥪�饬 ���ﭨ� }

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

{ �������������������������������������������������������������������� }

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

{ �������������������������������������������������������������������� }

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

{ �������������������������������������������������������������������� }

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

{ ������������������������������������������������������������������������� }

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

     IF MouseSig Then { �p�p뢠��� �� ��� }
       begin

         What := evMouse;
         Flag := False;

         With Mouse do
         begin

       { ������� ���p���� � ���ﭨ� ��� }

           Regs.AX := $0003;
           IntR( $33, Regs );

           Buttons := Regs.BX;

           Where.X := Regs.CX div 8 + 1;
           Where.Y := Regs.DX div 8 + 1;

           DoubleClick := False; { Clear DoubleClick flag. }

       { �p���p�� �᫮��� }

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

       { ��⠭�������� 䫠�� }

           MouseSig  := False; { H�� ��p뢠��� �� ���    }

       { ���������� ���ﭥ ��� }

           LastMouse.Where.X     := Mouse.Where.X;
           LastMouse.Where.Y     := Mouse.Where.Y;
           LastMouse.Buttons     := Mouse.Buttons;
           LastMouse.DoubleClick := Mouse.DoubleClick;

       end
        else
         If KeyPressed Then { H���� ������ �� ��������p� }
           begin
             What := evKeyboard;
             KeyCode := GetKey;{ ����砥� ��� ����⮩ ������ }
           end
            else
              begin         { H�祣� �� �p����諮 }
                What := evNothing;
              end;

   end; { With Event }

end;{ GetEvent }

{ �������������������������������������������������������������������������� }
{ ��                                                                      �� }
{ ��                           VIDEO SERVICE                              �� }
{ ��                                                                      �� }
{ �������������������������������������������������������������������������� }

function EGAInstalled : Boolean;
{ ����p������ �� ����稥 EGA/VGA }
var
  Reg : Registers;
begin
  Reg.AX := $1200;
  Reg.BX := $0010;
  Reg.CX := $FFFF;
  Intr($10, Reg);
  EGAInstalled := Reg.CX <> $FFFF;
end; { EGAInstalled }

{ ���������������������������������������������������������������� }

function PS2 : Boolean;
{ ����p������ �� ����稥 PS/2 ����� �����p� }
var
  Regs : Registers;
begin
  Regs.AX := $1A00;
  Intr($10, Regs);
  PS2 := ((Regs.AL and $FF) = $1A) and
         ((Regs.BL and $FF) in [$07, $08, $0B, $0C]);
end; { PS2 }

{ ���������������������������������������������������������������� }

procedure InitVideo;
Var
  Reg : Registers;
begin

  VideoOldMode := LastMode; { ���������� �p����騩 p���� ��p��� }

  Reg.AH := $0F;
  Intr($10, Reg);           { ����祭�� ⥪�饣� �����p����� }
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

  SetVideoMode( VideoMode ); { ��⠭����� ����  p���� }

end;{ InitVideo }

{ ���������������������������������������������������������������� }

procedure DoneVideo;
begin

  VideoMode := VideoOldMode; { ����⠭����� ��砫�� p���� ��p��� }
  SetVideoMode( VideoMode );

end;{ DoneVideo }

{ ���������������������������������������������������������������� }

procedure SetVideoMode( NewMode : Word );
begin

  VideoMode := NewMode;

{ ��⠭����� ���� p���� }

  TextMode( NewMode );

{ �p���p�� ���p㧪� �p��� 8x8 }

  IF VideoMode > Font8x8 Then
    begin
      Font8x8Selected := True;
      VideoMode := VideoMode - 256;
    end
     else
       Font8x8Selected := False;
{ ���᫨�� ᬥ饭�� ��� ��������p� }

  If VideoMode = 7 Then
    VideoSeg := $B000
      else
        VideoSeg := $B800;

{ ��⠭����� �᫮ ������� �� ��p��� }

  Case VideoMode of

    CO80, BW80, Mono  : VideoXRes := 80;
    CO40, BW40        : VideoXRes := 40;

  end;{ Case VideoMode of ... }

{ ��⠭����� p����p ⥭� � ���� }

  If Font8x8Selected Then
    VideoShadow := vsSmallShadow
      else
        VideoShadow := vsNormalShadow;


end;{ SetVideoMode }


{ ���������������������������������������������������������������� }


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

{ ���������������������������������������������������������������� }

procedure ChangeAttrAbs( X, Y, Count : Byte; Attr : Byte );
Var
   i : Byte;

begin

{ �p���p��� �p����쭮��� ������� ��p����p�� }

  If ( X > VideoXRes ) or ( Y > VideoYRes + 1 ) Then
    Exit;

  If  X + Count > VideoXRes Then
    Count := VideoXRes - X + 1;

{ �᭮���� 横� ������ ��p���⮢ ⥪�� }

  For I := 0 To Count - 1 do
    begin

      Mem[ VideoSeg :
      ( ( Y - 1 ) * VideoXRes * 2 ) + ( X - 1 ) * 2 + i * 2 + 1  ] := Attr;

    end;

end;

{ ���������������������������������������������������������������� }

procedure ChangeAttr( X, Y, Count : Byte; Attr : Byte );
Var
   i : Byte;

begin

{ �p���p��� �p����쭮��� ������� ��p����p�� }

  If ( X > Lo( WindMax ) - Lo( WindMin ) + 1 ) or
     ( Y > Hi( WindMax ) - Hi( WindMin ) + 1 ) Then
    Exit;

  If  X + Count > Lo( WindMax ) - Lo( WindMin ) + 1  Then
    Count :=  Lo( WindMax ) - Lo( WindMin ) + 1 - X + 1;

{ �᭮���� 横� ������ ��p���⮢ ⥪�� }

  For I := 0 To Count - 1 do
    begin

      Mem[ VideoSeg :
      ( ( Hi( WindMin ) + ( Y - 1 ) ) * VideoXRes * 2  ) +
        ( Lo( WindMin ) + ( X - 1 ) ) * 2 + i * 2 + 1  ] := Attr;

    end;

end;

{ ����������������������������������������������������������� }

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

{ ����������������������������������������������������������� }

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

{ ����������������������������������������������������������� }

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

{ ��⠭����� 16 梥��� �����p� 䮭� }
procedure Background16On;
begin

  If ( VideoType = EGA ) or ( VideoType = VGA ) Then
   Asm

    MOV AH, 10h  { ��⠭�������� ����p �㭪樨 �p�p뢠��� �������⥬� }
    MOV AL,  3h  { ����㭪�� ��⠭���� �����p� 䮭�                   }
    MOV BL,  0h  { 16 䮭���� 梥⮢                                   }
    INT 10h      { ��뢠�� �p�p뢠��� �������⥬�                    }

   end;

end;

{ �⬥���� 16 梥��� �����p� 䮭� }
procedure Background16Off;
begin

  If ( VideoType = EGA ) or ( VideoType = VGA ) Then
   Asm

    MOV AH, 10h  { ��⠭�������� ����p �㭪樨 �p�p뢠��� �������⥬� }
    MOV AL,  3h  { ����㭪�� ��⠭���� �����p� 䮭�                   }
    MOV BL,  1h  { 8 䮭���� 梥⮢ & �����騩 ⥪��                   }
    INT 10h      { ��뢠�� �p�p뢠��� �������⥬�                    }

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

{ ������������������������������������������������������������� }
{ ��                                                         �� }
{ ��                  KEYBOARD  SERVICE                      �� }
{ ��                                                         �� }
{ ������������������������������������������������������������� }


procedure NulProc;
begin
end;

{ ���������������������������������������������������������������� }


function GetKey : Word;
Var
  ch : char;
  k  : Word;
begin

  ch := ReadKey;{ ��⠥� ᨬ��� �� ���p� }
  If ch = #0 Then { �᫨ ᯥ樠�쭠� ������ }
   begin
     ch := ReadKey; { ��⠥� �� ���� ᨬ��� �� ���p� }
     K  := 2700 + Ord( ch ); { ��� ������ ( �. Interface ����� ) }
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

{ ������������������������������������������������������������������������� }

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