{$F+,O+}

Unit SSFont;
Interface

procedure LoadFont;

Implementation

Uses TDrivers, TFont, Font814, Font816;

procedure LoadFont;

Var
  GrDriv, GrMode : Integer;

begin

 { DetectGraph( GrDriv, GrMode );
  }

  If ( VideoType = EGA ) Then
    begin

{      LoadFontToMemory( VGAFont, 128, 127, Font8_16 );
      LoadFontToMemory( VGAFont, 224, 32, Font8_16 );
}
      LoadFontToMemory( VGAFont, 240, 16, Font8_16 );

    end;

  If ( VideoType = VGA ) Then
    begin

{      LoadFontToMemory( VGAFont, 128, 127, Font8_16 );
      LoadFontToMemory( VGAFont, 224, 32, Font8_16 );
 }
      LoadFontToMemory( VGAFont, 240, 16, Font8_16 );

    end;


end;

end.