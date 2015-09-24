function [pneuFun veiculoFun pneuDadosFrente pneuDadosTras veiculoDadosVet pneuTxt veiculoTxt] = seletor(pneuModelo,pneuDados,veiculoModelo,veiculoDados)
%% Descri��o
% Esta fun��o tem como objetivo fazer a sele��o dos dados e modelos de pneu e ve�culo

%% Pneu
% Os dados do pneu s�o definidos de acordo com o modelo de pneu escolhido

cd pneu % Entrando na pasta com os modelos de pneu

% Selecionando os dados do pneu
if pneuDados == 1
	pneuLinearDados
end
%--------------------------------------------------------------------------
if pneuDados == 2
	pneuSadriDados
end
%--------------------------------------------------------------------------
if pneuDados == 3
	pneuPacejkaDados
end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Selecionando o modelo de pneu
if pneuModelo == 1
	pneuFun = @pneuLinearFun; % Definindo a fun��o de pneu como a linear

	% Texto sobre o modelo de pneu para uso em descri��o de gr�ficos 
	pneuTxt = ' linear'; 
end
%--------------------------------------------------------------------------
if pneuModelo == 2
	pneuFun = @pneuSadriFun; % Definindo a fun��o de pneu como Sadri

	% Texto sobre o modelo de pneu para uso em descri��o de gr�ficos 
	pneuTxt = ' Sadri'; 
end
%--------------------------------------------------------------------------
if pneuModelo == 3
	pneuFun = @pneuPacejkaFun; % Definindo a fun��o de pneu como Pacejka

	% Texto sobre o modelo de pneu para uso em descri��o de gr�ficos 
	pneuTxt = ' Pacejka'; 

end

cd .. % Sa�ndo da pasta com os modelos de pneu

%% Ve�culo
% Os dados do ve�culo s�o definidos de acordo com o modelo de pneu
% escolhido

cd veiculo

% Selecionando os dados do pneu
if veiculoDados == 1
	veiculoDadosScript
	veiculoDadosVet = veiculoDadosVetor;
end
%--------------------------------------------------------------------------
if veiculoDados == 2
	veiculoDadosScript14
	veiculoDadosVet = veiculoDadosVetor;
end
%--------------------------------------------------------------------------
if veiculoDados == 3
	veiculoDadosScript45
	veiculoDadosVet = veiculoDadosVetor;
end
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Modelo de ve�culo
if veiculoModelo == 1
	veiculoFun = @veiculoLinear2gdl; % Definindo a fun��o de ve�culo
	
	% Texto sobre o modelo de veiculo para uso em descri��o de gr�ficos 
    veiculoTxt = ' linear 2 GDL';
end

if veiculoModelo == 2
	veiculoFun = @veiculoNaoLinear2gdl; % Definindo a fun��o de ve�culo
	
	% Texto sobre o modelo de veiculo para uso em descri��o de gr�ficos 
    veiculoTxt = ' n�o linear 2 GDL'; 
end

if veiculoModelo == 3
	veiculoFun = @veiculoNaoLinear3gdl; % Definindo a fun��o de ve�culo

	% Texto sobre o modelo de veiculo para uso em descri��o de gr�ficos 
    veiculoTxt = ' n�o linear 3 GDL'; 
end

if veiculoModelo == 4
	% Definindo a fun��o de ve�culo
    veiculoFun = @veiculoNaoLinear3gdlEst; 
    % Texto sobre o modelo de veiculo para uso em descri��o de gr�ficos 
	veiculoTxt = ' n�o linear 3 GDL Estendido'; 
end

cd ..