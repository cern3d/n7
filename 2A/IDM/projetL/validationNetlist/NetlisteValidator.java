package netlist.validation;

import java.util.HashSet;
import java.util.Set;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.resource.Resource;

import netlist.*;
import netlist.util.NetlistSwitch;

public class NetlisteValidator extends NetlistSwitch<Boolean> {

    private static final String IDENT_REGEX = "^[A-Za-z_][A-Za-z0-9_]*$";

    private ValidationResult result = null;

    
    private Set<String> ids = new HashSet<>();

    public NetlisteValidator() {}

    public ValidationResult validate(Resource resource) {
        this.result = new ValidationResult();
        this.ids.clear();

        for (EObject object : resource.getContents()) {
            this.doSwitch(object);
        }
        return this.result;
    }

    @Override
    public Boolean caseNetlist(Netlist object) {
        
        result.recordIfFailed(
                object.getElement() != null && !object.getElement().isEmpty(),
                object,
                "Netlist vide : aucun élément."
        );

        
        if (object.getElement() != null) {
            for (Element e : object.getElement()) {
                this.doSwitch(e);
            }
        }
        return null;
    }

    @Override
    public Boolean caseElement(Element object) {
        
        result.recordIfFailed(
                object.getId() != null && !object.getId().trim().isEmpty(),
                object,
                "Element.id est vide."
        );

        if (object.getId() != null) {

            
            result.recordIfFailed(
                    ids.add(object.getId()),
                    object,
                    "ID dupliqué dans la netlist : " + object.getId()
            );
        }

        
        result.recordIfFailed(
                object.getNetlist() != null,
                object,
                "Element.netlist est null (incohérence containment/opposite)."
        );

        return null;
    }

    @Override
    public Boolean caseInstancecomp(Instancecomp object) {
        
        catalogue.Composant c = object.getComposant();
        result.recordIfFailed(
            c != null,
            object,
            "Une instance doit référencer un composant du catalogue."
        );

        if (c != null) {
            int nbPortsCatalogue = c.getPort();              
            int nbPortsNetlist = object.getPort().size();    

            result.recordIfFailed(
                nbPortsNetlist == nbPortsCatalogue,
                object,
                "Nombre de ports incohérent : netlist=" + nbPortsNetlist
                + " alors que catalogue=" + nbPortsCatalogue
                + " (composant=" + c.getNom() + ")."
            );
        }
       
        if (object.getPort() != null) {
            for (Port p : object.getPort()) {
                this.doSwitch(p);
            }
        }
        return null;
    }

    @Override
    public Boolean caseConnexion(Connexion object) {
        result.recordIfFailed(
                object.getPorta() != null && object.getPortb() != null,
                object,
                "Connexion doit définir porta et portb."
        );

        if (object.getPorta() != null && object.getPortb() != null) {
            result.recordIfFailed(
                    object.getPorta() != object.getPortb(),
                    object,
                    "Connexion relie deux fois le même port."
            );
        }
        return null;
    }

    @Override
    public Boolean casePort(Port object) {
        
        return null;
    }

    @Override
    public Boolean caseCommentaire(Commentaire object) {
        result.recordIfFailed(
                object.getTexte() != null && !object.getTexte().trim().isEmpty(),
                object,
                "Commentaire.texte est vide."
        );

        
        result.recordIfFailed(
                object.getNetlist() != null || object.getInstancecomp() != null,
                object,
                "Commentaire doit référencer netlistcom ou instancecomp."
        );
        return null;
    }

    @Override
    public Boolean defaultCase(EObject object) {
        return null;
    }
}
