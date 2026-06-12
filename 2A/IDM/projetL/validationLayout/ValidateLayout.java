package layout.validation;

import java.util.List;
import java.util.Map;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl;

import layout.LayoutPackage; 

public class ValidateLayout {

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
        afficherErreurs("- Layout", resultat.getRecordedErrorsFor(LayoutPackage.Literals.LAYOUT));
        afficherErreurs("- Board", resultat.getRecordedErrorsFor(LayoutPackage.Literals.BOARD));
        afficherErreurs("- Couche", resultat.getRecordedErrorsFor(LayoutPackage.Literals.COUCHE));
        afficherErreurs("- Couche_externe", resultat.getRecordedErrorsFor(LayoutPackage.Literals.COUCHE_EXTERNE));
        afficherErreurs("- Piste", resultat.getRecordedErrorsFor(LayoutPackage.Literals.PISTE));
        afficherErreurs("- Instancecomp (layout)", resultat.getRecordedErrorsFor(LayoutPackage.Literals.INSTANCECOMP));
    }

    public static void main(String... args) {
        @SuppressWarnings("unused")
        LayoutPackage pkg = LayoutPackage.eINSTANCE;

        Resource.Factory.Registry reg = Resource.Factory.Registry.INSTANCE;
        Map<String, Object> m = reg.getExtensionToFactoryMap();
        m.put("xmi", new XMIResourceFactoryImpl());

        ResourceSet resSet = new ResourceSetImpl();
        LayoutValidator validator = new LayoutValidator();

        for (String model : args) {
            URI modelURI = URI.createURI(model);
            Resource resource = resSet.getResource(modelURI, true);

            ValidationResult resultat = validator.validate(resource);

            System.out.println("Résultat de validation Layout pour " + model + ":");
            afficherResultat(resultat);
        }

        System.out.println("Fini.");
    }
}
