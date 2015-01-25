#include<stdio.h>
#include<conio.h>
#include<dos.h>
#include<stdlib.h>

const header = 126; // Header size
long int acc;
int MAXEQUAL;

void write_equal(int n,FILE *F,char test,int pos)
{
     if (test==0) {
         fputc(n,F);
     }
     acc++;
}

void write_mod(int n,char *buf,FILE *F,char test,int pos)
{
     if (test==0) {
         fputc(n+pos,F);
         fwrite(buf,1,n,F);
     }
     acc+=(1+n);     
}

void compute(char *buf1,char *buf2,FILE *F3,long int size1,long int size2,char test,int pos)
{
    long i;
    int moddistance,equal,mod;
    char bufmod[256];
    int d1,d2;     
    moddistance=MAXEQUAL;
    equal=0;
    mod=0;
    for(i=0;i<size2;i++)
     {
       if (i<size1) d1=buf1[i];
               else d1=-1;
       d2=buf2[i];
       if (d1==d2)       
        if (moddistance<MAXEQUAL) { // parte modificata troppo vicina, continua con MOD
           bufmod[mod++]=(char)d2;
           moddistance++;
        }
        else if (mod!=0) {          // Altrimenti salvo il mod e parto con l'equal
              write_mod(mod-MAXEQUAL,bufmod,F3,test,pos);
              mod=0;
              equal=MAXEQUAL+1;
        }
        else equal++;               // Altrimenti proseguo con l'equal        
       else {                       // Altrimenti proseguo col mod
        moddistance=0;
        if (equal!=0) {             // Se venivo da un equal, lo salvo e parto col mod
                      write_equal(equal,F3,test,pos);
                      mod=0;                 
                      equal=0;
        }
        bufmod[mod++]=(char)d2;
       }                           
       if ((equal==(pos-1))||(equal!=0&&(i==size2-1))) {
                      write_equal(equal,F3,test,pos);
                      equal=0;                      
       }
       if ((mod==(255-pos))||(mod!=0&&(i==size2-1))) {
                      write_mod(mod,bufmod,F3,test,pos);
                      mod=0;
       }       
     }
     write_equal(0,F3,test,pos);     // End
}

long int getsize(FILE *F)
{
     long int size;
     fseek(F, 0L, SEEK_END);
     size = ftell(F);
     fseek(F, 0L, SEEK_SET);          
     return(size);     
}

int main(int argc,char *argv[])
{
     FILE *F1,*F2,*F3;
     int index=0,i,me=0;
     long int size1,size2,min;
     char test,*buf1,*buf2,headbuf[header];
     if (argc!=3) {
        printf("Wrong syntax\n");
        printf("Usage:\n");
        printf("   diffsid file1.sid file2.sid\n");        
        exit(-1);
     }
     F1=fopen(argv[1],"rb");
     if (F1==NULL) {
        printf("Can't open %s.\n",argv[1]);
        return(-1);
     }
     F2=fopen(argv[2],"rb");
     if (F2==NULL) {
        printf("Can't open %s.\n",argv[2]);
        fclose(F1);        
        return(-1);
     }     
     F3=fopen("rlcoded.dat","wb");
     if (F3==NULL) {
        printf("Can't open rlcoded.dat.\n");
        fclose(F2);
        fclose(F1);        
        return(-1);
     }    
     size1=getsize(F1)-header;
     size2=getsize(F2)-header;     
     if (size1<0||size2<0) {
        printf("Incorrect files size");
        fclose(F3);
        fclose(F2);
        fclose(F1);
        exit(-1);
     }                 
     min=size2;
     buf1=(char *)malloc(size1);
     if (buf1==NULL) {
        printf("Not enough memory\n");
        fclose(F3);
        fclose(F2);
        fclose(F1);                
        return(-1);
     }
     buf2=(char *)malloc(size2);     
     if (buf2==NULL) {
        printf("Not enough memory\n");
        free(buf1);
        fclose(F3);
        fclose(F2);
        fclose(F1);        
        return(-1);
     }     
     fread(headbuf,1,header,F1);
     fread(headbuf,1,header,F2);
     fread(buf1,1,size1,F1);
     fread(buf2,1,size2,F2);
     test=1;
     for(MAXEQUAL=1;MAXEQUAL<5;MAXEQUAL++)
          for(i=5;i<250;i++) {
            acc=0;
            compute(buf1,buf2,F3,size1,size2,test,i);
            if (acc<min) {
                    min=acc;
                    index=i;
                    me=MAXEQUAL;
                    }
          }                                  
     acc=0;          
     MAXEQUAL=me;          
     printf("Best separator: %d\nSize: %ld\nMax equal: %d\n",index,min,MAXEQUAL);
     write_equal(0,F3,0,index);           // Save lo ptr
     write_equal(160,F3,0,index);         // Save hi ptr  
     write_equal(index,F3,0,index);       // Save divide value       
     compute(buf1,buf2,F3,size1,size2,0,index);                   
     free(buf1);
     free(buf2);     
     fclose(F3);
     fclose(F2);
     fclose(F1);          
     return(0);
}
