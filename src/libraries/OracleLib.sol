// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

/**
 * @title OracleLib
 * @author Dominick L
 * @notice This library is used to check the ChainLink Oracle for stale data.
 * If a price is stale, the function will revert, and render the DSCEngine unusable - This is by design
 *
 *
 * We want the DSCEngine to freeze if the prices become stale.
 *
 * So if the Chainlink network explodes and you have alot of money locked in the protocol.
 */

library OracleLib {
    error OracleLib_StalePrice();

    uint256 private constant TIMEOUT = 3 hours;

    function staleCheckLatestRoundData(AggregatorV3Interface priceFeed)
        public
        view
        returns (uint80, int256, uint256, uint256, uint80)
    {
        (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound) =
            priceFeed.latestRoundData();

        uint256 secondsSince = block.timestamp - updatedAt;
        if (secondsSince > TIMEOUT) revert OracleLib_StalePrice();

        return (roundId, answer, startedAt, updatedAt, answeredInRound);
    }
}
