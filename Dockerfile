FROM golang:1.22-alpine AS build

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 go build -o /out/satoshi-radio-pool-api main.go

FROM alpine:3.20

RUN adduser -D -u 1000 pool
USER pool

COPY --from=build /out/satoshi-radio-pool-api /usr/local/bin/satoshi-radio-pool-api

EXPOSE 8081
ENTRYPOINT ["satoshi-radio-pool-api"]
