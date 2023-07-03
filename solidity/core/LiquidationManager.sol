// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.19;

import "../interfaces/util/IRegister.sol";
import "../interfaces/util/IVersion.sol";


import "../interfaces/ILiquidationManager.sol";

contract LiquidationManager is ILiquidationManager, IVersion {

    string constant name = "LIQUIDATION_MANAGER"; 
    uint256 constant version = 1; 

    IRegister register; 

    constructor(address _register) { 
        register = IRegister(_register); 
    }

    function getName() pure external returns (string memory _name) {
        return name;
    }

    function getVersion() pure external returns (uint256 _version) {
        return version;
    }

    function manageBondedLoan(BondedLoan memory _bondedLoan) external returns (uint256 _liquidationManagementId){

    }

    function getLiquidationStatus(uint256 _liquidationManagementId) view external returns (string memory _status){

    }

}