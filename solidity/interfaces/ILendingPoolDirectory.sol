// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.20;

import "../interfaces/util/IDirectory.sol";

// version 1

interface ILendingPoolDirectory is IDirectory { 

    function findSupportingPool(address _issuer, uint256 _requiredLoanAmount, address _paymentToken) view external returns (address _supportingPool);

}