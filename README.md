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

Conta AWS com permissões suficientes para
  
- Criar VPC, Gateway Nat, Security Groups;
- Criar instâncias EC2;
- Criar banco de dados RDS MySQL;
- Criar Elastic File System (EFS);
- Criar Load Balancer;
- Criar Auto Scaling.

<h2>Etapas:</h2>

1. Criar VPC;
2. Criar Gateway NAT;
3. Editar Tabela de Rotas;
4. Criar Security Groups;
5. Subir EC2 pública para Bastion Host (opcional);
6. Criar RDS;
7. Criar EFS;
8. Criar Template/Modelo da EC2;
9. Criar Load Balancer;
10. Criar Auto Scaling.

<h2> </h2>
  
<h3>1. Criar VPC:</h3>

1.1 Primeiro va até a aba VPC

![Criar VPC](https://github.com/user-attachments/assets/4de34799-af1a-4b29-a0f4-f7912c25e52a)

1.2 Agora clique em "Criar VPC" e selecione "VPC e muito mais", modifique o nome para o qual desejar. No meu caso preferi "Desafio02" e já pode criar, para esse laboratório não será necessário configurar mais sub-redes ou zonas de disponibilidade.

![VPC e nome](https://github.com/user-attachments/assets/66d163cf-35e9-4929-9611-907612b0c6dd)

<b>OBS:</b> Caso deseje adicionar mais zonas de disponibilidade ou subredes ai fica a seu criterio, mas para esse laboratório já temos o necessário.

<h3>2. Criar Gatewat NAT:</h3>

2.1 Mantendo ainda na aba de VPC, na lateral esquerda vai ter a opção Gateway Nat, clique nela e depois em "Criar Gateway NAT".

![Gateway nat](https://github.com/user-attachments/assets/265dbf1f-f054-4714-ac0f-a4f96c703393)

2.2 Agora de um Nome para seu Gateway NAT, selecione uma das Sub-rede criadas, certifiquese que a sub-rede e o tipo de conectividade sejam publicos ambos, para finalizar aloque um ip elástico, feito todas essas configurações pode criar seu Gateway Nat. Antes de processir para a proxima etapa, espere que o Gateway Nat já está criado e com "Estado" Available, para ver isso na tela de Gateway Nat contem todos os já criados, o "Estado" é uma coluna.

![criando NAT](https://github.com/user-attachments/assets/ec98942c-fe08-4b53-82ea-f7d7a0614b4e)

![image](https://github.com/user-attachments/assets/a5c2764c-0d04-41fe-826a-a92ca546d563)

<h3>3. Editar Tabela de Rotas:</h3>

3.1 Ainda na aba de "Painel da VPC" selecione a opção "Tabelas de rotas" a esquerda, apos isso selecione a sub-rede privada (faça isso para as duas sub-redes privadas disponiveis) e na parte de baixo a coluna "Rotas".

![tabela de rotas](https://github.com/user-attachments/assets/f8fccecc-b1f0-4361-af71-5250f72364ad)

3.2 Agora em "Adicionar Rota"

![cria rota](https://github.com/user-attachments/assets/e4073d54-59a1-4ab3-b596-22551b91f357)

3.3 No primeiro espaço selecione a opção "0.0.0.0", no segundo espaço "Gateway NAT" e em baixo selecione o nat criado.

![configurando rota](https://github.com/user-attachments/assets/76807b98-1598-4199-a885-959df579f82e)

<b>OBS:</b> Lembrese de fazer isso na outra sub-rede privada também.

<h3>4. Criar Security Groups:</h3>

<h3>5. Subir EC2 pública para Bastion Host (opcional):</h3>

