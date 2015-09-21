tic % In�cio da contagem do tempo de simula��o
clear,clc,close all
%% Info
% IMPORTANTE!: Ver Info de simulacao.m!

%% Descri��o
% Este script tem como objetivo obter a regi�o de estabilidade 

%% Op��es:
% Ver Op��es de simulacao.m

% Sele��o
pneuModelo = 2; % Escolha do modelo de pneu
pneuDados = 2; % Escolha dos dados do pneu

veiculoModelo = 1; % Escolha do modelo de ve�culo
veiculoDados = 1; % Escolha dos dados do ve�culo

%% Seletor
% Definindo as vari�veis necess�rias para a integra��o
[pneuFun veiculoFun pneuDadosFrente pneuDadosTras veiculoDadosVet pneuTxt veiculoTxt] = seletor(pneuModelo,pneuDados,veiculoModelo,veiculoDados);

%% Varia��o das condi��es iniciais
%% Definindo o grid

rr = 8*1; % refino do grid de r
vv = 40*1; % refino do grid de vy



total = num2str(rr); % String usado para a descri��o do progresso

rgrid = linspace(-4,4,rr);
vygrid = linspace(-12,12,vv);

% Valor total do grid usado para estimar o est�gio da simula��o
total = num2str(length(rgrid)); 

[X,Y] = meshgrid(vygrid,rgrid); % lp = linearpacejka

for i=1:length(rgrid)
    for j=1:length(vygrid)
    	
    	T = 5; % Tempo total de simula��o
		TSPAN = 0:T/30:T; % Vetor de tempo de an�lise

    	% Condi��es iniciais
    	r0 = rgrid(i); % velocidade angular [rad/s]
		vy0 = vygrid(j); % velocidade lateral [m/s]
		v = 20; % velocidade longitudinal [m/s] -> ATEN��O: Tem que estar de acordo com os dados dos ve�culos com 2 gdl
		ALPHAT0 = asin(vy0/v); % convers�o de vy0 para ALPHAT
		x0 = [r0 ; ALPHAT0]; % Condi��o inicial dos estados
		x0 = [x0 ; 0]; % Condi��o da orientacao
		x0 = [x0 ; 0 ; 0]; % Condi��o inicial da trajet�ria
		if veiculoModelo == 3
			% Para que o integrador consiga rodar no modelo com 3 gdl � necess�rio acrescentar uma
			% condi��o inicial referente ao estado velocidade "v".
			% Ou seja, a velocidade que era prescrita antes agora � condi��o inicial
			x0 = [x0 ; v]; % Condi��o inicial da velocidade
		end

        % As condi��es iniciais tem tr�s zeros devido a PSI X e Y
        [TOUT,XOUT] = ode45(@(t,x) veiculoFun(t,x,pneuFun,pneuDadosFrente,...
                    pneuDadosTras,veiculoDadosVet),TSPAN,x0); 

        % Verifica��o do maior valor de ALPHAT
        ALPHATmax = max(abs(XOUT(:,2)));

        % Mapeamento do atendimento da condi��o de estabilidade dada por:
        % * ALPHAT < 90 graus
        if ALPHATmax < (pi/2)
            Z(i,j) = 1;
        else
            Z(i,j) = 0;
        end

        % Progresso da simula��o
        % if rem(i,100)==0 & j == 1
        %     clc
        %     estagio = num2str(i);
        %     strcat(estagio,'/',total)
        % end
	end
end

% Salvando os dados do workspace para compara��o de regi�es posteriores
save('regiaoResultados')

f1 = figure(1);
contour(X,Y,Z,0.5)
title(strcat('Regi�o de estabilidade - Pneu: ',pneuTxt,';',' Ve�culo: ',veiculoTxt))
xlabel('Velocidade lateral [m/s]')
ylabel('Velocidade angular [rad/s]')

tempoDeSimulacao = toc % Fim do tempo de simula��o 

% Salvando todos os dados do workspace para compara��o de regi�es posteriores
save('regiaoResultados')