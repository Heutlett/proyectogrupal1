int pin12 = 12;  // LED connected to digital pin 13
int pin11 = 11;  // LED connected to digital pin 13
int pin10 = 10;  // LED connected to digital pin 13
int pin9 = 9;  // LED connected to digital pin 13

int val1 = 0;      // variable to store the read value
int val2 = 0;      // variable to store the read value
int val3 = 0;      // variable to store the read value
int val4 = 0;      // variable to store the read value

void setup() {
  Serial.begin(9600);
  pinMode(pin12, INPUT);    // sets the digital pin 7 as input
  pinMode(pin11, INPUT);    // sets the digital pin 7 as input
  pinMode(pin10, INPUT);    // sets the digital pin 7 as input
  pinMode(pin9, INPUT);    // sets the digital pin 7 as input

}

void loop() {
  val1 = digitalRead(pin9);   // read the input pin
  val2 = digitalRead(pin10);   // read the input pin
  val3 = digitalRead(pin11);   // read the input pin
  val4 = digitalRead(pin12);   // read the input pin
  Serial.print(val1);
  Serial.print(",");
  Serial.print(val2);
  Serial.print(",");
  Serial.print(val3);
  Serial.print(","); 
  Serial.println(val4);

  delay(1);
}