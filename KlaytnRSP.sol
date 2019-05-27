// Klaytn IDE uses solidity 0.4.24 version.
pragma solidity 0.4.24;

contract rsp {

    
    uint rock = 0;
    uint scissors = 1;
    uint paper = 2;
    

    mapping (address => string) public result;

    

function rsp_play(uint input) public returns(string)
{
    require((input<3)&&(0<=input));
    
    uint random = uint(keccak256(now,msg.sender,input))%3;

    if(input==random)
    {
       result[msg.sender]="darw";
       return result[msg.sender];
    }
    else if(input==rock)
    {
        if(random==scissors)
        {
            result[msg.sender]="win";
            return result[msg.sender];
        }
        else if(random ==paper)
        {
            result[msg.sender]="lose";
            return result[msg.sender];
        }
    }
    else if(input==scissors)
    {
        if(random==paper)
        {
            result[msg.sender]="win";
            return result[msg.sender];
        }
        else if(random ==rock)
        {
            result[msg.sender]="lose";
            return result[msg.sender];
        }
    }
    else if(input==paper)
    {
        if(random==rock)
        {
            result[msg.sender]="win";
            return result[msg.sender];
        }
        else if(random==scissors)
        {
            result[msg.sender]="lose";
            return result[msg.sender];
        }
    }
}

function checkresult(address user) public view returns(string)
{
    return result[user];    
} 
function clearresult(address user) public returns(string)
{
    result[user] = "Null";
    return result[user];
}
}