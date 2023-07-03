// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.19;


interface IBSAllocationFactory { 

    function createAllocation(address _distributor, address _owner) external returns (address _allocation);

}