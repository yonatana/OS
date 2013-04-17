
import java.io.Serializable;

public class dataPoint implements Serializable {

    private int x;
    private int y;
    private float color;

    public dataPoint() {
        x = 0;
        y = 0;
        color = 0;
    }

    public dataPoint(int newX, int newY, float newColor) {
        x = newX;
        y = newY;
        color = newColor;
    }

    public int getX() {
        return x;
    }

    public void setX(int x) {                            this.x = x;
    }

    public int getY() {
        return y;
    }

    public void setY(int y) {
        this.y = y;
    }

    public float getColor() {
        return color;
    }

    public void setColor(float color) {
        this.color = color;
    }
}
