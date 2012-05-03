{ ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿ }
{ ³                                                           ³ }
{ ³                 OVSoft Text Professional.                 ³ }
{ ³                                                           ³ }
{ ³             ª¥â ¯p®£p ¬¬ ¯p¥¤­ §­ ç¥­­ë© ¤«ï             ³ }
{ ³           á®§¤ ­¨ï ¨­â¥pä¥©á  á ¯®«ì§®¢ â¥«¥¬.            ³ }
{ ³                                                           ³ }
{ ³                      ‚¥àá¨ï  2.0                          ³ }
{ ³                                                           ³ }
{ ³                  Copyright (c) 1992 by                    ³ }
{ ³                                                           ³ }
{ ³                 Oleg Volchkov Software.                   ³ }
{ ³                                                           ³ }
{ ³                   All right reserved.                     ³ }
{ ³                                                           ³ }
{ ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ }
{ ³                                                           ³ }
{ ³               IBM   PC XT, PC AT 286/386.                 ³ }
{ ³              Œ®­¨â®pë  EGA, VGA, Hercules.                ³ }
{ ³                                                           ³ }
{ ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ }
{ ³                                                           ³ }
{ ³                     Œ®¤ã«ì TFont.                         ³ }
{ ³                                                           ³ }
{ ³     à®æ¥¤ãàë ¨ äã­ªæ¨¨ ¤«ï § £pã§ª¨ íªp ­­ëå èp¨äâ®¢.    ³ }
{ ³                                                           ³ }
{ ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´ }
{ ³                                                           ³ }
{ ³                     Turbo  Pascal                         ³ }
{ ³                      Version 6.0                          ³ }
{ ³                Copyright (c) 1983,90 by                   ³ }
{ ³               Borland International, Inc                  ³ }
{ ³                                                           ³ }
{ ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ }

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