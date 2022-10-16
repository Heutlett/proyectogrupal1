int b0 = 3;  // LED connected to digital pin 13
int b1 = 4;  // LED connected to digital pin 13
int b2 = 5;  // LED connected to digital pin 13
int b3 = 6;  // LED connected to digital pin 13
int enable = 0;


int flag = 0;
int val1 = 0;      // variable to store the read value
int val2 = 0;      // variable to store the read value
int val3 = 0;      // variable to store the read value
int val4 = 0;      // variable to store the read value

void setup() {
  Serial.begin(115200);
  pinMode(b0, INPUT);    // sets the digital pin 7 as input
  pinMode(b1, INPUT);    // sets the digital pin 7 as input
  pinMode(b2, INPUT);    // sets the digital pin 7 as input
  pinMode(b3, INPUT);    // sets the digital pin 7 as input
  pinMode(enable, INPUT);    // sets the digital pin 7 as input
}

void loop() {
  if (digitalRead(enable)==0){
    flag=0;
  }
  if (digitalRead(enable)==1 && flag==0){
    flag=1;
    val1 = digitalRead(b0);   // read the input pin
    val2 = digitalRead(b1);   // read the input pin
    val3 = digitalRead(b2);   // read the input pin
    val4 = digitalRead(b3);   // read the input pin
    Serial.print(val1);
    Serial.print(val2);
    Serial.print(val3);
    Serial.println(val4);

  }

}