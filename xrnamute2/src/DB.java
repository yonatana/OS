

import java.io.*;
import java.sql.*;
import java.util.logging.FileHandler;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.Properties;

public class DB {

    //default values for connection to the XRNA.DB, may be replaced by DB_PARAMS property file containing different values
    private String dbName = "mysqlsrv1.cs.bgu.ac.il/xrnamute2";
    private String user =  "xrnamute2";
    private String password = "@oj8~V0S";
    private boolean PARAMS_LOADED = false;

    /*
     Hard-coded queries to be used in inserting and retrieving data from the DB
     */
    private PreparedStatement st;
    final int STATUS_FAILURE = 2;
    final int STATUS_SUCCESS = 1;
    final String WRITE_RESULT = "INSERT INTO RESULTS(id, result, status,created) VALUES (?, ?, ?, NOW())";
    final String READ_RESULT = "SELECT result FROM RESULTS WHERE id = ?";
    final String CHECK_RESULT = "SELECT status FROM RESULTS WHERE id = ?";
    final String WRITE_INPUT = "INSERT INTO USER_INPUT(id,email,windowMin,windowMax,temp,sequence,created) VALUES (?,?,?,?,?,?,NOW())";
    final String READ_INPUT = "SELECT email, windowMin, windowMax, temp, sequence FROM USER_INPUT WHERE id = ?";
    final String PURGE_OLD_INPUT = "DELETE FROM USER_INPUT WHERE created < (NOW()- INTERVAL 1 MONTH)";
    final String PURGE_OLD_RESULT = "DELETE FROM RESULTS WHERE created < (NOW()- INTERVAL 1 MONTH)";
    final String INIT_USER_INPUT_TABLE = "CREATE TABLE IF NOT EXISTS USER_INPUT "+
                                                "(id INT UNSIGNED NOT NULL AUTO_INCREMENT, " +
                                                "email VARCHAR(30), " +
                                                "windowMin INTEGER, " +
                                                "windowMax INTEGER, " +
                                                "temp INTEGER, " +
                                                "sequence MEDIUMTEXT NOT NULL, "+
                                                "created DATETIME, " +
                                                "PRIMARY KEY (id))";
    final String INIT_RESULTS_TABLE =    "CREATE TABLE IF NOT EXISTS RESULTS "+
                                                "(id INT UNSIGNED NOT NULL, " +
                                                "result BLOB, " +
                                                "status SET('success','failure') NOT NULL, " +
                                                "created DATETIME, " +
                                                "PRIMARY KEY (id))";
    //Logger for exceptions logging
    private final static Logger LOGGER = Logger.getLogger(DB.class.getName());

    public DB(){
        try{
            LOGGER.addHandler(new FileHandler("XRNAmute2.log"));
            LOGGER.setLevel(Level.INFO);

            if (!PARAMS_LOADED){
                File params = new File("DB_PARAMS");
                if (params.exists()){
                    Properties prop = new Properties();
                    FileInputStream fstream= new FileInputStream("DB_PARAMS");
                    DataInputStream in = new DataInputStream(fstream);
                    prop.load(in);
                    if(!prop.isEmpty()){
                        dbName = prop.getProperty("db").isEmpty() ? dbName : prop.getProperty("db");
                        user = prop.getProperty("user").isEmpty() ? user : prop.getProperty("user");
                        password = prop.getProperty("password").isEmpty() ? password : prop.getProperty("password");
                        PARAMS_LOADED = true;
                    }
                }
            }
        }
        catch (IOException e){
            System.out.println(e.getMessage());
        }
        if(!initTables())
            System.out.println("Could not initialize XRNA.DB tables, please see log");
    }


    /*
    Initialize the tables if they do not already exist, and purges rows older than 1 month from both tables
    if DB_PARAMS file is present in the directory, DB credentials may be retrieved from it
    @return ans - true if queries were executed, false otherwise
     */
    public boolean initTables(){
        boolean ans = false;
        try
        {
            Connection newCon = dbConnect();
            if (newCon != null){
                st = newCon.prepareStatement(INIT_USER_INPUT_TABLE);
                st.executeUpdate();
                st = newCon.prepareStatement(INIT_RESULTS_TABLE);
                st.executeUpdate();
                ans = true;
                st = newCon.prepareStatement(PURGE_OLD_INPUT);
                st.executeUpdate();
                st = newCon.prepareStatement(PURGE_OLD_RESULT);
                st.executeUpdate();

                st.close();
                newCon.close();
            }
        }
            catch (Exception e){
                LOGGER.severe("Could not initialize the tables in the DB: "+e.getMessage());
                ans = false;
            }
        return ans;
    }

    /*
    Try to connect to the DB
    @return conn - a DB connection if successful, null otherwise
     */
    public Connection dbConnect()
    {
        try
        {
            Class.forName("com.mysql.jdbc.Driver").newInstance();
            Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://"+dbName,user , password);
            return conn;
        }
        catch (Exception e)
        {
            LOGGER.warning("Could not connect to DB: "+e.getMessage());
            return null;
        }
    }
    /*
    Insert the user input into the DB for the algorithm's use
    @param email - the user's email address, may be empty
    @param windowMin - the minimum size for the algorithm's sliding window
    @param windowMax - the maximum size for the algorithm's sliding window
    @param temp - the temperature for the algorithm's calculation, default is 38
    @param sequence - the RNA sequence for the algorithm
    @return id - the row number (unique identifier) in the DB USER_INPUT table, where the data was saved if successful, 0 otherwise.
     */
    public int insertInput(String email,String windowMin, String windowMax, String temp, String sequence){
        Connection newCon = dbConnect();
        int id = 0;   //default id is 0, will be replaced if insertion succeeds
        try{
            if(newCon!=null) {
                st = newCon.prepareStatement(WRITE_INPUT,Statement.RETURN_GENERATED_KEYS);
                st.setInt(1,0);
                st.setString(2, email);
                st.setInt(3, Integer.parseInt(windowMin));
                st.setInt(4, Integer.parseInt(windowMax));
                st.setInt(5, Integer.parseInt(temp));
                st.setString(6, sequence);
                st.executeUpdate();
                ResultSet rs = st.getGeneratedKeys();
                if(rs.next())
                    id = rs.getInt(1);
                rs.close();
                st.close();
                newCon.close();
            }
        }
        catch (SQLException e){
            LOGGER.warning("Could not insert input to DB: "+e.getMessage());
        }
        return id;
    }
    /*
    Extract the user input from the DB
    @param id - the unique identifier for the row of the user input
    @return in - the inputData object representing the user input to be calculated if successful, an empty object otherwise
     */
    public inputData getInput(int id){
        Connection newCon = dbConnect();
        inputData in = new inputData();   //default is an empty object, will be replaced if query succeeds
        try{
            if(newCon!=null) {
                st =  newCon.prepareStatement(READ_INPUT);
                st.setInt(1,id);
                ResultSet rs = st.executeQuery();
                if (rs.next()) {
                    in = new inputData(id,rs.getString("email"),rs.getInt("windowMin"),rs.getInt("windowMax"),rs.getInt("temp"),rs.getString("sequence"));
                }
                rs.close();
                st.close();
                newCon.close();
            }
        }
        catch (SQLException e){
            LOGGER.warning("Could not get input from DB for id "+id+" : "+e.getMessage());
        }
        return in;
    }
    /*
    Insert the algorithm's result into the DB
    @param id - the unique identifier for the row of the user input, to be used as the identifier for the correlating result
    @param data - the resultData object representing the calculation results for bp distance and tree-edit distance for the given input
    @param status - the job status, 1 if finished successfully, 2 if failed
    @return ans - true if the insertion succeeded, false otherwise
     */
    public boolean insertResults(int id,resultData data, int status){
        Connection newCon = dbConnect();
        boolean ans = false;
        try{
            if(newCon!=null) {
                st =  newCon.prepareStatement(WRITE_RESULT);
                st.setInt(1,id);
                if(status == STATUS_FAILURE)
                {
                    st.setString(3,"failure");
                    st.setObject(2, new resultData());
                }
                else
                {
                    st.setString(3,"success");
                    st.setObject(2, data);
                }
                if(st.executeUpdate()>0){
                    ans = true;
                }
                st.close();
                newCon.close();
            }
        }
        catch (SQLException e){
            LOGGER.warning("Could not insert result to DB for id "+id+" : "+e.getMessage());
        }
        return ans;
    }
    /*
    Extract the result from the DB
    @param id - the unique identifier for the row of the result, matching the correlating input
    @return res - the resultData object representing the calculation results for bp distance and tree-edit distance for the given input if successful, empty object otherwise
     */
    public resultData getResults(int id){
        Connection newCon = dbConnect();
        resultData res = new resultData();
        try{
            if(newCon!=null) {
                st =  newCon.prepareStatement(READ_RESULT);
                st.setInt(1,id);
                ResultSet rs = st.executeQuery();
                if (rs.next()) {
                    InputStream is = rs.getBlob("result").getBinaryStream();
                    ObjectInputStream ois = new ObjectInputStream(is);
                    Object x = ois.readObject();
                    res = (resultData)x;
                }
                rs.close();
                st.close();
                newCon.close();
            }
        }
        catch (Exception e){
            LOGGER.warning("Could not get result from DB for id "+id+" : "+e.getMessage());
        }
        return res;
    }

    /*
    Check the result status in the DB
    @param id - the unique identifier for the row of the result, matching the correlating input
    @return res - the int returned represents the job status - 0 if pending, 1 if successful, 2 if failed.
     */
    public int checkResults(int id){
        Connection newCon = dbConnect();
        int res = 0;
        try{
            if(newCon!=null) {
                st =  newCon.prepareStatement(CHECK_RESULT);
                st.setInt(1,id);
                ResultSet rs = st.executeQuery();
                if (rs.next()) {
                    if(rs.getString("status").equals("success"))
                        res = STATUS_SUCCESS;
                    else if(rs.getString("status").equals("failure"))
                        res = STATUS_FAILURE;
                }
                rs.close();
                st.close();
                newCon.close();
            }
        }
        catch (Exception e){
            LOGGER.warning("Could not check result in DB for id "+id+" : "+e.getMessage());
        }
        return res;
    }



    /*
    Utility method to help debugging the DB operations by running queries
     */
    public void runQuery(String query){
        Connection newCon = dbConnect();
        if (newCon != null){
            try{
                ResultSet rs = st.executeQuery(query);
                while (rs.next()) {
                    String db = rs.getString(1);
                    System.out.println(db);
                }
            }
            catch (SQLException e){
                System.out.println(e.getMessage());
            }
        } else {
            System.out.println("could not connect...");
        }
    }



}
