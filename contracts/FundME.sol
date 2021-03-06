/* Our contract should be able to:
   Get Funds from users
   Withdraw funds
   Set a minimum funding value in USD */

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "./PriceConverter.sol";

error notOWner (); //efficient way of catching erors

contract FundMe {

    using PriceConverter for uint256;

    //Two keywords that when assigned to a value, it never changes, that is constant and immutable
    //also takes less gas, have a different naming convention, all caps with underscores
    uint256 public constant MINIMUM_USD = 50 * 1e18;      //setting the minumum value in gwei

    address [] public funders; //A list of all those who successfully send funds to the contract 

    mapping(address => uint256) public addressToAmountFunded; //To map the amount sent by each individual

    address public immutable i_owner; //we set immutable for variables which are not initialized in the same line that they are created
                                    // naing convection, i_name

    //A constructor is a function that is called immediately you deploy a contract
    constructor(){
        i_owner = msg.sender;

    }

    function fund() public payable {

        /* function for people to send ethereum of any other token, we use the keyword "payable" for such
            We want to be able to set a minimum fund amount in USD
           for this there are some things to consider:
           1. How do we send ETH to this contract 
            Amount of ETH is specified in VALUE attribute
           we set the VALUE attribute by using keyword "msg.value"
           Money math is doen in terms of wei so eg 1 ETh is 1e18(1 * 10^18)
           To require the VALUE attribute to be more than a ceratain amount of 
           ETH we use "require" kwyword
           */
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Didn't send enough"); 
        /* the above function has a part for reverting, that is, if the require is not met, 
            revert with the message "Didn't send enough". 
            what is reverting? this is undoing any action before and send remaining gas back

        */
        funders.push(msg.sender); //msg.sender returns whoever initiated the fund function
        addressToAmountFunded[msg.sender] = msg.value; // does the mapping
    }

    
    //function for the owner of the contract to withdraw funds
    function withdraw() public onlyOwner{ //Due to the modifier, it will do whatever is in the modifier first before it executes the function

        //we use a loop to first reset the mapping
        //for (sarting index, ending index, step amount)
        for(uint256 funderIndex = 0; funderIndex > funders.length; funderIndex++){
            address funder = funders[funderIndex]; //creates a variable of type adress called funnder, initializes it to the value in the funders array at index that is equal to value of funderIndex
            addressToAmountFunded[funder] = 0; // Resets the mapping of funder to funds
        }
        //we now reset the funders array
        funders = new address[](0); // creates a funders as a new array with 0 elements
        
        /*
        withdraw the funds
        Three ways to do it: Transfer, Send, Call
        Call is the advisable way to do it

        Transfer (max 2300 gas, thros an error if it fails)
        payable(msg.sender).trasfer(address(this).balance); //This is to get the balance of the contract 

        Send (maximum 2300 gas, returns bool of whwhether or not sucessful)
        bool sendSuccess = payable(msg.sender).send(address(this).balance);
        require (sendSuccess, "Send Failed"); //send does not automatically revert so we add require statement
        */

        //call (forward all gas or set gas, returns bool)
        (bool callSucess,) = payable(msg.sender).call{value: address(this).balance}("");
        require (callSucess, "Call Failed");

    }

    // A modofier enables us to create a keyword that we can add onto a function declaration to modify it
    modifier onlyOwner {

        /* require(msg.sender == i_owner, "Sender is not Owner!"); //== is cheking for equivalence
        */

        //More efficient way
        if (msg.sender != i_owner){
            revert notOWner();
        }
         _; // Means now do the rest of the code in the function


    } 

    //Refer to FallBackExample
    receive() external payable {
        fund();
    }
    fallback() external payable {
        fund();
    }

}

