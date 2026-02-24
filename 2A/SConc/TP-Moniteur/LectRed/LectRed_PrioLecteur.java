// Time-stamp: <11 oct 2024 08:19 Philippe Queinnec>

import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import Synchro.Assert;

/** Lecteurs/rédacteurs
 * stratégie d'ordonnancement: priorité aux lecteurs,
 * implantation: avec un moniteur. */
public class LectRed_PrioLecteur implements LectRed{
    private Lock mon;
    private Condition AccesL;
    private Condition AccesR;
    private int nb_att;
    private int nb_lect;
    private int nb_red;

    public LectRed_PrioLecteur() {
        this.mon = new ReentrantLock();
        this.AccesL = mon.newCondition();
        this.AccesR = mon.newCondition();
        this.nb_lect = 0;
        this.nb_red = 0;
        this.nb_att = 0;
    }

    public void demanderLecture() throws InterruptedException {
        mon.lock();
        while (!(nb_red==0 && nb_att == 0)){
            AccesL.await();
        }
        nb_lect+=1;
        AccesL.signal();
        mon.unlock();
    }

    public void terminerLecture() throws InterruptedException {
        mon.lock();
        nb_lect-=1;
        if (nb_lect==0){
            AccesR.signal();
        }
        mon.unlock();
    }

    public void demanderEcriture() throws InterruptedException {
        mon.lock();
        while (!(nb_lect==0 && nb_red==0)){
            nb_att+=1;
            AccesR.await();
            nb_att-=1;
        }
        nb_red+=1;
        mon.unlock();
    }

    public void terminerEcriture() throws InterruptedException {
        mon.lock();
        nb_red-=1;
        if (nb_att>0){
        AccesR.signal();
        } else {AccesL.signal();}
        mon.unlock();
    }

    public String nomStrategie() {
        return "Stratégie: Priorité Lecteurs.";
    }
}
