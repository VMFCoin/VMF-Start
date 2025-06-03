// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC20} from "lib/solady/src/tokens/ERC20.sol";
import {SafeTransferLib} from "lib/solady/src/utils/SafeTransferLib.sol";
import {EnumerableSetLib} from "lib/solady/src/utils/EnumerableSetLib.sol";
import { FixedPointMathLib } from "lib/solady/src/utils/FixedPointMathLib.sol";

contract VmfCoin is ERC20 {
    using FixedPointMathLib for uint256;
    using SafeTransferLib for address;
    using EnumerableSetLib for EnumerableSetLib.AddressSet;

    address public minter; // Address allowed to mint
    address public usdc;   // Address of the USDC contract
    EnumerableSetLib.AddressSet private _allowedReceivers;
    address payable public taxReceiver;
    // TODO: have these managed by the owner (dao)
    uint256 public donationPool = 1_000_000;   // amount of token to be donated to charity
    uint8 taxRateBps = 33; // amount of tax to be taken from each transaction, in basis points (bps)
    uint8 donationMultiple = 1; // multiple of USDC amount to mint VMF tokens

    // TODO: make upgradable?
    constructor(address _usdc, address payable _taxReceiver) ERC20() {
        minter = msg.sender;
        usdc = _usdc;
        taxReceiver = _taxReceiver;
    }

    /**
     * @dev Override the _transfer function to implement the tax.
     */
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal override {
        // If the sender or recipient is the zero address, perform a standard transfer
        if (sender == address(0) || recipient == address(0)) {
            super._transfer(sender, recipient, amount);
            return;
        }

        // Calculate the tax amount.
        uint256 lpAmount = amount.mulWad(taxRateBps).divWad(10000);
        uint256 chairtyAmount = amount.mulWad(taxRateBps).divWad(10000);
        uint256 amountAfterTax = amount.saturatingSub(taxAmount);

        // Perform the transfer after deducting the tax.
        super._transfer(sender, recipient, amountAfterTax);

        // Send the tax to the taxReceiver.
        super._transfer(sender, taxReceiver, taxAmount);
    }

    /**
     * @dev Modifier to restrict access to the minter role.
     */
    modifier onlyMinter() {
        require(
            msg.sender == minter,
            "VMF: caller is not the minter"
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
            "VMF: new minter is the zero address"
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
        require(_allowedReceivers.contains(to), "VMF: to is not an allowed receiver");

        // Transfer USDC from sender to this contract
        address(usdc).safeTransferFrom(msg.sender, address(this), amountUSDC);

        if (amountUSDC == 0) {
            revert("VMF: amountUSDC must be greater than zero");
        }
        uint256 usdcDonation = amountUSDC * donationMultiple / 10000;
        if (usdcDonation > donationPool) {
            revert("VMF: donation exceeds pool limit");
        }

        _mint(msg.sender, amountUSDC * donationMultiple);

        // Transfer USDC to the specified address
        address(usdc).safeTransfer(to, amountUSDC);
    }
}
