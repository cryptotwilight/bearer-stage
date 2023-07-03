// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.19;

// version 2

struct LendingTerms {

    uint256 minimumTerm; 
    uint256 maximumTerm; 
    uint256 maxFunding; 
    uint256 minFunding; 
    uint256 minPerformance; 
    uint256 lendingRate; 

}

struct BondedLoanRequest { 
    uint256 id; 
    uint256 bondId; 
    address bearerTokenContract; 
    uint256 startDate; 
    uint256 endDate; 
    uint256 loanAmount;
}


struct BondedLoan { 
    uint256 id; 
    uint256 bondId; 
    uint256 loanId; 
    uint256 startDate; 
    uint256 endDate; 
    uint256 liquidationFactor; 
}

struct Loan { 
    uint256 id; 
    BondedLoanRequest request; 
    uint256 startDate; 
    uint256 endDate; 
    uint256 loanAmount; 
    uint256 paybackAmount; 
}

struct LoanPayment { 
    uint256 id; 
    uint256 loandId; 
    uint256 amount; 
    address payer; 


}

interface ILendingPool { 


    function getId() view external returns (uint256 _id);

    function getPoolName() view external returns (string memory _poolName);

    function getAcceptedInventoryContracts() view external returns (address [] memory _inventoryContracts);

    function getLendingTerms() view external returns (LendingTerms memory _terms);

    function requestFunds(BondedLoanRequest memory _bondedLoanRequest) external returns (Loan memory _loan);

    function drawdown(uint256 _loanId, uint256 _amount) external returns (uint256 _payout);

    function payback(uint256 _loanId, uint256 _amount) payable external returns (LoanPayment memory _payment);

}