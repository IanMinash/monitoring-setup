if ! less /etc/passwd | grep 'prometheus' &> /dev/null
then
    echo -e "Creating ${INFO}prometheus${NC} user"
    sudo useradd --system prometheus
    sudo usermod -a -G adm prometheus
fi

sed -e "s|User=root|User=prometheus|g" /etc/systemd/system/prom.service
sed -e "s|User=root|User=prometheus|g" /etc/systemd/system/promtail.service
sed -e "s|User=root|User=prometheus|g" /etc/systemd/system/prom_node_exporter.service

sudo chgrp -R prometheus prometheus/data
sudo chown -R prometheus prometheus/data
sudo chown prometheus /tmp/positions.yaml