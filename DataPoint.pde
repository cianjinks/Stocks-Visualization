/**
 
 Created By: Cian O'Grady
 This class holds the information about each stock. It cointains a load of getters and setters as well as a constructor.
 
 **/

class DataPoint {

  String ticker;
  double openPrice;
  double closePrice;
  double adjustedClose;
  double low;
  double high;
  int volume;
  String date;
  Date dateFull;

  DataPoint(String t, double oP, double cP, double aC, double l, double h, int v, String d) {
    ticker = t;
    openPrice = oP;
    closePrice = cP;
    adjustedClose = aC;
    low = l;
    high = h;
    volume = v;
    date = d;
    println("[INIT] Adding Stock from " + d + " for " + t);
  }
  
  void setTicker(String ticker) {
    this.ticker = ticker;
  }

  void setOpenPrice(double openPrice) {
    this.openPrice = openPrice;
  }

  void setClosePrice(double closePrice) {
    this.closePrice = closePrice;
  }

  void setAdjustedClose(double adjustedClose) {
    this.adjustedClose = adjustedClose;
  }

  void setLow(double low) {
    this.low = low;
  }

  void setHigh(double high) {
    this.high = high;
  }

  void setVolume(int volume) {
    this.volume = volume;
  }

  void setDate(String date) {
    this.date = date;
  }

  String getTicker() {
    return ticker;
  }

  double getOpenPrice() {
    return openPrice;
  }

  double getClosePrice() {
    return closePrice;
  }

  double getAdjustedClose() {
    return adjustedClose;
  }

  double getLow() {
    return low;
  }

  double getHigh() {
    return high;
  }

  int getVolume() {
    return volume;
  }

  String getDate() {
    return date;
  }

  // Return the time in seconds for this specific stock
  public long getTime() {
    return Time.parseDate(date);
  }
  
}
