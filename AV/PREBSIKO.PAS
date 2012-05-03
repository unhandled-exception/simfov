
{$O+,F+}



Unit PreBsIko ;

Interface

       Procedure PrepareBsIko ( Var NBsIko : Word ) ;

Implementation
Uses

 PVar, V_Catal, PVarMenu ;


       Procedure PrepareBsIko ( Var NBsIko : Word ) ;


 Var

   InputFileName : String ;

   InpFile   : File of BsSrcType   ;
   InpRecord : BsSrcType           ;

   PrecCalk  : Boolean ;

   II,
   NOut,
   MVINP         : INTEGER ;


   I,
   IND,
   NN,
   NW,
   NREC          : LONGINT ;


   RR,
   Mv,
   MPred,
   SRa, CRa,
   SDecl, CDecl,
   X, Y, Z,
   PmX, PmY, PmZ,
   Ra,
   Dec            : DOUBLE ;


Begin

 MPred := MvMax ;
 If ( MPred > 4.5 )  Then
   MPred := 4.5 ;

 Assign  ( InpFile, ParamDir.BsDir + '\' + 'Bs.Bin' ) ;
 FileMode := 0;  { Set file access to read }
 Reset   ( InpFile                ) ;

 GetMem ( BsIko, SizeOf ( BsIkoArr ) ) ; ;


 NOut := 0 ;

 If ( BsIko <> Nil )  Then
 While ( Not Eof ( InpFile ) )  Do
  Begin { Not Eof ( InpFile ) }

   Read ( InpFile, InpRecord ) ;

   Mv := InpRecord.Mv / C1000 ;

   If ( Mv <= MPred )  Then
     Begin  {  Mv  }

       Ra  := InpRecord.Ra  ;
       Dec := InpRecord.Dec ;

       BsIkoRec.Sa  := Round ( Sin ( Ra  ) * 32000.0 )  ;
       BsIkoRec.Ca  := Round ( Cos ( Ra  ) * 32000.0 )   ;
       BsIkoRec.Sd  := Round ( Sin ( Dec ) * 32000.0 )   ;

       BsIkoRec.Mv  :=  Round ( ( Mv + 5.0 ) * 10.0 );

       Inc ( NOut ) ;

       BsIko^ [ NOut ] := BsIkoRec ;


     End ;  { Mv  }

  End ; { Not Eof ( InpFile ) }

 Close ( InpFile    ) ;

 NBsIko := NOut ;

End ;

End.
