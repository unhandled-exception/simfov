
{$O+,F+}


Unit  PGalEkv ;


 InterFace
{ÜÜÜÜÜÜÜÜÜ}

 Procedure GalEkv (     L, B                     : Double ;
{ÄÄÄÄÄÄÄÄÄ}         Var Ra, Decl,
                        SRa, CRa, SDecl, CDecl   : Double  ) ;



  Procedure EkvGal ( Ra, Decl : Double;  Var  L, B : Double ) ;


 Implementation
{ÜÜÜÜÜÜÜÜÜÜÜÜÜÜ}

Uses PVar, V_Catal, PPreNew, PAtan2 ;

Const
   dLNewOld = 33.0 * 3600.0 / 206264.8062470964 ;




 Procedure GalEkv (     L, B                     : Double ;
{ÄÄÄÄÄÄÄÄÄ}         Var Ra, Decl,
                        SRa, CRa, SDecl, CDecl   : Double  ) ;


  Var
       Sl, Cl, Sb, Cb, dRa, SdRa, CdRa   : Double ;

  Begin

    Sl := Sin ( L - dLNewOld ) ;
    Cl := Cos ( L - dLNewOld ) ;
    Sb := Sin ( B ) ;
    Cb := Cos ( B ) ;

    SDecl := Sb * SDeclGalPol50  +  Cb * CDeclGalPol50 * Sl ;
    CDecl := Sqrt ( C10 - Sqr ( SDecl )  ) ;

    Decl := ArcTan ( SDecl / CDecl ) ;

    SdRa := Cb * Cl ;
    CdRa := Sb * CDeclGalPol50  -  Cb * SDeclGalPol50 * Sl ;

    If ( Abs ( CdRa ) > 0.1e-11 )
      Then
        Begin
          dRa  := ATan2 ( SdRa, CdRa ) ;
        End
      Else
        Begin
          If ( SdRa > 0 )
            Then dRa :=            Pi / C20
            Else dRa := Pi * C20 - Pi / C20 ;
        End ;

    Ra := dRa + RaGalPol50 ;
    If ( Ra > Pi * C20 )  Then
      Ra := Ra - Pi * C20 ;

    PreNew ( JD50, JDateFld, Ra, Decl ) ;

    SRa   := Sin ( Ra ) ;
    CRa   := Cos ( Ra ) ;

    SDecl := Sin ( Decl ) ;
    CDecl := Cos ( Decl ) ;

  End ;


 Procedure  EkvGal ( Ra, Decl : Double;  Var  L, B : Double ) ;
{ÄÄÄÄÄÄÄÄÄ}

 Var

     dRa, CdRa, SDecl, CDecl, Sl, Cl, Sb, Cb  : Double ;

  Begin

    PreNew ( JDateFld, JD50, Ra, Decl ) ;

    SDecl := Sin ( Decl ) ;
    CDecl := Sqrt ( C10 - Sqr ( SDecl )  );
    dRa   := Ra - RaGalPol50 ;
    CdRa  := Cos ( dRa ) ;

    Sb := SDeclGalPol50 * SDecl  +  CDeclGalPol50 * CDecl * CdRa ;
    Cb := Sqrt ( C10 - Sqr ( Sb )  ) ;

    Cl := CDecl * Sin ( dRa ) ;
    Sl := CDeclGalPol50 * SDecl  -  SDeclGalPol50 * CDecl * CdRa ;

    If ( Cb > 1.0e-11 )
      Then
        Begin
          B := ArcTan ( Sb / Cb ) ;
        End
      Else
        Begin
          If ( Sb > 0 )
            Then B :=   Pi / C20
            Else B := - Pi / C20 ;
        End ;

    If ( Abs ( Cl ) > 1.0e-11 )
      Then
        Begin
          L  := ATan2 ( Sl, Cl ) ;
        End
      Else
        Begin
          If ( Sl > 0 )
            Then L :=          Pi / C20
            Else L := Pi*C20 - Pi / C20 ;
        End ;

    L := L + dLNewOld ;

    If ( L > Pi*C20 )  Then
      L := L - Pi*C20 ;

  End;


End.