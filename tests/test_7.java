public class GCDFunction {
    
  
    public static int findGCD(int a, String b) {
        while (b != 0) {
            int temp = b;
            b = a % b;
            a = temp;
        }
        return a;
    }
    public static void main(String args[]) {
        int num1 = 24;
        int num2 = 36;
        int gcd = findGCD(num1, num2);
        System.out.println("The GCD of " + num1 + " and " + num2 + " is " + gcd);
    }
  }