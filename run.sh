BUILDARCH=$(uname -m)
BUILDOS=$(uname -s | tr A-Z a-z)
GOMOD_CACHE="$HOME/go/pkg/mod"
LOCAL_USER_ID=$(id -u)
ARCH="amd64"
PACKAGE_NAME="github.com/projectcalico/felix"
GOFLAGS="-mod=readonly"

mkdir -p .go-pkg-cache bin $GOMOD_CACHE

docker run --rm \
  --net=host \
  --init \
  -e GO111MODULE=on \
  -v $GOMOD_CACHE:/go/pkg/mod:rw \
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
  "calico/go-build:v0.40" \
  sh -c 'go mod download'
