#include <stdlib.h>
#include <stdio.h>
typedef struct link{
    char value;
    struct link* next;
} __attribute__((packed)) link;
void printN(link* l){
    link* curr = l;
    while(curr){
        char v = curr->value;
        printf("%hhX->", v);
        curr = curr->next;
    }
}
extern void debug(link** stack, link** stackBase, int capacity, int size){
    printf("###DEBUG###\n");
    printf("size: %d\n", size);
    printf("stack-index: %d\n", (stack-stackBase));
    // printf("stack: %d\n", (int)(stack));
    // printf("stackBase: %d\n", (int)(stackBase));
    
    for (int i=0; i< capacity; i++){
        if (i == stack - stackBase)
            printf("*");
        printf("s[%d]:->",i);
        printN(stackBase[i]);
        puts("\n");
    }
    printf("##########\n");

}