package insertOrder;

import java.util.Date;

public class Order {
	
	private String oderNumber;
	private String userName;
	private Date orderDate;
	private String carWeight;
	private String kindOfCar;
	private int refNumber;
	private String userPhoneNumber;
	private String fixedCarNumber;
	private String upDown;
	private String item;
	private String etc;
	
	public Order() {
	}

	public String getOderNumber() {
		return oderNumber;
	}

	public void setOderNumber(String oderNumber) {
		this.oderNumber = oderNumber;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public Date getOrderDate() {
		return orderDate;
	}

	public void setOrderDate(Date orderDate) {
		this.orderDate = orderDate;
	}

	public String getCarWeight() {
		return carWeight;
	}

	public void setCarWeight(String carWeight) {
		this.carWeight = carWeight;
	}

	public String getKindOfCar() {
		return kindOfCar;
	}

	public void setKindOfCar(String kindOfCar) {
		this.kindOfCar = kindOfCar;
	}

	public int getRefNumber() {
		return refNumber;
	}

	public void setRefNumber(int refNumber) {
		this.refNumber = refNumber;
	}

	public String getUserPhoneNumber() {
		return userPhoneNumber;
	}

	public void setUserPhoneNumber(String userPhoneNumber) {
		this.userPhoneNumber = userPhoneNumber;
	}

	public String getUpDown() {
		return upDown;
	}

	public void setUpDown(String upDown) {
		this.upDown = upDown;
	}

	public String getItem() {
		return item;
	}

	public void setItem(String item) {
		this.item = item;
	}

	public String getEtc() {
		return etc;
	}

	public void setEtc(String etc) {
		this.etc = etc;
	}

	public String getFixedCarNumber() {
		return fixedCarNumber;
	}

	public void setFixedCarNumber(String fixedCarNumber) {
		this.fixedCarNumber = fixedCarNumber;
	}
	
	
	
}
