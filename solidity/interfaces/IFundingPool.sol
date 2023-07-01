// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.20;

// version 1



struct InvestmentTerms { 

    uint256 minimumTerm; 
    address couponContract; 
    uint256 emsissionsLow; 
    uint256 emissionsHigh; 
    uint256 minimumFunding; 
    uint256 maximumFunding; 
    uint256 residual; 
    address currency; 

}

interface IFundingPool { 

    // investment 
    function getInvestmentTerms() view external returns (InvestmentTerms memory _terms);

    function getCouponContract() view external returns (address _couponContract);

    function commitFunds(uint256 _fundingAmount, uint256 _maxTerm ) external payable returns (uint256 _couponId);

    function getResidual(uint256 _couponId) view external returns (uint256 _residualRefund);

    function withdrawFunds(uint256 _couponId) external returns (uint256 _payoutAmount);

}