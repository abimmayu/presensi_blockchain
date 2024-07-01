// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Presence {
    struct Present {
        uint256 time;
        uint256 nip;
    }

    mapping(uint256 => Present[]) objectPresent;
    uint256[] listOfPresent;

    // Input Present
    function inputPresent(uint256 presentTime, uint256 employee_nip) public {
        objectPresent[presentTime].push(Present(block.timestamp, employee_nip));
        listOfPresent.push(presentTime);
    }

    // Mengembalikan daftar waktu presensi
    function getPresentTimes() public view returns (uint256[] memory) {
        return listOfPresent;
    }

    // Mengembalikan presensi berdasarkan waktu tertentu
    function getPresentByTime(uint256 time) public view returns (Present[] memory) {
        return objectPresent[time];
    }

    // Mengembalikan presensi dalam bentuk paginated
    function getPaginatedPresents(uint256 startIndex, uint256 endIndex) public view returns (Present[] memory) {
        require(startIndex < endIndex, "Invalid indices");
        require(endIndex <= listOfPresent.length, "End index out of range");

        uint256 totalPresentsCount = 0;

        // Hitung jumlah total present dalam rentang
        for (uint256 i = startIndex; i < endIndex; i++) {
            totalPresentsCount += objectPresent[listOfPresent[i]].length;
        }

        // Buat array untuk menyimpan hasil paginated
        Present[] memory paginatedPresents = new Present[](totalPresentsCount);
        uint256 currentIndex = 0;

        // Isi array hasil paginated
        for (uint256 i = startIndex; i < endIndex; i++) {
            uint256 time = listOfPresent[i];
            Present[] memory presentsForTime = objectPresent[time];
            for (uint256 j = 0; j < presentsForTime.length; j++) {
                paginatedPresents[currentIndex] = presentsForTime[j];
                currentIndex++;
            }
        }

        return paginatedPresents;
    }
}
