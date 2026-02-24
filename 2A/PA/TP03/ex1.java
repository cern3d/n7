import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Proxy;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class ex1 {

    public static void main(String[] args) throws IllegalAccessException, IllegalArgumentException, InvocationTargetException, NoSuchMethodException, SecurityException {
        List<Integer> l = new ArrayList<Integer>();
        Collections.addAll(l,2,3,5,7);
        System.out.println(l);
        l.remove(2);
        System.out.println(l);
        List<Integer> lu = Collections.unmodifiableList(l);
        try{
        lu.remove(2);
        }
        catch (UnsupportedOperationException e){
            System.out.println("Unsupported");
        }
        System.out.println(l);
        ProtectionHandler ph = new ProtectionHandler((Object) l,"remove");
        @SuppressWarnings("unchecked")
        List<Integer> lp =(List<Integer>) Proxy.newProxyInstance(List.class.getClassLoader(), new Class[]{List.class} , ph);
        try{
            lp.remove(2);
        }
        catch (UnsupportedOperationException e){
            System.out.println("Unsupported");
        }
        System.out.println(l);
        lp.add(2);
        System.out.println(l);
    }
}