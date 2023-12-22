// ENTRADAS
const int DHT = 34;   // Sensor de temperatura
const int AOUT = 32;  // PIN Sensor de gas
const int DOUT = 16;  // PIN Sensor de gas
const int IN0 = 33;   // Entrada Digital 0
const int IN1 = 15;   // Entrada Digital 1
const int AI0 = 39;   // Entrada Analogica 0
const int AI1 = 36;   // Entrada Analogica 1

// SENSORES DE ULTRASONIDO
const int ECHO1 = 25;
const int TRIG1 = 26;
const int ECHO2 = 27;
const int TRIG2 = 14;
const int ECHO3 = 12;
const int TRIG3 = 13;

// SALIDAS
const int Q2 = 16;
const int Q3 = 17;
const int RLY = 4;
const int BUZZER = 5;

// I2C
// SCL = 22;
// SDA = 21;

void setup() {
  // Cambiar el numero de TRIG y ECHO para probar diferentes entradas de ultrasonido.
  Serial.begin(9600);//iniciailzamos la comunicación
  pinMode(TRIG1, OUTPUT); //pin como salida
  pinMode(ECHO1, INPUT);  //pin como entrada
  digitalWrite(TRIG1, LOW);//Inicializamos el pin con 0
}

void loop()
{
  long t; //timepo que demora en llegar el eco
  long d; //distancia en centimetros

  // Cambiar el numero de TRIG y ECHO para probar diferentes entradas de ultrasonido.
  digitalWrite(TRIG1, HIGH);
  delayMicroseconds(10);          //Enviamos un pulso de 10us
  digitalWrite(TRIG1, LOW);
  
  t = pulseIn(ECHO1, HIGH); //obtenemos el ancho del pulso
  d = t/59;             //escalamos el tiempo a una distancia en cm
  
  Serial.print("Distancia: ");
  Serial.print(d);      //Enviamos serialmente el valor de la distancia
  Serial.print("cm");
  Serial.println();
  delay(100);          //Hacemos una pausa de 100ms
}