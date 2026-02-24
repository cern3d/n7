
import java.util.Hashtable;

public class StarterHotels {

    static Hashtable<String, Object> nameServer = new Hashtable<>();

    public static void main(String[] args) throws Exception {

        int port = 2000;

        Object lock = new Object();
        nameServer.put("Hotels_lock", lock);

        Server ns = new Server(port, nameServer);

        new Thread(ns).start();

        Agent agent = new Hotels();
        agent.init("Hotels", new Node("localhost", port));
        agent.setNameServer(nameServer);
        long times = System.nanoTime();

        synchronized (lock) {
            try {
                agent.main();

            } catch (MoveException e) {
            }
            lock.wait();

            long timee = System.nanoTime();
            System.out.println("DONE MAIN in ms: " + (timee - times) / 1000000);
        }
        System.out.println("Agent finished");
    }
}