//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

/*
 * Dehive Members contract.
 *
 * by @prabhu
 */
contract DeHiveToken is ERC1155, ERC1155Supply, Ownable {
    using Strings for string;
    using SafeMath for uint256;

    event MemberAdded(uint256 memberId, string name, string metadataUrl);

    struct DeHiveMember {
        uint256 friendCount;
        string profileName;
        string metadataUrl;
    }
    string public name;
    mapping(uint256 => DeHiveMember) public members;
    uint256 public totalMembers;
    constructor(
        string memory _name
        ) ERC1155("https://dehive.eth") {
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
    function addMember(string memory _name, string memory _metadataUrl) public onlyOwner {
        uint256 newMemberId = totalMembers;
        DeHiveMember memory member = DeHiveMember(0, _name, _metadataUrl );
        members[newMemberId] = member;
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

    function withdraw() public virtual onlyOwner {
        uint256 _balance = address(this).balance;
        uint256 baseAmount = _balance;
        require(payable(msg.sender).send(baseAmount));
    }

}