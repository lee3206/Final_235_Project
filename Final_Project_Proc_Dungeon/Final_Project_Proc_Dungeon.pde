/*Lee Taber
Proc Dungeon

tasks:   Add collision with walls for player: DONE
         Add pathing for dungeon: DONE
         Add key pick-up to "unlock" the down stairs: DONE
         If you get into down stairs, go down a floor: DONE
         Adding a dungeon interface to see how many keys are left NOT DONE
         Making key and stair icons DONE
         State machine to set up Title and End screens. DONE
Graded stuff: 
         Write project post-mortem DONE
         */
Dungeon floor;
Dungeon[] tower = new Dungeon[10];
Player p;
int dungeonIndex = 0;
int dungeonDepth = 5;
boolean dDone;
final static int START = 0;
final static int MAIN = 1;
final static int END = 2;
int state = START;

void setup(){
  size(1200,1200);
  
  for(int i = 0; i < dungeonDepth; i++){
    Dungeon d = new Dungeon(24,24);
    tower[i] = d;
  }
  floor = tower[dungeonIndex];
  floor.generate();
  floor.addStairs();
  floor.randomNoise();
  floor.addItems();
  floor.setPathKeys();
  p = new Player(floor.startX, floor.startY, floor.tileSize);
} 

void draw(){
  //Draw title screen stuff here
  if(state == START){
    background(0);
    textSize(50);
    text("DUNGEON OF MYSTERY", 50, height/3);
    textSize(32);
    text("You have decided to delve into the Dungeons of Mystery,\na catacomb of"+
    " endless dungeons that constantly shift and move.\nFind three keys on each floor" + 
    " to progress to the bottom\nand claim your heart's desire!", 50, height/2);
  }
  
  //Draw main game stuff here
  if(state == MAIN){
    dDone = floor.update();
    if(dDone){//If the dungeon is done
      dungeonIndex++;
      nextFloor();
    }
    background(0);
    floor.render();
    p.update();
    p.render();
    fill(255);
    text("Floor : " + (dungeonIndex+1), width - 140, 40);
  }
  
  //Draw end of screen stuff here
  if(state == END){
    background(0);
    //Maybe a title image?
    fill(255);
    textSize(32);
    text("You have made it to the bottom,\nand claimed that which you "+
    "so badly wanted.\nAnother chance at life perhaps?\n" +
    "The life of another?\nRegardless, the Dungeon does not care\n" +
    "Another will come soon and walk the paths that give the Dungeon\n" +
    "LIFE", 50, height/3);
  }
}

void nextFloor(){
  if(dungeonIndex < dungeonDepth){
    floor = tower[dungeonIndex];
    floor.generate();
    floor.addStairs();
    floor.randomNoise();
    floor.addItems();
    floor.setPathKeys();
    p = new Player(floor.startX, floor.startY, floor.tileSize);
  }
  else{
    state = END;
  }
}

void mousePressed(){
  if(state == START){
    state = MAIN;
  }
}

void keyPressed(){
  
  if(state == MAIN){
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
}
