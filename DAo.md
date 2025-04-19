# DAO Implementation TODOs

This document outlines the tasks needed to complete the SnookNet DAO implementation.

## Governance Functions

### Proposal Eligibility Check
- [ ] Implement `check_proposal_eligibility` function
  - Connect to GRUFT token contract to check token balance
  - Connect to NFT contract to check NFT ownership count
  - Implement Grandmaster status verification logic
  - Return proper `ProposerRequirements` struct with accurate values

### Voting System
- [ ] Complete the `vote` function implementation
  - Fix the voting power calculation
  - Implement proper NFT vote counting
  - Add validation for voting period
  - Implement vote recording with proper storage access
  - Add event emission when supported

### Proposal Execution
- [ ] Implement `execute_proposal` function
  - Add verification that proposal passed (more for votes than against)
  - Implement proposer-only execution unless auto-execution threshold is met
  - Set execution time for reward claiming
  - Implement the actual execution logic (e.g., calling functions based on execution_hash)

### Reward Distribution
- [ ] Implement `claim_proposal_reward` function
  - Verify proposal was executed
  - Check that waiting period (20 days) has passed
  - Calculate rewards based on proposal impact
  - Distribute tokens to proposer
  - Mark reward as claimed

### Voting Power Management
- [ ] Complete `delegate_voting_power` function
  - Verify delegator has sufficient tokens
  - Update delegation mappings
  - Handle multiple delegations to different addresses
  - Add safeguards against delegation attacks

- [ ] Implement `get_voting_power` function
  - Calculate base power from GRUFT token balance
  - Add power from NFT ownership
  - Apply multipliers based on lock duration
  - Include delegated power from other users

- [ ] Implement `get_total_voting_power` function
  - Sum all GRUFT tokens in circulation
  - Account for locked tokens with multipliers
  - Include NFT voting power

### Auto-Execution System
- [ ] Implement `can_auto_execute` function
  - Check if proposal meets minimum GRUFT votes threshold (200,000)
  - Verify minimum NFT votes threshold (70)
  - Add time-based conditions if needed

## Helper Functions

- [ ] Implement `is_proposal_active` function
  - Check execution status
  - Verify current time is within voting period
  - Add any additional activity conditions

- [ ] Implement `can_execute_proposal` function
  - Check execution status (not already executed)
  - Verify vote counts (more for than against)
  - Check if auto-execution thresholds are met
  - Verify proposer authorization

## Integration Tasks

- [ ] Connect DAO with GRUFT token contract
  - Implement proper interface for GRUFT token
  - Add balance checking functions
  - Implement token transfer for rewards

- [ ] Connect DAO with NFT contract
  - Implement proper interface for NFT contract
  - Add ownership verification
  - Implement NFT-based voting power

## Testing

- [ ] Create unit tests for proposal creation
- [ ] Create unit tests for voting system
- [ ] Create unit tests for proposal execution
- [ ] Create unit tests for reward distribution
- [ ] Create integration tests for the complete governance flow

## Documentation

- [ ] Document all public functions with detailed descriptions
- [ ] Create examples of governance flows
- [ ] Document the relationship between GRUFT tokens, NFTs, and governance power 