{$O+,F+}

Unit PGreek ;

Interface

Procedure  Greek ( X, Y : Integer; Let, Cnst : String ) ;


Implementation

Uses

 Graph, Crt, Dos, PVar ;


Procedure  Greek ( X, Y : Integer; Let, Cnst : String ) ;

 Var
     S    : String [ 3 ] ;
     SOut : String       ;
     Ind  : Integer      ;

  Begin

    S := Copy ( Let, 1, 3 ) ;
{
BGreekLat := False ;
}   {
    If  ( BGreekLat )
      Then
        Begin
    }
          {
          If  S = 'Alp'  Then  SOut := 'a' ;
          If  S = 'Bet'  Then  SOut := 'b' ;
          If  S = 'Gam'  Then  SOut := 'g' ;
          If  S = 'Del'  Then  SOut := 'd' ;
          If  S = 'Eps'  Then  SOut := 'e' ;
          If  S = 'Zet'  Then  SOut := 'z' ;
          If  S = 'Eta'  Then  SOut := 'h' ;
          If  S = 'The'  Then  SOut := 'q' ;
          If  S = 'Iot'  Then  SOut := 'i' ;
          If  S = 'Kap'  Then  SOut := 'k' ;
          If  S = 'Lam'  Then  SOut := 'l' ;
          If  S = 'Mu '  Then  SOut := 'm' ;
          If  S = 'Nu '  Then  SOut := 'n' ;
          If  S = 'Xi '  Then  SOut := 'j' ;
          If  S = 'Omi'  Then  SOut := 'o' ;
          If  S = 'Pi '  Then  SOut := 'p' ;
          If  S = 'Rho'  Then  SOut := 'r' ;
          If  S = 'Sig'  Then  SOut := 's' ;
          If  S = 'Tau'  Then  SOut := 't' ;
          If  S = 'Ups'  Then  SOut := 'u' ;
          If  S = 'Phi'  Then  SOut := 'f' ;
          If  S = 'Chi'  Then  SOut := 'x' ;
          If  S = 'Psi'  Then  SOut := 'v' ;
          If  S = 'Ome'  Then  SOut := 'w' ;
          }

          If  S = 'Alp'  Then  SOut := Chr ( 179 ) ;
          If  S = 'Bet'  Then  SOut := Chr ( 180 ) ;
          If  S = 'Gam'  Then  SOut := Chr ( 181 ) ;
          If  S = 'Del'  Then  SOut := Chr ( 182 ) ;
          If  S = 'Eps'  Then  SOut := Chr ( 183 ) ;
          If  S = 'Zet'  Then  SOut := Chr ( 184 ) ;
          If  S = 'Eta'  Then  SOut := Chr ( 185 ) ;
          If  S = 'The'  Then  SOut := Chr ( 186 ) ;
          If  S = 'Iot'  Then  SOut := Chr ( 187 ) ;
          If  S = 'Kap'  Then  SOut := Chr ( 188 ) ;
          If  S = 'Lam'  Then  SOut := Chr ( 189 ) ;
          If  S = 'Mu '  Then  SOut := Chr ( 190 ) ;
          If  S = 'Nu '  Then  SOut := Chr ( 191 ) ;
          If  S = 'Xi '  Then  SOut := Chr ( 192 ) ;
          If  S = 'Omi'  Then  SOut := Chr ( 193 ) ;
          If  S = 'Pi '  Then  SOut := Chr ( 194 ) ;
          If  S = 'Rho'  Then  SOut := Chr ( 195 ) ;
          If  S = 'Sig'  Then  SOut := Chr ( 196 ) ;
          If  S = 'Tau'  Then  SOut := Chr ( 197 ) ;
          If  S = 'Ups'  Then  SOut := Chr ( 198 ) ;
          If  S = 'Phi'  Then  SOut := Chr ( 199 ) ;
          If  S = 'Chi'  Then  SOut := Chr ( 200 ) ;
          If  S = 'Psi'  Then  SOut := Chr ( 201 ) ;
          If  S = 'Ome'  Then  SOut := Chr ( 202 ) ;

      {
        End
      Else
          SOut := S ;
      }

    If ( Let [ 4 ] <> ' ' )  Then
      Begin
        {
        SOut := SOut + Let [ 4 ] ;
        }
        Val ( Let [ 4 ], Ind, Code ) ;
        SOut := SOut + Char ( 202 + Ind ) ;
      End ;

    If ( Cnst <> '   ' )  Then
      SOut := SOut + ' ' + Cnst ;

    OutTextXY ( X, Y, SOut ) ;


  End ;

End.
