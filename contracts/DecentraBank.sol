// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./utils/BancorFormula.sol";
import "./interfaces/IDecentraDollar.sol";
import "./interfaces/IDecentraStock.sol";
import "./interfaces/IDecentraCore.sol";
import "./interfaces/IDecentraBank.sol";

////////////////////////////////////////////////////////////////////////////////////////////
/// @title DecentraBank
/// @author Christopher Dixon
////////////////////////////////////////////////////////////////////////////////////////////

contract DecentraBank is Ownable, BancorFormula, IDecentraBank {
    using SafeMath for uint256;

    uint32 public connectorWeight; /** connectorWeight, represented in ppm, 1-1000000
            1/3 corresponds to y= multiple * x^2
            1/2 corresponds to y= multiple * x
            2/3 corresponds to y= multiple * x^1/2
            multiple will depends on contract initialization,
            specifically totalAmount and poolBalance parameters. The values for this parameter are translated as follows:
            1000000 = 100%,
            10000 = 1%
            The connectorWeight determines the curvature of the bondig curve with 100% being a 1:1 token issuance and 50% being a diagonal linear curve type
            **/
    uint256 public lockedBalance; //lockedBalance represents the amount of ETH held in the contract that IS NOT part of the collateral pool
    uint256 public refundRatio; //refundRatio  follows the same rules as connectorWeight and is used to determine non Owner burn/exchange rates
    uint256 public percent; //used in calculating fees
    uint256 public divisor; //used in calculating fees
    uint256 public collateralCount;
    uint256 public fractionalReserveValue;

    IDecentraDollar public DD;
    IDecentraStock public DS;
    IDecentraCore public DC;

    address[] public collateralTypes;

    constructor(
        address _Dcore,
        address _Dstock,
        address _Ddollar,
        uint32 _connectorWeight,
        uint256 _refundRatio
    ) payable {
        DD = IDecentraDollar(_Ddollar);
        DS = IDecentraStock(_Dstock);
        DC = IDecentraCore(_Dcore);
        collateralTypes[0] = address(0);
        collateralTypes[1] = address(DD);
        collateralCount = 1;
        connectorWeight = _connectorWeight; //sets global reserve ratio
        refundRatio = _refundRatio; //sets global refund reserve ratio
        percent = 25;
        divisor = 10000;
        fractionalReserveValue = 2;
        DC.proxyMintDD(address(this), msg.value);
        uint256 dsValue = calculatePurchase(msg.value);
        DC.proxyMintDS(msg.sender, dsValue);
    }

    /**
  @notice purchaseStock is used to purchase DecentraStock at its current price
          as set by the DecentraBank bonding curve
  @param _amount is the dollar amount being purchased
  @param _tokenType is the address of the approved collateral type being used
  */
    function purchaseStock(uint256 _amount, uint256 _tokenType)
        external
        payable
        override
    {
        uint256 stockPurchased = calculatePurchase(_amount);
        uint256 value;
        if (_tokenType == 0) {
            value = msg.value;
        } else {
            IERC20 token = IERC20(collateralTypes[_tokenType]);
            value = _amount;
            token.transferFrom(msg.sender, address(this), value);
        }
        DC.proxyMintDD(address(this), value);
        DC.proxyMintDS(msg.sender, stockPurchased);
    }

    /**
  @notice sellStock is used to sell DecentraStock back to the DecentraBank bonding curve
  @param _amount is the amount of DecentraStock being sold
  @dev this function calculates the dollar value the input stock amount is worth and then
       repays the caller in equal parts of each approved collateral types
       EX: 1/3rd DAI, 1/3rd DecentraDollar, 1/3rd USDC
  */
    function sellStock(uint256 _amount) external override {
        uint256 returnValue = calculateSale(_amount);
        DC.proxyBurnDS(msg.sender, returnValue);
        uint256 returnFraction = collateralTypes.length;
        uint256 returnedAmount = returnValue.div(returnFraction);
        for (uint256 i = 0; i <= collateralTypes.length; ++i) {
            if (collateralTypes[i] == address(0)) {
                payable(msg.sender).transfer(returnedAmount);
            } else {
                IERC20 token = IERC20(collateralTypes[i]);
                token.transfer(msg.sender, returnedAmount);
            }
        }
    }

    /**
  @notice addNewCollateralType is a protected function that allows the owner of this
          contractto add a new collateral type to the DecentraBank
  @param _collateral is the address of the new ERC20 collateral being added
  @dev this function should only be used to add stablecoins ass collateral
  */
    function addNewCollateralType(address _collateral)
        external
        override
        onlyOwner
    {
        collateralCount++;
        collateralTypes[collateralCount] = _collateral;
    }

    /**
  @notice fundWithdrawl allows the owner of this contract to withdraw earned funds from the DecentraBank
  @param _to is the address the funds are being withdrawn totalAmount
  @param _to is the number representing the address the funds are being withdrawn to
  @param _amount is the amount of token being transfered
  */
    function fundWithdrawl(
        address _to,
        uint256 _type,
        uint256 _amount
    ) external override onlyOwner {
        IERC20 token = IERC20(collateralTypes[_type]);
        token.transfer(_to, _amount);
    }

    /**
  @notice calculatePoolBal is used to calculate the total pool balance of the DecentraBank contract
  */
    function calculatePoolBal() public view override returns (uint256) {
        uint256 total;
        for (uint256 i = 0; i <= collateralTypes.length; ++i) {
            if (collateralTypes[i] == address(0)) {
                total = total.add(address(this).balance);
            } else {
                IERC20 token = IERC20(collateralTypes[i]);
                uint256 bal = token.balanceOf(address(this));
                total = total.add(bal);
            }
        }
        return total;
    }

    /**
  @notice calculatePurchase is a view function that takes in a dollar amount and returns the amount of
          DecentraStock that dollar amount is worth
  @param _dollarAmount is the dollar amount value being spent on DecentraStock
  */
    function calculatePurchase(uint256 _dollarAmount)
        public
        view
        override
        returns (uint256)
    {
        uint256 poolBalance = calculatePoolBal();
        uint256 totalDSsupply = DS.totalSupply();
        uint256 stockToIssue = calculatePurchaseReturn(
            totalDSsupply,
            poolBalance,
            connectorWeight,
            _dollarAmount
        );
        return stockToIssue;
    }

    /**
  @notice calculateSale is a view function used to tell the dollar amount a DecentraStock could be sold
          for.
  @param _stockAmount is the input amount of stocks being used to calculate the sell value
  */
    function calculateSale(uint256 _stockAmount)
        public
        view
        override
        returns (uint256)
    {
        uint256 poolBalance = calculatePoolBal();
        uint256 totalDSsupply = DS.totalSupply();
        uint256 valueReturned = calculateSaleReturn(
            totalDSsupply,
            poolBalance,
            connectorWeight,
            _stockAmount
        );
        return valueReturned;
    }
}
