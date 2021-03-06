UNIT tDOS;

INTERFACE

Uses DOS;

function CopyFile( SourcePath, DestinationPath : String;
                                          BlockSize : Word ) : Boolean;
{ �㭪�� ������� 䠩� �� SourcePath � DestinationPath                    }
{ ����஢���� �ந�������� ������ �� BlockSize ����                        }
{ �� �������� ��ꥬ� 䠩�� ४��������� ��⠭�������� ࠧ��� �����      }
{ ࠢ�� 䨧��᪮�� ࠧ���� 䠩��                                         }
{ �㭪�� �����頥� True �� 㤠筮� �����襭��                           }
{                                                                          }
{ !!! �㭪�� �� �ந������ ����ᮢ � ���짮��⥫�                        }

IMPLEMENTATION


function CopyFile( SourcePath, DestinationPath : String;
                                          BlockSize : Word ) : Boolean;
{ �㭪�� ������� 䠩� �� SourcePath � DestinationPath                    }
{ ����஢���� �ந�������� ������ �� BlockSize ����                        }
{ �� �������� ��ꥬ� 䠩�� ४��������� ��⠭�������� ࠧ��� �����      }
{ ࠢ�� 䨧��᪮�� ࠧ���� 䠩��                                         }
{ �㭪�� �����頥� True �� 㤠筮� �����襭��                           }
{                                                                          }
{ !!! �㭪�� �� �ந������ ����ᮢ � ���짮��⥫�                        }
Var

  SFile,                            { ���� ��室���                        }
  DFile        : File;              { ���� �ਥ����                        }
  Block        : Pointer;           { ���� �����                          }
  BlocksCount  : Word;              { ��᫮ ������                         }
  EndBlockSize : Word;              { ������ ��᫥����� �����              }
  I            : Word;              { ���稪                              }

begin

{ ���뢠�� 䠩�� }

  Assign( SFile, SourcePath );
  Assign( DFile, DestinationPath );

  Reset( SFile );                   { ���� ��室���                        }
  If IOResult <> 0 Then             { �஢�ઠ �� �訡��                   }
    begin
      CopyFile := False;
      Exit;
    end;

  ReWrite( DFile );                 { ���� �ਥ����                        }
  If IOResult <> 0 Then             { �஢�ઠ �� �訡��                   }
    begin
      CopyFile := False;
      Exit;
    end;

{ ����塞 �᫮ ������ }

  BlocksCount := FileSize( SFile ) div BlockSize;

{ ����塞 ࠧ��� ��᫥����� ����� }

  EndBlockSize := FileSize( SFile ) - ( BlockSize * ( BlocksCount - 1 )) + 1;


{ �����㥬 �� ������ }

  GetMem( Block, BlockSize );       { �뤥�塞 ������ ��� ����            }


  For I := 1 to BlocksCount do
    begin

     If BlocksCount - 1 = I Then    { ��⠭�������� ����� ��᫥����� ����� }
       BlockSize := EndBlockSize;

     BlockRead ( SFile, Block, BlockSize );{ ��⠥� ���� �� 䠫� ���筨�� }
     If IOResult <> 0 Then                 { �஢�ઠ �� �訡��            }
      begin
       CopyFile := False;
       Exit;
      end;

     BlockWrite( DFile, Block, BlockSize );{ ��襬 ���� � 䠩� �ਥ����    }
     If IOResult <> 0 Then                 { �஢�ઠ �� �訡��            }
      begin
       CopyFile := False;
       Exit;
      end;

    end;

  FreeMem( Block, BlockSize );       { �᢮������� ������ ����           }


  Close( SFile );
  Close( DFile );

end;

END.
