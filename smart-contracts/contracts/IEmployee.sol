// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.13;

interface IEmployee {
    function employee_id() external view returns (bytes32);
    function employee_name() external view returns (string memory);
    function employee_address() external view returns (address);
}

interface IEmployeeFactory {
    struct ConstructingData {
        bytes32 id;
        string name;
        address employee_addr;
    }

    function make(ConstructingData memory data) external returns (IEmployee);
}