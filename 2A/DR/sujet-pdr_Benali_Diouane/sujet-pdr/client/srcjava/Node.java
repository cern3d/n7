/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
public class Node implements NodeInt {

    private int s;
    private String hostname;

    public Node(String name, int port) {
        this.s = port;
        this.hostname = name;
    }

    public int getPort() {
        return s;
    }

    public String getHostname() {
        return hostname;
    }

}
