pragma solidity ^0.4.0;

/// This is so we can set the price in USD constants
contract USDOracle {
    function WEI() constant returns (uint);
    function USD() constant returns (uint);
}
contract Lottery{
    
    address owner;
    uint private numPlayers = 0;
    uint creationTime = now;
    uint jackPot = 0;
    uint charityFee;
    
    USDOracle oracle = USDOracle(0x1c68f4f35ac5239650333d291e6ce7f841149937);
    uint constant USD_IN_CENTS = 100;
    
    
    mapping (address => Entry) entries;
    
    struct Entry {
        string firstName;
        string lastName;
        uint numberGuessed;
    }
    
    
    function Lottery () payable {
        owner = msg.sender;
    }
    
    modifier ifOwner {
        if (msg.sender != owner)
            throw;
        _;
    }
    
    modifier endPlay {
        if (creationTime + now == 7 days){
            _;
        }
        throw;
    }

    event Log(string message, address caller);

    function currentRate() constant returns (uint ratePerDollar) {
        ratePerDollar = USD_IN_CENTS * oracle.WEI();
        return ratePerDollar;
    }
    
    function buyTicket (uint _numberGuessed,
    string _firstName, string _lastName) payable {
        
        
        //if (msg.value != USD_IN_CENTS * oracle.WEI()) throw;
        
        var entry = entries[msg.sender];
        
        entry.firstName = _firstName;
        entry.lastName = _lastName;
        entry.numberGuessed = _numberGuessed;
        numPlayers++;
        jackPot += msg.value;
        
        Log("You have entered in to the lottery", msg.sender);
        
    }
    
    function getTicket () constant returns (string, string, uint) {
        var entry = entries[msg.sender];
        return (entry.firstName, entry.lastName, entry.numberGuessed);
    }
    
    /// Pick a winner for small lotteries put winnings in entry's address
    function pickSmallWinner () ifOwner endPlay {
        //Oracilize a "random" number
        if (numPlayers < 100){
            // pick the winner
            uint randomNum = 0;
            uint winner = randomNum % numPlayers; // Gets the index of the winner
            
            // subtract 2% charity fee from jackPot
            charityFee = (jackPot * 2) / 100;
            jackPot -= charityFee;
            //entries[winner].transfer(jackPot);
            
        }
        
    }
    
    /// Pick a winner for a big lottery (over 100 participants) put earnings into winners address
    function pickBigWinner () ifOwner endPlay {
        // Oraclize a "random" number
        uint randomNum = 0; //change this to the random function
        // For small lotteries, we will just pick a random player
        
        
        if (numPlayers > 100){
            // pick the winner
            
            
            // subtract 2% charity fee from jackPot
            charityFee = (jackPot * 2) / 100;
            jackPot -= charityFee;
    
        }        
    }
    
    /// Allow winner to withrawl their earnings
    function withdrawlWinnings () {
        
    }
    
    
}
