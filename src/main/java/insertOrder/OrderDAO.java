package insertOrder;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

import user.UserDAO;

public class OrderDAO {
	
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	private HttpSession session;
	private SqlSession sqlSession;
	
	public OrderDAO() {
	}
	public OrderDAO(SqlSession sqlSession) {
        this.sqlSession = sqlSession;
    }
	
	public void setSession(HttpSession session) {
        this.session = session;
    }
	
	public List<Order> getAllList() {
        try ( SqlSession session = MybatisUtil.getSession() ) {
            return session.selectList("OrderDAO.getAllList");
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
	
	public int writeOrder(
	        String userID, String kindOfCar, String userName, String orderDate, String carWeight,
	        int refNumber, String userPhoneNumber, String fixedCarNumber, String upDown, String item,
	        String etc, String startDate, String endDate, String departureName, String arrivalName,
	        String departureCities, String arrivalCities, String departureTown, String arrivalTown,
	        String departureDetailedAddress, String arrivalDetailedAddress, String departureManager,
	        String arrivalManager, String departureManagerPhoneNum, String arrivalManagerPhoneNum,
	        String driverName, String driverPhoneNum,
	        String option1, String option2, String option3, String option4, String destinationAddress,
	        String userCompany) {

	    int affectedRows = 0;
	    SqlSession sqlSession = null;
	    Connection conn = null;
	    PreparedStatement pstmt = null;

	    try {
	        // ✅ 트랜잭션 가능한 세션 열기
	        sqlSession = MybatisUtil.getSession();
	        conn = sqlSession.getConnection(); 
	        conn.setAutoCommit(false);

	        // ✅ 현재 날짜 (yyMMdd 형식) 생성 → "250313"
	        SimpleDateFormat dateFormat = new SimpleDateFormat("yyMMdd");
	        String datePart = dateFormat.format(new Date());

	        // ✅ 밀리초 값에서 뒤 6자리 사용 → 동시성 문제 방지
	        String timePart = String.valueOf(System.currentTimeMillis()).substring(7);

	        // ✅ orderNumber 생성 (날짜 + 밀리초)
	        String orderNumber = datePart + timePart;

	        // ✅ SQL 작성 (orderID는 제외)
	        String sql = "INSERT INTO cargoorder (" +
	                "orderNumber, kindOfCar, userName, orderDate, carWeight, refNumber, " +
	                "userPhoneNumber, fixedCarNumber, upDown, item, etc, " +
	                "startDate, endDate, departureName, arrivalName, " +
	                "departureCities, arrivalCities, departureTown, arrivalTown, " +
	                "departureDetailedAddress, arrivalDetailedAddress, departureManager, arrivalManager, " +
	                "departureManagerPhoneNum, arrivalManagerPhoneNum, driverName, driverPhoneNum, option1, option2, option3, option4, " +
	                "destinationAddress, userCompany) " +
	                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

	        // ✅ PreparedStatement 생성
	        pstmt = conn.prepareStatement(sql);

	        pstmt.setString(1, orderNumber);
	        pstmt.setString(2, kindOfCar);
	        pstmt.setString(3, userName);
	        pstmt.setString(4, orderDate);
	        pstmt.setString(5, carWeight);
	        pstmt.setInt(6, refNumber);
	        pstmt.setString(7, userPhoneNumber);
	        pstmt.setString(8, fixedCarNumber);
	        pstmt.setString(9, upDown);
	        pstmt.setString(10, item);
	        pstmt.setString(11, etc);
	        pstmt.setString(12, startDate);
	        pstmt.setString(13, endDate);
	        pstmt.setString(14, departureName);
	        pstmt.setString(15, arrivalName);
	        pstmt.setString(16, departureCities);
	        pstmt.setString(17, arrivalCities);
	        pstmt.setString(18, departureTown);
	        pstmt.setString(19, arrivalTown);
	        pstmt.setString(20, departureDetailedAddress);
	        pstmt.setString(21, arrivalDetailedAddress);
	        pstmt.setString(22, departureManager);
	        pstmt.setString(23, arrivalManager);
	        pstmt.setString(24, departureManagerPhoneNum);
	        pstmt.setString(25, arrivalManagerPhoneNum);
	        pstmt.setString(26, driverName);
	        pstmt.setString(27, driverPhoneNum);
	        pstmt.setString(28, option1);
	        pstmt.setString(29, option2);
	        pstmt.setString(30, option3);
	        pstmt.setString(31, option4);
	        pstmt.setString(32, destinationAddress);
	        pstmt.setString(33, userCompany);

	        // ✅ 쿼리 실행
	        affectedRows = pstmt.executeUpdate();

	        if (affectedRows > 0) {
	            // ✅ 커밋
	            conn.commit();
	        } else {
	            // ❌ 실패 시 롤백
	            conn.rollback();
	        }

	    } catch (Exception e) {
	        if (conn != null) {
	            try {
	                conn.rollback(); 
	            } catch (SQLException rollbackEx) {
	                rollbackEx.printStackTrace();
	            }
	        }
	        e.printStackTrace();

	    } finally {
	        try {
	            if (pstmt != null) pstmt.close();
	            if (conn != null) conn.setAutoCommit(true);
	            if (sqlSession != null) sqlSession.close();
	        } catch (SQLException closeEx) {
	            closeEx.printStackTrace();
	        }
	    }
	    return affectedRows;
	}
	
	public int writeOrder(
	        String userID, String kindOfCar, String userName, String orderDate, String carWeight,
	        int refNumber, String userPhoneNumber, String upDown, String item,
	        String etc, String startDate, String endDate, String departureName, String arrivalName,
	        String departureCities, String arrivalCities, String departureTown, String arrivalTown,
	        String departureDetailedAddress, String arrivalDetailedAddress, String departureManager,
	        String arrivalManager, String departureManagerPhoneNum, String arrivalManagerPhoneNum,
	        String option1, String option2, String option3, String option4, String destinationAddress,
	        String userCompany) {

	    int affectedRows = 0;
	    SqlSession sqlSession = null;
	    Connection conn = null;
	    PreparedStatement pstmt = null;

	    try {
	        // ✅ 트랜잭션 가능한 세션 열기
	        sqlSession = MybatisUtil.getSession();
	        conn = sqlSession.getConnection(); 
	        conn.setAutoCommit(false);

	        // ✅ 현재 날짜 (yyMMdd 형식) 생성 → "250313"
	        SimpleDateFormat dateFormat = new SimpleDateFormat("yyMMdd");
	        String datePart = dateFormat.format(new Date());

	        // ✅ 밀리초 값에서 뒤 6자리 사용 → 동시성 문제 방지
	        String timePart = String.valueOf(System.currentTimeMillis()).substring(7);

	        // ✅ orderNumber 생성 (날짜 + 밀리초)
	        String orderNumber = datePart + timePart;

	        // ✅ SQL 작성 (orderID는 제외)
	        String sql = "INSERT INTO cargoorder (" +
	                "orderNumber, kindOfCar, userName, orderDate, carWeight, refNumber, " +
	                "userPhoneNumber, upDown, item, etc, " +
	                "startDate, endDate, departureName, arrivalName, " +
	                "departureCities, arrivalCities, departureTown, arrivalTown, " +
	                "departureDetailedAddress, arrivalDetailedAddress, departureManager, arrivalManager, " +
	                "departureManagerPhoneNum, arrivalManagerPhoneNum, option1, option2, option3, option4, " +
	                "destinationAddress, userCompany) " +
	                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

	        // ✅ PreparedStatement 생성
	        pstmt = conn.prepareStatement(sql);

	        pstmt.setString(1, orderNumber);
	        pstmt.setString(2, kindOfCar);
	        pstmt.setString(3, userName);
	        pstmt.setString(4, orderDate);
	        pstmt.setString(5, carWeight);
	        pstmt.setInt(6, refNumber);
	        pstmt.setString(7, userPhoneNumber);
	        pstmt.setString(8, upDown);
	        pstmt.setString(9, item);
	        pstmt.setString(10, etc);
	        pstmt.setString(11, startDate);
	        pstmt.setString(12, endDate);
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
	        pstmt.setString(25, option1);
	        pstmt.setString(26, option2);
	        pstmt.setString(27, option3);
	        pstmt.setString(28, option4);
	        pstmt.setString(29, destinationAddress);
	        pstmt.setString(30, userCompany);

	        // ✅ 쿼리 실행
	        affectedRows = pstmt.executeUpdate();

	        if (affectedRows > 0) {
	            // ✅ 커밋
	            conn.commit();
	        } else {
	            // ❌ 실패 시 롤백
	            conn.rollback();
	        }

	    } catch (Exception e) {
	        if (conn != null) {
	            try {
	                conn.rollback(); 
	            } catch (SQLException rollbackEx) {
	                rollbackEx.printStackTrace();
	            }
	        }
	        e.printStackTrace();

	    } finally {
	        try {
	            if (pstmt != null) pstmt.close();
	            if (conn != null) conn.setAutoCommit(true);
	            if (sqlSession != null) sqlSession.close();
	        } catch (SQLException closeEx) {
	            closeEx.printStackTrace();
	        }
	    }
	    return affectedRows;
	}
	
	
	public List<Order> getSearchList( String startDate, String endDate, int refNumber, String userName, String departureName, String arrivalName, String arrivalCities, int pageNumber, String orderNumber ) {
		int pageSize = 10;
		try ( SqlSession session = MybatisUtil.getSession() ) {
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

            return session.selectList("OrderDAO.getSearchList", params);
			}
	}
	
	public List<Order> getPagedList( int pageNumber, int pageSize, String endDate, String endDate2, Integer refNumber, String userName, String departureName, String arrivalName, String arrivalCities, String orderNumber ) {
		 try ( SqlSession session = MybatisUtil.getSession() ) {
			 Map<String, Object> params = new HashMap<>();
	            int offset = (pageNumber - 1) * pageSize;
	            
	            params.put("offset", offset);
	            params.put("pageSize", pageSize);
	            params.put("endDate", endDate);
	            params.put("endDate2", endDate2);
	            params.put("refNumber", refNumber);
	            params.put("userName", userName);
	            params.put("departureName", departureName);
	            params.put("arrivalName", arrivalName);
	            params.put("arrivalCity", arrivalCities);
	            params.put("orderNumber", orderNumber);

	            return session.selectList("OrderDAO.getPagedList", params);
	        }
	}
	
	public List<Order> getPagedList( int pageNumber, int pageSize, String endDate, String endDate2, Integer refNumber, String userName, String departureName, String arrivalName, String arrivalCities, String orderNumber, String userType, String userCompany) {
		 try ( SqlSession session = MybatisUtil.getSession() ) {
			 Map<String, Object> params = new HashMap<>();
	            int offset = (pageNumber - 1) * pageSize;
	            
	            String userID = getUserID();
	            params.put("offset", offset);
	            params.put("pageSize", pageSize);
	            params.put("endDate", endDate);
	            params.put("endDate2", endDate2);
	            params.put("refNumber", refNumber);
	            params.put("userName", userName);
	            params.put("departureName", departureName);
	            params.put("arrivalName", arrivalName);
	            params.put("arrivalCity", arrivalCities);
	            params.put("orderNumber", orderNumber);
	            params.put("userType", userType);
	            params.put("userCompany", userCompany);
	            params.put("userID", userID);

	            return session.selectList("OrderDAO.getSearchOrderList", params);
	        }
	}
	
	public int getTotalCount( String endDate, String endDate2, Integer refNumber, String userName, String departureName, String arrivalName, String arrivalCities, String orderNumber ) {
        try ( SqlSession session = MybatisUtil.getSession() ) {
        	Map<String, Object> params = new HashMap<>();
        	params.put("endDate", endDate);
            params.put("endDate2", endDate2);
            params.put("refNumber", refNumber);
            params.put("userName", userName);
            params.put("departureName", departureName);
            params.put("arrivalName", arrivalName);
            params.put("arrivalCities", arrivalCities);
            params.put("orderNumber", orderNumber);
            params.put("userType", getUserType());

            return session.selectOne("OrderDAO.getTotalCount", params);
        	
        }
    }
	
	public Order getOrderById( String orderNumber ) {
        try ( SqlSession session = MybatisUtil.getSession() ) {
            return session.selectOne("OrderDAO.getOrderById", orderNumber);
        }
    }
	
	public int updateOrder(
	        String orderNumber, String kindOfCar, String userName, String orderDate, String carWeight,
	        Integer refNumber, String userPhoneNumber, String fixedCarNumber, String upDown, String item,
	        String etc, String startDate, String endDate, String departureName, String arrivalName,
	        String departureCities, String arrivalCities, String departureTown, String arrivalTown,
	        String departureDetailedAddress, String arrivalDetailedAddress, String departureManager,
	        String arrivalManager, String departureManagerPhoneNum, String arrivalManagerPhoneNum,
	        String carNumber, String driverName, String driverPhoneNum, int basicFare, int addFare,
	        String option1, String option2, String option3, String option4, String destinationAddress) {

	    int affectedRows = 0;
	    SqlSession sqlSession = null;

	    try {
	        // ✅ 세션 열기
	        sqlSession = MybatisUtil.getSession();

	        // ✅ 파라미터 설정
	        Map<String, Object> params = new HashMap<>();
	        params.put("orderNumber", orderNumber);
	        params.put("kindOfCar", kindOfCar);
	        params.put("userName", userName);
	        params.put("orderDate", orderDate);
	        params.put("carWeight", carWeight);
	        params.put("refNumber", refNumber);
	        params.put("userPhoneNumber", userPhoneNumber);
	        params.put("fixedCarNumber", fixedCarNumber);
	        params.put("upDown", upDown);
	        params.put("item", item);
	        params.put("etc", etc);
	        params.put("startDate", startDate);
	        params.put("endDate", endDate);
	        params.put("departureName", departureName);
	        params.put("arrivalName", arrivalName);
	        params.put("departureCities", departureCities);
	        params.put("arrivalCities", arrivalCities);
	        params.put("departureTown", departureTown);
	        params.put("arrivalTown", arrivalTown);
	        params.put("departureDetailedAddress", departureDetailedAddress);
	        params.put("arrivalDetailedAddress", arrivalDetailedAddress);
	        params.put("departureManager", departureManager);
	        params.put("arrivalManager", arrivalManager);
	        params.put("departureManagerPhoneNum", departureManagerPhoneNum);
	        params.put("arrivalManagerPhoneNum", arrivalManagerPhoneNum);
	        params.put("carNumber", carNumber);
	        params.put("driverName", driverName);
	        params.put("driverPhoneNum", driverPhoneNum);
	        params.put("basicFare", basicFare);
	        params.put("addFare", addFare);
	        params.put("option1", option1);
	        params.put("option2", option2);
	        params.put("option3", option3);
	        params.put("option4", option4);
	        params.put("destinationAddress", destinationAddress);

	        // ✅ 업데이트 실행
	        affectedRows = sqlSession.update("OrderDAO.updateOrder", params);

	        if (affectedRows > 0) {
	            // ✅ 트랜잭션 커밋
	            sqlSession.commit();
	        } else {
	            // ❌ 업데이트 실패 시 롤백
	            sqlSession.rollback();
	            return -1;
	        }
	    } catch (Exception e) {
	        if (sqlSession != null) {
	            try {
	                sqlSession.rollback(); // ❌ 예외 발생 시 롤백
	            } catch (Exception rollbackEx) {
	                rollbackEx.printStackTrace();
	            }
	        }
	        e.printStackTrace();
	        return -1;
	    } finally {
	        if (sqlSession != null) {
	            try {
	                sqlSession.close(); // ✅ 세션 닫기
	            } catch (Exception closeEx) {
	                closeEx.printStackTrace();
	            }
	        }
	    }
	    return affectedRows;
	}
	
	private String getUserID() {
		if (session != null) {
            return (String) session.getAttribute("userID");
        }
        return null; // 세션이 없으면 null 반환
    }
	
	public String getUserType() {
		try ( SqlSession session = MybatisUtil.getSession() ) {
			sqlSession = MybatisUtil.getSession();
            String userID = getUserID();
            if (userID != null) {
                return sqlSession.selectOne("OrderDAO.getUserType", userID);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null; // 오류 발생 시 null 반환
    }
	
	// 선택한 주문 삭제 메서드
    public boolean deleteOrders(List<String> orderNumbers) {
        try ( SqlSession session = MybatisUtil.getSession() ) {
        	sqlSession = MybatisUtil.getSession();
            int deletedRows = sqlSession.delete("OrderDAO.deleteOrders", orderNumbers);
            sqlSession.commit(); // 삭제 반영
            return deletedRows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false; 
    }
    
 // orderID와 현재 날짜를 결합하여 orderNumber를 생성하는 함수
    public int generateOrderNumber(int orderID) {
        // 현재 날짜 가져오기 (yyyyMMdd 형식)
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String currentDate = sdf.format(new Date());
        
        // 날짜 문자열을 숫자형으로 변환
        long currentDateNumber = Long.parseLong(currentDate);  // 예: 20250311
        
        // orderID 값을 4자리로 맞추고, 숫자 형태로 결합
        // 예: currentDateNumber = 20250311, orderID = 1 -> 202503110001
        int orderNumber = (int)(currentDateNumber * 10000 + orderID); // 예: 202503110001
        
        return orderNumber;
    }
    
    // 현재 세션의 LAST_INSERT_ID() 사용 → 동시성 문제 해결
    public int getGeneratedOrderNumber() {
    	try ( SqlSession session = MybatisUtil.getSession() ) {
    		sqlSession = MybatisUtil.getSession();
    		return sqlSession.selectOne("OrderDAO.getGeneratedOrderNumber");    		
    	}
    }
}

