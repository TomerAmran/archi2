
#include "stdio.h"
#include "stdlib.h"
#include "linux/limits.h"
#include "unistd.h"
#include "errno.h"
#include "string.h"
#include "wait.h"
#include <sys/wait.h> 
#include <fcntl.h>
#define	MAX_LEN 80			/* maximal input string size */
					/* enough to get 32-bit string + '\n' + null terminator */
extern int calculator();
void compareFiles(FILE *fp1, FILE *fp2);


int main(int argc, char** argv)
{
  char testIndex='6';//CHANGE TEST NUMBER HERE !(1-6)

  char inputFile [11]="input1.txt";
  char* outputFile ="output.txt";
  char exp[20]="expectedOutput1.txt";
  printf("Test number:%c\n",testIndex);

  inputFile[5]=testIndex;
  exp[14]=testIndex;

  int stdin_copy = dup(0);
  int stdout_copy = dup(1);
  close(STDIN_FILENO);
  close(STDOUT_FILENO);
  FILE* file;

  open(inputFile,O_RDONLY);
  file=fopen(outputFile,"w");

   calculator();			/* call your assembly function */
    fflush(file);
    fflush(stdout);
    close(file->_fileno);
    dup2(stdout_copy, 1);
  
  FILE* fileOut1=fopen(outputFile,"r");
  FILE* fileOut2=fopen(exp,"r");

  if(fileOut2!=NULL){
    compareFiles(fileOut1,fileOut2);
  }

  close(stdin_copy);
  close(stdout_copy);
  
 // }
  return 0;
}

void compareFiles(FILE *fp1, FILE *fp2) 
{ 
  if(fp1->_fileno<0||fp2->_fileno<0){
    printf("error has occuered\n");
    return;
  }

    // fetching character of two file 
    // in two variable ch1 and ch2 
    char ch1 = getc(fp1); 
    char ch2 = getc(fp2); 
  
    // error keeps track of number of errors 
    // pos keeps track of position of errors 
    // line keeps track of error line 
    int error = 0, pos = 0, line = 1; 
    int flag;
    // iterate loop till end of file 
    while (ch1 != EOF && ch2 != EOF) 
    {
       flag=0;
        pos++; 
  
        // if both variable encounters new 
        // line then line variable is incremented 
        // and pos variable is set to 0 
        if (ch1 == '\n' && ch2 == '\n') 
        {  
            line++; 
            pos = 0; 
        } 
  
        // if fetched data is not equal then 
        // error is incremented 
        if (ch1 != ch2) 
        {   flag=1;
            error++; 
            printf("Line Number : %d \tError"
               " Position : %d \n", line, pos);
               while(ch1!='\n'){
                 if(ch1==EOF){
                   printf("program terminated with error");
                   break;
                 }
                 ch1 = getc(fp1);  
               } 
               while(ch2!='\n'){
                 ch2 = getc(fp2);
                  if(ch2==EOF){
                   printf("program terminated with error");
                   break;
                 }
               }
               pos=0;
        } 
  
        // fetching character until end of file 
        if(flag!=1){
          ch1 = getc(fp1); 
          ch2 = getc(fp2); 
        }
        
    } 
  
    printf("Total Errors : %d\n", error); 
} 
