package user;

import java.util.Date;
import java.text.SimpleDateFormat;

public class User {
	
	private String userID;
	private String userPassword;
	private String userName;
	private String userType;
	private String userPhoneNumber;
	private String userCompany;
	private	String userTeam;
	private Date	regDate;
	
	public User() {
	}
	public User(String userID, String userPassword, String userName, String userType, 
            String userPhoneNumber, String userCompany, String userTeam) {
	    this.userID = userID;
	    this.userPassword = userPassword;
	    this.userName = userName;
	    this.userType = userType;
	    this.userPhoneNumber = userPhoneNumber;
	    this.userCompany = userCompany;
	    this.userTeam = userTeam;
	}
	public User(String userID, String userPassword) {
        this.userID = userID;
        this.userPassword = userPassword;
    }
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getUserPassword() {
		return userPassword;
	}
	public void setUserPassword(String userPassword) {
		this.userPassword = userPassword;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getUserType() {
		return userType;
	}
	public void setUserType(String userType) {
		this.userType = userType;
	}
	public String getUserPhoneNumber() {
		return userPhoneNumber;
	}
	public void setUserPhoneNumber(String userPhoneNumber) {
		this.userPhoneNumber = userPhoneNumber;
	}
	public String getUserCompany() {
		return userCompany;
	}
	public void setUserCompany(String userCompany) {
		this.userCompany = userCompany;
	}
	public String getUserTeam() {
		return userTeam;
	}
	public void setUserTeam(String userTeam) {
		this.userTeam = userTeam;
	}
	public Date getRegDate() {
		return regDate;
	}
	public String getFormattedRegDate() {
        if (regDate == null) return "";
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy년 M월 d일");
        return sdf.format(regDate);
    }
	public void setRegDate(Date regDate) {
		this.regDate = regDate;
	}
}
