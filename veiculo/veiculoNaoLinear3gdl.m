function dx = veiculoNaoLinear3gdl(t,x,pneuFun,pneuDadosFrente,pneuDadosTras,veiculoDados)

% Dados do ve�culo
m = veiculoDados(1); % massa do veiculo [kg]
I = veiculoDados(2); % momento de inercia [kg]
a = veiculoDados(3); % distancia do eixo dianteiro ao centro de massa [m]
b = veiculoDados(4); % distancia do eixo dianteiro ao centro de massa [m]
% Pelo amor de deus! isso devia ta dando mta cagada:
%v = veiculoDados(5); % m�dulo da velocidade do centro de massa [m/s]

DELTA = veiculoDados(6);

% Estados
dPSI = x(1);
ALPHAT = x(2);
v = x(6);
PSI = x(3);


% Angulos de deriva n�o linear
ALPHAF = atan((v*sin(ALPHAT) + a*dPSI)/(v*cos(ALPHAT))) - DELTA; % Dianteiro
ALPHAR = atan((v*sin(ALPHAT) - b*dPSI)/(v*cos(ALPHAT)));         % Traseiro

% For�as longitudinais
FxF = 0;
FxR = 0;

% Curva caracter�stica
FyF = pneuFun(ALPHAF,pneuDadosFrente);
FyR = pneuFun(ALPHAR,pneuDadosTras);

% Equa��es de estado
dx(1,1) = (FyF*a*cos(DELTA) - FyR*b + FxF*a*sin(DELTA))/I;
dx(2,1) = (FyR + FyF*cos(DELTA) + FxF*sin(DELTA) - m*(dPSI*v*cos(ALPHAT) + (sin(ALPHAT)*(FxR + 	FxF*cos(DELTA) - ...
	FyF*sin(DELTA) + dPSI*m*v*sin(ALPHAT)))/(m*cos(ALPHAT))))/(m*(v*cos(ALPHAT) + (v*sin(ALPHAT)^2)/cos(ALPHAT)));
dx(6,1) = (FxR*cos(ALPHAT) + FyR*sin(ALPHAT) - FyF*cos(ALPHAT)*sin(DELTA) + FyF*cos(DELTA)*sin(ALPHAT) + ...
	FxF*sin(ALPHAT)*sin(DELTA) + FxF*cos(ALPHAT)*cos(DELTA))/(m*cos(ALPHAT)^2 + m*sin(ALPHAT)^2);

% Obten��o da orienta��o
dx(3,1) = dPSI; % dPSI

% Equa��es adicionais para o posicionamento (N�o necess�rias para a din�mica em guinada)
dx(4,1) = v*cos(ALPHAT + PSI); % X
dx(5,1) = v*sin(ALPHAT + PSI); % Y