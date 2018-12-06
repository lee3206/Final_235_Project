class Player{
  PVector pos;
  float size;
  PImage img;
  PVector vel;
  PVector tilePos;
  
  
  Player(Tile tile){
    pos = tile.pos;
    size = tile.size;
    vel = new PVector();
    img = loadImage("player.png");
  }
  
  void update(){
    pos.add(vel);
  }
  
  void render(){
    image(img, pos.x, pos.y);
  }
  
  //Add collision with walls
  //AABB half width, half height, compare by x and y, use abs to apply to both x and y
  
  void collision(){
    
    
  }
  
}
