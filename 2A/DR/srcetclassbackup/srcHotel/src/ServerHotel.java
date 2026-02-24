import java.io.*;
import java.nio.*;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.URL;
import java.net.URLClassLoader;
import java.nio.file.Files;
import java.util.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class ServerHotel implements Runnable {

    private Hashtable<String, Object> nameServer = new Hashtable<>();
    private int port;


    // Constructor that sets the port
    public ServerHotel(int port) {
        this.port = port;
    }

    // Constructor that sets the port and nameserver
    public ServerHotel(int port,Hashtable<String, Object> nameServer) {
        this.port = port;
        this.nameServer = nameServer;
    }

    @Override
    public void run() {
        try (ServerSocket ServerHotel = new ServerSocket(port)) {
        System.out.println("ServerHotel ready on port " + port);

        Socket s = ServerHotel.accept();
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
            s.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
    }

    public static void main(String[] args) {
        if (args.length != 1) {
            System.out.println("usage: java ServerHotel <port>");
            return;
        }

        int port = Integer.parseInt(args[0]);
        Hashtable<String, Object> hotelNS = new Hashtable<>();

        List<String> toulouseHotels = new ArrayList<>();

        for (int i = 1; i <= 100; i++) {
            toulouseHotels.add("Hotel Toulouse " + i);
        }

        hotelNS.put("HOTEL_LIST", toulouseHotels);

        ServerHotel ServerHotel = new ServerHotel(port,hotelNS);
        new Thread(ServerHotel).start();
    }
}
