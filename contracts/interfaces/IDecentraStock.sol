// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IDecentraStock is IERC20 {
    event StockIssued(address _to, uint256 _amount);
    event StockBurned(address _from, uint256 _amount);

    /////Need to add additional event for burn before next deployment
    /**
@notice issueStock is a protected function only callable by the DecentraCore contract
@param _to is the address the DecentraStock is being issued to
@param _amount is the amount of DecentraStock being issued
  */
    function issueStock(address _to, uint256 _amount) external;

    /**
@notice burnStock is a protected function only callable by the DecentraCore contract
@param _from is the address the DecentraStock is being burned from
@param _amount is the amount of DecentraStock being burned
  */
    function burnStock(address _from, uint256 _amount) external;
}
