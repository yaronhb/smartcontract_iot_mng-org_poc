// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.13;

import "./Ticket.sol";

interface IEndPoint {
    function endpoint_id() external view returns (bytes32);
    
    function validate_ticket(Ticket memory ticket) external view returns (bool);
}