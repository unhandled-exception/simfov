Unit TInfo;
Interface
Uses Dos;

Const
  CPU : Array [0..6] of String[6] = ( 'V8086', 'i8086', 'i80286',
                                      'i80386', 'i80486', 'i80586',
                                      'i80686' );

function GetCPU : String;
function GetComputer : String;
function CoProcessor : Boolean;
function GetDOSVersion : String;

Implementation

function GetMachine : Byte; Assembler;
asm
  Pushf
  Xor AX, AX
  Push AX
  Popf
  Pushf
  Pop AX
  And AX, 0F000h
  Cmp AX, 0F000h
  Jnz @80X86
  Mov AL, 1d
  Jmp @Exit
@80X86:
  Mov AX, 0F000h
  Push AX
  Popf
  Pushf
  Pop BX
  And BX, AX
  Jnz @80386
  Mov AL, 2d
  Jmp @Exit
@80386:
  Mov  AL, 03
  Db   066h, 053h        { push ebx }
  Db   066h, 051h        { push ecx }
                           Push DX
                           Mov  DX, SP
                           And  SP, 0FFFCh
  Db   066h, 09Ch        { pushfd }
  Db   066h, 05Bh        { pop ebx }
  Db   066h, 08Bh, 0CBh  { mov ecx, ebx }
                         { xor ebx, 00040000h }
  Db   066h, 081h, 0F3h, 00,00,04,00
  Db   066h, 053h        { push ebx }
  Db   066h, 09Dh        { popfd }
  Db   066h, 09Ch        { pushfd }
  Db   066h, 05Bh        { pop ebx }
  Db   066h, 033h, 0D9h  { xor ebx, ecx }
                         { test ebx, 00040000h }
  Db   066h, 0F7h, 0C3h, 00,00,04,00
                           Je @@386
                           Inc AX
@@386:
  Db   066h, 051h        { push ecx }
  Db   066h, 09Bh        { popfd }
                           Mov SP, DX
                           Pop DX
  Db   066h, 059h        { pop ecx }
  Db   066h, 05Bh        { pop ebx }
  Xchg AX, BX
  Db   00Fh, 001h, 0E0h  {  smsw ax }
  And  AL, 00000001b     {  Protected Enable = 1 ? }
  Xchg AX, BX
  Jnz  @V8086
  Jmp  @Exit
@V8086:
  Or   AL, 080h
@Exit:
  Popf
end;

{ ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }

function GetCPU : String;
Var
  C : Byte;

begin

  C := GetMachine;
  If ( C and $80 <> 0 ) Then
    GetCpu := CPU[ C - $80 ]
      else
        GetCpu := CPU[ C ];

end;

{ ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }

function GetComputer : String;
Var
  CT : Word;

begin

  CT := MemW[ $FFFF : $FFFE ];

  Case CT of

    $FF: GetComputer := 'Original IBM PC';
    $FE: GetComputer := 'XT, Portable PC';
    $FD: GetComputer := 'PCjr';
    $FC: GetComputer := 'IBM AT';
    $FB: GetComputer := 'IBM XT, 640K';
    $FA: GetComputer := 'PS/2, 25 or 30';
    $F9: GetComputer := 'Convertible PC';
    $F8: GetComputer := 'PS/2, 555X, 70, 80';
    $9A: GetComputer := 'Compaq XT or Plus';
    $30: GetComputer := 'Sperry PC';
    $2D: GetComputer := 'Compaq PC or Deskpro';

    else
      GetComputer := 'IBM AT or compatible';

  end;

end;

{ ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }

function CoProcessor : Boolean;
Var
  Regs : Registers;
  InW  : Byte;
begin

  With Regs do
    begin

      Intr( $11, Regs );
      InW := AX Div 2;
      If ( InW mod 2 ) = 1 Then
        CoProcessor := True
          else
            CoProcessor := False;

    end;

end;

{ ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }

function GetDOSVersion : String;
Var
  DV1, DV2  : String [ 2 ];

begin

  Str( Lo( DosVersion ) , DV1 );
  Str( Hi( DosVersion ) , DV2 );

  GetDOSVersion :=  DV1 + '.' + DV2 ;

end;

end.
