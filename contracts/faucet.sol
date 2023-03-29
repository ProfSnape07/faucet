// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "./token_omen.sol";

contract Faucet {
    using SafeMath for uint256;

    OMEN private token;

    // State variable to keep track of owner and amount of Ether to dispense
    address public owner;
    uint public ethAllowed = 10000000000000000;
    uint public tokenAllowed = 1000000000000000000000;

    // Constructor to set the owner
    constructor(address payable _tokenAddress) {
        owner = msg.sender;
        token = OMEN(_tokenAddress);
    }

    // Address and blocktime + 1 day is saved in TimeLock
    mapping(address => uint) public lockTime;

    receive() external payable {
    // Receive function to receive ETH
    }

    fallback() external payable {
    // Fallback function to receive ETH
    }
    
    // Function modifier
    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    // Function to set the ETH amount allowable to be claimed. Only the owner can call this function
    function setEthAllowed(uint newEthAllowed) public onlyOwner {
        ethAllowed = newEthAllowed;
    }

    // Function to set the token amount allowable to be claimed. Only the owner can call this function
    function setTokenAllowed(uint newTokenAllowed) public onlyOwner {
        tokenAllowed = newTokenAllowed;
    }


    // Function to send tokens and Ether from faucet to an address
    function requestTokens(address payable _requestor) public {
        // Perform a few checks to make sure function can execute
        require(block.timestamp > lockTime[_requestor], "Address have received fund in last 24 hour. Please wait.");
        require(address(this).balance > ethAllowed, "Not enough Ether funds in the faucet. Please donate.");
        require(token.balanceOf(address(this)) > tokenAllowed, "Not enough token funds in the faucet. Please donate.");

        // If the balance of this contract is greater than the requested amount, send Ether and token
        _requestor.transfer(ethAllowed);
        token.transfer(_requestor, tokenAllowed);

        // Updates locktime 1 day from now
        lockTime[_requestor] = block.timestamp + 1 days;
    }
}
