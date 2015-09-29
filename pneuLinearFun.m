%% Pneu linear
% Rela��o linear entre a for�a lateral e o �ngulo de deriva
%
%% Sintaxe
% |Fy = pneuLinearFun(deriva,pneuDados)|
%
%% Argumentos
% Lista de entradas da fun��o:
%
% <html> <table border=1 width="97%"> <tr> <td
% width="30%"><tt>deriva</tt></td> <td width="70%">�ngulo de deriva do
% pneu. �ngulo formado entre o vetor velocidade e o plano longitudinal do
% pneu.</td> </tr> <tr> <td><tt>pneuDados</tt></td> <td>Vetor com os dados
% do pneu: <tt>C</tt> </td> </tr> </table> </html>
% 
% Lista de sa�das da fun��o:
%
% <html> <table border=1 width="97%"> <tr> <td width="30%"><tt>Fy</tt></td>
% <td width="70%">For�a lateral do pneu.</td></tr></table> </html>
% 
%% Dados
% Dados dispon�veis para este modelo:
%
% * <pneuLinearDados.html pneuLinearDados> (Linear)
%
%% Modelo
%
% *Equacionamento*
%
% A equa��o que descreve este modelo � dada por:
%
% $$ F_y = C \alpha $$
%
% Onde $F_y$ � a for�a lateral, $C$ � o coeficiente de rigidez de curva e
% $\alpha$ � o �ngulo de deriva.
%
% *Hip�teses*
%
% * Rela��o linear.
% * V�lido apenas para pequenos �ngulos de deriva.
%
%% C�digo
% C�digo da fun��o:

function Fy = pneuLinearFun(deriva,pneuDados)
C = pneuDados(1);   % Coeficiente de rigidez de curva [N/rad]
alpha = deriva;     % �ngulo de deriva [rad]
Fy = -C*alpha;      % For�a lateral [N]
end

%% Exemplos
% Ver: <pneuDoc.html Modelo de pneu>
%
%% Ver tamb�m
%
% <index.html In�cio> | <pneuDoc.html Modelo de pneu>
%