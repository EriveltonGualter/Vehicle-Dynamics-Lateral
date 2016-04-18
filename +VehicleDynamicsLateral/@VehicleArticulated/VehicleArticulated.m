%% Ve�culo articulado (Abstract)
%

classdef (Abstract) VehicleArticulated
	methods(Abstract)
		% VeiculoArticuladoNaoLinear4GDL(self,t,estados)
	end

    properties(Abstract)
		params
        tire
        distFT
        distTR
        distRA
        distAS
        distSM
        width     % Largura do caminh�o-trator
        widthSemi % Largura do semirreboque
	end
end

%% See Also
%
% <index.html Index> | <VehicleSimple.html VehicleSimple>
%
