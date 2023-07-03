// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.19;

// version 1
import "../interfaces/util/IDirectory.sol";

interface ILendingPoolDirectory is IDirectory { 

    function findSupportingPool(address _issuer, uint256 _requiredLoanAmount, address _paymentToken) view external returns (address _supportingPool);

}