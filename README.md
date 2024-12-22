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



<b>OBS:</b> Caso deseje adicionar mais zonas de disponibilidade ou subredes ai fica a seu criterio, mas para esse laboratório já temos o necessário.

<h3>2. Criar Gatewat NAT:</h3>

2.1 Mantendo ainda na aba de VPC, na lateral esquerda vai ter a opção Gateway Nat, clique nela e depois em "Criar Gateway NAT".

<h3>3. Editar Tabela de Rotas:</h3>

<b>OBS:</b> Lembrese de fazer isso na outra sub-rede privada também.

<h3>4. Criar Security Groups:</h3>

<h3>5. Subir EC2 pública para Bastion Host (opcional):</h3>

