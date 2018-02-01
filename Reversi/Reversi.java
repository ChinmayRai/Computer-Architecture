import java.util.*;
import java.lang.*;
import java.io.*;

public class Reversi
{
	int [][] board = new int [8][8];
	//Board will be filled by 1=X,-1=O and 0=-.
	int count=0;
	int [][] valid = new int [8][8];
	public void initialise()
	{
		for (int i=0;i<8;i++)
			for(int j=0;j<8;j++)
				board[i][j] = 0;
		board[3][3]=1;	board[4][4]=1;		board[3][4]=-1;		board[4][3]=-1;
	}
	public int label(int player)
	{
		if (player==1)
			return 1;
		else
			return -1;
	}

	// k = NOT(label)
	
	public int k(int player)      
	{
		if(player==1)
			return -1;
		else
			return 1;
	}
	
	public void display ()
	{
		for (int i=0;i<9;i++)
			System.out.print((i)+" ");
		System.out.println();
		for (int j=0;j<8;j++)
		{
			System.out.print((j+1)+" ");
			for(int i=0;i<8;i++)
			{
				if (board[i][j]==0)
					System.out.print("- ");
				else if(board[i][j]==1)
					System.out.print("X ");
				else
					System.out.print("O ");
			}
			System.out.println();
		}
		System.out.println();
	}
	
	public void chance(int x_coordinate, int y_coordinate)//define x and y in all
	{
		int x = x_coordinate-1;
		int y = y_coordinate-1;
		System.out.println("Player "+(count%2)+" is playing");		
		for(int i=0;i<8;i++)
			for(int j=0;j<8;j++)
				valid[i][j]=0;
		int player=count%2;
		int k=k(player);
		int label=label(player);

		//this mega loop sets the positions at which player can take chance to 1. 
		for(int i=0;i<8;i++)
		{
			for (int j=0;j<8;j++)
			{
				if(board[i][j]==k)
				{
					if(i==0)
					{
						if (j==0)
						{
							if(board[i+1][j]==0)
								valid[i+1][j]=1;
							if(board[i+1][j+1]==0)
								valid[i+1][j+1]=1;
							if(board[i][j+1]==0)
								valid[i][j+1]=1;
						}
						else if(j==7)
						{
							if(board[i+1][j]==0)
								valid[i+1][j]=1;
							if(board[i+1][j-1]==0)
								valid[i+1][j-1]=1;
							if(board[i][j-1]==0)
								valid[i][j-1]=1;
						}
						else
						{
							if(board[i+1][j]==0)
								valid[i+1][j]=1;
							if(board[i+1][j+1]==0)
								valid[i+1][j+1]=1;
							if(board[i+1][j-1]==0)
								valid[i+1][j-1]=1;
							if(board[i][j-1]==0)
								valid[i][j-1]=1;
							if(board[i][j+1]==0)
								valid[i][j+1]=1;
						}
					}
					
					else if(i==7)
					{
						if (j==0)
						{
							if(board[i-1][j]==0)
								valid[i-1][j]=1;
							if(board[i-1][j+1]==0)
								valid[i-1][j+1]=1;
							if(board[i][j+1]==0)
								valid[i][j+1]=1;
						}
						else if(j==7)
						{
							if(board[i-1][j]==0)
								valid[i-1][j]=1;
							if(board[i-1][j-1]==0)
								valid[i-1][j-1]=1;
							if(board[i][j-1]==0)
								valid[i][j-1]=1;
						}
						else
						{
							if(board[i-1][j]==0)
								valid[i-1][j]=1;
							if(board[i-1][j+1]==0)
								valid[i-1][j+1]=1;
							if(board[i-1][j-1]==0)
								valid[i-1][j-1]=1;
							if(board[i][j+1]==0)
								valid[i][j+1]=1;
							if(board[i][j-1]==0)
								valid[i][j-1]=1;
						}
					}
					else
					{
						if(j==0)
						{
							if(board[i][j+1]==0)
								valid[i][j+1]=1;
							if(board[i+1][j+1]==0)
								valid[i+1][j+1]=1;
							if(board[i-1][j+1]==0)
								valid[i-1][j+1]=1;
							if(board[i+1][j]==0)
								valid[i+1][j]=1;
							if(board[i-1][j]==0)
								valid[i-1][j]=1;
						}
						else if(j==7)
						{
							if(board[i-1][j-1]==0)
								valid[i-1][j-1]=1;
							if(board[i][j-1]==0)
								valid[i][j-1]=1;
							if(board[i+1][j-1]==0)
								valid[i+1][j-1]=1;
							if(board[i+1][j]==0)
								valid[i+1][j]=1;
							if(board[i-1][j]==0)
								valid[i-1][j]=1;
						}
						else
						{
							if(board[i-1][j-1]==0)
								valid[i-1][j-1]=1;
							if(board[i-1][j]==0)
								valid[i-1][j]=1;
							if(board[i-1][j+1]==0)
								valid[i-1][j+1]=1;
							if(board[i][j+1]==0)
								valid[i][j+1]=1;
							if(board[i+1][j+1]==0)
								valid[i+1][j+1]=1;
							if(board[i+1][j]==0)
								valid[i+1][j]=1;
							if(board[i+1][j-1]==0)
								valid[i+1][j-1]=1;
							if(board[i][j-1]==0)
								valid[i][j-1]=1;
						}
					}
				}
			}
		}

		int val_count=0;
		for(int i=0;i<8;i++)
			for(int j=0;j<8;j++)
				if(valid[i][j]==1){val_count++;}
		
		if(val_count==0)
		{
		int x1=0;
		int o1=0;
		for(int i=0;i<8;i++)
			for(int j=0;j<8;j++)
			{
				if(board[i][j]==-1)o1++;
				if(board[i][j]==1)x1++;
			}
		System.out.println("X="+x1+" and "+"O="+o1+" Game over ");
		return;

		}

		
		if(valid[x][y]==0)System.out.println(" Invalid move: Try Again");


		int i,j;
		int a,b,c,d,e,f,g,h;		    //the following part decides which traversals to perform.
		int flag=-1;
		if(x==0 && y==0)
		{	
			a=right_traversal(x,y,player);
			b=down_traversal(x,y,player);
			c=right_down_traversal(x,y,player);
			if(a==0 || b==0 || c==0)
				flag=1;
		}
		else if(x==0 && y==7)
		{
			d=left_traversal(x,y,player);
			b=down_traversal(x,y,player);
			e=left_down_traversal(x,y,player);
			if(d==0 || b==0 || e==0)
				flag=1;
		}
		else if(x==0)
		{
			a=right_traversal(x,y,player);
			b=down_traversal(x,y,player);
			c=right_down_traversal(x,y,player);
			d=left_traversal(x,y,player);
			e=left_down_traversal(x,y,player);
			if(a==0 || b==0 || c==0 || d==0 || e==0)
				flag=1;
		}
		else if(x==7 && y==0)
		{
			a=right_traversal(x,y,player);
			f=up_traversal(x,y,player);
			g=right_up_traversal(x,y,player);
			if(a==0 || f==0 || g==0)
				flag=1;
		}
		else if(x==7 && y==7)
		{
			d=left_traversal(x,y,player);
			f=up_traversal(x,y,player);
			h=left_up_traversal(x,y,player);
			if(d==0 || f==0 || h==0)
				flag=1;
		}
		else if(x==7)
		{
			a=right_traversal(x,y,player);
			f=up_traversal(x,y,player);
			g=right_up_traversal(x,y,player);
			d=left_traversal(x,y,player);
			h=left_up_traversal(x,y,player);
			if(a==0 || f==0 || g==0 || d==0 || h==0)
				flag=1;
		}
		else if(y==0)
		{
			a=right_traversal(x,y,player);
			f=up_traversal(x,y,player);
			g=right_up_traversal(x,y,player);
			b=down_traversal(x,y,player);
			c=right_down_traversal(x,y,player);
			if(a==0 || f==0 || g==0 || b==0 || c==0)
				flag=1;
		}
		else if(y==7)
		{
			d=left_traversal(x,y,player);
			f=up_traversal(x,y,player);
			h=left_up_traversal(x,y,player);
			b=down_traversal(x,y,player);
			e=left_down_traversal(x,y,player);
			if(d==0 || f==0 || h==0 || b==0 || e==0)
				flag=1;
		}
		else
		{
			a=right_traversal(x,y,player);
			f=up_traversal(x,y,player);
			g=right_up_traversal(x,y,player);
			b=down_traversal(x,y,player);
			c=right_down_traversal(x,y,player);
			d=left_traversal(x,y,player);
			e=left_down_traversal(x,y,player);
			h=left_up_traversal(x,y,player);
			if(a==0 || b==0 || c==0 || e==0 || d==0 ||f==0 ||g==0 ||h==0)
				flag=1;
		}

		if(flag==-1 || flag==0)
		{
			System.out.println(" Invalid move: Try Again");
		}
		else
		{
			display();
			count++;
		}
					
	}
	
	
	public 	int right_traversal(int x_coordinate, int y_coordinate, int player)
	{
		int x = x_coordinate;
		int y = y_coordinate;
		int label=label(player);
		int k = k(player);
		int flag=1;		
		int j=0;
		//right traversal
		if(board[x][y+1]==k)
		{
			for(j=y+1;j<8;j++)
			{
				if(board[x][j]==label)
				{	
					flag=0;
					break;
				}
			}
			if(flag==0)
			{
				for(j=j-1;j>=y;j--)
				{
					if(board[x][j]==label)
						break;
					board[x][j]=label;
				}
			}	
		}
		return flag;
	}
	public int down_traversal(int x_coordinate, int y_coordinate, int player)
	{
		int x = x_coordinate;
		int y = y_coordinate;
		int label=label(player);
		int k = k(player);int j=0;
		int flag=1;
		//down traversal
		if(board[x+1][y]==k)
		{
			for(j=x+1;j<8;j++)
			{
				if(board[j][y]==label)
				{	
					flag=0;
					break;
				}
			}
			if(flag==0)
			{
				for(j=j-1;j>=x;j--)
				{
					if(board[j][y]==label)
						break;
					board[j][y]=label;
				}
			}	
		}
		return flag;
	}
	public int left_traversal(int x_coordinate, int y_coordinate, int player)
	{
		int x = x_coordinate;
		int y = y_coordinate;
		int label=label(player);
		int k = k(player);int j=0;
		int flag=1;
		//left traversal
		if(board[x][y-1]==k)
		{
			for(j=y-1;j>=0;j--)
			{
				if(board[x][j]==label)
				{	
					flag=0;	break;
				}
			}
			if(flag==0)
			{
				for(j=j+1;j<=y;j++)
				{
					if(board[x][j]==label)
						break;
					board[x][j]=label;
				}	
			}	
		}
		return flag;
	}
	public int up_traversal(int x_coordinate, int y_coordinate, int player)
	{
		int x = x_coordinate;
		int y = y_coordinate;
		int label=label(player);
		int k = k(player);int j=0;
		int flag=1;
		//up traversal
		if(board[x-1][y]==k)
		{
			for(j=x-1;j>=0;j--)
			{
				if(board[j][y]==label)
				{	
					flag=0;
					break;
				}
			}
			if(flag==0)
			{
				for(j=j+1;j<=x;j++)
				{
					if(board[j][y]==label)
						break;
					board[j][y]=label;
				}
			}	
		}
		return flag;
	}
	public int right_down_traversal(int x_coordinate, int y_coordinate, int player)
	{

		int x = x_coordinate;
		int y = y_coordinate;
		int label=label(player);
		int k = k(player);int j=0;
		int flag=1;
		//right_down traversal
		if(board[x+1][y+1]==k)
		{
			for(j=1;;j++)
			{
				if(x+j==8 || y+j==8)
					break;
				if(board[x+j][y+j]==label)
				{
					flag=0;break;
				}
			}	
			if(flag==0)
			{
				for(j=j-1;j>=0;j--)
				{
					if(board[x+j][y+j]==label)
						break;
					board[x+j][y+j]=label;
				}
			}	
		}
		return flag;
	}
	
	public int right_up_traversal(int x_coordinate, int y_coordinate, int player)
	{
		int x = x_coordinate;
		int y = y_coordinate;
		int label=label(player);
		int k = k(player);int j=0;
		int flag=1;
		//right_up traversal
		if(board[x-1][y+1]==k)
		{
			for(j=1;;j++)
			{
				if(x-j==0 || y+j==8)
					break;
				if(board[x-j][y+j]==label)
				{
					flag=0;
					break;
				}
			}
			if(flag==0)
			{
				for(j=j-1;j>=0;j--)
				{
					if(board[x-j][y+j]==label)
						break;
					board[x-j][y+j]=label;
				}
			}	
		}
		return flag;
	}
	
	public int left_up_traversal(int x_coordinate, int y_coordinate, int player)
	{
		int x = x_coordinate;
		int y = y_coordinate;
		int label=label(player);
		int k = k(player);int j=0;
		int flag=1;
		//left_up traversal
		if(board[x-1][y-1]==k)
		{
			for(j=1;;j++)
			{
				if(x-j==0 || y-j==0)
					break;
				if(board[x-j][y-j]==label)
				{
					flag=0;break;
				}
			}
			if(flag==0)
			{
				for(j=j-1;j>=0;j--)
				{
					if(board[x-j][y-j]==label)
						break;
					board[x-j][y-j]=label;
				}
			}	
		}
		return flag;
	}
	
	public int left_down_traversal(int x_coordinate, int y_coordinate, int player)
	{
		int x = x_coordinate;
		int y = y_coordinate;
		int label=label(player);
		int k = k(player);int j=0;
		int flag=1;
		//left_down traversal
		if(board[x+1][y-1]==k)
		{
			for(j=1;;j++)
			{
				if(x+j==8 || y-j==0)
					break;
				if(board[x+j][y-j]==label)
				{
					flag=0;
					break;
				}
			}
			if(flag==0)
			{
				for(j=j-1;j>=0;j--)
				{
					if(board[x+j][y-j]==label)
						break;
					board[x+j][y-j]=label;
				}
			}	
		}
		return flag;
	}
	
	public static void main(String[] args)
	{
		Reversi obj = new Reversi();
		Scanner in=new Scanner(System.in);
		obj.initialise();
		obj.display();
		int count =0;
		
		while(true)
		{
			int a= in.nextInt();
			int b= in.nextInt();
			obj.chance(a,b);
		}
	}
}