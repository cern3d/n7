
import java.rmi.*;
import java.rmi.server.UnicastRemoteObject;

public class RRecordImpl extends UnicastRemoteObject implements RRecord {
    String name;
    String email;

    public RRecordImpl(String name,String email) throws RemoteException{
        this.name = name;
        this.email = email;
    }

	public String getName () throws RemoteException{
        return this.name;
    }
	public String getEmail () throws RemoteException{
        return this.email;
        }
}



