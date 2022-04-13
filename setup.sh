NC='\033[0m'
INFO='\033[1;34m'
SUCCESS='\033[0;32m'

echo "Setting up Prometheus..."

sed -e "s|<current_dir>|$PWD|g;s|<user>|$USER|g" ./prometheus/example_prom.service > /etc/systemd/system/prom.service

sudo systemctl start prom.service
sudo systemctl enable prom.service

echo -e "Prometheus Service [${SUCCESS}prom.service${NC}] created successfully."
echo -e "Edit ${INFO}$PWD/prometheus/prometheus-config.yml${NC} to add more integrations."

echo "-------------------------"

echo "Setting up Prometheus Node Exporter..."

sed -e "s|<current_dir>|$PWD|g;s|<user>|$USER|g" ./node_exporter/example_prom_node_exporter.service > /etc/systemd/system/prom_node_exporter.service

sudo systemctl start prom_node_exporter.service
sudo systemctl enable prom_node_exporter.service

echo -e "Prometheus Node Exporter Service [${SUCCESS}prom_node_exporter.service${NC}] created successfully."
echo -e "Edit ${INFO}$PWD/node_exporter/config${NC} to add command-line arguments to the Node Exporter Service."

echo "-------------------------"

echo "Setting up Promtail..."

sed -e "s|<current_dir>|$PWD|g;s|<user>|$USER|g" ./promtail/example_promtail.service > /etc/systemd/system/promtail.service
echo "enter loki url:"
read LOKI_URL
echo "enter host_name:"
read HOST_NAME
sed -e "s|<host_name>|$HOST_NAME|g;s|<loki_url>|$LOKI_URL|g" ./promtail/example-promtail-config.yml > ./promtail/promtail-config.yml

sudo systemctl start promtail.service
sudo systemctl enable promtail.service

echo -e "Promtail Service [${SUCCESS}promtail.service${NC}] created successfully."
echo -e "Edit ${INFO}$PWD/promtail/promtail-config.yml${NC} to configure Promtail."

echo "-------------------------"


