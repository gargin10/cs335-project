public class LambdaTest {

    public static void main(String[] args) {
        
        List<String> words = Arrays.asList("apple", "banana", "cherry", "date", "elderberry");
        
        // filter words that start with "a"
        List<String> aWords = words.stream()
                                   .filter(word -> word.startsWith("a"))
                                   .toList();
        System.out.println(aWords); // prints ["apple"]
        
        // transform words to uppercase
        List<String> upperCaseWords = words.stream()
                                           .map(String::toUpperCase)
                                           .toList();
        System.out.println(upperCaseWords); // prints ["APPLE", "BANANA", "CHERRY", "DATE", "ELDERBERRY"]
        
        // sort words by length
        List<String> sortedWords = words.stream()
                                        .sorted((s1, s2) -> s1.length() - s2.length())
                                        .toList();
        System.out.println(sortedWords); // prints ["date", "apple", "banana", "cherry", "elderberry"]
        
        // count words that end with "y"
        long yWordsCount = words.stream()
                                .filter(word -> word.endsWith("y"))
                                .count();
        System.out.println(yWordsCount); // prints 2
    }
}
