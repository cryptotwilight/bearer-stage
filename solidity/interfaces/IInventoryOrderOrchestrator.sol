// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.19;

// version 1

struct BondedParameters{
    uint256 bondId; 
    uint256 loanAmount; 
    uint256 distributorContribution;
    address distributor; 
    address owner;  
    uint256 bearerTokenIssuerId; 
    string assetType;
    uint256 startDate; 
    uint256 endDate; 
    uint256 maxUnitsPerDay; 
    address paymentToken; 
}

interface IInventoryOrderOrchestrator { 

    function getPaymentTokenContract() view external returns (address _erc20);

    function findAllocations() view external returns (address [] memory _allocation);

    function requestInventory(BondedParameters memory _params) payable external returns (address _allocation);

}