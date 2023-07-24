# Featurebyte-OSS helm chart repository for kubernetes

This chart is used to deploy featurebyte-oss on kubernetes.

## TL;DR

```bash
# Add mongodb community operator crds
helm upgrade community-operator-crds community-operator-crds -n default --install --repo=https://mongodb.github.io/helm-charts

# Install featurebyte-oss
helm upgrade featurebyte-oss featurebyte-oss -n featurebyte --create-namespace --install --repo=https://featurebyte.github.io/helm-charts
```


## Dependencies

featurebyte-oss chart creates and exposes a mongodb cluster, a redis server and a minio server.
However, we recommend that users have their own mongodb cluster, redis server and s3 storage.

| Dependency | Dev Provider               | Recommended Provider                           |
|------------|----------------------------|------------------------------------------------|
| Mongodb    | Mongodb Community Operator | Any mongodb cluster with replicaset integrated |
| Redis      | `redis/redis`              | Any Redis server                               |
| S3 Storage | `minio/minio`              | A Cloud vendored S3 [GCS / AWS S3 / ... ]      |

### Changing Dependencies

#### Mongodb

To switch mongodb resource to use a different mongodb cluster, change the following values in `values.yaml`

```diff
mongodb:
  # communityOperator or external
- provider: "communityOperator"
+ provider: "external"
  communityOperator:
    password: "your-password"
    passwordRef:
      # passwordRef takes precedence over password
      # if you set mongodb.passwordRef.enabled to true, mongodb.password will be IGNORED
      enabled: false
      name: ""
      key: "password"
  external:
-   connectionStr: "mongodb://<Account>:<Password>external:27017/"
+   connectionStr: "mongodb://<Account>:<Password>@<Host>:<Port>/"
# Specify the connection string required to access the cluster. Do note that the mongodb account
# must be able to manuiplate and create database `featurebyte`.
```

#### Redis

To switch redis resource to use a different redis server, change the following values in `values.yaml`

```diff
redis:
  # standalone or external
- provider: "standalone"
+ provider: "external"
  # If redis is disabled, you would need to specify a redis connection str to connect
  external:
-   connectionStr: "redis://external:6379"
+   connectionStr: "redis://<REDIS_USERNAME>:<REDIS_PASSWORD>@<REDIS_URL>:<REDIS_PORT>"
```

<i>Note: redis simple authentication might not require a redis_username, set it to a random or empty string</i>

#### S3 Storage

To switch s3 storage provider from minio to a cloud vendored s3, change the following values in `values.yaml`

```diff
s3:
  # Use minio for local development
  # Productionize switch to an external s3 provider
  # minio or external
- provider: minio
+ provider: external
  minio:
    rootUser: "root_user"
    rootPassword: "root_password"
    bucketName: "featurebyte"
  # External s3 provider
  # Provide your S3 credentials and config here
  external:
-   url: "<Url>"
-   region: "<Region>"
-   accessKey: "<AccessKey>"
-   secretKey: "<SecretKey>"
-   bucketName: "<BucketName>"
+   url: "https://storage.googleapis.com"
+   region: "us-central1"
+   accessKey: "GH0032412..."
+   secretKey: "someSecretKey"
+   bucketName: "your-bucket-name"
```

## Ingress / Loadbalancer

A Service with the name `{{ include "featurebyte-oss.fullname" . }}-api` will be created.

As the kubernetes admin, create an ingress resource that binds to said service, and users will be able to access the featurebyte-oss api. The `/status` endpoint is a  good candidate to see whether the user can connect to the server.

---

# Values.yaml

| **Key**                                                           	| Type    	| Default                                       	| Description                                                                                             	|
|-------------------------------------------------------------------	|---------	|-----------------------------------------------	|---------------------------------------------------------------------------------------------------------	|
| **nameOverride**                                                  	| string  	| ""                                            	|                                                                                                         	|
| **fullnameOverride**                                              	| string  	| ""                                            	|                                                                                                         	|
| **serviceAccount.create**                                         	| bool    	| true                                          	|                                                                                                         	|
| **serviceAccount.annotations**                                    	| object  	| {}                                            	|                                                                                                         	|
| **serviceAccount.name**                                           	| string  	| ""                                            	|                                                                                                         	|
| **featurebyte.kerberos.enabled**                                  	| bool    	| false                                         	| setup krb config file flag                                                                              	|
| **featurebyte.kerberos.realm**                                    	| string  	| EXAMPLE.COM                                   	| default krb realm used to authenticate featurebyte with active krb cluster                              	|
| **featurebyte.kerberos.kdc**                                      	| string  	| kdc.example.com                               	| krb KDC hostname that is used to obtain service ticket (this must be resolvable within the cluster pod) 	|
| **featurebyte.api.replicaCount**                                  	| int     	| 1                                             	| number of stateless api servers to run (this is ignored when $.autoscaling.enabled == true)             	|
| **featurebyte.api.image.repository**                              	| string  	| featurebyte/featurebyte-server                	|                                                                                                         	|
| **featurebyte.api.image.pullPolicy**                              	| enum    	| IfNotPresent                                  	|                                                                                                         	|
| **featurebyte.api.image.tag**                                     	| string  	| <Unset - Chart.appVersion>                    	|                                                                                                         	|
| **featurebyte.api.resources.requests.cpu**                        	| string  	| 1000m                                         	|                                                                                                         	|
| **featurebyte.api.resource.requests.memory**                      	| string  	| 2Gi                                           	|                                                                                                         	|
| **featurebyte.api.autoscaling.enabled**                           	| bool    	| true                                          	|                                                                                                         	|
| **featurebyte.api.autoscaling.minReplicas**                       	| int     	| 1                                             	|                                                                                                         	|
| **featurebyte.api.autoscaling.maxReplicas**                       	| int     	| 3                                             	|                                                                                                         	|
| **featurebyte.api.autoscaling.targetCPUUtilizationPercentage**    	| int     	| 80                                            	|                                                                                                         	|
| **featurebyte.api.nodeSelector**                                  	| object  	| {}                                            	|                                                                                                         	|
| **featurebyte.api.tolerations**                                   	| array   	| []                                            	|                                                                                                         	|
| **featurebyte.api.affinity**                                      	| object  	| []                                            	|                                                                                                         	|
| **featurebyte.worker.replicaCount**                               	| int     	| 1                                             	| number of worker replicas to spawn (each increment will spawn 1 cpu + 1 io worker)                      	|
| **featurebyte.worker.image.repository**                           	| string  	| featurebyte/featurebyte-server                	|                                                                                                         	|
| **featurebyte.worker.image.pullPolicy**                           	| enum    	| IfNotPresent                                  	|                                                                                                         	|
| **featurebyte.worker.image.tag**                                  	| string  	| <Unset - Chart.appVersion>                    	|                                                                                                         	|
| **featurebyte.worker.resources.requests.cpu**                     	| string  	| 1000m                                         	|                                                                                                         	|
| **featurebyte.worker.resources.requests.memory**                  	| string  	| 1024Mi                                        	|                                                                                                         	|
| **featurebyte.worker.autoscaling.enabled**                        	| bool    	| false                                         	|                                                                                                         	|
| **featurebyte.worker.autoscaling.minReplicas**                    	| int     	| 1                                             	|                                                                                                         	|
| **featurebyte.worker.autoscaling.maxReplicas**                    	| int     	| 3                                             	|                                                                                                         	|
| **featurebyte.worker.autoscaling.targetCPUUtilizationPercentage** 	| int     	| 80                                            	|                                                                                                         	|
| **featurebyte.worker.nodeSelector**                               	| object  	| {}                                            	|                                                                                                         	|
| **featurebyte.worker.tolerations**                                	| array   	| []                                            	|                                                                                                         	|
| **featurebyte.worker.affinity**                                   	| object  	| []                                            	|                                                                                                         	|
| **s3.provider**                                                   	| string  	| minio                                         	| s3 provider for featurebyte [minio/external]                                                            	|
| **s3.minio.rootUser**                                             	| string  	| root_user                                     	| default root user provisioned for minio                                                                 	|
| **s3.minio.rootPassword**                                         	| string  	| root_password                                 	| default root password provisioned for minio                                                             	|
| **s3.minio.bucketName**                                           	| string  	| featurebyte                                   	| default s3 bucket name created for minio                                                                	|
| **s3.minio.image.repository**                                     	| string  	| minio/minio                                   	|                                                                                                         	|
| **s3.minio.image.pullPolicy**                                     	| enum    	| IfNotPresent                                  	|                                                                                                         	|
| **s3.minio.image.tag**                                            	| string  	| RELEASE.2023-06-29T05-12-28Z                  	|                                                                                                         	|
| **s3.minio.persistence.size**                                     	| string  	| 4Gi                                           	|                                                                                                         	|
| **s3.minio.persistence.storageClass**                             	| string  	| standard                                      	|                                                                                                         	|
| **s3.external.url**                                               	| string  	| <URL>                                         	| s3 external URL to be specified. e.g. https://storage.googleapis.com/                                   	|
| **s3.external.region**                                            	| string  	| <Region>                                      	|                                                                                                         	|
| **s3.external.accessKey**                                         	| string  	| <AccessKey>                                   	| s3 HMAC accessKey                                                                                       	|
| **s3.external.secretKey**                                         	| string  	| <SecretKey>                                   	| s3 HMAC secretKey                                                                                       	|
| **s3.external.bucketName**                                        	| string  	| <BucketName>                                  	|                                                                                                         	|
| **mongodb.reduceResources**                                       	| bool    	| false                                         	| testing flag for mongodb to reduce allocated mongodb resources                                          	|
| **mongodb.provider**                                              	| string  	| communityOperator                             	| flag to switch between provisioned mongodb community or external mongodb                                	|
| **mongodb.communityOperator.persistence.storageClass**            	| string  	| standard                                      	|                                                                                                         	|
| **mongodb.communityOperator.persistence.dataSize**                	| string  	| 10G                                           	| PVC allocated to mongodb server data directory                                                          	|
| **mongodb.communityOperator.persistence.logSize**                 	| string  	| 2G                                            	| PVC allocated to mongodb log directory                                                                  	|
| **mongodb.communityOperator.password**                            	| string  	| your-password                                 	|                                                                                                         	|
| **mongodb.communityOperator.passwordRef.enabled**                 	| bool    	| false                                         	| flag to enable selecting the password via an existing secret                                            	|
| **mongodb.communityOperator.passwordRef.name**                    	| string  	| ""                                            	| kubernetes secret name to be referenced                                                                 	|
| **mongodb.communityOperator.passwordRef.key**                     	| string  	| password                                      	| key in mongodb.communityOperator.passwordRef.name whose value is to be used as password                 	|
| **mongodb.external.connectionStr**                                	| string  	| mongodb://<Account>:<Password>external:27017/ 	| external mongodb connectionStr (note the mongodb used must have a replicaset architecture)              	|
| **redis.provider**                                                	| string  	| standalone                                    	| provisioned redis                                                                                       	|
| **redis.standalone.image.repository**                             	| string  	| redis                                         	|                                                                                                         	|
| **redis.standalone.image.pullPolicy**                             	| enum    	| IfNotPresent                                  	|                                                                                                         	|
| **redis.standalone.image.tag**                                    	| string  	| "7.0"                                         	|                                                                                                         	|
| **redis.standalone.persistence.storageClass**                     	| string  	| standard                                      	|                                                                                                         	|
| **redis.standalone.persistence.size**                             	| string  	| 1Gi                                           	|                                                                                                         	|
| **redis.external.connectionStr**                                  	| string  	| "redis//external:6379"                        	| external redis connectionStr                                                                            	|
| **ingress.enabled**                                               	| bool    	| true                                          	|                                                                                                         	|
| **ingress.host**                                                  	| string  	| <UNSET>                                       	| ingress host to connect to featurebyte api service                                                      	|
