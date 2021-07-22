//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./BancorFormulaI.sol";


interface IDecentraBank {

  event StockPurchased(uint256 dollarAmount, uint256 stockAmount, address buyer);

  event StockSold(uint256 dollarAmount, uint256 stockAmount, uint reserveAmountAdded, address seller);

  event FundWithdrawl(uint256 dollarAmount, address tokenType);

  event NewCollateral(address collateral);

  /**
  @notice purchaseStock is used to purchase DecentraStock at its current price
          as set by the DecentraBank bonding curve
  @param _amount is the dollar amount being purchased
  @param _token is the address of the approved collateral type being used
  */
  function purchaseStock(uint256 _amount, address _token) external;

  /**
  @notice sellStock is used to sell DecentraStock back to the DecentraBank bonding curve
  @param _amount is the amount of DecentraStock being sold
  */
  function sellStock(uint256 _amount) external;

  /**
  @notice addNewCollateralType is a protected function that allows the owner of this
          contractto add a new collateral type to the DecentraBank
  @param _collateral is the address of the new ERC20 collateral being added
  @dev this function should only be used to add stablecoins ass collateral
  */
  function addNewCollateralType(address _collateral) external;

  /**
  @notice fundWithdrawl allows the owner of this contract to withdraw earned funds from the DecentraBank
  @param _to is the address the funds are being withdrawn to
  @param _type is the address of the collateral type being withdrawn
  */
  function fundWithdrawl(address _to, address _type) external;

  /**
  @notice calculatePoolBal is used to calculate the total pool balance of the DecentraBank contract
  */
  function calculatePoolBal() external view returns(uint256);

  /**
  @notice calculatePurchase is a view function that takes in a dollar amount and returns the amount of
          DecentraStock that dollar amount is worth
  @param _dollarAmount is the dollar amount value being spent on DecentraStock
  */
  function calculatePurchase(uint256 _dollarAmount) external view return(uint256);

  /**
  @notice calculateSale is a view function used to tell the dollar amount a DecentraStock could be sold
          for.
  @param _stockAmount is the input amount of stocks being used to calculate the sell value
  */
  function calculateSale(uint256 _stockAmount) external view returns(uint256);

}
