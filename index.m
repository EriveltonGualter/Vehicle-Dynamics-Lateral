%% Din�mica Veicular
% Esta � a documenta��o do reposit�rio Dinamica-Veicular. Para download dos
% arquivos acessar: <https://github.com/andresmendes/Dinamica-Veicular>
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
%
%% Estudos
% Os estudos s�o os scripts que usam os modelos e seus respectivos dados
% para buscar alguma informa��o � respeito do comportamento din�mico dos
% ve�culos. Estudos necessitam de modelos e dados. Lista dos estudos:
%
% <html> <table border=1 width="97%"> 
% <tr> <td width="30%"> <b> Estudo </b></td> <td width="70%"> <b> Descri��o </b></td> </tr>
% <tr> <td width="30%"> 1. <a href="estudoSimples.html">Simples</a> </td> <td width="70%">Integra��o do modelo para ester�amento nulo e condi��es inicais diferentes de zero.</td> </tr>
% <tr> <td width="30%"> 2. <a href="estudoComparacaoDelta14.html">Compara��o - DELTA = 14</a></td> <td width="70%">Compara��o entre os modelos de pneu para diferentes modelos de ve�culo. Condi��es iniciais nulas e ester�amento igual a 14 graus.</td> </tr>
% <tr> <td width="30%"> 3. <a href="estudoComparacaoDelta45.html ">Compara��o - DELTA = 45</a></td> <td width="70%"> Compara��o entre os modelos de pneu para diferentes modelos de ve�culo. Condi��es iniciais nulas e ester�amento igual a 45 graus.</td> </tr>
% <tr> <td width="30%"> 4. <a href="estudoComparacaoDpsi2.html">Compara��o - dPSI = 2</a></td> <td width="70%"> Compara��o entre os modelos de pneu para diferentes modelos de ve�culo. Ester�amento nulo e condi��es iniciais dadas por: dPSI0 = 2 rad/s e ALPHAT0 = 0 rad.</td> </tr>
% <tr> <td width="30%"> 5. <a href="estudoComparacaoDpsi3com.html">Compara��o - dPSI = 3 com Sadri</a></td> <td width="70%"> Com modelo Sadri. Compara��o entre os modelos de pneu para diferentes modelos de ve�culo. Ester�amento nulo e condi��es iniciais dadas por: dPSI0 = 3 rad/s e ALPHAT0 = 0 rad.</td> </tr>
% <tr> <td width="30%"> 6. <a href="estudoComparacaoDpsi3sem.html">Compara��o - dPSI = 3 sem Sadri</a></td> <td width="70%">Sem modelo Sadri. Compara��o entre os modelos de pneu para diferentes modelos de ve�culo. Ester�amento nulo e condi��es iniciais dadas por: dPSI0 = 3 rad/s e ALPHAT0 = 0 rad.</td> </tr>
% <tr> <td width="30%"> 7. <a href="estudoComparacaoDpsi3est.html">Compara��o - dPSI = 3 estendido</a></td> <td width="70%">Compara��o entre os modelos de pneu <a href="pneuPacejkaFun.html"> Pacejka</a> e <a href="pneuPacejkaEstFun.html"> Pacejka estendido</a>. Ester�amento nulo e condi��es iniciais dadas por: dPSI0 = 3 rad/s e ALPHAT0 = 0 rad.</td> </tr>
% <tr> <td width="30%"> 8. <a href="estudoComparacaoDpsi3veiculo.html">Compara��o - dPSI = 3 veiculo</a></td> <td width="70%">Compara��o entre os modelos de ve�culo com modelo de pneu <a href="pneuPacejkaEstFun.html"> Pacejka estendido</a>. Ester�amento nulo e condi��es iniciais dadas por: dPSI0 = 3 rad/s e ALPHAT0 = 0 rad.</td> </tr>
% </table> </html>
%
%% Modelos
% Os modelos s�o usados pelos sripts de estudo e necessitam de dados.
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
% # <veiculoDadosDelta0.html Dados delta 0>
% # <veiculoDadosDelta14.html Dados delta 14>
% # <veiculoDadosDelta45.html Dados delta 45>
%
% Para os modelos de ve�culo listados acima todos os dados de ve�culo s�o
% compat�veis.
%
% *Dados do pneu*
%
% Lista dos dados para modelos de pneu de acordo com a compatibilidade:
%
% <html> <table border=1 width="97%"> 
% <tr> <td width="25%"> <b> Modelos de pneu </b></td> <td width="25%"> <b> Dados compat�veis </b></td> <td width="50%"> <b> Descri��o </b> </td></tr>
% <tr> <td width="25%"> 1. <a href="pneuLinearFun.html">Pneu linear</a> </td> <td width="25%"> 1. <a href="pneuLinearDados.html">Dados para pneu linear</a> </td> <td width="50%"> Modelo linear de pneu. </td></tr>
% <tr> <td width="25%"> 2. <a href="pneuSadriFun.html">Pneu Sadri</a></td> <td width="25%"> 2. <a href="pneuSadriDadosTaylor.html">Dados para pneu Sadri Taylor</a> <br> 3. <a href="pneuSadriDadosAjuste.html">Dados para pneu Sadri Ajuste</a> </td> <td width="50%"> Modelo n�o linear de terceira ordem. </td></tr>
% <tr> <td width="25%"> 3. <a href="pneuPacejkaFun.html">Pneu Pacejka</a></td> <td width="25%"> 4. <a href="pneuPacejkaDados.html">Dados para pneu Pacejka</a> </td> <td width="50%"> Modelo n�o linear. Equa��o semi emp�rica com coeficientes experimentais </td></tr>
% <tr> <td width="25%"> 4. <a href="pneuPacejkaEstFun.html">Pneu Pacejka estendido</a></td> <td width="25%"> 4. <a href="pneuPacejkaDados.html">Dados para pneu Pacejka</a> </td> <td width="50%"> Modelo n�o linear. Equa��o semi emp�rica com coeficientes experimentais. Tratamento do �ngulo de deriva. </td></tr>
% </table> </html>
%
%% Documenta��o
% Para gerar toda a documenta��o: <docDin.html docDin.m>
%
%% Extra
% Para gerar a figura de fluxograma: <fluxograma.html fluxograma.m>
% Para gerar a animacao: <animacao.html animacao.m>
% Para gerar os vetores na anima��o: <vetor.html vetor.m>
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