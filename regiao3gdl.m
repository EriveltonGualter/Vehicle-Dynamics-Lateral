tic % In�cio da contagem do tempo de simula��o
clear,clc,close all
%% Info
% IMPORTANTE!: Ver Info de simulacao.m!

%% Descri��o
% Este script tem como objetivo obter a regi�o de estabilidade 

%% Op��es:
% Ver Op��es de simulacao.m

% Sele��o
pneuModelo = 3; % Escolha do modelo de pneu
pneuDados = 3; % Escolha dos dados do pneu

veiculoModelo = 4; % Escolha do modelo de ve�culo
veiculoDados = 1; % Escolha dos dados do ve�culo

%% Seletor
% Definindo as vari�veis necess�rias para a integra��o
[pneuFun veiculoFun pneuDadosFrente pneuDadosTras veiculoDadosVet pneuTxt veiculoTxt] = seletor(pneuModelo,pneuDados,veiculoModelo,veiculoDados);

%% Varia��o das condi��es iniciais
%% Definindo o grid

dPSIref = 8*5; % refino do grid de r
ALPHATref = 4*7; % refino do grid de vy



total = num2str(dPSIref); % String usado para a descri��o do progresso

dPSIgrid = linspace(-4,4,dPSIref);
ALPHATgrid = linspace(-pi,pi,ALPHATref);

% Valor total do grid usado para estimar o est�gio da simula��o
total = num2str(length(dPSIgrid)); 

[X,Y] = meshgrid(ALPHATgrid,dPSIgrid); % lp = linearpacejka


% Gerando figura
figure(3)            
hold on

n = 1 % Contador para indice da saida dos estados na gera��o das trajetorias

for i=1:length(dPSIgrid)
    for j=1:length(ALPHATgrid)
    	
    	T = 10; % Tempo total de simula��o
		TSPAN = 0:T/30:T; % Vetor de tempo de an�lise

    	% Condi��es iniciais
    	dPSI0 = dPSIgrid(i); % velocidade angular [rad/s]
		ALPHAT0 = ALPHATgrid(j); % velocidade lateral [m/s]
		v = 20; % velocidade longitudinal [m/s] -> ATEN��O: Tem que estar de acordo com os dados dos ve�culos com 2 gdl
		x0 = [dPSI0 ; ALPHAT0]; % Condi��o inicial dos estados
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

        % As condi��es iniciais tem tr�s zeros devido a PSI X e Y
        [TOUT,XOUT] = ode45(@(t,x) veiculoFun(t,x,pneuFun,pneuDadosFrente,...
                    pneuDadosTras,veiculoDadosVet),TSPAN,x0); 

% A curva de n�vel vai ser dada pelo valor para o qual o ALPHAT convergiu! Ou seja para qual valor do ponto fixo

        Z(i,j) = XOUT(end,2); % �timo valor do vetor solu��o do ALPHAT

        % Plotar algumas trajet�rias
        if rem(i,3)==0 & rem(j,3)==0
%            H1 = plot(XOUT(:,2),XOUT(:,1));
            XX(:,n) = XOUT(:,2);
            YY(:,n) = XOUT(:,1);

            n = n + 1; % Soma um pra proxima slavar na coluna do lado
        end


        % % Verifica��o do maior valor de ALPHAT
        % ALPHATmax = max(abs(XOUT(:,2)));

        % % Mapeamento do atendimento da condi��o de estabilidade dada por:
        % % * ALPHAT < 90 graus
        % if ALPHATmax < (pi/2)
        %     Z(i,j) = 1;
        % else
        %     Z(i,j) = 0;
        % end

        % % Caso o integrador falhe - Comum com o pneu sadri
        % if length(TOUT) < length(TSPAN)
        %     Z(i,j) = 0;
        % end
        
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
hold on
[C,h] = contour(X,Y,Z,'ShowText','on');
set(h,'LevelList',[-2*pi -pi 0 pi 2*pi]+0.00001)
set(h,'TextList',[-2*pi -pi  0 pi 2*pi]+0.00001)

for q=1:n
    if XX(end,q) < 0.1 && XX(end,q) > -0.1 % Em torno de zero
        plot(XX(:,q),YY(:,q),'r');
    end

    if XX(end,q) < (pi + 0.1) && XX(end,q) > (pi - 0.1) % Em torno de pi/2
        plot(XX(:,q),YY(:,q),'g');
    end

    if XX(end,q) > (-pi - 0.1) && XX(end,q) < (-pi + 0.1) % Em torno de pi/2
        plot(XX(:,q),YY(:,q),'b');
    end


end

plot(0,0,'k+')
plot(pi,0,'k+')
plot(-pi,0,'k+')
title(strcat('Regi�o de estabilidade - Pneu: ',pneuTxt,';',' Ve�culo: ',veiculoTxt))
xlabel('ALPHAT [rad]')
ylabel('Velocidade angular [rad/s]')

f2 = figure(2);
hold on
surface(X,Y,Z);
plot(0,0,'k+')
plot(pi,0,'k+')
plot(-pi,0,'k+')
title(strcat('Regi�o de estabilidade - Pneu: ',pneuTxt,';',' Ve�culo: ',veiculoTxt))
xlabel('ALPHAT [rad]')
ylabel('Velocidade angular [rad/s]')
zlabel('ALPHAT final [rad]')


tempoDeSimulacao = toc % Fim do tempo de simula��o 

% Salvando todos os dados do workspace para compara��o de regi�es posteriores
save('regiaoResultados')