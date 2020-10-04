//added by matt, used for searching in search boxes
class TextWidget  { 
  int x, y, width, height; 
  String label; 
  int event; 
  color widgetColor, labelColor; 
  PFont widgetFont;
  int maxlen;
  TextWidget(int x, int y, int width, int height, String label, color widgetColor, PFont font, int event, int maxlen) { 
    this.x=x; 
    this.y=y; 
    this.width = width; 
    this.height= height; 
    this.label=label; 
    this.event=event; 
    this.widgetColor=widgetColor; 
    this.widgetFont=font; 
    labelColor=color(0); 
    this.maxlen=maxlen;
  } 
  /*
    TextWidget(int x, int y, int width, int height, String label, color widgetColor, PFont font, int event, int maxlen) { 
    this.x=x; 
    this.y=y; 
    this.width = width; 
    this.height= height; 
    this.label=label; 
    this.event=event; 
    this.widgetColor=widgetColor; 
    this.widgetFont=font; 
    labelColor=color(0); 
    this.maxlen=maxlen;
  } 
  
*/  
  
  void append(char s) { 
    if (s==BACKSPACE) { 
      if (!label.equals("")) label=label.substring(0, label.length()-1);
    } else if (label.length() <maxlen) label=label+str(s);
  }
  
  void draw() { 
    stroke(255);
    fill(widgetColor); 
    rect(x, y, width, height); //noStroke();
    fill(labelColor); 
    textFont(widgetFont);
    text(label, x, y,  (x+width -30), y+height);
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
