      SUBROUTINE PCMCTAC(SAT,C,ADAL,TEP,UTT,VTT,UT,VT,VTTH,
     *			DELTA,SPUM,SPUS,SPUK,TBEG,TEND)
      IMPLICIT REAL*8(A-H,O-Z),INTEGER*2(I-N)
      DIMENSION C(50),ADAL(30,3),RV(6),PRMAT(3,3),
     *		UTT(3),VTT(3),CD(90),UT(3),VT(3),VTTH(3)
      CHARACTER SAT(20)
      DATA PI22/6.283185307179586D0/
c
	PI90=0.25D0*PI22
c
	C(1)= 3.98600448000D+5
	C(2)= 6.37813700000D+3
	C(3)= 2.09728850857D+2
	C(4)=-3.55889244242D-02
c
	CD(1)= 3.98600448000D+5
	CD(2)= 6.37813700000D+3
	CD(3)= 2.09728850857D+2
	CD(4)=-3.55889244242D-02
c
c	PRINT 132
  132	FORMAT(1X,/,
     *	1X,'in the KOCMOC format We have the osculant Elements',/,
     *	1X,'    on the moment of  Moscow  Decret  Time',/,
     *	1X,'    when the Satellite crossed the Equator',/,
     *	1X,'     in the Ascending Node of the Orbit.')
c	PRINT 230
  230	FORMAT(1X,'also We have',/,
     *	1X,'the Vector for Position of the Satellite in  km',/,
     *	1X,'the Vector for Velosity of the Satellite in km/s',/,
     *	1X,'in the Co-ordinate System  rotating with the Earth')
c
	PRINT 232
  232	FORMAT(1X,///,10X,' Absolut system format',//,
     *	1X,'in this format We have:',//,
     *	10X,'the Vector for Position of the Satellite in  km   and',/,
     *	10X,'the Vector for Velosity of the Satellite in  km/s',//,
     *	1X,'    on the moment of  Moscow  Decret  Time',/,
     *	5X,'in the System of the Co-ordinate on the fixed Epoch',/,
     *	5X,'for example',/,
     *	10X,'in the System of the fixed  Equator and Ecliptic',
     *	1X,' on the Epoch  B1975.0')
c
	FREZ=0.7292115D-4
	PRINT *,'attention:'
	PRINT 55
   55	FORMAT(1X,'input the name or number of Satellite  ',\)
	READ(*,56) SAT
   56	FORMAT(20A1)
	PRINT 137
  137	FORMAT(1X,'please input Date in form  DD MM YYYY  ',\)
	READ *,ID,IM,IG
	PRINT 138
  138	FORMAT(1X,'please input Time in form  HH MM SS.S  ',\)
	READ *,JH,JM,SEC
	if (IG.lt.100) IG=1900+IG
	J1=IG-1900
	M1=IM-3
	IF (M1.GE.0) GO TO 30003
	M1=M1+12
	J1=J1-1
30003	Q=0.5D0+30.6D0*M1
	IQ=Q
	IJ=J1/4
	Q=IQ+IJ+ID
	T=15078.D0+365.D0*J1+Q
	TEP=T+(JH+JM/60.D0+SEC/36.D2-3.D0)/24.D0
C
	TBEG=TEP-DMOD(TEP,1.D0)
	TEND=TBEG+30.D0
C
C if Absolut system is used then go to 237
C
	GO TO 237
C
	CALL ZTIME(TEP,SZZ,CZZ)
C
	print 240
	print 242
	READ *,PX
	print 243
	READ *,PY
	print 244
	READ *,PZ
	print 241
	print 245
	READ *,VX
	print 246
	READ *,VY
	print 247
	READ *,VZ
C
C  to the Epoch fixed Equatorial System in km and km/s
C
	PXX=PX*CZZ-PY*SZZ
	PYY=PX*SZZ+PY*CZZ
	PZZ=PZ
C
	VXX=VX*CZZ-VY*SZZ + FREZ * (-PX*SZZ-PY*CZZ)
	VYY=VX*SZZ+VY*CZZ + FREZ * (+PX*CZZ-PY*SZZ)
	VZZ=VZ
c
	PX=PXX
	PY=PYY
	PZ=PZZ
c
	VX=VXX
	VY=VYY
	VZ=VZZ
c
	go to 337
c
  237	continue
c
c	PRINT 260
c	READ *,TEPOCH
c
	TEPOCH=1975.0
c
	PRINT 251	
	PRINT 252
	READ *,PX
	PRINT 253
	READ *,PY
	PRINT 254
	READ *,PZ
C
	PRINT 258
	PRINT 255
	READ *,VX
	PRINT 256
	READ *,VY
	PRINT 257
	READ *,VZ
C
  337	IG=TEPOCH+1.D-8
	if (IG.lt.100) IG=1900+IG
	IM=1
	ID=0
	J1=IG-1900
	M1=IM-3
	IF (M1.GE.0) GO TO 30005
	M1=M1+12
	J1=J1-1
30005	Q=0.5D0+30.6D0*M1
	IQ=Q
	IJ=J1/4
	Q=IQ+IJ+ID
	TJD1=2415078.5D0+365.D0*J1+Q
	TJD2=2400000.5D0+TEP
C
	CALL OLDPR(TJD1,TJD2,PRMAT)
C
C on the Epoch of the Date
C
	RV(1)=PRMAT(1,1)*PX+PRMAT(1,2)*PY+PRMAT(1,3)*PZ
	RV(2)=PRMAT(2,1)*PX+PRMAT(2,2)*PY+PRMAT(2,3)*PZ
	RV(3)=PRMAT(3,1)*PX+PRMAT(3,2)*PY+PRMAT(3,3)*PZ
C
	RV(4)=PRMAT(1,1)*VX+PRMAT(1,2)*VY+PRMAT(1,3)*VZ
	RV(5)=PRMAT(2,1)*VX+PRMAT(2,2)*VY+PRMAT(2,3)*VZ
	RV(6)=PRMAT(3,1)*VX+PRMAT(3,2)*VY+PRMAT(3,3)*VZ
C
C       RV - position and velosity in km and km/sec
C
	CALL XVEILR(RV,AO,AU,AI,AE,AM,ANOB,AOR,AUR,AMR)
C
  240	FORMAT(1X,'please input the three-dimensional Vector',/,
     *		1X,'for Position of the Satellite',
     *		1X,'in the  Earth-rotating System:')
  242	FORMAT(1X,' the Value for  X - Co-ordinate in km    ',\)
  243	FORMAT(1X,' the Value for  Y - Co-ordinate in km    ',\)
  244	FORMAT(1X,' the Value for  Z - Co-ordinate in km    ',\)
C
  241	FORMAT(1X,'please input the three-dimensional Vector',/,
     *		1X,'for Velocity of the Satellite',
     *		1X,'in the  Earth-rotating System:')
  245	FORMAT(1X,' the Value for  X - Co-ordinate in km/s  ',\)
  246	FORMAT(1X,' the Value for  Y - Co-ordinate in km/s  ',\)
  247	FORMAT(1X,' the Value for  Z - Co-ordinate in km/s  ',\)
C
  260	FORMAT(1X,//,1X,'please input the Value for fixed Epoch',/,
     *		5X,'in form  GGGG.G   (for example  1975.0)   ',\)
  251	FORMAT(1X,//,1X,'please input the three-dimensional Vector',/,
     *		1X,'for Position of the Satellite',
     *		1X,'in the  System on the fixed Epoch:',/)
  252	FORMAT(1X,' the Value for  X - Co-ordinate in km    ',\)
  253	FORMAT(1X,' the Value for  Y - Co-ordinate in km    ',\)
  254	FORMAT(1X,' the Value for  Z - Co-ordinate in km    ',\)
C
  258	FORMAT(1X,//,1X,'please input the three-dimensional Vector',/,
     *		1X,'for Velocity of the Satellite',
     *		1X,'in the  System on the fixed Epoch:',/)
  255	FORMAT(1X,' the Value for  X - Co-ordinate in km/s  ',\)
  256	FORMAT(1X,' the Value for  Y - Co-ordinate in km/s  ',\)
  257	FORMAT(1X,' the Value for  Z - Co-ordinate in km/s  ',\)
C
	SPUM=500.
	SPUS=1.
	SPUK=1.
	PRINT *,'input please other :'
	PRINT *,'mass of Satellite in kg'
	READ(*,*,END=48) SPUM
	IF (SPUM.LT.1.D-1) SPUM=1.D9
	PRINT *,'the Midel Area in  m**2'
	READ(*,*,END=48) SPUS
	PRINT *,'Reflectance Coefficient'
	READ(*,*,END=48) SPUK
C
	PRINT *,'What is number of the Days to prognoz ?'
	READ(*,*,END=48) NUMDAY
	TEND=TBEG+NUMDAY
C
   48	DELTA=SPUK*(SPUS/SPUM)*1.D3
C
	GP=PI22
	GR=PI22/360.D0
	FM=C(1)
	CJ2=C(3)
	SIG=C(4)
C
	IRAN=0
	C(40)=0.D0
    3	CONTINUE
	IRAN=IRAN+1
      AN0=(GP*ANOB/8.64D4)*(1.D0-C(40))
      CALL EREMA(FM,CJ2,SIG,AN0,AE,AI,C) 
      CALL ALEI(C) 
      CALL CRONA(C)
c
	IF (IRAN.EQ.1) GO TO 3
c
	CALL PARMB(C,ADAL)
	CALL PARMC(C,ADAL)
c
	A1=C(5)
	A2=C(6)
	A3=C(7)
c
	CALL EMELD(CD,A1,A2,A3,EDL,EDG,EDH)
C
	UL0=AMR
	UG0=AOR+PI90
	UH0=AUR-PI90
C
	UDL=UL0
	UDG=UG0
	UDH=UH0
C
	UTT(1)=UDL
	UTT(2)=UDG
	UTT(3)=UDH
	VTT(1)=EDL
	VTT(2)=EDG
	VTT(3)=EDH
	DO 74 I=1,3
		UT(I)=UTT(I)
		VT(I)=VTT(I)
   74		VTTH(I)=VTT(I)
C
      RETURN
      END
C
	SUBROUTINE PCMORD(RUMIN,NTERM,IARW,RWW,BIT,BIW)
	IMPLICIT REAL*8(A-H,O-Z),INTEGER*2(I-N)
	CHARACTER BIT(2000),BIW(2000),BSC
	DIMENSION IARG(9),IARW(2000,9),RW(4),RWW(2000,4)
C
	NTERM=0
	IARMP=0
	MAXMP=0
	GO TO 303
  302	IARMP=IARMP+1
		IF (IARMP.GT.MAXMP) GO TO 3010
  303	IARMS=IARMP
	IR=0
	REWIND 11
C
  300	READ(11,END=301) (IARG(I),I=1,9),(RW(K),K=1,4),BSC
C
	IARM=IABS(IARG(3))
	IF ((IARMP.EQ.0).AND.(IARM.GT.MAXMP)) MAXMP=IARM
	IF (IARM.NE.IARMS) GO TO 300
C
	CALL SUUN(IARG,RW,BSC,IR,IARW,RWW,BIW)
	IF (IR.LT.2000) GO TO 300
  301	CONTINUE
	PRINT 204,IARMS,IR
	WRITE(17,204) IARMS,IR
C
 5204	N=IR
	IF (N.EQ.0) GO TO 39
	IF (N.EQ.1) GO TO 139
	CALL SNUR(N,IARW,RWW,BIW,BIT)
  139	IR=0
	DO 47 II=1,N
		IF (BIT(II).EQ.'N') GO TO 48
		DO 3131 K=2,4
			RAMP=DABS(RWW(II,K))
			IF (RAMP.GT.RUMIN) GO TO 3231
 3131		CONTINUE
		GO TO 48
 3231		CONTINUE
C
		WRITE(13) (IARW(II,I),I=1,9),
     *			(RWW(II,K),K=1,4),BIW(II)
		IR=IR+1
c
	qrw=dabs(rww(ii,2))
	qrww=rww(ii,2)+rww(ii,3)
	if (qrw.gt.1.e-2) write(17,206) ir,(iarw(ii,i),i=1,9),
     *			(rww(ii,k),k=1,3),qrww,biw(ii)
  206	format(i4,1x,9i3,1p,4e11.2,1x,a1)
c 
  48		CONTINUE
   47	CONTINUE
	NTERM=NTERM+IR
   39	PRINT 202,IARMS,IR
	WRITE(17,202) IARMS,IR
  204	FORMAT(1X,'   for  M=',I3,'  are read   ',I6,'  Terms')
  202	FORMAT(1X,'   for  M=',I3,'  are ordered',I6,'  Terms')
C
	GO TO 302
C
 3010	RETURN
	END
C
	SUBROUTINE SUUN(IARG,RW,BSC,IR,IARW,RWW,BIW)
	IMPLICIT REAL*8(A-H,O-Z),INTEGER*2(I-N)
	DIMENSION IARG(9),IARW(2000,9),RW(4),RWW(2000,4)
	CHARACTER BSC,BIW(2000)
	ISC=1
	DO 3 I=1,9
		II=I
		IA=IARG(I)
		IF (IA.GT.0) GO TO 4
		IF (IA.EQ.0) GO TO 55
			DO 66 JJ=II,9
   66				IARG(JJ)=-IARG(JJ)
			IF (BSC.EQ.'S') ISC=-1
			GO TO 4
   55		CONTINUE
    3	CONTINUE
    4	CONTINUE
	IR=IR+1
	DO 65 I=1,9
   65		IARW(IR,I)=IARG(I)
	DO 5 K=1,4
    5		RWW(IR,K)=ISC*RW(K)
	BIW(IR)=BSC
	RETURN
	END
C
	SUBROUTINE SNUR(N,IARW,RWW,BIW,BIT)
	IMPLICIT REAL*8(A-H,O-Z),INTEGER*2(I-N)
	DIMENSION IARW(2000,9),RWW(2000,4)
	CHARACTER BIW(2000),BIT(2000)
	IN=N-1
	DO 6 I=1,N
    6		BIT(I)='Y'
	DO 7 II=1,IN
		IF (BIT(II).EQ.'N') GO TO 9
		IJ=II+1
		DO 8 JJ=IJ,N
			IF (BIT(JJ).EQ.'N') GO TO 10
			IF (BIW(II).NE.BIW(JJ)) GO TO 10
			DO 88 I=1,9
		IF (IARW(II,I).NE.IARW(JJ,I)) GO TO 10
   88			CONTINUE
			BIT(JJ)='N'
	DO 11 K=1,4
   11		RWW(II,K)=RWW(II,K)+RWW(JJ,K)
   10			CONTINUE
    8		CONTINUE
    9		CONTINUE
    7	CONTINUE
	RETURN
	END
C
	SUBROUTINE XVEILR(X,AO,AU,AI,AE,AM,ANOB,AOR,AUR,AMR)
	IMPLICIT REAL*8(A-H,O-Z)
	DIMENSION X(6),C(50)
C
	FM= 3.98600448000D+5
	RZ= 6.37813700000D+3
	CJ2= 2.09728850857D+2
	SIG=-3.55889244242D-02
	GRARAD=1.7453292519943296D-2
	RADGRA=57.29577951308232D0
	Z2=CJ2**2
	Z0=CJ2*SIG
	X1=X(1)
	X2=X(2)
	X3=X(3)-Z0
	V1=X(4)
	V2=X(5)
	V3=X(6)
	ZX=X3**2
	R2=X1**2+X2**2+ZX
	U2=V1**2+V2**2+V3**2
	R1=X1*V1+X2*V2+X3*V3
	F2=0.5D0*(R2-Z2+DSQRT((R2-Z2)**2+4.D0*Z2*ZX))
	BS=DSQRT(F2)
	BT=X3/BS
	Z4=Z2*BT**2
	FI=2.D0*FM/(F2+Z4)
	VT=BS*V3-BT*R1
	VS=BS*R1+Z2*BT*V3
	A1=U2-FI*(BS-Z0*BT)
	A3=X1*V2-V1*X2
	A2=R1**2-R2*U2+Z2*V3**2-FI*(BS*Z4+Z0*BT*F2)
	C(1)=FM
	C(2)=RZ
	C(3)=CJ2
	C(4)=SIG
	C(5)=A1
	C(6)=A2
	C(7)=A3
	CALL ALEI(C)
	CALL CRONA(C)
C
	AB=C(8)
	AE=C(9)
	AS=C(10)
	AC=C(11)
	AD=C(12)
	ADZ=C(13)
	AX=C(14)
	AG=C(15)
	AT=C(16)
	AG1=C(17)
	AG2=C(18)
	AN=C(19)
	AQ=C(20)
	AC0=C(21)
	AC1=C(22)
	AC2=C(23)
	AC3=C(24)
	AC4=C(25)
	AK1=C(26)
	AK2=C(27)
	AQ0=C(28)
	AQ1=C(29)
	AQ2=C(30)
	AZ=C(31)
	AP0=C(32)
	AP1=C(33)
	AP2=C(34)
	AF0=C(35)
	AF1=C(36)
	AF2=C(37)
	AF3=C(38)
	AF4=C(39)
	ALAM=C(40)
	AN0=C(41)
	OH= C(45)
	AMU=C(46)
	AKF2=C(47)
	AKF4=C(48)
	AKP2=C(49)
	AKP4=C(50)
C
	CE=(1.D0-BS/AB)/AE
	SE=DSQRT(1.D0-CE**2)
	IF (VS.LT.0.D0) SE=-SE
	EA=DATAN2(SE,CE)
	CP=(CE-AX)/(1.D0-AX*CE)
	SP=DSQRT(1.D0-CP**2)
	IF (VS.LT.0.D0) SP=-SP
	EP=DATAN2(SP,CP)
	SF=(BT-AG)/(AS-BT*AT)
	CF=DSQRT(1.D0-SF**2)
	IF (VT.LT.0.D0) CF=-CF
	EF=DATAN2(SF,CF)
	S2P=2.D0*SP*CP
	C2P=CP**2-SP**2
	S4P=2.D0*S2P*C2P
	S2F=2.D0*SF*CF
	C2F=CF**2-SF**2
	S4F=2.D0*S2F*C2F
	AO0=EF-AK1*(1.+4.*AK1)*S2F+0.75*(AK1**2*S4F-AK2**2*S4P)
     *		-AN*(EP-AK2*(1.D0+4.*AK2)*S2P)
	R1=AC*SF+AQ
	BW=DATAN2(X2,X1)-DATAN2(R1,CF)
	AU0=BW-AC0*EP-AC1*SP-AC2*S2P-AC3*(S2P*CP+C2P*SP)
     *		-AC4*S4P-AQ0*EF-AQ1*CF-AQ2*S2F
	AM0=EA-AZ*SE+AP0*EP+AP1*SP+AP2*S2P
     *		+AF0*EF+AF1*CF+AF2*S2F+AF3*(C2F*CF-S2F*SF)+AF4*S4F
C
	R1=1.D0/(1.D0-C(40))
	AMR=R1*(AM0-AF0*AO0)
	AOR=AO0+OH*AM
	AUR=AU0+AQ0*AO0+AMU*AM
	AM=RADGRA*AM/360.D0
	AO=RADGRA*AO
	AU=RADGRA*AU
	AI=RADGRA*DATAN2(AS,AC)
	ANOB=AN0*R1*(RADGRA/360.D0)*8.64D4
	ANARGP=OH*R1*RADGRA*8.64D4
	ANNODE=AMU*R1*RADGRA*8.64D4
	RETURN
	END
C
	SUBROUTINE ZTIME(T,SZZ,CZZ)
	IMPLICIT REAL*8(A-H,O-Z)
	DATA PI22/6.283185307179586D0/
C
C      AJ=IDINT(T)
C      S=T-AJ
	S=DMOD(T,1.D0)
	AJ=T-S
      AJ=AJ-15019.5D0
      F=DMOD(AJ/365.25D0,1.D0)
      AJS=AJ/36525.D0
      S0=(.13420272950897D-1+.6755878646D-5*AJS)*AJS
      S0=S0+1.73993589371745D0+F*PI22
      S0=S0+1.002737909255831D0*S*PI22
      IF(S0.GT.PI22) S0=DMOD(S0,PI22)
C
C	S0=100.0755417D0+360.98564734598D0*(T-33282.D0)
C	S0=PI22*S0/360.0D0
C
      SZZ=DSIN(S0)
      CZZ=DCOS(S0)
C
	RETURN
	END
C
	SUBROUTINE PCMELM(CBT,ADAL,C,DA123,TEP,UTT,VTT,UT,VT,VTTH,
     *			IARG,AMP,BCS)
	IMPLICIT REAL*8(A-H,O-Z),INTEGER*2(I-N)
	DIMENSION CBT(50),ADAL(30,3),C(90),
     *		DA123(3,4),WTH(3),DV(3),YY(4),EL(3),
     *		DDU(3),DDDU(3),DDL(3),DDDL(3),
     *		UTT(3),VTT(3),UT(3),VT(3),VTTH(3),
     *		IARG(2000,9),AMP(2000,4),MAXS(9)
	CHARACTER BCS(2000)
	FM=CBT(1)
	RZ=CBT(2)
	CJ2=CBT(3)
	SIG=CBT(4)
	DO 9112 I=1,4
 9112		C(I)=CBT(I)
C
	DA123(1,1)=CBT(5)
	DA123(2,1)=CBT(6)
	DA123(3,1)=CBT(7)
	DA123(3,2)=0.D0
	DA123(3,3)=0.D0
	DA123(3,4)=1.D0
	DO 421 K=2,4
		K1=K-1
		DA123(1,K)=2.D0*ADAL(1,K1)
  421		DA123(2,K)=-ADAL(2,K1)
C
	DO 11 I=1,3
		WTH(I)=VTTH(I)
		DDU(I)=0.D0
   11		DDL(I)=0.D0
c
	IENDF=0
	NTERMT=0
	DELAMP=1.D0
c
   13	CONTINUE
	IF (IENDF.EQ.2) GO TO 12
c
	CALL AMPFUT(DELAMP,NTERMT,NTERMW,IARG,AMP,BCS,MAXS,IENDF)
c
	write(17,*) 'number of the short periodic terms',NTERMW
	print *,'number of the short periodic terms',NTERMW
c
	if (NTERMW.eq.0) go to 12
c
	CALL CAHORT(CBT,ADAL,DA123,WTH,
     *		NTERMW,IARG,AMP,BCS,MAXS,TEP,UTT,VT,DDDU,DDDL)
C
	DO 9 I=1,3
		DDU(I)=DDU(I)+DDDU(I)
    9		DDL(I)=DDL(I)+DDDL(I)
c
	GO TO 13
   12	CONTINUE
C
	DO 88 I=1,3
		VT(I)=VTT(I)-DDL(I)
		UT(I)=UTT(I)-DDU(I)
		DV(I)=VT(I)-VTTH(I)
   88		VTTH(I)=VT(I)
c
	write(17,2) (ddl(i),i=1,3),(ddu(i),i=1,3)
    2	format(1x,'corrections',/,1x,1p,3e12.3,3x,3e12.3)
c
	CALL CARTER(DV,YY)
	CALL CARTOT(YY,DA123,EL)
c
	CBT(5)=EL(1)
	CBT(6)=EL(2)
	CBT(7)=EL(3)
	CALL ALEI(CBT)
	CALL CRONA(CBT)
	CALL PARMB(CBT,ADAL)
	CALL PARMC(CBT,ADAL)
c
	RETURN
	END
c
	SUBROUTINE PCMWRT(SAT,CC,ADAL,TEP,UT,VT,DELTA,SPUM,SPUS,SPUK)
	IMPLICIT REAL*8(A-H,O-Z),INTEGER*2(I-N)
	DIMENSION CC(50),ADAL(30,3),UT(3),VT(3),RSEQ(3),IA(9),A(4)
	CHARACTER SAT(20),BOT
	DATA PI22/6.283185307179586D0/
c
	GR=PI22/360.D0
	RG=360.D0/PI22
	PI90=0.25D0*PI22
C
	AE=CC(9)
	AS=CC(10)
	AC=CC(11)
	AIR=DATAN2(AS,AC)
	AI=RG*AIR
	AMM=0.D0
C
	RSEQ(1)=0.D0
	RSEQ(2)=0.D0
	RSEQ(3)=0.D0
C
	J=-1
C
	OPEN(UNIT=12,FILE='CTAC.SEQ',STATUS='OLD',
     *		ERR=141,FORM='UNFORMATTED')
	GO TO 2141
  141	CONTINUE
	OPEN(UNIT=12,FILE='CTACTH.SEQ',STATUS='OLD',
     *		ERR=1141,FORM='UNFORMATTED')
C
 2141	J=0
  991	READ(12,END=992) (IA(K),K=1,9),(A(K),K=1,4),BOT
C
	IF (BOT.NE.'C') GO TO 991
	DO 993 K=1,9
		IF (IA(K).NE.0) GO TO 991
  993	CONTINUE
C
	J=J+1
	DO 994 K=2,4
		I=K-1
  994		RSEQ(I)=RSEQ(I)+A(K)
	GO TO 991
C
  992	CLOSE(UNIT=12)
C
 1141	EDL=VT(1)
	EDG=VT(2)
	EDH=VT(3)
C
	AMR=UT(1)
	AOR=UT(2)-PI90
	AUR=UT(3)+PI90
	AO=RG*AOR
	AU=RG*AUR
	AM=RG*AMR/360.D0
c
      GG=8.64D4/GR
      DAM=(CC(42)-RSEQ(1))*GG/360.D0
      DAO=(CC(43)-RSEQ(2))*GG
      DAU=(CC(44)-RSEQ(3))*GG
      ANOB=DAM
      PRINT 2,SAT,TEP,AO,DAO,AU,DAU,AI,AE,AM,DAM,AMM
	write(17,2) SAT,TEP,AO,DAO,AU,DAU,AI,AE,AM,DAM,AMM
    2 FORMAT(5X,'You deal with the Satellite  ',20A1,/,
     *	5X,' Middle Elements of Orbit :',/,
     *  5X,'    Epoch          ',F14.7,/,
     *	5X,'Argument of Perigei',2F14.7,/,
     *	5X,'the Ascending Node ',2F14.7,/,
     *  5X,'Inclination        ',F14.7,/,
     *	5X,'Eccentricity       ',F16.9,/,
     *	5X,'Mean Anomaly       ',F16.9,/,
     *	5X,'Mean Motion        ',F16.9,2X,1PE10.2)
	OPEN(UNIT=11,FILE='CTAC.SAT',STATUS='UNKNOWN')
	WRITE(11,2) SAT,TEP,AO,DAO,AU,DAU,AI,AE,AM,DAM,AMM
	CLOSE(UNIT=11)
C
	ITER=0
c
      OPEN(UNIT=10,FILE='CTACINIT.DAT',
     *		STATUS='UNKNOWN',FORM='UNFORMATTED')
      DO 11 J=1,50
         WRITE(10) CC(J)
   11 CONTINUE
	WRITE(10) TEP,ANOB,AOR,AUR,AMR,AMM
	DO 12 I=1,30
   12		WRITE(10) (ADAL(I,J),J=1,3)
	WRITE(10) DELTA,SPUM,SPUS,SPUK
	WRITE(10) ITER
	CLOSE(UNIT=10)
C
	RETURN
	END
C
	SUBROUTINE AMPFUT(DEL,NTERMT,NTERM,IARG,AMP,BCS,MAXS,IENDF)
	IMPLICIT REAL*8(A-H,O-Z),INTEGER*2(I-N)
	DIMENSION MAXS(9),IA(9),A(4),AMP(2000,4),IARG(2000,9)
	CHARACTER BOT,BCS(2000)
C
	NTERM=0
C
	DO 81421 I=1,9
81421		MAXS(I)=0
C
	IF (IENDF.EQ.1) GO TO 4991
C
	OPEN(UNIT=12,FILE='CTAC.DAT',STATUS='OLD',
     *		ERR=141,FORM='UNFORMATTED')
	ITH=0
	GO TO 2141
  141	CONTINUE
	OPEN(UNIT=12,FILE='CTACTH.DAT',STATUS='OLD',
     *		ERR=1141,FORM='UNFORMATTED')
	ITH=1
C
 2141	J=0
	JT=0
  991	READ(12,END=1992) (IA(K),K=1,9),(A(K),K=1,4),BOT
	JT=JT+1
	IF (JT.LE.NTERMT) GO TO 991
	J=J+1
	IF (J.GT.2000) GO TO 992
	NTERMT=NTERMT+1
	DO 993 K=1,9
		IF (IABS(IA(K)).GT.MAXS(K)) MAXS(K)=IABS(IA(K))
  993		IARG(J,K)=IA(K)
	DO 994 K=1,4
  994		AMP(J,K)=A(K)
    	BCS(J)=BOT
C
	GO TO 991
C
  992	CLOSE(UNIT=12)
	IF (J.GT.2000) J=2000
	IF (ITH.EQ.1) GO TO 4991
	NTERM=J
	IENDF=0
	if (NTERM.eq.0) IENDF=2
	RETURN
C
 1992	CLOSE(UNIT=12)
	IF (J.GT.2000) J=2000
	NTERM=J
	IENDF=1
	if (NTERM.eq.0) IENDF=2
	RETURN
C
 4991	OPEN(UNIT=12,FILE='CTACPR.DAT',STATUS='OLD',
     *		ERR=1141,FORM='UNFORMATTED')
C
	IF (ITH.EQ.0) J=0
 3991	READ(12,END=3992) (IA(K),K=1,9),(A(K),K=1,4),BOT
	J=J+1
	DO 3993 K=1,9
		IF (IABS(IA(K)).GT.MAXS(K)) MAXS(K)=IABS(IA(K))
 3993		IARG(J,K)=IA(K)
	DO 3994 K=1,4
 3994		AMP(J,K)=DEL*A(K)
    	BCS(J)=BOT
C
	GO TO 3991
C
 3992	CLOSE(UNIT=12)
C
	NTERM=J
	IENDF=2
c
 1141	continue
c
	if (NTERM.eq.0) IENDF=2
c
	RETURN
	END
c
C		      	staraq    precessiq
C		        ===================
C
C     ***************************************************************
C
	SUBROUTINE OLDPR(JD1,JD2,PRMAT)
C	###############################
C
C
	IMPLICIT INTEGER * 2 ( I - N )
	REAL*8 JD1,JD2,PRMAT(3,3),  T,T1,T2,T3,TC
C
C	   podprogramma wy~islqet matricu poworota, osu}estwlq`}u` 
C	perehod ot |kwatorialxnoj sistemy koordinat s |pohi i rawno-
C	denstwiq, sootwetstwu`}ej `lianskoj date "JD1", k sisteme s 
C	|pohoj "JD2".   osnowano na precessii nx`komba, po|tomu -
C	- staraq ( OLD ).  |poha 1950.0 sootwetstwuet `lianskoj
C	date   2 433 282.4234.
C
C	   literatura: EXRLANATORY SUPPLEMENT TO THE ASTRONOMICAL
C	   ----------  EPHEMERIS AND NAUTICAL ALMANAC, LONDON,1961,P.34
C
C
C     *************************************************************
C
C
	TC = 36524.2198 D0
C	TC - tropi~eskoe stoletie
	T  = ( JD1  - 2433282.2198 D0 ) / TC
	T1 = ( JD2  - JD1 ) / TC
	T2 = T1*T1
	T3 = T2*T1
C
	PRMAT(1,1) =  1.0 D0 -(0.29696D-3 + 0.26D-6 * T )*T2 
     *						-0.13D-6 * T3
	PRMAT(1,2) =-(0.2234941D-1 +0.1355D-4 *T)*T1-0.676D-5*T2+
     *						     0.221D-5*T3
	PRMAT(1,3) =-(0.971690D-2 - 0.414D-5 *T)*T1+0.207D-5*T2+
     *						     0.96D-6*T3
C
	PRMAT(2,1) = -PRMAT(1,2)
	PRMAT(2,2) =  1.0D0-(0.24975D-3 + 0.30D-6 * T ) * T2 -
     *						0.15D-6 * T3
	PRMAT(2,3) = -(0.10858D-3 + 0.2D-7 * T ) * T2
C
	PRMAT(3,1) = -PRMAT(1,3)
	PRMAT(3,2) =  PRMAT(2,3)
	PRMAT(3,3) =  1.0D0 -(0.4721D-4 -0.4D-7 * T ) * T2
C
	RETURN
C
	END