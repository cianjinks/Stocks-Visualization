/**  //<>//
 Created By: Eimhin Campbell Carroll
 This file creates the detailed page for each company which creates some statistics and displays the graph
 Added more Stats and improved layout. - Eimhin
 **/
class InfoScreen {
  //Get Fonts
  PFont infoScreenHeaderFont = loadInfoScreenHeaderFont;
  PFont infoScreenHeaderFontSmall = loadInfoScreenHeaderFontSmall;
  PFont infoScreenFont = loadInfoScreenFont;
  PFont infoScreenNumbers = loadGraphFont; //Same as infoScreenNumbers

  //Variables for text loactions
  int headerX = 640;
  int headerY =  50;
  float statX = 190;
  float statY = 550;
  float offset = 25;
  //Text colours
  color red = color(255, 0, 0);
  color green = color(0, 255, 0);
  int count = -255;

  //graph
  int x = 270;
  int y = 120;
  int width = 600;
  int height = 200;

  //Data needed for screen.
  Business theBusiness;
  ArrayList<DataPoint> log = new ArrayList<DataPoint>(); 
  color secondaryColor = (100);
  color textColor = (255);
  String name;
  DataPoint currentData;

  //Info displayed
  String ticker  = "Error - No Data Found"; 
  double openPrice; 
  double closePrice; 
  double adjustedClose; 
  double low; 
  double high; 
  int volume; 
  String volumeString;
  String date; 
  double dailyTrend;
  double averagePrice;
  double periodHigh;
  double periodLow;
  double percentageChange;

  int index = 0;
  int dateSelect = 1;
  int index2 = 0;
  int dateSelect2 = 1;

  boolean pause = false; // Rotating stats box

  Graph graph;

  InfoScreen(Business business) { 
    //Load Data for 1 perticular company
    theBusiness = business;
    name = theBusiness.getBusinessName();
    if (!theBusiness.stocks.isEmpty()) {
      log = theBusiness.stocks;
      currentData = log.get(0);

      ticker = currentData.getTicker();
      openPrice = currentData.getOpenPrice();
      closePrice = currentData.getClosePrice();
      adjustedClose = currentData.getAdjustedClose();
      low = currentData.getLow();
      high = currentData.getHigh();
      volume = currentData.getVolume();
      volumeToString();
      date = currentData.getDate();
      dailyTrend = closePrice - openPrice;

      //Average price calculator
      int i = 6;
      while (log.get(i).getTime() < currentData.getTime() - (24 * 60 * 60 * 7)) {
        i--;
      }
      int copyi = i;
      averagePrice = 0;
      while (i >= 0)
      {
        averagePrice += log.get(i).getOpenPrice();
        i--;
      }
      averagePrice /= (copyi + 1);
      i = copyi;

      //Period High calculator
      periodHigh = 0;
      while (i >= 0)
      {
        double temp = log.get(i).getHigh();
        if (temp > periodHigh) {
          periodHigh = temp;
        }
        i--;
      }

      //Period Low calculator
      periodLow = 999999999;
      while (i >= 0)
      {
        double temp = log.get(i).getLow();
        if (temp < periodLow) {
          periodLow = temp;
        }
        i--;
      }

      //percentageChange calculator
      percentageChange = ( (log.get(index2).getClosePrice() - currentData.getOpenPrice()) / currentData.getOpenPrice()) * 100;

      graph = new Graph(100, 90, 1030, 370, backgroundColor, strokeColor, business, currentData.getDate(), currentData.getDate());
      println("[INIT] Generating Detailed Graph for " + business.getTicker());
    }

    //Widgets for infoScreen
    backWidget = new Widgets (1175, 25, 105, 50, "Back", 1, backgroundColor, secondaryColor, infoScreenFont);
    dateWidget = new Widgets (28, 32, 100, 26, date, 2, backgroundColor, 140, infoScreenNumbers);
    dateAddYearWidget = new Widgets (8, 34, 25, 25, "-", 3, backgroundColor, secondaryColor, infoScreenNumbers);
    dateSubtractYearWidget = new Widgets (130, 34, 25, 25, "+", 4, backgroundColor, secondaryColor, infoScreenNumbers);
    dateWidget2 = new Widgets (165, 32, 100, 26, date, 5, backgroundColor, 140, infoScreenNumbers);
    dateAddYearWidget2 = new Widgets (150, 34, 25, 25, "-", 6, backgroundColor, secondaryColor, infoScreenNumbers);
    dateSubtractYearWidget2 = new Widgets (265, 34, 25, 25, "+", 7, backgroundColor, secondaryColor, infoScreenNumbers);
    dateSetWeek = new Widgets (1040, 55, 80, 30, "1 Week", 8, backgroundColor, green, infoScreenNumbers);
    dateSetMonth = new Widgets (950, 55, 80, 30, "1 Month", 9, backgroundColor, green, infoScreenNumbers);
    dateSetYear = new Widgets (860, 55, 80, 30, "1 Year", 10, backgroundColor, green, infoScreenNumbers);
    dateSetAllTime = new Widgets (770, 55, 80, 30, "All", 11, backgroundColor, green, infoScreenNumbers);
    pauseWidget = new Widgets (828, 500, 19, 30, "| |", 12, 100, textColor, infoScreenHeaderFontSmall);
  }

  void draw () {
    background(52);
    backWidget.draw();
    //back Widge Visuals
    fill(textColor);
    circle(1200, 50, 50);
    rect(1200, 25, 80, 50);
    noStroke();
    fill(0);
    textFont(infoScreenHeaderFont);
    text ("Back", 1205, 60);



    //Name
    textAlign(CENTER);
    textFont(infoScreenHeaderFont);
    fill(textColor);
    if (name.length() > 40) {
      textFont(infoScreenHeaderFontSmall);
    }
    text (ticker + ":   " + name, headerX, headerY);
    textFont(infoScreenHeaderFont);
    textAlign(LEFT);
    textFont(infoScreenHeaderFont);
    text ( "" + date, headerX + 800, headerY);

    if (!log.isEmpty()) {

      //Stats
      fill(255);
      textAlign(LEFT);
          if (name.length() > 40) {
      textFont(infoScreenHeaderFontSmall);
    }
      text (name + " : " + ticker, statX - 150, statY + offset * -1);
      textFont(infoScreenHeaderFont);


      if (index < 0)
        index = 0;
      if (index2 < 0)
        index2 = 0;
      //update graph endpoint here. For now I was thinking we can display from date picked to present with a minimum time of 7 days  
      if (index > 6)
        graph.updateTimePeriod(log.get(index).getDate(), log.get(index2).getDate());
      else
        graph.updateTimePeriod(log.get(0).getDate(), log.get(index2).getDate());

      //draw date widgets
      stroke(green);
      strokeWeight(0.5);
      dateSetWeek.draw();
      dateSetMonth.draw();
      dateSetYear.draw();
      dateSetAllTime.draw();
      noStroke();
      strokeWeight(1);

      graph.draw();    

      textFont(infoScreenHeaderFontSmall);
      fill(textColor);
      text("Select: Start Date                           End Date", 12, 15);

      textFont(infoScreenNumbers);

      dateWidget.label = log.get(index).date;
      dateWidget.draw();


      if (dateSelect == -1) {
        //Date selector
        dateAddYearWidget.draw();
        dateSubtractYearWidget.draw();

        fill(75);
        try {
          text (log.get(index - 1).date, 38, 30);
        }
        catch (Exception e) {
        }
        try {
          text (log.get(index + 1).date, 38, 70);
        }
        catch (Exception e) {
        }
      }

      dateWidget2.label = log.get(index2).date;
      dateWidget2.draw();

      if (dateSelect2 == -1) {
        //Date selector
        dateAddYearWidget2.draw();
        dateSubtractYearWidget2.draw();

        fill(75);
        try {
          text (log.get(index2 - 1).date, 175, 30);
        }
        catch (Exception e) {
        }
        try {
          text (log.get(index2 + 1).date, 175, 70);
        }
        catch (Exception e) {
        }
      }

      //Draw Stats
      fill(textColor);
      textFont(infoScreenNumbers);
      textAlign(CENTER);
      text ("Current Date Selected: " + date, statX, statY + offset * 0);
      textAlign(RIGHT);
      text ("Open Price :", statX, statY + offset * 1);
      text ("Close Price :", statX, statY + offset * 2);
      text ("Daily Trend :", statX, statY + offset * 3);
      text ("Adjusted Close :", statX, statY + offset * 4);
      text ("High :", statX, statY + offset * 5);
      text ("Low :", statX, statY + offset * 6);

      textAlign(LEFT);
      textFont(infoScreenNumbers);

      text (""+ String.format("%.2f", openPrice), statX + 15, statY + offset * 1);
      text ("" + String.format("%.2f", closePrice), statX + 15, statY + offset * 2);

      if (dailyTrend > 0)
        fill(green);
      else if (dailyTrend < 0)
        fill(red);

      text ("" + String.format("%.2f", dailyTrend), statX + 15, statY + offset * 3);

      fill(textColor);

      text ("" + String.format("%.2f", adjustedClose), statX + 15, statY + offset * 4);
      fill(green);
      text ("" + String.format("%.2f", high), statX + 15, statY + offset * 5);
      fill(red);
      text ("" + String.format("%.2f", low), statX + 15, statY + offset * 6);

      //Time Period Stats 
      textAlign(CENTER);
      textFont(infoScreenHeaderFont);
      fill(textColor);
      text ("Date Range Stats", statX + 520, statY + offset * -1);
      textAlign(RIGHT);
      textFont(infoScreenNumbers);

      fill(100);
      textAlign(CENTER);
      pauseWidget.draw();
      textAlign(RIGHT);
      fill(textColor);

      if (!pause) {
        if (count < 193)
          count += 1.5;
        else
          count = -255;
        if (count >= -62 && count < 0) {
          count = 0;
        }
      }
      textFont(infoScreenNumbers);
      if (count < 0) {
        fill(-count);
        text ("Start Price :", statX + 540, statY + offset * 0);
        text ("Close Price :", statX + 540, statY + offset * 1);
        text ("Period Trend :", statX + 540, statY + offset * 2);
        text ("Percentage Change :", statX + 540, statY + offset * 3);

        textAlign(LEFT);
        textFont(infoScreenNumbers);
        text (""+ String.format("%.2f", log.get(index).getOpenPrice()), statX + 15 + 540, statY + offset * 0);
        text ("" + String.format("%.2f", log.get(index2).getClosePrice()), statX + 15 + 540, statY + offset * 1);
        text ("" + String.format("%.2f", log.get(index2).getClosePrice() - log.get(index).getOpenPrice()), statX + 15 + 540, statY + offset * 2);
        text ("" + String.format("%.2f %s", percentageChange, "%"), statX + 15 + 540, statY + offset * 3);
      } else {
        fill(255 - count);
        text ("Average Price :", statX + 540, statY + offset * 0);
        text ("High :", statX + 540, statY + offset * 1);
        text ("Low :", statX + 540, statY + offset * 2);
        textAlign(LEFT);
        textFont(infoScreenNumbers);
        text ("" + String.format("%.2f", averagePrice), statX + 15 + 540, statY + offset * 0);
        text ("" + String.format("%.2f", periodHigh), statX + 15 + 540, statY + offset *1);
        text ("" + String.format("%.2f", low), statX + 15 + 540, statY + offset * 2);
      }

      //Sector Info
      textAlign(LEFT);
      textFont(infoScreenHeaderFont);
      fill(textColor);
      text (" Info ", statX + 710, statY + offset * -1);
      textFont(infoScreenNumbers);
      text ("" + theBusiness.sector, statX + 710, statY + offset * 0);
      text ("" + theBusiness.industry, statX + 710, statY + offset * 1);
      noStroke();
      
      //Volume
      text ("Volume : " + volumeString, statX + 160, statY + offset);
      
      
      
    } else 
    {
      textFont(infoScreenHeaderFont);
      textAlign(CENTER);
      fill(255, 0, 0);
      text("No Data Found", 600, 360);
      textAlign(LEFT);
    }
  }
  //Add commas every third number ie. 999,999,999
  void volumeToString(){
    String temp = Integer.toString(volume);
    String temp2 = "";
    volumeString = "";
    int count  = 0;
    for(int index = temp.length() - 1; index >= 0; index--) {
      if(count % 3 == 0 && count != 0){
        temp2 += ",";
      }
      temp2 += temp.charAt(index);
      count++;
    } 
    
    //reverse again for correct order
    for(int i = temp2.length() - 1; i >= 0; i--)
        {
            volumeString += temp2.charAt(i);
        }
  }


  //Updates the numbers displayed to those at new indexs.

  void updateData () {
    currentData = log.get(index);
    openPrice = currentData.getOpenPrice();
    closePrice = currentData.getClosePrice();
    adjustedClose = currentData.getAdjustedClose();
    low = currentData.getLow();
    high = currentData.getHigh();
    volume = currentData.getVolume();
    volumeToString();
    date = currentData.getDate();
    dailyTrend = closePrice - openPrice;
    averagePrice = 0;
    int i = index;
    while (i >= index2)
    {
      averagePrice += log.get(i).getOpenPrice();
      i--;
    }
    averagePrice = averagePrice/(index + 1 - index2);
    i = index;
    periodHigh = 0;
    while (i >= index2)
    {
      double temp = log.get(i).getHigh();
      if (temp > periodHigh) {
        periodHigh = temp;
      }
      i--;
    }
    i = index;
    periodLow = 999999999;
    while (i >= index2)
    {
      double temp = log.get(i).getLow();
      if (temp < periodLow) {
        periodLow = temp;
      }
      i--;
    }

    //Percentage change
    percentageChange = ((log.get(index2).getClosePrice() - currentData.getOpenPrice()) / currentData.getOpenPrice()) * 100;
  }
}
