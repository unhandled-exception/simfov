{$F+}

Unit MDef;   { Menu driver Definitions }
Interface
Uses
 Crt, Dos;
Const

 ROWS : Array [1..2] of byte = ( 25, 35 );
 COLS : Array [1..2] of byte = ( 80, 80 );
 CFont = 2;                             { 8x8 }
 FontCharSize : Array [1..2] of byte = ( 14, 10 );


 { Item activities }
 mn_non  = 0 ;
 mn_set  = 1 ;
 mn_ssh  = 2 ;
 mn_ret  = 3 ;
 mn_exe  = 4 ;
 mn_ext  = 5 ;

 { Maximum number of items }
 MaxMenuItems = 9 ;

 { Max Nesting allowed }
 MaxLevel = 3 ;

Type

SString          = String [ 79 ] ;
ProceduralType   = Procedure;

TraceProcType    = Procedure( i,j : Byte; k,l : Byte );
TraceRecType     = Record
                     Name      : TraceProcType;
                     L1,L2     : Byte;
                     I1,I2     : Byte;
                   End;

TraceType        = Record
                     Case Required : Boolean Of
                       True  : ( Proc : TraceRecType );
                       False : ();
                   End;

CHelpProcType    = Procedure ( HelpMsg : DirStr );

CHelpType        = Record
                     Case Present : Boolean Of
                       True  : ( Proc : CHelpProcType );
                       False : ();
                   End;

GHelpProcType    = Procedure ( L, I : Byte );  { Level and Item Number }

GHelpType        = Record
                     Case Present : Boolean Of
                       True  : ( Proc : CHelpProcType );
                       False : ();
                   End;

SetVarType       = Record
                     Variable : ^Byte ;
                     Value    :  Byte ;
                   End;

SShVarType       = ^Boolean;

OrdinaryItemType = Record
                     TextString    : SString ;
                     HelpText      : SString ;
                     Case Activity : Byte of
                        mn_set     : ( SetVar : SetVarType );
                        mn_ssh     : ( SShVar : SShVarType );
                        mn_ret     : ();
                        mn_exe     : ( Proc   : ProceduralType );
                        mn_ext     : ( EProc  : ProceduralType );
                   End;

MenuType         = Array [ 1 .. MaxMenuItems ] Of ^OrdinaryItemType ;

MenuDescType     = Record
                     ulx,uly,
                     lrx,lry   : Byte;
                     Con       : Boolean;
                   End;

MenuAttrType     = Record
                   BoxT   ,
                   BoxC   ,
                   BackC  ,
                   ForeC  ,
                   ABackC ,
                   AForeC ,
                   FLBack ,
                   FLFore ,
                   HBackC ,
                   HBoxC  ,
                   HForeC    : Byte;
                   End;

Const

 MenuColor : MenuAttrType =
  ( BoxT   :         1 ;
    BoxC   : LightGray ;
    BackC  : Blue      ;
    ForeC  : White     ;
    ABackC : Green     ;
    AForeC : White     ;
    FLBack : Blue      ;
    FLFore : White     ;
    HBackC : LightGray ;
    HBoxC  : Black     ;
    HForeC : Blue        ) ;

Var
 Keys     : String[50];                       { String collection of keys }
 Level    : Byte;                             { Current level of menu }

 Area     : Array [1..MaxLevel] of Pointer;   { Saved Screen Areas }
 Size     : Array [1..MaxLevel] of Word   ;   { Size of Image      }

 UpperLeft,                                   { Menues Window coordinates }
 LowerRight : Array [1..MaxLevel] of Word;
 PAttr      : Array [1..MaxLevel] of Byte;    { and attributes }
 PPage      : Array [1..MaxLevel] of Byte;    { Current Page }
 PHor       : Array [1..MaxLevel] of Boolean; { Hor menu }
 PType      : Array [1..MaxLevel] of Byte;    { Box Type }
 PItem      : Array [1..MaxLevel] of Byte;    { Current Row/Page depend on Hor }

 OrigMode   : Integer   ;
 NoTrace    : TraceType ;
 NoCHelp    : CHelpType ;
 NoGHelp    : GHelpType ;

Implementation
Begin

 Keys  := '';
 Level := 1 ;

 NoTrace.Required := False    ;
 NoCHelp.Present  := False    ;
 NoGHelp.Present  := False    ;
 OrigMode         := LastMode ;

End.
