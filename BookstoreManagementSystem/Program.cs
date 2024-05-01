using System;
using System.Data;

namespace BookstoreManagementSystem
{
    class Program
    {
        static void Main()
        {
            BookstoreManager manager = new BookstoreManager();

            while (true)
            {
                Console.WriteLine("Bookstore Management System Menu:");
                Console.WriteLine("1. Get all books");
                Console.WriteLine("2. Search books by title");
                Console.WriteLine("3. Insert an order");
                Console.WriteLine("4. Get customer orders data by view");
                Console.WriteLine("5. Exit");
                Console.Write("Enter your choice: ");
                string choice = Console.ReadLine();

                switch (choice)
                {
                    case "1":
                        DisplayBooks(manager.GetAllBooks());
                        break;
                    case "2":
                        Console.Write("Enter a keyword to search by title: ");
                        string keyword = Console.ReadLine();
                        DisplayBooks(manager.SearchBooks(keyword));
                        break;
                    case "3":
                        Console.Write("Enter CustomerID: ");
                        int customerId = Convert.ToInt32(Console.ReadLine());
                        Console.Write("Enter BookID: ");
                        int bookId = Convert.ToInt32(Console.ReadLine());
                        Console.Write("Enter Quantity: ");
                        int quantity = Convert.ToInt32(Console.ReadLine());
                        manager.InsertOrder(customerId, bookId, quantity);
                        Console.WriteLine("Order inserted successfully.");
                        break;
                    case "4":
                        Console.Write("Enter CustomerID: ");
                        int custId = Convert.ToInt32(Console.ReadLine());
                        DisplayCustomerOrders(manager.GetCustomersDataByView(custId));
                        break;
                    case "5":
                        Console.WriteLine("Exiting...");
                        return;
                    default:
                        Console.WriteLine("Invalid choice! Please try again.");
                        break;
                }
            }
        }

        static void DisplayBooks(DataTable books)
        {
            Console.WriteLine("Books:");
            foreach (DataRow row in books.Rows)
            {
                Console.WriteLine($"Title: {row["Title"]}, Author: {row["Author"]}, Price: {row["Price"]}, Quantity: {row["Quantity"]}, SalesCount: {row["SalesCount"]}");
            }
        }

        static void DisplayCustomerOrders(DataTable orders)
        {
            Console.WriteLine("Customer Orders:");
            foreach (DataRow row in orders.Rows)
            {
                Console.WriteLine($"OrderID: {row["OrderID"]}, OrderDate: {row["OrderDate"]}, Title: {row["Title"]}, Quantity: {row["Quantity"]}");
            }
        }
    }
}
