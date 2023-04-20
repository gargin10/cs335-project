class Whileloop
{
    public static int main()
    {
        int i = 0;
        int sum = 0;
        while (i < 5) 
        {
            sum = sum + i;
            i++;
            System.out.print(i);
            System.out.println(sum);
        }
        System.out.println(sum);
        return 0;
    }
}