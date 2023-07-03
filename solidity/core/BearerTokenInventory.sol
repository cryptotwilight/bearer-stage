// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../interfaces/util/IRegister.sol";
import "../interfaces/util/IVersion.sol";

import "../interfaces/IBearerTokenInventory.sol";
import "../interfaces/IBearerTokenNFT.sol";

contract BearerTokenInventory is IBearerTokenInventory, IVersion {

    string constant name = "BEARER_TOKEN_INVENTORY_CORE";
    uint256 constant version = 4; 
    address self; 
    address SAFE_HARBOUR = 0x7433e7A9dB99C98D86d13690f057D9D0a64FCC5B; 
    uint256 index = 0; 

    address owner; 

    IRegister registry;
    IERC20 paymentToken; 
    uint256 [] supportedAssetTypes; 

    
    mapping(string=>AssetType) assetTypeByName; 
    mapping(uint256=>AssetType) assetTypeById; 
    
    BearerTokenInventoryConfiguration configuration; 

    mapping(uint256=>BearerToken) bearerTokenById; 
    mapping(string=>address) bearerTokenContractByAssetType; 

    mapping(uint256=>BearerToken) mintedBearerTokenById;

    mapping(string=>mapping(uint256=>uint256[])) bearerTokenIdsByDateByAssetType; 
    mapping(string=>mapping(uint256=>uint256)) availableBearerTokenCountByDateByAssetType;  
    uint256 [] deliveryIds; 
    mapping(uint256=>DeliveredInventory) deliveryById; 
    
  
    constructor(address _register, BearerTokenInventoryConfiguration memory _configuration) {
        registry = IRegister(_register);
        owner = registry.getAddress("OWNER");
        configuration = _configuration;
        paymentToken = IERC20(paymentToken); 
        self = address(this);
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

    function getAvailableInventory(string memory _assetType, uint256 _startDate, uint256 _daysForward) view external returns (InventoryAvailability [] memory _availability ){
        _availability  = new  InventoryAvailability [](_daysForward);
        uint256 day_ = 24*60*60; 
        uint256 endDate_ = _startDate + (day_ * _daysForward);
        AssetType memory assetType_ = assetTypeByName[_assetType];
        uint256 y = 0;
        for(uint256 x = _startDate; x < endDate_; x += day_ ){
            uint256 unitCount_ = availableBearerTokenCountByDateByAssetType[_assetType][x]; 
            if(unitCount_ > 0) {
                InventoryAvailability memory availability_ = InventoryAvailability({
                                                                                    date : x,  
                                                                                    assetType : assetType_,
                                                                                    availableUnits : unitCount_
                                                                                });
                _availability[y] = availability_; 
                y++;
            }
        }
        return _availability;
    }

    function requestInventory(InventoryRequest memory _request) payable external returns (DeliveredInventory memory _delivered){
        // check the date requested 
        require(_request.startDate > block.timestamp, "start date in the past");
        // check the days forward and the end date
        require(_request.startDate + _request.daysForward < block.timestamp, " invalid start date, days forward combination ");
        require(_request.daysForward < configuration.maxDaysForward, " invalid days forward");
        // do math to check that the approved amount or transmitted amount is equal to the sum of requested inventory 
        uint256 inventoryCost_ = getInventoryCost(_request);
        require(paymentToken.allowance(msg.sender, self) > inventoryCost_, "insufficent allowance");
        // do money transfers 
        paymentToken.transferFrom(msg.sender, self, inventoryCost_);
        // move the money to the safe harbour 
        paymentToken.transfer(SAFE_HARBOUR, inventoryCost_);
        // do token transfers 
        IERC721 bearerTokenContract = IERC721(bearerTokenContractByAssetType[_request.assetType]);
        (uint256 [] memory availableTokenIds_, uint256 _availabletokenCount) = getAvailableTokens(_request.assetType, _request.startDate, _request.daysForward, _request.maxUnitsPerDay);

        for(uint256 x = 0; x < availableTokenIds_.length; x++) {
            bearerTokenContract.transferFrom(self,msg.sender, availableTokenIds_[x] );
        }
        // build delivery 
        _delivered = DeliveredInventory ({
                                            id : getIndex(),
                                            request : _request, 
                                            bearerTokenContract : self,
                                            transferredIds : availableTokenIds_,
                                            count : _availabletokenCount, 
                                            deliveredTo : msg.sender, 
                                            deliveryDate : block.timestamp
                                        });
        deliveryById[_delivered.id] = _delivered; 
        return _delivered; 
        // done 
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
            bearerTokenIdsByDateByAssetType[assetType_.name][mintedBearerToken_.useDate].push(mintedBearerToken_.nftId); 
            availableBearerTokenCountByDateByAssetType[assetType_.name][mintedBearerToken_.useDate]++;

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
/*
struct InventoryRequest{
    uint256 id; 
    uint256 startDate; 
    uint256 daysForward; 
    string assetType; 
}
*/
    function getInventoryCost(InventoryRequest memory _request) view internal returns (uint256 _cost) {
        (uint256 [] memory availableTokenIds_, uint256 _availabletokenCount) = getAvailableTokens(_request.assetType, _request.startDate, _request.daysForward, _request.maxUnitsPerDay);
        AssetType memory assetType_ = assetTypeByName[_request.assetType];
        _cost = assetType_.unitPrice * _availabletokenCount; 
        return _cost;
    }

    function getAvailableTokens(string memory _assetType, uint256 _startDate, uint256 _daysForward, uint256 _maxUnitsPerDay) view internal returns (uint256 [] memory _availableTokenIds, uint256 _availableCount) {
        uint256 day_ = 24*60*60; 
        uint256 endDate_ = _startDate + (day_ * _daysForward);
        uint256 maxUnits_ = _maxUnitsPerDay * _daysForward; 

        AssetType memory assetType_ = assetTypeByName[_assetType];
        uint256 y = 0;
        
        _availableTokenIds = new uint256[](maxUnits_);

        for(uint256 x = _startDate; x < endDate_; x += day_ ){
            uint256 [] memory availableTokens_ = bearerTokenIdsByDateByAssetType[assetType_.name][x]; 
            for(uint256 z = 0; z < _maxUnitsPerDay || z < availableTokens_.length; z++){
                _availableTokenIds[y] = availableTokens_[z];
                y++;
                _availableCount++;
             }
        }
        return (_availableTokenIds, _availableCount);
    }

    function getIndex() internal returns (uint256 _index) {
        _index = index++; 
        return _index; 
    }


}