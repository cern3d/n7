package netlist.validation;

import java.util.List;
import java.util.Map;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl;

import netlist.NetlistPackage; // <-- adapte si besoin

public class ValidateNetlist {

    private static void afficherErreurs(String prefix, List<ValidationResult.ValidationError> errors) {
        System.out.print(prefix + ":");
        if (errors.isEmpty()) {
            System.out.println(" OK");
        } else {
            System.out.println(" " + errors.size() + " erreurs trouvées");
            for (ValidationResult.ValidationError error : errors) {
                System.out.println("=> " + error.toString());
            }
        }
    }

    private static void afficherResultat(ValidationResult resultat) {
        afficherErreurs("- Netlist", resultat.getRecordedErrorsFor(NetlistPackage.Literals.NETLIST));
        afficherErreurs("- Element", resultat.getRecordedErrorsFor(NetlistPackage.Literals.ELEMENT));
        afficherErreurs("- Instancecomp", resultat.getRecordedErrorsFor(NetlistPackage.Literals.INSTANCECOMP));
        afficherErreurs("- Connexion", resultat.getRecordedErrorsFor(NetlistPackage.Literals.CONNEXION));
        afficherErreurs("- Commentaire", resultat.getRecordedErrorsFor(NetlistPackage.Literals.COMMENTAIRE));
        afficherErreurs("- Port", resultat.getRecordedErrorsFor(NetlistPackage.Literals.PORT));
    }

    public static void main(String... args) {
        @SuppressWarnings("unused")
        NetlistPackage pkg = NetlistPackage.eINSTANCE;

        Resource.Factory.Registry reg = Resource.Factory.Registry.INSTANCE;
        Map<String, Object> m = reg.getExtensionToFactoryMap();
        m.put("xmi", new XMIResourceFactoryImpl());

        ResourceSet resSet = new ResourceSetImpl();
        NetlisteValidator validator = new NetlisteValidator();

        for (String model : args) {
            URI modelURI = URI.createURI(model);
            Resource resource = resSet.getResource(modelURI, true);

            ValidationResult resultat = validator.validate(resource);

            System.out.println("Résultat de validation Netlist pour " + model + ":");
            afficherResultat(resultat);
        }

        System.out.println("Fini.");
    }
}

