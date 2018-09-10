pragma solidity 0.4.24;

contract Goodschain {
    // manager is who create smart contract
    address public chainManager;

    constructor() public {
        chainManager = msg.sender;
    }

    struct DataPusher {
        uint batchId;
        uint stageId;
    }
    
    // bachid => stage => list of hash (hash is String)
    mapping(uint => mapping(uint => string[])) public ChainData;
    mapping(address => DataPusher) public allowedPushers;

    function addPusher(uint batchId, uint stageId, address pusher) public managerOnly {
        allowedPushers[pusher].batchId = batchId;
        allowedPushers[pusher].stageId = stageId;
    }

    function deletePusher(address pusher) public managerOnly {
        delete allowedPushers[pusher];
    }

    function addHash(uint batchId, uint stageId, string stageHash) public stateAuthorized(batchId, stageId) {
        ChainData[batchId][stageId].push(stageHash);
    }
    
    function getHash(uint batchId, uint stageId, uint index) public view returns(string tempHash) {
        tempHash = ChainData[batchId][stageId][index];
        return tempHash;
    }

    function verifyHash(uint batchId, uint stageId, string hashValue) public view returns(bool) {
        for (uint i = 0; i < ChainData[batchId][stageId].length; i++ ) {
            if (keccak256(abi.encodePacked(ChainData[batchId][stageId][i])) == keccak256(abi.encodePacked(hashValue))) {return true;}
        }
        return false;
    }

    modifier managerOnly(){
        require(msg.sender == chainManager, "This function for manager only");
        _;
    }

    modifier stateAuthorized(uint batchId, uint stageId){
        require(allowedPushers[msg.sender].batchId == batchId && allowedPushers[msg.sender].stageId == stageId, "You are not authorized");
        _;
    }
}