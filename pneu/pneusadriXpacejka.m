clear,clc,close all
%% Descri��o
% O objetivo deste script � obter uma curva caracteristica atraves do modelo de pacejka porem equivalente ao usado por sadri.
% A equivalencia � obtida mantendo:
%     * Coeficiente de rigidez de curva para pequenos angulos
%     * Forca lateral maxima

%% Dados gerais
alpha = (0:0.1:25)*pi/180; % �ngulo de deriva

%% Pneu Sadri e Wu 2013
% Par�metros do pneu
Caf = 57300; % Par�metro do pneu [N/rad]
kf = 4.87; % Par�metro do pneu

% For�a lateral do modelo de Sadri
Fy = 2*Caf*(alpha-kf*alpha.^3);

% Forca do modelo linear equivalente
Fylin = 2*Caf*alpha;

Fymax = max(Fy);

%% For�a lateral do modelo de Pacejka

% Condi��es nominais
muy0 = 0.8;
Fz0 = Fymax/muy0; % Carga vertical inicial

% Condi��es de opera��o
muy = muy0;
FzF = Fz0;

% Par�metros do pneu
Cy = 1.3;
Ey = -1;
%c1 = 3.8;

c2 = 1.33;
% c1 calculado de maneira que a inclina��o para pequenos angulos seja a
% mesma
c1 = 2*Caf/(c2*Fz0*sin(2*atan(FzF/(c2*Fz0))));

% Redefinindo os DADOS
muy0 = 0.8;
Fz0 = 2.4985e+04;
muy = muy0;
FzF = Fz0;
Cy = 1.5;
Ey = -2;
c1 = 3.5899;
c2 = 1.33;

% �ngulo
ALPHAF = alpha;

CfaF = c1*c2*Fz0*sin(2*atan(FzF/(c2*Fz0))); % Cfa em fun��o de Fz

Cfa0 = c1*c2*Fz0*sin(2*atan(Fz0/(c2*Fz0))); % Cfa para Fz0

alphaeqF = CfaF/Cfa0*muy0/muy*Fz0/FzF*ALPHAF; % alpha equivalente

Dy0 = muy0*Fz0;

By0 = Cfa0/(Cy*Dy0); % Stiffness factor

Fy0F = Dy0*sin(Cy*atan(By0*alphaeqF-Ey*(By0*alphaeqF-atan(By0*alphaeqF))));

FyF = muy/muy0*FzF/Fz0*Fy0F;

%% Resultados

figure(1)
hold on
plot(ALPHAF*180/pi,FyF,'r')
plot(alpha*180/pi,Fy,'g')
plot(alpha*180/pi,Fylin,'--g')
title('Curva caracter�stica')
xlabel('angulo de deriva [grau]')
ylabel('Forca lateral [N]')
legend('Pacejka','Sadri','Sadri linear')

