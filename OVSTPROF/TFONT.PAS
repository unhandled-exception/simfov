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
{ �                     뙫ㅳレ TFont.                         � }
{ �                                                           � }
{ �     뤲�璵ㅳ贍 � 押�ゆĿ ㄻ� 쭬즤習え 咨p젺�音 �pⓧ獸�.    � }
{ �                                                           � }
{ 쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴� }
{ �                                                           � }
{ �                     Turbo  Pascal                         � }
{ �                      Version 6.0                          � }
{ �                Copyright (c) 1983,90 by                   � }
{ �               Borland International, Inc                  � }
{ �                                                           � }
{ 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴� }

Unit TFont;

Interface

const

  EGAFont = 14;
  VGAFont = 16;

procedure LoadFontToMemory( Height, FirstSymbol, Count : Word; var Font );

Implementation

Uses Dos;

procedure LoadFontToMemory( Height, FirstSymbol, Count : Word; var Font );

Var
  Regs : Registers;
  FS, FO : Word;

begin

  With Regs do
    begin

      AH := $11;
      AL := $10;

      BL := 0;
      BH := Height;
      CX := Count;
      DX := FirstSymbol;
      ES := Seg( Font );
      BP := Ofs( Font ) + FirstSymbol * Height;

      IntR( $10, Regs );

    end;

end;

end.