
{$O+,F+}

Unit PCcdFld ;   { Поле ипоpтных CCD }
                 { ───────────────── }


  InterFace


    Procedure CcdFld ;


  Implementation

    Uses  PVAR, V_CATAL, PMem, PPreNew, PProFld, Check ;


    Procedure CcdFld ;
   {*****************}


    Label EndMemory ,
          ExtraFld   ;

    Var

       NCompRed                                  : Integer ;

       JStar,
       JNBeg, JNEnd                              : LongInt ;

       Index,
       Mv,
       XSt, YSt,
       RaNp1, DeclNp1, SPozNp1, CPozNp1, Cs, Ss,
       MR, MD, PMX, PMY                          : Double  ;

     Begin  { PRO STARFLD }


        NPolFix         := True  ;
        MarkingRepStars := False ;

        DImp    := 0.0 ;
        EImp    := 0.0 ;
        DistImp := 0.0 ;

        ErrDistImp := 0.0 ;


       If ( Not Exist ( ConstCcdFileName ) )
         Then
           Begin

             ReductionExist := False ;

             AxImp   := C10 ;
             BxImp   := 0.0 ;
             CxImp   := 0.0 ;

             AyImp   := 0.0 ;
             ByImp   := C10 ;
             CyImp   := 0.0 ;

             DImp    := 0.0 ;
             EImp    := 0.0 ;
             DistImp := 0.0 ;

             ErrDImp    := 0.0 ;
             ErrEImp    := 0.0 ;
             ErrDistImp := 0.0 ;

           End
         Else
           Begin

             ReductionExist := True ;

             Assign ( ConstCcdFile, ConstCcdFileName ) ;
             ReSet  ( ConstCcdFile                   ) ;

             ReadLn ( ConstCcdFile, NCompRed ) ;

             ReadLn ( ConstCcdFile, AxImp   ) ;
             ReadLn ( ConstCcdFile, BxImp   ) ;
             ReadLn ( ConstCcdFile, CxImp   ) ;

             ReadLn ( ConstCcdFile, AyImp   ) ;
             ReadLn ( ConstCcdFile, ByImp   ) ;
             ReadLn ( ConstCcdFile, CyImp   ) ;

             If ( NCompRed = 9 )  Then
               Begin
                 ReadLn ( ConstCcdFile, DImp    ) ;
                 ReadLn ( ConstCcdFile, EImp    ) ;
                 ReadLn ( ConstCcdFile, DistImp ) ;
               End ;

             Close  ( ConstCcdFile ) ;

           End ;



          { Позиционный угол Севеpного Полюса }
          { ───────────────────────────────── }

        Povorot ( JdEp , SPozNp1 , CPozNp1 ) ;

        IndCat [ CatImp ].SPozNp1 := SPozNp1 ;
        IndCat [ CatImp ].CPozNp1 := CPozNp1 ;


        RaOptFld   := RaOpt   ;
        DeclOptFld := DeclOpt ;

        PRENew ( JDateFld, JdEp, RaOptFld, DeclOptFld );
       {===============================================}

        SDeclOptFld := Sin ( DeclOptFld ) ;
        CDeclOptFld := COS ( DeclOptFld ) ;

        SRaOptFld   := Sin ( RaOptFld   ) ;
        CRaOptFld   := COS ( RaOptFld   ) ;

        IndCat [ CatImp ].SRaOpt    := SRaOptFld   ;
        IndCat [ CatImp ].CRaOpt    := CRaOptFld   ;
        IndCat [ CatImp ].SDeclOpt  := SDeclOptFld ;
        IndCat [ CatImp ].CDeclOpt  := CDeclOptFld ;


		{  ПРОСМОТР  ЗВЕЗД  }
                {  ================ }
        (*
        CcdRecord.X    := Row * ARow + Col * BCol ; { Hа Hебе в mm. Идю к-ты }
        CcdRecord.Y    := Row * CRow + Col * DCol ; { Hа Hебе в mm. Идю к-ты }
        CcdRecord.Diam := Diam                    ;
        *)
        Reset ( ImportCcdFile ) ;
        JStar := 0 ;

        While ( Not Eof ( ImportCcdFile )  )  Do
          Begin  { JSTAR }
                 { ----- }

               Read ( ImportCcdFile , CCdRecord ) ;
               Inc ( JStar ) ;


	       XSt := - CcdRecord.X ;
	       YSt :=   CcdRecord.Y ;
               Mv  :=   CcdRecord.Diam ;


                { Повоpот Экв Сист JdCat -> Экв Сист JdFld }
                { ──────────────────────────────────────── }

               Index :=   XSt ;
               XSt   :=   XSt  * CPozNp1  -  YSt * SPozNp1 ;
               YSt   :=  Index * SPozNp1  +  YSt * CPozNp1 ;

                  { Ось 'Y' в полюсе JdFld }



               If ( Not ( NPolFix ) )   Then
                   Begin { Стабилизация оси Y в зенит }
                         { ────────────────────────── }
                     Index := XSt ;

                     XSt :=   XSt  * CPozNp  -  YSt * SPozNp ;
                     YSt :=  Index * SPozNp  +  YSt * CPozNp ;

                   End ;

               If ( StepDiamCcd < 0.0 )  Then
                 Begin
                   If ( MV < Abs ( StepDiamCcd )  ) Then
                     XSt := 2.0 * XMAX ;
                 End ;

               If (    ( ABS ( XSt ) > XMAX )
                    Or ( ABS ( YSt ) > YMAX )  )  Then
                   GoTo  ExtraFld ;


               If  ( NumberOfStars Mod ObjectBlockSize = 0 )  Then
                         CBlock :=  NumberOfStars Div ObjectBlockSize ;

               If (    ( BlockAllocFlag [ CBlock ] )
                    Or (  AllocBlock               )  )  Then
                       Begin

                         With ObjectPtr [ NumberOfStars Div ObjectBlockSize]^
                                        [ NumberOfStars Mod ObjectBlockSize] Do
                            Begin  { Очередная звезда }

			      X	   := XSt ;
			      Y	   := YSt ;

                              Sp   := 50  ;
                              Date :=  0  ;

                              If ( CcdDiamExist )
                                Then
                                  Begin
                                    If ( MV / Abs ( StepDiamCcd ) > 250 )
                                      Then  M := 255
                                      Else  M := Round ( MV / Abs ( StepDiamCcd ) ) ;
                                  End
                                Else
                                  Begin
                                            M := 0 ;
                                  End ;

			      NRecC := JStar ;

                            End  ;

                          If ( IndCat [ CatImp ].NBEG = -1 )  Then
                               IndCat [ CatImp ].NBEG := NumberOfStars ;

                          Inc ( NumberOfStars ) ;

                       End    { Блок выделен }
                              { ------------ }
                      Else  GoTo EndMemory ;  { Исчеpпана память }
                                              { ---------------- }

 ExtraFld  : ;

          End  ; { JSTAR }


 EndMemory : ;


     ImportReduction := False ;

     If ( IndCat [ CatImp ].NBeg <> -1 )  Then
       Begin
          IndCat [ CatImp ].NEnd      := NumberOfStars - 1 ;
          IndCat [ CatImp ].TypeCoord := IdCoord           ;
       End ;

    End  ;  { PRO ImpFld }


End .

