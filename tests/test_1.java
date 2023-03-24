public class ArraySum {
  
  private static int arr[][][] = {{{1, 2}, {3, 4}}, {{5, 6}, {7, 8}}};

  public static void main() {
    int sum = 0;
    for (int i = 0; i < 2; ++i) {
      for (int j = 0; j < 2; ++j) {
        for (int k = 0; k < 2; ++k) {
          sum += arr[i][j][k];
        }
      }
    }
    System.out.println("Sum of array elements: " + sum);
    
    int a = 5, b = 10;
    if (a > b) {
      System.out.println("a is greater than b");
    } else {
      System.out.println("b is greater than a");
    }
    
    int x = 10;
    while (x > 0) {
      System.out.print(x + " ");
      --x;
    }
    System.out.println();
    
    int y = 1;
    do {
      System.out.print(y + " ");
      ++y;
    } while (y <= 10);
    System.out.println();
    
    int z = 0;
    for (; z < 10; ++z) {
      System.out.print(z + " ");
    }
    System.out.println();
    
    int result = addNumbers(5, 10);
    System.out.println("Result of addNumbers method: " + result);
  }
  
  private static int addNumbers(int a, int b) {
    return a + b;
  }
}
