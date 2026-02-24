
import java.io.*;
import java.net.*;
import java.util.Random;

class LoadBalancer implements Runnable {
    private int nbports = 2;
    private int ports[] = {8081,8082};
    Random rand = new Random();

    private Socket input;

    LoadBalancer(Socket s){this.input = s;}

    public void run(){
        try{
        
        int i = rand.nextInt(nbports);
        Socket output = new Socket("localhost", ports[i]);

        byte[] buff = new byte[1024];
        InputStream inputInputStream = input.getInputStream();
        OutputStream inputOutputStream = input.getOutputStream();
        int Bread;
        Bread = inputInputStream.read(buff);


        OutputStream outputOutputStream = output.getOutputStream();
        outputOutputStream.write(buff,0,Bread);

        InputStream outputInputStream = output.getInputStream();
        while ((Bread=outputInputStream.read(buff)) != -1)
        inputOutputStream.write(buff,0,Bread);

        output.close();
        input.close();
        } catch (Exception e){
            e.printStackTrace();
        }
    }


public static void main(String[] args) 
{
    try {
        ServerSocket ss = new ServerSocket(8080);
        System.out.println("server turning on 8080");
        while (true){
            (new Thread(new LoadBalancer(ss.accept()))).start();
        }
    } catch (Exception e){
        e.printStackTrace();
    }
}

}