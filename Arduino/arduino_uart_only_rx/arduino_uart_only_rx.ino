// const byte LED = 1;

void setup ()
  {
  Serial.begin (115200);
  Serial.println ();
  UCSR0B &= ~bit (TXEN0);  // disable transmit
  Serial.println ("Testing");
  pinMode (LED_BUILTIN, OUTPUT);
  }  // end of setup

void loop ()
  {
  digitalWrite (LED_BUILTIN, HIGH);
  delay (500);
  digitalWrite (LED_BUILTIN, LOW);
  delay (500);
  }  // end of loop
