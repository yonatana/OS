package XRNA;

public class inputData {

    private String email,sequence;
    private int id,windowMin,windowMax,temp;

    public inputData(){
        email = "";
        sequence = "";
        id = 0;
        windowMin = 0;
        windowMax = 0;
        temp = 0;
    }

    public inputData(int idIn, String emailIn, int windowMinIn, int windowMaxIn, int tempIn, String sequenceIn){
        email = emailIn;
        sequence = sequenceIn;
        id = idIn;
        windowMin = windowMinIn;
        windowMax = windowMaxIn;
        temp = tempIn;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getSequence() {
        return sequence;
    }

    public void setSequence(String sequence) {
        this.sequence = sequence;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getWindowMin() {
        return windowMin;
    }

    public void setWindowMin(int windowMin) {
        this.windowMin = windowMin;
    }

    public int getWindowMax() {
        return windowMax;
    }

    public void setWindowMax(int windowMax) {
        this.windowMax = windowMax;
    }

    public int getTemp() {
        return temp;
    }

    public void setTemp(int temp) {
        this.temp = temp;
    }
}
