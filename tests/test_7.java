public class Bank {

    private BankAccount accounts[];
    private int numAccounts;
    
    public Bank() {
        this.accounts = new BankAccount[1000];
        this.numAccounts = 0;
    }
    
    public void addAccount(BankAccount account) {
        if (this.numAccounts < 1000) {
            this.accounts[this.numAccounts] = account;
            this.numAccounts++;
        } else {
            System.out.println("Error: Bank is full, cannot add account.");
        }
    }
    
    public BankAccount getAccount(int accountNumber) {
        for (int i = 0; i < this.numAccounts; i++) {
            if (this.accounts[i].getAccountNumber() == accountNumber) {
                return this.accounts[i];
            }
        }
        System.out.println("Error: Account not found.");
        return null;
    }
    
    public static void main(String[] args) {
        Bank bank = new Bank();
        
        BankAccount account1 = new BankAccount("John Smith", 1000);
        bank.addAccount(account1);
        
        BankAccount account2 = new BankAccount("Jane Doe", 5000);
        bank.addAccount(account2);
        
        bank.getAccount(1).deposit(500);
        bank.getAccount(2).withdraw(1000);
        
        System.out.println(bank.getAccount(1));
        System.out.println(bank.getAccount(2));
    }
}

public class BankAccount {

    private static int nextAccountNumber = 1;
    
    private int accountNumber;
    private String ownerName;
    private double balance;
    
    public BankAccount(String ownerName, double initialBalance) {
        this.accountNumber = nextAccountNumber;
        nextAccountNumber++;
        this.ownerName = ownerName;
        this.balance = initialBalance;
    }
    
    public int getAccountNumber() {
        return this.accountNumber;
    }
    
    public void deposit(double amount) {
        this.balance += amount;
    }
    
    public void withdraw(double amount) {
        if (this.balance >= amount) {
            this.balance -= amount;
        } else {
            System.out.println("Error: Insufficient funds.");
        }
    }
    
    public double getBalance() {
        return this.balance;
    }
    
    public String toString() {
        return "Account #" + this.accountNumber + ": " + this.ownerName + " - Balance: $" + this.balance;
    }
}
