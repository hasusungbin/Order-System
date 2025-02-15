package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class UserDAO {
	
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	public UserDAO() {
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
	
	public int login( String userID, String userPassword ) {
		String SQL = "SELECT userPassword FROM USER WHERE userID = ?";
		try {
			pstmt = conn.prepareStatement( SQL );
			pstmt.setString( 1, userID );
			rs = pstmt.executeQuery();
			if( rs.next() ) {
				if(rs.getString(1).equals(userPassword)) {
					return 1; // 로그인 성공
				} else
					return 0; // 비밀번호 불일치
			}
			return -1; // 아이디가 없음
		} catch( Exception e ) {
			e.printStackTrace();
		}
		return -2; // 데이터베이스 오류
	}
	
	public ArrayList<User> getUserList() {
		String SQL = "SELECT * FROM USER WHERE userType <> 'admin'";
		ArrayList<User> userList = new ArrayList<User>();
		try {
			pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			while( rs.next() ) {
				User user = new User();
				user.setUserID( rs.getString(1) );
				user.setUserPassword( rs.getString(2) );
				user.setUserName( rs.getString(3) );
				user.setUserGendder( rs.getString(4) );
				user.setUserEmail( rs.getString(5) );
				user.setUserType( rs.getString(6) );
				user.setUserPhoneNumber( rs.getString(7) );
				userList.add(user);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return userList;
	}
}
