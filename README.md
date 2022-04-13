# Prometheus Setup

Quick setup of Prometheus, Prometheus Node Exporter extension and Promtail
service. Grafana Loki is not included as it is assumed to be on an external
host.

## Prometheus

`Version 2.34.0`

See Prometheus Documentation [here](https://prometheus.io/docs/introduction/overview/).

- Port: `9090`
- Service Name: `prom.service`
- CLI Args File: `./prometheus/config`
- Config File: `./prometheus/prometheus-config.yml`

## Prometheus Node Exporter

`Version 1.3.1`

See Prometheus Node Exporter Documentation [here](https://github.com/prometheus/node_exporter/blob/master/README.md).

- Port: `9100`
- Service Name: `prom_node_exporter.service`
- CLI Args File: `./node_exporter/config`

## Promtail

`Version 2.5.0`

See Promtail Documentation [here](https://grafana.com/docs/loki/latest/clients/promtail/).

- Port: `9080`
- Service Name: `promtail.service`
- Config File: `./promtail/promtail-config.yml`
