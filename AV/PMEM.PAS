
{$O+,F+}


Unit PMem ;   { Работа с динамической памятью }
              { ============================= }
Interface


Function  AllocBlock       : Boolean ;   { Выделение очеpедного блока }
Function  AllocBlockPlanet : Boolean ;
Procedure FreeAll ;   { Освобождение всей памяти, занятой данными }


  Implementation
{ ============== }

Uses PVar, Crt ;


Function AllocBlock : Boolean;
        {──────────}
Begin

    If ( ( MaxAvail - GraphBuffSize < SizeOf ( ObjectArrType ) )
          Or ( CBlock >= ObjectMaxBlocksInit - 1 ) ) Then
      Begin
        AllocBlock := False;
        BlockAllocFlag [ CBlock ] := False ;
      End
     Else
      Begin
        GetMem ( ObjectPtr [ CBlock ] , SizeOf ( ObjectArrType ) );
        BlockAllocFlag [ CBlock ] := True ;
        AllocBlock := True;
      End

End;




Function AllocBlockPlanet : Boolean;
        {────────────────}
Begin

    If ( ( MaxAvail - GraphBuffSize < SizeOf ( PlanetArrType ) )
          Or ( CBlockPlanet >= PlanetMaxBlocksInit           ) ) Then
      Begin
        AllocBlockPlanet := False;
        PlanetAllocFlag [ CBlockPlanet ] := False ;
      End
     Else
      Begin
        GetMem ( PlanetPtr [ CBlockPlanet ] , SizeOf ( PlanetArrType ) );
        PlanetAllocFlag [ CBlockPlanet ] := True ;
        AllocBlockPlanet := True;
      End


End;


Procedure FreeAll;
Begin

 CBlock := 0 ;

 While BlockAllocFlag [ CBlock ] Do
  Begin
    FreeMem ( ObjectPtr [ CBlock ], SizeOf ( ObjectArrType ));
    BlockAllocFlag [ CBlock ] := False ;
    Inc ( CBlock ) ;
  End;


 CBlockPlanet := 0 ;

 While PlanetAllocFlag [ CBlockPlanet ] Do
  Begin
    FreeMem ( PlanetPtr [ CBlockPlanet ], SizeOf ( PlanetArrType ));
    PlanetAllocFlag [ CBlockPlanet ] := False ;
    Inc ( CBlockPlanet ) ;
  End;


 If ( DE200Buf <> Nil )  Then
   FreeMem ( DE200Buf , SizeOf ( DE200 ) ) ;
 DE200Buf := Nil ;

 If ( Ekv <> Nil )  Then
   FreeMem ( Ekv , SizeOf ( EkvArr ) );
 Ekv := Nil ;


 If ( Materiki <> Nil )  Then
   Begin
     FreeMem ( Materiki, SizeOf ( MaterikiArr ) );
     Materiki := Nil ;
   End ;

 If ( SatEartchPoint <> Nil )  Then
   Begin
     FreeMem ( SatEartchPoint, MaxSatMark * SizeOf ( SatEartchPointType ) ) ;
     SatEartchPoint := Nil ;
   End ;


 If ( PlateZagol <> Nil )  Then
   FreeMem ( PlateZagol , SizeOf ( PlateZagolArr ) );
 PlateZagol := Nil ;

 If ( PmVect <> Nil )  Then
   FreeMem ( PmVect , SizeOf ( PmVectArr ) );
 PmVect := Nil ;


{
 If ( FlagAcMainNumAlloc )  Then
   Begin
     FreeMem ( AcMainNum , SizeOf ( AcMainNumArr ) );
     FlagAcMainNumAlloc := False ;
   End ;
}

End;

End.
