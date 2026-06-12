package catalogue.validation;

import java.util.List;
import java.util.Map;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl;

import catalogue.CataloguePackage; 

public class ValidateCatalogue {

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
        afficherErreurs("- Catalogue", resultat.getRecordedErrorsFor(CataloguePackage.Literals.CATALOGUE));
        afficherErreurs("- Composant", resultat.getRecordedErrorsFor(CataloguePackage.Literals.COMPOSANT));
        afficherErreurs("- Empreinte", resultat.getRecordedErrorsFor(CataloguePackage.Literals.EMPREINTE));
        afficherErreurs("- Contrainte", resultat.getRecordedErrorsFor(CataloguePackage.Literals.CONTRAINTE));
    }

    public static void main(String... args) {
        @SuppressWarnings("unused")
        CataloguePackage pkg = CataloguePackage.eINSTANCE;

        Resource.Factory.Registry reg = Resource.Factory.Registry.INSTANCE;
        Map<String, Object> m = reg.getExtensionToFactoryMap();
        m.put("xmi", new XMIResourceFactoryImpl());

        ResourceSet resSet = new ResourceSetImpl();
        CatalogueValidator validator = new CatalogueValidator();

        for (String model : args) {
            URI modelURI = URI.createURI(model);
            Resource resource = resSet.getResource(modelURI, true);

            ValidationResult resultat = validator.validate(resource);

            System.out.println("Résultat de validation Catalogue pour " + model + ":");
            afficherResultat(resultat);
        }

        System.out.println("Fini.");
    }
}
