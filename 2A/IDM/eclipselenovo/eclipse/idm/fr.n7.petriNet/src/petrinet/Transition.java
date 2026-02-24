/**
 */
package petrinet;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>Transition</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * </p>
 * <ul>
 *   <li>{@link petrinet.Transition#getTemp_min <em>Temp min</em>}</li>
 *   <li>{@link petrinet.Transition#getTemp_max <em>Temp max</em>}</li>
 * </ul>
 *
 * @see petrinet.PetrinetPackage#getTransition()
 * @model
 * @generated
 */
public interface Transition extends Objet {
	/**
	 * Returns the value of the '<em><b>Temp min</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Temp min</em>' attribute.
	 * @see #setTemp_min(int)
	 * @see petrinet.PetrinetPackage#getTransition_Temp_min()
	 * @model
	 * @generated
	 */
	int getTemp_min();

	/**
	 * Sets the value of the '{@link petrinet.Transition#getTemp_min <em>Temp min</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Temp min</em>' attribute.
	 * @see #getTemp_min()
	 * @generated
	 */
	void setTemp_min(int value);

	/**
	 * Returns the value of the '<em><b>Temp max</b></em>' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @return the value of the '<em>Temp max</em>' attribute.
	 * @see #setTemp_max(int)
	 * @see petrinet.PetrinetPackage#getTransition_Temp_max()
	 * @model
	 * @generated
	 */
	int getTemp_max();

	/**
	 * Sets the value of the '{@link petrinet.Transition#getTemp_max <em>Temp max</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @param value the new value of the '<em>Temp max</em>' attribute.
	 * @see #getTemp_max()
	 * @generated
	 */
	void setTemp_max(int value);

} // Transition
