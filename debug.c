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
        printf("%d->", v);
        curr = curr->next;
    }
}
extern void printStack(link** stackBase, int capacity){
    printf("size of link:%d\n", sizeof(link));
    for (int i=0; i< capacity; i++){
        printf("s[%d]:->",i);
        printN(stackBase[i]);
        puts("\n");
    }
}