import java.rmi.*;
import java.util.List;

public interface HotelService extends Remote {
    List<String> getHotels(String Ville) throws RemoteException;
}
