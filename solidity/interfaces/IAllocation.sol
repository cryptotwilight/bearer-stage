// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.19;

// version 2

struct Allocation { 
    AllocationRequest request; 
    uint256 unitPrice; 
    uint256 unitRecommendedPrice; 
    uint256 [] bearerTokenIds; 
}

struct AllocationRequest { 
    uint256 startDate; 
    uint256 endDate; 
    string assetType;
    uint256 maxUnitsPerDay; 
    address bearerTokenContract;  
    uint256 fundedAmount; 
    address paymentToken; 
}

interface IAllocation { 

    function getOwner() view external returns (address _owner);

    function getDistributor() view external returns (address _distributor);

    function getAllocation() view external returns (Allocation memory _allocation);

    function isDistributed(uint256 _uint256) view external returns (bool _isDistributed);

    function executeAllocation(AllocationRequest memory _allocationRequest) payable external returns (Allocation memory _allocation);

    function transferTo(uint256[] memory _ids, address _target) payable external returns (uint256 _transferredCount);
}