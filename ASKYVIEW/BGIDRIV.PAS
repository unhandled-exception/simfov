




{ Copyright (c) 1985, 1990 by Borland International, Inc. }

unit BGIDriv;
{ Sample unit to accompany BGILINK.PAS. This unit links the BGI graphics
  driver into a single TPU file. This makes it easy to link the driver files
  directly into an .EXE file. See BGILINK.PAS for more information.
}
interface

procedure EgaVgaDriverProc;

implementation

procedure EgaVgaDriverProc; external;
{$L EGAVGA.OBJ }

end.
