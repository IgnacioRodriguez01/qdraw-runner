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
  
  println(text);
  
  //Separate between nested and not nested structures
  
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
  
  /* Loops */
  regex = "repetir\\s+(\\d+)\\s+veces\\s*\\{(.*?)\\}";
  p = Pattern.compile(regex, Pattern.DOTALL );
  m = p.matcher(text);
  while(m.find()) {
    String loopCode = "";
    for(int i = 0; i < int(m.group(1)); i++) {
      loopCode = loopCode + m.group(2);
    }
    //text = text.replace(m.group(0), loopCode);
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
  
  text = text.replace("}", "");
  String[] result = split(text, "\n");
  for(int i= 0; i< result.length; i++) {
    //println(result[i]);
  }
  return result;
}
