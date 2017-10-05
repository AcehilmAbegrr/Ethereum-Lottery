pragma solidity ^0.4.0;

/// This is so we can set the price in USD constants
contract USDOracle {
    function WEI() constant returns (uint);
    function USD() constant returns (uint);
}
contract Lottery{
    
    address owner;
    uint public creationTime = now;
    
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

    function currentRate() constant returns (uint ratePerDollar) {
        ratePerDollar = USD_IN_CENTS * oracle.WEI();
        return ratePerDollar;
    }
    
    function buyTicket (uint _numberGuessed,
    string _firstName, string _lastName) payable returns (string) {
        
        
        //if (msg.value != USD_IN_CENTS * oracle.WEI()) throw;
        
        var entry = entries[msg.sender];
        
        entry.firstName = _firstName;
        entry.lastName = _lastName;
        entry.numberGuessed = _numberGuessed;
        
        
        return ("You have entered into the lottery");
        
    }
    
    function getTicket () constant returns (string, string, uint) {
        var entry = entries[msg.sender];
        return (entry.firstName, entry.lastName, entry.numberGuessed);
    }
    
    
}
