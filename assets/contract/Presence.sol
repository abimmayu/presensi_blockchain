// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Presence {
    struct Present {
        uint256 time;
        uint256 nip;
    }

    mapping(uint256 => Present[]) private objectPresent;
    uint256[] private listOfPresent;
    mapping(uint256 => bool) private presentTimeExists;

    function inputPresent(uint256 presentTime, uint256 employee_nip) public {
        if (!presentTimeExists[presentTime]) {
            presentTimeExists[presentTime] = true;
            listOfPresent.push(presentTime);
        }
        objectPresent[presentTime].push(Present(block.timestamp, employee_nip));
    }

    function getPresentTimes() public view returns (uint256[] memory) {
        return listOfPresent;
    }

    function getPresentByTime(
        uint256 time
    ) public view returns (Present[] memory) {
        return objectPresent[time];
    }

    function getPaginatedPresents(
        uint256 startIndex,
        uint256 endIndex
    ) public view returns (Present[] memory) {
        require(startIndex < endIndex, "Invalid indices");
        require(endIndex <= listOfPresent.length, "End index out of range");

        uint256 totalPresentsCount;
        for (uint256 i = startIndex; i < endIndex; i++) {
            totalPresentsCount += objectPresent[listOfPresent[i]].length;
        }

        Present[] memory paginatedPresents = new Present[](totalPresentsCount);
        uint256 currentIndex;

        for (uint256 i = startIndex; i < endIndex; i++) {
            uint256 time = listOfPresent[i];
            Present[] memory presentsForTime = objectPresent[time];
            for (uint256 j = 0; j < presentsForTime.length; j++) {
                paginatedPresents[currentIndex++] = presentsForTime[j];
            }
        }

        return paginatedPresents;
    }
}
