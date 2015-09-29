%% Descri��o
% Script que gera toda a documenta��o do reposit�rio.

%% Documenta��o do pr�prio gerador de documenta��o

publish('docDin','evalCode',false)

%% P�gina inicial da documenta��o

publish('index','evalCode',false)
publish('fluxograma') % Gera o fluxograma ilustrativo
close all % Fechando as figuras geradas

%% P�gina principal do modelo de pneu

publish('pneuDoc')
close all % Fechando as figuras geradas

    % pneuLinear
    publish('pneuLinearFun','evalCode',false)
    publish('pneuLinearDados','evalCode',false)
    % pneuSadri
    publish('pneuSadriFun','evalCode',false)
    publish('pneuSadriDadosTaylor','evalCode',false)
    publish('pneuSadriDadosAjuste','evalCode',false)
    % pneuPacejka
    publish('pneuPacejkaFun','evalCode',false)
    publish('pneuPacejkaDados','evalCode',false)

%% P�gina principal do modelo de ve�culo

publish('veiculoDoc')
close all % Fechando as figuras geradas
clear all % Limpando o workspace
    % veiculoLinear2gdl
    publish('veiculoLinear2gdl','evalCode',false)
    %publish('veiculoLinear2gdlDados','evalCode',false)
    % veiculoNaoLinear2gdl
    publish('veiculoNaoLinear2gdl','evalCode',false)
    %publish('veiculoLinear2gdlDados','evalCode',false)
    % veiculoNaoLinear3gdl
    publish('veiculoNaoLinear3gdl','evalCode',false)
    %publish('veiculoLinear2gdlDados','evalCode',false)
    % veiculoNaoLinear3gdlEst
    publish('veiculoNaoLinear3gdlEst','evalCode',false)
    %publish('veiculoLinear2gdlDados','evalCode',false)

%% Simula��es

    % Simula��o
    publish('simulacao')
    close all % Fechando as figuras geradas
    clear all % Limpando o workspace
    % Compara��o DELTA 14
    publish('comparacaoDelta14')
    close all % Fechando as figuras geradas
    clear all % Limpando o workspace
    % Compara��o DELTA 45
    publish('comparacaoDelta45')
    close all % Fechando as figuras geradas
    clear all % Limpando o workspace
    % Compara��o dPSI 2
    publish('comparacaoDpsi2')
    close all % Fechando as figuras geradas
    clear all % Limpando o workspace
    % Compara��o dPSI 3
    publish('comparacaoDpsi3')
    close all % Fechando as figuras geradas
    clear all % Limpando o workspace

    
%% Seletor

publish('seletor','evalCode',false)

%% Frame

publish('frame','evalCode',false)

%% Anima��o

publish('animacao','evalCode',false)
% Vetor
publish('vetor','evalCode',false)


clear all
clc    

cd html % Entrando na pasta da documenta��o
open index.html % Abrindo a p�gina inicial da documenta��o
cd .. % Voltando para a pasta ra�z do reposit�rio