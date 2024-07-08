# Cluster

Um Cluster nada mais é do que um conjunto de servidores interconectados, que atuam como se fossem um único sistema e trabalham juntos para realizar tarefas de forma mais eficiente e escalável. 

## 🚀 Começando

A implementação do Cluster Bidirecional aqui proposto foca em apresentar de forma rápida e simples, como o mesmo pode ser construído, utilizando a princípio a plataforma *Docker* para hostear múltiplos serviços/sistemas no mesmo computador, além de também simplificar esse processo com o uso de *Scripts Bash* para a construção do Cluster.

## 📋 Pré-requisitos

**Windows Subsystem For Linux (WSL):** Como o próprio nome diz, WSL é um Subsistema de Windows para o Linux, que nos permite ter acesso ao terminal de um sistema operacional *Linux* diretamente pelo *Windows*, sem precisarmos instalar um novo sistema operacional em nosso computador. <br> 

**Disponível na Microsoft Store ou em:** https://learn.microsoft.com/en-us/windows/wsl/install<br>

**Docker:** Uma plataforma que permite criar, implementar e executar aplicações em contêineres. Contêineres são pacotes de software que incluem todas as dependências necessárias para uma aplicação rodar, como bibliotecas, arquivos de configuração e dependências de runtime, garantindo que ela funcione de maneira consistente em diferentes ambientes. <br>

**Tutorial de instalação disponível em:** https://learn.microsoft.com/en-us/windows/wsl/tutorials/wsl-containers<br>

**MySQL 8.0:** O sistema de gerenciamento de bancos de dados relacional que foi utilizado. <br>

#### Como baixar (acesse seu terminal linux e utilize os comandos):
```sh
sudo apt-get update
sudo apt-get install mysql-server
```

## 🔧 Instalação

<h4>

1 - Clone o repositório: Utilizando `git clone <url>` ou baixe o projeto zipado clicando em `code/Download Zip` <br>
2 - Acesse a pasta que contém o projeto, e a partir dela acesse o `wsl`, para ambiente de teste (que é o caso aqui) recomenda-se utilizar `sudo su`, pois o `wsl` tem alguns problemas de permissão. <br>
3 - Com os dois passos anteriores concluídos, você terá a seguinte estrutura de pastas:
> ```lua
> CLUSTER
> ├── src
> │   ├── default.txt
> │   ├── docker-compose.yml
> │   ├── update.txt
> ├── AVALIAÇÃO.jpg
> ├── cluster.sh
> └── README.md
> ```
4 - Agora assumindo que seu `wsl` possua tanto o `docker` como o `mysql` então você já pode testar o cluster. 
</h4>

## ⚙️ Executando a Avaliação

### Toda a interação foi programada com uma linguagem de scriptagem `bash`, portanto todo o processo de teste foi extremamente simplificado.
### Basta utilizar o arquivo `cluster.sh` com um argumento na frente para executar uma função pré-definida, como no exemplo abaixo:

```bash
./cluster.sh <argumento>
```

---

### **CONFIGURAÇÃO**

| Argumento  | Ação |
| ------------- | ------------- |
| *inicializar*  | Inicializar os *Containers* |
| *configurar*  | Ativar o *Cluster*  |
| *encerrar*  | Encerrar o *Cluster* e *Containers*  |

### **STATUS**

| Argumento  | Ação |
| ------------- | ------------- |
| *master*  | Checar o status do container master |
| *curitiba*  | Checar o status do container curitiba  |
| *maranhao*  | Checar o status do container maranhao  |
| *amapa*  | Checar o status do container amapa  |

### ATALHOS

| Argumento  | Ação |
| ------------- | ------------- |
| *ls*  | Lista os containers atualmente ativos |

### AVALIAÇÃO

| Argumento  | Ação |
| ------------- | ------------- |
| *parte1*  | Para um container e logo após o reinicia |
| *parte2*  | Destroi um container e adiciona um novo |

---