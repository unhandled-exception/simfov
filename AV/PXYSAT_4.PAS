{
Unit PXYSAT_4;
}
{           Author:  Dr TS Kelso }
{ Original Version:  1991 Oct 30}
{ Current Revision:  1992 Sep 03}
{          Version:  1.50 }
{        Copyright:  1991-1992, All Rights Reserved }
{$N+}

INTERFACE
  {
  Uses Support,
       SGP_Init,
       SGP_Math,SGP_Time;
  }

  Uses PSGP4 ;

Procedure  XYSATGP ( T, Epoch                               : Double  ;  { JD }
                        NPl0                                : Integer ;
                        eo, xincl, xnodeo, omegao,
                        xmo, xno, xndt2o, xndd6o, bstar                : Double  ;
                        Var X, Y, Z, VX, VY, VZ             : Double     ) ;

IMPLEMENTATION

Procedure SGP(time : double;
       var pos,vel : vector);
  var
    tsince : double;
  begin

Procedure  XYSATGP ( T, Epoch                               : Double  ;  { JD }
                        NPl0                                : Integer ;
                        eo, xincl, xnodeo, omegao,
                        xmo, xno, xndt2o, xndd6o, bstar                : Double  ;
                        Var X, Y, Z, VX, VY, VZ             : Double     ) ;

 Begin

  xno      := xno*twopi/xmnpda;
  xndt2o   := xndt2o*twopi/Sqr(xmnpda);
  xndd6o   := xndd6o*twopi/Cube(xmnpda);

  xke    := Sqrt(3600*ge/(Sqr(xkmper)*xkmper));  {Sqrt(ge) ER^3/min^2}
  qoms2t := Sqr(Sqr(qo-s));                      {(qo-s)^4 ER^4}


{* Determine whether Deep-Space Model is needed *}
  a1 := Power(xke/xno,tothrd);
  temp := 1.5*ck2*(3*Sqr(Cos(xincl))-1)/Power(1 - eo*eo,1.5);
  del1 := temp/(a1*a1);
  ao := a1*(1 - del1*(0.5*tothrd + del1*(1 + 134/81*del1)));
  delo := temp/(ao*ao);
  xnodp := xno/(1 + delo);
  if (twopi/xnodp >= 225) then
    ideep := 1
  else
    ideep := 0;
  iflag := 1;


  tsince := (time - julian_epoch) * xmnpda;
  if ideep = 0
    then  SGP4(tsince,iflag,pos,vel)
    else  SDP4(tsince,iflag,pos,vel);


 End;


end.
