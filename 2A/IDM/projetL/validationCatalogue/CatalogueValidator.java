package catalogue.validation;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.resource.Resource;

import catalogue.*;
import catalogue.util.CatalogueSwitch;

public class CatalogueValidator extends CatalogueSwitch<Boolean> {

    private static final String IDENT_REGEX = "^[A-Za-z_][A-Za-z0-9_]*$";

    private ValidationResult result = null;

    public CatalogueValidator() {}

    public ValidationResult validate(Resource resource) {
        this.result = new ValidationResult();

        for (EObject object : resource.getContents()) {
            this.doSwitch(object);
        }
        return this.result;
    }

    @Override
    public Boolean caseCatalogue(Catalogue object) {
        
        result.recordIfFailed(
                object.getComposant() != null && !object.getComposant().isEmpty(),
                object,
                "Le catalogue ne contient aucun composant."
        );

        
        if (object.getComposant() != null) {
            for (Composant c : object.getComposant()) {
                this.doSwitch(c);
            }
        }
        return null;
    }

    @Override
    public Boolean caseComposant(Composant object) {
        
        result.recordIfFailed(
                object.getNom() != null && !object.getNom().trim().isEmpty(),
                object,
                "Le nom du composant est vide."
        );

        
        if (object.getNom() != null) {
            result.recordIfFailed(
                    object.getNom().matches(IDENT_REGEX),
                    object,
                    "Le nom du composant ne respecte pas les conventions (IDENT_REGEX)."
            );
        }

        
        result.recordIfFailed(
                object.getEmpreinte() != null,
                object,
                "Empreinte manquante : nécessaire pour valider le layout (chevauchement/dimensions)."
        );

        if (object.getEmpreinte() != null) {
            this.doSwitch(object.getEmpreinte());
        }

        
        if (object.getCatalogue() != null) {
            result.recordIfFailed(
                    object.getCatalogue().getComposant() != null &&
                    object.getCatalogue().getComposant().contains(object),
                    object,
                    "Référence 'catalogue' incohérente : le catalogue référencé ne contient pas ce composant."
            );
        }

        
        result.recordIfFailed(
                object.getPort() >= 0,
                object,
                "Nombre de ports (attribut 'port') négatif."
        );

        return null;
    }

    @Override
    public Boolean caseEmpreinte(Empreinte object) {
        
        result.recordIfFailed(
                object.getLongueur() > 0,
                object,
                "Empreinte.longueur doit être > 0."
        );
        result.recordIfFailed(
                object.getLargeur() > 0,
                object,
                "Empreinte.largeur doit être > 0."
        );

        
        if (object.getTaillePort() != 0) {
            result.recordIfFailed(
                    object.getTaillePort() >= 0,
                    object,
                    "Empreinte.TaillePort ne peut pas être négatif."
            );
        }

        return null;
    }

    @Override
    public Boolean caseContrainte(Contrainte object) {
        
        return null;
    }

    @Override
    public Boolean defaultCase(EObject object) {
        return null;
    }
}

