NC='\033[0m'
INFO='\033[1;34m'
SUCCESS='\033[0;32m'

if ! command -v unzip &> /dev/null
then
    echo -e "${INFO}unzip${NC} not be found, installing..."
    sudo apt install unzip
fi

PROMTAIL_URL='https://github.com/grafana/loki/releases/download/v2.5.0/promtail-linux-amd64.zip'
NODE_EXPORTER_URL='https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz'
PROMETHEUS_URL='https://github.com/prometheus/prometheus/releases/download/v2.34.0/prometheus-2.34.0.linux-amd64.tar.gz'

echo "Setting up Prometheus..."

wget ${PROMETHEUS_URL}
tar xvf prometheus-*
rm prometheus-*.tar.gz
mv prometheus-*/ prometheus/
cp configs/prometheus.yml prometheus/prometheus.yml
cp configs/prometheus_config prometheus/config

# sed -e "s|<current_dir>|$PWD|g;s|<user>|$USER|g" ./service_files/prom.service > /etc/systemd/system/prom.service

# sudo systemctl start prom.service
# sudo systemctl enable prom.service

echo -e "Prometheus Service [${SUCCESS}prom.service${NC}] created successfully."
echo -e "Edit ${INFO}$PWD/prometheus/prometheus-config.yml${NC} to add more integrations."

echo "-------------------------"

echo "Setting up Prometheus Node Exporter..."

wget ${NODE_EXPORTER_URL}
tar xvf node_exporter-*
rm node_exporter-*.tar.gz
mv node_exporter-*/ node_exporter/
cp configs/node_exporter_config node_exporter/config
# sed -e "s|<current_dir>|$PWD|g;s|<user>|$USER|g" ./service_files/prom_node_exporter.service > /etc/systemd/system/prom_node_exporter.service

# sudo systemctl start prom_node_exporter.service
# sudo systemctl enable prom_node_exporter.service

echo -e "Prometheus Node Exporter Service [${SUCCESS}prom_node_exporter.service${NC}] created successfully."
echo -e "Edit ${INFO}$PWD/node_exporter/config${NC} to add command-line arguments to the Node Exporter Service."

echo "-------------------------"

echo "Setting up Promtail..."

wget ${PROMTAIL_URL}
unzip promtail-* -d promtail
rm promtail-*.zip
mv promtail/promtail-linux-amd64 promtail/promtail
cp configs/node_exporter_config node_exporter/config

# sed -e "s|<current_dir>|$PWD|g;s|<user>|$USER|g" ./service_files/promtail.service > /etc/systemd/system/promtail.service
echo "enter loki url:"
read LOKI_URL
echo "enter host_name:"
read HOST_NAME
sed -e "s|<host_name>|$HOST_NAME|g;s|<loki_url>|$LOKI_URL|g" configs/example-promtail-config.yml > ./promtail/promtail-config.yml

# sudo systemctl start promtail.service
# sudo systemctl enable promtail.service

echo -e "Promtail Service [${SUCCESS}promtail.service${NC}] created successfully."
echo -e "Edit ${INFO}$PWD/promtail/promtail-config.yml${NC} to configure Promtail."

echo "-------------------------"


