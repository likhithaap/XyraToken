// SPDX-License-Identifier: MIT
pragma solidity^0.8.17;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";


contract Xyra is ERC20Capped, ERC20Burnable{

    address public owner= msg.sender ;
    uint256 public blockReward;
    constructor(uint256 cap, uint256 reward) ERC20 ("Xyra", "XYA") ERC20Capped(cap* (10 **decimals())) {
        _mint(owner, 7000000 * (10**decimals()));
        blockReward = reward * (10 ** decimals());
    }

    function _mint(address account, uint256 amount) internal virtual override(ERC20Capped, ERC20) {
        require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
        super._mint(account, amount);
    }

    modifier onlyOwner{
        require(owner == msg.sender, "Only the owner can call this function");
        _;
    }

    function setBlockReward(uint256 reward) public onlyOwner {
        blockReward = reward * (10 ** decimals());
    }

    function mintMinerReward() internal{
        _mint(block.coinbase, blockReward);
    }

    function _beforeTokenTransfer(address from, address to, uint256 value) internal virtual override{
        if(from!=address(0)&& (to!=block.coinbase) &&(block.coinbase!=address(0))){
            mintMinerReward();
        }
        super._beforeTokenTransfer(from, to, value);

    }


}