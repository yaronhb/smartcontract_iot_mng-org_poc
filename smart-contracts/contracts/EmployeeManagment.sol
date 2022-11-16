// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.13;

import "./ITicketGranter.sol";
import "./IEndPoint.sol";
import "./IEmployee.sol";
import "./IEmployeeManagment.sol"; 

contract EmployeeManagment is IEmployeeManagment {
    address manager;
    modifier onlyManager {
        require(is_manager(msg.sender));
        _;
    }
    function is_manager(address id) public view returns (bool) {
        return id == address(manager);
    }

    struct EmployeeRecord {
        bool exists;

        bytes32 employee_id;
        address employee_address;
        IEmployee employee_obj;

        bool active;
    }
    EmployeeRecord[] records;
    mapping(bytes32 => uint) employee_ids;
    mapping(address => uint) employee_addrs;

    IEmployeeFactory factory;
    function set_factory(IEmployeeFactory factory_) public onlyManager {
        factory = factory_;
    }

    function new_employee(
        bytes32 employee_id,
        address employee_address,
        string memory name_
    )
    public onlyManager
    returns (IEmployee) {
        require(factory != IEmployeeFactory(address(0x0)), "No Factory");
        require(!records[employee_addrs[employee_address]].exists && !records[employee_ids[employee_id]].exists);

        IEmployeeFactory.ConstructingData memory data = IEmployeeFactory.ConstructingData({
            id: employee_id,
            name: name_,
            employee_addr: employee_address
        });
        IEmployee employee = factory.make(data);

        EmployeeRecord memory er = EmployeeRecord({
            exists: true,

            employee_id: employee_id,
            employee_address: employee_address,
            employee_obj:employee,

            active: true
        });
        records.push(er);

        employee_ids[employee_id] = records.length - 1;
        employee_addrs[employee_address] = records.length - 1;

        return employee;
    }

    constructor(address manager_) {
        manager = manager_;
        EmployeeRecord memory er;
        records.push(er);
    }

    function get_employeerec_address(address addr) private view returns(bool, EmployeeRecord storage) {
        EmployeeRecord storage er = records[employee_addrs[addr]];
        if (!er.exists || !er.active) {
            return (false, er);
        } else {
            return (true, er);
        }
    }

    function get_employee_address(address addr) public view override returns(bool, IEmployee) {
        (bool active, EmployeeRecord memory er) = get_employeerec_address(addr);
        if (!active) {
            return (false, IEmployee(address(0x0)));
        } else {
            return (true, er.employee_obj);
        }
    }

    function is_employee_active(address addr) public override returns(bool) {
        (bool active,) = get_employeerec_address(addr);
        return active;
    }
}