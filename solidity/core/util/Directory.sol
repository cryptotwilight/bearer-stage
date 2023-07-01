// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.20;

import "../../interfaces/util/IRegister.sol";
import "../../interfaces/util/IVersion.sol";

import "../../interfaces/util/IDirectory.sol";

contract Directory is IDirectory, IVersion {

    IRegister register; 

    string name; 
    uint256 constant version = 1; 

    mapping(string=>string[]) typesByName; 
    mapping(string=>mapping(string=>address)) addressByTypeByName;
    mapping(uint256=>address) addressById; 

    constructor(address _register, string memory _name) { 
        register = IRegister(_register);
        name = _name; 
    }

    function getName() view external returns (string memory _name){
       return name; 
    }

    function getVersion()  pure external returns (uint256 _version){
       return version; 
    }

    function getTypes(string memory _name) view external returns (string [] memory _types){
        return typesByName[_name];
    }

    function getAddress(string memory _name, string memory _type) view external returns (address _address){
        return addressByTypeByName[_name][_type];
    }

    function getAddress(uint256 _id) view external returns (address _address){
        return addressById[_id];
    }

}