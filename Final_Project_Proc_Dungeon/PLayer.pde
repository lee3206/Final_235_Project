class Player{
  PVector pos;
  float size;
  PImage img;
  PVector vel;
  PVector tilePos;
  int xIndex;
  int yIndex;
  
  
  Player(int x, int y, int tempSize){
    xIndex = x;
    yIndex = y;
    size = tempSize;
    pos = new PVector(xIndex * size, yIndex * size);
    //When a tile is created, it is placed at an index (i/j) times the size
    //of the tile. So to get the index, I deconstruct that).
    vel = new PVector();
    img = loadImage("player.png");
  }
  
  void update(){
    pos.set(xIndex * size, yIndex * size);
  }
  
  void render(){
    image(img, pos.x , pos.y);
  }
}
