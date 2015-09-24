clear all,clc,close all 
%% Info
% Encoding deste arquivo '*.m': windows-1252 (via Sublime3)
% Para rodar em Windows(7)/Matlab 2014a: SEM problemas pois windows-1252 �
% default (Verificar).
% Para rodar em Linux(Ubuntu14.04)/Matlab 2013a: COM problemas pois UTF-8 �
% o default (Verificar),(Nem tem na documenta��o 2013 UTF-8)
%	* Usar na linha de comando: 'slCharacterEncoding('Windows-1252')'
% 	* Editor n�o funciona: n�o exibe os caracteres corretamente (Usar
% 	Sublime3 por exemplo)
% 	* Os gr�ficos ficam direito.

%% Descri��o
% Este sript tem como objetivo simular o comportamento din�mico de um
% ve�culo simples escolhendo o modelo de pneu e o modelo bicicleta.
% Dependendo da aplica��o este script pode ser usado como fun��o em que os
% par�metros de entrada s�o justamente as escolhas de modelos tanto de pneu
% quanto de ve�culo.

%% Op��es:
% Este script possibilita a escolha do modelo de pneu e o modelo de ve�culo
% Modelos de pneu:
% 	1 - pneuLinearFun
% 	2 - pneuSadriFun
% 	3 - pneuPacejkaFun
% Dados do pneu escolhido:
%	1 - pneuLinearDados
%	2 - pneuSadriDados
%	3 - pneuPacejkaDados
% Modelos de ve�culo:
% 	1 - veiculoLinear2gdl
% 	2 - veiculoNaoLinear2gdl
% 	3 - veiculoNaoLinear3gdl
% 	4 - veiculoNaoLinear3gdlExt
% Dados do modelo de ve�culo escolhido:
% 	1 - veiculoDadosScript
% 	2 - veiculoDadosScript14
% 	3 - veiculoDadosScript45

% Sele��o
pneuModelo = 3; % Escolha do modelo de pneu
pneuDados = 3; % Escolha dos dados do pneu

veiculoModelo = 4; % Escolha do modelo de ve�culo
veiculoDados = 1; % Escolha dos dados do ve�culo

% OBS: para os dados se � uma simula��o sem varia��o de par�metro os dados s�o vetores. Se houver varia��o os par�metros vem em matrizes onde as colunas s�o os par�metros e as linhas o valor deles na varia��o

%% Dados b�sicos da integra��o (integrador � chamado mais abaixo)
% 
T = 3; % Tempo total de simula��o
TSPAN = 0:T/30:T; % Vetor de tempo de an�lise

r0 = 4; % velocidade angular [rad/s]
vy0 = 0; % velocidade lateral [m/s]
v = 20; % velocidade longitudinal [m/s] -> ATEN��O: Tem que estar de acordo com os dados dos ve�culos com 2 gdl
ALPHAT0 = asin(vy0/v); % convers�o de vy0 para ALPHAT

ALPHAT0 = -3;

x0 = [r0 ; ALPHAT0]; % Condi��o inicial dos estados
x0 = [x0 ; 0]; % Condi��o da orientacao
x0 = [x0 ; 0 ; 0]; % Condi��o inicial da trajet�ria
if veiculoModelo == 3
	% Para que o integrador consiga rodar no modelo com 3 gdl � necess�rio acrescentar uma
	% condi��o inicial referente ao estado velocidade "v".
	% Ou seja, a velocidade que era prescrita antes agora � condi��o inicial
	x0 = [x0 ; v]; % Condi��o inicial da velocidade
end

if veiculoModelo == 4
	% Para que o integrador consiga rodar no modelo com 3 gdl � necess�rio acrescentar uma
	% condi��o inicial referente ao estado velocidade "v".
	% Ou seja, a velocidade que era prescrita antes agora � condi��o inicial
	x0 = [x0 ; v]; % Condi��o inicial da velocidade
end


%% Seletor
% Definindo as vari�veis necess�rias para a integra��o
[pneuFun veiculoFun pneuDadosFrente pneuDadosTras veiculoDadosVet pneuTxt veiculoTxt] = seletor(pneuModelo,pneuDados,veiculoModelo,veiculoDados);

%% Integrando
% Utilizando a ode45

[TOUT,XOUT] = ode45(@(t,x) veiculoFun(t,x,pneuFun,pneuDadosFrente,...
                    pneuDadosTras,veiculoDadosVet),TSPAN,x0); 

%% Reconstru��o dos dados importantes

dPSI = XOUT(:,1);
ALPHAT = XOUT(:,2);

a = veiculoDadosVet(3);
b = veiculoDadosVet(4);
DELTA = veiculoDadosVet(6);

if veiculoModelo == 1
	% �ngulos de deriva	
	ALPHAF = ALPHAT + a*dPSI/v - DELTA; % Dianteiro
	ALPHAR = ALPHAT - b*dPSI/v;         % Traseiro
	% M�dulo dos vetores velocidade
	VT = ones(length(dPSI),1)*v; % Centro de massa T

	% �ngulo de deriva para anima��o
	% Isso � feito pq para os modelos 3 e 4 a contagem do angulo � diferente da orienta��o do vetor para anima��o
	ALPHAFA = ALPHAF + DELTA; % Tem que somar o delta por que � o �ngulo do vetor vel F em rela��o ao plano longitudinal
	ALPHARA = ALPHAR; 
end

if veiculoModelo == 2
	% Angulos de deriva n�o linear
	ALPHAF = atan((v*sin(ALPHAT) + a*dPSI)./(v*cos(ALPHAT))) - DELTA; % Dianteiro
	ALPHAR = atan((v*sin(ALPHAT) - b*dPSI)./(v*cos(ALPHAT)));         % Traseiro
	% Vetor velocidade do centro de massa
	VT = ones(length(dPSI),1)*v; % Centro de massa T

	% �ngulo de deriva para anima��o
	% Isso � feito pq para os modelos 3 e 4 a contagem do angulo � diferente da orienta��o do vetor para anima��o
	ALPHAFA = ALPHAF + DELTA; 
	ALPHARA = ALPHAR; 
end

if veiculoModelo == 3
	% Vetor velocidade do centro de massa
	VT = XOUT(:,6);
	v = VT;
	% Angulos de deriva n�o linear
	ALPHAF = atan((v.*sin(ALPHAT) + a*dPSI)./(v.*cos(ALPHAT))) - DELTA; % Dianteiro
	ALPHAR = atan((v.*sin(ALPHAT) - b*dPSI)./(v.*cos(ALPHAT)));         % Traseiro

	% �ngulo de deriva para anima��o
	% Isso � feito pq para os modelos 3 e 4 a contagem do angulo � diferente da orienta��o do vetor para anima��o
	ALPHAFA = ALPHAF + DELTA; 
	ALPHARA = ALPHAR; 
end

if veiculoModelo == 4
	% Vetor velocidade do centro de massa
	VT = XOUT(:,6);
	v = VT;

	numF = (v.*sin(ALPHAT) + a*dPSI);
	numR = (v.*sin(ALPHAT) - b*dPSI);
	den = (v.*cos(ALPHAT));
	
	for i=1:length(ALPHAT)

		% Angulos de deriva n�o linear para plot em fun��o do tempo
		ALPHAF(i) = atan(numF(i)/den(i)) - DELTA ;
		ALPHAR(i) = atan(numR(i)/den(i));
		if den(i)<=0%ALPHAT(i)>=pi/2 & ALPHAT(i)<3/2*pi
	        ALPHAF(i) = -atan(numF(i)/den(i)) - DELTA;
	        ALPHAR(i) = -atan(numR(i)/den(i));
	    end
	
		% �ngulo de deriva para anima��o
		% Isso � feito pq para os modelos 3 e 4 a contagem do angulo � diferente da orienta��o do vetor para anima��o
		ALPHAFA(i) = atan((v(i)*sin(ALPHAT(i)) + a*dPSI(i))/(v(i)*cos(ALPHAT(i))));
		ALPHARA(i) = atan((v(i)*sin(ALPHAT(i)) - b*dPSI(i))/(v(i)*cos(ALPHAT(i))));
	    if den(i)<=0%ALPHAT(i)>=pi/2 & ALPHAT(i)<3/2*pi
		    ALPHAFA(i) = atan((v(i)*sin(ALPHAT(i)) + a*dPSI(i))/(v(i)*cos(ALPHAT(i)))) - pi;
    		ALPHARA(i) = atan((v(i)*sin(ALPHAT(i)) - b*dPSI(i))/(v(i)*cos(ALPHAT(i)))) - pi;
	    end
	end
end


% if veiculoModelo == 4

% end

% Modulo do vetor velocidade
VF = sqrt((VT.*sin(ALPHAT) + a*dPSI).^2 + (VT.*cos(ALPHAT)).^2); % Dianteiro
VR = sqrt((VT.*sin(ALPHAT) - b*dPSI).^2 + (VT.*cos(ALPHAT)).^2); % Traseiro

%% Resultados

f1 = figure(1);
% Plotar o gr�fico com eixo vertical na esquerda e direita
[AX,H1,H2] = plotyy(TOUT,XOUT(:,1)*180/pi,TOUT,XOUT(:,2)*180/pi); 
% Mudando as cores dos eixos (Padr�o vem com cores iguais aos eixos)
set(AX(1),'YColor',[0 0 0]);
set(AX(2),'YColor',[0 0 0]);
set(H1,'Color',[1 0 0],'Marker','o','MarkerFaceColor',[1 0 0],'MarkerSize',7)
set(H2,'Color',[0 1 0],'Marker','s','MarkerFaceColor',[0 1 0],'MarkerSize',7)
title(strcat('Estados X Tempo - Pneu: ',pneuTxt,';',' Ve�culo: ',veiculoTxt));
ylabel(AX(1),'dPSI [grau/s]')
ylabel(AX(2),'ALPHAT [grau]')
xlabel('Tempo [s]')
legend('dPSI','ALPHAT');

f2 = figure(2);
H1 = plot(TOUT,XOUT(:,3)*180/pi,'r');
set(H1,'Color',[1 0 0],'Marker','o','MarkerFaceColor',[1 0 0],'MarkerSize',7)
title('Orienta��o X Tempo')
ylabel('PSI [grau]')
xlabel('Tempo [s]')

f3 = figure(3);
axis equal
H1 = plot(XOUT(:,4),XOUT(:,5),'r');
set(H1,'Color',[1 0 0],'Marker','o','MarkerFaceColor',[1 0 0],'MarkerSize',7)
title('Trajet�ria')
ylabel('Dist�ncia [m]')
xlabel('Dist�ncia [m]')

f4 = figure(4);
hold on
H1 = plot(TOUT,ALPHAF*180/pi,'r');
H2 = plot(TOUT,ALPHAR*180/pi,'g');
set(H1,'Color',[1 0 0],'Marker','o','MarkerFaceColor',[1 0 0],'MarkerSize',7)
set(H2,'Color',[0 1 0],'Marker','s','MarkerFaceColor',[0 1 0],'MarkerSize',7)
title('�ngulos de deriva X Tempo')
ylabel('�ngulo [grau]')
xlabel('Tempo [s]')
legend('Frente','Tras')

f5 = figure(5);
hold on
H1 = plot(XOUT(:,2),XOUT(:,1));
set(H1,'Color',[1 0 0],'Marker','o','MarkerFaceColor',[1 0 0],'MarkerSize',7)
plot(0,0,'k+')
plot(0,180,'k+')
plot(0,360,'k+')
plot(0,-180,'k+')
plot(0,-360,'k+')
title('Plano de fase')
xlabel('dPSI [grau/s]')
ylabel('ALPHAT [grau]')
legend('Trajet�ria','Ponto fixo')


% % figure(5)
% % hold on
% % plot(TOUT,real(valor(:,1)),'r')
% % plot(TOUT,real(valor(:,2)),'g')
% % title('Parte real dos autovalores')
% % xlabel('Tempo [s]')
% % xlabel('Autovalor')
% % legend('1','2')

if veiculoModelo == 3
	f6 = figure(6);
	hold on
	H1 = plot(TOUT,VT,'r');
	set(H1,'Color',[1 0 0],'Marker','o','MarkerFaceColor',[1 0 0],'MarkerSize',7)
	title('Velocidade longitudinal X Tempo ')
	ylabel('Velocidade [m/s]')
	xlabel('Tempo [s]')
end


% %% Salvando as figuras
% print(f1,'resultados/simulacao/estados.pdf','-dpdf')
% print(f2,'resultados/simulacao/orientacao.pdf','-dpdf')
% print(f3,'resultados/simulacao/Trajetoria.pdf','-dpdf')
% print(f4,'resultados/simulacao/deriva.pdf','-dpdf')

% %% Anima��o
% cd animacao % Entrando na pasta de anima��o
% % Executando o script de anima��o
% animacao(XOUT,TOUT,ALPHAFA,ALPHARA,VF,VR,VT,veiculoDadosVet);
% cd .. % Saindo da pasta de anima��o
