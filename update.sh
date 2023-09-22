read -p "Do you want to update to the latest version of Prometheus? (Y/n)" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    PROMETHEUS_URL=$(curl -s https://api.github.com/repos/prometheus/prometheus/releases/latest | grep "browser_download_url.*linux-amd64.tar.gz" | cut -d : -f 2,3 | tr -d \")
    echo "Updating Prometheus..."

    wget ${PROMETHEUS_URL}
    tar xvf prometheus-*
    rm prometheus-*.tar.gz
    mv prometheus-*/ prometheus
    
    sudo systemctl restart prom.service
   
    echo -e "Prometheus Service [${SUCCESS}prom.service${NC}] restarted successfully."
fi

echo "-------------------------"

read -p "Do you want to update to the latest version of Prometheus Node Exporter? (Y/n)" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    NODE_EXPORTER_URL=$(curl -s https://api.github.com/repos/prometheus/node_exporter/releases/latest | grep "browser_download_url.*linux-amd64.tar.gz" | cut -d : -f 2,3 | tr -d \")
    echo "Updating Prometheus Node Exporter..."

    wget ${NODE_EXPORTER_URL}
    tar xvf node_exporter-*
    rm node_exporter-*.tar.gz
    mv node_exporter-*/ node_exporter

    sudo systemctl restart prom_node_exporter.service

    echo -e "Prometheus Node Exporter Service [${SUCCESS}prom_node_exporter.service${NC}] restarted successfully."
fi

echo "-------------------------"

read -p "Do you want to update to the latest version of Promtail? (Y/n)" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then 
    PROMTAIL_URL=$(curl -s https://api.github.com/repos/grafana/loki/releases/latest | grep "browser_download_url.*promtail.*linux-amd64.zip" | cut -d : -f 2,3 | tr -d \") 
    echo "Updating Promtail..."

    wget ${PROMTAIL_URL}
    unzip promtail-* -d promtail
    rm promtail-*.zip
    mv promtail/promtail-linux-amd64 promtail/promtail
    
    sudo systemctl restart promtail.service

    echo -e "Promtail Service [${SUCCESS}promtail.service${NC}] restarted successfully."
fi