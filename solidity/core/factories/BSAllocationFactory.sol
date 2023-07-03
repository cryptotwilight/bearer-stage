// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.19;

import "../../interfaces/util/IVersion.sol";
import "../../interfaces/util/IRegister.sol";
import "../../interfaces/factories/IBSAllocationFactory.sol";

import "../../core/AllocationContract.sol";

contract BSAllocationFactory is IBSAllocationFactory, IVersion { 

    string constant name = "BS_ALLOCATION_FACTORY_CORE"; 
    uint256 constant version = 2; 

    string constant INVENTORY_ORCHESTRATOR_CA = "INVENTORY_ORCHESTRATOR_CORE";

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

    function createAllocation(address _distributor, address _owner) external returns (address _allocation){
            require(msg.sender == register.getAddress(INVENTORY_ORCHESTRATOR_CA), "inventory orchestrator only");
            return address(new AllocationContract(_distributor, _owner));
    }

}