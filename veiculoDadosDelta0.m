%% Dados delta 0 graus
% Este script define os dados do modelo de ve�culo.
%
%% Dados do ve�culo
% Mesmos dados apresentados por SADRI E WU 2013
m = 2527;   % massa do veiculo [kg]
I = 6550;   % momento de in�rcia [kg]
a = 1.37;   % distancia do eixo dianteiro ao centro de massa [m]
b = 1.86;   % distancia do eixo dianteiro ao centro de massa [m]
v = 20;     % m�dulo da velocidade do centro de massa [m/s]

DELTA = 0*pi/180; % ester�amento do eixo dianteiro [grau]

%% Sa�da
veiculoDadosVetor = [m I a b v DELTA]; 