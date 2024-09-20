// Include needed libraries
#include <Arduino.h>
#include <Adafruit_Sensor.h>
#include <Wire.h>
#include <DHT.h>
#include <LiquidCrystal_I2C.h>
#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <PubSubClient.h>


// define our ESP32 pins
#define moisture_pin 34
#define water_level_pin 35
#define DHT22_pin 32
#define pump_relay_pin 19
#define fan_relay_pin 5
#define humidifier_relay_pin 18
#define heater_relay_pin 4
#define water_level_led_pin 14
#define temp_led_pin 26
#define humidity_led_pin 27
#define buzzer_pin 2
#define button_up_pin 12
#define button_down_pin 13
// Define the type of DHT sensor
#define DHTTYPE DHT22 


// functions declarations
void wifiConnection();
void serverConnect();
void mycallback(char *topic, byte *payload, unsigned int length);

// MQTT cluster data
const char *cluster_url = "24934589ba0b470b8c3d9d6c83ca9ff5.s1.eu.hivemq.cloud";
const int port = 8883;
const char *user_name = "Al-Husain";
const char *client_password = "Al-Husain123";
const char *temp_pub = "ESP32/temp_pub";
const char *humidity_pub = "ESP32/humidity_pub";
const char *moisture_pub = "ESP32/moisture_pub";
const char *water_level_pub = "ESP32/water_level_pub";
const char *temp_sub = "ESP32/temp_sub";
const char *humidity_sub = "ESP32/humidity_sub";
const char *moisture_sub = "ESP32/moisture_sub";

// make a client
WiFiClientSecure espClient;
PubSubClient myclient(espClient);


// define the certificate
static const char *root_ca PROGMEM = R"EOF(
-----BEGIN CERTIFICATE-----
MIIFazCCA1OgAwIBAgIRAIIQz7DSQONZRGPgu2OCiwAwDQYJKoZIhvcNAQELBQAw
TzELMAkGA1UEBhMCVVMxKTAnBgNVBAoTIEludGVybmV0IFNlY3VyaXR5IFJlc2Vh
cmNoIEdyb3VwMRUwEwYDVQQDEwxJU1JHIFJvb3QgWDEwHhcNMTUwNjA0MTEwNDM4
WhcNMzUwNjA0MTEwNDM4WjBPMQswCQYDVQQGEwJVUzEpMCcGA1UEChMgSW50ZXJu
ZXQgU2VjdXJpdHkgUmVzZWFyY2ggR3JvdXAxFTATBgNVBAMTDElTUkcgUm9vdCBY
MTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAK3oJHP0FDfzm54rVygc
h77ct984kIxuPOZXoHj3dcKi/vVqbvYATyjb3miGbESTtrFj/RQSa78f0uoxmyF+
0TM8ukj13Xnfs7j/EvEhmkvBioZxaUpmZmyPfjxwv60pIgbz5MDmgK7iS4+3mX6U
A5/TR5d8mUgjU+g4rk8Kb4Mu0UlXjIB0ttov0DiNewNwIRt18jA8+o+u3dpjq+sW
T8KOEUt+zwvo/7V3LvSye0rgTBIlDHCNAymg4VMk7BPZ7hm/ELNKjD+Jo2FR3qyH
B5T0Y3HsLuJvW5iB4YlcNHlsdu87kGJ55tukmi8mxdAQ4Q7e2RCOFvu396j3x+UC
B5iPNgiV5+I3lg02dZ77DnKxHZu8A/lJBdiB3QW0KtZB6awBdpUKD9jf1b0SHzUv
KBds0pjBqAlkd25HN7rOrFleaJ1/ctaJxQZBKT5ZPt0m9STJEadao0xAH0ahmbWn
OlFuhjuefXKnEgV4We0+UXgVCwOPjdAvBbI+e0ocS3MFEvzG6uBQE3xDk3SzynTn
jh8BCNAw1FtxNrQHusEwMFxIt4I7mKZ9YIqioymCzLq9gwQbooMDQaHWBfEbwrbw
qHyGO0aoSCqI3Haadr8faqU9GY/rOPNk3sgrDQoo//fb4hVC1CLQJ13hef4Y53CI
rU7m2Ys6xt0nUW7/vGT1M0NPAgMBAAGjQjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNV
HRMBAf8EBTADAQH/MB0GA1UdDgQWBBR5tFnme7bl5AFzgAiIyBpY9umbbjANBgkq
hkiG9w0BAQsFAAOCAgEAVR9YqbyyqFDQDLHYGmkgJykIrGF1XIpu+ILlaS/V9lZL
ubhzEFnTIZd+50xx+7LSYK05qAvqFyFWhfFQDlnrzuBZ6brJFe+GnY+EgPbk6ZGQ
3BebYhtF8GaV0nxvwuo77x/Py9auJ/GpsMiu/X1+mvoiBOv/2X/qkSsisRcOj/KK
NFtY2PwByVS5uCbMiogziUwthDyC3+6WVwW6LLv3xLfHTjuCvjHIInNzktHCgKQ5
ORAzI4JMPJ+GslWYHb4phowim57iaztXOoJwTdwJx4nLCgdNbOhdjsnvzqvHu7Ur
TkXWStAmzOVyyghqpZXjFaH3pO3JLF+l+/+sKAIuvtd7u+Nxe5AW0wdeRlN8NwdC
jNPElpzVmbUq4JUagEiuTDkHzsxHpFKVK7q4+63SM1N95R1NbdWhscdCb+ZAJzVc
oyi3B43njTOQ5yOf+1CceWxG1bQVs5ZufpsMljq4Ui0/1lvh+wjChP4kqKOJ2qxq
4RgqsahDYVvTH9w7jXbyLeiNdd8XM2w9U/t7y0Ff/9yi0GE44Za4rF2LN9d11TPA
mRGunUHBcnWEvgJBQl9nJEiU0Zsnvgc/ubhPgXRR4Xq37Z0j4r7g1SgEEzwxA57d
emyPxgcYxn/eR44/KJ4EBs+lVDR3veyJm+kXQ99b21/+jh5Xos1AnX5iItreGCc=
-----END CERTIFICATE-----
)EOF";


// initialzie variables
int moisture_input, humidity_input, min_humidity_input, max_humidity_input, water_level_value, moisture_value, humidity_value;
float temp_input, min_temp_input, max_temp_input, temp_value;

// Variable to hold the page currently displayed on the screen.
int currentPage = 0;

// variables to check if the sensors read the same values or not
int moisture_checker = -1, humidity_checker = -1, water_level_checker = -1;
float temp_checker = -1;

// check if the user enter numbers as input
int temp_input_checker = 0, humidity_input_checker = 0, moisture_input_checker = 0;

// objects
DHT dht(DHT22_pin, DHTTYPE);

// define our LCD
LiquidCrystal_I2C lcd(0x27, 16, 2);  

void setup(){
  Serial.begin(115200);

  // initialize LCD
  lcd.init();
  
  // clear the screen
  lcd.clear();
  
  // turn on LCD backlight                      
  lcd.backlight();


  dht.begin();
  wifiConnection();
  espClient.setCACert(root_ca);
  myclient.setServer(cluster_url, port);
  myclient.setCallback(mycallback);
  serverConnect();

  // configure the pins
  pinMode(humidifier_relay_pin, OUTPUT);
  pinMode(fan_relay_pin, OUTPUT);
  pinMode(heater_relay_pin, OUTPUT);
  pinMode(pump_relay_pin, OUTPUT);
  pinMode(temp_led_pin, OUTPUT);
  pinMode(humidity_led_pin, OUTPUT);
  pinMode(water_level_led_pin, OUTPUT);
  pinMode(buzzer_pin, OUTPUT);
  pinMode(button_up_pin, INPUT);
  pinMode(button_down_pin, INPUT);
}


void loop(){
  // DHT22 sensor readings
  temp_value = dht.readTemperature();
  humidity_value = dht.readHumidity();

  // Water_level sensor readings
  water_level_value = analogRead(water_level_pin);

  // mapping the water_level according to our tank (in millimeters)
  int mapped_value_water_level = map(water_level_value, 0, 4095, 0, 40);

  // soil_moisture sensor readings
  moisture_value = analogRead(moisture_pin);

  // mapping the soil_moisture in percentage
  int mapped_value_moisture = map(moisture_value, 0, 4095, 100, 0);

  if (!myclient.connected()) {
      Serial.println("Reconnect to server...");
      serverConnect();
  }
  myclient.loop();

  // temp publish
  if(temp_checker != temp_value){
    myclient.publish(temp_pub, String(temp_value).c_str());
    temp_checker = temp_value; 
  }
  
  // himidity publish
  if(humidity_checker != humidity_value){
    myclient.publish(humidity_pub, String(humidity_value).c_str());
    humidity_checker = humidity_value;
  }

  // soil moisture publish
  if(moisture_checker != mapped_value_moisture){
    myclient.publish(moisture_pub, String(mapped_value_moisture).c_str());
    moisture_checker = mapped_value_moisture; 
  }

  // water level publish
  if(water_level_checker != mapped_value_water_level){
    myclient.publish(water_level_pub, String(mapped_value_water_level + 10).c_str());
    water_level_checker = mapped_value_water_level; 
  }

    lcd.clear();
     // set cursor to first column, first row
    lcd.setCursor(0, 0);
  // Display sensor readings by two touch buttouns
  switch (currentPage) {
    case 0:
      lcd.print("The temp: " + String(temp_value) + " C");
      break;

    case 1:
      lcd.print("The humidity: " + String(humidity_value) + "%");
      break;

    case 2:
      if(mapped_value_water_level == 0){
        lcd.print("Water <= 10 mm");
      }
      else{
        lcd.print("Water lvl: " + String(mapped_value_water_level + 10) + " mm");
      }
      break;

    case 3:
     lcd.print("soil moist: " + String(mapped_value_moisture) + "%");
      break;
  }

// Checking if UP button is pressed
  if (digitalRead(button_up_pin) == HIGH) {
    Serial.println("Button up pressed");
    if (currentPage > 0) {
      currentPage--;
    } else if (currentPage == 0){
      currentPage = 3;
    }
    delay(200); // Debounce delay
  }

  // Checking if DOWN button is pressed
  if (digitalRead(button_down_pin) == HIGH) {
    Serial.println("Button down pressed");
    if (currentPage < 3) {
      currentPage++;
      
    } else if (currentPage == 3){
      currentPage = 0;
    }
    delay(200); // Debounce delay
  }

  // Check if the water level is under a threshold
  if (mapped_value_water_level < 6){
    digitalWrite(water_level_led_pin, HIGH); // Turn the LED on
    tone(buzzer_pin, 262, 250); // warning of Low Water Level  
  }
  else {
    digitalWrite(water_level_led_pin, LOW); // Turn the LED off
    noTone(buzzer_pin); // stop the warning
  }

  if(moisture_input_checker != 0){
    // check the moisture of the soil
    if (mapped_value_moisture < moisture_input) {
      // activate the water pump
      digitalWrite(pump_relay_pin, HIGH);
    }
    
    else {
      // deactivate the water pump
      digitalWrite(pump_relay_pin, LOW);
    }

  }

  if(temp_input_checker != 0){
    // check the temperature of the air inside the greenhouse
    if(temp_value > max_temp_input){
      // the temperture is high ==> activate the fan & deactivate the heater
      digitalWrite(temp_led_pin, HIGH);
      digitalWrite(heater_relay_pin, LOW);
      digitalWrite(fan_relay_pin, HIGH);
    }

    else if (temp_value < min_temp_input){
      // the temperture is low ==> activate the heater
      digitalWrite(temp_led_pin, HIGH);
      digitalWrite(heater_relay_pin, HIGH);
    }

    else {
      // the temperture is good ==> deactivate the heater
      digitalWrite(temp_led_pin, LOW);
      digitalWrite(heater_relay_pin, LOW);
    }
  }

  if(humidity_input_checker != 0){
    // check the humidity of the air inside the greenhouse
    if (humidity_value > max_humidity_input){
      // the humidity is high ==> activate the fan & deactivate the humidifier    
      digitalWrite(humidity_led_pin, HIGH);
      digitalWrite(humidifier_relay_pin, LOW);
      digitalWrite(fan_relay_pin, HIGH);
    }

    else if (humidity_value < min_humidity_input){
      // The humidity is low ==> activate the humdifier 
      digitalWrite(humidity_led_pin, HIGH);
      digitalWrite(humidifier_relay_pin, HIGH);
    }

    else{
      // the humidity is good ==> deactivate the humidifier
      digitalWrite(humidity_led_pin, LOW);
      digitalWrite(humidifier_relay_pin, LOW);
    }
  }

  if((temp_value >= min_temp_input && temp_value <= max_temp_input) && (humidity_value >= min_humidity_input && humidity_value <= max_humidity_input)){
    // the temperature is good and the humidity is good ==> deactivate the fan
    digitalWrite(fan_relay_pin, LOW);
  }

  delay(300);
}

void wifiConnection()
{
  const char *ssid = "Wokwi-GUEST";
  const char *password = "";
  Serial.print("Connecting to ");
  Serial.println(ssid);
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED){
    delay(100);
    Serial.print(".");
  }
  
  Serial.println("\nWifi Connected");
  lcd.setCursor(0, 0);
  lcd.print("IP address: ");
  lcd.setCursor(0, 1);
  lcd.print(WiFi.localIP());
  delay(1000);
}

void mycallback(char *topic, byte *payload, unsigned int length) {
  String message = "";
  for (int i = 0; i < length; i++) {
    message += (char) payload[i];
  }

  if(strcmp(topic, temp_sub) == 0){
    temp_input = message.toFloat();
    min_temp_input = temp_input - 0.5;
    max_temp_input = temp_input + 0.5;
    Serial.println("Received temperature: " + String(temp_input));
    temp_input_checker = 1;
  }
  
  else if(strcmp(topic, humidity_sub) == 0){
    humidity_input = message.toInt();
    min_humidity_input = humidity_input - 2;
    max_humidity_input = humidity_input + 2;
    Serial.println("Received humidity: " + String(humidity_input));
    humidity_input_checker = 1;
  }

  else if(strcmp(topic, moisture_sub) == 0){
    moisture_input = message.toInt();
    Serial.println("Received soil moisture: " + String(moisture_input));
    moisture_input_checker = 1;
  }

  else{
    Serial.println("Received message on unknown topic!!");
  }

}


void serverConnect(){
  while (!myclient.connected()) {
    String client_id = "esp32-client-";
    client_id += String(WiFi.macAddress());
    Serial.print("Connecting to the server....");
    if (myclient.connect(client_id.c_str(), user_name, client_password)){
      Serial.println("\nServer Connected");
      myclient.subscribe(temp_sub);
      myclient.subscribe(humidity_sub);
      myclient.subscribe(moisture_sub);
    }
    else{
      Serial.print("failed with state ");
      Serial.println(myclient.state());
      delay(2000);
    }
  }
}