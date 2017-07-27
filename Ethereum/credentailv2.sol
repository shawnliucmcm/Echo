pragma solidity ^0.4.13;

contract owned {
  function owned() { owner = msg.sender; }
  address owner;
  modifier onlyowner { if (msg.sender == owner) 
    _ ;
  }
}

contract Credential is owned {
    struct Info {
        bytes32   issuer;
        bytes32   recipient;
        bytes32   imageHash;
        bytes32   credentialProofDoc;
    }
    Info info;
    uint256 public credentialDate;
    enum credentialStatus { Created, Locked, Inactive }
    credentialStatus status;

    function createCredential(bytes32 issuerEntry, bytes32 recipientEntry, uint256 credentialDateEntry, bytes32 credentialEntry, bytes32 descriptionEntry) onlyowner {

        info.issuer = issuerEntry;
        info.recipient = recipientEntry;
        credentialDate = credentialDateEntry;
        status = credentialStatus.Created;
    }

    function clear() onlyowner {
        delete info;
    }

    function setStatusLocked() onlyowner
    {
        status = credentialStatus.Locked;
        majorEventFunc(block.timestamp, "Changed Status to Locked", "");
    }
    
    function setStatusInactive() onlyowner
    {
        status = credentialStatus.Inactive;
        majorEventFunc(block.timestamp, "Changed Status to Inactive", "");
    }
    
    // Set the IPFS hash of the image of the recipient
    function setImage(bytes32 IPFSImageHash) onlyowner
    {
        info.imageHash = IPFSImageHash;
        majorEventFunc(block.timestamp, "Entered Recipient Image", "Image is in IPFS");
    }
    
    // Upload documentation for proof of credential - e.g. graduation certificate
    function credentialProof(bytes32 IPFSProofHash) onlyowner
    {
        info.credentialProofDoc = IPFSProofHash;
        majorEventFunc(block.timestamp, "Entered Credential Proof", "Credential proof in IPFS");
    }

    // Log major events
    function majorEventFunc(uint256 eventTimeStamp, bytes32 name, bytes32 description)
    {
        MajorEvent(block.timestamp, eventTimeStamp, name, description);
    }

    // Declare event structure
    event MajorEvent(uint256 logTimeStamp, uint256 eventTimeStamp, bytes32 indexed name, bytes32 indexed description);

}


contract MultipleCredential is Credential {

    mapping (bytes32 => Info) Infos;
    
    function createMultipleCredential(bytes32[] issuerEntries, bytes32[] recipientEntries, uint256 credentialDateEntry, bytes32 descriptionEntry, bytes32[] IPFSImageHashes, bytes32[] IPFSProofHashes) onlyowner {

        assert (issuerEntries.length == recipientEntries.length && issuerEntries.length == IPFSImageHashes.length && issuerEntries.length == IPFSProofHashes.length);

        credentialDate = credentialDateEntry;
        status = credentialStatus.Created;

        for (uint index = 0; index < issuerEntries.length; index++) {
            Infos[IPFSProofHashes[index]].issuer = issuerEntries[index];
            Infos[IPFSProofHashes[index]].recipient = recipientEntries[index];
            Infos[IPFSProofHashes[index]].imageHash = IPFSImageHashes[index];
            Infos[IPFSProofHashes[index]].credentialProofDoc = IPFSProofHashes[index];
        }
        
    }

}
