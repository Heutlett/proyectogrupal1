int pin2 = 2;
int pin3 = 3;
int pin4 = 4;
int pin5 = 5;

int val2 = 0;
int val3 = 0;
int val4 = 0;
int val5 = 0;

int valor_clk = 0;
int pinClk = 7;

int flag = 0;

void setup() {

  Serial.begin(115200);

  pinMode(pin2, INPUT);
  pinMode(pin3, INPUT);
  pinMode(pin4, INPUT);
  pinMode(pin5, INPUT);
  pinMode(pinClk, INPUT);
  
}

void loop() {

  val2 = digitalRead(pin2);   // read the input pin
  val3 = digitalRead(pin3);   // read the input pin
  val4 = digitalRead(pin4);   // read the input pin
  val5 = digitalRead(pin5);   // read the input pin

  valor_clk = digitalRead(pinClk);

  Serial.println(valor_clk);

  if (valor_clk == 0){
    flag = 0;
    //Serial.println(valor_clk);
  }


  if (valor_clk == 1){

    Serial.print(val2);
    Serial.print(val3);
    Serial.print(val4);
    Serial.println(val5);

    flag = 1;

  }
}