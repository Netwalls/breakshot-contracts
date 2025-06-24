Snooknet delivers authentic snooker gameplay on Starknet with transparent, low-cost, player-owned mechanics, enabling global competition and rewarding skill with tradable NFT assets and tokens.

## Features
- **Player Management**: Create and manage player profiles on-chain.
- **Match Creation**: Initiate snooker matches with customizable stakes and opponents.
- **Game Lifecycle**: Start, pause, and end matches with timestamp tracking.
- **Tournament System**: Organize and join tournaments with rewards.
- **Error Handling**: Structured error definitions for robust contract interactions.
- **Time Tracking**: Includes game start time to monitor duration.

### Project Structure
```
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
```

## Installation
1. **Clone the Repository**
   ```bash
   git clone https://github.com/your-username/snooknet.git
   cd snooknet
   ```
2. **

### Building the Project
Compile the contract:
```bash
sozo build
```

### Testing
Run tests using Starknet Foundry:
```bash
sozo test
```

### Deployment
Deploy the contract to a Starknet network (e.g., testnet):
```bash
sozo migrate
```
Ensure you have the necessary permissions and funds for deployment.

## Contributing
1. Fork the repository.
2. Create a feature branch (`git checkout -b feature-name`).
3. Commit changes (`git commit -m "Add feature-name"`).
4. Push to the branch (`git push origin feature-name`).
5. Open a Pull Request.

## Contact
For questions or support, reach out via [Telegram](https://t.me/GoSTEAN) or open an issue on GitHub.

## Docker
You can start stack using docker compose. [Here are the installation instruction](https://docs.docker.com/engine/install/)

```bash
docker compose up
```
