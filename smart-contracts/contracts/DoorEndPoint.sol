// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.13;

import "./Ticket.sol";
import "./IEndPoint.sol";
import "./ITicketGranter.sol";

import "./EndPointBase.sol";
import "./IEmployeeManagment.sol";

contract DoorEndPoint is IEndPoint, ITicketGranter, EndPointEncryptedSecretData {

    IEmployeeManagment managment;

    constructor(bytes32 _endpoint_id, IEmployeeManagment _managment, uint64 _validity_length, string memory _publickey) 
        EndPointBase(_endpoint_id) EndPointEncryptedSecretData(_validity_length, _publickey) {
        managment = _managment;
    }
    
    function CreateTicket(IEndPoint endpoint, string calldata data) external override returns(bool) {
        require(this == endpoint, "Incorrect endpoint");

        (bool active, IEmployee e) = managment.get_employee_address(msg.sender);
        // require(active, "Employee not active");
        if (!active) {
            return false;
        }

        Ticket memory ticket = Ticket({
             timestamp: block.timestamp,
             endpoint_id : endpoint.endpoint_id(),
             employee_id: e.employee_id(),

             validity_length: validity_length,
             data: data
        });

        bool valid = validate_ticket(ticket);
        if (!valid) {
            return false;
        }
        
        emit TicketIssued(ticket);
        return true;
    }
}