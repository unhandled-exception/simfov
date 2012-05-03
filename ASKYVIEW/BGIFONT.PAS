
{ Copyright (c) 1985, 1990 by Borland International, Inc. }

unit BGIFont;
{ Sample unit to accompany BGILINK.PAS. This unit links all the BGI graphics
  fonts into a single TPU file. This makes it easy to incorporate the font
  files directly into an .EXE file. See BGILINK.PAS for more information.
}
interface

procedure SmallFontProc;

implementation

procedure SmallFontProc; external;
{$L LITT.OBJ }

end.
