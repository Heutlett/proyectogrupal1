int b0 = 2;  // LED connected to digital pin 13
int b1 = 3;  // LED connected to digital pin 13
int b2 = 4;  // LED connected to digital pin 13
int b3 = 5;  // LED connected to digital pin 13

int clk_out = 13;
int flag = 0;

int val0 = 0;      // variable to store the read value
int val1 = 0;      // variable to store the read value
int val2 = 0;      // variable to store the read value
int val3 = 0;      // variable to store the read value

int val_clk = 0;

void setup() {
  Serial.begin(9600);
  pinMode(b0, INPUT);    // sets the digital pin 7 as input
  pinMode(b1, INPUT);    // sets the digital pin 7 as input
  pinMode(b2, INPUT);    // sets the digital pin 7 as input
  pinMode(b3, INPUT);    // sets the digital pin 7 as input
  pinMode(clk_out, INPUT);    // sets the digital pin 7 as input
}

void loop() {

  //Serial.println(digitalRead(clk_out));

  if (digitalRead(clk_out)==0){
    flag=0;
  }
  if (digitalRead(clk_out)==1 && flag==0){
    flag=1;
    val0 = digitalRead(b0);   // read the input pin
    val1 = digitalRead(b1);   // read the input pin
    val2 = digitalRead(b2);   // read the input pin
    val3 = digitalRead(b3);   // read the input pin
    Serial.print(val3);
    Serial.print(val2);
    Serial.print(val1);
    Serial.println(val0);
    
    
    

  }

}