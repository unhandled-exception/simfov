UNIT tDOS;

INTERFACE

Uses DOS;

function CopyFile( SourcePath, DestinationPath : String;
                                          BlockSize : Word ) : Boolean;
{ Функция копирует файл из SourcePath в DestinationPath                    }
{ Копирование производится блокам по BlockSize байт                        }
{ При небольших объемх файла рекомендуется устанавливать размер блока      }
{ равным физическому размеру файла                                         }
{ Функция возвращает True при удачном завершении                           }
{                                                                          }
{ !!! Функция не производит запросов у пользователя                        }

IMPLEMENTATION


function CopyFile( SourcePath, DestinationPath : String;
                                          BlockSize : Word ) : Boolean;
{ Функция копирует файл из SourcePath в DestinationPath                    }
{ Копирование производится блокам по BlockSize байт                        }
{ При небольших объемх файла рекомендуется устанавливать размер блока      }
{ равным физическому размеру файла                                         }
{ Функция возвращает True при удачном завершении                           }
{                                                                          }
{ !!! Функция не производит запросов у пользователя                        }
Var

  SFile,                            { Файл исходник                        }
  DFile        : File;              { Файл приемник                        }
  Block        : Pointer;           { Буфер блока                          }
  BlocksCount  : Word;              { Число блоков                         }
  EndBlockSize : Word;              { Размер последнего блока              }
  I            : Word;              { Счетчик                              }

begin

{ Открываем файлы }

  Assign( SFile, SourcePath );
  Assign( DFile, DestinationPath );

  Reset( SFile );                   { Файл исходник                        }
  If IOResult <> 0 Then             { Проверка на ошибки                   }
    begin
      CopyFile := False;
      Exit;
    end;

  ReWrite( DFile );                 { Файл приемник                        }
  If IOResult <> 0 Then             { Проверка на ошибки                   }
    begin
      CopyFile := False;
      Exit;
    end;

{ Вычисляем число блоков }

  BlocksCount := FileSize( SFile ) div BlockSize;

{ Вычисляем размер последнего блока }

  EndBlockSize := FileSize( SFile ) - ( BlockSize * ( BlocksCount - 1 )) + 1;


{ Копируем по блокам }

  GetMem( Block, BlockSize );       { Выделяем память под буфер            }


  For I := 1 to BlocksCount do
    begin

     If BlocksCount - 1 = I Then    { Устанавливаем длину последнего блока }
       BlockSize := EndBlockSize;

     BlockRead ( SFile, Block, BlockSize );{ Читаем блок из фала источника }
     If IOResult <> 0 Then                 { Проверка на ошибки            }
      begin
       CopyFile := False;
       Exit;
      end;

     BlockWrite( DFile, Block, BlockSize );{ Пишем блок в файл приемник    }
     If IOResult <> 0 Then                 { Проверка на ошибки            }
      begin
       CopyFile := False;
       Exit;
      end;

    end;

  FreeMem( Block, BlockSize );       { Освобождаем память буфера           }


  Close( SFile );
  Close( DFile );

end;

END.
