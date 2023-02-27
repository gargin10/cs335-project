public class RecordAndEnumExample {
    
    public static void main(String[] args) {
        
        // Create a new record and assign values to its fields
        Person person = new Person("John", "Doe", Gender.MALE, 30);
        
        // Print the record's fields
        System.out.println("Name: " + person.firstName() + " " + person.lastName());
        System.out.println("Gender: " + person.gender());
        System.out.println("Age: " + person.age());
        
        // Use the enum to perform a conditional action
        if (person.gender() == Gender.MALE) {
            System.out.println(person.firstName() + " is a male.");
        } else if (person.gender() == Gender.FEMALE) {
            System.out.println(person.firstName() + " is a female.");
        }
    }
    
    // Define an enum for gender
    public enum Gender {
        MALE,
        FEMALE
    }
    
    // Define a record for a person
    public record Person(String firstName, String lastName, Gender gender, int age) {}
}

