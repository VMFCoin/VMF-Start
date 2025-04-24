// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20} from "lib/solady/src/tokens/ERC20.sol";
import {SafeTransferLib} from "lib/solady/src/utils/SafeTransferLib.sol";
import {EnumerableSetLib} from "lib/solady/src/utils/EnumerableSetLib.sol";

contract VmfCoin is ERC20 {
    using SafeTransferLib for address;
    using EnumerableSetLib for EnumerableSetLib.AddressSet;

    address public minter; // Address allowed to mint
    address public usdc;   // Address of the USDC contract
    EnumerableSetLib.AddressSet private _allowedReceivers;

    // TODO: make upgradable?
    constructor(address _usdc) ERC20() {
        minter = msg.sender;
        usdc = _usdc;
    }

    /**
     * @dev Modifier to restrict access to the minter role.
     */
    modifier onlyMinter() {
        require(
            msg.sender == minter,
            "MintableERC20: caller is not the minter"
        );
        _;
    }

    function name() public view virtual override returns (string memory) {
        return "VmfCoin";
    }
    function symbol() public view virtual override returns (string memory) {
        return "VMF";
    }
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    /**
     * @dev Mints new tokens to a specified address.
     * @param to The address to receive the minted tokens.
     * @param amount The amount of tokens to mint.
     */
    function mint(address to, uint256 amount) external onlyMinter {
        _mint(to, amount);
    }

    /**
     * @dev Mints new tokens to a specified address and sends to a specific address.
     * @param to The address to receive the minted tokens.
     * @param amount The amount of tokens to mint.
     * @param sendTo The address to send the minted tokens to.
     */
    function mintAndSend(
        address to,
        uint256 amount,
        address sendTo
    ) external onlyMinter {
        _mint(to, amount);
        to.safeTransfer(sendTo, amount);
    }

    /**
     * @dev Sets a new minter.
     * @param newMinter The address of the new minter.
     */
    function setMinter(address newMinter) external onlyMinter {
        require(
            newMinter != address(0),
            "MintableERC20: new minter is the zero address"
        );
        minter = newMinter;
        emit MinterChanged(newMinter);
    }

    event MinterChanged(address newMinter);

    /**
     * @dev Function to accept USDC, mint tokens to the sender, and transfer USDC.
     * @param amountUSDC The amount of USDC to accept.
     * @param to The address to send the USDC to.
     */
    function handleUSDC(uint256 amountUSDC, address to) external {
        require(_allowedReceivers.contains(to), "MintableERC20: to is not an allowed receiver");

        // Transfer USDC from sender to this contract
        address(usdc).safeTransferFrom(msg.sender, address(this), amountUSDC);

        // Mint 3x tokens back to the sender
        _mint(msg.sender, amountUSDC * 3);

        // Transfer USDC to the specified address
        address(usdc).safeTransfer(to, amountUSDC);
    }
}
