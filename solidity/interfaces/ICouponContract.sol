// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.19;

import {Investment, EmissionPayment}  from "./IFundingPool.sol";

// version 2

struct Coupon { 
    uint256 id;
    uint256 startDate; 
    uint256 endDate; 
    uint256 fundsCommitted;
    uint256 fundingPoolId; 
    address fundingPool;
    uint256 emissionsRate; 
    uint256 burnResidual; 
    uint256 coolOffPeriodEndDate;  
}

interface ICouponContract {

    function getCoupons(uint256 _poolId) view external returns (Coupon[] memory _coupons);

    function getCoupon(uint256 _id) view external returns (Coupon memory _coupon);

    function mintCoupon(Investment memory _investment) external returns (uint256 _couponId);

    function payEmission(uint256 _paymentAmount, uint256 _poolId) payable external returns (EmissionPayment [] memory _payments);
}