// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.13;

struct Ticket {
    // uint256 random;
    uint timestamp;
    
    bytes32 endpoint_id;
    bytes32 employee_id;

    uint64 validity_length;

    string data;
}