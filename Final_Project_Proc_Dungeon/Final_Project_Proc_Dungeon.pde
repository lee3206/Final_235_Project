//Lee Taber
//Proc Dungeon
//http://www.roguebasin.com/index.php?title=Dungeon-Building_Algorithm
//http://pcg.wikidot.com/pcg-algorithm:dungeon-generation

//pixel art dungeon trick: test the color of a block for collisions to set up
//properties. i.e. black is wall, green is ground. Can also try and mess with
//a range if you want to drop in shaders/masks

//tasks:   Add collision with walls for player: DONE
         //Add pathing for dungeon: DONE
         //Add key pick-up to "unlock" the down stairs: DONE
         //If you get into down stairs, go down a floor: DONE
         //Adding a dungeon interface to see how many keys are left
         //Making key and stair icons
         //State machine to set up Title and End screens.
Dungeon floor;
Dungeon[] tower = new Dungeon[10];
Player p;
int dungeonIndex = 0;
boolean dDone;
final static int START = 0;
final static int MAIN = 1;
final static int END = 2;
int state = START;

void setup(){
  size(1200,1200);
  
  for(int i = 0; i < 10; i++){
    Dungeon d = new Dungeon(24,24);
    tower[i] = d;
  }
  floor = tower[dungeonIndex];
  floor.generate();
  floor.addStairs();
  floor.randomNoise();
  floor.addItems();
  floor.setPath();
  p = new Player(floor.startX, floor.startY, floor.tileSize);
} 

void draw(){
  if(state == START){
    
  }
  
  if(state == MAIN){
  //If the dungeon is done
  dDone = floor.update();
  if(dDone){
    dungeonIndex++;
    nextFloor();
    print("Finished the floor!");
  };
  floor.render();
  p.update();
  p.render();
  }
  
  if(state == END){
    
  }
}

void nextFloor(){
  floor = tower[dungeonIndex];
  floor.generate();
  floor.addStairs();
  floor.randomNoise();
  floor.addItems();
  floor.setPath();
  p = new Player(floor.startX, floor.startY, floor.tileSize);
}

void keyPressed(){
  int xInd = p.xIndex;
  int yInd = p.yIndex;
  if(key == CODED){
    if(keyCode == LEFT){
      if(!floor.collision(xInd - 1, yInd)){
        p.xIndex -= 1;
      }
    }
    else if(keyCode == RIGHT){ 
      if(!floor.collision(xInd + 1, yInd)){
        p.xIndex += 1;
      }
    }
    else if(keyCode == UP){
      if(!floor.collision(xInd, yInd-1)){
        p.yIndex -= 1;
      }
    }
    else if(keyCode == DOWN){
      if(!floor.collision(xInd,yInd + 1)){
        p.yIndex += 1;
      }
    }
  }
}
