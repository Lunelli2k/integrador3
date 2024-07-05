/*********
  Rui Santos
  Complete project details at http://randomnerdtutorials.com  
*********/

// Load Wi-Fi library
#include <WiFi.h>
#include <HTTPClient.h>
#include <string>
#include <ArduinoJson.h>

// Replace with your network credentials
// const char* UBIDOTS_TOKEN = "BBUS-RoAbH8MBaivX9WF1Pi59MLxdH1Ne3q";
// const char* ssid = "hentzrafael";
// const char* password = "unoesc123";

// Conexão do termistor
const int pinTermistor = 4;
const int pinRele = 5;
 
// Parâmetros do termistor
const double beta = 3600.0;
const double r0 = 10000.0;
const double t0 = 273.0 + 25.0;
const double rx = r0 * exp(-beta/t0);
 
// Parâmetros do circuito
const double vcc = 5.0;
const double R = 200.0;
 
// Numero de amostras na leitura
const int nAmostras = 5;


void setup() {
  Serial.begin(115200);
  pinMode(4, INPUT);
  pinMode(5, OUTPUT);
  WiFi.begin(ssid, password);

    while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi..");
  }

  Serial.println("Connected to the WiFi network");
}

void loop() {


  // Le o sensor algumas vezes
  int soma = 0;
  for (int i = 0; i < nAmostras; i++) {
    soma += analogRead(pinTermistor);
    delay (10);
  }
 
  // Determina a resistência do termistor
  double v = (vcc*soma)/(nAmostras*2048.0);
  double rt = (vcc*R)/v - R;
 
  // Calcula a temperatura
  double t = beta / log(rt/rx);
  double temp = t-273.0;
  Serial.println (t-273.0);

  if ((WiFi.status() == WL_CONNECTED)) { //Check the current connection status

  HTTPClient http;

  http.begin("https://rmm.agp.app.br/api/enviar_estado"); //Specify the URL
  http.addHeader("Content-Type", "application/json");


  String body = "{\"value\":" + String(temp) + "}";

  int httpResponseCode = http.POST(body);
                                        //Make the request

  if(httpResponseCode>0){
  
    String response = http.getString();                       //Get the response to the request
  
    Serial.println(httpResponseCode);   //Print return code
    Serial.println(response);           //Print request answer
  
  }else{
  
    Serial.print("Error on sending POST: ");
    Serial.println(httpResponseCode);
  
  }

    http.end(); //Free the resources
  }


 /* if ((WiFi.status() == WL_CONNECTED)) { //Check the current connection status
  
    HTTPClient httpGET;
  
    httpGET.begin("https://industrial.api.ubidots.com/api/v1.6/devices/esp32/temperatura/values/?page_size=1"); //Specify the URL
  
    int httpCode = httpGET.GET();                                        //Make the request
  
    if (httpCode > 0) { //Check for the returning code
  
        String payload = httpGET.getString();
        Serial.println(httpCode);
        Serial.println(payload);


        StaticJsonDocument<200> doc;
        // Parse do JSON
        DeserializationError error = deserializeJson(doc, payload);

        // Verifique se houve erro no parse
        if (error) {
          Serial.print("Falha ao analisar o JSON: ");
          Serial.println(error.c_str());
          return;
        }

        // Extraia o valor da propriedade "value"
        double valor = doc["results"][0]["value"];
        Serial.print("Valor extraído do JSON: ");
        Serial.println(valor);


        if (valor < 0){
          digitalWrite(pinRele, HIGH);
        }

      }
  
    else {
      Serial.println("Error on HTTP request");
    }
  
    httpGET.end(); //Free the resources
  }/*


  delay(5000);
}