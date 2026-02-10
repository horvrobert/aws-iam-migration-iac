#!/bin/bash
set -e

# Ensure SSM agent is installed (AL2023-compatible)
dnf -y update
dnf install -y amazon-ssm-agent

# Start and enable the SSM agent
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent
