// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.19;

struct Bond {
    uint256 id;
    address issuer; 
    uint256 amount; 
}

struct Liquidation {
    uint256 id; 
    uint256 bondIssuer; 
    uint256 bondId; 
    address proof; 
}

interface IBondManager {

    // returns the liquidations suffered by the caller
    function getLiquidations() view external returns (Liquidation [] memory _liquidations);
    // get the bond ids for the caller
    function getBondIds() view external returns(uint256 [] memory _bondIds);
    // get a description of the bond
    function getBond(uint256 _bondId) view external returns (Bond memory _bond);
    // issue a bond for the given amount
    function issueBond(uint256 _amount) payable external returns (uint256 _bondId);
    // release the given bond 
    function releaseBond(uint256 _bondId) external returns (uint256 _payoutAmount);
    // this locks the given bond preventing it from being released
    function lockBond(uint256 _bondId) external returns (bool _locked);
    // this unlocks the given bond allowing it to be released
    function unlockBond(uint256 _bondId) external returns (bool _unlocked);
    // this liquidates a given bond based on the attached proof
    function liquidateBond(uint256 _bondId, address _proof) external returns (uint256 _liquidationId);

}