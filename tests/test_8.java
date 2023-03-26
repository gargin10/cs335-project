public class Matrix {
  public static void main(String args[]) {
      int rows = 3;
      int cols = 4;

      // allocate memory for a 3x4 matrix
      int matrix[][] = new int[rows][cols][];

      // assign values to the elements of the matrix
      for ( i = 0; i < rows; i++) {
          for (int j = 0; j < cols; j++) {
              matrix[i][j] = i * j;
          }
      }

      // print the elements of the matrix
      for (int i = 0; i < rows; i++) {
          for (int j = 0; j < cols; j++) {
              System.out.print(matrix[i][j] + " ");
          }
          System.out.println();
      }
  }
}