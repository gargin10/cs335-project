public class OperatorExample {
    public static void main() {
        // arithmetic operators
        int a = 10;
        int b = 5;
        int c = a + b;
        int d = a - b;
        int e = a * b;
        int f = a / b;
        int g = a % b;
        int ab = ++a;
        int ac = !++a;
        int ad = -~x;
        int ae = +a+4-8;
        int af = (int)+a;

        boolean ag = true;
        int k = ++ag;
        
        // increment and decrement operators
        int h = ++a;
        int i = --b;
        int j = c++;
        int k = d--;
        
        // relational operators
        boolean l = (a == b);
        boolean m = (a != b);
        boolean n = (a > b);
        boolean o = (a < b);
        boolean p = (a >= b);
        boolean q = (a <= b);
        
        // bitwise operators
        int r = (a & b);
        int s = (a | b);
        int t = (a ^ b);
        int u = (~a);
        int v = (a << 2);
        int w = (a >> 2);
        int x = (a >>> 2);
        
        // logical operators
        boolean y = (a > b) && (c < d);
        boolean z = (a < b) || (c > d);
        boolean aa = !(a > b);
        
        // assignment operators
        a += b;
        b -= c;
        c *= d;
        d /= e;
        e %= f;
        f &= g;
        aa *= 2;
        
        // ternary operator
        int result = (a > b) ? c : d;
    }
}
