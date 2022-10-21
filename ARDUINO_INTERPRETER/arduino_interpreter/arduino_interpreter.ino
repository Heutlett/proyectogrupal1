int b0 = 2;       // 
int b1 = 3;       // 
int b2 = 4;       // 
int b3 = 5;       //  
int b4 = 6;       //  
int b5 = 7;       //  
int b6 = 8;       //  
int b7 = 9;       //  

int clk_out = 13;
int flag = 0;

int val0 = 0;     // 
int val1 = 0;     // 
int val2 = 0;     //
int val3 = 0;     // 
int val4 = 0;     // 
int val5 = 0;     //
int val6 = 0;     // 
int val7 = 0;     // 

int val_clk = 0;

void setup() {
  Serial.begin(9600);
  pinMode(b0, INPUT);
  pinMode(b1, INPUT);
  pinMode(b2, INPUT);
  pinMode(b3, INPUT);
  pinMode(clk_out, INPUT);
}

void loop() {

  //Serial.println(digitalRead(clk_out));

  if (digitalRead(clk_out)==0){
    flag=0;
  }
  if (digitalRead(clk_out)==1 && flag==0){
    flag=1;
    val0 = digitalRead(b0);   // 
    val1 = digitalRead(b1);   // 
    val2 = digitalRead(b2);   //
    val3 = digitalRead(b3);   //
    val4 = digitalRead(b4);   // 
    val5 = digitalRead(b5);   //
    val6 = digitalRead(b6);   //
    val7 = digitalRead(b7);   // 


    Serial.print(val7);
    Serial.print(val6);
    Serial.print(val5);
    Serial.print(val4);
    Serial.print(val3);
    Serial.print(val2);
    Serial.print(val1);
    Serial.println(val0);

  }

}