#include<stdio.h>
#include<sys/stat.h>
#include<stdlib.h>
#include<conio.h>
#include<windows.h>
#include<math.h>

#define XPix   68
#define YPix   2
#define M_PI   3.14159265358979323846

char bank[12288];
char bank2[12288];

/*char texture[][XPix]= {
     {3,2,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,2,3,3,1,2,1,2,1,2,1,2,3,1,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,3,3},
     {3,3,2,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,2,3,2,1,2,1,2,1,2,1,3,3,1,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,2,3}};
*/

/*                         
char texture[][XPix]= {
     {0,0,0,3,2,3,3,0,0,0,0,2,1,2,2,0,0,0,0,1,1,3,1,0,0,0,0,3,3,1,3,0,0,0,0,1,2,1,1,0,0,0,0,2,3,2,2,0,0,0},
     {0,0,0,3,3,2,3,0,0,0,0,2,2,1,2,0,0,0,0,1,3,1,1,0,0,0,0,3,1,3,3,0,0,0,0,1,1,2,1,0,0,0,0,2,2,3,2,0,0,0}};
*/

char texture1[YPix][XPix]= {
     {3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,2,2,2,2,2,2,2,2,3,3,3,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,3}};

char texture3[YPix][XPix]= {
     {3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2}};

/*char texture2[8][XPix]= {
     {3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,3,2,3,2,3,2,3,2,2,2,1,2,1,2,1,2,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,3,1,3,1,3,1,3,3,3,3,3,3,3,3,3,3,3,3,3},
     {3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,3,2,3,2,3,2,2,2,2,2,1,2,1,2,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,3,1,3,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3}}; 
*/

                   
// Check if file exists
// ********************
int fileexists(char * fileName)
{
	struct stat buf;
	int i=stat(fileName,&buf);
	if (i==0) return 1;
	return(0);
}

// Compute perpective correction
// *****************************
double perscor(double u0,double u1,double z0,double z1,double a)
{
 double res;
 int valint;
 if (a>1) exit(1);
 double num=(1-a)*u0*z1+a*u1*z0;
 double den=(1-a)*z1+a*z0;
 res=num/den;
 valint=(int)res;
 return(res);
}

// Effectively write on sprite
// ***************************
void writetosprite(int pos,char *row,int NR,int offset)
{
     for(int i=NR-1;i>=0;i--) bank[pos*48+(((i>>2)+offset)&0x3f)]|=(1<<(2*(3-(i&3))))*(row[i]&3);
}


// Build twist
// ***********
int buildtwist(int z,int dim,int NGradi,int YVal,int offset,char texture[][XPix])
{
    double x1,x2,x3,x4;
    double z1,z2,z3,z4;
    double rapz,rapx;
    double x=0,b=0;
    double FRow=dim*sqrt(2.0);
    int NRow=(int)(FRow);  
    char row[NRow];
    for(double i=0;i<NGradi;i++){
      for(int r=0;r<YVal;r++) {
            for(int j=0;j<NRow;j++) row[j]=(char)0x00;
            x1=((FRow/2)*sin(2*M_PI*i/(NGradi*4)));
            z1=z+((FRow/2)*cos(2*M_PI*i/(NGradi*4)));
            x2=((FRow/2)*sin(2*M_PI*(i+NGradi)/(NGradi*4)));
            z2=z+((FRow/2)*cos(2*M_PI*(i+NGradi)/(NGradi*4)));
            x3=((FRow/2)*sin(2*M_PI*(i+2*NGradi)/(NGradi*4)));
            z3=z+((FRow/2)*cos(2*M_PI*(i+2*NGradi)/(NGradi*4)));
            x4=((FRow/2)*sin(2*M_PI*(i+3*NGradi)/(NGradi*4)));
            z4=z+((FRow/2)*cos(b+2*M_PI*(i+3*NGradi)/(NGradi*4)));      
            rapx=x2+0.0001-x1;
            rapz=z2+0.0001-z1;
            for(double k=x1;k<=x2;k+=.2) row[(int)(k+FRow/2)]=texture[r][(int)perscor(0,XPix-.5,z1,z2,(k-x1)/rapx)];
            rapx=x3+0.0001-x2;
            rapz=z3+0.0001-z2;
            for(double k=x2;k<=x3;k+=.2) row[(int)(k+FRow/2)]=texture[r][(int)perscor(0,XPix-.5,z2,z3,(k-x2)/rapx)];              
            rapx=x4+0.0001-x3;
            rapz=z4+0.0001-z3;      
            for(double k=x3;k<=x4;k+=.2) row[(int)(k+FRow/2)]=texture[r][(int)perscor(0,XPix-.5,z3,z4,(k-x3)/rapx)];              
            rapx=x1+0.0001-x4;
            rapz=z1+0.0001-z4;
            for(double k=x4;k<=x1;k+=.2) row[(int)(k+FRow/2)]=texture[r][(int)perscor(0,XPix-.5,z4,z1,(k-x4)/rapx)];            
            writetosprite((int)(i*YVal+(YVal-1-r)),row,NRow,offset);
            }
      }
}


int main(int argc, char *argv[])
{    
    FILE *F;
    F=fopen("texture.bin","wb");
    for(int i=0;i<12288;i++) bank[i]=0;
    buildtwist(150,68,256,1,0,texture1);        
    buildtwist(150,68,256,1,24,texture3);    
  //  buildtwist(150,68,128,2,24,texture2);
    for(int i=0;i<12288;i++)
       bank2[i]=bank[(47-(int)i/256)+(i%256)*48];
    fwrite(bank2,1,12288,F);
    fclose(F);
    return(0);    
}
