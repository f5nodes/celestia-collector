# Celestia Collector — Monitoring Tool

Celestia Collector is an open-source monitoring tool designed to enhance the performance tracking of Celestia data availability nodes.

Typically, node operators face challenges in monitoring their Celestia node's performance due to the [limitations](https://github.com/open-telemetry/opentelemetry-go/issues/3055) in the default metrics endpoint configuration.
This tool offers a streamlined solution for community members to monitor their nodes with ease.

## Features
- Data Availability Nodes support.
- Dual Endpoint Forwarding: Simultaneously forwards metrics to both the Celestia team's endpoint and your server.
- Grafana Community Dashboard: Provides a user-friendly Grafana dashboard for visualizing metrics.
- Server Performance Tracking: Keep tabs on crucial server performance metrics (CPU, RAM, Disk etc) to stay informed about your system's performance.
- Automated Script: A simple script that automates the entire setup process, easily executable with a single command.
- Simple Setup with no performance impact to your node.

## Installation

> [!NOTE]
> This guidance assumes you have already [set up](https://github.com/f5nodes/celestia) your node.
>
> You can use [f5nodes/celestia](https://github.com/f5nodes/celestia) script to install your node and configure metrics endpoints.

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

To view your metrics see [Monitoring](#monitoring).

## Architecture
![diagram](https://github.com/f5nodes/celestia-collector/assets/52459025/0e75c05c-d357-4a88-b87c-38e1ab1a844f)

## Monitoring

Access Grafana Dashboard — [celestia.f5nodes.com](https://celestia.f5nodes.com)


![screenshot](https://github.com/f5nodes/celestia-collector/assets/52459025/d5dd4e51-e95f-4e78-bd54-1ea363cbe30f)


## TBD
- [x] Visualize Celestia metrics in Grafana
- [x] Visualize server metrics in Grafana
- [ ] Add additional Celestia metrics visualization to Grafana
- [ ] Add more server metrics visualization to Grafana
