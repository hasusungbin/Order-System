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
	
	public int writeOrder(
            String userID, String kindOfCar, String userName, String orderDate, String carWeight,
            int refNumber, String userPhoneNumber, String fixedCarNumber, String upDown, String item,
            String etc, String startDate, String endDate, String departureName, String arrivalName,
            String departureCities, String arrivalCities, String departureTown, String arrivalTown,
            String departureDetailedAddress, String arrivalDetailedAddress, String departureManager,
            String arrivalManager, String departureManagerPhoneNum, String arrivalManagerPhoneNum,
            String option1, String option2, String option3, String option4, String destinationAddress, String userCompany ) {
		sqlSession = MybatisUtil.getSession();
		System.out.println(sqlSession + ": sqlSession");
        try {
            Order order = new Order();
            order.setKindOfCar(kindOfCar);
            order.setUserName(userName);
            order.setOrderDate(orderDate);
            order.setCarWeight(carWeight);
            order.setRefNumber(refNumber);
            order.setUserPhoneNumber(userPhoneNumber);
            order.setFixedCarNumber(fixedCarNumber);
            order.setUpDown(upDown);
            order.setItem(item);
            order.setEtc(etc);
            order.setStartDate(startDate);
            order.setEndDate(endDate);
            order.setDepartureName(departureName);
            order.setArrivalName(arrivalName);
            order.setDepartureCities(departureCities);
            order.setArrivalCities(arrivalCities);
            order.setDepartureTown(departureTown);
            order.setArrivalTown(arrivalTown);
            order.setDepartureDetailedAddress(departureDetailedAddress);
            order.setArrivalDetailedAddress(arrivalDetailedAddress);
            order.setDepartureManager(departureManager);
            order.setArrivalManager(arrivalManager);
            order.setDepartureManagerPhoneNum(departureManagerPhoneNum);
            order.setArrivalManagerPhoneNum(arrivalManagerPhoneNum);
            order.setOption1(option1);
            order.setOption2(option2);
            order.setOption3(option3);
            order.setOption4(option4);
            order.setDestinationAddress(destinationAddress);
            order.setUserCompany(userCompany);
            System.out.println("departureCities Length: " + departureCities.length());

            // ✅ MyBatis 매퍼 호출
            int affectedRows = sqlSession.insert("insertOrder.OrderDAO.writeOrder", order);

            if (affectedRows > 0) {
                sqlSession.commit();
                System.out.println("✅ 트랜잭션 커밋 성공");
            } else {
                sqlSession.rollback();
                System.out.println("❌ 트랜잭션 롤백 발생");
            }

            return affectedRows;

        } catch (Exception e) {
            sqlSession.rollback();
            e.printStackTrace();
            System.out.println("❌ SQL 실행 오류 발생: " + e.getMessage());
            return -1;
        }
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

            return session.selectList("insertOrder.OrderDAO.getSearchList", params);
			}
	}
	
	public List<Order> getPagedList( int pageNumber, int pageSize, String startDate, String endDate, Integer refNumber, String userName, String departureName, String arrivalName, String arrivalCities, String orderNumber) {
		 try ( SqlSession session = MybatisUtil.getSession() ) {
			 Map<String, Object> params = new HashMap<>();
	            int offset = (pageNumber - 1) * pageSize;
	            
	            params.put("offset", offset);
	            params.put("pageSize", pageSize);
	            params.put("startDate", startDate);
	            params.put("endDate", endDate);
	            params.put("refNumber", refNumber);
	            params.put("userName", userName);
	            params.put("departureName", departureName);
	            params.put("arrivalName", arrivalName);
	            params.put("arrivalCity", arrivalCities);
	            params.put("orderNumber", orderNumber);

	            return session.selectList("insertOrder.OrderDAO.getPagedList", params);
	        }
	}
	
	public List<Order> getPagedList( int pageNumber, int pageSize, String startDate, String endDate, Integer refNumber, String userName, String departureName, String arrivalName, String arrivalCities, String orderNumber, String userType) {
		 try ( SqlSession session = MybatisUtil.getSession() ) {
			 Map<String, Object> params = new HashMap<>();
	            int offset = (pageNumber - 1) * pageSize;
	            
	            params.put("offset", offset);
	            params.put("pageSize", pageSize);
	            params.put("startDate", startDate);
	            params.put("endDate", endDate);
	            params.put("refNumber", refNumber);
	            params.put("userName", userName);
	            params.put("departureName", departureName);
	            params.put("arrivalName", arrivalName);
	            params.put("arrivalCity", arrivalCities);
	            params.put("orderNumber", orderNumber);
	            params.put("userType", userType);

	            return session.selectList("insertOrder.OrderDAO.getPagedList", params);
	        }
	}
	
	public int getTotalCount( String startDate, String endDate, Integer refNumber, String userName, String departureName, String arrivalName, String arrivalCities, String orderNumber ) {
        try ( SqlSession session = MybatisUtil.getSession() ) {
        	Map<String, Object> params = new HashMap<>();
        	params.put("startDate", startDate);
            params.put("endDate", endDate);
            params.put("refNumber", refNumber);
            params.put("userName", userName);
            params.put("departureName", departureName);
            params.put("arrivalName", arrivalName);
            params.put("arrivalCities", arrivalCities);
            params.put("orderNumber", orderNumber);
            params.put("userType", getUserType());

            return session.selectOne("insertOrder.OrderDAO.getTotalCount", params);
        	
        }
    }
	
	public Order getOrderById( String orderNumber ) {
        try ( SqlSession session = MybatisUtil.getSession() ) {
            return session.selectOne("insertOrder.OrderDAO.getOrderById", orderNumber);
        }
    }
	
	public int updateOrder(String orderNumber, String kindOfCar, String userName, String orderDate, String carWeight, Integer refNumber, String userPhoneNumber, String fixedCarNumber, String upDown, String item, String etc, 
			String startDate, String endDate, String departureName, String arrivalName, String departureCities, String arrivalCities, String departureTown, String arrivalTown, String departureDetailedAddress, 
			String arrivalDetailedAddress, String departureManager, String arrivalManager, String departureManagerPhoneNum, String arrivalManagerPhoneNum, String carNumber, String driverName, String driverPhoneNum,
			int basicFare, int addFare, String option1, String option2, String option3, String option4, String destinationAddress) {
        try ( SqlSession session = MybatisUtil.getSession() ) {
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

           int result = session.update("insertOrder.OrderDAO.updateOrder", params);
            session.commit();
            return (result > 0) ? 1 : -1;
        }
    }
	
	private String getUserID() {
		if (session != null) {
            return (String) session.getAttribute("userID");
        }
        return null; // 세션이 없으면 null 반환
    }
	
	public String getUserType() {
		try ( SqlSession session = MybatisUtil.getSession() ) {
            String userID = getUserID();
            if (userID != null) {
                return sqlSession.selectOne("insertOrder.OrderDAO.getUserType", userID);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null; // 오류 발생 시 null 반환
    }
	
	// 선택한 주문 삭제 메서드
    public boolean deleteOrders(List<String> orderNumbers) {
        try ( SqlSession session = MybatisUtil.getSession() ) {
            int deletedRows = sqlSession.delete("insertOrder.OrderDAO.deleteOrders", orderNumbers);
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
    		return sqlSession.selectOne("insertOrder.OrderDAO.getGeneratedOrderNumber");    		
    	}
    }
}

