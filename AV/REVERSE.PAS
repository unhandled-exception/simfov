
{$O+,F+}

Unit Reverse; { Reverses coordinates }

Interface
Procedure DoReverse ( RevX, RevY : Boolean );

Implementation
Uses
    PVar, Graph, Glib, PProFld, POscreen, Curs, Service;

Procedure DoReverse ( RevX, RevY : Boolean );
Var Ind : Integer ;
  Begin


    { ����⠭���� ������� ���न���� ��ꥪ⮢ }
    { ����������������������������������������� }

    ResetObjects ;

    If ( RevX ) Then
      XOrient := - XOrient ;

    If ( RevY ) Then
      YOrient := - YOrient ;

    RecalcObjects ;

    OScreen ;

    Orient ;

    LastObject := - 1 ;


  End;

End.
