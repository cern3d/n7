// Time-stamp: <06 jui 2023 11:58 Philippe Queinnec>

import CSP.*;

/** Réalisation de la voie unique avec des canaux JCSP. */
/* Version par automate d'états */
public class VoieUniqueAutomate implements VoieUnique {

    enum ChannelId { EntrerNS, EntrerSN, Sortir };
    
    private Channel<ChannelId> entrerNS;
    private Channel<ChannelId> entrerSN;
    private Channel<ChannelId> sortir;
    
    public VoieUniqueAutomate() {
        this.entrerNS = new Channel<>(ChannelId.EntrerNS);
        this.entrerSN = new Channel<>(ChannelId.EntrerSN);
        this.sortir = new Channel<>(ChannelId.Sortir);
        (new Thread(new Scheduler())).start();
    }

    public void entrer(Sens sens) {
        System.out.println("In  entrer " + sens);
        switch (sens) {
          case NS:
            entrerNS.write(true);
            break;
          case SN:
            entrerSN.write(true);
            break;
        }
        System.out.println("Out entrer " + sens);
    }

    public void sortir(Sens sens) {
        System.out.println("In  sortir " + sens);
        sortir.write(true);
        System.out.println("Out sortir " + sens);
    }

    public String nomStrategie() {
        return "Automate";
    }

    /****************************************************************/
    enum Etat { Libre, SN, NS }

    class Scheduler implements Runnable {
        private Etat etat = Etat.Libre;
        private int nb = 0;
        public void run() {
            Alternative<ChannelId> alt = new Alternative<>(entrerNS, entrerSN, sortir);
            while (true){
                if (etat == Etat.Libre) {
                    switch (alt.select()) {
                      case EntrerNS:
                        entrerNS.read();
                        etat = Etat.NS;
                        nb ++;
                        break;
                      case EntrerSN:
                        entrerSN.read();
                        etat = Etat.SN;
                        nb ++;
                        break;
                    }
                } else if (etat == Etat.SN) {
                    switch (alt.select()) {
                    case EntrerSN:
                        entrerSN.read();
                        //etat = Etat.LectureEnCours; // inchangé
                        nb++;
                        break;
                      case Sortir:
                        sortir.read();
                        nb--;
                        if (nb == 0) etat = Etat.Libre;
                        break;
                    }
                } else if (etat == Etat.NS) {
                    switch (alt.select()) {
                    case EntrerNS:
                        entrerNS.read();
                        //etat = Etat.LectureEnCours; // inchangé
                        nb++;
                        break;
                      case Sortir:
                        sortir.read();
                        nb--;
                        if (nb == 0) etat = Etat.Libre;
                        break;
                    }
                }
            }
        }
    } // class Scheduler
}

