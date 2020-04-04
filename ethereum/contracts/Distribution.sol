pragma solidity ^0.4.25;

contract Distribution{
    struct Player{
        uint playerType;
        address playerAddress;
        uint inStock;
        uint inPipeline;
        uint backlog;
        uint cummulativeCost;
    }

    uint public week;
    uint public delay;
    address public downstreamPlayerAddress;
    address public upstreamPlayerAddress;
    Player public downstreamPlayer;
    Player public upstreamPlayer;
    mapping(uint => uint) public downstreamOrders;
    mapping(uint => uint) public upstreamFulfillments;

//Contract initialization with the week number and the existing delay in weeks
    constructor (uint weekNumber, uint delayInWeeks) public{
        require(weekNumber > 0);
        require(delayInWeeks > 0);
        week = weekNumber;
        delay = delayInWeeks;
    }

    function getWeekValue() public view returns (uint){
      return week;
    }

    function getDelayValue() public view returns (uint){
      return delay;
    }
//This is an additional check to restrict downstream player from restricting as upstream player as well
    modifier restrictUpstreamPlayer(){
        if(downstreamPlayerAddress != 0){
            require(msg.sender == downstreamPlayerAddress);
        }
        require(msg.sender  != upstreamPlayerAddress);
        _;
    }
//This is an additional check to restrict upstream player from restricting as downstream player as well
    modifier restrictDownstreamPlayer(){
         if(upstreamPlayerAddress != 0){
            require(msg.sender == upstreamPlayerAddress);
        }
        require(msg.sender != downstreamPlayerAddress);
        _;
    }
// This function is used to register a user as an upstream player
    function registerAsUpstreamPlayer(uint inStock) public restrictDownstreamPlayer{
        Player memory definedPlayer = Player({
           playerType:  2,
           playerAddress: msg.sender,
           inStock: inStock,
           inPipeline: 0,
           backlog: 0,
           cummulativeCost:0
        });

         upstreamPlayer = definedPlayer;
         upstreamPlayerAddress = msg.sender;
    }

    // This function is used to register a user as a downstream player
     function registerAsDownstreamPlayer(uint inStock) public restrictUpstreamPlayer{
        Player memory definedPlayer = Player({
           playerType:  1,
           playerAddress: msg.sender,
           inStock: inStock,
           inPipeline: 0,
           backlog: 0,
           cummulativeCost:0
        });
        downstreamPlayer = definedPlayer;
        downstreamPlayerAddress = msg.sender;
    }

// This function is used to place orders
    function placeOrders(uint currentWeek, uint orderQuanity) public {
        if(week != currentWeek){
            week = currentWeek;
        }
        downstreamOrders[currentWeek] = orderQuanity;
        updatePipeline(orderQuanity);
    }

    // This function is used to update pipeline
    function updatePipeline(uint pipelineQuanity ) public{
       uint alreadyInPipeline= downstreamPlayer.inPipeline;
       uint newPipeline = alreadyInPipeline + pipelineQuanity;
       downstreamPlayer.inPipeline = newPipeline;
    }

// This function is used to full fill orders for the current week by the upstream player
    function fulfillOrders (uint currentWeek) public{
        uint orderweek = currentWeek - delay;
       upstreamFulfillments[week] = downstreamOrders[orderweek];

    }

// This function is used to update the backlog for the downstream player
    function updateBacklog(uint backlogOrders) public{
        downstreamPlayer.backlog = backlogOrders;
    }

//This function is used by downstream player to move to the next week
    function incrementToNextWeek() public{
        week = week + 1;
    }

    //This function is used to update the cummulative cost for each player
    function updateCummulativeCost(uint cummCost, uint playerType ) public{
      if(playerType == 1){
          downstreamPlayer.cummulativeCost = cummCost;
      }
      if(playerType == 2){
          upstreamPlayer.cummulativeCost = cummCost;
      }

    }
  }
