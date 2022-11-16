// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.13;

import "./IEndPoint.sol";

// solregex --name CertRegex '-----BEGIN CERTIFICATE-----[ \n]*[A-Za-z0-9\+/]+[ \n]*-----END CERTIFICATE-----[ \n]*' > CertRegex.sol
//import "./CertRegex.sol";

abstract contract EndPointBase is IEndPoint {

    //uint256 public lastTicket;

    constructor(bytes32 endpoint_id_) {
        _endpoint_id = endpoint_id_;
        //lastTicket = 0;
    }

    bytes32 _endpoint_id;
    function endpoint_id() public view override returns (bytes32) { return _endpoint_id; }

    function validate_ticket(Ticket memory ticket) public view override returns (bool) {
        if (ticket.endpoint_id != endpoint_id()) {
            return false;
        }
        return validate_ticket_extra(ticket);
    }

    function validate_ticket_extra(Ticket memory ticket) internal view virtual returns (bool);
}

abstract contract EndPointCertData is EndPointBase {

    uint64 public validity_length;

    constructor(uint64 _validity_length) {
        validity_length = _validity_length;
    }

    function validate_ticket_extra(Ticket memory ticket) internal view override returns (bool) {
        if (ticket.validity_length != validity_length) {
            return false;
        }
        // string memory cert = ticket.data;
        // return CertRegex.matches(cert);
        return true;
    }
}

abstract contract EndPointEncryptedSecretData is EndPointBase {

    uint64 public validity_length;
    string public publicKey; 

    constructor(uint64 _validity_length, string memory _publicKey) {
        validity_length = _validity_length;
        publicKey = _publicKey;
    }

    function validate_ticket_extra(Ticket memory ticket) internal view override returns (bool) {
        if (ticket.validity_length != validity_length) {
            return false;
        }
        // string memory cert = ticket.data;
        // return CertRegex.matches(cert);
        return true;
    }
}

