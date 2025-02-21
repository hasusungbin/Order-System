package insertOrder;

import java.sql.Date;

public class Order {
	
	private String orderNumber;
	private String userName;
	private String orderDate;
	private String carWeight;
	private String kindOfCar;
	private int refNumber;
	private String userPhoneNumber;
	private String fixedCarNumber;
	private String upDown;
	private String item;
	private String etc;
	private String startDate;
	private String endDate;
	private String departureName;
	private String arrivalName;
	private String departureCities;
	private String arrivalCities;
	private String departureTown;
	private String arrivalTown;
	private String departureDetailedAddress;
	private String arrivalDetailedAddress;
	private String departureManager;
	private String arrivalManager;
	private String departureManagerPhoneNum;
	private String arrivalManagerPhoneNum;
	private int orderID;
	private String carNumber;
	private String driverName;
	private	String driverPhoneNum;
	private int basicFare;
	private int addFare;
	private Date regDate;
	private String option1;
	private String option2;
	private String option3;
	private String option4;
	private String destinationAddress;
	
	public Order() {
	}

	public String getOrderNumber() {
		return orderNumber;
	}

	public void setOrderNumber(String oderNumber) {
		this.orderNumber = oderNumber;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getOrderDate() {
		return orderDate;
	}

	public void setOrderDate(String orderDate) {
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

	public String getStartDate() {
		return startDate;
	}

	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}

	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

	public String getDepartureName() {
		return departureName;
	}

	public void setDepartureName(String departureName) {
		this.departureName = departureName;
	}

	public String getArrivalName() {
		return arrivalName;
	}

	public void setArrivalName(String arrivalName) {
		this.arrivalName = arrivalName;
	}

	public String getDepartureCities() {
		return departureCities;
	}

	public void setDepartureCities(String departureCities) {
		this.departureCities = departureCities;
	}

	public String getArrivalCities() {
		return arrivalCities;
	}

	public void setArrivalCities(String arrivalCities) {
		this.arrivalCities = arrivalCities;
	}

	public String getDepartureTown() {
		return departureTown;
	}

	public void setDepartureTown(String departureTown) {
		this.departureTown = departureTown;
	}

	public String getArrivalTown() {
		return arrivalTown;
	}

	public void setArrivalTown(String arrivalTown) {
		this.arrivalTown = arrivalTown;
	}

	public String getDepartureDetailedAddress() {
		return departureDetailedAddress;
	}

	public void setDepartureDetailedAddress(String departureDetailedAddress) {
		this.departureDetailedAddress = departureDetailedAddress;
	}

	public String getArrivalDetailedAddress() {
		return arrivalDetailedAddress;
	}

	public void setArrivalDetailedAddress(String arrivalDetailedAddress) {
		this.arrivalDetailedAddress = arrivalDetailedAddress;
	}

	public String getDepartureManager() {
		return departureManager;
	}

	public void setDepartureManager(String departureManager) {
		this.departureManager = departureManager;
	}

	public String getArrivalManager() {
		return arrivalManager;
	}

	public void setArrivalManager(String arrivalManager) {
		this.arrivalManager = arrivalManager;
	}

	public String getDepartureManagerPhoneNum() {
		return departureManagerPhoneNum;
	}

	public void setDepartureManagerPhoneNum(String departureManagerPhoneNum) {
		this.departureManagerPhoneNum = departureManagerPhoneNum;
	}

	public String getArrivalManagerPhoneNum() {
		return arrivalManagerPhoneNum;
	}

	public void setArrivalManagerPhoneNum(String arrivalManagerPhoneNum) {
		this.arrivalManagerPhoneNum = arrivalManagerPhoneNum;
	}

	public int getOrderID() {
		return orderID;
	}

	public void setOrderID(int orderID) {
		this.orderID = orderID;
	}

	public String getCarNumber() {
		return carNumber;
	}

	public void setCarNumber(String carNumber) {
		this.carNumber = carNumber;
	}

	public String getDriverName() {
		return driverName;
	}

	public void setDriverName(String driverName) {
		this.driverName = driverName;
	}

	public String getDriverPhoneNum() {
		return driverPhoneNum;
	}

	public void setDriverPhoneNum(String driverPhoneNum) {
		this.driverPhoneNum = driverPhoneNum;
	}

	public int getBasicFare() {
		return basicFare;
	}

	public void setBasicFare(int basicFare) {
		this.basicFare = basicFare;
	}

	public int getAddFare() {
		return addFare;
	}

	public void setAddFare(int addFare) {
		this.addFare = addFare;
	}

	public Date getRegDate() {
		return regDate;
	}

	public void setRegDate(Date regDate) {
		this.regDate = regDate;
	}

	public String getOption1() {
		return option1;
	}

	public void setOption1(String option1) {
		this.option1 = option1;
	}

	public String getOption2() {
		return option2;
	}

	public void setOption2(String option2) {
		this.option2 = option2;
	}

	public String getOption4() {
		return option4;
	}

	public void setOption4(String option4) {
		this.option4 = option4;
	}

	public String getDestinationAddress() {
		return destinationAddress;
	}

	public void setDestinationAddress(String destinationAddress) {
		this.destinationAddress = destinationAddress;
	}

	public String getOption3() {
		return option3;
	}

	public void setOption3(String option3) {
		this.option3 = option3;
	}
	
	
	
}
