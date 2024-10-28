FROM golang:1.22-alpine AS builder
ARG GIT_HASH

WORKDIR /

COPY go.mod go.sum ./
RUN go mod download

COPY . .

ENV CGO_ENABLED=0 GOOS=linux
RUN go build -ldflags "-X main.GitHash=$GIT_HASH" -o mox ./cmd/mox/*.go

FROM alpine:latest

WORKDIR /

COPY --from=builder /mox .

ENTRYPOINT ["/mox"]
