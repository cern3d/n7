import java.rmi.*;
import java.rmi.server.*;
import java.util.*;

public class AnnuaireImpl extends UnicastRemoteObject implements Annuaire {

    private Map<String, Integer> phones;

    public AnnuaireImpl() throws RemoteException {
        phones = new HashMap<>();
        for (int i = 1; i <= 99; i++) {
            phones.put("Hotel Toulouse " + i, i);
        }
        phones.put("Hotel Toulouse 100",50);
        phones.put("Radisson Blu", 60);
        phones.put("Astoria", 70);
    }

    @Override
    public int getPhone(String hotelNom) throws RemoteException {
        return phones.get(hotelNom);
    }
}
