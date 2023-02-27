public class FourDimensionalArray {

    public static void main(String[] args) {
        int fourDArray [][][][]  = new int[3][4][5][6];

        // initialize the array with some values
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 4; j++) {
                for (int k = 0; k < 5; k++) {
                    for (int l = 0; l < 6; l++) {
                        fourDArray[i][j][k][l] = i + j + k + l;
                    }
                }
            }
        }

        // print the elements of the array
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 4; j++) {
                for (int k = 0; k < 5; k++) {
                    for (int l = 0; l < 6; l++) {
                        System.out.println("fourDArray[" + i + "][" + j + "][" + k + "][" + l + "] = " + fourDArray[i][j][k][l]);
                    }
                }
            }
        }

        // find the sum of all the elements in the array
        int sum = 0;
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 4; j++) {
                for (int k = 0; k < 5; k++) {
                    for (int l = 0; l < 6; l++) {
                        sum += fourDArray[i][j][k][l];
                    }
                }
            }
        }
        System.out.println("The sum of all the elements in the array is " + sum);
    }
}

