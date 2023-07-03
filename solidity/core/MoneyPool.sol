// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "../interfaces/util/IRegister.sol";
import "../interfaces/util/IVersion.sol";


import "../interfaces/IFundingPool.sol";
import "../interfaces/ILendingPool.sol";
import "../interfaces/ICouponContract.sol";
import "../interfaces/IPerformanceManager.sol"; 


contract MoneyPool is IFundingPool, ILendingPool, IVersion {

    string constant COUPON_CONTRACT_CA = "COUPON_CONTRACT";

    address self; 
    string constant name = "MONEY_POOL_CORE";
    uint256 constant version = 2; 
    uint256 index = 0; 

    uint256 id; 
    string poolName; 
    IRegister register; 
    ICouponContract couponContract; 
    IPerformanceManager performanceManager; 


    IERC20 fundingToken; 
    uint256 [] coolingInvestments;

    address [] acceptedInventoryContracts; 
    InvestmentTerms investmentTerms; 
    LendingTerms lendingTerms; 
    mapping(address=>uint256[]) investmentsByOwner; 
    mapping(uint256=>uint256) couponIdByInvestmentId; 
    mapping(uint256=>Investment) investmentById; 
    mapping(address=>uint256[]) investmentIdsByOwner;
    mapping(uint256=>uint256) investmentIdByCouponId;  
    mapping(uint256=>bool) isCooled; 

    mapping(uint256=>uint256[]) loanIdsByBondId; 
    mapping(address=>uint256[]) loanIdsBySourceBorrower; 
    mapping(uint256=>Loan) loanById; 

    mapping(uint256=>uint256[]) emissionPaymentIdByEmissionPeriod; 
    mapping(uint256=>EmissionPayment) emissionPaymentById; 

    uint256 coolingBalance; 
    uint256 poolBalance; 


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
        self = address(this);
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

    function commitFunds(uint256 _fundingAmount) external payable returns (uint256 _couponId){
        require(fundingToken.allowance(msg.sender, self) >= _fundingAmount, "insufficient allowance");
        fundingToken.transferFrom(msg.sender, self, _fundingAmount); 
        coolingBalance += _fundingAmount;
        uint256 safeDate = block.timestamp;
        Investment memory investment_ = Investment({ 
            id          : getIndex(),  
            poolId      : id, 
            poolAddress : self,
            owner       : msg.sender,  
            commitDate  : safeDate, 
            amount      : _fundingAmount, 
            poolRate    : investmentTerms.emissionsRate, 
            residualPercentage : investmentTerms.residualPercentage, 
            minimumTerm : investmentTerms.minimumTerm, 
            earliestExitDate : safeDate + investmentTerms.minimumTerm,
            coolOffPeriodEndDate : safeDate + investmentTerms.coolOffPeriod
        });
        investmentById[investment_.id] = investment_; 
        _couponId = couponContract.mintCoupon(investment_);
        investmentIdByCouponId[_couponId] = investment_.id; 
        couponIdByInvestmentId[investment_.id] = _couponId;
        coolingInvestments.push(investment_.id); 

    }

    function getResidual(uint256 _couponId) view external returns (uint256 _residualRefund){
        return investmentById[investmentIdByCouponId[_couponId]].residualPercentage;
    }

    function withdrawFunds(uint256 _couponId) external returns (uint256 _payoutAmount){

        Investment memory investment_ = investmentById[investmentIdByCouponId[_couponId]]; 
        require(investment_.coolOffPeriodEndDate > block.timestamp, "cool off expired");
        require(coolingBalance >= investment_.amount, "insufficient funds");
        _payoutAmount = investment_.amount; 
        coolingBalance -= investment_.amount; 
        fundingToken.transferFrom(self, msg.sender, investment_.amount);
        return _payoutAmount; 
    }

    function getAcceptedInventoryContracts() view external returns (address [] memory _inventoryContracts){
        return acceptedInventoryContracts;
    }

    function getLendingTerms() view external returns (LendingTerms memory _terms){
        return lendingTerms;
    }
    // coupone contract used by the pool 
    function getInvestments() view external returns (Investment [] memory _investments){
            uint256 [] memory investmentIds_ = investmentIdsByOwner[msg.sender];
            _investments = new Investment[](investmentIds_.length);
            for(uint256 x = 0; x < investmentIds_.length; x++){
                _investments[x] = investmentById[investmentIds_[x]];
            }
            return _investments; 
    }
   
    function getCoolingBalance() view external returns (uint256 _coolingBalance) {
        return coolingBalance; 
    }

    function commitCooledFunds() external returns (uint256 _amountCommitted) {
        for(uint256 x = 0; x < coolingInvestments.length; x++) {
            Investment memory investment_ = investmentById[coolingInvestments[x]];
            if(!isCooled[investment_.id] && (investment_.coolOffPeriodEndDate > block.timestamp)) {
                coolingBalance -= investment_.amount; 
                poolBalance += investment_.amount; 
                _amountCommitted += investment_.amount; 
                isCooled[investment_.id] = true; 
            }
        }
        return _amountCommitted; 
    }

    function getEmissionPayments(uint256 _emissionPeriod) view external returns (EmissionPayment [] memory _emissionPayments) {
        uint256 [] memory emissionPaymentIds_ = emissionPaymentIdByEmissionPeriod[_emissionPeriod];
        _emissionPayments = new EmissionPayment[](emissionPaymentIds_.length);
        for(uint256 x = 0; x < _emissionPayments.length; x++) {
            _emissionPayments[x] = emissionPaymentById[emissionPaymentIds_[x]];
        }
        return _emissionPayments; 
    }
/*
struct BondedLoanRequest { 
    uint256 id; 
    uint256 bondId; 
    address bearerTokenContract; 
    uint256 startDate; 
    uint256 endDate; 
    uint256 loanAmount;
}
*/
    function requestFunds(BondedLoanRequest memory _bondedLoanRequest) external returns (Loan memory _loan){
        // check the bond 
        Performance memory performance_ = performanceManager.getPerformance(_bondedLoanRequest.bondId);
        uint256 success_ = performance_.completed - performance_.liquidated;
        // check the performance against the bond  
        require(lendingTerms.minPerformance < (success_ / performance_.completed), "inadequate performance"); 
        // check the start date
        require(_bondedLoanRequest.startDate > block.timestamp && _bondedLoanRequest.endDate > _bondedLoanRequest.startDate, "date misalignment");
        // check the end date 
        require(poolBalance >= _bondedLoanRequest.loanAmount, "insufficient funds in pool");
        // check the loan amount is available from the pool 

        // grant the loan
        uint256 loanAmount_ = _bondedLoanRequest.loanAmount; 
        poolBalance -= loanAmount_; 

        Loan memory loan_ = Loan({
                                    id              : getIndex(), 
                                    request         : _bondedLoanRequest, 
                                    startDate       : _bondedLoanRequest.startDate, 
                                    endDate         : _bondedLoanRequest.endDate,  
                                    loanAmount      : loanAmount_,  
                                    paybackAmount   : calculatePaybackAmount(loanAmount_)
                                });
        loanById[loan_.id] = loan_; 

        return _loan; 

    }

    function drawdown(uint256 _loanId, uint256 _amount) external returns (uint256 _payout){

        // check the loan has been granted to the caller 

        // check the amount requested against the amount remaining 

        // transfer the amount requested to the caller 

    }

    function payback(uint256 _loanId, uint256 _amount) payable external returns (LoanPayment memory _payment){
        // check the balance of the loan ( if it has been liquidated it will already be paid)

        // transfer the funds in 

        // update the balancess 
    }

    //============================ INTERNAL ========================================

    function getIndex() internal returns (uint256 _index){
        _index = index++; 
        return _index; 
    }

    function calculatePaybackAmount(uint256 _loanAmount) internal returns (uint256 _amount) {

    }
}
mj