// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.20;

import "../../interfaces/factories/IBSAllocationFactory.sol";

import "../../core/AllocationContract.sol";

contract BSAllocationFactory is IBSAllocationFactory, IVersion { 

    string constant name = "BS_ALLOCATION_FACTORY_CORE"; 
    uint256 constant verssion = 1; 

    string constant INVENTORY_ORCHESTRATOR_CA = "INVENTORY_ORCHESTRATOR_CORE";

    IRegister register; 
    
    constructor(address _register) {
        register = IRegister(_register);
    }
     
    function getName() view external returns (string memory _name) { 
        return name; 
    }

    function getVersion() view external returns (uint256 _version) {
        return version; 
    }

    function createAllocation(address _distributor, address _owner) external returns (address _allocation){
            require(msg.sender == register.getAddress(INVENTORY_ORCHESTRATOR_CA), "inventory orchestrator only");
            return address(new AllocationContract(_distributor, _owner));
    }

}