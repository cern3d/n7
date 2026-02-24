import java.io.*;
import java.net.Socket;
import java.net.URI;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Hashtable;

public class AgentImpl implements Agent {

    private Node place;
    private String name;
    private Node origin;
    private transient Hashtable<String, Object> nameserver;
    private byte[] cachedJarBytes; // On garde le JAR en mémoire pour les déplacements suivants

    public void init(String name, Node origin) {
        this.name = name;
        this.origin = origin;
        this.place = origin;
    }

    public void setNameServer(Hashtable<String, Object> ns) {
        this.nameserver = ns;
    }

    public Hashtable<String, Object> getNameServer() {
        return nameserver;
    }

   public void move(Node target) throws MoveException {
    try (Socket s = new Socket(target.getHostname(), target.getPort())) {
        DataOutputStream out = new DataOutputStream(s.getOutputStream());


        // 1. Find the JAR file containing this class
        File jarFile = new File("MyAgent.jar");
        byte[] jarBytes = Files.readAllBytes(jarFile.toPath());
        
        // 2. Send the JAR
        out.writeUTF(jarFile.getName());
        out.writeInt(jarBytes.length);
        out.write(jarBytes);

        // 3. Serialize the object
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ObjectOutputStream oos = new ObjectOutputStream(baos);
        oos.writeObject(this);
        byte[] objBytes = baos.toByteArray();

        out.writeInt(objBytes.length);
        out.write(objBytes);
        
        out.close();
        baos.close();
        oos.close();

        s.close();

        throw new MoveException("Migration réussie");
    } catch (IOException ex) {
        ex.printStackTrace();
    }
    
}

    public void back() throws MoveException {
        move(this.origin);
    }

    public void main() throws MoveException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

}
