// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.20;

// version 1

struct Coupon { 
    uint256 id;
    uint256 startDate; 
    uint256 endDate; 
    uint256 fundsCommitted;
    address fundingPool;
    uint256 maxRate; 
    uint256 minRate;  
    uint256 residual; 
    uint256 emissionsLow; 
    uint256 emissionsHigh; 
}

interface ICouponContract {

    function getCoupons() view external returns (uint256[] memory _couponId);

    function getCoupon(uint256 _id) view external returns (Coupon memory _coupon);
}