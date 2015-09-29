%% Ve�culo n�o linear com 2 GDL
% Modelo bicicleta n�o linear com 2 graus de liberdade
%
%% Sintaxe
% |dx =
% veiculoNaoLinear2gdl(t,x,pneuFun,pneuDadosFrente,pneuDadosTras,veiculoDados)|
%% Argumentos
% Lista de entradas da fun��o:
%
% <html> <table border=1 width="97%"> 
% <tr> <td width="30%"><tt>t</tt></td> <td width="70%">Tempo.</td> </tr> 
% <tr> <td> <tt> x </tt></td> <td>Estados.</td> </tr>
% <tr> <td> <tt> pneuFun </tt></td> <td>Handle da fun��o do modelo de pneu. Ver <a href="pneuDoc.html">Modelo pneu</a>. </td></tr>
% <tr> <td> <tt> pneuDadosFrente </tt></td> <td>Vetor com os dados do pneu dianteiro. Ver <a href="pneuDoc.html">Modelo pneu</a>.</td> </tr>
% <tr> <td> <tt> pneuDadosTras </tt></td> <td>Vetor com os dados do pneu traseiro. Ver <a href="pneuDoc.html">Modelo pneu</a>.</td> </tr>
% <tr> <td> <tt> veiculoDados</tt></td> <td>Vetor com os dados do ve�culo: <tt>[m I a b v DELTA]</tt></td> </tr>
% </table> </html>
% 
% Lista de sa�das da fun��o:
%
% <html> <table border=1 width="97%">
% <tr> <td width="30%"><tt>dx</tt></td> <td width="70%">Derivada dos estados.</td></tr>
% </table> </html>
% 
%% C�digo
% C�digo da fun��o:

function dx = veiculoNaoLinear2gdl(t,x,pneuFun,pneuDadosFrente,pneuDadosTras,veiculoDados)

% Dados do ve�culo
m = veiculoDados(1); % massa do veiculo [kg]
I = veiculoDados(2); % momento de inercia [kg]
a = veiculoDados(3); % distancia do eixo dianteiro ao centro de massa [m]
b = veiculoDados(4); % distancia do eixo dianteiro ao centro de massa [m]
v = veiculoDados(5); % m�dulo da velocidade do centro de massa [m/s]

DELTA = veiculoDados(6);

% Estados

dPSI = x(1);
ALPHAT = x(2);
PSI = x(3);

% Angulos de deriva n�o linear
ALPHAF = atan2((v*sin(ALPHAT) + a*dPSI),(v*cos(ALPHAT))) - DELTA; % Dianteiro
ALPHAR = atan2((v*sin(ALPHAT) - b*dPSI),(v*cos(ALPHAT)));         % Traseiro

% Curva caracter�stica
FyF = pneuFun(ALPHAF,pneuDadosFrente);
FyR = pneuFun(ALPHAR,pneuDadosTras);

% Equa��es de estado
dx(1,1) = (FyF*cos(DELTA)*a - FyR*b)/I; % ddPSI
dx(2,1) = (FyF*cos(DELTA) + FyR - m*v*cos(ALPHAT)*dPSI)/(m*v*cos(ALPHAT)); % dALPHAT

% Obten��o da orienta��o
dx(3,1) = dPSI; % dPSI

% Equa��es adicionais para o posicionamento (N�o necess�rias para a din�mica em guinada)
dx(4,1) = v*cos(ALPHAT + PSI); % X
dx(5,1) = v*sin(ALPHAT + PSI); % Y
end

%% Ver tamb�m
%
% <index.html In�cio> | <veiculoDoc.html Modelo de ve�culo>
%