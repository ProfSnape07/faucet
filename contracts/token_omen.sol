// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract OMEN is ERC20 {
    using SafeMath for uint256;

    address private _owner;

    constructor(address owner) ERC20("OMEN", "OMEN") {
        uint256 initialSupply = 100000000 * (10 ** uint256(decimals()));
        _mint(owner, initialSupply);
        _owner = owner;
    }

    function mint(uint256 amount) public {
        require(msg.sender == _owner, "Only the contract owner can perform this action");
        _mint(msg.sender, amount);
    }

    function destroySmartContract(address payable _to) public {
        require(msg.sender == _owner, "Only the contract owner can perform this action");
        selfdestruct(_to);
    }

    modifier onlyOwner() {
        require(msg.sender == _owner, "Only the contract owner can perform this action");
        _;
    }

    fallback() external payable {
        revert("This contract does not support Ether transfers");
    }

    receive() external payable {
        revert("This contract does not support Ether transfers");
    }
}
