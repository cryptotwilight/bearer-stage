// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.19;

interface IDirectory  { 

    function getTypes(string memory _name) view external returns (string [] memory _types);

    function getAddress(string memory _name, string memory _type) view external returns (address _address);

    function getAddress(uint256 _id) view external returns (address _address);

}