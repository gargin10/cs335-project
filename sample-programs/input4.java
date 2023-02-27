public class ArrayTest {
    private static int[][][] matrix = new int[2][3][4];

    public static void main(String[] args) {
        fillArray();
        printArray();
        System.out.println("The sum of all elements is: " + sumArray());
    }

    private static void fillArray() {
        int val = 0;
        for (int i = 0; i < matrix.length; i++) {
            for (int j = 0; j < matrix[i].length; j++) {
                for (int k = 0; k < matrix[i][j].length; k++) {
                    matrix[i][j][k] = val;
                    val++;
                }
            }
        }
    }

    private static void printArray() {
        for (int i = 0; i < matrix.length; i++) {
            for (int j = 0; j < matrix[i].length; j++) {
                for (int k = 0; k < matrix[i][j].length; k++) {
                    System.out.print(matrix[i][j][k] + " ");
                }
                System.out.println();
            }
            System.out.println();
        }
    }

    private static int sumArray() {
        int sum = 0;
        for (int i = 0; i < matrix.length; i++) {
            for (int j = 0; j < matrix[i].length; j++) {
                for (int k = 0; k < matrix[i][j].length; k++) {
                    sum += matrix[i][j][k];
                }
            }
        }
        return sum;
    }
}
