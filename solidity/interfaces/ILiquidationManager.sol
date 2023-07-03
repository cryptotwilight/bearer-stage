// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.19;

import {BondedLoan} from "./ILendingPool.sol";

interface ILiquidationManager {

    function manageBondedLoan(BondedLoan memory _bondedLoan) external returns (uint256 _liquidationManagementId);

    function getLiquidationStatus(uint256 _liquidationManagementId) view external returns (string memory _status);
    
}