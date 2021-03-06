



        ����� ���p��p���᪮�� ��⠫��� � ����筮� �p��
        ��������������������������������������������������




#ifndef BDATADEF_H
#define BDATADEF_H

#include "miscdefs.h"

                       ����筠� ������
                       ���������������

typedef struct		{
	LONG	N;			   H���p � 䫠�� ��� ����� � 楫��
	LONG	X;                         ���p������ (� �p��������� ����)
	LONG	Y;                         � �� 䫠��
	WORD	E;			   �業�� �p���� � �� 䫠��
			} B_RECORD;

#define N_FLAG_BITS	10



                                H����
                                �����


   	H���p ��⮨� �� ᮡ�⢥��� ��室���� ����p� � 䫠���. ��室�� ��-
   ��p 㬭������� �� 10, ��᫥ 祣� � ���� �p��������� �������⥫�� ����p
   (�� �������� � ⮬ ��砥, �᫨ ������ ���� �������⥫쭮�). �����
   ��p����, ������ � ��室�� ����p�� 34571 �㤥� ����� ����p 345710, � ��-
   �����⥫쭠� (����� �� ���) ������ ����p 34571A �㤥� ����� ����p
   345711.
  	����� �������� ����訥 10 ��� ����p�. ��室�� ����p ����� �������
   �� �p�㫥
  	N = (r.N >> 10)/10 ( ��� N = (r.N shr 10) div 10 �� ��᪠�� )
   �ᯮ�짮����� 10 ��� ��� 䫠��� ��⠢��� �� ����p 22 ���, �.�. ����-
   ����� �����⨬� ����p ���� 4194300 ( �⮣�, ��-��������, �����筮,
   ��᪮��� ⮬� ᮤ�p��� ���ᨬ� 100000 ����ᥩ).
  	����訩 ��� ����p� ᮤ�p��� 0, �᫨ ������ �p������ ��� ��p���⪨
   (�⮦��᢫���� � GSC) � 1 � �p�⨢��� ��砥 (��� �, �᫨ ��� ������ ���
   ����� ��������� ��� �������� ���宣� ����⢠).
  	��⠫�� 䫠�� � �᭮���� �� ����� �⭮襭�� � ��p���⪥.
        ��� 4 ����p� p���� 1, �᫨ � ���� '�業�� �p����' ��⠢����
   �������� ����稭� ( 7 ��� 14 ).



#define C_FLAG_BITS 4
#define VOL_COOR(OC,SHIFT,SCALE) ((OC)/(SCALE)+(SHIFT))
#define RED_COOR(VC,SHIFT,SCALE) (((VC)-(SHIFT))*(SCALE))




                               ������H���
                               ����������


  	���� "���p�����" (X ��� Y) ��⮨� �� ᮡ�⢥��� ���p������ � 䫠-
   ���. ����� �������� ����訥 4 ���. ��� �p���p����� ����⢮ ������:
  		0 - �� � ��p浪�
  		1 - ����� ���������
  		2 - ��� ������
  		3 - ����� ��p������ (�� �⭮襭�� � ⮬�)
  		4 - ���祭�� (� ⮬�) �� �� ��p浪�
  	���p������ �p������ �p�������묨 � �⠭��p⭮� ��⥬� ( 業�p �
   ����᪮� 業�p� ����⨭��, ��� X � ���⮪� �� �����, ��� Y � ��� ��
   ����p). �p�������� �������� �� �p�㫠�:
   	�᫨ ���. ���p������ (� ⮬�)SX, SY, � ��室�� OX, OY, �
   	OX = ( SX - XSHIFT ) * XSCALE
  	OY = ( SY - YSHIFT ) * YSCALE ,
   � �����p��
   	SX = OX / XSCALE + XSHIFT,
  	SY = SY / YSCALE + YSHIFT,
   �p�祬
  	xShift = (xMin+xMax) / 2.0, xScale = (130.0 / (xMax-xMin)) * 10 ** P,
  	yShift = (yMin+yMax) / 2.0, yScale = (130.0 / (yMax-yMin)) * 10 ** P,
        P      = 4 - �᫮ ������ ��᫥ ����⮩

   �� �⭮���� � ����, ����� xMax-xMin < 130.0; � �p�⨢��� ��砥
   ����⠡�p������ �� �p����������

   ����稭� xShift, yShift, xScale, yScale �p������ � ��������� ����⨭��.


#define E_FLAG_BITS 4




                              ���H�� �������
                              ��������������


  	��� � � ��砥 � ���p����⠬�, �p������ ��室��� �業�� �p����
   � 䫠��.
  	���祭�� 䫠���:
  		0 - ��p���쭮
  		1 - ����� ���������
  		2 - ��� ������
  		3 - ����� ��p������ (�� �⭮襭�� � ⮬�)
  		4 - �業�� �p���� � ⮬� ᮤ�p���� ᪮���, �� ���筮
  		    ����砥� ���� �� ���� - ���� �業�� �p���� ��� ������
  		    ������ ���� � �p㣮� ��⥬�, ���� �業�� �p����
  		    (� ���� ����� � ���p������) �������� ���宣� ����⢠.





   �����, �⭮��騥�� � ����� � 楫��
   �����������������������������������

#define RECORD_OK		0     �������� ��p���⪥
#define RECORD_UNUSABLE		1     H� �������� ��p���⪥
#define RECORD_BADQUALITY       2     �p����� ���宣� ����⢠ - ����
				      ���⠢��� ᫨�訬�� ������ �������
#define RECORD_NONSTAR          4     H� ������ �� ����� ⮬�

   �����, ��騥 ��� ��� ����� (���p������/�業�� �p����)
   ������������������������������������������������������

#define FIELD_OK	 0		   H�p���쭮
#define FIELD_UNRELIABLE 1                 H�������� �����
#define FIELD_NODATA 	 2                 H�� ������
#define FIELD_CHANGED	 4                 ���ᥭ� ��������� �� �p������� � ⮬��

#define FIELD_C_BADORDER 8                 ��� ���p�����
#define FIELD_E_BRACKETS 8                 ��� �業�� �p����





             ������  ������  �  �����  ������H��  -  ������H��
             �������������������������������������������������


             ��� � ��������� �����H��� ����� ��HH�� ������H��
             ������������������������������������������������

  	��� ����筮�� 䠩�� ��p������ �� �p���� ᪫������, �ᮢ � �����
   �pאַ�� ���宦����� 業�p�, ����ᨬ���쭮�� ������ (�. ����) � ��������
   ����. �p���p: ����⨭�� ���� ����p, 業�p D=+01, RAh=0, RAm=04, Tag='A';
   ��� 䠩��: N01A0004.ALG

     ��������� ����筮�� 䠩�� (��p�� 14 ����) ᮤ�p���:
     ���������������������������������������������������
       ����                      ᮤ�p�����
       ----                      ----------

  	1		����p ���� (���p���p��, �. ⠡���� ����)

  	2		�p���� ᪫������ 業�p� + 90
  	3		��� �pאַ�� ���宦����� 業�p�
  	4		������ �pאַ�� ���宦����� 業�p�

  	5		�᫮       �
  	6		�����       ���> ���� �������
  	7		��� - 1800  �

  	8		������ ����⨭��

  	9               ��
  	10		�����      �
  	11		ᥪ㭤�     �
  	12		�᫮       ���> ᮧ����� 䠩��
  	13		�����       �
  	14		��� -1800   �

  	����� ��p����, �᫮ ����ᥩ � 䠩�� �� ������� ����� �᫠ �����
     �� ����⨭��.



������������������������������������������������������������������������������



               ��������� ������H�� � ����� "������ ������H��"
               ���������������������������������������������


   ��� 䠩�� ᯨ᪠ ����⨭�� ��⠢����� �� �p���� ᪫������ � ᮪p�饭-
   ���� �������� ���� (�. ⠡���� ����). H��p���p, ⠪�� 䠩� ��� ����⨭��
   � D=+1 ����p᪮� ���� �㤥� ���뢠���� "N01PLIST.ALG"


typedef struct			{

	BYTE	ZoneNo		;  	   H���p ���� (�. ������� ����)
	INT	DCg   		;
	BYTE	RAh, RAm	;
	BYTE	Day, Mon	;
	INT	Year		;

   ��᪮��� ���������� ����⨭�� � ��������묨 業�p���, �p��������騥 �����
   ����, �㦥� �p�����, �� p������騩 (��� p����� ��� �� ���⨣����� � ����-
   ��� ����p� ����). ����쭮 ����⨭�� �������筮 ����뢠���� 業�p�� � ��⮩,
   ������ �p� �p��p������ ����� ����筮�� 䠩�� �㦥� ����ᨬ����� �p�����.
   ��� ��:

	Char	Tag		;

   ����� ���祭�� 'A', 'B', 'C' � �.�. ( �� ᠬ�� ���� ����� �p�� ����⨭��
   � ��������� 業�p�� � �� ���p�砫).

	WORD	RecCount	;

	Double	xScale		,
		yScale		,
		xShift		,
		yShift		;

	BYTE	meType		,	   0 �᫨ ������p � 1 �᫨ ����稭�
		meTable		,          ��� ����p��� ��� �� ����� ���祭��
		meTblInd	;	   ����⮢���� ��p�� ��� �� ���.



				} B_PLATE_INFO;




            ������ ��� (� ��᫥ ���p���p��)
            ����������������������������������

  	01  -90  -65  �����p�      Melbourne     MLB
  	02  -64  -52  ������        Sydney        SYD
  	03  -51  -41  ���           Cape          CAP
  	04  -40  -32  ��p�          Perth         PRT
  	05  -31  -24  ��p����       Cordoba       CRD
  	06  -23  -17  �.�����p����  S.Hyderabad   SHY
  	07  -16  -10  ���㡠��      Tacubaya      TCB
  	08  -09  -03  ���-��p�����  San-Fernando  SNF
  	09  -02  +04  ����p         Algiers       ALG
  	10  +05  +11  ��㧠        Toulouse      TLS
  	11  +11  +17  ��p��         Bordeaux      BRD
  	12  +18  +24  ��p��         Paris         PAR
  	13  +25  +33  ����p�       Oxford        OXF
  	14  +34  +35  ����          Uccles        UCL
  	15  +36  +39  �.�����p����  N.Hyderabad   NHY
  	16  +40  +46  ����ᨭ��     Helsingfors   HLS
  	17  +47  +54  ��⠭��       Catania       CAT
  	18  +52  +64  ��⨪��       Vatican       VAT
  	19  +65  +90  �p�����       Greenwich     GRN


#endif