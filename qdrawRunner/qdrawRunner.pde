/************************************************************************************/
/*  ^    ^                                                                          */
/* Ejecutar/                                                                        */
/*  Detener                                                                         */
/*                                                                                  */
/*                                                                                  */
/*       / _ \|   \ _ _ __ ___ __ __ | _ \_  _ _ _  _ _  ___ _ _                    */
/*      | (_) | |) | '_/ _` \ V  V / |   | || | ' \| ' \/ -_| '_|                   */
/*   ___ \__\_|___/|_| \__,_|\_/\_/  |_|_\\_,_|_||_|_||_\___|_|_                    */
/*  | _ )_  _  |_ _|__ _ _ _  __ _ __(_)___  | _ \___ __| |_ _(_)__ _ _  _ ___ ___  */
/*  | _ | || |  | |/ _` | ' \/ _` / _| / _ \ |   / _ / _` | '_| / _` | || / -_|_ /  */
/*  |___/\_, | |___\__, |_||_\__,_\__|_\___/ |_|_\___\__,_|_| |_\__, |\_,_\___/__|  */
/*       |__/      |___/                                        |___/               */
/*                                                                                  */
/*                                                                                  */
/*                                                                                  */
/*                                                                                  */
/*                                                                                  */
/************************************************************************************/

import java.util.Arrays;
import java.util.regex.Pattern;
import java.util.regex.Matcher;
import controlP5.*;

ControlP5 cp5;
String[] lines;
int sizeX, sizeY, startX, startY, posX, posY;
int[][] board;

String arr = "MoverArriba";
String aba = "MoverAbajo";
String izq = "MoverIzquierda";
String der = "MoverDerecha";
String pn = "PintarNegro";
String pr = "PintarRojo";
String pv = "PintarVerde";
String lim = "Limpiar";
String[] punt = {"{", "}", "(", ")", "/*", "*/"};
//String[] prerec = {"sizeX", "sizeY", "startX", "startY"};

/* Draw variables */
int centerStartX, centerStartY;
int squareSize;
int x = 0;
int y = 0;
int li = 0;
boolean readCode = false;
int velocity = 0;
int currentTime = millis();
int startTime = currentTime;

/********************* Classes *********************/

class Block {
  int start, end;
  String type, content;
  void start(int s) {
    start = s;
  }
  void end(int e) {
    end = e;
  }
  void type(String t) {
    type = t;
  }
  void content(String c) {
    content = c;
  }
}
class Prog {
  String code;
  void set(String c) {
    code = c;
  }
}
class Proc {
  String code, name;
  void set(String n, String c) {
    name = n;
    code = c;
  }
}
class Loop {
  String code;
  int times;
  void set(int t, String c) {
    times = t;
    code = c;
  }
}

Proc procList[] = new Proc[32];
Loop loopList[] = new Loop[32];
Block blockList[] = new Block[0];

/********************* Setup *********************/

void setup() {
  size(600, 600);
  background(255);
  stroke(#d8d8d8);
  frameRate(60);
  cp5 = new ControlP5(this);
  
  /* Controllers */
  cp5.addButton("playButton")
     .setPosition(20,20)
     .setSize(80,40)
     .setColorBackground(color(#16de34))
     .setColorForeground(color(#14c42d))
     .setColorActive(color(#11ab27))
     .setLabel("Play")
     .setFont(createFont("", 15))
     ;
  cp5.addButton("stopButton")
     .setPosition(120,20)
     .setSize(80,40)
     .setColorBackground(color(#de1616))
     .setColorForeground(color(#c41414))
     .setColorActive(color(#ab1111))
     .setLabel("Stop")
     .setFont(createFont("", 15))
     ;
  cp5.addSlider("velSlider")
     .setPosition(220,20)
     .setSize(200,40)
     .setLabel("Velocity")
     .setFont(createFont("", 15))
     .setRange(1,10)
     .setValue(5)
     .setNumberOfTickMarks(10)
     ;
     
  lines = loadStrings("qdraw.txt");
  
  /* Check syntax errors (WIP) */
  verifySyntax(lines);
  
  /* Read code structures */
  lines = nestResolve(lines);
  
  /* Read code structures */
  readCode(lines);
  
  /* Initialize board */
  for (int i = 0 ; i < lines.length; i++) {
    startBoard(lines[i]);
  }
  board = new color[sizeY][sizeX];
  for (int x = 0; x < sizeX; x++) {
    for (int y = 0; y < sizeY; y++) {
      board[y][x] = #FFFFFF;
    }
  }
  
  /* Compile code structures */
  lines = compileCode(lines);
  
  /* Initialize draw vars */
  posX = startX;
  posY = startY;
  squareSize = min((height-130)/sizeY, (width-50)/sizeX);
  
  /* First grid draw */
  renderGrid();
  
}

/********************* Draw *********************/

void draw() {
  //Check conds
  
  /* Main Timer */
  currentTime = millis(); // update timer

  if (currentTime - startTime >= round(500/velocity-49)) {
    main();
    startTime = currentTime;  // reset timer
  }
}
  

/********************* Initialize methods *********************/

void main() {
  /* Execute commands, write board, draw */
  
  if(readCode && li < lines.length) {
      textAlign(CENTER, BOTTOM);
      
      movePos(lines[li]);
      
      if(posX < 0 || posX > sizeX-1) {
        fill(#c41414);
        text("Error: Fuera de límite en el eje X", width/2, centerStartY + squareSize*(sizeY) + 50);
        readCode = false;
        return;
      }
      if(posY < 0 || posY > sizeY-1) {
        fill(#c41414);
        text("Error: Fuera de límite en el eje Y", width/2, centerStartY + squareSize*(sizeY) + 50);
        readCode = false;
        return;
      }
      board[posY][posX] = paint(lines[li], board[posY][posX]);
      
      renderGrid();
      
      
      fill(0);
      text(lines[li], width/2, centerStartY + squareSize*(sizeY) + 25);
      
      strokeWeight(2);
      noFill();
      stroke(#03a9fc);
      square(centerStartX + startX*squareSize, centerStartY + startY*squareSize, squareSize);
      stroke(#ff7601);
      square(centerStartX + posX*squareSize, centerStartY + posY*squareSize, squareSize);
      strokeWeight(1);
      
      li++;
    } else if(readCode) {
      String text = String.format("Finalizado en (%d, %d)", posX, sizeY-posY-1);
      fill(0);
      text(text, width/2, centerStartY + squareSize*(sizeY) + 25);
      readCode = false;
    }
  }

void startBoard(String input) {
  if(input.contains("sizeX")) {
      String[] temp = split(input, " = ");
      sizeX = int(temp[1]);
  }
  if(input.contains("sizeY")) {
      String[] temp = split(input, " = ");
      sizeY = int(temp[1]);
  }
  if(input.contains("startX")) {
      String[] temp = split(input, " = ");
      startX = int(temp[1]);
  }
  if(input.contains("startY")) {
      String[] temp = split(input, " = ");
      startY = int(temp[1]);
      startY = (sizeY-1)-startY; //Invert Y axis
  }
}

void verifySyntax(String[] linesArr) {
  
}

/********************* Draw methods *********************/

void renderGrid() {
  background(255);
  centerStartX = (width - squareSize*sizeX)/2;
  centerStartY = (height - squareSize*sizeY)/2 + 10;
  for (int x = 0; x < sizeX; x++) {
    for (int y = 0; y < sizeY; y++) {
      fill(board[y][x]);
      stroke(#d8d8d8);
      square(centerStartX + x*squareSize, centerStartY + y*squareSize, squareSize); //Variable size?
    }
  }
}

color paint(String input, color actual) {
  color colorOut = actual;
  
  if(input.contains(pn)) {
      colorOut = #000000;
  }
  if(input.contains(pr)) {
      colorOut = #fb0d1c;
  }
  if(input.contains(pv)) {
      colorOut = #0f7f11;
  }
  if(input.contains(lim)) {
      colorOut = #FFFFFF;
  }
  return colorOut;
}

void movePos(String input) {
  if(input.contains(arr)) {
      posY--;
  }
  if(input.contains(aba)) {
      posY++;
  }
  if(input.contains(izq)) {
      posX--;
  }
  if(input.contains(der)) {
      posX++;
  }
}

/********************* Controller Events *********************/

void playButton() {
  /* Clean grid */
  board = new color[sizeY][sizeX];
  for (int x = 0; x < sizeX; x++) {
    for (int y = 0; y < sizeY; y++) {
      board[y][x] = #FFFFFF;
    }
  }
  renderGrid();
  
  posX = startX;
  posY = startY;
  li = 0;
  readCode = true;
}

void stopButton() {
  readCode = false;
  
  /* Clean grid */
  board = new color[sizeY][sizeX];
  for (int x = 0; x < sizeX; x++) {
    for (int y = 0; y < sizeY; y++) {
      board[y][x] = #FFFFFF;
    }
  }
  renderGrid();
}

void velSlider(int value) {
  velocity = value;
}
