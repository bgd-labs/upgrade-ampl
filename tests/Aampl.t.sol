// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import {Test} from 'forge-std/Test.sol';
import {AaveV2Ethereum, AaveV2EthereumAssets} from 'aave-address-book/AaveV2Ethereum.sol';
import {AAmplToken, ILendingPool as OldILendingPool} from '../src/etherscan/1_0x6fBC3BE5ee5273598d1491D41bB45F6d05a7541A/AAmplToken/contracts/protocol/tokenization/ampl/AAmplToken.sol';
import {IERC20} from '../src/etherscan/1_0x6fBC3BE5ee5273598d1491D41bB45F6d05a7541A/AAmplToken/contracts/dependencies/openzeppelin/contracts/IERC20.sol';

contract AamplTest is Test {
  address constant aAMPL_WHALE = 0xF03387d8d0FF326ab586A58E0ab4121d106147DF;
  address constant vAMPL_WHALE = 0xAa24D0Ee83CB785Be0A571692e516fa62Ba43eF3;
  address constant AMPL_WHALE = 0x7b32Ec1A1768cfF4a2Ef7B34bc1783eE1F8965F9;
  address constant vAMPL_LIQUIDATABLE = 0xe684700BA51280Da463c1aA0f46Ee52098B87538;

  function setUp() public {
    vm.createSelectFork(vm.rpcUrl('mainnet'), 19561616);
    AAmplToken impl = new AAmplToken(
      OldILendingPool(address(AaveV2Ethereum.POOL)),
      AaveV2EthereumAssets.AMPL_UNDERLYING,
      address(AaveV2Ethereum.COLLECTOR),
      'Ampl',
      'Ampl',
      AaveV2Ethereum.DEFAULT_INCENTIVES_CONTROLLER
    );
    vm.prank(AaveV2Ethereum.POOL_ADMIN);
    AaveV2Ethereum.POOL_CONFIGURATOR.updateAToken(
      AaveV2EthereumAssets.AMPL_UNDERLYING,
      address(impl)
    );
  }

  function _fundAddress(address receiver, uint256 amount) internal {
    vm.prank(AMPL_WHALE);
    IERC20(AaveV2EthereumAssets.AMPL_UNDERLYING).transfer(receiver, amount);
  }

  function test_withdraw() public {
    _fundAddress(AaveV2EthereumAssets.AMPL_A_TOKEN, 1e9);

    vm.prank(aAMPL_WHALE);
    vm.expectRevert(bytes('BURNING_IS_DISABLED'));
    AaveV2Ethereum.POOL.withdraw(AaveV2EthereumAssets.AMPL_UNDERLYING, 1e9, address(42));
  }

  function test_repay() public {
    _fundAddress(vAMPL_WHALE, 1e9);

    vm.startPrank(vAMPL_WHALE);
    IERC20(AaveV2EthereumAssets.AMPL_UNDERLYING).approve(address(AaveV2Ethereum.POOL), 1e9);
    AaveV2Ethereum.POOL.repay(AaveV2EthereumAssets.AMPL_UNDERLYING, 1e9, 2, vAMPL_WHALE);
  }

  function test_transfer() public {
    vm.prank(aAMPL_WHALE);
    vm.expectRevert(bytes('TRANSFER_IS_DISABLED'));
    IERC20(AaveV2EthereumAssets.AMPL_A_TOKEN).transfer(address(42), 1e9);
  }

  function test_transferFrom() public {
    vm.prank(aAMPL_WHALE);
    IERC20(AaveV2EthereumAssets.AMPL_A_TOKEN).approve(address(this), 1e9);

    vm.expectRevert(bytes('TRANSFER_IS_DISABLED'));
    IERC20(AaveV2EthereumAssets.AMPL_A_TOKEN).transferFrom(aAMPL_WHALE, address(42), 1e9);
  }

  function test_liquidation() public {
    _fundAddress(address(this), 5000e9);

    IERC20(AaveV2EthereumAssets.AMPL_UNDERLYING).approve(
      address(AaveV2Ethereum.POOL),
      type(uint256).max
    );
    AaveV2Ethereum.POOL.liquidationCall(
      AaveV2EthereumAssets.WETH_UNDERLYING,
      AaveV2EthereumAssets.AMPL_UNDERLYING,
      vAMPL_LIQUIDATABLE,
      type(uint256).max,
      false
    );
  }

  function test_flash() public {
    _fundAddress(address(AaveV2EthereumAssets.AMPL_A_TOKEN), 5000e9);

    address[] memory assets = new address[](1);
    assets[0] = AaveV2EthereumAssets.AMPL_UNDERLYING;
    uint256[] memory amounts = new uint256[](1);
    amounts[0] = 10e9;
    uint256[] memory modes = new uint256[](1);
    modes[0] = 0;

    vm.expectRevert(bytes('FLASHLOANING_IS_DISABLED'));
    AaveV2Ethereum.POOL.flashLoan(
      address(this),
      assets,
      amounts,
      modes,
      address(this),
      bytes(''),
      0
    );
  }
}
