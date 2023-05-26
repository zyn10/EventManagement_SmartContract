//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract EventContract{
    struct Event{
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint ticketRemain;
        address organizer;
    }

    mapping (uint=>Event) public events;//---> for multiple events
    mapping (address=>mapping (uint=>uint)) public tickets;
    uint public nextId;


    function createEvent(string memory name, uint date,uint price,uint ticketCount) external {
        require(date>block.timestamp,"You can organize event in future");
        require(ticketCount>0,"You can organize only if you create more than 0 tickets");
        events[nextId] = Event(name,date,price,ticketCount,ticketCount,msg.sender);
        nextId++;
        //1716697967
    }

   function buyTicket(uint id ,uint quantity) external payable  {
       require(events[id].date!=0,"This event doesnot exist");
       require(events[id].date > block.timestamp,"Event already occured");
       Event storage _event =events[id];
       require(msg.value==(_event.price*quantity),"Ether is not enough");
       _event.ticketRemain-=quantity;
       //2d Array
        tickets[msg.sender][id]+=quantity;
   }

   function transferTicket(uint id,uint quantity,address to) external{
        require(events[id].date!=0,"This event doesnot exist");
        require(events[id].date > block.timestamp,"Event already occured");
        require(tickets[msg.sender][id]>=quantity,"You do not have the tickets");

        tickets[msg.sender][id]-= quantity;
        tickets[to][id]+=quantity;
   }

}
