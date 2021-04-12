pragma solidity ^0.7.6;

// Source for sending ETH to contract: https://www.youtube.com/watch?v=4k_ak3SFczc
// Source for sending ETH to address: https://solidity-by-example.org/
// Source for mapping implementation: https://ethereum.stackexchange.com/questions/27510/solidity-list-contains



// Sample addresses for testing
// 0x71C7656EC7ab88b098defB751B7401B5f6d8976F
// 0xbe63619e50B7707388aF43665D61a6A40C71413C
// 0xEB61Fa0BF3014E69472e2d9bE3016D551c58C207
// 0x905b63Fff465B9fFBF41DeA908CEb12478ec7601
contract Vendify {
   // store on blockchain the creator of the contract (the parent) and the designated user (the child)
   address public creator;
   address public user;
   constructor(address addr) {
       creator = msg.sender; 
       user = addr;
    }
   
    // tracks approved vendors in a map
    mapping (address => bool) public approvedAddresses;
    
    // adds approved vendors by setting to true in map
    function addVendor(address payable addr) virtual public {
        if(msg.sender != creator) {
            revert("Only the creator can add Vendors");
        }
        approvedAddresses[addr] = true;
    }
    
    // adds money to wallet
    function addMoney() external payable {
        if(msg.sender != creator) {
            revert("Only the creator can add money");
        }
        if(msg.value < 1000) {
            revert("Too small, minimum amount is 1000 wei");
        }
    }

    // checks balance
    function checkBalance() external view returns(uint) {
        return address(this).balance;
    }
    
    // sends money, but checks if it is from user and to an approved address
    function sendViaCall(address payable _to) virtual public payable {
        // Call returns a boolean value indicating success or failure.
        // This is the current recommended method to use.
        
        if(msg.sender != user) {
            revert("Only the specific user can pay others");
        }
        
        if (approvedAddresses[_to] == false) {
            revert("This is not an approved address");
        }

        (bool sent, bytes memory data) = _to.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }
    
}