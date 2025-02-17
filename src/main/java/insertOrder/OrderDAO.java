package insertOrder;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

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
	
	 public ArrayList<Order> getOrderList(int pageNumber) {
		 String SQL = "SELECT * FROM cargoorder WHERE cargoorderID < ? AND cargoorder = 1 ORDER BY orderNumber DESC LIMIT 10";
		 ArrayList<Order> list = new ArrayList<Order>();
			try {
				PreparedStatement pstmt = conn.prepareStatement(SQL);
				pstmt.setInt(1, getNext() - (pageNumber -1) * 10);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					Order order = new Order();
					//order.setOrder // 여기서 부터 다시하기
				}
			} catch ( Exception e ) {
				e.printStackTrace();
			}
		 return list;
	 }
	
	
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
	
	public int writeOrder( String userName, String orderDate, String carWeight, String kindOfCar, int refNumber, String userPhoneNumber, String fixedCarNumber, String upDown, String item, String etc, 
							String startDate, String endDate, String departureName, String arrivalName, String departureCities, String arrivalCities, String departureTown, String arrivalTown, String departureDetailedAddress, String arrivalDetailedAddress, String departureManager, String arrivalManager, String departureManagerPhoneNum, String arrivalManagerPhoneNum ) {
		String SQL = "INSERT INTO cargoorder VALUES(NOW()+1, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		java.util.Date sqlOrderDate = null;
		try {
			sqlOrderDate = sdf.parse(orderDate);
		} catch (ParseException e) {
			e.printStackTrace();
		}
        java.sql.Date resultOrderDate = new java.sql.Date(sqlOrderDate.getTime());
        java.util.Date sqlStartDate = null;
		try {
			sqlStartDate = sdf.parse(startDate);
		} catch (ParseException e) {
			e.printStackTrace();
		}
        java.sql.Date resultStartDate = new java.sql.Date(sqlStartDate.getTime());
        java.util.Date sqlEndDate = null;
		try {
			sqlEndDate = sdf.parse(endDate);
		} catch (ParseException e) {
			e.printStackTrace();
		}
        java.sql.Date resultEndDate = new java.sql.Date(sqlEndDate.getTime());
		try {
			if( userName == null || orderDate == null || carWeight == null || kindOfCar == null || startDate == null || endDate == null || departureCities == null 
				|| arrivalCities == null || departureTown == null || arrivalTown == null ) return -2;
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, kindOfCar);
			pstmt.setString(2, userName);
			pstmt.setDate(3, resultOrderDate);
			pstmt.setString(4, carWeight);
			pstmt.setInt(5, refNumber);
			pstmt.setString(6, userPhoneNumber);
			pstmt.setString(7, fixedCarNumber);
			pstmt.setString(8, upDown);
			pstmt.setString(9, item);
			pstmt.setString(10, etc);
			pstmt.setDate(11, resultStartDate);
			pstmt.setDate(12, resultEndDate);
			pstmt.setString(13, departureName);
			pstmt.setString(14, arrivalName);
			pstmt.setString(15, departureCities);
			pstmt.setString(16, arrivalCities);
			pstmt.setString(17, departureTown);
			pstmt.setString(18, arrivalTown);
			pstmt.setString(19, departureDetailedAddress);
			pstmt.setString(20, arrivalDetailedAddress);
			pstmt.setString(21, departureManager);
			pstmt.setString(22, arrivalManager);
			pstmt.setString(23, departureManagerPhoneNum);
			pstmt.setString(24, arrivalManagerPhoneNum);
			int resultRows = pstmt.executeUpdate();

			return resultRows;
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}
}
