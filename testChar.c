
#include <stdio.h>
#include <stdlib.h>

int main(void){
    
    int index;
    int i;

    for (i = 0; i < 50000; i++) {

        index = rand() % 0x7F;

        if ((index == 0x09 || index == 0x0A) || (index >= 0x20 && index <= 0x7E)) {
            putchar(index);
        } 
        else {
            i--;
        } 

    } 
    return 0;
} 


