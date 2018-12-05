//Lee Taber
//Proc Dungeon
//http://www.roguebasin.com/index.php?title=Dungeon-Building_Algorithm
//http://pcg.wikidot.com/pcg-algorithm:dungeon-generation

//pixel art dungeon trick: test the color of a block for collisions to set up
//properties. i.e. black is wall, green is ground. Can also try and mess with
//a range if you want to drop in shaders/masks
Dungeon d;

void setup(){
  size(1200,1200);
  
  d = new Dungeon(22,22);
  d.generate(50);
  d.update();
  d.render();
 
} 

void draw(){
  /* Not bothering with draw until I have something I need to draw over and over
  background(0);
  for(int i = 0; i < col; i++){
    for(int j = 0; j < row;j++){
      tiles[i][j].update();
      tiles[i][j].render();
    }
  }
  */
}

void keyPressed(){
  if(key == CODED){
    if(keyCode == LEFT){
      d.moveIt(-20,0);
    }
    if(keyCode == RIGHT){
      d.moveIt(20,0);
    }
    if(keyCode == UP){
      d.moveIt(0,-20);
    }
    if(keyCode == DOWN){
      d.moveIt(0,20);
    }
  }
}
