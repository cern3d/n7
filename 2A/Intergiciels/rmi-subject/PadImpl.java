
import java.rmi.*;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.rmi.server.UnicastRemoteObject;
import java.util.HashMap;
import java.util.Map;

public class PadImpl extends UnicastRemoteObject implements Pad {
    private Map<String, RRecord> dict;
    String name;

    public PadImpl(String name) throws RemoteException {
        this.dict = new HashMap<>();
        this.name = name;
    }

    public void add(SRecord sr) throws RemoteException {
        dict.put(sr.getName(), new RRecordImpl(sr.getName(), sr.getEmail()));
    }

    public RRecord consult(String n, boolean forward) throws RemoteException {
        if (dict.containsKey(n)) {
            return dict.get(n);
        }
        if (forward) {
            try {
                // get the stub of the server object from the rmiregistry
                Pad obj = (Pad) Naming.lookup((name == "Pad1") ? "Pad2" : "Pad1");
                // Invocation of a method on the remote object
                return obj.consult(n, forward);
            } catch (Exception exc) {
            }
        }
        System.out.println("non trouver");
        return null;
    }

    public static void main(String args[]) {
        
        String URL;
        String URL2;

        try {
            // Launching the naming service – rmiregistry – within the JVM
            Registry registry = LocateRegistry.createRegistry(8080);
            // Create an instance of the server object
            Pad obj = new PadImpl("Pad1");
            Pad obj2 = new PadImpl("Pad2");
            // compute the URL of the server
            URL = "Pad1";
            URL2 = "Pad2";
            Naming.rebind(URL, obj);
        } catch (Exception exc) {
            exc.printStackTrace();
        }
    }
}
