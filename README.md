# Featurebyte helm charts

This repository contains helm charts from featurebyte, a feature store used for machine learning application.

The contents are as follows:

| Chart Name      | Description                      |
|-----------------|----------------------------------|
| featurebyte-oss | featurebyte community helm chart |

## Quickstart

Featurebyte uses mongodb community operator to provision

```shell
# Install mongodb community operator crds
helm upgrade community-operator-crds community-operator-crds -n default --install --repo=https://mongodb.github.io/helm-charts
```

## Pre-requisites

- Kubernetes 1.20
- Helm 3.2+
- PV storage class provisioner support in the underlying infrastructure
