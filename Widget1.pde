/**

  Created By: Matt
  Used for business widgets and all widgets on main screen

**/
class Widget { 
  int x, y, width, height; 
  String label; 
  int event; 
  color widgetColor, labelColor; 
  PFont widgetFont;
  boolean isStroke = false;
  Widget(String label, int event) {// Used to link the main screen to the info screens, 
   /* this.x=x; 
    this.y=y; 
    this.width = width; 
    this.height= height; */
   // this.label=label; 
    this.event=event; 
   // this.widgetColor=widgetColor; 
    //this.widgetFont=widgetFont; 
    labelColor= color(255);
    widgetFont = loadFont("Arial-Black-18.vlw");
     widgetColor = color(52, 52, 52);
    this.label = " ";
    width = 720;
    height = 50;
   // width1
  } 
  
   Widget(String label, int event, int x, int y, int width, int height, PFont widgetFont, color widgetColor) { //int x, int y, int width, int height, 
    this.x=x; 
    this.y=y; 
    this.width = width; 
    this.height= height; 
    this.label=label; 
    this.event=event; 
    this.widgetColor=widgetColor; 
    this.widgetFont=widgetFont; 
    labelColor= color(0);
    //widgetFont = loadFont("Arial-Black-18.vlw");
     //widgetColor = color(52, 52, 52);
    //width = 720;
    //height = 35;
  } 
  
  void setStroke(boolean set) {
  isStroke = set;
}
 
  void draw() { 
    if (isStroke){
    stroke(255);
    }
    else {
    noStroke();
  }
    fill(widgetColor); 
    rect(x, y, width, height); //noStroke();
    fill(labelColor); 
    textFont(widgetFont);
    text(label, x + 2, y + height / 2 - 8,  (width ), (height) );
  } 
  int getEvent(int mX, int mY) { 
    if (mX>x && mX < x+width && mY >y && mY <y+height) { 
      return event;
    } 
    return EVENT_NULL;
  }
  
  void setXandY(int x, int y){
    this.x = x;
    this.y = y;
  }
  
  
}
