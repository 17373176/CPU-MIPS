//�˳���Ϊ������Ʒ���޳�Ϯ����ת��
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
int a[8][8];
int vis[8]={0};//�������
int flag=0;
int n, m;
void dfs(int i,int j){
    if(j==1){
        int k=0;//��¼���ʸ���
        for(j=2; j<=n;j++)
            if(vis[j]==1) k++;
        if(k==n-1) flag=1;
    }else{
        vis[j]=1;//���ʱ��
        int q;
        for(q=1; q<=n;q++)
            if(a[j][q]!=0&&vis[q]==0){//�붥��j���ڱ�
                dfs(j,q);
                vis[q]=0;//�������
            }
    }
    return;
}
int main(){
    scanf("%d%d", &n, &m);
    int i,j;//i�������
    for(i=1; i<=m; i++){
        int u,v;
        scanf("%d%d",&u, &v);
        a[u][v]=1;
        a[v][u]=1;
    }
    if(n==1 && m>=1) flag=1;//��,��һ��������1����������Ի�
    else if(n==2 && m>=2) flag=1;
    else if(n!=2){
        //�Ӷ���1��ʼ
        for(j=1; j<=n;j++)
            if(a[1][j]!=0&&vis[j]==0){//�붥��1���ڱ�
                dfs(1,j);
                vis[j]=0;
                if(flag==1) break;//ֱ����ת���
            }
    }
    //ֱ����ת���
    if(flag) printf("1");
    else printf("0");
    return 0;
}
