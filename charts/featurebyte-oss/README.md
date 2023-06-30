# Featurebyte-OSS helm chart repository for kubernetes

This chart is used to deploy featurebyte-oss on kubernetes.

## Dependencies

featurebyte-oss chart creates and exposes a mongodb cluster, a redis server and a minio server.
However, we recommend that users have their own mongodb cluster, redis server and s3 storage.

| Dependency | Dev Provider               | Recommended Provider                            |
|------------|----------------------------|-------------------------------------------------|
| Mongodb    | Mongodb Community Operator | Any mongodb cluster with replicaset  integrated |
| Redis      | redis/redis                | Any Redis server                                |
| S3 Storage | minio/minio                | A Cloud vendored S3 [GCS / AWS S3 / ... ]       |

## Ingress / Loadbalancer

A Service with the name `{{ include "featurebyte-oss.fullname" . }}-api` will be created.
We highly recommend that you disable the basic ingress that is created by default and define your own ingress
