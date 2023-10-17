// SPDX-License-Identifier:  MPL-2.0

//yes, I know this is a mess. this is just proof of concept minimum viable product, I have burnout


pragma solidity ^0.8.18;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

type coords is uint256; //did this whole thing just cause you can't have structs as the key for a mapping! yes i know not gas optimal and could just do the converting offchain, this is an alpha

library xymath{
    uint constant multiplier = 2**128;
    function ints2coords(int128 x, int128 y) internal pure returns(coords){
        return coords.wrap((uint256(uint128(x))<<128)+uint128(y));
    }
    function coords2ints(coords _xy) internal pure returns(int128 x, int128 y){
        uint xy = coords.unwrap(_xy);
        x = int128(uint128(xy / multiplier));
        y = int128(uint128(xy % multiplier));
    }
}

contract cosmicplace is Ownable {
    using EnumerableSet for EnumerableSet.UintSet;

	struct pixel{ 
        //yes, i know i need to pack the data better

		bytes16 data; //intention for this is that first 12 bytes are pixel data, on a 2x2 square, and the rest is text data
        /*first 12 bytes map to 2x2 square of pixels like this: 
        ^ +y
        |  (next pixel +1 y)
        +---------+---------+
        |  R  G  B|  R  G  B|
        |  6  7  8|  9 10 11|
        +---------+---------+ (next pixel +1 x)
        |  R  G  B|  R  G  B|
        |  0  1  2|  3  4  5|
    -x <+---------+---------+--> +x
        v -y
        so, each "pixel" xy coordinates is 4 actual color pixels  */
        uint128 nextRound;
		address owner;
        address highestBidder;
        uint highestBid;
        bool autoRenew;
        uint writes; // for easy heatmap of pixel writes
        uint alltimeRent; // for easy heatmap of all time revenue ~= land values
        //todo: historical data built in?
        	
    }
    struct world{
		mapping(coords => pixel) pixels;
        mapping(address => EnumerableSet.UintSet) ownedPixels; // use this with coords.unwrap
	}
    mapping(address => world) worlds;
    mapping(address => bool) public feesOn; //enable private fee collection
    uint public roundInterval;
    uint public offsetTime;
    uint public minBid;
    uint public privateFeePerGwei;

    mapping(address => uint) public balances;
    uint public contractBal;

    constructor() Ownable(msg.sender){
        roundInterval = 2 hours;
        offsetTime = 0;
        minBid = 1 gwei;
        privateFeePerGwei = 1 gwei - (1 gwei / 2);
    }

    function worldToggleFees() public returns (bool _b){
        _b = !(feesOn[msg.sender]);
        feesOn[msg.sender] = _b;
    }

    //get next round time
    function globalNextRound() public view returns(uint128){
        return uint128((block.timestamp) - ((block.timestamp - offsetTime) % roundInterval) + roundInterval);
    }

    ///////////MONEY HANDLING FUNCTIONS

    function bid(address _world, int128 _x, int128 _y, bool _autoRenew) public payable {
        require(msg.value > minBid, "value < minBid");
        coords xy = xymath.ints2coords(_x, _y);

        checkRoundXY(_world, xy);

        uint _highestBid = worlds[_world].pixels[xy].highestBid;

        require(msg.value > _highestBid, "value < highest");
        address _highestBidder = worlds[_world].pixels[xy].highestBidder;
        if(_highestBidder != address(0)){
            balances[_highestBidder] += _highestBid;
        }
        worlds[_world].pixels[xy].highestBidder = msg.sender;
        worlds[_world].pixels[xy].highestBid = msg.value;
        worlds[_world].pixels[xy].autoRenew = _autoRenew;
    }

    function setAutoRenew(address _world, int128 _x, int128 _y, bool _autoRenew) public payable {
        coords xy = xymath.ints2coords(_x,_y);
        require(worlds[_world].pixels[xy].owner == msg.sender);
        worlds[_world].pixels[xy].autoRenew = _autoRenew;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }
    function withdraw(uint amount) public {
        require(amount > 0);
        require(balances[msg.sender] >= amount);
        balances[msg.sender] -= amount;

        //figure out which pay thing to use, there's a few
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "failed to send ether");
    }

    
    //function to activate to execute an auction round and finalize a bid

    function checkRoundXY(address _world, coords xy) public {
        uint128 _next = worlds[_world].pixels[xy].nextRound;
        address _highestBidder = worlds[_world].pixels[xy].highestBidder;

        if(_next == 0){
            worlds[_world].pixels[xy].nextRound = globalNextRound(); //update next round time
        } else if(_next <= block.timestamp && _highestBidder != address(0)){

            //update ownership
            address _oldOwner = worlds[_world].pixels[xy].owner;

            uint _xy = coords.unwrap(xy);
            if(_oldOwner != address(0)){
                worlds[_world].ownedPixels[_oldOwner].remove(_xy);
            }
            worlds[_world].ownedPixels[_highestBidder].add(_xy);
            worlds[_world].pixels[xy].owner = _highestBidder;


            uint _highestBid = worlds[_world].pixels[xy].highestBid;

            if(worlds[_world].pixels[xy].autoRenew && balances[_highestBidder] >= _highestBid){ //if either autoRenew is set to false or the bidder doesn't have enough money, reset for a clean next round, otherwise, they keep paying and it starts from their bid
                balances[_highestBidder] -= _highestBid; //simulate another bid call, take the bid from the bidder and leave highestBidder and highestBid unchanged
            } else {
                worlds[_world].pixels[xy].highestBidder = address(0); //update this later to check if autorenew and if highestbidder has some bal leftover, and if it does, then keep it as highest bidder until it's outbid
                worlds[_world].pixels[xy].highestBid = 0;
                worlds[_world].pixels[xy].autoRenew = false;
            }

            //update alltimerent for long term rent heatmap
            worlds[_world].pixels[xy].alltimeRent += _highestBid;

            //pay world owner portion set by privateFeePerGwei, if they enabled feesOn
            uint _toPrivate = 0;
            if(_world != address(0) && feesOn[_world]){
                _toPrivate = (_highestBid * privateFeePerGwei) / 1 gwei;
                balances[_world] += _toPrivate;
            }
            contractBal += _highestBid - _toPrivate;
            worlds[_world].pixels[xy].nextRound = globalNextRound(); //update next round time
        }
    }
    function checkRound(address _world, int128 _x, int128 _y) public {
        coords xy = xymath.ints2coords(_x, _y);
        checkRoundXY(_world, xy);
    }

    function withdrawOwner(uint amount) public onlyOwner {
        require(contractBal >= amount, "amount > contractbal");
        
        contractBal -= amount;
        //again, figure out which pay thing to use
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "failed to send ether");
    }

    //owner setter functions
    function setRoundInterval(uint _time) public onlyOwner {
        roundInterval = _time;
    }
    function setOffsetTime(uint _time) public onlyOwner {
        offsetTime = _time;
    }
    function setMinBid(uint _wei) public onlyOwner {
        minBid = _wei;
    }
    function setPrivateFee(uint _gwei) public onlyOwner {
        require(_gwei <= 1 gwei);
        privateFeePerGwei = _gwei;
    }


    //pixel editing and reading

    function setPixel(address _world, int128 _x, int128 _y, bytes16 _data) public returns (bool){
        coords xy = xymath.ints2coords(_x, _y);
        checkRoundXY(_world, xy);
        address _o = worlds[_world].pixels[xy].owner;
		if(_o == address(0) || _o == msg.sender){
			worlds[_world].pixels[xy].data = _data;
            worlds[_world].pixels[xy].writes += 1; //count writes for easy heatmap
            return true;
		}
        return false;   
    }

    function readPixels(address _world, int128 x1, int128 y1, int128 x2, int128 y2) public view returns (pixel[] memory P){
        require(x2 >= x1, "x2 must > x1");
        require(y2 >= y1, "y2 must > y1");
        uint size = uint128(x2 - x1 + 1) * uint128(y2 - y1 + 1);
        P = new pixel[](size);
        uint k = 0;
        for(int128 i = x1; i <= x2; ++i){
            for(int128 j = y1; j <= y2; ++j){
                P[k] = worlds[_world].pixels[xymath.ints2coords(i, j)];
                ++k;
            }
        }
    }

    function viewOwnedPixels(address _world, address _owner) public view returns (uint[] memory) { //note that this *will* return it in the coords.unwrapped form
        return worlds[_world].ownedPixels[_owner].values();
    }
}
