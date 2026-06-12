import java.util.*;
import java.io.File;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.*;
import org.eclipse.emf.ecore.resource.impl.*;
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl;

import layout.*;
import netlist.*;

public class Verifie {

    public static void main(String[] args) throws Exception {

        Scanner sc = new Scanner(System.in);

        System.out.print("Layout XMI path: ");
        String layoutPath = sc.nextLine().trim();

        System.out.print("Netlist XMI path: ");
        String netlistPath = sc.nextLine().trim();

        if (!new File(layoutPath).exists())
            throw new RuntimeException("Layout file not found");

        if (!new File(netlistPath).exists())
            throw new RuntimeException("Netlist file not found");

        LayoutPackage.eINSTANCE.eClass();
        NetlistPackage.eINSTANCE.eClass();

        ResourceSet rs = new ResourceSetImpl();
        rs.getResourceFactoryRegistry()
          .getExtensionToFactoryMap()
          .put("xmi", new XMIResourceFactoryImpl());

        Resource layoutRes = rs.getResource(
            URI.createFileURI(layoutPath), true);

        Resource netlistRes = rs.getResource(
            URI.createFileURI(netlistPath), true);

        Layout layout = (Layout) layoutRes.getContents().get(0);
        Netlist netlist = (Netlist) netlistRes.getContents().get(0);

        checkInstanceComp(layout, netlist);

        System.out.println("MODELS ARE COHERENT");
        sc.close();
    }

    static void checkInstanceComp(Layout layout, Netlist netlist) {

        List<layout.Instancecomp> layoutIC = new ArrayList<>();

        for (Board b : layout.getBoard())
            for (Couche_externe ce : b.getCouche_externe())
                layoutIC.addAll(ce.getInstancecomp());

        List<netlist.Instancecomp> netlistIC = new ArrayList<>();

        for (Element e : netlist.getElement())
            if (e instanceof netlist.Instancecomp)
                netlistIC.add((netlist.Instancecomp) e);

        if (layoutIC.size() != netlistIC.size())
            throw new RuntimeException(
                "Instancecomp count mismatch: layout="
                + layoutIC.size() + ", netlist="
                + netlistIC.size());

        Set<String> netlistIds = new HashSet<>();
        for (netlist.Instancecomp ic : netlistIC)
            netlistIds.add(ic.getId());

        for (layout.Instancecomp ic : layoutIC)
            if (!netlistIds.contains(ic.getName()))
                throw new RuntimeException(
                    "Missing Instancecomp in netlist: "
                    + ic.getName());
    }
}
