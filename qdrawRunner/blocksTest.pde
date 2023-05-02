void blocksTest(String[] linesArr) {
  String regex, text;
  Pattern p;
  Matcher m;
  Block tempList[] = new Block[0];
  
  text = join(linesArr, "\n");
 
  regex = "\\{|\\}";
  p = Pattern.compile(regex, Pattern.DOTALL );
  m = p.matcher(text);
  while(m.find()) {
    
    if(m.group().contains("{")) {
      Block block = new Block();
      block.start(m.start());
      tempList = push(tempList, block);
      
      println("{ at " + block.start);
    }
    
    if(m.group().contains("}")) {
      Block block = tempList[tempList.length - 1];
      block.end = m.end();
      
      blockList = push(blockList, block);
      
      tempList = pop(tempList);
      println("} at " + block.end);
    }
    println(tempList.length);
    if(tempList.length == 0) {
      println("finished");
      break;
    }
  }
  
  for(int i = 0; i < blockList.length; i++) {
    println("start at " + blockList[i].start, "end at " + blockList[i].end);
    String result = "";
    for(int x = blockList[i].start; x < blockList[i].end; x++) {
      result = result + text.charAt(x);
    }
    println(result);
  }
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
