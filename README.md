Snooknet delivers authentic snooker gameplay on Starknet with transparent, low-cost, player-owned mechanics, enabling global competition and rewarding skill with tradable NFT assets and tokens.


### Project Structure
snooknet/
├── Scarb.toml          # Project configuration
├── src/
│   ├── errors/         # Custom error definitions (e.g., error.cairo)
│   ├── events/         # Event definitions (e.g., events.cairo)
│   ├── interfaces/     # Interface definitions (e.g., ISnooknet.cairo)
│   ├── model/          # Data models (e.g., game_model.cairo)
│   ├── systems/        # Contract logic (e.g., Snooknet.cairo)
│   └── tests/          # Test files (e.g., test_world.cairo)
├── README.md           # This file


## Installation
1. **Clone the Repository**
   ```bash
   git clone https://github.com/your-username/snooknet.git
   cd snooknet
   ```
2. **

```bash
# Run Katana
katana --dev --dev.no-fee
```

#### Terminal two

```bash
# Build the example
sozo build

# Inspect the world
sozo inspect

# Migrate the example
sozo migrate
```

## Docker
You can start stack using docker compose. [Here are the installation instruction](https://docs.docker.com/engine/install/)

```bash
docker compose up
```


