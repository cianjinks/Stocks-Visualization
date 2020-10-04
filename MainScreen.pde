/**
 
 Created By: Matthew Thompson
 This class holds displays all the businesses to the user as well as all methods to sort the dataset.
 Updates:
 
 
 **/

class MainScreen {
  ArrayList<Business> searchBusinesses;
  ArrayList<Business> defaultBusinesses;
  ArrayList<Business> businessesWithStocks;
  ArrayList<Widget> dropDownWidgets;
  boolean displayDropDown = false;
  boolean isBusinessWithStocksOnly = false;
  int firstIndexOnScreen, lastIndexOnScreen;
  int numOfRowsOnScreen = 14;
  
  ArrayList<Widget> Widgets;
  Widget highPrice;
  Widget alphabetical; 
  Widget scrollDownWidget;
  Widget sortByBiggestGainWidget;
  Widget dropDownWidget;
  Widget sortByPercentageChangeWidget;
  Widget dropDownSearchWidget;

  float scrollBarX = 1255, scrollBarY;

  color backgroundColor = color(52, 52, 52);
  color textColor = color(170, 170, 170);
  color priceColor = color(94, 150, 196);
  color black = color(0);
  PFont priceFont = loadFont("Monospaced.italic-18.vlw");
  PFont mainScreenFont = loadFont("SansSerif.plain-30.vlw");
  PFont mainScreenFont2 = loadFont("SansSerif.plain-18.vlw");
  PFont companyNameFont = loadFont("Arial-Black-8.vlw");
  PFont searchFont = loadFont("SitkaDisplay-Bold-26.vlw");
  PFont dropDownFont = loadFont("Monospaced.bold-16.vlw");
  PFont topBarFont = mainScreenFont2;
  int rowSize = 55;
  int columnSize = 185;
  int amountOfRows = 20;
  int amountOfColumns = 5;
  int startOfTable =0;
  int dropDownX = 1120; 
  int dropDownY = 140;
  int dropDownRowSize = 44;
  int dropDownColumnSize= 155;
  TextWidget search;
  public int searchEvent = 666666;
  boolean defaultBusinessesSet = false;
  int startOfList = 20; //leave as 0 for now
  int startBusiness;
  int yOffset = 0;
  int yHeader = 30;
  boolean dropDownSortStatus = false;
  boolean dropDownSearchStatus = false;
  int dropDownSearchY = 50;
  int scrollSpeed = 8;
  int xSel = 807;

  MainScreen() {
    //for (int i = 0; i > uniqueBusinesses.size(); i++){
    // Business business = uniqueBusinesses.get(i);
    // Widget widget = business.

    defaultBusinesses= new ArrayList<Business>();
    searchBusinesses = new ArrayList<Business>();

    println("[INIT] Creating Main Screen");  
    //for setting up sorting drop down
    dropDownWidget = new Widget("Sort By:", DROP_DOWN, dropDownX, dropDownY, dropDownColumnSize, dropDownRowSize, dropDownFont, color(209, 224, 224)) ;
    highPrice = new Widget("High to Low (ALL TIME)", SORT_MAIN_HIGH_PRICE, -1000, 100, dropDownColumnSize, dropDownRowSize, dropDownFont, color(209, 224, 224)) ; // set off screen for dropdown
    alphabetical = new Widget("Show Business with Data Only", SORT_MAIN_ALPHA, -1000, 136, dropDownColumnSize, dropDownRowSize, dropDownFont, color(209, 224, 224)); // set off screen 
    sortByPercentageChangeWidget = new Widget("Percentage Change", SORT_PERCENTAGE_CHANGE, -1000, 379, dropDownColumnSize, dropDownRowSize, dropDownFont, color(209, 224, 224));
    sortByBiggestGainWidget = new Widget("Biggest Gain", BIGGEST_GAIN, -1069, 231, dropDownColumnSize, dropDownRowSize, dropDownFont, color(209, 224, 224));
    //for sorting search drop down    
    dropDownSearchWidget = new Widget("Search By:", SEARCH_DROP_DOWN, dropDownX, dropDownSearchY, dropDownColumnSize, dropDownRowSize, dropDownFont, color(209, 224, 224));
    search = new TextWidget(SCREEN_X - columnSize, -1000, dropDownColumnSize, dropDownRowSize, "", color(151, 151, 151), searchFont, searchEvent, 6);

    ticker = new Widgets (10, 5, 100, 24, "Ticker", 1, black, textColor, topBarFont);
    companyName = new Widgets (180, 5, 150, 24, "Company Name", 2, black, textColor, topBarFont);
    exchange = new Widgets (370, 5, 120, 24, "Exchange", 3, black, textColor, topBarFont);
    sector = new Widgets (545, 5, 120, 24, "Sector", 4, black, textColor, topBarFont);
    value = new Widgets (730, 5, 100, 24, "Value", 5, black, textColor, topBarFont);
    firstIndexOnScreen = 0;
    lastIndexOnScreen = firstIndexOnScreen + numOfRowsOnScreen;
  }

  public void draw() {
    noStroke();
    amountOfRows = uniqueBusinesses.size();
    background(backgroundColor);
    firstIndexOnScreen = abs(yOffset / 50); //our first element drawn is the offset for y didvided by 50
    lastIndexOnScreen = firstIndexOnScreen + numOfRowsOnScreen;
    if(lastIndexOnScreen < uniqueBusinesses.size()){
      //do nothing
    }else{
      lastIndexOnScreen = uniqueBusinesses.size();
    }
    if (uniqueBusinesses != null) {
      for (int k=0; k < uniqueBusinesses.size(); k++) 
      {        
        Business business = uniqueBusinesses.get(k);
        //drawing widget
        Widget widget = business.getWidget(((0)), yHeader + (yOffset+ (k * rowSize) ));
        widget.draw();
        fill(textColor);
        textFont(mainScreenFont);
        noFill();
        //drawing ticker
        String ticker = business.getTicker();
        fill(textColor);
        textFont(mainScreenFont);
        text( ticker, (startOfTable + 10 ), yHeader +( yOffset+  (k * rowSize) + 12 ), columnSize, rowSize ); //figures here are just offset to center the text a bit better
        noFill();
        //------- drawing BUSINESS NAMES to table
        String companyName = business.getBusinessName();
        fill(textColor);
        textFont(companyNameFont);
        text( companyName, (startOfTable + (1 * columnSize) ), yHeader +yOffset+ ((k * rowSize) + 7 ), columnSize, rowSize ); //text(str, x1, y1, x2, y2) wraps text in box.....figures here are just offset to center the text a bit better+++++  !!(1 * columnSize) refers to the 2nd Column
        noFill();
         //------- drawing EXCHANGE to table
        String stockExchange = business.getStockExchange();
        fill(textColor);
        textFont(mainScreenFont2);
        text( stockExchange, ((2 * columnSize) + 10), yHeader +yOffset+  ((k * rowSize) + 12), columnSize -10, rowSize ); //figures here are just offset to center the text a bit better+++++  !!(1 * columnSize) refers to the 2nd Column
        noFill();
        // drawing sector to table
        String sector =  business.getSector();
        fill(textColor);
        textFont(mainScreenFont2);
        text( sector, ((3 * columnSize)), yHeader + yOffset+ ((k * rowSize) + 12 ), columnSize, rowSize ); //figures here are just offset to center the text a bit better+++++  !!(1 * columnSize) refers to the 2nd Column
        noFill();
        
        // drawing most recent price 
        double mostRecentPrice =  business.returnMostRecentPrice();
        String price = String.format ("%.2f", mostRecentPrice);
        fill(priceColor);
        textFont(priceFont);
        text( "$" +price, ((4 * columnSize)), yHeader +yOffset+  ((k * rowSize) + 12 ), columnSize, rowSize ); //figures here are just offset to center the text a bit better+++++  !!(1 * columnSize) refers to the 2nd Column
        noFill();
        
        //drawing preview graph 
        business.drawPreview(((5 * columnSize)), yHeader + yOffset+ ((k * rowSize)  ));
        noFill();
      }
    } //end of drawing businesses
    //draw drop down menu
    textAlign(CENTER);
    dropDownWidget.draw();
    dropDownSearchWidget.draw();
    textAlign(LEFT);

    if (dropDownSortStatus) {
      sortByPercentageChangeWidget.draw();
      highPrice.draw();
      alphabetical.draw();
      sortByBiggestGainWidget.draw();
    }


    //draw drop down search box
    if (dropDownSearchStatus) {
      search.draw();
    }

    //draw search for tickers
    fill(textColor);
    textFont(mainScreenFont);
    search.draw();


    //Top selection bar -added by Eimhin
    noStroke();
    fill(black);
    rect(0, 0, 1280, 30);
    ticker.draw();
    companyName.draw();
    exchange.draw();
    sector.draw();
    value.draw();
    text("Graph (All Time)", 945, 20);

    //draw scrollBar
    rect(scrollBarX, scrollBarY, scrollBarWidth, scrollBarHeight);
    fill(0);
    updateScrollBarDrawPosition();
    //end of draw
    
    //selected sort
    fill(100);
    rect (xSel,10 , 5, 5);
  }

  public  void sortByAlphabetical() {
    //sorts unique Business array in alpahbetical order
    yOffset = 0;
    Collections.sort(uniqueBusinesses, new alphabeticalComp());
  }


  public void sortBySearch(String label) {
    //Function which takes a ticker and searches the unique businesses array and adjusts the uniqueBusinesses array if a match is found
    yOffset = 0;
    if (!defaultBusinessesSet) {
      for (int i = 0; i < uniqueBusinesses.size(); i++) {
        Business business = uniqueBusinesses.get(i);
        defaultBusinesses.add(business);
      }
      defaultBusinessesSet = true;
    }
    searchBusinesses = new ArrayList<Business>();
    uniqueBusinesses = defaultBusinesses;



    for (int i = 0; i < uniqueBusinesses.size(); i++) {
      Business business = uniqueBusinesses.get(i);
      String ticker = business.getTicker();
      if (label.equalsIgnoreCase(ticker)) {
        searchBusinesses.add(business);
        break;
      }
    }
    if (label.equals("")) {
      uniqueBusinesses = defaultBusinesses;
    } else {
      uniqueBusinesses = searchBusinesses;
    }
  }
    public void sortByTicker() {
    yOffset = 0;
    Collections.sort(uniqueBusinesses, new alphabeticalTicker());
  }
    public void sortBySector() {
    yOffset = 0;
    Collections.sort(uniqueBusinesses, new alphabeticalSector());
  }
    public void sortByExchange() {
    yOffset = 0;
    Collections.sort(uniqueBusinesses, new alphabeticalExchange());
  }
    public void sortByCurrentPrice() {
    yOffset = 0;
    Collections.sort(uniqueBusinesses, new currentPriceSort());
  }
  public void sortByLargestPriceChange() {
    yOffset = 0;
    Collections.sort(uniqueBusinesses, new BusinessComparasionHighStock());
  }

  public void sortByBiggestGain() {
    yOffset = 0;
    Collections.sort(uniqueBusinesses, new biggestGain());
  }

  public void sortByPercentageChange() {
    yOffset = 0;
    Collections.sort(uniqueBusinesses, new sortByPercentageChange());
  }

  public void scrollDown() {
    //Scrolls down the main screen
    //System.out.println(yOffset);
    if (yOffset < 0) {
      yOffset += scrollSpeed;
    }
  }
  public void scrollUp() {
    // scroll up the mainscreen
    if (uniqueBusinesses.size()> 20) {
      //System.out.println(yOffset);
      yOffset -= scrollSpeed;
    }
  }

  public void scrollUp2() {
    //alternative scrolling feature
    Collections.rotate(uniqueBusinesses, -1);
  }

  public void scrollDown2() {
     //alternative scrolling feature
    Collections.rotate(uniqueBusinesses, 1);
  }
  
  public void setDropDown() {
    if (!dropDownSortStatus) {
      dropDownSortStatus = true;
      highPrice.setXandY(dropDownX, dropDownY +  dropDownRowSize);
      alphabetical.setXandY(dropDownX, dropDownY + 2 * dropDownRowSize);
      sortByPercentageChangeWidget.setXandY(dropDownX, dropDownY + 3 * dropDownRowSize);
      sortByBiggestGainWidget.setXandY(dropDownX, dropDownY + 4 * dropDownRowSize);
    } else {
      alphabetical.setXandY(-1000, 0);
      highPrice.setXandY(-1000, 0);
      sortByPercentageChangeWidget.setXandY(-1000, 0);
      sortByBiggestGainWidget.setXandY(-1000, 0);
      dropDownSortStatus = false;
    }
  }

  public void setSearchDropDown() {
    if (!dropDownSearchStatus) {
      dropDownSearchStatus = true;
      search.setXandY(dropDownX, dropDownSearchY +  dropDownRowSize);
    } else {
      search.setXandY(-1000, 0);
      dropDownSearchStatus = false;
    }
  }


  public void updateScrollBarDrawPosition() {
    //moves the scroll bar up and down the screen
    if (uniqueBusinesses.size()!=0) {
      if (yOffset != 0) {
        // Equation for handling the scroll bar position on screen - Cian and Matt
        scrollBarY = (-(float)yOffset/((float)uniqueBusinesses.size() * (float)rowSize)) * (float)SCREEN_Y;
        scrollBarY += scrollBarHeight;
        //System.out.println(scrollBarHeight);
      }
    }
  }
  
  public void onlyShowBusinessesWithStocks(){
    //adjusts uniqueBusinesses array to only display business with stocks
        yOffset = 0;
        if(!isBusinessWithStocksOnly){
    if (!defaultBusinessesSet) {
      for (int i = 0; i < uniqueBusinesses.size(); i++) {
        Business business = uniqueBusinesses.get(i);
        defaultBusinesses.add(business);
      }
      defaultBusinessesSet = true;
    }
    businessesWithStocks = new ArrayList<Business>();
    uniqueBusinesses = defaultBusinesses;
    
        for (int i = 0; i < uniqueBusinesses.size(); i++) {
      Business business = uniqueBusinesses.get(i);
      double price = business.returnMostRecentPrice();
      if (price > 0) {
        businessesWithStocks.add(business);
      }
    }
    
    uniqueBusinesses = businessesWithStocks;
    isBusinessWithStocksOnly = true;
    } else{
      uniqueBusinesses = defaultBusinesses;
      isBusinessWithStocksOnly = false;
    }
    
  }
  
  public int getFirstDrawnBusiness(){
    //finds which business is drawn at top of the screen
    return firstIndexOnScreen;
  }
  
    public int getLastDrawnBusiness(){
      //finds business drawn at end of screen
    return lastIndexOnScreen;
  }
}
