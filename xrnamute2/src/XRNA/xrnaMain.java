package XRNA;

import java.util.ArrayList;

public class xrnaMain {

    public static void main(String[] args){
        DB db = new DB();

        try {

            boolean ans = db.initTables();
            if(ans){
                //db.runQuery("SHOW TABLES");
                int id = db.insertInput("alice@example.com","10","20", "39", "AAAAAAAAAAUUUUUUUUUUUUUUTTTTTTTGGCCGCGCGCGCGCGCGCGCGCCGCGCCUUTUTTUTUTUTUTUTUTUT");
                if(id!=0){
                    System.out.println("Inserted successfully: "+id);
                    inputData data = db.getInput(id);
                    if(data!=null){
                        System.out.println("extracted successfully: "+data.getId());
                        final dataPoint dp1 = new dataPoint(20,50,0.67f);
                        final dataPoint dp2 = new dataPoint(25,55,0.87f);
                        final dataPoint dp3 = new dataPoint(32,70,0.47f);
                        final dataPoint dp4 = new dataPoint(10,120,0.17f);
                        ArrayList<dataPoint> bpdist = new ArrayList();
                        bpdist.add(dp1);
                        bpdist.add(dp2);
                        bpdist.add(dp3);
                        bpdist.add(dp4);
                        ArrayList<dataPoint> treedist = new ArrayList();
                        treedist.add(dp1);
                        treedist.add(dp2);
                        treedist.add(dp3);
                        treedist.add(dp4);
                        resultData res = new resultData(bpdist,treedist);
                        boolean ins = db.insertResults(id,res,1);
                        boolean ins2 = db.insertResults(id+1,null,2);
                        if(ins){
                            System.out.println("inserted results");
                            res = db.getResults(id);
                            if(!res.isEmpty()){
                                System.out.println("got results");
                                for(dataPoint d : res.getBpDist()){
                                    System.out.println(d.getX()+","+d.getY()+","+d.getColor());
                                }
                            }
                        }
                        if(ins2){
                            System.out.println("inserted failure");
                            int status = db.checkResults(id+1);
                            if(status == 2){
                                System.out.println("got failure");
                            }
                        }
                    }
                }

            } else {
                System.out.println("Failure");
            }

           /*
           try{
            SSHAgent agent = new SSHAgent("clustrix1.cs.bgu.ac.il","xrna2","L.#Xhi27");
            agent.connect();
            agent.executeCommand("cd /home/studies/projects/xrna2/ ; qsub -v id=<id> runAlgo.sh");
            // may want to try qsub -v id=<id> runAlgo.sh and change the script to use $ENV{id}
            }
            catch( Exception e )
            {
                e.printStackTrace();
            }*/
        }
        catch (Exception e) {
            System.out.print(e.getMessage());
        }




    }


   /*
    try
    {
        SSHAgent sshAgent = new SSHAgent( "192.168.1.13", "yarivz", "Banda(1)" );
        if( sshAgent.connect() )
        {
            sshAgent.executeCommand( "/home/yarivz/run.sh 12345" );
            System.out.println( "ans : " );

            // Logout
            sshAgent.logout();
        }
    }
    catch( Exception e )
    {
        e.printStackTrace();
    } */







}
