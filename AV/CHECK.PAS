
{$O+,F+}

Unit check;          { Проверка входных файлов }
InterFace
Uses Dos ;
Procedure CheckFile( FileName : PathStr )       ;
Function  Exist( FileName : PathStr ) : boolean ;
Procedure Fatal( ErrMsg   : PathStr )           ;

Implementation
Uses
 Crt, PVar, MLib;
Procedure Fatal ( ErrMsg : PathStr ) ;
Var
 ta : byte;
Begin
 ta:=textattr;
 ClrScr ;
 textattr := red * 16 + white;
 gotoxy((79-length(ErrMsg)) div 2, 24);
 write(ErrMsg);
 textattr:=ta;
 CatNotFound := True ;
{
 halt(1);
}
End ;

Function Exist ( FileName : PathStr ) : Boolean;
Begin
 Exist:= ( FSearch ( FileName,'') <> '') ;
End;

Procedure CheckFile ( FileName : PathStr ) ;
Var Ch : Char ;
Begin
 If Not Exist ( FileName ) Then
   Begin
     Fatal ( 'File '+ FileName + ' not found...') ;
     Repeat
     Until  KeyPressed ;
     Ch := GetCh ;
   End ;
End;

End.