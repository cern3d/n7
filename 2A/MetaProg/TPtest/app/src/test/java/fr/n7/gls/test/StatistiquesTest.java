/**
 * StatistiquesTest, classe de test de Statistiques.
 *
 * @author	Xavier Crégut &lt;Prenom.Nom@enseeiht.fr&gt;
 */

package fr.n7.gls.test;

import org.junit.*;
import static org.junit.Assert.*;

import java.util.*;

public class StatistiquesTest {

	@Test
	public void testStatistiquesNominal() {
		List<Integer> l = new ArrayList<>();
		Collections.addAll(l, 1, 3, 11, 5, 7);
		Statistiques.Resultat<Integer> r = new Statistiques().statistiques(l);
		assertEquals(Integer.valueOf(1), r.min);
		assertEquals(Integer.valueOf(11), r.max);
		assertEquals(1, r.nbMin);
		assertEquals(1, r.nbMax);
	}
	
	
	@Test
	public void testStatistiquesNominal2() {
		List<Integer> l = new ArrayList<>();
		Collections.addAll(l,  10,11,1,1);
		Statistiques.Resultat<Integer> r = new Statistiques().statistiques(l);
		assertEquals(Integer.valueOf(1), r.min);
		assertEquals(Integer.valueOf(11), r.max);
		assertEquals(1, r.nbMin);
		assertEquals(1, r.nbMax);
	}
	
	@Test
	public void testStatistiquesNominalPlusieursMax() {
		List<Integer> l = new ArrayList<>();
		Collections.addAll(l, 7, 11, 1, 3, 5, 11, 11);
		Statistiques.Resultat<Integer> r = new Statistiques().statistiques(l);
		assertEquals(Integer.valueOf(1), r.min);
		assertEquals(Integer.valueOf(11), r.max);
		assertEquals(3, r.nbMin);
		assertEquals(3, r.nbMax);
	}

}
