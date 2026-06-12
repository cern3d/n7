package layout.validation;

import java.util.List;
import java.util.HashSet;
import java.util.Set;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.resource.Resource;

import layout.*;
import layout.util.LayoutSwitch;
import netlist.*;
import catalogue.Composant;
import catalogue.Empreinte;

public class LayoutValidator extends LayoutSwitch<Boolean> {

    private ValidationResult result = null;

    public LayoutValidator() {}

    public ValidationResult validate(Resource resource) {
        this.result = new ValidationResult();

        for (EObject object : resource.getContents()) {
            this.doSwitch(object);
        }
        return this.result;
    }

    @Override
    public Boolean caseLayout(Layout object) {
        
        result.recordIfFailed(
                object.getBoard() != null && !object.getBoard().isEmpty(),
                object,
                "Layout sans board."
        );

        if (object.getBoard() != null) {
            for (Board b : object.getBoard()) {
                this.doSwitch(b);
            }
        }
        return null;
    }

    @Override
    public Boolean caseBoard(Board object) {
        
        result.recordIfFailed(
                object.getLayout() != null,
                object,
                "Board.layout est null."
        );

       
        result.recordIfFailed(
                object.getCouche_externe() == null || object.getCouche_externe().size() <= 2,
                object,
                "Board possède plus de 2 couches externes."
        );

        Set<Connexion> connexionsVues = new HashSet<>();
        if (object.getCouche_interne() != null) {
            for (Couche_interne ci : object.getCouche_interne()) this.doSwitch(ci);
        }
        if (object.getCouche_externe() != null) {
            for (Couche_externe ce : object.getCouche_externe()) this.doSwitch(ce);
        }
        for (Couche c : object.getCouche_externe()) {
            for (Piste p : c.getPiste()) {
                Connexion cx = p.getConnexion();
                if (cx != null) {
                    result.recordIfFailed(
                        connexionsVues.add(cx),
                        p,
                        "Deux pistes ne doivent pas référencer la même connexion ."
                    );
                }
            }
        }

        // pistes des couches internes
        for (Couche c : object.getCouche_interne()) {
            for (Piste p : c.getPiste()) {
                Connexion cx = p.getConnexion();
                if (cx != null) {
                    result.recordIfFailed(
                        connexionsVues.add(cx),
                        p,
                        "Deux pistes ne doivent pas référencer la même connexion ."
                    );
                }
            }
        }

        
        Set<netlist.Instancecomp> instancesVues = new HashSet<>();

        for (Couche_externe ce : object.getCouche_externe()) {
            for (layout.Instancecomp plc : ce.getInstancecomp()) {
                netlist.Instancecomp inst = plc.getComposant(); // référence vers netlist::Instancecomp
                if (inst != null) {
                    result.recordIfFailed(
                        instancesVues.add(inst),
                        plc,
                        "Une instance netlist ne peut pas être placée deux fois dans le layout."
                    );
                }
            }
        }

        // Continuer la visite (optionnel si tu as d'autres contraintes)
        for (Couche_externe ce : object.getCouche_externe()) {
            doSwitch(ce);
        }
        for (Couche ci : object.getCouche_interne()) {
            doSwitch(ci);
        }
        return null;
    }

    @Override
    public Boolean caseCouche(Couche object) {
        
        if (object.getPiste() != null) {
            for (Piste p : object.getPiste()) this.doSwitch(p);
        }
        return null;
    }

    @Override
    public Boolean caseCouche_externe(Couche_externe object) {
        // Visite parent Couche (pistes)
        this.caseCouche(object);

        // Sur couche externe : composants placés
        if (object.getInstancecomp() != null) {
            for (layout.Instancecomp ic : object.getInstancecomp()) {
                this.doSwitch(ic);
            }
        }
        for (layout.Instancecomp plc : object.getInstancecomp()) {
            result.recordIfFailed(
                plc.eContainer() == object,
                plc,
                "Cette instance de layout ne doit pas être contenue dans une autre couche."
            );
        }

        // Contrainte générale : pas de chevauchement
        checkNoOverlap(object);

        return null;
    }

    @Override
    public Boolean casePiste(Piste object) {
        result.recordIfFailed(
                object.getCouche() != null,
                object,
                "Piste.couche est null."
        );

        // F3.5 : une piste doit pointer vers une connexion netlist
        result.recordIfFailed(
                object.getConnexion() != null,
                object,
                "Piste.connexion manquante."
        );

        // cohérence : connexion appartient à une netlist (Connexion hérite Element)
        if (object.getConnexion() != null) {
            result.recordIfFailed(
                    object.getConnexion().getNetlist() != null,
                    object,
                    "La connexion référencée n'appartient à aucune netlist ."
            );
        }

        return null;
    }

    @Override
    public Boolean caseInstancecomp(layout.Instancecomp object) {
        // F3.5 local : un composant placé doit référencer une instance netlist
        result.recordIfFailed(
                object.getComposant() != null,
                object,
                "Composant placé sans référence vers netlist::Instancecomp."
        );

        // Vérifie empreinte dispo pour vérifier contraintes géométriques
        if (object.getComposant() != null) {
            // object.getComposant() = netlist::Instancecomp
            Composant catComp = object.getComposant().getComposant(); // netlist Instancecomp -> catalogue Composant
            result.recordIfFailed(
                    catComp != null,
                    object,
                    "Instance netlist référencée sans composant catalogue."
            );

            if (catComp != null) {
                Empreinte e = catComp.getEmpreinte();
                result.recordIfFailed(
                        e != null,
                        object,
                        "Composant catalogue sans empreinte (impossible de valider géométrie)."
                );
            }
        }

        return null;
    }

    private void checkNoOverlap(Couche_externe coucheExt) {
        List<layout.Instancecomp> pcs = coucheExt.getInstancecomp();
        if (pcs == null) return;

        for (int i = 0; i < pcs.size(); i++) {
            for (int j = i + 1; j < pcs.size(); j++) {
                layout.Instancecomp p1 = pcs.get(i);
                layout.Instancecomp p2 = pcs.get(j);

                if (p1.getComposant() == null || p2.getComposant() == null) continue;
                Composant c1 = p1.getComposant().getComposant();
                Composant c2 = p2.getComposant().getComposant();
                if (c1 == null || c2 == null) continue;
                if (c1.getEmpreinte() == null || c2.getEmpreinte() == null) continue;

                double x1 = p1.getX();
                double y1 = p1.getY();
                double w1 = c1.getEmpreinte().getLongueur();
                double h1 = c1.getEmpreinte().getLargeur();

                double x2 = p2.getX();
                double y2 = p2.getY();
                double w2 = c2.getEmpreinte().getLongueur();
                double h2 = c2.getEmpreinte().getLargeur();

                boolean overlap = rectanglesOverlap(x1, y1, w1, h1, x2, y2, w2, h2);
                result.recordIfFailed(
                        !overlap,
                        coucheExt,
                        "Chevauchement détecté entre deux composants placés."
                );
            }
        }
    }

    private static boolean rectanglesOverlap(double x1, double y1, double w1, double h1,
                                             double x2, double y2, double w2, double h2) {
        boolean separated =
                (x1 + w1 <= x2) || (x2 + w2 <= x1) ||
                (y1 + h1 <= y2) || (y2 + h2 <= y1);
        return !separated;
    }

    @Override
    public Boolean defaultCase(EObject object) {
        return null;
    }
}

