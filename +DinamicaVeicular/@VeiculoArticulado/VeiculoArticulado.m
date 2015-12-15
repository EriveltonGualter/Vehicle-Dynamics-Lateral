%% Ve�culo articulado (Abstract)
%

classdef (Abstract) VeiculoArticulado
	methods(Abstract)
		% VeiculoArticuladoNaoLinear4GDL(self,t,estados)
	end

    properties(Abstract)
		params
        pneu
        distFT
        distTR
        distRA
        distAS
        distSM
        largura     % Largura do caminh�o-trator
        larguraSemi % Largura do semirreboque
	end
end

%% Ver tamb�m
%
% <index.html In�cio>
%
