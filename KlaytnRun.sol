pragma solidity 0.4.24;

contract KlaytnRun {
    uint public room_count;
    uint public end_count;

    enum room_state {idle, playing, end}

    struct user_info {
        uint room;
        uint count;
        bool turn;
        string message;
    }

    struct room_info{
        room_state state;
        address player_1;
        address player_2;
        uint user_num;
    }

    constructor() {
        room_count = 1;
        end_count = 28;
    }

    mapping (address => user_info) public userInfos;
    mapping (uint => room_info) public roomInfos;

    function FindTarget(uint _number) view returns (address){
        if(roomInfos[_number].player_1 == msg.sender){
            return roomInfos[_number].player_2;
        }
        else{
            return roomInfos[_number].player_1;
        }
    }

    function CreateRoom() public returns (uint){
        require(userInfos[msg.sender].room == 0);

        userInfos[msg.sender].room = room_count;
        userInfos[msg.sender].count = 0;
        userInfos[msg.sender].turn = false;
        roomInfos[room_count].player_1 = msg.sender;
        roomInfos[room_count].state = room_state.idle;
        roomInfos[room_count].user_num = 1;
        room_count += 1;

        return room_count - 1;
    }

    function JoinRoom(uint _number) public returns (uint){
        require(userInfos[msg.sender].room == 0);
        require(roomInfos[_number].user_num < 2);
        require(roomInfos[_number].state == room_state.idle);

        userInfos[msg.sender].room = _number;
        userInfos[msg.sender].count = 0;
        userInfos[msg.sender].turn = true;
        roomInfos[_number].player_2 = msg.sender;
        roomInfos[_number].user_num = 2;

        return _number;
    }

    function StartGame(uint _number) public returns (bool){
        require(roomInfos[_number].state == room_state.idle);
        require(roomInfos[_number].user_num == 2);

        roomInfos[_number].state = room_state.playing;
        
        return true;
    }

    function BetDice() returns (uint){
       uint value = (uint(keccak256(now,msg.sender)))%6; 
       return value + 1;  
    }

    function uint2str(uint i) internal pure returns (string){
        if (i == 0) return "0";
        uint j = i;
        uint length;
        while (j != 0){
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint k = length - 1;
        while (i != 0){
            bstr[k--] = byte(48 + i % 10);
            i /= 10;
        }
        return string(bstr);
    }

    function strConcat(string _a, string _b) internal returns (string){
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        string memory abcde = new string(_ba.length + _bb.length );
        bytes memory babcde = bytes(abcde);
        uint k = 0;
        for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
        for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
        return string(babcde);
}

    function Move(uint _number) public returns(string){
        require(userInfos[msg.sender].turn);
        require(userInfos[msg.sender].room == _number);
        
            if(roomInfos[_number].state == room_state.end){
                userInfos[msg.sender].room = 0;
                userInfos[msg.sender].turn = false;

                return userInfos[msg.sender].message;
            }

            else{
                userInfos[msg.sender].count += BetDice();

                if(userInfos[msg.sender].count >= end_count){
                    userInfos[msg.sender].turn = false;
                    userInfos[msg.sender].room = 0;
                    userInfos[FindTarget(_number)].turn = true;

                    roomInfos[_number].state = room_state.end;

                    userInfos[msg.sender].message = "You Win";
                    userInfos[FindTarget(_number)].message = "You Lose";

                    return  userInfos[msg.sender].message;
                }
                else{
                    userInfos[msg.sender].turn = false;
                    userInfos[FindTarget(_number)].turn = true;

                    userInfos[msg.sender].message = strConcat("Your position is ", uint2str(userInfos[msg.sender].count));
                    return  userInfos[msg.sender].message;
                }
            }
    }
}