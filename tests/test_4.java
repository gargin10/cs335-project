class Forloop{
    public static int main()
    {
        int x = 0;
        int sum = 0;
        for (int i = 0; i < 3; ++i) 
        {
            for (int j = 0; j < 3; ++j) 
            {
                for (int k = 0; k < 3; ++k) 
                {
                    sum +=1;
                    System.out.print(i+1);
                    System.out.print(j+1);
                    System.out.println(k+1);
                }
                // System.out.println();
            }
            // System.out.println(); 
        }
        // System.out.println(sum);
        return 0;
    } 
}