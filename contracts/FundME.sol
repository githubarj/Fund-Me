/* Our contract should be able to:
   Get Funds from users
   Withdraw funds
   Set a minimum funding value in USD */

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

contract FundMe {

    uint256 public minimumUSD = 50;      //setting the minumum value in usd

    function fund() public payable {

        /* function for people to send money, we use the keyword "payable" for such
            We want to be able to set a minimum fund amount in USD
           for this there are some things to consider:
           1. How do we send ETH to this contract 
            Amount of ETH is specified in VALUE attribute
           we set the VALUE attribute by using keyword "msg.value"
           Money math is doen in terms of wei so eg 1 ETh is 1e18(1 * 10^18)
           To require the VALUE attribute to be more than a ceratain amount of 
           ETH we use "require" kwyword
           */

        require(msg.value >= minimumUSD, "Didn't send enough"); 

        /* the above function has a part for reverting, that is, if the require is not met, 
            revert with the message "Didn't send enough". 
            what is reverting? this is undoing any action before and send remaining gas back

        */
        





    }

    //function for the owner of the contract to withdraw funds
    function withdraw() public {}

}

