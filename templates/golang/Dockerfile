FROM golang:1.21-alpine3.19 AS builder

WORKDIR /app

COPY git-repository/ /app
COPY main.go /app
COPY go.mod /app
COPY go.sum /app
COPY entrypoint.sh /app

# Download and install dependencies
RUN go mod download

# Build the Go application
RUN go build -o main .


# Create a minimal image
FROM alpine:3.19

WORKDIR /app

# Copy the built binary from the builder stage
COPY --from=builder /app/main /app/main
COPY --from=builder /app/entrypoint.sh /app/entrypoint.sh

# this avoid run as root. without this, files created inside
# the container have messed permissions when linked to local volumes.
# use uid 1000 solve the problem to bind volumes from 'my machine' and
# container volume
RUN adduser --system --uid 1000 --group testuser

RUN chown -R testuser:testuser /app

USER testuser

CMD ["./entrypoint.sh"]
