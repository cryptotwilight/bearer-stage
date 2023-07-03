// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.19;

// version 1

struct Performance { 
    uint256 bondId; 
    uint256 completed; 
    uint256 liquidated; 
}


interface IPerformanceManager { 

    function getPerformance(uint256 _bondId) view external returns (Performance memory _performance);

}