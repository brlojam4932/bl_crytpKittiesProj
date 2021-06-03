// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./IERC721.sol";
import "./SafeMath.sol";
import "./Ownable.sol";

 contract KittyContract is IERC721, Ownable {

  using SafeMath for uint256;

  mapping(uint256 => address) public kittyIndexToOwner; // an interger or index to an address
  mapping(address => uint256) ownershipTokenCount; // an address to a number, a count
  mapping(address => uint256[]) ownerToCats; //an address to a number of cats in an array

  mapping(uint256 => address) private _tokenApprovals;

  event Birth(address owner, uint256 kittenId, uint256 mumId, uint256 dadId, uint256 genes);

  // if made 'public constant', getter functions would be created
  // automatically, thus there would be no need to create getter functions
  // it's optional
  uint256 public constant CERATION_LIMIT_GEN0 = 10; // max num of cats to be generated
  string private _name;
  string private _symbol;

  uint256 public gen0Counter;

  function createKittyGen0(uint256 _genes) public onlyOwner returns(uint256){
    require(gen0Counter < CERATION_LIMIT_GEN0);

    gen0Counter++;

    // mum, dad and generation is 0
    // Gen0 have no owners; they are owned by the contract
   return  _createKitty(0,0,0, _genes, msg.sender); // msg.sender could also be -- address(this) - we are giving cats to owner

  }

struct Kitty{
  uint256 genes;
  uint64 birthTime;
  uint32 mumId;
  uint32 dadId;
  uint16 generation;
}

Kitty[] kitties;

constructor(string memory name_, string memory symbol_) {
  _name = name_;
  _symbol = symbol_;
}

  function name() external view override returns (string memory tokenName) {
    return _name;
  }
 
   
  function symbol() external view override returns (string memory tokenSymbol) {
    return _symbol;
  }
  // could be external but externals can only be called from outside not within this contract
  function totalSupply() public view override returns (uint256 total) {
    return kitties.length;

  }

  function getAllCatsFor(address owner) external view returns (uint[] memory cats) {
    return  ownerToCats[owner];
  }

   function balanceOf(address owner) external view override returns (uint256 balance ) {
    return ownershipTokenCount[owner];
  }

  function ownerOf(uint256 _tokenId) external view override returns (address) {
    address _owner = kittyIndexToOwner[_tokenId];
    require(_owner != address(0), "ERC721: owner query for nonexistent token");

    return _owner;
  }
/*
  function approve(address to, uint256 _tokenId) public virtual {
    address _owner = kittyIndexToOwner[_tokenId];
    require(to != _owner);
    require(msg.sender == _owner);

    _approve(to, _tokenId);

  }
  */

  // create cats by generation and by breeding
  // retuns cat id
  function _createKitty(
    uint256 _genes,
    uint256 _mumId,
    uint256 _dadId,
    uint256 _generation, //1,2,3..etc
    address _owner // recipient
  ) private returns(uint256) {
    Kitty memory newKitties = Kitty({ // create struct object
      genes: (_genes),
      birthTime: uint64(block.timestamp),
      mumId: uint32(_mumId),
      dadId: uint32(_dadId),
      generation: uint16(_generation)
     });

     kitties.push(newKitties); // returns the size of array - 1 for the first cat

     uint256 newKittenId = kitties.length -1; // 0 -1

     emit Birth(_owner, newKittenId, _mumId, _dadId, _genes);

     _transfer(address(0), _owner, newKittenId); // birth of a cat from 0 (standard)

    return newKittenId; //returns 256 bit integer


  }
  
    // available function to outside calls - it only sends from msg.sender to recipients
    function transfer(address _to, uint256 _tokenId) external override {
    require(address(_to) != address(this), "to cannot be the contract address" );
    require(address(_to) != address(0),"to cannot be the zero address" );
    require(_owns(msg.sender, _tokenId));

    _transfer(address(0), _to, _tokenId);
    // 
    emit Transfer(address(0), _to, _tokenId);
     
  }

  // must transfer from address 0
  function _transfer(address _from,  address _to, uint256 _tokenId) internal {
    require(address(_to) != address(this), "to cannot be the contract address" );
    require(address(_to) != address(0),"to cannot be the zero address" );
    require(kittyIndexToOwner[_tokenId] == msg.sender);

    //_approve(address(0), _tokenId);

    ownershipTokenCount[_to] = ownershipTokenCount[_to].add(1);

    kittyIndexToOwner[_tokenId] = _to;
    ownerToCats[_to].push(_tokenId);
   
    // decrease token count from person A to person B
    if (_from != address(0)) {
      ownershipTokenCount[_from] = ownershipTokenCount[_to].sub(1);
        _removeTokenIdFromOwner(_from, _tokenId);
    }

    // might need to input _from instead of msg.sender to transfer from 0 address
    emit Transfer(_from, _to, _tokenId);
     
  }

    function _removeTokenIdFromOwner(address _owner, uint256 _tokenId) internal {
      uint256 lastId = ownerToCats[_owner][ownerToCats[_owner].length -1];
      for (uint256 i = 0; i < ownerToCats[_owner].length -1; i++) {
        if (ownerToCats[_owner][i] == _tokenId) {
            ownerToCats[_owner][i] = lastId;
            ownerToCats[_owner].pop();
        }

      }

  }
/*
  function _approve(address to, uint256 _tokenId) internal virtual {
    address _owner = kittyIndexToOwner[_tokenId];
    _tokenApprovals[_tokenId] = to;
    emit Approval(_owner, to, _tokenId);

  }
  */

  function _owns(address _claimant, uint256 _tokenId) internal view returns(bool) {
    return kittyIndexToOwner[_tokenId] == _claimant;
  }



}