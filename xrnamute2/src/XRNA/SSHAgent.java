package XRNA;


import ch.ethz.ssh2.Connection;
import ch.ethz.ssh2.Session;
import ch.ethz.ssh2.StreamGobbler;

import java.io.*;
import java.util.Properties;
import java.util.logging.FileHandler;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * The SSHAgent allows a Java application to execute commands on a remote server via SSH
 *
 * @author shaines
 *
 */
public class SSHAgent {

    //private final static Logger LOGGER = Logger.getLogger(DB.class.getName());

    /**
     * The hostname (or IP address) of the server to connect to
     */
    private String hostname;

    /**
     * The username of the user on that server
     */
    private String username;

    /**
     * The password of the user on that server
     */
    private String password;

    /**
     * A connection to the server
     */
    private Connection connection;


    private boolean PARAMS_LOADED = false;

    /**
     * Creates a new SSHAgent2
     *
     * @param hostname
     * @param username
     * @param password
     */
    public SSHAgent(String hostname, String username, String password)
    {
        this.hostname = hostname;
        this.username = username;
        this.password = password;
        try{
            //LOGGER.addHandler(new FileHandler("XRNAmute2.log"));
            //LOGGER.setLevel(Level.INFO);
            if (!PARAMS_LOADED){
                File params = new File("SSH_PARAMS");
                if (params.exists()){
                    Properties prop = new Properties();
                    FileInputStream fstream= new FileInputStream("SSH_PARAMS");
                    DataInputStream in = new DataInputStream(fstream);
                    prop.load(in);
                    if(!prop.isEmpty()){
                        this.hostname = prop.getProperty("hostname").isEmpty() ? hostname : prop.getProperty("hostname");
                        this.username = prop.getProperty("username").isEmpty() ? username : prop.getProperty("username");
                        this.password = prop.getProperty("password").isEmpty() ? password : prop.getProperty("password");
                        PARAMS_LOADED = true;
                    }
                }
            }
        }
        catch (IOException e){
            System.out.println(e.getMessage());
        }
    }

    /**
     * Connects to the server
     *
     * @return        True if the connection succeeded, false otherwise
     */
    public boolean connect() throws Exception
    {
        try
        {
            // Connect to the server
            connection = new Connection( hostname );
            connection.connect();

            // Authenticate
            boolean result = connection.authenticateWithPassword( username, password );
            System.out.println( "Connection result: " + result );
            return result;
        }
        catch( Exception e )
        {
            //LOGGER.severe("An exception occurred while trying to connect to the host: " + hostname + ", Exception=" + e.getMessage());
            //throw new Exception( "An exception occurred while trying to connect to the host: " + hostname + ", Exception=" + e.getMessage(), e );
            return false;
        }
    }

    /**
     * Executes the specified command and returns the response from the server
     *
     * @param command        The command to execute
     * @return               The response that is returned from the server (or null)
     */
    public String executeCommand( String command ) throws Exception
    {
        try
        {
            // Open a session
            Session session = connection.openSession();

            // Execute the command
            session.execCommand( command );

            // Read the results
            StringBuilder sb = new StringBuilder();
            InputStream stdout = new StreamGobbler( session.getStdout() );
            BufferedReader br = new BufferedReader(new InputStreamReader(stdout));
            String line = br.readLine();
            while( line != null )
            {
                sb.append( line + "\n" );
                line = br.readLine();
            }

            // DEBUG: dump the exit code
            System.out.println( "ExitCode: " + session.getExitStatus() );

            // Close the session
            session.close();

            // Return the results to the caller
            return sb.toString();
        }
        catch( Exception e )
        {
            //LOGGER.severe("An exception occurred while executing the following command: " + command + ". Exception = " + e.getMessage());
            //throw new Exception( "An exception occurred while trying to connect to the host: " + hostname + ", Exception=" + e.getMessage(), e );
            return "ERROR";        }
    }

    /**
     * Logs out from the server
     * @throws SSHException
     */
    public void logout() throws Exception
    {
        try
        {
            connection.close();
        }
        catch( Exception e )
        {
            //LOGGER.severe("An exception occurred while closing the SSH connection: " + e.getMessage());
            //throw new Exception( "An exception occurred while closing the SSH connection: " + e.getMessage(), e );
        }
    }

    /**
     * Returns true if the underlying authentication is complete, otherwise returns false
     * @return
     */
    public boolean isAuthenticationComplete()
    {
        return connection.isAuthenticationComplete();
    }


}