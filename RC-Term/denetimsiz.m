%*******************************************
%  SISTEM SIMULASYONU              
%*******************************************
% SISTEM 192 - RC Circuit - Dorf (page 176)
%******************************************* 
clear ; clc % Hafizayi ve ekrani temizle
A=[ -2 -25;
    1 0 ];
B=[1 0;
   0 0];
C=[ 0 5]; 
D=0;
% initials for simulation
x10=0; x20=0; u1=10; u2=10; dt=0.01; tend=10;
t0=0; k=1; % k is dimension counter

U0=[u1;u2];
LENGTHMATRIX=size(A);  
LS=LENGTHMATRIX(1); 
LK=LENGTHMATRIX(2);

x0 = zeros(1,LS);
r0=2;

	EMAX  = r0;        EMIN  = -EMAX;
	DEMAX = EMAX/10;   DEMIN = -DEMAX;
	DUMAX = 1;         DUMIN = -1;

   NLe=EMIN;   NTe=NLe;    NRe=0; 
   SLe=NTe;    STe=0;      SRe=EMAX;
   PLe=STe;    PTe=EMAX;   PRe=PTe;
  
   NLde=DEMIN;     NTde=NLde;     NRde=0;
   SLde=NTde;      STde=0;        SRde=DEMAX;
   PLde=STde;      PTde=DEMAX;    PRde=PTde;

   NLdu=DUMIN;       NTdu=DUMIN;    NRdu=0;
   SLdu=NTdu;        STdu=0;        SRdu=DUMAX;
   PLdu=STdu;        PTdu=DUMAX;    PRdu=PTdu;
   % Baslangic ve hata degerleri:  
   ee=EMAX;   dee=0;  E=EMAX;  dE=0;    
   e0=EMAX;   e(1)=0; e(2)=0;  de=e(2)-e(1); 
   C(1)=0;

% DU matrisi:
     DU=[ NTdu NTdu STdu
          NTdu STdu PTdu
          STdu PTdu PTdu ];

% Cozum
while t0<tend-dt

      E=limiter(EMIN,EMAX,ee);%---------- limit E 
      FSE(1)=ucgen(NLe,NTe,NRe,E);
      FSE(2)=ucgen(SLe,STe,SRe,E);
      FSE(3)=ucgen(PLe,PTe,PRe,E);
      DE=limiter(DEMIN,DEMAX,dee); %----- limit DE 
      FSDE(1)=ucgen(NLde,NTde,NRde,DE);
      FSDE(2)=ucgen(SLde,STde,SRde,DE);
      FSDE(3)=ucgen(PLde,PTde,PRde,DE);

     i=length(FSE);
     j=length(FSDE);
     NM=i*j;
     sa=1;
     for as=1:i
        for yu=1:j
            FSDU(sa)=min( [FSE(as) FSDE(yu)] );
            sa=sa+1;
        end
     end
     sa=1;
     for as=1:N1
         for yu=1:N2
             DDU(sa)=FSDU(sa)*DU(as,yu);
             sa=sa+1;
         end
      end
      DUTOP1 = sum(DDU) ;            
      DUTOP2 = sum(FSDU);
      DV = (DUTOP1/DUTOP2);

     C(k+1) = C(k) + DV;
     CC=limiter(0,DUMAX,C(k+1));                    
     UU0 = CC*U0;
     [x]=runge(A,B,U0,x0,dt);
     UU(k)=UU0(1);
     t(k)=t0+dt;    
     t0=t(k);
     r(k)=r0;       
     y(k)=2*x0(1)+4*x0(2);  
	 x1(k)=x(1); x2(k)=x(2);
     e(k)=r(k)-y(k);    de(k)=e(k)-e0;
     ee=e(k);  dee=de(k);   e0=e(k);   duty(k)=CC;
      for i=1:LS
           x0(i)=x(i);  XX(k,i)=x(i); 
      end
      k=k+1;
end;
%*******************************************
% Grafiklerin Cizimi                       %
%*******************************************
subplot(411)
plot(t,x1); xlabel('Zaman (sn)'); ylabel('x1');grid
subplot(412)
plot(t,y,t,r,t,e); xlabel('Zaman (sn)'); ylabel('y');grid
subplot(413)
plot(t,x2);  xlabel('Zaman (sn)');  ylabel('x2'); grid