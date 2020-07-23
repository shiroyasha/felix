# echo '{ "debug": true }' | sudo tee -a /etc/docker/daemon.json
# sudo service docker restart

BUILDARCH=$(uname -m)
BUILDOS=$(uname -s | tr A-Z a-z)
GOMOD_CACHE="$HOME/go/pkg/mod"
LOCAL_USER_ID=$(id -u)
ARCH="amd64"
PACKAGE_NAME="github.com/projectcalico/felix"
GOFLAGS="-mod=readonly"

mkdir -p .go-pkg-cache bin $GOMOD_CACHE

docker pull "calico/go-build:v0.40"

echo "=========================================="
echo "=========================================="
echo "=========================================="
echo "Running FSCK"
sudo fsck -n /dev/mapper/semaphore--vm--vg-root

echo "=========================================="
echo "=========================================="
echo "=========================================="
echo "Running Go get"

docker run --rm \
  --net=host \
  --init \
  -e GO111MODULE=on \
  -e LOCAL_USER_ID=$LOCAL_USER_ID \
  -e GOCACHE=/go-cache \
  -e GOARCH=$ARCH \
  -e GOPATH=/go \
  -e OS=$BUILDOS \
  -e GOOS=$BUILDOS \
  -e GOFLAGS=$GOFLAGS \
  -v $(pwd):/go/src/$PACKAGE_NAME:rw \
  -v $(pwd)/.go-pkg-cache:/go-cache:rw \
  -w /go/src/$PACKAGE_NAME \
  --entrypoint go \
  "calico/go-build:v0.40" \
  mod download

echo "=========================================="
echo "=========================================="
echo "=========================================="
echo "Running FSCK"

sudo fsck -n /dev/mapper/semaphore--vm--vg-root
