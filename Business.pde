/**
 
 Created By: Cian O'Grady
 This class stores the stocks of each specific business as well as info about the business. It also has many useful functions for querying stocks and data.
 Updates:
 Added getTime() function using the Time class - Cian Jinks
 Added functions to get max and minimum price for all time and between a given time period - Cian Jinks
 Added a function to get the latest date string of a business - Cian Jinks
 Added various functions for price data - Cian Jinks
 
 **/

class Business {

  String ticker;
  String stockExchange;  
  String businessName;
  String sector;
  String industry;
  ArrayList<DataPoint> stocks;
  int widgetReference;
  Widget screenLink; // links main screen to info screen
  double mostRecentPrice;
  PreviewGraph preview;
  double percentageChange;


  Business (String tick, String ex, String name, String sec, String ind, int widgetReference) {
    ticker = tick;
    stockExchange = ex;
    businessName = name;
    sector = sec;
    industry = ind;
    stocks = new ArrayList<DataPoint>();
    this.widgetReference = widgetReference;
    screenLink = new Widget(name, widgetReference);
    println("[INIT] Generating Business Object for " + tick);
  }
  
  String getTicker() {
    return ticker;
  }

  String getStockExchange() {
    return stockExchange;
  }

  String getBusinessName() {
    return businessName;
  }

  String getSector() {
    return sector;
  }

  String getIndustry() {
    return industry;
  }
  
  double getPercentageChange() {
    return percentageChange;
  }
  
  // Recalculates percentage change for a business
  public void updatePercentageChange(int start, int end) {
    if (!stocks.isEmpty()) {
      percentageChange = (((stocks.get(end).getClosePrice() - stocks.get(start).getOpenPrice()) / stocks.get(start).getOpenPrice() ) * 100);
    }
  }


  // Get the maximum price of all time for a business - Cian Jinks
  double getMaxPrice() {
    double maxPrice = 0;
    for (DataPoint stock : stocks) { 
      if (stock.getClosePrice() > maxPrice) {
        maxPrice = stock.getClosePrice();
      }
    }
    return maxPrice;
  }

  // Get the minimum price all time for a business - Cian Jinks
  double getMinPrice() {
    double minPrice = stocks.get(0).getClosePrice(); // Start with first element
    for (DataPoint stock : stocks) { 
      if (stock.getClosePrice() < minPrice) {
        minPrice = stock.getClosePrice();
      }
    }
    return minPrice;
  }

  Widget getWidget(int x, int y) {
    screenLink.setXandY(x, y);
    return screenLink;
  }

  void setWidgetXandY(int x, int y) {
    screenLink.setXandY(x, y);
  }

  void drawWidget() {
    screenLink.draw();
  }

  int getEvent(int x, int y) {
    return screenLink.getEvent(x, y);
  }



  int getWidgetReference() {
    return widgetReference;
  }

  // Get the maximum price for all stocks for this business between a given time frame - Cian Jinks
  double getMaxPrice(long startTime, long endTime) {
    double maxPrice = 0;
    for (DataPoint stock : stocks) { 
      if (stock.getTime() >= startTime && stock.getTime() <= endTime) {
        if (stock.getClosePrice() > maxPrice) {
          maxPrice = stock.getClosePrice();
        }
      }
    }
    return maxPrice;
  }

  // Get the minimum price for all stocks for this business between a given time frame - Cian Jinks
  double getMinPrice(long startTime, long endTime) {
    double minPrice = stocks.get(0).getClosePrice(); // Start with first element
    for (DataPoint stock : stocks) { 
      if (stock.getTime() >= startTime && stock.getTime() <= endTime) {
        if (stock.getClosePrice() < minPrice) {
          minPrice = stock.getClosePrice();
        }
      }
    }
    return minPrice;
  }

  // Return a subarray of a businesses stocks between a given timeframe - Cian Jinks 
  ArrayList<DataPoint> getStocks(long startTime, long endTime) {
    ArrayList<DataPoint> subStocks = new ArrayList<DataPoint>(); 
    for (DataPoint stock : stocks) { 
      if (stock.getTime() >= startTime && stock.getTime() <= endTime) {
        subStocks.add(stock);
      }
    }
    return subStocks;
  }

  // function to get the date for the latest stock entry of a business   -added by Matt 1/4/20
  public long getLastestDateEntry() {  

    if (stocks != null) {
      //long currentLatestDate = stocks.get(0).getTime();
      long currentLatestDate = 0;
      for (int i = 0; i < stocks.size(); i++) {
        DataPoint theStock = stocks.get(i);
        long tempDate = theStock.getTime();
        if (tempDate > currentLatestDate) {
          currentLatestDate = tempDate;
        }
      }
      return currentLatestDate;
    } else {
      return 0;
    }
  }

  // Get the latest date for a given business as a string - Cian Jinks 2/4/20
  public String getLatestDateString() {
    if(!stocks.isEmpty()) {
      return stocks.get(0).getDate();
    } else {
      return "";
    }
  }
  
  // Get the oldest date for a given business as a string - Cian Jinks 9/4/20
  public String getOldestDateString() {
    if(!stocks.isEmpty()) {
      return stocks.get(stocks.size() - 1).getDate();
    } else {
      return "";
    }
  }
  
  // Get the date of a stock a year in the past from the most recent stock for a given business - Cian 9/4/20
  public String getYearPastDateString() {
    String latestDate = getLatestDateString();
    if(!latestDate.equals("")) {
      long yearAgo = Time.parseDate(getLatestDateString()) - (365 * 24 * 60 * 60);
      String result = stocks.get(0).getDate();
      for(DataPoint stock : stocks) {
        if(Time.parseDate(stock.getDate()) < Time.parseDate(result) && Time.parseDate(stock.getDate()) > yearAgo) {
          result = stock.getDate();
        }
      }
      return result;
    }
    return "";
  }

  // function to get the most recent price of a companies stock  -- added by Matt 1/4/20
  public double getMostRecentPrice() { 
    long latestDate = getLastestDateEntry();

    double recentPrice = 0;
    for (DataPoint stock : stocks) { 
      if (stock.getTime() == latestDate) {

        recentPrice = stock.getClosePrice();
      }
    }
    return recentPrice;
  }
  
  public void setMostRecentPrice() {
    double price = getMostRecentPrice();
    mostRecentPrice = price;
  }

  public double returnMostRecentPrice() {
    return mostRecentPrice;
  }
  
  // Draw the preview graph for this business
  public void drawPreview(int x, int y) {
     preview.updatePosition(x, y);
     preview.draw(); 
  }
}
