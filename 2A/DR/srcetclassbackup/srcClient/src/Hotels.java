import java.util.*;

public class Hotels extends AgentImpl {

    boolean start = true;

    Node n1 = new Node("localhost", 2001); // serveur liste hôtels
    Node n2 = new Node("localhost", 2002); // serveur map hôtels

    Node place = null;

    // Données collectées
    List<String> hotels = new ArrayList<>();
    Map<String, Integer> hotelNumbers = new HashMap<>();

    @Override
    public void main() throws MoveException {

        // départ
        if (start) {
            start = false;
            place = n1;
            System.out.println("Going to server 1 (hotel list)");
            move(n1);
        }

        // serveur 1 : liste des hôtels
        if (place == n1) {
            place = n2;

            System.out.println("On server 1: retrieving hotel list");

            // Récupération depuis le nameServer
            hotels = (List<String>) getNameServer().get("HOTEL_LIST");

            move(n2);
        }

        // serveur 2 : numéros des hôtels
        if (place == n2) {
            place = null;

            System.out.println("On server 2: retrieving hotel numbers");

            // Récupération depuis le nameServer
            hotelNumbers =
                (Map<String, Integer>) getNameServer().get("HOTEL_NUMBERS");

            back();
        }

        // retour
        System.out.println("Back to origin");
        for (String h : hotels) {
            System.out.println(h + " -> " + hotelNumbers.get(h));
        }

        Object o = getNameServer().get(this.getClass().getName() + "_lock");
        synchronized (o) {
            o.notify();
        }
    }
}
