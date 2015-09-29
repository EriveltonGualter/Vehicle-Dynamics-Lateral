%% Dados pneu linear
% Determina��o dos valores dos par�metros para o modelo de pneu sadri
%
%% Dados
% Os dados apresentados aqui s�o obtidos a partir do coeficiente de rigidez
% de curva do modelo de pneu <pneuPacejkaFun.m pneuPacejka>.
%
% O modelo de pneu linear � dado por:
%
% $$ F_y = C \alpha $$
% 
% A Magic Formula � dada por:
%
% $$ F_y = D \sin(C \arctan(B \alpha - E (B \alpha - \arctan(B \alpha))))$$
%
% � poss�vel mostrar que:
%
% $$ C = B C D $$
%
%% Modelo de refer�ncia
% O modelo de refer�ncia usado � o modelo de pneu Pacejka que tem os
% seguintes dados:

pneuPacejkaDados

%% C�digo
% C�digo dos dados:

CfaF = c1F*c2F*Fz0*sin(2*atan(FzF/(c2F*Fz0))); % Cfa em fun��o de Fz
CfaR = c1R*c2R*Fz0*sin(2*atan(FzR/(c2R*Fz0))); % Cfa em fun��o de Fz

Cfa0F = c1F*c2F*Fz0*sin(2*atan(Fz0/(c2F*Fz0))); % Cfa para Fz0
Cfa0R = c1R*c2R*Fz0*sin(2*atan(Fz0/(c2R*Fz0))); % Cfa para Fz0

Dy0 = muy0*Fz0;

By0F = Cfa0F/(CyF*Dy0); % Stiffness factor
By0R = Cfa0R/(CyR*Dy0); % Stiffness factor

% Coeficientes utilizados no modelo linear
Cf = By0F*CyF*Dy0; % Coeficiente de rigidez de curva [N/rad] 
Cr = By0R*CyR*Dy0; % Coeficiente de rigidez de curva [N/rad] 

pneuDadosFrente = [Cf];
pneuDadosTras = [Cr];

%% Ver tamb�m
%
% <index.html In�cio> | <pneuDoc.html Modelo de pneu>
%