%% Graphics
% Functions for graphics generation.
%
%% Code
%

classdef Graphics
	methods
        % Constructor
        function self = Graphics(varargin)
            v = VehicleDynamics.VehicleArticulatedNonlinear4DOF;
            if nargin == 0
                self.vehicle = v;%.params;
            else
                self.vehicle = varargin{1};%.params;
            end
        end

        %% Animation
        % Animates the manoever.
        %
        % *Sintax*
        %
        % |_GraphicsClass_.Animation(XOUT,TOUT,saveit)|
        %
        % *Arguments*
        %
        % The following table describes the input arguments:
        %
        % <html> <table border=1 width="97%">
        % <tr> <td width="30%"><tt>XOUT</tt></td> <td width="70%">Solution array. Each column corresponds to the solution of each state variable of the vehicle. The columns must respect the following variable order: [XT YT PSI dPSI VT ALPHAT (PHI dPHI)] </td> </tr>
        % <tr> <td width="30%"><tt>TOUT</tt></td> <td width="70%">Column vector of time points.</td> </tr>
        % <tr> <td width="30%"><tt>saveit</tt></td> <td width="70%">Flag for saving the animation in a gif file. If savit = 0 the animation will not be saved. If savit = 1 a file Animacao.gif is generated.</td> </tr>
        % </table> </html>
        %
        % *Description*
        %
        % TEXT

        function Animation(self,XOUT,TOUT,saveit)
            % Verificando quantidade de colunas para saber se � ve�culo simples ou articulado
            % col = 6 -> simples
            % col = 8 -> articulado
            [col] = size(XOUT,2);

            % States
            XT = XOUT(:,1);                 % Horizontal position [m]
            YT = XOUT(:,2);                 % Vertical position [m]
            PSI = XOUT(:,3);                % Vehicle yaw angle [rad]
            dPSI = XOUT(:,4);               % Yaw rate [rad/s]
            VT = XOUT(:,5);                 % Vehicle CG velocity [m/s]
            ALPHAT = XOUT(:,6);             % Vehicle side slip angle [rad]

            % Distances
            a = self.vehicle.distFT;        % Distance FT [m]
            b = self.vehicle.distTR;        % Distance TR [m]
            lT = self.vehicle.width / 2;  % Metade da width do vehicle [m]

            % �ngulo de deriva na dianteira [rad]
            ALPHAF = atan2((a*dPSI + VT.*sin(ALPHAT)),(VT.*cos(ALPHAT)));
            % �ngulo de deriva na traseira [rad]
            ALPHAR = atan2((-b*dPSI + VT.*sin(ALPHAT)),(VT.*cos(ALPHAT)));
            % OBS: Calculando os �ngulos de deriva com "atan2", quando o valor chega a
            % 180 graus fica estranho o vector.

            % M�dulo da velocidade no eixo dianteiro [m/s]
            VF = sqrt((VT.*cos(ALPHAT)).^2 + (a*dPSI + VT.*sin(ALPHAT)).^2);
            % M�dulo da velocidade no eixo traseiro [m/s]
            VR = sqrt((VT.*cos(ALPHAT)).^2 + (-b*dPSI + VT.*sin(ALPHAT)).^2);

            % Posi��o relativa dos cantos e eixos
            % Determina a posi��o dos cantos e eixos do ve�culo com rela��o ao centro
            % de massa.

            % Vectores posi��o 1, 2, 3 e 4 em rela��o a T na base (T t1 t2 t3)
            rt1t = [a;lT];                  % dianteira esquerda
            rt2t = [a;-lT];                 % dianteira direita
            rt3t = [-b;-lT];                % traseira direita
            rt4t = [-b;lT];                 % traseira esquerda

            eif = [a;0];                    % Posicao do eixo dianteiro
            eir = [-b;0];                   % Posicao do eixo trasiero

            % Evolu��o da posi��o absoluta dos cantos e eixos
            % Determina a movimenta��o dos pontos devido a mudan�a de orienta��o do
            % ve�culo.

            % Pre alocando as matrizes

            rt1i = zeros(length(TOUT),2);
            rt2i = zeros(length(TOUT),2);
            rt3i = zeros(length(TOUT),2);
            rt4i = zeros(length(TOUT),2);

            eff = zeros(length(TOUT),2);
            err = zeros(length(TOUT),2);

            % In�cio do loop
            for j=1:length(TOUT)
                % Matriz de rota��o da base (T t1 t2 t3) para (o i j k)
                RTI=[cos(PSI(j)) -sin(PSI(j));sin(PSI(j)) cos(PSI(j))];
                % Vectores posi��o 1, 2, 3 e 4 em rela��o a origem do ref inercial na
                rt1i(j,1:2) = (RTI*rt1t)';
                % base (T t1 t2 t3)
                rt2i(j,1:2) = (RTI*rt2t)';
                rt3i(j,1:2) = (RTI*rt3t)';
                rt4i(j,1:2) = (RTI*rt4t)';
                % Posicionando o eixo dianteiro e o traseiro
                eff(j,1:2) = (RTI*eif);     % Eixo dianteiro
                err(j,1:2) = (RTI*eir);     % Eixo trasiro
            end

            % Posi��o absoluta dos cantos e eixos
            % A evolu��o da posi��o absoluta dos pontos ao longo do tempo.

            % Vectores posi��o 1, 2, 3 e 4 em rela��o a o na base (o i j k)
            rc1t=[XT YT]+rt1i;
            rc2t=[XT YT]+rt2i;
            rc3t=[XT YT]+rt3i;
            rc4t=[XT YT]+rt4i;

            % Posicionamento absoluto do eixo dianteiro e trasiero
            ef = [XT YT]+eff;
            er = [XT YT]+err;

            % Ajuste do tempo
            % A exibi��o deve ser ajustada pois a o n�mero de frames n�o � a mesma que
            % a resolu��o do integrador (TSPAN).
            %

            TEMPO = 0:0.05:TOUT(end);

            % Pre alocando as matrizes
            rc1 = zeros(length(TEMPO),2);
            rc2 = zeros(length(TEMPO),2);
            rc3 = zeros(length(TEMPO),2);
            rc4 = zeros(length(TEMPO),2);

            efrente = zeros(length(TEMPO),2);
            etras = zeros(length(TEMPO),2);

            xxx = zeros(length(TEMPO),2);
            yyy = zeros(length(TEMPO),2);
            alphat = zeros(length(TEMPO),2);
            psii = zeros(length(TEMPO),2);

            alphaf = zeros(length(TEMPO),2);
            alphar = zeros(length(TEMPO),2);

            velf = zeros(length(TEMPO),2);
            velr = zeros(length(TEMPO),2);
            velt = zeros(length(TEMPO),2);

            rn1 = zeros(length(TEMPO),2);
            rn2 = zeros(length(TEMPO),2);
            rn3 = zeros(length(TEMPO),2);
            rn4 = zeros(length(TEMPO),2);

            for i=1:length(TEMPO)
                % Posi��o dos cantos e eixo
                rc1(i,1:2) = interp1(TOUT,rc1t,TEMPO(i));
                rc2(i,1:2) = interp1(TOUT,rc2t,TEMPO(i));
                rc3(i,1:2) = interp1(TOUT,rc3t,TEMPO(i));
                rc4(i,1:2) = interp1(TOUT,rc4t,TEMPO(i));

                efrente(i,1:2) = interp1(TOUT,ef,TEMPO(i));
                etras(i,1:2) = interp1(TOUT,er,TEMPO(i));

                % Posi��o do centro de massa
                xxx(i,1:2) = interp1(TOUT,XT,TEMPO(i));
                yyy(i,1:2) = interp1(TOUT,YT,TEMPO(i));

                % Estados
                alphat(i,1:2) = interp1(TOUT,ALPHAT,TEMPO(i));
                psii(i,1:2) = interp1(TOUT,PSI,TEMPO(i));

                % �ngulos de deriva
                alphaf(i,1:2) = interp1(TOUT,ALPHAF,TEMPO(i));
                alphar(i,1:2) = interp1(TOUT,ALPHAR,TEMPO(i));

                % Velocidade
                velf(i,1:2) = interp1(TOUT,VF,TEMPO(i));
                velr(i,1:2) = interp1(TOUT,VR,TEMPO(i));
                velt(i,1:2) = interp1(TOUT,VT,TEMPO(i));
            end

            % Definindo a figura
            % Gerando a figura e definindo algumas propriedades
            f=figure(666);
            set(f,'Units','centimeters')
            set(f,'Position',[1 1 24 14])
            ax=gca();
            axis equal
            set(ax,'NextPlot','add','Box','on','XGrid','on','YGrid','on','ZGrid','on')
            set(ax,'XLim',[min(XT)-10 max(XT)+10])
            set(ax,'XLimMode','manual')
            set(ax,'YLim',[min(YT)-10 max(YT)+10])
            set(ax,'YLimMode','manual')

            % Legendas
            title('Trajet\''oria','Interpreter','Latex')
            xlabel('Dist\^ancia [m]','Interpreter','Latex');
            ylabel('Dist\^ncia [m]','Interpreter','Latex');

            % Primeiro frame
            %
            %

            % Vectores velocidade
            % Script "vector.m"
            % Escolhi n�o exibir o vector velocidade do centro de massa pq fica muito poluido
            %vector([xxx(1) yyy(1)],(alphat(1)+psii(1)),velt(1),'k');
            self.Vector(efrente(1,1:2),(alphaf(1)+psii(1)),velf(1),'r');
            self.Vector(etras(1,1:2),(alphar(1)+psii(1)),velr(1),'g');

            % Coordenadas dos cantos para o primeiro frame
            xc = [rc1(1,1) rc2(1,1) rc3(1,1) rc4(1,1)];
            yc = [rc1(1,2) rc2(1,2) rc3(1,2) rc4(1,2)];

            % Exibindo o ve�culo
            fill(xc,yc,'r')

            % Adding semitrailer
            if col == 8
                PHI = XOUT(:,7);        % Orienta��o relativa do semirreboque [rad]
                dPHI = XOUT(:,8);       % Velocidade angular relativa entre as unidades [rad/s]

                c = self.vehicle.distRA;        % distancia da articula��o ao centro de massa do caminh�o-trator [m]
                d = self.vehicle.distAS;        % distancia do eixo traseiro ao centro de massa do caminh�o-trator [m]
                e = self.vehicle.distSM;        % distancia da articula��o ao centro de massa do caminh�o-trator [m]
                lS = self.vehicle.widthSemi / 2;              % Metade da width do vehicle [m]

                % �ngulo de deriva no eixo do semirreboque [rad]
                ALPHAM = atan2(((d + e)*(dPHI - dPSI) + VT.*sin(ALPHAT + PHI) - b*dPSI.*cos(PHI) - c*dPSI.*cos(PHI)),(VT.*cos(ALPHAT + PHI) + b*dPSI.*sin(PHI) + c*dPSI.*sin(PHI)));
                % M�dulo da velocidade no eixo do semirreboque [m/s]
                VM = sqrt((VT.*cos(ALPHAT + PHI) + b*dPSI.*sin(PHI) + c*dPSI.*sin(PHI)).^2 + ((d + e)*(dPHI - dPSI) + VT.*sin(ALPHAT + PHI) - b*dPSI.*cos(PHI) - c*dPSI.*cos(PHI)).^2);
                RS = [XT-(b+c)*cos(PSI)-d*cos(PSI-PHI) YT-(b+c)*sin(PSI)-d*sin(PSI-PHI)];
                % Vectores posi��o 1, 2, 3 e 4 em rela��o a S na base (S s1 s2 s3)
                rs1s = [d;lS];           % dianteira esquerda
                rs2s = [d;-lS];          % dianteira direita
                rs3s = [-e;-lS];         % traseira direita
                rs4s = [-e;lS];          % traseira esquerda

                eim = [-e;0];           % Posicao do eixo do semirreboque

                rn1i = zeros(length(TOUT),2);
                rn2i = zeros(length(TOUT),2);
                rn3i = zeros(length(TOUT),2);
                rn4i = zeros(length(TOUT),2);

                emm = zeros(length(TOUT),2);

                for j=1:length(TOUT)
                    % Matriz de rota��o da base (S s1 s2 s3) para (o i j k)
                    RSI=[cos(PSI(j)-PHI(j)) -sin(PSI(j)-PHI(j));sin(PSI(j)-PHI(j)) cos(PSI(j)-PHI(j))];
                    % Vectores posi��o 1, 2, 3 e 4 em rela��o a O na base (c c1 c2 c3)
                    rn1i(j,1:2) = (RSI*rs1s)';
                    rn2i(j,1:2) = (RSI*rs2s)';
                    rn3i(j,1:2) = (RSI*rs3s)';
                    rn4i(j,1:2) = (RSI*rs4s)';

                    % Posicionando o eixo dianteiro e o traseiro
                    emm(j,1:2) = (RSI*eim);     % Eixo trasiro
                end

                % Vectores posi��o 1, 2, 3 e 4 em rela��o a o na base (o i j k)
                rn1t=RS+rn1i;
                rn2t=RS+rn2i;
                rn3t=RS+rn3i;
                rn4t=RS+rn4i;

                em = RS+emm;

                phii = zeros(length(TEMPO),2);
                alpham = zeros(length(TEMPO),2);
                velm = zeros(length(TEMPO),2);
                emsemi = zeros(length(TEMPO),2);

                for i=1:length(TEMPO)
                    phii(i,1:2) = interp1(TOUT,PHI,TEMPO(i));
                    alpham(i,1:2) = interp1(TOUT,ALPHAM,TEMPO(i));
                    velm(i,1:2) = interp1(TOUT,VM,TEMPO(i));
                    % Semirreboque
                    rn1(i,1:2) = interp1(TOUT,rn1t,TEMPO(i));
                    rn2(i,1:2) = interp1(TOUT,rn2t,TEMPO(i));
                    rn3(i,1:2) = interp1(TOUT,rn3t,TEMPO(i));
                    rn4(i,1:2) = interp1(TOUT,rn4t,TEMPO(i));

                    emsemi(i,1:2) = interp1(TOUT,em,TEMPO(i));
                end

                self.Vector(emsemi(1,1:2),(alpham(1)+psii(1)-phii(1)),velm(1),'b');
                xn = [rn1(1,1) rn2(1,1) rn3(1,1) rn4(1,1)];
                yn = [rn1(1,2) rn2(1,2) rn3(1,2) rn4(1,2)];
                fill(xn,yn,'g')
            end


            if saveit == 1
                % Inicializando o gif
                frame = getframe(666);
                im = frame2im(frame);
                [A,map] = rgb2ind(im,256,'nodither');
                imwrite(A,map,'Animacao.gif','LoopCount',Inf,'DelayTime',0.05);
            end

            % Frames restantes
            %
            for j = 1:length(TEMPO)
                % Trajet�ria do centro de massa

                % Centro de massa (Comentado porque n�o sei se vou usar)
                % plot(XT,YT,'r')
                % plot(RS(:,1),RS(:,2),'g')

                % Eixos
                plot(efrente(:,1),efrente(:,2),'r')
                plot(etras(:,1),etras(:,2),'g')

                % Coordenadas dos cantos para os frames
                xc = [rc1(j,1) rc2(j,1) rc3(j,1) rc4(j,1)];
                yc = [rc1(j,2) rc2(j,2) rc3(j,2) rc4(j,2)];


                % Exibindo o ve�culo
                fill(xc,yc,'r')

                % Vectores velocidade
                % Com cores diferentes
                % Escolhi n�o exibir o vector velocidade do centro de massa pq fica muito poluido
                %vector([xxx(j) yyy(j)],(alphat(j)+psii(j)),velt(j),'k');
                self.Vector(efrente(j,1:2),(alphaf(j)+psii(j)),velf(j),'r');
                self.Vector(etras(j,1:2),(alphar(j)+psii(j)),velr(j),'g');

                if col == 8
                    plot(emsemi(:,1),emsemi(:,2),'b')
                    xn = [rn1(j,1) rn2(j,1) rn3(j,1) rn4(j,1)];
                    yn = [rn1(j,2) rn2(j,2) rn3(j,2) rn4(j,2)];
                    fill(xn,yn,'g')
                    self.Vector(emsemi(j,1:2),(alpham(j)+psii(j)-phii(j)),velm(j),'b');
                end

                if saveit == 1
                    % Adicionando o frame atual ao gif iniciado
                    frame = getframe(666);
                    im = frame2im(frame);
                    [A,map] = rgb2ind(im,256,'nodither');
                    imwrite(A,map,'Animacao.gif','WriteMode','append','DelayTime',0.05);
                end
                % Pausa a exibi��o - ATEN��O: Tem que ser o mesmo valor usado no ajuste
                % do tempo

                pause(0.05)

                cla(ax); % Limpando o axes
            end

            % �ltimo frame
            % A �ltima imagem que a figura vai exibir quando a anima��o acabar
            %

            % Eixos
            plot(efrente(:,1),efrente(:,2),'r')
            plot(etras(:,1),etras(:,2),'g')

            % Coordenadas dos cantos para o �ltimo frame
            xc = [rc1(end,1) rc2(end,1) rc3(end,1) rc4(end,1)];
            yc = [rc1(end,2) rc2(end,2) rc3(end,2) rc4(end,2)];

            % Exibindo o ve�culo
            fill(xc,yc,'r')

            % Escolhi n�o exibir o vector velocidade do centro de massa pq fica muito poluido
            %vector([xxx(end) yyy(end)],(alphat(end)+psii(end)),velt(end),'k');
            self.Vector(efrente(end,1:2),(alphaf(end)+psii(end)),velf(end),'r');
            self.Vector(etras(end,1:2),(alphar(end)+psii(end)),velr(end),'g');

            % Incluindo o semirreboque
            if col == 8
                plot(emsemi(:,1),emsemi(:,2),'b')
                xn = [rn1(end,1) rn2(end,1) rn3(end,1) rn4(end,1)];
                yn = [rn1(end,2) rn2(end,2) rn3(end,2) rn4(end,2)];
                fill(xn,yn,'g')
                self.Vector(emsemi(end,1:2),(alpham(end)+psii(end)-phii(end)),velm(end),'b');
            end
        end

        %% Frame
        % Plots the sequence of frames of the vehicle manoever.
        %
        % *Sintax*
        %
        % |_GraphicsClass_.Frame(XOUT,TOUT,saveit)|
        %
        % *Arguments*
        %
        % The following table describes the input arguments:
        %
        % <html> <table border=1 width="97%">
        % <tr> <td width="30%"><tt>XOUT</tt></td> <td width="70%">Solution array. Each column corresponds to the solution of each state variable of the vehicle. The columns must respect the following variable order: [XT YT PSI dPSI VT ALPHAT (PHI dPHI)] </td> </tr>
        % <tr> <td width="30%"><tt>TOUT</tt></td> <td width="70%">Column vector of time points.</td> </tr>
        % <tr> <td width="30%"><tt>saveit</tt></td> <td width="70%">Flag for saving the trajectory image in a pdf file. If savit = 0 the image will not be saved. If savit = 1 a file Trajetoria.pdf is generated.</td> </tr>
        % </table> </html>
        %
        % *Description*
        %
        % TEXTO

        function Frame(self,XOUT,TOUT,saveit)
            % Verificando quantidade de colunas para saber se � ve�culo simples ou articulado
            % col = 6 -> simples
            % col = 8 -> articulado
            [col] = size(XOUT,2);

            % States
            XT = XOUT(:,1);                 % Horizontal position [m]
            YT = XOUT(:,2);                 % Vertical position [m]
            PSI = XOUT(:,3);                % Vehicle yaw angle [rad]
            dPSI = XOUT(:,4);               % Yaw rate [rad/s]
            VT = XOUT(:,5);                 % Vehicle CG velocity [m/s]
            ALPHAT = XOUT(:,6);             % Vehicle side slip angle [rad]

            % Distances
            a = self.vehicle.distFT;        % Distance FT [m]
            b = self.vehicle.distTR;        % Distance TR [m]
            lT = self.vehicle.width / 2;  % Metade da width do vehicle [m]

            % Slip angles
            ALPHAF = atan2((a*dPSI + VT.*sin(ALPHAT)),(VT.*cos(ALPHAT)));   % Front [rad]
            % OBS: N�o tem o delta pq � pra medir o �ngulo entre o vector velocidade do eixo dianteiro e o plano longitudinal do ve�culo
            ALPHAR = atan2((-b*dPSI + VT.*sin(ALPHAT)),(VT.*cos(ALPHAT)));  % Rear [rad]

            %
            % OBS: Calculando os �ngulos de deriva com "atan2", quando o valor chega a
            % 180 graus fica estranho o vector.
            %
            % Velocity
            VF = sqrt((VT.*cos(ALPHAT)).^2 + (a*dPSI + VT.*sin(ALPHAT)).^2);    % Front [m/s]
            VR = sqrt((VT.*cos(ALPHAT)).^2 + (-b*dPSI + VT.*sin(ALPHAT)).^2);   % Rear [m/s]

            % Posi��o relativa dos cantos e eixos
            % Determina a posi��o dos cantos e eixos do ve�culo com rela��o ao centro
            % de massa.
            % Vectores posi��o 1, 2, 3 e 4 em rela��o a T na base (T t1 t2 t3)
            rt1t = [a;lT];           % dianteira esquerda
            rt2t = [a;-lT];          % dianteira direita
            rt3t = [-b;-lT];         % traseira direita
            rt4t = [-b;lT];          % traseira esquerda

            eif = [a;0];            % Posicao do eixo dianteiro
            eir = [-b;0];           % Posicao do eixo trasiero

            % Pre alocando
            rt1i = zeros(length(TOUT),2);
            rt2i = zeros(length(TOUT),2);
            rt3i = zeros(length(TOUT),2);
            rt4i = zeros(length(TOUT),2);

            eff = zeros(length(TOUT),2);
            err = zeros(length(TOUT),2);

            % Evolu��o da posi��o absoluta dos cantos e eixos
            % Determina a movimenta��o dos pontos devido a mudan�a de orienta��o do
            % ve�culo.
            for j=1:length(TOUT)
                % Matriz de rota��o da base (T t1 t2 t3) para (o i j k)
                RTI=[cos(PSI(j)) -sin(PSI(j));sin(PSI(j)) cos(PSI(j))];
                % Vectores posi��o 1, 2, 3 e 4 em rela��o a origem do ref inercial na
                % base (T t1 t2 t3)
                rt1i(j,1:2) = (RTI*rt1t)';
                rt2i(j,1:2) = (RTI*rt2t)';
                rt3i(j,1:2) = (RTI*rt3t)';
                rt4i(j,1:2) = (RTI*rt4t)';
                % Posicionando o eixo dianteiro e o traseiro
                eff(j,1:2) = (RTI*eif);     % Eixo dianteiro
                err(j,1:2) = (RTI*eir);     % Eixo trasiro
            end

            % Posi��o absoluta dos cantos e eixos
            % A evolu��o da posi��o absoluta dos pontos ao longo do tempo.
            % Vectores posi��o 1, 2, 3 e 4 em rela��o a o na base (o i j k)
            rc1t=[XT YT]+rt1i;
            rc2t=[XT YT]+rt2i;
            rc3t=[XT YT]+rt3i;
            rc4t=[XT YT]+rt4i;
            % Posicionamento absoluto do eixo dianteiro e trasiero
            ef = [XT YT]+eff;
            er = [XT YT]+err;

            % Ajuste do tempo
            % A exibi��o deve ser ajustada pois a o n�mero de frames n�o � a mesma que
            % a resolu��o do integrador (TSPAN).
            %
            % A vari�vel tempo define em que instantes o ve�culo vai ser plotado
            TEMPO = 0:1:TOUT(end);

            % Pre alocando as matrizes
            rc1 = zeros(length(TEMPO),2);
            rc2 = zeros(length(TEMPO),2);
            rc3 = zeros(length(TEMPO),2);
            rc4 = zeros(length(TEMPO),2);

            efrente = zeros(length(TEMPO),2);
            etras = zeros(length(TEMPO),2);

            xxx = zeros(length(TEMPO),2);
            yyy = zeros(length(TEMPO),2);
            alphat = zeros(length(TEMPO),2);
            psii = zeros(length(TEMPO),2);

            alphaf = zeros(length(TEMPO),2);
            alphar = zeros(length(TEMPO),2);

            velf = zeros(length(TEMPO),2);
            velr = zeros(length(TEMPO),2);
            velt = zeros(length(TEMPO),2);

            for i=1:length(TEMPO)
                % Posi��o dos cantos e eixo
                rc1(i,1:2) = interp1(TOUT,rc1t,TEMPO(i));
                rc2(i,1:2) = interp1(TOUT,rc2t,TEMPO(i));
                rc3(i,1:2) = interp1(TOUT,rc3t,TEMPO(i));
                rc4(i,1:2) = interp1(TOUT,rc4t,TEMPO(i));
                % Posi��o do centro de massa
                xxx(i,1:2) = interp1(TOUT,XT,TEMPO(i));
                yyy(i,1:2) = interp1(TOUT,YT,TEMPO(i));
                % Estados
                alphat(i,1:2) = interp1(TOUT,ALPHAT,TEMPO(i));
                psii(i,1:2) = interp1(TOUT,PSI,TEMPO(i));
                % �ngulos de deriva
                alphaf(i,1:2) = interp1(TOUT,ALPHAF,TEMPO(i));
                alphar(i,1:2) = interp1(TOUT,ALPHAR,TEMPO(i));
                % Velocidade
                velf(i,1:2) = interp1(TOUT,VF,TEMPO(i));
                velr(i,1:2) = interp1(TOUT,VR,TEMPO(i));
                velt(i,1:2) = interp1(TOUT,VT,TEMPO(i));
            end

            % Definindo a figura
            % Gerando a figura e definindo algumas propriedades
            %
            f999 = figure(999);
            set(f999,'Units','centimeters')
            set(f999,'Position',[1 1 24 14])
            set(f999,'PaperUnits','centimeters')
            set(f999,'PaperPosition',[5 0 16 12])
            PaperPos = get(f999,'PaperPosition');
            set(f999,'PaperSize',PaperPos(3:4))
            ax999=gca();
            set(ax999,'NextPlot','add','Box','on','XGrid','on','YGrid','on','ZGrid','on')
            axis equal
            set(ax999,'XLim',[min(XT)-20 max(XT)+10])
            set(ax999,'XLimMode','manual')
            set(ax999,'YLim',[min(YT)-10 max(YT)+10])
            set(ax999,'YLimMode','manual')

            xlabel('Dist\^ancia [m]','Interpreter','Latex')
            ylabel('Dist\^ancia [m]','Interpreter','Latex')

            TEMPOplot = 0:0.05:TOUT(end); % Tempo para os plot da curva de trajet�ria
            for i=1:length(TEMPOplot)
                efrente(i,1:2) = interp1(TOUT,ef,TEMPOplot(i));
                etras(i,1:2) = interp1(TOUT,er,TEMPOplot(i));
            end

            % plot(efrente(:,1),efrente(:,2),'r')
            % plot(etras(:,1),etras(:,2),'g')
            plot(ef(:,1),ef(:,2),'r')
            plot(er(:,1),er(:,2),'g')

            for j = 1:length(TEMPO)
                % Coordenadas dos cantos para os frames
                xc = [rc1(j,1) rc2(j,1) rc3(j,1) rc4(j,1)];
                yc = [rc1(j,2) rc2(j,2) rc3(j,2) rc4(j,2)];
                % Exibindo o ve�culo
                fill(xc,yc,'r');
            end

            % Adding semitrailer
            if col == 8
                PHI = XOUT(:,7);        % Orienta��o relativa do semirreboque [rad]
                dPHI = XOUT(:,8);       % Velocidade angular relativa entre as unidades [rad/s]

                c = self.vehicle.distRA;        % distancia da articula��o ao centro de massa do caminh�o-trator [m]
                d = self.vehicle.distAS;        % distancia do eixo traseiro ao centro de massa do caminh�o-trator [m]
                e = self.vehicle.distSM;        % distancia da articula��o ao centro de massa do caminh�o-trator [m]
                lS = self.vehicle.widthSemi / 2;              % Metade da width do vehicle [m]
                % �ngulo de deriva no eixo do semirreboque [rad]
                ALPHAM = atan2(((d + e)*(dPHI - dPSI) + VT.*sin(ALPHAT + PHI) - b*dPSI.*cos(PHI) - c*dPSI.*cos(PHI)),(VT.*cos(ALPHAT + PHI) + b*dPSI.*sin(PHI) + c*dPSI.*sin(PHI)));
                % M�dulo da velocidade no eixo do semirreboque [m/s]
                VM = sqrt((VT.*cos(ALPHAT + PHI) + b*dPSI.*sin(PHI) + c*dPSI.*sin(PHI)).^2 + ((d + e)*(dPHI - dPSI) + VT.*sin(ALPHAT + PHI) - b*dPSI.*cos(PHI) - c*dPSI.*cos(PHI)).^2);
                % Posi��o do centro de massa do semirreboque
                RS = [XT-(b+c)*cos(PSI)-d*cos(PSI-PHI) YT-(b+c)*sin(PSI)-d*sin(PSI-PHI)];
                % Vectores posi��o 1, 2, 3 e 4 em rela��o a S na base (S s1 s2 s3)
                rs1s = [d;lS];           % dianteira esquerda
                rs2s = [d;-lS];          % dianteira direita
                rs3s = [-e;-lS];         % traseira direita
                rs4s = [-e;lS];          % traseira esquerda
                eim = [-e;0];           % Posicao do eixo do semirreboque
                % Pre alocando
                rn1i = zeros(length(TOUT),2);
                rn2i = zeros(length(TOUT),2);
                rn3i = zeros(length(TOUT),2);
                rn4i = zeros(length(TOUT),2);
                emm = zeros(length(TOUT),2);

                for j=1:length(TOUT)
                    % Matriz de rota��o da base (S s1 s2 s3) para (o i j k)
                    RSI=[cos(PSI(j)-PHI(j)) -sin(PSI(j)-PHI(j));sin(PSI(j)-PHI(j)) cos(PSI(j)-PHI(j))];
                    % Vectores posi��o 1, 2, 3 e 4 em rela��o a O na base (c c1 c2 c3)
                    rn1i(j,1:2) = (RSI*rs1s)';
                    rn2i(j,1:2) = (RSI*rs2s)';
                    rn3i(j,1:2) = (RSI*rs3s)';
                    rn4i(j,1:2) = (RSI*rs4s)';
                    % Posicionando o eixo dianteiro e o traseiro
                    emm(j,1:2) = (RSI*eim);     % Eixo trasiro
                end
                % Vectores posi��o 1, 2, 3 e 4 em rela��o a o na base (o i j k)
                rn1t=RS+rn1i;
                rn2t=RS+rn2i;
                rn3t=RS+rn3i;
                rn4t=RS+rn4i;

                em = RS+emm;

                phii = zeros(length(TEMPO),2);
                alpham = zeros(length(TEMPO),2);
                velm = zeros(length(TEMPO),2);
                rn1 = zeros(length(TEMPO),2);
                rn2 = zeros(length(TEMPO),2);
                rn3 = zeros(length(TEMPO),2);
                rn4 = zeros(length(TEMPO),2);
                emsemi = zeros(length(TEMPO),2);

                for i=1:length(TEMPO)
                    phii(i,1:2) = interp1(TOUT,PHI,TEMPO(i));
                    alpham(i,1:2) = interp1(TOUT,ALPHAM,TEMPO(i));
                    velm(i,1:2) = interp1(TOUT,VM,TEMPO(i));

                    rn1(i,1:2) = interp1(TOUT,rn1t,TEMPO(i));
                    rn2(i,1:2) = interp1(TOUT,rn2t,TEMPO(i));
                    rn3(i,1:2) = interp1(TOUT,rn3t,TEMPO(i));
                    rn4(i,1:2) = interp1(TOUT,rn4t,TEMPO(i));
                end
                for i=1:length(TEMPOplot)
                    emsemi(i,1:2) = interp1(TOUT,em,TEMPOplot(i));
                end
                plot(em(:,1),em(:,2),'b')
                % plot(emsemi(:,1),emsemi(:,2),'b')

                for j = 1:length(TEMPO)
                    xn = [rn1(j,1) rn2(j,1) rn3(j,1) rn4(j,1)];
                    yn = [rn1(j,2) rn2(j,2) rn3(j,2) rn4(j,2)];
                    fill(xn,yn,'g');
                end
            end

            if saveit == 1
                print(f999,'-dpdf','Trajetoria.pdf')
            end
        end
    end

    methods(Static)

        %% Vector
        % Plots a vector arrow.
        %
        % *Sintax*
        %
        % |_GraphicsClass_.Vector(inicio,angulo,modulo,cor)|
        %
        % *Arguments*
        %
        % The following table describes the input arguments:
        %
        % <html> <table border=1 width="97%">
        % <tr> <td width="30%"><tt>inicio</tt></td> <td width="70%">Coordenada do �nicio da flecha.</td> </tr>
        % <tr> <td width="30%"><tt>angulo</tt></td> <td width="70%">�ngulo da orienta��o da flecha.</td> </tr>
        % <tr> <td width="30%"><tt>M�dulo</tt></td> <td width="70%">Comprimento da flecha.</td> </tr>
        % <tr> <td width="30%"><tt>cor</tt></td> <td width="70%">Cor da flecha.</td> </tr>
        % </table> </html>
        %
        % *Description*
        %
        % TEXTO

        function Vector(inicio,angulo,modulo,cor)
            coord1 = inicio;                                    % inicio do vector
            theta = angulo;
            modulo = 0.7*modulo;                                % modulo do vector
            coord2 = modulo*[cos(theta) sin(theta)] + coord1;   % fim do vector

            %theta = atan2((coord1(1)-coord2(1)),(coord1(2)-coord2(2))); % angulo de orienta��o do triangulo
            esc = 1; % Escala
            l = 0.5; % width relativa em rela��o ao comprimento do triangulo (0-1)

            % Forma e orienta��o do triangulo
            c1 = esc*l*[-sin(theta) +cos(theta)];   % canto 1 - inferior esquerdo
            c2 = esc*l*[+sin(theta) -cos(theta)];   % canto 2 - inferior direito
            c3 = esc*[+cos(theta) +sin(theta)];     % canto 3 - superior central

            % Escala e posicionamento
            x = [c1(1)+coord2(1) c2(1)+coord2(1) c3(1)+coord2(1)];
            y = [c1(2)+coord2(2) c2(2)+coord2(2) c3(2)+coord2(2)];

            % figure(1)
            % axis equal
            hold on
            fill(x,y,cor)
            p = plot([coord1(1) coord2(1)],[coord1(2) coord2(2)],cor);
            set(p,'LineWidth',2)
            % Id�ia de colocar um marcador no in�cio do vector
            % m = plot(coord1(1),coord1(2),strcat('*',cor));
            % set(m,'MarkerSize',10)
        end

        %% changeMarker
        % A fun��o changeMarker altera o n�mero de marcadores num plot.
        %
        % *Sintax*
        %
        % |_GraphicsClass_.changeMarker(p,n)|
        %
        % *Arguments*
        %
        % The following table describes the input arguments:
        %
        % <html> <table border=1 width="97%">
        % <tr> <td width="30%"><tt>p</tt></td> <td width="70%">Handle do plot.</td> </tr>
        % <tr> <td width="30%"><tt>n</tt></td> <td width="70%">N�mero de marcadores que devem ser exibidos.</td> </tr>
        % </table> </html>
        %
        % *Description*
        %
        % TEXTO

        function changeMarker(p,n)
            % p - handle of plot
            % n - number of markers

            % Line info
            line_color = get(p,'Color');
            line_Style = get(p,'LineStyle');
            line_LineWidth = get(p,'LineWidth');
            % Marker info
            marker_type = get(p,'Marker');
            marker_size = get(p,'MarkerSize');
            marker_EdgeColor = get(p,'MarkerEdgeColor');
            marker_FaceColor = get(p,'MarkerFaceColor');
            % Axis info
            vec_XData = get(p,'XData');
            vec_YData = get(p,'YData');

            size_XData = length(vec_XData);

            step = floor((size_XData)/(n-1));

            % Fazendo o plot dos marcadores
            p_marker = plot(vec_XData(1:step:end),vec_YData(1:step:end));
            set(p_marker,'LineStyle','none','Marker',marker_type,'MarkerSize',marker_size,...
            	'MarkerEdgeColor',marker_EdgeColor,'MarkerFaceColor',marker_FaceColor)

            % Removendo o marcador do plot original
            set(p,'Marker','none')
            % Remover a visibilidade do handle do original e do marcador
            set(p,'HandleVisibility','off')
            set(p_marker,'HandleVisibility','off')

            % Dummy para legenda
            p_dummy = plot(vec_XData(1),vec_YData(1));
            set(p_dummy,'Color',line_color,'LineStyle',line_Style,'LineWidth',line_LineWidth,...
            	'Marker',marker_type,'MarkerSize',marker_size,...
            	'MarkerEdgeColor',marker_EdgeColor,'MarkerFaceColor',marker_FaceColor)
        end

    end

    %% Properties
    %

    properties
        vehicle
    end
end

%% See Also
%
% <index.html Index>
%
