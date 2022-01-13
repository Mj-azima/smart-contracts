// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.16 <0.9.0;

contract Vote{
    // state variable

    address public owner;
    enum states{NotStarted, Started, Finished}
    states public currentState;
    struct condidate{
        uint8 id;
        string name;
        uint voteCount;
    }
    mapping(uint8=> condidate) public condidates;
    mapping(address => bool) public voters;
    uint8 public candidateNumber;
    // error functions
    // modifiers
    modifier inState(states _state){
        if(currentState != _state)
        revert("invalid state!");
        _;
    }
    modifier onlyOwner(){
        require(msg.sender == owner, "only owner can call this function");
        _;
    }
    modifier alreadyVoted(){
        if(voters[msg.sender])
        revert("the voter has already voted!");
        _;
    }
    modifier candidateNotFound(uint8 _id){
        if(_id>candidateNumber-1)
        revert("candidate not found!");
        _;
    }
    // events
    event Winner(uint8 winnerId , uint winnerVote);
    // constructor
    constructor(){
        owner = msg.sender;
    }
    // functions
    function changeState(uint8 s) public onlyOwner{
        if(s==0){
            currentState = states.NotStarted;
        }else if(s==1){
            currentState = states.Started;
        }else{
            currentState = states.Finished;
        }
    }

    function addCondidate(string memory name) public onlyOwner inState(states.NotStarted) returns(string memory) {
        condidates[candidateNumber] = condidate(candidateNumber,name,0);
        candidateNumber++;
        return "condidate Add!";
    }

    function vote(uint8 _id) public inState(states.Started) alreadyVoted candidateNotFound(_id) returns(string memory){
        condidates[_id].voteCount++;
        voters[msg.sender] = true;
        return "voted succesfully!";
    }

    function getFinalWinner() public inState(states.Finished) {
        uint8 winnerId;
        uint winnerVote;
        for(uint8 i= 0; i< candidateNumber; i++){
            if(condidates[i].voteCount>winnerVote){
                winnerId = i;
                winnerVote =condidates[i].voteCount;

            }
        }
        emit Winner(winnerId,winnerVote);
    }

}