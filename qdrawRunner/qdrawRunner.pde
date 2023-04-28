/************************************************************************************/
/*  ^    ^                                                                          */
/* Ejecutar/                                                                        */
/*  Detener                                                                         */
/*                                  QDRAW RUNNER                                    */
/*                              By Ignacio Rodriguez                                */
/*                                                                                  */
/*                                                                                  */
/*                                                                                  */
/*                                                                                  */
/************************************************************************************/

import java.util.Arrays;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

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
int x = 0;
int y = 0;
int li = 0;
int frameRateValue = 1;

/********************* Classes *********************/

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

/********************* Setup *********************/

void setup() {
  size(500, 500);
  background(255);
  stroke(#d8d8d8);
  frameRate(frameRateValue);

  lines = loadStrings("qdraw.txt");
  
  /* Check syntax errors (WIP) */
  verifySyntax(lines);
  
  /* Read code structures */
  readCode(lines);
  
  for (int i = 0 ; i < lines.length; i++) {
    startBoard(lines[i]);
    //println(lines[i]);
  }

  /* Initialize board */
  board = new color[sizeY][sizeX];
  for (int x = 0; x < sizeX; x++) {
    for (int y = 0; y < sizeY; y++) {
      board[y][x] = #FFFFFF;
    }
  }
  
  /* Compile code structures */
  lines = compileCode(lines);
  
  posX = startX;
  posY = startY;
}

/********************* Draw *********************/

void draw() {
  int centerStartX = (width - 25*sizeX)/2;
  int centerStartY = (height - 25*sizeY)/2;
  
  /* Execute commands, write board, draw */
  if(li < lines.length) {
    movePos(lines[li]);
    
    if(posX < 0 || posX > sizeX-1) {
      println("Error: Fuera de límite en el eje X");
      exit();
    }
    if(posY < 0 || posX > sizeY-1) {
      println("Error: Fuera de límite en el eje Y");
      exit();
    }
    board[posY][posX] = paint(lines[li], board[posY][posX]);
    
    background(255);
    for (int x = 0; x < sizeX; x++) {
      for (int y = 0; y < sizeY; y++) {
        fill(board[y][x]);
        stroke(#d8d8d8);
        square(centerStartX + x*25, centerStartY + y*25, 25); //Variable size?
      }
    }
    
    textAlign(CENTER, BOTTOM);
    fill(0);
    text(lines[li], width/2, centerStartY + 25*sizeY + 25);
    
    strokeWeight(2);
    noFill();
    stroke(#03a9fc);
    square(centerStartX + startX*25, centerStartY + startY*25, 25);
    stroke(#ff7601);
    square(centerStartX + posX*25, centerStartY + posY*25, 25);
    strokeWeight(1);
    
    li++;
    return;
  }
  
  String text = String.format("Finalizado en (%d, %d)", posX, sizeY-posY-1);
  textAlign(CENTER, BOTTOM);
  fill(0);
  text(text, width/2, centerStartY + 25*sizeY + 25);
  
  noLoop();
}

/********************* Initialize methods *********************/

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

void readCode(String[] linesArr) {
  String text, regex;
  Pattern p;
  Matcher m;
  Prog prog;
  
  text = join(linesArr, "\n");
  //println(text);}
  int count = 0;
  
  //Program
  regex = "programa\\s+\\{([\\s\\w()]+)\\}";
  p = Pattern.compile(regex, Pattern.DOTALL );
  m = p.matcher(text);
  
  m.find();
  println("Prog" + count);
  println(m.group(1)); //Code
  
  prog = new Prog();
  prog.set(m.group(1));
  
  //Procedures
  regex = "procedimiento\\s(\\w+)(?:\\(\\))\\s+\\{([\\s\\w()]+)\\}";
  p = Pattern.compile(regex, Pattern.DOTALL );
  m = p.matcher(text);

  while(m.find()) {
    println("Proc" + count);
    println(m.group(1)); //Name
    println(m.group(2)); //Code
    
    Proc obj = new Proc();
    obj.set(m.group(1), m.group(2));
    procList[count] = obj;

    count++;
  }
  count = 0;
  
  //Loops
  regex = "repetir\\s+(\\d+)\\s+veces\\s+\\{([\\s\\w()]+)\\}";
  p = Pattern.compile(regex, Pattern.DOTALL );
  m = p.matcher(text);

  while(m.find()) {
    println("Loop" + count);
    println(m.group(1)); //N
    println(m.group(2)); //Code
    
    Loop obj = new Loop();
    obj.set(int(m.group(1)), m.group(2));
    loopList[count] = obj;
    
    count++;
  }
  count = 0;
}

String[] compileCode(String[] linesArr) {
  String text, regex;
  Pattern p;
  Matcher m;
  text = join(linesArr, "\n");
  //println(text);
  
  /* Program */
  regex = "programa\\s+\\{([\\s\\w()]+)\\}";
  p = Pattern.compile(regex, Pattern.DOTALL );
  m = p.matcher(text);
  m.find();
  text = m.group(0);
  
  /* Comments */ 
  regex = "\\/\\*[\\s\\w()]+\\*\\/";
  p = Pattern.compile(regex, Pattern.DOTALL );
  m = p.matcher(text);
  while(m.find()) {
    text = text.replace(m.group(0), "");
  }
  
  /* Procedures */
  for(int i = 0; i < procList.length; i++) {
    if(procList[i] == null) {break;}
    
    regex = String.format("%s\\(\\)(?!\\s+\\{)", procList[i].name);

    p = Pattern.compile(regex, Pattern.DOTALL );
    m = p.matcher(text);
    while(m.find()) {
      text = text.replace(m.group(0), procList[i].name + procList[i].code);
      println(text);
    }
  }
  
  /* Loops */
  
  
  /*
  //Empty lines 
  text = text.trim();
  regex = "^\\s*$";
  p = Pattern.compile(regex, Pattern.MULTILINE );
  m = p.matcher(text);
  while(m.find()) {
    text = text.replace(m.group(0), "");
  }
  */
  
  text = text.replace("}", "");
  String[] result = split(text, "\n");
  for(int i= 0; i< result.length; i++) {
    println(result[i]);
  }
  return result;
}

/********************* Draw methods *********************/

public color paint(String input, color actual) {
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
