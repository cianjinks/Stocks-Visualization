//added by Matt
public class BusinessComparasionHighStock implements Comparator<Business> { //sorts businesses by all time high stocks
  public int compare(Business t1, Business t2) {
    return (int)(t2.getMaxPrice() - t1.getMaxPrice()); //getMostRecentPrice
    // return (int)(t2.getMostRecentPrice() - t1.getMostRecentPrice());
  }
}


public class alphabeticalComp implements Comparator<Business> { //sorts business array in alphabetical order
  @Override
    public int compare(Business o1, Business o2) {
    return o1.getBusinessName().compareTo(o2.getBusinessName());
  }
}
//added by Eimhin
//Sort by ticker alphabetical
public class alphabeticalTicker implements Comparator<Business> { //sorts business array in alphabetical order
  @Override
    public int compare(Business o1, Business o2) {
    return o1.getTicker().compareTo(o2.getTicker());
  }
}
//Sort by sector alphabetical
public class alphabeticalSector implements Comparator<Business> { //sorts business array in alphabetical order
  @Override
    public int compare(Business o1, Business o2) {
    return o1.getSector().compareTo(o2.getSector());
  }
}
//Sort by exchange alphabetical
public class alphabeticalExchange implements Comparator<Business> { //sorts business array in alphabetical order
  @Override
    public int compare(Business o1, Business o2) {
    return o1.getStockExchange().compareTo(o2.getStockExchange());
  }
}
//Sort by current value (most recent close price
public class currentPriceSort implements Comparator<Business> {
  @Override
    public int compare(Business t1, Business t2) {

    double price1 = -1;
    double price2 = -1;
    if (!t1.stocks.isEmpty()) {
      price1 = t1.stocks.get(0).getClosePrice();
    }
    if (!t2.stocks.isEmpty()) {
      price2= t2.stocks.get(0).getClosePrice();
    }
    return (int)(price2 - price1 ); 
  }
}
//Sort by percentage change all time
public class sortByPercentageChange implements Comparator<Business> {
  @Override
    public int compare(Business t1, Business t2) {

    double percentageChange1 = Integer.MAX_VALUE;
    double percentageChange2 = Integer.MAX_VALUE;
    if (!t1.stocks.isEmpty()) {
      percentageChange1 = t1.getPercentageChange();
    }
    if (!t2.stocks.isEmpty()) {
      percentageChange2 = t2.getPercentageChange();
    }
    return (int)(percentageChange1 - percentageChange2 ); 
  }
}
//Sort by value gained all time
public class biggestGain implements Comparator<Business> {
  @Override
    public int compare(Business t1, Business t2) {

    double gain1 = Integer.MIN_VALUE;
    double gain2 = Integer.MIN_VALUE;
    if (!t1.stocks.isEmpty()) {
      gain1 = ((t1.stocks.get(0).getClosePrice() - t1.stocks.get(t1.stocks.size() - 1).getOpenPrice()) * 1000);
    }
    if (!t2.stocks.isEmpty()) {
      gain2 = ((t2.stocks.get(0).getClosePrice() - t2.stocks.get(t2.stocks.size() - 1).getOpenPrice())* 1000);
    }
    return (int)(gain2 -  gain1); 
  }
}
