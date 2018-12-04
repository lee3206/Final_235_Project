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
  int roomDist = 5;
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
    Tile test = new Tile(new PVector(0,0),"w");
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
    startGen();
    for(int i = 1; i < maxFeatures; i++){
      println("Starting feature # "+(i+1));
      Room r;
      r = makeFeature();
      rooms.add(r);
      r.makeRect(tiles);
      pickDirection();
    }
  }
  
  void startGen(){
    //start at middle of area
    int centerCol = col/2;
    int centerRow = row/2;
    currentX = centerCol;
    currentY = centerRow;
    currentDirection = (int)random(1,4);
    println("Starting feature # "+(1));
    //Make starting room 3x3 in the center
    Room r = new Room(centerCol, centerRow, 3,3);
    r.makeRect(tiles);
    rooms.add(r);
    println("I'm going " + currentDirection + " now");
    //Go to the edge of the starting room using goEdge method
    
    
  }
  
  //boolean goEdge(Room r){
    //Use getTile method to find a tile on the direction's side of the room
    //Move forward one from there, checking getTile to make sure it is valid
    //set current x and y to correct edge based on room size and direction
  //}
  
  Room makeFeature(){
    Room r = null;
    boolean dirCheck = false;
    System.out.println("I'm going to make a room at col: "+ currentX + " and row: " + currentY);
    switch(currentDirection){
      case(North):
        if(currentY - roomDist -maxSize > 0){
          currentY -= roomDist;
          dirCheck = true;
        }
        if(dirCheck == true){
          r= new Room(currentX, currentY, (int)random(minSize,maxSize),(int) random(minSize,maxSize));
          return r;
        }
        break;
      case(East):
        if(currentX + roomDist +maxSize< col){
          currentX += roomDist;
          dirCheck = true;
        }
        if(dirCheck == true){
          r = new Room(currentX, currentY, (int)random(minSize,maxSize),(int)random(minSize,maxSize));
          return r;
        }
        break;
      case(South):
        if(currentY + roomDist +maxSize< row){
          currentY += roomDist;
          dirCheck = true;
        }
        if(dirCheck == true){
          r = new Room(currentX, currentY, (int)random(minSize,maxSize), (int)random(minSize,maxSize));
          return r;
        }
        break;
      case(West):
        if(currentX - roomDist -maxSize > 0){
          currentX -= roomDist;
          dirCheck = true;
        }
        if(dirCheck == true){
          r = new Room(currentX, currentY, (int)random(minSize,maxSize), (int)random(minSize,maxSize));
          return r;
        }
        break;
    } 
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
