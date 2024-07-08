#!/bin/bash

# HUB - INTERFACE #
show_menu() {
  clear
  echo -e "\033[34m-------------------------------------------------------\033[m"
  echo -e "\n\033[36m                 - COMANDOS: CLUSTER -\033[m\n"
  echo -e "\033[34m-------------------------------------------------------\033[m"

  echo -e "\n\033[36m▶ CONFIGURAÇÃO\033[m\n"
  echo -e "- Inicializar: \033[32m./cluster.sh inicializar\033[m"
  echo -e "- Configurar:  \033[32m./cluster.sh configurar\033[m"
  echo -e "- Encerrar:    \033[32m./cluster.sh encerrar\033[m"
   
  echo -e "\n\033[36m▶ STATUS \033[m\n"
  echo -e "- Master:   \033[32m./cluster.sh master\033[m"
  echo -e "- Curitiba: \033[32m./cluster.sh curitiba\033[m"
  echo -e "- Maranhão: \033[32m./cluster.sh maranhao\033[m"
  echo -e "- Amapa:    \033[32m./cluster.sh amapa\033[m"

  echo -e "\n\033[36m▶ ATALHOS \033[m\n"
  echo -e "- Containers: \033[32m./cluster.sh ls\033[m"
      
  echo -e "\n\033[36m▶ AVALIAÇÃO\033[m\n"
  echo -e "- 1ª Parte: \033[32m./cluster.sh parte1\033[m"
  echo -e "- 2ª Parte: \033[32m./cluster.sh parte2\033[m\n"

  echo -e "\033[34m-------------------------------------------------------\033[m\n"
}

if [ -z "$1" ]; then
  show_menu

# INICIALIZAÇÃO  # 
elif [ "$1" == "inicializar" ]; then
    
    # clear

    cd src
    cp default.txt docker-compose.yml

    echo -e "\n\033[34m-------------------------------------------------------\033[m"
    echo -e "\n\033[36m              - INICIALIZANDO O CLUSTER -\033[m\n"
    echo -e "\033[34m-------------------------------------------------------\033[m\n"

    echo -e "\033[36m▶ EXECUTANDO docker-compose up -d\033[m\n"
    docker-compose up -d
    cd ..

    echo -e "\n\033[36m▶ CHECANDO OS CONTAINERS\033[m\n"
    docker ps
    echo ""
    
# CONFIGURAÇÃO  # 
elif [ "$1" == "configurar" ]; then
    
    # clear

    echo -e "\n\033[34m-------------------------------------------------------\033[m"
    echo -e "\n\033[36m              - CONFIGURANDO O CLUSTER -\033[m\n"
    echo -e "\033[34m-------------------------------------------------------\033[m\n"
    
    # Configurando o master-slave
    echo -e "\033[36m▶ CONFIGURANDO O MASTER\033[m"
    sleep 25
 
    docker exec -it AMAPA mysql -uroot -pallenJDK -e"CHANGE MASTER TO MASTER_HOST='MASTER', MASTER_PORT=3306, MASTER_USER='root', MASTER_PASSWORD='allenJDK', MASTER_AUTO_POSITION = 1; START SLAVE;"2>/dev/null   
    docker exec -it CURITIBA mysql -uroot -pallenJDK -e"CHANGE MASTER TO MASTER_HOST='MASTER', MASTER_PORT=3306, MASTER_USER='root', MASTER_PASSWORD='allenJDK', MASTER_AUTO_POSITION = 1;  START SLAVE;"2>/dev/null
    docker exec -it MARANHAO mysql -uroot -pallenJDK -e"CHANGE MASTER TO MASTER_HOST='MASTER', MASTER_PORT=3306, MASTER_USER='root', MASTER_PASSWORD='allenJDK', MASTER_AUTO_POSITION = 1; START SLAVE;"2>/dev/null
   
    echo "                       Configuração Concluída!"

    # Configurando os slaves
    echo -e "\n\033[36m▶ CONFIGURANDO OS SLAVES\033[m"
    sleep 5

    docker exec -it MASTER mysql -uroot -pallenJDK -e"CHANGE MASTER TO MASTER_HOST='CURITIBA', MASTER_PORT=3306, MASTER_USER='root', MASTER_PASSWORD='allenJDK', MASTER_AUTO_POSITION=1 FOR CHANNEL 'curitiba'; START SLAVE FOR CHANNEL 'curitiba';"2>/dev/null   
    echo -e "                        Curitiba Foi Configurado Com Sucesso!"
    sleep 5
    
    docker exec -it MASTER mysql -uroot -pallenJDK -e"CHANGE MASTER TO MASTER_HOST='MARANHAO', MASTER_PORT=3306, MASTER_USER='root', MASTER_PASSWORD='allenJDK', MASTER_AUTO_POSITION=1 FOR CHANNEL 'maranhao'; START SLAVE FOR CHANNEL 'maranhao';"2>/dev/null   
    echo -e "                        Maranhão Foi Configurado Com Sucesso!"
    sleep 5

    docker exec -it MASTER mysql -uroot -pallenJDK -e"CHANGE MASTER TO MASTER_HOST='AMAPA', MASTER_PORT=3306, MASTER_USER='root', MASTER_PASSWORD='allenJDK', MASTER_AUTO_POSITION=1 FOR CHANNEL 'amapa'; START SLAVE FOR CHANNEL 'amapa';"2>/dev/null   
    echo -e "                        Amapa Foi Configurado Com Sucesso!\n"
    sleep 5

# ENCERRAR  # 
elif [ "$1" == "encerrar" ]; then
    
    # clear

    echo -e "\n\033[34m-------------------------------------------------------\033[m"
    echo -e "\n\033[36m              - ENCERRANDO O CLUSTER -\033[m\n"
    echo -e "\033[34m-------------------------------------------------------\033[m\n"

    cd src
    echo -e "\033[36m▶ EXECUTANDO docker-compose down\033[m\n"
    docker-compose down
    cd ..

    echo -e "\n\033[36m▶ LIMPANDO O ESPAÇO GASTO PELO CLUSTER\033[m\n"
    docker volume prune -a -f
    docker network prune -f

    docker ps
    echo ""

# MASTER - STATUS #
elif [ "$1" == "master" ]; then 

    echo -e "\n\033[34m-------------------------------------------------------\033[m"
    echo -e "\n\033[36m                 - STATUS DO MASTER -\033[m\n"
    echo -e "\033[34m-------------------------------------------------------\033[m\n"

    echo -e "\033[36m▶ STATUS DO CHANNEL:\033[m \033[33mcuritiba\033[m\n"
    docker exec -it MASTER mysql -uroot -pallenJDK -e"SHOW REPLICA STATUS FOR CHANNEL 'curitiba'\G"

    echo -e "\n\033[36m▶ STATUS DO CHANNEL:\033[m \033[33mmaranhao\033[m\n"
    docker exec -it MASTER mysql -uroot -pallenJDK -e"SHOW REPLICA STATUS FOR CHANNEL 'maranhao'\G"

    echo -e "\n\033[36m▶ STATUS DO CHANNEL:\033[m \033[33mamapa\033[m\n"
    docker exec -it MASTER mysql -uroot -pallenJDK -e"SHOW REPLICA STATUS FOR CHANNEL 'amapa'\G"
    echo ""

# CURITIBA - STATUS #
elif [ "$1" == "curitiba" ]; then

    echo -e "\n\033[34m-------------------------------------------------------\033[m"
    echo -e "\n\033[36m                 - STATUS DE CURITIBA -\033[m\n"
    echo -e "\033[34m-------------------------------------------------------\033[m\n" 
    
    docker exec -it CURITIBA mysql -uroot -pallenJDK -e"SHOW REPLICA STATUS\G"
    echo ""
    
# MARANHAO - STATUS #
elif [ "$1" == "maranhao" ]; then 

    echo -e "\n\033[34m-------------------------------------------------------\033[m"
    echo -e "\n\033[36m                 - STATUS DE MARANHÃO -\033[m\n"
    echo -e "\033[34m-------------------------------------------------------\033[m\n" 
    
    docker exec -it MARANHAO mysql -uroot -pallenJDK -e"SHOW REPLICA STATUS\G"
    echo ""

# AMAPA - STATUS #
elif [ "$1" == "amapa" ]; then 

    echo -e "\n\033[34m-------------------------------------------------------\033[m"
    echo -e "\n\033[36m                 - STATUS DE AMAPA -\033[m\n"
    echo -e "\033[34m-------------------------------------------------------\033[m\n" 
    
    docker exec -it AMAPA mysql -uroot -pallenJDK -e"SHOW REPLICA STATUS\G"
    echo ""

# LS #
elif [ "$1" == "ls" ]; then 

    echo -e "\n\033[34m-------------------------------------------------------\033[m"
    echo -e "\n\033[36m                     - CONTAINERS -\033[m\n"
    echo -e "\033[34m-------------------------------------------------------\033[m\n" 
    
    docker ps 

    echo ""

# PARTE 1 #
elif [ "$1" == "parte1" ]; then 

    echo -e "\n\033[34m-------------------------------------------------------\033[m"
    echo -e "\n\033[36m             - PARTE 1: PARAR CONTAINER -\033[m\n"
    echo -e "\033[34m-------------------------------------------------------\033[m\n" 

    echo -e "\033[36m▶ PARANDO O CONTAINER:\033[m \033[33mMARANHÃO\033[m\n"
    
    cd src
    docker-compose stop maranhao
    cd ..

    echo -e "\n\033[36m▶ PARA REATIVAR O CONTAINER PRESSIONE QUALQUER TECLA...\033[m"
    read 
    
    echo -e "\033[36m▶ REATIVANDO O CONTAINER:\033[m \033[33mMARANHÃO\033[m\n"
    cd src 
    docker-compose up -d maranhao
    cd ..

    echo ""

# PARTE 2 #
elif [ "$1" == "parte2" ]; then 

    echo -e "\n\033[34m-------------------------------------------------------\033[m"
    echo -e "\n\033[36m             - PARTE 2: NOVO CONTAINER -\033[m\n"
    echo -e "\033[34m-------------------------------------------------------\033[m\n" 
 
    echo -e "\033[36m▶ MATANDO O CONTAINER:\033[m \033[33mMARANHÃO\033[m\n"
    cd src
    docker-compose stop maranhao
    docker exec -it MASTER mysql -uroot -pallenJDK -e"STOP SLAVE FOR CHANNEL 'maranhao';"2>/dev/null   

    echo -e "\n\033[36m▶ FORMATANDO O CONTAINER:\033[m \033[33mMARANHÃO\033[m\n"
    docker-compose rm -v maranhao
    docker volume rm -f cluster_maranhaoVol
    
    echo -e "\n\033[36m▶ PARAR INSERIR UM NOVO CONTAINER PRESSIONE QUALQUER TECLA...\033[m"
    read

    > docker-compose.yml
    cp update.txt docker-compose.yml
    docker-compose up -d

    sleep 25
    docker exec -it BAHIA mysql -uroot -pallenJDK -e"CHANGE MASTER TO MASTER_HOST='MASTER', MASTER_PORT=3306, MASTER_USER='root', MASTER_PASSWORD='allenJDK', MASTER_AUTO_POSITION = 1; START SLAVE;"2>/dev/null
    docker exec -it MASTER mysql -uroot -pallenJDK -e"CHANGE MASTER TO MASTER_HOST='BAHIA', MASTER_PORT=3306, MASTER_USER='root', MASTER_PASSWORD='allenJDK', MASTER_AUTO_POSITION=1 FOR CHANNEL 'bahia'; START SLAVE FOR CHANNEL 'bahia';"2>/dev/null
    echo ""
    
else
    show_menu
fi
