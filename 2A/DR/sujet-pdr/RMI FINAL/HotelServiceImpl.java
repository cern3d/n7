import java.rmi.*;
import java.rmi.server.*;
import java.util.*;

public class HotelServiceImpl extends UnicastRemoteObject implements HotelService {

    private Map<String, List<String>> hotels;

    public HotelServiceImpl() throws RemoteException {
        hotels = new HashMap<>();
        List<String> toulouseHotels = new ArrayList<>();

        for (int i = 1; i <= 100; i++) {
            toulouseHotels.add("Hotel Toulouse " + i);
        }

        hotels.put("Toulouse", toulouseHotels);

        hotels.put("Nantes", List.of("Radisson Blu", "Astoria"));
    }

    @Override
    public List<String> getHotels(String Ville) throws RemoteException {
        return hotels.getOrDefault(Ville, new ArrayList<>());
    }
}
