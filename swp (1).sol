// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface tkA {
    function getTokenPrice() external view returns (uint256);
}

interface EtherPriceInterface {
    function getEtherPriceInUSD() external view returns (uint256);
}

contract Swap {
    
    uint256 public conversionRate = 80; // Make it public to view the rate

    function setConversionRate(address tkAAddress, address etherPriceInterfaceAddress) public {
        tkA priceOfGold = tkA(tkAAddress);
        EtherPriceInterface priceOfUsdt = EtherPriceInterface(etherPriceInterfaceAddress);

        uint256 goldPrice = priceOfGold.getTokenPrice();
        uint256 usdtPrice = priceOfUsdt.getEtherPriceInUSD();

        conversionRate = (goldPrice * 100) / usdtPrice;
    }

    function swapTokensGoldToUSDT(
        address _tokenIn,
        address _tokenOut,
        uint256 _amountIn
    ) external {
        IERC20(_tokenIn).transferFrom(msg.sender, address(this), _amountIn * 10**6);

        uint256 amountOut = (_amountIn * conversionRate) / 100;

        IERC20(_tokenOut).transfer(msg.sender, amountOut * 10**6);
    }


    function swapUSDTToGold( address Gold, address Usdt, uint256 tokenIn ) external {
        IERC20(Usdt).transferFrom(msg.sender, address(this), tokenIn*10**6);
        
        uint256 amountOut = (tokenIn * 100) / conversionRate;

        IERC20(Gold).transfer(msg.sender, amountOut*10**6);
    }

}