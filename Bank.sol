pragma solidity >=0.4.22 <0.6.0;

import "./ownable.sol";
import "./safemath.sol";

contract Bank is Ownable{
    
    using SafeMath for uint256;
 

    address BankAccount;
    uint256 BanckBalance;
    event NewUser(uint UserId, string name, uint256 balance);
    uint idModulus = 10 ** 8;
    uint256 UserCount;


    mapping (uint256 => string) IdToName;
    mapping (uint256 => address) public ownerUserAddress;
    mapping (address => uint256)  ownerUserBalance;
    
    function _generateRandomId(string memory _name)  public view returns (uint) {
        uint rand_id = uint(keccak256(abi.encodePacked(_name)));
        return rand_id % idModulus;
    }
    
    function _createNewUser(string memory _name, uint256 _balance) internal  {
        UserCount = UserCount.add(1);
        uint id = _generateRandomId(_name);
        id = id - id % 100;  
        IdToName[id] = _name;
        ownerUserAddress[id] = msg.sender;
        ownerUserBalance[msg.sender] = _balance;
        BanckBalance = BanckBalance.add(_balance);
        emit NewUser(id, _name, _balance);
    }
    
     
    function _addBalance() public payable returns (bool) {
        if (msg.value > 0){
            ownerUserBalance[msg.sender] = ownerUserBalance[msg.sender].add(msg.value);
            BanckBalance = BanckBalance.add(msg.value);
            return true;
        } 
        return false;
    }
    // withdraw balance of the user
    function _withdrawBalance(uint withdrawAmount) public  payable returns (bool) {
        // Check enough balance available, otherwise just return false
        if (withdrawAmount <= ownerUserBalance[msg.sender] && ownerUserBalance[msg.sender] > 0) {
            ownerUserBalance[msg.sender] = ownerUserBalance[msg.sender].sub(msg.value);
            BanckBalance = BanckBalance.sub(msg.value);
            return true;
        }
        return false;
    }

    // @return The balance of the user
    function _balance() public view returns (uint) {
        return ownerUserBalance[msg.sender];
    }

    // @return The balance of the Simple Bank contract
    function BankBalance() public view returns (uint) {
        return BanckBalance;
    }

    
}    
