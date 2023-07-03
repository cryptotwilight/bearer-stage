// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.19;

// version 2



struct InvestmentTerms { 

    uint256 coolOffPeriod; 
    uint256 minimumTerm; 
    address couponContract; 
    uint256 emissionsRate;
    uint256 minimumFundingCommitment; 
    uint256 maximumFundingCommitment; 
    uint256 residualPercentage; 
    address fundingToken; 

}

struct Investment {
    uint256 id; 
    uint256 poolId; 
    address poolAddress; 
    address owner; 
    uint256 commitDate; 
    uint256 amount; 
    uint256 poolRate; 
    uint256 residualPercentage; 
    uint256 minimumTerm; 
    uint256 earliestExitDate; 
    uint256 coolOffPeriodEndDate; 
}

struct EmissionPayment { 
    uint256 id; 
    uint256 couponId; 
    uint256 poolId; 
    address recipient; 
    uint256 amountPaid;
    uint256 date;  
}


interface IFundingPool { 

    // published investment terms for the pool
    function getInvestmentTerms() view external returns (InvestmentTerms memory _terms);
    // investements held by the caller
    function getInvestments() view external returns (Investment [] memory _investments);
    // coupone contract used by the pool 
    function getCouponContract() view external returns (address _couponContract);
    // Emissions issued by period
    function getEmissionPayments(uint256 _emissionPeriod) view external returns (EmissionPayment [] memory _payments);

    // enable investor to commit funds 
    function commitFunds(uint256 _fundingAmount ) external payable returns (uint256 _couponId);

    // enable investor to burn their coupons for the associated residual 
    function getResidual(uint256 _couponId) view external returns (uint256 _residualRefund);

    // enable investor to withdraw funds automatically burning coupon (during cool off period) 
    function withdrawFunds(uint256 _couponId) external returns (uint256 _payoutAmount);

}