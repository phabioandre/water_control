# Aqua Control
<p align="center">
<img src='https://github.com/phabioandre/water_control/blob/main/assets/images/aquicultura.png' width=50% height=50%>
</p>
O Aqua Control tem como objetivo tornar possível o acompanhamento remoto das condições de processos de Aquicultira (cultivo de organismos aquáticos: peixes, crustáceos, moluscos, algas, répteis e qualquer outra forma de vida aquática de interesse humano, geralmente num espaço confinado e controlado), através da supervisão dos parâmetros Físicos e Químicos do meio aquático utilizado para a cultura. O Aqua Control possibilita ao usuário realizar o acompanhamento em Tempo Real das supervisões dos parâmetros relacionadas a um dos Viveiros instalados na Base de Pesca de Departamento de Pesca da UFRPE. Além disso, é possível também ter acesso aos valores históricos das últimas 24h, com opção de baixar esses dados e exportá-los através de uma planilha editável, em formato excel, que pode ser distribuído entre outros aplicativos do sistema utilizado (WhatsApp, Telegram, etc.). Em conjunto com as supervisões do Viveiro, o Aqua Control disponbiliza ao usuário dados referentes às condições climáticas da região fazendo acesso a Estação Meteorológica instalada no local.

<img src='https://github.com/phabioandre/water_control/blob/main/assets/images/ArquiteturaApp.png'>

Este aplicativo, em versão beta, possui a finalidade de servir como resultado de um trabalho de conclusão realizado para disciplina de Fundamentos de Programação Aplicada (PPGIA7310), do Programa de Pós Graduação em Informática Aplicada (PPGIA) da Universidade Federal Rural de Pernambuco (UFRPE). Portanto, a priori, os dados fornecidos no aplicativo e salvos no Firebase - Firestore, que podem inclusive ser fictícios, serão usados apenas com a finalidade do funcionamento primário proposto pelo aplicativo.

## Requisitos básicos
- Acesso plataforma de IOT utilizada pelo Grupo ao qual este aluno está vinculado para exibir informações de supervisão em tempo real de um viveiro utilizado para Aquicultura;
- Permitir que dados históricos das medições do viveiro supervisionado sejam exibidos;
- Permitir a exportação de dados históricos em formato de planilha Excel;
- Acessar plataforma de Estação Meteorológica utilizada pelo Grupo ao qual este aluno está vinculado para exibir informações de dados disponíveis de um ponto de coleta;
- Utilizar conceitos abordados durante disciplina PPGIA7310 realizada no semestre 2023.1;

## Links
- [Link](https://youtu.be/KxdTlqMCwuk) Para vídeo de apresentação e divulgação do Aplicativo
- [Link](https://youtu.be/Wns7OPwYEJk) Para vídeo de demonstração de uso do Aplicativo
- [Link]() Para acesso ao App no Play Store

## Fluxo de navegação de telas
Abaixo segue fluxo de navegação entre telas do App:
<img src='https://github.com/phabioandre/water_control/blob/main/assets/images/Navega%C3%A7%C3%A3o%20entre%20telas.png'>

## Árvore de Widgets de cada tela

- SignInPage:
<img src='https://github.com/phabioandre/water_control/blob/main/assets/images/SignInPage_widgets.png'>

- HomePage:
<img src='https://github.com/phabioandre/water_control/blob/main/assets/images/HomePage_widgets.png'>

- OnlinePage:
<img src='https://github.com/phabioandre/water_control/blob/main/assets/images/OnLinePage_widgets.png'>

- BeWeatherPage:
<img src='https://github.com/phabioandre/water_control/blob/main/assets/images/BeWeatherPage_widgets.png'>

- ChartPage:
<img src='https://github.com/phabioandre/water_control/blob/main/assets/images/ChartPage_widgets.png'>

## Tecnologias utilizadas
- [Flutter ](https://flutter.dev/) Framework para criação do Aplicativo para plataforma Android
- [Dart](https://dart.dev/) Linguagem de Programação utilizada para desenvolvimento do App
- [ThingsBoard](https://thingsboard.io/) Plataforma para dispositivos IOT;
- [Be Weather](https://beweather.b2ktech.com.br/) Plataforma para monitoramenteo climático;
- [Google Firebase](https://firebase.google.com/docs/auth) Como ferramente de gerenciamento de Autenticação de usuários;

  