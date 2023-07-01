// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.20;

import "../interfaces/util/IRegister.sol";
import "../interfaces/util/IVersion.sol";


import "../interfaces/IFundingPool.sol";
import "../interfaces/ILendingPool.sol";
import "../interfaces/ICouponContract.sol";

struct Investment {
    uint256 id; 
    address owner; 
    uint256 commitDate; 
    uint256 amount; 
    uint256 residual; 
    uint256 minTerm; 
    uint256 earliestExit; 
}


contract MoneyPool is IFundingPool, ILendingPool, IVersion {

    string constant COUPON_CONTRACT_CA = "COUPON_CONTRACT";


    string constant name = "MONEY_POOL_CORE";
    uint256 constant version = 1; 

    uint256 id; 
    string poolName; 
    IRegister register; 
    ICouponContract couponContract; 

    address [] acceptedInventoryContracts; 
    InvestmentTerms investmentTerms; 
    LendingTerms lendingTerms; 
    mapping(address=>uint256[]) investmentsByOwner; 
    mapping(uint256=>uint256) couponIdByInvestmentId; 
    mapping(uint256=>Investment) investmentById; 


    constructor(address _register, uint256 _id, string memory _poolName, 
                                    InvestmentTerms memory _investmentTerms, 
                                    LendingTerms memory _lendingTerms,
                                    address [] memory _acceptedInventoryContracts) {
        register                    = IRegister(_register);
        id                          = _id; 
        poolName                    = _poolName; 
        couponContract              = ICouponContract(register.getAddress(COUPON_CONTRACT_CA));
        investmentTerms             = _investmentTerms; 
        lendingTerms                = _lendingTerms; 
        acceptedInventoryContracts  = _acceptedInventoryContracts; 
    }

    function getId() view external returns (uint256 _ic) {
        return id; 
    }

    function getPoolName() view external returns (string memory _poolName) {
        return poolName; 
    }

    function getName() pure external returns (string memory _name){
        return name;
    }

    function getVersion() pure external returns (uint256 _version) {
        return version; 
    }

    function getInvestmentTerms() view external returns (InvestmentTerms memory _terms){
        return investmentTerms;
    }

    function getCouponContract() view external returns (address _couponContract){
        return address(couponContract);
    }

    function commitFunds(uint256 _fundingAmount, uint256 _maxTerm ) external payable returns (uint256 _couponId){

    }

    function getResidual(uint256 _couponId) view external returns (uint256 _residualRefund){

    }

    function withdrawFunds(uint256 _couponId) external returns (uint256 _payoutAmount){

    }

    function getAcceptedInventoryContracts() view external returns (address [] memory _inventoryContracts){
        return acceptedInventoryContracts;
    }

    function getLendingTerms() view external returns (LendingTerms memory _terms){
        return lendingTerms;
    }

   
    function requestFunds(BondedLoanRequest memory _bondedLoanRequest) external returns (Loan memory _loan){

    }

    function drawdown(uint256 _loanId, uint256 _amount) external returns (uint256 _payout){

    }

    function payback(uint256 _loanId, uint256 _amount) payable external returns (LoanPayment memory _payment){
        
    }
    
}
