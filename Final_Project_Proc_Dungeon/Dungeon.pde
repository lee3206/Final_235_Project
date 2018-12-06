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
  int roomDist = 3;
  int minSize = 2;
  int maxSize = 4;
  Tile[][] tiles;
  ArrayList<Room> rooms;
  
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
    float size = test.size;
    
    for(int i = 0; i < col; i++){
      for(int j = 0; j < row;j++){
        tiles[i][j] = new Tile(new PVector(i*size,j*size), "w");
      }
    }
  }
  
  /* Gen Plan
  Fill the whole map with solid earth (Done in setup)
  Dig out a single room in the centre of the map (Done, see startGen)
  Pick a wall of any room (working, first time through pick starting)
  Decide upon a new feature to build
  See if there is room to add the new feature through the chosen wall
  If yes, continue. If no, go back to step 3
  Add the feature through the chosen wall
  Go back to step 3, until the dungeon is complete
  Add the up and down staircases at random points in map
  Finally, sprinkle some monsters and items liberally over dungeon
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
      println("Starting feature # "+(i+1));
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
  }
  /* Depreciated in favor of a do-while loop
  void generate(int maxFeatures){
    //start at middle of area
    int centerCol = col/2;
    int centerRow = row/2;
    currentX = centerCol;
    currentY = centerRow;
    //currentDirection = (int)random(1,4);
    for(int i = 0; i < maxFeatures; i++){
      println("Starting feature # "+(i+1));
      Room r = null;
      if(i == 0){
        //Add a room to the center for the first room.
        r = new Room(centerCol, centerRow, 3,3);
      }
      else{
        if(checkFeature()){ //<>//
          r = makeFeature();
        }
      }
      if(r != null){
        rooms.add(r);
        r.makeRect(tiles);
      }
      //pickDirection();
    }
  }
  */
  boolean checkFeature(){
    boolean dirCheck = false;
    //for each room
    for(int i = 0; i < rooms.size(); i++){
      //for each direction
      for(int j = 1; j < 5; j++){
        currentX = rooms.get(i).xStart;
        currentY = rooms.get(i).yStart;
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
      tiles[randomX][randomY].setTile("us");
      tiles[dsRandomX][dsRandomY].setTile("ds");
  }
  
  void addItems(){
    //Lets call these keys for the demo.
    //Find random floors tiles in the dungeon and switch them to keys
    boolean allPlaced = false; //<>//
    int counter = 0;
    do{
      int randomX = int(random(0, col));
      int randomY = int(random(0, row));
      if(tiles[randomX][randomY].getType() == "f"){
        tiles[randomX][randomY].setTile("i");
        counter++;
      }
      
      if(counter == 3){
        allPlaced = true;
      }
      
    }
    while(!allPlaced);
  }
  
  
  Room makeFeature(){
    Room r = new Room(currentX, currentY, (int)random(minSize,maxSize),(int) random(minSize,maxSize));
    return r;
  }
  
  void update(){
    for(int i = 0; i < col; i++){
      for(int j = 0; j < row;j++){
        tiles[i][j].update();
      }
    }
  }
  
  void render(){
    for(int i = 0; i < col; i++){
      for(int j = 0; j < row;j++){
        tiles[i][j].render();
      }
    }
  }
  
  void moveIt(float move, float it){
    for (int i = 0; i < col; i++) {
      for (int j = 0; j < row; j++) {
        pushMatrix();
        translate(move, it);
        tiles[i][j].render();
        popMatrix();
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
  
  void pickDirection(){
    currentDirection = (int)random(1,4);
    switch(currentDirection){
      case 1:
        println("I'm going North now!");
        break;
      case 2:
        println("I'm going East now!");
        break;
      case 3:
        println("I'm going South now!");
        break;
      case 4:
        println("I'm going West now!");
        break;
    }  
  }
  
  Tile getTile(int x, int y){
    if(x < 0 || y < 0 || x >= col || y >= row){
      return null;
    }
    return tiles[x][y];
  }
}
