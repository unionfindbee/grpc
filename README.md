## gRPC-Gateway Demo Overview

This demonstration is constructed following the guide available at https://grpc-ecosystem.github.io/grpc-gateway/docs/tutorials/introduction/.

### Run the demo

#### 1. Create a secrets file

Create file called `.env` and inside of it put:  

```
MAPI_TOKEN=<Your Mayhem API Token>
```

#### 2. Build the demo

Simply run:

```
make build
```

#### 3. Run the demo!

Simply run:

```
make run
```

### Manual Setup Requirements

#### 1. Required Software Installations
- Ensure Go is installed: https://go.dev/doc/install
- Ensure protoc is installed: https://grpc.io/docs/protoc-installation/

#### 2. Installation of Necessary Libraries for gRPC and gRPC Gateway
Execute the following commands to install required libraries:
```
go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway@latest
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
```


and

#### 3. Installing bufbuild
For bufbuild installation, refer to https://github.com/bufbuild/buf
For macOS users, use homebrew:
```
brew install bufbuild/buf/buf
```

---
### Building the gRPC Gateway Demo
Initially, clone the repository and then utilize buf along with protoc plugins to generate the necessary server, client, and gateway code by following these steps:

#### 1. Code Generation for gRPC
Execute:
```
buf dep update
buf generate
```

#### 2. Building the gRPC Server and Gateway
Compile using the following commands:
```
go build -o grpcserver -ldflags="-w -s" ./server.go
go build -o grpcgateway -ldflags="-w -s" ./gateway.go
```


#### 3. Execute the Demo
This demo includes two applications:
- grpcserver on port 8080
- grpcgateway on port 8090

Launch them as follows:

In the first terminal:
```
./grpcserver
```

In the second terminal:
```
./grpcgateway
```

You can test using curl, insomnia, or postman. Example with curl:
```
curl -X POST -k http://localhost:8090/v1/example/echo -d '{"name": " hello"}'
```


---

### Generating an OpenAPI Specification from a Proto File
To generate an OAS file based on the proto file, ensure the proto files have the correct API annotations. Here is an annotation example for a service:
```
service TimeCheck {
  // Sends a greeting
  rpc GiveTime (TimeRequest) returns (TimeReply) {
    option (google.api.http) = {
      post: "/api/v1/time"
      body: "*"
    };
  }
}
```

Follow these steps to generate the OpenAPI Specification (OAS):

#### 1. Install protoc-gen-openapiv2 Plugin

- Verify Go installation.
- Install the plugin with:
sh
```
go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@latest
```


#### 2. Generating the OpenAPI Specification

Use the protoc command with the --openapiv2_out option to generate the OpenAPI specification at the project root:

sh
```
protoc -I . --openapiv2_out . --openapiv2_opt logtostderr=true timeservice/time_service.proto
```

The OAS file will be generated in timeservice/time_service.swagger.json

