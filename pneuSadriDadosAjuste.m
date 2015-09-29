%% Dados pneu Sadri - Ajuste
% Determina��o dos valores dos par�metros para o modelo de pneu sadri. Os
% dados s�o obtidos a partir do ajuste da inclina��o para �ngulo igual a
% zero e for�a lateral m�xima.
%
%% Dados
% Os par�metros dos eixos dianteiros e traseiros visam ser equivalentes a
% um modelo de <pneuPacejkaFun.m pneuPacejka>. Isto � feito impondo as
% seguintes caracter�sticas:
%
% * Mesmo coeficiente de rigidez de curva para angulos de deriva pequenos
% * Mesma for�a lateral m�xima
%
% Como o modelo aqui � dado por:
%
% $$ F_y = k_1 \alpha  - k_2\alpha^3 $$
%
% A derivada de $ F_y $ com rela��o a $\alpha$:
%
% $$ \frac{dF_y}{d \alpha} = k_1 - 3 k_2 \alpha^2 $$
%
% Logo, para $\alpha = 0$:
%
% $$ \left. \frac{dF_y}{d \alpha} \right|_{\alpha = 0} = k_1 $$
%
% Portanto, $k_1$ � o pr�prio coeficiente de rigidez de curva para pequenos
% �ngulos.
%
% Como o valor de m�xima for�a lateral $F_{ymax}$ ocorre no �ngulo em que
% $\frac{dF_y}{d \alpha} = 0$ temos que este �ngulo � dado por:
%
% $$ \alpha_{max} = \sqrt{\frac{k_1}{3 k_2}}$$
%
% Manipulando as equa��es, o valor de $k_2$ que fornece a mesma for�a
% lateral m�xima no modelo de Sadri � dado por:
%
% $$k_2 = (4*k1^3)/(27*FyMax^2) $$
% 
% Onde $FyMax$ � o valor da for�a lateral m�xima do modelo em rela��o ao
% qual se deseja obter a equival�ncia, neste caso, <pneuPacejkaFun.html
% pneuPacejka>
% 
%% Modelo de refer�ncia
% O modelo de refer�ncia usado � o modelo de pneu Pacejka que tem os
% seguintes dados:

pneuPacejkaDados

%% C�digo e dados
% C�digo dos dados:

FyMaxF = muy*FzF; % For�a lateral m�xima
FyMaxR = muy*FzR; % For�a lateral m�xima

CfaF = c1F*c2F*Fz0*sin(2*atan(FzF/(c2F*Fz0))); % Cfa em fun��o de Fz
CfaR = c1R*c2R*Fz0*sin(2*atan(FzR/(c2R*Fz0))); % Cfa em fun��o de Fz

Cfa0F = c1F*c2F*Fz0*sin(2*atan(Fz0/(c2F*Fz0))); % Cfa para Fz0
Cfa0R = c1R*c2R*Fz0*sin(2*atan(Fz0/(c2R*Fz0))); % Cfa para Fz0

Dy0 = muy0*Fz0;

By0F = Cfa0F/(CyF*Dy0); % Stiffness factor
By0R = Cfa0R/(CyR*Dy0); % Stiffness factor

% Modelo Sadri Equivalente
k1F = CyF*By0F*Dy0;
k2F = (4*k1F^3)/(27*FyMaxF^2);
k1R = CyR*By0R*Dy0;
k2R = (4*k1R^3)/(27*FyMaxR^2);

pneuDadosFrente = [k1F k2F];
pneuDadosTras = [k1R k2R];

%% Ver tamb�m
%
% <index.html In�cio> | <pneuDoc.html Modelo de pneu>
%