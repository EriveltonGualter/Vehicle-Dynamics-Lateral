%% Estudo compara��o - dPSI = 3 rad/s ve�culo
% Este script mostra o desempenho dos ve�culos para um �ngulo de
% ester�amento nulo e condi��es iniciais dadas por: dPSI0 = 3 rad/s e
% ALPHAT0 = 0 rad.
%
%% Objetivo
% O objetivo deste estudo � ...
%
%% Op��es:
% Ver as op��es de modelos e dados em <index.html In�cio>.
%
%% Modelos de ve�culos
% Os modelos de ve�culos que ser�o usados nas simula��es:

% Modelos
veiculoModeloVet = [1 2 3]; % Vai ser o n�mero de figuras
% Onde: % 1 = veiculoLinear2gdl (Linear com 2 GDL)
        % 2 = veiculoNaoLinear2gdl (N�o linear com 2 GDL)
        % 3 = veiculoNaoLinear3gdl (N�o linear com 3 GDL)

% Vetor com texto para a descri��o dos gr�ficos
veiculoModeloTxt = char(' Linear 2 GDL',' N�o linear 2 GDL',' N�o linear 3 GDL');

% Dados
veiculoDados = 1; % N�o ocorre varia��o dos dados do ve�culo
% Onde: % 1 = veiculoDadosDelta0
        % 2 = veiculoDadosDelta14
        % 3 = veiculoDadosDelta45

veiculoModeloCor = char('r','g','b');
veiculoModeloMarcador = char('o','s','d');

        
%% Modelos de pneu
% Os modelos de pneu que ser�o usados nas simula��es:

pneuModelo = 4;
% Onde: % 1 = pneuLinearFun (Pneu linear)
        % 2 = pneuSadriFun (Pneu Sadri)
        % 3 = pneuPacejkaFun (Pneu Pacejka)
        % 4 = pneuPacejkaEstFun (Pneu Pacejka Estendido)

pneuDados = 4;
% Onde: % 1 = pneuLinearDados (Dados para pneu linear)
        % 2 = pneuSadriDadosTaylor (Dados para pneu Sadri)
        % 3 = pneuSadriDadosAjuste (Dados para pneu Sadri)
        % 4 = pneuPacejkaDados (Dados para pneu Pacejka)

%% Dados b�sicos da integra��o
T = 3; % Tempo total de simula��o
res = 40; % Resolu��o
TSPAN = 0:T/res:T; % Vetor de tempo de an�lise
        
% Pre alocando x0
x0 = [0;0;0;0;0;0];
% Pre alocando dPSI e ALPHAT
dPSI = zeros(res + 1,3);
ALPHAT = zeros(res + 1,3);
% Pre alocando X e Y
X = zeros(res + 1,3);
Y = zeros(res + 1,3);

%% Loop
%
for i = 1:length(veiculoModeloVet)
    
    veiculoModelo = veiculoModeloVet(i); % Modelo de ve�culo da itera��o i
        
    [pneuFun,veiculoFun,pneuDadosFrente,pneuDadosTras,veiculoDadosVet,pneuTxt,veiculoTxt] ...
        = seletor(pneuModelo,pneuDados,veiculoModelo,veiculoDados);
        
    % M�dulo do vetor velocidade. Quando o modelo tem 2gdl � a velocidade
    % prescrita. Quando o modelo tem 3gdl � a condi��o inicial.
    v = veiculoDadosVet(5);
		
    % Condi��es iniciais
	r0 = 3; % velocidade angular [rad/s]
	ALPHAT0 = 0; % �ngulo de deriva do centro de massa [rad]
	x0(1:2,1) = [r0 ; ALPHAT0]; % Condi��o inicial dos estados
	x0(3,1) = 0; % Condi��o da orientacao
	x0(4:5,1) = [0 ; 0]; % Condi��o inicial da trajet�ria
	% Para que o integrador consiga rodar no modelo com 3 gdl � necess�rio acrescentar uma
	% condi��o inicial referente ao estado velocidade "v".
	% Ou seja, a velocidade que era prescrita antes agora � condi��o inicial
	x0(6,1) = v; % Condi��o inicial da velocidade
    if veiculoModelo == 3
        X0 = x0; % Condi��o inicial da velocidade
    else
        X0 = x0(1:5,1);
    end

    % Integrando
	[TOUT,XOUT] = ode45(@(t,x) veiculoFun(t,x,pneuFun,pneuDadosFrente,pneuDadosTras,veiculoDadosVet),TSPAN,X0); 

	% Obtendo as sa�das do integrador para cada varia��o de pneu
	% utiliza-se "size" pois se a integra��o abortar XOUT vai ter um
	% tamanho menor que a pr� aloca��o dos vetores.
	dPSI(1:size(XOUT,1),i) = XOUT(:,1);
	ALPHAT(1:size(XOUT,1),i) = XOUT(:,2);
	X(1:size(XOUT,1),i) = XOUT(:,4);
	Y(1:size(XOUT,1),i) = XOUT(:,5);

end
%% Velocidade angular
% Comparando a velocidade �ngular:
%
figure(1)
hold on
box on
H = plot(TOUT,dPSI*180/pi);
set(H(1),'Color',veiculoModeloCor(1),'Marker',veiculoModeloMarcador(1),'MarkerFaceColor',veiculoModeloCor(1),'MarkerSize',7)
set(H(2),'Color',veiculoModeloCor(2),'Marker',veiculoModeloMarcador(2),'MarkerFaceColor',veiculoModeloCor(2),'MarkerSize',7)
set(H(3),'Color',veiculoModeloCor(3),'Marker',veiculoModeloMarcador(3),'MarkerFaceColor',veiculoModeloCor(3),'MarkerSize',7)
title('Velocidade angular X Tempo')
title('Vel. angular - dPSI0: 3 rad/s - Pneu: Pacejka estendido');
ylabel('dPSI [grau/s]')
xlabel('Tempo [s]')
legend(veiculoModeloTxt(1,:),veiculoModeloTxt(2,:),veiculoModeloTxt(3,:),'Location','NorthEast')

%% �ngulo de deriva do centro de massa
% Comparando o �ngulo de deriva do centro de massa:
%
figure(2)
hold on
box on
H = plot(TOUT,ALPHAT*180/pi);
set(H(1),'Color',veiculoModeloCor(1),'Marker',veiculoModeloMarcador(1),'MarkerFaceColor',veiculoModeloCor(1),'MarkerSize',7)
set(H(2),'Color',veiculoModeloCor(2),'Marker',veiculoModeloMarcador(2),'MarkerFaceColor',veiculoModeloCor(2),'MarkerSize',7)
set(H(3),'Color',veiculoModeloCor(3),'Marker',veiculoModeloMarcador(3),'MarkerFaceColor',veiculoModeloCor(3),'MarkerSize',7)
title('�ngulo de deriva CG X Tempo')
title('�ng. de deriva - dPSI0: 3 rad/s - Pneu: Pacejka estendido');
ylabel('�ngulo de deriva CG [grau]')
xlabel('Tempo [s]')
legend(veiculoModeloTxt(1,:),veiculoModeloTxt(2,:),veiculoModeloTxt(3,:),'Location','SouthWest')
        
%% Trajet�ria
% Comparando a trajet�ria do ve�culo:
%
figure(3);
hold on
box on
axis equal
H = plot(X,Y);
set(H(1),'Color',veiculoModeloCor(1),'Marker',veiculoModeloMarcador(1),'MarkerFaceColor',veiculoModeloCor(1),'MarkerSize',7)
set(H(2),'Color',veiculoModeloCor(2),'Marker',veiculoModeloMarcador(2),'MarkerFaceColor',veiculoModeloCor(2),'MarkerSize',7)
set(H(3),'Color',veiculoModeloCor(3),'Marker',veiculoModeloMarcador(3),'MarkerFaceColor',veiculoModeloCor(3),'MarkerSize',7)
title('Trajet�ria - dPSI0: 3 rad/s - Pneu: Pacejka estendido');
ylabel('Dist�ncia [m]')
xlabel('Dist�ncia [m]')
legend(veiculoModeloTxt(1,:),veiculoModeloTxt(2,:),veiculoModeloTxt(3,:),'Location','West')

%% An�lise
%
%% Ver tamb�m
%
% <index.html In�cio>
%