FROM golang:1.23rc2-bookworm

# Argument for MAPI_TOKEN
ARG MAPI_TOKEN

# Set MAPI_TOKEN as an environment variable inside the container
ENV MAPI_TOKEN=${MAPI_TOKEN}

WORKDIR /grpc

# Install prerequisites
RUN apt-get -qq -y update \
    && apt-get -qq -y install \
        vim \
        curl \
        protobuf-compiler \
    && go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway@latest \
    && go install google.golang.org/protobuf/cmd/protoc-gen-go@latest \
    && go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest \
    # Install buf
    && go install github.com/bufbuild/buf/cmd/buf@v1.35.1 \
    # Install protoc-gen-openapiv2 Plugin
    && go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@latest \
    # Install Mayhem
    && curl -sS --fail -L https://app.mayhem.security/cli/Linux/install.sh | sh \
    && mkdir -p /usr/local/bin/ \
    && install mapi /usr/local/bin/ \
    && mapi login ${MAPI_TOKEN}

COPY . .

# buf generate
RUN buf generate \
    && go get github.com/unionfindbee/grpc/proto/timeservice \
    && go build -o grpcserver -ldflags="-w -s" ./server.go \
    && go build -o grpcgateway -ldflags="-w -s" ./gateway.go \
    && protoc -I . --openapiv2_out . --openapiv2_opt logtostderr=true timeservice/time_service.proto

CMD ./grpcserver \
    & ./grpcgateway \
    & mapi run forallsecure-demo/grpc/grpc auto "timeservice/time_service.swagger.json" --url "http://localhost:8090/" 

