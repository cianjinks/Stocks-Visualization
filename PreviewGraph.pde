/**
 
 Created By: Cian Jinks
 This is a preview graph for use on the main screen. 
 Updates:
 - Created a basic working version
 - Made the preview graph draw all stocks for all time
 - Made the "resolution" of the preview graph controllable
 
 **/
class PreviewGraph extends Graph {

  PreviewGraph(int x, int y, int width, int height, color backgroundColor, color strokeColor, Business business) {
    super(x, y, width, height, backgroundColor, strokeColor, business, business.getOldestDateString(), business.getLatestDateString());
    
    // This part of the constructor removes a certain number of stocks from the stocks array based on a "resolution" amount, 
    // this means the preview graph looks less blocky
    int divisor = (int)(stocks.size() / 100);
    if (divisor > PREVIEW_RESOLUTION) {
      ArrayList<DataPoint> tempStocks = new ArrayList<DataPoint>();
      for (int index = 0; index < stocks.size(); index++) {
        if (index % divisor == 0) {
          tempStocks.add(stocks.get(index));
        }
      }
      stocks = tempStocks;
    }
    println("[INIT] Generating Preview Graph for " + business.getTicker()); 
  }

  @Override
    void draw() {
    stroke(strokeColor);
    strokeWeight(1);
    fill(backgroundColor);
    rect(x, y, width, height);
    fill(255, 0, 0);
    noStroke();
    if (noStocks == false) {
      for (int stock = 0; stock < stocks.size(); stock++) {
        // Draw the lines connecting each stock
        if (stock != stocks.size() - 1) {
          stroke(0, 255, 0);
          strokeWeight(3);
          line(getXForStock(stocks.get(stock).getTime()), getYForStock(stocks.get(stock).getClosePrice()), getXForStock(stocks.get(stock + 1).getTime()), getYForStock(stocks.get(stock + 1).getClosePrice()));
        }
      }
    } else {
      // Just display "NO STOCKS" if no stock data is available
      text("NO STOCKS", x + (width / 2) - (0.3 * width), y + (height / 2));
    }

    fill(255);
    noStroke();
    strokeWeight(1); // Fixes stroke weight on MainScreen
  }
}
