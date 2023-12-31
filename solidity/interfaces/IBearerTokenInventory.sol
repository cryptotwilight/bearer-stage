// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.19;

// version 2

struct InventoryAvailability{
    uint256 date; 
    AssetType assetType;
    uint256 availableUnits;  
}

struct InventoryRequest{
    uint256 id; 
    uint256 startDate; 
    uint256 daysForward; 
    string assetType; 
    uint256 maxUnitsPerDay; 
}

struct DeliveredInventory { 
    uint256 id; 
    InventoryRequest request; 
    address bearerTokenContract; 
    uint256 [] transferredIds; 
    address deliveredTo;
    uint256 deliveryDate; 
    uint256 count; 
}

struct BearerToken{ 
    uint256 id; 
    uint256 nftId; 
    uint256 issueDate; 
    uint256 exipiryDate;
    uint256 useDate;
    AssetType assetType; 
    string issuer;
    uint256 issuerId;
}

struct BearerTokenInventoryConfiguration {
    uint256 issuerId;
    string issuerName; 
    string tokenSymbol;
    uint256 startDate; 
    uint256 endDate; 
    address paymentToken; 
    uint256 maxDaysForward; 
}

struct AssetType {
    uint256 id; 
    string name; 
    uint256 unitPrice; 
    uint256 unitRecommendedPrice; 
    uint256 issuerId;
    uint256 capacity; 
    uint256 unitCount; 
}

interface IBearerTokenInventory { 

    function getConfiguration() view external returns (BearerTokenInventoryConfiguration memory _configuration);

    function getAvailableInventory(string memory _assetType, uint256 _startDate, uint256 _endDate) view external returns (InventoryAvailability [] memory _availability );

    function requestInventory(InventoryRequest memory _request) payable external returns (DeliveredInventory memory _delivered); 

    function getBearerToken(uint256 _tokenId) view external returns (BearerToken memory _bearerToken);

    function getAssetType(string memory _name) view external returns (AssetType memory _assetType);

    function getSupportedAssetTypes() view external returns (AssetType [] memory _supportedAssetTypes);

    function configureAssetTypes(AssetType [] memory _assetTypes) external returns (bool _configured);

}