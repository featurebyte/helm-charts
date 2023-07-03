# Featurebyte-OSS helm chart repository for kubernetes

This chart is used to deploy featurebyte-oss on kubernetes.

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
