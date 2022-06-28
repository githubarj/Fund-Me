// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract FallBackExample{
    uint256 public result;

    receive() external payable {      //Triggered if transactions are sent without any call data 
        result = 1;

    }

    fallback() external payable{
        result = 2;
    }
}