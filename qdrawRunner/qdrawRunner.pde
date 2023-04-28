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
import java.util.regex.Matcher;
import java.util.regex.Pattern;

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
String prog = "programa";
String[] punt = {"{", "}", "(", ")", "/*", "*/"};
//String[] prerec = {"sizeX", "sizeY", "startX", "startY"};


/********************* Classes *********************/

class Prog {
  int start, end;
  void set(int s, int e) {
    start = s;
    end = e;
  }
}
class Proc {
  int start, end;
  void set(int s, int e, String name) {
    start = s;
    end = e;
    name = name;
  }
}
class Loop {
  int start, end;
  void set(int s, int e) {
    start = s;
    end = e;
  }
}

Proc[] procList;
Loop[] loopList;

/********************* Setup *********************/

void setup() {
  size(500, 500);
  background(255);
  stroke(#d8d8d8);
  frameRate(30);

  lines = loadStrings("qdraw.txt");
  
  //Verify code
  for (int i = 0 ; i < lines.length; i++) {
    startBoard(lines[i]);
    //Agregar syntax errors...
    //Agregar lectura de procedimientos, loops, condiciones
    //try/catchs
    
    /*if (proc?) {
      append(procList, proc)
    }*/
    
    println(lines[i]);
  }
  readSyntax(lines);
  /*
  String[] linesStrip = Arrays.copyOfRange(lines, 0, 5);
  println("hola");
  
  for (int i = 0 ; i < linesStrip.length; i++) {
    println(linesStrip[i]);
  }*/

  //Initialize board
  board = new color[sizeY][sizeX];
  for (int x = 0; x < sizeX; x++) {
    for (int y = 0; y < sizeY; y++) {
      board[y][x] = #FFFFFF;
    }
  }
  
}

/********************* Draw *********************/

void draw() {
  posX = startX;
  posY = (sizeY-1)-startY; //Invert Y axis
  
  //Read code, write board (Execute)
  for (int i = 0 ; i < lines.length; i++) {
    movePos(lines[i]);
    
    if(posX < 0 || posX > sizeX-1) {
      println("Error: Fuera de límite en el eje X");
      exit();
    }
    
    if(posY < 0 || posX > sizeY-1) {
      println("Error: Fuera de límite en el eje Y");
      exit();
    }
    
    board[posY][posX] = paint(lines[i], board[posY][posX]);
  }
  
  //Draw board
  int centerStartX = (width - 25*sizeX)/2;
  int centerStartY = (height - 25*sizeY)/2;
  
  for (int x = 0; x < sizeX; x++) {
    for (int y = 0; y < sizeY; y++) {
      fill(board[y][x]);
      stroke(#d8d8d8);
      if (x == posX && y == posY) {
        stroke(#ff7601);
      }
      square(centerStartX + x*25, centerStartY + y*25, 25); //Variable size?
    }
  }
  
  //Final cursor
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
  }
}

void readSyntax(String[] linesArr) {
  String text;
  text = join(linesArr, " ");
  println(text);
  
  String regex = "procedimiento";
  Pattern pattern = Pattern.compile(regex, Pattern.CASE_INSENSITIVE | Pattern.DOTALL );
  Matcher matcher = pattern.matcher(text);
  boolean matchFound = matcher.find();
  println(matchFound);
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
