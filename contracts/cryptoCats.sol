// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./IERC721.sol";
import "./SafeMath.sol";
import "./Ownable.sol";


  contract KittyContract is IERC721,  Ownable {

  using SafeMath for uint256;

  mapping(uint256 => address) public kittyIndexToOwner; // an interger or index to an address
  mapping(address => uint256) ownershipTokenCount; // an address to a number, a count
  mapping(address => uint256[]) ownerToCats; //an address to a number of cats in an array

  //mapping(uint256 => address) private _tokenApprovals;

  event Birth(address owner, uint256 kittenId, uint256 mumId, uint256 dadId, uint256 genes);

  // if made 'public constant', getter functions would be created
  // automatically, thus there would be no need to create getter functions
  // it's optional
  uint256 public constant CERATION_LIMIT_GEN0 = 10; // max num of cats to be generated
  uint256 public gen0Counter;
 

  string private _name;
  string private _symbol;

  struct Kitty{
  uint64 birthTime;
  uint32 mumId;
  uint32 dadId;
  uint16 generation;
  uint256 genes;
}

Kitty[] kitties;

  constructor(string memory name_, string memory symbol_) {
    _name = name_;
    _symbol = symbol_;
    owner = msg.sender;
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

  function ownerOf(uint256 tokenId) external view override returns (address owner) {
    address _owner = kittyIndexToOwner[tokenId];
    require(_owner != address(0), "ERC721: owner query for nonexistent token");

    return _owner;
  }
  

  function getKitty(uint256 tokenId) external view returns(uint256, uint256, uint256, uint256, uint256) {
    Kitty storage returnKitty = kitties[tokenId]; // storage is a pointer, instead of using memory - - we do not make a local copy of it
    return (returnKitty.birthTime,  returnKitty.mumId, returnKitty.dadId, returnKitty.generation, returnKitty.genes);
  }

   function getKittyFilip(uint256 _id) public view returns(
     uint256 birthTime, 
     uint256 mumId, 
     uint256 dadId, 
     uint256 generation, 
     uint256 genes) {

    Kitty storage kitty = kitties[_id];

    birthTime = uint256(kitty.birthTime);
    mumId = uint256(mumId);
    dadId = uint256(dadId);
    generation = uint256(kitty.generation);
    genes = kitty.genes;
  }

  /*

  function approve(address to, uint256 tokenId) public virtual {
    address _owner = kittyIndexToOwner[tokenId];
    require(to != _owner);
    require(msg.sender == _owner);

    _approve(to, tokenId);

  }
  */

   // available function to outside calls - it only sends from msg.sender to recipients
  function transfer(address to, uint256 tokenId) external override {
    require(to != address(this), "to cannot be the contract address" );
    require(to != address(0),"to cannot be the zero address" );
    require(_owns(msg.sender, tokenId));

    _transfer(address(0), to, tokenId);
    
    // might need to input _from instead of msg.sender to transfer from 0 address
    emit Transfer(address(0), to, tokenId);
     
  }

  function createKittyGen0(uint256 _genes) public onlyOwner returns(uint256){
    require(gen0Counter < CERATION_LIMIT_GEN0, "Gen 0 should be less than creation limit gen 0");

    gen0Counter++;

    // mum, dad and generation is 0
    // Gen0 have no owners; they are owned by the contract
   return  _createKitty(0,0,0, _genes, msg.sender); // msg.sender could also be -- address(this) - we are giving cats to owner

  }

  // create cats by generation and by breeding
  // retuns cat id
  function _createKitty(
    uint256 _mumId,
    uint256 _dadId,
    uint256 _generation, //1,2,3..etc
    uint256 _genes, // recipient
    address owner
  ) private returns(uint256) {
    Kitty memory newKitties = Kitty({ // create struct object
      genes: _genes,
      birthTime: uint64(block.timestamp),
      mumId: uint32(_mumId),
      dadId: uint32(_dadId),
      generation: uint16(_generation)
     });

     kitties.push(newKitties); // returns the size of array - 1 for the first cat

     uint256 newKittenId = kitties.length -1; // 0 -1

     emit Birth(owner, newKittenId, _mumId, _dadId, _genes);

     _transfer(address(0), owner, newKittenId); // birth of a cat from 0 (standard)

    return newKittenId; //returns 256 bit integer

  }


 

  // must transfer from address 0
  function _transfer(address from,  address to, uint256 tokenId) internal {
    //_approve(address(0), tokenId);

    ownershipTokenCount[to] = ownershipTokenCount[to].add(1);

    kittyIndexToOwner[tokenId] = to;
    ownerToCats[to].push(tokenId);
   
    // decrease token count from person A to person B
    if (from != address(0)) {
      ownershipTokenCount[from] = ownershipTokenCount[from].sub(1);
        _removeTokenIdFromOwner(from, tokenId);
    }
     
  }

    function _removeTokenIdFromOwner(address owner, uint256 tokenId) internal {
      uint256 lastId = ownerToCats[owner][ownerToCats[owner].length -1];
      for (uint256 i = 0; i < ownerToCats[owner].length; i++) {
        if (ownerToCats[owner][i] == tokenId) {
            ownerToCats[owner][i] = lastId;
            ownerToCats[owner].pop();
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
  
  function _owns(address _claimant, uint256 tokenId) internal view returns(bool) {
    return kittyIndexToOwner[tokenId] == _claimant;
  }

}
