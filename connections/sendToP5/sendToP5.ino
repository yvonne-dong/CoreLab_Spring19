int inPin1 = 2;
int inPin2 = 3;
int inPin3 = 4;
//int inPin4 = 5;
int pot1 = A0;
int pot2 = A1;

int cVal1 = 0;
int cVal2 = 0;
int cVal3 = 0;
//int cVal4 = 0;
int cPotVal1 = 0;
int cPotVal2 = 0;

int val1 = 0;
int val2 = 0;
int val3 = 0;
//int val4 = 0;
int potVal1 = 0;
int potVal2 = 0;

void setup() {
  pinMode(inPin1, INPUT);
  pinMode(inPin2, INPUT);
  pinMode(inPin3, INPUT);
  //  pinMode(inPin4, INPUT);

  Serial.begin(9600);
}

void loop() {
  val1 = digitalRead(inPin1);
  val2 = digitalRead(inPin2);
  val3 = digitalRead(inPin3);
  //  val4 = digitalRead(inPin4);

  potVal1 = analogRead(pot1);
  potVal2 = analogRead(pot2);
  //potVal != cPotVal

  Serial.print(val1);
  Serial.print(".");
  Serial.print(val2);
  Serial.print(".");
  Serial.print(val3);
  //  Serial.print(".");
  //  Serial.print(val4);
  Serial.print(".");
  Serial.print(potVal1);
  Serial.print(".");
  if (potVal2 > 10) {
    Serial.println(potVal2);
  } else if (potVal2 <= 10) {
    Serial.println("0");
  }

  delay(100);
}

