/**
 
 This file holds all of our constants that need to be used across multiple classes and files.
 
 **/
 
Table table;
ArrayList<DataPoint> dataPoints; // ArrayList of all stocks from the data set
ArrayList<Business> uniqueBusinesses; // ArrayList of businesses
public static final int SCREEN_X = 1280;
public static final int SCREEN_Y = 720;
MainScreen screen;
InfoScreen screen2;
boolean searchComplete = false;
String textValue = "";
public static final int EVENT_NULL =-1;

public static final int MS_ROW_SIZE = 35;
public static final int MS_COLUMN_SIZE = 155;


//Main screen widget ids
public static final int SORT_MAIN_HIGH_PRICE = 66665;
public static final int SORT_MAIN_ALPHA = 66664;
public static final int SORT_PERCENTAGE_CHANGE = 66663;
public static final int BIGGEST_GAIN = 66662;
public static final int DROP_DOWN = 66661; 
//SEARCH_DROP_DOWN
public static final int SEARCH_DROP_DOWN = 66660;

public static final int PREVIEW_RESOLUTION = 3; // The smaller the less stocks that are drawn

color backgroundColor = color(52);
color strokeColor = color(82, 82, 82);


public float scrollBarHeight; 
public final int scrollBarWidth = 15;
