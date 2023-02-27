public class Example {
  
  private static int count = 0;
  private int numbers[] = new int[10];
  private boolean flag = true;
  
  public static void main(String[] args) {
    Example ex = new Example();
    ex.run();
  }
  
  public void run() {
    System.out.println("Starting program...");
    initializeArray();
    printArray();
    int sum = calculateSum();
    System.out.println("The sum of the numbers is: " + sum);
    int max = findMax();
    System.out.println("The maximum number in the array is: " + max);
    boolean isEven = isNumberEven(max);
    System.out.println("Is the maximum number even? " + isEven);
    int result = multiplyNumbers(sum, max);
    System.out.println("The product of the sum and the maximum number is: " + result);
    if (isEven) {
      System.out.println("The result is even!");
    } else {
      System.out.println("The result is odd!");
    }
    int i = 0;
    while (i < 10) {
      if (i % 2 == 0) {
        incrementCounter();
      }
      i++;
    }
    System.out.println("The counter is now: " + count);
    boolean shouldContinue = true;
    do {
      System.out.println("Please enter a number: ");
      int input = Integer.parseInt(System.console().readLine());
      switch (input) {
        case -1:
        case 0:
          System.out.println("Goodbye!");
          shouldContinue = false;
          break;
        case 1:
          System.out.println("You entered 1!");
          break;
        case 2:
          System.out.println("You entered 2!");
          break;
        default:
          System.out.println("You entered a number other than 0, 1, or 2.");
          break;
      }
    } while (shouldContinue);
  }
  
  private void initializeArray() {
    for (int i = 0; i < numbers.length; i++) {
      numbers[i] = i;
    }
  }
  
  private void printArray() {
    for (int i = 0; i < numbers.length; i++) {
      System.out.println("numbers[" + i + "] = " + numbers[i]);
    }
  }
  
  private int calculateSum() {
    int sum = 0;
    for (int i = 0; i < numbers.length; i++) {
      sum += numbers[i];
    }
    return sum;
  }
  
  private int findMax() {
    int max = Integer.MIN_VALUE;
    for (int i = 0; i < numbers.length; i++) {
      if (numbers[i] > max) {
        max = numbers[i];
      }
    }
    return max;
  }
  
  private boolean isNumberEven(int number) {
    return number % 2 == 0;
  }
  
  private int multiplyNumbers(int a, int b) {
    return a * b;
  }
  
  private void incrementCounter() {
    count++;
  }
  
}
