#include "stdio.h"
int main()
{
    FILE * infile ,*outfile;
    int i,max_num=0,id;
    int* buffer;
    buffer = new int[2];
    infile = fopen("a.in","rb");
    fread(buffer, 4, 2, infile);
    fclose(infile);
    scanf("%d",&i);
    max_num = i;
    for(id=0;id<=2;++id)
    {
     if(max_num < buffer[id])
     {max_num = buffer[id];}
    }
    buffer[0] = max_num;
    printf("%d",buffer[0]);
    outfile = fopen("a.out","wb");
    fwrite(buffer, 4, 1, outfile);
    fclose(outfile);
    return 0;
}
