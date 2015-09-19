clear,clc
%% Pneu Sadri e Wu 2013
alpha = (0:0.1:25)*pi/180; % �ngulo de deriva

% Par�metros do pneu
Caf = 57300; % Par�metro do pneu [N/rad]
kf = 4.87; % Par�metro do pneu

% For�a lateral do modelo de Sadri
Fy = 2*Caf*(alpha-kf*alpha.^3);

% Forca do modelo linear equivalente
Fylin = 2*Caf*alpha;

% Angulo da forca lateral maxima (saturacao)
[Fymax,i] = max(Fy); % Valor e indice da forca lateral maxima
alphamax = alpha(i)*180/pi; % angulo [grau]

%% Resultados
% Gr�ficos dos resultados:

figure(1)
hold on
plot(alpha*180/pi,Fy,'r')
plot(alpha*180/pi,Fylin,'g')
title('Curva caracteristica')
xlabel('Angulo de deriva [grau]')
ylabel('Forca lateral [N]')
legend('Sadri e Wu 2013','Modelo linear equivalente','Location','Northwest')