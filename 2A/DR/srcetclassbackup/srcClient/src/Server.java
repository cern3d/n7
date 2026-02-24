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

public class Server implements Runnable {

    private Hashtable<String, Object> nameServer = new Hashtable<>();
    private int port;


    // Constructor that sets the port
    public Server(int port) {
        this.port = port;
    }

    // Constructor that sets the port and nameserver
    public Server(int port,Hashtable<String, Object> nameServer) {
        this.port = port;
        this.nameServer = nameServer;
    }

    @Override
    public void run() {
        try (ServerSocket server = new ServerSocket(port)) {
        System.out.println("Server ready on port " + port);

        // Inside the server loop
        Socket s = server.accept();
        DataInputStream in = new DataInputStream(s.getInputStream());

        // 1. Receive and save the JAR file
        String jarName = in.readUTF();
        int jarLen = in.readInt();
        byte[] jarBytes = in.readNBytes(jarLen);

        Path jarPath = Paths.get("MyAgent.jar");
        Files.write(jarPath, jarBytes);

        // 2. Create a ClassLoader pointing to that JAR
        URLClassLoader jarLoader = new URLClassLoader(
            new URL[]{jarPath.toFile().toURI().toURL()},
            this.getClass().getClassLoader() // Parent loader has Agent interface
        );

        // 3. Deserialize using the JAR loader
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

            s.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        if (args.length != 1) {
            System.out.println("usage: java Server <port>");
            return;
        }

        int port = Integer.parseInt(args[0]);
        Server server = new Server(port);
        new Thread(server).start();
    }
}
