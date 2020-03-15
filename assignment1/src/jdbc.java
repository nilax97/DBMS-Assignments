import java.sql.*;
import java.io.*;
import java.util.*;

public class jdbc
{
	public static void main(String[] argv)
	{
		try
		{
      		//STEP 2: Register JDBC driver
      		Class.forName("org.postgresql.Driver");
      	} catch (ClassNotFoundException e)
      	{
      		System.out.println("JDBC driver not found.");
      	}

      	Connection connection = null;
      	Statement stmt = null;
      	long startTime=0;
      	long endTime=0;
      	long timeElapsed=0;
    	startTime = System.currentTimeMillis();
      	try
      	{
	
			connection = DriverManager.getConnection("jdbc:postgresql://127.0.0.1:5432/assn1");
			
			stmt = connection.createStatement();
			//PreparedStatement ps = connection.prepareStatement("INSERT INTO registers VALUES (?,?);");

			try
			{
				FileReader fr = new FileReader("datafile.csv");
				BufferedReader br = new BufferedReader(fr);

				String str;
				String ins;

				try
				{
					while ((str = br.readLine()) != null)
					{
						String [] vals = str.split(",",0);
						//ps.setString(vals[0], vals[1]);
						ins = ("INSERT INTO registers VALUES ('" + vals[0] + "','" + vals[1] + "');");
						stmt.executeUpdate(ins);

					}
				} catch(IOException e) {}
			}catch(FileNotFoundException e)
			{
				System.out.println("File not found");
			}

		} catch (SQLException e) 
		{

			System.out.println("Connection Failed.");
			e.printStackTrace();
			return;

		}
		endTime = System.currentTimeMillis();
		timeElapsed = endTime - startTime;
		System.out.println("Time elapsed: " + timeElapsed);
	}
}