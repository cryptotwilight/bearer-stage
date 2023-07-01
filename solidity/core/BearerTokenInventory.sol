// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.20;

import "../interfaces/util/IRegister.sol";
import "../interfaces/util/IVersion.sol";

import "../interfaces/IBearerTokenInventory.sol";
import "../interfaces/IBearerTokenNFT.sol";

contract BearerTokenInventory is IBearerTokenInventory, IVersion {

    string constant name = "BEARER_TOKEN_INVENTORY_CORE";
    uint256 constant version = 1; 

    address owner; 

    IRegister registry;
    uint256 [] supportedAssetTypes; 

    
    mapping(string=>AssetType) assetTypeByName; 
    mapping(uint256=>AssetType) assetTypeById; 
    
    BearerTokenInventoryConfiguration configuration; 

    mapping(uint256=>BearerToken) bearerTokenById; 
    mapping(string=>address) bearerTokenContractByAssetType; 

    mapping(uint256=>BearerToken) mintedBearerTokenById; 
    
  
    constructor(address _register, BearerTokenInventoryConfiguration memory _configuration) {
        registry = IRegister(_register);
        owner = registry.getAddress("OWNER");
        configuration = _configuration;
    }

    function getName() pure external returns (string memory _name){
        return name;
    }

    function getVersion()  pure external returns (uint256 _version){
        return version; 
    }

    function getConfiguration() view external returns (BearerTokenInventoryConfiguration memory _configuration){
        return configuration; 
    }

    function getAvailableInventory(string memory _assetType, uint256 _startDate, uint256 _endDate) view external returns (InventoryAvailability [] memory _availability ){

    }

    function requestInventory(InventoryRequest memory _request) payable external returns (DeliveredInventory memory _delivered){

    }

    function postInventory(BearerToken [] memory _bearerTokens) external returns (uint256 _postedCount, uint256 [] memory _missedItems) {
        require(msg.sender == owner, "admin only" );
        for(uint256 x = 0; x < _bearerTokens.length; x++){
            BearerToken memory bearerToken_ = _bearerTokens[x];

            AssetType memory assetType_ = bearerToken_.assetType; 
            string memory assetTypeName_ = assetType_.name;
            address nftAddress_ = bearerTokenContractByAssetType[assetTypeName_];
            IBearerTokenNFT tokenContract_ = IBearerTokenNFT(nftAddress_);
            BearerToken memory mintedBearerToken_ = tokenContract_.mint(bearerToken_);
            mintedBearerTokenById[mintedBearerToken_.nftId] = mintedBearerToken_;
            _postedCount++; 
        }
        return (_postedCount, _missedItems);
    }

    function getBearerToken(uint256 _tokenId) view external returns (BearerToken memory _bearerToken){
        return bearerTokenById[_tokenId];
    }

    function getAssetType(string memory _name) view external returns (AssetType memory _assetType){
        return assetTypeByName[_name];
    }

    function getSupportedAssetTypes() view external returns (AssetType [] memory _supportedAssetTypes){
        _supportedAssetTypes = new AssetType[](supportedAssetTypes.length);
        for(uint256 x = 0; x < _supportedAssetTypes.length; x++) {
            _supportedAssetTypes[x] = assetTypeById[supportedAssetTypes[x]];
        }
        return _supportedAssetTypes; 
    }   

    function configureAssetTypes(AssetType [] memory _assetTypes) external returns (bool _configured){
        adminOnly();
        uint256 [] memory supportedAssetTypes_ = new uint256[](_assetTypes.length);
        for(uint256 x = 0; x < _assetTypes.length; x++) {
            AssetType memory assetType_ = _assetTypes[x];
            assetTypeById[assetType_.id] = assetType_;
            assetTypeByName[assetType_.name] = assetType_;  
            supportedAssetTypes_[x] = assetType_.id; 
            // find or create bearerToken minting contract
        }
        supportedAssetTypes = supportedAssetTypes_;
        return true; 
    }

    //=========================================== INTERNAL ======================================================

    function adminOnly() view internal returns (bool) {
        require(msg.sender == owner, "admin only");
        return true; 
    }


}