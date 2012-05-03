
{$O+,F+}

UNIT PCdcFLD ;   { ВЫБОР ЗВЕЗД  Cdc }
                 { ================ }


  INTERFACE

    USES  DOS, V_CATAL, PVAR, PVarMenu, PPreOld, PPreNew,
          PJd8 , PMem ;


    PROCEDURE CdcFLD ;


  IMPLEMENTATION



    PROCEDURE CdcFLD ;
   {****************}



 LABEL

     EndMemory ;

 Var

     Tag                                : Char    ;

     PREdGsc, PhotRed                   : Boolean ;

     RaAkCH , RaAkCM,
     NSerAkZagol                        : Byte    ;

     AkDate                             : Word    ;

     DeclAkCg                           : Integer ;

     Ss, D70,
     RaNp, DeclNp                       : Double  ;


     RectCoordFile  : File  Of  AkStarType  ;
     AkStarRec      :           AkStarType  ;



     Begin  { PRO CdcFld }
            { ▄▄▄▄▄▄▄▄▄▄ }


        IndCat [ CatCdc ].RoDet := Param.RoCdcDet ;


        RAOPTFLD   := RAOPT   ;
        DECLOPTFLD := DECLOPT ;


        Assign ( RectCoordFile  , RectCoordFileName   ) ;

                    {$I-}
        Reset  ( RectCoordFile ) ;
                    {$I+}
        If ( IOResult <> 0 )  Then
          Begin
            GoTo EndMemory ;  { Файл AKZ отсутствует }
          End ;

        Seek   ( RectCoordFile  , AkZagolRec.NBeg + 1 ) ;


                { Дата пластинки }
                { ************** }

        AkDate := Round (( AkZagolRec.Year - 1890 ) * 13 + AkZagolRec.Mon ) ;
	JD8 ( AkZagolRec.Year , AkZagolRec.Mon , AkZagolRec.Day  , JdAk );



               { Чтение Звезд АК }
               { ─────────────── }

        MType := AkZagolRec.MeType  ;

        If ( MType = 0 )  Then
            Begin  { Diameter }

              If ( Abs ( PRedK1Gsc ) > 1.0e-6 ) Then
                  Begin
                    If ( PRedK1Gsc * PRedK1Gsc  -
                         4.0 * PRedK2Gsc * ( PRedK0Gsc - 8.5 ) ) > 0.01  Then
                      Begin
                        D70 := ( - PRedK1Gsc -
                               Sqrt ( PRedK1Gsc * PRedK1Gsc  -
                               4.0 * PRedK2Gsc * ( PRedK0Gsc - 8.5 ) ) ) /
                           (   C20 * PRedK2Gsc ) ;
                      End
                     Else
                      Begin  { Поиск D70 по PPM }
                        If ( PRedK1PPM < - 0.1 )
                           Then D70 := ( 8.5 - PRedK0PPM ) / PRedK1PPM
                           Else D70 := 10.0 ;
                      End;
                  End
               Else
                  Begin
                    If (  PRedK1PPM < - 0.1 )
                       Then D70 := ( 8.5 - PRedK0PPM ) / PRedK1PPM
                       Else D70 := 10.0 ;
                  End ;

            End ;  { Diameter }




        FOR JStar := 1 TO  AkZagolRec.RecCount  DO

          Begin  { JStar }

            Read ( RectCoordFile , AkStarRec ) ;

            NUMSTAR := AkStarRec.N ;

            If ( NumStar Mod 2 = 0 )  Then

              Begin  { Звезда пpигожая }
                     { --------------- }

                X  := AkStarRec.X / 160000 ;
                Y  := AkStarRec.Y / 160000 ;

                X := - X ;

                XSt :=  X * Ax  +  Y * Bx  +  Cx  +  D * X * X  +  E * X * Y  ;
                YSt :=  X * Ay  +  Y * By  +  Cy  +  D * X * Y  +  E * Y * Y  ;


                IF  ( NumberOfStars mod ObjectBlockSize = 0 )  Then
                  CBlock :=  NumberOfStars Div ObjectBlockSize ;


                If (    ( BlockAllocFlag [ CBlock ] )
                     Or (  AllocBlock               )  )  Then

                     Begin

                       With ObjectPtr [ NumberOfStars div ObjectBlockSize]^
                                      [ NumberOfStars mod ObjectBlockSize] do
                         Begin  { Очередная звезда }
                                { ---------------- }

                           X	  :=  XST ;
			   Y	  :=  YST ;
                           Sp     :=  11    ;
{
			   NRecC  :=  AkDate +
                                      ( AkStarRec.N shr 10 ) * 1000 ;
}
			   NRecC  :=  AkDate +
                                      ( AkStarRec.N Div 1024 ) * 1000 ;

                           PhotRed := True ;
                           If ( ( AkStarRec.N Div 8 ) Mod 2 ) = 1
                               Then PhotRed := False ;


                           If (     ( MType = 0 )
                                And ( PhotRed   )  )  Then

                               Begin  { Diameter }
                                      { -------- }
{
   	                         Mv  :=  Sqrt ( AkStarRec.E Shr 4 ) ;
}
   	                         Mv  :=  Sqrt ( AkStarRec.E Div 16 ) ;

                                 If ( AkStarRec.E and 2 = 2 )
                                   Then Mv := 5 ;

                                 If ( Mv < D70 )
                                    Then  PRedGsc := True
                                    Else  PRedGsc := False ;

                               End

                            Else

                             Begin   { Magnitude }
                                     { --------- }
{
                               Mv  := ( AkStarRec.E Shr 4 ) / 10 ;
}
                               Mv  := ( AkStarRec.E Div 16 ) / 10 ;

                               If ( AkStarRec.E and 2 = 2 )
                                  Then Mv := 13 ;

                               If ( Mv > 8.5 )
                                  Then  PRedGsc := True
                                  Else  PRedGsc := False ;

                             End ;


                              { Фотометpическая pедукция }
                              { ------------------------ }

                           If ( PhotRed )  Then
                             Begin  { PhotRed }
                               If (     ( Abs ( PRedK2GSC ) < 99  )
                                    And ( PRedGsc                 ) ) Then
                                 Begin
                                   Mv :=  PRedK0Gsc + PRedK1Gsc * Mv
                                                    + PRedK2Gsc * Mv * Mv ;
                                 End
                                Else
                                 Begin
                                   Mv := PRedK0PPM + PRedK1PPM * Mv ;
                                 End ;
                             End ;  { PhotRed }


                           M :=  Round ( ( MV + 5 ) * 10 ) ;


                         End ;   { Очередная звезда }
                                 { ---------------- }

                       If ( IndCat [ CatCdc ].NBEG = -1 )  Then
                            IndCat [ CatCdc ].NBEG := NumberOfStars ;

                       NumberOfStars  :=  NumberOfStars  +   1 ;


                     End   { Блок выделен }
                           { ------------ }
                    ELSE
                      Begin
                        Close  ( RectCoordFile ) ;
                        GOTO EndMemory ;  { Исчеpпана память }
                                          { ---------------- }
                      End ;

              End ;  { Звезда пpигожая }
                     { --------------- }

            End ;  { JStar }

 Close ( RectCoordFile ) ;


 EndMemory : ;


     If ( IndCat [ CatCdc ].NBeg <> -1 )  Then
       Begin
          IndCat [ CatCdc ].NEnd      := NumberOfStars - 1 ;
          IndCat [ CatCdc ].TypeCoord := IdCoord           ;
       End ;

    End ;  { PRO SAOFLD }

End.

