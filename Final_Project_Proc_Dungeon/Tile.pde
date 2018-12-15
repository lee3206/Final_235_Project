class Tile{
  PVector pos;
  float size = 50;
  color tileColor;
  String type;
  PImage tileImg;
  int xInd;
  int yInd;

  
  Tile(PVector tempPos, String tempType){
    pos = tempPos;
    type = tempType;
    setType(type);
    tileImg = null;
  }
  
  void render(){
    if(tileImg == null){
      fill(tileColor);
      rect(pos.x,pos.y, size, size);
    }
    else{
      image(tileImg, pos.x,pos.y);
    }
  }
  
  void update(){
    setType(type);
  }
  
  String getType(){
    return type;
  }
  
  void setType(String tempType){
    switch(tempType){
      case "f":
        tileImg = null;
        tileColor = color(100,72,0);
        type = "f";
        break;
      case "w":
        tileImg = loadImage("wall.jpg");
        type = "w";
        break;
      case "d":
        tileColor = color(99, 150, 90);
        type = "d";
        break;
      case "us":
        tileImg = loadImage("stairs_up.png");
        type = "us";
        break;
      case "ds":
        tileImg = loadImage("stairs_down.png");
        type = "ds";
        break;
      case "i":
        tileImg = loadImage("key.png");
        type = "i";
        break;
      default:
        tileColor = color(0);
        break;
    }
  }
}
