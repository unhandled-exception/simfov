
{$O+,F+}

Unit SGP_Time;
{           Author:  Dr TS Kelso }
{ Original Version:  1992 Jun 02 }
{ Current Revision:  1992 Sep 28 }
{          Version:  1.50 }
{        Copyright:  1992, All Rights Reserved }
{$N+}

INTERFACE
  {
  Uses SGP_Math;
  }
type
  clock_time = string[12];
  date       = string[11];

const
  twopi    = 6.283185307179586 ;
  xmnpda   =  1440.0;        {Minutes per day}
  secday   = 86400.0;        {Seconds per day}
  omega_E  = 1.00273790934;  {Earth rotations per sidereal day (non-constant)}
  omega_ER = omega_E*twopi;  {Earth rotation, radians per sidereal day}

var
  ds50 : double;
{
Function Julian_Date_of_Year(year : double) : double;
Function Julian_Date_of_Epoch(epoch : double) : double;
Function Epoch_Time(jd : double) : double;
Function DOY(yr,mo,dy : word) : word;
Function Fraction_of_Day(hr,mi,se,hu : word) : double;
Function Calendar_Date(jd : double) : date;
Function Time_of_Day(jd : double;
                   full : boolean;
                    res : byte) : clock_time;
}
Function ThetaG(epoch  : double) : double;
Function ThetaG_JD(jd  : double) : double;
Function Delta_ET(year : double) : double;

IMPLEMENTATION

const
  half_sec = 0.5/secday;

Function Julian_Date_of_Year(year : double) : double;
  { Astronomical Formulae for Calculators, Jean Meeus, pages 23-25 }
  { Calculate Julian Date of 0.0 Jan year }
  var
    A,B   : longint;
  begin
  year := year - 1;
  A := Trunc(year/100);
  B := 2 - A + Trunc(A/4);
  Julian_Date_of_Year := Trunc(365.25 * year)
                       + Trunc(30.6001 * 14)
                       + 1720994.5 + B;
  end; {Function Julian_Date_of_Year}

Function Julian_Date_of_Epoch(epoch : double) : double;
  var
    year,day : double;
  begin
  year := 1900 + Int(epoch*1E-3);
  day  := Frac(epoch*1E-3)*1E3;
  Julian_Date_of_Epoch := Julian_Date_of_Year(year) + day;
  end; {Function Julian_Date_of_Epoch}
(*
Function Epoch_Time(jd : double) : double;
  var
    year,mo,dy    : word;
    yr,time,epoch : double;
    edate         : date;
  begin
  edate := Calendar_Date(jd);
  year := Integer_Value(edate,1,4);
  yr := Integer_Value(edate,3,2);
  mo := Pos(Copy(edate,6,3),'  JanFebMarAprMayJunJulAugSepOctNovDec') div 3;
  dy := Integer_Value(edate,10,2);
  time := Frac(jd + 0.5);
  Epoch_Time := yr*1000 + DOY(year,mo,dy) + time;
  end; {Function Epoch_Time}
*)
(*
Function DOY(yr,mo,dy : word) : word;
  const
    days : array [1..12] of word = (31,28,31,30,31,30,31,31,30,31,30,31);
  var
    i,day : word;
  begin
  day := 0;
  for i := 1 to mo-1 do
    day := day + days[i];
  day := day + dy;
  if ((yr mod 4) = 0) and
     (((yr mod 100) <> 0) or ((yr mod 400) = 0)) and
     (mo > 2) then
    day := day + 1;
  DOY := day;
  end; {Function DOY}

Function Fraction_of_Day(hr,mi,se,hu : word) : double;
  begin
  Fraction_of_Day := (hr + (mi + (se + hu/100)/60)/60)/24;
  end; {Function Fraction_of_Day}

Function Calendar_Date(jd : double) : date;
  { Astronomical Formulae for Calculators, Jean Meeus, pages 26-27 }
  var
    Z,month           : longint;
    A,B,C,D,E,F,alpha : double;
    day,year          : double;
    syear             : string[4];
    cdate             : date;
  begin
  Z := Trunc(jd + 0.5);
  F := Frac(jd + 0.5);
  if Z < 2299161 then
    A := Z
  else
    begin
    alpha := Int((Z - 1867216.25)/36524.25);
    A := Z + 1 + alpha - Int(alpha/4);
    end; {else}
  B := A + 1524;
  C := Int((B - 122.1)/365.25);
  D := Int(365.25 * C);
  E := Int((B - D)/30.6001);
  day := B - D - Int(30.6001 * E) + F;
  if E < 13.5 then
    month := Round(E - 1)
  else
    month := Round(E - 13);
  if month > 2.5 then
    year := C - 4716
  else
    year := C - 4715;
  Str(year:4:0,syear);
  cdate := syear + ' '
         + Copy('  JanFebMarAprMayJunJulAugSepOctNovDec',3*month,3) + ' '
         + TwoDigit(Trunc(day));
  Calendar_Date := cdate;
  end; {Function Calendar_Date}

Function Time_of_Day(jd : double;
                   full : boolean;
                    res : byte) : clock_time;
  var
    hr,mn   : longint;
    time,sc : double;
    ctime   : string;
  begin
  res := IMin(IMax(0,res),3);
  time := 24 * Frac(jd - 0.5 + half_sec);
  hr   := Trunc(time);
  time := 60 * Frac(time);
  mn   := Trunc(time);
  sc   := 60 * Frac(time) - 0.5;
  time := 1000000 + 10000 * hr + 100 * mn + sc;
  Str(time:(7+res):res,ctime);
  Delete(ctime,1,1);
  if full then
    begin
    Insert(':',ctime,5);
    Insert(':',ctime,3);
    end; {if}
  Time_of_Day := ctime;
  end; {Function Time_of_Day}
*)
Function Modulus(arg1,arg2 : double) : double;
  var
    modu : double;
  begin
  modu := arg1 - Trunc(arg1/arg2) * arg2;
  if modu >= 0 then
    Modulus := modu
  else
    Modulus := modu + arg2;
  end; {Function Modulus}

Function ThetaG(epoch : double) : double;
{ Reference:  The 1992 Astronomical Almanac, page B6. }
  var
    year,day,UT,jd,TU,GMST : double;
  begin
  {
  year := 1900 + Int(epoch*1E-3);
  day  := Frac(epoch*1E-3)*1E3;
  UT   := Frac(day);
  day  := Int(day);
  jd   := Julian_Date_of_Year(year) + day;
  }
  UT   := Frac(epoch) ;
  If ( UT < 0.5 )
    Then
      Begin
        UT := UT + 0.5 ;
        TU := Int (epoch) - 0.5 ;
      End
    Else
      Begin
        UT := UT - 0.5 ;
        TU := Int (epoch) + 0.5 ;
      End ;
  {
  TU   := (epoch - 2451545.0)/36525;
  }
  TU   := (TU - 2451545.0)/36525;
  GMST := 24110.54841 + TU * (8640184.812866 + TU * (0.093104 - TU * 6.2E-6));
  GMST := Modulus(GMST + secday*omega_E*UT,secday);
  ThetaG := twopi * GMST/secday;
  ds50 := epoch - 2433281.5;
{ ThetaG := Modulus(6.3003880987*ds50 + 1.72944494,twopi); }
  end; {Function ThetaG}

Function ThetaG_JD(jd : double) : double;
{ Reference:  The 1992 Astronomical Almanac, page B6. }
  var
    UT,TU,GMST : double;
  begin
  UT   := Frac(jd + 0.5);
  jd   := jd - UT;
  TU   := (jd - 2451545.0)/36525;
  GMST := 24110.54841 + TU * (8640184.812866 + TU * (0.093104 - TU * 6.2E-6));
  GMST := Modulus(GMST + secday*omega_E*UT,secday);
  ThetaG_JD := twopi * GMST/secday;
  end; {Function ThetaG_JD}

Function Delta_ET(year : double) : double;
  { Values determined using data from 1950-1991 in the 1990 Astronomical
    Almanac.  See DELTA_ET.WQ1 for details. }
  begin
  Delta_ET := 26.465 + 0.747622*(year - 1950)
             + 1.886913*Sin(twopi*(year - 1975)/33);
  end; {Function Delta_ET}

end.
