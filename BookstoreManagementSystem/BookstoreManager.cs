using System;
using System.Data;
using System.Data.SqlClient;

namespace BookstoreManagementSystem
{
    public class BookstoreManager
    {
        private readonly string connectionString = "server=CAPEDBOLDY\\SQLEXPRESS; Initial Catalog = BookstoreManagementSystem; Integrated Security = SSPI";

        public DataTable GetAllBooks()
        {
            DataTable booksTable = new DataTable();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM Books";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    connection.Open();
                    SqlDataAdapter adapter = new SqlDataAdapter(command);
                    adapter.Fill(booksTable);
                }
            }

            return booksTable;
        }

        public void InsertOrder(int customerId, int bookId, int quantity)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "INSERT INTO Orders (CustomerID, OrderDate) VALUES (@CustomerID, @OrderDate);" +
                               "INSERT INTO OrderDetails (OrderID, BookID, Quantity) VALUES (SCOPE_IDENTITY(), @BookID, @Quantity);" +
                               "UPDATE Inventory SET StockLevel = StockLevel - @Quantity WHERE BookID = @BookID";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@CustomerID", customerId);
                    command.Parameters.AddWithValue("@OrderDate", DateTime.Now);
                    command.Parameters.AddWithValue("@BookID", bookId);
                    command.Parameters.AddWithValue("@Quantity", quantity);

                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }
        }

        public DataTable SearchBooks(string keyword)
        {
            DataTable searchResults = new DataTable();

            string query = "SELECT * FROM Books WHERE Title LIKE @Keyword";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    string keywordWithValue = "%" + keyword + "%";
                    command.Parameters.AddWithValue("@Keyword", keywordWithValue);

                    connection.Open();
                    SqlDataAdapter adapter = new SqlDataAdapter(command);
                    adapter.Fill(searchResults);
                }
            }

            return searchResults;
        }

        public DataTable GetCustomersDataByView(int customerId)
        {
            DataTable customerOrders = new DataTable();
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT * FROM CustomerOrders WHERE CustomerID = @CustomerID";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@CustomerID", customerId);

                    connection.Open();
                    SqlDataAdapter adapter = new SqlDataAdapter(command);
                    adapter.Fill(customerOrders);
                }
            }

            return customerOrders;
        }

    }
}
