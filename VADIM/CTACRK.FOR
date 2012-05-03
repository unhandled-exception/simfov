	SUBROUTINE INTRKP(MT,TN,UN,VN,W,DH,TK,UK,VK,DM,NT,IA,A,C,M)
	IMPLICIT REAL*8(A-H,O-Z),INTEGER*2(I-N)
	DIMENSION UN(3),VN(3),W(3),UK(3),VK(3),
     *		DM(3,4),IA(2000,9),A(2000,4),
     *		U1(3),U2(3),U3(3),U4(3),UT(3),
     *		V1(3),V2(3),V3(3),V4(3),VT(3),
     *		M(9)
	INTEGER*4 MT
	CHARACTER C(2000)
	DATA R6/1.666666666666667D-1/
C
	DHS=86400.D0*DH
	TN=TK
	DO 1 J=1,3
		UN(J)=UK(J)
    1		VN(J)=VK(J)
C
	IF (DABS(DH).LT.1.D-12) RETURN
C
	DD=0.5D0*DH
	DDS=86400.D0*DD
	TT=TN+DD
	TK=TN+DH
C
	CALL INTFOR(MT,TN,UN,VN,W,DM,NT,IA,A,C,M,U1,V1)
C
	DO 2 J=1,3
		UT(J)=UN(J)+DDS*U1(J)
    2		VT(J)=VN(J)+DDS*V1(J)
C
	CALL INTFOR(MT,TT,UT,VT,W,DM,NT,IA,A,C,M,U2,V2)
C
	DO 3 J=1,3
		UT(J)=UN(J)+DDS*U2(J)
    3		VT(J)=VN(J)+DDS*V2(J)
C
	CALL INTFOR(MT,TT,UT,VT,W,DM,NT,IA,A,C,M,U3,V3)
C
	DO 4 J=1,3
		UT(J)=UN(J)+DHS*U3(J)
    4		VT(J)=VN(J)+DHS*V3(J)
C
	CALL INTFOR(MT,TK,UT,VT,W,DM,NT,IA,A,C,M,U4,V4)
C
	DO 5 J=1,3
		U=R6*(U1(J)+2.D0*(U2(J)+U3(J))+U4(J))
		V=R6*(V1(J)+2.D0*(V2(J)+V3(J))+V4(J))
		UK(J)=UN(J)+DHS*U
    5		VK(J)=VN(J)+DHS*V
C
	RETURN
	END
C
	SUBROUTINE INTFOR(MT,T,U,V,W,DANU,NTERM,IARG,AMP,BCS,MAXS,FU,FV)
	IMPLICIT REAL*8(A-H,O-Z),INTEGER*2(I-N)
	DIMENSION U(3),V(3),W(3),FU(3),FV(3),DANU(3,4),
     *		IARG(2000,9),AMP(2000,4),IA(9),A(4),AMOT(3),MAXS(9),
     *		CQ(9),SQ(9),CU(9,13),SU(9,13),BL(3),F(9),DV(3),Y(4)
	INTEGER*4 MT
	CHARACTER BCS(2000),BOT
	DATA PI22/6.283185307179586D0/
C
	GG=360.D0
	GR=PI22/GG
	RG=1.D0/GR
C
	TCLC=MT+T
C
	DO 121 I=1,3
  121		F(I)=U(I)
C
      T40000=TCLC-40000.D0
      AJ=IDINT(T40000)+40000.D0
      S=TCLC-AJ
C
C IAU 1976  for the Greenwich Mean Sidereal Time
C
	AJJ=AJ-51544.5D0
	AJS=AJJ/36525.D0
	S0=1.753368559233266D0+(628.3319706888409D0+
     *	(6.770713944903336D-06-4.508767234318685D-10*AJS)*AJS)*AJS
	FREQ=1.002737909350795D0+
     *	(5.900575455674703D-11-5.893984333409384D-15*AJS)*AJS
	S0=S0+FREQ*S*PI22
	S0=DMOD(S0,PI22)
C
	DT=(TCLC-51544.5D0)/3.6525D4
	DT2=DT**2
	DT3=DT*DT2
	FILA=218.31643250D0+481267.8812772222D0*DT
     *		-0.00161167D0*DT2+0.00000528D0*DT3
	FILA=GR*DMOD(FILA,GG)
	FIL=134.96298139D0+477198.8673980556D0*DT
     *		+0.00869722D0*DT2+0.00001778D0*DT3
	FIL=GR*DMOD(FIL,GG)
	FILS=357.52772333D0+35999.05034D0*DT
     *		-0.00016028D0*DT2-0.00000333D0*DT3
	FILS=GR*DMOD(FILS,GG)
	FIF=93.27191028D0+483202.0175380555D0*DT
     *		-0.00368250D0*DT2+0.00000306D0*DT3
	FIF=GR*DMOD(FIF,GG)
	FID=297.85036306D0+445267.11148D0*DT
     *		-0.00191417D0*DT2+0.00000528D0*DT3
	FID=GR*DMOD(FID,GG)
C
		F(4)=S0
		F(5)=FILA
		F(6)=FIL
		F(7)=FILS
		F(8)=FIF
		F(9)=FID
	DO 3242 J=1,9
		CQ(J)=DCOS(F(J))
 3242		SQ(J)=DSIN(F(J))
C
	DO 17 J=1,9
		QC=CQ(J)
		QS=SQ(J)
		CU(J,1)=QC
		SU(J,1)=QS
		VC=QC
		VS=QS
		MAXI=MAXS(J)
		IF (MAXI.LT.2) GO TO 1917
		DO 1718 I=2,MAXI
			UC=VC*QC-VS*QS
			US=VS*QC+VC*QS
			CU(J,I)=UC
			SU(J,I)=US
			VC=UC
 1718			VS=US
 1917		CONTINUE
   17	CONTINUE
C
	DO 126 J=1,3
  126		DV(J)=V(J)-W(J)
C
	CALL CARTER(DV,Y)
C
	CALL CARTOT(Y,DANU,AMOT)
C
	DO 117 J=1,3
		FU(J)=AMOT(J)
  117		FV(J)=0.D0
C
	IF (NTERM.EQ.0) GO TO 141
C
	DO 123 ITERM=1,NTERM
C
		DO 124 J=1,9
  124			IA(J)=IARG(ITERM,J)
		DO 125 K=1,4
  125			A(K)=AMP(ITERM,K)
		BOT=BCS(ITERM)
C
	CA=1.D0
	SA=0.D0
	DO 18 J=1,9
		IU=IA(J)
		IF (IU.EQ.0) GO TO 19
		IZ=1
		IF (IU.LT.0) IZ=-1
		IU=IZ*IU
		IF (IU.GT.13) GO TO 19
		UC=CU(J,IU)
		US=SU(J,IU)
		CB=CA
		SB=SA
		CA=CB*UC-IZ*SB*US
		SA=SB*UC+IZ*CB*US
   19		CONTINUE
   18	CONTINUE
C
		CALL CARFUT(Y,A,B,BL)
C
		IF (BOT.EQ.'C') RV=-B*SA
		IF (BOT.EQ.'S') RV=+B*CA
		DO 127 J=1,3
			IF (BOT.EQ.'C') FU(J)=FU(J)-BL(J)*CA
			IF (BOT.EQ.'S') FU(J)=FU(J)-BL(J)*SA
  127			FV(J)=FV(J)+IA(J)*RV
C
C FU and FV -> the Forces on Angle and Action Variables
C
  123	CONTINUE
C
  141	RETURN
	END
C
	SUBROUTINE CARFUT(Y,X,BF,BL)
	IMPLICIT REAL*8(A-H,O-Z),INTEGER*2(I-N)
	DIMENSION X(4),BL(3),Y(4)
C
	BF=X(1)
	DO 11 I=2,4
   11		BF=BF+Y(I)*X(I)
	DO 12 J=1,3
   12		BL(J)=X(J+1)
	RETURN
	END
C
	SUBROUTINE CARTOT(Y,U,Z)
	IMPLICIT REAL*8(A-H,O-Z),INTEGER*2(I-N)
	DIMENSION U(3,4),Z(3),Y(4)
C
	DO 13 J=1,3
   13		Z(J)=0.D0
C
	DO 11 I=1,4
		Q=Y(I)
		DO 11 J=1,3
   11			Z(J)=Z(J)+Q*U(J,I)
C
	RETURN
	END
C
	SUBROUTINE CARTER(D,Y)
	IMPLICIT REAL*8(A-H,O-Z),INTEGER*2(I-N)
	DIMENSION D(3),Y(4)
	Y(1)=1.D0
	Y(2)=D(1)
	Y(3)=D(2)
	Y(4)=D(3)
	RETURN
	END
C
      SUBROUTINE PSEU(AC,N,M,EPS,IR,MR,AI)
      IMPLICIT REAL*8(A-H,O-Z),INTEGER*2(I-N)
      DIMENSION CM(20),CK(20),CC(20),
     *		CA(20),MR(20),AI(20,20),AC(20,20)
      IR=0
      IM=M
      DO 1 M1=1,M
         M0=M1-1
         C2=0.D0
         DO 2 I=1,N
            CC(I)=AC(I,M1)
            CM(I)=AC(I,M1)
            C2=C2+CM(I)**2
    2    CONTINUE
         IF(C2.GT.EPS) GO TO 3
         DO 4 I=1,N
            CK(I)=0.D0
    4    CONTINUE
         MR(IM)=M1
         IM=IM-1
         GO TO 5
    3    CONTINUE
         IF (IR.GT.0) GO TO 6
         DO 7 I=1,N
            CK(I)=CM(I)/C2
    7    CONTINUE
         MR(1)=M1
         IR=1
         GO TO 5
    6    CONTINUE
         DO 8 J=1,M0
            CA(J)=0.D0
            DO 9 I=1,N
               CA(J)=CA(J)+AI(J,I)*CM(I)
    9       CONTINUE
            DO 10 I=1,N
               CC(I)=CC(I)-CA(J)*AC(I,J)
   10       CONTINUE
    8    CONTINUE
         C2=0.D0
         DO 11 I=1,N
            C2=C2+CC(I)**2
   11    CONTINUE
         IF (C2.GT.EPS) GO TO 12
         C2=0.D0
         MR(IM)=M1
         IM=IM-1
         DO 13 I=1,N
            CC(I)=0.D0
            DO 14 J=1,M0
               CC(I)=CC(I)+CA(J)*AI(J,I)
   14       CONTINUE
            C2=C2+CM(I)*CC(I)
   13    CONTINUE
         C2=C2/(1.D0+C2)
         DO 15 I=1,N
            CK(I)=C2*CC(I)
   15    CONTINUE
         GO TO 16
   12    CONTINUE
         C2=0.D0
         IR=IR+1
         MR(IR)=M1
         DO 17 I=1,N
            C2=C2+CM(I)*CC(I)
   17    CONTINUE
         C2=1.D0/C2
         DO 18 I=1,N
            CK(I)=C2*CC(I)
   18    CONTINUE
   16    CONTINUE
         DO 19 J=1,M0
            DO 20 I=1,N
               AI(J,I)=AI(J,I)-CA(J)*CK(I)
   20       CONTINUE
   19    CONTINUE
    5    CONTINUE
         DO 21 I=1,N
            AI(M1,I)=CK(I)
   21    CONTINUE
    1 CONTINUE
      RETURN
      END
C
	SUBROUTINE INTCOF(RM,U1,U2,U3,U4,V1,V2,V3,V4,UC,VC)
	IMPLICIT REAL*8(A-H,O-Z),INTEGER*2(I-N)
	DIMENSION RM(20,20),UC(3,4),VC(3,4),
     *		U1(3),U2(3),U3(3),U4(3),V1(3),V2(3),V3(3),V4(3)
C
	DO 1 J=1,3
		DO 1 K=1,4
			UC(J,K)=RM(K,1)*U1(J)+RM(K,2)*U2(J)
     *				+RM(K,3)*U3(J)+RM(K,4)*U4(J)
			VC(J,K)=RM(K,1)*V1(J)+RM(K,2)*V2(J)
     *				+RM(K,3)*V3(J)+RM(K,4)*V4(J)
    1	CONTINUE
	RETURN
	END
C
	SUBROUTINE INTPOL(TN,UC,VC,T,U,V)
	IMPLICIT REAL*8(A-H,O-Z),INTEGER*2(I-N)
	DIMENSION UC(3,4),VC(3,4),U(3),V(3)
	D=T-TN
	D2=D**2
	D3=D*D2
	DO 1 J=1,3
		U(J)=UC(J,1)+UC(J,2)*D+UC(J,3)*D2+UC(J,4)*D3
    1		V(J)=VC(J,1)+VC(J,2)*D+VC(J,3)*D2+VC(J,4)*D3
	RETURN
	END
C
	SUBROUTINE INTDRK(MT,TN,UN,VN,W,DH,TK,UK,VK,DM,NT,IA,A,C,M)
	IMPLICIT REAL*8(A-H,O-Z),INTEGER*2(I-N)
	DIMENSION UN(3,7),VN(3,7),W(3),UK(3,7),VK(3,7),
     *		DM(3,4),IA(2000,9),A(2000,4),M(9),
     *		UT(3),FU(3),VT(3),FV(3)
	INTEGER*4 MT
	CHARACTER C(2000)
C
	DHS=86400.D0*DH
	TN=TK
	TK=TN+DH
	DO 11 I=1,7
		DO 1 J=1,3
			UT(J)=UK(J,I)
			VT(J)=VK(J,I)
			UN(J,I)=UK(J,I)
    1			VN(J,I)=VK(J,I)
C
		CALL INTFOR(MT,TN,UT,VT,W,DM,NT,IA,A,C,M,FU,FV)
C
		DO 5 J=1,3
			UK(J,I)=UT(J)+DHS*FU(J)
    5			VK(J,I)=VT(J)+DHS*FV(J)
C
   11	CONTINUE
	RETURN
	END
C
      SUBROUTINE ALEI(C)
      IMPLICIT REAL*8(A-H,O-Z),INTEGER*2(I-N)
      DIMENSION C(50)
      O=1.D0
      A1=C(5)
      A2=C(6)
      A3=C(7)
      FM=C(1)
      CJ2=C(3)	
      SIG=C(4)
      AB=-FM/A1
      FA=AB
      FE=-A2/FM
      RE=FE/FA
      PA=A3**2
      RD=-PA/A2
      RDZ=RD
      FD=RD
      PA=PA/FM
      DO 1 J=1,5
         PE=CJ2/(AB*RE)
         P2=PE**2
         PS=PE*SIG
         D2=O-RD
         AD=DSQRT(D2)
         P1=2.D0*P2*(2.D0-RE)
         P2=P2*RE
         P4=P2**2
         RR=O+P1*D2+P4*D2**2
         RC=O-2.D0*PS*AD-P2*D2
         RR=RC/RR
         RF=(O+P1+P4)*RR
         RT=O+(RF-RR)*RD
         AB=FA*(O-P2*RD*RR)
         RE=FE/(AB*RT)
         RD=FD*RT/RF
         DZ2=O-RDZ
         ADZ=-DSQRT(DZ2)
         RRZ=O+P1*DZ2+P4*DZ2**2
         RCZ=O-2.D0*PS*ADZ-P2*DZ2
         RDZ=PA*RRZ/(AB*RE*(O+P1+P4)*RCZ)
    1 CONTINUE
      E2=O-RE
c	if (E2.lt.0.0d0) print *,'e**2 < 0.0'
c	if (E2.lt.0.0d0) write(17,*) 'e**2 < 0.0'
      C(8)=AB
      C(9)=DSQRT(DABS(E2))
      D2=O-RD
      C(12)=DSQRT(D2)
      DZ2=O-RDZ
      C(13)=-DSQRT(DZ2)
      P2=PE**2*(3.D0-4.D0*D2+E2)
      C(10)=C(12)+PS*RD*(O-3.D0*PS*C(12)-P2)
      C(11)=DSQRT(O-C(10)**2)
      IF (A3.LT.0.D0) C(11)=-C(11)
      RF=O/FM
      R=-A1**3
      C(41)=DSQRT(R)*RF
      C(31)=-C(8)*C(9)*A1*RF
      RETURN
      END
C
      SUBROUTINE CRONA(C)
      IMPLICIT REAL*8(A-H,O-Z),INTEGER*2(I-N)
      DIMENSION C(50)
      FM=C(1)
      CJ2=C(3)
      SIG=C(4)
      A=C(8)
      E=C(9)
      S=C(10)
      AC=DSQRT(1.D0-S**2)
      IF (C(7).LT.0.D0) AC=-AC
      O=1.D0
      O2=2.D0
      O3=3.D0
      O4=0.25D0
      O5=0.5D0
      E2=E**2
      RE=O-E2
      E4=E2**2
      S2=S**2
      RS=O-S2
      S4=S2**2
      P=CJ2/(A*RE)
      P2=P**2
      PS=P*SIG
      Z2=SIG**2
      AX=E*(O+P2*RE*(O-O2*S2+P2*(O3-
     *   16.D0*S2+14.D0*S4-O2*E2*RS**2)))
      C(14)=AX
      AG=-PS*(O-O2*S2-P2*(O3-12.D0*S2+10.D0*S4+E2*(O-O2*S4)))
      AT=PS*S*(O-P2*(5.D0-6.D0*S2-E2*(O-O2*S2)))
      C(15)=AG
      C(16)=AT
      AK1=0.125D0*P2*S2*(RE+Z2-4.D0*P2*RE*RS)
      AK2=0.125D0*P2*E2*(S2-P2*(O-10.D0*S2+11.D0*S4+E2*S4))
      C(26)=AK1
      C(27)=AK2
      PM=DSQRT(FM*A*RE)
      P2=O5*P2
      P4=O5*P2**2
      AG1=PM*(O+P2*(RS*(O3+E2)+Z2*(6.D0-7.D0*S2))
     *    -P4*RS*(9.D0+11.D0*S2+E2*(6.D0+34.D0*S2)+E4*(O+O3*S2)))
      AG2=PM*(O-P2*(O3-4.D0*S2-E2)-P4*(9.D0-72.D0*S2
     *   +64.D0*S4+E2*(O2-40.D0*S2+48.D0*S4)+E4))
      AN=AG1*(O+O2*AK2+9.D0*AK2**2)/(AG2*(O+O2*AK1+9.D0*AK1**2))
      C(17)=AG1
      C(18)=AG2
      C(19)=AN
      PS=PS*S*AC
      P2=P**2
      P4=P2/16.D0
      C(20)=O2*PS*(O-P2*(4.D0-5.D0*S2+E2*S2))
      R1=P2*AC
      R2=O2*P4
      R3=4.D0*R2
      R4=O4*R1*P4
      AC0=-R1*(O+O5*E2+P4*(24.D0-56.D0*S2
     *   -4.D0*E2*(O+16.D0*S2)-E4*(O2+O3*S2)))
      C(21)=AC0
      C(22)=-O2*R1*E*(O+R2*(4.D0-28.D0*S2-E2*(6.D0+7.D0*S2)))
      C(23)=-O4*R1*E2*(O-R3*(11.D0+E2*(O+S2)))
      C(24)=16.D0*R4*E*E2*(O2-S2)
      C(25)=R4*E4*(O2+S2)
      AQ0=-O5*R1*(RE+O3*Z2-O2*P4*RE
     *    *(30.D0-35.D0*S2+E2*(O2+O3*S2)))
      C(28)=AQ0
      C(29)=P2*PS*RE
      C(30)=6.D0*R4*S2*RE**2
      F2=O-R3*RE*(4.D0-7.D0*S2)-P2*R2*RE
     *    *(20.D0-136.D0*S2+113.D0*S4-E2*(8.D0+24.D0*S2-47.D0*S4))
      F1=P2*RE*(O2-O3*S2+R3*(O2-22.D0*S2+19.D0*S4
     *  -E2*S2*(10.D0-13.D0*S2)))
      F0=O/(F1+F2)
      F0=F0/DSQRT(O-AX**2)
      F0=F0*RE**2
      B0=R3*(-S2+R3*(6.D0-20.D0*S2+15.D0*S4-E2*S4))
      B1=-P2*R3*S2*(O2-S2)
      B2=O3*P2*R2*S4
      AP0=F0*(B0+B1+B2*(O+O5*AX**2))
      C(32)=AP0
      C(33)=AX*(B1+O2*B2)*F0
      C(34)=O4*E2*B2*F0
      F0=P2*F0*AG2/AG1
      AF0=O5*F0*S2*(O+O3*AK1)
      C(35)=AF0
      C(36)=-F0*S*(O2*AG-1.5D0*S*AT)
      C(38)=-F0*S2*AT/6.D0
      C(37)=-F0*S2*(O4+AK1)
      C(39)=0.125D0*F0*S2*AK1
      C(40)=-AP0-AN*AF0
      C(45)=AN-O
      C(42)=C(41)/(O-C(40))
      C(43)=C(45)*C(42)
      C(46)=AC0+AN*AQ0
      C(44)=C(42)*C(46)
      C(47)=AK1*(O+4.D0*AK1)
      C(48)=-0.75D0*AK1**2
      C(49)=-AN*AK2*(O+4.D0*AK2)
      C(50)=0.75D0*AN*AK2**2
      C(23)=C(23)+AQ0*C(49)
      C(30)=C(30)+AQ0*C(47)
      C(34)=C(34)+AF0*C(49)
      C(37)=C(37)+AF0*C(47)
      RETURN
      END
C
      SUBROUTINE DEREMA(FM,CJ2,SIG,AN0,AE,AI,A1,A2,A3)
      IMPLICIT REAL*8(A-H,O-Z),INTEGER*2(I-N)
      DATA PI22/6.283185307179586D0/
      GR=PI22/360.D0
      S=GR*AI
      AS=DSIN(S)  
      AC=DCOS(S)
      AD=AS
      ADZ=-AS
      A1=-(FM*AN0)**(0.666666666666667D0)
      F0=-FM/A1
      AB=F0
      FC=CJ2/F0
      RE=1.D0-AE**2
      F1=2.D0-RE
      F2=RE**2
      DO 1 J=1,7
         PE=CJ2/(AB*RE)
         P2=PE**2
         P4=P2**2
         PS=PE*SIG
         D2=AD**2
         RD=1.D0-D2
         D4=D2**2
         RC=1.D0-2.D0*PS*AD-P2*D2*RE
         RR=1.D0+2.D0*P2*D2*F1+P4*D4*F2
         R1=RC/RR
         F3=1.D0-RD*R1
         AB=F0*(1.D0-P2*RE*RD*R1)
         DZ2=ADZ**2
         RDZ=1.D0-DZ2
         DZ4=DZ2**2
         RCZ=1.D0-2.D0*PS*ADZ-P2*DZ2*RE
         RRZ=1.D0+2.D0*P2*DZ2*F1+P4*DZ4*F2
         R2=RCZ/RRZ
         F4=1.D0-RDZ*R2
         F5=F3+D2*ADZ*(FC*PE*(2.D0*AD+ADZ)+2.D0*PS)
         F6= F4+DZ2*AD*(FC*PE*(2.D0*ADZ+AD)+2.D0*PS)
         F7=DSQRT((F5/F6)*(F4/F3))
         F9=R1/R2
         F8=2.D0*F7*(1.D0+F7)*F9*AS
         ADZ=(-1.D0+F9-F9*((1.D0+F7)*AS)**2
     *       +(1.D0-F9*F7**2)*DZ2)/F8
         AD=AS*(1.D0+F7)+F7*ADZ
    1 CONTINUE
      R3=FM*AB*RE*RD*(1.D0+2.D0*P2*F1+P4*F2)*R1
      R4=FM*AB*RE*RDZ*(1.D0+2.D0*P2*F1+P4*F2)*R2
      A3=DSQRT(R3)
      IF (AC.LT.0.D0) A3=-A3
      A2=-FM*AB*RE*(1.D0+2.D0*P2*F1*RD*R1+P4*F2*RD*R1)
      RETURN
      END
C
	SUBROUTINE EILX(C,UDL,UDG,UDH,X)
	IMPLICIT REAL*8(A-H,O-Z),INTEGER*2(I-N)
	DIMENSION X(3),C(50)
	O=1.0D0
	W=2.00000D0
	OL=0.0D0
	FM=C(1)
	RZ=C(2)
	CJ2=C(3)
	SIG=C(4)
	A1=C(5)
	A2=C(6)
	A3=C(7)
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
	RXX=1.D0-AX**2
	RX=DSQRT(RXX)
	Z2=CJ2**2
	Z0=CJ2*SIG
C
	SP=DSIN(UDL)
	SE=SP
	CP=DCOS(UDL)
	CE=CP
	SF=OL
	CF=O
	EP=UDL
	EA=EP
	DO 11 J=1,15
		PUDL=EP-UDL
		SPP=W*SP*CP
		CPP=CP**2-SP**2
		SPR=W*SPP*CPP
		SFF=W*SF*CF
		CFF=CF**2-SF**2
		SFR=W*SFF*CFF
		EE=UDL+AZ*SE+ALAM*PUDL-AP1*SP-AP2*SPP
     *		-AF1*SF+AF2*SFF+AF3*(SF*CFF+CF*SFF)-AF4*SFR
		SE=DSIN(EE)
		CE=DCOS(EE)
		RB=O/(O-AX*CE)
		SP=RX*RB*SE
		CP=(CE-AX)*RB
		EP=EE+DATAN((SP*CE-CP*SE)/(CP*CE+SP*SE))
	EF=EP+UDG+OH*PUDL+AKP2*SPP+AKP4*SPR-AKF2*SFF+AKF4*SFR
		SF=DSIN(EF)
		CF=DCOS(EF)
	IF (DABS(EA-EE).LT.1.D-10) GO TO 111
   11		EA=EE
  111	BS=AB*(O-AE*CE)
	RT=O/(O-AT*CF)
	BT=RT*(-AS*CF+AG)
	R1=BS**2+Z2
	R2=O-BT**2
	R3=DSQRT(R1*R2)
	R4=-AC*CF+AQ
	R6=O/(R4**2+SF**2)
	R5=DSQRT(R6)
	BW=UDH+1.570796326794896D0+AMU*PUDL+AQ1*SF-AQ2*SFF
	BW=BW+AC1*SP+AC2*SPP+AC3*(SP*CPP+CP*SPP)+AC4*SPR
	SW=R4*R5
	CW=SF*R5
	SU=DSIN(BW)
	CU=DCOS(BW)
	X(1)=R3*(CW*CU-SW*SU)
	X(2)=R3*(CW*SU+SW*CU)
	X(3)=Z0+BS*BT
	RETURN
	END
C
	SUBROUTINE EMELD(C,A1,A2,A3,EDL,EDG,EDH)
	IMPLICIT REAL*8(A-H,O-Z),INTEGER*2(I-N)
	DIMENSION C(1),
     *		A(11),B(11),D(11),F(11),E(11),
     *		G(11),H(11),HH(11),G1(11),G2(11),
     *		BKS(11),BPS(11),U(11),P(11),V(11),
     *		BKS2(11),BKS4(11),BKS6(11),
     *		BKS8(11),BPS2(11),BPS3(11),
     *		BPS4(11),G3(11),G4(11),G5(11),
     *		TT(6),TD(10),UU(10,10),WW(10),
     *		AKP(5),AKF(5),AXX(6),VV(11),EE(11),
     *		AQF(10),ACP(10),AFF(10),APP(10)
	REAL*8 KA2
C
	FM=C(1)
	RZ=C(2)
	CJ2=C(3)
	SIG=C(4)
	OL=0.0D0
	O=1.0D0
	W=2.0D0
	T1=0.50D0
	T2=0.375D0
	T3=0.3125D0
	T4=0.2734375D0
	T5=2.4609375D-1
C
	M=3
	N=11
	N2=2
	N3=3
	N10=N-1
	N5=N10/2
	N9=N-2
	N8=N-3
	N7=N-4
	N6=N-5
	TT(1)=O
	TT(2)=T1
	TT(3)=T2
	TT(4)=T3
	TT(5)=T4
	TT(6)=T5
	DO 70 J=1,10
		R=J
   70		TD(J)=O/R
	DO 771 I=1,10
		DO 771 J=1,10
			UU(I,J)=OL
			IF (I.EQ.J) UU(I,J)=O
  771	CONTINUE
	WW(2)=W
	WW(4)=6.D0
	WW(6)=20.D0
	WW(8)=70.D0
	DO 72 K=2,8,2
		KK=K+1
		R=WW(K)
		DO 72 I=KK,10
			J=I-K
			II=I-1
			JJ=J+1
			RQ=R+UU(II,JJ)
			R=RQ
   72			UU(I,J)=RQ
	R=O
	DO 73 I=1,10
		DO 74 J=1,I
   74			UU(I,J)=R*UU(I,J)
   73		R=T1*R
	DO 75 I=2,10
		II=I-1
		DO 75 J=1,II
   75			UU(J,I)=UU(I,J)
C
	FEM=O/FM
	FA=-FM/A1
	AB=FA
C
	AN0=-A1*DSQRT(-A1)*FEM
C
	FE=-A2*FEM
	RE=-FE*A1*FEM
	P3=A3**2
	FD=-P3/A2
	RD=FD
	RDZ=FD
	PA=P3*FEM
	Z2=CJ2**2
	Z0=CJ2*SIG
	DO 10 J=1,7
		PE=CJ2/(AB*RE)
		P2=PE**2
		PS=PE*SIG
		P1=W*P2*(W-RE)
		P5=P2*RE
		P4=P5**2
		D2=O-RD
		AD=DSQRT(D2)
		RR=O+P1*D2+P4*D2**2
		RC=O-W*PS*AD-P5*D2
		RR=RC/RR
		RF=(O+P1+P4)*RR
		RT=O+(RF-RR)*RD
		DZ2=O-RDZ
		ADZ=-DSQRT(DZ2)
		RRZ=O+P1*DZ2+P4*DZ2**2
		RCZ=O-W*PS*ADZ-P5*DZ2
		RDZ=PA*RRZ/(AB*RE*(O+P1+P4)*RCZ)
		RD=FD*RT/RF
		AB=FA*(O-P5*RD*RR)
   10		RE=FE/(AB*RT)
	E2=O-RE
	AE=DSQRT(DABS(E2))
	AZ=-A1*AB*AE*FEM
	D2=O-RD
	AD=DSQRT(D2)
	DZ2=O-RDZ
	ADZ=-DSQRT(DZ2)
C
	X1=AB*(O-AE)
	X2=AB*(O+AE)
	AL1=-AB+FA
	BC=A2+P3
	PQ22=Z2*BC/(X1*X2*A1)
	BA=PQ22-AL1**2
	AKR=DSQRT((X2-AL1)**2+BA)
	BKR=DSQRT((X1-AL1)**2+BA)
	AG2=DSQRT(-A1*AKR*BKR)
	R1=AKR-BKR
	AX=R1/(AKR+BKR)
	AK22=((X2-X1)**2-R1**2)/(4.D0*AKR*BKR)
	APR=-FA*SIG/CJ2-T1*(ADZ+AD)
	DPR=BC/(A1*Z2*ADZ*AD)
	BPR=APR**2-DPR
	AKR=DSQRT(BPR-(AD-APR)**2)
	BKR=DSQRT(BPR-(ADZ-APR)**2)
	R1=AKR-BKR
	KA2=((AD-ADZ)**2+R1**2)/(4.D0*AKR*BKR)
	R2=O+KA2
	AK12=KA2/R2
	ABKR=O/(AKR+BKR)
	AG1=DSQRT(-A1*Z2*AKR*BKR*R2)
	AS=-(AKR*ADZ-BKR*AD)*ABKR
	AT=-R1*ABKR
	AG=(AKR*ADZ+BKR*AD)*ABKR
C
	S2=AS**2
	RS=O-S2
C
	AX2=AX**2
	R1=O
	AXX(1)=O
	DO 76 I=2,6
		R1=AX2*R1
   76		AXX(I)=R1
C
	AG22=AG**2
	ASAG=W*AS*AG
C
	DO 60 I=1,11
		A(I)=OL
		B(I)=OL
		D(I)=OL
		E(I)=OL
		U(I)=OL
		V(I)=OL
		VV(I)=OL
		EE(I)=OL
		BKS(I)=OL
		BPS(I)=OL
		BKS2(I)=OL
		BPS2(I)=OL
		F(I)=OL
   60		P(I)=OL
	DO 6060 I=1,10
		ACP(I)=OL
		AQF(I)=OL
		APP(I)=OL
 6060		AFF(I)=OL
C
	D(1)=O
	D(2)=-W*AT
	D(3)=AT**2
C
	A(1)=O
	A(2)=D(2)
C
	B(1)=O-AG22
	B(2)=D(2)+ASAG
	B(3)=D(3)-S2
C
	V(1)=AG22
	V(2)=-ASAG
	V(3)=S2
C
	VV(1)=+AG
	VV(2)=-AS
C
	R1=O
	E(1)=O
	EE(1)=O
	DO 77 I=2,N6
		R1=AT*R1
		EE(I)=R1
   77		E(I)=I*R1
C
	Q1=O/(O-AK22)
	QK=DSQRT(Q1)
	Q2=-AK22*Q1
	I=0
	RF=O
	RP=O
	QA=OL
	QB=OL
	DO 78 J=1,N,2
		I=I+1
		F(J)=TT(I)*RF
		P(J)=TT(I)*RP
		RF=AK12*RF
		RP=Q2*RP
		QA=QA+TT(I)*F(J)
   		QB=QB+TT(I)*P(J)
   78	CONTINUE
C
	AQK=QA
C
	QA=O/QA
	QQ=QK*QA*AG1/AG2
	AN=QQ*QB
	OH=AN-O
C
	DO 79 I=1,N5
		II=2*I
		RP=OL
		RF=OL
		DO 80 J=II,N10,2
			IJ=J+1
			RP=RP+UU(II,J)*P(IJ)
   80			RF=RF+UU(II,J)*F(IJ)
		AKP(I)=+TD(II)*QQ*RP
   79		AKF(I)=-TD(II)*QA*RF
C
	DO 61 J=M,N
   61		A(J)=D(1)*F(J)+D(2)*F(J-1)+D(3)*F(J-2)
	DO 62 II=M,N
		I=N-II+M
		L=I-M+1
		ULL=A(I)/B(M)
		U(L)=ULL
		K=I
		DO 63 JJ=1,M
			J=M-JJ+1
			A(K)=A(K)-B(J)*ULL
			K=K-1
   63		CONTINUE
   62	CONTINUE
C
	QQ=A3/AG1
	AQ0=OL
	I=0
	DO 51 J=1,N9,2
		I=I+1
   51		AQ0=AQ0+TT(I)*U(J)
	AQ0=QQ*AQ0
	DO 52 I=1,N8
		RR=OL
		DO 53 J=I,N8,2
			IJ=J+1
   53			RR=RR+UU(I,J)*U(IJ)
   52		AQF(I)=TD(I)*QQ*RR
C
	ABC1=DSQRT(B(1)-B(2)+B(3))
	ABC2=DSQRT(B(1)+B(2)+B(3))
	ABCS=ABC1+ABC2
	ABCR=ABC1-ABC2
	AGKR=4.D0/(ABCS**2-4.D0*B(3))
	SG=DSQRT(AGKR)
	TT1=T1
	IF (A3.LT.0.D0) TT1=-T1
	AC=TT1*SG*ABCS
	AQ=TT1*SG*ABCR
	ACW=TT1*ABCS
	AQW=TT1*ABCR
	AGW=O/SG
C
	Q1=O-AE*AX
	QR=O/Q1
	QE=-(AX-AE)*QR
C
	DO 66 I=1,11
		G1(I)=OL
   66		G2(I)=OL
	G1(1)=QR
	G1(2)=AX*QR
	R1=O
	DO 54 I=1,N6
		G2(I)=R1
   54		R1=QE*R1
C
	CALL ABBA(G1,G2,BKS,N2,N6,N7)
	CALL ABBA(BKS,BKS,BKS2,N7,N7,N8)
C
	AB22=O/AB**2
	Q2=-Z2*AB22
	QZ=O
	QQ=-A3*Z2*AB22*QK/AG2
	DO 7771 I=1,N
		BKS8(I)=BKS2(I)
 7771		BKS4(I)=BKS2(I)
C
	DO 772 K=4,N,2
		QZ=QZ*Q2
		CALL ABBA(BKS2,BKS8,BKS6,N8,N,N)
		DO 772 I=1,N
			BKS4(I)=BKS4(I)+QZ*BKS6(I)
  772			BKS8(I)=BKS6(I)
C
		DO 71 I=1,N
			QU=BKS4(I)
   71			U(I)=QQ*QU
		CALL ABBA(U,P,G,N,N,N)
C
		AC0=OL
		I=0
		DO 55 J=1,N,2
			I=I+1
   55			AC0=AC0+TT(I)*G(J)		
		DO 56 I=1,N10
			RR=OL
			DO 57 J=I,N10,2
				IJ=J+1
   57				RR=RR+UU(I,J)*G(IJ)
   56			ACP(I)=TD(I)*RR
C
	BPS(1)=2.D0*AL1/AB
	PQ22=PQ22*AB22
	DO 67 I=1,N
   67		BPS(I)=BPS(I)-PQ22*BKS(I)
	CALL ABBA(BPS,BPS,BPS2,N7,N7,N8)
	DO 667 I=1,N
  667		BPS4(I)=T2*BPS2(I)
C
	CALL ABBA(BKS,BPS,G3,N7,N7,N)
C
	IF (N.LE.5) GO TO 68
	CALL ABBA(BPS,BPS2,BPS3,N7,N8,N9)
	CALL ABBA(BKS,BPS3,G4,N7,N9,N)
C
	DO 6667 I=1,N
 6667		BPS4(I)=BPS4(I)+T3*G4(I)
	IF (N.LE.7) GO TO 68
C
	II=4
	DO 668 K=8,N,2
		II=II+1
		CALL ABBA(G3,G4,G5,N,N,N)
		DO 668 I=1,N
			G4(I)=G5(I)
  668			BPS4(I)=BPS4(I)+TT(II)*G5(I)
C
   68	CONTINUE
C
	BPS4(1)=-T1*PQ22+BPS4(1)
	BX2=DSQRT(O-AX2)
	BETA=AX/(O+BX2)
	BETW=O-BETA**2
	BETZ=AZ*BETW
	RX=-A1*FEM*AB*BX2*QR
	QQ=Z2*AN0/AG1
C
	CALL ABBA(G2,BPS4,H,N6,N,N)
	CALL ABBA(V,E,G,N3,N6,N8)
	CALL ABBA(G,F,HH,N8,N,N)
C
	DO 69 I=1,N
		HH(I)=QQ*HH(I)
   69		H(I)=RX*H(I)
C
	I=0
	AF0=OL
	AP0=OL
	DO 58 J=1,N,2
		I=I+1
		AP0=AP0+TT(I)* H(J)
   58		AF0=AF0+TT(I)*HH(J)
	DO 59 I=1,N10
		RP=OL
		RF=OL
		DO 559 J=I,N10,2
			IJ=J+1
			RP=RP+UU(I,J)* H(IJ)
  559			RF=RF+UU(I,J)*HH(IJ)
		APP(I)=TD(I)*RP
   59		AFF(I)=TD(I)*RF
C
	I=0
	DO 41 J=2,N8,2
		I=I+1
		AQF(J)=AQF(J)+AQ0*AKF(I)
		ACP(J)=ACP(J)+AQ0*AKP(I)
		AFF(J)=AFF(J)+AF0*AKF(I)
   41		APP(J)=APP(J)+AF0*AKP(I)
C
	DO 3210 I=1,N
		G4(I)=BPS(I)
 3210		BPS4(I)=T1*BPS(I)
C
	II=2
	DO 3211 K=4,N,2
		II=II+1
		CALL ABBA(G3,G4,G5,N,N,N)
		DO 3211 I=1,N
			G4(I)=G5(I)
 3211			BPS4(I)=BPS4(I)+TT(II)*G5(I)
C
	CALL ABBA(G2,BPS4,H,N6,N,N)
	CALL ABBA(VV,EE,G,N2,N6,N8)
	CALL ABBA(G,F,HH,N8,N,N)
C
	ODA1=O/DSQRT(-A1)
	RX=ODA1*DSQRT(O-AX2)*QR
	QQ=O/AG1
C
	DO 3214 I=1,N
		HH(I)=QQ*HH(I)
 3214		H(I)=RX*H(I)
C
	I=0
	APP0=ODA1
	AFF0=OL
	DO 3215 J=1,N,2
		I=I+1
		AFF0=AFF0+TT(I)*HH(J)
 3215		APP0=APP0+TT(I)*H(J)
C
	AMU=AC0+AN*AQ0
	ALAM=-AP0-AN*AF0
C
	RLAM=O/(O-ALAM)
	ANR=AN0*RLAM
C
	EDH=A3
	EDG=(A1/AN0)*AF0+(-A2/AG1)*AQK-AQ0*EDH-W*FM*Z0*AFF0
	EDL=(A1/ANR)-OH*EDG-AMU*EDH+W*FM*APP0-W*FM*Z0*AN*AFF0
C
	C(5)=A1
	C(6)=A2
	C(7)=A3
	C(8)=AB
	C(9)=AE
	C(10)=AS
	C(11)=AC
	C(12)=AX
	C(13)=AG
	C(14)=AT
	C(15)=AQ
	C(16)=AG1
	C(17)=AG2
	C(18)=AK12
	C(19)=AK22
	C(20)=AZ
	C(21)=AN
	C(22)=AMU
	C(23)=ALAM
	C(24)=ANR
	C(25)=ANR*OH
	C(26)=ANR*AMU
	C(27)=AN0
	C(28)=OH
	C(29)=AQ0
	C(30)=AF0
	C(31)=AC0
	C(32)=AP0
	C(33)=RLAM
	C(34)=BETA
	C(35)=AGW
	C(36)=ACW
	C(37)=AQW
	C(38)=BETW
	C(39)=BETZ
	DO 42 I=1,5
		I1=40+I
		I2=45+I
		C(I1)=AKF(I)
   42		C(I2)=AKP(I)
	DO 43 I=1,10
		I1=50+I
		I2=60+I
		I3=70+I
		I4=80+I
		C(I1)=AQF(I)
		C(I2)=ACP(I)
		C(I3)=AFF(I)
   43		C(I4)=APP(I)
	RETURN
	END
C
	SUBROUTINE ABBA(A,B,C,K,L,M)
	IMPLICIT REAL*8(A-H,O-Z),INTEGER*2(I-N)
	DIMENSION A(11),B(11),C(11)
	DO 9 N=1,11
    9		C(N)=0.D0
	DO 1 N=1,M
		DO 2 I=1,N
			J=N-I+1
			IF (I.GT.K) GO TO 3
			IF (J.GT.L) GO TO 4
			C(N)=C(N)+A(I)*B(J)
    4			CONTINUE
    2		CONTINUE
    3		CONTINUE
    1	CONTINUE
	RETURN
	END
C
	SUBROUTINE FAREL(IW,IP,IH,IT,CFS,HS,SH,LI,DR)
	IMPLICIT REAL*8(A-H,O-Z),INTEGER*2(I-N)
C
	RIP=0.1D0*IP
	RIH=IH
	RIT=0.1D0*IT
C
	IF (IW.NE.0) GO TO 1
		IF (LI.EQ.0) IW=6943
		IF (LI.EQ.1) IW=5320
		IF (IW.EQ.0) RETURN
    1	WW=1.D-4*IW
	WW=1.D0/WW
	W2=WW**2
	FL=0.9650D0+(0.0164D0+0.000228D0*W2)*W2
	FFH=1.D0-0.0026D0*CFS-0.31D-6*HS
C
	TC=RIT-273.15D0
	STEP=7.5D0*TC/(237.3D0+TC)
	Q=(10.0D0)**STEP
	QE=6.11D-2*RIH*Q
C
	QK=1.163D0-0.00968D0*CFS-0.00104D0*RIT+0.1435D-4*RIP
	RK=2.D0/(3.D0-1.D0/QK)
C
	A=0.002357D0*RIP+0.000141D0*QE
	B=1.084D-8*RIP*RIT*QK+4.734D-8*RIP**2*RK/RIT
C
	AB=A+B
	RR=(B/AB)/(SH+0.01D0)
	DR=(FL/FFH)*AB/(SH+RR)
C
	RETURN
	END