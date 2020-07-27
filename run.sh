sudo apt-get remove --purge docker-ce docker-ce-cli
sudo apt-get install -y docker-ce=5:19.03.11~3-0~ubuntu-bionic docker-ce-cli=5:19.03.11~3-0~ubuntu-bionic

BUILDARCH=$(uname -m)
BUILDOS=$(uname -s | tr A-Z a-z)
GOMOD_CACHE="$HOME/go/pkg/mod"
LOCAL_USER_ID=$(id -u)
ARCH="amd64"
PACKAGE_NAME="github.com/projectcalico/felix"
GOFLAGS="-mod=readonly"

mkdir -p .go-pkg-cache bin $GOMOD_CACHE

docker pull "calico/go-build:v0.40"

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
  "golang:1.13.7" \
  sh -c 'go mod download'
