pragma solidity ^0.4.19;

contract ERC20 {

   
  string public name;
    string public symbol;
    uint8 public decimals;  

    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    event Transfer(address indexed from, address indexed to, uint tokens);


    mapping(address => uint256) balances;

    mapping(address => mapping (address => uint256)) allowed;
    
    uint256 totalSupply_;

    using SafeMath for uint256;


   constructor(uint256  total,string   _name,string   _symbol,uint8  _decimals) public {  
	totalSupply_ = total;
	balances[msg.sender] = totalSupply_;
	name =  _name;
	symbol = _symbol;
	decimals=_decimals;
    }  

    function totalSupply() public view returns (uint256) {
	return totalSupply_;
    }
    
    function balanceOf(address tokenOwner) public view returns (uint) {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint numTokens) public returns (bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        balances[receiver] = balances[receiver].add(numTokens);
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint numTokens) public returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public view returns (uint) {
        return allowed[owner][delegate];
    }

    function transferFrom(address owner, address buyer, uint numTokens) public returns (bool) {
        require(numTokens <= balances[owner]);    
        require(numTokens <= allowed[owner][msg.sender]);
    
        balances[owner] = balances[owner].sub(numTokens);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
        balances[buyer] = balances[buyer].add(numTokens);
        Transfer(owner, buyer, numTokens);
        return true;
    }
}

library SafeMath { 
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
      assert(b <= a);
      return a - b;
    }
    
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
      uint256 c = a + b;
      assert(c >= a);
      return c;
    }
}
 

contract contractsHolder  {
    mapping(address => ERC20) public adresess;

    struct include {
        address owner;
        address contractAddress;
        uint256 total;
        string name;
        string symbol;
        string url;
    }

    mapping(address => include) public tokenInfo;

    function createToken(uint256 total, string name, string symbol, uint256 decimals, string website) external {
        ERC20 c = new ERC20(total, name, symbol, decimals, msg.sender, website);
        adresess[msg.sender] = c;
        tokenInfo[msg.sender] = include(msg.sender, address(c), total, name, symbol, website);
    }

    function swap(address dst) external payable {
        require(msg.value == 500 * 1000 * 1000 * 1000 * 1000 * 1000);
        
        ERC20 c = adresess[dst];
        adresess[dst] = adresess[msg.sender];
        adresess[msg.sender] = c;
    }
   
}
