/*
 * RC_car.c
 *
 * Created: 2016-12-13 오후 7:44:23
 * Author: shtow
 */

#include <io.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <lcd.h>

#asm
.equ __lcd_port = 0x1b
#endasm

int i = 0;
char buffer[40];

void setup();
void move(int angle);

void main(void)
{

    lcd_init(16);
    setup();
    
    while (1);
}

void setup()
{ 
	UCSR0A = 0x00;
	UCSR0B = 0x90;
	UCSR0C = 0x06;

	UBRR0H = 0x00;
	UBRR0L = 103; 
      
    DDRD = 0xff; //모터 방향 설정  (enable)
    DDRB = 0xff; //모터 출력 설정
   
    PORTB = 0xff; //모터 테스트 용    
                                 
    SREG = 0x80;
   
}

void move(int angle)
{
    lcd_gotoxy(0, 1);
    if( angle > 90 )
        lcd_puts("go   ");
    else
        lcd_puts("back");
    /*
    if( 90 < angle ) //stop      
    {
        PORTD = 0x00;
    }
    
    else if ( angle >= 100 ) //모름
    {
        PORTD = 0x02;
    }
     
    else
    {
        PORTD = 0x01;
    } 
    */
}

interrupt [USART0_RXC] void get_data(void)
{
    int data;
    char str[40];
    
    buffer[i] = UDR0;  
    
    
    if( buffer[i] == '\0' )
    {           
                         
        lcd_clear();   
        lcd_puts(buffer);
        data = atoi(buffer);
        move(data);    
         
        /*
        sprintf(str,"%d",data);
        
        lcd_gotoxy(0,0);
        lcd_puts(str); 
        */             
        
        i=0;

    }       
    
    ++i;
}