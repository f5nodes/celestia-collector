# Celestia Collector — Monitoring Tool

Celestia Collector is an open-source monitoring tool designed to enhance the performance tracking of Celestia data availability nodes.

Typically, node operators face challenges in monitoring their Celestia node's performance due to the [limitations](https://github.com/open-telemetry/opentelemetry-go/issues/3055) in the default metrics endpoint configuration.
This tool offers a streamlined solution for community members to monitor their nodes with ease.

## Features
- Dual Endpoint Forwarding: Simultaneously forwards metrics to both the Celestia team's endpoint and your server.
- Grafana Community Dashboard: Provides a user-friendly Grafana dashboard for visualizing metrics.
- Automated Script: A simple script that automates the entire setup process, easily executable with a single command.
- Simple Setup with no performance impact to your node.

## Installation

> [!NOTE]
> This guidance assumes you have already [set up](https://github.com/f5nodes/celestia) your node.

1. Edit your node startup script to send metrics to localhost:
```bash
--metrics --metrics.endpoint localhost:4318 --metrics.tls=false
```
2. Execute the [Installation Script](https://github.com/f5nodes/celestia-collector/blob/main/setup.sh) and process the installation:
```bash
. <(wget -qO- sh.f5nodes.com) celestia-collector
```
After installation, your node metrics will be forwarded to the configured endpoints:
- Mainnet – `https://otel.celestia.observer`
- Mocha testnet – `soon`

To view your metrics see [Monitoring](https://github.com/f5nodes/celestia-collector?tab=readme-ov-file#monitoring).

## Architecture

## Monitoring

Access Grafana Dashboard


## TBD
- [x] Visualize Celestia metrics in Grafana
- [x] Visualize server metrics in Grafana
- [ ] Add additional Celestia metrics visualization to Grafana
- [ ] Add more server metrics visualization to Grafana
