

import java.io.Serializable;
import java.util.ArrayList;

public class resultData implements Serializable {

    private ArrayList<dataPoint> bpDist;
    private ArrayList<dataPoint> treeDist;

    public resultData(){
        bpDist = new ArrayList<dataPoint>();
        treeDist = new ArrayList<dataPoint>();
    }

    public resultData(ArrayList bp, ArrayList tree){
        bpDist = bp;
        treeDist = tree;
    }

    public ArrayList<dataPoint> getBpDist() {
        return bpDist;
    }

    public void setBpDist(ArrayList<dataPoint> bpDist) {
        this.bpDist = bpDist;
    }

    public ArrayList<dataPoint> getTreeDist() {
        return treeDist;
    }

    public void setTreeDist(ArrayList<dataPoint> treeDist) {
        this.treeDist = treeDist;
    }

    public boolean isEmpty(){
        return bpDist.isEmpty() && treeDist.isEmpty();
    }
}
