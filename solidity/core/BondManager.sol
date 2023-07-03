// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "../interfaces/IBondManager.sol";
import "../interfaces/util/IVersion.sol";
import "../interfaces/util/IRegister.sol";

contract BondManager is IBondManager, IVersion {

    string constant name = "BOND_MANAGER";
    uint256 constant version = 1; 

    string constant PAYMENT_TOKEN_CONTRACT_CA = "PAYMENT_TOKEN";
    address self; 
    uint256 index = 0; 
    uint256 bondedBalance = 0; 

    IRegister register; 
    IERC20 paymentToken; 

    uint256 [] bondIds; 
    mapping(address=>uint256[]) bondIdsByAddress; 
    mapping(uint256=>Bond) bondById; 
    mapping(address=>uint256[]) liqudationsByBondIssuer; 
    mapping(uint256=>Liquidation) liquidationById; 

    mapping(uint256=>bool) isLockedByBondId; 
    mapping(uint256=>bool) isLiquidatedByBondId; 
    mapping(uint256=>bool) isReleased; 

    constructor(address _register) {
        register = IRegister(_register);
        paymentToken = IERC20(register.getAddress(PAYMENT_TOKEN_CONTRACT_CA));
        self = address(this);
    }

    function getName() pure external returns (string memory _name) {
        return name; 
    }

    function getVersion () pure external returns (uint256 _version) {
        return version; 
    }

    // get the bond ids for the caller
    function getBondIds() view external returns(uint256 [] memory _bondIds){
        return bondIdsByAddress[msg.sender]; 
    }
    // get a description of the bond
    function getBond(uint256 _bondId) view external returns (Bond memory _bond){
        return bondById[_bondId];
    }
    // issue a bond for the given amount
    function issueBond(uint256 _amount) payable external returns (uint256 _bondId){
        // check allowance 
        require(paymentToken.allowance(msg.sender, self) >= _amount, "insufficient allowance");
        // do transfer 
        paymentToken.transferFrom(msg.sender, self, _amount);
        bondedBalance += _amount; 
        // create bond 
        Bond memory bond_ = Bond({ 
                                    id      : getIndex(), 
                                    issuer  : msg.sender,  
                                    amount  : _amount
                                });
        bondById[bond_.id] = bond_; 
        bondIdsByAddress[msg.sender].push(bond_.id);
        return bond_.id;
    }
    // release the given bond 
    function releaseBond(uint256 _bondId) external returns (uint256 _payoutAmount){
        // check the bond is not locked (if the bond is liquidated it is permanently locked)
        require(!isReleased[_bondId], "bond already released ");
        require(!isLockedByBondId[_bondId], "bond locked "); 
        // check funds are available 
        Bond memory bond_ = bondById[_bondId];
        require(bondedBalance >= bond_.amount, "insufficient bond manager balance " );
        // transfer out funds 
        bondedBalance -= bond_.amount; 
        paymentToken.transferFrom(self, bond_.issuer, bond_.amount);
        isReleased[_bondId] = true;
        _payoutAmount = bond_.amount;  
        return _payoutAmount;
    }

    function lockBond(uint256 _bondId) external returns (bool _locked) {
        // check bond is not already locked 
        require(!isLockedByBondId[_bondId], "bond already locked");
        // lock the bond 
        isLockedByBondId[_bondId] = true; 
        return isLockedByBondId[_bondId];
    }

    function unlockBond(uint256 _bondId) external returns (bool _unlocked) {
        // check the bond is locked 
        require(isLockedByBondId[_bondId], "bond not locked");
        // check the bond is not liquidated 
        require(!isLiquidatedByBondId[_bondId], "bond liquidated");
        // unlock the bond; 
        isLockedByBondId[_bondId] = false; 
        return isLockedByBondId[_bondId];
    }

    function getLiquidations()  view external returns (Liquidation [] memory _liquidations) {
        uint256 [] memory liquidationIds_ =  liqudationsByBondIssuer[msg.sender];
        _liquidations = new Liquidation[](liquidationIds_.length);
        for(uint256 x = 0; x < liquidationIds_.length; x++) {
            _liquidations[x] = liquidationById[liquidationIds_[x]];
        }
        return _liquidations; 
    }

    function liquidateBond(uint256 _bondId, address _proof)  external returns (uint256 _liquidationId) {
        

    }
    //======================================= INTERNAL =======================================

    function getIndex() internal returns (uint256 _index) {
        _index = index++;
        return _index; 
    }

}