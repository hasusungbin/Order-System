package insertOrder;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

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
	
	public List<Order> getAllList() {
        try (SqlSession session = MybatisUtil.getSession()) {
            return session.selectList("insertOrder.OrderDAO.getAllList");
        }
    }
	
	 public ArrayList<Order> getOrderList( int pageNumber ) {
		 String SQL = "SELECT * FROM cargoorder WHERE orderID < ? ORDER BY orderID DESC LIMIT 10";
		 ArrayList<Order> list = new ArrayList<Order>();
			try {
				PreparedStatement pstmt = conn.prepareStatement( SQL );
				pstmt.setInt( 1, getNext() - (pageNumber -1) * 10 );
				rs = pstmt.executeQuery();
				while ( rs.next() ) {
					Order order = new Order();
					order.setOrderNumber( rs.getString(1) );
					order.setKindOfCar( rs.getString(2) );
					order.setUserName( rs.getString(3) );
					order.setOrderDate( rs.getString(4) );
					order.setCarWeight( rs.getString(5) );
					order.setRefNumber( rs.getInt(6) );
					order.setUserPhoneNumber( rs.getString(7) );
					order.setFixedCarNumber( rs.getString(8) );
					order.setUpDown( rs.getString(9) );
					order.setItem( rs.getString(10) );
					order.setEtc( rs.getString(11) );
					order.setStartDate( rs.getString(12) );
					order.setEndDate( rs.getString(13) );
					order.setDepartureName( rs.getString(14) );
					order.setArrivalName( rs.getString(15) );
					order.setDepartureCities( rs.getString(16) );
					order.setArrivalCities( rs.getString(17) );
					order.setDepartureTown( rs.getString(18) );
					order.setArrivalTown( rs.getString(19) );
					order.setDepartureDetailedAddress( rs.getString(20) );
					order.setArrivalDetailedAddress( rs.getString(21) );
					order.setDepartureManager( rs.getString(22) );
					order.setArrivalManager( rs.getString(23) );
					order.setDepartureManagerPhoneNum( rs.getString(24) );
					order.setArrivalManagerPhoneNum( rs.getString(25) );
					order.setOrderID( rs.getInt(26) );
					order.setCarNumber( rs.getString(27) );
					order.setDriverName( rs.getString(28) );
					order.setDriverPhoneNum( rs.getString(29) );
					order.setBasicFare( rs.getInt(30) );
					order.setAddFare( rs.getInt(31) );
					order.setRegDate( rs.getDate(32) );
					list.add( order );
				}
			} catch ( Exception e ) {
				e.printStackTrace();
			}
		return list;
	 }
	 
	 public boolean nextPage( int pageNumber ) {
		 String SQL = "SELECT * FROM cargoorder WHERE orderID < ? ORDER BY orderID DESC LIMIT 10";
			try {
				PreparedStatement pstmt = conn.prepareStatement( SQL );
				pstmt.setInt(1, getNext() - (pageNumber -1) * 10);
				rs = pstmt.executeQuery();
				if ( rs.next() ) {
					return true;
				}
			} catch ( Exception e ) {
				e.printStackTrace();
			}
		return false;
	 }
	
	
	public String getDate() { 
		String SQL = "SELECT NOW()";
		try {
			PreparedStatement pstmt = conn.prepareStatement( SQL );
			rs = pstmt.executeQuery();
			if( rs.next() ) {
				return rs.getString( 1 );
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		return ""; // 데이터베이스 오류
	}
	
	public int getNext() { 
		String SQL = "SELECT orderID FROM cargoorder ORDER BY orderID DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement( SQL );
			rs = pstmt.executeQuery();
			if( rs.next() ) {
				return rs.getInt( 1 ) + 1;
			}
			return 1;
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}
	
	public int writeOrder( String kindOfCar, String userName, String orderDate, String carWeight, int refNumber, String userPhoneNumber, String fixedCarNumber, String upDown, String item, String etc, 
							String startDate, String endDate, String departureName, String arrivalName, String departureCities, String arrivalCities, String departureTown, String arrivalTown, String departureDetailedAddress, 
							String arrivalDetailedAddress, String departureManager, String arrivalManager, String departureManagerPhoneNum, String arrivalManagerPhoneNum ) {
		String SQL = "INSERT INTO cargoorder(orderNumber, kindOfCar, userName, orderDate, carWeight, refNumber, userPhoneNumber, fixedCarNumber, upDown, item, etc, startDate, endDate, departureName, arrivalName, departureCities, arrivalCities, departureTown, arrivalTown, departureDetailedAddress, arrivalDetailedAddress, departureManager, arrivalManager, departureManagerPhoneNum, arrivalManagerPhoneNum, orderID ) "
				+ "VALUES(NOW()+1, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
		
		SimpleDateFormat sdf = new SimpleDateFormat( "yyyy-MM-dd" );
		java.util.Date sqlOrderDate = null;
		java.util.Date sqlStartDate = null;
		java.util.Date sqlEndDate = null;
		try {
			sqlOrderDate = sdf.parse( orderDate );
		} catch ( ParseException e ) {
			e.printStackTrace();
		}
        java.sql.Date resultOrderDate = new java.sql.Date( sqlOrderDate.getTime() );
		
        try {
			sqlStartDate = sdf.parse( startDate );
		} catch ( ParseException e ) {
			e.printStackTrace();
		}
        java.sql.Date resultStartDate = new java.sql.Date( sqlStartDate.getTime() );
        
		try {
			sqlEndDate = sdf.parse( endDate );
		} catch ( ParseException e ) {
			e.printStackTrace();
		}
        java.sql.Date resultEndDate = new java.sql.Date( sqlEndDate.getTime() );
        
		try {
			if( kindOfCar == null || userName == null || orderDate == null || carWeight == null || startDate == null || endDate == null || departureCities == null 
				|| arrivalCities == null || departureTown == null || arrivalTown == null ) return -2;
			PreparedStatement pstmt = conn.prepareStatement( SQL );
			pstmt.setString( 1, kindOfCar );
			pstmt.setString( 2, userName );
			pstmt.setDate( 3, resultOrderDate );
			pstmt.setString( 4, carWeight );
			pstmt.setInt( 5, refNumber );
			pstmt.setString( 6, userPhoneNumber );
			pstmt.setString( 7, fixedCarNumber );
			pstmt.setString( 8, upDown );
			pstmt.setString( 9, item );
			pstmt.setString( 10, etc );
			pstmt.setDate( 11, resultStartDate );
			pstmt.setDate( 12, resultEndDate );
			pstmt.setString( 13, departureName );
			pstmt.setString( 14, arrivalName );
			pstmt.setString( 15, departureCities );
			pstmt.setString( 16, arrivalCities );
			pstmt.setString( 17, departureTown );
			pstmt.setString( 18, arrivalTown );
			pstmt.setString( 19, departureDetailedAddress );
			pstmt.setString( 20, arrivalDetailedAddress );
			pstmt.setString( 21, departureManager );
			pstmt.setString( 22, arrivalManager );
			pstmt.setString( 23, departureManagerPhoneNum );
			pstmt.setString( 24, arrivalManagerPhoneNum );
			pstmt.setInt( 25, getNext() );
			int resultRows = pstmt.executeUpdate();

			return resultRows;
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}
	
	public List<Order> getSearchList( String startDate, String endDate, int refNumber, String userName, String departureName, String arrivalName, String arrivalCities, int pageNumber, String orderNumber ) {
		int pageSize = 10;
		System.out.println(pageNumber);
		try (SqlSession session = MybatisUtil.getSession()) {
			Map<String, Object> params = new HashMap<>();
            params.put("startDate", startDate);
            params.put("endDate", endDate);
            params.put("refNumber", refNumber);
            params.put("userName", userName);
            params.put("departureName", departureName);
            params.put("arrivalName", arrivalName);
            params.put("arrivalCities", arrivalCities);
            params.put("pageNumber", (pageNumber -1) * pageSize);
            params.put("pageSize", pageSize);
            params.put("orderNumber", orderNumber);

            return session.selectList("insertOrder.OrderDAO.getSearchList", params);
			}
	}
	
	//public int updateSelect( String orderNumber, )
}

