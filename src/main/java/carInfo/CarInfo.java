package carInfo;

import java.text.SimpleDateFormat;
import java.util.Date;

public class CarInfo {
	
	private String carNumber;
	private String driverName;
	private String carWeight;
	private String driverPhoneNumber;
	private String kindOfCar;
	private String userCompany;
	private Date regDate;
	
	public CarInfo() {
	}
	
	public String getCarNumber() {
		return carNumber;
	}
	
	public void setCarNumber( String carNumber ) {
		this.carNumber = carNumber;
	}
	
	public String getDriverName() {
		return driverName;
	}
	
	public void setDriverName( String driverName ) {
		this.driverName = driverName;
	}
	
	public String getDriverPhoneNumber() {
		return driverPhoneNumber;
	}
	
	public void setDriverPhoneNumber( String driverPhoneNumber ) {
		this.driverPhoneNumber = driverPhoneNumber;
	}
	
	public String getUserCompany() {
		return userCompany;
	}
	public void setUserCompany( String userCompany ) {
		this.userCompany = userCompany;
	}

	public String getCarWeight() {
		return carWeight;
	}

	public void setCarWeight( String carWeight ) {
		this.carWeight = carWeight;
	}

	public String getKindOfCar() {
		return kindOfCar;
	}

	public void setKindOfCar( String kindOfCar ) {
		this.kindOfCar = kindOfCar;
	}

	public Date getRegDate() {
		return regDate;
	}

	public void setRegDate(Date regDate) {
		this.regDate = regDate;
	}
	
	public String getFormattedRegDate() {
        if (regDate == null) return "";
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy년 M월 d일");
        return sdf.format(regDate);
    }
	
}
