// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

//deployed to goerli at 0x5c66eE33776D1266E278216fa04E3F738385d26b

// Import this file to use console.log
//import "hardhat/console.sol";

contract BuyMeACoffee {
    // event to emit when a memo is created
    event NewMemo(
        address indexed from,
        uint256 timestamp,
        string name,
        string message        
    );

    //memo struct
    struct Memo {
        address from;
        uint256 timestamp;
        string name;
        string message;
    }

    //list of all memos received from friends
    Memo[] memos;

    // address of contract deployer.
    address payable owner;
    
    // address to withdraw funds to
    address payable withdrawalAddress;


    //deploy logic
    constructor() {
        //initially owners of contract and address to withdrawl to are the same
        owner = payable(msg.sender);
        withdrawalAddress = owner;

    }

    /** 
    * @dev buy a coffee for contract owner
    * @param _name name of cofeee buyer
    * @param _message a nice message from the coffee buyer
    */

    function buyCoffee(string memory _name, string memory _message) public payable {

        require(msg.value > 0, "Can't buy coffee with 0 eth");

        //add memo to storage
        memos.push(Memo(
            msg.sender,
            block.timestamp,
            _name,
            _message
        ));

        //emit a log event when a new memo is created
        emit NewMemo(
            msg.sender,
            block.timestamp,
            _name,
            _message
        );

    }

    /** 
    * @dev buy a large coffee for contract owner
    * @param _name name of cofeee buyer
    * @param _message a nice message from the coffee buyer
    */
    function buyLargeCoffee(string memory _name, string memory _message) public payable {

        require(msg.value >= 0.003 * (10**18), "Can't buy large coffee with less than 0.003 eth");

        //add memo to storage
        memos.push(Memo(
            msg.sender,
            block.timestamp,
            _name,
            _message
        ));

        //emit a log event when a new memo is created
        emit NewMemo(
            msg.sender,
            block.timestamp,
            _name,
            _message
        );

    }


    /** 
    * @dev send the entire balance stored in this contract to the owner
    */


    function withdrawTips() public {
        
        require(withdrawalAddress.send(address(this).balance));

    }
    
    /** 
    * @dev retrieve all the memos stored on the blockchain
    */
    function getMemos() public view returns(Memo[] memory) {

        return memos;
    }

    /** 
    * @dev change withdrawal address for contract
    */
    function changeWithdrawalAddress(address _withdrawalAddress) public {
        
        //only owner of contract can designate a different address to send funds to
        require(msg.sender == owner);

        //assign new withdrawal address
        withdrawalAddress = payable(_withdrawalAddress);

    }

    
}
