class Room{
  int xStart;
  int yStart;
  int xSize;
  int ySize;
  int type;
  final static int CIRC = 1;
  final static int REC = 2;
  
  Room(int tempXStart, int tempYStart, int tempX, int tempY){
    xStart = tempXStart;
    yStart = tempYStart;
    xSize = tempX;
    ySize = tempY;
  }
  
  void makeRect(Tile[][] tiles){
    //Turning off for MJ
    //println("I'm starting at col: "+xStart+ " row: "+yStart);
    //put the current X/Y marker in center of room.
    int fixedX;
    int fixedY;
    int nudgeX = 0;
    int nudgeY = 0;
    if(xSize%2 != 0){
      fixedX = (int)(xSize/2);
      nudgeX = 1;
    }
    else{
      fixedX = (int)(xSize/2);
    }
    if(ySize%2 != 0){
      fixedY = (int)(ySize/2);
      nudgeY = 1;
    }
    else{
      fixedY = (int)(ySize/2);
    }
    for(int i = xStart-(fixedX + nudgeX); i < xStart+fixedX; i++){
      for(int j = yStart-(fixedY + nudgeY);j < yStart+fixedY; j++){
        //get existing position, set tile to floor at that position
        tiles[i][j].setType("f");
      }
    }
    //Turning this off for MJ
    //println("Done, made a "+xSize+ " by " +ySize+ " rec room");
  }
  
  //Turning this off for MJ too
  /*void printCenter(){
    System.out.println("I'm a room at col: "+xStart+ " row: "+yStart);
  }
  */
}
