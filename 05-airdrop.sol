pragma solidity >=0.7.0;

import "./03-token.sol";

// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Airdrop {
    // Using Libs

    // Structs

    // Enum
    enum Status {
        ACTIVE,
        PAUSED,
        CANCELLED
    } // mesmo que uint8

    // Properties
    address private owner;
    address public tokenAddress;
    address[] private subscribers;
    Status contractState;

    // Modifiers
    modifier isOwner() {
        require(msg.sender == owner, "Sender is not owner!");
        _;
    }

    // Events
    event NewSubscriber(address beneficiary, uint256 amount);

    // Constructor
    constructor(address token) {
        owner = msg.sender;
        tokenAddress = token;
        contractState = Status.PAUSED;
    }

    // Public Functions

    function subscribe() public returns (bool) {
        //TODO: Need Implementation
        if (subscribers.length > 0)
            require(
                hasSubscribed(msg.sender),
                "Wallet is already registered with AirDrop!"
            );
        subscribers.push(msg.sender);
        return true;
    }

    function execute() public isOwner returns (bool) {
        uint256 balance = CryptoToken(tokenAddress).balanceOf(address(this));
        uint256 amountToTransfer = balance / subscribers.length;
        for (uint256 i = 0; i < subscribers.length; i++) {
            require(subscribers[i] != address(0));
            require(
                CryptoToken(tokenAddress).transfer(
                    subscribers[i],
                    amountToTransfer
                )
            );
        }

        return true;
    }

    function state() public view returns (Status states) {
        return contractState;
    }

    // Private Functions
    function hasSubscribed(address subscriber) private view returns (bool) {
        //TODO: Need Implementation
        uint256 count = 0;
        bool isSubscribed = false;
        do {
            if (subscribers[count] != subscriber) isSubscribed = true;
            count += 1;
        } while (count < subscribers.length && !isSubscribed);

        return isSubscribed;
    }

    // Kill
    function kill() public isOwner {
        //TODO: Need Implementation
        delete subscribers;
        contractState = Status.CANCELLED;
        selfdestruct(payable(owner));
    }
}
