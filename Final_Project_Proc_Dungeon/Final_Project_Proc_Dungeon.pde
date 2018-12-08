//Lee Taber
//Proc Dungeon
//http://www.roguebasin.com/index.php?title=Dungeon-Building_Algorithm
//http://pcg.wikidot.com/pcg-algorithm:dungeon-generation

//pixel art dungeon trick: test the color of a block for collisions to set up
//properties. i.e. black is wall, green is ground. Can also try and mess with
//a range if you want to drop in shaders/masks

//tasks:   Add collision with walls for player: DONE
         //Add pathing for dungeon
Dungeon d;
Player p;

void setup(){
  size(1200,1200);
  
  d = new Dungeon(24,24);
  d.generate();
  d.addStairs();
  d.addItems();
  p = new Player(d.startX, d.startY, d.tileSize);
} 

void draw(){
  //background(0);
  d.update();
  d.render();
  p.update();
  p.render();
  //p.collision(d.tiles[int(p.pos.x)][int(p.pos.y)]);
}

void keyPressed(){
  int xInd = p.xIndex;
  int yInd = p.yIndex; //<>//
  if(key == CODED){
    if(keyCode == LEFT){
      if(!d.collision(xInd - 1, yInd)){
        p.pos.add(-50,0);
        p.xIndex -= 1;
      }
    }
    else if(keyCode == RIGHT){ 
      if(!d.collision(xInd + 1, yInd)){
        p.pos.add(50,0);
        p.xIndex += 1;
      }
    }
    else if(keyCode == UP){
      if(!d.collision(xInd, yInd-1)){
        p.pos.add(0,-50);
        p.yIndex -= 1;
      }
    }
    else if(keyCode == DOWN){
      if(!d.collision(xInd,yInd + 1)){
        p.pos.add(0,50);
        p.yIndex += 1;
      }
    }
  }
}
