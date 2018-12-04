class Tile{
  PVector pos;
  float size = 50;
  color tileColor;
  String type;
  
  Tile(PVector tempPos, String tempType){
    pos = tempPos;
    type = tempType;
    setTile(type);
  }
  
  void render(){
    fill(tileColor);
    rect(pos.x,pos.y, size, size);
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
        tileColor = color(99, 95, 77);
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
