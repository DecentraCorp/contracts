// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./interfaces/IDecentraStock.sol";

////////////////////////////////////////////////////////////////////////////////////////////
/// @title DecentraStock
/// @author Christopher Dixon
////////////////////////////////////////////////////////////////////////////////////////////
/**
@notice the DecentraStock contract is a standard ERC20 contract that uses
        Open Zeppelin's smart-contract library. DecentraStock is DecentraCorps
        Membership utility token.
**/
contract DecentraStock is Ownable, ERC20 {
    constructor() ERC20("DecentraStock", "DSK") {
        issueStock(msg.sender, 10000000000000000000000000000);
    }

    /**
  @notice issueStock is a protected function only callable by the DecentraCore contract
  @param _to is the address the DecentraStock is being issued to
  @param _amount is the amount of DecentraStock being issued
    */
    function issueStock(address _to, uint256 _amount) public onlyOwner {
        _mint(_to, _amount);
    }

    /**
  @notice burnStock is a protected function only callable by the DecentraCore contract
  @param _from is the address the DecentraStock is being burned from
  @param _amount is the amount of DecentraStock being burned
    */
    function burnStock(address _from, uint256 _amount) public onlyOwner {
        _burn(_from, _amount);
    }
}
