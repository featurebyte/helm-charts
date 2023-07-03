# Featurebyte helm charts

This repository contains helm charts from featurebyte, a feature store used for machine learning application.

The contents are as follows:

| Chart Name      | Description                      |
|-----------------|----------------------------------|
| featurebyte-oss | featurebyte community helm chart |

## Quickstart

Featurebyte uses mongodb community operator to provision a mongodb cluster.
If you already have mongodb community operator installed, you can skip the first step.


```shell
# Install mongodb community operator crds
# DO NOT INSTALL if you already have mongodb community operator crds installed
helm upgrade community-operator-crds community-operator-crds -n default --install --repo=https://mongodb.github.io/helm-charts

helm upgrade featurebyte-oss featurebyte-oss -n featurebyte --create-namespace --install --repo=https://featurebyte.github.io/helm-charts
```

## Pre-requisites

- Kubernetes 1.24+
- Helm 3.2+
- PV storage class provisioner support in the underlying infrastructure
