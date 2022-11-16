// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";

interface DeviceController {
    struct DeviceConfig {
        bool on;
    }
    event DeviceConfigChange(bytes4 device_id, DeviceConfig cnf);
}

abstract contract LightsController is DeviceController, Ownable {
    bytes4[] lights;
    uint256 duration;
    uint256 iterationCount; 

    bool lastState;

    constructor(bytes4[] memory lights_, uint256 duration_){
        lights = lights_;
        duration = duration_;
        lastState = true;
        iterationCount = 0;
    }

    function _beginIteration(uint256 _iterationCount) internal virtual;
    function _endIteration(uint256 _iterationCount) internal virtual;
    function _shouldChangeConfig(bytes4 _light_id) 
        internal virtual 
        returns (bool, DeviceConfig memory);
    
    function doIteration() public onlyOwner {
        _beginIteration(iterationCount);
        for (uint256 i = 0; i < lights.length; i++) {
            bytes4 light_id = lights[i];
            (bool shouldChange, DeviceConfig memory cnf) = _shouldChangeConfig(light_id);
            if (shouldChange) {
                emit DeviceConfigChange(light_id, cnf);
            }
        }
        _endIteration(iterationCount);
        iterationCount++;
    }
}

// contract MyLightsController2{
//     struct DeviceConfig {
//         bool on;
//     }
//     event DeviceConfigChange(bytes4 device_id, DeviceConfig cnf);
//     bytes4[] lights;
//     uint256 duration;
//     uint256 iterationCount; 

//     bool lastState;

//     uint i;
//     uint n;

//     constructor(bytes4[] memory lights_, uint256 duration_){
//         lights = lights_;
//         duration = duration_;
//         lastState = true;
//         iterationCount = 0;
//         i = 0;
//         n = lights.length;
//         first = true;
//     }

//     bool first;
//     function _beginIteration(uint256 _iterationCount) internal  {}
//     function _endIteration(uint256 _iterationCount) internal {
//         if(first) {
//             first = false;
//         } else {
//             i++;
//             i = i % n;
//             if (i == 0) {
//                 first = true;
//             }
//         }
//     }
//     function _shouldChangeConfig(bytes4 light_id) internal  
//     returns (bool, DeviceConfig memory) {
//         bool change = true;
//         DeviceConfig memory cnf;
//         if (first || light_id == lights[i]) {
//             cnf.on = true;
//         } else {
//             cnf.on = false;
//         }
//         return (change, cnf);
//     }
    
//     function doIteration() public {
//         _beginIteration(iterationCount);
//         for (uint256 i = 0; i < lights.length; i++) {
//             bytes4 light_id = lights[i];
//             (bool shouldChange, ) = _shouldChangeConfig(light_id);
//             if (shouldChange) {
//                 //emit DeviceConfigChange(light_id, cnf);
//             }
//         }
//         _endIteration(iterationCount);
//         iterationCount++;
//     }
// }

contract MyLightsController is LightsController {
    uint i;
    uint n; 
    constructor(bytes4[] memory lights_, uint256 duration_)
        LightsController(lights_, duration_) {
        i = 0;
        n = lights.length;
        first = true;
    }

    bool first;
    function _beginIteration(uint256 _iterationCount) internal override {}
    function _endIteration(uint256 _iterationCount) internal override {
        if(first) {
            first = false;
        } else {
            i++;
            i = i % n;
            if (i == 0) {
                first = true;
            }
        }
    }
    function _shouldChangeConfig(bytes4 light_id) internal override 
    returns (bool, DeviceConfig memory) {
        bool change = true;
        DeviceConfig memory cnf;
        if (first || light_id == lights[i]) {
            cnf.on = true;
        } else {
            cnf.on = false;
        }
        return (change, cnf);
    }
}