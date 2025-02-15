// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./Sbt.sol";

contract Voting {
    struct Candidate {
        string name;
        uint256 voteCount;
    }

    Candidate[] public candidates;
    address owner;
    mapping(address => bool) public voters;

    uint256 public votingStart;
    uint256 public votingEnd;

     SBT public sbtContract;

constructor(string[] memory _candidateNames, uint256 _durationInMinutes, address _sbtAddress) {
    for (uint256 i = 0; i < _candidateNames.length; i++) {
        candidates.push(Candidate({
            name: _candidateNames[i],
            voteCount: 0
        }));
    }
    owner = msg.sender;
    votingStart = block.timestamp;
    votingEnd = block.timestamp + (_durationInMinutes * 1 minutes);

    sbtContract = SBT(_sbtAddress); // SBT kontratını bağlama
}

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function addCandidate(string memory _name) public onlyOwner {
        candidates.push(Candidate({
                name: _name,
                voteCount: 0
        }));
    }

    function vote(uint256 _candidateIndex) public {
        require(block.timestamp >= votingStart && block.timestamp < votingEnd, "Voting is not active.");
        require(!voters[msg.sender], "You have already voted.");
        require(_candidateIndex < candidates.length, "Invalid candidate index.");
        
        // Kullanıcının SBT'ye sahip olup olmadığını kontrol et
        require(sbtContract.hasSoul(msg.sender), "You must have an SBT to vote.");
        
        // Oy verme işlemi
        candidates[_candidateIndex].voteCount++;
        voters[msg.sender] = true;
    }

    function getVotingStatus() public view returns (bool) {
    return (block.timestamp >= votingStart && block.timestamp < votingEnd);
}

    function getRemainingTime() public view returns (uint256) {
        require(block.timestamp >= votingStart, "Voting has not started yet.");
        if (block.timestamp >= votingEnd) {
            return 0;
        }
        return votingEnd - block.timestamp;
}
}