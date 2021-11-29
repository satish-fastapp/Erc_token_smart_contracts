pragma solidity ^0.8.7;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol";



contract NFTAirdrop {
  struct Airdrop {
    address nft;
    uint id;
  }
  uint public nextAirdropId;
  address public admin;
  mapping(uint => Airdrop) public airdrops;
  mapping(address => bool) public recipients;

  constructor() public payable {
    admin = msg.sender;
  }

  function addAirdrops(Airdrop[] memory _airdrops) external payable{
    uint _nextAirdropId = nextAirdropId;
    for(uint i = 0; i < _airdrops.length; i++) {
      airdrops[_nextAirdropId] = _airdrops[i];
      IERC721(_airdrops[i].nft).transferFrom(
        msg.sender, 
        _airdrops[i].nft,
        _airdrops[i].id
      );
      _nextAirdropId++;
    }
  }
  

  function addRecipients(address[] memory _recipients) external {
    require(msg.sender == admin, 'only admin');
    for(uint i = 0; i < _recipients.length; i++) {
      recipients[_recipients[i]] = true;
    }
  }

  function removeRecipients(address[] memory _recipients) external {
    require(msg.sender == admin, 'only admin');
    for(uint i = 0; i < _recipients.length; i++) {
      recipients[_recipients[i]] = false;
    }
  }

  function claim() external {
    require(recipients[msg.sender] == true, 'recipient not registered');
    recipients[msg.sender] = false;
    Airdrop storage airdrop = airdrops[nextAirdropId];
    IERC721(airdrop.nft).transferFrom(address(this), msg.sender, airdrop.id);
    nextAirdropId++;
  }
}