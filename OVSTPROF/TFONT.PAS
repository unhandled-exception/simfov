{ �����������������������������������������������������������Ŀ }
{ �                                                           � }
{ �                 OVSoft Text Professional.                 � }
{ �                                                           � }
{ �            ����� �p��p��� �p�������祭�� ���             � }
{ �           ᮧ����� ���p䥩� � ���짮��⥫��.            � }
{ �                                                           � }
{ �                      �����  2.0                          � }
{ �                                                           � }
{ �                  Copyright (c) 1992 by                    � }
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
{ �                     ����� TFont.                         � }
{ �                                                           � }
{ �     ��楤��� � �㭪樨 ��� ���p㧪� ��p����� �p��⮢.    � }
{ �                                                           � }
{ �����������������������������������������������������������Ĵ }
{ �                                                           � }
{ �                     Turbo  Pascal                         � }
{ �                      Version 6.0                          � }
{ �                Copyright (c) 1983,90 by                   � }
{ �               Borland International, Inc                  � }
{ �                                                           � }
{ ������������������������������������������������������������� }

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