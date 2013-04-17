

import java.awt.Color;
import java.awt.Paint;
import java.util.ArrayList;

import org.jfree.chart.renderer.xy.XYLineAndShapeRenderer;


public class MyRenderer extends XYLineAndShapeRenderer {
	ArrayList<dataPoint> myDataPoints;
	
	public MyRenderer(boolean lines, boolean shapes, ArrayList<dataPoint> myDataPoints) {
		super(lines, shapes);
		this.myDataPoints = myDataPoints;
	}

	@Override
	public Paint getItemPaint(int row, int col) {
		float pointColor = 1- myDataPoints.get(col).getColor();
		//System.out.println("myDataPoints.get(col).getColor(): "+ myDataPoints.get(col).getColor());
		return new Color(pointColor, pointColor, pointColor);

	}
}