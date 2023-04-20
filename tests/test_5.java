class Condition{

    void display( int x)
    {
      System.out.println(x);
    }
    int sum1 ( int a, int b, int c, int d, int e)
    {
      int sum = a + b + c+ d +e;
      display(sum);
      return sum;
    }
    public static int main()
    {
        int a = 16;
        if (a < 10) {
          System.out.println(a);
        } 
        else if (a < 18) {
          System.out.println(18-a);
        } else {
          System.out.println(a+5);
        }  

        sum1(1,2,3,4,5);
        return 0; 
    }
  }