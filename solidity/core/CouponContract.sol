// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.19;


import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

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
import "../interfaces/IFundingPool.sol";


contract CouponContract is ERC721, ERC721Enumerable, ERC721URIStorage, Pausable, AccessControl, ERC721Burnable, ICouponContract, IVersion { 

    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    address self; 

    string constant nme = "COUPON_CONTRACT";
    uint256 constant version = 2; 
    uint256 index = 0; 

    string constant COUPON_DISPLAY_URL = ""; 

    string constant MONEY_POOL_REGISTER_ENTRY = "Money Pool";
    using Counters for Counters.Counter;


    Counters.Counter private _tokenIdCounter;
    IRegister register; 
    

    uint256 [] registeredPools; 
    mapping(uint256=>address) poolAddressById; 

    mapping(uint256=>bool) poolIsRegisteredByPoolId; 
    mapping(uint256=>uint256[]) couponsByPool; 
    mapping(uint256=>uint256) couponTotalByPool;
    mapping(uint256=>EmissionPayment) emissionPaymentById; 

    uint256 [] couponIds; 
    mapping(uint256=>Coupon) couponsById; 

    constructor(address _register) ERC721("Bearer Stage Coupon Contract", "BSCC") {
        register = IRegister(_register);
        _grantRole(MINTER_ROLE, register.getAddress(MONEY_POOL_REGISTER_ENTRY));
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(PAUSER_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        self = address(this);
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

    function getCoupons(uint256 _poolId) view external returns (Coupon [] memory _coupons) {
        uint256 [] memory couponIds_ = couponsByPool[_poolId];
        return getCoupons(couponIds_);
    }


    function _baseURI() internal pure override returns (string memory) {
        return "https://billowing-dew-3206.on.fleek.co/coupons/";
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function safeMint(address to, string memory uri) public onlyRole(MINTER_ROLE) {
    
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

    function mintCoupon(Investment memory _investment) external  onlyRole(MINTER_ROLE)  returns (uint256 _couponId) {
        uint256 safeDate = block.timestamp;
        Coupon memory coupon_ = Coupon ({
                                            id              : _tokenIdCounter.current(), 
                                            startDate       :  safeDate, 
                                            endDate         : safeDate + _investment.minimumTerm, 
                                            fundsCommitted  : _investment.amount,
                                            fundingPoolId   : _investment.poolId,
                                            fundingPool     : _investment.poolAddress,
                                            emissionsRate   : _investment.poolRate,  
                                            burnResidual    : _investment.residualPercentage,
                                            coolOffPeriodEndDate : _investment.coolOffPeriodEndDate
                                        });
        _tokenIdCounter.increment();
        mintCoupon(coupon_, _investment.owner); 
        return coupon_.id; 
    }

 
    function payEmission(uint256 _paymentAmount, uint256 _poolId) payable external returns (EmissionPayment [] memory _payments){
        Coupon [] memory _coupons = getCoupons(couponsByPool[_poolId]);
        IERC20 paymentToken = IERC20(IFundingPool(poolAddressById[_poolId]).getInvestmentTerms().fundingToken); 
        uint256 couponTotal_ = couponTotalByPool[_poolId];
        for(uint256 x = 0; x < _coupons.length; x++) {
            Coupon memory coupon_ = _coupons[x]; 

            uint256 payoutAmount_ = getPayoutAmount(couponTotal_, _paymentAmount, coupon_);
            address currentOwner_ = ownerOf(coupon_.id);

            paymentToken.transferFrom(self, currentOwner_, payoutAmount_);
            EmissionPayment memory payment_ = EmissionPayment({
                                                            id          : getIndex(),  
                                                            couponId    : coupon_.id, 
                                                            poolId      : coupon_.fundingPoolId, 
                                                            recipient   : currentOwner_,
                                                            amountPaid  : payoutAmount_,
                                                            date        : block.timestamp 
                                                      });
            emissionPaymentById[payment_.id] = payment_; 
            _payments[x] = payment_; 
        }
        return _payments; 

    }

    //=========================== INTERNAL ==============================================

    function getIndex() internal returns (uint256 _index) {
        _index = index++;
        return _index; 
    }

    function getPayoutAmount(uint256 _couponTotal, uint256 _paymentAmount, Coupon memory _coupon) pure internal returns (uint256 _payoutAmount){
        uint256 couponPercentage = _coupon.fundsCommitted / _couponTotal; 
        _payoutAmount = _paymentAmount * couponPercentage; 
        return _payoutAmount;  
    }

    function mintCoupon(Coupon memory _coupon, address _couponOwner) internal returns (uint256 _couponId)  {
        _safeMint(_couponOwner, _coupon.id);
        _setTokenURI(_coupon.id, COUPON_DISPLAY_URL);
        couponsByPool[_coupon.fundingPoolId].push(_coupon.id); 
        couponsById[_coupon.id] = _coupon; 
        couponIds.push(_coupon.id);
        return _coupon.id; 
    }

    function getCoupons(uint256 [] memory _couponIds) view internal returns (Coupon [] memory _coupons) {
        _coupons = new Coupon[](_couponIds.length);
        for(uint256 x = 0; x < _couponIds.length; x++) {
            _coupons[x] = couponsById[_couponIds[x]];
        }
        return _coupons; 
    }

}
