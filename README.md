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


VPC

![image](https://github.com/user-attachments/assets/00a4a631-f1cb-44cc-accc-1390abaf5cec)


NAT GATEWAY

![image](https://github.com/user-attachments/assets/bae7dba8-9df8-4c5e-b168-74afac87b53c)


ROTAS

![image](https://github.com/user-attachments/assets/839e3701-47c2-42d4-803f-5b8254444632)


Security Groups

BH (Opcional)

![image](https://github.com/user-attachments/assets/0e9248bb-e236-4a29-942b-e5485f353923)

EC2

![image](https://github.com/user-attachments/assets/8f6c7388-5a37-4f53-bda9-cba8533d70d1)

![image](https://github.com/user-attachments/assets/5f4a15c9-657d-45d9-82ef-42b380312021)

OBS: Caso não queira ter um Bastion Host, pode modificar quem tem acesso ao ssh a seu criterio

RDS

![image](https://github.com/user-attachments/assets/912098dd-9b93-42be-adf3-10f05d84952a)

EFS

![image](https://github.com/user-attachments/assets/ff09a509-265b-43d6-8749-85af0c70e6ac)

EFS - Config

![image](https://github.com/user-attachments/assets/14b50540-aa61-41ea-818c-dee1d846ee35)


RDS - Config

Seleciona MYSQL
Modelos - Nivel Gratuito
Configurações - Identificador da instância de banco de dados - de o nome que quiser
              - Configurações de credenciais - Nome do usuário principal - admin
                                             - Senha principal - decida uma senha a sua escolha 
                                             - Confirmar a senha - repita a senha escolhida
              - Configuração da instância - selecione o db.t3.micro      
              - Conectividade - mantenha tudo padrão e privado, sem acesso ao publico, mesma vpc que vc criou e selecione o grupo de segurança que criou, deselecione o default se estiver marcado
              - Configuração Adicional - Opções de banco de dados - Nome do banco de dados inicial - coloque o nome que desejar


Load Balancer - Config

Selecione o Classic Load Balancer
Coloque o nome que desejar
Selecione a VPC criada
Selecione as zonas A a Z disponiveis - em subredes publicas
Grupos de Segurança - mesmo da EC2
Em verificação de integridade mude o /index.html para /healthcheck.php


Auto Scaling - Config

Coloque um nome que desejar
Clique em "Criar um modelo de execução", vc será redirecionado e podera criar um template de EC2 que será utilizado
Apos ter criado o modelo de execução retorne aqui
Selecione o modelo de execução criado, avance
em Rede - selecione a VPC criada e as subrede privadas e pode avaçar
na proxima aba selecione "Anexar a um balanceador de carga existente" - Anexar a um balanceador de carga existente - Escolher entre Classic Load Balancers - selecione o Load Balancer criado
em Verificações de integridade selecione Ative as verificações de integridade do Elastic Load Balancing
na proxima aba em Tamanho do grupo - capacidade desejada - coloque 2 ou o valor que desejar fica a seu criterio, pode avançar
Adicionar notificações - opcional - Adicionar Notificação - personalize a notificação como desejar
Adicione as Etiquetas/Tags
Finalize a criação
Teste de funcionamento <Link>


Modelo de Execução - Config

De um nome para o modelo e depois a descrição
Selecione uma AMI - Amazon Linux 2
Tipo de instância - t2.micro
Par de Chaves - Selecione sua chave de segurança
Configurações de Rede - selecione apenas o grupo de segurança da EC2
Tag de Recurso (nos colocamos umas por ser obrigatoria...)
Detalhes avançados - Dados do usuário (opcional) - selecione o script que achar melhor Dockerfile ou Docker Compose, lembrese que precisa fazer a modificação de nome, eu por padrão deixei o user_data.sh com o codigo que roda Dockerfile, mas caso queira fazer diferente fica a seu criterio, substitua os dados necessario, <DNS_NAME> <DB_WORDPRESS_HOST> <DB_WORDPRESS_USER> .... (para pegar o tal e tal e tal)
pode voltar para a Etapa de Auto Scaling apos terminar de criar


Teste de Funcionamento

Na aba de Load Balancer pegue o DNS e coloque no seu navegador de preferencia, certifiquese que esta no protocolo http e não no https. Pronto vc conseguiu
