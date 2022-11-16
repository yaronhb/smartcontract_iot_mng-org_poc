// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.13;

import "./IEmployee.sol";

interface IEmployeeManagment {
    function is_manager(address id) external view returns (bool);
    function is_employee_active(address addr) external returns(bool);

    function get_employee_address(address addr) external view returns(bool, IEmployee);
}