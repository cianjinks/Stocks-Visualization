/**      //<>// //<>// //<>//
 Created By: -
 Program Main
 ------------------------------------
 Eimhin Campbell Carroll 
 -Added a sort method while loading stocks dataPoints to sort by date.
 -Added mouse scroll for date selection
 -Added date jump widgets
 -Moved font loads from other classes to setup to prevent memory loss on multiple instances of a class;
 Cian Jinks
 -Removed all redundant code
 **/

//InfoScreen widgets - Eimhin

Widgets backWidget;
Widgets dateWidget;
Widgets dateAddYearWidget;
Widgets dateSubtractYearWidget;
Widgets dateWidget2;
Widgets dateAddYearWidget2;
Widgets dateSubtractYearWidget2;
Widgets dateSetWeek;
Widgets dateSetMonth;
Widgets dateSetYear;
Widgets dateSetAllTime;
Widgets pauseWidget;

//Main Screen Widgets
Widgets ticker;
Widgets companyName;
Widgets exchange;
Widgets sector;
Widgets value;

int currentScreen;
int widgetReference =0;
import java.util.*;
import java.text.*;
TextWidget focus; 

PFont loadGraphFont;
PFont loadGraphFont2 ;
PFont loadGraphFont3;

PFont loadInfoScreenHeaderFont;
PFont loadInfoScreenHeaderFontSmall;
PFont loadInfoScreenFont;

PFont loadFont;

void setup() {

  loadGraphFont = loadFont("ArialMT-18.vlw");
  loadGraphFont2 = loadFont("Arial-BoldMT-15.vlw");
  loadGraphFont3 = loadFont("ArialMT-15.vlw");

  loadInfoScreenHeaderFont = loadFont("YuGothicUI-Light-30.vlw");
  loadInfoScreenHeaderFontSmall = loadFont("YuGothicUI-Light-14.vlw");
  loadInfoScreenFont = loadFont("Arial-Black-18.vlw");
  loadFont = loadFont("LeelawadeeUI-Semilight-100.vlw");

  println("[INIT] Loading Fonts");

  // fill(255, 0, 0, 0);
  textFont(loadFont);
  text("LOADING", (SCREEN_X / 2) - 0.2*SCREEN_X, SCREEN_Y / 2);

  currentScreen = 0;
  size(1280, 720); 
  screen = new MainScreen();
  // Use loadTable function to process a csv
  table = loadTable("stocks.csv", "header");
  print("[INIT] Loading Dataset");
  // Create a unique business for every business in the stocks.csv
  uniqueBusinesses = new ArrayList<Business>();
  for (TableRow row : table.rows()) {
    String ticker = row.getString("ticker");
    String exchange = row.getString("exchange");
    String name = row.getString("name");
    String sector = row.getString("sector");
    String industry = row.getString("industry");
    widgetReference++;
    uniqueBusinesses.add(new Business(ticker, exchange, name, sector, industry, widgetReference));
  }
  // Create a DataPoint for every stock
  table = loadTable("daily_prices100k.csv", "header");
  dataPoints = new ArrayList<DataPoint>();
  for (TableRow row : table.rows()) {
    String ticker = row.getString("ticker");
    double openPrice = row.getDouble("open");
    double closePrice = row.getDouble("close");
    double adjustedClose = row.getDouble("adj_close");
    double low = row.getDouble("low");
    double high = row.getDouble("high");
    int volume = row.getInt("volume");
    String dateString = row.getString("date");
    DataPoint newDP = new DataPoint(ticker, openPrice, closePrice, adjustedClose, low, high, volume, dateString); 
    // Add the new DataPoint to its respective business
    for (Business b : uniqueBusinesses) {
      if (b.ticker.equalsIgnoreCase(newDP.getTicker())) {
        int index = 0;
        if (!b.stocks.isEmpty()) {  
          //Sort DataPoints by date
          while (newDP.getTime() < (b.stocks.get(index).getTime()) && index < b.stocks.size() ) {
            index++;
          }
        }
        b.stocks.add(index, newDP);
        break;
      }
    }
    dataPoints.add(newDP);
  }

  // Create a preview graph for every business as well as update some other basic information
  for (int i = 0; i < uniqueBusinesses.size(); i++) {
    Business business = uniqueBusinesses.get(i);
    business.setMostRecentPrice();
    business.preview = new PreviewGraph(0, 0, 185, 55, backgroundColor, strokeColor, business);
    business.updatePercentageChange(0, business.stocks.size() - 1);
  }
  
  scrollBarHeight = (13.0f/(float)uniqueBusinesses.size()) * (float)SCREEN_Y;
  //Initial settings for showing businesses
  screen.sortByCurrentPrice();
  screen.onlyShowBusinessesWithStocks();
}

void draw() {
  // Switch screens based on currentScreen
  switch (currentScreen) {
    case (0):
    screen.draw();
    break;
    case(1):
    screen2.draw();
  }
}

void mousePressed() {
  //added by matt up to case 
  System.out.println("x: " + mouseX + "y: " + mouseY);
  switch (currentScreen) {
    case (0):
    int event = -1;
    focus = null; 
    if (event == EVENT_NULL) {
      event = screen.dropDownSearchWidget.getEvent(mouseX, mouseY);
    }
    if (event == EVENT_NULL) {
      event = screen.dropDownWidget.getEvent(mouseX, mouseY);
    }
    if (event == EVENT_NULL) {
      event = screen.sortByPercentageChangeWidget.getEvent(mouseX, mouseY);
    }
    if (event == EVENT_NULL) {
      event = screen.sortByBiggestGainWidget.getEvent(mouseX, mouseY);
    }
    if (event == EVENT_NULL) {
      event = screen.highPrice.getEvent(mouseX, mouseY);
    }
    if (event == EVENT_NULL) {
      event = screen.alphabetical.getEvent(mouseX, mouseY);
    }
    if (event == EVENT_NULL) {
      event = screen.search.getEvent(mouseX, mouseY);
    }
    if (event == EVENT_NULL) {
      for (int i = 0; i < uniqueBusinesses.size(); i++) {
        Business business = uniqueBusinesses.get(i);
        event = business.getEvent(mouseX, mouseY);
        if (event!= -1) {
          break;
        }
      }
      // System.out.println(event);
      //ground work for connecting main screen with "info screen"
      if (uniqueBusinesses != null) {
        for (int i = 0; i < uniqueBusinesses.size(); i++) {
          Business business = uniqueBusinesses.get(i);
          int businessEvent = business.getWidgetReference();

          if (event == businessEvent) {
            screen2 = new InfoScreen(business);
            currentScreen = 1;
          }
        }
      }
    }
    if (event == screen.searchEvent) {
      focus = screen.search;
      //screen.search.label = "";
    }//else{
    //focus = null;
    //  }
    if (event == SORT_MAIN_HIGH_PRICE) {
      screen.sortByLargestPriceChange();
    }
    if (event == SORT_MAIN_ALPHA) { // change back to alpha
      screen.onlyShowBusinessesWithStocks();
    }
    if (event == SORT_PERCENTAGE_CHANGE) {
      screen.sortByPercentageChange();
    }
    if (event == BIGGEST_GAIN) {
      screen.sortByBiggestGain();
    }
    if (event == DROP_DOWN) {
      screen.setDropDown();
    }
    if (event == SEARCH_DROP_DOWN) {
      screen.setSearchDropDown();
    }
    event = ticker.getEvent(mouseX, mouseY);
    if (event == 1) {
      screen.sortByTicker();
      screen.xSel = 100;
    }
    event = companyName.getEvent(mouseX, mouseY);
    if (event == 2) {
      screen.sortByExchange();
      screen.xSel = 333;      
    }
    event = exchange.getEvent(mouseX, mouseY);
    if (event == 3) {
      screen.sortByExchange();
      screen.xSel = 475;      

    }
    event = sector.getEvent(mouseX, mouseY);
    if (event == 4) {
      screen.sortBySector();
      screen.xSel = 635;      

    }
    event = value.getEvent(mouseX, mouseY);
    if (event == 5) {
      screen.sortByCurrentPrice();
      screen.xSel = 807;      

    }

    break;
    case (1):

    //InfoScreen Widgets for Mouse Pressed - Eimhin
    //Back
    int pressed = 0;
    pressed = backWidget.getEvent(mouseX, mouseY);
    if (pressed == 1) {
      currentScreen = 0;
    }
    //date select mode date 1
    pressed = dateWidget.getEvent(mouseX, mouseY);
    if (pressed == 2) {
      screen2.dateSelect2 = 1;
      screen2.dateSelect *= -1;
      screen2.updateData();
    }
    //add a year date 1
    pressed = dateAddYearWidget.getEvent(mouseX, mouseY);
    if (pressed == 3) {
      long newTime = screen2.log.get(screen2.index).getTime() - 365 * 24 * 60 * 60;
      while (screen2.index < screen2.log.size() -1 && screen2.log.get(screen2.index).getTime() > newTime) {
        screen2.index++;
      }
      screen2.updateData();
    }
    //subtract a year date 1
    pressed = dateSubtractYearWidget.getEvent(mouseX, mouseY);
    if (pressed == 4) {
      long newTime = screen2.log.get(screen2.index).getTime() + 365 * 24 * 60 * 60;
      while (screen2.index > 0 && screen2.log.get(screen2.index).getTime() < newTime && screen2.index > screen2.index2) {
        screen2.index--;
      }
      screen2.updateData();
    }
    //date select mode date 2
    pressed = dateWidget2.getEvent(mouseX, mouseY);
    if (pressed == 5) {
      screen2.dateSelect = 1;
      screen2.dateSelect2 *= -1;
      screen2.updateData();
    }
    //add a year date 2
    pressed = dateAddYearWidget2.getEvent(mouseX, mouseY);
    if (pressed == 6) {
      long newTime = screen2.log.get(screen2.index2).getTime() - 365 * 24 * 60 * 60;
      while (screen2.index2 < screen2.log.size() -1 && screen2.log.get(screen2.index2).getTime() > newTime && screen2.index2 < screen2.index ) {
        screen2.index2++;
      }
      screen2.updateData();
    }
    //subtract a year date 2
    pressed = dateSubtractYearWidget2.getEvent(mouseX, mouseY);
    if (pressed == 7) {
      // System.out.println("Subtract Year");
      long newTime = screen2.log.get(screen2.index2).getTime() + 365 * 24 * 60 * 60;
      while (screen2.index2 > 0 && screen2.log.get(screen2.index2).getTime() < newTime) {
        screen2.index2--;
      }
      screen2.updateData();
    }
    //set dates to most recent and a week apart
    pressed = dateSetWeek.getEvent(mouseX, mouseY);
    if (pressed == 8) {
      screen2.index2= 0;   
      screen2.index= 0;
      while (screen2.log.get(screen2.index).getTime() >= (screen2.log.get(0).getTime() - (24 * 60 * 60 * 7))) {
        screen2.index++;
      }
      screen2.updateData();
    }
    //set dates to most recent and a month apart
    pressed = dateSetMonth.getEvent(mouseX, mouseY);
    if (pressed == 9) {
      screen2.index2= 0;
      screen2.index= 0;
      while (screen2.log.get(screen2.index).getTime() >= (screen2.log.get(0).getTime() - (24 * 60 * 60 * 30))) {
        screen2.index++;
      }
      screen2.updateData();
    }
    //set dates to most recent and a year apart
    pressed = dateSetYear.getEvent(mouseX, mouseY);
    if (pressed == 10) {
      screen2.index2= 0;
      screen2.index= 0;
      while (screen2.log.get(screen2.index).getTime() >= (screen2.log.get(0).getTime() - (24 * 60 * 60 * 365))) {
        screen2.index++;
      }
      screen2.updateData();
    }
    //set dates to start and end of data
    pressed = dateSetAllTime.getEvent(mouseX, mouseY);
    if (pressed == 11) {
      screen2.index2= 0;
      screen2.index=screen2.log.size()-1;
      screen2.updateData();
    }
    pressed = pauseWidget.getEvent(mouseX, mouseY);
    if (pressed == 12) {
      screen2.pause = !screen2.pause;
    }
    break;
  }
}

//added by Eimhin for dates
void mouseWheel(MouseEvent event) {
  if (currentScreen == 1 && screen2.index + event.getCount()  < screen2.log.size() && screen2.index + event.getCount() >= screen2.index2 && screen2.dateSelect == -1) {
    screen2.index += event.getCount();
  } else if (currentScreen == 1 && screen2.index2 + event.getCount() <= screen2.index && screen2.index2 + event.getCount()  < screen2.log.size() && screen2.dateSelect2 == -1) {
    screen2.index2 += event.getCount();
  }
  if (currentScreen == 0)
  {
    if (event.getCount() < 0) {
      screen.scrollDown();
    } else {
      screen.scrollUp();
    }
  }
}

// Highlight hovered stock
void  mouseMoved() {
  if (currentScreen == 0) {
    int event = -1;
    for (int i = screen.getFirstDrawnBusiness(); i < screen.getLastDrawnBusiness(); i++) {
      Business business = uniqueBusinesses.get(i);
      event = business.getEvent(mouseX, mouseY);
      business.screenLink.setStroke(false);
      if (event!= -1) {
        business.screenLink.setStroke(true);
        break;
      }
    }
  }
}

// added by Matt
// Some debug keys to use instead of on screen buttons
void keyPressed() {
  if (focus == null) {
    if (key== 'a') {
      screen.sortByAlphabetical();
    }
    if (key== 'q') {
      screen.sortByLargestPriceChange();
    }
    if (key== 'w') {
      screen.scrollUp2();
    }
    if (key== 's') {
      screen.scrollDown2();
    }
  }

  if (focus != null) {
    if (key!= ENTER || key != RETURN) { 
      focus.append(key);
      focus.label = focus.label.toUpperCase();
    }
  }
  if (key== ENTER || key == RETURN) {
    screen.sortBySearch(screen.search.label.replaceAll("[^a-zA-Z0-9]", ""));
    if (focus!=null) {
      focus.label = "";
    }
  }
}
