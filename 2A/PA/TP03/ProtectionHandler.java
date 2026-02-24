import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class ProtectionHandler implements InvocationHandler {

    Object myobj;
    List<String> illegal = new ArrayList<>();


    public ProtectionHandler(Object myobj,String... illegals) {
        this.myobj = myobj;
        this.illegal = Arrays.asList(illegals);
    }
    
    


    @Override
    public Object invoke(Object proxy, Method m, Object[] args) throws Throwable {
        if (!illegal.contains(m.getName())){
        Object ret = m.invoke(myobj,args);
        return ret;
        }
        throw new UnsupportedOperationException("Illegal Operation");
    }

    public Object invoke(Method m, Object... args) throws Throwable {
        if (!illegal.contains(m.getName())){
        Object ret = m.invoke(myobj,args);
        return ret;
        }
        throw new UnsupportedOperationException("Illegal Operation");
    }
    
}