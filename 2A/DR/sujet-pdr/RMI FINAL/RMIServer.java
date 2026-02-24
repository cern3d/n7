import java.rmi.*;
import java.rmi.registry.*;

public class RMIServer {
    public static void main(String[] args) throws Exception {

        LocateRegistry.createRegistry(1099);

        HotelService hotelService = new HotelServiceImpl();
        Annuaire annuaire = new AnnuaireImpl();

        Naming.rebind("HotelService", hotelService);
        Naming.rebind("AnnuaireService", annuaire);

        System.out.println("Serveur Hôtel et Annuaire prêts");
    }
}
