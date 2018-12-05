class Tile{
  PVector pos;
  float size = 50;
  color tileColor;
  String type;
  PImage tileImg;
  
  Tile(PVector tempPos, String tempType){
    pos = tempPos;
    type = tempType;
    setTile(type);
    tileImg = null;
  }
  
  void render(){
    if(tileImg == null){
      fill(tileColor);
      rect(pos.x,pos.y, size, size);
    }
    else{
      image(tileImg, pos.x,pos.y, size,size);
    }
  }
  
  void update(){
    
  }
  
  String returnType(){
    return type;
  }
  
  void setTile(String tempType){
    switch(tempType){
      case "f":
        tileColor = color(120,72,0);
        type = "f";
        break;
      case "w":
        tileImg = loadImage("wall.jpg");
        type = "w";
        break;
      case "d":
        tileColor = color(99, 150, 90);
        type = "d";
      default:
        tileColor = color(0);
    }
  }
}
