#include <io.h>
#include <delay.h>
#include <lcd.h>
#include <stdio.h>
#include <math.h>

#asm
.equ __lcd_port = 0x1b
#endasm

#define GYRO_LSB 131.0
#define GYRO_WEIGHT 0.98
#define ACCEL_WEIGHT 0.02
#define DELTA_TIME 0.001

typedef struct {
	int x;
	int y;
	int z;
} Gyro;

typedef struct {
	int x;
	int y;
	int z;
} Accel;

typedef struct {
	float x;
	float y;
	float z;
} Angle;

void setUp();
void I2C_init(void);
void I2C_write(unsigned char slv_addr,
		unsigned char regi_addr,
		unsigned char data);

int I2C_read(unsigned char slv_addr, unsigned char regi_addr);

void getRawData(int *rawData);
void updateAngle(int *rawData, Angle *angle);
void putch(char data);
void sendAngle(Angle angle);

void main()
{
	char firstBuf[20];
	char secondBuf[20];
	int rawData[10];

	Angle angle;
	angle.x = 0;
	angle.y = 0;

	setUp();

	while(1)
	{
		getRawData(rawData);

		updateAngle(rawData, &angle);

		sprintf(firstBuf, "XANGLE : %5d",(int)angle.x);
		sprintf(secondBuf, "YANGLE : %5d",(int)angle.y);

		lcd_gotoxy(0, 0);
		lcd_puts(firstBuf);
		lcd_gotoxy(0, 1);
		lcd_puts(secondBuf);

		sendAngle(angle);
	}
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

void I2C_init(void)
{
	TWBR = 74;
	TWSR = 0;
	delay_ms(100);
}

void I2C_write(unsigned char slv_addr,
		unsigned char regi_addr,
		unsigned char data) {

	delay_ms(1);

	TWCR = 0xA4; // Start
	while(((TWCR & 0x80) == 0x00) || (TWSR & 0xF8) != 0x08);
	//Wait for TWINT flag set. This indicates that
	//the START condition has been transmitted

	//Check value of TWI Status Register. Mask
	//prescaler bits. If status different from START
	//go to ERROR

	TWDR = slv_addr; // data
	TWCR = 0x84;
	while(((TWCR & 0x80) == 0x00) || (TWSR & 0xF8) != 0x18);
	// SLA + W transmitted, ACK received

	TWDR = regi_addr;
	TWCR = 0x84;
	while(((TWCR & 0x80) == 0x00) || (TWSR & 0xF8) != 0x28);
	// data transmitted, ACK received

	TWDR = data;
	TWCR = 0x84;
	while(((TWCR & 0x80) == 0x00) || (TWSR & 0xF8) != 0x28);

	TWCR = 0x94; // stop
}

int I2C_read(unsigned char slv_addr, unsigned char regi_addr)
{
	unsigned int result;
	delay_ms(1);

	TWCR = 0xA4;

	while(((TWCR & 0x80) == 0x00) || (TWSR & 0xF8) != 0x08);
	TWDR = slv_addr;
	TWCR = 0x84;
	delay_us(50);

	while(((TWCR & 0x80) == 0x00) || (TWSR & 0xF8) != 0x18); // MT_SLV_ACK
	TWDR = regi_addr;
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

void getRawData(int *rawData)
{
	//AccelX H & L
	rawData[0] = I2C_read(0xd0, 0x3B);
	rawData[1] = I2C_read(0xd0, 0x3C);

	//AccelY H & L
	rawData[2] = I2C_read(0xd0, 0x3D);
	rawData[3] = I2C_read(0xd0, 0x3E);

	//AccelZ H & L
	rawData[4] = I2C_read(0xd0, 0x3F);
	rawData[5] = I2C_read(0xd0, 0x40);

	//GyroX H & L
	rawData[6] = I2C_read(0xd0, 0x43);
	rawData[7] = I2C_read(0xd0, 0x44);

	//GyroY H & L
	rawData[8] = I2C_read(0xd0, 0x45);
	rawData[9] = I2C_read(0xd0, 0x46);

}

void updateAngle(int *rawData, Angle *angle)
{
	Accel accel;
	Gyro gyro;

	float gyro_x_angle;
	float gyro_y_angle;
	float accel_x_angle;
	float accel_y_angle;

	accel.x = rawData[0] << 8 | rawData[1];
	accel.y = rawData[2] << 8 | rawData[3];
	accel.z = rawData[4] << 8 | rawData[5];

	gyro.x = rawData[6] << 8 | rawData[7];
	gyro.y = rawData[8] << 8 | rawData[9];

	gyro_x_angle = gyro.x / GYRO_LSB;
	gyro_y_angle = gyro.y / GYRO_LSB;

	// radian to degired
	accel_x_angle = atan2((float)accel.x, (float)accel.z) * 180 / PI;
	accel_y_angle = atan2((float)accel.y, (float)accel.z) * 180 / PI;

	angle->x = ( GYRO_WEIGHT * ( angle->x + ( gyro_x_angle * DELTA_TIME) ) +
			( ACCEL_WEIGHT * accel_x_angle ) );

	angle->y = ( GYRO_WEIGHT * ( angle->y + ( gyro_y_angle * DELTA_TIME) ) +
			( ACCEL_WEIGHT * accel_y_angle ) );

}

void putch(char data)
{
	while(!(UCSR0A & 0x20));
	UDR0 = data;
}

void sendAngle(Angle angle)
{
	int i = 0;
	char sendBuff[40];

	sprintf(sendBuff, "%d", (int)angle.x);

	while(sendBuff[i] != '\0')
	{
		putch(sendBuff[i]);
		++i;
	}
}
