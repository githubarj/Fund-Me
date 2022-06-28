//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

//importing from github and npm
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


//Creating a library
library PriceConverter {
     // We then create a function to get the price of eth, to do this we will use chainlink data feeds, which is essentially reading from another contract
    function getPrice() internal view returns(uint256){
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

    function getVersion() internal view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.version();
    }

    function getConversionRate(uint256 ethAmount) internal view returns(uint256) {
        uint256 ethPrice = getPrice(); //will call the get price function which will return the price of ETh and put it into the ethPrice variable
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18; // Multiplies the ethAmount to its price to get total in USD
        return ethAmountInUsd;
    }

}