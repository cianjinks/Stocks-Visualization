/**

 Created By: Cian Jinks
 This is the class for the graph. It is resizeable and can take in any time frame and display the stocks held in the passed in business for that period of time.
 Updates: (Weren't written until later)
 - Draw lines connecting stocks - Cian Jinks
 - Selecting of individual stocks by hovering nearest - Cian Jinks
 - Removed dots past a certain zoom - Cian Jinks
 - Added startDate and endDate at bottom by modifying constructor - Cian Jinks
 - Some error handling for no stocks - Cian Jinks
 - Moved font load to Main setup (Memory saved) - Eimhin 
 **/
class Graph {


  PFont graphFont = loadGraphFont;
  PFont graphFont2 = loadGraphFont2;
  PFont graphFont3 = loadGraphFont3;

  
  int x, y, width, height;
  color backgroundColor, strokeColor;
  Business business;
  long startTime, endTime, timePeriod;
  double yMax, yMin, xMax, xMin;
  ArrayList<DataPoint> stocks;
  ArrayList<Double> stockPositions;
  String startDate, endDate;
  boolean noStocks = false;

  Graph(int x, int y, int width, int height, color backgroundColor, color strokeColor, Business business, String startDate, String endDate) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.backgroundColor = backgroundColor;
    this.strokeColor = strokeColor;
    this.business = business;
    
    updateTimePeriod(startDate, endDate);
   
  }

  // This function will update the graphs time period to display a different one. This makes up a chunk of the constructor up above too.
  void updateTimePeriod(String startDate, String endDate) {
    // Make sure the date is not blank
    if(!startDate.equals("")) {
       this.startDate = startDate; 
    } else {
       this.startDate = "2018-08-24"; 
    }
    
    // Make sure the date is not blank
    if(!endDate.equals("")) {
      this.endDate = endDate;
    } else {
       this.endDate = "2018-08-24"; 
    }
    
    // If the dates passed are the same display the past week
    if(this.startDate.equals(this.endDate)) {
      this.startTime = Time.parseDate(this.startDate) - (24 * 60 * 60 * 7);
    } else {
      this.startTime = Time.parseDate(this.startDate);
    }
    this.endTime = Time.parseDate(this.endDate);
    this.timePeriod = endTime - startTime;

    this.yMax = business.getMaxPrice(startTime, endTime) + 0.4 * business.getMaxPrice(startTime, endTime); // The highest point of the graph (20% offset from maxPrice)
    this.yMin = 0;
    this.xMin = startTime - (0.05 * (endTime-startTime)); // The farthest left point of the graph (5% offset from the endTime)
    this.xMax = endTime + (0.05 * (endTime-startTime)); // The farthest right point of the graph (5% offset from the endTime)

    stocks = business.getStocks(startTime, endTime); 
    stockPositions = new ArrayList<Double>();
    
    // Check if the dataset has no stocks for the given business
    if(stocks.size() == 0) {
       noStocks = true; 
    } else {
       noStocks = false; 
    }
  }

  void draw() {

    stroke(strokeColor);
    strokeWeight(1);
    fill(backgroundColor);
    rect(x, y, width, height);
    fill(255, 0, 0);
    // Variables for the stock to be hovered's position
    int closestStockX = 0;
    int closestStockY = 0;
    DataPoint closestStock = null;
    if(noStocks == false) {
      closestStockX = getXForStock(stocks.get(0).getTime());
      closestStockY = getYForStock(stocks.get(0).getClosePrice());
      closestStock = stocks.get(0);
      for(int stock = 0; stock < stocks.size(); stock++) {
        noStroke();
        // Draw a red circle at each stocks point on the graph if the timePeriod is not over 3 months ish
        if(timePeriod <= (3 * 28 * 24 * 60 * 60)) {
          circle(getXForStock(stocks.get(stock).getTime()), getYForStock(stocks.get(stock).getClosePrice()), 6); 
        }
        // Determine stock closest to the mouse pointer
        if (abs(mouseX - getXForStock(stocks.get(stock).getTime())) < abs(mouseX - getXForStock(closestStock.getTime()))) {
          closestStockX = getXForStock(stocks.get(stock).getTime());
          closestStockY = getYForStock(stocks.get(stock).getClosePrice());
          closestStock = stocks.get(stock);
        }
        // Draw a green line connecting every stock
        if (stock != stocks.size() - 1) {
          stroke(0, 255, 0);
          strokeWeight(3);
          line(getXForStock(stocks.get(stock).getTime()), getYForStock(stocks.get(stock).getClosePrice()), getXForStock(stocks.get(stock + 1).getTime()), getYForStock(stocks.get(stock + 1).getClosePrice()));
        }
        noStroke();
        // Draw a red circle at each stocks point on the graph if the timePeriod is not over 3 months ish
        if(timePeriod <= (3 * 30 * 24 * 60 * 60)) {
          circle(getXForStock(stocks.get(stock).getTime()), getYForStock(stocks.get(stock).getClosePrice()), 6);
        }
      }
    } else {
       // Just display "NO STOCKS" if no stock data is available
       text("NO STOCKS", x + (width / 2) - (0.1 * width), y + (height / 2));
    }
    strokeWeight(1);
    stroke(150, 150, 150);
    fill(255);

    // Draw lines going across the screen
    textFont(graphFont);
    int xoffset = (height / 4) - 5;
    int yoffset = height / 40;
    line(x, y + height, x + width, y + height);
    text("$0", x - xoffset, y + height); 
    for (int i = 1; i <= 5; i++) {
      line(x, getYForStock((yMax/5) * i), x + width, getYForStock((yMax/5) * i));
      text(String.format("$%.3f", (yMax/5) * i), x - xoffset, getYForStock((yMax/5) * i) + yoffset);
    }
    
    // Draw dates at the bottom
    text(startDate, x, y + height + (height / 12));
    text(endDate, x + width - (width / 12), y + height + (height / 12));

    // Draw hovered stock information
    if(noStocks == false) {
      strokeWeight(1);
      line(closestStockX, y + height, closestStockX, closestStockY + 6);
      line(closestStockX, y, closestStockX, closestStockY - 6);
      noFill();
      stroke(173, 216, 230, 255);
      strokeWeight(3);
      circle(closestStockX, closestStockY, 12);
      textFont(graphFont);
      fill(255);
      noStroke();
      if (closestStockX < x + 170) {
        drawStockInformation(getXForStock(closestStock.getTime()) + 20, getYForStock(closestStock.getClosePrice()) - 100, 152, 80, closestStock.date, String.format("%.2f", closestStock.getOpenPrice()) 
        ,String.format("%.2f", closestStock.getClosePrice()));
      } else {
        drawStockInformation(getXForStock(closestStock.getTime()) - 170, getYForStock(closestStock.getClosePrice()) - 100, 152, 80, closestStock.date, String.format("%.2f", closestStock.getOpenPrice())  
        ,String.format("%.2f", closestStock.getClosePrice()));
      }
    }

    noStroke();
    fill(255, 0, 0);
    strokeWeight(1); // Fixes stroke weight on MainScreen
  }
  
  // This functions draws the information about a stock in a box when it is hovered
  void drawStockInformation(int x, int y, int width, int height, String date, String openPrice, String closePrice) {
    fill(255);
    rect(x, y, width, height);
    fill(0);
    text(date, x + 5, y + 20);
    textFont(graphFont2);
    text("$" + openPrice, x + 96, y + 43);
    text("$" + closePrice, x + 96, y + 68);
    textFont(graphFont2);
    fill(0, 0, 255, 255);
    text("Open Price:", x + 5, y + 43);
    fill(255, 165, 0, 255);
    text("Close Price:", x + 5, y + 68);

    fill(255);
    textFont(graphFont);
  }
  
  // Update the x and y position of the graph
  void updatePosition(int x, int y) {
      this.x = x;
      this.y = y;
  }

  // Gets the y value on the screen for the graph based on its price relative to its the yMax created in the constructor
  int getYForStock(double price) {
    return y + (int)(height - (height * (price/(yMax)))); // Convert price on y axis to y position on screen
  }

  // Gets the x value on the screen for the graph based on its time relative to its the xMax-xMin (an offset version of the timePeriod) created in the constructor
  int getXForStock(long time) {
    return x + (int)(width *  ((time-xMin)/(xMax-xMin)));
  }
}
