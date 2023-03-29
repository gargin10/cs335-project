class Tree {
    public int climb;
}

class Flower {
    int petal = 0;
    public int getPollen(int bee)
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
        System.out.println("I got " + flow.getPollen(10) + " pollen.");
        flow.setPetal(10);
        System.out.println("I got " + flow.getPetal() + " petals.");
    }
}
