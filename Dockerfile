FROM golang:1.23rc2-bookworm

# Install prerequisites
RUN apt-get -y update \
    && apt-get -y install vim \
    && go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway@latest \
    && go install google.golang.org/protobuf/cmd/protoc-gen-go@latest \
    && go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

# Install buf
RUN go install github.com/bufbuild/buf/cmd/buf@v1.35.1

WORKDIR /grpc

COPY . .

# buf generate
RUN buf generate