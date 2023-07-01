// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "../interfaces/IAllocation.sol";
import "../interfaces/IBearerTokenInventory.sol";

contract AllocationContract is IAllocation { 


    address constant NATIVE = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    address self; 
    address distributor; 
    address owner; 
    bool executed = false; 
    uint256 index = 0;
    DeliveredInventory delivery; 


    Allocation allocation; 

    IERC721 bearerTokenContract;
    mapping(uint256=>bool) isDistributedInventoryById; 

    constructor(address _distributor, address _owner) {
        self = address(this);
        distributor = _distributor; 
        owner = _owner; 
    }

    function getOwner() view external returns (address _owner){
        return owner; 
    }

    function getDistributor() view external returns (address _distributor){
        return distributor; 
    }


    function getAllocation() view external returns (Allocation memory _allocation){
        return allocation;
    }

    function isDistributed(uint256 _bearerTokenId) view external returns (bool _isDistributed){
        return isDistributedInventoryById[_bearerTokenId];
    }

    function executeAllocation(AllocationRequest memory _allocationRequest) payable external returns (Allocation memory _allocation){
        require(!executed, "already executed");
        // request and pay for an allocation from the bearer token contract
        InventoryRequest memory inventoryRequest_ = InventoryRequest({

                                                                        id          : getIndex(),
                                                                        startDate   : _allocationRequest.startDate,
                                                                        endDate     : _allocationRequest.endDate,
                                                                        assetType   : _allocationRequest.assetType 
                                                                    });
                                                                    // secure the inventory
        IBearerTokenInventory inventory_ = IBearerTokenInventory(_allocationRequest.bearerTokenContract);
        AssetType memory assetType_ = inventory_.getAssetType(_allocationRequest.assetType);
        // assemble totals 
        uint256 totalPayment_ = calculateTotalPayment(assetType_, _allocationRequest.startDate,  _allocationRequest.endDate );
        address paymentTokenAddress_ = inventory_.getConfiguration().paymentToken;
       
        // run payment 
        if(paymentTokenAddress_ == NATIVE) {
            delivery = inventory_.requestInventory{value : totalPayment_}(inventoryRequest_);
        }   
        else {
            IERC20 paymentToken_ = IERC20(paymentTokenAddress_);            
            paymentToken_.approve(_allocationRequest.bearerTokenContract, totalPayment_);
            delivery = inventory_.requestInventory(inventoryRequest_);
        }

        // prepare the allocation 
        _allocation = Allocation({
                                    request                     : _allocationRequest, 
                                    unitPrice                   : assetType_.unitPrice,
                                    unitRecommendedPrice        : assetType_.unitRecommendedPrice,
                                    bearerTokenIds              : delivery.transferredIds
                                });
        allocation = _allocation; 

        executed = true; 

        return _allocation; 
    }   

    function transferTo(uint256[] memory _ids, address _target) payable external returns (uint256 _transferredCount){
        require(executed, "allocation not executed");
        require(msg.sender == distributor, "distributor only" );
        for(uint256 x = 0; x < _ids.length; x++) {
            bearerTokenContract.transferFrom(self, _target, x);
            _transferredCount++;
        }
        return _transferredCount; 
    }

    function setOwner(address _owner) external returns (bool _set) {
        require(msg.sender == owner, "owner only" );
        owner = _owner; 
        return true; 
    }


    function setDistributor(address _newDistributor) external returns (bool _set) {
        require(msg.sender == distributor || msg.sender == owner, "distributor or owner only");
        distributor = _newDistributor; 
        return true; 
    }

    //================================== INTERNAL ========================================

    function getIndex() internal returns (uint256 _index) {
        _index = index++; 
        return _index; 
    }

    function calculateTotalPayment(AssetType memory _assetType, uint256 _startDate, uint256 _endDate ) pure internal returns (uint256 _total) {
        uint256 totalUnits = (_endDate - _startDate) / (24*60*60);
        _total = totalUnits * _assetType.unitPrice; 
        return _total; 
    }

}