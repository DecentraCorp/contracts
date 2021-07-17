//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IDecentraDollar is IERC20 {

  event DD_Mined(address _to, uint256 _amount);

  event DD_Burned(address _to, uint256 _amount);

  /**
  @notice mintDD is a protected function only callable by the DecentraCore contract
  @param _to is the address the DecentraDollar is being minted to
  @param _amount is the amount of DecentraDollar being minted
  */
   function mintDD(address _to, uint256 _amount) external;

   /**
   @notice  burnDD is a protected function only callable by the DecentraCore contract
   @param _from is the address the DecentraDollar is being burned from
   @param _amount is the amount of DecentraDollar being burned
   */
   function burnDD(address _from, uint256 _amount) external;

}
