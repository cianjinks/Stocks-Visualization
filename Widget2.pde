/**

  Created By: Eimhin Campbell Carroll  //<>//
  This file is used to create widgets for infoScreen.

**/
class Widgets {  //<>//
  
  int x, y, height, width;
  String label;
  int event;
  color widgetColour, labelColour;
  PFont widgetFont;
  boolean stroke = false;

  Widgets(int x, int y, int width, int height, String label, int event, color widgetColour, color labelColour, PFont widgetFont) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.label = label;
    this.event = event;
    this.widgetColour = widgetColour;
    this.widgetFont = widgetFont;
    this.labelColour = labelColour;
  }

  void draw() {
   //Draw the basic widget box with text inside
    fill(widgetColour);
    rect(x, y, width, height);
    fill(labelColour);
    textFont(widgetFont);
    text(label, x + 10, y + height - 10);
    
  }
  //Check if the coordintates passed are within widget bounderies.
  int getEvent (int mX, int mY) {
    if (mX > x && mX < x + width && mY > y && mY < y + height) {
      return event;
    }
    return 0;
  }
}
