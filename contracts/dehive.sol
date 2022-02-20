//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.12;
pragma abicoder v2; // required to accept structs as function parameters

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/draft-EIP712.sol";

/*
 * Dehive Members contract.
 *
 * by @prabhu
 */
contract DeHiveToken is ERC1155,EIP712, ERC1155Supply, Ownable {
    using Strings for string;
    using SafeMath for uint256;
    string private constant SIGNING_DOMAIN = "DeHiveNFT-Voucher";
    string private constant SIGNATURE_VERSION = "1";
    event MemberAdded(uint256 memberId, string name, string metadataUrl);

    struct DeHiveMember {
        uint256 friendCount;
        string profileName;
        string metadataUrl;
        address owner;
    }
      /// @notice Represents an un-minted NFT, which has not yet been recorded into the blockchain. A signed voucher can be redeemed for a real NFT using the redeem function.
  struct NFTVoucher {
    /// @notice The id of the token to be redeemed. Must be unique - if another token with this ID already exists, the redeem function will revert.
    uint256 tokenId;

    /// @notice The minimum price (in wei) that the NFT creator is willing to accept for the initial sale of this NFT.
    uint256 minPrice;

    /// @notice The metadata URI to associate with this token.
    string uri;

    /// @notice the EIP-712 signature of all other fields in the NFTVoucher struct. For a voucher to be valid, it must be signed by an account with the MINTER_ROLE.
    bytes signature;
  }
    string public name;
    mapping(uint256 => DeHiveMember) public members;
    mapping(address => uint256) public memberByAddress;
    uint256 public totalMembers;
    constructor(
        string memory _name
        ) ERC1155("https://dehive.eth")
        EIP712(SIGNING_DOMAIN, SIGNATURE_VERSION) { 
        name = _name;
    }

    function acceptOneInvite(uint256 _memberId)
        public
    {
        DeHiveMember storage member = members[_memberId];
        member.friendCount = member.friendCount+1;
        _mint(msg.sender, _memberId, 1, "");
    }
    function sendOneInvite(uint256 _memberId, address[] calldata _list)
        public
    {
        sendMultipleInvite(_memberId,1,_list);
    }
    function sendMultipleInvite(uint256 _memberId, uint256 _memberCount, address[] calldata _list)
        public
    {
        for (uint256 i = 0; i < _list.length; i++) {
            DeHiveMember storage member = members[_memberId];
            member.friendCount = member.friendCount+_memberCount;

            _mint(_list[i], _memberId, _memberCount, "");
        }
    }
    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal override(ERC1155, ERC1155Supply) {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
    function addMember(string memory _name, string memory _metadataUrl) public  {
        uint256 newMemberId = totalMembers+1;
        DeHiveMember memory member = DeHiveMember(0, _name, _metadataUrl, msg.sender );
        members[newMemberId] = member;
        memberByAddress[msg.sender] = newMemberId;
        totalMembers++;
        emit MemberAdded(newMemberId, _name, _metadataUrl);
    }
    function listMembers() public view onlyOwner returns (DeHiveMember[] memory _members) {
        _members = new DeHiveMember[](totalMembers);
        for (uint256 i = 0; i < totalMembers; i++) {
            _members[i] = members[i];
        }
    }

    function uri(uint256 _memberId) public view override returns (string memory output) {
        require(exists(_memberId), "Member doesn't exists");
        DeHiveMember memory member = members[_memberId];
        output = member.metadataUrl;
    }
    function uriByAddress(uint256 _memberAddress) public view returns (string memory output) {
        uint256 _memberId = memberByAddress[msg.sender];
        require(exists(_memberId), "Member doesn't exists");
        DeHiveMember memory member = members[_memberId];
        output = member.metadataUrl;
    }

    function withdraw() public virtual onlyOwner {
        uint256 _balance = address(this).balance;
        uint256 baseAmount = _balance;
        require(payable(msg.sender).send(baseAmount));
    }
    function getMemberId() public view returns (uint256 output) {
        output = memberByAddress[msg.sender];
    }

   /// @notice Returns a hash of the given NFTVoucher, prepared using EIP712 typed data hashing rules.
  /// @param voucher An NFTVoucher to hash.
  function _hash(NFTVoucher calldata voucher) internal view returns (bytes32) {
    return super._hashTypedDataV4(keccak256(abi.encode(
        
      keccak256("NFTVoucher(uint256 tokenId,uint256 minPrice,string uri)"),
      voucher.tokenId,
      voucher.minPrice,
      keccak256(bytes(voucher.uri))
    )));
  }

  /// @notice Verifies the signature for a given NFTVoucher, returning the address of the signer.
  /// @dev Will revert if the signature is invalid. Does not verify that the signer is authorized to mint NFTs.
  /// @param voucher An NFTVoucher describing an unminted NFT.
  function _verify(NFTVoucher calldata voucher) internal view returns (address) {
    bytes32 digest = _hash(voucher);
    return ECDSA.recover(digest, voucher.signature);
  }



  /// @notice Redeems an NFTVoucher for an actual NFT, creating it in the process.
  /// @param redeemer The address of the account which will receive the NFT upon success.
  /// @param voucher A signed NFTVoucher that describes the NFT to be redeemed.
  function acceptInvite(address redeemer, uint256 _memberId,NFTVoucher calldata voucher) public payable returns (uint256) {
    // make sure signature is valid and get the address of the signer
    address signer = _verify(voucher);

    _mint(redeemer, _memberId, 1, "");

    return voucher.tokenId;
  }

  function acceptInviteOpen( uint256 _memberId) public  {
    _mint(msg.sender, _memberId, 1, "");
  }
}