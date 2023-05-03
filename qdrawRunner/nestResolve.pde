String[] nestResolve(String[] linesArr) {
  String regex, text, textAlt;
  Pattern p;
  Matcher m;
  Block tempList[] = new Block[0];
  
  text = join(linesArr, "\n");
  textAlt = text;
  
  String progRegex = "programa\\s*\\{";
  String procRegex = "procedimiento\\s(\\w+\\(\\))\\s*\\{";
  String loopRegex = "repetir\\s+(\\d+)\\s+veces\\s*\\{";
  String condRegex = "si\\s*\\((.*?)\\)\\s+entonces\\s*\\{";
  
  //Openings and closings (Nesting processing)
  boolean flag = true;
  while(flag) {
    flag = false;
    
    regex = progRegex + "|" + procRegex + "|" + loopRegex + "|" + condRegex + "|" + "\\}";
    p = Pattern.compile(regex, Pattern.DOTALL );
    m = p.matcher(text);
    
    while(m.find()) {
      Block block;
      //Start
      if(m.group().contains("{")) {
        block = new Block();
        block.start(m.start());
        println("{ at " + block.start);
      
        //Types
        if(m.group().contains("programa")) {
          block.type("Prog");
        }
        if(m.group().contains("procedimiento")) {
          block.type("Proc");
        }
        if(m.group().contains("repetir")) {
          block.type("Loop");
        }
        if(m.group().contains("si")) {
          block.type("Cond");
        }
        
        tempList = push(tempList, block);
      }
      
      //End
      if(m.group().contains("}")) {
        block = tempList[tempList.length - 1];
        block.end = m.end();
        blockList = push(blockList, block);
        println("} at " + block.end);
        
        //Father block
        if(tempList.length == 1) {
          println("terminating");
          
        } else {
        //Child block
          
          //Assign contents
          String content = "";
          for(int x = block.start; x < block.end; x++) {
            content = content + text.charAt(x);
          }
          block.content(content);
          
          //Translate contents
          String label = String.format("$%s%d$", block.type, blockList.length-1);
          println(label);
          flag = true; //If theres new nestings, continue
          textAlt = textAlt.replace(block.content, label);
        }
        
        tempList = pop(tempList);
      }
      
    }//while(m.find())

    text = textAlt;
  }//while(flag)
  println(textAlt);
  
  String[] result = split(text, "\n");
  return result;
}

<T> T[] push(T[] arr, T item) {
    T[] tmp = Arrays.copyOf(arr, arr.length + 1);
    tmp[tmp.length - 1] = item;
    return tmp;
}

<T> T[] pop(T[] arr) {
    T[] tmp = Arrays.copyOf(arr, arr.length - 1);
    return tmp;
}
