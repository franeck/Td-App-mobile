# TD App Mobile

Ce TD va vous permettre de prendre en main la gestion d'une App Mobile sur vos objets connectés.

## Exercice 1 : Configuration + Hello World

Pour commencer, il faut telecharger le logiciel EvoThings sur votre pc et un viewer sur votre télephone.

L'application Evothings va nous permettre de convertir notre code HTML CSS Javascript en Android.

Une fois le logiciel telechargé, rendez vous sur le lien suivant et suivre la partie "First time step-by-step guide" pour initier une connexion entre votre pc et votre smartphone.
https://evothings.com/doc/tutorials/evothings-studio-getting-started.html

Vous pouvez telecharger le dossier Hell_World et le placer dans C:\Users\VotreNom\EvothingsStudio\Myapps\

Lancer maintenant votre votre projet HelloWorld sur le logiciel dans la partie MyApps.

## Exercice 2 :

Nous allons maintenant utiliser notre smartphone pour controler une LED à distance.

Pour ce faire nous allons utiliser une communication via wifi pour commander notre LED.

Il faut donc configurer notre ESP en consequence.

Pour commencer, il nous faut importer la librairie ESP8266WiFi :

#include <ESP8266WiFi.h>

On definit les identifiants de connexion du wifi sur lequel votre ESP va venir se connecter:

const char* ssid = "VotreRéseau";
const char* password = "VotreMdp";
const int ledPin = 2;
WiFiServer server(1337);

Dans la fonction setup(), on se connecte à notre wifi et on configure la LED :


void setup(void) {
  Serial.begin(115200);
  WiFi.begin(ssid, password);

  // Configure GPIO2 as OUTPUT.
  pinMode(ledPin, OUTPUT);

  // Start TCP server.
  server.begin();
}
Afin de récupérer les données reçues via le wifi, à chaque tour de boucle (fonction loop) on vérifie si l'on a reçu ou non des données. Si c'est le cas, on vérifie leurs valeurs et on agit en conséquence.

void loop(void) {
  WiFiClient client = server.available();

  if (client) {
    Serial.println("Client connected.");

    while (client.connected()) {
      if (client.available()) {
        //On recupere les données envoyées par le client
        char command = client.read();
        //On allume la LED
        if (command == 'H') { 
          digitalWrite(ledPin, HIGH);
          Serial.println("LED is now on.");
        }
        //On eteint la LED
        else if (command == 'L') {
          digitalWrite(ledPin, LOW);
          Serial.println("LED is now off.");
        }
      }
    }
    Serial.println("Client disconnected.");
    client.stop();
  }
}

Vous avez maintenant un code fonctionnel. Afin de le tester, vous pouvez télecharger le dossier ExerciceLed à mettre dans myapps sur le logiciel Evothings.

Téléversez le code ci-dessous en changeant les data d'accés à votre wifi pour obtenir l'adresse IP de votre ESP, elle vous sera utile pour vous connecter à votre ESP 
lors du lancement de l'application mobile.

#include <ESP8266WiFi.h>

const char* ssid = "Gandin";
const char* password = "012301230123";
const int ledPin = 2;
WiFiServer server(1337);

void printWiFiStatus();

void setup(void) {
  Serial.begin(115200);
  WiFi.begin(ssid, password);

  // Configure GPIO2 as OUTPUT.
  pinMode(ledPin, OUTPUT);

  // Start TCP server.
  server.begin();
}

void loop(void) {
  // Check if module is still connected to WiFi.
  if (WiFi.status() != WL_CONNECTED) {
    while (WiFi.status() != WL_CONNECTED) {
      delay(500);
    }
    // Print the new IP to Serial.
    printWiFiStatus();
  }

  WiFiClient client = server.available();

  if (client) {
    Serial.println("Client connected.");

    while (client.connected()) {
      if (client.available()) {
        char command = client.read();
        if (command == 'H') {
          digitalWrite(ledPin, HIGH);
          Serial.println("LED is now on.");
        }
        else if (command == 'L') {
          digitalWrite(ledPin, LOW);
          Serial.println("LED is now off.");
        }
      }
    }
    Serial.println("Client disconnected.");
    client.stop();
  }
}

void printWiFiStatus() {
  Serial.println("");
  Serial.print("Connected to ");
  Serial.println(ssid);
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());
}

Lancez l'application mobile et verifiez le bon fonctionnement.
