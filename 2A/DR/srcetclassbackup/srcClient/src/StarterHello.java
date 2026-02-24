
import java.util.Hashtable;

public class StarterHello {

    static Hashtable<String, Object> nameServer = new Hashtable<>();

    public static void main(String[] args) throws Exception {

        int port = 2000;

        Object lock = new Object();
        nameServer.put("Hotels_lock", lock);

        Server ns = new Server(port,nameServer);

        new Thread(ns).start();

        Agent agent = new Hotels();
        agent.init("Hotels", new Node("localhost", port));
        agent.setNameServer(nameServer);

        synchronized (lock) {
            try {
                agent.main();
                System.out.println("DONE MAIN");
            } catch (MoveException e) {
            }
            lock.wait();
        }
        System.out.println("Agent finished");
    }
}