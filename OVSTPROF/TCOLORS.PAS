Unit TColors;

Interface

Uses Crt;

Const



  DeskTopFillChar         : Char   = '°';

  DeskTopNormalText         : Byte  =   Blue       +  LightGray    *  16 ;

  DeskTopLineText           : Byte  =   Black      +  LightGray    *  16 ;
  DeskTopOptText            : Byte  =   White      +  Green        *  16 ;
  DeskTopStatLineText       : Byte  =   Black      +  LightGray    *  16 ;
  DeskTopStatLineAcText     : Byte  =   Red        +  LightGray    *  16 ;

   { –¢¥â  í«¥¬¥­â®¢ ®ª®­ ¤¨ «®£ . }
   { ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ }

    InputLineNormalText     : Byte  =  White       +  Blue  * 16       ;
    InputLineOptionText     : Byte  =  LightGreen  +  Blue  * 16       ;
    InputLineSelectText     : Byte  =  White       +  Green * 16       ;

    RadioButtonNormalText   : Byte  =  Black       +  Cyan * 16        ;
    RadioButtonAccentText   : Byte  =  White       +  Cyan * 16        ;

    RadioButtonTitleText    : Byte  =  Black       +  LightGray * 16   ;
    RadioButtonTitleAccText : Byte  =  White       +  LightGray * 16   ;
    RadioButtonOneSymbol    : Byte  =  Yellow      +  LightGray * 16   ;

    CheckBoxesNormalText    : Byte  =  Black       +  Cyan * 16        ;
    CheckBoxesAccentText    : Byte  =  White       +  Cyan * 16        ;

    CheckBoxesTitleText     : Byte  =  Black       +  LightGray * 16   ;
    CheckBoxesTitleAccText  : Byte  =  White       +  LightGray * 16   ;
    CheckBoxesOneSymbol     : Byte  =  Yellow      +  LightGray * 16   ;

    TButtonNormalText       : Byte  =  Black       +  Green * 16       ;
    TButtonRunText          : Byte  =  White       +  Green * 16       ;
    TButtonAccentText       : Byte  =  Yellow      +  Green * 16       ;
    TButtonDefaultText      : Byte  =  LightCyan   +  Green * 16       ;
    TButtonTText            : Byte  =  Black       +  LightGray * 16   ;

    TLableNormalText        : Byte  =  Black       +  LightGray * 16   ;
    TLableNormalAcText      : Byte  =  Yellow      +  LightGray * 16   ;
    TLableAccentText        : Byte  =  White       +  LightGray * 16   ;
    TLableAccentAcText      : Byte  =  Yellow      +  LightGray * 16   ;

    TDialogNormalText       : Byte  =  Black       +  LightGray * 16   ;
    TDialogFrameAttr        : Byte  =  White       +  LightGray * 16   ;
    TDialogAccentAttr       : Byte  =  LightGreen  +  LightGray * 16   ;

    TDialogStatLineText     : Byte  =  Black       +  LightGray * 16   ;
    TDialogStatLineAcText   : Byte  =  Red         +  LightGray * 16   ;
    TDialogLineText         : Byte  =  Black       +  LightGray * 16   ;
    TDialogOptText          : Byte  =  White       +  Green     * 16   ;

    TStaticTextNormalAttr   : Byte  =  Black       +  LightGray * 16   ;

 { ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± }

   MenuShadowColor          : Byte  = LightGray    + Black      * 16;

   MenuNormalText           : Byte  = Black        + LightGray  * 16 ;
   MenuNormalAcText         : Byte  = Red          + LightGray  * 16 ;
   MenuframeColor           : Byte  = Black        + LightGray  * 16;
   MenuAccentText           : Byte  = Black        + Green      * 16 ;
   MenuAccentAcText         : Byte  = Red          + Green      * 16 ;
   MenuDisabledText         : Byte  = LightGray    + LightGray  * 16 ;
   MenuDisabledAcText       : Byte  = LightGray    + LightGray  * 16 ;
   MenuDisabledAccentText   : Byte  = LightGray    + Green      * 16 ;
   MenuDisabledAccentAcText : Byte  = LightGray    + Green      * 16 ;

   StatusLineNormalText     : Byte =  Black        + LightGray  * 16;
   StatusLineNormalAcText   : Byte =  Red          + LightGray  * 16;


Implementation
end.