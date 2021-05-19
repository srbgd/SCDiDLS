pragma solidity ^0.4.19;

contract InnoCoin {

    string public constant name = "InnoCoin";
    string public constant symbol = "INC";
    uint8 public constant decimals = 18;  
 

    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    event Transfer(address indexed from, address indexed to, uint tokens);


    mapping(address => uint256) balances;

    mapping(address => mapping (address => uint256)) allowed;
    
    uint256 totalSupply_ = 10 * 1000 * 1000;

    using SafeMath for uint256;

    address owner;

   constructor(uint256 total) public {  
	totalSupply_ = total;
	balances[msg.sender] = totalSupply_;
    owner = msg.sender;
    }  

    function totalSupply() public view returns (uint256) {
	return totalSupply_;
    }
    
    function balanceOf(address tokenOwner) public view returns (uint) {
        require(tokenOwner == owner);
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
        emit Approval(msg.sender, delegate, numTokens);
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
        emit Transfer(owner, buyer, numTokens);
        return true;
    }

    function buy(uint256 amount) external {
        require(balanceOf(owner) >= amount);
        require(msg.value == amount * 100 * 1000 * 1000 * 1000 * 1000);
        
        transferFrom(owner, msg.sender, amount);
    }

    function sell(uint256 amount) external {
        require(balances[msg.sender] >= amount);
        require(balanceOf(owner) >= amount * 90 * 1000 * 1000 * 1000 * 1000);

        transferFrom(msg.sender, owner, amount);
        msg.sender.transfer(amount * 90 * 1000 * 1000 * 1000 * 1000);
    }

    function withdraw(address dst, uint256 amount) external {
        require(msg.sender == owner);
        require(balanceOf(owner) >= amount);
        
        dst.transfer(amount);
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