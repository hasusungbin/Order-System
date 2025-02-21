/*
 * package insertOrder;
 * 
 * import insertOrder.OrderDAO; import insertOrder.Order; import
 * org.apache.poi.ss.usermodel.*; import
 * org.apache.poi.xssf.usermodel.XSSFWorkbook;
 * 
 * import javax.servlet.ServletException; import
 * javax.servlet.annotation.WebServlet; import javax.servlet.http.HttpServlet;
 * import javax.servlet.http.HttpServletRequest; import
 * javax.servlet.http.HttpServletResponse; import java.io.IOException; import
 * java.io.OutputStream; import java.util.ArrayList; import java.util.List;
 * 
 * @WebServlet("/OrderServlet") public class OrderServlet extends HttpServlet {
 * protected void doPost(HttpServletRequest request, HttpServletResponse
 * response) throws ServletException, IOException {
 * request.setCharacterEncoding("UTF-8"); String action =
 * request.getParameter("action");
 * 
 * if ("updateOrder".equals(action)) { updateOrder(request, response); } }
 * 
 * private void updateOrder(HttpServletRequest request, HttpServletResponse
 * response) throws IOException { OrderDAO orderDAO = new OrderDAO();
 * 
 * int orderNumber = Integer.parseInt(request.getParameter("orderNumber"));
 * String orderDate = request.getParameter("orderDate"); int refNumber =
 * Integer.parseInt(request.getParameter("refNumber")); String departureName =
 * request.getParameter("departureName"); String arrivalName =
 * request.getParameter("arrivalName"); String carNumber =
 * request.getParameter("carNumber"); String driverName =
 * request.getParameter("driverName"); int basicFare =
 * Integer.parseInt(request.getParameter("basicFare"));
 * 
 * orderDAO.updateOrder(orderNumber, orderDate, refNumber, departureName,
 * arrivalName, carNumber, driverName, basicFare);
 * 
 * response.sendRedirect("orderModify.jsp"); } }
 */
