class Factors{
  public static int main()
  {
    int number = 60;
    for (int i = 1; i <= number; i++) {
        if (number % i == 0) {
          System.out.print(i);
        }
    }
    return 0;
  }
}