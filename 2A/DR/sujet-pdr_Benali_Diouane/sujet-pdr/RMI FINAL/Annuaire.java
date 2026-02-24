import java.rmi.*;

public interface Annuaire extends Remote {
    int getPhone(String hotelName) throws RemoteException;
}
