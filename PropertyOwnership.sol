pragma solidity >=0.7.0 <0.9.0;

contract PropertyOwnership {

    address public owner;
    bool[] public deposits;
    address[] public depositsOwners;
    uint weekPrice;

    uint weekStart;
    uint weekEnd;

    constructor (uint price) {
        owner = msg.sender;
        deposits = new bool[](52);
        depositsOwners = new address[](52);
        weekPrice = price;

        weekStart = 0;
        weekEnd = 52;
    }

    function buyOwnership(uint week) public payable{
        require(msg.value > 0, "Send some money at least");
        require(msg.value == weekPrice, "Money must equal price = ");
        require(week <= 52, "week must be <= 52");
        require(week >= weekStart, "week must be more than weekStart");
        require(week <= weekEnd, "week must be less than weekEnd");
        require(deposits[week] == false, "this week if not free");
 
        deposits[week] = true;     
        depositsOwners[week] = msg.sender;  
    }


    function cancelOwnership(uint week) public restricted{
        require(week <= 52, "week must be <= 52");
        require(depositsOwners[week] == msg.sender, "this week is not yours");

        deposits[week] = false;    
        payable(msg.sender).transfer(weekPrice);    
    }

    function changeWeeksAvailible(uint weekStarti, uint weekEndi) public restricted{
        require(weekStarti <= 52, "weekStart must be <= 52");
        require(weekEndi <= 52, "weekEnd must be <= 52");
  
        weekStart = weekStarti;
        weekEnd = weekEndi;
    }

    modifier restricted(){
        require(msg.sender == owner);
        _;

    }
}
