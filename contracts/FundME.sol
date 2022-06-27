/* Our contract should be able to:
   Get Funds from users
   Withdraw funds
   Set a minimum funding value in USD */

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

//importing from github and npm
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe {

    uint256 public minimumUSD = 50 * 1e18;      //setting the minumum value in gwei

    address [] public funders; //A list of all those who successfully send funds to the contract 

    mapping(address => uint256) public addressToAmountFunded; //To map the amount sent by each individual

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
        require(getConversionRate(msg.value) >= minimumUSD, "Didn't send enough"); 
        /* the above function has a part for reverting, that is, if the require is not met, 
            revert with the message "Didn't send enough". 
            what is reverting? this is undoing any action before and send remaining gas back

        */
        funders.push(msg.sender); //msg.sender returns whoever initiated the fund function
        addressToAmountFunded[msg.sender] = msg.value; // does the mapping
    }

    // We then create a function to get the price of eth, to do this we will use chainlink data feeds, which is essentially reading from another contract
    function getPrice() public view returns(uint256){
        //Since this is an instance of us interacting with a contract outside of our project we need
        //ABI - this is basically the list of functions and interactions you can have within a contract
        //example of chainlink interface- github.com/smartcontractkit/chainlink - contracts - src - vo.8 - interfaces
        //we can paste the interface and we will get the ABI of the contract
        //Address- this can be gotten from the contract adresses in chainlink docs
        //under the network you want  and token relatinship eg ETH/USD
        //Address - 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (,int price,,,) = priceFeed.latestRoundData(); //This returns multiple values thats why we do the bracket before 
        //Will return price of ETH in terms of USD
        //the number will not come with decimals
        //msg.value has 18 decimals and the ETH to USD price has 8, so we have to make them match up
        return uint256(price * 1e10); //to match mdg.value which is a uint 256

    }

    function getVersion() public view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.version();
    }

    function getConversionRate(uint256 ethAmount) public view returns(uint256) {
        uint256 ethPrice = getPrice(); //will call the get price function which will return the price of ETh and put it into the ethPrice variable
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18; // Multiplies the ethAmount to its price to get total in USD
        return ethAmountInUsd;
    }



    //function for the owner of the contract to withdraw funds
    function withdraw() public {}

}

