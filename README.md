<h1>CompassUOL DevSecOps Desafio02 - Wordpress</h1> 

<h2>Descrição Geral:</h2>
Este projeto tem como objetivo consolidar conhecimentos em DevSecOps utilizando Docker e AWS. Ele envolve a instalação e configuração do Docker em uma instância EC2, o deploy de uma aplicação WordPress com banco de dados RDS MySQL, a integração com o serviço EFS da AWS para arquivos estáticos, e a configuração de um Load Balancer para gerenciar o tráfego combinado com Auto Scaling.
<br><br/>

![image](https://github.com/user-attachments/assets/d3735872-7f4d-478c-b33f-1ff1c0b160e8)

<h2>Tecnologias usadas:</h2>

- AWS
- Linux
- Docker

<h2>Requisitos:</h2>

Conta AWS com permissões suficientes para:
  
- Criar VPC, Gateway Nat, Security Groups;
- Criar instâncias EC2;
- Criar banco de dados RDS MySQL;
- Criar Elastic File System (EFS);
- Criar Load Balancer;
- Criar Auto Scaling.

<h2>Etapas:</h2>

1. [Criar VPC](#1-criar-vpc)
2. [Criar Gateway NAT](#2-criar-gateway-nat)
3. [Editar Tabela de Rotas das Sub-Redes](#3-editar-tabela-de-rotas-das-sub-redes)
4. [Criar Security Groups](#4-criar-security-groups)
5. [Criar EFS](#5-criar-efs)
6. [Criar RDS](#6-criar-rds)
7. [Subir EC2 publica para Bastion Host (Opcional)](#7-subir-ec2-publica-para-bastion-host)
8. [Criar Template da EC2](#8-criar-template-da-ec2)
9. [Criar Load Balancer](#9-criar-load-balancer)
10. [Criar Auto Scaling](#10-criar-auto-scaling)
11. [Teste de Funcionamento](#11-teste-de-funcionamento)
12. [Materiais de Apoio](#12-materiais-de-apoio)

<h2></h2>

<h3>1. Criar VPC:</h3> 

Pesquise por VPC -> Clique em "Criar VPC" -> Selecione "VPC e muito mais", insira o nome que quiser, caso queira modifciar fica a seu criterio, se baseie na imagem a baixo.

![image](https://github.com/user-attachments/assets/00a4a631-f1cb-44cc-accc-1390abaf5cec)

> [!NOTE]
> Caso deseje adicionar mais zonas de disponibilidade ou sub-redes ai fica a seu criterio, mas para esse laboratório já temos o necessário.
 
<h3>2. Criar Gateway NAT:</h3>

Ainda na "Painel da VPC" na lateral esquerda clique em "Gateways NAT" -> "Criar gateway NAT" -> Insira um nome, selecione a sub-rede publica, mantenha a opção público no "Tipo de conectividade" e para finalizar clique em "Alocar IP elástico".

![image](https://github.com/user-attachments/assets/bae7dba8-9df8-4c5e-b168-74afac87b53c)

<h3>3. Editar Tabela de Rotas das Sub-Redes:</h3>

Também na aba "Painel da VPC" na lateral esquerda clique em "Tabelas de Rotas" -> Selecione uma rede privada, na parte inferior, clique onde está escrito "Rotas" -> "Editar Rotas" -> "Adicionar Rota", preencha conforme a imagem abaixo, primeiro retangulo é "0.0.0.0" depois "Gateway NAT" e em baixo o gateway criado anteriormente.

![image](https://github.com/user-attachments/assets/0d47cf41-23aa-424b-84ad-8a1b492f1ff0)

> [!IMPORTANT]
> Lembra-se de fazer isso na outra sub-rede privada também.

<h3>4. Criar Security Groups:</h3>

Pesquise por Security groups -> "Criar grupo de segurança"

- Decida se vai usar Bastion Host (BH):  
  - Sim: Crie o BH e siga normalmente.  
  - Não: Pule o Security Group "BH" e configure o acesso SSH diretamente na EC2.  

- Sequência para criar Security Groups:  
  - Com BH:  
  BH → EC2 (sem alterar regras de saída) → RDS → EC2 (alterar regras de saída conforme imagens) → EFS.  
  - Sem BH:  
  EC2 (sem alterar regras de saída) → RDS → EC2 (alterar regras de saída conforme imagens) → EFS.  

- Observações:  
  - Escolha nomes e descrições conforme preferir.  
  - Sempre associe os Security Groups à VPC criada anteriormente.  


1. Bastion Host ⚠️(Opcional)⚠️:
  - Regra Entrada:

![image](https://github.com/user-attachments/assets/1b2af0da-dc7d-4edc-a39c-7ae5d6be0df0)

Regra de Entrada SSH, que aponta para o grupo de segurança da EC2.

2. EC2:
  - Regra Entrada:
  
![image](https://github.com/user-attachments/assets/50f9aaec-0e11-4a53-b340-5c8176df074f)

Regra de Entrada SSH, que aponta para o grupo de segurança do Bastion Host(BH).

  - Regra Saída:

![image](https://github.com/user-attachments/assets/8540d4d1-4644-476d-bc8c-402eadd55d20)

Regra de Saída MYSQL/Aurora, que aponta para o grupo de segurança do RDS.

3. RDS:
  - Regra Entrada:

![image](https://github.com/user-attachments/assets/1562a03e-cd4f-4420-a11d-8311a2e69d2e)

Regra de Entrada MYSQL/Aurora, que aponta para o grupo de segurança da EC2.

4. EFS:
  - Regra Entrada: 

![image](https://github.com/user-attachments/assets/4139206c-549a-4b5d-8fe8-4690b9d15068)

Regra de Entrada NFS, que aponta para o grupo de segurança da EC2.

<h3>5. Criar EFS:</h3>

Pesquise EFS -> "Criar sistema de arquivos" -> "Personalizar", insira o nome que desejar e pode avançar para proxima aba, deixe selecionado a VPC criada e nos "Grupos de segurança" selecione o criado para EFS "SG-EFS-Desafio02".

![image](https://github.com/user-attachments/assets/fe73254a-5144-44cd-8f27-0ae8b9d45422)

> [!IMPORTANT]
> Após terminar a criação do EFS, anote o endereço DNS gerado.

<h3>6. Criar RDS:</h3>

Pesquise por RDS, depois em "Criar banco de dados"  
O banco que será usado já vai ser criado junto da criação do RDS, está na parte de configuração Adicional.

- Opções do mecanismo: MySQL;
- Modelos: Nível gratuito;
- Configurações:
  - Identificador do cluster de banco de dados: Atribua o nome que desejar;
- Configurações de credenciais:
  - Nome do usuário principal: admin;
  - Senha principal: Escolha uma senha; 
  - Confirmar senha principal: Repita a senha escolhida;
- Configuração da instância: db.t3.micro;
- Conectividade:
  - Grupos de segurança da VPC existentes: Selecione o "SG-RDS-Desafio02";  
    <b>OBS:</b> Caso o grupo "default" esteja selecionado, desselecione.
- Configuração Adicional:
  - Opções de banco de dados:
    - Nome do banco de dados inicial: Coloque o nome que desejar;

> [!IMPORTANT]
> Lembrese de guardar o nome de usuário, senha, o nome do banco de dados inicial e o endpoint que será gerado após a finalizar a criação do banco.

<h3>7. Subir EC2 publica para Bastion Host:</h3>

### ⚠️ Etapa Opcional ⚠️

Pesquise EC2 -> "Executar Instância"

- Adicione as Tags necessarias;
- Selecione a AMI: Amazon Linux 2;
- Tipo de instância: t2.micro;
- Selecione o seu par de chaves;
- Configurações de rede:
    - Rede: VPC criada;
    - Sub-rede: uma subrede pública;
    - Atribuir IP público automaticamente: Habilitar;
    - Firewall (grupos de segurança): -> Selecionar grupo de segurança existente -> Selecione o "SG-BH-Desafio02";

Pode criar sua instância que servira de Bastion Host já.

<h3>8. Criar Template da EC2:</h3>

Pesquise por "Launch templates" -> "Criar modelo de execução"

- Nome e descrição do modelo de execução: Insira o nome e a descrição que desejar.
- AMI: Amazon Linux 2;
- Tipo de instância: t2.micro;
- Par de chaves (login): Selecione seu par de chaves;
- Configurações de rede:
  - Selecionar grupo de segurança existente:
    - Grupos de segurança: Selecione o grupo da EC2 "SG-EC2-Desafio02";
- Tags de recurso: Preencha com as Tags necessárias;
- Detalhes avançados:
  - Dados do usuário (opcional): Coloque o aquivo user_data.sh aqui;

Já pode voltar para etapa de [Auto Scaling](#9-criar-auto-scaling) agora.

> [!WARNING]
> Lembresse de substituir os valores <DNS_NAME>, <DB_WORDPRESS_HOST>, <DB_WORDPRESS_USER>, etc. Substitua pelos valores salvos durante a criação do EFS e do RDS.

> [!TIP]
> Disponibilizei o arquivo user_data.sh no repositorio, deixei duas opções de script, uma sendo Dockerfile e outra Docker Compose, o presente no user_data.sh é o Dockerfile, caso queira a versão Docker Compose basta copiar o conteudo para dentro do arquivo user_data.sh e salvar, substituindo o script anterior. 

<h3>9. Criar Load Balancer:</h3>

Pesquise por Load balancers -> "Criar load balancer" -> Classic Load Balancer - geração anterior -> "Criar"

- Configuração básica:
  - Nome do load balancer: Escolha o nome que desejar;
- Mapeamento de rede:
  - VPC: Selecione a VPC criada;
  - Zonas de disponibilidade: Marque as zonas disponíveis e deixe nas subredes públicas;
- Grupos de segurança: Selecione o mesmo grupo da EC2; 
- Verificações de integridade:
  - Caminho de ping: /healthcheck.php 

<h3>10. Criar Auto Scaling:</h3>

Pesquise por Auto Scaling groups -> "Criar grupo do Auto Scaling"

- Escolher o modelo de execução:
  - Nome: Fica a seu criterio o nome; 
- Modelo de execução: Selecione o modelo de execução criado;
> [!NOTE]
> Caso não tenha um modelo de execução clique em "Criar um modelo de execução", va para a [etapa 10](#10-criar-template-da-ec2) e depois volte aqui. 

- Rede:
  - VPC: Selecione a VPC criada;
  - Zonas de disponibilidade e sub-redes: Selecione as sub-redes privadas (nesse caso as duas);
- Balanceamento de carga -> Anexar a um balanceador de carga existente;
- Anexar a um balanceador de carga existente -> Escolher entre Classic Load Balancers:
  - Classic Load Balancers: Seleciona o Load Balancers criado;
- Verificações de integridade: Marque a opção "Ative as verificações de integridade do Elastic Load Balancing";
- Tamanho do grupo:
  - Capacidade desejada: 2;
- Adicionar notificações:
  - Adicionar notificação:
    - Criar um tópico: Personalize a notificação do jeito que achar melhor;
- Adicionar etiquetas: Adicione as tags;       

Finalize a criação. Va até a [etapa 11](#11-teste-de-funcionamento) agora para testar e ver se está tudo funcionando.

<h3>11. Teste de Funcionamento</h3>

Para finalizar o projeto, acesse a aba de Load Balancer e copie o DNS correspondente. Em seguida, cole o link no navegador de sua preferência. Atenção: ao colar o link, verifique se o navegador não adicionou automaticamente o "s" ao protocolo "http", transformando-o em "https". No nosso caso, utilizamos exclusivamente o protocolo HTTP. Se necessário, remova o "s" para garantir o funcionamento correto.  
Ao carregar a página, você deverá visualizar uma imagem como esta:

![image](https://github.com/user-attachments/assets/0e64ac61-83f7-4932-8400-7a5eb205f944)

Parabéns você conseguiu concluir esse labóratorio!!! 🎉

<h3>12. Materiais de Apoio:</h3>

https://hub.docker.com/_/wordpress  
https://gist.github.com/morvanabonin/862a973c330107540f28fab0f26181d8  
https://docs.aws.amazon.com/pt_br/AWSEC2/latest/UserGuide/tutorial-ec2-rds-option3.html  
https://www.youtube.com/watch?v=UIbZOjXAJ6U  
https://www.youtube.com/watch?v=U6JB-DJRtOA  
https://www.youtube.com/watch?v=lFTSs8UT_sA  

↩️[Voltar ao Topo](#descrição-geral)
