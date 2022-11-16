// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.13;

import "./Ticket.sol";
import "./IEndPoint.sol";

interface ITicketGranter {
    event TicketIssued(Ticket ticket);
    event TicketRejected(Ticket ticket);

    function CreateTicket(IEndPoint endpoint, string calldata data) external returns(bool);
}