// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.16 <0.9.0;



contract Bendaz{
    
    // state variable

    uint public value;    
    address payable seller;
    address payable consumer;

    enum modes{Created, Locked, Release, Inactivate}
    modes public currentMode;

    // modifiers

    modifier condition(bool _condition){
        require(_condition, "condition is not true!");
        _;
    }

    modifier onlySeller(){
        require(msg.sender == seller,"this command just use by Seller!");
        _;
    }

    modifier onlyConsumer(){
        require(msg.sender == consumer, "this command just use by Consumer!");
        _;
    }
    modifier inMode( modes _mode){
        require(currentMode == _mode, "by this mode this command Invalid!");
        _;
    }

    // event
    event StopContract();
    event AcceptBuy();
    event AcceptRecived();
    event GetPrice();
    // error

    // constructor
    constructor() payable {
        seller = payable(msg.sender);
        currentMode = modes.Created;
        value = msg.value/2;
        if ( 2* value != msg.value)
        revert("value is not even!");

    }

    //functions
    function stopContract() public onlySeller inMode(modes.Created) {
        currentMode = modes.Inactivate;
        seller.transfer(address(this).balance);
        emit StopContract();
    }

    function acceptBuy() public payable inMode(modes.Created) condition(msg.value == (2*value)) {
        currentMode = modes.Locked;
        consumer = payable (msg.sender);
        emit AcceptBuy();
    }

    function acceptRecived() public onlyConsumer inMode(modes.Locked) {
        currentMode= modes.Release;
        consumer.transfer(value);
        emit AcceptRecived();
    }

    function getPrice() public onlySeller inMode(modes.Release){
        currentMode = modes.Inactivate;
        seller.transfer(3*value);
        emit GetPrice();
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;        
    }

}