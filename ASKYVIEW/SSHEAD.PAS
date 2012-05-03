{$F+,O+}

Unit SSHead;

Interface

Uses Crt, SSVar, PVar, TStdObj, TDrivers, TUtil;

procedure HeadRun;

Implementation

Const

  TileNormalText     = LightCyan  +  Blue * 16 ;
  TileTitleText      = Yellow     +  Blue * 16 ;
  TileParamText      = Black      +  Cyan * 16 ;
  TileNameParamText  = White      +  Cyan * 16 ;
  TileBorderText     = Cyan       +  Blue * 16 ;

{**********
  TileTitleText      = Yellow     +  Blue * 16 ;
  TileTitleText      = LightGray  +  Blue * 16 ;
***********}

  Flag : boolean = False;

Type

  TStr = String[ 60 ];

  PHead = ^THead;
  THead = object

    Title : String;
    R     : TRect;

    constructor Init( TTitle : String );
    procedure   Draw;

  End;

Var
  Tile : THead;

procedure HeadRun;
Begin

  If Not Flag Then
    Begin

      Tile.Init( '' );
      Flag := True;

    End;

  Tile.Draw;

End;


constructor THead.Init( TTitle : String );
Begin

  Title  := TTitle;
  R.Assign( 1, 16, 80, 24 );

End;

procedure THead.Draw;
Var
  h : byte;

  OldWindMin,
  OldWindMax : Word;

  Y,x        : Byte;

  S          : String[16];

  I          : Integer ;
  NObjOut    : Word ;
  OCF        : Word;

Begin

 With R do
   Begin

     Y := 0;
     X := 15;

     OldWindMin   :=  WindMin;
     OldWindMax   :=  WinDMax;

     Window( a.x, a.y, b.x, b.y );
     FillWin( ' ', TileNormalText );

     Window( 1, 1, 80, 25 );

     WriteChar( A.X , a.y, 1 , '⁄', TileBorderText );
     WriteChar( A.X , b.y, 1 , '‘', TileBorderText );
     WriteChar( B.X , a.y, 1 , '∑', TileBorderText );
     WriteChar( B.X , B.y, 1 , 'º', TileBorderText );


     WriteChar( A.X + 1, a.y, b.x - a.x - 1 , 'ƒ', TileBorderText );
     WriteChar( A.X + 1, b.y, b.x - a.x - 1 , 'Õ', TileBorderText );

     For h := a.Y + 1 to   b.y - 1 do
       Begin

         WriteChar( A.X, H, 1, '≥', TileBorderText  );
         WriteChar( B.X, H, 1, '∫', TileBorderText  );

       End;

    If MainParamFileName <> '' Then
     WriteStr( A.X + 1, A.Y,
         Title + ' ' + UpString( MainParamFileName ) + ' ', TileTitleText )
       else
     WriteStr( A.X + 1, A.Y,
         Title + ' ' + MainParamFileMemo + ' ', TileTitleText );



  { ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }


    Window( a.x + 1, a.y + 1, b.x - 1, b.y - 1 );

     For h := 1 to  B.Y - A.Y - 1 do
       WriteChar( 15, H, 63,' ', TileParamText );



                  { H†°´Ó§†‚•´Ï }
                  { ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ }

    Inc( y );

    WriteStr( 1,Y,'Observer',TileNormalText );
    TextAttr :=  TileParamText;

    GoToXY( X,Y );


    If ( Space_Earth_Flag = 1 )  Then

      Begin  { è´†≠•‚† }
             { ƒƒƒƒƒƒƒ }

        If TPCP = 1 Then

          Begin  { è´†≠•‚Æñ•≠‚p }
                 { ƒƒƒƒƒƒƒƒƒƒƒƒ }

            TextAttr :=  TileNameParamText;
            Write ( ' ', PlanetName [ KosmosCentralTelo ] ) ;
            TextAttr :=  TileParamText;

           End   { è´†≠•‚Æñ•≠‚p }
                 { ƒƒƒƒƒƒƒƒƒƒƒƒ }

          Else

           Begin { èÆ¢•pÂ≠Æ·‚Ï }
                 { ƒƒƒƒƒƒƒƒƒƒƒ }

             If ( KosmosCentralTelo <> 3 )
               Then
                 Begin
                   TextAttr :=  TileNameParamText;
                   Write ( ' ', PlanetName [ KosmosCentralTelo ] ) ;
                   TextAttr :=  TileParamText;
                 End
               Else
                 Begin

                   TextAttr :=  TileNameParamText;
                   Write ( ' Long : ' ) ;
                   TextAttr :=  TileParamText;

                   Write (  TeleskopPosition.Dolgota.Bchar,
                            TeleskopPosition.Dolgota.PI1 : 3     ,'¯',
                            TeleskopPosition.Dolgota.PI2 : 2     ,#249,
                            TeleskopPosition.Dolgota.PD  : 2 : 0 ,#250 ) ;

                   TextAttr :=  TileNameParamText;
                   Write ( '   Lat  : ' ) ;
                   TextAttr :=  TileParamText;


                   Write (  TeleskopPosition.Shirota.Bchar,
                            TeleskopPosition.Shirota.PI1 : 2     ,'¯',
                            TeleskopPosition.Shirota.PI2 : 2     ,#249,
                            TeleskopPosition.Shirota.PD  : 2 : 0 ,#250 );

                   TextAttr :=  TileNameParamText;
                   Write ( '  Height : ' ) ;
                   TextAttr :=  TileParamText;

                   Write ( TeleskopPosition.Height : 6 : 3,' km'   )

                 End ;

           End ; { èÆ¢•pÂ≠Æ·‚Ï }
                 { ƒƒƒƒƒƒƒƒƒƒƒ }


      End    { è´†≠•‚† }
             { ƒƒƒƒƒƒƒ }
     Else

      Begin  { äÆ·¨Æ· }
             { ƒƒƒƒƒƒ }

        If ( SetOptOrbit Div 4 = 0 )
          Then
            Begin

              If ( SetOptOrbit Mod 4 = 1 )  Then
                Begin  { Kepler }

                  TextAttr :=  TileNameParamText;
                  Write ( ' ', PlanetName [ KosmosCentralTelo ] ) ;
                  TextAttr :=  TileParamText;

                  TextAttr :=  TileNameParamText;
                  Write ( 'Ha ' ) ;
                  TextAttr :=  TileParamText;
                  Write ( KosmosOrbita.HeightAppoCentra : 0 : 0 );

                  TextAttr :=  TileNameParamText;
                  Write ( ' Hp ' ) ;
                  TextAttr :=  TileParamText;
                  Write ( KosmosOrbita.HeightPeriCentra : 0 : 0 );

                  TextAttr :=  TileNameParamText;
                  Write ( ' i: ' ) ;
                  TextAttr :=  TileParamText;
                  Str ( KosmosOrbita.NaklOrbKEkv      : 0 : 1 , S );
                  S [ Length ( S ) - 1 ] := #243 ;
                  Write ( S ) ;

                  TextAttr :=  TileNameParamText;
                  Write ( ' '#241': ' ) ;
                  TextAttr :=  TileParamText;
                  Str ( KosmosOrbita.PrVoshVoshUzla   : 0 : 1 , S );
                  S [ Length ( S ) - 1 ] := #243 ;
                  Write ( S ) ;

                  TextAttr :=  TileNameParamText;
                  Write ( ' '#242': ' ) ;
                  TextAttr :=  TileParamText;
                  Str ( KosmosOrbita.ArgPeriCentra    : 0 : 1 , S );
                  S [ Length ( S ) - 1 ] := #243 ;
                  Write ( S ) ;

                  TextAttr :=  TileNameParamText;
                  Write ( ' u: ' ) ;
                  TextAttr :=  TileParamText;
                  Str ( KosmosOrbita.ArgShir          : 0 : 1 , S );
                  S [ Length ( S ) - 1 ] := #243 ;
                  Write ( S ) ;

                End ;  { Kepler }


              If ( SetOptOrbit Mod 4 = 3 )  Then
                Begin  { X, Y }

                  TextAttr :=  TileNameParamText;
                  Write ( ' ', PlanetName [ KosmosCentralTelo ] ) ;
                  TextAttr :=  TileParamText;

                  TextAttr :=  TileNameParamText;
                  Write ( 'X ' ) ;
                  TextAttr :=  TileParamText;
                  Write ( KosmosOrbita.HeightAppoCentra : 0 : 0 );

                  TextAttr :=  TileNameParamText;
                  Write ( ' Y ' ) ;
                  TextAttr :=  TileParamText;
                  Write ( KosmosOrbita.HeightPeriCentra : 0 : 0 );

                  TextAttr :=  TileNameParamText;
                  Write ( ' Z ' ) ;
                  TextAttr :=  TileParamText;
                  Write ( KosmosOrbita.NaklOrbKEkv      : 0 : 0 );

                  TextAttr :=  TileNameParamText;
                  Write ( ' Vx ' ) ;
                  TextAttr :=  TileParamText;
                  Write ( KosmosOrbita.PrVoshVoshUzla   : 0 : 3 );

                  TextAttr :=  TileNameParamText;
                  Write ( ' Vy ' ) ;
                  TextAttr :=  TileParamText;
                  Write ( KosmosOrbita.ArgPeriCentra    : 0 : 3 );

                  TextAttr :=  TileNameParamText;
                  Write ( ' Vz ' ) ;
                  TextAttr :=  TileParamText;
                  Write ( KosmosOrbita.ArgShir          : 0 : 3 );

                End ;  { X, Y }


            End
          Else
            Begin  { ëØ„‚≠®™ ØÆ ≠Æ¨•p„ }

              If ( Round ( KosmosOrbita.NaklOrbKEkv ) <= -1 )
                Then
                  Begin
                    TextAttr :=  TileNameParamText;
                    Write ( ' Planet ways' );
                  End
                Else
                  Begin
                    TextAttr :=  TileNameParamText;
                    Write ( ' Satellite:  ' );
                    TextAttr :=  TileParamText;
                    Write ( ' Number ',
                      Trunc ( Abs ( KosmosOrbita.NaklOrbKEkv ) + 0.5 ) : 0 ) ;
                  End ;

            End ;

      End ;  { äÆ·¨Æ· }
             { ƒƒƒƒƒƒ }






              { éØ‚®Á•·™†Ô é·Ï }
              { ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ }

    Inc( y );

    WriteStr( 1,Y,'Ax Optic',TileNormalText );
    TextAttr :=  TileParamText;

    GoToXY( X,Y );

    Case OptOsOrient of

    1 : { ù™¢†‚Æp®†´Ï≠Î• ™ÆÆp§®≠†‚Î }
        { ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ }

     Begin

      TextAttr :=  TileNameParamText;
      If ( Regims.DetCdc = 0 )
        Then
          Begin
            If ( EkvCoord.Param1.PI1 >= 100 )
              Then  Write ( ' From Star : ' )
              Else  Write ( ' R.A. :   ' )
          End
        Else
          Write ( ' LGal :   ' ) ;
      TextAttr :=  TileParamText;

      If ( Regims.DetCdc = 0 )
        Then
          Begin
            Str ( EkvCoord.Param1.PD : 6 : 3 , S ) ;
            S [ 3 ] := #246 ;
            If ( EkvCoord.Param1.PI1 >= 100 )
              Then  Write (  EkvCoord.Param1.PI1 - 100 : 2, #244,
                             EkvCoord.Param1.PI2       : 2, #245,
                                               S       : 6        )
              Else  Write (  EkvCoord.Param1.PI1       : 2, #244,
                             EkvCoord.Param1.PI2       : 2, #245,
                                               S       : 6        ) ;
          End
        Else
          Begin
            Str ( EkvCoord.Param1.PD : 4 : 1 , S ) ;
            S [ 3 ] := #253 ;
            Write (  EkvCoord.Param1.PI1 : 2, #248,
                     EkvCoord.Param1.PI2 : 2, #249,
                                       S : 4        ) ;
          End ;

      TextAttr :=  TileNameParamText;
      If ( Regims.DetCdc = 0 )
        Then  Write ( '   Decl : ' )
        Else  Write ( '  BGal : ' ) ;

      TextAttr :=  TileParamText;

      If ( Regims.DetCdc = 0 )
        Then
          Begin
            Str ( EkvCoord.Param2.PD : 5 : 2 , S ) ;
            S [ 3 ] := #253 ;
            Write (  EkvCoord.Param2.BChar,
                     EkvCoord.Param2.PI1 : 2, #248,
                     EkvCoord.Param2.PI2 : 2, #249,
                                       S : 5        );
          End
        Else
          Begin
            Str ( EkvCoord.Param2.PD : 4 : 1 , S ) ;
            S [ 3 ] := #253 ;
            Write (  EkvCoord.Param2.BChar,
                     EkvCoord.Param2.PI1 : 2, #248,
                     EkvCoord.Param2.PI2 : 2, #249,
                                       S : 4        );
          End ;

        If ( DmFlag )  Then
          Begin
            TextAttr :=  TileNameParamText;
            If ( DmDel )
              Then
                Begin
                  TextColor ( White + Blink ) ;
                  Sound ( 1000 ) ;
                  Delay (  200 ) ;   { For 20 ms }
                  NoSound;
                  Write ( '   ', DMNumber, ' d' ) ;
                End
              Else
                  Write ( '   ', DMNumber       ) ;

            DmDel := False ;
          End ;

     End ;

    2 : { ÉÆp®ßÆ≠‚†´Ï≠Î• ™ÆÆp§®≠†‚Î }
        { ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ }

     Begin

      TextAttr :=  TileNameParamText;
      Write ( '    A : ' ) ;
      TextAttr :=  TileParamText;

      Write (  HorCoord.Param1.BChar,
               HorCoord.Param1.PI1 : 3, #248,
               HorCoord.Param1.PI2 : 2, #249,
               HorCoord.Param1.PD  : 2 : 0 , #250 ) ;

      TextAttr :=  TileNameParamText;
      Write ( '     H  : ' ) ;
      TextAttr :=  TileParamText;

      Write (  HorCoord.Param2.BChar,
               HorCoord.Param2.PI1 : 2, #248,
               HorCoord.Param2.PI2 : 2, #249,
               HorCoord.Param2.PD  : 2 : 0 , #250 );

     End ;


    3 : Begin  { é‚≠Æ·®‚•´Ï≠Æ ¢•™‚Æp† ·™ÆpÆ·‚® }
               { ‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ }


      TextAttr :=  TileNameParamText;
      Write ( ' Tangage : ' ) ;
      TextAttr :=  TileParamText;
      Str ( OrientDet.Tangag      : 0 : 3 , S );
      S [ Length ( S ) - 3 ] := #243 ;
      Write ( S ) ;

      TextAttr :=  TileNameParamText;
      Write ( '      Course : ' ) ;
      TextAttr :=  TileParamText;
      Str ( OrientDet.Ryskanie    : 0 : 3 , S );
      S [ Length ( S ) - 3 ] := #243 ;
      Write ( S ) ;


     End ;


    4 : Begin  { èÆ é°Í•™‚„ }
               { ‹‹‹‹‹‹‹‹‹‹ }

          Write (' ');

          TextAttr :=  TileNameParamText;

          If ( NObject < 12 )
            Then
                Write ( PlanetName [ NObject ] )
            Else
              Begin

                If ( NObject = 12 )
                  Then
                    Begin

                      If ( NObjectSputnikNum = 0 )
                        Then
                          Begin
                            Write ( 'A - H  View ' );
                          End
                        Else
                          Begin
                            Write ( 'Satellite:  ' );
                            TextAttr :=  TileParamText;
                            Write ( ' Number ', NObjectSputnikNum );
                          End
                    End
                  Else
                    Begin
                      While ( DMNumber [ Length ( DMNumber ) ] = ' ' ) Do
                        Delete ( DMNumber, Length ( DMNumber ) , 1 ) ;
                      If ( DmDel )  Then
                        TextColor ( White+Blink);
                      Write ( DMNumber,  ' : ' );
                    End ;
              End ;

          TextAttr :=  TileParamText;

        End; { èÆ é°Í•™‚„ }

    End; { case OptOsOrient }

   End;




                   { èÆ´• áp•≠®Ô }
                   { ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ }

    Inc( y );

    WriteStr( 1,Y,'Field of view', TileNormalText );
    TextAttr :=  TileParamText;

    GoToXY( X,Y );

    TextAttr :=  TileNameParamText;
    Write ( ' Size X: ' ) ;
    TextAttr :=  TileParamText;

    If ( PoleZr.RazmPolX >= 1.0 )
      Then  Str ( PoleZr.RazmPolX : 7 : 3 , S )
      Else  Str ( PoleZr.RazmPolX : 7 : 5 , S ) ;
    S [ Pos ( '.', S ) ] := #243 ;
    Write ( S ) ;

    TextAttr :=  TileNameParamText;
    Write ( '  Size Y: ' ) ;
    TextAttr :=  TileParamText;

    If ( PoleZr.RazmPolY >= 1.0 )
      Then  Str ( PoleZr.RazmPolY : 7 : 3 , S )
      Else  Str ( PoleZr.RazmPolY : 7 : 5 , S ) ;
    S [ Pos ( '.', S ) ] := #243 ;
    Write ( S ) ;


    TextAttr :=  TileNameParamText;
    Write ('  E');
    TextAttr :=  TileParamText;

    If PoleZr.OrientX > 0
      Then  Write (#27)
      Else  Write (#26);

    TextAttr :=  TileNameParamText;
    If Regims.NPolFix = 1
      Then  Write ( ' N')
      Else  Write ( ' Z');
    TextAttr :=  TileParamText;

    If PoleZr.OrientY > 0
      Then  Write (#24)
      Else  Write (#25);


    If Regims.DetImp = 1 Then
      Begin

        TextAttr :=  TileNameParamText;
        Write ('  Mv <= ' );
        TextAttr :=  TileParamText;

        Write ( FotometrHar.MvPred : 4 : 1 );

        TextAttr :=  TileNameParamText;
        Write (' DmDt:' ) ;
        TextAttr :=  TileParamText;

        Write ( FotometrHar.dMPriOtogd : 4 : 1 );

      End
     Else
      Begin

        Write ( FotometrHar.dMPriOtogd : 6 : 1 );
        TextAttr :=  TileParamText;

        TextAttr :=  TileNameParamText;
        Write (' <= Mv <= ' ) ;
        TextAttr :=  TileParamText;

        Write ( FotometrHar.MvPred : 4 : 1 );

      End ;



                   { ä†‚†´Æ£® }
                   { ﬂﬂﬂﬂﬂﬂﬂﬂ }

    Inc( y );

    WriteStr( 1,Y,'Catalogs',TileNormalText );

    GoToXY( X,Y );
    Write ( ' ' ) ;

    OCF := CCatalogFlag;

    TextAttr :=  TileNameParamText;

    For I := 1 To CatImp + 1 Do
      Begin

        If ( OCF mod 2 ) = 1 Then
          Begin
            If ( I <= CatImp )
              Then
                Begin
                  If ( I = CatImp )
                   Then
                    Begin { Import }
                      Str ( NGrImpBeg, S ) ;
                      Write ( NameCat [ I ], '(', S , ') ' ) ;
                    End
                   Else
                  Write (  NameCat [ I ], ' ' ) ;
                End
              Else
                Write (  'Satl' );
          End;

        OCF := OCF div 2;

      End ;


    TextAttr :=  TileParamText;



                   { ùØÆÂ® }
                   { ﬂﬂﬂﬂﬂ }

    Inc( y );

    WriteStr( 1,Y,'Equinoxes',TileNormalText );

    GoToXY( X,Y );

    TextAttr :=  TileNameParamText;
    If ( Space_Earth_Flag = 1 )
      Then  { è´†≠•‚† }
          Write ( ' Eq.Parameters : ' )
      Else  { ëØ„‚≠®™ }
          Write ( ' Eq.Sat.Elems. : ' );
    TextAttr :=  TileParamText;


    Write ( EpohaElementov.Year : 4,'  ',
            MonthName [ EpohaElementov.Month ],'  ',
            EpohaElementov.Day );

    TextAttr :=  TileNameParamText;
    If ( Space_Earth_Flag = 1 )
      Then  { è´†≠•‚† }
          Write ( '    Eq.Out : ' )
      Else  { ëØ„‚≠®™ }
          Write ( '   Eq.StarInp,Out : ' );
    TextAttr :=  TileParamText;

    If ( EpModel = 2 )
      Then
        Write ( ' On Date ' )
      Else
        Write ( EpInform.Year : 4,'  ',
               MonthName [ EpInform.Month ],'  ',
               EpInform.Day );




      { H†Á†´Ï≠Î© ¨Æ¨•≠‚ }
      { ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ }

    Inc( Y );

    WriteStr( 1, Y, 'Starting date', TileNormalText ) ;



        GoToXY( X,Y );

        TextAttr :=  TileNameParamText;
        Write ( ' Date :' );
        TextAttr :=  TileParamText;

        If ( BeginDate.Year = 0 )
          Then
            Begin  { BeginDate.Year = 0 }
{
              Write ( ' From Timer' ) ;
}
              Write ( ' SysClock' ) ;

              If ( BeginDate.Minute >= 100 )
                Then
                  Begin

                    TextAttr :=  TileNameParamText;
                    Write ( ' TCivil-UT: ' );
                    TextAttr :=  TileParamText;

                    Write ( BeginDate.Minute Mod 100  : 2 ,#244' ' ) ;

                    If ( BeginDate.Hour >= 100 )  Then
                      Begin

                        TextAttr :=  TileNameParamText;
                        Write ( 'TCivil: ' );
                        TextAttr :=  TileParamText;

                        Write ( BeginDate.Hour Mod 100  : 2 ,#244' ' ) ;

                      End ;

                  End
                Else
                  Begin

                    If ( BeginDate.Hour >= 100 )  Then
                      Begin

                        TextAttr :=  TileNameParamText;
                        Write ( ' UT: ' );
                        TextAttr :=  TileParamText;

                        Write ( BeginDate.Hour Mod 100  : 2 ,#244' ' ) ;

                      End ;


                  End ;

            End    { BeginDate.Year = 0 }
          Else
            Begin  { BeginDate.Year <> 0 }

              Write ( BeginDate.Year : 5 ,' ',
                      MonthName[ BeginDate.Month ] , ' ' ,
                      BeginDate.Day : 2  ) ;

              If ( BeginDate.Minute < 100 )
                Then
                  Begin

                    TextAttr :=  TileNameParamText;
                    Write ( ' UT: ' );
                    TextAttr :=  TileParamText;

                    Str ( BeginDate.Sec : 4 : 1 , S ) ;
                    S [ 3 ] := #246 ;
                    Write ( BeginDate.Hour Mod 100  : 2 ,#244' ' ,
                            BeginDate.Minute        : 2, #245' ' ,
                            S                       : 4           );
                  End
                Else
                  Begin

                    TextAttr :=  TileNameParamText;
                    Write ( ' TCivil-UT: ' );
                    TextAttr :=  TileParamText;

                    Write ( BeginDate.Minute Mod 100  : 2 ,#244' ' ) ;

                    If ( BeginDate.Minute >= 100 )
                      Then
                        Begin

                          TextAttr :=  TileNameParamText;
                          Write ( 'TCivil: ' );
                          TextAttr :=  TileParamText;

                          Write ( BeginDate.Hour Mod 100  : 2 ,#244' ' ) ;

                        End
                      Else
                        Begin

                          TextAttr :=  TileNameParamText;
                          Write ( 'UT: ' );
                          TextAttr :=  TileParamText;

                          Write ( BeginDate.Hour Mod 100  : 2 ,#244' ' ) ;

                        End ;


                  End ;

            End ; { BeginDate.Year <> 0 }


        TextAttr :=  TileNameParamText;
        Write ( ' Step: ' );
        TextAttr :=  TileParamText;


        If ( BeginDate.Step <> 0 )
          Then
            Begin

              If ( Abs ( BeginDate.Step ) < 86400.0 )  Then
                Begin
                  Str ( BeginDate.Step : 12 : 3 , S ) ;
                  S [ 9 ] := #246 ;
                  While ( S [ 1 ] = ' ' )  Do
                    Delete ( S, 1, 1 ) ;
                  Write ( S ) ;
                End ;

              If (     ( Abs ( BeginDate.Step ) >=    86400 )
                   And ( Abs ( BeginDate.Step ) <  31557600 )  )  Then
                Begin
                  Str ( BeginDate.Step / 86400.0 : 11 : 1 , S ) ;
                  S := S + ' d' ;
                  While ( S [ 1 ] = ' ' )  Do
                    Delete ( S, 1, 1 ) ;
                  Write ( S ) ;
                End ;

              If ( Abs ( BeginDate.Step ) >= 31557600.0 )  Then
                Begin
                  Str ( BeginDate.Step / 86400 / 365.25 : 11 : 1 , S ) ;
                  S := S + ' y' ;
                  While ( S [ 1 ] = ' ' )  Do
                    Delete ( S, 1, 1 ) ;
                  Write ( S ) ;
                End ;

            End
          Else
            Begin
              Write ( 'SysClock' ) ;
            End ;




        { ê•¶®¨Î }
        { ﬂﬂﬂﬂﬂﬂ }


    Inc( Y );

    WriteStr( 1,y,'Modes',TileNormalText );

    TextAttr :=  TileParamText;

    GoToXY( X,Y );

    TextAttr :=  TileNameParamText;
    Write ( ' ' );

    If Regims.NPolFix = 1 Then
     Write ( 'NPolY ' );

    If ( Regims.OutFOV And 1 ) = 1 Then
     Write ( 'OutFOV ' );

    If Regims.Object_Tracks = 1 Then
     Write ( 'Tracks ' );

    If ( Regims.OutFOV Div 2 ) Mod 2 = 1 Then
     Write ( 'ColA20 ' );

    If Regims.DetCdc = 1 Then
     Write ( 'GalCrd ' );

    If Regims.ImportStar = 1 Then
     Write ( 'ImpObj ' );

    If Regims.DetImp = 1 Then
     Write ( 'DetImp ' );

    If (     ( Regims.DetImp = 1    )
         And ( RCatDet.RoImpDet < 0 )  )
      Then
        Begin
          Write ( 'StopAll ' );
        End
      Else
        Begin
          If Regims.StopNoDet = 1 Then
             Write ( 'StopNoDet ' );
        End ;

    If Regims.PzsInFOV = 1 Then
     Write ( 'V.Diag ' );
{
     Write ( 'CCDInFOV ' );
}
    If Regims.Corr_Fot_Sys = 1 Then
     Write ( 'PhRd' );


{ ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }

  Window( Hi( OldWindMin ), Lo( OldWindMin ),
          Hi( OldWindMax ), Lo( OldWindMax ));

End;



End.