#include <io.h>
#include <delay.h>
#include <lcd.h>
#include <stdio.h>
#include <math.h>

int rawData[10];
int gyroX, gyroY;
int accX, accY, accZ;

float accXangle, accYangle;
float gyroXangle, gyroYangle;
float xAngle, yAngle;

char sendBuff[40];

#asm
    .equ __lcd_port = 0x1b
#endasm

void I2C_init(void)
{
  TWBR = 74;
  TWSR = 0;
  delay_ms(100);
}

void I2C_write(unsigned char slv_addr, unsigned char address, unsigned char byte)// master
{

  delay_ms(1);


  TWCR = 0xA4; // Start
  while(((TWCR & 0x80) == 0x00) || (TWSR & 0xF8) != 0x08); //Wait for TWINT flag set. This indicates that
        //the START condition has been transmitted

        //Check value of TWI Status Register. Mask
        //prescaler bits. If status different from START
        //go to ERROR

  TWDR = slv_addr; // Address
  TWCR = 0x84;
  while(((TWCR & 0x80) == 0x00) || (TWSR & 0xF8) != 0x18); // SLA + W transmitted, ACK received

  TWDR = address;
  TWCR = 0x84;
  while(((TWCR & 0x80) == 0x00) || (TWSR & 0xF8) != 0x28); // data transmitted, ACK received

  TWDR = byte;
  TWCR = 0x84;
  while(((TWCR & 0x80) == 0x00) || (TWSR & 0xF8) != 0x28);

  TWCR = 0x94; // stop
}

int I2C_read(unsigned char slv_addr, unsigned char regi)  //master
{
  unsigned int result;
  delay_ms(1);

  TWCR = 0xA4;       // MCU?? ??????? ??????? ???? ???
  while(((TWCR & 0x80) == 0x00) || (TWSR & 0xF8) != 0x08);  //TWI?? ?????? ????? ?????? ??????? ||

  TWDR = slv_addr;     // TWI?????? ??? ???? ???? ?? ????
  TWCR = 0x84;

  delay_us(50);
  printf("ack2%c",TWSR);

  while(((TWCR & 0x80) == 0x00) || (TWSR & 0xF8) != 0x18); // MT_SLV_ACK

  TWDR = regi;        // TWI?????? ??? ???? ???????? ??
  TWCR = 0x84;

  delay_us(50);

  while(((TWCR & 0x80) == 0x00) || (TWSR & 0xF8) != 0x28); // MT_DAT_ACK

  TWCR = 0xA4; // Restart
  while(((TWCR & 0x80) == 0x00) || (TWSR & 0xF8) != 0x10); // RESTART

  TWDR = slv_addr+1; // AD+R ??
  TWCR = 0x84;

   delay_us(50);

  while(((TWCR & 0x80) == 0x00) || (TWSR & 0xF8) != 0x40); // MR_SLV_ACK

  TWCR = 0x84;

  delay_us(50);

  while(((TWCR & 0x80) == 0x00) || (TWSR & 0xF8) != 0x58); // MR_DAT_NACK

  result = TWDR;
  TWCR = 0x94; // stop

  return result;
}

void getRawData()
{
    /* ACCEL */
    rawData[0] = I2C_read(0xd0, 0x3B);
    rawData[1] = I2C_read(0xd0, 0x3C);
    
    rawData[2] = I2C_read(0xd0, 0x3D);
    rawData[3] = I2C_read(0xd0, 0x3E);
    
    rawData[4] = I2C_read(0xd0, 0x3F);
    rawData[5] = I2C_read(0xd0, 0x40);
    /* ACCEL */                       
     
    /* GYRO */
    rawData[6] = I2C_read(0xd0, 0x43);
    rawData[7] = I2C_read(0xd0, 0x44);
    rawData[8] = I2C_read(0xd0, 0x45);
    rawData[9] = I2C_read(0xd0, 0x46);
    /* Gyro */
}

void convertData()
{
    accX = rawData[0] << 8 | rawData[1]; 
    accY = rawData[2] << 8 | rawData[3]; 
    accZ = rawData[4] << 8 | rawData[5];
                                 
    gyroX = rawData[6] << 8 | rawData[7];
    gyroY = rawData[8] << 8 | rawData[9];
    
    gyroXangle = gyroX / 131.0;
    gyroYangle = gyroY / 131.0;
        
    accXangle = atan2((float)accX, (float)accZ) * 180 / PI;
    accYangle = atan2((float)accY, (float)accZ) * 180 / PI;
                                     
    xAngle = ( 0.98 * ( xAngle + ( gyroXangle * 0.001) ) + ( 0.02 * accXangle ) ); 
    yAngle = ( 0.98 * ( yAngle + ( gyroYangle * 0.001) ) + ( 0.02 * accYangle ) );  
}

void putch(char data)
{
    while(!(UCSR0A & 0x20));
    UDR0 = data;
}

void setUp()
{
  lcd_init(16);

  I2C_init();
  I2C_write(0xd0, 0x6B, 0); 
  
  UCSR0A = 0x00;
  UCSR0B = 0xA8;
  UCSR0C = 0x06;

  UBRR0H = 0x00;
  UBRR0L = 103;
}

void sendAngle()
{
  int i;
  
  sprintf(sendBuff, "%d", (int)xAngle);

  while(sendBuff[i] != '\0')
  {
    putch(sendBuff[i]);
    ++i;
  }
}

void main()
{                           
    char firstBuf[20];
    char secondBuf[20];
                  
    setUp();

    while(1)
    {            
        getRawData();           
        
        convertData();
        
        sprintf(firstBuf, "XANGLE : %5d",(int)xAngle); 
        sprintf(secondBuf, "YANGLE : %5d",(int)yAngle);   
                                                 
        lcd_gotoxy(0, 0);
        lcd_puts(firstBuf);
        lcd_gotoxy(0, 1);
        lcd_puts(secondBuf);                

        sendAngle();
    }
}