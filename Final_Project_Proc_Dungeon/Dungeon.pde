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
  int roomDist = 3;
  int minSize = 2;
  int maxSize = 4;
  Tile[][] tiles;
  ArrayList<Room> rooms;
  
  Dungeon(int tempCol, int tempRow){
    col = tempCol;
    row = tempRow;
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
  
  
  //boolean goEdge(Room r){
    //Use getTile method to find a tile on the direction's side of the room
    //Move forward one from there, checking getTile to make sure it is valid
    //set current x and y to correct edge based on room size and direction
  //}
  
  boolean checkFeature(){
    boolean dirCheck = false; //<>//
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
        //pushMatrix();
        translate(move, it);
        tiles[i][j].render();
        //popMatrix();
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
