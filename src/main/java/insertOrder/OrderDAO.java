package insertOrder;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;

public class OrderDAO {
	
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	public OrderDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/ORDERS?serverTimezone=UTC&useSSL=false";;
			String dbID = "root";
			String dbPassword = "root";
			Class.forName( "com.mysql.jdbc.Driver" );
			conn = DriverManager.getConnection( dbURL, dbID, dbPassword );
		} catch ( Exception e ) {
			e.printStackTrace();
		}
	}
	
	/*
	 * public ArrayList<Order> getOrderList() {
	 * 
	 * }
	 */
	
	public String getDate() { 
		String SQL = "SELECT NOW()";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString(1);
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		return ""; // 데이터베이스 오류
	}
	
	public int getNext() { 
		String SQL = "SELECT orderNumber FROM cargoorder ORDER BY orderNumber DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1) + 1;
			}
			return 1;
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}
	
	public int write( String userName, Date orderDate, String carWeight, String kindOfCar, int refNumber, String userPhoneNumber, String fixedCarNumber, String upDown, String item, String etc ) {
		String SQL1 = "INSERT INTO cargoorder VALUES(NOW()+1, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		String SQL2 = "INSERT INTO carinfo VALUES(NOW()+1, '강예진', ?, null, null)";
		
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL1);
			pstmt.setString(1, userName);
			pstmt.setDate(2, (java.sql.Date)orderDate);
			pstmt.setString(3, carWeight);
			pstmt.setString(4, kindOfCar);
			pstmt.setInt(5, refNumber);
			pstmt.setString(6, userPhoneNumber);
			pstmt.setString(7, fixedCarNumber);
			pstmt.setString(8, upDown);
			pstmt.setString(9, item);
			pstmt.setString(10, etc);
			int resultRows = pstmt.executeUpdate();
			
			PreparedStatement pstmt2 = conn.prepareStatement(SQL2);
			pstmt2.setString(1, userPhoneNumber);
			int resultRows2 = pstmt2.executeUpdate();
			
			return resultRows + resultRows2;
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}
}
