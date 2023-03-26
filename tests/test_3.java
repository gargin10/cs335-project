public class ArrayDeclaration {
    public static void main(String args[]) {
        int numbers[] = new int[3];
        int len = 5;
        String fruits[] = new String[3];
        fruits[0] = "apple";
        fruits[1] = "banana";
        fruits[2] = "orange";
  
        System.out.println("The numbers are:");
        for (int i = 0; i < len; i++) {
            System.out.print(numbers[i] + " ");
        }
        System.out.println();
  
        System.out.println("The fruits are:");
        for (int i = 0; i < 3; i++){
            System.out.print(fruits[i]);
        }
        System.out.println();
  
        int sum = 0;
        int number=0;
        for (int i = 0; i < len; i++) {
          sum += number;
        }
        double average = sum / len;
        System.out.println("The average of the numbers is: " + average);
    }
  }