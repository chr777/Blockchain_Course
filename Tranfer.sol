pragma solidity >=0.4.22 <0.6.0;

import "./erc721.sol";
import "./safemath.sol";
import "./Bank.sol";

contract Transfer is  Bank, ERC721 {

  using SafeMath for uint256;

   mapping (uint => address) transferApprovals;

  function _transfer(address _from, address _to, uint256 _tokenId, uint256 _balance) private returns (bool){
      
      if (ownerUserBalance[msg.sender] >= _balance && _balance > 0) {
            ownerUserBalance[_to] = ownerUserBalance[_to].add(_balance);
            ownerUserBalance[msg.sender] = ownerUserBalance[msg.sender].sub(_balance);
            ownerUserAddress[_tokenId] = _to;
            emit Transfer(_from, _to, _tokenId);
            return true;
        } else { return false; }
  }
  

  function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
      require (ownerUserAddress[_tokenId] == msg.sender || transferApprovals[_tokenId] == msg.sender);
      _transfer(_from, _to, _tokenId, msg.value);
    }

  function approve(address _approved, uint256 _tokenId) external payable {
      transferApprovals[_tokenId] = _approved;
      emit Approval(msg.sender, _approved, _tokenId);
    }
    
}
