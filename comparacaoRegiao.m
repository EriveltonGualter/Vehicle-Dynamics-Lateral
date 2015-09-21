tic % In�cio da contagem do tempo de simula��o
clear,clc,close all
%% Info
% IMPORTANTE!: Ver Info de simulacao.m!

%% Descri��o
% Este script tem como objetivo obter a regi�o de estabilidade 

%% Op��es:
% Ver Op��es de simulacao.m

% Vai ser o n�mero de figuras
veiculoModeloVet = [1 2 3];
veiculoModeloTxt = char(' Linear 2 GDL',' N�o linear 2 GDL',' N�o linear 3 GDL');
veiculoModeloTxtSave = char('L2GDL','NL2GDL','NL3GDL'); % Texto para o arquivo do workspace
%veiculoModeloTitulo4 = 'veiculoNaoLinear3gdlExtendido';

veiculoDados = 1; 

% Vai ser o n�mero de curvas em cada figura
pneuModeloVet = [1 3]; % Modelos 1-Linear; 2-Sadri; 3-Pacejka
pneuModeloTxt = char(' Linar',' Sadri',' Pacejka');
pneuModeloTxtSave = char('Linar','Sadri','Pacejka');
pneuModeloCor = char('r','g','b');
pneuModeloMarcador = char('o','s','d');
pneuDadosVet = [1 3];

for p = 1:length(veiculoModeloVet)
    for q = 1:length(pneuModeloVet)
        
        veiculoModelo = veiculoModeloVet(p);

        pneuModelo = pneuModeloVet(q);
        pneuDados = pneuDadosVet(q);

        %% Varia��o das condi��es iniciais
        %% Definindo o grid

        rr = 8*1; % refino do grid de r
        vv = 40*1; % refino do grid de vy

        total = num2str(rr); % String usado para a descri��o do progresso

        rgrid = linspace(-4,4,rr);
        vygrid = linspace(-19,19,vv);

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

                [pneuFun veiculoFun pneuDadosFrente pneuDadosTras veiculoDadosVet pneuTxt veiculoTxt] = seletor(pneuModelo,pneuDados,veiculoModelo,veiculoDados);

                % As condi��es iniciais tem tr�s zeros devido a PSI X e Y
                [TOUT,XOUT] = ode45(@(t,x) veiculoFun(t,x,pneuFun,pneuDadosFrente,pneuDadosTras,veiculoDadosVet),TSPAN,x0); 

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
        save(strcat('resultados/regiaoResultados',veiculoModeloTxtSave(p,:),pneuModeloTxtSave(q,:)))

    end
end

%% Gera��o dos gr�ficos

vetor = [0.1 0.5 0.9]

for p = 1:length(veiculoModeloVet)
    for q = 1:length(pneuModeloVet)
    % Carregando as vari�veis usadas nos gr�ficos
    load(strcat('resultados/regiaoResultados',veiculoModeloTxtSave(p,:),pneuModeloTxtSave(q,:)))

    figure(p);
    hold on
    contour(X,Y,Z,vetor(q))
    title(strcat('Regi�o de Estabilidade - Pneu: ',pneuModeloTxt(q,:),';',' Ve�culo: ',veiculoModeloTxt(p,:)));
    ylabel('dPSI [rad/s]')
    xlabel('Velocidade lateral [m/s]')
    if q == length(pneuModeloVet)
    legend(pneuModeloTxt(1,:),pneuModeloTxt(2,:),pneuModeloTxt(3,:),'Location','SouthEast')
    end

    % title(strcat('Regi�o de estabilidade - Pneu: ',pneuTxt,';',' Ve�culo: ',veiculoTxt))
    % xlabel('Velocidade lateral [m/s]')
    % ylabel('Velocidade angular [rad/s]')
    end
end


tempoDeSimulacao = toc % Fim do tempo de simula��o 