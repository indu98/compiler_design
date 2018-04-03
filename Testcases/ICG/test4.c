#include <stdio.h>

void func(int a)
{
	int a;
	a=0;
	a=a+1;
	return;
}

void work(int a,int b)
{
	int tes=0;
	int b=tes+1;
	return;
}

void choc(int a,int b,int c)
{
	int roast=9;
	int tem=0;
	tem=tem+2;
	return;
}

int main()
{
	int a=5;
	int b=6;
	do
	{
		b=b+1;
		do
		{
			choc(1,2,3);
			b=4;
		}while(a==7);
	}while(a>7);
	return 0;
}
