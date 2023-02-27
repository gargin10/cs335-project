public class Blackjack {
    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        Random rand = new Random();

        String suits[] = { "Hearts", "Diamonds", "Clubs", "Spades" };
        String ranks[] = { "Ace", "2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King" };
        int values[] = { 11, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10 };

        int numDecks = 2;
        int numCards = suits.length * ranks.length * numDecks;
        int deck[] = new int[numCards];

        for (int i = 0; i < numCards; i++) {
            deck[i] = i;
        }

        for (int i = numCards - 1; i > 0; i--) {
            int j = rand.nextInt(i + 1);
            int temp = deck[i];
            deck[i] = deck[j];
            deck[j] = temp;
        }

        int playerScore = 0;
        int dealerScore = 0;
        int playerCards = 0;
        int dealerCards = 0;

        while (true) {
            System.out.println("New game of blackjack!");
            playerScore = 0;
            dealerScore = 0;
            playerCards = 0;
            dealerCards = 0;

            for (int i = 0; i < 2; i++) {
                int card = deck[playerCards++];
                String suit = suits[card / ranks.length];
                String rank = ranks[card % ranks.length];
                int value = values[card % ranks.length];

                System.out.println("Player drew " + rank + " of " + suit);
                playerScore += value;
            }

            if (playerScore == 21) {
                System.out.println("Player wins!");
            } else {
                while (dealerScore < 17) {
                    int card = deck[dealerCards++];
                    String suit = suits[card / ranks.length];
                    String rank = ranks[card % ranks.length];
                    int value = values[card % ranks.length];

                    System.out.println("Dealer drew " + rank + " of " + suit);
                    dealerScore += value;
                }

                if (dealerScore > 21) {
                    System.out.println("Dealer busts! Player wins!");
                } else if (dealerScore >= playerScore) {
                    System.out.println("Dealer wins!");
                } else {
                    System.out.println("Player wins!");
                }
            }

            System.out.println("Play again? (y/n)");
            String playAgain = input.nextLine();

            if (!playAgain.toLowerCase().startsWith("y")) {
                break;
            }
        }
    }
}
