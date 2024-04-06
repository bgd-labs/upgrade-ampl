```diff
diff --git a/raw/etherscan/1_0x6fBC3BE5ee5273598d1491D41bB45F6d05a7541A/AAmplToken/contracts/protocol/tokenization/ampl/AAmplToken.sol b/src/etherscan/1_0x6fBC3BE5ee5273598d1491D41bB45F6d05a7541A/AAmplToken/contracts/protocol/tokenization/ampl/AAmplToken.sol
index 8e21022..1a56220 100644
--- a/raw/etherscan/1_0x6fBC3BE5ee5273598d1491D41bB45F6d05a7541A/AAmplToken/contracts/protocol/tokenization/ampl/AAmplToken.sol
+++ b/src/etherscan/1_0x6fBC3BE5ee5273598d1491D41bB45F6d05a7541A/AAmplToken/contracts/protocol/tokenization/ampl/AAmplToken.sol
@@ -143,7 +143,7 @@ contract AAmplToken is VersionedInitializable, IncentivizedERC20, IAToken {
   bytes32 public constant PERMIT_TYPEHASH =
     keccak256('Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)');
 
-  uint256 public constant ATOKEN_REVISION = 0x1;
+  uint256 public constant ATOKEN_REVISION = 0x2;
   address public immutable UNDERLYING_ASSET_ADDRESS;
   address public immutable RESERVE_TREASURY_ADDRESS;
   ILendingPool public immutable POOL;
@@ -248,6 +248,7 @@ contract AAmplToken is VersionedInitializable, IncentivizedERC20, IAToken {
     uint256 amount,
     uint256 index
   ) external override onlyLendingPool {
+    require(false, 'BURNING_IS_DISABLED');
     uint256 amountScaled = amount.rayDiv(index);
     require(amountScaled != 0, Errors.CT_INVALID_BURN_AMOUNT);
 
@@ -276,6 +277,7 @@ contract AAmplToken is VersionedInitializable, IncentivizedERC20, IAToken {
     uint256 amount,
     uint256 index
   ) external override onlyLendingPool returns (bool) {
+    require(false, 'MINTING_IS_DISABLED');
     uint256 previousBalanceInternal = super.balanceOf(user);
 
     uint256 amountScaled = amount.rayDiv(index);
@@ -351,6 +353,7 @@ contract AAmplToken is VersionedInitializable, IncentivizedERC20, IAToken {
     address target,
     uint256 amount
   ) external override onlyLendingPool returns (uint256) {
+    require(false, 'FLASHLOANING_IS_DISABLED');
     IERC20(UNDERLYING_ASSET_ADDRESS).safeTransfer(target, amount);
     return amount;
   }
@@ -400,6 +403,7 @@ contract AAmplToken is VersionedInitializable, IncentivizedERC20, IAToken {
    * @param validate `true` if the transfer needs to be validated
    **/
   function _transfer(address from, address to, uint256 amount, bool validate) internal {
+    require(false, 'TRANSFER_IS_DISABLED');
     uint256 index = POOL.getReserveNormalizedIncome(UNDERLYING_ASSET_ADDRESS);
     uint256 amountScaled = amount.rayDiv(index);
 
```
