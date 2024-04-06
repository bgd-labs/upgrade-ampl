# aAMPL (aToken) v2 Ethereum upgrade

Repository containing an upgrade for the aAMPL implementation on Aave v2 Ethereum, simply halting transfers and withdrawals.

More context can be found [HERE](https://snapshot.org/#/aave.eth/proposal/0xb7226dd6441b67225924082215f7a512bfd98252897ee43a879084e07ab53607) and the associated forum post.

## Contents

- The new implementation is a modification from production aAMPL, just reverting the operations to be halted. Can be found [HERE](https://github.com/bgd-labs/upgrade-ampl/blob/main/src/etherscan/1_0x6fBC3BE5ee5273598d1491D41bB45F6d05a7541A/AAmplToken/contracts/protocol/tokenization/ampl/AAmplToken.sol)
- The contracts has been deployed [HERE](https://etherscan.io/address/0x1f32642b216d19daeb1531862647195a626f4193#code).
- Code diffs between the current implementation and the new one can be found [HERE](https://github.com/bgd-labs/upgrade-ampl/blob/main/diffs/atoken_impl.md)
