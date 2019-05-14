pragma solidity ^0.4.24;

contract MYDAX{

  mapping(bytes32 => uint256) public orderTokens;
  mapping(bytes32 => uint256) public orderPrice;
  mapping(bytes32 => address) public orderAsset;
  mapping(bytes32 => address) public orderPair;
  mapping(bytes32 => address) public orderCreator;

  function createOrder(address asset, address pair, uint256 amount, uint256 price) external returns (bool){
    require(ERC20(asset).transferFrom(msg.sender, address(this), amount));
    bytes32 orderID = keccak256(abi.encodePacked('exchange.orderID', msg.sender, asset, pair, price));
    if(orderTokens[orderID] > 0){
      orderTokens[orderID] = orderTokens[orderID].add(amount);
      emit orderUpdated(orderID, orderTokens[orderID])
    } else {
      orderTokens[orderID] = amount;
      orderPrice[orderID] = price;
      orderAsset[orderID] = asset;
      orderPair[orderID] = pair;
      orderCreator[orderID] = msg.sender;
      emit orderCreated(orderID, msg.sender, asset, pair, amount, price)
    }

    return true;
  }

  function cancelOrder(bytes32 orderID, uint256 amount) external returns (bool){
    require(msg.sender == orderCreator[orderID]);
    require(amount <= orderTokens[orderID]);
    orderTokens[orderID] = orderTokens[orderID].sub(amount);
    emit orderUpdated(orderID, orderTokens[orderID]);
  }

  function purchase(bytes32 orderID, uint256 payment) payable external returns (bool){

  }
}
