//�˳���Ϊ������Ʒ���޳�Ϯ����ת��
#include<stdio.h>
#include<string.h>
#include<stdlib.h>


int main(){
    int n,m;
    scanf("%d%d", &n, &m);
    int a[50][50];//ÿ��Ԫ��ռһ����
    int i, j;
    for(i = 1; i<=n; i++)
        for(j=1; j<=m; j++)
            scanf("%d", &a[i][j]);//�������
    for(i = n; i>0; i--){
        for(j=m; j>0; j--){
            if(a[i][j]!=0) printf("%d %d %d\n", i, j, a[i][j]);
        }
    }
    return 0;
}
