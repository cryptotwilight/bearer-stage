// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "../interfaces/util/IVersion.sol";
import "../interfaces/util/IRegister.sol";
import "../interfaces/util/IDirectory.sol";
import "../interfaces/ILendingPoolDirectory.sol";

import "../interfaces/factories/IBSAllocationFactory.sol";

import "../interfaces/IInventoryOrderOrchestrator.sol";
import "../interfaces/ILendingPool.sol";
import "../interfaces/IAllocation.sol";


contract InventoryOrderOrchestrator is IInventoryOrderOrchestrator, IVersion {

    string constant name = "INVENTORY_ORCHESTRATOR_CORE";
    uint256 constant version = 1; 

    string constant ISSUER_DIRECTORY_CA = "ISSUER_DIRECTORY";
    string constant LENDING_POOL_DIRECTORY_CA = "LENDING_POOL";
    string constant PAYMENT_TOKEN_CONTRACT_CA = "PAYMENT_TOKEN";
    string constant ALLOCATION_FACTORY_CA = "ALLOCATION_FACTORY";


    uint256 index = 0; 
    bool NATIVE = false; 

    IRegister register; 
    IDirectory issuerDirectory; 
    ILendingPoolDirectory lendingPoolDirectory; 
    IERC20 paymentToken; 
    IBSAllocationFactory allocationFactory; 
    
    mapping(address=>address[]) allocationAddressesByOwner;

    constructor(address _registry) {
        register = IRegister(_registry);
        issuerDirectory = IDirectory(register.getAddress(ISSUER_DIRECTORY_CA));
        lendingPoolDirectory = ILendingPoolDirectory(register.getAddress(LENDING_POOL_DIRECTORY_CA));
        paymentToken = IERC20(register.getAddress(PAYMENT_TOKEN_CONTRACT_CA));
        if(address(paymentToken) == address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)  ) {
            NATIVE = true; 
        }
        allocationFactory = IBSAllocationFactory(register.getAddress(ALLOCATION_FACTORY_CA));
    }

    function getName() pure external returns (string memory _name) {
        return name; 
    }

    function getVersion() pure external returns (uint256 _version) {
        return version; 
    }

    function findAllocations() view external returns (address [] memory _allocation){
        return allocationAddressesByOwner[msg.sender];
    }

    function getPaymentTokenContract() view external returns (address _paymentToken) {
        return address(paymentToken);
    }

    function requestInventory(BondedParameters memory _params) payable external returns (address _allocation) {
        // find a supporting pool 
        address issuer_ = issuerDirectory.getAddress(_params.bearerTokenIssuerId);
        ILendingPool lendingPool_ = ILendingPool(lendingPoolDirectory.findSupportingPool(issuer_, _params.loanAmount, _params.paymentToken));
        uint256 id_ = index++;
        // request a bonded loan
        BondedLoanRequest memory loanRequest_ = BondedLoanRequest(  {id                 : id_,
                                                                    bondId              : _params.bondId, 
                                                                    bearerTokenContract : issuer_, 
                                                                    startDate           : _params.startDate, 
                                                                    endDate             : _params.endDate,
                                                                    loanAmount          : _params.loanAmount }); 
        Loan memory loan_ = lendingPool_.requestFunds(loanRequest_);
        
        // creeate an allocation contract 
        _allocation = allocationFactory.createAllocation(_params.distributor, _params.owner);
        IAllocation allocation_ = IAllocation(_allocation);

        // draw down the loan 
        lendingPool_.drawdown(loan_.id, loan_.loanAmount); 
        
        // execute allocation
        uint256 fundingTotal_ = loan_.loanAmount + _params.distributorContribution; 

        AllocationRequest memory allocationRequest_ = AllocationRequest({
                                                                            startDate : _params.startDate,
                                                                            endDate : _params.endDate, 
                                                                            assetType : _params.assetType, 
                                                                            bearerTokenContract : issuer_, 
                                                                            fundedAmount : fundingTotal_,
                                                                            paymentToken : _params.paymentToken
                                                                        });
        if(NATIVE) {
            allocation_.executeAllocation{value : (fundingTotal_)}(allocationRequest_);
        }
        else { 
            paymentToken.approve(_allocation, fundingTotal_ );
            allocation_.executeAllocation(allocationRequest_);
        }
        return _allocation;
    }

}