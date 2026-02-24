/**
 */
package petrinet.impl;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;
import org.eclipse.emf.ecore.impl.MinimalEObjectImpl;
import org.eclipse.emf.ecore.util.EcoreUtil;
import petrinet.Arc;
import petrinet.Objet;
import petrinet.PetriNet;
import petrinet.PetrinetPackage;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>Arc</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * </p>
 * <ul>
 *   <li>{@link petrinet.impl.ArcImpl#getToken <em>Token</em>}</li>
 *   <li>{@link petrinet.impl.ArcImpl#getPredecessor_link <em>Predecessor link</em>}</li>
 *   <li>{@link petrinet.impl.ArcImpl#getSuccessor_link <em>Successor link</em>}</li>
 *   <li>{@link petrinet.impl.ArcImpl#getPetrinet <em>Petrinet</em>}</li>
 * </ul>
 *
 * @generated
 */
public class ArcImpl extends MinimalEObjectImpl.Container implements Arc {
	/**
	 * The default value of the '{@link #getToken() <em>Token</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getToken()
	 * @generated
	 * @ordered
	 */
	protected static final int TOKEN_EDEFAULT = 1;

	/**
	 * The cached value of the '{@link #getToken() <em>Token</em>}' attribute.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getToken()
	 * @generated
	 * @ordered
	 */
	protected int token = TOKEN_EDEFAULT;

	/**
	 * The cached value of the '{@link #getPredecessor_link() <em>Predecessor link</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getPredecessor_link()
	 * @generated
	 * @ordered
	 */
	protected Objet predecessor_link;

	/**
	 * The cached value of the '{@link #getSuccessor_link() <em>Successor link</em>}' reference.
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @see #getSuccessor_link()
	 * @generated
	 * @ordered
	 */
	protected Objet successor_link;

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	protected ArcImpl() {
		super();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	protected EClass eStaticClass() {
		return PetrinetPackage.Literals.ARC;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public int getToken() {
		return token;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setToken(int newToken) {
		int oldToken = token;
		token = newToken;
		if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, PetrinetPackage.ARC__TOKEN, oldToken, token));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Objet getPredecessor_link() {
		if (predecessor_link != null && predecessor_link.eIsProxy()) {
			InternalEObject oldPredecessor_link = (InternalEObject)predecessor_link;
			predecessor_link = (Objet)eResolveProxy(oldPredecessor_link);
			if (predecessor_link != oldPredecessor_link) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, PetrinetPackage.ARC__PREDECESSOR_LINK, oldPredecessor_link, predecessor_link));
			}
		}
		return predecessor_link;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Objet basicGetPredecessor_link() {
		return predecessor_link;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetPredecessor_link(Objet newPredecessor_link, NotificationChain msgs) {
		Objet oldPredecessor_link = predecessor_link;
		predecessor_link = newPredecessor_link;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, PetrinetPackage.ARC__PREDECESSOR_LINK, oldPredecessor_link, newPredecessor_link);
			if (msgs == null) msgs = notification; else msgs.add(notification);
		}
		return msgs;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setPredecessor_link(Objet newPredecessor_link) {
		if (newPredecessor_link != predecessor_link) {
			NotificationChain msgs = null;
			if (predecessor_link != null)
				msgs = ((InternalEObject)predecessor_link).eInverseRemove(this, PetrinetPackage.OBJET__SUCCESSOR, Objet.class, msgs);
			if (newPredecessor_link != null)
				msgs = ((InternalEObject)newPredecessor_link).eInverseAdd(this, PetrinetPackage.OBJET__SUCCESSOR, Objet.class, msgs);
			msgs = basicSetPredecessor_link(newPredecessor_link, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, PetrinetPackage.ARC__PREDECESSOR_LINK, newPredecessor_link, newPredecessor_link));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Objet getSuccessor_link() {
		if (successor_link != null && successor_link.eIsProxy()) {
			InternalEObject oldSuccessor_link = (InternalEObject)successor_link;
			successor_link = (Objet)eResolveProxy(oldSuccessor_link);
			if (successor_link != oldSuccessor_link) {
				if (eNotificationRequired())
					eNotify(new ENotificationImpl(this, Notification.RESOLVE, PetrinetPackage.ARC__SUCCESSOR_LINK, oldSuccessor_link, successor_link));
			}
		}
		return successor_link;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public Objet basicGetSuccessor_link() {
		return successor_link;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetSuccessor_link(Objet newSuccessor_link, NotificationChain msgs) {
		Objet oldSuccessor_link = successor_link;
		successor_link = newSuccessor_link;
		if (eNotificationRequired()) {
			ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, PetrinetPackage.ARC__SUCCESSOR_LINK, oldSuccessor_link, newSuccessor_link);
			if (msgs == null) msgs = notification; else msgs.add(notification);
		}
		return msgs;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setSuccessor_link(Objet newSuccessor_link) {
		if (newSuccessor_link != successor_link) {
			NotificationChain msgs = null;
			if (successor_link != null)
				msgs = ((InternalEObject)successor_link).eInverseRemove(this, PetrinetPackage.OBJET__PREDECESSOR, Objet.class, msgs);
			if (newSuccessor_link != null)
				msgs = ((InternalEObject)newSuccessor_link).eInverseAdd(this, PetrinetPackage.OBJET__PREDECESSOR, Objet.class, msgs);
			msgs = basicSetSuccessor_link(newSuccessor_link, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, PetrinetPackage.ARC__SUCCESSOR_LINK, newSuccessor_link, newSuccessor_link));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public PetriNet getPetrinet() {
		if (eContainerFeatureID() != PetrinetPackage.ARC__PETRINET) return null;
		return (PetriNet)eInternalContainer();
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	public NotificationChain basicSetPetrinet(PetriNet newPetrinet, NotificationChain msgs) {
		msgs = eBasicSetContainer((InternalEObject)newPetrinet, PetrinetPackage.ARC__PETRINET, msgs);
		return msgs;
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void setPetrinet(PetriNet newPetrinet) {
		if (newPetrinet != eInternalContainer() || (eContainerFeatureID() != PetrinetPackage.ARC__PETRINET && newPetrinet != null)) {
			if (EcoreUtil.isAncestor(this, newPetrinet))
				throw new IllegalArgumentException("Recursive containment not allowed for " + toString());
			NotificationChain msgs = null;
			if (eInternalContainer() != null)
				msgs = eBasicRemoveFromContainer(msgs);
			if (newPetrinet != null)
				msgs = ((InternalEObject)newPetrinet).eInverseAdd(this, PetrinetPackage.PETRI_NET__ARC, PetriNet.class, msgs);
			msgs = basicSetPetrinet(newPetrinet, msgs);
			if (msgs != null) msgs.dispatch();
		}
		else if (eNotificationRequired())
			eNotify(new ENotificationImpl(this, Notification.SET, PetrinetPackage.ARC__PETRINET, newPetrinet, newPetrinet));
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@SuppressWarnings("unchecked")
	@Override
	public NotificationChain eInverseAdd(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case PetrinetPackage.ARC__PREDECESSOR_LINK:
				if (predecessor_link != null)
					msgs = ((InternalEObject)predecessor_link).eInverseRemove(this, PetrinetPackage.OBJET__SUCCESSOR, Objet.class, msgs);
				return basicSetPredecessor_link((Objet)otherEnd, msgs);
			case PetrinetPackage.ARC__SUCCESSOR_LINK:
				if (successor_link != null)
					msgs = ((InternalEObject)successor_link).eInverseRemove(this, PetrinetPackage.OBJET__PREDECESSOR, Objet.class, msgs);
				return basicSetSuccessor_link((Objet)otherEnd, msgs);
			case PetrinetPackage.ARC__PETRINET:
				if (eInternalContainer() != null)
					msgs = eBasicRemoveFromContainer(msgs);
				return basicSetPetrinet((PetriNet)otherEnd, msgs);
		}
		return super.eInverseAdd(otherEnd, featureID, msgs);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs) {
		switch (featureID) {
			case PetrinetPackage.ARC__PREDECESSOR_LINK:
				return basicSetPredecessor_link(null, msgs);
			case PetrinetPackage.ARC__SUCCESSOR_LINK:
				return basicSetSuccessor_link(null, msgs);
			case PetrinetPackage.ARC__PETRINET:
				return basicSetPetrinet(null, msgs);
		}
		return super.eInverseRemove(otherEnd, featureID, msgs);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public NotificationChain eBasicRemoveFromContainerFeature(NotificationChain msgs) {
		switch (eContainerFeatureID()) {
			case PetrinetPackage.ARC__PETRINET:
				return eInternalContainer().eInverseRemove(this, PetrinetPackage.PETRI_NET__ARC, PetriNet.class, msgs);
		}
		return super.eBasicRemoveFromContainerFeature(msgs);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public Object eGet(int featureID, boolean resolve, boolean coreType) {
		switch (featureID) {
			case PetrinetPackage.ARC__TOKEN:
				return getToken();
			case PetrinetPackage.ARC__PREDECESSOR_LINK:
				if (resolve) return getPredecessor_link();
				return basicGetPredecessor_link();
			case PetrinetPackage.ARC__SUCCESSOR_LINK:
				if (resolve) return getSuccessor_link();
				return basicGetSuccessor_link();
			case PetrinetPackage.ARC__PETRINET:
				return getPetrinet();
		}
		return super.eGet(featureID, resolve, coreType);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void eSet(int featureID, Object newValue) {
		switch (featureID) {
			case PetrinetPackage.ARC__TOKEN:
				setToken((Integer)newValue);
				return;
			case PetrinetPackage.ARC__PREDECESSOR_LINK:
				setPredecessor_link((Objet)newValue);
				return;
			case PetrinetPackage.ARC__SUCCESSOR_LINK:
				setSuccessor_link((Objet)newValue);
				return;
			case PetrinetPackage.ARC__PETRINET:
				setPetrinet((PetriNet)newValue);
				return;
		}
		super.eSet(featureID, newValue);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public void eUnset(int featureID) {
		switch (featureID) {
			case PetrinetPackage.ARC__TOKEN:
				setToken(TOKEN_EDEFAULT);
				return;
			case PetrinetPackage.ARC__PREDECESSOR_LINK:
				setPredecessor_link((Objet)null);
				return;
			case PetrinetPackage.ARC__SUCCESSOR_LINK:
				setSuccessor_link((Objet)null);
				return;
			case PetrinetPackage.ARC__PETRINET:
				setPetrinet((PetriNet)null);
				return;
		}
		super.eUnset(featureID);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public boolean eIsSet(int featureID) {
		switch (featureID) {
			case PetrinetPackage.ARC__TOKEN:
				return token != TOKEN_EDEFAULT;
			case PetrinetPackage.ARC__PREDECESSOR_LINK:
				return predecessor_link != null;
			case PetrinetPackage.ARC__SUCCESSOR_LINK:
				return successor_link != null;
			case PetrinetPackage.ARC__PETRINET:
				return getPetrinet() != null;
		}
		return super.eIsSet(featureID);
	}

	/**
	 * <!-- begin-user-doc -->
	 * <!-- end-user-doc -->
	 * @generated
	 */
	@Override
	public String toString() {
		if (eIsProxy()) return super.toString();

		StringBuilder result = new StringBuilder(super.toString());
		result.append(" (token: ");
		result.append(token);
		result.append(')');
		return result.toString();
	}

} //ArcImpl
