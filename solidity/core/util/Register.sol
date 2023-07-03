// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.19;

import "../../interfaces/util/IVersion.sol";
import "../../interfaces/util/IRegister.sol";

contract Register is IRegister, IVersion { 

    string constant name = "REGISTER";
    uint256 constant version = 2; 


    address admin; 
    mapping(string=>address) addressByName; 
    mapping(address=>string) nameByAddress; 

    constructor (address _admin) { 
        admin = _admin; 
    }

    function getName() pure external returns (string memory _name) {
        return name; 
    }

    function getVersion() pure external returns (uint256 _version) {
        return version;
    }

    function getAddress(string memory _name) view external returns (address _address){
        return addressByName[_name];
    }

    function getName(address _address) view external returns (string memory _name){
        return nameByAddress[_address];
    }


    function setAdmin(address _newAdmin) external returns (bool _set) {
        adminOnly(); 
        admin = _newAdmin;
        return true; 
    }

    // ========================= INTERNAL ========================================================

    function adminOnly() view internal returns (bool ){
        require(msg.sender == admin, "admin only");
        return true; 
    }
}