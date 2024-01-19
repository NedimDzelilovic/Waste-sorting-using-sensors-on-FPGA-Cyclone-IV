#include "ThingsBoard.h"
#include <ESP8266WiFi.h>

#define WIFI_AP "8D1E7F"
#define WIFI_PASSWORD "EVW327N033077"

WiFiClient espClient;
#define TOKEN "IhcifXMd1oJW2Y3AMZQW" 
#define THINGSBOARD_SERVER "demo.thingsboard.io"

// Baud rate for debug serial
#define SERIAL_DEBUG_BAUD 115200

ThingsBoard tb(espClient);
int status = WL_IDLE_STATUS;

//int counter_flasa_temp = 5;  //D1
//int counter_flasa;
//int counter = 0;

int metal = 5; //D1
int plastika = 4; //D2
int staklo = 14; //D5
int counter_metala;
int conter_plastike;
int counter_staklo;
int counterM = 0;
int counterP = 0;
int counterS = 0;

int plastika_detect = 0;
int metal_detect = 0;
int staklo_detect = 0;


void setup() {
  Serial.begin(SERIAL_DEBUG_BAUD);
  WiFi.begin(WIFI_AP, WIFI_PASSWORD);
  InitWiFi();

  pinMode(metal, INPUT);
  pinMode(plastika, INPUT);
  pinMode(staklo, INPUT);
}

void loop() {
  delay(1000);

  if (WiFi.status() != WL_CONNECTED) {
    reconnect();
  }

  if (!tb.connected()) {
    // Connect to the ThingsBoard
    Serial.print("Connecting to: ");
    Serial.print(THINGSBOARD_SERVER);
    Serial.print(" with token ");
    Serial.println(TOKEN);
    if (!tb.connect(THINGSBOARD_SERVER, TOKEN)) {
      Serial.println("Failed to connect");
      return;
    }
  }

  Serial.println("Sending data...");

  int counter_metala = digitalRead(metal);
  int counter_plastike = digitalRead(plastika);
  int counter_staklo = digitalRead(staklo);


if(counter_metala == 1){
metal_detect = 1;
}

if(counter_plastike == 0){
plastika_detect = 1;
}

if(counter_staklo == 1){
staklo_detect = 1;
}

//metal
if(metal_detect == 1 && plastika_detect == 1 && staklo_detect == 1){
    delay(3000);
    counterM++;
    plastika_detect = 0;
    metal_detect = 0;
    staklo_detect = 0;
}  

//plastika
else if(metal_detect == 0 && plastika_detect == 1 && staklo_detect == 1){
delay(3000);
counterP++;
plastika_detect = 0;
metal_detect = 0;
staklo_detect = 0;  
}

//staklo
else if(metal_detect == 0 && plastika_detect == 1 && staklo_detect == 0){
delay(3000);
counterS++;
plastika_detect = 0;
metal_detect = 0;
staklo_detect = 0;  
}

  tb.sendTelemetryInt("Broj sortiranog metala", counterM);
  tb.sendTelemetryInt("Broj sortirane plastike", counterP);
  tb.sendTelemetryInt("Broj sortiranog stakla", counterS);

  tb.loop();
}

void InitWiFi() {
  Serial.println("Connecting to AP ...");
  // attempt to connect to WiFi network

  WiFi.begin(WIFI_AP, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("Connected to AP");
}

void reconnect() {
  // Loop until we're reconnected
  status = WiFi.status();
  if (status != WL_CONNECTED) {
    WiFi.begin(WIFI_AP, WIFI_PASSWORD);
    while (WiFi.status() != WL_CONNECTED) {
      delay(500);
      Serial.print(".");
    }
    Serial.println("Connected to AP");
  }
}
