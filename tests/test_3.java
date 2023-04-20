class Expression{

    int proc( int a1, int a2){
        System.out.println(a1);
        System.out.println(a2);
        a2 += a1;
        System.out.println(a2);
        return a2+2;
    }
    public static int main()
    {
        int a = 2;
        int b = 3;
        int c = 1;
        b = proc(54,56);
        int d = (a*b)+c-b;
        System.out.println(a);
        System.out.println(b);
        System.out.println(c);
        System.out.println(a*b);
        System.out.println(a*b+c);
        System.out.println(a*b+c - b);
        System.out.println(d);
        return 0;
    }
  }