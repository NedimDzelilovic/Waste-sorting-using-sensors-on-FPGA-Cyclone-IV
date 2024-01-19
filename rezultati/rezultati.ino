#include "ThingsBoard.h"
#include <ESP8266WiFi.h>

#define WIFI_AP "8D1E7F"
#define WIFI_PASSWORD "EVW327N033077"

WiFiClient espClient;
#define TOKEN "VZaFkMlzjwTElOGLjTJk" 
#define THINGSBOARD_SERVER "demo.thingsboard.io"

// Baud rate for debug serial
#define SERIAL_DEBUG_BAUD 115200

ThingsBoard tb(espClient);
int status = WL_IDLE_STATUS;

int induktivni = 5; //D1
int kapacitivni = 4; //D2
int foto = 14; //D5
int motor_traka = 12; //D6
int motor_pregrada = 13; //D7
int metal;
int plastika;
int staklo;
int traka;
int pregrada;

int plastika1;

void setup() {
  Serial.begin(SERIAL_DEBUG_BAUD);
  WiFi.begin(WIFI_AP, WIFI_PASSWORD);
  InitWiFi();

  pinMode(induktivni, INPUT);
  pinMode(kapacitivni, INPUT);
  pinMode(foto, INPUT);
  pinMode(motor_traka, INPUT);
  pinMode(motor_pregrada, INPUT);
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

  int  metal = digitalRead(induktivni);
  int plastika = digitalRead(kapacitivni);
  int staklo = digitalRead(foto);
  int traka = digitalRead(motor_traka);
  int pregrada = digitalRead(motor_pregrada);

if(plastika == 0){
 plastika1 = 1; 
}

else if(plastika == 1){
  plastika1 = 0;
}

  tb.sendTelemetryInt("Induktivni", metal);
  tb.sendTelemetryInt("Kapacitivni", plastika1);
  tb.sendTelemetryInt("Foto", staklo);
  tb.sendTelemetryInt("Traka", traka);
  tb.sendTelemetryInt("Pregrada", pregrada);
  

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
