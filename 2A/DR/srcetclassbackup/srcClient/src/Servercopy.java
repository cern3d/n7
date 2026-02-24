
import java.io.ByteArrayInputStream;
import java.io.DataInputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectStreamClass;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Hashtable;

public class Servercopy {

    private static Hashtable<String, Object> nameServer = new Hashtable<>();

    public static void run(int port) throws Exception {

        ServerSocket server = new ServerSocket(port);
        System.out.println("server ready");

        while (true) {
            Socket s = server.accept();
            DataInputStream in = new DataInputStream(s.getInputStream());

            String className = in.readUTF();
            int classLen = in.readInt();
            byte[] classBytes = in.readNBytes(classLen);

            int objLen = in.readInt();
            byte[] objBytes = in.readNBytes(objLen);

            Loader loader = new Loader();
            loader.addClass(className, classBytes);

            ObjectInputStream ois = new ObjectInputStream(
                    new ByteArrayInputStream(objBytes)) {

                @Override
                protected Class<?> resolveClass(ObjectStreamClass desc)
                        throws IOException, ClassNotFoundException {
                    return loader.loadClass(desc.getName());
                }
            };

            Agent a = (Agent) ois.readObject();
            a.setNameServer(nameServer);
            System.out.println("received agent");
            try {
                a.main();
            } catch (MoveException e) {
            }

            s.close();
        }
    }

    public static void main(String[] args) throws Exception {
        if (args.length != 1) {
            System.out.println("usage: java Server <port>");
            return;
        }
        int port = Integer.parseInt(args[0]);
        run(port);
        System.out.print("DONE");
    }
}
