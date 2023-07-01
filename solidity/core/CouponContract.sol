// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "../interfaces/util/IRegister.sol";
import "../interfaces/util/IVersion.sol";

import "../interfaces/ICouponContract.sol";


contract CouponContract is ERC721, ERC721Enumerable, ERC721URIStorage, Pausable, AccessControl, ERC721Burnable, ICouponContract, IVersion { 

    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    string constant nme = "COUPON_CONTRACT";
    uint256 constant version = 1; 

    string constant MONEY_POOL_REGISTER_ENTRY = "Money Pool";
    using Counters for Counters.Counter;


    Counters.Counter private _tokenIdCounter;
    IRegister register; 
    uint256 [] couponIds; 
    mapping(uint256=>Coupon) couponsById; 

    constructor(address _register) ERC721("Bearer Stage Coupon Contract", "BSCC") {
        register = IRegister(_register);
        _grantRole(MINTER_ROLE, register.getAddress(MONEY_POOL_REGISTER_ENTRY));
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }

    function getName() pure external returns (string memory _name) {
        return nme; 
    }

    function getVersion() pure  external returns (uint256 _version) {
        return version; 
    }

    function getCoupons() view external returns (uint256[] memory _couponId){
        return couponIds; 
    }

    function getCoupon(uint256 _id) view external returns (Coupon memory _coupon){
        return couponsById[_id];
    }
    function _baseURI() internal pure override returns (string memory) {
        return "https://www.bearerstage.com/coupons/";
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function safeMint(address to, string memory uri) public onlyRole(MINTER_ROLE) {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        whenNotPaused
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
    //=========================== INTERNAL ==============================================

    function mintCoupon(Coupon memory coupon, address _couponOwner) internal onlyRole(MINTER_ROLE) returns (uint256 _couponId)  {

    }

}
