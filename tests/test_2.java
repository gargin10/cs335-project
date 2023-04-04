class Tree {
    public int climb;
}

class Flower {
    int petal = 0;
    double t=0.0;
    char ch;
    int a = 5;
    int getPollen(int bee)
    {
        return bee * 10;
    }
    public int getPetal() { return petal; }
    void setPetal(int newPetal) { petal = newPetal; }
}

public class Main {
    public static void main(String args[]) {
        Tree obj1 =  new Tree();
        obj1.climb = 8;
        Flower flow = new Flower();
        System.out.print(flow.getPollen(10));
        System.out.println("I got " + flow.getPollen(10) + " pollen.");
        flow.setPetal(10);
        System.out.println("I got " + flow.getPetal() + " petals.");
    }
}

class Animal
{
    int x;

    int print(int a, int b)
    {
        System.out.println(a+b);
        return 0;
    }
}

class Foo{

    float func(int x, int y, int z, Animal r){
        int p  = x;
        float g = 90 + y;
        double t = x;
        return g;
    }
    int main(){
        int a = 3;
        int b = 6;
        int c = a+ b;
        
        Animal obj = new Animal();
        int y = obj.print(a,b);
        int x2= obj.x;
        float x = func(a, b, 0,obj);
    }   
}