// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.16 <0.9.0;

contract Vote{
    // state variable

    address public owner;
    address public  Mode;
    string[] public condidatesName;
    uint public result;
    mapping (address => uint ) public condidates;


    // error functions




    // modifiers

    modifier onlyOwner(){
        require(msg.sender == owner );
        _;
    }

    modifier electionIsNotStarted(){
        
        require(Mode == keccak256(abi.encodePacked(("NotStarted"))));
        _;
    }

    modifier electionIsStarted(){
        require(Mode == keccak256(abi.encodePacked(("Started"))));
        _;
    }


    // events




    
    // constructor

    constructor(){
        owner = msg.sender;
        Mode = keccak256(abi.encodePacked(("NotStarted")));
    }



    // functions

    function setCondidate(address  _address) external onlyOwner electionIsNotStarted  {
        condidates[_address] = 0;
        condidatesName.push[_address];
    }

    function changeMode(string memory _Mode ) external onlyOwner {
        Mode = _Mode;
    }

    function election (address  _address) external {
        condidates[_address]++;
    }

    function resultElection() external {
        for(uint i=0;i<condidatesName.length();i++){
            if(condidates[condidatesName[i]] >= result)
            result= condidates[condidatesName[i]] ; 
        }
    }
}