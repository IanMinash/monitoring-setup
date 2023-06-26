NC='\033[0m'
INFO='\033[1;34m'
SUCCESS='\033[0;32m'

if ! command -v unzip &> /dev/null
then
    echo -e "${INFO}unzip${NC} not be found, installing..."
    sudo apt install unzip
fi

if ! less /etc/passwd | grep 'prometheus' &> /dev/null
then
    echo -e "Creating ${INFO}prometheus${NC} user"
    sudo useradd --system prometheus
    sudo usermod -a -G adm prometheus
fi

read -p "Do you want to install the latest version of Prometheus? (Y/n)" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    PROMETHEUS_URL=$(curl -s https://api.github.com/repos/prometheus/prometheus/releases/latest | grep "browser_download_url.*linux-amd64.tar.gz" | cut -d : -f 2,3 | tr -d \")
    echo "Setting up Prometheus..."

    wget ${PROMETHEUS_URL}
    tar xvf prometheus-*
    rm prometheus-*.tar.gz
    mv prometheus-*/ prometheus
    cp configs/prometheus.yml prometheus/prometheus.yml
    cp configs/prometheus_config prometheus/config

    sed -e "s|<current_dir>|$PWD|g;s|<user>|prometheus|g" ./service_files/prom.service > ./prometheus/prom.service
    sudo mv ./prometheus/prom.service /etc/systemd/system
    mkdir ./prometheus/data
    sudo chown -R prometheus prometheus
    sudo chgrp -R prometheus prometheus

    sudo systemctl start prom.service
    sudo systemctl enable prom.service

    echo -e "Prometheus Service [${SUCCESS}prom.service${NC}] created successfully."
    echo -e "Edit ${INFO}$PWD/prometheus/prometheus-config.yml${NC} to add more integrations."
fi

echo "-------------------------"

read -p "Do you want to install the latest version of Prometheus Node Exporter? (Y/n)" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    NODE_EXPORTER_URL=$(curl -s https://api.github.com/repos/prometheus/node_exporter/releases/latest | grep "browser_download_url.*linux-amd64.tar.gz" | cut -d : -f 2,3 | tr -d \")
    echo "Setting up Prometheus Node Exporter..."

    wget ${NODE_EXPORTER_URL}
    tar xvf node_exporter-*
    rm node_exporter-*.tar.gz
    mv node_exporter-*/ node_exporter
    cp configs/node_exporter_config node_exporter/config
    sed -e "s|<current_dir>|$PWD|g;s|<user>|prometheus|g" ./service_files/prom_node_exporter.service > ./node_exporter/prom_node_exporter.service
    sudo mv ./node_exporter/prom_node_exporter.service /etc/systemd/system/

    sudo systemctl start prom_node_exporter.service
    sudo systemctl enable prom_node_exporter.service

    echo -e "Prometheus Node Exporter Service [${SUCCESS}prom_node_exporter.service${NC}] created successfully."
    echo -e "Edit ${INFO}$PWD/node_exporter/config${NC} to add command-line arguments to the Node Exporter Service."
fi

echo "-------------------------"

read -p "Do you want to install the latest version of Promtail? (Y/n)" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then 
    PROMTAIL_URL=$(curl -s https://api.github.com/repos/grafana/loki/releases/latest | grep "browser_download_url.*promtail.*linux-amd64.zip" | cut -d : -f 2,3 | tr -d \") 
    echo "Setting up Promtail..."

    wget ${PROMTAIL_URL}
    unzip promtail-* -d promtail
    rm promtail-*.zip
    mv promtail/promtail-linux-amd64 promtail/promtail
    sed -e "s|<current_dir>|$PWD|g;s|<user>|prometheus|g" ./service_files/promtail.service > ./promtail/promtail.service
    sudo mv ./promtail/promtail.service /etc/systemd/system/

    echo "enter loki url:"
    read LOKI_URL
    echo "enter host_name:"
    read HOST_NAME
    sed -e "s|<host_name>|$HOST_NAME|g;s|<loki_url>|$LOKI_URL|g" configs/example-promtail-config.yml > ./promtail/promtail-config.yml

    sudo systemctl start promtail.service
    sudo systemctl enable promtail.service

    echo -e "Promtail Service [${SUCCESS}promtail.service${NC}] created successfully."
    echo -e "Edit ${INFO}$PWD/promtail/promtail-config.yml${NC} to add more integrations."
fi

echo "Installation complete!"
