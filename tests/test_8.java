class Square {

    int recur(int x)
    {
        if(x<1)
            return 0;
        System.out.println(x);
        recur(x-1);
    }
    public static int main() 
    {
        recur(10);
        return 0;
    }
}