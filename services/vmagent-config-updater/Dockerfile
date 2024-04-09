ARG GOLANG_IMAGE=golang
ARG GOLANG_IMAGE_VERSION=1.22
ARG ALPINE_IMAGE=alpine
ARG ALPINE_IMAGE_VERSION=3.19

FROM --platform=${BUILDPLATFORM} ${GOLANG_IMAGE}:${GOLANG_IMAGE_VERSION}-${ALPINE_IMAGE}${ALPINE_IMAGE_VERSION} as builder
ARG BUILDPLATFORM
ARG TARGETOS
ARG TARGETARCH

ARG GOCACHE=/root/.cache/go-build
ARG GOMODCACHE=/go/pkg/mod

RUN go env -w GOCACHE=${GOCACHE}
RUN go env -w GOMODCACHE=${GOMODCACHE}

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN --mount=type=cache,target=${GOCACHE} \
    --mount=type=cache,target=${GOMODCACHE} \
    GOOS=${TARGETOS} GOARCH=${TARGETARCH} CGO_ENABLED=0 \
    go build -trimpath -buildvcs=false \
    -ldflags "-s -w -extldflags -static" -tags 'netgo osusergo nethttpomithttp2' \
    -o /usr/local/bin/vmagent-config-updater

FROM ${GOLANG_IMAGE}:${GOLANG_IMAGE_VERSION}-${ALPINE_IMAGE}${ALPINE_IMAGE_VERSION}
LABEL maintainer="Andrew Ostroumov"

RUN apk --no-cache add ca-certificates

COPY --from=builder /usr/local/bin/vmagent-config-updater /usr/local/bin/vmagent-config-updater

EXPOSE 8436

ENTRYPOINT ["vmagent-config-updater"]
