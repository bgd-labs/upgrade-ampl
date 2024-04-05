// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import 'forge-std/Test.sol';
import 'forge-std/Script.sol';
import {AaveV2Ethereum, AaveV2EthereumAssets} from 'aave-address-book/AaveV2Ethereum.sol';
import {AAmplToken, ILendingPool as OldILendingPool} from '../src/etherscan/1_0x6fBC3BE5ee5273598d1491D41bB45F6d05a7541A/AAmplToken/contracts/protocol/tokenization/ampl/AAmplToken.sol';

/**
 * make deploy-ledger contract=scripts/Deploy.s.sol:DeployMainnet chain=mainnet
 */
contract DeployMainnet is Script {
  function run() external {
    vm.startBroadcast();
    AAmplToken impl = new AAmplToken(
      OldILendingPool(address(AaveV2Ethereum.POOL)),
      AaveV2EthereumAssets.AMPL_UNDERLYING,
      address(AaveV2Ethereum.COLLECTOR),
      'Aave interest bearing AMPL',
      'aAMPL',
      AaveV2Ethereum.DEFAULT_INCENTIVES_CONTROLLER
    );
    impl.initialize(9, 'Aave interest bearing AMPL', 'aAMPL');
  }
}
