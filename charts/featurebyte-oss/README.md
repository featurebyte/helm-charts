# Push local image to local registry

**Edit your /etc/hosts file**

```diff
+ featurebyte.localhost 127.0.0.1
```

**Push new local image**
```bash
cd featurebyte

docker buildx build . -f docker/Dockerfile -t featurebyte.localhost:10443/featurebyte-server:latest
```


