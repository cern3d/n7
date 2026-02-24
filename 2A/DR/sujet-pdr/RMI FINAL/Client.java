import java.rmi.*;
import java.util.*;

public class Client {
    public static void main(String[] args) throws Exception {
        long times=System.nanoTime();

        HotelService hotelService=(HotelService) Naming.lookup("HotelService");
        Annuaire annuaire =(Annuaire) Naming.lookup("AnnuaireService");
        
        String Ville ="Toulouse";
        //String Ville="Nantes";
        List<String> hotels = hotelService.getHotels(Ville);
        System.out.println("Numéros des hôtels à " + Ville+ " :");
        for (String h : hotels) {
            int phone = annuaire.getPhone(h);
            System.out.println(h + " : " + phone);
        }
        long timee=System.nanoTime();
        System.out.println("Done main in ms: "+(timee-times)/1000000);
        

    }
}
