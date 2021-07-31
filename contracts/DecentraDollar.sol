// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./interfaces/IDecentraDollar.sol";

////////////////////////////////////////////////////////////////////////////////////////////
/// @title DecentraDollar
/// @author Christopher Dixon
////////////////////////////////////////////////////////////////////////////////////////////
/**
@notice the DecentraDollar contract is a standard ERC20 contract that uses
        Open Zeppelin's smart-contract library. Decentradollar is designed
        to be a loosly tethered semi-stablecoin
**/
contract DecentraDollar is Ownable, ERC20, IDecentraDollar {
    constructor() ERC20("DecentraDollar", "D$") {
        _mint(msg.sender, 10000000000000000000000000000);
    }

    /**
    @notice mintDD is a protected function only callable by the DecentraCore contract
    @param _to is the address the DecentraDollar is being minted to
    @param _amount is the amount of DecentraDollar being minted
    */
    function mintDD(address _to, uint256 _amount) public override onlyOwner {
        _mint(_to, _amount);
        emit DD_Mined(_to, _amount);
    }

    /**
    @notice  burnDD is a protected function only callable by the DecentraCore contract
    @param _from is the address the DecentraDollar is being burned from
    @param _amount is the amount of DecentraDollar being burned
    */
    function burnDD(address _from, uint256 _amount) public override onlyOwner {
        _burn(_from, _amount);
        emit DD_Burned(_from, _amount);
    }
}
