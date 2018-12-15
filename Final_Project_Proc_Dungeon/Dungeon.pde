class Dungeon{
  //Start at N, count clockwise
  final static int North = 1;
  final static int East = 2;
  final static int South = 3;
  final static int West = 4;
  int currentDirection;
  int currentX;
  int currentY;
  int col;
  int row;
  int centerCol;
  int centerRow;
  int tileSize;
  int roomDist = 3;
  int minSize = 2;
  int maxSize = 4;
  Tile[][] tiles;
  ArrayList<Room> rooms;
  int startX;
  int startY;
  PVector endVector = new PVector();
  PVector key1 = new PVector();
  PVector key2 = new PVector();
  PVector key3 = new PVector();
  ArrayList<PVector> keyList;
  int keyCount = 0;
  boolean dungeonDone = false;
  
  Dungeon(int tempCol, int tempRow){
    col = tempCol;
    centerCol = col/2;
    row = tempRow;
    centerRow = row/2;
    tiles = new Tile[col][row];
    rooms = new ArrayList<Room>();
    //Makes a test tile so I have access to size (and only have to write it once for
    //changes)
    Tile test = new Tile(new PVector(0,0), "w");
    tileSize = int(test.size);
    for(int i = 0; i < col; i++){
      for(int j = 0; j < row;j++){
        tiles[i][j] = new Tile(new PVector(i*tileSize,j*tileSize), "w");
      }
    }
  }
  
  /* Gen Plan
  Fill the whole map with solid earth (Done in setup)
  Dig out a single room in the centre of the map (Done, see startGen)
  (IK: Can put not in center for more variety)
  Pick a direction from any room (done)
  Decide upon a new feature to build (simplistic but done)
  See if there is room to add the new feature (done)
  If yes, continue. If no, go back to step 3
  Add the feature in direction (done)
  Go back to step 3, until the dungeon is complete
  Add the up and down staircases at random points in map (done)
  Finally, sprinkle some monsters and items liberally over dungeon (items done, no monsters)
  */
  
  /*"Pathfinding" plans
  One way would be to keep room dist at 4 which makes not touching squares, and 
  then iterate through with a way to randomly flip tiles at about 10% (i.e. 
  if it is a floor, switch to wall, if it is a wall, switch to floor.)
  
  Also, Batu pointed out an easy pathfinding workaround. If I add features and know
  the x and y of where they are, I can make a path between them that draws floors as it
  goes, and have it randomly wander a bit to keep the path interesting.*/
  void generate(){
    //start at middle of area //<>//
    currentX = centerCol;
    currentY = centerRow;
    boolean run = true;
    int i = 0;
    do{ //<>//
      //Turning off for MJ
      //println("Starting feature # "+(i+1));
      Room r = null;
      if(i == 0){
        //Add a room to the center for the first room.
        r = new Room(centerCol, centerRow, 3,3);
      }
      else{
        run = checkFeature();
        if(run){
          r = makeFeature();
        }
      }
      if(r != null){
        rooms.add(r);
        r.makeRect(tiles);
      }
      i++;
    }
    while(run);
    //Turning off for MJ
    //println("Cancel feature " + i + ", floor is full");
  }
   //<>//
  boolean checkFeature(){
    boolean dirCheck = false;
    //for each room
    for(int i = 0; i < rooms.size(); i++){
      //for each direction
      for(int j = 1; j < 5; j++){
        currentX = rooms.get(i).xStart + int(random(-1,1));
        currentY = rooms.get(i).yStart + int(random(-1,1));
        currentDirection = j;
        switch(currentDirection){
          case(North):
            if(currentY - roomDist >0){//-maxSize > 0){
              currentY -= roomDist;
              if(roomCheck(currentX, currentY)){
                dirCheck = true;
                return dirCheck;
              }
            }
            break;
          case(East):
            if(currentX + roomDist < col){ //+maxSize< col){
              currentX += roomDist;
              if(roomCheck(currentX, currentY)){
                dirCheck = true;
                return dirCheck;
              }
            }
            break;
          case(South):
            if(currentY + roomDist <row){//+maxSize< row){
              currentY += roomDist;
              if(roomCheck(currentX, currentY)){
                dirCheck = true;
                return dirCheck;
              }
            }
            break;
          case(West):
            if(currentX - roomDist >0){//-maxSize > 0){
              currentX -= roomDist;
              if(roomCheck(currentX, currentY)){
                dirCheck = true;
                return dirCheck;
              }
            }
            break;
        }
      }
    }
    return dirCheck;
  }
  
  //I want to move through the tiles and add stairs at random* points in the map
  //*Random here means in different places, but always "somewhat far" away
  void addStairs(){
    //start at the center
    currentX = centerCol;
    currentY = centerRow;
    //generate some random numbers for the distance
    //numbers are between 1/8 and 1/2 of the total size of the dungeon
    //to keep it in a goldilocks zone
    int randomX = int(random(centerCol/4, centerCol-1));
    int randomY = int(random(centerCol/4, centerRow-1));
    int dsRandomX = randomX;
    int dsRandomY = randomY;
    //Pick a side, put the up stairs, than pick the opposite and put the down stairs
    int d4 = int(random(0,3));
    switch(d4){
      case 0://us in upper left, ds in lower right
      {
        dsRandomX += centerCol;
        dsRandomY += centerCol;
        break;
      }
      case 1://us in upper right, ds in lower left
      {
        randomX += centerCol;
        dsRandomY += centerRow;
        break;
      }
      case 2: //us in lower left, ds in upper right
      {
        randomY += centerRow;
        dsRandomX += centerCol;
        break;
      }
      case 3: //us in lower right, ds in upper left
      {
        dsRandomX = randomX;
        dsRandomY = randomY;
        randomX += centerCol;
        randomY += centerRow;
        break;
      }
    }
      tiles[randomX][randomY].setType("us");
      startX = randomX;
      startY = randomY;
      tiles[dsRandomX][dsRandomY].setType("ds");
      endVector.add(dsRandomX,dsRandomY);
  }
  
  void addItems(){
    //Lets call these keys for the demo.
    //Find random floors tiles in the dungeon and switch them to keys
    boolean allPlaced = false;
    int counter = 0;
    do{
      int randomX = int(random(0, col));
      int randomY = int(random(0, row));
      if(tiles[randomX][randomY].getType().equals("f")){
        tiles[randomX][randomY].setType("i");
        switch(counter){
          case 0:
            key1.add(randomX, randomY);
            break;
          case 1:
            key2.add(randomX, randomY);
            break;
          case 2:
            key3.add(randomX, randomY);
            break;
        }
        counter++;
      }
      
      if(counter == 3){
        allPlaced = true;
        keyList = new ArrayList<PVector>();
        keyList.add(key1);
        keyList.add(key2);
        keyList.add(key3);
        keyList.add(endVector);
      }
      
    }
    while(!allPlaced);
  }
  
  
  //Start at the start stairs, and move towards the goal in
  //x and y paths.
  //Every part of the loop, turn walls it sees into floors
  //Makes it so there is at least one path towards each key and the exit.
  void setPathKeys(){
    currentX = startX; //<>//
    currentY = startY;
    for(int i = 0; i < keyList.size();i++){
      int nextX = int(keyList.get(i).x);
      int nextY = int(keyList.get(i).y);
      boolean stop = false;
      //X loop
      do{
        //If the current tile is more to the right than the end
        if(currentX > nextX){
          currentX--;
        }
        //If the current tile is more to the left than the end
        else if(currentX < nextX){
          currentX++;
        }
        //Y look
        //If the current tile is higher than the end
        else if(currentY < nextY){
          currentY++;
        }
        //If the current tile is lower than the end
        else if(currentY > nextY){
          currentY--;
        }
        if(tiles[currentX][currentY].getType().equals("w")){
          tiles[currentX][currentY].setType("f");
        }
        if(currentX == nextX && currentY == nextY){
          stop = true;
        }
      }while(!stop);
    }
  }
  
  
  void randomNoise(){
    //Go through the entire floor
    //flipping 10% of walls to floors and floors to walls
    //This ignores x = 0 & col, y = 0 & row 
    for(int i = 1; i < col-1; i++){
      for(int j = 1; j < row-1; j++){
        int d10 = int(random(10));
        Tile t = tiles[i][j];
        if(d10 == 10 && t.getType().equals("w")){
          t.setType("f");
        }
        else if(d10 == 10 && t.getType().equals("f")){
          t.setType("w");
        }
      }
    }
  }
  
  boolean collision(int xIn, int yIn){
    if(tiles[xIn][yIn].getType().equals("w")){ //<>//
      return true;
    }
    else if(tiles[xIn][yIn].getType().equals("i")){
      takeKey(xIn, yIn);
      return false;
    }
    else if(tiles[xIn][yIn].getType().equals("ds")){
      takeStairs(xIn, yIn);
      return false;
    }
    else{
      return false;
    }
    
  }
  
  Room makeFeature(){
    Room r = new Room(currentX, currentY, (int)random(minSize,maxSize),(int) random(minSize,maxSize));
    return r;
  }
  
  boolean update(){
    for(int i = 0; i < col; i++){
      for(int j = 0; j < row;j++){
        tiles[i][j].update();
      }
    }
    if(dungeonDone == true){
      return true;
    }
    return false;
  }
  
  void render(){
    for(int i = 0; i < col; i++){
      for(int j = 0; j < row;j++){
        tiles[i][j].render();
      }
    }
  }
  
  boolean roomCheck(int testX, int testY){
    for(int i = 0; i < rooms.size(); i++){
      Room r = rooms.get(i);
      if(r.xStart == testX && r.yStart == testY){
        return false;
      }
    }
    return true;
  }
 
  Tile getTile(int x, int y){
    if(x < 0 || y < 0 || x >= col || y >= row){
      return null;
    }
    return tiles[x][y];
  }
  
  Tile getStart(){
    Tile t = new Tile(new PVector(),"");
    t = tiles[startX][startY];
    return t;
  }
  
  void takeKey(int x, int y){
    if(tiles[x][y].getType().equals("i")){
      tiles[x][y].setType("f");
      keyCount++;
    }
  }
  
  void takeStairs(int x, int y){
    if(tiles[x][y].getType().equals("ds") && keyCount == 3){
      dungeonDone = true;
    }
  }
}
