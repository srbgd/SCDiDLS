pragma solidity 0.4.24;

contract EtherStore {
    uint256 public withdrawalLimit = 1 ether;

    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public depositTime;
    mapping(address => uint256) public balances;

    function depositFunds() public payable {
        balances[msg.sender] += msg.value;
        depositTime[msg.sender] = now;
    }
    
    function withdrawFunds (uint256 _weiToWithdraw) public {

        // second technique: ensure that all logic that changes state variables happens before ether is sent out of the contract

        // ensure min withdraw limit
        require(_weiToWithdraw > 0);
        // ensure max withdraw limit
        require(_weiToWithdraw <= withdrawalLimit);
        // ensure balance
        require(balances[msg.sender] >= _weiToWithdraw);
        // ensure withdraw allowed
        require(now > depositTime[msg.sender] + 1 weeks)
        // limit the time allowed to withdraw
        require(msg.sender.call.value(_weiToWithdraw)());
        // ensure no external call before
        require(lastWithdrawTime[msg.sender] == 0)

        // start transfer
        lastWithdrawTime[msg.sender] = now;
        // first technique: use the built-in transfer function
        msg.sender.transfer(balances[msg.sender]);
        balances[msg.sender] = 0;
    }
}