%% Din�mica Veicular
% Esta � a documenta��o do reposit�rio Dinamica-Veicular. Para download dos
% arquivos acessar:
%
%% Organiza��o
% Este reposit�rio � organizado em tr�s camadas (ESTUDOS, MODELOS e DADOS)
% com mostrado na figura abaixo.
%%
%
% <<fluxograma_01.png>>
%
% A seguir cada camada � apresentada com os scripts dispon�veis e os links
% para maiores informa��es.
%% Estudos
% Os estudos s�o os scripts que usam os modelos e seus respectivos dados
% para buscar alguma informa��o � respeito do comportamento din�mico dos
% ve�culos. Estudos necessitam de modelos e dados. Lista dos estudos:
%
% * <simulacao.html Simula��o simples>
% * <comparacaoDelta14.html Compara��o - DELTA = 14>
% * <comparacaoDelta45.html Compara��o - DELTA = 45>
% * <comparacaoDpsi2.html Compara��o - dPSI = 2>
% * <comparacaoDpsi3.html Compara��o - dPSI = 3>
%
%% Modelos
% Os modelos s�o usados pelos sripts de estudos e necessitam de dados.
%
% *Modelo de ve�culo*
%
% Os modelos de ve�culo s�o as equa��es diferenciais que descrevem a
% din�mica do ve�culo. Os modelos dispon�veis s�o:
%
% # <veiculoLinear2gdl.html Linear com 2 GDL>
% # <veiculoNaoLinear2gdl.html N�o linear com 2 GDL>
% # <veiculoNaoLinear3gdl.html N�o linear com 3 GDL>
%
% Para maiores detalhes ver: <veiculoDoc.html Modelo de ve�culo>.
%
% *Modelos de pneu*
%
% Os modelos de pneu descrevem a curva caracter�stica do pneu. Os modelos
% dispon�veis s�o:
%
% # <pneuLinearFun.html Pneu linear>
% # <pneuSadriFun.html Pneu Sadri>
% # <pneuPacejkaFun.html Pneu Pacejka>
% # <pneuPacejkaEstFun.html Pneu Pacejka Estendido>
%
% Para maiores detalhes ver: <pneuDoc.html Modelo de pneu>.
%
%% Dados
% Os dados s�o usados pelos scripts de modelos que por sua vez s�o usados
% pelos scripts de estudos.
%
% *Dados de ve�culo*
%
% Lista de dados para modelos de ve�culo:
%
% # <veiculoDadosScript.html Dados para o ve�culo 1>
% # <veiculoDadosScript14.html Dados para o ve�culo 2>
% # <veiculoDadosScript45.html Dados para o ve�culo 3>
%
% *Dados do pneu*
%
% Lista dos dados para modelos de pneu:
%
% # <pneuLinearDados.html Dados para o pneu linear>
% # <pneuSadriDadosTaylor.html Dados para o pneu Sadri - S�rie de Taylor>
% # <pneuSadriDadosAjuste.html Dados para o pneu Sadri - Ajuste>
% # <pneuPacejkaDados.html Dados para o pneu Pacejka>
%
%% Documenta��o
% Para gerar toda a documenta��o: <docDin.html docDin.m>
%
%% Extra
% Para gerar a figura de fluxograma: <fluxograma.html fluxograma.m>
%
%% Encoding
% Todos os arquivos deste reposit�rio utilizam o encoding: windows-1252 (via
% Sublime3). Logo, o encoding do Matlab deve ser o mesmo. Para isto, utilize
% o seguinte c�digo na linha de comando:

% Verifica o encoding:
slCharacterEncoding() 
% Modifica o encoding para 'windows-1252'
slCharacterEncoding('Windows-1252')

%%
% Para rodar os c�digos em sistemas operacionais Windows (Testado em
% Windows(7)/Matlab 2014a): sem problemas pois encoding windows-1252 � o
% padr�o (Verificar com os comandos acima). Por�m o texto no editor ou em
% figuras pode apresentar erros quando executados em sistemas operacionais
% Linux.
%
% Para rodar em Linux (Testado em Ubuntu14.04)/Matlab 2013a): com problemas
% pois UTF-8 � o padr�o (Verificar). Logo:
%
% * Usar na linha de comando: 'slCharacterEncoding('Windows-1252')'
% * Mesmo assim editor n�o funciona: n�o exibe os caracteres corretamente
% (Usar
% 	Sublime-Text por exemplo)
% * Os gr�ficos ficam direito.
%