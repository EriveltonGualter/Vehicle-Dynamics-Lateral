function dx = veiculoLinear2gdl(t,x,pneuFun,pneuDadosFrente,pneuDadosTras,veiculoDados)

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

% �ngulos de deriva
ALPHAF = ALPHAT + a*dPSI/v - DELTA; % Dianteiro
ALPHAR = ALPHAT - b*dPSI/v;         % Traseiro

% Curva caracter�stica
FyF = pneuFun(ALPHAF,pneuDadosFrente);
FyR = pneuFun(ALPHAR,pneuDadosTras);

% Equa��es de estado
dx(1,1) = (FyF*a - FyR*b)/I;            % ddPSI
dx(2,1) = (FyF + FyR - m*v*dPSI)/(m*v); % dALPHAT

% Obten��o da orienta��o
dx(3,1) = dPSI; % dPSI

% Equa��es adicionais para o posicionamento (N�o necess�rias para a din�mica em guinada)
dx(4,1) = v*cos(ALPHAT + PSI); % X
dx(5,1) = v*sin(ALPHAT + PSI); % Y