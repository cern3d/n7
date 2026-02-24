package renderer.core.camera;

import renderer.algebra.Matrix;
import renderer.algebra.SizeMismatchException;
import renderer.algebra.Vector;


/**
 * The Transformation class represents a transformation in 3D space.
 * author: cdehais
 */
public class Transformation {

    /**
     * The world to camera matrix.
     */
    private Matrix worldToCamera;
    /**
     * The 3x4 projection matrix.
     */
    private Matrix projection;
    /**
     * The 3x3 calibration matrix.
     */
    private Matrix calibration;

    /**
     * Creates a new Transformation object.
     */
    public Transformation() {
        final int w2cDim = 4;
        worldToCamera = Matrix.createIdentity("W2C", w2cDim);
        final int projRows = 3;
        final int projCols = 4;
        projection = new Matrix("P", projRows, projCols);
        final int calibDim = 3;
        calibration = Matrix.createIdentity("K", calibDim);
    }

    /**
     * Sets the lookAt transformation.
     * @param eye a 3D vector representing the eye position
     * @param lookAtPoint a 3D vector representing the point to look at
     * @param up a 3D vector representing the up direction
     */
    public void setLookAt(final Vector eye, final Vector lookAtPoint, final Vector up) {
        try {
            // compute rotation
            Vector z = new Vector((lookAtPoint.subtract(eye)).normalize());
            Vector x = up.cross(z).normalize();
            Vector y = z.cross(x).normalize();
            Matrix view = new Matrix(4, 4);

            // Rotation
            view.set(0, 0, x.getX());
            view.set(1, 0, x.getY());
            view.set(2, 0, x.getZ());

            view.set(0, 1, y.getX());
            view.set(1, 1, y.getY());
            view.set(2, 1, y.getZ());

            view.set(0, 2, z.getX());
            view.set(1, 2, z.getY());
            view.set(2, 2, z.getZ());

            // compute translation
            view.set(0, 3, -x.dot(eye));
            view.set(1, 3, -y.dot(eye));
            view.set(2, 3, -z.dot(eye));

            // Last row
            view.set(3, 0, 0);
            view.set(3, 1, 0);
            view.set(3, 2, 0);
            view.set(3, 3, 1);

            worldToCamera = view;
        } catch (Exception e) {
            e.printStackTrace();
        }

        System.out.println("Modelview matrix:\n" + worldToCamera);
    }

    /**
     * Sets the projection matrix.
     */
    public void setProjection() {
        // Copy rotation
        projection = new Matrix(3, 4);

        // Copy rotation (3x3 part)
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                projection.set(i, j, worldToCamera.get(i, j));
            }
        }

        // Copy translation column
        projection.set(0, 3, worldToCamera.get(0, 3));
        projection.set(1, 3, worldToCamera.get(1, 3));
        projection.set(2, 3, worldToCamera.get(2, 3));


        System.out.println("Projection matrix:\n" + projection);
    }

    /**
     * Sets the calibration matrix.
     * @param focal the focal length
     * @param width the width of the image
     * @param height the height of the image
     */
    public void setCalibration(double focal, double width, double height) {

        calibration = new Matrix(3, 3);

        double cx = width / 2.0;
        double cy = height / 2.0;

        calibration.set(0, 0, focal);
        calibration.set(0, 1, 0);
        calibration.set(0, 2, cx);

        calibration.set(1, 0, 0);
        calibration.set(1, 1, focal);
        calibration.set(1, 2, cy);

        calibration.set(2, 0, 0);
        calibration.set(2, 1, 0);
        calibration.set(2, 2, 1);
        
        System.out.println("Calibration matrix:\n" + calibration);
    }

    /**
     * Projects the given 3 dimensional point onto the screen.
     * The resulting Vector as its (x,y) coordinates in pixel, and its z coordinate
     * is the depth of the point in the camera coordinate system.
     * @param p a 3d vector representing a point
     * @return the projected point as a 3d vector, with (x,y) the pixel
     * coordinates and z the depth
     * @throws SizeMismatchException if the size of the input vector is not 3
     */
    public Vector projectPoint(Vector p) throws SizeMismatchException {
        // TODO
        if (p.size() != 3) {
        throw new SizeMismatchException("Input vector must be size 3");
    }

    // Step 1: Convert to homogeneous world point
    Vector pw = new Vector(4);
    pw.set(0, p.get(0));
    pw.set(1, p.get(1));
    pw.set(2, p.get(2));
    pw.set(3, 1.0);

    // Step 2: Transform to camera coordinates
    Vector pc = worldToCamera.multiply(pw);

    double Xc = pc.get(0);
    double Yc = pc.get(1);
    double Zc = pc.get(2);  // depth

    // Step 3: Apply intrinsic matrix K
    Vector camPoint = new Vector(3);
    camPoint.set(0, Xc);
    camPoint.set(1, Yc);
    camPoint.set(2, Zc);

    Vector projected = calibration.multiply(camPoint);

    // Step 4: Perspective division
    double u = projected.get(0) / projected.get(2);
    double v = projected.get(1) / projected.get(2);

    // Step 5: Return pixel + depth
    Vector ps = new Vector(3);
    ps.set(0, u);
    ps.set(1, v);
    ps.set(2, Zc);   // depth in camera space

    return ps;
    }

    /**
     * Transform a vector from world to camera coordinates.
     * @param v the vector to transform
     * @return the transformed vector
     * @throws SizeMismatchException if the size of the input vector is not 3
     */
    public Vector transformVector(final Vector v) {
        // Doing nothing special here because there is no scaling
        final Matrix m = worldToCamera.getSubMatrix(0, 0, 3, 3);
        return m.multiply(v);
    }

}
