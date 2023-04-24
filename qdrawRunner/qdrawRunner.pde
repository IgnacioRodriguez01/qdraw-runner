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

void setup() {
  size(500, 500);
  background(255);
  stroke(#d8d8d8);

  lines = loadStrings("qdraw.txt");
  
  //Verify code
  for (int i = 0 ; i < lines.length; i++) {
    startBoard(lines[i]);
    //Agregar syntax errors...
  }

  //Initialize board
  board = new color[sizeY][sizeX];
  for (int x = 0; x < sizeX; x++) {
    for (int y = 0; y < sizeY; y++) {
      board[y][x] = #FFFFFF;
    }
  }
  
}

void draw() {
  posX = startX;
  posY = (sizeY-1)-startY; //Invert Y axis
  
  //Read code, write board
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
  for (int x = 0; x < sizeX; x++) {
    for (int y = 0; y < sizeY; y++) {
      fill(board[y][x]);
      square(x*25, y*25, 25);
    }
  }
  
  noLoop();
}
