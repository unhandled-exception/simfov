program outfont;

Uses Font816;

Var
  F : File of Byte;

  I, k : Word;

begin

  Assign( F, 'SYMFOV.816' );
  ReWrite( F );

  For I := 1 to 256 do
   For K := 1 to 16 do
     Write( F, Byte( Font8_16[I][K] ) );

  Close( f );

end.