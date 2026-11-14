FROM golang:1.25-alpine AS build

WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -trimpath -ldflags="-s -w" -o /out/simkdo ./cmd/simkdo

FROM alpine:3.22

RUN addgroup -S app && adduser -S -G app app
COPY --from=build --chown=app:app /out/simkdo /app/simkdo
USER app
EXPOSE 8080
ENTRYPOINT ["/app/simkdo"]
