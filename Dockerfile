FROM ghcr.io/gleam-lang/gleam:v0.19.0-erlang-alpine

# Add project code
WORKDIR /app/
COPY gleam.toml manifest.toml ./
COPY src/ ./src

# Create a group and user
RUN addgroup -S echogroup && adduser -S echouser -G echogroup

# Compile the Gleam application
RUN gleam build && chown -R echouser:echogroup .

# Run as the application user
USER echouser

# Expose a port to accept traffic on
EXPOSE 3000

# Run the application
CMD ["gleam", "run"]
