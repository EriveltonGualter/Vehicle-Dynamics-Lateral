%% Pneu Pacejka
% Rela��o n�o linear entre a for�a lateral e o �ngulo de deriva.
%
%% Sintaxe
%  Fy = pneuPacejkaFun(deriva,pneuDados)
%
%% Argumentos
% Lista de entradas da fun��o:
%
% <html> <table border=1 width="97%"> <tr> <td
% width="30%"><tt>deriva</tt></td> <td width="70%">�ngulo de deriva do
% pneu. �ngulo formado entre o vetor velocidade e o plano longitudinal do
% pneu.</td> </tr> <tr> <td><tt>pneuDados</tt></td> <td>Vetor com os dados
% do pneu: <tt>[Fz0 muy0 Cy Ey c1 c2 Fz muy]</tt> </table> </html>
% 
% Lista de sa�das da fun��o:
%
% <html> <table border=1 width="97%"> <tr> <td width="30%"><tt>Fy</tt></td>
% <td width="70%">For�a lateral do pneu.</td></tr></table> </html>
%  
%% Dados
% Dados dispon�veis para este modelo:
%
% * <pneuPacejkaDados.html pneuPacejkaDados>
%
%% Modelo
%
% *Equacionamento*
%
% A equa��o que descreve este modelo � dada por:
%
% $$ F_y = - \frac{\mu_y}{\mu_{y0}} \frac{F_z}{F_{z0}} F_{y0}; $$
%
% A equa��o caracter�stica � dada por:
%
% $$ F_{y0} = D \sin(C \arctan(B \alpha_{eq} - E (B \alpha_{eq} - \arctan(B \alpha_{eq})))) $$
%
% Onde $F_{y0}$ � a for�a lateral nominal e $\alpha_{eq}$ � o �ngulo de
% deriva equivalente. $B$, $C$, $D$ e $E$ s�o coeficientes obtidos
% experimentalmente. As equa��es auxiliares s�o mostradas abaixo.
%
% $$ C_{f \alpha} = c_1 c_2 F_{z0} \sin \left( 2 \arctan \left( \frac{F_z}{c_2 F_{z0}} \right) \right) $$
%
% $$ C_{f \alpha 0} = c_1 c_2 F_{z0} \sin \left( 2 \arctan \left( \frac{F_{z0}}{c_2 F_{z0}} \right) \right) $$
%
% $$ \alpha_{eq} = \frac{C_{f \alpha}}{C_{f \alpha 0}} \frac{\mu_{y0}}{\mu_y} \frac{F_{z0}}{F_z} \alpha $$
%
% $$ D = \mu_{y0} F_{z0} $$
%
% $$ B = \frac{C_{f \alpha 0}}{C*D} $$
%
% *Hip�teses*
%
% * Rela��o n�o linear.
% * V�lido at� 90 graus de �ngulo de deriva.
%
%% C�digo
% C�digo da fun��o:
function Fy = pneuPacejkaFun(deriva,pneuDados)

% Par�metros nominais
Fz0 = pneuDados(1);
muy0 = pneuDados(2);

% Par�metros do pneu frente
Cy = pneuDados(3);
Ey = pneuDados(4);
c1 = pneuDados(5);
c2 = pneuDados(6);

% Condi��es de opera��o
Fz = pneuDados(7); 
muy = pneuDados(8);

% �ngulo de deriva
ALPHA = deriva; % [rad]

% Modelo de pneu
Cfa = c1*c2*Fz0*sin(2*atan(Fz/(c2*Fz0))); % Cfa em fun��o de Fz

Cfa0 = c1*c2*Fz0*sin(2*atan(Fz0/(c2*Fz0))); % Cfa para Fz0

alphaeq = Cfa/Cfa0*muy0/muy*Fz0/Fz*ALPHA; % alpha equivalente

Dy0 = muy0*Fz0;

By0 = Cfa0/(Cy*Dy0); % Stiffness factor

Fy0 = Dy0*sin(Cy*atan(By0*alphaeq-Ey*(By0*alphaeq-atan(By0*alphaeq))));

Fy = -muy/muy0*Fz/Fz0*Fy0;
end
%% Ver tamb�m
%
% <index.html In�cio> | <pneuDoc.html Modelo de pneu>
% 