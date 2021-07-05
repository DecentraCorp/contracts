//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IDecentraStock is IERC20 {

  event StockIssued(address _to, uint256 _amount);

  /**
@notice issueStock is a protected function only callable by the DecentraCore contract
@param _to is the address the DecentraStock is being issued to
@param _amount is the amount of DecentraStock being issued 
  */
  function issueStock(address _to, uint256 _amount) external;

}
