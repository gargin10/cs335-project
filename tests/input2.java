public class Calculator {
    private static int matrixA[][] = {{1, 2, 3}, {4, 5, 6}};
    private static int matrixB[][] = {{7, 8}, {9, 10}, {11, 12}};

    public static void main(String[] args) {
        int sum = 0;
        for (int i = 0; i < matrixA.length; i++) {
            for (int j = 0; j < matrixB[0].length; j++) {
                for (int k = 0; k < matrixB.length; k++) {
                    sum += matrixA[i][k] * matrixB[k][j];
                }
            }
        }
        System.out.println("The product of the two matrices is:");
        for (int i = 0; i < matrixA.length; i++) {
            for (int j = 0; j < matrixB[0].length; j++) {
                System.out.print(sum + " ");
            }
            System.out.println();
        }
    }
}
