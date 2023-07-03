// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.19;

interface IVersion { 

    function getName() view external returns (string memory _name);

    function getVersion()  view external returns (uint256 _version);

}