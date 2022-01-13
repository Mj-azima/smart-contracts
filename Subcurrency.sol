// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.16 <0.9.0;

contract Subcurrency {
    // state variables
    address public minter;
    mapping (address => uint) public balances;

    
    
    // error functions 
    
    
    // modifiers
    modifier onlyMinter(){
        require(msg.sender == minter);
        _;
    }
    

    // events
    event Send(address _from , address _to , uint amount);

    // constructor
    constructor(){
        minter = msg.sender;
        
    }


    //functions

    function mint(address receiver , uint amount) public onlyMinter {
        balances[receiver] += amount;

    }

    function send(address receiver, uint amount) public  {
        if(amount>balances[msg.sender])
        revert("insufficent balance!");

        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Send(msg.sender , receiver , amount);
    
    }



}