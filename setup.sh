#!/bin/bash
# Celestia Collector installation script.
#
# Usage:
# . <(wget -qO- sh.f5nodes.com) celestia-collector -y

echo "Select chain:"
select chain in "mainnet" "mocha" "arabica"; do
    case $chain in
        mainnet)
            endpoint="https://otel.celestia.observer"
            echo "Chain: $chain"
            break
            ;;
        mocha)
            endpoint="https://otel.mocha.celestia.observer"
            echo "Chain: $chain"
            break
            ;;
        arabica)
            endpoint="https://otel.arabica.celestia.observer"
            echo "Chain: $chain"
            break
            ;;
        *)
            echo "Invalid option, please try again."
            ;;
    esac
done

echo "Select node type:"
select node_type in "light" "full" "bridge"; do
    case $node_type in
        light|full|bridge)
            echo "Node type: $node_type"
            break
            ;;
        *)
            echo "Invalid option, please try again."
            ;;
    esac
done

read -p "Enter nodename: " nodename
echo "Nodename: $nodename"

# Install OpenTelemetry

wget https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.94.0/otelcol-contrib_0.94.0_linux_amd64.deb
sudo dpkg -i otelcol-contrib_0.94.0_linux_amd64.deb
rm otelcol-contrib_0.94.0_linux_amd64.deb
otelcol-contrib --version

sudo tee <<EOF >/dev/null /etc/otelcol-contrib/config.yaml
receivers:
  otlp:
    protocols:
      grpc:
      http:
  prometheus:
    config:
      scrape_configs:
      - job_name: 'otel-collector'
        scrape_interval: 10s
        static_configs:
        - targets: ['127.0.0.1:8888']
exporters:
  otlphttp:
    endpoint: $endpoint
  prometheus:
    endpoint: "0.0.0.0:8889"
    namespace: celestia
    send_timestamps: true
    metric_expiration: 180m
    enable_open_metrics: true
    resource_to_telemetry_conversion:
      enabled: true
processors:
  batch:
  memory_limiter:
    limit_mib: 1536
    spike_limit_mib: 512
    check_interval: 5s
service:
  pipelines:
    metrics:
      receivers: [otlp]
      exporters: [otlphttp, prometheus]
EOF

sudo systemctl daemon-reload
sudo systemctl restart otelcol-contrib

# Install Telegraf

wget https://dl.influxdata.com/telegraf/releases/telegraf_1.29.4-1_amd64.deb
sudo dpkg -i telegraf_1.29.4-1_amd64.deb
rm telegraf_1.29.4-1_amd64.deb
telegraf --version

cat <<EOF | sudo tee /etc/telegraf/telegraf.conf
[agent]
  hostname = "$nodename-$chain-$node_type"
  interval = "15s"
  flush_interval = "15s"
  round_interval = true

[[inputs.cpu]]
    percpu = true
    totalcpu = true
    collect_cpu_time = false
    report_active = false
[[inputs.disk]]
    ignore_fs = ["devtmpfs", "devfs"]
[[inputs.mem]]
[[inputs.system]]
[[inputs.swap]]
[[inputs.netstat]]
[[inputs.processes]]
[[inputs.kernel]]
[[inputs.diskio]]

[[inputs.prometheus]]
  urls = ["http://localhost:8889/metrics"]

[[outputs.influxdb_v2]]
  urls = ["https://celestia-metrics.f5nodes.com"]
  token = "TUM74_V-GQACI_LtmCIZ_mNwX1OXk8uMWCT5R0r5CUepsZNb2Qbefaf45G2Me1XRcHGZ5Pr9NhPMQ80LZx2Gow=="
  organization = "celestia-community"
  bucket = "celestia-community-metrics"
EOF

sudo systemctl start telegraf

echo -e "\nCelestia Collector Monitoring Tool succesfully installed and running"
echo -e "To view your metrics visit celestia.f5nodes.com\n"
