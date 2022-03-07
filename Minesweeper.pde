import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public static final int NUM_ROWS = 20;
public static final int NUM_COLS = 20;
private MSButton[][] buttons;//2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>();  //ArrayList of just the minesweeper buttons that are mined
boolean isLost;

void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int r = 0; r < buttons.length; r++)
    for (int c = 0; c< buttons[0].length; c++)
      buttons[r][c]= new MSButton(r, c);
  setMines();
}
public void setMines()
{
  for(int i = 0;i < 40; i++){
  int row = (int)(Math.random()*NUM_ROWS);
  int col = (int)(Math.random()*NUM_COLS);
  if (!mines.contains(buttons[row][col]))
    mines.add(buttons[row][col]);
  }
}

public void draw ()
{
  background( 0 );
  System.out.println(isWon());
  System.out.println(mines);
  if (isWon()== true)
    displayWinningMessage();
  else
    displayLosingMessage();
}
public boolean isWon()
{
  int sumNotClicked = 0;
  for (int r = 0; r < buttons.length; r++) {
    for (int c = 0; c< buttons[0].length; c++) {
      if (buttons[r][c].clicked == false)
        sumNotClicked++;
    }
  }
  boolean minesFlagged;
  ArrayList<Boolean>win = new ArrayList<Boolean>();
  int sum = 0;
  // checks if all the mines are flagged
  for (int i = 0; i < mines.size(); i++)
    if (mines.get(i).flagged == false)
      win.add(true);
    else
      win.add(false);
  for (int i = 0; i < win.size(); i++)
    if (win.get(i)== true)
      sum++;
  if (sum > 0) {
    minesFlagged= false;
  } else {
    minesFlagged= true;
  }
  System.out.println(sumNotClicked);
  if (sumNotClicked == mines.size() && minesFlagged == true) { 
    return true;
  } else 
  return false;
}
public void displayLosingMessage()
{
  if (isLost == true){
    buttons[NUM_ROWS/2][NUM_COLS/2].setLabel("you lose!");
    for (int i=0; i<mines.size(); i++)
    if (mines.get(i).clicked==false)
      mines.get(i).mousePressed();
}
}
public void displayWinningMessage()
{
  for (int i = 0; i <buttons.length; i++)
    for (int x = 0; x <buttons[0].length; x++)
      buttons[i][x].setLabel("you win!");
}
public boolean isValid(int r, int c)
{
  if (r < 0 || c >= NUM_COLS) {
    return false;
  } else if (r >= NUM_ROWS  || c < 0) {
    return false;
  }
  return true;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  if (isValid(row, col-1)==true && mines.contains(buttons[row][col-1])) {
    numMines = numMines+1;
  }
  if (isValid(row, col+1)==true && mines.contains(buttons[row][col+1])) {
    numMines = numMines+1;
  }
  for (int i = col-1; i <= col+1; i++) {
    if (isValid(row-1, i)==true && mines.contains(buttons[row-1][i]))
      numMines = numMines+1;
    if (isValid(row+1, i)==true && mines.contains(buttons[row+1][i]))      
      numMines = numMines+1;
  }
  System.out.println(numMines);
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col;
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed ()
  {
    clicked = true;
    if (mouseButton == RIGHT && flagged == true) {
      flagged = !flagged;
      clicked = false;
    } else if (mouseButton == RIGHT && flagged == false) {
      flagged = !flagged;
      clicked = false;
    } else if (clicked && mines.contains(this)) {
      displayLosingMessage();
    } else if (countMines(myRow, myCol) > 0)
      myLabel = countMines(myRow, myCol)+ "";
    else if (isValid(myRow, myCol-1) && buttons[myRow][myCol-1].clicked == false)
      buttons[myRow][myCol-1].mousePressed();
    else if (isValid(myRow, myCol+1) && buttons[myRow][myCol+1].clicked == false)
      buttons[myRow][myCol+1].mousePressed();
    else if (isValid(myRow+1, myCol) && buttons[myRow+1][myCol].clicked == false)
      buttons[myRow+1][myCol].mousePressed();
    else if (isValid(myRow+1, myCol-1) && buttons[myRow+1][myCol-1].clicked == false)
      buttons[myRow+1][myCol-1].mousePressed();
    else if (isValid(myRow+1, myCol+1) && buttons[myRow+1][myCol+1].clicked == false)
      buttons[myRow+1][myCol+1].mousePressed();
    else if (isValid(myRow-1, myCol-1) && buttons[myRow-1][myCol-1].clicked == false)
      buttons[myRow-1][myCol-1].mousePressed();
    else if (isValid(myRow-1, myCol) && buttons[myRow-1][myCol].clicked == false)
      buttons[myRow][myCol-1].mousePressed();
    else if (isValid(myRow-1, myCol+1) && buttons[myRow-1][myCol+1].clicked == false)
      buttons[myRow-1][myCol+1].mousePressed();
  }
  public void draw ()
  {    
    if (flagged)
      fill(0);
    else if ( clicked && mines.contains(this) ) {
      isLost = true;
      fill(255, 0, 0);
    } else if (clicked)
      fill(255,192,203);
    else
      fill(197,199,196 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
}
