public class Example {
    public class Animal {
      public void makeSound() {
          System.out.println("The animal makes a sound");
      }
  }
  
  public class Dog extends Animal {
      public void makeSound() {
          System.out.println("The dog barks");
      }
  }
  
  public class Cat extends Animal {
      public void makeSound() {
          System.out.println("The cat meows");
      }
  }
  
  public class Main {
      public static void main(String args[]) {
          Animal animal1, animal2, animal3;
          animal1= new Dog();
          animal2 = new Cat();
          animal3 = new Animal();
      }
  }
  }