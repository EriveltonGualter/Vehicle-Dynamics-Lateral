%% Pneu Sadri
% Rela��o n�o linear entre a for�a lateral e o �ngulo de deriva.
%
%% Sintaxe
% |Fy = pneuSadriFun(deriva,pneuDados)|
%
%% Argumentos
% Lista de entradas da fun��o:
%
% <html> <table border=1 width="97%"> <tr> <td
% width="30%"><tt>deriva</tt></td> <td width="70%">�ngulo de deriva do
% pneu. �ngulo formado entre o vetor velocidade e o plano longitudinal do
% pneu.</td> </tr> <tr> <td><tt>pneuDados</tt></td> <td>Vetor com os dados
% do pneu: <tt>[k1 k2]</tt></td> </tr> </table> </html>
% 
% Lista de sa�das da fun��o:
%
% <html> <table border=1 width="97%"> <tr> <td width="30%"><tt>Fy</tt></td>
% <td width="70%">For�a lateral do pneu.</td></tr></table> </html>
%
%% Dados
% Dados dispon�veis para este modelo:
%
% * <pneuSadriDadosTaylor.html pneuSadriDadosTaylor>
% * <pneuSadriDadosAjuste.html pneuSadriDadosAjuste>
%
%% Modelo
%
% *Equacionamento*
%
% A equa��o que descreve este modelo � dada por:
%
% $$ F_y = k_1 \alpha  - k_2\alpha^3 $$
%
% Onde $F_y$ � a for�a lateral e $\alpha$ � o �ngulo de deriva. $k_1$ e
% $k_2$ s�o constantes do modelo.
%
% *Hip�teses*
%
% * Rela��o n�o linear.
% * V�lido apenas at� o �ngulos de deriva que fornece a m�xima for�a
% lateral (Satura��o do pneu).
%
%% C�digo
% C�digo da fun��o:

function Fy = pneuSadriFun(deriva,pneuDados)
% Par�metros do pneu
k1 = pneuDados(1);
k2 = pneuDados(2);

alpha = deriva; % �ngulo de deriva [rad]

Fy = -(k1*alpha-k2*alpha.^3); % For�a lateral [N]
end

%% Exemplos
% Ver: <pneuDoc.html Modelo de pneu>
%
%% Ver tamb�m
%
% <index.html In�cio> | <pneuDoc.html Modelo de pneu> |
% 