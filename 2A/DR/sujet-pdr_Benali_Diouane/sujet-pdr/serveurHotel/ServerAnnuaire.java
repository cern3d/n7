import java.io.*;
import java.nio.*;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.URL;
import java.net.URLClassLoader;
import java.nio.file.Files;
import java.util.Hashtable;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class ServerAnnuaire implements Runnable {

    private Hashtable<String, Object> nameServer = new Hashtable<>();
    private int port;


    // Constructor that sets the port
    public ServerAnnuaire(int port) {
        this.port = port;
    }

    // Constructor that sets the port and nameserver
    public ServerAnnuaire(int port,Hashtable<String, Object> nameServer) {
        this.port = port;
        this.nameServer = nameServer;
    }

    @Override
    public void run() {
        try (ServerSocket ServerAnnuaire = new ServerSocket(port)) {
        System.out.println("ServerAnnuaire ready on port " + port);

        Socket s = ServerAnnuaire.accept();
        DataInputStream in = new DataInputStream(s.getInputStream());

        // Receive and save the JAR file
        String jarName = in.readUTF();
        int jarLen = in.readInt();
        byte[] jarBytes = in.readNBytes(jarLen);

        // Make Jar file that will be delted later to avoid errors with the agent (FileNotFoundException)
        Path jarPath = Paths.get("MyAgent.jar");
        Files.write(jarPath, jarBytes);

        // Create a ClassLoader pointing to that JAR
        URLClassLoader jarLoader = new URLClassLoader(
            new URL[]{jarPath.toFile().toURI().toURL()},
            this.getClass().getClassLoader() // Parent loader has Agent interface
        );

        // Deserialize using the JAR loader
        int objLen = in.readInt();
        byte[] objBytes = in.readNBytes(objLen);

        ObjectInputStream ois = new ObjectInputStream(new ByteArrayInputStream(objBytes)) {
            @Override
            protected Class<?> resolveClass(ObjectStreamClass desc) throws IOException, ClassNotFoundException {
                return Class.forName(desc.getName(), false, jarLoader);
            }
        };

        Agent a = (Agent) ois.readObject();
        a.setNameServer(nameServer);
            try {
                a.main();
            } catch (MoveException e) {
            }
            Files.deleteIfExists(jarPath);
            s.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
    }

    public static void main(String[] args) {
        if (args.length != 1) {
            System.out.println("usage: java ServerAnnuaire <port>");
            return;
        }

        Hashtable<String, Object> annuaireNS = new Hashtable<>();

Hashtable<String, Integer> hotelNumbers = new Hashtable<>();
    for (int i = 1; i <= 100; i++) {
            hotelNumbers.put("Hotel Toulouse " + i, i);
        }

annuaireNS.put("HOTEL_NUMBERS", hotelNumbers);

        int port = Integer.parseInt(args[0]);
        ServerAnnuaire ServerAnnuaire = new ServerAnnuaire(port,annuaireNS);
        new Thread(ServerAnnuaire).start();
    }
}
