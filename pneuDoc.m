%% Modelo de pneu
% Rela��o entre a for�a lateral e o �ngulo de deriva.
%
%% Sintaxe
% |Fy = _pneuFun_(deriva,pneuDados)|
%
%% Argumentos
% Lista de entradas da fun��o:
%
% <html> <table border=1 width="97%"> <tr> <td
% width="30%"><tt>deriva</tt></td> <td width="70%">�ngulo de deriva do
% pneu. �ngulo formado entre o vetor velocidade e o plano longitudinal do
% pneu.</td> </tr> <tr> <td><tt>pneuDados</tt></td> <td>Vetor com os dados
% do pneu.</td> </tr> </table> </html>
% 
% Lista de sa�das da fun��o:
%
% <html> <table border=1 width="97%"> <tr> <td width="30%"><tt>Fy</tt></td>
% <td width="70%">For�a lateral do pneu.</td></tr></table> </html>
% 
%% Fun��es de pneu - pneuFun
% As op��es de fun��es de pneu s�o aprentadas na tabela abaixo:
%
% <html> <table border=1 width="97%"> <tr><td width="30%"> <b> pneuFun
% </b></td><td width="35%"> <b>Modelo</b></td><td width="35%"><b>Argumentos
% de entrada</b></td></tr> <tr> <td> <a
% href="pneuLinearFun.html"><tt>pneuLinearFun</tt></a> </td> <td>Pneu
% linear</td><td> <tt>delta, pneuDados = [C]</tt> </td></tr><tr> <td> <a
% href="pneuSadriFun.html"><tt>pneuSadriFun</tt></a> </td> <td>Pneu
% Sadri</td><td> <tt>delta, pneuDados = [k1 k2]</tt> </td></tr><tr> <td> <a
% href="pneuPacejkaFun.html"><tt>pneuPacejkaFun</tt></a> </td> <td>Pneu
% pacejka</td><td> <tt>delta, pneuDados = [Fz0 muy0 Cy Ey c1 c2 Fz muy]</tt>
% </td></tr></table> </html>
%
%% Dados do pneu - pneuDados
% Os dados do pneu dependem do modelo adotado. Este reposit�rio possui os
% seguintes dados de pneu para cada modelo:
%
% * <pneuLinearDados.html pneuLinearDados> (Linear)
% * <pneuSadriDadosTaylor.html pneuSadriDadosTaylor> (Sadri)
% * <pneuSadriDadosAjuste.html pneuSadriDadosAjuste> (Sadri)
% * <pneuPacejkaDados.html pneuPacejkaDados> (Pacejka)
%
% Estes modelos fornecem as informa��es dos par�metros dos pneus para a
% determina��o da for�a lateral exercida em fun��o do �ngulo de deriva.
%
%% Modelos
% O modelo de pneu relaciona a for�a lateral com o �ngulo de deriva (�ngulo
% formado entre o vetor velocidade do centro do pneu com o plano
% longitudinal do pneu). A rela��o t�pica entre essas duas grandezas pode
% ser observada na figura abaixo. Al�m disso � poss�vel verificar a
% defini��o do �ngulo de deriva.
%
% <<curvaCaracteristica.png>>
%
% *Modelo Linear*
%
% Para simula��es em que os �ngulos de deriva sejam pequenos � poss�vel
% aproximar a curva caracter�stica por uma rela��o linear dada por:
%
% $$ F_y = C \alpha $$
%
% Onde $F_y$ � a for�a lateral, $C$ � o coeficiente de rigidez de curva e
% $\alpha$ � o �ngulo de deriva.
%
% Para maiores informa��es sobre o modelo linear ver: <pneuLinearFun.html
% pneuLinearFun>
%
% As op�oes de dados para este modelo s�o: <pneuLinearDados.html
% pneuLinearDados>
%
% *Modelo Sadri*
%
% Na tentativa de levar em considera��o a n�o linearidade da curva
% caracter�stica muitos autores adotam o modelo de terceira ordem dado por:
%
% $$ F_y = k_1 \alpha  - k_2\alpha^3 $$
%
% Onde $k_1$ e $k_2$ s�o constantes do modelo.
%
% Para maiores informa��es sobre o modelo sadri ver: <pneuSadriFun.html
% pneuSadriFun>
%
% As op�oes de dados para este modelo s�o: <pneuSadriDadosTaylor.html
% pneuSadriDadosTaylor> e <pneuSadriDadosAjuste.html pneuSadriDadosAjuste>
%
% *Modelo Pacejka*
% 
% Uma outra alternativa para o modelar o pneu levando em considera��o o seu
% comportamento n�o linear � atrav�s da vers�o simplificada da Magic
% Formula apresentada por Pacejka.
%
% $$ F_y = D \sin(C \arctan(B \alpha - E (B \alpha - \arctan(B \alpha))))$$
%
% Onde $B$, $C$, $D$ e $E$ s�o coeficientes obtidos experimentalmente.
%
% Para maiores informa��es sobre o modelo Pacejka ver: <pneuPacejkaFun.html
% pneuPacejkaFun>
%
% As op�oes de dados para este modelo s�o: <pneuPacejkaDados.html
% pneuPacejkaDados>
%
%% Exemplo - Linear
% Ilustrando a curva caracter�stica do pneu para um modelo linear.

deriva = (0:0.7:25)*pi/180; % �ngulo de deriva [rad]

pneuLinearDados % Obtendo os dados do pneu linear (Dianteira e traseira)

pneuDados = pneuDadosFrente; % Atribuindo aos dados usados na gera��o da curva

FyLinear = pneuLinearFun(deriva,pneuDados);

figure(1)
box on
plot(deriva*180/pi,-FyLinear,'Color','r','Marker','o','MarkerFaceColor','r')
title('Modelo de pneu - Linear')
ylabel('For�a lateral [N]')
xlabel('�ngulo de deriva [grau]')

%% Exemplo - Sadri (S�rie de Taylor)
% Ilustrando a curva caracter�stica do pneu para um modelo sadri.

deriva = (0:0.7:25)*pi/180; % �ngulo de deriva [rad]

% Obtendo os dados do pneu Sadri a partir da expans�o da Magic Formula em
% s�rie de Taylor (Dianteira e traseira)
pneuSadriDadosTaylor 

pneuDados = pneuDadosFrente; % Atribuindo aos dados usados na gera��o da curva

FySadriST = pneuSadriFun(deriva,pneuDados);

figure(2)
box on
plot(deriva*180/pi,-FySadriST,'Color','c','Marker','*','MarkerFaceColor','c')
title('Modelo de pneu - Sadri (S�rie de Taylor)')
ylabel('For�a lateral [N]')
xlabel('�ngulo de deriva [grau]')

%% Exemplo - Sadri (Ajuste)
% Ilustrando a curva caracter�stica do pneu para um modelo sadri.

deriva = (0:0.7:25)*pi/180; % �ngulo de deriva [rad]

% Obtendo os dados do pneu Sadri a partir dos ajustes de inclina��o e for�a
% lateral m�xima (Dianteira e traseira)
pneuSadriDadosAjuste

pneuDados = pneuDadosFrente; % Atribuindo aos dados usados na gera��o da curva

FySadriAj = pneuSadriFun(deriva,pneuDados);

figure(3)
box on
plot(deriva*180/pi,-FySadriAj,'Color','g','Marker','s','MarkerFaceColor','g')
title('Modelo de pneu - Sadri (Ajuste)')
ylabel('For�a lateral [N]')
xlabel('�ngulo de deriva [grau]')

%% Exemplo - Pacejka
% Ilustrando a curva caracter�stica do pneu para um modelo pacejka.

deriva = (0:0.7:25)*pi/180; % �ngulo de deriva [rad]

pneuPacejkaDados % Obtendo os dados do pneu Pacejka (Dianteira e traseira)

pneuDados = pneuDadosFrente;

FyPacejka = pneuPacejkaFun(deriva,pneuDados);

figure(4)
box on
plot(deriva*180/pi,-FyPacejka,'Color','b','Marker','d','MarkerFaceColor','b')
title('Modelo de pneu - Pacejka')
ylabel('For�a lateral [N]')
xlabel('�ngulo de deriva [grau]')

%% Exemplo - Compara��o
% Compara��o dos modelos para par�metros equivalentes.

figure(5)
box on
hold on
plot(deriva*180/pi,-FyLinear,'Color','r','Marker','o','MarkerFaceColor','r')
plot(deriva*180/pi,-FySadriST,'Color','c','Marker','*','MarkerFaceColor','c')
plot(deriva*180/pi,-FySadriAj,'Color','g','Marker','s','MarkerFaceColor','g')
plot(deriva*180/pi,-FyPacejka,'Color','b','Marker','d','MarkerFaceColor','b')
title('Compara��o - Modelo de pneu')
ylabel('For�a lateral [N]')
xlabel('�ngulo de deriva [grau]')
legend('Linear','Sadri - Taylor','Sadri - Ajuste','Pacejka','Location','NorthWest')

%% Exemplo - Compara��o (Grandes �ngulos)
% *Pacejka*
%

deriva = (0:3:180)*pi/180; % �ngulo de deriva [rad]

pneuPacejkaDados % Obtendo os dados do pneu Pacejka (Dianteira e traseira)

pneuDados = pneuDadosFrente;

FyPacejka = pneuPacejkaFun(deriva,pneuDados);

%%
%
% *Pacejka estendido*
%
deriva = (0:3:180)*pi/180; % �ngulo de deriva [rad]

pneuPacejkaDados % Obtendo os dados do pneu Pacejka (Dianteira e traseira)

pneuDados = pneuDadosFrente;

FyPacejkaEst = pneuPacejkaEstFun(deriva,pneuDados);

figure(6)
box on
hold on
plot(deriva*180/pi,-FyPacejka,'Color','b','Marker','d','MarkerFaceColor','b')
plot(deriva*180/pi,-FyPacejkaEst,'Color','m','Marker','+','MarkerFaceColor','m')
title('Compara��o - Grandes �ngulos')
ylabel('For�a lateral [N]')
xlabel('�ngulo de deriva [grau]')
legend('Pacejka','Pacejka estendido','Location','South')


%% Ver tamb�m
%
% <index.html In�cio> | <pneuLinearFun.html Pneu linear> |
% <pneuSadriFun.html Pneu sadri> | <pneuPacejkaFun.html Pneu pacejka>
%