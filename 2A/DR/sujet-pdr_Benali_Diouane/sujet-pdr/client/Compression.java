import java.util.zip.*;
import java.io.*;

public class Compression extends AgentImpl {

    boolean start = true;

    Node n2 = new Node("localhost", 2002);
    Node place = null;

    byte[] compressedFile;

    @Override
    public void main() throws MoveException {
        if (start) {
            start = false;
            place = n2;
            move(n2);
        }

        if (place == n2) {
            place = null;

            Object data = getNameServer().get("DATA_FILE");
            byte[] fileBytes = ((String)data).getBytes();
            System.out.println("Uncompressed size: " + (fileBytes != null ? fileBytes.length : 0));


            try (ByteArrayOutputStream baos = new ByteArrayOutputStream();
                 GZIPOutputStream gzipOut = new GZIPOutputStream(baos)) {

                gzipOut.write(fileBytes);
                gzipOut.finish();
                compressedFile = baos.toByteArray();

            } catch (Exception e) { e.printStackTrace(); }

            back();
        }

        System.out.println("Back to origin");

        System.out.println("Compressed size: " + (compressedFile != null ? compressedFile.length : 0));

        Object o = getNameServer().get(this.getClass().getName() + "_lock");
        synchronized (o) {
            o.notify();
        }
    }
}