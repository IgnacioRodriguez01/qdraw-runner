void readCode(String[] linesArr) {
  String text, regex;
  Pattern p;
  Matcher m;
  Prog prog;
  
  text = join(linesArr, "\n");
  int count = 0;
  
  //Program
  regex = "programa\\s*\\{(.*?)\\}";
  p = Pattern.compile(regex, Pattern.DOTALL );
  m = p.matcher(text);
  m.find();
  prog = new Prog();
  prog.set(m.group(1));
  
  //Procedures
  regex = "procedimiento\\s(\\w+\\(\\))\\s*\\{(.*?)\\}";
  p = Pattern.compile(regex, Pattern.DOTALL );
  m = p.matcher(text);
  while(m.find()) {
    Proc obj = new Proc();
    obj.set(m.group(1), m.group(2));
    procList[count] = obj;

    count++;
  }
  count = 0;
}
