function Fy = pneuLinearFun(deriva,pneuDados)

% Par�metros do pneu
C = pneuDados(1); % Coeficiente de rigidez de curva [N/rad]

% �ngulo de deriva
alpha = deriva; % [rad]

% For�a lateral
Fy = -C*alpha;