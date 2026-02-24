/** Définir une position.  */
public class Position {
	private final int x;
	private final int y;

	public Position(int x, int y) {
		this.x = x;
		this.y = y;
		System.out.println("...appel à Position(" + x + "," + y + ")" + " --> " + this);
	}

	@Override public String toString() {
		return super.toString() + "(" + x + "," + y + ")";
	}

	public int getX() {
		return x;
	}

	public int getY() {
		return y;
	}
}
