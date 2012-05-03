
                         PROGRAM  EXSOURC ;
                        {*****************}

{    ˆ‡‚‹…—…ˆ… ‡‚…‡„ ˆ €‘‘Ž–ˆ€’ŽŽ‚ „‹Ÿ ˆ‘’Ž—ˆŠŽ‚   }
{    **********************************************   }



USES
     CRT;



CONST


  InpStarFileName  = 'G:\CATALOG\IRAS\IRAS.SRT'  ;
   InpSrcFileName  = 'G:\CATALOG\IRAS\IRAS.SRC'  ;
   InpAssFileName  = 'G:\CATALOG\IRAS\IRAS.ASO'  ;
    InpSpFileName  = 'F:\IRAS\IRAS.SP'           ;

  OutStarFileName  = 'F:\IRAS.SRT'  ;
   OutSrcFileName  = 'F:\IRAS.SRC'  ;
   OutAssFileName  = 'F:\IRAS.ASO'  ;
    OutSpFileName  = 'F:\IRAS.SP'   ;


Type



    NameIrasType  = Record

                      NUMRA   : Integer ;
                      SNUMDEC : Char    ;
                      NUMDEC  : Integer ;
                      MULT    : Char    ;

                    END ;



  SrcType  = Record

               NAME_RA      : Integer  ;
               NAME_SDC     : Char     ;
               NAME_DC      : Integer  ;
               NAME_MULT    : Char     ;
               SNUM         : Longint  ;
               RA,
               DC           : Single   ;
               MAJOR,
               MINOR,
               POSANG       : Integer  ;
               FLUX1,
               FLUX2        : Single   ;
               FQUAL1,
               FQUAL2       : Shortint ;
	       LRSCHAR1,
               LRSCHAR2     : Char     ;
               RELUN1,
               RELUN2       : Integer  ;
               PVAR         : Shortint ;
               HSDFLAG      : Char     ;
               IRSUR        : Longint  ;
               NID          : Shortint ;

             END ;



   SourceType = Array [ 1 .. 15 ] Of Char ;
        TType = Array [ 1 ..  5 ] Of Char ;


   AssType = Record

               CATNO        : Shortint   ;
               RADIUS,
               POS          : Integer    ;
               F1,
               F2,
               F3           : Integer    ;
               SOURCE       : SourceType ;
               STYPE        :      TType ;


             End ;



          SpType  = Array [ 1 .. 100 ]  Of Integer ;

    BaseLineType  = Record

                      BASELINE1 : Integer ;
                      BASELINE2 : Integer ;
                      BASELINE3 : Integer ;
                      BASELINE4 : Integer ;

                    End ;



 InputSpType      = Record

                      NAME     : NameIrasType   ;
                      BASELINE : BaseLineType   ;
                      SRATIO   : Single         ;
                      SCALE    : Single         ;
                      SP1      : SpType         ;
                      SP2      : SpType         ;

                    End ;



         StarType = Record

		      SDRA    : Word    ;  { SIN DRA   * CONSTDSIN         }
		      SDDEC   : Word    ;  { SIN DDEC  * CONSTDSIN         }
                      MURA    : Integer ;  { TRUNC (NUMIRAS DIV 10 )       }
                      MUDEC   : Integer ;  { NUMIRAS MOD 10 + (M1+9)*1000  }
                      MV      : Byte    ;  { ( MV+5 )  *      10           }
                      SP      : Byte    ;  { SP        *      10           }
                      CAT     : Byte    ;  { SIGNS                         }
                      NUMSTAR : LongInt ;  { IRSUR                         }
                      SAO     : Longint ;  { SAO * 8000 + (M2+9) * 100/2   }
                      ADRSP   : Integer ;  { N RECORD IN SPECTR. FILE      }

		    end;




 Var

   NID                              : Shortint ;

   NRECSTAR, NRECSRC, NRECASS,
   NSRC, NASS, I                    : LONGINT ;


   StarRecord :    StarType ;
    SrcRecord :     SrcType ;
    AssRecord :     AssType ;
     SpRecord : InputSpType ;


     InpStarFile : File of StarType  ;
      InpSrcFile : File of  SrcType  ;
      InpAssFile : File of  AssType  ;
       InpSpFile : File of  InputSpType      ;


     OutStarFile : File of StarType  ;
      OutSrcFile : File of  SrcType  ;
      OutAssFile : File of  AssType  ;
       OutSpFile : File of  InputSpType      ;



 Begin



  ASSIGN ( InpStarFile , InpStarFileName  ) ;
  RESET  ( InpStarFile  ) ;

  ASSIGN (  InpSrcFile ,  InpSrcFileName  ) ;
  RESET  (  InpSrcFile  ) ;

  ASSIGN (  InpAssFile ,  InpAssFileName  ) ;
  RESET  (  InpAssFile  ) ;

  ASSIGN (  InpSpFile  ,  InpSpFileName   ) ;
  RESET  (  InpSpFile   ) ;




  ASSIGN ( OutStarFile , OutStarFileName  ) ;
  REWRITE( OutStarFile  ) ;

  ASSIGN (  OutSrcFile ,  OutSrcFileName  ) ;
  REWRITE(  OutSrcFile  ) ;

  ASSIGN (  OutAssFile ,  OutAssFileName  ) ;
  REWRITE(  OutAssFile  ) ;

  ASSIGN (  OutSpFile  ,   OutSpFileName  ) ;
  REWRITE(  OutSpFile   ) ;





  NRECSTAR := 0 ;
  NRECSRC  := 0 ;
  NRECASS  := 0 ;
  NRECSP   := 0 ;




  WHILE ( NOT   EOF ( InpStarFile )  )  DO
    BEGIN


      READ ( InpStarFile , StarRecord ) ;  { ‡‚…‡„€ ˆ‡ ‘Ž’. ”€‰‹€ }
     {--------------------------------}    { ..................... }


      IF ( NRECSTAR MOD 100 ) = 0  THEN  WRITELN ( NRECSTAR : 7 ) ;



      NSRC := LongInt ( StarRecord.MURA  )  *  10  +   { ŽŒ… ‚ SRC }
              LongInt ( StarRecord.MUDEC ) mod 10   ;  { ........... }


      SEEK  ( InpSrcFile ,  NSRC  ) ;      { Ž„‚Ž„ ‡€ˆ‘ˆ ‚ SRC }
     {----------------------------}        { ................... }


      StarRecord.NUMSTAR := NRECSTAR ;     { Ž‚›‰ €„…‘ ˆ‘’Ž—ˆŠ€ }
      NRECSTAR := NRECSTAR + 1 ;           { ..................... }

      WRITE ( OutStarFile , StarRecord ) ; { ‡‚…‡„€ ˆ‡ ‘Ž’. ”€‰‹€ ‡€ˆ‘€€ }
     {---------------------------------}   { .............................. }


      READ  ( InpSrcFile , SrcRecord ) ;   { —’…ˆ… ˆ‘’Ž—ˆŠ€ }
     {-------------------------------}     { ................ }


      NID  := SrcRecord.NID ;              { —ˆ‘‹Ž €‘‘Ž–ˆ€’ŽŽ‚ ˆ €„…‘ }
      NASS := SrcRecord.IRSUR ;            { .......................... }



      SrcRecord.IRSUR := NRECASS ;         { Ž‚›‰ €„…‘ €—€‹€ €‘‘Ž–ˆ€’ŽŽ‚ }
      NRECASS := NRECASS + NID ;           { ............................... }


      WRITE ( OutSrcFile , SrcRecord ) ;   { ‡€ˆ‘€ ˆ‘’Ž—ˆŠ }
     {-------------------------------}     { ................ }



      IF ( NID > 0 )  THEN
        BEGIN                              { …‘’œ €‘‘Ž–ˆ€’Ž› }
                                           { ................ }

          SEEK ( InpAssFile , NASS  ) ;    { Ž„‚Ž„ €‘‘Ž–ˆ€’ŽŽ‚ }
         {--------------------------}      { ................... }


          FOR I := 1  TO  NID  DO
            BEGIN

              READ  ( InpAssFile , AssRecord ) ;  { —’…ˆ… €‘‘Ž–ˆ€’Ž€ }
             {-------------------------------}    { .................. }

              WRITE ( OutAssFile , AssRecord ) ;  { ‡€ˆ‘œ €‘‘Ž–ˆ€’Ž€ }
             {-------------------------------}    { .................. }

            END ;

        END ; { NID > 0 }
              { ------- }

    END ;  { NOT EOF }
           { ------- }


  CLOSE  ( InpStarFile  ) ;
  CLOSE  (  InpSrcFile  ) ;
  CLOSE  (  InpAssFile  ) ;
  CLOSE  (   InpSpFile  ) ;

  CLOSE  ( OutStarFile  ) ;
  CLOSE  (  OutSrcFile  ) ;
  CLOSE  (  OutAssFile  ) ;
  CLOSE  (   OutSpFile  ) ;


 End.
