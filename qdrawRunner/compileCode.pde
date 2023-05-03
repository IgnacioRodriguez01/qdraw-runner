String[] compileCode(String[] linesArr) {
  String text, regex;
  Pattern p;
  Matcher m;
  text = join(linesArr, "\n");

  println("****************************************************");
  
  /* Program */
  regex = "programa\\s*\\{(.*?)\\}";
  p = Pattern.compile(regex, Pattern.DOTALL );
  m = p.matcher(text);
  m.find();
  text = m.group(0);
    
  /* Procedures */
  for(int i = 0; i < procList.length; i++) {
    if(procList[i] == null) {break;}
    
    regex = String.format("%s\\(\\)(?!\\s+\\{)", procList[i].name);
    p = Pattern.compile(regex, Pattern.DOTALL );
    m = p.matcher(text);
    while(m.find()) {
      text = text.replace(m.group(0), procList[i].code);
    }
  }

  /* Blocks (Loops or Conditions) */
  boolean flag = true;
  
  regex = "\\$(\\w+)(\\d+)\\$";
  p = Pattern.compile(regex, Pattern.DOTALL );
  while(flag) {
    flag = false;
    m = p.matcher(text);
    
    while(m.find()) {
      flag = true;
      String regex2;
      String condContent = "";
      Pattern p2;
      Matcher m2, m3;
      
      switch(m.group(1)) {
        case "Loop": 
          
          regex2 = "repetir\\s+(\\d+)\\s+veces\\s*\\{(.*?)\\}";
          p2 = Pattern.compile(regex2, Pattern.DOTALL );
          m2 = p2.matcher(blockList[int(m.group(2))].content);
          m2.find();
          
          String loopCode = "";
          for(int i = 0; i < int(m2.group(1)); i++) {
            loopCode = loopCode + m2.group(2);
          }
          text = text.replace(m.group(0), loopCode);
          break;
        case "Cond":
          //Conditions: Dependant of cursor position.
          /*Must be compiled in a simple way, such that it can be executed in real
          time and and the decision be taken relative to the board color.*/
          regex2 = "si\\s*\\((.*?)\\)\\s+entonces\\s*\\{(.*?)\\}";
          p2 = Pattern.compile(regex2, Pattern.DOTALL );
          m2 = p2.matcher(blockList[int(m.group(2))].content);
          m2.find();
          
          //Check. Compile all contents of cond and then render?
          //Read and compile nested contents
          m3 = p.matcher(blockList[int(m.group(2))].content);
          while(m3.find()){
            //Use block compile in general?
            flag = true;
            break;
            //add to contents?
          }
          println(m2.group(2),"hola"); //? m2 solo una vez
          text = text.replace(m.group(0), m2.group(2));
          //Format all contents
          //Actual contents
          /*
          String content = m2.group(2).trim().replace("\t", "");
          contents = split(content, "\n");
          
          content = "";
          for(int i = 0; i < contents.length; i++){
            content = content + "\n" + String.format("$%s$%s", m2.group(1), contents[i]);
          }
          
          text = text.replace(m.group(0), content);*/
          break;
      }
    }
  }
 
  /*
  //Empty lines (WIP)
  text = text.trim();
  regex = "^\\s*$";
  p = Pattern.compile(regex, Pattern.MULTILINE );
  m = p.matcher(text);
  while(m.find()) {
    text = text.replace(m.group(0), "");
  }
  */
  
  /* Comments */ 
  regex = "\\/\\*(.*?)\\*\\/";
  p = Pattern.compile(regex, Pattern.DOTALL );
  m = p.matcher(text);
  while(m.find()) {
    text = text.replace(m.group(0), "");
  }
  
  println(text);
  
  
  text = text.replace("}", "");
  String[] result = split(text, "\n");
  return result;
}
