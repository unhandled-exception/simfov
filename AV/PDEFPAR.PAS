
{$O+,F+}

 UNIT  PDEFPAR ;


  INTERFACE

    PROCEDURE  DEFPARAM ;


  IMPLEMENTATION

    USES

         PVAR, V_CATAL ;




  PROCEDURE  DefParam ;

        { Паpаметpы пpи незаданном номеpе ваpианта }
        { ======================================== }

 BEGIN


      NVar         :=      1   ;

      NPL0         :=      3   ;

      DATEEL.MONTH :=      3   ;
      DATEEL.DAY   :=     21   ;
      DATEEL.YEAR  :=   1992   ;

      TIMEEL.HOUR  :=      0   ;
      TIMEEL.MIN   :=      0   ;
      TIMEEL.SEC   :=      0   ;

      JDOut        :=  JDate   ;


      MVMAX        :=     5.0  ;
{
      DMvDet       :=     5.0  ;
      RDetImp      :=     5.0  ;
}
      FLDX         :=    22    ;
      FLDY         :=    22    ;

      RRX          :=    18    ;
      RRY          :=    18    ;
{
      RSUN0        :=    34    ;
      RMON0        :=     0    ;
      AOPT0        :=   270    ;
      HOPT0        :=   180    ;
}

      NGrImportBeg :=     0    ;
      {
      PERIOD_X_MIN :=     0    ;
      PERIOD_Y_MIN :=     0    ;
      PIXEL_X_MIN  :=     0    ;
      PIXEL_Y_MIN  :=     0    ;
      }
{
      N_PIXEL_X    :=     0    ;
      N_PIXEL_Y    :=     0    ;
}
 END ;  { DEFPAR }

END.



