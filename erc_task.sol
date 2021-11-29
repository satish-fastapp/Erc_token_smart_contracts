pragma solidity >= 0.5.0 < 0.9.0;


import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";


contract NFTMarketDemo is Ownable, ERC20{
    
    using SafeMath for uint; 
  string constant tokenName = "FASTAPP";
  string constant tokenSymbol = "FAT";
  uint public timeInOneYearFromNow;
  uint public OneYearMintValue;
  mapping(address => uint) public balances;
  mapping(address => uint) public lockTime;
  
    
    constructor() public ERC20(tokenName, tokenSymbol) {}
  
   function mintValueschedule(uint256 mintvalue, uint256 time) public{
      timeInOneYearFromNow = time;
      OneYearMintValue = mintvalue;
  }
  
  function mint(address account, uint256 amount) public onlyOwner {
        require(amount > 0, "Amount has to be greater than 0");
        if(block.timestamp > timeInOneYearFromNow){
            _mint(account, OneYearMintValue);
            timeInOneYearFromNow += 365 days;
        }
        else{
        _mint(account, amount);
        }
    }
    
    function burn(address account, uint256 amount) public onlyOwner {
        require(block.timestamp > timeInOneYearFromNow, "You Can't burn");
        if(block.timestamp > timeInOneYearFromNow){
            _burn(account, amount);
             timeInOneYearFromNow += 90 days;
        }
    }
    
    function deposit(uint256 amount) external payable {

        balances[msg.sender] +=amount;
        lockTime[msg.sender] = block.timestamp + 1 weeks;

    }
    
    
    function increaseLockTime(uint _secondsToIncrease) public {

         lockTime[msg.sender] = lockTime[msg.sender].add(_secondsToIncrease);

    }
    
    function withdraw(uint256 _amount) public {

        require(_amount > 0, "insufficient funds");
        require(block.timestamp > lockTime[msg.sender], "lock time has not expired");
        uint amount = _amount;
        balances[msg.sender] = 0;
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send ether");

    }

}
