#include "stdio.h"
int main()
{
    int i,j,temp,sum=0;
    scanf("%d",&i);
    scanf("%d",&j);
    if (i<0){i=-i;}
    if (j<0){j=-j;}
    if (j>i){
        temp = i;
        i = j;
        j = temp;
    }
    for(temp=0;temp<=j;++temp)
    {
        sum += temp;
    }
    printf("%d",sum);
    return 0;
}
