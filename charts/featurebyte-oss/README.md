# Push local image to local registry

**Edit your /etc/hosts file**

```diff
+ 127.0.0.1    featurebyte.localhost
```

**Push new local image**
```bash
cd featurebyte

docker buildx build . -f docker/Dockerfile -t featurebyte.localhost:10443/featurebyte-server:latest --push
```

**If you are unable to push** its probably you did not add `127.0.0.1    featurebyte.localhost` into your /etc/hosts file


