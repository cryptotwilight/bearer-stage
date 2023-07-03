// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.19;

import {BearerToken} from "../interfaces/IBearerTokenInventory.sol";

// version 1

interface IBearerTokenNFT { 

    function mint(BearerToken memory _bearerToken) external returns (BearerToken memory _updatedBearerToken);

}