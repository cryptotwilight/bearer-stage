// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "../interfaces/util/IRegister.sol";

import "../interfaces/IBearerTokenNFT.sol";

contract BearerTokenNFT is ERC721, IBearerTokenNFT { 

    uint256 nftIndex; 
    IRegister register; 

    mapping(uint256=>BearerToken) bearerTokenById; 

    constructor(address _register, string memory _name, string memory _symbol) ERC721(_name, _symbol) {
        register = IRegister(_register);
    }

    function mint(BearerToken memory _bearerToken) external returns (BearerToken memory _updatedBearerToken){
        
    }

    //==================== INTERNAL ==================================

    function getIndex() internal returns (uint256 _index){
        _index = nftIndex++;
        return _index; 
    } 

}