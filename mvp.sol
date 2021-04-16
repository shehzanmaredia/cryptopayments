pragma solidity ^0.7.6;

// Source for sending ETH to contract: https://www.youtube.com/watch?v=4k_ak3SFczc
// Source for sending ETH from smart contract to other address: https://www.youtube.com/watch?v=_Nvl-gz-tRs
// Source for mapping implementation: https://ethereum.stackexchange.com/questions/27510/solidity-list-contains

// Sample addresses for testing:
// 0x71C7656EC7ab88b098defB751B7401B5f6d8976F
// 0xbe63619e50B7707388aF43665D61a6A40C71413C
// 0xEB61Fa0BF3014E69472e2d9bE3016D551c58C207
// 0x905b63Fff465B9fFBF41DeA908CEb12478ec7601

contract Vend {
   
   // store on blockchain the creator of the contract and the designated user
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
    
    // adds money to wallet - check if you're the creator and that the amount sent is above the minimum
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
    
    
    //sends select amount of ether from contract to vendor - check if you're the designated user, the address is approved, and there's enough money
    function sendEther(address payable destination, uint amountInWei) external {
        if(msg.sender != user) {
            revert("Only the specific user can pay others");
        }

        if (approvedAddresses[destination] == false) {
            revert("This is not an approved address");
        }

        if (address(this).balance < amountInWei) {
            revert("Balance too low"); 
        }

        destination.transfer(amountInWei);
    }
    
}