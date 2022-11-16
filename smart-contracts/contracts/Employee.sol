// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.13;

import "./IEmployee.sol";
import "./IEmployeeManagment.sol";

contract Empolyee is IEmployee {

    bytes32 _employee_id;
    function employee_id() public view override returns (bytes32) { return _employee_id;}

    address _employee_addr;
    function employee_address() public view override returns (address) { return _employee_addr; }
    modifier onlyEmployee {
        require(msg.sender == _employee_addr);
        _;
    }

    string _employee_name;
    function employee_name() public view override returns (string memory) { return _employee_name; }

    IEmployeeManagment manager;
    modifier onlyManager {
        require(msg.sender == address(manager) || manager.is_manager(msg.sender));
        _;
    }

    constructor(address employee_addr_, bytes32 employee_id_, string memory employee_name_, IEmployeeManagment manager_) {
        _employee_addr = employee_addr_;
        _employee_id = employee_id_;
        _employee_name = employee_name_;
        manager = manager_;
    }

   
}

contract EmpolyeeFactory is IEmployeeFactory {
    IEmployeeManagment manager;

    constructor(IEmployeeManagment manager_) {
        manager = manager_;
    }

    function make(ConstructingData memory data) external override returns (IEmployee) {
        IEmployee employee = new Empolyee(
            data.employee_addr,
            data.id,
            data.name,
            manager
        );
        return employee;
    }
}