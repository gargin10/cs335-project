class GCDFunction {
    

    public static int findGCD(int a, int b) {
        while (b != 0) {
            int temp = b;
            b = a % b;
            a = temp;
        }
        return a;
    }
    
    public static int main() 
    {
        int num1 = 24;
        int num2 = 36;
        int gcd = findGCD(num1, num2);
        System.out.println(gcd);
        return 0;
    }
  }