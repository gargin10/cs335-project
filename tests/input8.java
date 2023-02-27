public class MyGenericClass<T> {

  private T myArray [];

  public MyGenericClass(T array []) {
    this.myArray = array;
  }

  public void setValue(int index, T value) throws IndexOutOfBoundsException {
    if (index < 0 || index >= myArray.length) {
      throw new IndexOutOfBoundsException("Invalid index!");
    }
    myArray[index] = value;
  }

  public T getValue(int index) throws IndexOutOfBoundsException {
    if (index < 0 || index >= myArray.length) {
      throw new IndexOutOfBoundsException("Invalid index!");
    }
    return myArray[index];
  }

  public static void main(String[] args) {
    Integer intArray [] = {1, 2, 3, 4, 5};
    MyGenericClass<Integer> myIntClass = new MyGenericClass<>(intArray);

    try {
      myIntClass.setValue(6, 6);
    } catch (IndexOutOfBoundsException e) {
      System.out.println("Caught exception: " + e.getMessage());
    }

    try {
      Integer value = myIntClass.getValue(6);
    } catch (IndexOutOfBoundsException e) {
      System.out.println("Caught exception: " + e.getMessage());
    }
  }
}

