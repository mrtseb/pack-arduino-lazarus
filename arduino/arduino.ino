String dimmer="";
long port =0;
int a0,a1,a2,a3;

long stringToLong(String s)
{
   char arr[12];
   s.toCharArray(arr, sizeof(arr));
   return atol(arr);
}

char* stringToArr(String s)
{
   char arr[12];
   s.toCharArray(arr, sizeof(arr));
   return arr;
}
 
 void setup() 
 {
  pinMode(6, OUTPUT);
  Serial.begin(57600);
  //Serial.write("Hello from MrT");
 }
 
 void loop() 
 {  
  while (Serial.available() > 0) 
  {
    char data = Serial.read();
    dimmer += data;
    delay(1);
    
    if (data == '-')
    {
    
    port= stringToLong(dimmer);
    //Serial.write(stringToArr(dimmer));
    dimmer="";
    
    }
    
    if (data == '.')
    {
      analogWrite(port, dimmer.toInt());
      dimmer = "";
    }
    if (data == '#')
    {   
    
    a0 = analogRead(0);
    a1 = analogRead(1);
    a2 = analogRead(2);
    a3 = analogRead(3);
    
    Serial.print(a0);
    Serial.print(";");
    Serial.print(a1);
    Serial.print(";");
    Serial.print(a2);
    Serial.print(";");
    Serial.println(a3);
    
    
    
    dimmer="";    
    }
  }
 }
