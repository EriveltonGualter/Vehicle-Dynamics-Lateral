clear,clc,close all

%% Descri��o
% Este scipt tem como objetivo obter o valor do �ngulo para um dado valor de erro de lineariza��o do �ngulo e o seu seno.
% Entende-se por condi��es extremas aquelas que as hip�teses de lineariza��o n�o s�o atingidas. Neste caso, erros acima
% de 10% s�o considerados extremos. Condi��es aceit�veis s�o consideradas como aquelas em que o erro n�o passa de 1%.

% Para erro de 10%
% anguloSolucao = 45 graus

% Para erro de 1%
% anguloSolucao = 14 graus


%% Equacionamento
% Temos que o erro � dado por:
% 	erro = (angulo - sin(angulo)) / angulo 	(1)
% Logo:
% 	angulo*(1 - erro) = sin(angulo) 		(2)

%% C�lculo

erro = 0.01; % Erro desejado [%]

angulo = (0:0.1:60)*pi/180; % �ngulo de deriva [rad]
reta = (1 - erro)*angulo; % Lado esquerdo da equa��o (2)
sangulo = sin(angulo); % Lado direito da equa��o (2)

dif = abs(reta - sangulo); % M�dulo da diferen�a das curvas

[valor,indice] = min(dif(2:end)); % O menor valor da diferen�a exluindo o valor em zero. Pois ja se sabe que os dois partem do mesmo valor

anguloSolucao = angulo(indice)*180/pi % �ngulo que satisfaz aproximadamente a solu��o

%% Resultados
% Gr�ficamente 
figure(1)
hold on
plot(angulo*180/pi,reta,'r')
plot(angulo*180/pi,sangulo,'g')
title('Curvas da equa��o (2) - Ver c�digo')
xlabel('�ngulo [graus]')

% Para erro de 10%
% anguloSolucao = 45 graus

% Para erro de 1%
% anguloSolucao = 14 graus